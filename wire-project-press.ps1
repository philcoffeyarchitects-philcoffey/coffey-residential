# Wire up the "Press for this project" rows on every project page. Source
# names are matched against the row, and href="#" is replaced with the
# external URL from Phils press list. Anything we still dont have a URL
# for is left as href="#" so it stays inert until a URL is supplied.

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Read-File([string]$p) { [System.IO.File]::ReadAllText($p, $utf8) }
function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

# slug -> @{ source-name = url }
$pressMap = @{
  'apartment-block-clerkenwell' = [ordered]@{
    "Architects' Journal" = 'https://www.architectsjournal.co.uk/buildings/coffey-architects-designs-clerkenwell-flat-as-solid-piece-of-joinery'
    'Wallpaper*' = 'https://www.wallpaper.com/architecture/coffey-architects-apartment-school-house-clerkenwell-london'
    'Architecture Today' = 'https://architecturetoday.co.uk/apartment-block/'
    'Building Design Online' = 'https://www.bdonline.co.uk/news/coffey-crafts-apartment-block-with-clerkenwell-flat-conversion/5102088.article'
    'Dezeen' = 'https://www.dezeen.com/2019/09/19/apartment-block-coffey-architects-wood-interiors/'
    'RIBA London Awards' = 'https://www.architecture.com/awards-and-competitions-landing-page/awards/riba-regional-awards/riba-london-award-winners/2021/apartment-block'
    'Yellow Trace' = 'https://www.yellowtrace.com.au/coffey-architects-london-apartment-refurbishment-covered-in-thousands-of-timber-blocks/'
    'London Build Expo' = 'https://www.londonbuildexpo.com/news/coffey-architects-covers-london-apartment-in-30000-wooden-blocks'
  }
  'cove-ridge-devon' = [ordered]@{
    'Wallpaper*' = $null   # no URL supplied
    'RIBA Journal' = 'https://www.ribaj.com/buildings/regional-awards-2023-south-west-wessex-coffey-architects-cove-ridge-house-woolacombe'
    'Dezeen' = $null
    # extra URLs from the list that arent in the rows: architecture.com (RIBA SW), architecturetoday, homeworlddesign
  }
  'folded-house-islington' = [ordered]@{
    'Ideas GN' = 'http://ideasgn.com/folded-house-london-coffey-architects/'
    'The Daily Telegraph' = $null
  }
  'hidden-house-clerkenwell' = [ordered]@{
    "Architects' Journal" = 'https://www.architectsjournal.co.uk/buildings/coffey-architects-hidden-house-revealed'
    'RIBA London Awards' = 'https://www.architecture.com/awards-and-competitions-landing-page/awards/riba-regional-awards/riba-london-award-winners/2017/hidden-house'
    'Dezeen' = 'https://www.dezeen.com/2017/04/06/coffey-architects-small-brick-polished-concrete-oak-panelling-hidden-house-victorian-prison-vaults/'
    'Wallpaper*' = 'https://www.wallpaper.com/architecture/hidden-house-coffey-architects-london-uk'
    'RIBA Journal' = 'https://www.ribaj.com/buildings/hidden-house-clerkenwell-coffey-architects-riba-awards-2017-london'
    'The Guardian' = 'https://www.theguardian.com/lifeandstyle/2017/nov/26/jail-house-rocks-an-architectural-marvel-built-over-an-old-prison-vault'
    'Curbed' = 'https://archive.curbed.com/2017/4/7/15223930/london-homes-design-clerkenwell'
  }
  'modern-barn-devon' = [ordered]@{
    'The Spectator' = 'https://www.spectator.co.uk/article/what-it-takes-to-build-a-modern-home-high-on-the-dorset-cliffs/'
    'Wallpaper*' = 'https://www.wallpaper.com/architecture/modern-barn-coffey-architects-uk'
    'Dezeen' = 'https://www.dezeen.com/2023/09/11/coffey-architects-rural-modern-barn-coastal-home-dorset/'
    "Architects' Journal" = 'https://www.architectsjournal.co.uk/buildings/coffey-completes-three-volume-timber-clad-home-on-dorset-coast'
    'Architecture Today' = 'https://architecturetoday.co.uk/coffey-architects-modern-barn-dorset/'
    'Building Design Online' = 'https://www.bdonline.co.uk/news/in-pictures-coffey-architects-completes-modern-barn/5124817.article'
    'DesignBoom' = 'https://www.designboom.com/architecture/pitched-timber-volumes-coffey-architects-dorset-modern-barn-08-27-2023/'
    'Homebuilding &amp; Renovating' = 'https://www.homebuilding.co.uk/ideas/sustainable-modern-barn-with-360-views'
    'E-Architect' = 'https://www.e-architect.com/england/modern-barn-dorset-southwest-england'
  }
  'modern-detached-harpenden' = [ordered]@{
    'AJ Buildings Library' = 'https://www.ajbuildingslibrary.co.uk/projects/display/id/7946'
    'Architecture Today' = 'https://architecturetoday.co.uk/modern-detached/'
    'RIBA East Awards' = 'https://www.architecture.com/awards-and-competitions-landing-page/awards/riba-regional-awards/riba-east-award-winners/2017/modern-detached'
    'Brick Development Association' = 'https://www.brick.org.uk/news/2017-11-14-modern-detached-by-coffey-architects'
  }
  'modern-mews-paddington' = [ordered]@{
    'Dezeen' = 'https://www.dezeen.com/2016/12/12/modern-mews-london-house-renovation-phil-coffey-architects-oak-staircase/'
    'RIBA Journal' = 'https://www.ribaj.com/buildings/modern-mews-london'
    'Archello' = 'https://archello.com/project/modern-mews'
    'Architonic' = 'https://www.architonic.com/en/project/coffey-architects-modern-mews/5103644'
  }
  'modern-side-extension' = [ordered]@{
    "Architects' Journal" = 'https://www.architectsjournal.co.uk/buildings/stephen-lawrence-prize-modern-side-extension-by-coffey-architects'
    'RIBA Journal' = 'https://www.ribaj.com/buildings/modern-side-extension'
  }
  'canyon-house-clerkenwell' = [ordered]@{
    'Journal du Design' = 'https://www.journal-du-design.fr/architecture/canyon-house-coffey-architects-35382/'
    'Corriere della Sera Living' = 'https://living.corriere.it/case/minimal/canyon-house-londra-coffey-architects-401711461625/'
  }
  'meadow-grove-barnes' = [ordered]@{
    'The Wall Street Journal' = 'https://www.wsj.com/real-estate/luxury-homes/family-home-renovation-london-1fc41ff7'
  }
}

$patched = 0
foreach ($slug in $pressMap.Keys) {
  $path = Join-Path $root "$slug.html"
  if (-not (Test-Path $path)) { Write-Warning "missing: $slug.html"; continue }
  $orig = Read-File $path
  $new = $orig
  foreach ($source in $pressMap[$slug].Keys) {
    $url = $pressMap[$slug][$source]
    if (-not $url) { continue }   # leave unmapped sources as href="#"
    # Match: <a class="project-press__row" href="#"><div class="src">{source}</div>
    $sourceEsc = [regex]::Escape($source)
    $pattern = '<a\s+class="project-press__row"\s+href="#"(\s*>\s*<div class="src">' + $sourceEsc + '</div>)'
    $replacement = '<a class="project-press__row" href="' + $url + '" target="_blank" rel="noopener noreferrer"$1'
    $new = [regex]::Replace($new, $pattern, $replacement)
  }
  if ($new -ne $orig) {
    Write-File $path $new
    $patched++
    $changes = ([regex]::Matches($new, 'class="project-press__row" href="https').Count)
    Write-Host "  patched: $slug.html ($changes urls wired)"
  }
}
Write-Host ""
Write-Host "Done. Patched $patched project pages."
