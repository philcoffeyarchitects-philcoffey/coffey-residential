# Generate the 10 new image-led journal articles plus the rebuilt
# journal.html index. Old (image-less) entries get shown via a separate
# /journal/archive.html page linked from the new index.
#
# All copy is in this one file so it is easy to revise without grepping
# across ten article HTML files.

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding $false
$root = 'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential'

function Write-File([string]$p, [string]$c) { [System.IO.File]::WriteAllText($p, $c, $utf8) }

# Match the structure of journal-on-the-architecture-of-light.html and the
# existing /journal/*.html articles. Image paths are relative to /journal/.

# ------------ The 10 new posts ------------
# 'body' is one HTML chunk (paragraphs, blockquotes etc). First <p> gets
# .drop-cap. Em-dashes are written as &mdash; to keep the PowerShell
# source ASCII-safe.

$posts = @(
    @{
        slug    = 'the-corner-of-the-room'
        title   = 'The corner of the room.'
        tag     = 'Essay'
        date    = 'May 2026'
        read    = '4 min read'
        image   = 'shelf-in-plaster.png'
        alt     = 'A travertine shelf set into a hand-trowelled plaster wall'
        caption = 'Niche shelf in lime plaster &middot; studio detail'
        deck    = 'On the niche, the shelf, and what to put on it.'
        ogdesc  = 'On the niche, the shelf, and what to put on it &mdash; a short essay on the corner of the room as a designed object.'
        body    = @'
<p class="drop-cap">Every house we draw has a corner that we treat as carefully as the bigger gestures. It is usually a shelf set into the plaster, a quiet rectangle two or three hundred millimetres deep, in stone or oak, lit by whatever happens to be passing through the room that day.</p>
<p>The point is not really the shelf. The point is the discipline of saying that this corner deserves a thing in it, and that the thing should be drawn at full size before it is built.</p>
<p>Most clients ask for storage. We are usually drawing for something slower than that. The niche is not where you put the post; it is where you set down a book that you have not yet finished, a candle, a small piece of work the kids brought home from school, a glass of water that you mean to drink before bed.</p>
<blockquote>
  <p>&ldquo;A house is the sum of its small surfaces. Get those right and the bigger rooms tend to look after themselves.&rdquo;</p>
</blockquote>
<p>The detail matters. Three millimetres of shadow gap between the shelf and the wall reads as something held by light rather than glued to plaster. The front edge is bevelled the same way every shelf on the project is bevelled, so the house feels drawn by one hand. The bracket underneath is invisible.</p>
<p>None of this is clever. All of it is the kind of work that asks for a Wednesday afternoon and a 1:1 drawing, and a willingness on the client&rsquo;s part to spend ten minutes on a corner that most people will never notice. The people who live there will, though &mdash; every day, for the rest of the house&rsquo;s life.</p>
'@
    },
    @{
        slug    = 'how-a-window-meets-a-wall'
        title   = 'How a window meets a wall.'
        tag     = 'Detail'
        date    = 'May 2026'
        read    = '3 min read'
        image   = 'window-meets-brick.png'
        alt     = 'A bronze window frame set into a weathered London-stock brick wall'
        caption = 'Bronze frame, London stock brick &middot; junction detail'
        deck    = 'A window is mostly a junction. The trick is to draw the junction first.'
        ogdesc  = 'A short detail piece on the bronze-to-brick junction, and why we draw the junction before the window.'
        body    = @'
<p class="drop-cap">A window is mostly a piece of glass and four edges. The four edges are where the work is. Most of the time spent designing a window goes into how those edges meet whatever they touch &mdash; brick, plaster, oak, render, sky.</p>
<p>This bronze frame sits proud of the brickwork by twelve millimetres, with a shadow gap below the cill. The frame reads as a piece of metal placed in front of a wall, not pushed into it. The brick courses run uninterrupted up to the reveal and then stop, and the bronze takes over.</p>
<p>It is a small choice. It would have been quicker to set the frame flush. But flush windows lose their shape after a few years &mdash; the silicone catches dust, the brick courses look like they are pretending to be paper, the wall stops feeling like a wall. The deeper reveal keeps both materials honest.</p>
<p>The bronze is left to weather. In ten years it will look quieter than it does now; in twenty it will be the same colour as the mortar. The brick is London stock, lime-mortared, picked from a stockpile thirty miles from the site. It will outlast the metal.</p>
<p>We draw the junction first and the window second. By the time you draw the window, the junction has already told you what the window can be.</p>
'@
    },
    @{
        slug    = 'one-dial-per-room'
        title   = 'One dial, per room.'
        tag     = 'Detail'
        date    = 'April 2026'
        read    = '3 min read'
        image   = 'brass-dial.png'
        alt     = 'A solid brass rotary dimmer set into a hand-trowelled plaster wall'
        caption = 'Brass rotary dimmer &middot; lighting control'
        deck    = 'Why we still wire each room to a single switch.'
        ogdesc  = 'A short piece on why we still specify one rotary dimmer per room, against the tide of app-controlled lighting systems.'
        body    = @'
<p class="drop-cap">A house should be possible to turn on with one hand. The lighting in our projects is wired so that every room has a single dial near the door, you walk in, you turn it, and the room comes up to the level you want it.</p>
<p>This is a small political position. The default in high-end residential is a Lutron or Crestron system, an app on a wall-mounted tablet, sixteen scenes per room. We have lived in houses with those systems. They are difficult to use, and they age badly, and the tablet stops working two years after the warranty.</p>
<p>The dial is brass, machined, ten millimetres proud of the plaster. It dims one circuit, slowly, from off to full. Behind it is a single LED driver tuned to the room. There is no scene called &ldquo;evening&rdquo;. The dimmer is the scene.</p>
<blockquote>
  <p>&ldquo;If the architecture is right, you don&rsquo;t need sixteen lighting scenes. You need one fitting, well placed, and a way to take it up and down.&rdquo;</p>
</blockquote>
<p>This means the lighting design happens earlier. You can&rsquo;t paper over a badly-placed downlight with a programme. The fitting has to be where the wall meets the ceiling, or held off the ceiling, or hidden behind a coffer, before the cable is run. The plan and the section have to know about it.</p>
<p>What you get in return is a house that you can hand to a teenager without an instruction manual. They walk in. They turn the dial. The room comes up.</p>
'@
    },
    @{
        slug    = 'the-pile-on-the-table'
        title   = 'The pile on the table.'
        tag     = 'Process'
        date    = 'April 2026'
        read    = '4 min read'
        image   = 'material-samples.png'
        alt     = 'A small pile of material samples on a studio table &mdash; oak, brick, stone, wood-wool board'
        caption = 'Material samples for an early-stage project &middot; studio table'
        deck    = 'Three or four materials, side by side, for months.'
        ogdesc  = 'How material choices for a new house are made by looking at three or four samples on a table for months at a time.'
        body    = @'
<p class="drop-cap">Around month three of a project the studio table starts to gather a small pile. A piece of brick, a chunk of oak block, a sample of the stone we&rsquo;re thinking about for the worktop, a square of wood-wool board to keep the building warm. There are usually four or five things and they sit there for a long time.</p>
<p>This is the early architecture of the house. We look at them in different light. We pick them up. We move them around. We bring them home for a weekend and look at them next to the materials of the existing house. Slowly, three of them survive and the rest are quietly removed.</p>
<p>The surviving materials are the ones that work with each other in every light. Some materials are beautiful at noon and dead at four; some are quiet at noon and remarkable at dusk. The pile shows you that, slowly.</p>
<p>By the time the planning drawings go in, the materials have been on the table for sixteen weeks. By the time the builder is on site they have been there for a year. The conversations about materials are mostly conversations we have already had. The site decisions are detail decisions.</p>
<p>You can do this digitally. We have tried. It does not work. The pile is the thing.</p>
'@
    },
    @{
        slug    = 'a-plant-is-a-piece-of-architecture'
        title   = 'A plant is a piece of architecture.'
        tag     = 'Field'
        date    = 'March 2026'
        read    = '3 min read'
        image   = 'fiddle-leaf-fig.png'
        alt     = 'A fiddle-leaf fig leaf against a hand-trowelled plaster wall'
        caption = 'Fiddle-leaf fig &middot; living detail'
        deck    = 'On living things in rooms drawn by hand.'
        ogdesc  = 'Houseplants as a piece of the architecture, not a piece of styling &mdash; on living things in rooms drawn by hand.'
        body    = @'
<p class="drop-cap">A house with plants in it feels different to a house without. We have stopped pretending this is a styling choice and started drawing for it.</p>
<p>The plant is the thing in the room that changes. It grows over the year, drops a leaf, finds the light. Everything else in a well-built room stays put. The architecture is the score; the plant is the part of the music that is improvised.</p>
<p>So we draw the plant in. There is a corner that takes morning sun and is wide enough for something to grow tall. The skirting steps back at the foot so the pot doesn&rsquo;t announce itself. The floor under the pot is honest stone or tile, not a finish that will mark under a watering can.</p>
<p>The fig in the picture is in a house we finished last spring. It moved in with the family. It has put on six inches since. The shadow it casts on the plaster shifts about thirty degrees over the course of a year. None of that was an accident.</p>
<p>People sometimes ask whether we recommend plants. We don&rsquo;t. We recommend a room that can hold one if you want one. That is the same thing, drawn earlier.</p>
'@
    },
    @{
        slug    = 'why-we-still-draw-by-hand'
        title   = 'Why we still draw by hand.'
        tag     = 'Process'
        date    = 'March 2026'
        read    = '5 min read'
        image   = 'hand-drawn-plan.png'
        alt     = 'A pencil plan on tracing paper, with dimensions and a &ldquo;VOID&rdquo; annotation'
        caption = 'Concept plan &middot; pencil on tracing paper'
        deck    = 'What pencil on tracing paper still does that software can&rsquo;t.'
        ogdesc  = 'On the hand-drawn plan &mdash; why we still start every project in pencil on tracing paper before any line touches a screen.'
        body    = @'
<p class="drop-cap">Every project we work on starts the same way. Phil at the studio table with a roll of tracing paper, an HB pencil, and a scale rule. The first month of drawings is mostly that.</p>
<p>The argument for hand drawing is not nostalgia. It is about resolution. A pencil line can be any thickness; a wall on a CAD plan is exactly the thickness the wall layer says it is. The pencil records uncertainty. The CAD plan pretends there is none.</p>
<p>So when a wall is provisional &mdash; when we are still asking whether it is a wall or a curtain or a step in the floor &mdash; the pencil draws it light, and the next plan draws it darker, and by the seventh sketch it has the weight of a real wall and the project moves on. None of those intermediate drawings can be made in a programme that requires you to commit.</p>
<blockquote>
  <p>&ldquo;CAD is for making the building. Pencil is for finding it.&rdquo;</p>
</blockquote>
<p>We move to CAD around the planning stage. Once the plan has been drawn forty or fifty times and the section nine times, there is something there to draw cleanly. Before that, the hand is faster and more honest. The drawings stack up in a flat file in the studio, dated, scribbled on, an obvious record of where the design came from.</p>
<p>The client gets the pencil drawings as much as the CAD ones. We find clients understand them better. A pencil line is a thinking line; it is easier to disagree with than a CAD line, which always looks decided.</p>
'@
    },
    @{
        slug    = 'what-we-keep-the-cold-out-with'
        title   = 'What we keep the cold out with.'
        tag     = 'Materials'
        date    = 'February 2026'
        read    = '4 min read'
        image   = 'sheep-wool-insulation.png'
        alt     = 'A batt of natural sheep-wool insulation'
        caption = 'Sheep-wool batt &middot; natural insulation'
        deck    = 'Sheep wool, hemp, and the slow case against PIR.'
        ogdesc  = 'On natural insulation &mdash; sheep wool, hemp, wood-fibre &mdash; and the slow case against polyisocyanurate (PIR) boards.'
        body    = @'
<p class="drop-cap">Most new houses in Britain are insulated with PIR boards. They are the orange foam panels on every site, and they are insulating roughly half of the country. We have stopped using them.</p>
<p>The reasons are simple and slow. PIR is a petrochemical product with a very high embodied-carbon footprint. The board you nail to a stud wall takes more carbon to make than the wall will save in operational heating for the first seven or eight years. It is also not breathable, which makes it the wrong material for a Victorian solid wall, where moisture needs to move through the build-up. And it is difficult to recycle.</p>
<p>The alternative is natural fibre. Sheep wool is the easiest to talk about, because the supply chain is honest: it is a by-product of the meat industry that would otherwise be burned. It has roughly the same thermal performance as mineral wool, breathes, absorbs and releases humidity, and lasts as long as the building. Hemp and wood-fibre boards do similar things.</p>
<p>The trade-off is cost. Sheep wool is currently about two and a half times the price of PIR. The headline number is real, but the lifetime number tells a different story: a house insulated in sheep wool will not need its build-up redone in twenty years, because the material has not failed.</p>
<p>It is also easier to install. The fitter cuts it with scissors. There is no dust, no taping, no waste skip full of foam offcuts. The fitters we work with prefer it. Make of that what you will.</p>
'@
    },
    @{
        slug    = 'the-cross-and-what-holds-it'
        title   = 'The cross, and what holds it.'
        tag     = 'Detail'
        date    = 'February 2026'
        read    = '3 min read'
        image   = 'window-cross.png'
        alt     = 'A bronze cross junction in a Crittall-style window, looking out at a cloudy sky'
        caption = 'Bronze cross junction &middot; window detail'
        deck    = 'Where four pieces of bronze meet, and how to draw it.'
        ogdesc  = 'On the four-way cross junction in a Crittall-style window &mdash; the small piece of bronze that holds the architecture together.'
        body    = @'
<p class="drop-cap">The cross in the picture is the place where four pieces of bronze meet behind glass. It is a window detail that almost no one will look at, and it is the part of the window that we spend the most time drawing.</p>
<p>A cross junction in a steel or bronze window is hard. The two horizontals have to thread through the verticals without losing their alignment. The drainage needs to go somewhere. The thermal break has to be continuous. And visually, the four arms should read as one piece &mdash; not as a clumsy intersection of two pieces of metal.</p>
<p>The way to do it is to draw the cross before drawing the window. The window is then the four panels of glass that this cross holds. It is a small reversal of how most architects think about windows, but it puts the right thing first.</p>
<p>The bronze here is hand-finished by a small fabricator in north London who has been making windows for forty years. We send him a full-size drawing of the cross. He sends back a sample. We argue about it. He wins, usually.</p>
<p>Built well, a cross junction will outlast the architects who drew it.</p>
'@
    },
    @{
        slug    = 'one-light-well-placed'
        title   = 'One light, well placed.'
        tag     = 'Essay'
        date    = 'January 2026'
        read    = '4 min read'
        image   = 'light-on-plaster.png'
        alt     = 'A single warm spotlight falling on a hand-trowelled plaster wall'
        caption = 'One downlight, a quiet wall &middot; evening'
        deck    = 'What a single fitting can do to a wall after dark.'
        ogdesc  = 'On the restraint of using one light per wall &mdash; what a single, well-placed fitting can do that twenty downlights cannot.'
        body    = @'
<p class="drop-cap">There is a temptation in a new build to add lights until the rooms are evenly lit. We have learned to resist it.</p>
<p>The picture is a corner of a hallway in a house we finished last year. There is one fitting, set into the ceiling about a metre back from the wall, washing the plaster from above. There are no skirting-level lights, no downlights in the corridor, no second wash from the opposite wall. The light is doing the work alone.</p>
<p>What this gets you is contrast. The hallway is dark; the wall is bright; the texture of the plaster shows because the light is grazing it. You feel where you are. There is somewhere lit and somewhere not, and the architecture is what tells you which is which.</p>
<p>Even lighting is a sort of cinema-screen effect &mdash; flat, bright, generic. It is good for warehouses. It is poor for living. A house wants its corners darker than its centres. It wants its walls brighter than its floor, in the evening, and dimmer than its windows, in the day.</p>
<p>The plan we draw early includes where the single light goes. Not the lighting plan: the architectural plan. The light fitting is not a finish; it is part of the wall.</p>
'@
    },
    @{
        slug    = 'houses-outlast-watches'
        title   = 'Houses outlast watches.'
        tag     = 'Essay'
        date    = 'January 2026'
        read    = '5 min read'
        image   = 'watch-on-stone.png'
        alt     = 'A simple mechanical wristwatch lying on a travertine surface'
        caption = 'A watch on stone &middot; studio still life'
        deck    = 'Designing for fifty years, not five.'
        ogdesc  = 'A short essay on time and longevity &mdash; the case for designing houses to last fifty years, not five.'
        body    = @'
<p class="drop-cap">A house we finished in 2015 is the same house it was when we handed it over. A watch I bought in 2015 is its third strap and second battery. This is not a comparison I had thought about until recently. It explains something about how we design.</p>
<p>The Victorian terraces we work on are nearly all over a hundred years old. The brick was fired in the 1880s. The mortar is patchier than it was; the floorboards have moved; the staircase still works. None of the original drawings exist. The house has survived through patience and reasonable maintenance.</p>
<p>This is the company most of our new work is going to keep. The houses we are drawing now will, with luck, still be standing in 2125. The plaster will have been redone twice; the heating system three times; the windows once. The walls, the section, the way light arrives in the kitchen &mdash; those should be the same.</p>
<blockquote>
  <p>&ldquo;Don&rsquo;t build something a building can&rsquo;t carry for a hundred years. That goes for materials, services, decisions and ideas.&rdquo;</p>
</blockquote>
<p>It is a simple rule. It rules out a lot of the things you are currently allowed to do as a house architect: the screens, the underfloor lighting fed by a control system that won&rsquo;t be supported in 2032, the bespoke joinery that is screwed to the substrate of the wall, the metallic finish on the brick that will spall in a London winter.</p>
<p>Houses outlast watches. Most of our work is making sure that they outlast us, too.</p>
'@
    }
)

