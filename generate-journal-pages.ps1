# Generate one HTML article page per scraped markdown post.
# Output: journal/[slug].html
# Each page uses the article template chassis (breadcrumb / centred title block /
# lead image / narrow body / read-next / CTA / footer).

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$postsDir = Join-Path $root 'journal\posts'
$outDir   = Join-Path $root 'journal'
$indexJson = Join-Path $root 'journal\index.json'

# Read the index for the "Read next" picker
$index = Get-Content $indexJson -Raw -Encoding UTF8 | ConvertFrom-Json

# ──────────── helpers ────────────

function Encode-Html([string]$s) {
    if ($null -eq $s) { return '' }
    return $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

function Parse-Frontmatter([string]$content) {
    $fm = @{}
    $body = $content
    if ($content -match '(?s)\A---\s*\r?\n(.*?)\r?\n---\s*\r?\n(.*)\z') {
        $fmText = $matches[1]
        $body   = $matches[2]
        # Simple YAML parse &mdash;flat key:value pairs, with optional list values
        $currentKey = $null
        foreach ($line in $fmText -split "`r?`n") {
            if ($line -match '^\s*-\s+(.+)$') {
                if ($currentKey -and $fm[$currentKey] -is [System.Collections.IList]) {
                    $val = $matches[1].Trim().Trim('"')
                    [void]$fm[$currentKey].Add($val)
                }
            } elseif ($line -match '^([a-zA-Z_]+):\s*(.*)$') {
                $k = $matches[1]; $v = $matches[2].Trim()
                if ($v -eq '') {
                    # Start of a list (followed by - items)
                    $fm[$k] = New-Object System.Collections.ArrayList
                    $currentKey = $k
                } else {
                    $fm[$k] = $v.Trim('"')
                    $currentKey = $k
                }
            }
        }
    }
    return @{ frontmatter = $fm; body = $body }
}

function Convert-MarkdownBody([string]$md) {
    # Convert a simplified subset of markdown into HTML.
    $lines = $md -split "`r?`n"
    $sb = New-Object System.Text.StringBuilder
    $inList = $false
    $listType = $null
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        $trim = $line.Trim()

        # Close an open list when the next line isn't a list item
        if ($inList -and -not ($trim -match '^[-*]\s+' -or $trim -match '^\d+\.\s+')) {
            [void]$sb.AppendLine("</$listType>")
            $inList = $false; $listType = $null
        }

        if ($trim -eq '') { $i++; continue }

        if ($trim -match '^####\s+(.+)$') {
            [void]$sb.AppendLine("<h4>$(Inline-Markdown $matches[1])</h4>")
        }
        elseif ($trim -match '^###\s+(.+)$') {
            [void]$sb.AppendLine("<h3>$(Inline-Markdown $matches[1])</h3>")
        }
        elseif ($trim -match '^##\s+(.+)$') {
            [void]$sb.AppendLine("<h2>$(Inline-Markdown $matches[1])</h2>")
        }
        elseif ($trim -match '^>\s*(.*)$') {
            # Blockquote &mdash;gather consecutive quoted lines
            $quoteText = New-Object System.Collections.ArrayList
            while ($i -lt $lines.Count -and $lines[$i].Trim() -match '^>\s*(.*)$') {
                [void]$quoteText.Add($matches[1])
                $i++
            }
            $joined = ($quoteText -join ' ').Trim()
            [void]$sb.AppendLine("<blockquote><p>$(Inline-Markdown $joined)</p></blockquote>")
            continue
        }
        elseif ($trim -match '^!\[([^\]]*)\]\(([^)]+)\)\s*$') {
            # Per Phil's direction: no images in journal articles. Drop image lines entirely.
        }
        elseif ($trim -match '^[-*]\s+(.+)$') {
            if (-not $inList) {
                [void]$sb.AppendLine('<ul>')
                $inList = $true; $listType = 'ul'
            }
            [void]$sb.AppendLine("<li>$(Inline-Markdown $matches[1])</li>")
        }
        elseif ($trim -match '^\d+\.\s+(.+)$') {
            if (-not $inList) {
                [void]$sb.AppendLine('<ol>')
                $inList = $true; $listType = 'ol'
            }
            [void]$sb.AppendLine("<li>$(Inline-Markdown $matches[1])</li>")
        }
        else {
            [void]$sb.AppendLine("<p>$(Inline-Markdown $trim)</p>")
        }
        $i++
    }
    if ($inList) { [void]$sb.AppendLine("</$listType>") }
    return $sb.ToString()
}

