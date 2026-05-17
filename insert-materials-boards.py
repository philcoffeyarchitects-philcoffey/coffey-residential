"""
insert-materials-boards.py
==========================

Reads /materials-boards/_index.json and inserts a per-project Materials
Board section into the matching project HTML file. Each entry renders
the overhead board image on the left, a numbered <ol> key on the right.

Insertion point: after the existing "Materials & makers" .section-2col
block (if present), otherwise just before the "nextprev" / "next/prev"
section, otherwise just before the closing .cta panel.

Idempotent: re-running finds the existing section by marker and either
updates it in place or leaves it alone if unchanged.

Run from project root:

    py insert-materials-boards.py
"""

from __future__ import annotations

import html
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
BOARDS_DIR = ROOT / "materials-boards"
INDEX = BOARDS_DIR / "_index.json"

MARK_START = "<!-- materials-board:start -->"
MARK_END = "<!-- materials-board:end -->"

ALREADY_RX = re.compile(
    re.escape(MARK_START) + r".*?" + re.escape(MARK_END),
    re.DOTALL,
)

# Try these in order — first one that matches wins.
INSERTION_PATTERNS = [
    # 1. After the existing "Materials & makers" .section-2col block
    re.compile(
        r'(<section class="section-2col">\s*<div class="section-2col__grid">\s*'
        r'<div class="section-2col__lhs">\s*'
        r'<span class="eyebrow">Materials\s*(?:&amp;|&)\s*makers</span>.*?</section>)',
        re.DOTALL | re.IGNORECASE,
    ),
    # 2. Just before the next/prev section
    re.compile(r'(<section class="nextprev">)', re.IGNORECASE),
    re.compile(r'(<section class="next-prev">)', re.IGNORECASE),
    # 3. Just before the CTA panel
    re.compile(r'(<section class="cta">)', re.IGNORECASE),
]


def build_section(entry: dict, data: dict) -> str:
    """Render the materials-board section HTML from the data."""
    project_name = data["project_name"]
    materials = data["materials"]

    # Asset paths are root-relative so they work from any project page.
    img_path = f"/materials-boards/{entry['board_image']}"
    img_clean = f"/materials-boards/{entry['board_image_clean']}"

    # Build the alt text from the material names — descriptive for
    # screen readers and search engines.
    names = [m["name"] for m in materials]
    if len(names) > 1:
        names_list = ", ".join(names[:-1]) + " and " + names[-1]
    else:
        names_list = names[0]
    alt = (
        f"Overhead flat lay of {len(materials)} material samples from "
        f"{project_name} — {names_list} — arranged on a soft "
        f"{data.get('ground', 'neutral')} surface."
    )

    # Build the <ol> key
    items = []
    for m in materials:
        name = html.escape(m["name"])
        use = html.escape(m.get("use", ""))
        items.append(
            f'        <li>\n'
            f'          <span class="materials-board__name">{name}</span>\n'
            f'          <span class="materials-board__use">{use}</span>\n'
            f'        </li>'
        )
    items_html = "\n".join(items)

    return (
        f"{MARK_START}\n"
        f'<section class="materials-board" aria-labelledby="materials-board-heading">\n'
        f'  <div class="materials-board__head">\n'
        f'    <span class="eyebrow">Materials &middot; board</span>\n'
        f'    <h2 id="materials-board-heading">{html.escape(project_name)} &mdash; materials, all on one surface.</h2>\n'
        f'  </div>\n'
        f'  <div class="materials-board__layout">\n'
        f'    <figure class="materials-board__image">\n'
        f'      <img src="{img_path}"\n'
        f'           onerror="this.onerror=null;this.src=\'{img_clean}\'"\n'
        f'           alt="{html.escape(alt, quote=True)}"\n'
        f'           loading="lazy" decoding="async"\n'
        f'           width="2048" height="2048">\n'
        f'    </figure>\n'
        f'    <ol class="materials-board__key" aria-label="Materials key">\n'
        f'{items_html}\n'
        f'    </ol>\n'
        f'  </div>\n'
        f'</section>\n'
        f"{MARK_END}"
    )


def process_file(html_path: Path, entry: dict, data: dict) -> str | None:
    """Insert or refresh the materials section. Returns the action taken."""
    text = html_path.read_text(encoding="utf-8")
    section = build_section(entry, data)

    # If already present, replace existing block with the fresh one.
    if ALREADY_RX.search(text):
        new_text = ALREADY_RX.sub(lambda _m: section, text, count=1)
        if new_text == text:
            return "unchanged"
        html_path.write_text(new_text, encoding="utf-8")
        return "refreshed"

    # Otherwise find an insertion point.
    for rx in INSERTION_PATTERNS:
        m = rx.search(text)
        if not m:
            continue
        # If the pattern captured a whole block (variant 1), insert after.
        # Otherwise insert before the matched <section>.
        if rx is INSERTION_PATTERNS[0]:
            new_text = text[: m.end()] + "\n\n" + section + "\n" + text[m.end():]
        else:
            new_text = text[: m.start()] + section + "\n\n" + text[m.start():]
        html_path.write_text(new_text, encoding="utf-8")
        return f"inserted (via pattern {INSERTION_PATTERNS.index(rx) + 1})"

    return None  # no insertion point found


def main() -> None:
    if not INDEX.exists():
        raise SystemExit(f"_index.json not found at {INDEX}")
    index = json.loads(INDEX.read_text(encoding="utf-8"))

    inserted = 0
    refreshed = 0
    unchanged = 0
    missing_html = []
    missing_data = []
    no_insertion_point = []

    for entry in index["projects"]:
        slug = entry["project_slug"]
        html_path = ROOT / f"{slug}.html"
        data_path = BOARDS_DIR / entry["materials_json"]

        if not html_path.exists():
            missing_html.append(slug)
            continue
        if not data_path.exists():
            missing_data.append(slug)
            continue

        data = json.loads(data_path.read_text(encoding="utf-8"))
        action = process_file(html_path, entry, data)

        if action is None:
            no_insertion_point.append(slug)
        elif action == "unchanged":
            unchanged += 1
            print(f"  {slug:42s}  [unchanged]")
        elif action == "refreshed":
            refreshed += 1
            print(f"  {slug:42s}  [refreshed]")
        else:
            inserted += 1
            print(f"  {slug:42s}  [{action}]")

    print()
    print(
        f"Processed {len(index['projects'])} projects: "
        f"{inserted} inserted, {refreshed} refreshed, {unchanged} unchanged."
    )
    if missing_html:
        print(f"  Project HTML missing: {missing_html}")
    if missing_data:
        print(f"  Materials JSON missing: {missing_data}")
    if no_insertion_point:
        print(f"  No insertion point found: {no_insertion_point}")


if __name__ == "__main__":
    main()
