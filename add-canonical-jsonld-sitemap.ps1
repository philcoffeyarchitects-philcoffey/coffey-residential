# Generates sitemap.xml + robots.txt and injects <link rel="canonical"> and
# JSON-LD structured data into every active HTML page on the site.
#
# Idempotent: re-running produces the same files. Existing canonical tags and
# JSON-LD blocks (matched by a stable signature comment) are replaced; new
# ones are inserted just before </head>.
#
# Why: the Squarespace-era sitemap.xml is stale, and the rebuilt pages have
# OG/Twitter meta but no canonical URLs and no schema.org markup. This brings
# the site up to the SEO baseline in the design handoff.

$ErrorActionPreference = 'Stop'
$utf8    = New-Object System.Text.UTF8Encoding $false
$root    = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$baseUrl = 'https://coffeyresidential.com'
$lastmod = '2026-05-11'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

function HtmlAttrEncode([string]$s) {
    if ([string]::IsNullOrEmpty($s)) { return '' }
    return $s.Replace('&', '&amp;').Replace('"', '&quot;').Replace('<', '&lt;').Replace('>', '&gt;')
}

function Get-Meta([string]$html, [string]$attr, [string]$name) {
    # Reads <meta {attr}="{name}" content="..."> — returns content or $null
    $rx = [regex]::new("<meta\s+$attr=`"$([regex]::Escape($name))`"\s+content=`"([^`"]*)`"", 'IgnoreCase')
    $m = $rx.Match($html)
    if ($m.Success) { return [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value) }
    return $null
}

function Get-Title([string]$html) {
    $m = [regex]::Match($html, '<title>([^<]*)</title>', 'IgnoreCase')
    if ($m.Success) { return [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value) }
    return $null
}

# ------------ 1. Pick the active pages ------------
# Root content pages — nav + 20 project pages + the standalone journal piece.
# Excluded: thanks.html, specimens.html, source.html, reference-editorial.html
# (dev/design/internal pages — kept out of the sitemap).

$navPages = @(
    'index.html',
    'homes.html',
    'studio.html',
    'process.html',
    'press.html',
    'journal.html',
    'contact.html'
)
$projectPages = @(
    'ad-house-york.html',
    'apartment-block-clerkenwell.html',
    'arch-study-notting-hill.html',
    'canyon-house-clerkenwell.html',
    'capablanca-house-barnsbury.html',
    'cove-ridge-devon.html',
    'folded-house-islington.html',
    'garden-lodge-harpenden.html',
    'helios-house-white-city.html',
    'hidden-house-clerkenwell.html',
    'island-home-shoreditch.html',
    'kitchen-garden-maida-vale.html',
    'meadow-grove-barnes.html',
    'modern-barn-devon.html',
    'modern-detached-harpenden.html',
    'modern-mews-paddington.html',
    'modern-side-extension.html',
    'modern-terrace-islington.html',
    'sky-house-camden.html',
    'well-house-islington.html'
)
$rootJournal = @('journal-on-the-architecture-of-light.html')

$journalDir   = Join-Path $root 'journal'
$journalPages = Get-ChildItem -Path $journalDir -Filter '*.html' -File |
                Where-Object { $_.Name -ne 'index.html' } |
                ForEach-Object { "journal/$($_.Name)" } | Sort-Object

$rootSet = $navPages + $projectPages + $rootJournal

# ------------ 2. The shared Organization schema ------------
# Used on every page. The LocalBusiness / Article / CreativeWork schemas on
# specific pages are emitted in addition to this.

$orgSchema = @'
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Coffey Residential",
  "alternateName": "Coffey Architects",
  "url": "https://coffeyresidential.com/",
  "logo": "https://coffeyresidential.com/images/webp/logo.webp",
  "founder": { "@type": "Person", "name": "Phil Coffey" },
  "foundingDate": "2005",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "104-110 Goswell Road",
    "addressLocality": "London",
    "addressRegion": "Clerkenwell",
    "postalCode": "EC1V 7DH",
    "addressCountry": "GB"
  },
  "telephone": "+44 20 7549 2141",
  "email": "contact@coffeyresidential.com",
  "sameAs": [
    "https://www.coffeyarchitects.com/"
  ]
}
'@

$websiteSchema = @'
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "Coffey Residential",
  "url": "https://coffeyresidential.com/",
  "publisher": { "@type": "Organization", "name": "Coffey Residential" },
  "inLanguage": "en-GB"
}
'@

$localBusinessSchema = @'
{
  "@context": "https://schema.org",
  "@type": "ArchitecturalService",
  "name": "Coffey Residential",
  "image": "https://coffeyresidential.com/images/cove-ridge-roofline-and-quarry.jpg",
  "url": "https://coffeyresidential.com/contact.html",
  "telephone": "+44 20 7549 2141",
  "email": "contact@coffeyresidential.com",
  "priceRange": "£££",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "104-110 Goswell Road",
    "addressLocality": "London",
    "addressRegion": "Clerkenwell",
    "postalCode": "EC1V 7DH",
    "addressCountry": "GB"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 51.5260,
    "longitude": -0.0986
  },
  "areaServed": [
    { "@type": "City", "name": "London" },
    { "@type": "Country", "name": "United Kingdom" }
  ]
}
'@

function Build-CreativeWork([string]$url, [string]$title, [string]$desc, [string]$image) {
    $titleE = HtmlAttrEncode $title
    $descE  = HtmlAttrEncode $desc
    return @"
{
  "@context": "https://schema.org",
  "@type": "CreativeWork",
  "name": "$titleE",
  "description": "$descE",
  "url": "$url",
  "image": "$image",
  "creator": { "@type": "Organization", "name": "Coffey Residential" }
}
"@
}

function Build-Breadcrumb([string[]]$labels, [string[]]$urls) {
    $items = @()
    for ($i = 0; $i -lt $labels.Count; $i++) {
        $labelE = HtmlAttrEncode $labels[$i]
        $urlE   = $urls[$i]
        $items += @"
    { "@type": "ListItem", "position": $($i + 1), "name": "$labelE", "item": "$urlE" }
"@
    }
    $itemsJoined = $items -join ",`n"
    return @"
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
$itemsJoined
  ]
}
"@
}

