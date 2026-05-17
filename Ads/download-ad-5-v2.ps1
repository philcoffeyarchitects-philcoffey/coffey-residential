# Ad 5 v2 — replacement shots 3 and 4, downloaded only.
# Phil will restitch using the existing shot-1 (plaster), shot-2 (banister),
# title card, and these two new files. No ffmpeg step in this script.

$ErrorActionPreference = 'Continue'
$ProgressPreference    = 'SilentlyContinue'

$dest = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }

$logPath = Join-Path $dest 'download-ad-5-v2.log'
"Run at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Out-File -FilePath $logPath -Encoding utf8

$downloads = @(
    @{
        name = 'ad-5-the-morning_shot-3-under-stairs.mp4'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_095201_4c194c94-a4a6-4f4a-a317-177ecae101ec.mp4'
    },
    @{
        name = 'ad-5-the-morning_shot-4-full-height.mp4'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_095207_b8dae9f4-f470-48e9-b6b4-450d47ed79a0.mp4'
    }
)

$ok = 0; $fail = 0
foreach ($d in $downloads) {
    $path = Join-Path $dest $d.name
    try {
        Invoke-WebRequest -Method Get -Uri $d.url -OutFile $path -UseBasicParsing -UserAgent 'Mozilla/5.0' -ErrorAction Stop | Out-Null
        $sz = (Get-Item $path).Length
        $msg = ("  OK    {0}  ({1:N0} bytes)" -f $d.name, $sz)
        Write-Host $msg -ForegroundColor Green
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $ok++
    } catch {
        $msg = ("  FAIL  {0}  -> {1}" -f $d.name, $_.Exception.Message)
        Write-Host $msg -ForegroundColor Red
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $fail++
    }
}

$summary = "Done. $ok downloaded, $fail failed. Files in $dest"
Write-Host ""
Write-Host $summary -ForegroundColor Cyan
$summary | Out-File -FilePath $logPath -Append -Encoding utf8

Write-Host ""
Write-Host "Press Enter to close..." -ForegroundColor Yellow
Read-Host | Out-Null