# ------------ Shared HTML chunks ------------

$schemaOrg = @'
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Coffey Residential",
  "alternateName": "Coffey Architects",
  "url": "https://coffeyresidential.com/",
  "logo": "https://coffeyresidential.com/images/webp/logo.webp",
  "founder": { "@type": "Person", "name": "Phil Coffey" },
  "foundingDate": "2005",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "104-110 Goswell Road",
    "addressLocality": "London",
    "addressRegion": "Clerkenwell",
    "postalCode": "EC1V 7DH",
    "addressCountry": "GB"
  },
  "telephone": "+44 20 7549 2141",
  "email": "contact@coffeyresidential.com",
  "sameAs": [ "https://www.coffeyarchitects.com/" ]
}
'@

# ------------ Per-post HTML template ------------

# Bullet ndash: U+2014 (em-dash) is encoded as &mdash; in source, so this
# script stays Windows-1252-safe.
$baseUrl = 'https://coffeyresidential.com'

# Build a quick list of {slug, title} for read-next generation.
$lookup = $posts | ForEach-Object { @{ slug = $_.slug; title = $_.title; tag = $_.tag; date = $_.date; read = $_.read } }

for ($i = 0; $i -lt $posts.Count; $i++) {
    $p = $posts[$i]
    # Read-next: the next three posts, wrapping around.
    $readNext = @()
    for ($j = 1; $j -le 3; $j++) {
        $idx = ($i + $j) % $posts.Count
        $readNext += $lookup[$idx]
    }

    $articleSchema = @"
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "$($p.title -replace '\.$','')",
  "description": "$($p.ogdesc -replace '&mdash;', [char]0x2014)",
  "url": "$baseUrl/journal/$($p.slug)",
  "image": "$baseUrl/journal/img/$($p.image)",
  "datePublished": "2026-$(switch -Regex ($p.date) { 'May' { '05-15' } 'April' { '04-08' } 'March' { '03-12' } 'February' { '02-05' } 'January' { '01-22' } default { '05-01' } })",
  "author": { "@type": "Person", "name": "Phil Coffey" },
  "publisher": {
    "@type": "Organization",
    "name": "Coffey Residential",
    "logo": { "@type": "ImageObject", "url": "$baseUrl/images/webp/logo.webp" }
  }
}
"@

    $breadcrumb = @"
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Journal", "item": "$baseUrl/journal" },
    { "@type": "ListItem", "position": 2, "name": "$($p.title -replace '\.$','')", "item": "$baseUrl/journal/$($p.slug)" }
  ]
}
"@

    $readNextCards = ($readNext | ForEach-Object {
        @"
    <a class="read-next__card" href="$($_.slug).html">
      <div class="meta">Journal &middot; $($_.date) &middot; $($_.read)</div>
      <div class="title">$($_.title)</div>
    </a>
"@
    }) -join "`n"

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<link rel="icon" type="image/svg+xml" href="../favicon.svg" />
<meta property="og:title" content="$($p.title -replace '\.$','') &mdash; Coffey Residential &mdash; Journal" />
<meta property="og:description" content="$($p.ogdesc)" />
<meta property="og:type" content="article" />
<meta property="og:url" content="$baseUrl/journal/$($p.slug)" />
<meta property="og:image" content="$baseUrl/journal/img/$($p.image)" />
<meta property="og:site_name" content="Coffey Residential" />
<meta property="og:locale" content="en_GB" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:image" content="$baseUrl/journal/img/$($p.image)" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>$($p.title) &mdash; Coffey | Residential &mdash; Journal</title>
<meta name="description" content="$($p.ogdesc)" />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700&family=PT+Serif+Caption:ital@0;1&family=Work+Sans:ital,wght@0,300;0,400;0,500;1,400&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../styles.css">
<!-- seo:canonical+jsonld start -->
<link rel="canonical" href="$baseUrl/journal/$($p.slug)" />
<script type="application/ld+json">$schemaOrg</script>
<script type="application/ld+json">$articleSchema</script>
<script type="application/ld+json">$breadcrumb</script>
<!-- seo:canonical+jsonld end -->
</head>
<body>
<div class="shell">

