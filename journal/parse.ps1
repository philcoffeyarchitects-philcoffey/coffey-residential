$ErrorActionPreference = "Continue"
$base = "C:/Users/philc/Documents/Claude/Claude Code/coffey-residential"
$rawDir = "$base/journal/_raw"
$postsDir = "$base/journal/posts"
$imgDir = "$base/images/journal"
$indexPath = "$base/journal/index.json"
$failLog = "$base/journal/_failures.log"
$imgUrlMapPath = "$base/journal/_image_urls.json"

New-Item -ItemType Directory -Force -Path $postsDir, $imgDir | Out-Null

# Map of cdn_url -> local_filename for download phase
$globalImgMap = @{}

function Decode-HtmlEntities {
    param([string]$s)
    if (-not $s) { return $s }
    $s = $s -replace '&amp;', '&'
    $s = $s -replace '&quot;', '"'
    $s = $s -replace '&#39;', "'"
    $s = $s -replace '&apos;', "'"
    $s = $s -replace '&lt;', '<'
    $s = $s -replace '&gt;', '>'
    $s = $s -replace '&nbsp;', ' '
    $s = $s -replace '&mdash;', "--"
    $s = $s -replace '&ndash;', "-"
    $s = $s -replace '&hellip;', "..."
    $s = $s -replace '&rsquo;', "'"
    $s = $s -replace '&lsquo;', "'"
    $s = $s -replace '&rdquo;', '"'
    $s = $s -replace '&ldquo;', '"'
    # numeric entities
    $s = [regex]::Replace($s, '&#(\d+);', { param($m) [char][int]$m.Groups[1].Value })
    $s = [regex]::Replace($s, '&#x([0-9a-fA-F]+);', { param($m) [char][Convert]::ToInt32($m.Groups[1].Value, 16) })
    return $s
}

function Clean-Slug-Name {
    param([string]$name)
    # Take filename portion of a URL path, strip query
    $clean = $name -replace '\?.*$', ''
    # Decode percent-encoding minimally
    try { $clean = [System.Uri]::UnescapeDataString($clean) } catch {}
    # Sanitize for filesystem
    $clean = $clean -replace '[<>:"\\|?*]', '_'
    return $clean
}

function Get-LocalImageName {
    param([string]$cdnUrl)
    # Squarespace CDN URLs end with /<filename>?format=...
    # static1.squarespace.com URLs:  /static/<id>/<id>/<id>/<ts>/<filename>?...
    # images.squarespace-cdn.com URLs:  /content/v1/<id>/<guid>/<filename>?...
    $u = $cdnUrl -replace '^http:', 'https:'
    $stripped = ($u -split '\?')[0]
    $parts = $stripped -split '/'
    $name = $parts[-1]
    if (-not $name -or $name -eq '') { $name = $parts[-2] }
    $name = Clean-Slug-Name $name
    if ([string]::IsNullOrWhiteSpace($name)) {
        # fallback to hash
        $sha = [System.Security.Cryptography.SHA1]::Create()
        $hash = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($cdnUrl))
        $name = -join ($hash | ForEach-Object { $_.ToString('x2') })
        $name = "image-$name.jpg"
    }
    # ensure extension
    if ($name -notmatch '\.(jpg|jpeg|png|gif|webp|svg|avif)$') {
        $name = "$name.jpg"
    }
    return $name
}

function Normalize-CdnUrl {
    param([string]$url)
    # Convert to https + add format=2500w for max-res
    if (-not $url) { return $null }
    $u = $url -replace '^http:', 'https:'
    $u = $u -replace '^//', 'https://'
    # Remove existing format param
    $base = ($u -split '\?')[0]
    return "${base}?format=2500w"
}

