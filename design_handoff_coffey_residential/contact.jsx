// Contact page — enquiry form + studio details.

const C_W = 1440;
const C_CAP = 1280;

const PROJECT_TYPES = ['New build', 'Whole house', 'Extension', 'Refurbishment', 'Not sure yet'];
const BUDGETS = ['£1m — £2m', '£2m — £3m', '£3m — £5m', '£5m +', 'Prefer not to say'];
const TIMELINES = ['Within 6 months', 'This year', 'Next year', 'Just exploring'];
const HEARS = ['Press / publication', 'A previous client', 'Architect we know', 'Awards', 'Search', 'Other'];

const CMono = (props) => (
  <div {...props} style={{
    fontFamily: 'JetBrains Mono, ui-monospace, monospace',
    fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase',
    ...(props.style || {}),
  }} />
);

// Underlined-input style — calm, editorial, no Material boxes.
const Field = ({ label, hint, palette, headlineFont, value = '', required, multi, rows = 3 }) => (
  <label style={{ display: 'block', padding: '20px 0' }}>
    <CMono style={{ color: palette.muted, marginBottom: 10 }}>{label}{required && <span style={{ color: palette.muted, marginLeft: 6 }}>· required</span>}</CMono>
    {multi ? (
      <div style={{ borderBottom: `1px solid ${palette.fg}`, paddingBottom: 10 }}>
        <div style={{ fontFamily: headlineFont, fontSize: 20, lineHeight: 1.5, minHeight: rows * 28, color: value ? palette.fg : palette.muted, letterSpacing: '-0.005em', whiteSpace: 'pre-wrap' }}>
          {value || hint}
        </div>
      </div>
    ) : (
      <div style={{ borderBottom: `1px solid ${palette.fg}`, paddingBottom: 10 }}>
        <div style={{ fontFamily: headlineFont, fontSize: 22, color: value ? palette.fg : palette.muted, letterSpacing: '-0.005em' }}>{value || hint}</div>
      </div>
    )}
  </label>
);

const ChipRow = ({ options, active, palette }) => (
  <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginTop: 8 }}>
    {options.map(o => (
      <span key={o} style={{
        padding: '10px 16px', borderRadius: 999, fontSize: 13,
        border: `1px solid ${palette.line}`,
        background: o === active ? palette.fg : 'transparent',
        color: o === active ? palette.bg : palette.fg,
      }}>{o}</span>
    ))}
  </div>
);

