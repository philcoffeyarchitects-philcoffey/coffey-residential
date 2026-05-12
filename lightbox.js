// Gallery lightbox.  No dependencies; ~1.5 KB minified.
//
// Activates on any page that has gallery images:
//   .gallery .g-image img, .gallery .g-wide img
// Click an image -> open the lightbox.
// Inside the lightbox:
//   - Arrow keys / on-screen buttons cycle prev/next
//   - Esc / click on backdrop / × button closes
//
// Idempotent: returns early on pages without a gallery.

(function () {
  const images = Array.from(document.querySelectorAll(
    '.gallery .g-image img, .gallery .g-wide img'
  ));
  if (!images.length) return;

  // Build the overlay once and append to <body>.
  const box = document.createElement('div');
  box.className = 'lightbox';
  box.setAttribute('aria-hidden', 'true');
  box.innerHTML = [
    '<button class="lightbox__close" aria-label="Close">×</button>',
    '<button class="lightbox__prev"  aria-label="Previous">←</button>',
    '<button class="lightbox__next"  aria-label="Next">→</button>',
    '<figure class="lightbox__stage">',
    '  <img class="lightbox__img" src="" alt="" />',
    '  <figcaption class="lightbox__caption"></figcaption>',
    '</figure>'
  ].join('');
  document.body.appendChild(box);

  const img = box.querySelector('.lightbox__img');
  const cap = box.querySelector('.lightbox__caption');
  let idx = -1;

  function show(i) {
    idx = (i + images.length) % images.length;
    const src = images[idx];
    img.src = src.src;
    img.alt = src.alt || '';
    cap.textContent = (src.alt || '') + '  ·  ' + (idx + 1) + ' / ' + images.length;
    box.classList.add('is-open');
    box.setAttribute('aria-hidden', 'false');
    document.documentElement.style.overflow = 'hidden';
  }

  function hide() {
    box.classList.remove('is-open');
    box.setAttribute('aria-hidden', 'true');
    document.documentElement.style.overflow = '';
    idx = -1;
  }

  // Bind: each gallery image opens at its own index
  images.forEach(function (el, i) {
    el.style.cursor = 'zoom-in';
    el.addEventListener('click', function () { show(i); });
  });

  box.querySelector('.lightbox__close').addEventListener('click', hide);
  box.querySelector('.lightbox__prev' ).addEventListener('click', function () { show(idx - 1); });
  box.querySelector('.lightbox__next' ).addEventListener('click', function () { show(idx + 1); });

  // Click outside the image closes (clicking the image itself doesn't)
  box.addEventListener('click', function (e) {
    if (e.target === box || e.target.classList.contains('lightbox__stage')) hide();
  });

  document.addEventListener('keydown', function (e) {
    if (!box.classList.contains('is-open')) return;
    if (e.key === 'Escape')     hide();
    if (e.key === 'ArrowLeft')  show(idx - 1);
    if (e.key === 'ArrowRight') show(idx + 1);
  });
})();
