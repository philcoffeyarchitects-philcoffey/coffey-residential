# Adds OG / Twitter meta tags and rewrites image alt text across the site.
# Idempotent: skips OG injection if og:image is already present, and re-runs
# of the alt rewrite produce the same output.
#
# SEO target: "residential architects london"

$ErrorActionPreference = 'Stop'
$utf8    = New-Object System.Text.UTF8Encoding $false
$root    = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$baseUrl = 'https://coffeyresidential.com'
$defaultOgImg = 'images/cove-ridge-roofline-and-quarry.jpg'

# ──────────── helpers ────────────

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

function HtmlAttrEncode([string]$s) {
    if ([string]::IsNullOrEmpty($s)) { return '' }
    return $s.Replace('&', '&amp;').Replace('"', '&quot;').Replace('<', '&lt;').Replace('>', '&gt;')
}

function Caption-From-Filename([string]$imgPath, [string]$projectSlug) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($imgPath)
    # Try slug, then slug-minus-last-segment, as the prefix to strip
    $candidates = @($projectSlug)
    $parts = $projectSlug -split '-'
    if ($parts.Count -gt 2) {
        $candidates += (($parts[0..($parts.Count - 2)]) -join '-')
    }
    foreach ($p in $candidates) {
        if ($base.StartsWith("$p-")) {
            $caption = $base.Substring($p.Length + 1)
            $caption = ($caption -replace '-', ' ').Trim()
            if ($caption.Length -gt 0) {
                $caption = $caption.Substring(0,1).ToUpper() + $caption.Substring(1)
            }
            return $caption
        }
    }
    # Fallback: turn the basename into a phrase
    $fallback = ($base -replace '-', ' ').Trim()
    if ($fallback.Length -gt 0) {
        $fallback = $fallback.Substring(0,1).ToUpper() + $fallback.Substring(1)
    }
    return $fallback
}

# Build slug → project info from filename (used as fallback when an image
# on the homepage / homes index references a project not on its own page).
function Slug-From-ImagePath([string]$imgPath, $allSlugs) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($imgPath)
    # Pick the longest slug-base that the image filename starts with
    $best = $null
    foreach ($s in $allSlugs) {
        $parts = $s -split '-'
        $candidates = @($s)
        if ($parts.Count -gt 2) {
            $candidates += (($parts[0..($parts.Count - 2)]) -join '-')
        }
        foreach ($c in $candidates) {
            if ($base.StartsWith("$c-") -or $base -eq $c) {
                if (-not $best -or $c.Length -gt $best.matched.Length) {
                    $best = @{ slug = $s; matched = $c }
                }
            }
        }
    }
    return $best
}

# ──────────── Phase A: scan project pages ────────────

Write-Host "── Phase A: scanning project pages ─────────────────────────────"

$projectMap = @{}
$rootHtml   = Get-ChildItem -Path $root -Filter '*.html' -File

foreach ($f in $rootHtml) {
    $c = Read-File $f.FullName
    if ($c -notmatch '<section class="project-hero">') { continue }

    $slug = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)

    $name = $null; $loc = $null; $hero = $null; $year = $null; $type = $null; $desc = $null

    if ($c -match '<div class="project-title__lhs">[\s\S]*?<h1>([^<]+)</h1>') { $name = $matches[1].Trim() }
    if ($c -match '<div class="project-title__lhs">[\s\S]*?<div class="loc">([^<]+)</div>') { $loc = $matches[1].Trim() }
    if ($c -match '<section class="project-hero">[\s\S]*?<img[^>]+src="([^"]+)"') { $hero = $matches[1] }
    if ($c -match '<meta name="description" content="([^"]+)"') { $desc = $matches[1] }
    if ($c -match '<span class="eyebrow">([^<]+) &middot; (\d{4})</span>') {
        $type = $matches[1].Trim()
        $year = $matches[2].Trim()
    }

    if ($name -and $hero) {
        $projectMap[$slug] = @{
            slug=$slug; name=$name; location=$loc; hero=$hero; year=$year;
            type=$type; description=$desc; file=$f.FullName
        }
    }
}

