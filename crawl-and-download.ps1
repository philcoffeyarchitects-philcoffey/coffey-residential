$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Continue'

$root      = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'
$pagesDir  = Join-Path $root 'pages-html'
$imagesDir = Join-Path $root 'images'
if (-not (Test-Path $pagesDir))  { New-Item -ItemType Directory -Force -Path $pagesDir  | Out-Null }
if (-not (Test-Path $imagesDir)) { New-Item -ItemType Directory -Force -Path $imagesDir | Out-Null }

# All non-blog pages from sitemap
$pages = @(
    'https://www.coffeyresidential.com/home',
    'https://www.coffeyresidential.com/who-we-are',
    'https://www.coffeyresidential.com/our-services-coffey-residential',
    'https://www.coffeyresidential.com/awards-coffey-residential',
    'https://www.coffeyresidential.com/press-coffey-residential',
    'https://www.coffeyresidential.com/testimonials-coffey-residential',
    'https://www.coffeyresidential.com/contact-us-coffey-residential',
    'https://www.coffeyresidential.com/book-a-free-consultation-coffey-residential',
    'https://www.coffeyresidential.com/privacy-policy',
    'https://www.coffeyresidential.com/portfolio-coffey-residential',
    'https://www.coffeyresidential.com/portfolio-coffey-residential-1',
    'https://www.coffeyresidential.com/blog',
    # Project pages
    'https://www.coffeyresidential.com/ad-house-york',
    'https://www.coffeyresidential.com/apartment-block-clerkenwell',
    'https://www.coffeyresidential.com/arch-study-notting-hill',
    'https://www.coffeyresidential.com/canyon-house-clerkenwell',
    'https://www.coffeyresidential.com/capablanca-house-barnsbury',
    'https://www.coffeyresidential.com/cove-ridge-devon',
    'https://www.coffeyresidential.com/folded-house-islington',
    'https://www.coffeyresidential.com/garden-lodge-harpenden',
    'https://www.coffeyresidential.com/helios-house-white-city',
    'https://www.coffeyresidential.com/hidden-house-clerkenwell',
    'https://www.coffeyresidential.com/island-home-shoreditch',
    'https://www.coffeyresidential.com/kitchen-garden-maida-vale',
    'https://www.coffeyresidential.com/meadow-grove-barnes',
    'https://www.coffeyresidential.com/modern-barn-devon',
    'https://www.coffeyresidential.com/modern-detached-harpenden',
    'https://www.coffeyresidential.com/modern-mews-paddington',
    'https://www.coffeyresidential.com/modern-side-extension',
    'https://www.coffeyresidential.com/modern-terrace-islington',
    'https://www.coffeyresidential.com/sky-house-camden',
    'https://www.coffeyresidential.com/step-house-canada-water',
    'https://www.coffeyresidential.com/well-house-islington'
)

Write-Output ("Pages to crawl: " + $pages.Count)

# Step 1: download every page's HTML
$pagesFetched = 0
foreach ($u in $pages) {
    $slug = ($u -split '/')[-1]
    $out  = Join-Path $pagesDir ($slug + '.html')
    try {
        Invoke-WebRequest -Uri $u -UserAgent 'Mozilla/5.0' -OutFile $out -ErrorAction Stop
        $pagesFetched++
    } catch {
        Write-Output ("PAGE FAIL: " + $u + " :: " + $_.Exception.Message)
    }
}
Write-Output ("Pages fetched: " + $pagesFetched)

# Step 2: harvest all squarespace CDN image URLs from every page
$pattern = 'https://images\.squarespace-cdn\.com/content/v1/[a-z0-9]+/[a-z0-9-]+/[^"''\\\s\?]+\.(?:jpg|jpeg|png|webp|gif|svg)'
$urlSet = New-Object System.Collections.Generic.HashSet[string]
Get-ChildItem $pagesDir -Filter *.html | ForEach-Object {
    $text = Get-Content $_.FullName -Raw
    foreach ($m in [regex]::Matches($text, $pattern, 'IgnoreCase')) {
        [void]$urlSet.Add($m.Value)
    }
}
$urls = $urlSet | Sort-Object
Write-Output ("Unique image URLs: " + $urls.Count)

# Step 3: download each unique image
$ok = 0; $fail = 0; $skip = 0
$nameClashes = @{}
foreach ($u in $urls) {
    $name = ($u -split '/')[-1]
    # Squarespace gives the same filename across many CDN paths sometimes; namespace the file by its asset GUID to avoid clashes
    $segs  = $u -split '/'
    $guid  = $segs[$segs.Length - 2]
    $short = $guid.Substring(0, [Math]::Min(8, $guid.Length))

    if ($nameClashes.ContainsKey($name)) {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($name)
        $ext  = [System.IO.Path]::GetExtension($name)
        $name = $base + '-' + $short + $ext
    } else {
        $nameClashes[$name] = $true
    }

    $out = Join-Path $imagesDir $name
    if (Test-Path $out) { $skip++; continue }
    try {
        Invoke-WebRequest -Uri ($u + '?format=2500w') -UserAgent 'Mozilla/5.0' -OutFile $out -ErrorAction Stop
        $ok++
    } catch {
        try {
            Invoke-WebRequest -Uri $u -UserAgent 'Mozilla/5.0' -OutFile $out -ErrorAction Stop
            $ok++
        } catch {
            Write-Output ("IMG FAIL: " + $name + " :: " + $_.Exception.Message)
            $fail++
        }
    }
}
Write-Output ("Images downloaded: " + $ok + ", skipped (already had): " + $skip + ", failed: " + $fail)
Write-Output ("Total in folder: " + (Get-ChildItem $imagesDir).Count)
