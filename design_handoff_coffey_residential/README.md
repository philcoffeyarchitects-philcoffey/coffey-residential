# Handoff: Coffey Residential — Full Website Rebuild

## Overview

Replace the studio's existing Squarespace site with a fast, SEO-optimised, custom-built website for **Coffey Residential** — a London-based, RIBA-accredited residential architecture practice founded 2005 by Phil Coffey.

The studio's current site is slow and feels tired. This rebuild delivers a calm, editorial, photography-led design across seven page templates, with a clear path to ranking for "residential architects London" and adjacent terms.

The design comps live in this handoff as a single React/Babel canvas (`Coffey Residential.html` opens 12 artboards at 1440×N each). Ship them as a proper site.

---

## About the design files

**The HTML files in this bundle are design references — not production code.** They are React-in-the-browser prototypes built on a pan/zoom design canvas; do not copy the JSX directly into a real codebase.

**Your task:** recreate these designs pixel-perfectly in a production-grade framework. The studio's existing site is Squarespace, so there is no codebase to slot into — choose the framework. **Recommended: Astro** (content-led, MDX-friendly, statically rendered, excellent Core Web Vitals, easy CMS integration). Alternatives: Next.js (app router) if a more dynamic future is wanted, or Eleventy if the studio prefers something simpler.

CMS recommendation: **Sanity** or **Payload** for projects/journal entries; both let Phil write entries without touching code.

---

## Fidelity

**Hi-fi.** Colors, typography, spacing, photography placement and copy are all final-direction. Recreate exactly. Where you see a placeholder ("portrait — Phil Coffey", "section study — six houses"), that is real content the studio will provide later — leave a clean slot in the data model for it.

---

## Brand & design tokens

### Type system

| Role | Family | Notes |
|---|---|---|
| **Headlines / display** | **Editorial New** (commercial) *or* **Cormorant Garamond** (free fallback) | Regular weight only. Italic used for the second line of split headlines. Letter-spacing `-0.02em` to `-0.035em` at large sizes. |
| **Body** | **Söhne** (commercial) *or* **Inter Tight** / system sans (free fallback) | 14–17px. Line-height 1.55–1.75. |
| **Labels / meta** | **JetBrains Mono** | 10–11px, `letter-spacing: .14em`, `text-transform: uppercase`. Used for `Mono` component across every page. |

Headline sizes used: 120 / 88 / 72 / 56 / 48 / 36 / 32 / 28 / 24 / 22 / 20 / 18.
Body sizes: 17 / 16 / 15 / 14 / 13 / 12.5.

### Color palette ("bone" — the production palette)

| Token | Hex | Usage |
|---|---|---|
| `bg` | `#f6f3ec` | Page background — warm bone |
| `fg` | `#1a1916` | Primary text, headline, dark CTA fill |
| `muted` | `#8a8478` | Mono labels, captions, secondary copy |
| `line` | `#d8d2c4` | All hairlines (1px) between sections, table rows, cards |
| `cta` | `#1a1916` | "Tell us about your house" footer panel background |
| `ctaFg` | `#f6f3ec` | Text on CTA panel |
| `softBg` | `#efe9df` | Optional soft panel (used on Plans & Drawings) |

The five homepage variations expose other palettes via tweaks (cinematic dark `#0e0d0b`/`#e9e3d4`; warm asymmetric, etc.) — **lock the production site to the bone palette unless Phil chooses otherwise**.

### Spacing

- Content cap: **1280px** centred in a **1440px** artboard with 56px gutters either side
- Section vertical rhythm: **120px** / **140px** top + bottom padding for major sections
- Inner stacks: 24 / 32 / 48 / 64 / 80 px
- Grid gaps: 0 (touching), 3 (image gutters on Project gallery), 16, 24, 32, 48, 80

### Hairlines, borders, radii

- Every horizontal separator is **`1px solid var(--line)`**
- Cards and table rows use top-and-bottom border treatment, no surrounding box
- **No border-radius** on cards or images (radius is only used on filter chips: `border-radius: 999px`)
- **No shadows anywhere**. The aesthetic is matte, papery, editorial
- Image gutters between adjacent photos on the Project gallery use 3px of page-background as a thin separator line (no border)

### Layout patterns repeated across pages

