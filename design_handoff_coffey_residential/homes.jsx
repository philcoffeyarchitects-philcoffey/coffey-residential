// Homes index page — three variations.
// Each is a 1440-wide artboard following the V6 Editorial Hybrid chassis
// (same nav, footer, type system) but presenting the projects differently.

const HOMES_W = 1440;

// Extended project set so the index has weight. Same shape as PROJECTS.
const HOMES_PROJECTS = [
  ...PROJECTS,
  { n: '07', title: 'Highgate Cottage',     loc: 'Highgate, N6',       yr: '2021', tag: 'Refurbishment', cap: 'kitchen island, north light',                 img: 'images/03-apartment-floor.png' },
  { n: '08', title: 'AD House',             loc: 'Stoke Newington, N16', yr: '2020', tag: 'New Build',    cap: 'view from the street, brick + zinc',          img: 'images/02-ad-house-street.jpg' },
  { n: '09', title: 'Island Home',          loc: 'Outer Hebrides',     yr: '2020', tag: 'New Build',    cap: 'detail \u2014 chromatic glazing',             img: 'images/08-island-home-detail.jpg' },
];

const HomesNav = ({ palette, headlineFont }) => (
  <header style={{
    display: 'grid', gridTemplateColumns: '1fr auto 1fr',
    alignItems: 'center', padding: '24px 56px', borderBottom: `1px solid ${palette.line}`,
    background: palette.bg, color: palette.fg,
  }}>
    <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase', color: palette.muted }}>London · Est. 2005</div>
    <div style={{ fontFamily: window.WORDMARK_FONT, fontSize: 16, letterSpacing: '.04em', textAlign: 'center' }}>Coffey<span style={{ opacity: .35, margin: '0 8px' }}>|</span>Residential</div>
    <nav style={{ display: 'flex', gap: 28, justifyContent: 'flex-end', fontSize: 13 }}>
      {['Homes','Studio','Process','Press','Journal','Contact'].map(n =>
        <a key={n} style={{ color: n === 'Homes' ? palette.fg : palette.muted, textDecoration: n === 'Homes' ? 'underline' : 'none', textUnderlineOffset: 6 }}>{n}</a>
      )}
    </nav>
  </header>
);

const HomesFooter = ({ palette, headlineFont }) => (
  <>
    <section style={{ padding: '120px 56px', background: palette.cta, color: palette.ctaFg, display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 80 }}>
      <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>Tell us about your house.</h2>
      <div style={{ alignSelf: 'end', fontSize: 13, opacity: .8 }}>contact@coffeyresidential.com</div>
    </section>
    <footer style={{ padding: '32px 56px', display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted, background: palette.bg }}>
      <div>Coffey Residential · 104\u2013110 Goswell Road · Clerkenwell EC1V 7DH</div>
      <div>contact@coffeyresidential.com</div>
      <div>© 2026</div>
    </footer>
  </>
);

// Filter chip strip used at the top of each variation.
const FilterRow = ({ palette, headlineFont, active = 'All' }) => {
  const filters = ['All', 'New Build', 'Whole House', 'Refurbishment', 'Extension'];
  const types = ['All locations', 'London', 'Outside London'];
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '24px 56px', borderBottom: `1px solid ${palette.line}` }}>
      <div style={{ display: 'flex', gap: 8 }}>
        {filters.map(f => (
          <span key={f} style={{
            padding: '8px 14px', borderRadius: 999, fontSize: 12,
            border: `1px solid ${palette.line}`,
            background: f === active ? palette.fg : 'transparent',
            color: f === active ? palette.bg : palette.fg,
          }}>{f}</span>
        ))}
      </div>
      <div style={{ display: 'flex', gap: 18, fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted }}>
        {types.map(t => <span key={t} style={{ color: t === 'All locations' ? palette.fg : palette.muted }}>{t}</span>)}
        <span>·</span>
        <span>Sort · Year ↓</span>
      </div>
    </div>
  );
};

