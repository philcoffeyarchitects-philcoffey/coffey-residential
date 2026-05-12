param(
    [int]$Concurrency = 8
)

$ErrorActionPreference = "Continue"
$base = "C:/Users/philc/Documents/Claude/Claude Code/coffey-residential"
$imgDir = "$base/images/journal"
$imgUrlMapPath = "$base/journal/_image_urls.json"
$failLog = "$base/journal/_failures.log"

New-Item -ItemType Directory -Force -Path $imgDir | Out-Null

if (-not (Test-Path $imgUrlMapPath)) {
    Write-Host "No image URL map at $imgUrlMapPath -- did parse.ps1 run?"
    exit 1
}

$mapJson = Get-Content $imgUrlMapPath -Raw
$map = $mapJson | ConvertFrom-Json

# Build flat list of (url, localName)
$entries = New-Object System.Collections.ArrayList
foreach ($prop in $map.PSObject.Properties) {
    $url = $prop.Name
    $name = $prop.Value
    $local = Join-Path $imgDir $name
    if (Test-Path $local) {
        $sz = (Get-Item $local).Length
        if ($sz -gt 1024) { continue }  # already downloaded; skip if non-trivial size
    }
    $entries.Add(@{ url = $url; local = $local; name = $name }) | Out-Null
}

Write-Host "Images to download: $($entries.Count) (total in map: $($map.PSObject.Properties.Count))"
if ($entries.Count -eq 0) { exit 0 }

$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

$pool = [runspacefactory]::CreateRunspacePool(1, $Concurrency)
$pool.Open()

$scriptBlock = {
    param($url, $local, $ua)
    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.UserAgent = $ua
        $req.Timeout = 60000
        $req.ReadWriteTimeout = 60000
        $req.AllowAutoRedirect = $true
        $resp = $req.GetResponse()
        $stream = $resp.GetResponseStream()
        $fs = New-Object System.IO.FileStream($local, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
        $buf = New-Object byte[] 65536
        while (($read = $stream.Read($buf, 0, $buf.Length)) -gt 0) {
            $fs.Write($buf, 0, $read)
        }
        $fs.Close()
        $stream.Close()
        $resp.Close()
        return @{ ok = $true; url = $url; size = (Get-Item $local).Length }
    } catch {
        return @{ ok = $false; url = $url; error = $_.Exception.Message }
    }
}

$jobs = New-Object System.Collections.ArrayList
foreach ($e in $entries) {
    $ps = [powershell]::Create()
    $ps.RunspacePool = $pool
    [void]$ps.AddScript($scriptBlock).AddArgument($e.url).AddArgument($e.local).AddArgument($ua)
    $jobs.Add(@{ ps = $ps; handle = $ps.BeginInvoke(); url = $e.url }) | Out-Null
}

Write-Host "Queued $($jobs.Count) image downloads..."

$ok = 0
$fail = 0
while ($jobs.Count -gt 0) {
    $done = @()
    for ($k = 0; $k -lt $jobs.Count; $k++) {
        if ($jobs[$k].handle.IsCompleted) { $done += $k }
    }
    if ($done.Count -eq 0) {
        Start-Sleep -Milliseconds 200
        continue
    }
    [array]::Reverse($done)
    foreach ($idx in $done) {
        $j = $jobs[$idx]
        try {
            $r = ($j.ps.EndInvoke($j.handle) | Select-Object -First 1)
            if ($r.ok) { $ok++ } else {
                $fail++
                Add-Content -Path $failLog -Value "IMG_FAIL`t$($r.url)`t$($r.error)"
            }
        } catch {
            $fail++
            Add-Content -Path $failLog -Value "IMG_EX`t$($j.url)`t$($_.Exception.Message)"
        } finally {
            $j.ps.Dispose()
            $jobs.RemoveAt($idx)
        }
    }
    if (($ok + $fail) % 50 -eq 0) {
        Write-Host "  img progress ok=$ok fail=$fail remaining=$($jobs.Count)"
    }
}

$pool.Close()
$pool.Dispose()

Write-Host "DONE images: ok=$ok fail=$fail"