function Build-Article([string]$url, [string]$title, [string]$desc, [string]$image) {
    $titleE = HtmlAttrEncode $title
    $descE  = HtmlAttrEncode $desc
    return @"
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "$titleE",
  "description": "$descE",
  "url": "$url",
  "image": "$image",
  "author": { "@type": "Organization", "name": "Coffey Residential" },
  "publisher": {
    "@type": "Organization",
    "name": "Coffey Residential",
    "logo": { "@type": "ImageObject", "url": "https://coffeyresidential.com/images/webp/logo.webp" }
  }
}
"@
}

# ------------ 3. URL + title helpers ------------

# Compute the canonical (extension-less) URL for a relative file path.
# Matches the URL scheme of the old Squarespace site so Google's existing
# index of /cove-ridge-devon (no .html) keeps resolving to the right page.
function Get-CleanUrl([string]$relPath) {
    $clean = $relPath -replace '\\', '/'
    if ($clean -ieq 'index.html') { return "$baseUrl/" }
    $clean = $clean -replace '\.html$', ''
    return "$baseUrl/$clean"
}

# Strip the site suffix from the page <title> so Article.headline and
# CreativeWork.name read as just the project / article name, not
# "X (dash) Coffey | Residential (dash) Journal".
#
# Uses \u escapes (em-dash U+2014, en-dash U+2013, hyphen U+002D) because
# Windows PowerShell 5 reads .ps1 files as Windows-1252 when there is no
# BOM, which mangles literal em-dashes in regex character classes.
function Clean-Title([string]$title) {
    if (-not $title) { return '' }
    $t = $title
    # Build dash character class from explicit codepoints so the regex is
    # immune to how PowerShell reads this script file's encoding.
    $em = [char]0x2014  # em-dash
    $en = [char]0x2013  # en-dash
    $hy = [char]0x002D  # hyphen-minus
    $dash = "[$em$en$hy]"
    # Drop trailing "(dash) Coffey | Residential (dash) Journal"
    $t = $t -replace ('\s*' + $dash + '\s*Coffey\s*\|\s*Residential\s*' + $dash + '\s*Journal\s*$'), ''
    # Drop trailing "(dash) Coffey | Residential"
    $t = $t -replace ('\s*' + $dash + '\s*Coffey\s*\|\s*Residential\s*$'), ''
    # Drop trailing "(dash) Coffey Residential, residential architects in London"
    $t = $t -replace ('\s*' + $dash + '\s*Coffey\s+Residential,\s+residential\s+architects\s+in\s+London\s*$'), ''
    return $t.Trim()
}

# ------------ 4. Inject canonical + JSON-LD into one page ------------

# Marker comment identifies the block we inject so re-runs can replace it
# without leaving stale copies behind.
$blockStart = '<!-- seo:canonical+jsonld start -->'
$blockEnd   = '<!-- seo:canonical+jsonld end -->'