Write-Host ("Found {0} project pages." -f $projectMap.Count)

# Decode common HTML entities in titles for OG content (browsers tolerate raw,
# but it's cleaner to send "Don't" instead of "Don&rsquo;t" in OG meta).
function Decode-Light([string]$s) {
    return $s.Replace('&amp;', '&').Replace('&ndash;', [char]0x2013).Replace('&mdash;', [char]0x2014).Replace('&rsquo;', "'").Replace('&lsquo;', "'").Replace('&middot;', [char]0x00B7)
}

# ──────────── Phase B: project pages — OG tags + gallery alts ────────────

Write-Host ""
Write-Host "── Phase B: OG tags + gallery alts (project pages) ─────────────"

$bOg = 0; $bAlts = 0; $bSkippedOg = 0

foreach ($slug in $projectMap.Keys) {
    $info = $projectMap[$slug]
    $c    = Read-File $info.file

    # OG block
    $ogTitle = "$($info.name), $($info.location) — Coffey Residential, residential architects in London"
    $ogDesc  = $info.description
    if (-not $ogDesc) { $ogDesc = "$($info.name) — a residential architecture project in $($info.location) by Coffey Residential, London." }
    $ogImg   = "$baseUrl/$($info.hero)"
    $ogUrl   = "$baseUrl/$slug.html"

    $ogBlock = "<meta property=`"og:title`" content=`"$(HtmlAttrEncode $ogTitle)`" />`r`n" +
               "<meta property=`"og:description`" content=`"$(HtmlAttrEncode $ogDesc)`" />`r`n" +
               "<meta property=`"og:type`" content=`"article`" />`r`n" +
               "<meta property=`"og:url`" content=`"$ogUrl`" />`r`n" +
               "<meta property=`"og:image`" content=`"$ogImg`" />`r`n" +
               "<meta property=`"og:site_name`" content=`"Coffey Residential`" />`r`n" +
               "<meta property=`"og:locale`" content=`"en_GB`" />`r`n" +
               "<meta name=`"twitter:card`" content=`"summary_large_image`" />`r`n" +
               "<meta name=`"twitter:image`" content=`"$ogImg`" />"

    if ($c -match 'property="og:image"') {
        $bSkippedOg++
    } else {
        $c = [regex]::Replace($c, '(<link rel="icon"[^>]+>)', { param($m) $m.Groups[1].Value + "`r`n" + $ogBlock })
        $bOg++
    }

    # Rewrite gallery alts (g-image and g-wide). Format: "Name, Location — Caption"
    $localInfo = $info  # capture for closure
    $localSlug = $slug
    $altRewrite = [System.Text.RegularExpressions.MatchEvaluator]{
        param($m)
        $imgPath = $m.Groups[2].Value
        $cap = Caption-From-Filename $imgPath $localSlug
        $newAlt = HtmlAttrEncode ("{0}, {1} &mdash; {2}" -f $localInfo.name, $localInfo.location, $cap)
        # The regex preserves everything except the alt value
        return $m.Groups[1].Value + $imgPath + $m.Groups[3].Value + $newAlt + $m.Groups[4].Value
    }
    $patternGallery = '(<figure class="g-(?:image|wide)"[^>]*>\s*<img[^>]+src=")([^"]+)("[^>]*?\salt=")[^"]*(")'
    $before = $c
    $c = [regex]::Replace($c, $patternGallery, $altRewrite)
    if ($c -ne $before) { $bAlts++ }

    Write-File $info.file $c
}

Write-Host ("OG injections:    {0}" -f $bOg)
Write-Host ("OG already set:   {0}" -f $bSkippedOg)
Write-Host ("Gallery alt swap: {0} pages" -f $bAlts)

# ──────────── Phase C: main pages — OG + project-tile alts ──────────────

Write-Host ""
Write-Host "── Phase C: main pages (OG + project-tile alts) ────────────────"

