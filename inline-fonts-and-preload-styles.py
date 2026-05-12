"""
inline-fonts-and-preload-styles.py
==================================

Two PageSpeed-targeted HTML sweeps, both idempotent:

  1. Inline fonts.css contents into <head> as a <style> block, eliminating
     the render-blocking fonts.css HTTP request. Wrapped in marker comments
     so re-runs are safe.

  2. Add a <link rel="preload" href="styles.css" as="style"> hint
     immediately before the existing <link rel="stylesheet" href="styles.css">,
     so the browser fetches styles.css earlier in the parse.

Paths inside fonts.css are root-anchored (e.g. `/fonts/foo.woff2`), so the
same inlined block works from / and /journal/ alike.

Run from the project root:

    python inline-fonts-and-preload-styles.py
"""

from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent
FONTS_CSS = ROOT / "fonts.css"

FONTS_START = "<!-- fonts-inline:start -->"
FONTS_END = "<!-- fonts-inline:end -->"

# Matches <link rel="stylesheet" href="(../)?fonts.css"> with optional trailing slash on tag.
FONTS_LINK_RX = re.compile(
    r'<link\s+rel="stylesheet"\s+href="((?:\.\./)?)fonts\.css"\s*/?>',
    re.IGNORECASE,
)

# Matches <link rel="stylesheet" href="(../)?styles.css">.
STYLES_LINK_RX = re.compile(
    r'<link\s+rel="stylesheet"\s+href="((?:\.\./)?)styles\.css"\s*/?>',
    re.IGNORECASE,
)

# Already-inlined block (idempotency check).
INLINED_BLOCK_RX = re.compile(
    re.escape(FONTS_START) + r".*?" + re.escape(FONTS_END),
    re.DOTALL,
)


def build_fonts_block() -> str:
    """Return the <style> block to inline, wrapped in markers."""
    css = FONTS_CSS.read_text(encoding="utf-8")
    return f"{FONTS_START}\n<style>\n{css}\n</style>\n{FONTS_END}"


def process_file(path: Path, fonts_block: str) -> tuple[bool, list[str]]:
    """Return (changed?, list-of-actions) for the file at `path`."""
    actions: list[str] = []
    text = path.read_text(encoding="utf-8")
    original = text

    # ── 1. Inline fonts.css ──────────────────────────────────────────────
    if INLINED_BLOCK_RX.search(text):
        # Already inlined — refresh contents in case fonts.css changed.
        text = INLINED_BLOCK_RX.sub(lambda _m: fonts_block, text, count=1)
        if text != original:
            actions.append("refreshed-inline-fonts")
    else:
        m = FONTS_LINK_RX.search(text)
        if m:
            text = text[: m.start()] + fonts_block + text[m.end() :]
            actions.append("inlined-fonts")

    # ── 2. Add styles.css preload hint ───────────────────────────────────
    m = STYLES_LINK_RX.search(text)
    if m:
        prefix = m.group(1)  # "" or "../"
        preload_tag = (
            f'<link rel="preload" href="{prefix}styles.css" as="style">'
        )
        # Look for the preload tag in a small window before the stylesheet
        # link (to avoid matching one elsewhere in the head).
        window_start = max(0, m.start() - 200)
        window = text[window_start : m.start()]
        if preload_tag not in window:
            text = text[: m.start()] + preload_tag + "\n" + text[m.start() :]
            actions.append("added-styles-preload")

    if text != original:
        path.write_text(text, encoding="utf-8")
        return True, actions
    return False, actions


def main() -> None:
    if not FONTS_CSS.exists():
        raise SystemExit(f"fonts.css not found at {FONTS_CSS}")

    fonts_block = build_fonts_block()

    html_files = sorted(ROOT.rglob("*.html"))
    # Skip vendored / archived directories.
    skip_dirs = {"node_modules", "_archive", ".git"}
    html_files = [
        p for p in html_files if not any(part in skip_dirs for part in p.parts)
    ]

    changed = 0
    inlined = 0
    preloaded = 0
    for path in html_files:
        ok, actions = process_file(path, fonts_block)
        if ok:
            changed += 1
            rel = path.relative_to(ROOT)
            print(f"  {rel}  [{', '.join(actions)}]")
        if "inlined-fonts" in actions or "refreshed-inline-fonts" in actions:
            inlined += 1
        if "added-styles-preload" in actions:
            preloaded += 1

    print()
    print(f"Scanned {len(html_files)} HTML files.")
    print(f"Changed: {changed}")
    print(f"  - fonts.css inlined/refreshed: {inlined}")
    print(f"  - styles.css preload added:    {preloaded}")


if __name__ == "__main__":
    main()
