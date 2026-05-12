# Finds visual duplicates among project images, two ways:
#   1. Content hash (SHA1) — catches byte-identical copies
#   2. Naming pattern    — catches Squarespace cache-buster variants:
#                          foo.jpg + foo-c5c97c95.jpg (8 hex chars suffix)
# Then cross-references with project page galleries to flag pages
# that reference more than one copy of the same source image.

$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$imagesDir = Join-Path $root 'images'

Write-Host 'Building image index...'
$imageFiles = Get-ChildItem -Path $imagesDir -File | Where-Object {
    $_.Extension -match '\.(jpg|jpeg|png|webp|gif)$'
}

# ──────────── Step 1: hash-based ────────────
$byHash = @{}
foreach ($f in $imageFiles) {
    $hash = (Get-FileHash -Algorithm SHA1 -Path $f.FullName).Hash
    if (-not $byHash.ContainsKey($hash)) { $byHash[$hash] = @() }
    $byHash[$hash] += $f.Name
}
$hashDupes = $byHash.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }

# ──────────── Step 2: naming-pattern based ────────────
# Group files by their "stem" — drop a trailing -[8 hex chars] before the extension.
$byStem = @{}
foreach ($f in $imageFiles) {
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $stem = $stem -replace '-[a-f0-9]{6,}$', ''
    $key = $stem + $f.Extension.ToLower()
    if (-not $byStem.ContainsKey($key)) { $byStem[$key] = @() }
    $byStem[$key] += $f.Name
}
$stemDupes = $byStem.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }

# Combine: every set of "likely the same source image"
$canonicalSets = @{}
foreach ($e in $hashDupes) {
    foreach ($name in $e.Value) {
        if (-not $canonicalSets.ContainsKey($name)) {
            $canonicalSets[$name] = [System.Collections.Generic.HashSet[string]]::new()
        }
        foreach ($n in $e.Value) { [void]$canonicalSets[$name].Add($n) }
    }
}
foreach ($e in $stemDupes) {
    foreach ($name in $e.Value) {
        if (-not $canonicalSets.ContainsKey($name)) {
            $canonicalSets[$name] = [System.Collections.Generic.HashSet[string]]::new()
        }
        foreach ($n in $e.Value) { [void]$canonicalSets[$name].Add($n) }
    }
}

# Build a list of distinct dupe groups
$seen = [System.Collections.Generic.HashSet[string]]::new()
$dupeGroups = @()
foreach ($name in ($canonicalSets.Keys | Sort-Object)) {
    if ($seen.Contains($name)) { continue }
    $group = $canonicalSets[$name] | Sort-Object
    foreach ($n in $group) { [void]$seen.Add($n) }
    if ($group.Count -gt 1) { $dupeGroups += ,$group }
}

Write-Host ''
Write-Host '=== Visual duplicate FILE groups ==='
Write-Host '(byte-identical OR Squarespace cache-buster variants)'
Write-Host ''
foreach ($g in $dupeGroups) {
    Write-Host ("  {0} files:" -f $g.Count)
    foreach ($n in $g) { Write-Host "    $n" }
    Write-Host ''
}

# ──────────── Step 3: which project pages reference 2+ of the same source ────────────
$projectPages = Get-ChildItem -Path $root -Filter '*.html' -File | Where-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
    $c -match '<section class="project-hero">'
}

Write-Host '=== Project pages that reference multiple copies of the same source image ==='
$pagesAffected = @()
foreach ($g in $dupeGroups) {
    foreach ($f in $projectPages) {
        $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
        $foundHere = @()
        foreach ($n in $g) {
            if ($c -match [regex]::Escape($n)) { $foundHere += $n }
        }
        if ($foundHere.Count -gt 1) {
            $pagesAffected += [pscustomobject]@{
                page  = $f.Name
                files = $foundHere
            }
        }
    }
}
if ($pagesAffected.Count -eq 0) {
    Write-Host '  none'
} else {
    foreach ($p in $pagesAffected | Sort-Object page) {
        Write-Host ("  {0}" -f $p.page)
        foreach ($n in $p.files) { Write-Host "    $n" }
        Write-Host ''
    }
}
