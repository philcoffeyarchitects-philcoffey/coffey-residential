// Press + Awards page — a list of placements and recognitions.
// Built as an editorial index: filter chip row, awards strip, press list,
// 'as featured in' logo wall, downloadable press kit.

const PR_W = 1440;
const PR_CAP = 1280;

const PRESS = [
  { yr: '2025', mo: 'Apr', src: 'House & Garden',       kind: 'Print',  proj: 'Hampstead House',        line: 'A house that breathes with the garden' },
  { yr: '2025', mo: 'Mar', src: 'The Sunday Times',     kind: 'Print',  proj: 'Hampstead House',        line: 'Inside a north London family home, cut into the slope' },
  { yr: '2024', mo: 'Nov', src: 'Dezeen',                kind: 'Online', proj: 'Hampstead House',        line: '"Cut into the slope, rather than placed on it"' },
  { yr: '2024', mo: 'Sep', src: 'Wallpaper*',            kind: 'Print',  proj: 'Garden Lodge',           line: 'A working studio at the end of a London garden' },
  { yr: '2024', mo: 'Jul', src: 'Architects\u2019 Journal',  kind: 'Print',  proj: 'Studio',                 line: 'Profile: Phil Coffey on twenty years of houses' },
  { yr: '2024', mo: 'May', src: 'Dwell',                 kind: 'Online', proj: 'Capablanca House',       line: 'A 1960s villa, reimagined for its third generation' },
  { yr: '2024', mo: 'Feb', src: 'The Modern House',      kind: 'Online', proj: 'Cove Ridge',             line: 'Quiet rooms, in a coastal vernacular' },
  { yr: '2023', mo: 'Nov', src: 'Domus',                 kind: 'Print',  proj: 'Studio',                 line: 'On the architecture of a small London practice' },
  { yr: '2023', mo: 'Aug', src: 'Elle Decoration',       kind: 'Print',  proj: 'Island Home',            line: 'A holiday house on Mull' },
  { yr: '2023', mo: 'Jun', src: 'Architectural Review',  kind: 'Print',  proj: 'Cove Ridge',             line: 'Materials, weathered: an essay on patience' },
  { yr: '2023', mo: 'Mar', src: 'World of Interiors',    kind: 'Print',  proj: 'Capablanca House',       line: 'A long-married house' },
  { yr: '2022', mo: 'Oct', src: 'Architects\u2019 Journal',  kind: 'Print',  proj: 'Garden Lodge',           line: '"It looks like it has always been there"' },
];

const AWARDS = [
  { yr: '2025', body: 'British Homes Awards',        title: 'Homes Architect of the Year',                cat: 'Practice',     status: 'Winner'   },
  { yr: '2024', body: 'RIBA London',                  title: 'Hampstead House',                            cat: 'House',        status: 'Winner'   },
  { yr: '2024', body: 'AJ Architecture Awards',       title: 'Garden Lodge',                               cat: 'Small Project', status: 'Shortlist' },
  { yr: '2023', body: 'RIBA National Awards',         title: 'Cove Ridge',                                 cat: 'House',        status: 'Winner'   },
  { yr: '2023', body: 'Don\u2019t Move, Improve!',         title: 'Capablanca House',                           cat: 'Refurb',       status: 'Finalist' },
  { yr: '2022', body: 'House & Garden Top 100',       title: 'Coffey Residential',                         cat: 'Architects',   status: 'Listed'   },
  { yr: '2021', body: 'RIBA London',                  title: 'Garden Lodge',                               cat: 'Small Project',status: 'Winner'   },
  { yr: '2012', body: 'Architects\u2019 Journal',           title: 'Phil Coffey \u2014 Young Architect of the Year',  cat: 'Individual',   status: 'Winner'   },
];

// 'As featured in' wall — title only, set in headline italic to read as
// a typographic mark instead of a logo (we don't have rights to actual logos).
const OUTLETS = [
  'House & Garden', 'The Sunday Times', 'Dezeen', 'Wallpaper*',
  'AJ', 'Dwell', 'The Modern House', 'Domus', 'Elle Decoration',
  'Architectural Review', 'World of Interiors', 'FT How To Spend It',
];

const PrMono = (props) => (
  <div {...props} style={{
    fontFamily: 'JetBrains Mono, ui-monospace, monospace',
    fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase',
    ...(props.style || {}),
  }} />
);

