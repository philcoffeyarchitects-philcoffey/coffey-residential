# Ad 5 — The Morning reel: download four Seedance clips + the Nano Banana title card,
# then stitch them into a single 9:16 mp4 via ffmpeg.
#
# Produces:
#   ad-5-the-morning_shot-1-plaster.mp4
#   ad-5-the-morning_shot-2-banister.mp4
#   ad-5-the-morning_shot-3-door.mp4
#   ad-5-the-morning_shot-4-dusk.mp4
#   ad-5-the-morning_title-card.png
#   ad-5-the-morning.mp4              <-- final stitched 15s reel (3s per shot + 3s title)
#
# Requires ffmpeg on PATH for the stitching step. If ffmpeg isn't installed,
# the script downloads everything and skips the stitch with a clear message —
# you can stitch in your editor of choice.

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$dest = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }

# -------- Step 1: downloads --------

$downloads = @(
    @{
        name = 'ad-5-the-morning_shot-1-plaster.mp4'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_085438_e5ae6901-8009-4b73-a232-5f65028f29ec.mp4'
    },
    @{
        name = 'ad-5-the-morning_shot-2-banister.mp4'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_085529_d8e2503e-7261-4e85-ab0f-29b8e0301262.mp4'
    },
    @{
        name = 'ad-5-the-morning_shot-3-door.mp4'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_085543_f1316c4f-7833-4af0-90e3-c1a9699ef06c.mp4'
    },
    @{
        name = 'ad-5-the-morning_shot-4-dusk.mp4'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_085549_5c766856-c7f3-4235-8cac-538aa67ac5e6.mp4'
    },
    @{
        name = 'ad-5-the-morning_title-card.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_085552_9c056a4e-194b-4a9c-8d14-4ccfe64af3d2.png'
    }
)

$ok = 0; $fail = 0
foreach ($d in $downloads) {
    $path = Join-Path $dest $d.name
    try {
        Invoke-WebRequest -Method Get -Uri $d.url -OutFile $path -UseBasicParsing -UserAgent 'Mozilla/5.0' | Out-Null
        $sz = (Get-Item $path).Length
        Write-Host ("  OK    {0}  ({1:N0} bytes)" -f $d.name, $sz) -ForegroundColor Green
        $ok++
    } catch {
        Write-Host ("  FAIL  {0}  -> {1}" -f $d.name, $_.Exception.Message) -ForegroundColor Red
        $fail++
    }
}

Write-Host ""
Write-Host "Downloaded $ok of $($downloads.Count). Files in $dest" -ForegroundColor Cyan
if ($fail -gt 0) {
    Write-Host "Some downloads failed; aborting stitch." -ForegroundColor Yellow
    return
}

# -------- Step 2: stitch via ffmpeg --------

$ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
if (-not $ffmpeg) {
    Write-Host ""
    Write-Host "ffmpeg not found on PATH. Skipping the stitch step." -ForegroundColor Yellow
    Write-Host "Install ffmpeg (winget install Gyan.FFmpeg) and re-run this script," -ForegroundColor Yellow
    Write-Host "or open the four clips and the title card in your editor and assemble manually." -ForegroundColor Yellow
    return
}

Write-Host ""
Write-Host "ffmpeg found at $($ffmpeg.Source). Stitching the reel..." -ForegroundColor Cyan

$clip1 = Join-Path $dest 'ad-5-the-morning_shot-1-plaster.mp4'
$clip2 = Join-Path $dest 'ad-5-the-morning_shot-2-banister.mp4'
$clip3 = Join-Path $dest 'ad-5-the-morning_shot-3-door.mp4'
$clip4 = Join-Path $dest 'ad-5-the-morning_shot-4-dusk.mp4'
$title = Join-Path $dest 'ad-5-the-morning_title-card.png'
$final = Join-Path $dest 'ad-5-the-morning.mp4'

# Target: 1080x1920, 30 fps, 3s per segment. Final duration = 5 x 3s = 15s.
# Each shot is trimmed to its first 3 seconds. The title card is rendered as a 3s still.
# All segments are re-encoded to a common profile so the concat is seamless.

$ffmpegArgs = @(
    '-y',
    # 4 video clips, each capped at 3s
    '-t','3','-i',$clip1,
    '-t','3','-i',$clip2,
    '-t','3','-i',$clip3,
    '-t','3','-i',$clip4,
    # title still, looped to 3s, 30fps
    '-loop','1','-t','3','-framerate','30','-i',$title,
    '-filter_complex',
    '[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=30,format=yuv420p[v0];' +
    '[1:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=30,format=yuv420p[v1];' +
    '[2:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=30,format=yuv420p[v2];' +
    '[3:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=30,format=yuv420p[v3];' +
    '[4:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=30,format=yuv420p[v4];' +
    '[v0][v1][v2][v3][v4]concat=n=5:v=1:a=0[out]',
    '-map','[out]',
    '-an',                              # no audio in the final reel
    '-c:v','libx264','-preset','medium','-crf','18',
    '-pix_fmt','yuv420p',
    '-movflags','+faststart',
    $final
)

& ffmpeg @ffmpegArgs 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ffmpeg failed (exit $LASTEXITCODE). The individual clips are still in $dest." -ForegroundColor Red
    return
}

$finalSz = (Get-Item $final).Length
Write-Host ""
Write-Host ("  OK    ad-5-the-morning.mp4  ({0:N0} bytes, 15s, 1080x1920)" -f $finalSz) -ForegroundColor Green
Write-Host "Done. Final reel saved to $final" -ForegroundColor Cyan
