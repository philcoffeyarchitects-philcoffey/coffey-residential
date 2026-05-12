// Studio page — Phil + philosophy + values + team grid.
// Follows the V6 / Homes / Project chassis: 1440 artboard, 1280 content cap.

const STUDIO_W = 1440;
const STUDIO_CAP = 1280;

// Team data — names are placeholders; user said avoid disclosing team size,
// but "All of the above" includes a team grid. We render a small studio's
// grid with role-led labels rather than headshots-of-everyone, and keep
// the count deliberately vague (no n=X counter, no "the team of X").
const TEAM = [
  { role: 'Founder · Principal', name: 'Phil Coffey',          short: 'Founded the studio in 2005. On every project, from first sketch to final snag.', tag: 'Studio' },
  { role: 'Project Architect',   name: 'A. — Project lead',    short: 'Leads delivery on residential projects across London and the South.',              tag: 'Studio' },
  { role: 'Architect',           name: 'B. — Architect',        short: 'Conservation and listed building specialism. Detailing lead.',                     tag: 'Studio' },
  { role: 'Architectural Assistant', name: 'C. — Assistant',    short: 'Drawing, modelling, on-site measurement.',                                         tag: 'Studio' },
  { role: 'Studio Manager',      name: 'D. — Studio',          short: 'The reason meetings start on time and invoices arrive on the right day.',           tag: 'Studio' },
];

const VALUES = [
  { n: 'I',   t: 'Quiet over loud.',
    d: 'A house should be calm to live in. Strong ideas, restrained delivery. The work doesn’t need to announce itself.' },
  { n: 'II',  t: 'Light is the brief.',
    d: 'We design plans around how daylight moves through them. Rooms placed for the sun they get, not the wall they share.' },
  { n: 'III', t: 'Detail at one-to-one.',
    d: 'Every junction, joint and reveal is drawn at full size. Most decisions a house lives or dies by are made at this scale.' },
  { n: 'IV',  t: 'The same people, all the way.',
    d: 'The people who sketch the first idea are on site for the last snag. Continuity from brief to handover.' },
];

// Short-form journal/essay highlights to round out the page.
const STUDIO_ESSAYS = [
  { tag: 'Essay',   yr: '2024', t: 'On the architecture of light',     read: '6 min' },
  { tag: 'Process', yr: '2024', t: 'How we measure a Victorian house', read: '4 min' },
  { tag: 'Field',   yr: '2023', t: 'Notes from a year on site',        read: '8 min' },
];

const StudioMono = (props) => (
  <div {...props} style={{
    fontFamily: 'JetBrains Mono, ui-monospace, monospace',
    fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase',
    ...(props.style || {}),
  }} />
);