<header class="site-header">
  <div class="brand">
    <img class="brand-mark" src="../images/webp/logo.webp" alt="" />
    <span class="eyebrow">London &nbsp;&middot;&nbsp; Est. 2005</span>
  </div>
  <a class="wordmark" href="../index.html">Coffey<span class="pipe">|</span>Residential</a>
  <nav class="site-nav right">
    <a href="../homes.html">Homes</a>
    <a href="../studio.html">Studio</a>
    <a href="../process.html">Process</a>
    <a href="../press.html">Awards &amp; Press</a>
    <a href="../journal.html" class="is-active">Journal</a>
    <a href="../contact.html">Contact</a>
  </nav>
</header>

<div class="article-meta-strip">
  <div>
    <a href="../journal.html">Journal</a>
    <span class="sep">/</span>
    <span>$($p.tag)</span>
    <span class="sep">/</span>
    <span class="now">$($p.title)</span>
  </div>
  <div>$($p.read)</div>
</div>

<section class="article-hero">
  <span class="eyebrow">$($p.tag) &nbsp;&middot;&nbsp; $($p.date)</span>
  <h1>$($p.title)</h1>
  <p class="deck">$($p.deck)</p>
  <div class="meta-row">
    <span>Words &middot; Phil Coffey</span>
    <span>&middot;</span>
    <span>$($p.read)</span>
  </div>