// ═══════════════════════════════════════════════════════════════════════
// HOMES OPTION A — EDITORIAL GRID
// 3-up grid, generous gutters, large index headline.
// ═══════════════════════════════════════════════════════════════════════
function HomesGrid({ headlineFont, bodyFont, palette }) {
  return (
    <div style={{ width: HOMES_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* page header */}
      <section style={{ padding: '120px 56px 80px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80, alignItems: 'flex-end' }}>
          <div>
            <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', color: palette.muted, marginBottom: 20 }}>Selected work · 2020 — 2024</div>
            <h1 style={{ fontFamily: headlineFont, fontSize: 112, lineHeight: 0.98, fontWeight: 400, margin: 0, letterSpacing: '-0.03em' }}>Homes,<br/><em>nine of them.</em></h1>
          </div>
          <p style={{ fontSize: 17, lineHeight: 1.6, margin: 0, color: palette.muted, maxWidth: 480, justifySelf: 'end' }}>A small selection of recent houses. New build, whole-house refurbishment, and the occasional extension that grew into something bigger.</p>
        </div>
      </section>

      <FilterRow palette={palette} headlineFont={headlineFont} />

      {/* 3-up grid */}
      <section style={{ padding: '64px 56px 80px' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 28, rowGap: 64 }}>
          {HOMES_PROJECTS.map(p => (
            <a key={p.n} style={{ color: palette.fg, textDecoration: 'none' }}>
              <Slot tone="bone" caption={p.cap} height={420} src={p.img} />
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginTop: 16 }}>
                <div>
                  <div style={{ fontFamily: headlineFont, fontSize: 26, letterSpacing: '-0.01em' }}>{p.title}</div>
                  <div style={{ fontSize: 12, color: palette.muted, marginTop: 4 }}>{p.loc} · {p.tag}</div>
                </div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted }}>{p.n} · {p.yr}</div>
              </div>
            </a>
          ))}
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// HOMES OPTION B — FULL-BLEED ALTERNATING
// Each project a row, image full-bleed, copy in the opposite column.
// Cinematic; closest to V6 spine.
// ═══════════════════════════════════════════════════════════════════════
function HomesFullBleed({ headlineFont, bodyFont, palette }) {
  return (
    <div style={{ width: HOMES_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* hero header — type only, narrower for breathing room */}
      <section style={{ padding: '140px 56px 80px', borderBottom: `1px solid ${palette.line}`, maxWidth: 1200, margin: '0 auto' }}>
        <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', color: palette.muted, marginBottom: 28 }}>The Index · 09 Homes</div>
        <h1 style={{ fontFamily: headlineFont, fontSize: 104, lineHeight: 0.98, fontWeight: 400, margin: 0, letterSpacing: '-0.035em' }}>
          <div>Every house</div>
          <div style={{ fontStyle: 'italic' }}>we have built.</div>
        </h1>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 32, marginTop: 64, paddingTop: 24, borderTop: `1px solid ${palette.line}` }}>
          {[['New build','5'],['Refurbishment','3'],['Extension','1'],['Since 2005','40+ total']].map(([l,v],i) => (
            <div key={l}>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted }}>{l}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 36, marginTop: 6 }}>{v}</div>
            </div>
          ))}
        </div>
      </section>

      <FilterRow palette={palette} headlineFont={headlineFont} />

      {/* alternating rows — image fills its column edge-to-edge */}
      {HOMES_PROJECTS.map((p, i) => {
        const imgLeft = i % 2 === 0;
        return (
          <section key={p.n} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', borderBottom: `1px solid ${palette.line}`, minHeight: 560 }}>
            <div style={{ order: imgLeft ? 0 : 1, position: 'relative' }}>
              <Slot tone="bone" caption={p.cap} height="100%" src={p.img} />
            </div>
            <div style={{ order: imgLeft ? 1 : 0, padding: '72px 56px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
              <div style={{ maxWidth: 460 }}>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase', color: palette.muted, marginBottom: 20 }}>{p.n} / 09 · {p.tag}</div>
                <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: 0, letterSpacing: '-0.015em', lineHeight: 1.05 }}>{p.title}</h2>
                <div style={{ fontSize: 14, color: palette.muted, marginTop: 10 }}>{p.loc}</div>
                <p style={{ fontSize: 15, lineHeight: 1.65, marginTop: 28 }}>
                  A {p.tag.toLowerCase()} project completed in {p.yr}. The brief asked for daylight, calm, and rooms that grow with a family — the answer is in the photograph.
                </p>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', borderTop: `1px solid ${palette.line}`, paddingTop: 18, maxWidth: 460 }}>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted }}>{p.yr}</div>
                <a style={{ fontSize: 13 }}>View project →</a>
              </div>
            </div>
          </section>
        );
      })}

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// HOMES OPTION C — LIST INDEX
// Tabular list of every project with a hover-revealed thumbnail strip
// above the active row. Drawing-office, archive feel.
// ═══════════════════════════════════════════════════════════════════════
function HomesList({ headlineFont, bodyFont, palette }) {
  const M = 'JetBrains Mono, ui-monospace, monospace';
  return (
    <div style={{ width: HOMES_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* header */}
      <section style={{ padding: '100px 40px 40px', borderBottom: `1px solid ${palette.line}`, display: 'grid', gridTemplateColumns: '60px 1fr 200px', alignItems: 'flex-end', gap: 32 }}>
        <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>01.0</div>
        <h1 style={{ fontFamily: headlineFont, fontSize: 96, fontWeight: 400, margin: 0, letterSpacing: '-0.03em', lineHeight: 0.98 }}>The index<br/>of homes.</h1>
        <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase', textAlign: 'right' }}>n = 09<br/>2020 — 2024</div>
      </section>

      {/* featured strip — a row of thumbnails above the table */}
      <section style={{ padding: '32px 40px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase', marginBottom: 16 }}>Featured · most recent</div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16 }}>
          {HOMES_PROJECTS.slice(0, 4).map(p => (
            <a key={p.n} style={{ color: palette.fg, textDecoration: 'none' }}>
              <Slot tone="bone" caption={p.cap} height={220} src={p.img} />
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 10, fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.06em', textTransform: 'uppercase' }}>
                <span>{p.n} · {p.title}</span><span>{p.yr}</span>
              </div>
            </a>
          ))}
        </div>
      </section>

      <FilterRow palette={palette} headlineFont={headlineFont} />

      {/* table header */}
      <div style={{ display: 'grid', gridTemplateColumns: '60px 80px 1.4fr 1fr 1fr 100px 80px', padding: '14px 40px', borderBottom: `1px solid ${palette.line}`, fontFamily: M, fontSize: 10, color: palette.muted, letterSpacing: '.12em', textTransform: 'uppercase' }}>
        <div>No.</div><div>Year</div><div>Project</div><div>Location</div><div>Type</div><div>Status</div><div></div>
      </div>
      {/* rows */}
      {HOMES_PROJECTS.map((p, i) => (
        <a key={p.n} style={{ display: 'grid', gridTemplateColumns: '60px 80px 1.4fr 1fr 1fr 100px 80px', padding: '22px 40px', borderBottom: `1px solid ${palette.line}`, alignItems: 'center', textDecoration: 'none', color: palette.fg, background: i === 0 ? palette.softBg || 'transparent' : 'transparent' }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted }}>{p.n}</div>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted }}>{p.yr}</div>
          <div style={{ fontFamily: headlineFont, fontSize: 26, letterSpacing: '-0.01em' }}>{p.title}</div>
          <div style={{ fontSize: 13 }}>{p.loc}</div>
          <div style={{ fontSize: 13, color: palette.muted }}>{p.tag}</div>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.accent, letterSpacing: '.1em', textTransform: 'uppercase' }}>Complete</div>
          <div style={{ fontFamily: M, fontSize: 14, color: palette.muted, textAlign: 'right' }}>→</div>
        </a>
      ))}

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { HomesGrid, HomesFullBleed, HomesList });
