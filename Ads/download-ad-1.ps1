# Ad 1 — The Award: download the three Higgsfield variants to the Ads folder.
# Run from anywhere; absolute paths are baked in.

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$dest = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }

$downloads = @(
    @{
        name = 'ad-1-the-award_with-text-v1.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_073453_9e965cdf-1011-46b3-9dca-ecfca038ffc1.png'
    },
    @{
        name = 'ad-1-the-award_with-text-v2.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_073453_f58294ca-cfe9-490b-95bc-b1c7bac4b8ee.png'
    },
    @{
        name = 'ad-1-the-award_clean.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_073456_0f882977-420a-4daa-bed7-4a6487be8c3d.png'
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
Write-Host "Done. $ok downloaded, $fail failed. Files in $dest" -ForegroundColor Cyan
