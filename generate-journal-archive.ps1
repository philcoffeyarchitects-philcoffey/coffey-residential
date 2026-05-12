# Build /journal/archive.html — a dense text list of every old journal
# entry (the 474 image-less posts) for SEO depth and reference. Entries
# get a title pulled from each file's <title> tag, with the site suffix
# stripped.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Web -ErrorAction SilentlyContinue
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

# Slugs for the 10 new image-led posts — exclude these from the archive.
$newSlugs = @(
    'the-corner-of-the-room',
    'how-a-window-meets-a-wall',
    'one-dial-per-room',
    'the-pile-on-the-table',
    'a-plant-is-a-piece-of-architecture',
    'why-we-still-draw-by-hand',
    'what-we-keep-the-cold-out-with',
    'the-cross-and-what-holds-it',
    'one-light-well-placed',
    'houses-outlast-watches',
    'archive'
)

$journalDir = Join-Path $root 'journal'
$files = Get-ChildItem -Path $journalDir -Filter '*.html' -File |
         Where-Object { $newSlugs -notcontains [System.IO.Path]::GetFileNameWithoutExtension($_.Name) } |
         Sort-Object Name

Write-Host "Found $($files.Count) archive entries"

# Clean-title regex (matches the SEO script)
function Clean-Title([string]$title) {
    if (-not $title) { return '' }
    $t = $title
    $em = [char]0x2014
    $en = [char]0x2013
    $hy = [char]0x002D
    $dash = "[$em$en$hy]"
    $t = $t -replace ('\s*' + $dash + '\s*Coffey\s*\|\s*Residential\s*' + $dash + '\s*Journal\s*$'), ''
    $t = $t -replace ('\s*' + $dash + '\s*Coffey\s*\|\s*Residential\s*$'), ''
    return $t.Trim()
}

# Pull each entry's title from its <title> tag.
$entries = @()
foreach ($f in $files) {
    $html = Read-File $f.FullName
    $m = [regex]::Match($html, '<title>([^<]*)</title>', 'IgnoreCase')
    if (-not $m.Success) { continue }
    $title = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)
    $title = Clean-Title $title
    $slug  = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $entries += [pscustomobject]@{ slug = $slug; title = $title }
}

Write-Host "Parsed $($entries.Count) titles"

