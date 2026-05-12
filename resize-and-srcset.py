"""
resize-and-srcset.py
====================

Three-phase image optimisation, all idempotent. Run from project root:

    py resize-and-srcset.py

Phase 1 — Downsize oversized originals
  Any webp whose longest edge is > MAX_FULL_PX is re-encoded in place to
  MAX_FULL_PX at QUALITY_FULL. Files <= MAX_FULL_PX are left alone.

Phase 2 — Generate -m.webp mobile variants
  For every webp in images/webp/, generate `<name>-m.webp` next to it at
  MAX_MOBILE_PX on the longest edge, QUALITY_MOBILE. Skip files that are
  already smaller than MAX_MOBILE_PX (use the original — no new variant
  needed, and the HTML sweep will skip them).
  Re-runs only regenerate variants if the source is newer than the variant.

Phase 3 — HTML sweep
  For every active HTML file (skipping _raw, _archive, pages-html, source.html),
  every `<img>` whose src points at `images/webp/<name>.webp` and where
  `<name>-m.webp` exists gets:
    - srcset="<orig>.webp 1500w, <orig>-m.webp 800w"
    - sizes="(max-width: 768px) 100vw, 50vw"
  Tags already containing srcset are left alone (idempotency).
"""

from __future__ import annotations

import re
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parent
WEBP_DIR = ROOT / "images" / "webp"

MAX_FULL_PX = 1500       # max longest edge for the "desktop" original
MAX_MOBILE_PX = 800      # max longest edge for the -m.webp variant
QUALITY_FULL = 80
QUALITY_MOBILE = 75
METHOD = 6               # PIL/libwebp encoder effort (0=fast, 6=best)

# Default sizes hint. The galleries use 2-column layout above 768px, so each
# image fills ~50vw on desktop and ~100vw on mobile.
SIZES_HINT = "(max-width: 768px) 100vw, 50vw"


# ─── Phase 1: downsize oversized originals ─────────────────────────────────
def downsize_oversized() -> int:
    changed = 0
    for p in sorted(WEBP_DIR.glob("*.webp")):
        if p.name.endswith("-m.webp"):
            continue
        try:
            with Image.open(p) as im:
                w, h = im.size
                if max(w, h) <= MAX_FULL_PX:
                    continue
                ratio = MAX_FULL_PX / max(w, h)
                new_size = (round(w * ratio), round(h * ratio))
                im2 = im.convert("RGB").resize(new_size, Image.LANCZOS)
        except Exception as e:
            print(f"  ! skip {p.name}: {e}")
            continue
        tmp = p.with_suffix(".webp.tmp")
        im2.save(tmp, "webp", quality=QUALITY_FULL, method=METHOD)
        # Only swap if the new file is actually smaller.
        if tmp.stat().st_size < p.stat().st_size:
            tmp.replace(p)
            print(f"  resized  {p.name}  {w}x{h} -> {new_size[0]}x{new_size[1]}")
            changed += 1
        else:
            tmp.unlink()
    return changed


# ─── Phase 2: generate -m.webp variants ────────────────────────────────────
def make_mobile_variants() -> int:
    made = 0
    for p in sorted(WEBP_DIR.glob("*.webp")):
        if p.name.endswith("-m.webp"):
            continue
        try:
            with Image.open(p) as im:
                w, h = im.size
        except Exception as e:
            print(f"  ! skip {p.name}: {e}")
            continue
        # If the original is already smaller than the mobile target, skip —
        # there's no point making a same-size variant.
        if max(w, h) <= MAX_MOBILE_PX:
            continue
        out = p.with_name(p.stem + "-m.webp")
        if out.exists() and out.stat().st_mtime > p.stat().st_mtime:
            continue
        ratio = MAX_MOBILE_PX / max(w, h)
        new_size = (round(w * ratio), round(h * ratio))
        with Image.open(p) as im:
            im2 = im.convert("RGB").resize(new_size, Image.LANCZOS)
            im2.save(out, "webp", quality=QUALITY_MOBILE, method=METHOD)
        made += 1
    return made


