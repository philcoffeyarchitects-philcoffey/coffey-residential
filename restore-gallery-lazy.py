"""
restore-gallery-lazy.py
=======================

Re-add loading="lazy" to <img> tags inside <section class="gallery"> on
project pages. The previous strip was based on a wrong diagnosis (the real
gallery-invisible-on-mobile bug was the universal reveal-on-scroll
applying opacity:0 to gallery containers, not the column-count + lazy
combination). Restoring lazy loading saves significant mobile bandwidth on
larger galleries (Meadow Grove has 53 images).

Pattern: match <img ...> inside .gallery sections. If decoding="async" is
present and loading="lazy" is not, insert it before decoding="async".
Otherwise, insert it before the closing > of the tag.

Idempotent: re-runs find nothing missing.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent

SECTION_RX = re.compile(
    r'(<section\s+class="gallery"[^>]*>)(.*?)(</section>)',
    re.IGNORECASE | re.DOTALL,
)
IMG_RX = re.compile(r'<img\b[^>]*>', re.IGNORECASE)


def add_lazy(tag: str) -> tuple[str, bool]:
    if re.search(r'\bloading\s*=', tag, re.IGNORECASE):
        return tag, False
    # Insert before decoding="async" if present, else before the closing >.
    m = re.search(r'\sdecoding="', tag, re.IGNORECASE)
    if m:
        return tag[: m.start()] + ' loading="lazy"' + tag[m.start():], True
    # Insert before closing > (or /> for self-closing)
    if tag.endswith('/>'):
        return tag[:-2] + ' loading="lazy"/>', True
    return tag[:-1] + ' loading="lazy">', True


def process(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    original = text
    added = 0

    def _sub_section(m: re.Match[str]) -> str:
        nonlocal added
        head, body, tail = m.group(1), m.group(2), m.group(3)

        def _sub_img(im: re.Match[str]) -> str:
            nonlocal added
            tag = im.group(0)
            new_tag, did = add_lazy(tag)
            if did:
                added += 1
            return new_tag

        new_body = IMG_RX.sub(_sub_img, body)
        return head + new_body + tail

    text = SECTION_RX.sub(_sub_section, text)
    if text != original:
        path.write_text(text, encoding="utf-8")
    return added


def main() -> None:
    skip_parts = {"_raw", "_archive", "pages-html", "design_handoff_coffey_residential"}
    total_files = 0
    total_added = 0
    for path in sorted(ROOT.glob("*.html")):
        if any(part in skip_parts for part in path.parts):
            continue
        n = process(path)
        if n:
            total_files += 1
            total_added += n
            print(f"  {path.name}: restored {n} loading=lazy")
    print()
    print(f"Touched {total_files} files, restored {total_added} attributes.")


if __name__ == "__main__":
    main()
