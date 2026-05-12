# Smarter duplicate scan: classifies each img by section so we can tell
# genuine duplicates from intentional reuse.

$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

$projectPages = Get-ChildItem -Path $root -Filter '*.html' -File | Where-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
    $c -match '<section class="project-hero">'
}

function Classify-Section([string]$html, [int]$pos) {
    $opens = [regex]::Matches($html.Substring(0, $pos), '<section class="([^"]+)"')
    if ($opens.Count -gt 0) {
        return $opens[$opens.Count - 1].Groups[1].Value
    }
    return 'other'
}

$inPage = @()
foreach ($f in $projectPages) {
    $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
    $imgMatches = [regex]::Matches($c, '<img[^>]+src="([^"]+)"')
    $bySrc = @{}
    foreach ($m in $imgMatches) {
        $name = [System.IO.Path]::GetFileName($m.Groups[1].Value)
        if (-not $bySrc.ContainsKey($name)) { $bySrc[$name] = @() }
        $bySrc[$name] += @{ pos = $m.Index; section = Classify-Section $c $m.Index }
    }
    foreach ($k in $bySrc.Keys) {
        if ($bySrc[$k].Count -gt 1) {
            $sections = $bySrc[$k] | ForEach-Object { $_.section }
            $inPage += [pscustomobject]@{
                page     = $f.Name
                image    = $k
                count    = $bySrc[$k].Count
                sections = ($sections -join ', ')
            }
        }
    }
}

$hero_and_gallery = $inPage | Where-Object { $_.sections -match 'project-hero' -and $_.sections -match 'gallery' }
$gallery_only     = $inPage | Where-Object { $_.sections -notmatch 'project-hero' -and $_.sections -match 'gallery' }
$other            = $inPage | Where-Object { $_.sections -notmatch 'gallery' }

Write-Host '=== In-page duplicates ==='
Write-Host ''
Write-Host '-- HERO also in GALLERY [common, but worth removing the gallery copy if hero already shows it] --'
foreach ($r in $hero_and_gallery | Sort-Object page) {
    Write-Host ("  {0,-40}  {1}x  {2}" -f $r.page, $r.count, $r.image)
}
Write-Host ''
Write-Host '-- GALLERY only, duplicated inside [real duplicate, should remove one] --'
if ($gallery_only.Count -eq 0) { Write-Host '  none' }
foreach ($r in $gallery_only | Sort-Object page) {
    Write-Host ("  {0,-40}  {1}x  {2}  [{3}]" -f $r.page, $r.count, $r.image, $r.sections)
}
Write-Host ''
Write-Host '-- OTHER --'
if ($other.Count -eq 0) { Write-Host '  none' }
foreach ($r in $other | Sort-Object page) {
    Write-Host ("  {0,-40}  {1}x  {2}  [{3}]" -f $r.page, $r.count, $r.image, $r.sections)
}
