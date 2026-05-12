// site.js — mobile nav toggle + universal reveal-on-scroll. Loaded on every page.

// ─── Mobile nav: inject a hamburger button into .site-header and wire it
// to toggle a body.nav-open class. The drawer markup is just the existing
// .site-nav element — CSS handles the slide-down on small screens.
(function () {
  const header = document.querySelector('.site-header');
  const nav    = document.querySelector('.site-nav');
  if (!header || !nav) return;
  if (header.querySelector('.nav-toggle')) return; // idempotent

  const btn = document.createElement('button');
  btn.type = 'button';
  btn.className = 'nav-toggle';
  btn.setAttribute('aria-label', 'Open menu');
  btn.setAttribute('aria-expanded', 'false');
  btn.setAttribute('aria-controls', 'site-nav');
  btn.innerHTML = '<span class="nav-toggle__bars"><span></span><span></span><span></span></span>';

  const closeMenu = () => {
    document.body.classList.remove('nav-open');
    btn.setAttribute('aria-expanded', 'false');
    btn.setAttribute('aria-label', 'Open menu');
  };
  const openMenu = () => {
    document.body.classList.add('nav-open');
    btn.setAttribute('aria-expanded', 'true');
    btn.setAttribute('aria-label', 'Close menu');
  };

  btn.addEventListener('click', () => {
    if (document.body.classList.contains('nav-open')) closeMenu();
    else openMenu();
  });
  // Close on link tap so navigation feels right on mobile.
  nav.addEventListener('click', (e) => {
    if (e.target.closest('a')) closeMenu();
  });
  // Close on escape.
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeMenu();
  });

  nav.id = nav.id || 'site-nav';
  header.appendChild(btn);
})();

// ─── universal reveal-on-scroll, loaded on every page.
//
// Major content blocks fade up as they enter the viewport. When several
// arrive at once (the top of a fresh section coming into view), they
// cascade in 60 ms apart so the page reads top-to-bottom.
//
// The pattern is borrowed from the existing press / awards reveal —
// generalised here so it applies site-wide without per-page wiring.
//
// What it skips:
//   - Heroes and other above-the-fold content (already in view at load)
//   - Sticky headers and CTA / footer panels
//   - Elements that already have their own choreographed reveal
//     (timeline stages, awards rows, press rows, counters)
//   - `prefers-reduced-motion: reduce` users
//
// What it targets:
//   - The direct children of every <section> on the page, which is the
//     natural rhythm unit for these editorial layouts.

(function () {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  if (!('IntersectionObserver' in window)) return;

  // Sections that are already on screen at first paint, so revealing them
  // would just make them flicker in.
  var skipParentSelectors = [
    '.hero',
    '.studio-hero',
    '.project-hero',
    '.press-hero',
    '.journal-hero',
    '.cta-panel',
    '.cta',
    'footer',
    '.site-header'
  ].join(',');

  // Elements that already manage their own reveal — don't double-animate.
  var ownAnimationSelectors = [
    '.timeline',
    '.timeline__stage',
    '.timeline__baseline',
    '.awards-row',
    '.press-row',
    '.press-year__num',
    '.counter'
  ].join(',');

  function shouldSkip(el) {
    if (el.closest(skipParentSelectors)) return true;
    if (el.matches(ownAnimationSelectors)) return true;
    // Skip very small wrappers and bare text nodes
    if (el.tagName === 'SCRIPT' || el.tagName === 'STYLE') return true;
    return false;
  }

  // Pull together the candidate elements: direct children of sections, plus
  // grid items that should fade in individually (testimonials, values, team).
  var candidates = [];
  document.querySelectorAll('section').forEach(function (sec) {
    Array.prototype.forEach.call(sec.children, function (child) {
      candidates.push(child);
    });
  });
  // Add grid children explicitly so they stagger nicely.
  var gridChildSelectors = [
    '.values-grid > *',
    '.team-grid > *',
    '.testimonials-grid > *',
    '.studio-facts__cell',
    '.facts__cell',
    '.stages-summary__grid > *',
    '.stages-detail__row',
    '.faq__row',
    '.fees__card',
    '.project-row',
    '.homes-rows > *',
    '.projects__rows > *',
    '.homes-grid > *',
    '.journal-grid > *',
    '.outlet-wall__cell',
    '.press-kit__row',
    '.principal__grid > *',
    '.materials__row',
    '.project-press__row',
    '.credits-table__row',
    '.next-prev > a',
    '.next-prev__tile',
    '.section-head'
  ].join(',');
  document.querySelectorAll(gridChildSelectors).forEach(function (el) {
    candidates.push(el);
  });

  // Dedupe + filter.
  var seen = new Set();
  var targets = [];
  candidates.forEach(function (el) {
    if (seen.has(el)) return;
    seen.add(el);
    if (shouldSkip(el)) return;
    targets.push(el);
  });

  targets.forEach(function (el) { el.classList.add('reveal-on-scroll'); });

  var io = new IntersectionObserver(function (entries, obs) {
    var arrived = entries
      .filter(function (e) { return e.isIntersecting; })
      .sort(function (a, b) { return a.boundingClientRect.top - b.boundingClientRect.top; });
    arrived.forEach(function (e, i) {
      // Cascade by 60ms when several items appear at once.
      setTimeout(function () { e.target.classList.add('is-in'); }, i * 60);
      obs.unobserve(e.target);
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -5% 0px' });

  targets.forEach(function (el) { io.observe(el); });
})();
