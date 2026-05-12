// Single project page — "Hampstead House" as the worked example.
// 1440-wide artboard. Follows the V6 / Homes index chassis.
//
// Sections, in order:
//   1. Sticky breadcrumb / project meta strip
//   2. Hero image (full-bleed within the 1280 cap)
//   3. Project facts strip (location, year, type, budget band, team)
//   4. Brief / narrative copy (two-column editorial)
//   5. Long-scroll gallery (alternating large + paired stills)
//   6. Plans & drawings (line-art on a soft panel)
//   7. Materials & makers list
//   8. Press the project received
//   9. Credits (photographer, contractor, structural, MEP)
//  10. Next / previous project navigation
//  11. Standard footer

const PROJECT_W = 1440;
const CAP = 1280;

// Worked example. Real copy can replace this later; the chassis is what matters.
const PROJECT = {
  n: '01',
  title: 'Hampstead House',
  loc: 'Hampstead, NW3',
  yr: '2024',
  tag: 'New Build',
  hero: 'images/01-hampstead-rear.jpg',
  blurb: 'A new family house on a sloping plot, replacing a 1960s villa that had outlived its arrangement. The brief asked for light, calm, and a garden that runs through the house rather than alongside it.',
  facts: [
    ['Location',    'Hampstead, NW3'],
    ['Year',        '2022 — 2024'],
    ['Type',        'New build · single dwelling'],
    ['Floor area',  '420 m²'],
    ['Budget band', 'Construction £2.5 — 3m'],
    ['Status',      'Complete'],
  ],
  brief: [
    'The site sloped a full storey from front to back. Rather than terrace the garden into the building, we cut the house into the slope so the lower ground floor opens directly onto a sunken courtyard, and the upper levels read as a single quiet volume from the street.',
    'The plan is organised around two stairs and a top-lit central spine. Materials are deliberately few: a buff London stock to the street, board-marked concrete in the courtyard, oak inside. The roof is a folded zinc form that picks up the geometry of the neighbouring mansards.',
    'The family wanted rooms that grow with their children, not rooms that need rearranging every few years. Bedrooms are smaller than convention; living rooms larger; the kitchen is the centre of gravity, with a window seat that catches the morning sun.',
  ],
  gallery: [
    { src: 'images/01-hampstead-rear.jpg',     cap: 'rear elevation, brick fins + black extension',  span: 'wide' },
    { src: 'images/05-capablanca-dining.jpg',  cap: 'dining room, rooflight + courtyard',            span: 'half' },
    { src: 'images/07-garden-lodge-kitchen.jpg', cap: 'kitchen island, north light',                 span: 'half' },
    { src: 'images/06-cove-ridge-living.jpg',  cap: 'first-floor living, blackened ceiling',         span: 'wide' },
    { src: 'images/08-island-home-detail.jpg', cap: 'detail — joinery + chromatic glazing',          span: 'third' },
    { src: 'images/04-apartment-bedroom.jpg',  cap: 'bedroom landing, oak + soft daylight',          span: 'third' },
    { src: 'images/02-ad-house-street.jpg',    cap: 'view from the street',                          span: 'third' },
  ],
  materials: [
    ['Façade',         'Buff London stock brick, hand-laid'],
    ['Roof',           'Standing-seam zinc, pre-weathered'],
    ['Joinery',        'European oak, rift-sawn — Cobbe & Sons'],
    ['Floors',         'Brushed oak boards, white oil finish'],
    ['Concrete',       'Board-marked in-situ, sandblasted soffits'],
    ['Glazing',        'Slim aluminium, anodised bronze — Maxlight'],
    ['Lighting',       'Custom brass surface fittings — Davey'],
    ['Kitchen',        'Stainless + oak, Vola tapware'],
    ['Stone',          'Honed Belgian bluestone, Hauteville for the bath'],
  ],
  press: [
    { src: 'House & Garden',   yr: '2024', line: 'A house that breathes with the garden' },
    { src: 'Dezeen',           yr: '2024', line: '"Cut into the slope, rather than placed on it"' },
    { src: 'The Sunday Times', yr: '2024', line: 'Inside a north London family home' },
  ],
  credits: [
    ['Architect',         'Coffey Residential'],
    ['Photographer',      'TBD — to insert'],
    ['Main Contractor',   'TBD — to insert'],
    ['Structural',        'TBD — to insert'],
    ['Services / MEP',    'TBD — to insert'],
    ['Landscape',         'TBD — to insert'],
    ['Joinery',           'Cobbe & Sons'],
    ['Planning',          'London Borough of Camden'],
  ],
  next: { n: '02', title: 'Garden Lodge',     img: 'images/07-garden-lodge-kitchen.jpg' },
  prev: { n: '09', title: 'Island Home',      img: 'images/08-island-home-detail.jpg'   },
};

