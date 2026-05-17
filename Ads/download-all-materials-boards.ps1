# Materials boards — bulk download for all 20 Coffey Residential projects.
# Pulls each board PNG from Higgsfield, converts to JPG quality 92, and lands at
#   coffey-residential\Materials boards\{slug}\materials-board_clean.jpg
# The agent will then overlay numbered circles on top to produce the labelled
# materials-board.jpg alongside, and write materials.json per folder.

$ErrorActionPreference = 'Continue'
$ProgressPreference    = 'SilentlyContinue'

$baseFolder = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Materials boards'
if (-not (Test-Path $baseFolder)) { New-Item -ItemType Directory -Force -Path $baseFolder | Out-Null }

$logPath = Join-Path $baseFolder 'download-all-materials-boards.log'
"Run at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Out-File -FilePath $logPath -Encoding utf8

# Load System.Drawing once.
try { Add-Type -AssemblyName System.Drawing -ErrorAction Stop } catch { Write-Host 'WARN: System.Drawing not available - JPG conversion will be skipped.' -ForegroundColor Yellow }
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }

$boards = @(
    @{ slug='ad-house-york';                url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_080349_ba91a594-af0c-4580-9a2e-019d9457299a.png' },
    @{ slug='apartment-block-clerkenwell';  url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_080439_335e1e9b-1a37-4254-b610-93c8a38749b1.png' },
    @{ slug='arch-study-notting-hill';      url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_073502_aa49edf8-def1-4a31-a065-bb070ac4ed2b.png' },
    @{ slug='canyon-house-clerkenwell';     url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_080521_332e1aba-6626-4784-9314-97f8672ba568.png' },
    @{ slug='capablanca-house-barnsbury';   url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_080603_cd480546-dc86-4505-8731-d2baa068487e.png' },
    @{ slug='cove-ridge-devon';             url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_080645_6022897d-3f88-4a2d-8a2e-62187d02b831.png' },
    @{ slug='folded-house-islington';       url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_080950_42d6df1c-40fc-4ea7-8044-e4b6a234d4da.png' },
    @{ slug='garden-lodge-harpenden';       url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081027_842d4cda-72de-4479-937a-260a7f7af457.png' },
    @{ slug='helios-house-white-city';      url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081100_b420fa29-a189-43aa-84c9-3aa76817309c.png' },
    @{ slug='hidden-house-clerkenwell';     url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081145_8365cd91-4e31-424e-9f8a-6ce3f2509002.png' },
    @{ slug='island-home-shoreditch';       url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081232_932eee23-5741-4353-9e90-56bd48d1929f.png' },
    @{ slug='kitchen-garden-maida-vale';    url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081534_b65dd3f1-fa3b-4c35-ab72-faf2d92b2995.png' },
    @{ slug='meadow-grove-barnes';          url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081542_01e1740a-d421-4ca5-9401-00fb2ee2d0b7.png' },
    @{ slug='modern-barn-devon';            url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081616_b12e38f0-c3ff-46ef-83a7-c6e5421cf226.png' },
    @{ slug='modern-detached-harpenden';    url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081658_378a6f02-c12b-4112-a2fb-b65d4da0cc96.png' },
    @{ slug='modern-mews-paddington';       url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_081730_52780142-2561-468e-8c29-f55037d7b4e1.png' },
    @{ slug='modern-side-extension';        url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_082017_16223c5a-2c60-44a6-a7f3-3c06945d42df.png' },
    @{ slug='modern-terrace-islington';     url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_082053_20bb0d6e-98fb-48d0-bd13-667b7e42102e.png' },
    @{ slug='sky-house-camden';             url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_082149_fff5c823-4150-4f2e-9571-0ae956616352.png' },
    @{ slug='well-house-islington';         url='https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260517_082236_f01d60a8-b0dc-4384-b5c5-c29c4e91b92d.png' }
)

$ok = 0; $fail = 0
foreach ($b in $boards) {
    $slugDir = Join-Path $baseFolder $b.slug
    if (-not (Test-Path $slugDir)) { New-Item -ItemType Directory -Force -Path $slugDir | Out-Null }
    $tmpPng = Join-Path $slugDir 'materials-board.tmp.png'
    $clean  = Join-Path $slugDir 'materials-board_clean.jpg'

    try {
        Invoke-WebRequest -Method Get -Uri $b.url -OutFile $tmpPng -UseBasicParsing -UserAgent 'Mozilla/5.0' -ErrorAction Stop | Out-Null
    } catch {
        $msg = "  FAIL  $($b.slug): download failed -> $($_.Exception.Message)"
        Write-Host $msg -ForegroundColor Red
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $fail++; continue
    }

    if ($jpegCodec) {
        try {
            $bitmap = [System.Drawing.Bitmap]::FromFile($tmpPng)
            $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
            $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]92)
            $bitmap.Save($clean, $jpegCodec, $params)
            $bitmap.Dispose()
            Remove-Item -Path $tmpPng -Force
            $sz = (Get-Item $clean).Length
            $msg = ("  OK    {0,-32}  ({1:N0} bytes)" -f $b.slug, $sz)
            Write-Host $msg -ForegroundColor Green
            $msg | Out-File -FilePath $logPath -Append -Encoding utf8
            $ok++
        } catch {
            $msg = "  WARN  $($b.slug): conversion failed -> $($_.Exception.Message). PNG kept at $tmpPng"
            Write-Host $msg -ForegroundColor Yellow
            $msg | Out-File -FilePath $logPath -Append -Encoding utf8
            $fail++
        }
    } else {
        # No System.Drawing: keep PNG but rename it to .png so the agent can still process it.
        $fallback = Join-Path $slugDir 'materials-board_clean.png'
        Move-Item -Path $tmpPng -Destination $fallback -Force
        $msg = "  PNG-ONLY  $($b.slug) (no System.Drawing - saved PNG)"
        Write-Host $msg -ForegroundColor Yellow
        $msg | Out-File -FilePath $logPath -Append -Encoding utf8
        $ok++
    }
}

$summary = "Done. $ok ok, $fail failed. 20 projects expected. Files in $baseFolder\{slug}\materials-board_clean.jpg"
Write-Host ""
Write-Host $summary -ForegroundColor Cyan
$summary | Out-File -FilePath $logPath -Append -Encoding utf8

Write-Host ""
Write-Host "Press Enter to close..." -ForegroundColor Yellow
Read-Host | Out-Null