// ════════════════════════════════════════════════════════════════════════
// CONTACT PAGE
// ════════════════════════════════════════════════════════════════════════
function ContactPage({ headlineFont, bodyFont, palette }) {
  return (
    <div style={{ width: C_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* header */}
      <section style={{ maxWidth: C_CAP, margin: '0 auto', padding: '140px 56px 80px', borderBottom: `1px solid ${palette.line}` }}>
        <CMono style={{ color: palette.muted, marginBottom: 32 }}>Contact · Clerkenwell, London · Mon — Fri</CMono>
        <h1 style={{ fontFamily: headlineFont, fontSize: 120, lineHeight: 0.96, fontWeight: 400, margin: 0, letterSpacing: '-0.035em', maxWidth: 1100 }}>
          <div>Tell us about</div>
          <div style={{ fontStyle: 'italic' }}>your house.</div>
        </h1>
        <p style={{ fontSize: 17, lineHeight: 1.6, maxWidth: 640, marginTop: 40, color: palette.muted }}>
          A short form. We read every enquiry ourselves and reply within a week — usually within two days. There’s no obligation in either direction.
        </p>
      </section>

      {/* QUICK CONTACTS strip — for people who don’t need the form */}
      <section style={{ maxWidth: C_CAP, margin: '0 auto', padding: '0' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', borderBottom: `1px solid ${palette.line}` }}>
          {[
            ['New work',    'contact@coffeyresidential.com', 'Replies within a week'],
            ['Press',       'press@coffeyresidential.com',   'Same-day turnaround'],
            ['Careers',     'work@coffeyresidential.com',    'Open applications'],
            ['Phone',       '+44 (0)20 7253 7174',           'Studio · Mon — Fri · 9 — 6'],
          ].map(([l,v,sub],i) => (
            <div key={l} style={{
              padding: '36px 28px',
              borderRight: i < 3 ? `1px solid ${palette.line}` : 'none',
            }}>
              <CMono style={{ color: palette.muted, marginBottom: 14 }}>{l}</CMono>
              <div style={{ fontFamily: headlineFont, fontSize: 18, letterSpacing: '-0.005em', lineHeight: 1.25 }}>{v}</div>
              <div style={{ fontSize: 12, color: palette.muted, marginTop: 10 }}>{sub}</div>
            </div>
          ))}
        </div>
      </section>

      {/* THE FORM */}
      <section style={{ maxWidth: C_CAP, margin: '0 auto', padding: '140px 56px 60px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '340px 1fr', gap: 80, alignItems: 'flex-start' }}>
          <div style={{ position: 'sticky', top: 40 }}>
            <CMono style={{ color: palette.muted, marginBottom: 16 }}>Enquiry · §01 — §05</CMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 44, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>The short form.</h2>
            <p style={{ fontSize: 14.5, lineHeight: 1.65, color: palette.muted, marginTop: 24, maxWidth: 280 }}>
              Five short sections. We don’t need a brief at this stage — just enough to know how to be useful.
            </p>
            <div style={{ marginTop: 32, paddingTop: 24, borderTop: `1px solid ${palette.line}` }}>
              <CMono style={{ color: palette.muted, marginBottom: 8 }}>Rather email?</CMono>
              <div style={{ fontSize: 15, color: palette.fg }}>contact@coffeyresidential.com</div>
            </div>
          </div>

          <form style={{ maxWidth: 720 }}>
            {/* § 1 about you */}
            <div style={{ paddingBottom: 24 }}>
              <CMono style={{ color: palette.muted, marginBottom: 18 }}>§01 · About you</CMono>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 32 }}>
                <Field label="Your name"  hint="First and last" required palette={palette} headlineFont={headlineFont} />
                <Field label="Email"      hint="we@example.com" required palette={palette} headlineFont={headlineFont} />
                <Field label="Phone"      hint="Optional"               palette={palette} headlineFont={headlineFont} />
                <Field label="Best way to reach you" hint="Email or phone" palette={palette} headlineFont={headlineFont} />
              </div>
            </div>

            {/* § 2 the project */}
            <div style={{ paddingTop: 48, paddingBottom: 24, borderTop: `1px solid ${palette.line}` }}>
              <CMono style={{ color: palette.muted, marginBottom: 18 }}>§02 · The project</CMono>
              <Field label="Project location" hint="City and approximate postcode" required palette={palette} headlineFont={headlineFont} />
              <div style={{ padding: '20px 0' }}>
                <CMono style={{ color: palette.muted, marginBottom: 4 }}>Project type</CMono>
                <ChipRow options={PROJECT_TYPES} active="Whole house" palette={palette} />
              </div>
              <div style={{ padding: '20px 0' }}>
                <CMono style={{ color: palette.muted, marginBottom: 4 }}>Indicative construction budget</CMono>
                <ChipRow options={BUDGETS} active="" palette={palette} />
                <p style={{ fontSize: 12.5, color: palette.muted, marginTop: 12, lineHeight: 1.5 }}>
                  We work on construction budgets from £1m and up. If you’re not sure where you sit, leave it blank — we’ll talk it through.
                </p>
              </div>
              <div style={{ padding: '20px 0' }}>
                <CMono style={{ color: palette.muted, marginBottom: 4 }}>When would you like to start?</CMono>
                <ChipRow options={TIMELINES} active="This year" palette={palette} />
              </div>
            </div>

            {/* § 3 the brief */}
            <div style={{ paddingTop: 48, paddingBottom: 24, borderTop: `1px solid ${palette.line}` }}>
              <CMono style={{ color: palette.muted, marginBottom: 18 }}>§03 · In your own words</CMono>
              <Field
                label="Tell us about the house"
                hint="What it is, what isn’t working, what you’d like it to become. Plain language is best."
                multi rows={5}
                palette={palette} headlineFont={headlineFont}
              />
            </div>

            {/* § 4 attachments */}
            <div style={{ paddingTop: 48, paddingBottom: 24, borderTop: `1px solid ${palette.line}` }}>
              <CMono style={{ color: palette.muted, marginBottom: 18 }}>§04 · Anything to share</CMono>
              <div style={{
                border: `1px dashed ${palette.line}`,
                padding: '28px 24px',
                display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              }}>
                <div>
                  <div style={{ fontFamily: headlineFont, fontSize: 20, letterSpacing: '-0.005em' }}>Drag images or PDFs here</div>
                  <div style={{ fontSize: 13, color: palette.muted, marginTop: 4 }}>Photos, sketches, planning correspondence — up to 25 MB</div>
                </div>
                <CMono style={{ color: palette.fg }}>Browse →</CMono>
              </div>
            </div>

            {/* § 5 how heard */}
            <div style={{ paddingTop: 48, paddingBottom: 24, borderTop: `1px solid ${palette.line}` }}>
              <CMono style={{ color: palette.muted, marginBottom: 18 }}>§05 · How you found us</CMono>
              <ChipRow options={HEARS} active="" palette={palette} />
            </div>

            {/* submit row */}
            <div style={{ paddingTop: 56, paddingBottom: 24, borderTop: `1px solid ${palette.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <p style={{ fontSize: 12.5, color: palette.muted, margin: 0, maxWidth: 360, lineHeight: 1.55 }}>
                By sending this you agree we can read it. We keep enquiries confidential and won’t add you to any list. <span style={{ textDecoration: 'underline' }}>Privacy note</span>.
              </p>
              <button style={{
                padding: '20px 36px',
                background: palette.fg, color: palette.bg,
                border: 'none', cursor: 'pointer',
                fontFamily: 'JetBrains Mono, monospace',
                fontSize: 11, letterSpacing: '.14em', textTransform: 'uppercase',
              }}>Send enquiry →</button>
            </div>
          </form>
        </div>
      </section>

      {/* STUDIO — address + map placeholder */}
      <section style={{ maxWidth: C_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.2fr', gap: 64, alignItems: 'flex-start' }}>
          <div>
            <CMono style={{ color: palette.muted, marginBottom: 16 }}>The Studio</CMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>
              <div>104 — 110</div>
              <div style={{ fontStyle: 'italic' }}>Goswell Road.</div>
            </h2>
            <p style={{ fontSize: 16, lineHeight: 1.65, marginTop: 28 }}>
              Clerkenwell, London EC1V 7DH<br />
              <span style={{ color: palette.muted }}>Five minutes from Farringdon, ten from Old Street.</span>
            </p>

            <div style={{ marginTop: 40, paddingTop: 24, borderTop: `1px solid ${palette.line}`, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24 }}>
              <div>
                <CMono style={{ color: palette.muted, marginBottom: 8 }}>Hours</CMono>
                <div style={{ fontSize: 14, lineHeight: 1.65 }}>Mon — Fri · 9 — 6<br />By appointment otherwise</div>
              </div>
              <div>
                <CMono style={{ color: palette.muted, marginBottom: 8 }}>Telephone</CMono>
                <div style={{ fontSize: 14 }}>+44 (0)20 7253 7174</div>
              </div>
            </div>
          </div>

          {/* Schematic map — paper-toned with a simple street grid + pin */}
          <div style={{ position: 'relative', aspectRatio: '4 / 3', background: '#efe9df' }}>
            <svg viewBox="0 0 400 300" style={{ width: '100%', height: '100%', display: 'block' }} stroke="rgba(40,30,20,.35)" strokeWidth="0.8" fill="none">
              {/* horizontal streets */}
              {[40, 100, 165, 230].map(y => <line key={y} x1="0" y1={y} x2="400" y2={y} />)}
              {/* vertical streets */}
              {[60, 140, 210, 290, 360].map(x => <line key={x} x1={x} y1="0" x2={x} y2="300" />)}
              {/* angled — Goswell Road */}
              <line x1="0" y1="280" x2="400" y2="20" strokeWidth="1.8" stroke="rgba(40,30,20,.65)" />
              {/* park / square */}
              <rect x="220" y="180" width="60" height="40" fill="rgba(60,90,60,.18)" stroke="none" />
              {/* labels */}
              <g fontFamily="JetBrains Mono, monospace" fontSize="7" fill="rgba(40,30,20,.55)" letterSpacing="0.5">
                <text x="240" y="172" textAnchor="middle">Spa Fields</text>
                <text x="14" y="34" transform="rotate(-32 14 34)">Goswell Rd</text>
                <text x="64" y="98" >Clerkenwell Rd</text>
                <text x="144" y="13" transform="rotate(90 144 13)">St John St</text>
              </g>
            </svg>
            {/* pin */}
            <div style={{ position: 'absolute', left: '46%', top: '52%', transform: 'translate(-50%, -100%)' }}>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                <div style={{ background: palette.fg, color: palette.bg, padding: '6px 10px', fontFamily: 'JetBrains Mono, monospace', fontSize: 9, letterSpacing: '.12em', textTransform: 'uppercase' }}>Studio</div>
                <div style={{ width: 1, height: 14, background: palette.fg }} />
                <div style={{ width: 10, height: 10, borderRadius: '50%', background: palette.fg, marginTop: -5 }} />
              </div>
            </div>
            <div style={{ position: 'absolute', left: 12, bottom: 10, fontFamily: 'JetBrains Mono, monospace', fontSize: 9, letterSpacing: '.12em', textTransform: 'uppercase', color: 'rgba(40,30,20,.65)' }}>EC1V · 1:5000</div>
          </div>
        </div>
      </section>

      {/* TRANSPORT row */}
      <section style={{ maxWidth: C_CAP, margin: '0 auto', padding: '0' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', borderBottom: `1px solid ${palette.line}` }}>
          {[
            ['Tube',     'Farringdon · 5 min',       'Elizabeth, Circle, H&C, Metropolitan, Thameslink'],
            ['Tube',     'Angel · 8 min',            'Northern'],
            ['Tube',     'Old Street · 10 min',      'Northern'],
            ['Cycle',    'Quietway 2',               'Secure parking in the courtyard'],
          ].map(([k,l,sub],i) => (
            <div key={i} style={{
              padding: '28px 24px',
              borderRight: i < 3 ? `1px solid ${palette.line}` : 'none',
            }}>
              <CMono style={{ color: palette.muted, marginBottom: 10 }}>{k}</CMono>
              <div style={{ fontFamily: headlineFont, fontSize: 18, letterSpacing: '-0.005em' }}>{l}</div>
              <div style={{ fontSize: 12, color: palette.muted, marginTop: 8, lineHeight: 1.5 }}>{sub}</div>
            </div>
          ))}
        </div>
      </section>

      {/* MICRO FAQ — three things we get asked at the contact stage */}
      <section style={{ maxWidth: C_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 48 }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 32, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>Before you send</h2>
          <CMono style={{ color: palette.muted }}>Three quick things</CMono>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 32 }}>
          {[
            ['Do I need to know what I want?',
             'No. Half the people who write to us are trying to work out whether to extend, refurbish or move. We’re happy to be part of that conversation.'],
            ['When will I hear back?',
             'Within a week, usually two days. Phil reads every enquiry himself. If we’re not the right studio for the project we’ll say so, and try to point you somewhere useful.'],
            ['What happens next?',
             'If it looks like a fit, we’ll suggest a first conversation — a walk around the house, no fee, no obligation. Everything is on the Process page.'],
          ].map(([q,a],i) => (
            <div key={i} style={{ borderTop: `1px solid ${palette.line}`, paddingTop: 24 }}>
              <CMono style={{ color: palette.muted, marginBottom: 14 }}>Q.0{i+1}</CMono>
              <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.01em', lineHeight: 1.2 }}>{q}</div>
              <p style={{ fontSize: 14, lineHeight: 1.7, color: palette.muted, marginTop: 14 }}>{a}</p>
            </div>
          ))}
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { ContactPage });
