"""
insert-inline-cta.py
====================

Adds a compact "Considering a project of your own?" CTA band into:
  - every project page, immediately after the new Materials Board
    section (using its end marker as the anchor)
  - the homepage, immediately after the About section (before the
    "Recent work" projects section)

Idempotent — wraps the band in <!-- inline-cta:start --> markers and
re-runs find/refresh the existing block in place.

Run from project root:

    py insert-inline-cta.py
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent

MARK_START = "<!-- inline-cta:start -->"
MARK_END = "<!-- inline-cta:end -->"
EXISTING_RX = re.compile(
    re.escape(MARK_START) + r".*?" + re.escape(MARK_END), re.DOTALL
)

# Anchors for placing the block on different page types.
PROJECT_ANCHOR = "<!-- materials-board:end -->"          # insert AFTER this
# Homepage anchor: insert BEFORE the Services section, immediately
# after Recent Work ends. Pushing the CTA below the project showcase
# means visitors only meet it once they've seen real work, when
# imagining their own project carries weight.
HOMEPAGE_ANCHOR_RX = re.compile(
    r'<!--\s*=====\s*Services.*?-->\s*<section class="section services">',
    re.IGNORECASE,
)

CTA_BLOCK = (
    f"{MARK_START}\n"
    f'<section class="inline-cta">\n'
    f'  <div class="inline-cta__inner">\n'
    f'    <p class="inline-cta__text">Considering a project of your own?</p>\n'
    f'    <a class="cta-btn" href="contact.html">Get in touch &nbsp;&rarr;</a>\n'
    f'  </div>\n'
    f'</section>\n'
    f"{MARK_END}"
)


def insert_after_anchor(text: str, anchor: str) -> tuple[str, bool]:
    if EXISTING_RX.search(text):
        new_text = EXISTING_RX.sub(lambda _m: CTA_BLOCK, text, count=1)
        return new_text, new_text != text
    idx = text.find(anchor)
    if idx == -1:
        return text, False
    insert_at = idx + len(anchor)
    return text[:insert_at] + "\n\n" + CTA_BLOCK + text[insert_at:], True


def insert_before_anchor_rx(text: str, anchor_rx: re.Pattern[str]) -> tuple[str, bool]:
    if EXISTING_RX.search(text):
        new_text = EXISTING_RX.sub(lambda _m: CTA_BLOCK, text, count=1)
        return new_text, new_text != text
    m = anchor_rx.search(text)
    if not m:
        return text, False
    return text[:m.start()] + CTA_BLOCK + "\n\n" + text[m.start():], True


def process_project_pages() -> tuple[int, list[str]]:
    """Run on every project listed in materials-boards/_index.json."""
    index_path = ROOT / "materials-boards" / "_index.json"
    if not index_path.exists():
        raise SystemExit(f"_index.json missing at {index_path}")
    index = json.loads(index_path.read_text(encoding="utf-8"))

    touched = 0
    skipped = []
    for entry in index["projects"]:
        slug = entry["project_slug"]
        html_path = ROOT / f"{slug}.html"
        if not html_path.exists():
            skipped.append(slug + " (no HTML)")
            continue
        text = html_path.read_text(encoding="utf-8")
        new_text, changed = insert_after_anchor(text, PROJECT_ANCHOR)
        if not changed:
            if PROJECT_ANCHOR not in text:
                skipped.append(slug + " (no materials-board anchor)")
            continue
        html_path.write_text(new_text, encoding="utf-8")
        touched += 1
        print(f"  {slug:42s}  [updated]")
    return touched, skipped


def process_homepage() -> bool:
    html_path = ROOT / "index.html"
    text = html_path.read_text(encoding="utf-8")
    new_text, changed = insert_before_anchor_rx(text, HOMEPAGE_ANCHOR_RX)
    if changed:
        html_path.write_text(new_text, encoding="utf-8")
        print(f"  index.html                                  [updated]")
    return changed


def main() -> None:
    print("Project pages:")
    touched, skipped = process_project_pages()
    print()
    print("Homepage:")
    home_changed = process_homepage()
    print()
    print(f"Project pages updated: {touched}")
    print(f"Homepage updated:      {1 if home_changed else 0}")
    if skipped:
        print(f"Skipped: {skipped}")


if __name__ == "__main__":
    main()
