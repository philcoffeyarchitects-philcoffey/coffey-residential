"""
optimise-pagespeed.py
=====================
Three-pass optimisation across every active HTML file in the Coffey
Residential project:

  1. Add explicit width="" height="" to every <img> tag, read from the
     intrinsic dimensions of the actual file on disk.

  2. Identify the hero / largest above-the-fold image on each page and
     add fetchpriority="high" + decoding="async" + remove loading="lazy".
     Every other <img> keeps (or gets) loading="lazy".

  3. Self-host the four Google Fonts the site uses. Download woff2 files
     to /fonts/, generate /fonts.css with @font-face declarations, and
     replace the Google Fonts <link> tags in every HTML file with one
     <link rel="stylesheet" href="/fonts.css">.

Designed to be re-runnable. Idempotent on subsequent runs.
"""

import re
import struct
import sys
import urllib.request
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(r'C:\Users\philc\Documents\Claude\Claude Code\coffey-residential')
FONTS_DIR = ROOT / 'fonts'
FONTS_CSS = ROOT / 'fonts.css'

# -----------------------------------------------------------------------------
# Image dimensions
# -----------------------------------------------------------------------------

def get_dimensions(path: Path):
    """Return (width, height) for a PNG / JPEG / WebP / SVG file."""
    if not path.exists() or not path.is_file():
        return None
    with open(path, 'rb') as f:
        head = f.read(64)
    # PNG
    if head[:8] == b'\x89PNG\r\n\x1a\n':
        w, h = struct.unpack('>II', head[16:24])
        return w, h
    # JPEG
    if head[:2] == b'\xff\xd8':
        with open(path, 'rb') as f:
            data = f.read()
        i = 2
        while i < len(data) - 9:
            while i < len(data) and data[i] != 0xFF:
                i += 1
            while i < len(data) and data[i] == 0xFF:
                i += 1
            if i >= len(data):
                break
            marker = data[i]
            i += 1
            if marker in (0xC0, 0xC1, 0xC2):
                # SOF: skip length(2) + precision(1), then height(2) width(2)
                h, w = struct.unpack('>HH', data[i+3:i+7])
                return w, h
            if i + 2 > len(data):
                break
            length = struct.unpack('>H', data[i:i+2])[0]
            i += length
        return None
    # WebP
    if head[:4] == b'RIFF' and head[8:12] == b'WEBP':
        chunk = head[12:16]
        if chunk == b'VP8 ':
            w = struct.unpack('<H', head[26:28])[0] & 0x3FFF
            h = struct.unpack('<H', head[28:30])[0] & 0x3FFF
            return w, h
        if chunk == b'VP8L':
            b = head[21:25]
            data = struct.unpack('<I', b)[0]
            return (data & 0x3FFF) + 1, ((data >> 14) & 0x3FFF) + 1
        if chunk == b'VP8X':
            w_bytes = head[24:27] + b'\x00'
            h_bytes = head[27:30] + b'\x00'
            return struct.unpack('<I', w_bytes)[0] + 1, struct.unpack('<I', h_bytes)[0] + 1
    # SVG — read viewBox or width/height
    if b'<svg' in head or b'<?xml' in head:
        try:
            text = path.read_text(encoding='utf-8', errors='ignore')
        except Exception:
            return None
        m = re.search(r'viewBox="\s*\d+\s+\d+\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)', text)
        if m:
            return int(float(m.group(1))), int(float(m.group(2)))
    return None


# -----------------------------------------------------------------------------
# Pass 1 + 2: walk HTML, inject attrs on <img>
# -----------------------------------------------------------------------------

IMG_RX = re.compile(r'<img\b([^>]*?)/?>', re.IGNORECASE)
ATTR_RX = re.compile(r'(\w[\w-]*)\s*=\s*"([^"]*)"')
HERO_PARENT_RX = re.compile(
    r'class="[^"]*\b(?:hero|project-hero|journal-hero|process-hero|press-hero|studio-hero|'
    r'archive-hero|page-feature|article-lead-image|principal__portrait|home-journal__hero)\b',
    re.IGNORECASE,
)


def resolve_src(src: str, html_path: Path) -> Path | None:
    """Resolve an <img src> to a path on disk."""
    src = unquote(src)
    if src.startswith('http://') or src.startswith('https://') or src.startswith('data:'):
        return None
    # Strip leading slash so / is treated as project root
    if src.startswith('/'):
        return (ROOT / src.lstrip('/')).resolve()
    return (html_path.parent / src).resolve()