$mainPages = @{
    'index.html'   = @{
        title = 'Coffey Residential — Residential Architects, London'
        desc  = 'A London residential architecture studio. Founded by Phil Coffey in 2005; new houses and whole-house refurbishments, with Phil on every project.'
        img   = $defaultOgImg
        url   = "$baseUrl/"
        type  = 'website'
    }
    'homes.html'   = @{
        title = 'Homes — Coffey Residential, Residential Architects in London'
        desc  = 'Twenty homes by Coffey Residential — new builds, whole-house refurbishments and considered additions across London.'
        img   = 'images/meadow-grove-living.jpg'
        url   = "$baseUrl/homes.html"
        type  = 'website'
    }
    'studio.html'  = @{
        title = 'Studio — Coffey Residential, Residential Architects in London'
        desc  = 'A residential architecture studio in Clerkenwell, London. Phil Coffey founded the practice in 2005; a handful of new houses and whole-house refurbishments each year.'
        img   = 'images/phil-coffey-residential.jpg'
        url   = "$baseUrl/studio.html"
        type  = 'website'
    }
    'process.html' = @{
        title = 'Process — How We Work | Coffey Residential, London Architects'
        desc  = 'How a Coffey Residential project actually runs — from the first conversation through planning, detail and site, with Phil on every project.'
        img   = $defaultOgImg
        url   = "$baseUrl/process.html"
        type  = 'website'
    }
    'press.html'   = @{
        title = 'Press &amp; Awards — Coffey Residential, Residential Architects London'
        desc  = 'Press coverage and awards for Coffey Residential — Homes Architect of the Year (British Homes Awards 2025), RIBA awards, Young Architect of the Year 2012.'
        img   = $defaultOgImg
        url   = "$baseUrl/press.html"
        type  = 'website'
    }
    'journal.html' = @{
        title = 'Journal — Coffey Residential, Residential Architects in London'
        desc  = 'Notes from the studio. Essays, process pieces and field notes from a London residential architecture practice.'
        img   = $defaultOgImg
        url   = "$baseUrl/journal.html"
        type  = 'website'
    }
    'contact.html' = @{
        title = 'Contact — Coffey Residential, Residential Architects, London EC1V'
        desc  = 'Tell us about your house. Coffey Residential is at 104–110 Goswell Road, Clerkenwell, London EC1V 7DH.'
        img   = $defaultOgImg
        url   = "$baseUrl/contact.html"
        type  = 'website'
    }
    'thanks.html'  = @{
        title = 'Thank you — Coffey Residential'
        desc  = 'Thanks for getting in touch. We will be in contact shortly.'
        img   = $defaultOgImg
        url   = "$baseUrl/thanks.html"
        type  = 'website'
    }
    'journal-on-the-architecture-of-light.html' = @{
        title = 'On the architecture of light — Coffey Residential Journal'
        desc  = 'An essay on how light shapes a house. Coffey Residential, residential architects, London.'
        img   = $defaultOgImg
        url   = "$baseUrl/journal-on-the-architecture-of-light.html"
        type  = 'article'
    }
}

$cOg = 0; $cAlts = 0; $cSkippedOg = 0

$allSlugs = $projectMap.Keys

