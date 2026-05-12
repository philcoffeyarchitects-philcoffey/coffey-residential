# Swap every reference to the 10 journal/img/*.png images over to .webp,
# now that Phil has replaced the PNGs with webp versions in journal/img/.
# Pattern targets only those 10 stems so the script wont touch other PNGs.

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

$stems = @(
    'brass-dial','fiddle-leaf-fig','hand-drawn-plan','light-on-plaster',
    'material-samples','sheep-wool-insulation','shelf-in-plaster',
    'watch-on-stone','window-cross','window-meets-brick'
)

# Match either 'journal/img/{stem}.png' (root-level pages) or 'img/{stem}.png'
# (when referenced from inside the /journal/ folder). Group 1 is the path
# prefix (with or without 'journal/'), group 2 is the stem.
$alt = ($stems | ForEach-Object { [regex]::Escape($_) }) -join '|'
$rx  = [regex]::new('((?:journal/)?img/)(' + $alt + ')\.png', 'IgnoreCase')

$paths = @()
$paths += Get-ChildItem -Path $root -Filter '*.html' -File | ForEach-Object { $_.FullName }
$paths += Get-ChildItem -Path (Join-Path $root 'journal') -Filter '*.html' -File | ForEach-Object { $_.FullName }

$patched = 0
foreach ($p in $paths) {
    $orig = [System.IO.File]::ReadAllText($p, $utf8)
    $new = $rx.Replace($orig, '$1$2.webp')
    if ($new -ne $orig) {
        [System.IO.File]::WriteAllText($p, $new, $utf8)
        $patched++
        $rel = $p.Substring($root.Length + 1)
        Write-Host "  patched: $rel"
    }
}

Write-Host ""
Write-Host "Done. Patched $patched files."
