// Five distinct homepage variations for Coffey Residential.
// Each is a 1440-wide artboard rendering a full homepage layout.
// All share the same content (PROJECTS, COPY, etc. from parts.jsx)
// but differ in nav, hero, grid, type and rhythm.

const W = 1440;

// ── Shared utility components ───────────────────────────────────────────
const Eyebrow = ({ children, color, mono = true, style = {} }) => (
  <div style={{
    fontFamily: mono ? 'JetBrains Mono, ui-monospace, monospace' : 'inherit',
    fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase',
    color, ...style,
  }}>{children}</div>
);

const Rule = ({ color, style = {} }) => (
  <div style={{ height: 1, background: color, width: '100%', ...style }} />
);

// ═══════════════════════════════════════════════════════════════════════
// VARIATION 1 — EDITORIAL CLASSIC
// Top centered nav, full-bleed hero, large serif headline, traditional
// project grid (3 across), warm bone palette.
// ═══════════════════════════════════════════════════════════════════════
function V1Editorial({ headlineFont, bodyFont, heroMedia, gridDensity, palette, copy }) {
  const c = COPY[copy];
  const cols = gridDensity === 'sparse' ? 2 : gridDensity === 'dense' ? 4 : 3;
  return (
    <div style={{
      width: W, fontFamily: bodyFont,
      background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55,
    }}>
      {/* nav */}
      <header style={{
        display: 'grid', gridTemplateColumns: '1fr auto 1fr',
        alignItems: 'center', padding: '28px 56px', borderBottom: `1px solid ${palette.line}`,
      }}>
        <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', color: palette.muted }}>London · Est. 2005</div>
        <div style={{ fontFamily: WORDMARK_FONT, fontSize: 16, letterSpacing: '.02em', textAlign: 'center' }}>Coffey<span style={{ opacity: .35, margin: '0 6px' }}>|</span>Residential</div>
        <nav style={{ display: 'flex', gap: 28, justifyContent: 'flex-end', fontSize: 13 }}>
          {['Homes','Studio','Process','Press','Journal','Contact'].map(n => <a key={n} style={{ color: palette.fg, textDecoration: 'none' }}>{n}</a>)}
        </nav>
      </header>

      {/* hero */}
      <section style={{ position: 'relative', height: 720 }}>
        <HeroMedia heroMedia={heroMedia} tone="ink" dark caption="hero · Hampstead House, garden room at dusk" label="01 / 06" height="100%" src={HERO_IMG} objectPosition="center 60%" />
        <div style={{ position: 'absolute', inset: 0, padding: '56px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', color: '#fff' }}>
          <Eyebrow color="rgba(255,255,255,.75)">{c.eyebrow}</Eyebrow>
          <div>
            <h1 style={{ fontFamily: headlineFont, fontSize: 96, lineHeight: 1.02, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', maxWidth: 1100 }}>
              {c.h1Lines.map((l,i) => <div key={i}>{l}</div>)}
            </h1>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginTop: 36 }}>
              <div style={{ maxWidth: 420, fontSize: 15, opacity: .9 }}>Houses across London. New builds, whole refurbishments, extensions.</div>
              <button style={{ background: '#fff', color: '#1a1714', border: 0, padding: '16px 28px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
            </div>
          </div>
        </div>
      </section>

      {/* about */}
      <section style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80, padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div>
          <Eyebrow color={palette.muted} style={{ marginBottom: 24 }}>About · The Studio</Eyebrow>
          <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>{c.aboutTitle}</h2>
        </div>
        <div>
          <p style={{ fontSize: 17, lineHeight: 1.6, margin: 0, color: palette.fg }}>{c.intro}</p>
          <p style={{ fontSize: 15, lineHeight: 1.65, marginTop: 20, color: palette.muted }}>{c.aboutBody}</p>
          <Slot tone="bone" caption="portrait · Phil Coffey, studio, daylight" height={420} style={{ marginTop: 36 }} src={INTERIOR_1} />
        </div>
      </section>

      {/* projects */}
      <section style={{ padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 56 }}>
          <div>
            <Eyebrow color={palette.muted} style={{ marginBottom: 16 }}>Selected Homes · 2021–2024</Eyebrow>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>Recent work.</h2>
          </div>
          <a style={{ fontSize: 13, color: palette.fg }}>All homes →</a>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: `repeat(${cols}, 1fr)`, gap: 28 }}>
          {PROJECTS.slice(0, cols * 2).map(p => (
            <div key={p.n}>
              <Slot tone={['bone','stone','warm','paper','cream','sage'][PROJECTS.indexOf(p) % 6]} caption={p.cap} height={cols === 4 ? 280 : cols === 3 ? 380 : 480} src={p.img} />
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 14 }}>
                <div>
                  <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.01em' }}>{p.title}</div>
                  <div style={{ fontSize: 12, color: palette.muted, marginTop: 4 }}>{p.loc} · {p.tag}</div>
                </div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted }}>{p.yr}</div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* services */}
      <section style={{ padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <Eyebrow color={palette.muted} style={{ marginBottom: 16 }}>Services</Eyebrow>
        <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: '0 0 64px', letterSpacing: '-0.015em' }}>What we do.</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 36, borderTop: `1px solid ${palette.line}`, paddingTop: 32 }}>
          {SERVICES.map(s => (
            <div key={s.n}>
              <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 18, color: palette.muted, marginBottom: 16 }}>{s.n}</div>
              <h3 style={{ fontFamily: headlineFont, fontSize: 26, fontWeight: 400, margin: '0 0 12px', letterSpacing: '-0.01em' }}>{s.t}</h3>
              <p style={{ fontSize: 13, lineHeight: 1.6, color: palette.muted, margin: 0 }}>{s.d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* awards */}
      <section style={{ padding: '90px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 80, marginBottom: 32 }}>
          <Eyebrow color={palette.muted}>Awards</Eyebrow>
          <div style={{ fontFamily: headlineFont, fontSize: 32, lineHeight: 1.2, letterSpacing: '-0.015em', maxWidth: 720 }}>
            <em style={{ fontStyle: 'italic' }}>Homes Architect of the Year, 2025</em> — British Homes Awards.
          </div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 80 }}>
          <div />
          <div>
            {AWARDS.map((a,i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: '80px 1fr 1fr 90px', padding: '18px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted }}>{a.yr}</div>
                <div style={{ fontFamily: headlineFont, fontSize: 18, letterSpacing: '-0.01em' }}>{a.t}</div>
                <div style={{ fontSize: 13, color: palette.muted }}>{a.by}</div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.1em', textTransform: 'uppercase', color: a.k === 'win' ? palette.fg : palette.muted, textAlign: 'right' }}>{a.k === 'win' ? 'Winner' : 'Shortlist'}</div>
              </div>
            ))}
            <div style={{ borderTop: `1px solid ${palette.line}` }} />
          </div>
        </div>
      </section>

      {/* press */}
      <section style={{ padding: '100px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 80 }}>
          <Eyebrow color={palette.muted}>Press</Eyebrow>
          <div>
            {PRESS.map((p,i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: '160px 1fr 60px', padding: '20px 0', borderTop: i === 0 ? `1px solid ${palette.line}` : 'none', borderBottom: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted }}>{p.src}</div>
                <div style={{ fontFamily: headlineFont, fontSize: 20, letterSpacing: '-0.01em' }}>“{p.line}”</div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, textAlign: 'right' }}>{p.yr}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* testimonial */}
      <section style={{ padding: '140px 56px', textAlign: 'center', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 40, lineHeight: 1.25, fontWeight: 400, maxWidth: 1000, margin: '0 auto', letterSpacing: '-0.01em' }}>“{TESTIMONIALS[0].q}”</div>
        <Eyebrow color={palette.muted} style={{ marginTop: 32 }}>{TESTIMONIALS[0].a}</Eyebrow>
      </section>

      {/* journal */}
      <section style={{ padding: '100px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 40 }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 40, fontWeight: 400, margin: 0 }}>Journal</h2>
          <a style={{ fontSize: 13 }}>All posts →</a>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 28 }}>
          {JOURNAL.map((j,i) => (
            <div key={i} style={{ borderTop: `1px solid ${palette.line}`, paddingTop: 20 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted, marginBottom: 24 }}>
                <span>{j.tag} · {j.yr}</span><span>{j.read}</span>
              </div>
              <div style={{ fontFamily: headlineFont, fontSize: 26, lineHeight: 1.2, letterSpacing: '-0.01em' }}>{j.t}</div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA + newsletter + footer */}
      <section style={{ padding: '120px 56px', background: palette.cta, color: palette.ctaFg, display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 80 }}>
        <div>
          <h2 style={{ fontFamily: headlineFont, fontSize: 64, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>Tell us about your house.</h2>
          <button style={{ marginTop: 36, background: '#fff', color: '#1a1714', border: 0, padding: '18px 32px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
        </div>
        <div>
          <Eyebrow color="rgba(255,255,255,.6)" style={{ marginBottom: 16 }}>Newsletter</Eyebrow>
          <div style={{ fontSize: 14, opacity: .9, marginBottom: 20 }}>Two letters a year. New work, recent writing.</div>
          <div style={{ display: 'flex', borderBottom: '1px solid rgba(255,255,255,.4)', paddingBottom: 12 }}>
            <input placeholder="email@address" style={{ flex: 1, background: 'transparent', border: 0, color: '#fff', fontSize: 14, outline: 'none' }} />
            <span style={{ fontSize: 12, opacity: .8 }}>Subscribe →</span>
          </div>
        </div>
      </section>

      <footer style={{ padding: '40px 56px', display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted }}>
        <div>Coffey Residential · 104–110 Goswell Road, Clerkenwell, London EC1V 7DH</div>
        <div>contact@coffeyresidential.com</div>
        <div>© 2026</div>
      </footer>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// VARIATION 2 — QUIET TYPE-LED
// Side rail nav (left), no hero image — oversized headline as hero.
// Sparse projects shown as a list-as-index. Maximum whitespace.
// ═══════════════════════════════════════════════════════════════════════
function V2Quiet({ headlineFont, bodyFont, heroMedia, gridDensity, palette, copy }) {
  const c = COPY[copy];
  const showCount = gridDensity === 'sparse' ? 4 : gridDensity === 'dense' ? 6 : 5;
  return (
    <div style={{
      width: W, fontFamily: bodyFont,
      background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55,
      display: 'grid', gridTemplateColumns: '180px 1fr',
    }}>
      {/* side rail */}
      <aside style={{ padding: '40px 28px', borderRight: `1px solid ${palette.line}`, position: 'sticky', top: 0, alignSelf: 'start' }}>
        <div style={{ fontFamily: WORDMARK_FONT, fontSize: 15, lineHeight: 1.1, marginBottom: 56 }}>Coffey<br/>Residential</div>
        <nav style={{ display: 'flex', flexDirection: 'column', gap: 14, fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.1em', textTransform: 'uppercase' }}>
          {['Index','Studio','Process','Press','Journal','Contact'].map((n,i) => (
            <a key={n} style={{ color: i === 0 ? palette.fg : palette.muted, textDecoration: 'none', display: 'flex', justifyContent: 'space-between' }}>
              <span>{n}</span><span style={{ opacity: .4 }}>0{i+1}</span>
            </a>
          ))}
        </nav>
        <div style={{ marginTop: 80, fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted, lineHeight: 2 }}>
          London<br/>Since 2005<br/>RIBA Chartered
        </div>
      </aside>

      <main>
        {/* hero — pure type, no image */}
        <section style={{ padding: '180px 80px 140px', borderBottom: `1px solid ${palette.line}` }}>
          <Eyebrow color={palette.muted} style={{ marginBottom: 80 }}>{c.eyebrow}</Eyebrow>
          <h1 style={{ fontFamily: headlineFont, fontSize: 132, lineHeight: 0.98, fontWeight: 400, margin: 0, letterSpacing: '-0.035em', maxWidth: 1100 }}>
            {c.h1Lines.map((l,i) => <div key={i} style={{ fontStyle: i === c.h1Lines.length - 1 ? 'italic' : 'normal' }}>{l}</div>)}
          </h1>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 60, marginTop: 100, paddingTop: 24, borderTop: `1px solid ${palette.line}` }}>
            <div>
              <Eyebrow color={palette.muted} style={{ marginBottom: 8 }}>Founded</Eyebrow>
              <div style={{ fontFamily: headlineFont, fontSize: 32 }}>2005</div>
            </div>
            <div>
              <Eyebrow color={palette.muted} style={{ marginBottom: 8 }}>Homes completed</Eyebrow>
              <div style={{ fontFamily: headlineFont, fontSize: 32 }}>40+</div>
            </div>
          </div>
        </section>

        {/* about — single column, narrow */}
        <section style={{ padding: '140px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <Eyebrow color={palette.muted} style={{ marginBottom: 32 }}>Studio · Note</Eyebrow>
          <h2 style={{ fontFamily: headlineFont, fontSize: 44, lineHeight: 1.15, fontWeight: 400, margin: '0 0 40px', maxWidth: 800, letterSpacing: '-0.015em' }}>{c.aboutTitle}</h2>
          <p style={{ fontSize: 17, lineHeight: 1.65, maxWidth: 720, margin: 0 }}>{c.intro}</p>
          <p style={{ fontSize: 15, lineHeight: 1.7, maxWidth: 720, marginTop: 20, color: palette.muted }}>{c.aboutBody}</p>
        </section>

        {/* projects — index list */}
        <section style={{ padding: '140px 80px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 60 }}>
            <h2 style={{ fontFamily: headlineFont, fontSize: 44, fontWeight: 400, margin: 0 }}>Index of homes.</h2>
            <Eyebrow color={palette.muted}>2021 — 2024</Eyebrow>
          </div>
          {PROJECTS.slice(0, showCount).map((p,i) => (
            <a key={p.n} style={{ display: 'grid', gridTemplateColumns: '60px 1.5fr 1fr 1fr 80px', alignItems: 'baseline', padding: '32px 0', borderTop: `1px solid ${palette.line}`, color: palette.fg, textDecoration: 'none' }}>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted }}>{p.n}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 36, letterSpacing: '-0.015em' }}>{p.title}</div>
              <div style={{ fontSize: 13, color: palette.muted }}>{p.loc}</div>
              <div style={{ fontSize: 13, color: palette.muted }}>{p.tag}</div>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, textAlign: 'right' }}>{p.yr} →</div>
            </a>
          ))}
          <div style={{ borderTop: `1px solid ${palette.line}` }} />
          <Slot tone="paper" caption="single feature image · chosen project of the season" height={520} style={{ marginTop: 80 }} src={INTERIOR_2} />
        </section>

        {/* services list */}
        <section style={{ padding: '140px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <Eyebrow color={palette.muted} style={{ marginBottom: 24 }}>Services</Eyebrow>
          <div>
            {SERVICES.map((s,i) => (
              <div key={s.n} style={{ display: 'grid', gridTemplateColumns: '80px 1fr 2fr', padding: '32px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
                <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 22, color: palette.muted }}>{s.n}</div>
                <div style={{ fontFamily: headlineFont, fontSize: 28, letterSpacing: '-0.01em' }}>{s.t}</div>
                <div style={{ fontSize: 14, lineHeight: 1.6, color: palette.muted, maxWidth: 520 }}>{s.d}</div>
              </div>
            ))}
            <div style={{ borderTop: `1px solid ${palette.line}` }} />
          </div>
        </section>

        {/* press */}
        <section style={{ padding: '120px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <Eyebrow color={palette.muted} style={{ marginBottom: 32 }}>Press</Eyebrow>
          {PRESS.slice(0,4).map((p,i) => (
            <div key={i} style={{ display: 'grid', gridTemplateColumns: '160px 1fr 60px', padding: '24px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
              <Eyebrow color={palette.muted}>{p.src}</Eyebrow>
              <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 20 }}>“{p.line}”</div>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, textAlign: 'right' }}>{p.yr}</div>
            </div>
          ))}
          <div style={{ borderTop: `1px solid ${palette.line}` }} />
        </section>

        {/* testimonials — quiet, three side by side */}
        <section style={{ padding: '120px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <Eyebrow color={palette.muted} style={{ marginBottom: 48 }}>Voices</Eyebrow>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 48 }}>
            {TESTIMONIALS.map((t,i) => (
              <div key={i}>
                <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 22, lineHeight: 1.4, marginBottom: 20 }}>“{t.q}”</div>
                <Eyebrow color={palette.muted}>{t.a}</Eyebrow>
              </div>
            ))}
          </div>
        </section>

        {/* journal */}
        <section style={{ padding: '120px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <Eyebrow color={palette.muted} style={{ marginBottom: 32 }}>Journal</Eyebrow>
          {JOURNAL.map((j,i) => (
            <div key={i} style={{ display: 'grid', gridTemplateColumns: '120px 1fr 80px', padding: '24px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
              <Eyebrow color={palette.muted}>{j.tag} · {j.yr}</Eyebrow>
              <div style={{ fontFamily: headlineFont, fontSize: 22 }}>{j.t}</div>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, textAlign: 'right' }}>{j.read}</div>
            </div>
          ))}
          <div style={{ borderTop: `1px solid ${palette.line}` }} />
        </section>

        {/* CTA + newsletter */}
        <section style={{ padding: '160px 80px', borderBottom: `1px solid ${palette.line}` }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 80, fontWeight: 400, lineHeight: 1, margin: 0, letterSpacing: '-0.025em' }}>Write to us.</h2>
          <p style={{ fontSize: 17, marginTop: 32, maxWidth: 640, color: palette.muted }}>We answer every email. Most projects start with a long, slow conversation.</p>
          <div style={{ display: 'flex', gap: 16, marginTop: 48 }}>
            <button style={{ background: palette.fg, color: palette.bg, border: 0, padding: '18px 28px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
            <button style={{ background: 'transparent', color: palette.fg, border: `1px solid ${palette.line}`, padding: '18px 28px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>Newsletter →</button>
          </div>
        </section>

        <footer style={{ padding: '40px 80px', display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted }}>
          <div>104–110 Goswell Road · Clerkenwell · London</div>
          <div>© 2026 · RIBA Chartered Practice</div>
        </footer>
      </main>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// VARIATION 3 — CINEMATIC DARK
// Fixed left vertical nav, full-screen video hero, dark palette,
// full-bleed projects with overlapping captions.
// ═══════════════════════════════════════════════════════════════════════
function V3Cinematic({ headlineFont, bodyFont, heroMedia, gridDensity, palette, copy }) {
  const c = COPY[copy];
  const dense = gridDensity === 'dense';
  const dark = { bg: '#15130f', fg: '#f1ece0', line: 'rgba(241,236,224,.12)', muted: 'rgba(241,236,224,.5)', accent: palette.accent || '#c8a878' };
  return (
    <div style={{
      width: W, fontFamily: bodyFont,
      background: dark.bg, color: dark.fg, fontSize: 14, lineHeight: 1.55,
    }}>
      {/* fixed left nav (within artboard, position absolute) */}
      <div style={{ position: 'absolute', left: 32, top: 32, zIndex: 5, fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase', color: '#fff' }}>
        Coffey — Residential
      </div>
      <div style={{ position: 'absolute', right: 32, top: 32, zIndex: 5, display: 'flex', gap: 24, fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', color: '#fff' }}>
        {['Work','Studio','Press','Contact'].map(n => <a key={n} style={{ color: '#fff', textDecoration: 'none' }}>{n}</a>)}
      </div>

      {/* hero - full bleed video */}
      <section style={{ position: 'relative', height: 880 }}>
        <HeroMedia heroMedia={heroMedia} tone="ink" dark caption="reel · 90s sequence across four homes, ambient sound" label="reel · 2024" height="100%" src={HERO_DARK} />
        <div style={{ position: 'absolute', inset: 0, padding: '0 56px 64px', display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', color: '#fff' }}>
          <Eyebrow color="rgba(255,255,255,.7)" style={{ marginBottom: 32 }}>{c.eyebrow}</Eyebrow>
          <h1 style={{ fontFamily: headlineFont, fontSize: 112, lineHeight: 1, fontWeight: 400, margin: 0, letterSpacing: '-0.025em', maxWidth: 1100 }}>
            {c.h1Lines.map((l,i) => <div key={i}>{l}</div>)}
          </h1>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginTop: 48 }}>
            <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', opacity: .8 }}>Scroll ↓</div>
            <div style={{ display: 'flex', gap: 40, fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.12em', textTransform: 'uppercase' }}>
              <div><div style={{ opacity: .55, marginBottom: 4 }}>Now showing</div>Hampstead House</div>
              <div><div style={{ opacity: .55, marginBottom: 4 }}>Sound</div>On</div>
            </div>
          </div>
        </div>
      </section>

      {/* about — narrow, centered, on dark */}
      <section style={{ padding: '160px 56px', textAlign: 'center', borderBottom: `1px solid ${dark.line}` }}>
        <Eyebrow color={dark.muted} style={{ marginBottom: 32 }}>{c.aboutTitle}</Eyebrow>
        <p style={{ fontFamily: headlineFont, fontSize: 42, lineHeight: 1.3, fontWeight: 400, margin: 0, maxWidth: 1100, marginInline: 'auto', letterSpacing: '-0.01em' }}>{c.intro}</p>
      </section>

      {/* projects — full-bleed alternating */}
      {PROJECTS.slice(0, dense ? 6 : 4).map((p, i) => (
        <section key={p.n} style={{ position: 'relative', padding: '0', borderBottom: `1px solid ${dark.line}` }}>
          <Slot tone={i % 2 ? 'char' : 'ink'} dark caption={p.cap} height={dense ? 540 : 720} src={p.img} />
          <div style={{ padding: '32px 56px 40px', display: 'grid', gridTemplateColumns: '80px 1fr 1fr 1fr', alignItems: 'baseline' }}>
            <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: dark.muted }}>{p.n} / 06</div>
            <div style={{ fontFamily: headlineFont, fontSize: 40, letterSpacing: '-0.015em' }}>{p.title}</div>
            <div style={{ fontSize: 13, color: dark.muted }}>{p.loc} · {p.tag}</div>
            <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: dark.muted, textAlign: 'right' }}>{p.yr} →</div>
          </div>
        </section>
      ))}

      {/* services as dark cards */}
      <section style={{ padding: '120px 56px', borderBottom: `1px solid ${dark.line}` }}>
        <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: '0 0 60px', letterSpacing: '-0.02em' }}>How we work.</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 1, background: dark.line }}>
          {SERVICES.map(s => (
            <div key={s.n} style={{ background: dark.bg, padding: '32px 28px', minHeight: 280 }}>
              <div style={{ color: dark.accent, fontFamily: headlineFont, fontStyle: 'italic', fontSize: 18, marginBottom: 28 }}>{s.n}</div>
              <h3 style={{ fontFamily: headlineFont, fontSize: 26, fontWeight: 400, margin: '0 0 16px' }}>{s.t}</h3>
              <p style={{ fontSize: 13, lineHeight: 1.65, color: dark.muted, margin: 0 }}>{s.d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* testimonial */}
      <section style={{ padding: '160px 56px', borderBottom: `1px solid ${dark.line}` }}>
        <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 56, lineHeight: 1.2, fontWeight: 400, maxWidth: 1100, letterSpacing: '-0.015em' }}>“{TESTIMONIALS[2].q}”</div>
        <Eyebrow color={dark.muted} style={{ marginTop: 36 }}>{TESTIMONIALS[2].a}</Eyebrow>
      </section>

      {/* press strip */}
      <section style={{ padding: '80px 56px', borderBottom: `1px solid ${dark.line}` }}>
        <Eyebrow color={dark.muted} style={{ marginBottom: 32 }}>Press</Eyebrow>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 40, alignItems: 'center' }}>
          {PRESS.map((p,i) => (
            <div key={i} style={{ fontFamily: headlineFont, fontSize: 22, color: i === 0 ? dark.fg : dark.muted, letterSpacing: '-0.01em' }}>{p.src}</div>
          ))}
        </div>
      </section>

      {/* journal */}
      <section style={{ padding: '120px 56px', borderBottom: `1px solid ${dark.line}` }}>
        <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: '0 0 48px' }}>Recent writing</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 32 }}>
          {JOURNAL.map((j,i) => (
            <div key={i}>
              <Slot tone="char" dark caption={`essay artwork · ${j.t.toLowerCase()}`} height={240} src={[INTERIOR_1, INTERIOR_2, HERO_WARM][i % 3]} />
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 16 }}>
                <Eyebrow color={dark.muted}>{j.tag} · {j.yr}</Eyebrow>
                <Eyebrow color={dark.muted}>{j.read}</Eyebrow>
              </div>
              <div style={{ fontFamily: headlineFont, fontSize: 24, marginTop: 12, letterSpacing: '-0.01em' }}>{j.t}</div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA full-bleed */}
      <section style={{ padding: '180px 56px', textAlign: 'center' }}>
        <h2 style={{ fontFamily: headlineFont, fontSize: 96, fontWeight: 400, margin: 0, letterSpacing: '-0.03em', lineHeight: 1 }}>Tell us about <em style={{ color: dark.accent }}>your house</em>.</h2>
        <button style={{ marginTop: 48, background: dark.accent, color: dark.bg, border: 0, padding: '20px 36px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.16em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
        <div style={{ marginTop: 32, fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.12em', textTransform: 'uppercase', color: dark.muted }}>Or write · contact@coffeyresidential.com</div>
      </section>

      <footer style={{ padding: '40px 56px', display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: dark.muted, borderTop: `1px solid ${dark.line}` }}>
        <div>Coffey Residential — High End Residential Architects, London</div>
        <div>© 2026</div>
      </footer>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// VARIATION 4 — WARM ASYMMETRIC
// Split hero (text left, large image right), asymmetric mixed grid,
// cream/sage palette with terracotta accent.
// ═══════════════════════════════════════════════════════════════════════
function V4Warm({ headlineFont, bodyFont, heroMedia, gridDensity, palette, copy }) {
  const c = COPY[copy];
  const cols = gridDensity === 'sparse' ? 6 : gridDensity === 'dense' ? 12 : 8;
  return (
    <div style={{
      width: W, fontFamily: bodyFont,
      background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55,
    }}>
      {/* nav — split logo + nav, with phone */}
      <header style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '24px 48px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 32, height: 32, borderRadius: '50%', background: palette.accent }} />
          <div style={{ fontFamily: WORDMARK_FONT, fontSize: 15, letterSpacing: '-0.01em' }}>Coffey Residential</div>
        </div>
        <nav style={{ display: 'flex', gap: 32, fontSize: 13 }}>
          {['Homes','Studio','Process','Press','Journal'].map(n => <a key={n} style={{ color: palette.fg, textDecoration: 'none' }}>{n}</a>)}
        </nav>
        <button style={{ background: palette.fg, color: palette.bg, border: 0, padding: '12px 22px', fontSize: 12, letterSpacing: '.05em', textTransform: 'uppercase', cursor: 'pointer', borderRadius: 999, fontFamily: 'inherit', fontWeight: 500 }}>{c.cta}</button>
      </header>

      {/* split hero */}
      <section style={{ display: 'grid', gridTemplateColumns: '1fr 1.2fr', gap: 0, padding: '0 0 0 48px', alignItems: 'stretch', minHeight: 720 }}>
        <div style={{ paddingRight: 48, paddingTop: 80, paddingBottom: 80, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
          <div>
            <Eyebrow color={palette.muted} style={{ marginBottom: 28 }}>{c.eyebrow}</Eyebrow>
            <h1 style={{ fontFamily: headlineFont, fontSize: 88, lineHeight: 1.02, fontWeight: 400, margin: 0, letterSpacing: '-0.03em' }}>
              {c.h1Lines.map((l,i) => <div key={i} style={{ color: i === 1 ? palette.accent : palette.fg, fontStyle: i === 1 ? 'italic' : 'normal' }}>{l}</div>)}
            </h1>
            <p style={{ fontSize: 16, lineHeight: 1.65, marginTop: 32, maxWidth: 480, color: palette.muted }}>Houses in London. New builds, refurbishments, extensions.</p>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 16, paddingTop: 32, borderTop: `1px solid ${palette.line}` }}>
            <button style={{ background: palette.accent, color: '#fff', border: 0, padding: '16px 26px', fontSize: 12, letterSpacing: '.08em', textTransform: 'uppercase', borderRadius: 999, cursor: 'pointer', fontFamily: 'inherit', fontWeight: 500 }}>{c.cta} →</button>
            <a style={{ fontSize: 13, color: palette.fg }}>See homes</a>
          </div>
        </div>
        <div style={{ position: 'relative' }}>
          <HeroMedia heroMedia={heroMedia} tone="sage" dark={false} caption="hero · Holland Park villa, glazed rear extension" label="featured · 03" height="100%" src={HERO_WARM} />
        </div>
      </section>

      {/* about — image + text columns */}
      <section style={{ padding: '140px 48px', borderTop: `1px solid ${palette.line}`, marginTop: 80 }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr', gap: 80, alignItems: 'flex-start' }}>
          <Slot tone="cream" caption="portrait · Phil + studio team, working photo" height={560} src={INTERIOR_2} />
          <div style={{ paddingTop: 40 }}>
            <Eyebrow color={palette.accent} style={{ marginBottom: 20 }}>About · The Practice</Eyebrow>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: '0 0 32px', letterSpacing: '-0.02em' }}>{c.aboutTitle}</h2>
            <p style={{ fontSize: 17, lineHeight: 1.65, margin: 0 }}>{c.intro}</p>
            <p style={{ fontSize: 15, lineHeight: 1.7, marginTop: 20, color: palette.muted }}>{c.aboutBody}</p>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24, marginTop: 48, paddingTop: 32, borderTop: `1px solid ${palette.line}` }}>
              {[['2005','Founded'],['40+','Homes'],['London','Studio']].map(([n,l],i) => (
                <div key={i}>
                  <div style={{ fontFamily: headlineFont, fontSize: 40 }}>{n}</div>
                  <Eyebrow color={palette.muted} style={{ marginTop: 4 }}>{l}</Eyebrow>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* asymmetric project grid */}
      <section style={{ padding: '120px 48px', borderTop: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 48 }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Selected homes.</h2>
          <a style={{ fontSize: 13 }}>All work →</a>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: `repeat(${cols}, 1fr)`, gap: 24, gridAutoRows: 'minmax(0, auto)' }}>
          {/* hand-tuned spans for asymmetric rhythm */}
          {[
            { p: PROJECTS[0], col: cols === 6 ? 4 : cols === 12 ? 7 : 5, h: 520 },
            { p: PROJECTS[1], col: cols === 6 ? 2 : cols === 12 ? 5 : 3, h: 380 },
            { p: PROJECTS[2], col: cols === 6 ? 3 : cols === 12 ? 5 : 4, h: 420 },
            { p: PROJECTS[3], col: cols === 6 ? 3 : cols === 12 ? 7 : 4, h: 420 },
            { p: PROJECTS[4], col: cols === 6 ? 6 : cols === 12 ? 8 : 5, h: 480 },
            { p: PROJECTS[5], col: cols === 6 ? 6 : cols === 12 ? 4 : 3, h: 480 },
          ].map((it,i) => (
            <div key={it.p.n} style={{ gridColumn: `span ${it.col}` }}>
              <Slot tone={['cream','sage','warm','paper','bone','stone'][i]} caption={it.p.cap} height={it.h} src={it.p.img} />
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 14 }}>
                <div>
                  <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.01em' }}>{it.p.title}</div>
                  <div style={{ fontSize: 12, color: palette.muted }}>{it.p.loc} · {it.p.tag}</div>
                </div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted }}>{it.p.yr}</div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* services — soft cards */}
      <section style={{ padding: '120px 48px', borderTop: `1px solid ${palette.line}`, background: palette.softBg || palette.bg }}>
        <Eyebrow color={palette.accent} style={{ marginBottom: 16 }}>Services</Eyebrow>
        <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: '0 0 48px', letterSpacing: '-0.02em' }}>What the studio does.</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 32 }}>
          {SERVICES.map(s => (
            <div key={s.n} style={{ background: palette.bg, padding: 36, borderRadius: 6, border: `1px solid ${palette.line}` }}>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 16, marginBottom: 16 }}>
                <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 22, color: palette.accent }}>{s.n}</div>
                <h3 style={{ fontFamily: headlineFont, fontSize: 28, fontWeight: 400, margin: 0, letterSpacing: '-0.01em' }}>{s.t}</h3>
              </div>
              <p style={{ fontSize: 14, lineHeight: 1.65, color: palette.muted, margin: 0 }}>{s.d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* testimonials carousel feel — 3 cards */}
      <section style={{ padding: '120px 48px', borderTop: `1px solid ${palette.line}` }}>
        <Eyebrow color={palette.accent} style={{ marginBottom: 32 }}>From clients</Eyebrow>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24 }}>
          {TESTIMONIALS.map((t,i) => (
            <div key={i} style={{ padding: 32, background: i === 1 ? palette.accent : palette.softBg, color: i === 1 ? '#fff' : palette.fg, borderRadius: 6 }}>
              <div style={{ fontFamily: headlineFont, fontSize: 22, lineHeight: 1.4, fontStyle: 'italic' }}>“{t.q}”</div>
              <Eyebrow color={i === 1 ? 'rgba(255,255,255,.7)' : palette.muted} style={{ marginTop: 24 }}>{t.a}</Eyebrow>
            </div>
          ))}
        </div>
      </section>

      {/* press + journal as 2-col */}
      <section style={{ padding: '120px 48px', borderTop: `1px solid ${palette.line}`, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80 }}>
        <div>
          <Eyebrow color={palette.accent} style={{ marginBottom: 24 }}>Press</Eyebrow>
          {PRESS.slice(0,4).map((p,i) => (
            <div key={i} style={{ padding: '20px 0', borderTop: `1px solid ${palette.line}` }}>
              <Eyebrow color={palette.muted} style={{ marginBottom: 6 }}>{p.src} · {p.yr}</Eyebrow>
              <div style={{ fontFamily: headlineFont, fontSize: 20, fontStyle: 'italic' }}>“{p.line}”</div>
            </div>
          ))}
        </div>
        <div>
          <Eyebrow color={palette.accent} style={{ marginBottom: 24 }}>Journal</Eyebrow>
          {JOURNAL.map((j,i) => (
            <div key={i} style={{ padding: '20px 0', borderTop: `1px solid ${palette.line}` }}>
              <Eyebrow color={palette.muted} style={{ marginBottom: 6 }}>{j.tag} · {j.read}</Eyebrow>
              <div style={{ fontFamily: headlineFont, fontSize: 22 }}>{j.t}</div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA + newsletter */}
      <section style={{ padding: '120px 48px', borderTop: `1px solid ${palette.line}`, background: palette.accent, color: '#fff' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 80, alignItems: 'flex-end' }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 72, fontWeight: 400, margin: 0, letterSpacing: '-0.025em', lineHeight: 1.05 }}>Write to us.</h2>
          <div>
            <Eyebrow color="rgba(255,255,255,.7)" style={{ marginBottom: 16 }}>Newsletter</Eyebrow>
            <div style={{ display: 'flex', borderBottom: '1px solid rgba(255,255,255,.4)', paddingBottom: 12 }}>
              <input placeholder="email@address" style={{ flex: 1, background: 'transparent', border: 0, color: '#fff', fontSize: 14, outline: 'none' }} />
              <span style={{ fontSize: 12 }}>Subscribe →</span>
            </div>
          </div>
        </div>
      </section>

      <footer style={{ padding: '40px 48px', display: 'flex', justifyContent: 'space-between', fontSize: 12, color: palette.muted }}>
        <div>© 2026 Coffey Residential</div>
        <div>RIBA Chartered · ARB Registered</div>
        <div>contact@coffeyresidential.com</div>
      </footer>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// VARIATION 5 — MODERN INDEX
// Numbered sticky utility nav, list-as-grid projects, monospace details
// throughout, near-black with brass accent.
// ═══════════════════════════════════════════════════════════════════════
function V5Index({ headlineFont, bodyFont, heroMedia, gridDensity, palette, copy }) {
  const c = COPY[copy];
  const detail = gridDensity === 'sparse' ? false : gridDensity === 'dense' ? true : true;
  const M = 'JetBrains Mono, ui-monospace, monospace';
  return (
    <div style={{
      width: W, fontFamily: bodyFont,
      background: palette.bg, color: palette.fg, fontSize: 13, lineHeight: 1.55,
    }}>
      {/* numbered nav */}
      <header style={{ position: 'relative', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '20px 40px' }}>
          <div style={{ fontFamily: M, fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase' }}>Coffey/Residential <span style={{ color: palette.muted }}>— LDN</span></div>
          <div style={{ fontFamily: M, fontSize: 11, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted }}>{new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).toUpperCase()} · 51.5°N 0.1°W</div>
          <div style={{ fontFamily: M, fontSize: 11, letterSpacing: '.12em', textTransform: 'uppercase' }}>EN · EU</div>
        </div>
        <nav style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', borderTop: `1px solid ${palette.line}` }}>
          {[['00','Index'],['01','Homes'],['02','Studio'],['03','Process'],['04','Press'],['05','Journal'],['06','Contact']].map(([n,t],i) => (
            <a key={n} style={{ display: 'flex', alignItems: 'baseline', gap: 8, padding: '14px 20px', borderRight: i < 6 ? `1px solid ${palette.line}` : 'none', textDecoration: 'none', color: palette.fg, fontFamily: M, fontSize: 11, letterSpacing: '.12em', textTransform: 'uppercase' }}>
              <span style={{ color: palette.muted }}>{n}</span>{t}
            </a>
          ))}
        </nav>
      </header>

      {/* hero — split: oversized headline + hero image */}
      <section style={{ borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ padding: '80px 40px 48px', display: 'grid', gridTemplateColumns: '60px 1fr 200px', alignItems: 'flex-start', gap: 32 }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>00.0</div>
          <h1 style={{ fontFamily: headlineFont, fontSize: 120, lineHeight: 0.96, fontWeight: 400, margin: 0, letterSpacing: '-0.04em' }}>
            {c.h1Lines.map((l,i) => <div key={i}>{l}</div>)}
          </h1>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.05em', lineHeight: 1.7 }}>
            <div style={{ color: palette.fg }}>{c.eyebrow}</div>
            <div style={{ marginTop: 16 }}>EST — 2005</div>
            <div>RIBA — CHARTERED</div>
            <div>RANK — YAOTY 2012</div>
          </div>
        </div>
        <div style={{ borderTop: `1px solid ${palette.line}`, padding: '0 40px' }}>
          <HeroMedia heroMedia={heroMedia} tone="ink" dark caption="00.1 · hero — Hampstead House, garden facade" label="hero" height={520} src={HERO_IMG} objectPosition="center 60%" />
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', borderTop: `1px solid ${palette.line}` }}>
          {[['Founded','2005'],['Homes','40+'],['Awards','RIBA × 4']].map(([l,v],i) => (
            <div key={l} style={{ padding: '20px 28px', borderRight: i < 2 ? `1px solid ${palette.line}` : 'none' }}>
              <div style={{ fontFamily: M, fontSize: 10, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>{l}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 24, marginTop: 4 }}>{v}</div>
            </div>
          ))}
        </div>
      </section>

      {/* about */}
      <section style={{ padding: '100px 40px', borderBottom: `1px solid ${palette.line}`, display: 'grid', gridTemplateColumns: '60px 1fr 1fr 1fr', gap: 32 }}>
        <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>02.0</div>
        <h2 style={{ fontFamily: headlineFont, fontSize: 44, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', gridColumn: 'span 1' }}>{c.aboutTitle}</h2>
        <p style={{ fontSize: 15, lineHeight: 1.65, margin: 0 }}>{c.intro}</p>
        <p style={{ fontSize: 14, lineHeight: 1.7, margin: 0, color: palette.muted }}>{c.aboutBody}</p>
      </section>

      {/* projects — list-as-grid (rows with thumbnail on hover state) */}
      <section style={{ borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ padding: '60px 40px 24px', display: 'grid', gridTemplateColumns: '60px 1fr 200px', alignItems: 'baseline' }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>01.0</div>
          <h2 style={{ fontFamily: headlineFont, fontSize: 44, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Index of homes.</h2>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase', textAlign: 'right' }}>n={PROJECTS.length}</div>
        </div>
        <div style={{ borderTop: `1px solid ${palette.line}` }}>
          <div style={{ display: 'grid', gridTemplateColumns: '60px 80px 1fr 200px 200px 100px 80px', padding: '12px 40px', borderBottom: `1px solid ${palette.line}`, fontFamily: M, fontSize: 10, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>
            <div>No.</div><div>Year</div><div>Project</div><div>Location</div><div>Type</div><div>Status</div><div></div>
          </div>
          {PROJECTS.map(p => (
            <a key={p.n} style={{ display: 'grid', gridTemplateColumns: '60px 80px 1fr 200px 200px 100px 80px', padding: '20px 40px', borderBottom: `1px solid ${palette.line}`, alignItems: 'center', textDecoration: 'none', color: palette.fg }}>
              <div style={{ fontFamily: M, fontSize: 11, color: palette.muted }}>{p.n}</div>
              <div style={{ fontFamily: M, fontSize: 11, color: palette.muted }}>{p.yr}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.01em' }}>{p.title}</div>
              <div style={{ fontSize: 13 }}>{p.loc}</div>
              <div style={{ fontSize: 13, color: palette.muted }}>{p.tag}</div>
              <div style={{ fontFamily: M, fontSize: 11, color: palette.accent, letterSpacing: '.1em', textTransform: 'uppercase' }}>Complete</div>
              <div style={{ fontFamily: M, fontSize: 14, color: palette.muted, textAlign: 'right' }}>→</div>
            </a>
          ))}
        </div>
        {detail && (
          <div style={{ padding: '40px', display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16, borderBottom: `1px solid ${palette.line}` }}>
            {PROJECTS.slice(0,3).map((p,i) => (
              <Slot key={p.n} tone={['ink','char','warm'][i]} dark={i < 2} caption={p.cap} height={260} label={p.n} src={p.img} />
            ))}
          </div>
        )}
      </section>

      {/* services */}
      <section style={{ padding: '100px 40px 0', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '60px 1fr', gap: 32, marginBottom: 48 }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>03.0</div>
          <h2 style={{ fontFamily: headlineFont, fontSize: 44, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Service index.</h2>
        </div>
        <div style={{ borderTop: `1px solid ${palette.line}` }}>
          {SERVICES.map((s,i) => (
            <div key={s.n} style={{ display: 'grid', gridTemplateColumns: '60px 80px 1fr 2fr', padding: '32px 0', borderBottom: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
              <div style={{ fontFamily: M, fontSize: 11, color: palette.muted }}>03.{i+1}</div>
              <div style={{ fontFamily: M, fontSize: 11, color: palette.accent, letterSpacing: '.1em', textTransform: 'uppercase' }}>{s.n}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 28, letterSpacing: '-0.01em' }}>{s.t}</div>
              <div style={{ fontSize: 14, lineHeight: 1.65, color: palette.muted, maxWidth: 560 }}>{s.d}</div>
            </div>
          ))}
        </div>
      </section>

      {/* press */}
      <section style={{ padding: '80px 40px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '60px 1fr', gap: 32, marginBottom: 32 }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>04.0</div>
          <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0 }}>Press · Awards</h2>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', borderTop: `1px solid ${palette.line}` }}>
          {PRESS.map((p,i) => (
            <div key={i} style={{ padding: 24, borderRight: i < 4 ? `1px solid ${palette.line}` : 'none' }}>
              <div style={{ fontFamily: M, fontSize: 10, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase', marginBottom: 12 }}>{p.src} · {p.yr}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 18, fontStyle: 'italic', lineHeight: 1.3 }}>“{p.line}”</div>
            </div>
          ))}
        </div>
      </section>

      {/* testimonial — single, centred, with index */}
      <section style={{ padding: '120px 40px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase', marginBottom: 32 }}>05.0 · Voice 01/03</div>
        <div style={{ fontFamily: headlineFont, fontSize: 48, lineHeight: 1.25, fontStyle: 'italic', maxWidth: 1100, letterSpacing: '-0.01em' }}>“{TESTIMONIALS[1].q}”</div>
        <Eyebrow color={palette.muted} style={{ marginTop: 32 }}>{TESTIMONIALS[1].a}</Eyebrow>
      </section>

      {/* journal */}
      <section style={{ padding: '80px 40px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '60px 1fr', gap: 32, marginBottom: 32 }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>06.0</div>
          <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0 }}>Field notes</h2>
        </div>
        {JOURNAL.map((j,i) => (
          <div key={i} style={{ display: 'grid', gridTemplateColumns: '60px 80px 1fr 100px', padding: '20px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
            <div style={{ fontFamily: M, fontSize: 11, color: palette.muted }}>06.{i+1}</div>
            <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>{j.tag}</div>
            <div style={{ fontFamily: headlineFont, fontSize: 22 }}>{j.t}</div>
            <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, textAlign: 'right' }}>{j.yr} · {j.read}</div>
          </div>
        ))}
        <div style={{ borderTop: `1px solid ${palette.line}` }} />
      </section>

      {/* CTA + newsletter — strict utility */}
      <section style={{ padding: '120px 40px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '60px 1fr 1fr', gap: 32 }}>
          <div style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>07.0</div>
          <div>
            <h2 style={{ fontFamily: headlineFont, fontSize: 64, fontWeight: 400, margin: 0, letterSpacing: '-0.025em', lineHeight: 1.05 }}>Begin</h2>
            <button style={{ marginTop: 32, background: palette.fg, color: palette.bg, border: 0, padding: '16px 28px', fontFamily: M, fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
          </div>
          <div>
            <Eyebrow color={palette.muted} style={{ marginBottom: 16 }}>07.1 · Newsletter</Eyebrow>
            <div style={{ display: 'flex', borderBottom: `1px solid ${palette.line}`, paddingBottom: 12 }}>
              <input placeholder="email@address" style={{ flex: 1, background: 'transparent', border: 0, color: palette.fg, fontSize: 14, outline: 'none' }} />
              <span style={{ fontFamily: M, fontSize: 11, color: palette.muted, letterSpacing: '.1em', textTransform: 'uppercase' }}>Subscribe →</span>
            </div>
            <div style={{ fontSize: 12, color: palette.muted, marginTop: 12 }}>Two letters a year. Unsubscribe any time.</div>
          </div>
        </div>
      </section>

      <footer style={{ padding: '24px 40px', display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', fontFamily: M, fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted, gap: 24 }}>
        <div>Coffey/Residential</div>
        <div>104–110 Goswell Road · EC1V 7DH</div>
        <div>contact@coffeyresidential.com</div>
        <div style={{ textAlign: 'right' }}>© 2026 · RIBA · ARB</div>
      </footer>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════
// VARIATION 6 — EDITORIAL HYBRID
// Editorial Classic chassis (proven info architecture, light palette,
// magazine-style hierarchy) with three Cinematic moves grafted in:
//   1. Oversized headline-over-image hero
//   2. Full-bleed alternating project rows (instead of 3-up grid)
//   3. Big italic pull-quote testimonial
// Stays on the user's palette (not forced dark).
// ═══════════════════════════════════════════════════════════════════════
function V6Hybrid({ headlineFont, bodyFont, heroMedia, gridDensity, palette, copy }) {
  const c = COPY[copy];
  const shown = gridDensity === 'sparse' ? 3 : gridDensity === 'dense' ? 6 : 4;
  return (
    <div style={{
      width: W, fontFamily: bodyFont,
      background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55,
    }}>
      {/* nav — same as V1 */}
      <header style={{
        display: 'grid', gridTemplateColumns: '1fr auto 1fr',
        alignItems: 'center', padding: '28px 56px', borderBottom: `1px solid ${palette.line}`,
      }}>
        <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', color: palette.muted }}>London · Est. 2005</div>
        <div style={{ fontFamily: WORDMARK_FONT, fontSize: 16, letterSpacing: '.02em', textAlign: 'center' }}>Coffey<span style={{ opacity: .35, margin: '0 6px' }}>|</span>Residential</div>
        <nav style={{ display: 'flex', gap: 28, justifyContent: 'flex-end', fontSize: 13 }}>
          {['Homes','Studio','Process','Press','Journal','Contact'].map(n => <a key={n} style={{ color: palette.fg, textDecoration: 'none' }}>{n}</a>)}
        </nav>
      </header>

      {/* HERO — oversized headline over image (Cinematic move #2) */}
      <section style={{ position: 'relative', height: 820 }}>
        <HeroMedia heroMedia={heroMedia} tone="ink" dark caption="hero · Hampstead House, garden room at dusk" label="01 / 06" height="100%" src={HERO_IMG} objectPosition="center 60%" />
        <div style={{ position: 'absolute', inset: 0, padding: '56px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', color: '#fff' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Eyebrow color="rgba(255,255,255,.75)">{c.eyebrow}</Eyebrow>
            <Eyebrow color="rgba(255,255,255,.6)">Now showing · Hampstead House</Eyebrow>
          </div>
          <div>
            <h1 style={{ fontFamily: headlineFont, fontSize: 128, lineHeight: 0.98, fontWeight: 400, margin: 0, letterSpacing: '-0.03em', maxWidth: 1280 }}>
              {c.h1Lines.map((l,i) => <div key={i}>{l}</div>)}
            </h1>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginTop: 40 }}>
              <div style={{ maxWidth: 460, fontSize: 15, opacity: .9, lineHeight: 1.55 }}>Houses across London. New builds, whole refurbishments, extensions.</div>
              <button style={{ background: '#fff', color: '#1a1714', border: 0, padding: '16px 28px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
            </div>
          </div>
        </div>
      </section>

      {/* about — V1 layout, kept */}
      <section style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80, padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div>
          <Eyebrow color={palette.muted} style={{ marginBottom: 24 }}>About · The Studio</Eyebrow>
          <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>{c.aboutTitle}</h2>
        </div>
        <div>
          <p style={{ fontSize: 17, lineHeight: 1.6, margin: 0, color: palette.fg }}>{c.intro}</p>
          <p style={{ fontSize: 15, lineHeight: 1.65, marginTop: 20, color: palette.muted }}>{c.aboutBody}</p>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24, marginTop: 40, paddingTop: 24, borderTop: `1px solid ${palette.line}` }}>
            {[['2005','Founded'],['40+','Homes'],['12','Studio']].map(([n,l],i) => (
              <div key={i}>
                <div style={{ fontFamily: headlineFont, fontSize: 36, letterSpacing: '-0.01em' }}>{n}</div>
                <Eyebrow color={palette.muted} style={{ marginTop: 4 }}>{l}</Eyebrow>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* PROJECTS — full-bleed alternating rows (Cinematic move #1) */}
      <section style={{ borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', padding: '120px 56px 56px' }}>
          <div>
            <Eyebrow color={palette.muted} style={{ marginBottom: 16 }}>Selected Homes · 2021–2024</Eyebrow>
            <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>Recent work.</h2>
          </div>
          <a style={{ fontSize: 13, color: palette.fg }}>All homes →</a>
        </div>
        <div>
        {PROJECTS.slice(0, shown).map((p, i) => {
          const reverse = i % 2 === 1;
          return (
            <div key={p.n} style={{
              display: 'grid', gridTemplateColumns: '1fr 1fr', borderTop: `1px solid ${palette.line}`,
              minHeight: 480,
            }}>
              <div style={{ position: 'relative', order: reverse ? 2 : 1 }}>
                <Slot tone={['bone','stone','warm','paper','cream','sage'][i % 6]} caption={p.cap} height="100%" src={p.img} />
              </div>
              <div style={{ order: reverse ? 1 : 2, padding: '56px 56px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', maxWidth: 540 }}>
                <div>
                  <Eyebrow color={palette.muted} style={{ marginBottom: 20 }}>{p.n} / {String(PROJECTS.length).padStart(2,'0')} · {p.tag}</Eyebrow>
                  <h3 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>{p.title}</h3>
                  <div style={{ fontSize: 14, color: palette.muted, marginTop: 10 }}>{p.loc}</div>
                  <p style={{ fontSize: 15, lineHeight: 1.65, marginTop: 24, color: palette.fg }}>{p.cap.charAt(0).toUpperCase() + p.cap.slice(1)}. A house that takes its cues from the site and the way the family wanted to live in it.</p>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginTop: 32 }}>
                  <a style={{ fontSize: 13, color: palette.fg }}>Read the project →</a>
                  <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, letterSpacing: '.1em' }}>{p.yr}</div>
                </div>
              </div>
            </div>
          );
        })}
        </div>
      </section>

      {/* services — V1 layout, kept */}
      <section style={{ padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <Eyebrow color={palette.muted} style={{ marginBottom: 16 }}>Services</Eyebrow>
        <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.05, fontWeight: 400, margin: '0 0 64px', letterSpacing: '-0.015em' }}>What we do.</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 28, borderTop: `1px solid ${palette.line}`, paddingTop: 32 }}>
          {SERVICES.map(s => (
            <div key={s.n}>
              <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 18, color: palette.muted, marginBottom: 16 }}>{s.n}</div>
              <h3 style={{ fontFamily: headlineFont, fontSize: 26, fontWeight: 400, margin: '0 0 12px', letterSpacing: '-0.01em' }}>{s.t}</h3>
              <p style={{ fontSize: 13, lineHeight: 1.6, color: palette.muted, margin: 0 }}>{s.d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* PULL-QUOTE testimonial (Cinematic move #3) — bigger, off-centre */}
      <section style={{ padding: '180px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '80px 1fr', gap: 48, alignItems: 'flex-start' }}>
          <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 96, lineHeight: 1, color: palette.muted, marginTop: -16 }}>“</div>
          <div>
            <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 64, lineHeight: 1.18, fontWeight: 400, letterSpacing: '-0.015em', maxWidth: 1200 }}>{TESTIMONIALS[2].q}</div>
            <Eyebrow color={palette.muted} style={{ marginTop: 40 }}>{TESTIMONIALS[2].a}</Eyebrow>
          </div>
        </div>
      </section>

      {/* awards */}
      <section style={{ padding: '90px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 80, marginBottom: 32 }}>
          <Eyebrow color={palette.muted}>Awards</Eyebrow>
          <div style={{ fontFamily: headlineFont, fontSize: 32, lineHeight: 1.2, letterSpacing: '-0.015em', maxWidth: 720 }}>
            <em style={{ fontStyle: 'italic' }}>Homes Architect of the Year, 2025</em> — British Homes Awards.
          </div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 80 }}>
          <div />
          <div>
            {AWARDS.map((a,i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: '80px 1fr 1fr 90px', padding: '18px 0', borderTop: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted }}>{a.yr}</div>
                <div style={{ fontFamily: headlineFont, fontSize: 18, letterSpacing: '-0.01em' }}>{a.t}</div>
                <div style={{ fontSize: 13, color: palette.muted }}>{a.by}</div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.1em', textTransform: 'uppercase', color: a.k === 'win' ? palette.fg : palette.muted, textAlign: 'right' }}>{a.k === 'win' ? 'Winner' : 'Shortlist'}</div>
              </div>
            ))}
            <div style={{ borderTop: `1px solid ${palette.line}` }} />
          </div>
        </div>
      </section>

      {/* press */}
      <section style={{ padding: '100px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 80 }}>
          <Eyebrow color={palette.muted}>Press</Eyebrow>
          <div>
            {PRESS.map((p,i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: '160px 1fr 60px', padding: '20px 0', borderTop: i === 0 ? `1px solid ${palette.line}` : 'none', borderBottom: `1px solid ${palette.line}`, alignItems: 'baseline' }}>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted }}>{p.src}</div>
                <div style={{ fontFamily: headlineFont, fontSize: 20, letterSpacing: '-0.01em' }}>“{p.line}”</div>
                <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: palette.muted, textAlign: 'right' }}>{p.yr}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* journal */}
      <section style={{ padding: '100px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 40 }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 40, fontWeight: 400, margin: 0 }}>Journal</h2>
          <a style={{ fontSize: 13 }}>All posts →</a>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 28 }}>
          {JOURNAL.map((j,i) => (
            <div key={i} style={{ borderTop: `1px solid ${palette.line}`, paddingTop: 20 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.1em', textTransform: 'uppercase', color: palette.muted, marginBottom: 24 }}>
                <span>{j.tag} · {j.yr}</span><span>{j.read}</span>
              </div>
              <div style={{ fontFamily: headlineFont, fontSize: 26, lineHeight: 1.2, letterSpacing: '-0.01em' }}>{j.t}</div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA + newsletter */}
      <section style={{ padding: '120px 56px', background: palette.cta, color: palette.ctaFg, display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 80 }}>
        <div>
          <h2 style={{ fontFamily: headlineFont, fontSize: 64, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>Tell us about your house.</h2>
          <button style={{ marginTop: 36, background: '#fff', color: '#1a1714', border: 0, padding: '18px 32px', fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase', cursor: 'pointer' }}>{c.cta} →</button>
        </div>
        <div>
          <Eyebrow color="rgba(255,255,255,.6)" style={{ marginBottom: 16 }}>Newsletter</Eyebrow>
          <div style={{ fontSize: 14, opacity: .9, marginBottom: 20 }}>Two letters a year. New work, recent writing.</div>
          <div style={{ display: 'flex', borderBottom: '1px solid rgba(255,255,255,.4)', paddingBottom: 12 }}>
            <input placeholder="email@address" style={{ flex: 1, background: 'transparent', border: 0, color: '#fff', fontSize: 14, outline: 'none' }} />
            <span style={{ fontSize: 12, opacity: .8 }}>Subscribe →</span>
          </div>
        </div>
      </section>

      <footer style={{ padding: '40px 56px', display: 'flex', justifyContent: 'space-between', fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '.12em', textTransform: 'uppercase', color: palette.muted }}>
        <div>Coffey Residential · 104–110 Goswell Road, Clerkenwell, London EC1V 7DH</div>
        <div>contact@coffeyresidential.com</div>
        <div>© 2026</div>
      </footer>
    </div>
  );
}

Object.assign(window, { V1Editorial, V2Quiet, V3Cinematic, V4Warm, V5Index, V6Hybrid });
