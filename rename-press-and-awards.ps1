# Rename every instance of "Press & Awards" to "Awards & Press" across all
# active HTML pages. Handles both the HTML-entity form (Press &amp; Awards)
# and the raw form, plus case-preserving variants like "press & awards"
# inside attribute values that we want left untouched.
#
# Page slug stays at /press — only the human-readable label changes.

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

$paths = @()
$paths += Get-ChildItem -Path $root -Filter '*.html' -File |
          ForEach-Object { $_.FullName }
$paths += Get-ChildItem -Path (Join-Path $root 'journal') -Filter '*.html' -File |
          ForEach-Object { $_.FullName }

$patched = 0
foreach ($p in $paths) {
    $orig = Read-File $p
    $new  = $orig
    # Both forms — entity-encoded and raw — get swapped.
    $new = $new -creplace 'Press &amp; Awards', 'Awards &amp; Press'
    $new = $new -creplace 'Press & Awards',     'Awards & Press'
    if ($new -ne $orig) {
        Write-File $p $new
        $patched++
        $rel = $p.Substring($root.Length + 1)
        Write-Host "  patched: $rel"
    }
}
Write-Host ""
Write-Host "Done. Patched $patched files."
