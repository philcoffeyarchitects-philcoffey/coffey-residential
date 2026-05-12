param(
    [int]$BatchSize = 10,
    [int]$BatchPauseMs = 1500,
    [string]$Mode = "full"  # full | skeleton
)

$ErrorActionPreference = "Continue"
$base = "C:/Users/philc/Documents/Claude/Claude Code/coffey-residential"
$rawDir = "$base/journal/_raw"
$postsDir = "$base/journal/posts"
$imgDir = "$base/images/journal"
$indexPath = "$base/journal/index.json"
$failLog = "$base/journal/_failures.log"

New-Item -ItemType Directory -Force -Path $rawDir, $postsDir, $imgDir | Out-Null

# Parse blog URLs from sitemap
$sitemap = Get-Content "$base/sitemap.xml" -Raw
$urls = [regex]::Matches($sitemap, '<loc>(https://www\.coffeyresidential\.com/blog/[^<]+)</loc>') |
    ForEach-Object { $_.Groups[1].Value } |
    Where-Object { $_ -notmatch '/blog$' } |
    Sort-Object -Unique

Write-Host "Found $($urls.Count) blog URLs"

if ($Mode -eq "skeleton") {
    # Fast mode: write minimal stubs for older posts
    $skipUrls = @{}
    Get-ChildItem -Path $postsDir -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        $skipUrls[$_.BaseName] = $true
    }
    $urls = $urls | Where-Object {
        $slug = ($_ -split '/blog/')[1]
        -not $skipUrls.ContainsKey($slug)
    }
    Write-Host "After dedupe, processing $($urls.Count) skeleton URLs"
}

# Headers to look like a browser
$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    "Accept-Language" = "en-GB,en;q=0.9"
}

$batches = [Math]::Ceiling($urls.Count / $BatchSize)
$globalFailures = @()
$globalSuccess = 0
$globalSkippedEmpty = 0

for ($b = 0; $b -lt $batches; $b++) {
    $start = $b * $BatchSize
    $end = [Math]::Min($start + $BatchSize - 1, $urls.Count - 1)
    $batch = $urls[$start..$end]

    Write-Host "Batch $($b+1)/$batches (urls $start..$end)"

    $jobs = @()
    foreach ($url in $batch) {
        $slug = ($url -split '/blog/')[1]
        $rawPath = "$rawDir/$slug.html"
        if (Test-Path $rawPath) {
            # already fetched
            continue
        }
        $jobs += Start-ThreadJob -ScriptBlock {
            param($url, $rawPath, $headers)
            try {
                $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 40 -Headers $headers -ErrorAction Stop
                Set-Content -Path $rawPath -Value $r.Content -Encoding utf8
                return @{ ok = $true; url = $url; status = $r.StatusCode; size = $r.RawContentLength }
            } catch {
                return @{ ok = $false; url = $url; error = $_.Exception.Message }
            }
        } -ArgumentList $url, $rawPath, $headers
    }

    if ($jobs.Count -gt 0) {
        $results = $jobs | Wait-Job | Receive-Job
        $jobs | Remove-Job -Force
        foreach ($r in $results) {
            if (-not $r.ok) {
                $globalFailures += $r.url
                Add-Content -Path $failLog -Value "FETCH_FAIL`t$($r.url)`t$($r.error)"
            }
        }
    }

    Start-Sleep -Milliseconds $BatchPauseMs
}

Write-Host "Fetch phase done. Fetched files: $((Get-ChildItem $rawDir -Filter '*.html').Count). Failures: $($globalFailures.Count)"
