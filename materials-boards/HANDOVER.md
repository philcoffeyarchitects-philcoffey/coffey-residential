# Materials boards — handover for the website integration

This document is the spec Claude Code should read before wiring the per-project materials boards into the Coffey Residential site.

## What's here

For each of the 20 Coffey Residential projects, the `Materials boards/{slug}/` folder contains:

- `materials-board_clean.jpg` — the AI-generated overhead flat-lay (1:1, 2048×2048, ~600–880 KB, JPG q92).
- `materials-board.jpg` — the same image with small numbered circles overlaid at the top-right of each sample. **First commit: not yet present. Fall back to `materials-board_clean.jpg` if missing.** Second commit will add this file alongside the clean one.
- `materials.json` — the per-project data file (schema below).

At the top of `Materials boards/`:

- `_index.json` — discovery index mapping every slug to its folder and asset paths. Use this for batch discovery rather than directory walking.
- `HANDOVER.md` — this file.

## Project slugs

Slugs match the existing project HTML filenames in `pages-html/` (without `.html`). Twenty projects covered:

`ad-house-york`, `apartment-block-clerkenwell`, `arch-study-notting-hill`, `canyon-house-clerkenwell`, `capablanca-house-barnsbury`, `cove-ridge-devon`, `folded-house-islington`, `garden-lodge-harpenden`, `helios-house-white-city`, `hidden-house-clerkenwell`, `island-home-shoreditch`, `kitchen-garden-maida-vale`, `meadow-grove-barnes`, `modern-barn-devon`, `modern-detached-harpenden`, `modern-mews-paddington`, `modern-side-extension`, `modern-terrace-islington`, `sky-house-camden`, `well-house-islington`.

`step-house-canada-water` is **not** covered — there are no project images in the source folder yet. Skip it from any auto-discovery loop, or fall through to "materials board coming soon".

## materials.json schema

```json
{
  "project_slug": "arch-study-notting-hill",
  "project_name": "Arch Study, Notting Hill",
  "board_image": "materials-board.jpg",
  "board_image_clean": "materials-board_clean.jpg",
  "ground": "warm-white painted timber",
  "generated": "2026-05-17",
  "numbering_pass": "pending",
  "materials": [
    {
      "id": 1,
      "name": "Pale rift-cut European oak",
      "use": "Dominant joinery",
      "category": "Timber"
    },
    {
      "id": 2,
      "name": "Walnut (or fumed oak)",
      "use": "Lower kitchen cabinetry",
      "category": "Timber"
    }
  ]
}
```

**Field notes:**

- `id` is the number that will appear on `materials-board.jpg`. Ordering for first commit is canonical (dominant material first, then complementary). The numbered overlay arriving in the second commit will preserve this ordering — i.e. the circle marked `1` corresponds to materials.json `id: 1`. Use `numbering_pass: "complete"` as the marker that the labelled image is in sync.
- `name` is the descriptive material name (specific where possible — e.g. "Fluted travertine" not just "stone").
- `use` is a one-line description of what the material does in the project.
- `category` is one of: `Timber`, `Stone`, `Metal`, `Tile`, `Plaster`, `Fabric`, `Leather`, `Glass`, `Other`. Useful if you want to group materials visually in the key.

## _index.json schema

```json
{
  "generated": "2026-05-17",
  "numbering_pass": "pending",
  "count": 20,
  "projects": [
    {
      "project_slug": "ad-house-york",
      "project_name": "AD House, York",
      "folder": "ad-house-york",
      "materials_json": "ad-house-york/materials.json",
      "board_image": "ad-house-york/materials-board.jpg",
      "board_image_clean": "ad-house-york/materials-board_clean.jpg",
      "material_count": 8
    }
  ]
}
```

Use `_index.json` for batch discovery. The project loader's recommended pattern is:

1. Read `_index.json` once at build time.
2. For each project page, match its slug to the index entry; if present, load `materials.json`.
3. If the labelled `board_image` path doesn't exist on disk, fall back to `board_image_clean`.

## Reference HTML snippet

Semantic markup with an `<ol>` for the key so screen readers announce the numbering correctly. The numbers in the `<ol>` will line up with the numbered circles on the board image once the second pass commits.

```html
<section class="materials-board" aria-labelledby="materials-board-heading">
  <h2 id="materials-board-heading">Materials</h2>

  <div class="materials-board__layout">
    <figure class="materials-board__image">
      <img src="/Materials%20boards/arch-study-notting-hill/materials-board.jpg"
           alt="Overhead flat lay of eight material samples from Arch Study, Notting Hill — pale oak, walnut, fluted travertine, honed travertine, reclaimed London stock brick, cognac saddle leather, blackened bronze and aged brass — arranged on a soft warm-white painted-timber surface."
           loading="lazy"
           width="2048" height="2048" />
    </figure>

    <ol class="materials-board__key" aria-label="Materials key">
      <li><span class="materials-board__name">Pale rift-cut European oak</span>
          <span class="materials-board__use">Dominant joinery</span></li>
      <li><span class="materials-board__name">Walnut (or fumed oak)</span>
          <span class="materials-board__use">Lower kitchen cabinetry</span></li>
      <!-- … one <li> per material in order … -->
    </ol>
  </div>
</section>
```