function Inline-Markdown([string]$s) {
    if ($null -eq $s) { return '' }
    # Drop inline images — journal articles are text-only by direction.
    $s = [regex]::Replace($s, '!\[([^\]]*)\]\(([^)]+)\)', '')
    # Then links &mdash;strip any old coffeyresidential.com prefix and point internal links to the new site
    $s = [regex]::Replace($s, '\[([^\]]+)\]\(([^)]+)\)',
        { param($m)
            $href = $m.Groups[2].Value
            # Rewrite any links back to the homepage on the old site
            $href = $href -replace 'https?://www\.coffeyresidential\.com/?', '/'
            "<a href=`"$href`">$($m.Groups[1].Value)</a>"
        })
    # Bold / italic
    $s = [regex]::Replace($s, '\*\*([^*]+)\*\*', '<strong>$1</strong>')
    $s = [regex]::Replace($s, '(?<!\w)_([^_]+)_(?!\w)', '<em>$1</em>')
    $s = [regex]::Replace($s, '(?<!\*)\*([^*]+)\*(?!\*)', '<em>$1</em>')
    # Inline code
    $s = [regex]::Replace($s, '`([^`]+)`', '<code>$1</code>')
    return $s
}

# ──────────── template ────────────

$template = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<link rel="icon" type="image/svg+xml" href="../favicon.svg" />
<meta property="og:title" content="{{TITLE_ESC}} &mdash; Coffey Residential Journal" />
<meta property="og:description" content="{{META_DESC}}" />
<meta property="og:type" content="article" />
<meta property="og:url" content="https://coffeyresidential.com/journal/{{SLUG}}.html" />
<meta property="og:image" content="https://coffeyresidential.com/images/cove-ridge-roofline-and-quarry.jpg" />
<meta property="og:site_name" content="Coffey Residential" />
<meta property="og:locale" content="en_GB" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:image" content="https://coffeyresidential.com/images/cove-ridge-roofline-and-quarry.jpg" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>{{TITLE_ESC}} &mdash; Coffey | Residential &mdash; Journal</title>
<meta name="description" content="{{META_DESC}}" />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700&family=PT+Serif+Caption:ital@0;1&family=Work+Sans:ital,wght@0,300;0,400;0,500;1,400&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../styles.css">
</head>
<body>
<div class="shell">

<header class="site-header">
  <div class="brand">
    <img class="brand-mark" src="../images/logo.png" alt="" />
    <span class="eyebrow">London &nbsp;&middot;&nbsp; Est. 2005</span>
  </div>
  <a class="wordmark" href="../index.html">Coffey<span class="pipe">|</span>Residential</a>
  <nav class="site-nav right">
    <a href="../homes.html">Homes</a>
    <a href="../studio.html">Studio</a>
    <a href="../process.html">Process</a>
    <a href="../press.html">Press</a>
    <a href="../journal.html" class="is-active">Journal</a>
    <a href="../contact.html">Contact</a>
  </nav>
</header>

<div class="article-meta-strip">
  <div>
    <a href="../journal.html">Journal</a>
    <span class="sep">/</span>
    <span class="now">{{TITLE_ESC}}</span>
  </div>
  <div>{{READ_TIME}}</div>
</div>

<section class="article-hero">
  <span class="eyebrow">{{EYEBROW}}</span>
  <h1>{{TITLE_HTML}}</h1>
  <div class="meta-row">
    <span>Words &middot; {{AUTHOR}}</span>
    <span>&middot;</span>
    <span>{{READ_TIME}}</span>
  </div>
</section>

<section class="article-body">
{{BODY_HTML}}
</section>

<section class="article-footer">
  <div class="article-footer__row">
    <div>
      <div class="by">Words by</div>
      <div class="name">{{AUTHOR}}</div>
      <div class="role">Coffey Residential &middot; Journal</div>
    </div>
    <div class="share">
      <span>Share &middot; Copy link</span>
      <span>Email</span>
      <span>Print</span>
    </div>
  </div>
</section>

<section class="read-next">
  <div class="read-next__head">
    <h3>Read next</h3>
    <a class="more" href="../journal.html">All journal &rarr;</a>
  </div>
  <div class="read-next__grid">
{{READ_NEXT_CARDS}}
  </div>
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
</body>
</html>
'@

# ──────────── build ────────────

$mdFiles = Get-ChildItem $postsDir -Filter '*.md'
$totalCount = $mdFiles.Count
Write-Output "Building $totalCount article pages..."

# Resolve image references in markdown to point UP one directory level
# (we're rendering at journal/[slug].html, images/ is at ../images/).
$fixImagePath = {
    param($html)
    $html = $html -replace 'src="images/', 'src="../images/'
    return $html
}

$built = 0; $failed = 0
foreach ($mdFile in $mdFiles) {
    try {
        $content = [System.IO.File]::ReadAllText($mdFile.FullName, $utf8)
        $parsed = Parse-Frontmatter $content
        $fm = $parsed.frontmatter
        $bodyMd = $parsed.body
        $bodyHtml = Convert-MarkdownBody $bodyMd
        $bodyHtml = & $fixImagePath $bodyHtml

        $slug = if ($fm.slug) { $fm.slug } else { [System.IO.Path]::GetFileNameWithoutExtension($mdFile.Name) }
        $title = if ($fm.title) { $fm.title } else { $slug -replace '-', ' ' }
        $titleEsc = Encode-Html $title
        $author = if ($fm.author) { $fm.author } else { 'Coffey Residential' }
        $date = if ($fm.date) { $fm.date } else { '' }
        $hero = if ($fm.hero_image) { $fm.hero_image } else { '' }
        $wordCount = if ($bodyMd) { ($bodyMd -split '\s+').Count } else { 0 }
        $readTime = [Math]::Max(1, [Math]::Round($wordCount / 200))
        $readTimeStr = "$readTime min read"

        # Eyebrow: Journal · Mar 2024 (or just Journal)
        $eyebrowParts = @('Journal')
        if ($date) {
            try {
                $d = [DateTime]::Parse($date)
                $eyebrowParts += $d.ToString('MMMM yyyy')
            } catch {}
        }
        $eyebrow = ($eyebrowParts -join ' &middot; ')

        # Lead image block
        $leadImageBlock = ''
        if ($hero) {
            $heroAdjusted = $hero -replace '^images/', '../images/'
            $heroAlt = Encode-Html $title
            $leadImageBlock = @"
<figure class="article-lead-image">
  <img src="$heroAdjusted" alt="$heroAlt" loading="lazy">
</figure>
"@
        }

        # Read-next picks: pick 3 random from the index, excluding the current slug
        $candidates = $index | Where-Object { $_.slug -ne $slug } | Get-Random -Count 3
        $cardsHtml = ($candidates | ForEach-Object {
            $rn = $_
            $rnDate = ''
            if ($rn.date) {
                try { $rnDate = ([DateTime]::Parse($rn.date)).ToString('MMM yyyy') } catch {}
            }
            $rnReadTime = if ($rn.word_count) { [Math]::Max(1, [Math]::Round($rn.word_count / 200)).ToString() + ' min' } else { '' }
            $metaParts = @('Journal')
            if ($rnDate) { $metaParts += $rnDate }
            if ($rnReadTime) { $metaParts += $rnReadTime }
            $meta = ($metaParts -join ' &middot; ')
            $rnTitleEsc = Encode-Html $rn.title
@"

    <a class="read-next__card" href="$($rn.slug).html">
      <div class="meta">$meta</div>
      <div class="title">$rnTitleEsc</div>
    </a>
"@
        }) -join ''

        $metaDesc = ''
        if ($bodyMd) {
            $stripped = ($bodyMd -replace '[#*_`>\-\[\]\(\)!]', '' -replace '\s+', ' ').Trim()
            $metaDesc = $stripped.Substring(0, [Math]::Min(160, $stripped.Length))
            $metaDesc = Encode-Html $metaDesc
        }

        $html = $template `
            -replace '\{\{TITLE_ESC\}\}', $titleEsc `
            -replace '\{\{TITLE_HTML\}\}', $titleEsc `
            -replace '\{\{SLUG\}\}', $slug `
            -replace '\{\{META_DESC\}\}', $metaDesc `
            -replace '\{\{EYEBROW\}\}', $eyebrow `
            -replace '\{\{AUTHOR\}\}', (Encode-Html $author) `
            -replace '\{\{READ_TIME\}\}', $readTimeStr `
            -replace '\{\{LEAD_IMAGE_BLOCK\}\}', $leadImageBlock `
            -replace '\{\{BODY_HTML\}\}', $bodyHtml `
            -replace '\{\{READ_NEXT_CARDS\}\}', $cardsHtml

        $outPath = Join-Path $outDir "$slug.html"
        [System.IO.File]::WriteAllText($outPath, $html, $utf8)
        $built++
    } catch {
        Write-Output ("FAIL " + $mdFile.Name + " :: " + $_.Exception.Message)
        $failed++
    }
}

Write-Output ("Built: $built, Failed: $failed")
