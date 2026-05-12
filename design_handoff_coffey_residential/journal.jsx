// Journal — index page + a single article page.
// Two artboards in one section.

const J_W = 1440;
const J_CAP = 1280;

const JOURNAL = [
  { tag: 'Essay',    yr: '2025', mo: 'Apr', read: '6 min', t: 'On the architecture of light',
    sub: 'A century of north-London houses, and what their windows tell us about how we like to live.',
    auth: 'Phil Coffey', img: 'images/06-cove-ridge-living.jpg', size: 'lead' },
  { tag: 'Process',  yr: '2025', mo: 'Mar', read: '4 min', t: 'How we measure a Victorian house',
    sub: 'The case for a proper laser survey before anyone draws a line.',
    auth: 'Studio',     img: 'images/05-capablanca-dining.jpg' },
  { tag: 'Field',    yr: '2024', mo: 'Nov', read: '8 min', t: 'Notes from a year on site',
    sub: 'Twelve months at Hampstead House, in plain English.',
    auth: 'Phil Coffey', img: 'images/01-hampstead-rear.jpg' },
  { tag: 'Materials', yr: '2024', mo: 'Sep', read: '5 min', t: 'Why we keep going back to oak',
    sub: 'The grain, the patina, and the joiner who picks every board.',
    auth: 'Studio',     img: 'images/04-apartment-bedroom.jpg' },
  { tag: 'Process',  yr: '2024', mo: 'Jul', read: '7 min', t: 'Planning, in plain English',
    sub: 'What actually happens when an application lands at the council.',
    auth: 'Phil Coffey', img: 'images/02-ad-house-street.jpg' },
  { tag: 'Essay',    yr: '2024', mo: 'May', read: '6 min', t: 'A house is a slow argument',
    sub: 'On the value of taking longer than you needed to.',
    auth: 'Phil Coffey', img: 'images/07-garden-lodge-kitchen.jpg' },
  { tag: 'Field',    yr: '2024', mo: 'Feb', read: '4 min', t: 'A morning at the brickworks',
    sub: 'How a brick is fired, and why the kiln matters more than the colour chart.',
    auth: 'Studio',     img: 'images/08-island-home-detail.jpg' },
  { tag: 'Materials', yr: '2023', mo: 'Nov', read: '5 min', t: 'Concrete that doesn’t look like concrete',
    sub: 'Board-marked finishes, and the timber that makes them.',
    auth: 'Studio',     img: 'images/05-capablanca-dining.jpg' },
  { tag: 'Essay',    yr: '2023', mo: 'Aug', read: '6 min', t: 'On rooms that grow with children',
    sub: 'Why we draw bedrooms smaller than convention says we should.',
    auth: 'Phil Coffey', img: 'images/04-apartment-bedroom.jpg' },
];

const TAGS = ['All', 'Essay', 'Process', 'Field', 'Materials'];

const JMono = (props) => (
  <div {...props} style={{
    fontFamily: 'JetBrains Mono, ui-monospace, monospace',
    fontSize: 10, letterSpacing: '.14em', textTransform: 'uppercase',
    ...(props.style || {}),
  }} />
);