- **Section-headed two-column** (280px label / 1fr content) — used for Brief, Materials, Press, Credits, Philosophy, FAQ, Fees, Press kit
- **Filter chip row** — pill chips left, mono sort label right, sitting on a 1px-line bordered strip
- **Stat strip** — `repeat(4, 1fr)` grid, cells separated by vertical 1px lines, with a Mono label / 32–40px figure / 12px sub-label
- **Section header pattern** — Mono kicker, then big display headline with italic split on the second line (`<div>Word.</div><div style="font-style:italic">Italic.</div>`)
- **Year-grouped lists** (Press, Awards, Journal index) — big serif year on the left, rows on the right

---

## Pages / templates

The canvas has 12 artboards across 8 sections. **7 unique templates** to build.

### 1. Homepage — 5 variations

Five complete homepage designs are on the canvas. The studio will pick one (or one to lead from). Each shares: header nav, hero, featured projects, awards, journal teaser, footer.

| Variation | Direction |
|---|---|
| V1 Editorial Classic | Photography-led, big serif headlines, project index below the hero |
| V2 Quiet Type-led | Type-heavy, image-light, single hero photo, calm |
| V3 Cinematic Dark | Inverted palette, full-bleed imagery, gallery-style |
| V4 Warm Asymmetric | Off-grid layout, paired large/small images, casual confidence |
| V5 Modern Index | List-led, tabular project index with hover image, almost archive-like |

Plus a sixth **V6 — Homes index** lays out all 9 projects in a single grid (the "/homes" route after the homepage).

**Live tweaks panel** controls: headline font, body font, hero media (image / video / type-only), palette, project density, copy tone. Ship the chosen direction as the default — the tweaks are for the design phase, not the live site.

### 2. Project page

Single-project template. Worked example: **Hampstead House**. Sections in order:

1. Breadcrumb (Homes / project name) + index counter (01 / 09)
2. Hero image (full image inside the 1280 cap, 760px tall)
3. Title block — 88px serif title left, italic lede right, location subtitle
4. Facts strip — 6 cells: Location · Year · Type · Floor area · Budget band · Status
5. Brief — left label "The brief" + 36px headline; right 2-column body copy
6. Gallery — long scroll, mixed rhythm: 1-wide → 2-up → pull-quote → 1-wide → 3-up. **3px page-bg gutters** between adjacent images.
7. Plans & drawings — 3 schematic floor plans on soft panel. Currently SVG placeholders — replace with real GAs.
8. Materials & makers — labelled list, side-headed
9. Press for this project — italic source / headline / year-arrow rows
10. Credits — 2-column table
11. Next / Previous — full-bleed paired image tiles linking to neighbouring projects, 3px gutter
12. Standard CTA panel + footer

### 3. Studio page

1. Type-only header — "A small studio, / one house at a time." (italic split)
2. Phil section — portrait left, principal blurb + pull-quote right
3. Philosophy — large 32px editorial single column
4. Values — 4 numbered cards (I–IV): *Quiet over loud · Light is the brief · Detail at one-to-one · The same people, all the way*
5. Team grid — role-led 3-col grid with portrait slots
6. Studio facts strip — Founded · Houses · Awards · Location
7. Journal teaser — 3 recent essays
8. Footer

### 4. Process page

1. Header — "From the first conversation / to the second year in."
2. Timeline strip — 8 stages laid out left-to-right with proportional widths (Stage 06 "On site" is by far the longest), dots on a baseline, duration under each
3. Summary grid — 4×2 cards, one per stage
4. Stage-by-stage detail — 8 rows, each split into *Deliverables · From you · From us*
5. Fees — fixed feasibility + percentage after, 3-card breakdown
6. FAQ — 6 Q&A rows
7. Footer

Stages: *00 First conversation · 01 Brief & feasibility · 02 Concept design · 03 Planning · 04 Developed design · 05 Tender & contract · 06 On site · 07 Handover & after*

### 5. Press & Awards page

1. Header — "The work, / through other voices."
2. Filter chips (All / Print / Online / Awards / Studio)
3. Stat strip — RIBA Awards · Recent recognition · Press placements · Outlets
4. Awards table — Year / Body / Project / Category / Status. Winners get a filled-black tag; shortlist/finalist outlined
5. Press list — grouped under big serif year headings (2025 / 2024 / 2023 / 2022)
6. "As featured in" wall — 12 outlet names in editorial italic in a 4-col grid
7. Press kit — downloadables (PDFs, JPGs, ZIPs) + press contact
8. Footer

### 6. Journal — 2 templates