foreach ($name in $mainPages.Keys) {
    $p = Join-Path $root $name
    if (-not (Test-Path $p)) { continue }
    $c = Read-File $p
    $meta = $mainPages[$name]

    if ($c -match 'property="og:image"') {
        $cSkippedOg++
    } else {
        $ogImgFull = if ($meta.img -match '^https?://') { $meta.img } else { "$baseUrl/$($meta.img)" }
        $ogBlock = "<meta property=`"og:title`" content=`"$(HtmlAttrEncode $meta.title)`" />`r`n" +
                   "<meta property=`"og:description`" content=`"$(HtmlAttrEncode $meta.desc)`" />`r`n" +
                   "<meta property=`"og:type`" content=`"$($meta.type)`" />`r`n" +
                   "<meta property=`"og:url`" content=`"$($meta.url)`" />`r`n" +
                   "<meta property=`"og:image`" content=`"$ogImgFull`" />`r`n" +
                   "<meta property=`"og:site_name`" content=`"Coffey Residential`" />`r`n" +
                   "<meta property=`"og:locale`" content=`"en_GB`" />`r`n" +
                   "<meta name=`"twitter:card`" content=`"summary_large_image`" />`r`n" +
                   "<meta name=`"twitter:image`" content=`"$ogImgFull`" />"
        $c = [regex]::Replace($c, '(<link rel="icon"[^>]+>)', { param($m) $m.Groups[1].Value + "`r`n" + $ogBlock })
        $cOg++
    }

    # Project tile alts (index.html, homes.html). Match the img inside
    # <a class="project-row..." href="/SLUG.html"> ... <img src=... alt=...>
    $tilePattern = '(<a class="project-row[^"]*" href="/([a-z0-9-]+)\.html"[^>]*>\s*<div class="pr-image">\s*(?:<div[^>]*>\s*)?<img[^>]+src=")([^"]+)("[^>]*?\salt=")[^"]*(")'
    $before = $c
    $c = [regex]::Replace($c, $tilePattern, {
        param($m)
        $tileSlug = $m.Groups[2].Value
        $imgPath  = $m.Groups[3].Value
        if ($projectMap.ContainsKey($tileSlug)) {
            $proj = $projectMap[$tileSlug]
            $cap = Caption-From-Filename $imgPath $tileSlug
            $newAlt = HtmlAttrEncode ("{0}, {1} &mdash; {2}" -f $proj.name, $proj.location, $cap)
            return $m.Groups[1].Value + $imgPath + $m.Groups[4].Value + $newAlt + $m.Groups[5].Value
        } else {
            return $m.Value
        }
    })
    if ($c -ne $before) { $cAlts++ }

    Write-File $p $c
}

Write-Host ("OG injections:    {0}" -f $cOg)
Write-Host ("OG already set:   {0}" -f $cSkippedOg)
Write-Host ("Tile alt swap:    {0} pages" -f $cAlts)

# ──────────── Phase D: journal articles — OG tags ────────────

Write-Host ""
Write-Host "── Phase D: journal article OG tags ────────────────────────────"

$journalDir = Join-Path $root 'journal'
$jOg = 0; $jSkipped = 0

if (Test-Path $journalDir) {
    Get-ChildItem -Path $journalDir -Filter '*.html' -File | ForEach-Object {
        $c = Read-File $_.FullName
        if ($c -match 'property="og:image"') { $jSkipped++; return }

        # Pull existing title and description from the page
        $pageTitle = 'Coffey Residential Journal'
        $pageDesc  = 'Notes from the studio. Coffey Residential, residential architects in London.'
        if ($c -match '<title>([^<]+)</title>') { $pageTitle = $matches[1].Trim() }
        if ($c -match '<meta name="description" content="([^"]+)"') {
            $d = $matches[1].Trim()
            if ($d.Length -gt 0) { $pageDesc = $d }
        }

        $slug = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        $url  = "$baseUrl/journal/$slug.html"
        $img  = "$baseUrl/$defaultOgImg"

        $ogBlock = "<meta property=`"og:title`" content=`"$(HtmlAttrEncode $pageTitle)`" />`r`n" +
                   "<meta property=`"og:description`" content=`"$(HtmlAttrEncode $pageDesc)`" />`r`n" +
                   "<meta property=`"og:type`" content=`"article`" />`r`n" +
                   "<meta property=`"og:url`" content=`"$url`" />`r`n" +
                   "<meta property=`"og:image`" content=`"$img`" />`r`n" +
                   "<meta property=`"og:site_name`" content=`"Coffey Residential`" />`r`n" +
                   "<meta property=`"og:locale`" content=`"en_GB`" />`r`n" +
                   "<meta name=`"twitter:card`" content=`"summary_large_image`" />`r`n" +
                   "<meta name=`"twitter:image`" content=`"$img`" />"

        $c = [regex]::Replace($c, '(<link rel="icon"[^>]+>)', { param($m) $m.Groups[1].Value + "`r`n" + $ogBlock })
        Write-File $_.FullName $c
        $jOg++
    }
}

Write-Host ("OG injections:    {0}" -f $jOg)
Write-Host ("OG already set:   {0}" -f $jSkipped)

Write-Host ""
Write-Host "── Done. ───────────────────────────────────────────────────────"
