"""
fix-gallery-eager.py
====================

Strip loading="lazy" from <img> tags inside .gallery sections on project
pages. Galleries broke on iOS Safari because the column-count layout +
loading="lazy" combination prevented intersection-observer firing, leaving
images unrendered until tapped (when the lightbox could still find the
DOM node and open the file).

Targets only <img> tags between the opening <section class="gallery"> and
the next </section>. Leaves all other lazy-loaded images alone (homes.html
thumbnails, journal article images, next/prev tiles, etc.).

Idempotent: re-runs find nothing to strip.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent

SECTION_RX = re.compile(
    r'(<section\s+class="gallery"[^>]*>)(.*?)(</section>)',
    re.IGNORECASE | re.DOTALL,
)
LAZY_RX = re.compile(r'\s+loading="lazy"', re.IGNORECASE)


def process(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    original = text
    stripped = 0

    def _sub(m: re.Match[str]) -> str:
        nonlocal stripped
        head, body, tail = m.group(1), m.group(2), m.group(3)
        new_body, n = LAZY_RX.subn("", body)
        stripped += n
        return head + new_body + tail

    text = SECTION_RX.sub(_sub, text)
    if text != original:
        path.write_text(text, encoding="utf-8")
    return stripped


def main() -> None:
    skip_parts = {"_raw", "_archive", "pages-html", "design_handoff_coffey_residential"}
    total_files = 0
    total_stripped = 0
    for path in sorted(ROOT.glob("*.html")):
        if any(part in skip_parts for part in path.parts):
            continue
        n = process(path)
        if n:
            total_files += 1
            total_stripped += n
            print(f"  {path.name}: stripped {n} loading=lazy")
    print()
    print(f"Touched {total_files} files, stripped {total_stripped} attributes.")


if __name__ == "__main__":
    main()