**Index:**
1. Header — "Notes from / the drawing board."
2. Tag chips + RSS / newsletter
3. Lead article — image left, 56px title + italic deck + author right
4. Grid — 8 entries in 3-col layout
5. Newsletter signup — underlined input
6. Footer

**Article:**
1. Breadcrumb (Journal / Tag / Title)
2. Centred title block — narrow 820px column, 72pt title, italic deck, byline
3. Lead image with Fig.01 caption
4. Body in narrow 680px column with **drop cap** on first paragraph, italic blockquote with top/bottom 1px borders, in-body figure with Fig.02 caption
5. Author footer + share row
6. Read next — 3 more entries
7. Footer

### 7. Contact page

1. Header — "Tell us about / your house."
2. Quick contacts strip — 4 cells (New work / Press / Careers / Phone)
3. Enquiry form — sticky left label, form right, broken into §01–§05:
   - §01 About you (name, email, phone, preferred contact)
   - §02 The project (location, type chips, budget chips, timeline chips)
   - §03 In your own words (multi-line)
   - §04 Attachments (drag-drop, 25 MB cap)
   - §05 How you found us (chips)
   - Submit row with privacy + "Send enquiry →" button
4. Studio block — address + schematic SVG map of Clerkenwell with pin
5. Transport strip — 4 cells (nearest tubes, cycle route)
6. "Before you send" — 3 Q&A cards
7. Footer

---

## Persistent UI elements

### Top navigation (used on every page)

3-column grid: `1fr auto 1fr`. Left: location/establishment label in Mono. Centre: wordmark `Coffey | Residential` (the `|` is a low-opacity separator at 35% with 8px margin either side). Right: nav links — Homes · Studio · Process · Press · Journal · Contact. Active route is underlined with `text-underline-offset: 6px`; inactive routes are muted.

24px vertical padding, 56px horizontal, bottom 1px line.

### CTA panel (used as the second-to-last block on every page)

Full-bleed dark panel, 120px vertical padding, 56px horizontal. 1.5fr / 1fr grid. Left: 56px serif "Tell us about your house." Right (bottom-aligned): `contact@coffeyresidential.com` in muted 13px.

### Footer (used on every page)

10px Mono row, 32px padding, three columns: address · email · © year.

---

## Interactions & behaviour

- **Hover** on project tiles: cursor → pointer, slight image scale (1.02 over 400ms ease-out) — optional, the design is restrained enough to work static
- **Filter chips**: click toggles active state; chip with `bg: fg` is active. On a real site, filter URL: `/homes?type=new-build&loc=london`
- **Project page next/prev**: prefetch on hover, soft fade transition (200ms)
- **Form submission**: POST to a server route, success state replaces the form with a thank-you card in the same outline-input style
- **Journal**: tag chips filter the index. Article slug routing.
- **All page nav transitions**: cross-fade body, header persists. Astro view transitions are perfect for this.
- **No fancy animation library needed.** The aesthetic is calm. CSS transitions only.

---

## Photography & assets

The studio has a folder of real project photography (originally in `uploads/`, mapped to `images/` in the design files):

- `01-hampstead-rear.jpg`
- `02-ad-house-street.jpg`
- `03-apartment-block-floor.png`
- `04-apartment-bedroom.jpg`
- `05-capablanca-dining.jpg`
- `06-cove-ridge-living.jpg`
- `07-garden-lodge-kitchen.jpg`
- `08-island-home-detail.jpg`

For production: **serve via a CDN with responsive `srcset`**, AVIF + WebP fallbacks, and a low-quality placeholder while the full image loads. Sharp / Astro Image / next/image — pick the right tool for the framework.

The Slot component in the designs (see `parts.jsx`) shows either a real image or a striped placeholder. Replace with proper `<picture>` markup.

---

## SEO requirements (this was the studio's #1 ask)

Target: rank for **"residential architects London"** and adjacent terms.

Implementation checklist for the developer:

- **Server-render every page.** Static generation via Astro is ideal — every project page, journal entry and studio page is a separate URL with crawlable HTML.
- **Page titles & meta descriptions** — per-page, written by Phil through the CMS. Default pattern: `{Project title} · Coffey Residential — Residential Architects London`.
- **JSON-LD structured data**:
  - `Organization` schema on every page (name, logo, address, telephone, sameAs links)
  - `LocalBusiness` schema on Contact page (geo coords for the Goswell Road studio)
  - `Article` schema on Journal entries
  - `CreativeWork` or custom schema on Project pages
