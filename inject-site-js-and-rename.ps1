# One-off: inject site.js into every active HTML page, and rename the
# "Press" nav link to "Press & Awards" across the site.
#
# Idempotent: skips pages that already reference site.js, and the rename
# is a no-op if the link already reads "Press & Awards".

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

# Active pages = same set as the SEO script (skip pages-html/, journal/_raw/,
# specimens/source/reference-editorial dev pages).
$navPages = @(
    'index.html','homes.html','studio.html','process.html',
    'press.html','journal.html','contact.html','thanks.html'
)
$projectPages = @(
    'ad-house-york.html','apartment-block-clerkenwell.html',
    'arch-study-notting-hill.html','canyon-house-clerkenwell.html',
    'capablanca-house-barnsbury.html','cove-ridge-devon.html',
    'folded-house-islington.html','garden-lodge-harpenden.html',
    'helios-house-white-city.html','hidden-house-clerkenwell.html',
    'island-home-shoreditch.html','kitchen-garden-maida-vale.html',
    'meadow-grove-barnes.html','modern-barn-devon.html',
    'modern-detached-harpenden.html','modern-mews-paddington.html',
    'modern-side-extension.html','modern-terrace-islington.html',
    'sky-house-camden.html','well-house-islington.html'
)
$rootJournal = @('journal-on-the-architecture-of-light.html')
$rootSet = $navPages + $projectPages + $rootJournal

$journalDir   = Join-Path $root 'journal'
$journalPages = Get-ChildItem -Path $journalDir -Filter '*.html' -File |
                Where-Object { $_.Name -ne 'index.html' } |
                ForEach-Object { "journal/$($_.Name)" }

function Patch-Page([string]$relPath) {
    $abs = Join-Path $root $relPath
    if (-not (Test-Path $abs)) {
        Write-Warning "missing: $relPath"
        return
    }
    $html = Read-File $abs
    $original = $html

    # Decide the path to site.js based on whether the page is in /journal/.
    $isJournalSub = $relPath -like 'journal/*'
    $siteJsPath = if ($isJournalSub) { '../site.js' } else { 'site.js' }
    $scriptTag  = '<script src="' + $siteJsPath + '" defer></script>'

    # Inject the script tag right before </body>, but only if site.js isn't
    # already referenced anywhere on the page.
    if ($html -notmatch 'site\.js') {
        $html = [regex]::Replace(
            $html,
            '</body>',
            "  $scriptTag`r`n</body>",
            'IgnoreCase'
        )
    }

    # Rename the "Press" nav link to "Press & Awards".
    # Match: <a href="press.html"...>Press</a>
    # Match: <a href="press"...>Press</a>
    # Match: <a href="../press.html"...>Press</a>
    # Match: <a href="../press"...>Press</a>
    # Use a MatchEvaluator so we keep whatever attributes are already there.
    $html = [regex]::Replace(
        $html,
        '(<a\s+href="(?:\.\./)?press(?:\.html)?"[^>]*>)Press(</a>)',
        { param($m) "$($m.Groups[1].Value)Press &amp; Awards$($m.Groups[2].Value)" },
        'IgnoreCase'
    )

    if ($html -ne $original) {
        Write-File $abs $html
        Write-Host "  patched: $relPath"
    } else {
        Write-Host "  unchanged: $relPath"
    }
}

Write-Host "-- Root pages --------------------------------------------------"
foreach ($p in $rootSet) { Patch-Page $p }

Write-Host "-- Journal pages -----------------------------------------------"
foreach ($p in $journalPages) { Patch-Page $p }

Write-Host ""
Write-Host "Done."
