$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Continue'

$dest = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\images'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }

$urls = @(
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/d0f82569-bb80-466c-9705-5dade646ec0f/phil-coffey-residential.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/60bdfa4c-ca02-49d7-82a2-50d8d4e5c820/meadow-grove-living.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/3996eaa8-72ea-4926-bd7d-0c746af6c747/garden-lodge-dining-and-kitchen-connection.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/ff50b255-61fc-4842-bb43-43cd06d45bef/cove-ridge-external-terrace.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/3358cce8-5780-48d7-9210-5759be0fcb6c/modern-detached-kitchen.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/0df2b615-711f-430a-88b0-cf5ceeab4eaf/helios-house-bathroom-window.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/534c67a8-b304-4109-99e1-d1107251814c/modern-mews-living-room.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/3824f004-4e2a-40dd-97aa-ed5cc41b4ca7/coffey-residential-studio.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/81673154-9b77-433f-a0ab-499d9416ccff/individual-house-architect-of-the-year.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/77b4048e-2a00-46b1-bc29-6b9dce111db1/riba-award-winner.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/5e08cb75-cd72-4cb3-b583-ad86cf0ef635/retrofit-awards-winner.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/637d973c-5556-45e9-a910-843f19096f7a/daily-telegraph-winner.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/00dfc084-671a-4d6d-9353-2eccde2d4f9f/new-london-award-winner.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/c9a5f571-dbf3-447a-bff4-b031ca719670/brick-awards-winner.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/5c48e63e-f4ab-48e1-8cf3-3c6e65974509/riba-house-of-the-year.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/8b8ccf9b-ec77-43b1-90f2-b51b5dc1ffc9/stephen-lawrence-prize-shortlisted.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/b797a993-efa1-4e49-8173-907930b6cb52/wallpaper.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/89914937-6262-46f6-8f00-1e4bfe6a0222/the-guardian.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/b22061ea-62c3-4df3-9560-8fa45d0b45a2/homebuilding-and-renovating.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/a0572204-6955-4748-aa41-04fb4fe6feae/dezeen-logo.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/bd8bd9d0-8428-41b0-ab82-c5f21a982cec/the-spectator.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/a28551e6-0a0d-4399-bca9-c81dff6ef4ae/dont-move-improve.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/c2a12790-6ca2-4b9a-9b96-724085be98a6/grand-designs.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/c19a620e-9a02-458c-ae17-1adb1bd62413/living-etc.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/cc777dea-01af-4f97-b2ef-c7cce22e72c1/the-daily-telegraph.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/2a81fb8c-f3df-4586-91f5-05d9acdc427c/riba-journal.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/781983d6-8238-4a11-a384-7c6cd092cd09/the-wall-street-journal.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/36f8603c-e22f-4ec0-8a83-e9eafba0419d/ideas-gn.jpg',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/6650bbf1-a997-4e2e-a1bc-6c273365780f/building-design.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/2d7ac704-03fa-4825-bdee-ef2f535c1bef/evening-standard.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/70c9161e-c4ff-4884-9658-15d697d1a8de/elle-decoration.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/f15819da-aa03-4291-934a-f5f730e3ff6d/architecture-today.png',
    'https://images.squarespace-cdn.com/content/v1/6785171870c31d13d6d79a5e/bb80b135-4931-4b79-8535-d42aaa494f9f/archietcts-journal.png'
)

$ok = 0; $fail = 0
foreach ($u in $urls) {
    $name = ($u -split '/')[-1]
    $out  = Join-Path $dest $name
    # Squarespace serves a clean original when no ?format= is passed; use the format=2500w param to force a high-res render.
    $hires = $u + '?format=2500w'
    try {
        Invoke-WebRequest -Uri $hires -UserAgent 'Mozilla/5.0' -OutFile $out -ErrorAction Stop
        $ok++
    } catch {
        try {
            Invoke-WebRequest -Uri $u -UserAgent 'Mozilla/5.0' -OutFile $out -ErrorAction Stop
            $ok++
        } catch {
            Write-Output ("FAIL: " + $name + " :: " + $_.Exception.Message)
            $fail++
        }
    }
}
Write-Output ("Downloaded: " + $ok + ", Failed: " + $fail)
Get-ChildItem $dest | Select-Object Name, @{n='KB';e={[math]::Round($_.Length/1KB,1)}} | Format-Table -AutoSize
