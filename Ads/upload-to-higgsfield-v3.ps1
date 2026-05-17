# Higgsfield source-image upload helper (v3) — fresh URLs for the Ad 5 re-shoot.
# Same two files as v2, but fresh presigned URLs (issued 2026-05-16 09:40 UTC).
#
# This script also writes its output to upload-to-higgsfield-v3.log so we have
# a record even if the window auto-closes after a right-click → Run.

$ErrorActionPreference = 'Continue'   # keep going past individual failures so the log is complete
$ProgressPreference    = 'SilentlyContinue'

$imagesDir = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\images'
$logPath   = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads\upload-to-higgsfield-v3.log'

# Truncate the log
"Run at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Out-File -FilePath $logPath -Encoding utf8

$uploads = @(
    @{ file='meadow-grove-under-stairs.jpg'; media_id='47ba28fb-2eb1-4c76-ac52-24a73e50e656'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/47ba28fb-2eb1-4c76-ac52-24a73e50e656.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T094008Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=cbf9382c1dac2c4929505399277a64bc473597ce40a8812c6964d99bd506ea3c' },
    @{ file='meadow-grove-full-height.jpg';  media_id='2eb040b5-2f7c-4ad9-a4fd-98e7349904e3'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/2eb040b5-2f7c-4ad9-a4fd-98e7349904e3.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T094008Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=0e9b1658c0256173f8154b3de969374b6945cdbd154ecc88697393a04de89c67' }
)

$ok = 0; $fail = 0
foreach ($u in $uploads) {
    $path = Join-Path $imagesDir $u.file
    if (-not (Test-Path $path)) {
        $msg = "  MISSING  $($u.file) at $path"
        Write-Host $msg -ForegroundColor Red
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $fail++; continue
    }
    $sz = (Get-Item $path).Length
    try {
        $resp = Invoke-WebRequest -Method Put -Uri $u.url -InFile $path -ContentType 'image/jpeg' -UseBasicParsing -ErrorAction Stop
        $msg = "  OK       $($u.file)  ($sz bytes)  HTTP $($resp.StatusCode)  -> $($u.media_id)"
        Write-Host $msg -ForegroundColor Green
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $ok++
    } catch {
        $msg = "  FAIL     $($u.file)  -> $($_.Exception.Message)"
        Write-Host $msg -ForegroundColor Red
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $fail++
    }
}

$summary = "Done. $ok ok, $fail failed. Log written to $logPath"
Write-Host ""
Write-Host $summary -ForegroundColor Cyan
$summary | Out-File -FilePath $logPath -Append -Encoding utf8

# Keep the window open so the result is readable when run via right-click → Run with PowerShell.
Write-Host ""
Write-Host "Press Enter to close..." -ForegroundColor Yellow
Read-Host | Out-Null
