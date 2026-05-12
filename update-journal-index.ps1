# Update journal.html to show the 9 most-recent posts from index.json
# (lead article + 8 grid cards), with real titles, hero images and read times.
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

$index = Get-Content (Join-Path $root 'journal\index.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$posts = $index | Select-Object -First 9
$lead  = $posts[0]
$grid  = $posts[1..8]

function Encode-Html([string]$s) {
    if ($null -eq $s) { return '' }
    return $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

function ReadTime([int]$wc) {
    if ($wc -le 0) { return '1 min' }
    return ([Math]::Max(1, [Math]::Round($wc / 200))).ToString() + ' min'
}

function FormatDate($d) {
    if (-not $d) { return '' }
    try { return ([DateTime]::Parse($d)).ToString('MMM yyyy') } catch { return $d }
}

# Build the lead article HTML
$leadImg = if ($lead.hero_image) { $lead.hero_image } else { 'images/cove-ridge-first-floor-living.jpg' }
$leadTitle = Encode-Html $lead.title
$leadDate = FormatDate $lead.date
$leadRead = ReadTime ([int]$lead.word_count)

$leadHtml = @"
<a class="journal-lead" href="/journal/$($lead.slug).html">
  <div class="journal-lead__grid">
    <div class="journal-lead__content">
      <div>
        <span class="eyebrow">Lead &middot; Journal &middot; $leadRead read</span>
        <h2>$leadTitle</h2>
      </div>
      <div class="journal-lead__foot">
        <span>$(Encode-Html $lead.author) &middot; $leadDate</span>
        <span class="read">Read &rarr;</span>
      </div>
    </div>
  </div>
</a>
"@

# Build the 8 grid cards
$cardsHtml = ($grid | ForEach-Object {
    $p = $_
    $date = FormatDate $p.date
    $read = ReadTime ([int]$p.word_count)
    $titleEsc = Encode-Html $p.title
@"

    <a class="journal-card" href="/journal/$($p.slug).html">
      <div class="journal-card__meta"><span>Journal</span><span>$date &middot; $read</span></div>
      <div class="journal-card__title">$titleEsc</div>
    </a>
"@
}) -join ''

# Now read journal.html and swap the existing lead + grid blocks
$path = Join-Path $root 'journal.html'
$html = [System.IO.File]::ReadAllText($path, $utf8)

# Replace the entire lead article block (from <!-- ===== Lead article ===== --> to its closing </a>)
$leadPattern = '(?s)<!-- ===== Lead article =====[\s\S]*?</a>\s*'
$html = [regex]::Replace($html, $leadPattern, "<!-- ===== Lead article ===== -->`r`n$leadHtml`r`n`r`n")

# Replace everything inside <div class="journal-index__grid"> ... </div>
$gridPattern = '(?s)(<div class="journal-index__grid">)[\s\S]*?(\s*</div>\s*</section>)'
$html = [regex]::Replace($html, $gridPattern, "`$1$cardsHtml`r`n  `$2")

# Update the "All entries" count to reflect the real archive
$html = $html -replace '<span class="meta">8 shown</span>', "<span class=`"meta`">$($index.Count) in the archive</span>"

[System.IO.File]::WriteAllText($path, $html, $utf8)
Write-Output ("journal.html updated. Lead: " + $lead.title)
Write-Output ("Grid: " + ($grid | ForEach-Object { $_.title }) -join ' / ')