// Reusable, narrow-margin section wrapper.
const Section = ({ children, palette, pad = '120px 56px', border = true, style = {} }) => (
  <section style={{
    padding: pad,
    borderBottom: border ? `1px solid ${palette.line}` : 'none',
    maxWidth: CAP, margin: '0 auto',
    ...style,
  }}>
    {children}
  </section>
);

const Mono = (props) => (
  <div {...props} style={{
    fontFamily: 'JetBrains Mono, ui-monospace, monospace',
    fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase',
    ...(props.style || {}),
  }} />
);

// ════════════════════════════════════════════════════════════════════════
// PROJECT PAGE
// ════════════════════════════════════════════════════════════════════════
function ProjectPage({ headlineFont, bodyFont, palette }) {
  const p = PROJECT;
  return (
    <div style={{ width: PROJECT_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* breadcrumb / meta strip */}
      <div style={{ maxWidth: CAP, margin: '0 auto', padding: '22px 56px', borderBottom: `1px solid ${palette.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <Mono style={{ color: palette.muted }}>
          <span style={{ color: palette.muted }}>Homes</span>
          <span style={{ margin: '0 10px', opacity: .4 }}>/</span>
          <span style={{ color: palette.fg }}>{p.title}</span>
        </Mono>
        <Mono style={{ color: palette.muted }}>{p.n} / 09 · {p.tag}</Mono>
      </div>

      {/* hero */}
      <section style={{ maxWidth: CAP, margin: '0 auto' }}>
        <Slot tone="bone" caption={p.blurb.slice(0,80)+'…'} height={760} src={p.hero} />
      </section>

      {/* title + lede, sitting under the hero */}
      <Section palette={palette} pad="80px 56px 100px">
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80, alignItems: 'flex-end' }}>
          <div>
            <Mono style={{ color: palette.muted, marginBottom: 24 }}>{p.tag} · {p.yr}</Mono>
            <h1 style={{ fontFamily: headlineFont, fontSize: 88, lineHeight: 0.98, fontWeight: 400, margin: 0, letterSpacing: '-0.03em' }}>{p.title}</h1>
            <div style={{ fontSize: 16, color: palette.muted, marginTop: 14 }}>{p.loc}</div>
          </div>
          <p style={{ fontFamily: headlineFont, fontSize: 22, lineHeight: 1.45, fontStyle: 'italic', margin: 0, color: palette.fg, maxWidth: 500, justifySelf: 'end' }}>
            {p.blurb}
          </p>
        </div>
      </Section>

      {/* facts strip — 6 cells */}
      <Section palette={palette} pad="0">
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)' }}>
          {p.facts.map(([l,v],i) => (
            <div key={l} style={{
              padding: '28px 24px',
              borderRight: i < 5 ? `1px solid ${palette.line}` : 'none',
              borderTop: `1px solid ${palette.line}`,
              borderBottom: `1px solid ${palette.line}`,
            }}>
              <Mono style={{ color: palette.muted, marginBottom: 12 }}>{l}</Mono>
              <div style={{ fontFamily: headlineFont, fontSize: 18, letterSpacing: '-0.01em', lineHeight: 1.25 }}>{v}</div>
            </div>
          ))}
        </div>
      </Section>

      {/* brief / narrative */}
      <Section palette={palette} pad="120px 56px">
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <Mono style={{ color: palette.muted, marginBottom: 16 }}>The brief</Mono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>A house cut into the slope.</h2>
          </div>
          <div style={{ columnCount: 2, columnGap: 48, maxWidth: 880 }}>
            {p.brief.map((para, i) => (
              <p key={i} style={{ fontSize: 16, lineHeight: 1.7, margin: '0 0 1.2em', breakInside: 'avoid' }}>{para}</p>
            ))}
          </div>
        </div>
      </Section>

      {/* gallery — long scroll, mixed rhythm */}
      <Section palette={palette} pad="0 56px 80px" border={false}>
        <Mono style={{ color: palette.muted, padding: '60px 0 24px' }}>Gallery · 12 images</Mono>

        {/* row 1 — single wide image */}
        <Slot tone="bone" caption={p.gallery[0].cap} height={720} src={p.gallery[0].src} />

        {/* row 2 — two side by side */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 3, marginTop: 3 }}>
          <Slot tone="bone" caption={p.gallery[1].cap} height={520} src={p.gallery[1].src} />
          <Slot tone="bone" caption={p.gallery[2].cap} height={520} src={p.gallery[2].src} />
        </div>

        {/* pull-quote between gallery groups */}
        <div style={{ padding: '120px 0', textAlign: 'center', maxWidth: 880, margin: '0 auto' }}>
          <p style={{ fontFamily: headlineFont, fontSize: 36, lineHeight: 1.25, fontStyle: 'italic', margin: 0, letterSpacing: '-0.01em' }}>
            "The light is what we notice most. It moves through the rooms like it was designed for it — because it was."
          </p>
          <Mono style={{ color: palette.muted, marginTop: 24 }}>Client</Mono>
        </div>

        {/* row 3 — another wide */}
        <div style={{ marginTop: 3 }}>
          <Slot tone="bone" caption={p.gallery[3].cap} height={720} src={p.gallery[3].src} />
        </div>

        {/* row 4 — three details */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 3, marginTop: 3 }}>
          <Slot tone="bone" caption={p.gallery[4].cap} height={420} src={p.gallery[4].src} />
          <Slot tone="bone" caption={p.gallery[5].cap} height={420} src={p.gallery[5].src} />
          <Slot tone="bone" caption={p.gallery[6].cap} height={420} src={p.gallery[6].src} />
        </div>
      </Section>

      {/* plans & drawings */}
      <Section palette={palette} pad="120px 56px" style={{ background: palette.softBg || palette.bg }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 48 }}>
          <div>
            <Mono style={{ color: palette.muted, marginBottom: 16 }}>Plans & drawings</Mono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Three floors, two stairs.</h2>
          </div>
          <Mono style={{ color: palette.muted }}>1 : 200</Mono>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16 }}>
          {['Lower ground', 'Ground floor', 'First floor'].map((lvl, i) => (
            <div key={lvl}>
              {/* line-drawing placeholder — schematic floor plan */}
              <div style={{ aspectRatio: '1 / 1.1', position: 'relative', background: palette.bg, border: `1px solid ${palette.line}` }}>
                <svg viewBox="0 0 200 220" style={{ width: '100%', height: '100%', display: 'block' }} stroke={palette.fg} strokeWidth="0.6" fill="none">
                  {/* outer wall */}
                  <rect x="20" y="20" width="160" height="180" />
                  {/* internal walls — varies by level for the illusion */}
                  {i === 0 && <>
                    <line x1="20" y1="110" x2="180" y2="110" />
                    <line x1="100" y1="20" x2="100" y2="110" />
                    <line x1="80" y1="110" x2="80" y2="200" />
                    <rect x="120" y="130" width="50" height="60" />
                    <line x1="20" y1="60" x2="60" y2="60" />
                  </>}
                  {i === 1 && <>
                    <line x1="20" y1="90" x2="180" y2="90" />
                    <line x1="120" y1="20" x2="120" y2="90" />
                    <line x1="60" y1="90" x2="60" y2="200" />
                    <line x1="130" y1="90" x2="130" y2="200" />
                    <rect x="70" y="120" width="50" height="20" />
                    <line x1="130" y1="150" x2="180" y2="150" />
                  </>}
                  {i === 2 && <>
                    <line x1="20" y1="120" x2="180" y2="120" />
                    <line x1="90" y1="20" x2="90" y2="120" />
                    <line x1="70" y1="120" x2="70" y2="200" />
                    <line x1="130" y1="120" x2="130" y2="200" />
                    <line x1="40" y1="50" x2="90" y2="50" />
                  </>}
                  {/* stair indicators */}
                  <g stroke={palette.muted} strokeWidth="0.4">
                    {[...Array(6)].map((_,k) => (
                      <line key={k} x1="40" y1={140+k*8} x2="56" y2={140+k*8} />
                    ))}
                  </g>
                </svg>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 12 }}>
                <Mono style={{ color: palette.muted }}>{lvl}</Mono>
                <Mono style={{ color: palette.muted }}>{['LG.0','GF.0','01.0'][i]}</Mono>
              </div>
            </div>
          ))}
        </div>
      </Section>

      {/* materials */}
      <Section palette={palette} pad="120px 56px">
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <Mono style={{ color: palette.muted, marginBottom: 16 }}>Materials & makers</Mono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>What it's made of.</h2>
          </div>
          <div>
            {p.materials.map(([l,v],i) => (
              <div key={l} style={{ display: 'grid', gridTemplateColumns: '180px 1fr', padding: '18px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
                <Mono style={{ color: palette.muted }}>{l}</Mono>
                <div style={{ fontSize: 15 }}>{v}</div>
              </div>
            ))}
          </div>
        </div>
      </Section>

      {/* press */}
      <Section palette={palette} pad="120px 56px">
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <Mono style={{ color: palette.muted, marginBottom: 16 }}>Press</Mono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Where it appeared.</h2>
          </div>
          <div>
            {p.press.map((pr,i) => (
              <a key={i} style={{ display: 'grid', gridTemplateColumns: '180px 1fr 80px', padding: '24px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline', color: palette.fg, textDecoration: 'none' }}>
                <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 18 }}>{pr.src}</div>
                <div style={{ fontSize: 16 }}>{pr.line}</div>
                <Mono style={{ color: palette.muted, textAlign: 'right' }}>{pr.yr} →</Mono>
              </a>
            ))}
          </div>
        </div>
      </Section>

      {/* credits */}
      <Section palette={palette} pad="120px 56px">
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <Mono style={{ color: palette.muted, marginBottom: 16 }}>Credits</Mono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>The people who made it.</h2>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '0 48px' }}>
            {p.credits.map(([l,v],i) => (
              <div key={l} style={{ padding: '18px 0', borderTop: `1px solid ${palette.line}` }}>
                <Mono style={{ color: palette.muted, marginBottom: 6 }}>{l}</Mono>
                <div style={{ fontSize: 15 }}>{v}</div>
              </div>
            ))}
          </div>
        </div>
      </Section>

      {/* next / prev navigation — full bleed, two big tiles */}
      <section style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 3, borderTop: `1px solid ${palette.line}`, borderBottom: `1px solid ${palette.line}` }}>
        {[['Previous', p.prev],['Next', p.next]].map(([dir, proj], i) => (
          <a key={dir} style={{
            position: 'relative', minHeight: 360, color: palette.fg, textDecoration: 'none',
          }}>
            <Slot tone="bone" caption={proj.title} height={360} src={proj.img} />
            <div style={{ position: 'absolute', inset: 0, padding: '40px 56px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', color: '#fff', background: 'linear-gradient(180deg, rgba(0,0,0,.05) 0%, rgba(0,0,0,.45) 100%)' }}>
              <Mono>{dir === 'Previous' ? '← Previous' : 'Next →'}</Mono>
              <div>
                <Mono style={{ marginBottom: 8, opacity: .8 }}>{proj.n} / 09</Mono>
                <div style={{ fontFamily: headlineFont, fontSize: 48, letterSpacing: '-0.02em', lineHeight: 1 }}>{proj.title}</div>
              </div>
            </div>
          </a>
        ))}
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { ProjectPage });