def is_hero_candidate(file_text: str, img_match_pos: int) -> bool:
    """Treat the FIRST non-logo <img> on the page as the hero / LCP image."""
    # Quick rule: first <img> outside <header>, not class=brand-mark.
    # We mark heroes by checking if this <img> is the first one that isn't
    # the logo. The caller passes the running index; only the first qualifying
    # image is the hero.
    return True  # Logic handled by the caller (sees only one true at a time)


def patch_img_tag(tag_html: str, html_path: Path, is_hero: bool, has_seen_first_content_img: bool) -> tuple[str, bool, bool]:
    """
    Patch a single <img ...> tag. Returns (new_tag_html, was_hero, changed).
    """
    inner = tag_html[len('<img'):].rstrip('/>').rstrip()
    attrs = dict(ATTR_RX.findall(inner))

    # Logo never counts as hero / never needs lazy
    is_logo = attrs.get('class', '').strip() == 'brand-mark'

    # Width / height
    changed = False
    has_dims = 'width' in attrs and 'height' in attrs
    if not has_dims and 'src' in attrs:
        path = resolve_src(attrs['src'], html_path)
        if path:
            dims = get_dimensions(path)
            if dims:
                attrs['width'] = str(dims[0])
                attrs['height'] = str(dims[1])
                changed = True

    # Loading + priority
    if is_logo:
        # Logo: small, decorative, no priority hints needed but make it eager.
        attrs.pop('loading', None)
    elif is_hero and not has_seen_first_content_img:
        attrs['fetchpriority'] = 'high'
        attrs['decoding'] = 'async'
        attrs.pop('loading', None)
        new_first = True
    else:
        if attrs.get('loading') != 'lazy':
            attrs['loading'] = 'lazy'
        if 'decoding' not in attrs:
            attrs['decoding'] = 'async'
        new_first = has_seen_first_content_img

    # Rebuild tag.  Keep attribute order: src first, alt second, then the rest
    # alphabetised so the output is stable across reruns.
    order = ['src', 'alt', 'class', 'id', 'width', 'height', 'loading',
             'fetchpriority', 'decoding']
    seen = set()
    parts = []
    for k in order:
        if k in attrs:
            parts.append(f'{k}="{attrs[k]}"')
            seen.add(k)
    for k in sorted(attrs):
        if k not in seen:
            parts.append(f'{k}="{attrs[k]}"')
    new_tag = '<img ' + ' '.join(parts) + '>'

    new_first = (is_hero and not has_seen_first_content_img and not is_logo) or has_seen_first_content_img
    if is_logo:
        # Logo doesn't count toward "seen first content img"
        new_first = has_seen_first_content_img
    return new_tag, (is_hero and not is_logo and not has_seen_first_content_img), new_tag != tag_html or changed


def _comment_ranges(text: str) -> list[tuple[int, int]]:
    """Return list of (start, end) byte offsets covering HTML comments."""
    ranges = []
    i = 0
    while True:
        s = text.find('<!--', i)
        if s == -1:
            break
        e = text.find('-->', s + 4)
        if e == -1:
            break
        ranges.append((s, e + 3))
        i = e + 3
    return ranges


def _in_any_range(pos: int, ranges: list[tuple[int, int]]) -> bool:
    for a, b in ranges:
        if a <= pos < b:
            return True
    return False


def process_html_imgs(text: str, html_path: Path) -> tuple[str, int, int]:
    """
    Process every <img> in `text`. The FIRST non-logo <img> we encounter
    (outside HTML comments) is the page's hero / LCP candidate. Returns
    (new_text, changed_count, hero_count).
    """
    comment_ranges = _comment_ranges(text)

    new_parts = []
    last_end = 0
    seen_first_content = False
    changed = 0
    hero_count = 0
    for m in IMG_RX.finditer(text):
        # Skip <img> matches that fall inside HTML comments — they're
        # documentation, not real elements.
        if _in_any_range(m.start(), comment_ranges):
            continue
        before = text[last_end:m.start()]
        new_parts.append(before)
        tag = m.group(0)

        attrs = dict(ATTR_RX.findall(tag))
        is_logo = attrs.get('class', '').strip() == 'brand-mark'
        is_hero = not is_logo and not seen_first_content
        # Patch
        new_tag, was_hero, did_change = patch_img_tag(tag, html_path, is_hero, seen_first_content)
        new_parts.append(new_tag)
        if did_change:
            changed += 1
        if was_hero:
            hero_count += 1
        if not is_logo:
            seen_first_content = True
        last_end = m.end()
    new_parts.append(text[last_end:])
    return ''.join(new_parts), changed, hero_count


