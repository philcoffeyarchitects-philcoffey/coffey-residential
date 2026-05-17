# Higgsfield source-image upload helper (v2) — for the Ad 5 re-shoot.
# Two new reference images: under-stairs and full-height.
# URLs expire 24h after issue (issued 2026-05-16 09:19 UTC).

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$imagesDir = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\images'

$uploads = @(
    @{ file='meadow-grove-under-stairs.jpg'; media_id='ab05f653-3699-482f-b041-14cf1a356ee2'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/ab05f653-3699-482f-b041-14cf1a356ee2.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T091921Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=333bc634b28de946d9edfcea5e7dbcfe6e01d76d23bd0145f416f9306beb485e' },
    @{ file='meadow-grove-full-height.jpg';  media_id='31f12048-f0d6-4ba7-8365-89d5d8af0c71'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/31f12048-f0d6-4ba7-8365-89d5d8af0c71.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T091921Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=364b1ca409a01e3373349318eb8c4bae036848047e2089e7e47624f1f3db3ade' }
)

$ok = 0; $fail = 0
foreach ($u in $uploads) {
    $path = Join-Path $imagesDir $u.file
    if (-not (Test-Path $path)) { Write-Host "  MISSING  $($u.file)" -ForegroundColor Red; $fail++; continue }
    try {
        Invoke-WebRequest -Method Put -Uri $u.url -InFile $path -ContentType 'image/jpeg' -UseBasicParsing | Out-Null
        Write-Host "  OK       $($u.file)  -> $($u.media_id)" -ForegroundColor Green
        $ok++
    } catch {
        Write-Host "  FAIL     $($u.file)  -> $($_.Exception.Message)" -ForegroundColor Red
        $fail++
    }
}

Write-Host ""
Write-Host "Done. $ok ok, $fail failed." -ForegroundColor Cyan
Write-Host "Reply 'v2 uploads done' so the agent can confirm them on Higgsfield."
