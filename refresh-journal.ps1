# After editing journal/posts/*.md, sync index.json with the new
# frontmatter (title/author/deck), then regenerate all HTML pages and
# update journal.html to reflect the new top-9.
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

$index = Get-Content (Join-Path $root 'journal\index.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$byslug = @{}
foreach ($e in $index) { $byslug[$e.slug] = $e }

# Read all .md files; extract title/author from frontmatter; update matching index entry.
$mdFiles = Get-ChildItem (Join-Path $root 'journal\posts') -Filter '*.md'
$updated = 0
foreach ($f in $mdFiles) {
    $text = [System.IO.File]::ReadAllText($f.FullName, $utf8)
    if ($text -match '(?s)\A---\s*\r?\n(.*?)\r?\n---') {
        $fm = $matches[1]
        $title = $null; $author = $null; $deck = $null
        if ($fm -match '(?m)^title:\s*"?(.*?)"?\s*$') { $title = $matches[1] }
        if ($fm -match '(?m)^author:\s*"?(.*?)"?\s*$') { $author = $matches[1] }
        if ($fm -match '(?m)^deck:\s*"?(.*?)"?\s*$') { $deck = $matches[1] }
        $slug = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
        if ($byslug.ContainsKey($slug)) {
            $entry = $byslug[$slug]
            $entry.title = $title
            if ($author) { $entry.author = $author }
            if ($deck -and -not ($entry.PSObject.Properties.Match('deck').Count)) {
                $entry | Add-Member -NotePropertyName deck -NotePropertyValue $deck -Force
            } elseif ($deck) {
                $entry.deck = $deck
            }
            $updated++
        }
    }
}
# Save updated index.json back
$index | ConvertTo-Json -Depth 5 | Out-File (Join-Path $root 'journal\index.json') -Encoding UTF8
Write-Output ("Synced index.json from frontmatter: $updated posts")

# Now regenerate HTML
& (Join-Path $root 'generate-journal-pages.ps1')

# And refresh the journal index page
& (Join-Path $root 'update-journal-index.ps1')

Write-Output "Done."
