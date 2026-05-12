# v2: remove duplicate gallery figures using a canonical map that groups
# filenames known to be the same source image — catches both:
#   - byte-identical files (SHA1)
#   - Squarespace cache-buster variants:  foo.jpg + foo-c5c97c95.jpg

$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$imagesDir = Join-Path $root 'images'

# ──── Build canonical map: filename -> canonical key ────
$imageFiles = Get-ChildItem -Path $imagesDir -File | Where-Object {
    $_.Extension -match '\.(jpg|jpeg|png|webp|gif)$'
}

# Step 1: stem-based grouping (drop trailing -[6+ hex chars])
$stemKey = @{}
foreach ($f in $imageFiles) {
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name) -replace '-[a-f0-9]{6,}$', ''
    $stemKey[$f.Name] = $stem + $f.Extension.ToLower()
}

# Step 2: hash-based grouping
$hashByName = @{}
$namesByHash = @{}
foreach ($f in $imageFiles) {
    $h = (Get-FileHash -Algorithm SHA1 -Path $f.FullName).Hash
    $hashByName[$f.Name] = $h
    if (-not $namesByHash.ContainsKey($h)) { $namesByHash[$h] = @() }
    $namesByHash[$h] += $f.Name
}

# Step 3: union-find equivalence classes
$parent = @{}
function Find([string]$x) {
    if (-not $parent.ContainsKey($x)) { $parent[$x] = $x }
    if ($parent[$x] -ne $x) { $parent[$x] = Find $parent[$x] }
    return $parent[$x]
}
function Union([string]$a, [string]$b) {
    $ra = Find $a; $rb = Find $b
    if ($ra -ne $rb) { $parent[$ra] = $rb }
}

foreach ($f in $imageFiles) {
    [void](Find $f.Name)
    # Union with stem-key partner (use stem-key as a virtual "group node")
    Union $f.Name $stemKey[$f.Name]
}
foreach ($e in $namesByHash.GetEnumerator()) {
    if ($e.Value.Count -lt 2) { continue }
    $first = $e.Value[0]
    foreach ($n in $e.Value[1..($e.Value.Count - 1)]) { Union $first $n }
}

# canonicalMap[filename] = the root of its equivalence class
$canonicalMap = @{}
foreach ($f in $imageFiles) {
    $canonicalMap[$f.Name] = Find $f.Name
}

# ──── Walk project pages and dedupe their galleries ────
$projectPages = Get-ChildItem -Path $root -Filter '*.html' -File | Where-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
    $c -match '<section class="project-hero">'
}

$figurePattern = '(?s)\s*<figure[^>]*>[\s\S]*?<img[^>]+src="([^"]+)"[\s\S]*?</figure>'

$totalRemoved = 0
$pagesTouched = 0
$report = @()

foreach ($f in $projectPages) {
    $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
    $orig = $c

    # Hero canonical
    $heroCanonical = $null
    if ($c -match '<section class="project-hero">[\s\S]*?<img[^>]+src="([^"]+)"') {
        $heroName = [System.IO.Path]::GetFileName($matches[1])
        $heroCanonical = if ($canonicalMap.ContainsKey($heroName)) { $canonicalMap[$heroName] } else { $heroName }
    }

    # Gallery bounds
    if (-not ($c -match '(?s)(<section class="gallery">)([\s\S]*?)(</section>)')) { continue }
    $galleryInner = $matches[2]

    $matches2 = [regex]::Matches($galleryInner, $figurePattern)

    $seen = @{}
    if ($heroCanonical) { $seen[$heroCanonical] = $true }

    $toRemove = @()
    foreach ($m in $matches2) {
        $src = [System.IO.Path]::GetFileName($m.Groups[1].Value)
        $canon = if ($canonicalMap.ContainsKey($src)) { $canonicalMap[$src] } else { $src }
        if ($seen.ContainsKey($canon)) {
            $toRemove += @{ index = $m.Index; length = $m.Length; src = $src }
        } else {
            $seen[$canon] = $true
        }
    }

    if ($toRemove.Count -eq 0) { continue }

    $newInner = $galleryInner
    $sorted = $toRemove | Sort-Object { -[int]$_.index }
    foreach ($t in $sorted) { $newInner = $newInner.Remove($t.index, $t.length) }

    # Recount remaining figures and rewrite the "Gallery · N images" header
    $newFigCount = [regex]::Matches($newInner, '<figure[^>]*>').Count
    $newInner = [regex]::Replace(
        $newInner,
        '(<div class="gallery__head">[^0-9<]*?)(\d+)(\s*images?</div>)',
        ('${1}' + $newFigCount + '${3}')
    )

    $c = $c.Replace(
        '<section class="gallery">' + $galleryInner + '</section>',
        '<section class="gallery">' + $newInner + '</section>'
    )

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $c, $utf8)
        $pagesTouched++
        $totalRemoved += $toRemove.Count
        foreach ($t in $toRemove) {
            $report += [pscustomobject]@{ page = $f.Name; image = $t.src }
        }
    }
}

Write-Host ("Pages updated:    {0}" -f $pagesTouched)
Write-Host ("Figures removed:  {0}" -f $totalRemoved)
Write-Host ''
foreach ($r in $report | Sort-Object page, image) {
    Write-Host ("  removed from {0,-40}  {1}" -f $r.page, $r.image)
}
