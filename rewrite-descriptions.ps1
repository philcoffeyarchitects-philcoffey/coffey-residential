$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

# Project descriptions, grounded in the content audit.
# Source kept pure ASCII; em-dashes etc are HTML entities so PowerShell
# parses the file regardless of console encoding.
$desc = [ordered]@{
  'meadow-grove-barnes'         = 'A four-bedroom new build in Barnes, organised around a triple-storey stair. Clay plaster, dark timber, marble and a monolithic kitchen island in ice-white concrete.'
  'garden-lodge-harpenden'      = 'An Edwardian lodge with a modern extension, set out as three volumes &mdash; kitchen and dining, living, and a detached gym &mdash; with polished concrete floors and frameless skylights.'
  'cove-ridge-devon'            = 'A five-bedroom sustainable seaside home built into a reclaimed quarry above the North Devon coast. White render, ash joinery, slate-grey polished concrete. Winner, RIBA Regional Award 2023.'
  'capablanca-house-barnsbury'  = 'A four-bedroom Barnsbury home, refurbished and extended around a double-height office above the ground-floor kitchen. White joinery, dark-stained oak and slim aluminium sliding doors to the garden.'
  'modern-barn-devon'           = 'A sustainable three-bedroom new build on the Jurassic Coast &mdash; three single-storey buildings clad in untreated larch on a locally quarried limestone base.'
  'arch-study-notting-hill'     = 'A home office and guest bedroom inside a historic Notting Hill structure, organised around brick arches and a vaulted ceiling. A bespoke oak desk crafted in situ over three months; fluted oak and fluted stone.'
  'apartment-block-clerkenwell' = 'A two-bedroom, two-storey London flat reorganised around a floor of 30,000 hand-cut European oak blocks, under three-metre sash windows. Winner, RIBA London Award 2020 and NLA Don&rsquo;t Move, Improve.'
  'canyon-house-clerkenwell'    = 'Two stacked Clerkenwell warehouse apartments stitched into a single vertical home, around a seven-metre storage wall, a glazed floor panel and a mirrored slot corridor.'
  'helios-house-white-city'     = 'An apartment in the former BBC Television Centre, drawn around the curve of the central Helios statue. Brass inlays, brass flooring trim, perforated screens. Winner, RIBA National Award 2019.'
  'hidden-house-clerkenwell'    = 'A two-bedroom new build on a 72&thinsp;sqm footprint above the vaults of the Clerkenwell House of Detention. Reclaimed London stock brick, oak panelling, ocular rooflights. Final four, RIBA House of the Year 2017.'
  'modern-detached-harpenden'   = 'A four-bedroom new build in two interlocking volumes &mdash; a serrated brick &lsquo;house&rsquo; and a charred-timber insert &mdash; with a brass stair under a circular rooflight. Winner, RIBA East Award 2017.'
  'modern-mews-paddington'      = 'A four-storey Paddington mews house reorganised around a central oak stair with translucent rice-paper sliding doors and a glass-floored upper level. Final four, RIBA House of the Year 2016.'
  'modern-side-extension'       = 'A side extension to a Queens Park terrace that turns the side-alley problem into a brick-pier solution with frameless rooflight glazing. AJ Retrofit Award; shortlisted, Stephen Lawrence Prize.'
  'folded-house-islington'      = 'A six-bedroom Islington refurbishment and extension, organised around a folded birch-plywood staircase that rises through three storeys to an ocular rooflight. Winner, Daily Telegraph Homebuilding &amp; Renovating Award.'
  'island-home-shoreditch'      = 'A Hoxton Square penthouse built around a stainless-steel kitchen island with switchable smart-glass screens and a glazed floor between the two levels. Shortlisted, NLA Don&rsquo;t Move, Improve.'
  'ad-house-york'               = 'A two-storey extension and new garage to a contemporary York home in a conservation area, clad in recycled self-finish zinc over sustainably sourced timber. RIBA Award; shortlisted, Stephen Lawrence Prize.'
  'kitchen-garden-maida-vale'   = 'A three-bedroom Maida Vale apartment opened to its garden by ultra-slim profile glazing, with a linear rooflight aligned over a bespoke kitchen island.'
  'well-house-islington'        = 'A five-bedroom Edwardian refurbishment with side and rear extensions, organised around a double-height light well over the children&rsquo;s playroom. Concrete floors and worktops cast on site.'
  'sky-house-camden'            = 'A three-bedroom Camden penthouse split into two rooftop pavilions, with yellow-pigmented skylights washing the entrance and study. Winner, Grand Designs Award for Best Redesign.'
  'modern-terrace-islington'    = 'A traditional Islington terrace renovated for daylight, with a glass second-flight staircase under a skylight and an open inglenook fireplace at the heart of the plan. Winner, Daily Telegraph Homebuilding &amp; Renovating Award.'
}

$files = 'index.html', 'homes.html'
$updatedTotal = 0

foreach ($f in $files) {
    $path = Join-Path $root $f
    $content = [System.IO.File]::ReadAllText($path, $utf8)
    $updated = 0
    foreach ($slug in $desc.Keys) {
        $newText = $desc[$slug]
        $pattern = '(?s)(<a class="project-row[^"]*"[^>]*href="/' + [regex]::Escape($slug) + '\.html"[^>]*>.*?<p class="pr-body">)[^<]*(</p>)'
        # Escape $ in the replacement so PowerShell doesn't treat it as a backreference
        $escaped = $newText.Replace('$', '$$')
        $replacement = '$1' + $escaped + '$2'
        $new = [regex]::Replace($content, $pattern, $replacement)
        if ($new -ne $content) { $updated++; $content = $new }
    }
    [System.IO.File]::WriteAllText($path, $content, $utf8)
    Write-Output ("{0} - updated {1} descriptions" -f $f, $updated)
    $updatedTotal += $updated
}
Write-Output ("Total replacements: " + $updatedTotal)