function Process-Page([string]$relPath) {
    $abs = Join-Path $root $relPath
    if (-not (Test-Path $abs)) {
        Write-Warning "missing: $relPath"
        return
    }
    $html = Read-File $abs

    # Compute the canonical URL from the file path (not the existing og:url).
    # The old Squarespace site uses extension-less URLs, so we match that.
    $cleanUrl = Get-CleanUrl $relPath

    $rawTitle = Get-Title $html
    $title    = Clean-Title $rawTitle
    $desc     = Get-Meta $html 'name' 'description'
    $ogImg    = Get-Meta $html 'property' 'og:image'
    if (-not $ogImg) {
        $ogImg = "$baseUrl/images/cove-ridge-roofline-and-quarry.jpg"
    }
    if (-not $title) { $title = 'Coffey Residential' }
    if (-not $desc)  { $desc  = '' }

    # Bring the page's <meta property="og:url"> into sync with the canonical
    # URL. Squarespace indexed these without .html, so dropping the extension
    # here keeps OpenGraph shares and canonical pointing at the same path.
    $html = [regex]::Replace(
        $html,
        '(<meta\s+property="og:url"\s+content=")[^"]*(")',
        { param($m) "$($m.Groups[1].Value)$cleanUrl$($m.Groups[2].Value)" },
        'IgnoreCase'
    )

    # Build the page-specific schemas
    $schemas = @($orgSchema)

    $isContact   = ($relPath -ieq 'contact.html')
    $isIndex     = ($relPath -ieq 'index.html')
    $isProject   = ($projectPages -contains $relPath)
    $isJournal   = ($relPath -like 'journal/*.html') -or ($rootJournal -contains $relPath)

    if ($isIndex)   { $schemas += $websiteSchema }
    if ($isContact) { $schemas += $localBusinessSchema }

    if ($isProject) {
        $schemas += (Build-CreativeWork $cleanUrl $title $desc $ogImg)
        $schemas += (Build-Breadcrumb @('Homes', $title) @("$baseUrl/homes", $cleanUrl))
    }
    if ($isJournal) {
        $schemas += (Build-Article $cleanUrl $title $desc $ogImg)
        $schemas += (Build-Breadcrumb @('Journal', $title) @("$baseUrl/journal", $cleanUrl))
    }

    # Assemble the injected block
    $scriptTags = ($schemas | ForEach-Object {
        "<script type=`"application/ld+json`">$_</script>"
    }) -join "`n"

    $canonical = "<link rel=`"canonical`" href=`"$cleanUrl`" />"

    $block = @"
$blockStart
$canonical
$scriptTags
$blockEnd
"@

    # Replace existing block (between marker comments) OR insert before </head>
    $rxBlock = [regex]::new(
        [regex]::Escape($blockStart) + '.*?' + [regex]::Escape($blockEnd),
        'Singleline'
    )
    if ($rxBlock.IsMatch($html)) {
        # Replace the existing injected block. MatchEvaluator avoids needing to
        # escape `$` and `\` in the replacement string.
        $newHtml = $rxBlock.Replace($html, { param($m) $block }, 1)
    } else {
        # Strip any pre-existing stray rel=canonical so it doesn't double up.
        $htmlNoCanonical = [regex]::Replace($html, '<link\s+rel="canonical"[^>]*>\s*', '', 'IgnoreCase')
        $newHtml = [regex]::Replace($htmlNoCanonical, '</head>', "$block`n</head>", 'IgnoreCase')
    }

    if ($newHtml -ne $html) {
        Write-File $abs $newHtml
        Write-Host "  patched: $relPath"
    } else {
        Write-Host "  unchanged: $relPath"
    }
}

# ------------ 4. Run the page pass ------------

Write-Host "-- Patching root pages -----------------------------------------"
foreach ($p in $rootSet) { Process-Page $p }

Write-Host "-- Patching journal pages --------------------------------------"
foreach ($p in $journalPages) { Process-Page $p }

# ------------ 5. Sitemap ------------

Write-Host "-- Writing sitemap.xml -----------------------------------------"

$allPaths = @()
$allPaths += $rootSet | ForEach-Object { $_ }
$allPaths += $journalPages

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')

# Homepage gets priority 1.0; primary nav pages 0.9; project pages 0.8;
# journal pages 0.5. Crawl frequency conservative.
# URLs in the sitemap match the canonical (extension-less) form so Google's
# existing index of the old Squarespace slugs maps onto the new site.
foreach ($p in $allPaths) {
    $url = Get-CleanUrl $p
    $priority = '0.5'
    $changefreq = 'monthly'
    if ($p -eq 'index.html') {
        $priority = '1.0'
        $changefreq = 'weekly'
    } elseif ($navPages -contains $p) {
        $priority = '0.9'
        $changefreq = 'monthly'
    } elseif ($projectPages -contains $p) {
        $priority = '0.8'
        $changefreq = 'monthly'
    }
    [void]$sb.AppendLine('  <url>')
    [void]$sb.AppendLine("    <loc>$url</loc>")
    [void]$sb.AppendLine("    <lastmod>$lastmod</lastmod>")
    [void]$sb.AppendLine("    <changefreq>$changefreq</changefreq>")
    [void]$sb.AppendLine("    <priority>$priority</priority>")
    [void]$sb.AppendLine('  </url>')
}
[void]$sb.AppendLine('</urlset>')

Write-File (Join-Path $root 'sitemap.xml') $sb.ToString()
Write-Host "  wrote sitemap.xml ($($allPaths.Count) URLs)"

# ------------ 6. robots.txt ------------

Write-Host "-- Writing robots.txt ------------------------------------------"

$robots = @"
User-agent: *
Allow: /
Disallow: /pages-html/
Disallow: /journal/_raw/
Disallow: /design_handoff_coffey_residential/

Sitemap: $baseUrl/sitemap.xml
"@
Write-File (Join-Path $root 'robots.txt') $robots
Write-Host "  wrote robots.txt"

Write-Host ""
Write-Host "Done."
