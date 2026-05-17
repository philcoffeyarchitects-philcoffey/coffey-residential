# Materials board (Arch Study, Notting Hill) — download from Higgsfield, save as JPG.
# Higgsfield delivers PNG; this script converts to JPG to honour the requested filename.

$ErrorActionPreference = 'Continue'
$ProgressPreference    = 'SilentlyContinue'

$destFolder = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Materials boards'
if (-not (Test-Path $destFolder)) { New-Item -ItemType Directory -Force -Path $destFolder | Out-Null }

$logPath = Join-Path $destFolder 'download-materials-board.log'
"Run at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Out-File -FilePath $logPath -Encoding utf8

$url       = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_071940_88966ef3-8a31-4f97-87ca-3018b86b66db.png'
$tempPng   = Join-Path $destFolder 'materials-board_arch-study.tmp.png'
$finalJpg  = Join-Path $destFolder 'materials-board_arch-study.jpg'

try {
    Invoke-WebRequest -Method Get -Uri $url -OutFile $tempPng -UseBasicParsing -UserAgent 'Mozilla/5.0' -ErrorAction Stop | Out-Null
    $pngSz = (Get-Item $tempPng).Length
    $msg = "  OK    downloaded PNG ($pngSz bytes) -> $tempPng"
    Write-Host $msg -ForegroundColor Green
    $msg | Out-File -FilePath $logPath -Append -Encoding utf8
} catch {
    $msg = "  FAIL  download -> $($_.Exception.Message)"
    Write-Host $msg -ForegroundColor Red
    $msg | Out-File -FilePath $logPath -Append -Encoding utf8
    Write-Host ""
    Write-Host "Press Enter to close..." -ForegroundColor Yellow
    Read-Host | Out-Null
    return
}

try {
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    $bitmap = [System.Drawing.Bitmap]::FromFile($tempPng)
    # Encode with JPEG quality 92.
    $jpegCodec  = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $params     = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]92)
    $bitmap.Save($finalJpg, $jpegCodec, $params)
    $bitmap.Dispose()
    Remove-Item -Path $tempPng -Force
    $jpgSz = (Get-Item $finalJpg).Length
    $msg = "  OK    converted to JPG ($jpgSz bytes) -> $finalJpg"
    Write-Host $msg -ForegroundColor Green
    $msg | Out-File -FilePath $logPath -Append -Encoding utf8
} catch {
    # Fallback: keep the PNG, rename so Phil at least has the asset.
    $fallback = Join-Path $destFolder 'materials-board_arch-study.png'
    Move-Item -Path $tempPng -Destination $fallback -Force
    $msg = "  WARN  could not convert PNG->JPG ($($_.Exception.Message)). Saved as PNG instead: $fallback"
    Write-Host $msg -ForegroundColor Yellow
    $msg | Out-File -FilePath $logPath -Append -Encoding utf8
}

Write-Host ""
Write-Host "Done. Files in $destFolder" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Enter to close..." -ForegroundColor Yellow
Read-Host | Out-Null
