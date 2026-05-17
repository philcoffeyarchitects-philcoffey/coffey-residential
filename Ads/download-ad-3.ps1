# Ad 3 — The Quiet Question carousel: download the four slides to the Ads folder.
# Run from anywhere; absolute paths are baked in.

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$dest = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }

$downloads = @(
    @{
        name = 'ad-3-the-quiet-question_slide-01.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_083624_9f88da32-385f-4c10-bd05-0a5b1b4d10c2.png'
    },
    @{
        name = 'ad-3-the-quiet-question_slide-02.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_083629_15d1333c-893c-49d8-a32c-816da4b18be5.png'
    },
    @{
        name = 'ad-3-the-quiet-question_slide-03.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_083633_24b314aa-28de-4ab6-8c50-373e3f65f0fd.png'
    },
    @{
        name = 'ad-3-the-quiet-question_slide-04.png'
        url  = 'https://d8j0ntlcm91z4.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/hf_20260516_083638_d7b8fcbf-47a9-4ce5-b484-c15116a432e6.png'
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
