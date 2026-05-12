$utf8 = New-Object System.Text.UTF8Encoding $false
$path = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\homes.html'
$content = [System.IO.File]::ReadAllText($path, $utf8)

# Step 1: Update Capablanca House year from 2023 to 2015
$content = $content -replace '(<a class="project-row project-row--index" href="/capablanca-house-barnsbury.html"[^>]*>.*?<span class="year">)2023(</span>)', '${1}2015${2}'
# .NET regex Singleline equivalent via inline flag (?s)
$content = [regex]::Replace($content,
    '(?s)(<a class="project-row project-row--index" href="/capablanca-house-barnsbury.html"[^>]*>.*?<span class="year">)2023(</span>)',
    '${1}2015${2}'
)

# Step 2: Extract rows, reorder, renumber
$startMarker = '<div class="homes-rows">'
$endMarker   = '</div><!-- /.homes-rows -->'
$startIdx = $content.IndexOf($startMarker) + $startMarker.Length
$endIdx   = $content.IndexOf($endMarker)
$rowsBlock = $content.Substring($startIdx, $endIdx - $startIdx)

$pattern = '(?s)<a class="project-row project-row--index"[^>]*href="([^"]+)"[^>]*>.*?</a>'
$rows = @{}
foreach ($m in [regex]::Matches($rowsBlock, $pattern)) {
    $rows[$m.Groups[1].Value] = $m.Value
}
Write-Output ("Parsed rows: " + $rows.Count)

# New order: by year, newest first. 2015 ties resolved alphabetically.
$newOrder = @(
    '/meadow-grove-barnes.html',          # 01 - 2024
    '/garden-lodge-harpenden.html',       # 02 - 2023
    '/cove-ridge-devon.html',             # 03 - 2023
    '/modern-barn-devon.html',            # 04 - 2021
    '/arch-study-notting-hill.html',      # 05 - 2021
    '/apartment-block-clerkenwell.html',  # 06 - 2020
    '/canyon-house-clerkenwell.html',     # 07 - 2020
    '/helios-house-white-city.html',      # 08 - 2019
    '/hidden-house-clerkenwell.html',     # 09 - 2017
    '/modern-detached-harpenden.html',    # 10 - 2017
    '/modern-mews-paddington.html',       # 11 - 2016
    '/capablanca-house-barnsbury.html',   # 12 - 2015
    '/modern-side-extension.html',        # 13 - 2015
    '/folded-house-islington.html',       # 14 - 2013
    '/island-home-shoreditch.html',       # 15 - 2013
    '/ad-house-york.html',                # 16 - 2012
    '/kitchen-garden-maida-vale.html',    # 17 - 2010
    '/well-house-islington.html',         # 18 - 2010
    '/sky-house-camden.html',             # 19 - 2009
    '/modern-terrace-islington.html'      # 20 - 2008
)

$rebuilt = New-Object System.Text.StringBuilder
[void]$rebuilt.Append("`n`n")
$n = 1
foreach ($href in $newOrder) {
    $row = $rows[$href]
    if (-not $row) { Write-Output ("MISSING row: $href"); continue }
    $nn = '{0:D2}' -f $n
    $row = [regex]::Replace($row, '(<div class="pr-eyebrow">)\d+ / 20', "`${1}$nn / 20")
    [void]$rebuilt.Append($row)
    [void]$rebuilt.Append("`n`n")
    $n++
}
$newRowsBlock = $rebuilt.ToString()
$newContent = $content.Substring(0, $startIdx) + $newRowsBlock + $content.Substring($endIdx)
[System.IO.File]::WriteAllText($path, $newContent, $utf8)
Write-Output "homes.html saved"

# Verify
$check = [regex]::Matches($newContent, '<a class="project-row project-row--index"[^>]*href="([^"]+)".*?<div class="pr-eyebrow">([^<]+)</div>.*?<h2 class="pr-title">([^<]+)</h2>.*?<span class="year">([^<]+)</span>', 'Singleline')
foreach ($m in $check) {
    Write-Output ("  {0,-15}  {1,-26}  {2}" -f $m.Groups[2].Value, $m.Groups[3].Value, $m.Groups[4].Value)
}
