// Shared placeholder + helper components for all variations.
// All photography is intentionally a striped panel with a monospace caption
// describing what should drop in.

const StripeBg = ({ tone = 'warm', stripe = 0.04, dir = 135 }) => {
  // Subtle diagonal stripe pattern. Not a gradient AI-slop wash — fixed
  // on/off bands at low contrast.
  const tones = {
    warm:   { a: '#e8e2d6', b: '#dcd4c4' },
    bone:   { a: '#ece6da', b: '#e0d8c8' },
    stone:  { a: '#dfddd5', b: '#d3d0c5' },
    sage:   { a: '#cfd4ca', b: '#c2c8bd' },
    ink:    { a: '#1f1d1a', b: '#252320' },
    char:   { a: '#262420', b: '#2c2a26' },
    cream:  { a: '#f0e9d8', b: '#e6dec9' },
    paper:  { a: '#efece4', b: '#e4e0d4' },
  };
  const t = tones[tone] || tones.warm;
  return (
    <div style={{
      position: 'absolute', inset: 0,
      backgroundImage: `repeating-linear-gradient(${dir}deg, ${t.a} 0 14px, ${t.b} 14px 28px)`,
    }} />
  );
};

// Image placeholder — striped panel + monospace caption describing the shot
// that should land here. Optional `dark` flips caption to light.
function Slot({ caption, tone = 'warm', dark = false, height, aspect, style = {}, children, label, src, objectPosition = 'center' }) {
  return (
    <div style={{
      position: 'relative', overflow: 'hidden',
      width: '100%', height, aspectRatio: aspect,
      ...style,
    }}>
      {src ? (
        <img src={src} alt={caption || ''} style={{
          position: 'absolute', inset: 0, width: '100%', height: '100%',
          objectFit: 'cover', objectPosition,
        }} />
      ) : (
        <StripeBg tone={tone} />
      )}
      <div style={{
        position: 'absolute', inset: 0,
        background: dark ? 'rgba(0,0,0,.18)' : (src ? 'rgba(0,0,0,.05)' : 'rgba(255,255,255,.05)'),
      }} />
      {caption && !src && (
        <div style={{
          position: 'absolute', left: 16, bottom: 14,
          fontFamily: 'JetBrains Mono, ui-monospace, monospace',
          fontSize: 10, letterSpacing: '.08em', textTransform: 'uppercase',
          color: dark ? 'rgba(255,255,255,.85)' : 'rgba(40,30,20,.65)',
          maxWidth: '70%',
        }}>
          {label && <div style={{ opacity: .5, marginBottom: 2 }}>{label}</div>}
          {caption}
        </div>
      )}
      {children}
    </div>
  );
}

// "Video" placeholder — adds a play glyph and a faint vignette so it reads as
// motion rather than a still.
function VideoSlot({ caption, tone = 'ink', dark = true, height, aspect, label, src, objectPosition }) {
  return (
    <Slot caption={caption} tone={tone} dark={dark} height={height} aspect={aspect} label={label} src={src} objectPosition={objectPosition}>
      <div style={{
        position: 'absolute', inset: 0,
        background: 'radial-gradient(ellipse at center, transparent 40%, rgba(0,0,0,.35) 100%)',
      }} />
      <div style={{
        position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
        width: 56, height: 56, borderRadius: '50%',
        border: '1px solid rgba(255,255,255,.6)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <div style={{
          width: 0, height: 0, marginLeft: 4,
          borderTop: '8px solid transparent',
          borderBottom: '8px solid transparent',
          borderLeft: '12px solid rgba(255,255,255,.8)',
        }} />
      </div>
    </Slot>
  );
}

// Hero media — switches between image and video placeholder per tweak.
function HeroMedia({ heroMedia, tone = 'ink', dark = true, height, aspect, caption, label, src, objectPosition }) {
  // When heroMedia is 'video' we render the video chrome; the still image
  // (if provided) sits behind the play glyph.
  const Comp = heroMedia === 'video' ? VideoSlot : Slot;
  return <Comp caption={caption} tone={tone} dark={dark} height={height} aspect={aspect} label={label} src={src} objectPosition={objectPosition} />;
}

// Project data — six representative projects per the brief. Captions describe
// the imagery the user should drop in.
const PROJECTS = [
  { n: '01', title: 'Hampstead House',      loc: 'Hampstead, NW3',     yr: '2024', tag: 'New Build',    cap: 'rear elevation, brick fins + black extension', img: 'images/01-hampstead-rear.jpg' },
  { n: '02', title: 'Garden Lodge',         loc: 'Highgate, N6',       yr: '2023', tag: 'Whole House',  cap: 'dining + kitchen connection, top-lit',        img: 'images/07-garden-lodge-kitchen.jpg' },
  { n: '03', title: 'Capablanca House',     loc: 'Holland Park, W14',  yr: '2023', tag: 'Extension',    cap: 'dining room, rooflight + courtyard',          img: 'images/05-capablanca-dining.jpg' },
  { n: '04', title: 'Apartment Block',      loc: 'Primrose Hill, NW1', yr: '2022', tag: 'Refurbishment',cap: 'bedroom landing, oak + soft daylight',        img: 'images/04-apartment-bedroom.jpg' },
  { n: '05', title: 'Cove Ridge',           loc: 'North Devon coast',  yr: '2022', tag: 'New Build',    cap: 'first-floor living, blackened ceiling',       img: 'images/06-cove-ridge-living.jpg' },
  { n: '06', title: 'Modern Barn',          loc: 'South Hams, Devon',  yr: '2021', tag: 'New Build',    cap: 'rear elevation reflecting the field',         img: 'images/09-modern-barn.jpg' },
];