`<ol>` is the correct element because the numbers in the key are meaningful — they reference the circles on the image. Don't use `<ul>` and don't render the numbers as text inside each `<li>` (let the browser do it via list-style-position).

## Reference React snippet

```jsx
import materialsBoardIndex from '/Materials boards/_index.json';

async function loadMaterialsBoard(slug) {
  const entry = materialsBoardIndex.projects.find(p => p.project_slug === slug);
  if (!entry) return null;
  const data = await fetch(`/Materials boards/${entry.materials_json}`).then(r => r.json());
  return { ...data, _index: entry };
}

function MaterialsBoard({ data }) {
  if (!data) return null;
  const { project_name, materials, board_image, board_image_clean } = data;

  return (
    <section className="materials-board" aria-labelledby="mb-heading">
      <h2 id="mb-heading">Materials — {project_name}</h2>
      <div className="materials-board__layout">
        <figure className="materials-board__image">
          <img
            src={`/Materials boards/${board_image}`}
            onError={(e) => { e.currentTarget.src = `/Materials boards/${board_image_clean}`; }}
            alt={`Overhead flat lay of ${materials.length} material samples from ${project_name}`}
            loading="lazy"
          />
        </figure>
        <ol className="materials-board__key" aria-label="Materials key">
          {materials.map(m => (
            <li key={m.id}>
              <span className="materials-board__name">{m.name}</span>
              <span className="materials-board__use">{m.use}</span>
              <span className="materials-board__category">{m.category}</span>
            </li>
          ))}
        </ol>
      </div>
    </section>
  );
}
```

The `onError` fallback handles the first-commit / second-commit split: if `materials-board.jpg` isn't on disk yet, the browser falls back to the clean version automatically.

## Responsive behaviour

- **Desktop (≥ 960 px):** image left, key right. Image scales to about 50–60% column width; key takes the rest. The numbered circles need to be readable on the image, so the image shouldn't drop below ~480 px wide.
- **Tablet (640–960 px):** image stacked above key, both full-width. Image caps around 600 px.
- **Mobile (< 640 px):** image stacked above key. Image full bleed (edge-to-edge) is fine for editorial feel. The key reads as a plain `<ol>` below.

Suggested CSS:

```css
.materials-board__layout {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}
@media (min-width: 960px) {
  .materials-board__layout {
    grid-template-columns: minmax(0, 1.2fr) minmax(0, 1fr);
    gap: 2.5rem;
    align-items: start;
  }
}
.materials-board__image img {
  width: 100%;
  height: auto;
  display: block;
}
.materials-board__key {
  list-style-position: outside;
  padding-left: 1.5rem;
  margin: 0;
  font-family: 'PT Serif', serif;
}
.materials-board__key li {
  margin-bottom: 0.75rem;
  break-inside: avoid;
}
.materials-board__name {
  display: block;
  font-weight: 500;
}
.materials-board__use {
  display: block;
  font-size: 0.875em;
  color: var(--muted, #6b6b6b);
}
.materials-board__category {
  display: block;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.75em;
  color: var(--muted, #6b6b6b);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
```

## Grouping by category

The `category` field is provided in case you want to group materials visually in the key (e.g. all Timbers together, then all Stones). Useful when a project has 8 samples with 3+ timbers. **Default rendering should keep the canonical order from materials.json** so the numbers stay sequential — only switch to grouped layout if the project has 4+ samples in a single category, or if Phil asks for it. If you do group, render section headings inside the `<ol>` using `<li role="presentation">` so the numbering still increments correctly.

## Categories used across the 20 boards

`Timber`, `Stone`, `Metal`, `Tile`, `Plaster`, `Fabric`, `Leather`, `Glass`, `Other`.

`Other` is used for "composite" materials that don't fit one of the above — painted brick (where the paint is the finish), shou-sugi-ban (charred timber sits between Timber and a treated finish), serrated brick (the relief profile is the point), MDF-lacquered joinery, painted accents, rice-paper screens, etc. Treat `Other` as a normal category in the UI — don't special-case it.

## Two-commit plan

This handover represents the **first commit**: `materials-board_clean.jpg` and `materials.json` per project, plus `_index.json` and this file. Both `numbering_pass` keys in the JSONs are set to `"pending"`.

The **second commit** will add `materials-board.jpg` per project (the same image with numbered circles overlaid) and flip `numbering_pass` to `"complete"` in both `_index.json` and each `materials.json`. Until that lands, the React snippet above falls back to the clean image automatically.

## Provenance & regeneration

- Boards were generated using Higgsfield's Nano Banana 2 Pro model at 2k resolution, 1:1, on 17 May 2026.
- The eight materials per project were curated by reading 3–5 strongest interior photographs per project from `coffey-residential/images/`, identifying real, specific finishes (e.g. fluted travertine, end-grain oak block, perforated brass screen, board-marked concrete).
- If you need to regenerate any single board, the source prompts and Higgsfield job IDs are recorded in `coffey-residential/Ads/_generation-log.json` (or in the agent session for the materials-board run).
- Step House Canada Water has no project photography in the source folder — it's deliberately excluded. When photography lands, regenerate using the same workflow.