// ════════════════════════════════════════════════════════════════════════
// STUDIO PAGE
// ════════════════════════════════════════════════════════════════════════
function StudioPage({ headlineFont, bodyFont, palette }) {
  return (
    <div style={{ width: STUDIO_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* page header — type-only, no hero image, sets a quieter tone */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '140px 56px 80px', borderBottom: `1px solid ${palette.line}` }}>
        <StudioMono style={{ color: palette.muted, marginBottom: 32 }}>The Studio · Clerkenwell, London</StudioMono>
        <h1 style={{ fontFamily: headlineFont, fontSize: 120, lineHeight: 0.96, fontWeight: 400, margin: 0, letterSpacing: '-0.035em', maxWidth: 1100 }}>
          <div>A small studio,</div>
          <div style={{ fontStyle: 'italic' }}>one house at a time.</div>
        </h1>
      </section>

      {/* PHIL — portrait + practice philosophy in two columns */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.1fr', gap: 80, alignItems: 'flex-start' }}>
          <div>
            <Slot tone="bone" caption="portrait — Phil Coffey, principal" height={680} src="images/02-ad-house-street.jpg" />
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 14 }}>
              <StudioMono style={{ color: palette.muted }}>Phil Coffey · Founder</StudioMono>
              <StudioMono style={{ color: palette.muted }}>Est. 2005</StudioMono>
            </div>
          </div>
          <div style={{ paddingTop: 24, maxWidth: 540 }}>
            <StudioMono style={{ color: palette.muted, marginBottom: 16 }}>The Principal</StudioMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 48, lineHeight: 1.05, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Phil started the studio in 2005.</h2>
            <p style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 22, lineHeight: 1.45, marginTop: 32 }}>
              "I wanted a practice that did fewer houses, better. One where the person at the first meeting is the person on site for the last snag."
            </p>
            <div style={{ fontSize: 15, lineHeight: 1.7, color: palette.fg, marginTop: 32 }}>
              <p style={{ margin: '0 0 1.2em' }}>Phil trained at the Bartlett and worked across cultural and residential projects before founding Coffey Residential. The studio has stayed small on purpose — a handful of new houses and whole-house refurbishments a year, with Phil drawing on every one.</p>
              <p style={{ margin: '0 0 1.2em' }}>He was named <em>Young Architect of the Year</em> by The Architects' Journal in 2012. The studio's most recent recognition is <em>Homes Architect of the Year</em> at the 2025 British Homes Awards.</p>
            </div>
          </div>
        </div>
      </section>

      {/* PHILOSOPHY — large type, single column */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <StudioMono style={{ color: palette.muted, marginBottom: 16 }}>Philosophy</StudioMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.1 }}>What we believe a house is for.</h2>
          </div>
          <div style={{ maxWidth: 720 }}>
            <p style={{ fontFamily: headlineFont, fontSize: 32, lineHeight: 1.35, margin: 0, letterSpacing: '-0.01em' }}>
              A house is the room you spend the most time in, the stair you climb every day, the window you look out of when you're thinking. We design houses to be calm in the hand and patient over time — built well enough that they don't need to be redone in a decade, restrained enough that they don't date in five years.
            </p>
            <p style={{ fontSize: 16, lineHeight: 1.75, marginTop: 36, color: palette.fg }}>
              Most of our work begins with an existing house: a Victorian terrace, a 1930s semi, a country place that has been added to four times. We are interested in the question of how to make these houses work for the way people actually live now, without erasing what makes them worth keeping.
            </p>
            <p style={{ fontSize: 16, lineHeight: 1.75, marginTop: 16, color: palette.fg }}>
              When we do build new, we build with the same care: brick that will weather for a century, oak floors that get better with use, glass that closes properly. The work is residential because we believe the house is the most important building you ever commission.
            </p>
          </div>
        </div>
      </section>

      {/* VALUES — four numbered cards */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 56 }}>
          <div>
            <StudioMono style={{ color: palette.muted, marginBottom: 16 }}>Values</StudioMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Four things we mean.</h2>
          </div>
          <StudioMono style={{ color: palette.muted }}>I — IV</StudioMono>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 0, borderTop: `1px solid ${palette.line}` }}>
          {VALUES.map((v,i) => (
            <div key={v.n} style={{
              padding: '36px 28px 40px',
              borderRight: i < 3 ? `1px solid ${palette.line}` : 'none',
              minHeight: 320,
            }}>
              <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 20, color: palette.muted, marginBottom: 32 }}>{v.n}</div>
              <h3 style={{ fontFamily: headlineFont, fontSize: 24, fontWeight: 400, margin: 0, letterSpacing: '-0.015em', lineHeight: 1.15 }}>{v.t}</h3>
              <p style={{ fontSize: 14, lineHeight: 1.6, marginTop: 16, color: palette.muted }}>{v.d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* TEAM — role-led grid, no headshots required */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 56 }}>
          <div>
            <StudioMono style={{ color: palette.muted, marginBottom: 16 }}>The Studio</StudioMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>The people you’ll work with.</h2>
          </div>
          <p style={{ fontSize: 14, color: palette.muted, maxWidth: 280, textAlign: 'right', margin: 0, lineHeight: 1.5 }}>The studio is intentionally small. The people you meet at the first conversation are the people doing the work.</p>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 32, rowGap: 56 }}>
          {TEAM.map((m,i) => (
            <div key={m.role}>
              <div style={{ aspectRatio: '4 / 5', position: 'relative' }}>
                <StripeBg tone={['bone','stone','warm','paper','cream'][i % 5]} />
                <div style={{
                  position: 'absolute', left: 16, bottom: 14,
                  fontFamily: 'JetBrains Mono, monospace',
                  fontSize: 10, letterSpacing: '.08em', textTransform: 'uppercase',
                  color: 'rgba(40,30,20,.65)',
                }}>portrait — {m.name.split(' — ')[0]}</div>
              </div>
              <StudioMono style={{ color: palette.muted, marginTop: 18 }}>{m.role}</StudioMono>
              <div style={{ fontFamily: headlineFont, fontSize: 24, letterSpacing: '-0.01em', marginTop: 6 }}>{m.name}</div>
              <p style={{ fontSize: 14, lineHeight: 1.65, color: palette.muted, marginTop: 12, maxWidth: 320 }}>{m.short}</p>
            </div>
          ))}
        </div>
        <div style={{ marginTop: 64, paddingTop: 24, borderTop: `1px solid ${palette.line}`, display: 'flex', justifyContent: 'space-between' }}>
          <StudioMono style={{ color: palette.muted }}>Hiring · open applications</StudioMono>
          <a style={{ fontSize: 13, color: palette.fg }}>Write to us about working here →</a>
        </div>
      </section>

      {/* STUDIO FACTS — quiet numbers strip, no team-size figure */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '0' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', borderBottom: `1px solid ${palette.line}` }}>
          {[
            ['Founded',  '2005'],
            ['Houses',   '40 +'],
            ['Awards',   'RIBA × 4'],
            ['Location', 'Clerkenwell, EC1V'],
          ].map(([l,v],i) => (
            <div key={l} style={{
              padding: '32px 28px',
              borderRight: i < 3 ? `1px solid ${palette.line}` : 'none',
            }}>
              <StudioMono style={{ color: palette.muted, marginBottom: 12 }}>{l}</StudioMono>
              <div style={{ fontFamily: headlineFont, fontSize: 32, letterSpacing: '-0.01em' }}>{v}</div>
            </div>
          ))}
        </div>
      </section>

      {/* JOURNAL TEASER — three recent essays */}
      <section style={{ maxWidth: STUDIO_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 48 }}>
          <div>
            <StudioMono style={{ color: palette.muted, marginBottom: 16 }}>Journal</StudioMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>How we think, in writing.</h2>
          </div>
          <a style={{ fontSize: 13, color: palette.fg }}>All journal →</a>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 32 }}>
          {STUDIO_ESSAYS.map(e => (
            <a key={e.t} style={{ color: palette.fg, textDecoration: 'none', borderTop: `1px solid ${palette.line}`, paddingTop: 28, display: 'block' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <StudioMono style={{ color: palette.muted }}>{e.tag}</StudioMono>
                <StudioMono style={{ color: palette.muted }}>{e.yr} · {e.read}</StudioMono>
              </div>
              <div style={{ fontFamily: headlineFont, fontSize: 28, letterSpacing: '-0.015em', marginTop: 28, maxWidth: 320 }}>{e.t}</div>
            </a>
          ))}
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { StudioPage });