// Hero & secondary stills used across the variations.
const HERO_IMG     = 'images/01-hampstead-rear.jpg';
const HERO_DARK    = 'images/06-cove-ridge-living.jpg';
const HERO_WARM    = 'images/02-ad-house-street.jpg';
const INTERIOR_1   = 'images/08-island-home-detail.jpg';
const INTERIOR_2   = 'images/05-capablanca-dining.jpg';

const AWARDS = [
  { yr: '2025', t: 'Homes Architect of the Year', by: 'British Homes Awards',  k: 'win' },
  { yr: '2024', t: 'RIBA London Award',           by: 'RIBA',                  k: 'win' },
  { yr: '2023', t: 'House of the Year, shortlist', by: 'RIBA',                 k: 'shortlist' },
  { yr: '2012', t: 'Young Architect of the Year',  by: 'The Architects\u2019 Journal', k: 'win' },
];

const PRESS = [
  { src: 'House & Garden',     yr: '2024', line: 'A house that breathes with the garden' },
  { src: 'Wallpaper*',         yr: '2023', line: 'On the architecture of light' },
  { src: 'Dezeen',             yr: '2023', line: 'Coffey Residential’s quiet refurbishment' },
  { src: 'The Sunday Times',   yr: '2022', line: 'Inside a North London family home' },
  { src: 'AJ',                 yr: '2022', line: 'Young Architect of the Year follow-up' },
];

const SERVICES = [
  { n: 'I',   t: 'Design',             d: 'Concept and scheme design. Feasibility, briefing, sketch ideas through to a resolved architectural proposition for your house.' },
  { n: 'II',  t: 'Planning',           d: 'Planning applications, listed building consent, pre-application advice and conservation area work. London boroughs are our home turf.' },
  { n: 'III', t: 'Detail',             d: 'Technical design and detailing — every junction, joint and finish drawn at one-to-one. The drawings the builder actually needs.' },
  { n: 'IV',  t: 'Project management', d: 'Tendering, contract administration and site supervision. We stay on site from first dig to final snag, weekly.' },
  { n: 'V',   t: 'Turnkey',            d: 'Single appointment, single point of contact: design, planning, detail and delivery. Hand over the keys at the end. Hand them back furnished.' },
];

const TESTIMONIALS = [
  { q: 'They listened more than they spoke. The house we live in is the one we tried to describe at the very first meeting.', a: 'Client — Hampstead' },
  { q: 'Every detail considered, every meeting on time, every contractor on the same page. Rare.',                              a: 'Client — Notting Hill' },
  { q: 'The light is what we notice most. It moves through the rooms like it was designed for it — because it was.',         a: 'Client — Holland Park' },
];

const JOURNAL = [
  { tag: 'Essay',    yr: '2024', t: 'On the architecture of light',          read: '6 min' },
  { tag: 'Process',  yr: '2024', t: 'How we measure a Victorian house',       read: '4 min' },
  { tag: 'Field',    yr: '2023', t: 'Notes from a year on site',              read: '8 min' },
];

// Three tonal voices for the about/intro paragraph + hero strapline. The
// `copy` tweak switches between these.
// Copy tone is intentionally quiet. No "luxury", no "bespoke", no superlatives.
// Shorter sentences. Plain language. The work does the selling.
const COPY = {
  confident: {
    eyebrow: 'Residential architects — London',
    h1Lines: ['New houses,', 'and houses made new.'],
    intro: 'Coffey Residential is a London architecture studio. We design new family houses and the whole-house refurbishments that bring older ones back to life. Phil Coffey founded the practice in 2005.',
    aboutTitle: 'A small studio.',
    aboutBody: 'A small studio working closely with each client. Phil is on every project. We design new build houses and whole-house refurbishments. We take on extensions when they are part of a larger refurbishment, not on their own. Construction budgets start at £1m.',
    cta: 'Get in touch',
  },
  quiet: {
    eyebrow: 'London · since 2005',
    h1Lines: ['Light first.', 'Then everything else.'],
    intro: 'A small London studio working on new houses and considered refurbishments. We pay attention to how light moves through rooms, how a stair turns, how a kitchen sits next to a garden.',
    aboutTitle: 'How we work.',
    aboutBody: 'A handful of projects a year. New build houses and whole-house refurbishments — some include an extension; we don’t take on extensions alone. Construction budgets start at £1m. Most of our clients come from people who have already lived in something we made.',
    cta: 'Say hello',
  },
  editorial: {
    eyebrow: 'London · est. 2005',
    h1Lines: ['On houses,', 'and how to live', 'in them.'],
    intro: 'Coffey Residential is a London architecture studio. The work is mostly new build houses and whole-house refurbishments. Phil Coffey started the practice in 2005 and still draws on every project.',
    aboutTitle: 'The studio.',
    aboutBody: 'A north London studio, a few projects a year. New houses and whole-house refurbishments — with an extension folded in where the house needs it. We do not take on standalone extensions. Construction budgets start at £1m. The people you meet are the people doing the work.',
    cta: 'Write to us',
  },
};

Object.assign(window, { Slot, VideoSlot, HeroMedia, StripeBg, PROJECTS, PRESS, AWARDS, SERVICES, TESTIMONIALS, JOURNAL, COPY, HERO_IMG, HERO_DARK, HERO_WARM, INTERIOR_1, INTERIOR_2 });
