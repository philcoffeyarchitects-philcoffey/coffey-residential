# Where are the remaining duplicate image FILES actually used?
# Scans all root-level HTML pages (not just project pages) for any page
# that references 2+ copies of the same source image.

$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$imagesDir = Join-Path $root 'images'

$imageFiles = Get-ChildItem -Path $imagesDir -File | Where-Object {
    $_.Extension -match '\.(jpg|jpeg|png|webp|gif)$'
}

# Same canonical grouping as before: stem-based + hash-based
$stemKey = @{}
foreach ($f in $imageFiles) {
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name) -replace '-[a-f0-9]{6,}$', ''
    $stemKey[$f.Name] = $stem + $f.Extension.ToLower()
}
$namesByHash = @{}
foreach ($f in $imageFiles) {
    $h = (Get-FileHash -Algorithm SHA1 -Path $f.FullName).Hash
    if (-not $namesByHash.ContainsKey($h)) { $namesByHash[$h] = @() }
    $namesByHash[$h] += $f.Name
}

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
foreach ($f in $imageFiles) { [void](Find $f.Name); Union $f.Name $stemKey[$f.Name] }
foreach ($e in $namesByHash.GetEnumerator()) {
    if ($e.Value.Count -lt 2) { continue }
    $first = $e.Value[0]
    foreach ($n in $e.Value[1..($e.Value.Count - 1)]) { Union $first $n }
}

# Build groups (only those with 2+ members)
$groups = @{}
foreach ($f in $imageFiles) {
    $grpRoot = Find $f.Name
    if (-not $groups.ContainsKey($grpRoot)) { $groups[$grpRoot] = @() }
    $groups[$grpRoot] += $f.Name
}
$dupeGroups = $groups.Values | Where-Object { $_.Count -gt 1 }

# For each root-level html, check
$htmlFiles = Get-ChildItem -Path $root -Filter '*.html' -File
$pagesWithDupes = @()
foreach ($f in $htmlFiles) {
    $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
    foreach ($g in $dupeGroups) {
        $foundHere = @()
        foreach ($n in $g) {
            if ($c -match [regex]::Escape($n)) { $foundHere += $n }
        }
        if ($foundHere.Count -gt 1) {
            $pagesWithDupes += [pscustomobject]@{
                page  = $f.Name
                files = $foundHere
            }
        }
    }
}

Write-Host '=== Pages referencing 2+ copies of the same source image ==='
if ($pagesWithDupes.Count -eq 0) {
    Write-Host '  none'
} else {
    foreach ($p in $pagesWithDupes | Sort-Object page) {
        Write-Host ("  {0}" -f $p.page)
        foreach ($n in $p.files) { Write-Host "    $n" }
        Write-Host ''
    }
}

# Are there duplicate FILES that aren't used at all? (orphans)
Write-Host '=== Orphan duplicate files (one or more copies not referenced anywhere) ==='
$allReferenced = [System.Collections.Generic.HashSet[string]]::new()
foreach ($f in $htmlFiles) {
    $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
    foreach ($img in $imageFiles) {
        if ($c -match [regex]::Escape($img.Name)) { [void]$allReferenced.Add($img.Name) }
    }
}
$jDir = Join-Path $root 'journal'
if (Test-Path $jDir) {
    Get-ChildItem -Path $jDir -Filter '*.html' -File | ForEach-Object {
        $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
        foreach ($img in $imageFiles) {
            if ($c -match [regex]::Escape($img.Name)) { [void]$allReferenced.Add($img.Name) }
        }
    }
}

$orphansInDupes = @()
foreach ($g in $dupeGroups) {
    $unrefInGroup = $g | Where-Object { -not $allReferenced.Contains($_) }
    if ($unrefInGroup.Count -gt 0) {
        $orphansInDupes += [pscustomobject]@{
            group     = ($g -join ', ')
            orphans   = ($unrefInGroup -join ', ')
        }
    }
}
if ($orphansInDupes.Count -eq 0) {
    Write-Host '  none'
} else {
    foreach ($o in $orphansInDupes) {
        Write-Host ("  group: {0}" -f $o.group)
        Write-Host ("  unused: {0}" -f $o.orphans)
        Write-Host ''
    }
}
