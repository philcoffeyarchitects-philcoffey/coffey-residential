# Rewrite every image reference on the site from <name>.jpg|jpeg|png to
# images/webp/<name>.webp. Phil generated webp copies of every image
# beforehand; this script just retargets the references.
#
# Touched: every active HTML page (root + journal/) and styles.css.
# Reference forms handled:
#   src="images/foo.jpg"
#   src="../images/foo.jpg"     (journal subdir pages)
#   href="https://coffeyresidential.com/images/foo.jpg"   (og:image, JSON-LD)
#   url(images/foo.jpg)         (in styles.css)
#
# Idempotent: a second run is a no-op because the patterns no longer match.
# Safe: only rewrites a reference when the corresponding .webp actually
# exists in images/webp/ — anything without a webp counterpart is left alone.

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

# Build a lookup of "<basename without ext>" -> exists in webp folder.
$webpDir = Join-Path $root 'images\webp'
$webpNames = @{}
Get-ChildItem -Path $webpDir -Filter '*.webp' -File | ForEach-Object {
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    $webpNames[$stem] = $true
}
Write-Host "Webp variants available: $($webpNames.Count)"

# Build a single regex that catches every reference form. The capture groups
# pull out:
#   [1] the prefix path before the filename (e.g. "images/" or "../images/"
#       or "https://coffeyresidential.com/images/")
#   [2] the filename stem (no extension)
#   [3] the extension (jpg|jpeg|png)
# Used inside attribute values, CSS url(...), and JSON strings alike.
$rx = [regex]::new(
    '((?:\.\./)?images/|https?://[^"''\s)]*?/images/)([^"''\s)/]+)\.(jpg|jpeg|png)',
    'IgnoreCase'
)

function Rewrite([string]$content) {
    $changed = $false
    $out = $rx.Replace($content, {
        param($m)
        $prefix = $m.Groups[1].Value
        $stem   = $m.Groups[2].Value
        $ext    = $m.Groups[3].Value
        # Skip if the path already points inside webp/ — defensive against
        # a partial run.
        if ($prefix -like '*/webp/') { return $m.Value }
        # Skip if no webp variant exists for this filename.
        if (-not $webpNames.ContainsKey($stem)) { return $m.Value }
        $script:changed = $true
        return "${prefix}webp/${stem}.webp"
    })
    return @{ content = $out; changed = $changed }
}

$paths = @()
$paths += Get-ChildItem -Path $root -Filter '*.html' -File |
          ForEach-Object { $_.FullName }
$paths += Get-ChildItem -Path (Join-Path $root 'journal') -Filter '*.html' -File |
          ForEach-Object { $_.FullName }
$paths += Join-Path $root 'styles.css'
# site.js + lightbox.js don't reference images by path; skip.

$patched = 0
$unchanged = 0
foreach ($p in $paths) {
    if (-not (Test-Path $p)) { continue }
    $orig = Read-File $p
    $script:changed = $false
    $result = Rewrite $orig
    if ($result.content -ne $orig) {
        Write-File $p $result.content
        $patched++
        $rel = $p.Substring($root.Length + 1)
        Write-Host "  patched: $rel"
    } else {
        $unchanged++
    }
}

Write-Host ""
Write-Host "Done. Patched $patched files, $unchanged unchanged."
