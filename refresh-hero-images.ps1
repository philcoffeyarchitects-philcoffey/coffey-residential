# refresh-hero-images.ps1
#
# Rebuilds the manifest of homepage hero candidates from whatever images
# currently sit in images/webp/homepage/.
#
# Workflow:
#   1. Drop new hero images into images/webp/homepage/, or remove ones you
#      no longer want.
#   2. Run this script.
#   3. Commit the updated manifest.json (and the new images).
#
# The homepage JS reads manifest.json on load and picks one at random.
# Filenames don't matter — only the contents of the folder do.
#
# This script also rewrites the default <img src> in index.html so the
# page still shows a real homepage hero even before JS runs (and for
# social-share scrapers reading the static HTML).

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

$heroDir     = Join-Path $root 'images\webp\HomePage Images'
$heroUrlPath = 'images/webp/HomePage%20Images'
$manifest    = Join-Path $heroDir 'manifest.json'
$indexHtml   = Join-Path $root 'index.html'

if (-not (Test-Path $heroDir)) {
    throw "Hero folder not found: $heroDir"
}

# Collect the webp files (sorted for stable diffs).
$files = Get-ChildItem -Path $heroDir -Filter '*.webp' -File |
         Sort-Object Name |
         ForEach-Object { $_.Name }

if ($files.Count -eq 0) {
    throw "No .webp files in $heroDir - drop some images in first."
}

Write-Host "Found $($files.Count) hero candidate(s):"
$files | ForEach-Object { Write-Host "  $_" }

# Turn a filename like "modern-barn-aerial-view-from-coast.webp" into a
# sensible alt-text fallback: "Modern barn aerial view from coast".
# Used only when the file's filename is the alt text we get; Phil can
# author better alt copy later by hand-editing manifest.json if needed.
function Make-Alt([string]$filename) {
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($filename)
    $words = $stem -replace '[-_]+', ' '
    if ($words.Length -gt 0) {
        $words = $words.Substring(0,1).ToUpper() + $words.Substring(1)
    }
    return $words
}

# Build the manifest as a list of { src, alt } objects so the JS can
# wire alt text without further work.
$entries = @()
foreach ($name in $files) {
    # URL-encode the filename so spaces and special chars survive the fetch.
    $encoded = [uri]::EscapeDataString($name)
    $entries += [ordered]@{
        src = "$heroUrlPath/$encoded"
        alt = Make-Alt $name
    }
}

$json = $entries | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($manifest, $json, $utf8)
Write-Host ""
Write-Host "Wrote: $manifest"

# Also bake the heroes list into the inline <script> in index.html so the
# random pick happens synchronously during HTML parse (no manifest fetch,
# no flash of the default image, no duplicate download).
$jsLines = ($entries | ForEach-Object {
    '          { src: ''' + $_.src + ''', alt: ''' + ($_.alt -replace "'", "\'") + ''' }'
}) -join ",`r`n"

$newBlock = @"
// <!-- hero-picker:start -->
      (function () {
        var heroes = [
$jsLines
        ];
        var pick = heroes[Math.floor(Math.random() * heroes.length)];
        var img = document.getElementById('hero-img');
        if (img && pick) {
          img.src = pick.src;
          if (pick.alt) img.alt = pick.alt;
        }
      })();
      // <!-- hero-picker:end -->
"@

$html = [System.IO.File]::ReadAllText($indexHtml, $utf8)
$rxBlock = [regex]::new(
    '//\s*<!--\s*hero-picker:start\s*-->.*?//\s*<!--\s*hero-picker:end\s*-->',
    'Singleline'
)
if ($rxBlock.IsMatch($html)) {
    $newHtml = $rxBlock.Replace($html, { param($m) $newBlock }, 1)
} else {
    $newHtml = $html
}

if ($newHtml -ne $html) {
    [System.IO.File]::WriteAllText($indexHtml, $newHtml, $utf8)
    Write-Host "Updated index.html inline hero pool ($($entries.Count) candidates)"
} else {
    Write-Host "index.html inline hero pool already up to date"
}

Write-Host ""
Write-Host "Done."
