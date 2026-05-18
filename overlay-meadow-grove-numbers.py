"""
overlay-meadow-grove-numbers.py
================================

Takes materials-boards/meadow-grove-barnes/materials-board_clean.jpg
and overlays numbered circles 1-9 in the top-right of each sample,
matching the style of the other 19 boards (dark solid circle, white
bold number). Saves the result as materials-board.jpg in the same
folder. Run once after regenerating the clean image.
"""

from __future__ import annotations

from PIL import Image, ImageDraw, ImageFont
from pathlib import Path

ROOT = Path(__file__).resolve().parent
BOARD_DIR = ROOT / "materials-boards" / "meadow-grove-barnes"
SRC = BOARD_DIR / "materials-board_clean.jpg"
DST = BOARD_DIR / "materials-board.jpg"

# Numbered-circle positions for the 9 samples in the meadow-grove clean
# image. Coords measured from the 2048x2048 source against the top-right
# inset of each sample. (x, y) is the CENTER of the circle.
POSITIONS = {
    1: (490, 210),     # warm-white plaster (TL square)
    2: (1050, 190),    # green marble (top-mid large)
    3: (1470, 220),    # charcoal stone (top-mid-right)
    4: (500, 640),     # pale concrete (mid-left small)
    5: (1470, 940),    # aged brass bar (mid-right small)
    6: (710, 1130),    # matt-black fluted joinery (BL large)
    7: (1070, 1190),   # frameless clear glass (B-mid)
    8: (1490, 1170),   # warm walnut (B-mid-right)
    9: (1920, 210),    # pale ash plank (R full height)
}

# Style: solid dark circle, white bold number. ~80px diameter on 2048px.
CIRCLE_RADIUS = 44
CIRCLE_FILL = (24, 26, 28, 255)     # near-black, matching other boards
NUMBER_FILL = (255, 255, 255, 255)
FONT_SIZE = 52

# Bold sans-serif font candidates — first one that exists wins.
FONT_PATHS = [
    "C:/Windows/Fonts/arialbd.ttf",
    "C:/Windows/Fonts/calibrib.ttf",
    "C:/Windows/Fonts/segoeuib.ttf",
    "/System/Library/Fonts/Helvetica.ttc",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
]


def load_font(size: int) -> ImageFont.ImageFont:
    for p in FONT_PATHS:
        if Path(p).exists():
            try:
                return ImageFont.truetype(p, size=size)
            except OSError:
                continue
    return ImageFont.load_default()


def draw_number(draw: ImageDraw.ImageDraw, font, cx: int, cy: int, num: int) -> None:
    r = CIRCLE_RADIUS
    # Solid filled circle
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=CIRCLE_FILL)
    # Centred number
    text = str(num)
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    # textbbox returns a bounding box that doesn't always start at (0,0);
    # account for the offset so digits centre visually.
    ox, oy = bbox[0], bbox[1]
    draw.text(
        (cx - tw / 2 - ox, cy - th / 2 - oy),
        text,
        font=font,
        fill=NUMBER_FILL,
    )


def main() -> None:
    if not SRC.exists():
        raise SystemExit(f"Source image not found: {SRC}")

    img = Image.open(SRC).convert("RGBA")
    print(f"Loaded {SRC.name} at {img.size}")

    # Draw on a transparent overlay so we can preserve the JPEG quality of
    # the source by recompositing only once at save time.
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    font = load_font(FONT_SIZE)

    for num, (cx, cy) in POSITIONS.items():
        draw_number(draw, font, cx, cy, num)

    out = Image.alpha_composite(img, overlay).convert("RGB")
    out.save(DST, "JPEG", quality=92, optimize=True)
    print(f"Saved {DST.name} ({DST.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
