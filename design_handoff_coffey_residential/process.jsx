// Process page — how working with the studio actually goes.
// 8 stages laid out as a timeline + per-stage detail blocks.

const PROC_W = 1440;
const PROC_CAP = 1280;

const STAGES = [
  { n: '00', t: 'First conversation',     dur: '1 — 2 weeks',  fee: 'No fee',
    one: 'A coffee, a walk around the house, an honest read of whether we’re right for each other.',
    deliver: ['Site walk', 'Initial scoping note', 'Fee proposal'],
    you:     'Tell us what you want from the house — even if it’s not the brief yet.',
    we:      'Listen, look, and write back within a week.',
  },
  { n: '01', t: 'Brief & feasibility',   dur: '4 — 8 weeks',  fee: 'Fixed fee',
    one: 'We measure the house, test what’s possible, and write the brief with you.',
    deliver: ['Measured survey', 'Feasibility options', 'Written brief', 'Outline cost'],
    you:     'Live with the options for a fortnight before deciding.',
    we:      'Test two or three directions properly, not seven half-baked ones.',
  },
  { n: '02', t: 'Concept design',         dur: '6 — 10 weeks', fee: 'Percentage',
    one: 'The plan, the section, the feel of the house. The biggest decisions, made now.',
    deliver: ['Concept drawings', 'Massing model', 'Materials direction', 'Planning strategy'],
    you:     'Push back on anything that doesn’t feel right.',
    we:      'Draw at scale and show real samples, not mood boards.',
  },
  { n: '03', t: 'Planning',               dur: '8 — 16 weeks', fee: 'Percentage',
    one: 'We assemble the application and walk it through the planning system.',
    deliver: ['Planning drawings', 'Design & Access', 'Consultant reports', 'Neighbour engagement'],
    you:     'Be patient. Planning is the longest wait of the project.',
    we:      'Talk to the case officer early; surprises later cost months.',
  },
  { n: '04', t: 'Developed design',       dur: '8 — 12 weeks', fee: 'Percentage',
    one: 'Every wall, window, joint and finish, drawn and decided before we go to tender.',
    deliver: ['1:50 drawings', '1:5 details', 'Specification', 'Schedules'],
    you:     'Sign off on rooms and materials as we go — no big bang at the end.',
    we:      'Detail at 1:1 for anything you’ll touch.',
  },
  { n: '05', t: 'Tender & contract',      dur: '6 — 10 weeks', fee: 'Percentage',
    one: 'Three or four contractors price the work; we help you choose and sign the contract.',
    deliver: ['Tender pack', 'Returned prices', 'Cost report', 'Building contract'],
    you:     'Meet the contractors. Pick the one you’d rather have in your house for a year.',
    we:      'Read every line of the pricing and explain it in plain English.',
  },
  { n: '06', t: 'On site',                dur: '9 — 18 months', fee: 'Percentage',
    one: 'We are on site weekly. We administer the contract, sign off work, and handle the dozens of small decisions a build asks of you.',
    deliver: ['Weekly site visits', 'Monthly cost reports', 'Sample approvals', 'Snagging'],
    you:     'Visit when you can. Trust the people you chose.',
    we:      'Catch problems while they’re still cheap.',
  },
  { n: '07', t: 'Handover & after',       dur: 'Ongoing',       fee: 'Included',
    one: 'We hand the house over with everything documented, and come back at six months and a year to put right anything that has moved.',
    deliver: ['Handover pack', 'Maintenance notes', '6-month snag', '12-month return'],
    you:     'Move in. Live in the house for a season before judging it.',
    we:      'Answer the phone, for as long as you own the house.',
  },
];

const FAQ = [
  { q: 'How long does a whole-house project take, end to end?',
    a: 'Eighteen months to three years is typical, from first conversation to moving in. Planning is the variable that swings it most.' },
  { q: 'What do you charge?',
    a: 'A fixed fee for feasibility (so you know the cost of finding out), then a percentage of construction cost for everything after. Percentage scales down with budget — bigger projects pay a smaller share.' },
  { q: 'Can we start construction before planning is granted?',
    a: 'Almost never, and we won’t advise it. Internal work to an unlisted house can sometimes begin under permitted development; we’ll tell you honestly when it applies.' },
  { q: 'Do you work outside London?',
    a: 'Yes — about a third of our work is outside the M25. We charge travel at cost and visit weekly when on site.' },
  { q: 'What’s the minimum project size?',
    a: 'Construction budgets from roughly £1m and up. Smaller projects are usually better served by someone closer to the work.' },
  { q: 'Can you recommend a contractor / structural engineer / interior designer?',
    a: 'Yes. We keep a short list of people we’ve worked with for years. We’ll always tender between three.' },
];