// ════════════════════════════════════════════════════════════════════════
// PRESS PAGE
// ════════════════════════════════════════════════════════════════════════
function PressPage({ headlineFont, bodyFont, palette }) {
  const filters = ['All', 'Print', 'Online', 'Awards', 'Studio'];
  return (
    <div style={{ width: PR_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* header */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '140px 56px 80px', borderBottom: `1px solid ${palette.line}` }}>
        <PrMono style={{ color: palette.muted, marginBottom: 32 }}>Press &amp; Awards · {PRESS.length + AWARDS.length} entries</PrMono>
        <h1 style={{ fontFamily: headlineFont, fontSize: 120, lineHeight: 0.96, fontWeight: 400, margin: 0, letterSpacing: '-0.035em', maxWidth: 1100 }}>
          <div>The work,</div>
          <div style={{ fontStyle: 'italic' }}>through other voices.</div>
        </h1>
      </section>

      {/* filter chip strip */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '24px 56px', borderBottom: `1px solid ${palette.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div style={{ display: 'flex', gap: 8 }}>
          {filters.map(f => (
            <span key={f} style={{
              padding: '8px 14px', borderRadius: 999, fontSize: 12,
              border: `1px solid ${palette.line}`,
              background: f === 'All' ? palette.fg : 'transparent',
              color: f === 'All' ? palette.bg : palette.fg,
            }}>{f}</span>
          ))}
        </div>
        <PrMono style={{ color: palette.muted }}>Sort · Newest first ↓</PrMono>
      </section>

      {/* RECOGNITION — pulled out as a stat strip up top */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '0' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', borderBottom: `1px solid ${palette.line}` }}>
          {[
            ['RIBA Awards',         '4',  'London + National'],
            ['Recent recognition',  '2025', 'Homes Architect of the Year'],
            ['Press placements',    '120 +', 'Across 14 years'],
            ['Outlets',             '40 +', 'Print and online'],
          ].map(([l,v,sub],i) => (
            <div key={l} style={{
              padding: '36px 28px',
              borderRight: i < 3 ? `1px solid ${palette.line}` : 'none',
            }}>
              <PrMono style={{ color: palette.muted, marginBottom: 14 }}>{l}</PrMono>
              <div style={{ fontFamily: headlineFont, fontSize: 40, letterSpacing: '-0.02em', lineHeight: 1 }}>{v}</div>
              <div style={{ fontSize: 12, color: palette.muted, marginTop: 10 }}>{sub}</div>
            </div>
          ))}
        </div>
      </section>

      {/* AWARDS table */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 48 }}>
          <div>
            <PrMono style={{ color: palette.muted, marginBottom: 16 }}>Awards</PrMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>The shelf.</h2>
          </div>
          <PrMono style={{ color: palette.muted }}>{AWARDS.length} entries · 2012 — present</PrMono>
        </div>
        <div>
          {/* header row */}
          <div style={{
            display: 'grid',
            gridTemplateColumns: '60px 1.4fr 1.6fr 1fr 120px',
            gap: 24, padding: '14px 0',
            borderTop: `1px solid ${palette.line}`,
            borderBottom: `1px solid ${palette.line}`,
          }}>
            <PrMono style={{ color: palette.muted }}>Year</PrMono>
            <PrMono style={{ color: palette.muted }}>Body</PrMono>
            <PrMono style={{ color: palette.muted }}>Project / Title</PrMono>
            <PrMono style={{ color: palette.muted }}>Category</PrMono>
            <PrMono style={{ color: palette.muted, textAlign: 'right' }}>Status</PrMono>
          </div>
          {AWARDS.map((a,i) => (
            <div key={i} style={{
              display: 'grid',
              gridTemplateColumns: '60px 1.4fr 1.6fr 1fr 120px',
              gap: 24, padding: '22px 0',
              borderBottom: `1px solid ${palette.line}`,
              alignItems: 'baseline',
            }}>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 13, color: palette.muted }}>{a.yr}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 18, fontStyle: 'italic', letterSpacing: '-0.005em' }}>{a.body}</div>
              <div style={{ fontSize: 15 }}>{a.title}</div>
              <div style={{ fontSize: 13, color: palette.muted }}>{a.cat}</div>
              <div style={{ textAlign: 'right' }}>
                <span style={{
                  display: 'inline-block',
                  padding: '4px 10px',
                  fontFamily: 'JetBrains Mono, monospace',
                  fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase',
                  background: a.status === 'Winner' ? palette.fg : 'transparent',
                  color:      a.status === 'Winner' ? palette.bg : palette.fg,
                  border: a.status === 'Winner' ? `1px solid ${palette.fg}` : `1px solid ${palette.line}`,
                }}>{a.status}</span>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* PRESS — grouped by year */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 48 }}>
          <div>
            <PrMono style={{ color: palette.muted, marginBottom: 16 }}>Press</PrMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Where the work appeared.</h2>
          </div>
          <PrMono style={{ color: palette.muted }}>{PRESS.length} shown · all on request</PrMono>
        </div>

        {/* Group by year */}
        {Array.from(new Set(PRESS.map(p => p.yr))).map(yr => {
          const items = PRESS.filter(p => p.yr === yr);
          return (
            <div key={yr} style={{ display: 'grid', gridTemplateColumns: '120px 1fr', gap: 48, paddingTop: 56, borderTop: `1px solid ${palette.line}`, marginBottom: 8 }}>
              <div style={{ fontFamily: headlineFont, fontSize: 64, letterSpacing: '-0.02em', lineHeight: 1 }}>{yr}</div>
              <div>
                {items.map((p,i) => (
                  <a key={i} style={{
                    display: 'grid',
                    gridTemplateColumns: '60px 200px 1fr 180px 60px',
                    gap: 24, padding: '20px 0',
                    borderBottom: `1px solid ${palette.line}`,
                    alignItems: 'baseline',
                    color: palette.fg, textDecoration: 'none',
                  }}>
                    <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, letterSpacing: '.08em', textTransform: 'uppercase' }}>{p.mo}</div>
                    <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 20, letterSpacing: '-0.005em' }}>{p.src}</div>
                    <div style={{ fontSize: 15, lineHeight: 1.4 }}>{p.line}</div>
                    <div style={{ fontSize: 13, color: palette.muted }}>{p.proj}</div>
                    <div style={{ textAlign: 'right' }}>
                      <PrMono style={{ color: palette.muted }}>{p.kind} →</PrMono>
                    </div>
                  </a>
                ))}
              </div>
            </div>
          );
        })}
      </section>

      {/* AS FEATURED IN — typographic outlet wall (no logos) */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <PrMono style={{ color: palette.muted, marginBottom: 32, textAlign: 'center' }}>As featured in</PrMono>
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(4, 1fr)',
          rowGap: 8,
        }}>
          {OUTLETS.map((o,i) => (
            <div key={o} style={{
              padding: '36px 16px',
              textAlign: 'center',
              borderTop: `1px solid ${palette.line}`,
              borderBottom: i >= OUTLETS.length - 4 ? `1px solid ${palette.line}` : 'none',
              borderRight: (i+1) % 4 !== 0 ? `1px solid ${palette.line}` : 'none',
              fontFamily: headlineFont,
              fontStyle: 'italic',
              fontSize: 28,
              letterSpacing: '-0.01em',
              color: palette.fg,
            }}>{o}</div>
          ))}
        </div>
      </section>

      {/* PRESS KIT — for journalists */}
      <section style={{ maxWidth: PR_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80, alignItems: 'flex-start' }}>
          <div>
            <PrMono style={{ color: palette.muted, marginBottom: 16 }}>Press kit</PrMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>Writing about us?</h2>
            <p style={{ fontSize: 16, lineHeight: 1.65, color: palette.fg, marginTop: 28, maxWidth: 460 }}>
              We keep a current press pack with practice biography, principal portrait, project shortlist and approved photography. Send a note and we’ll have it back to you the same day.
            </p>
          </div>
          <div style={{ borderTop: `1px solid ${palette.line}` }}>
            {[
              ['Practice biography',    'PDF · 240 KB'],
              ['Principal portrait',     'JPG · 6 MB'],
              ['Project shortlist 2025', 'PDF · 1.4 MB'],
              ['Approved photography',   'Folder · 320 MB'],
              ['Logo + wordmark',        'ZIP · 480 KB'],
            ].map(([l,size]) => (
              <a key={l} style={{
                display: 'grid', gridTemplateColumns: '1fr auto auto',
                gap: 24, padding: '22px 0',
                borderBottom: `1px solid ${palette.line}`,
                alignItems: 'baseline',
                color: palette.fg, textDecoration: 'none',
              }}>
                <div style={{ fontFamily: headlineFont, fontSize: 20, letterSpacing: '-0.005em' }}>{l}</div>
                <PrMono style={{ color: palette.muted }}>{size}</PrMono>
                <PrMono style={{ color: palette.fg }}>↓ Download</PrMono>
              </a>
            ))}
            <div style={{ marginTop: 32 }}>
              <PrMono style={{ color: palette.muted, marginBottom: 10 }}>Press contact</PrMono>
              <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.005em' }}>press@coffeyresidential.com</div>
              <div style={{ fontSize: 13, color: palette.muted, marginTop: 4 }}>+44 (0)20 7253 7174</div>
            </div>
          </div>
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { PressPage });
