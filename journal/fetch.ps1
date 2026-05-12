param(
    [int]$Concurrency = 8,
    [int]$BatchPauseMs = 500
)

$ErrorActionPreference = "Continue"
$base = "C:/Users/philc/Documents/Claude/Claude Code/coffey-residential"
$rawDir = "$base/journal/_raw"
$failLog = "$base/journal/_failures.log"

New-Item -ItemType Directory -Force -Path $rawDir | Out-Null

$sitemap = Get-Content "$base/sitemap.xml" -Raw
$allUrls = [regex]::Matches($sitemap, '<loc>(https://www\.coffeyresidential\.com/blog/[^<]+)</loc>') |
    ForEach-Object { $_.Groups[1].Value } |
    Where-Object { $_ -notmatch '/blog/?$' } |
    Sort-Object -Unique

Write-Host "Total blog URLs: $($allUrls.Count)"

# Filter to ones we haven't fetched
$urls = @()
foreach ($u in $allUrls) {
    $slug = ($u -split '/blog/')[1]
    $rawPath = Join-Path $rawDir "$slug.html"
    if (-not (Test-Path $rawPath)) { $urls += $u }
}
Write-Host "To fetch: $($urls.Count)"
if ($urls.Count -eq 0) { Write-Host "Nothing to do"; exit 0 }

$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

$pool = [runspacefactory]::CreateRunspacePool(1, $Concurrency)
$pool.Open()

$jobs = New-Object System.Collections.ArrayList

$scriptBlock = {
    param($url, $rawPath, $ua)
    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.UserAgent = $ua
        $req.Timeout = 40000
        $req.ReadWriteTimeout = 40000
        $req.AllowAutoRedirect = $true
        $req.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        $resp = $req.GetResponse()
        $sr = New-Object System.IO.StreamReader($resp.GetResponseStream(), [System.Text.Encoding]::UTF8)
        $content = $sr.ReadToEnd()
        $sr.Close()
        $resp.Close()
        [System.IO.File]::WriteAllText($rawPath, $content, [System.Text.UTF8Encoding]::new($false))
        return @{ ok = $true; url = $url; size = $content.Length }
    } catch {
        return @{ ok = $false; url = $url; error = $_.Exception.Message }
    }
}

$i = 0
foreach ($u in $urls) {
    $slug = ($u -split '/blog/')[1]
    $rawPath = Join-Path $rawDir "$slug.html"
    $ps = [powershell]::Create()
    $ps.RunspacePool = $pool
    [void]$ps.AddScript($scriptBlock).AddArgument($u).AddArgument($rawPath).AddArgument($ua)
    $jobs.Add(@{ ps = $ps; handle = $ps.BeginInvoke(); url = $u }) | Out-Null
    $i++
    if ($i % 50 -eq 0) { Write-Host "  queued $i" }
}

Write-Host "All $i queued, waiting..."

$completedCount = 0
$failCount = 0
while ($jobs.Count -gt 0) {
    $done = @()
    for ($k = 0; $k -lt $jobs.Count; $k++) {
        if ($jobs[$k].handle.IsCompleted) { $done += $k }
    }
    if ($done.Count -eq 0) {
        Start-Sleep -Milliseconds 200
        continue
    }
    # iterate in reverse so removals don't shift indices
    [array]::Reverse($done)
    foreach ($idx in $done) {
        $j = $jobs[$idx]
        try {
            $result = $j.ps.EndInvoke($j.handle)
            $r = $result | Select-Object -First 1
            if ($r.ok) {
                $completedCount++
            } else {
                $failCount++
                Add-Content -Path $failLog -Value "FETCH_FAIL`t$($r.url)`t$($r.error)"
            }
        } catch {
            $failCount++
            Add-Content -Path $failLog -Value "FETCH_EX`t$($j.url)`t$($_.Exception.Message)"
        } finally {
            $j.ps.Dispose()
            $jobs.RemoveAt($idx)
        }
    }
    if (($completedCount + $failCount) % 25 -eq 0) {
        Write-Host "  progress: ok=$completedCount fail=$failCount remaining=$($jobs.Count)"
    }
}

$pool.Close()
$pool.Dispose()

Write-Host "DONE. fetched=$completedCount failed=$failCount"
Write-Host "raw files on disk: $((Get-ChildItem $rawDir -Filter '*.html').Count)"