- **`/sitemap.xml`** auto-generated from routes
- **`/robots.txt`** allowing all crawlers
- **OpenGraph + Twitter card** images per page — use the lead project image
- **Semantic HTML**: every page has exactly one `<h1>`, headings cascade properly, nav is in `<nav>`, primary content in `<main>`, footer in `<footer>`
- **Image alt text** — required field in the CMS, never optional
- **Core Web Vitals targets**: LCP < 2.0s, INP < 200ms, CLS < 0.05 (this is why we're not using Next.js client components for content)
- **Schema for awards**: list them on the Press page with proper `Award` markup
- **Local SEO**: register Google Business Profile, NAP consistency (Name / Address / Phone) — Address shows on Contact, in footer, in JSON-LD

---

## Content model (CMS shape)

```
Project {
  slug, title, location, year, type (new-build|whole-house|extension|refurb),
  floorArea, budgetBand, status, heroImage,
  blurb, brief (rich text),
  galleryImages[] {src, caption, span},
  materials[] {label, value},
  press[] {source, year, headline, url},
  credits[] {role, name},
  facts[] {label, value},
  seo {title, description, ogImage},
  next, prev (auto-computed by year)
}

JournalEntry {
  slug, title, deck, tag (essay|process|field|materials),
  publishedAt, readTime, author, leadImage,
  body (rich text with figure + blockquote support),
  seo
}

Award {
  year, body, title, category, status (winner|shortlist|finalist|listed)
}

PressPlacement {
  year, month, source, kind (print|online), project, headline, url
}

Page (singletons) {
  studio { heroCopy, philIntro, philQuote, philBio, philosophy, values[] {n, t, d}, team[] {role, name, short, portrait} }
  process { intro, stages[] {n, t, dur, fee, oneLine, deliverables[], fromYou, fromUs }, fees, faq[] }
  contact { intro, quickContacts[], studioAddress, hours, transport[], beforeYouSend[] }
}
```

---

## Files in this handoff

```
Coffey Residential.html      Main canvas — open this to see all 12 artboards
design-canvas.jsx            Pan/zoom canvas component (design-time only)
tweaks-panel.jsx             Tweaks shell (design-time only)
parts.jsx                    Shared HomesNav, HomesFooter, Slot, StripeBg, FilterRow
homes.jsx                    Homes-index template
project.jsx                  Project template (Hampstead House)
studio.jsx                   Studio template
process.jsx                  Process template
press.jsx                    Press & Awards template
journal.jsx                  Journal index + article templates
contact.jsx                  Contact template
variations.jsx               5 homepage variations + V6 homes index
images/                      Real project photography (8 files)
```

Open `Coffey Residential.html` to see everything in one canvas. Drag to pan, scroll to zoom. Each artboard has a "focus" button to view it fullscreen.

---

## What's NOT in this handoff (open questions for Phil + the developer)

- Real team names beyond Phil — currently placeholder initials
- Real press list, awards roster, fees, durations
- Real photographer credits per project
- Real plans/sections for the Project page (currently SVG placeholders)
- Mobile breakpoints — the design is desktop-first at 1440. Mobile rules: stack 2-col → 1-col, reduce 120px section padding → 64px, headline sizes 120 → 56 / 88 → 44, drop the sticky sidebar on Contact form to inline labels
- The studio's logo/wordmark is currently set in the headline serif; if they want a custom wordmark they need to commission one
- Cookie banner / privacy policy text — required for UK GDPR
- Domain transfer from Squarespace, redirect map for old URLs (Squarespace URLs → new clean URLs)

---

## Suggested implementation order

1. Set up Astro + Tailwind + chosen CMS, build the design tokens as CSS variables / Tailwind config
2. Build the shared chrome (HomesNav, HomesFooter, CTA panel) as components
3. Build the **Project** template first — it's the most complex layout and unlocks the rest
4. Build the **Homes index** + chosen homepage variation
5. Studio, Process, Press, Journal index, Contact — they reuse the section-headed two-column pattern repeatedly
6. Journal article template
7. SEO pass: JSON-LD, sitemap, OG images, semantic audit
8. Lighthouse + WebPageTest pass — target 95+ on every metric
9. Migrate content from Squarespace into the CMS
10. Set up redirects, switch DNS, monitor 404s for a fortnight
