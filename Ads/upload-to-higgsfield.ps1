# Higgsfield source-image upload helper — generated for the Coffey Residential ads brief.
# The sandbox the agent runs in can't reach Higgsfield's S3 upload bucket (proxy 403),
# so the eight presigned URLs below need to be PUT from your machine instead.
#
# Just run this script in PowerShell from anywhere — it reads from the images folder
# directly. URLs expire 24h after issue (issued 2026-05-16 07:18 UTC).

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$imagesDir = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\images'

$uploads = @(
    @{ file='cove-ridge-structure.jpg';              media_id='a2d54ea7-7165-4d38-88c6-7b12fb9af4c1'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/a2d54ea7-7165-4d38-88c6-7b12fb9af4c1.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=991233877ff118557c3193038793a51714aa9c28ffa38c012e45d87d1b3c5472' },
    @{ file='meadow-grove-living-from-hallaway.jpg'; media_id='8e09cb3c-dcbb-4761-b06b-3b3639dd8150'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/8e09cb3c-dcbb-4761-b06b-3b3639dd8150.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=055d6593bdf9928ad5ce62b2a873d08e8e4025dffe36690476c0c217b1dd20ae' },
    @{ file='meadow-grove-staris-light-from-top.jpg'; media_id='58d95900-d201-4728-960d-236e0826c20c'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/58d95900-d201-4728-960d-236e0826c20c.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=ca322fab40f7cc4f80ff43407e818d56d6422271cf8f0fb01b2a0916fdff4711' },
    @{ file='hidden-house-living-view.jpg';          media_id='7c9c3046-08af-4f42-a30b-cf4598975d09'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/7c9c3046-08af-4f42-a30b-cf4598975d09.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=0bc5c416c072cf86a7953353b06429c9887bdc4dbb649d72aa24c2bb3ee3a789' },
    @{ file='cove-ridge-sunlight-abstract.jpg';      media_id='568e3de4-cb71-41c7-b321-e36a5fa1fbad'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/568e3de4-cb71-41c7-b321-e36a5fa1fbad.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=1b029907481083e7dc9c56a588b8650bf6466ebce151aacc56126a42fa0b4aac' },
    @{ file='meadow-grove-banister-detail.jpg';      media_id='69bf1739-a2bc-4b89-a80c-c54a7a1e1d5b'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/69bf1739-a2bc-4b89-a80c-c54a7a1e1d5b.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=b06293e935ed2635a0189ca6e7ea5dc7b80555214d7ff032cfe1d93bf83f176c' },
    @{ file='arch-study-doors-to-courtyard.jpg';     media_id='fd9eb351-3743-4d46-a486-7314482c74df'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/fd9eb351-3743-4d46-a486-7314482c74df.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=ab0a7029050e20b974c5eb1ec0b0669c9bd06ebcfc875cef6ae47fc6d8438fe2' },
    @{ file='modern-mews-dusk-from-outside.jpg';     media_id='b54e644f-50b1-45df-983f-3fe4f5e602d3'; url='https://d276s3zg8h21b2.cloudfront.net/user_3DcB3TWAyKGVDci2Bpamfbf1356/b54e644f-50b1-45df-983f-3fe4f5e602d3.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYPNTVMCGYPZMTKFK%2F20260516%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20260516T071848Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=1e000070c838ae1994d2f271fa816e7d6606e60308d24d9b74949c5cd322042a' }
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
Write-Host "Reply to Phil's chat with 'uploads done' so the agent can confirm them on Higgsfield."