function Html-To-Markdown {
    param([string]$html)
    if (-not $html) { return "" }

    $s = $html

    # Strip style/script tags fully
    $s = [regex]::Replace($s, '(?is)<style[^>]*>.*?</style>', '')
    $s = [regex]::Replace($s, '(?is)<script[^>]*>.*?</script>', '')

    # Convert <br>
    $s = [regex]::Replace($s, '(?i)<br\s*/?>', "`n")

    # Headings
    $s = [regex]::Replace($s, '(?is)<h1[^>]*>(.*?)</h1>', { param($m) "`n`n# " + ($m.Groups[1].Value.Trim()) + "`n`n" })
    $s = [regex]::Replace($s, '(?is)<h2[^>]*>(.*?)</h2>', { param($m) "`n`n## " + ($m.Groups[1].Value.Trim()) + "`n`n" })
    $s = [regex]::Replace($s, '(?is)<h3[^>]*>(.*?)</h3>', { param($m) "`n`n### " + ($m.Groups[1].Value.Trim()) + "`n`n" })
    $s = [regex]::Replace($s, '(?is)<h4[^>]*>(.*?)</h4>', { param($m) "`n`n#### " + ($m.Groups[1].Value.Trim()) + "`n`n" })
    $s = [regex]::Replace($s, '(?is)<h5[^>]*>(.*?)</h5>', { param($m) "`n`n##### " + ($m.Groups[1].Value.Trim()) + "`n`n" })
    $s = [regex]::Replace($s, '(?is)<h6[^>]*>(.*?)</h6>', { param($m) "`n`n###### " + ($m.Groups[1].Value.Trim()) + "`n`n" })

    # Blockquote
    $s = [regex]::Replace($s, '(?is)<blockquote[^>]*>(.*?)</blockquote>', { param($m)
        $body = $m.Groups[1].Value -replace '(?is)<[^>]+>', '' -replace '\s+', ' '
        "`n`n> " + ($body.Trim()) + "`n`n"
    })

    # Bold / italic
    $s = [regex]::Replace($s, '(?is)<(strong|b)[^>]*>(.*?)</\1>', { param($m) "**" + $m.Groups[2].Value + "**" })
    $s = [regex]::Replace($s, '(?is)<(em|i)[^>]*>(.*?)</\1>', { param($m) "*" + $m.Groups[2].Value + "*" })

    # Links
    $s = [regex]::Replace($s, '(?is)<a[^>]*href="([^"]+)"[^>]*>(.*?)</a>', { param($m)
        $href = $m.Groups[1].Value
        $text = $m.Groups[2].Value -replace '(?is)<[^>]+>', ''
        # Resolve relative URLs to absolute
        if ($href -match '^/') { $href = "https://www.coffeyresidential.com$href" }
        "[$text]($href)"
    })

    # Lists
    $s = [regex]::Replace($s, '(?is)<li[^>]*>(.*?)</li>', { param($m)
        $body = $m.Groups[1].Value -replace '(?is)<[^>]+>', '' -replace '\s+', ' '
        "- " + ($body.Trim()) + "`n"
    })
    $s = [regex]::Replace($s, '(?is)</?(ul|ol)[^>]*>', "`n")

    # Paragraphs
    $s = [regex]::Replace($s, '(?is)<p[^>]*>(.*?)</p>', { param($m) "`n`n" + ($m.Groups[1].Value.Trim()) + "`n`n" })

    # Divs and spans -- keep content
    $s = [regex]::Replace($s, '(?is)<(div|span|section|article)[^>]*>', '')
    $s = [regex]::Replace($s, '(?is)</(div|span|section|article)>', "`n")

    # Strip remaining HTML tags
    $s = [regex]::Replace($s, '(?is)<!--.*?-->', '')
    $s = [regex]::Replace($s, '(?is)<[^>]+>', '')

    # Decode entities
    $s = Decode-HtmlEntities $s

    # Collapse whitespace
    $s = $s -replace "`r`n", "`n"
    $s = $s -replace "`r", "`n"
    $s = [regex]::Replace($s, '[ \t]+', ' ')
    $s = [regex]::Replace($s, '\n[ \t]+', "`n")
    $s = [regex]::Replace($s, '\n{3,}', "`n`n")
    $s = $s.Trim()
    return $s
}

function Yaml-Quote {
    param([string]$s)
    if ($null -eq $s) { return '""' }
    $s = $s -replace '"', '\"'
    return '"' + $s + '"'
}