// ════════════════════════════════════════════════════════════════════════
// JOURNAL INDEX
// ════════════════════════════════════════════════════════════════════════
function JournalIndexPage({ headlineFont, bodyFont, palette }) {
  const lead = JOURNAL[0];
  const grid = JOURNAL.slice(1);
  return (
    <div style={{ width: J_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* header */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '140px 56px 80px', borderBottom: `1px solid ${palette.line}` }}>
        <JMono style={{ color: palette.muted, marginBottom: 32 }}>Journal · {JOURNAL.length} entries · Updated monthly</JMono>
        <h1 style={{ fontFamily: headlineFont, fontSize: 120, lineHeight: 0.96, fontWeight: 400, margin: 0, letterSpacing: '-0.035em', maxWidth: 1100 }}>
          <div>Notes from</div>
          <div style={{ fontStyle: 'italic' }}>the drawing board.</div>
        </h1>
        <p style={{ fontSize: 17, lineHeight: 1.6, maxWidth: 640, marginTop: 40, color: palette.muted }}>
          Writing about how we work, what we’re reading, and what we’re learning on site. Slower than a blog, longer than a post, indexed by year.
        </p>
      </section>

      {/* tag filter row */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '24px 56px', borderBottom: `1px solid ${palette.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <div style={{ display: 'flex', gap: 8 }}>
          {TAGS.map(t => (
            <span key={t} style={{
              padding: '8px 14px', borderRadius: 999, fontSize: 12,
              border: `1px solid ${palette.line}`,
              background: t === 'All' ? palette.fg : 'transparent',
              color: t === 'All' ? palette.bg : palette.fg,
            }}>{t}</span>
          ))}
        </div>
        <div style={{ display: 'flex', gap: 24, alignItems: 'baseline' }}>
          <JMono style={{ color: palette.muted }}>RSS</JMono>
          <JMono style={{ color: palette.muted }}>Letter ↓</JMono>
        </div>
      </section>

      {/* lead article — full bleed (within cap) */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '0' }}>
        <a style={{ display: 'block', color: palette.fg, textDecoration: 'none' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', alignItems: 'stretch' }}>
            <div style={{ position: 'relative' }}>
              <Slot tone="bone" caption={lead.t} height={560} src={lead.img} />
            </div>
            <div style={{ padding: '64px 56px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', borderRight: `1px solid ${palette.line}` }}>
              <div>
                <JMono style={{ color: palette.muted, marginBottom: 24 }}>Lead · {lead.tag} · {lead.read} read</JMono>
                <h2 style={{ fontFamily: headlineFont, fontSize: 56, lineHeight: 1.02, fontWeight: 400, margin: 0, letterSpacing: '-0.025em' }}>{lead.t}</h2>
                <p style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 22, lineHeight: 1.45, marginTop: 28, color: palette.fg }}>{lead.sub}</p>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginTop: 48 }}>
                <JMono style={{ color: palette.muted }}>{lead.auth} · {lead.mo} {lead.yr}</JMono>
                <JMono style={{ color: palette.fg }}>Read →</JMono>
              </div>
            </div>
          </div>
        </a>
      </section>

      {/* index grid — 3 col */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '120px 56px', borderTop: `1px solid ${palette.line}`, borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 48 }}>
          <h2 style={{ fontFamily: headlineFont, fontSize: 32, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>All entries</h2>
          <JMono style={{ color: palette.muted }}>{grid.length} shown</JMono>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 32, rowGap: 64 }}>
          {grid.map((p,i) => (
            <a key={i} style={{ color: palette.fg, textDecoration: 'none' }}>
              <Slot tone={['bone','stone','warm','paper','cream'][i % 5]} caption={p.t} height={260} src={p.img} />
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 16 }}>
                <JMono style={{ color: palette.muted }}>{p.tag}</JMono>
                <JMono style={{ color: palette.muted }}>{p.mo} {p.yr} · {p.read}</JMono>
              </div>
              <div style={{ fontFamily: headlineFont, fontSize: 24, letterSpacing: '-0.015em', marginTop: 12, lineHeight: 1.15 }}>{p.t}</div>
              <p style={{ fontSize: 14, lineHeight: 1.55, color: palette.muted, marginTop: 10 }}>{p.sub}</p>
            </a>
          ))}
        </div>
      </section>

      {/* newsletter — minimal */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '120px 56px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 80, alignItems: 'flex-end' }}>
          <div>
            <JMono style={{ color: palette.muted, marginBottom: 16 }}>Letter</JMono>
            <h2 style={{ fontFamily: headlineFont, fontSize: 48, fontWeight: 400, margin: 0, letterSpacing: '-0.02em', lineHeight: 1.05 }}>
              <span>A short letter, </span>
              <span style={{ fontStyle: 'italic' }}>roughly every six weeks.</span>
            </h2>
            <p style={{ fontSize: 15, lineHeight: 1.6, color: palette.muted, marginTop: 20, maxWidth: 420 }}>What we’re drawing, building and reading. Unsubscribe in one click.</p>
          </div>
          <div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: 16, alignItems: 'stretch', borderBottom: `1px solid ${palette.fg}`, paddingBottom: 10 }}>
              <div style={{ fontSize: 18, color: palette.muted }}>your@email.com</div>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, letterSpacing: '.12em', textTransform: 'uppercase', alignSelf: 'end' }}>Subscribe →</div>
            </div>
            <div style={{ fontSize: 12, color: palette.muted, marginTop: 14 }}>By subscribing you agree to receive occasional emails from the studio. No third-party use.</div>
          </div>
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

// ════════════════════════════════════════════════════════════════════════
// JOURNAL ARTICLE
// ════════════════════════════════════════════════════════════════════════
function JournalArticlePage({ headlineFont, bodyFont, palette }) {
  const a = JOURNAL[0]; // "On the architecture of light"
  return (
    <div style={{ width: J_W, fontFamily: bodyFont, background: palette.bg, color: palette.fg, fontSize: 14, lineHeight: 1.55 }}>
      <HomesNav palette={palette} headlineFont={headlineFont} />

      {/* breadcrumb */}
      <div style={{ maxWidth: J_CAP, margin: '0 auto', padding: '22px 56px', borderBottom: `1px solid ${palette.line}`, display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <JMono style={{ color: palette.muted }}>
          <span>Journal</span>
          <span style={{ margin: '0 10px', opacity: .4 }}>/</span>
          <span style={{ color: palette.muted }}>{a.tag}</span>
          <span style={{ margin: '0 10px', opacity: .4 }}>/</span>
          <span style={{ color: palette.fg }}>{a.t}</span>
        </JMono>
        <JMono style={{ color: palette.muted }}>{a.read} read</JMono>
      </div>

      {/* article title — centred, narrow column, no hero up top (image goes after the deck) */}
      <section style={{ maxWidth: 820, margin: '0 auto', padding: '120px 56px 60px', textAlign: 'center' }}>
        <JMono style={{ color: palette.muted, marginBottom: 32 }}>{a.tag} · {a.mo} {a.yr}</JMono>
        <h1 style={{ fontFamily: headlineFont, fontSize: 72, lineHeight: 1.02, fontWeight: 400, margin: 0, letterSpacing: '-0.03em' }}>{a.t}</h1>
        <p style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 22, lineHeight: 1.45, marginTop: 32, color: palette.fg }}>{a.sub}</p>
        <div style={{ marginTop: 40, display: 'flex', justifyContent: 'center', gap: 16, alignItems: 'baseline' }}>
          <JMono style={{ color: palette.muted }}>Words · {a.auth}</JMono>
          <span style={{ color: palette.muted, opacity: .5 }}>·</span>
          <JMono style={{ color: palette.muted }}>{a.read} read</JMono>
        </div>
      </section>

      {/* lead image */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '0 56px' }}>
        <Slot tone="bone" caption={a.t} height={680} src={a.img} />
        <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 12 }}>
          <JMono style={{ color: palette.muted }}>Fig. 01</JMono>
          <JMono style={{ color: palette.muted }}>Living room, Cove Ridge · photograph by TBD</JMono>
        </div>
      </section>

      {/* article body — narrow column, drop cap, blockquote */}
      <section style={{ maxWidth: 680, margin: '0 auto', padding: '120px 56px' }}>
        <p style={{ fontSize: 17, lineHeight: 1.75, margin: '0 0 1.4em', textWrap: 'pretty' }}>
          <span style={{ fontFamily: headlineFont, fontSize: 68, lineHeight: 0.85, float: 'left', marginRight: 14, marginTop: 6, letterSpacing: '-0.02em' }}>L</span>
          ight is the one thing in a house you can’t buy at a shop. It arrives where the plan puts the window, in the colour the season decides. You can read a hundred specifications and not be ready for the way a kitchen feels at half past four in February — but you can draw a house that is ready for it, if you take the question seriously.
        </p>
        <p style={{ fontSize: 17, lineHeight: 1.75, margin: '0 0 1.4em', textWrap: 'pretty' }}>
          In Hampstead, the Victorian terrace has a particular relationship with daylight that we’ve thought about for years. The plot is narrow, the rear is the only place to find south, the front rooms get the long evening of west. Every solution to the standard "we want it lighter at the back" brief is really an argument about which of those you choose to lose.
        </p>
        <blockquote style={{
          margin: '56px 0',
          padding: '28px 0',
          borderTop: `1px solid ${palette.line}`,
          borderBottom: `1px solid ${palette.line}`,
        }}>
          <p style={{ fontFamily: headlineFont, fontStyle: 'italic', fontSize: 28, lineHeight: 1.35, margin: 0, letterSpacing: '-0.005em' }}>
            "Most of the projects I’m proudest of were the ones where the client let us spend an extra fortnight on the section."
          </p>
        </blockquote>
        <p style={{ fontSize: 17, lineHeight: 1.75, margin: '0 0 1.4em', textWrap: 'pretty' }}>
          The drawings that follow are sections through six houses we’ve worked on in the past eight years. They’re not at the same scale and they’re not meant to be compared on equal terms; what I want to show is the variety of moves available when daylight is treated as the brief rather than a finish.
        </p>
        <p style={{ fontSize: 17, lineHeight: 1.75, margin: '0 0 1.4em', textWrap: 'pretty' }}>
          A roof light over a stair turns a circulation space into a place; a low window seat catches morning sun that no other room in the house can hold; a clerestory pulls north light over a kitchen that would otherwise be lit by the sun setting in someone else’s garden. None of these are clever. All of them require a section, drawn early, in a section book.
        </p>

        {/* in-body figure */}
        <figure style={{ margin: '56px 0' }}>
          <Slot tone="paper" caption="section study — six houses, six sections" height={420} src="" />
          <figcaption style={{ display: 'flex', justifyContent: 'space-between', marginTop: 10 }}>
            <JMono style={{ color: palette.muted }}>Fig. 02</JMono>
            <JMono style={{ color: palette.muted }}>Section studies · drawing by the studio</JMono>
          </figcaption>
        </figure>

        <p style={{ fontSize: 17, lineHeight: 1.75, margin: '0 0 1.4em', textWrap: 'pretty' }}>
          A house lasts a hundred years if it’s built properly. Light is the one thing you’ll notice every single day of those hundred years. It is worth taking longer on.
        </p>
      </section>

      {/* footer meta — author / share / tags */}
      <section style={{ maxWidth: 680, margin: '0 auto', padding: '0 56px 120px' }}>
        <div style={{ padding: '32px 0', borderTop: `1px solid ${palette.line}`, borderBottom: `1px solid ${palette.line}`, display: 'grid', gridTemplateColumns: '1fr auto', gap: 32, alignItems: 'baseline' }}>
          <div>
            <JMono style={{ color: palette.muted, marginBottom: 8 }}>Words by</JMono>
            <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.005em' }}>{a.auth}</div>
            <div style={{ fontSize: 13, color: palette.muted, marginTop: 4 }}>Founder · Coffey Residential</div>
          </div>
          <div style={{ display: 'flex', gap: 18 }}>
            <JMono style={{ color: palette.muted }}>Share · Copy link</JMono>
            <JMono style={{ color: palette.muted }}>Email</JMono>
            <JMono style={{ color: palette.muted }}>Print</JMono>
          </div>
        </div>
      </section>

      {/* RELATED — three more from the journal */}
      <section style={{ maxWidth: J_CAP, margin: '0 auto', padding: '0 56px 140px', borderBottom: `1px solid ${palette.line}` }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 32 }}>
          <h3 style={{ fontFamily: headlineFont, fontSize: 28, fontWeight: 400, margin: 0, letterSpacing: '-0.015em' }}>Read next</h3>
          <JMono style={{ color: palette.muted }}>All journal →</JMono>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 32 }}>
          {JOURNAL.slice(1, 4).map((p,i) => (
            <a key={i} style={{ color: palette.fg, textDecoration: 'none' }}>
              <Slot tone={['stone','warm','paper'][i]} caption={p.t} height={220} src={p.img} />
              <JMono style={{ color: palette.muted, marginTop: 16 }}>{p.tag} · {p.mo} {p.yr}</JMono>
              <div style={{ fontFamily: headlineFont, fontSize: 22, letterSpacing: '-0.01em', marginTop: 8, lineHeight: 1.15 }}>{p.t}</div>
            </a>
          ))}
        </div>
      </section>

      <HomesFooter palette={palette} headlineFont={headlineFont} />
    </div>
  );
}

Object.assign(window, { JournalIndexPage, JournalArticlePage });