# -----------------------------------------------------------------------------
# Pass 3: self-host Google Fonts
# -----------------------------------------------------------------------------

GOOGLE_FONTS_URL = (
    'https://fonts.googleapis.com/css2'
    '?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700'
    '&family=PT+Serif+Caption:ital@0;1'
    '&family=Work+Sans:ital,wght@0,300;0,400;0,500;1,400'
    '&family=JetBrains+Mono:wght@400;500'
    '&display=swap'
)

# Chrome UA so Google serves woff2 (older UAs get woff)
CHROME_UA = (
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
)


def fetch(url: str) -> bytes:
    req = urllib.request.Request(url, headers={'User-Agent': CHROME_UA})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read()


def _guess_subset(unicode_range: str) -> str:
    """Map a unicode-range string to a short subset label."""
    ur = unicode_range
    if 'U+0301' in ur and 'U+0400' in ur:
        return 'cyrillic'
    if 'U+0460' in ur or 'U+1C80' in ur:
        return 'cyrillic-ext'
    if 'U+0370' in ur and 'U+03FF' in ur:
        return 'greek'
    if 'U+0102-0103' in ur or 'U+1EA0-1EF9' in ur:
        return 'vietnamese'
    if 'U+0100-02BA' in ur or 'U+0100-02AF' in ur:
        return 'latin-ext'
    if 'U+0000-00FF' in ur or 'U+0020-007F' in ur or 'U+0300' in ur:
        return 'latin'
    return 'misc'


def download_fonts() -> tuple[str, list[str]]:
    """
    Fetch the Google Fonts CSS, then download each woff2 to fonts/. Returns
    the rewritten CSS pointing at local files, and a list of saved filenames.
    """
    FONTS_DIR.mkdir(exist_ok=True)
    css = fetch(GOOGLE_FONTS_URL).decode('utf-8')

    # Find every src: url(...) format('woff2') reference and download.
    src_rx = re.compile(r"url\((https://fonts\.gstatic\.com/[^)]+\.woff2)\)")
    saved = []
    new_css_parts = []
    last = 0
    # Walk through each font-face block so we can name files predictably:
    # family-weight-style.woff2
    family_rx = re.compile(r"font-family:\s*'([^']+)'")
    weight_rx = re.compile(r'font-weight:\s*(\d+)')
    style_rx  = re.compile(r'font-style:\s*(\w+)')
    unicode_rx= re.compile(r'unicode-range:\s*([^;]+);')

    # Split on @font-face { ... } blocks. Google returns one block per
    # (family, weight, style, unicode-subset). Each subset is a separate
    # woff2 file, so we keep them separate and let the browser pick the
    # right one via unicode-range. For Coffey's English-only content this
    # means only the Latin file actually loads at runtime.
    block_rx = re.compile(r'@font-face\s*\{[^}]*\}', re.IGNORECASE)
    # Track how many subsets we've seen per (family, weight, style) so we
    # can name files with a stable index suffix.
    subset_idx = {}
    new_blocks = []
    for blk in block_rx.findall(css):
        fam = family_rx.search(blk)
        wt  = weight_rx.search(blk)
        st  = style_rx.search(blk)
        url_m = src_rx.search(blk)
        ur  = unicode_rx.search(blk)
        if not (fam and wt and st and url_m):
            continue
        family = fam.group(1).replace(' ', '-')
        weight = wt.group(1)
        style  = st.group(1)
        # Identify the subset via its primary Unicode range so the file
        # name is human-readable.
        subset_label = _guess_subset(ur.group(1) if ur else '')
        key = (family, weight, style)
        # Make subset_label unique within this combo by appending an index
        # if we've seen the same label before (defensive).
        idx = subset_idx.get(key + (subset_label,), 0)
        subset_idx[key + (subset_label,)] = idx + 1
        suffix = subset_label if idx == 0 else f"{subset_label}-{idx}"
        out_name = f"{family.lower()}-{weight}-{style}-{suffix}.woff2"
        out_path = FONTS_DIR / out_name
        if not out_path.exists():
            print(f"  downloading: {out_name}")
            data = fetch(url_m.group(1))
            out_path.write_bytes(data)
        else:
            print(f"  cached:      {out_name}")
        saved.append(out_name)
        # Build a local @font-face block.
        ur_decl = f"\n  unicode-range: {ur.group(1)};" if ur else ''
        new_blocks.append(
            f"@font-face {{\n"
            f"  font-family: '{fam.group(1)}';\n"
            f"  font-style: {style};\n"
            f"  font-weight: {weight};\n"
            f"  font-display: swap;\n"
            f"  src: url('/fonts/{out_name}') format('woff2');{ur_decl}\n"
            f"}}"
        )

    fonts_css = (
        '/* fonts.css — self-hosted woff2 files.  Generated by\n'
        '   optimise-pagespeed.py from Google Fonts CSS. Re-run the script\n'
        '   to refresh.  font-display: swap on every face. */\n\n'
        + '\n\n'.join(new_blocks) + '\n'
    )
    FONTS_CSS.write_text(fonts_css, encoding='utf-8')
    return fonts_css, saved