# ─── Phase 3: HTML sweep adds srcset ───────────────────────────────────────
# Match <img ... src="<prefix>images/webp/<name>.webp" ...>, capturing the
# whole tag so we can rewrite it without disturbing other attributes.
IMG_RX = re.compile(
    r'(<img\b[^>]*?\bsrc=")((?:\.\./)?images/webp/)([^"]+?)\.webp("[^>]*?)>',
    re.IGNORECASE,
)


def has_attr(tag_body: str, attr: str) -> bool:
    return re.search(rf'\b{re.escape(attr)}\s*=', tag_body, re.IGNORECASE) is not None


def rewrite_img(m: re.Match[str], mobile_names: set[str]) -> str:
    head, prefix, stem, tail = m.group(1), m.group(2), m.group(3), m.group(4)
    full_tag = m.group(0)
    # Already has srcset? leave alone.
    if has_attr(full_tag, "srcset"):
        return full_tag
    # No -m variant exists for this image? leave alone.
    if stem not in mobile_names:
        return full_tag
    srcset = (
        f' srcset="{prefix}{stem}-m.webp 800w, '
        f'{prefix}{stem}.webp 1500w"'
    )
    sizes = ""
    if not has_attr(full_tag, "sizes"):
        sizes = f' sizes="{SIZES_HINT}"'
    return f"{head}{prefix}{stem}.webp{tail}{srcset}{sizes}>"


def sweep_html(mobile_names: set[str]) -> tuple[int, int]:
    skip_parts = {"_raw", "_archive", "pages-html", "design_handoff_coffey_residential"}
    skip_names = {"source.html"}
    files_changed = 0
    tags_changed = 0
    for path in sorted(ROOT.rglob("*.html")):
        if any(part in skip_parts for part in path.parts):
            continue
        if path.name in skip_names:
            continue
        text = path.read_text(encoding="utf-8")

        local_count = 0
        def _sub(m: re.Match[str]) -> str:
            nonlocal local_count
            new = rewrite_img(m, mobile_names)
            if new != m.group(0):
                local_count += 1
            return new

        new_text = IMG_RX.sub(_sub, text)
        if new_text != text:
            path.write_text(new_text, encoding="utf-8")
            files_changed += 1
            tags_changed += local_count
    return files_changed, tags_changed


def main() -> None:
    if not WEBP_DIR.exists():
        raise SystemExit(f"images/webp not found at {WEBP_DIR}")

    print("Phase 1: downsizing oversized originals (>1500px)...")
    n1 = downsize_oversized()
    print(f"  -> {n1} files resized\n")

    print("Phase 2: generating -m.webp mobile variants (800px)...")
    n2 = make_mobile_variants()
    print(f"  -> {n2} variants created\n")

    mobile_names = {
        p.name[: -len("-m.webp")]
        for p in WEBP_DIR.glob("*-m.webp")
    }
    print(f"Have -m variants for {len(mobile_names)} images.\n")

    print("Phase 3: adding srcset to <img> tags in active HTML...")
    fc, tc = sweep_html(mobile_names)
    print(f"  -> updated {tc} tags across {fc} files\n")

    total_full = sum(p.stat().st_size for p in WEBP_DIR.glob("*.webp") if not p.name.endswith("-m.webp"))
    total_mobile = sum(p.stat().st_size for p in WEBP_DIR.glob("*-m.webp"))
    print(f"images/webp totals:")
    print(f"  full:   {total_full/1024/1024:6.1f} MB across {len(list(WEBP_DIR.glob('*.webp'))) - len(mobile_names)} files")
    print(f"  mobile: {total_mobile/1024/1024:6.1f} MB across {len(mobile_names)} -m files")


if __name__ == "__main__":
    main()