const PMono = (props) => (
  <div {...props} style={{
    fontFamily: 'JetBrains Mono, ui-monospace, monospace',
    fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase',
    ...(props.style || {}),
  }} />
);

// ════════════════════════════════════════════════════════════════════════
// PROCESS PAGE
// ════════════════════════════════════════════════════════════════════════
function ProcessPage({ headlineFont, bodyFont, palette }) {
  return (
    <div style={{ width: PROC_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* page header */}
      <section style={{ maxWidth: PROC_CAP, margin: '0 auto', padding: '140px 56px 80px', borderBottom: `1px solid ${palette.line}` }}>
        <PMono style={{ color: palette.muted, marginBottom: 32 }}>How we work · 8 stages · 18 — 36 months</PMono>
        <h1 style={{ fontFamily: headlineFont, fontSize: 120, lineHeight: 0.96, fontWeight: 400, margin: 0, letterSpacing: '-0.035em', maxWidth: 1100 }}>
          <div>From the first conversation</div>
          <div style={{ fontStyle: 'italic' }}>to the second year in.</div>
        </h1>
        <p style={{ fontSize: 17, lineHeight: 1.6, maxWidth: 640, marginTop: 40, color: palette.muted }}>
          A residential project is a long collaboration. We’ve broken ours into eight stages, with the time, fee structure and decisions each one asks of you written down. So nothing arrives as a surprise.
        </p>
      </section>

      {/* TIMELINE STRIP — proportional duration bars */}
      <section style={{ maxWidth: PROC_CAP, margin: '0 auto', padding: '80px 56px 40px' }}>
        <PMono style={{ color: palette.muted, marginBottom: 24 }}>Indicative timeline</PMono>
        <div style={{ position: 'relative', padding: '32px 0 16px' }}>
          {/* baseline */}
          <div style={{ position: 'absolute', left: 0, right: 0, top: 56, height: 1, background: palette.line }} />

          {/* stage ticks */}
          <div style={{ display: 'grid', gridTemplateColumns: '0.7fr 1fr 1.2fr 1.6fr 1.2fr 1fr 3fr 0.8fr', position: 'relative' }}>
            {STAGES.map((s,i) => (
              <div key={s.n} style={{
                borderRight: i < STAGES.length - 1 ? `1px solid ${palette.line}` : 'none',
                paddingRight: 12, paddingLeft: 0,
                paddingTop: 0, paddingBottom: 24,
                position: 'relative',
                minHeight: 120,
              }}>
                <PMono style={{ color: palette.muted, marginBottom: 6 }}>{s.n}</PMono>
                <div style={{ fontFamily: headlineFont, fontSize: 16, letterSpacing: '-0.01em', lineHeight: 1.15 }}>{s.t}</div>
                {/* dot on baseline */}
                <div style={{ position: 'absolute', top: 90, left: -3, width: 7, height: 7, borderRadius: '50%', background: palette.fg }} />
                <div style={{ fontSize: 11, color: palette.muted, marginTop: 56, fontFamily: 'JetBrains Mono, monospace', letterSpacing: '.06em' }}>{s.dur}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* SUMMARY GRID — at-a-glance cards */}
      <section style={{ maxWidth: PROC_CAP, margin: '0 auto', padding: '40px 56px 120px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 0, borderTop: `1px solid ${palette.line}` }}>
          {STAGES.map((s,i) => (
            <div key={s.n} style={{
              padding: '28px 24px 32px',
              borderRight: (i+1) % 4 !== 0 ? `1px solid ${palette.line}` : 'none',
              borderBottom: i < 4 ? `1px solid ${palette.line}` : 'none',
              minHeight: 200,
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                <PMono style={{ color: palette.muted }}>{s.n}</PMono>
                <PMono style={{ color: palette.muted }}>{s.fee}</PMono>
              </div>
              <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.015em', marginTop: 18, lineHeight: 1.15 }}>{s.t}</div>
              <div style={{ fontSize: 13, color: palette.muted, marginTop: 8 }}>{s.dur}</div>
              <p style={{ fontSize: 13.5, lineHeight: 1.6, marginTop: 16, color: palette.fg }}>{s.one}</p>
            </div>
          ))}
        </div>
      </section>

      {/* DETAIL BLOCKS — each stage gets its own row */}
      <section style={{ maxWidth: PROC_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 64 }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 56, fontWeight: 400, margin: 0, letterSpacing: '-0.02em' }}>Stage by stage.</h2>
          <PMono style={{ color: palette.muted }}>00 — 07</PMono>
        </div>

        {STAGES.map((s,i) => (
          <div key={s.n} style={{
            display: 'grid', gridTemplateColumns: '180px 1fr 1fr 1fr',
            gap: 48, padding: '40px 0',
            borderTop: `1px solid ${palette.line}`,
            borderBottom: i === STAGES.length - 1 ? `1px solid ${palette.line}` : 'none',
            alignItems: 'flex-start',
          }}>
            <div>
              <div style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 14, color: palette.muted, marginBottom: 16 }}>Stage {s.n}</div>
              <div style={{ fontFamily: headlineFont, fontSize: 28, letterSpacing: '-0.015em', lineHeight: 1.1 }}>{s.t}</div>
              <div style={{ fontSize: 13, color: palette.muted, marginTop: 12 }}>{s.dur}</div>
              <div style={{ fontSize: 13, color: palette.muted }}>{s.fee}</div>
            </div>

            <div>
              <PMono style={{ color: palette.muted, marginBottom: 12 }}>Deliverables</PMono>
              <ul style={{ margin: 0, padding: 0, listStyle: 'none' }}>
                {s.deliver.map(d => (
                  <li key={d} style={{ fontSize: 14, lineHeight: 1.6, padding: '6px 0', borderBottom: `1px dotted ${palette.line}` }}>{d}</li>
                ))}
              </ul>
            </div>

            <div>
              <PMono style={{ color: palette.muted, marginBottom: 12 }}>From you</PMono>
              <p style={{ fontSize: 14, lineHeight: 1.6, margin: 0 }}>{s.you}</p>
            </div>

            <div>
              <PMono style={{ color: palette.muted, marginBottom: 12 }}>From us</PMono>
              <p style={{ fontSize: 14, lineHeight: 1.6, margin: 0 }}>{s.we}</p>
            </div>
          </div>
        ))}
      </section>

      {/* FEES — straight-talking strip */}
      <section style={{ maxWidth: PROC_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <PMono style={{ color: palette.muted, marginBottom: 16 }}>Fees</PMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.1 }}>How we charge.</h2>
          </div>
          <div style={{ maxWidth: 720 }}>
            <p style={{ fontFamily: headlineFont, fontSize: 24, lineHeight: 1.45, margin: 0, letterSpacing: '-0.005em' }}>
              A fixed fee for feasibility, so you know the cost of finding out. Then a percentage of the construction cost for everything after — paid in stages, against work delivered.
            </p>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24, marginTop: 56 }}>
              {[
                ['Feasibility',    'Fixed fee',  'Agreed up front. Includes survey + brief.'],
                ['Concept → Tender','% of build', 'Scaled to budget. Typical range 9 — 13%.'],
                ['On site → Year 2','% of build', 'Includes contract admin + first-year return visits.'],
              ].map(([l,h,p]) => (
                <div key={l} style={{ padding: '24px 0 0', borderTop: `1px solid ${palette.line}` }}>
                  <PMono style={{ color: palette.muted, marginBottom: 12 }}>{l}</PMono>
                  <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.01em' }}>{h}</div>
                  <p style={{ fontSize: 13.5, lineHeight: 1.6, color: palette.muted, marginTop: 10 }}>{p}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section style={{ maxWidth: PROC_CAP, margin: '0 auto', padding: '140px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '280px 1fr', gap: 80 }}>
          <div>
            <PMono style={{ color: palette.muted, marginBottom: 16 }}>Frequently asked</PMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 36, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.1 }}>The questions people ask first.</h2>
          </div>
          <div>
            {FAQ.map((f,i) => (
              <div key={i} style={{ padding: '28px 0', borderTop: `1px solid ${palette.line}`, borderBottom: i === FAQ.length - 1 ? `1px solid ${palette.line}` : 'none' }}>
                <div style={{ display: 'grid', gridTemplateColumns: '40px 1fr 1fr', gap: 32, alignItems: 'baseline' }}>
                  <PMono style={{ color: palette.muted }}>Q.{String(i+1).padStart(2,'0')}</PMono>
                  <div style={{ fontFamily: headlineFont, fontSize: 20, letterSpacing: '-0.01em', lineHeight: 1.25 }}>{f.q}</div>
                  <p style={{ fontSize: 14.5, lineHeight: 1.65, margin: 0, color: palette.fg }}>{f.a}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { ProcessPage });
