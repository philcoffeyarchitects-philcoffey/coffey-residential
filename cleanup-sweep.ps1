# Multi-purpose cleanup sweep across all active HTML pages:
#   - Swap favicon from favicon.svg ("C" mark) to logo.webp
#   - Remove the newsletter signup block from the .cta panel
#   - Remove the standalone .newsletter-section on journal.html
#   - Fix the 33 broken inline links inside scraped journal articles
#
# Run once. Idempotent. Press-kit removal is a one-shot Edit, not in here.

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

$paths = @()
$paths += Get-ChildItem -Path $root -Filter '*.html' -File | ForEach-Object { $_.FullName }
$paths += Get-ChildItem -Path (Join-Path $root 'journal') -Filter '*.html' -File | ForEach-Object { $_.FullName }

$ctaNewsletterRx = [regex]::new(
    '\s*<div class="cta__news">.*?</div>\s*(?=</section>)',
    'Singleline'
)
$standaloneNewsletterRx = [regex]::new(
    '\s*<!--\s*=+\s*Newsletter\s*=+\s*-->\s*<section class="newsletter-section">.*?</section>',
    'Singleline'
)
# Some pages dont have the html comment delimiter, so also handle bare:
$standaloneNewsletterRx2 = [regex]::new(
    '\s*<section class="newsletter-section">.*?</section>',
    'Singleline'
)

$patched = 0
foreach ($p in $paths) {
    $rel = $p.Substring($root.Length + 1)
    $isJournalSub = $rel -like 'journal\*'
    $orig = Read-File $p
    $new = $orig

    # 1. Favicon: <link rel="icon" type="image/svg+xml" href="...favicon.svg" />
    #    becomes <link rel="icon" href="...logo.webp" />
    $logoPath = if ($isJournalSub) { '../images/webp/logo.webp' } else { 'images/webp/logo.webp' }
    $new = [regex]::Replace(
        $new,
        '<link\s+rel="icon"\s+type="image/svg\+xml"\s+href="[^"]*favicon\.svg"\s*/?>',
        '<link rel="icon" type="image/png" href="' + $logoPath + '" />',
        'IgnoreCase'
    )

    # 2. Remove the .cta__news block inside the .cta panel.
    $new = $ctaNewsletterRx.Replace($new, '')

    # 3. Remove the standalone .newsletter-section (journal.html).
    $new = $standaloneNewsletterRx.Replace($new, '')
    $new = $standaloneNewsletterRx2.Replace($new, '')

    # 4. Fix broken inline links in scraped article bodies.
    # All four patterns are simple string swaps:
    $new = $new -replace 'href="coffeyarchitects\.com/project/#filter=\.homes"', 'href="https://www.coffeyarchitects.com/project/#filter=.homes"'
    $new = $new -replace 'href="coffeyarchitects\.com/project/"', 'href="https://www.coffeyarchitects.com/project/"'
    $new = $new -replace 'href="coffeyarchitects\.com/"', 'href="https://www.coffeyarchitects.com/"'
    # The portfolio-coffey-residential href points at the OLD Squarespace
    # portfolio page; the new equivalent is homes.html.
    $new = $new -replace 'href="\.\./portfolio-coffey-residential"', 'href="../homes.html"'

    # Make sure external coffeyarchitects.com links open in a new tab.
    # Only apply to <a ...> tags that point at the external site AND dont
    # already have target=. Use a MatchEvaluator to inject the attr.
    $extLinkRx = [regex]::new(
        '<a\s+([^>]*?href="https://www\.coffeyarchitects\.com/[^"]*")([^>]*?)>',
        'IgnoreCase'
    )
    $new = $extLinkRx.Replace($new, {
        param($m)
        $attrs = $m.Groups[1].Value + $m.Groups[2].Value
        if ($attrs -match 'target=') { return $m.Value }
        return '<a ' + $m.Groups[1].Value + $m.Groups[2].Value + ' target="_blank" rel="noopener noreferrer">'
    })

    if ($new -ne $orig) {
        Write-File $p $new
        $patched++
    }
}

Write-Host "Done. Patched $patched files."