# Helper: extract attribute from an HTML tag string
function Get-Attr {
    param([string]$tag, [string]$attr)
    $m = [regex]::Match($tag, "(?i)$attr=`"([^`"]*)`"")
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}

$indexEntries = New-Object System.Collections.ArrayList
$failed = New-Object System.Collections.ArrayList
$emptyBodies = New-Object System.Collections.ArrayList

$files = Get-ChildItem -Path $rawDir -Filter "*.html"
$total = $files.Count
$n = 0
foreach ($f in $files) {
    $n++
    if ($n % 25 -eq 0) { Write-Host "Parsing $n / $total..." }
    $slug = $f.BaseName
    if ($slug -eq "_sample") { continue }
    $url = "https://www.coffeyresidential.com/blog/$slug"

    try {
        $html = [System.IO.File]::ReadAllText($f.FullName)
    } catch {
        $failed.Add(@{ slug = $slug; url = $url; reason = "read_error: $($_.Exception.Message)" }) | Out-Null
        continue
    }

    # === Extract metadata ===

    # Title from <h1 class="entry-title...">
    $title = $null
    $m = [regex]::Match($html, '(?is)<h1[^>]*class="[^"]*entry-title[^"]*"[^>]*>(.*?)</h1>')
    if ($m.Success) {
        $rawTitle = $m.Groups[1].Value -replace '(?is)<[^>]+>', ''
        $title = (Decode-HtmlEntities $rawTitle).Trim()
    }
    if (-not $title) {
        $m = [regex]::Match($html, '(?is)<meta\s+itemprop="headline"\s+content="([^"]+)"')
        if ($m.Success) { $title = (Decode-HtmlEntities $m.Groups[1].Value).Trim() }
    }
    if (-not $title) {
        $m = [regex]::Match($html, '(?is)<title>(.*?)</title>')
        if ($m.Success) {
            $title = (Decode-HtmlEntities $m.Groups[1].Value).Trim()
            $title = $title -replace ' &mdash;.*$', '' -replace ' -- .*$', '' -replace ' --.*$', ''
        }
    }

    # Date from meta itemprop="datePublished"
    $date = $null
    $m = [regex]::Match($html, '(?is)<meta\s+itemprop="datePublished"\s+content="([^"]+)"')
    if ($m.Success) {
        $raw = $m.Groups[1].Value
        if ($raw -match '^(\d{4})-(\d{2})-(\d{2})') { $date = $Matches[0] }
    }
    if (-not $date) {
        $m = [regex]::Match($html, '"datePublished":"([^"]+)"')
        if ($m.Success -and $m.Groups[1].Value -match '^(\d{4})-(\d{2})-(\d{2})') {
            $date = $Matches[0]
        }
    }

    # Author
    $author = $null
    $m = [regex]::Match($html, '(?is)<meta\s+itemprop="author"\s+content="([^"]+)"')
    if ($m.Success) { $author = (Decode-HtmlEntities $m.Groups[1].Value).Trim() }
    if (-not $author) {
        $m = [regex]::Match($html, '(?is)class="blog-author-name"[^>]*>(.*?)</a>')
        if ($m.Success) { $author = (Decode-HtmlEntities ($m.Groups[1].Value -replace '<[^>]+>', '')).Trim() }
    }

    # Tags / categories — Squarespace often uses class="blog-meta-item--categories" or similar
    $tags = @()
    $catMatches = [regex]::Matches($html, '(?is)class="[^"]*blog-meta-item--cate[^"]*"[^>]*>(.*?)</[^>]+>')
    foreach ($cm in $catMatches) {
        $catBlock = $cm.Groups[1].Value
        $linkMatches = [regex]::Matches($catBlock, '(?is)<a[^>]*>(.*?)</a>')
        foreach ($lm in $linkMatches) {
            $t = (Decode-HtmlEntities ($lm.Groups[1].Value -replace '<[^>]+>', '')).Trim()
            if ($t) { $tags += $t }
        }
    }
    if ($tags.Count -eq 0) {
        # check meta keywords
        $m = [regex]::Match($html, '(?is)<meta\s+name="keywords"\s+content="([^"]+)"')
        if ($m.Success -and $m.Groups[1].Value.Trim()) {
            $tags = $m.Groups[1].Value -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        }
    }

    # === Extract body ===
    # Body is everything inside <article id="article-..." class="h-entry...">  up to </article>
    # but more precisely from <div class="blog-item-content e-content"> to its matching close.
    # We'll grab from `blog-item-content` div start to first occurrence of `<div ... class="item-pagination`
    $bodyHtml = $null
    $m = [regex]::Match($html, '(?is)<div class="blog-item-content e-content">(.*?)(?:<nav[^>]*class="item-pagination|<div[^>]*class="item-pagination|</article>)')
    if ($m.Success) {
        $bodyHtml = $m.Groups[1].Value
    } else {
        # fallback: from <article ...> to </article>
        $m = [regex]::Match($html, '(?is)<article[^>]*class="h-entry[^"]*"[^>]*>(.*?)</article>')
        if ($m.Success) { $bodyHtml = $m.Groups[1].Value }
    }

    # === Extract images from body ===
    $postImages = New-Object System.Collections.ArrayList   # local filenames in order
    $postImageAlts = @{}
    $bodyForImg = $bodyHtml
    if ($bodyForImg) {
        # Squarespace lazy-loads with data-src / data-image / srcset, plus standard src
        $imgTags = [regex]::Matches($bodyForImg, '(?is)<img\b[^>]*>')
        foreach ($it in $imgTags) {
            $tag = $it.Value
            $src = $null
            foreach ($attr in @('data-image', 'data-src', 'src')) {
                $v = Get-Attr $tag $attr
                if ($v -and $v -notmatch '^data:') { $src = $v; break }
            }
            if (-not $src) { continue }
            $alt = Get-Attr $tag 'alt'
            $localName = Get-LocalImageName $src
            # Normalize CDN url and store mapping
            $cdnUrl = Normalize-CdnUrl $src
            if (-not $globalImgMap.ContainsKey($cdnUrl)) {
                $globalImgMap[$cdnUrl] = $localName
            } else {
                $localName = $globalImgMap[$cdnUrl]
            }
            if (-not $postImages.Contains($localName)) {
                $postImages.Add($localName) | Out-Null
                if ($alt) { $postImageAlts[$localName] = (Decode-HtmlEntities $alt).Trim() }
            }
        }
        # Replace <img> tags in body with markdown images BEFORE main conversion
        $bodyForImg = [regex]::Replace($bodyForImg, '(?is)<img\b[^>]*>', {
            param($m)
            $tag = $m.Value
            $src = $null
            foreach ($attr in @('data-image', 'data-src', 'src')) {
                $v = $null
                $am = [regex]::Match($tag, "(?i)$attr=`"([^`"]*)`"")
                if ($am.Success) { $v = $am.Groups[1].Value }
                if ($v -and $v -notmatch '^data:') { $src = $v; break }
            }
            if (-not $src) { return '' }
            $alt = ''
            $am = [regex]::Match($tag, '(?i)alt="([^"]*)"')
            if ($am.Success) { $alt = $am.Groups[1].Value }
            $name = $src -replace '^http:', 'https:' -replace '^//', 'https://'
            $name = ($name -split '\?')[0]
            $parts = $name -split '/'
            $fname = $parts[-1]
            if (-not $fname) { $fname = $parts[-2] }
            # use the same naming logic — simplest: relax and recompute
            $clean = $fname -replace '\?.*$', ''
            try { $clean = [System.Uri]::UnescapeDataString($clean) } catch {}
            $clean = $clean -replace '[<>:"\\|?*]', '_'
            if ([string]::IsNullOrWhiteSpace($clean)) { $clean = 'image.jpg' }
            if ($clean -notmatch '\.(jpg|jpeg|png|gif|webp|svg|avif)$') { $clean = "$clean.jpg" }
            $altOut = if ($alt) { $alt } else { ($clean -replace '\.[^.]+$', '') -replace '[-_]+', ' ' }
            return "`n`n![${altOut}](images/journal/$clean)`n`n"
        })
    }

    $bodyMd = ""
    if ($bodyForImg) {
        $bodyMd = Html-To-Markdown $bodyForImg
    }

    # If hero image not from body, try og:image
    $heroLocal = $null
    if ($postImages.Count -gt 0) {
        $heroLocal = $postImages[0]
    } else {
        $m = [regex]::Match($html, '(?is)<meta\s+property="og:image"\s+content="([^"]+)"')
        if ($m.Success) {
            $ogUrl = $m.Groups[1].Value
            $heroLocal = Get-LocalImageName $ogUrl
            $cdnUrl = Normalize-CdnUrl $ogUrl
            if (-not $globalImgMap.ContainsKey($cdnUrl)) {
                $globalImgMap[$cdnUrl] = $heroLocal
            } else {
                $heroLocal = $globalImgMap[$cdnUrl]
            }
            $postImages.Add($heroLocal) | Out-Null
        }
    }

    # === Word count ===
    $wordCount = 0
    if ($bodyMd) {
        # strip md syntax for counting
        $textOnly = $bodyMd -replace '\!\[[^\]]*\]\([^)]*\)', '' -replace '\[[^\]]*\]\([^)]*\)', '' -replace '[*_#>`]', ''
        $wordCount = ($textOnly -split '\s+' | Where-Object { $_ -ne '' }).Count
    }

    # === Build index entry ===
    $entry = [ordered]@{}
    $entry.slug = $slug
    $entry.title = if ($title) { $title } else { $slug }
    if ($date) { $entry.date = $date }
    if ($author) { $entry.author = $author }
    if ($tags.Count -gt 0) { $entry.tags = @($tags) }
    if ($heroLocal) { $entry.hero_image = "images/journal/$heroLocal" }
    $entry.image_count = $postImages.Count
    $entry.word_count = $wordCount
    $entry.source_url = $url

    $indexEntries.Add($entry) | Out-Null

    # If body is empty, log but skip md file
    if (-not $bodyMd -or $wordCount -lt 10) {
        $emptyBodies.Add($slug) | Out-Null
        continue
    }

    # === Write markdown file ===
    $frontmatter = New-Object System.Text.StringBuilder
    [void]$frontmatter.AppendLine('---')
    [void]$frontmatter.AppendLine("slug: $slug")
    [void]$frontmatter.AppendLine("title: $(Yaml-Quote $entry.title)")
    if ($date) { [void]$frontmatter.AppendLine("date: $date") }
    if ($author) { [void]$frontmatter.AppendLine("author: $(Yaml-Quote $author)") }
    if ($tags.Count -gt 0) {
        $tagList = ($tags | ForEach-Object { Yaml-Quote $_ }) -join ', '
        [void]$frontmatter.AppendLine("tags: [$tagList]")
    }
    if ($heroLocal) { [void]$frontmatter.AppendLine("hero_image: images/journal/$heroLocal") }
    if ($postImages.Count -gt 0) {
        [void]$frontmatter.AppendLine("images:")
        foreach ($img in $postImages) {
            [void]$frontmatter.AppendLine("  - images/journal/$img")
        }
    }
    [void]$frontmatter.AppendLine("source_url: $url")
    [void]$frontmatter.AppendLine('---')
    [void]$frontmatter.AppendLine('')

    $finalMd = $frontmatter.ToString() + $bodyMd + "`n"
    [System.IO.File]::WriteAllText("$postsDir/$slug.md", $finalMd, [System.Text.UTF8Encoding]::new($false))
}

# Sort index newest-first by date; entries without date go last
$sorted = $indexEntries | Sort-Object -Property @{Expression = { if ($_.Contains('date')) { $_.date } else { '0000-00-00' } }; Descending = $true }

# Convert to JSON
$jsonArray = @()
foreach ($e in $sorted) {
    $obj = [ordered]@{}
    foreach ($k in $e.Keys) { $obj[$k] = $e[$k] }
    $jsonArray += $obj
}

$jsonOut = $jsonArray | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($indexPath, $jsonOut, [System.Text.UTF8Encoding]::new($false))

# Save image URL map for download phase
$imgMapJson = $globalImgMap | ConvertTo-Json -Depth 3
[System.IO.File]::WriteAllText($imgUrlMapPath, $imgMapJson, [System.Text.UTF8Encoding]::new($false))

Write-Host "Parsed posts: $($indexEntries.Count)"
Write-Host "Empty-body posts (logged in index but no .md): $($emptyBodies.Count)"
Write-Host "Unique images to download: $($globalImgMap.Count)"
if ($failed.Count -gt 0) {
    Add-Content -Path $failLog -Value ($failed | ForEach-Object { "PARSE_FAIL`t$($_.slug)`t$($_.reason)" })
    Write-Host "Parse failures: $($failed.Count)"
}
if ($emptyBodies.Count -gt 0) {
    Add-Content -Path $failLog -Value ($emptyBodies | ForEach-Object { "EMPTY_BODY`t$_" })
}