# Render as a dense alphabetised list, grouped by first letter.
$entries = $entries | Sort-Object title
$sb = New-Object System.Text.StringBuilder
$currentLetter = ''
foreach ($e in $entries) {
    $first = ($e.title.Substring(0,1)).ToUpper()
    if ($first -ne $currentLetter) {
        if ($currentLetter -ne '') {
            [void]$sb.AppendLine('    </div>')
            [void]$sb.AppendLine('  </div>')
        }
        $currentLetter = $first
        [void]$sb.AppendLine('  <div class="archive-letter">')
        [void]$sb.AppendLine("    <div class=`"archive-letter__num`">$currentLetter</div>")
        [void]$sb.AppendLine('    <div class="archive-letter__list">')
    }
    $titleEsc = [System.Web.HttpUtility]::HtmlEncode($e.title)
    [void]$sb.AppendLine("      <a class=`"archive-row`" href=`"$($e.slug).html`"><span class=`"archive-row__title`">$titleEsc</span></a>")
}
if ($currentLetter -ne '') {
    [void]$sb.AppendLine('    </div>')
    [void]$sb.AppendLine('  </div>')
}
$archiveList = $sb.ToString()

# ------------ Archive HTML ------------

$baseUrl = 'https://coffeyresidential.com'

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<link rel="icon" type="image/svg+xml" href="../favicon.svg" />
<meta property="og:title" content="Journal archive &mdash; Coffey Residential" />
<meta property="og:description" content="The full archive of writing from the studio &mdash; $($entries.Count) entries, indexed alphabetically." />
<meta property="og:type" content="website" />
<meta property="og:url" content="$baseUrl/journal/archive" />
<meta property="og:image" content="$baseUrl/images/webp/cove-ridge-roofline-and-quarry.webp" />
<meta property="og:site_name" content="Coffey Residential" />
<meta property="og:locale" content="en_GB" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:image" content="$baseUrl/images/webp/cove-ridge-roofline-and-quarry.webp" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Journal archive &mdash; Coffey | Residential</title>
<meta name="description" content="The full archive of writing from the studio &mdash; $($entries.Count) entries from 2014 to early 2026, indexed alphabetically." />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700&family=PT+Serif+Caption:ital@0;1&family=Work+Sans:ital,wght@0,300;0,400;0,500;1,400&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../styles.css">
<!-- seo:canonical+jsonld start -->
<link rel="canonical" href="$baseUrl/journal/archive" />
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Coffey Residential",
  "alternateName": "Coffey Architects",
  "url": "https://coffeyresidential.com/",
  "logo": "https://coffeyresidential.com/images/webp/logo.webp"
}
</script>
<!-- seo:canonical+jsonld end -->
</head>
<body>
<div class="shell">

<header class="site-header">
  <div class="brand">
    <img class="brand-mark" src="../images/webp/logo.webp" alt="" />
    <span class="eyebrow">London &nbsp;&middot;&nbsp; Est. 2005</span>
  </div>
  <a class="wordmark" href="../index.html">Coffey<span class="pipe">|</span>Residential</a>
  <nav class="site-nav right">
    <a href="../homes.html">Homes</a>
    <a href="../studio.html">Studio</a>
    <a href="../process.html">Process</a>
    <a href="../press.html">Awards &amp; Press</a>
    <a href="../journal.html" class="is-active">Journal</a>
    <a href="../contact.html">Contact</a>
  </nav>
</header>

<div class="article-meta-strip">
  <div>
    <a href="../journal.html">Journal</a>
    <span class="sep">/</span>
    <span class="now">Archive</span>
  </div>
  <div>$($entries.Count) entries</div>
</div>

<section class="archive-hero">
  <div class="archive-hero__inner">
    <span class="eyebrow">Journal &nbsp;&middot;&nbsp; Archive</span>
    <h1>
      Everything we&rsquo;ve written
      <em>that didn&rsquo;t make the front page.</em>
    </h1>
    <p class="lede">Older entries from the studio &mdash; $($entries.Count) short posts on residential architecture in London, mostly written between 2014 and 2026. Indexed alphabetically, no images, no filters. The kind of thing you read if the algorithm sent you here.</p>
  </div>
</section>

<section class="archive-section">
$archiveList
</section>

<section class="cta">
  <div>
    <h2>Tell us about your house.</h2>
    <a class="cta-btn" href="../contact.html">Get in touch &nbsp;&rarr;</a>
  </div>
  <div class="cta__news">
    <span class="eyebrow">Newsletter</span>
    <p>Two letters a year. New work, recent writing.</p>
    <form class="form" onsubmit="event.preventDefault();">
      <input type="email" placeholder="email@address" required>
      <button type="submit">Subscribe &rarr;</button>
    </form>
  </div>
</section>

<footer class="site-footer">
  <div>Coffey Residential &nbsp;&middot;&nbsp; 104&ndash;110 Goswell Road, Clerkenwell, London EC1V 7DH</div>
  <div><a href="mailto:contact@coffeyresidential.com">contact@coffeyresidential.com</a></div>
  <div>&copy; 2026</div>
</footer>

</div><!-- /.shell -->
  <script src="../site.js" defer></script>
</body>
</html>
"@

# Need System.Web for HtmlEncode (PowerShell 5 doesn't load by default).
Add-Type -AssemblyName System.Web -ErrorAction SilentlyContinue

$outPath = Join-Path $journalDir 'archive.html'
Write-File $outPath $html
Write-Host "Wrote: journal/archive.html"