# -----------------------------------------------------------------------------
# Replace Google Fonts <link> tags in every HTML file
# -----------------------------------------------------------------------------

def replace_font_links(text: str) -> tuple[str, bool]:
    """Remove preconnect / fonts.googleapis.com link tags, add /fonts.css."""
    orig = text
    # Remove the three Google Fonts <link> tags we put in the head.
    text = re.sub(
        r'\s*<link\s+rel="preconnect"\s+href="https://fonts\.googleapis\.com">',
        '', text, flags=re.IGNORECASE,
    )
    text = re.sub(
        r'\s*<link\s+rel="preconnect"\s+href="https://fonts\.gstatic\.com"[^>]*>',
        '', text, flags=re.IGNORECASE,
    )
    text = re.sub(
        r'\s*<link\s+href="https://fonts\.googleapis\.com/css2[^"]*"\s+rel="stylesheet">',
        '', text, flags=re.IGNORECASE,
    )

    # Insert <link rel="stylesheet" href="fonts.css"> before styles.css link.
    # Idempotent: skip if already present.
    if 'fonts.css"' not in text and "fonts.css'" not in text:
        # Find the existing styles.css link — accepts plain styles.css (root
        # pages) or ../styles.css (journal subdir pages).
        m = re.search(r'(<link\s+rel="stylesheet"\s+href="((?:\.\./)?)styles\.css"\s*/?>)', text, flags=re.IGNORECASE)
        if m:
            prefix = m.group(2)  # '' or '../'
            fonts_link = f'<link rel="stylesheet" href="{prefix}fonts.css">'
            text = text[:m.start()] + fonts_link + '\n' + text[m.start():]
    return text, text != orig


# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

def main():
    print('=== 1. Self-host Google Fonts ===')
    try:
        _, saved = download_fonts()
        print(f"  wrote: fonts.css ({len(saved)} faces)")
    except Exception as e:
        print(f"  WARNING: font download failed: {e}")
        print(f"  Will still proceed with image / link-tag passes.")
        saved = []

    print()
    print('=== 2. Walk HTML files: img dims, hero hints, font links ===')

    html_files = []
    html_files.extend(sorted(ROOT.glob('*.html')))
    html_files.extend(sorted((ROOT / 'journal').glob('*.html')))

    # Exclude scraped originals + dev pages
    skip_dirs = {'pages-html', '_raw', 'design_handoff_coffey_residential'}
    html_files = [
        p for p in html_files
        if not any(part in skip_dirs for part in p.parts)
        and p.name not in ('source.html', 'reference-editorial.html', 'specimens.html')
    ]

    total_img_changes = 0
    total_hero_marks  = 0
    total_link_swaps  = 0
    files_changed = 0
    for path in html_files:
        text = path.read_text(encoding='utf-8')
        new_text, img_changes, hero_marks = process_html_imgs(text, path)
        new_text, link_changed = replace_font_links(new_text)
        if new_text != text:
            path.write_text(new_text, encoding='utf-8')
            files_changed += 1
        total_img_changes += img_changes
        total_hero_marks  += hero_marks
        if link_changed:
            total_link_swaps += 1

    print(f"  files touched:        {files_changed}/{len(html_files)}")
    print(f"  img tags patched:     {total_img_changes}")
    print(f"  hero priorities set:  {total_hero_marks}")
    print(f"  font-link rewires:    {total_link_swaps}")
    print()
    print('Done.')


if __name__ == '__main__':
    main()