</section>

<figure class="article-lead-image">
  <img src="img/$($p.image)" alt="$($p.alt)" loading="lazy">
  <div class="meta">
    <span>Fig. 01</span>
    <span>$($p.caption)</span>
  </div>
</figure>

<section class="article-body">
$($p.body)
</section>

<section class="article-footer">
  <div class="article-footer__row">
    <div>
      <div class="by">Words by</div>
      <div class="name">Phil Coffey</div>
      <div class="role">Founder &middot; Coffey Residential</div>
    </div>
    <div class="share">
      <span>Share &middot; Copy link</span>
      <span>Email</span>
      <span>Print</span>
    </div>
  </div>
</section>

<section class="read-next">
  <div class="read-next__head">
    <h3>Read next</h3>
    <a class="more" href="../journal.html">All journal &rarr;</a>
  </div>
  <div class="read-next__grid">
$readNextCards
  </div>
</section>

<section class="cta">
  <div>
    <h2>Tell us about your house.</h2>
    <a class="cta-btn" href="../contact.html">Get in touch &nbsp;&rarr;</a>
  </div>
  <div class="cta__news">
    <span class="eyebrow">Newsletter</span>
    <p>Two letters a year. New work, recent writing.</p>
    <form class="form" onsubmit="event.preventDefault();">
      <input type="email" placeholder="email@address" required>
      <button type="submit">Subscribe &rarr;</button>
    </form>
  </div>
</section>

<footer class="site-footer">
  <div>Coffey Residential &nbsp;&middot;&nbsp; 104&ndash;110 Goswell Road, Clerkenwell, London EC1V 7DH</div>
  <div><a href="mailto:contact@coffeyresidential.com">contact@coffeyresidential.com</a></div>
  <div>&copy; 2026</div>
</footer>

</div><!-- /.shell -->
  <script src="../site.js" defer></script>
</body>
</html>
"@

    $outPath = Join-Path $root "journal\$($p.slug).html"
    Write-File $outPath $html
    Write-Host "  wrote: journal/$($p.slug).html"
}

Write-Host ""
Write-Host "Done. Wrote $($posts.Count) new journal articles."
