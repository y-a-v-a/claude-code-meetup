#!/usr/bin/env bash
#
# capture-slides.sh — Export a Reveal.js deck to per-slide PNG screenshots.
#
# Usage:
#   ./capture-slides.sh <folder> [options]
#
# Example:
#   ./capture-slides.sh 2026-06-18
#   ./capture-slides.sh 2026-06-18 --width 1920 --height 1080
#
# Result:
#   ./2026-06-18/slides/slide-01.png, slide-02.png, ...
#
# The deck is served over a local HTTP server (the Reveal markdown plugin
# fetches files, so file:// does not work) and driven through Reveal's own
# navigation API via Playwright, so every horizontal and vertical slide is
# captured in order. Fragments are flattened (shown all at once) so each
# section yields a single image.
#
set -euo pipefail

# --- defaults -----------------------------------------------------------------
WIDTH=1280
HEIGHT=720
SCALE=2          # deviceScaleFactor — 2 = retina-sharp PNGs
FORMAT=png

# --- args ---------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <folder> [--width N] [--height N] [--scale N] [--format png|jpeg]" >&2
  exit 1
fi

FOLDER="${1%/}"   # strip a trailing slash if present
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    --width)  WIDTH="$2";  shift 2 ;;
    --height) HEIGHT="$2"; shift 2 ;;
    --scale)  SCALE="$2";  shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# --- resolve paths ------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DECK_DIR="$SCRIPT_DIR/$FOLDER"
INDEX="$DECK_DIR/index.html"
OUT_DIR="$DECK_DIR/slides"

if [[ ! -f "$INDEX" ]]; then
  echo "Error: $INDEX not found." >&2
  echo "Pass a folder in this repo that contains an index.html, e.g. 2026-06-18" >&2
  exit 1
fi

# --- ensure Playwright is available -------------------------------------------
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  echo "Error: Node.js (node + npm) is required but was not found." >&2
  exit 1
fi

# Keep the Playwright npm package + browser in a self-contained cache next to
# this script so the repo isn't polluted and re-runs are fast.
TOOL_DIR="$SCRIPT_DIR/.capture-slides"
export PLAYWRIGHT_BROWSERS_PATH="$TOOL_DIR/browsers"

if [[ ! -d "$TOOL_DIR/node_modules/playwright" ]]; then
  echo "Installing Playwright (first run only, may take a minute)..."
  mkdir -p "$TOOL_DIR"
  # A valid package.json keeps npm from walking up the tree (the dir name
  # ".capture-slides" is itself an invalid npm package name).
  printf '{"name":"capture-slides-tooling","private":true}\n' > "$TOOL_DIR/package.json"
  ( cd "$TOOL_DIR" && npm install playwright )
  ( cd "$TOOL_DIR" && node node_modules/playwright/cli.js install chromium )
fi

mkdir -p "$OUT_DIR"

# --- start a static file server rooted at the repo ----------------------------
PORT=$(node -e 'const s=require("net").createServer();s.listen(0,()=>{console.log(s.address().port);s.close()})')
node -e '
  const http = require("http");
  const fs = require("fs");
  const path = require("path");
  const root = process.argv[1];
  const port = Number(process.argv[2]);
  const types = {
    ".html":"text/html",".css":"text/css",".js":"text/javascript",
    ".mjs":"text/javascript",".json":"application/json",".md":"text/markdown",
    ".png":"image/png",".jpg":"image/jpeg",".jpeg":"image/jpeg",".gif":"image/gif",
    ".svg":"image/svg+xml",".webp":"image/webp",".mp4":"video/mp4",".webm":"video/webm",
    ".woff":"font/woff",".woff2":"font/woff2",".ttf":"font/ttf"
  };
  http.createServer((req, res) => {
    let p = decodeURIComponent(req.url.split("?")[0]);
    let fp = path.join(root, p);
    if (!fp.startsWith(root)) { res.writeHead(403); return res.end(); }
    if (fs.existsSync(fp) && fs.statSync(fp).isDirectory()) fp = path.join(fp, "index.html");
    fs.readFile(fp, (err, data) => {
      if (err) { res.writeHead(404); return res.end("Not found"); }
      res.writeHead(200, {"Content-Type": types[path.extname(fp)] || "application/octet-stream"});
      res.end(data);
    });
  }).listen(port, () => console.error("server up on " + port));
' "$SCRIPT_DIR" "$PORT" &
SERVER_PID=$!

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]]; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
    wait "$SERVER_PID" 2>/dev/null || true  # suppress bash "Terminated" message
  fi
}
trap cleanup EXIT

# wait for the server to accept connections
for _ in $(seq 1 50); do
  if node -e "require('net').connect($PORT,'127.0.0.1').on('connect',()=>process.exit(0)).on('error',()=>process.exit(1))" 2>/dev/null; then
    break
  fi
  sleep 0.1
done

URL="http://127.0.0.1:$PORT/$FOLDER/index.html"
echo "Capturing $FOLDER -> $OUT_DIR (${WIDTH}x${HEIGHT} @${SCALE}x)"

# --- drive Reveal with Playwright ---------------------------------------------
# Written inside TOOL_DIR so Node's node_modules resolution finds `playwright`
# (ESM bare-specifier imports ignore NODE_PATH).
CAPTURE_JS="$TOOL_DIR/capture.mjs"
trap 'cleanup; rm -f "$CAPTURE_JS"' EXIT

cat > "$CAPTURE_JS" <<'NODE'
import { chromium } from 'playwright';

const url    = process.env.SLIDE_URL;
const outDir = process.env.SLIDE_OUT;
const width  = Number(process.env.SLIDE_W);
const height = Number(process.env.SLIDE_H);
const scale  = Number(process.env.SLIDE_SCALE);
const format = process.env.SLIDE_FORMAT;

const browser = await chromium.launch();
const page = await browser.newPage({
  viewport: { width, height },
  deviceScaleFactor: scale,
});

await page.goto(url, { waitUntil: 'load' });

// Wait for Reveal to finish initializing.
await page.waitForFunction(
  () => window.Reveal && window.Reveal.isReady && window.Reveal.isReady(),
  { timeout: 30000 }
);

// Wait for webfonts so headings aren't captured in a fallback face.
await page.evaluate(() => document.fonts && document.fonts.ready).catch(() => {});

// Resolves once every <img> in the currently-active slide has loaded.
const settle = async () => {
  await page.waitForFunction(() => {
    const cur = document.querySelector('.reveal .slides section.present');
    if (!cur) return false;
    return [...cur.querySelectorAll('img')].every(im => im.complete && im.naturalWidth > 0);
  }, { timeout: 10000 }).catch(() => {});
  await page.waitForTimeout(120); // brief paint settle
};

// Disable slide transitions so screenshots can never catch an animation
// sub-frame, flatten fragments (show everything at once), hide chrome, and
// rewind to the first slide.
await page.evaluate(() => {
  window.Reveal.configure({
    transition: 'none',
    backgroundTransition: 'none',
    fragments: false,
    controls: false,
    progress: false,
  });
  window.Reveal.slide(0, 0, 0);
});
await page.waitForTimeout(400);

const total = await page.evaluate(() => window.Reveal.getTotalSlides());
const pad = String(total).length < 2 ? 2 : String(total).length;

let i = 0;
while (true) {
  i++;
  await settle();
  const name = `slide-${String(i).padStart(pad, '0')}.${format === 'jpeg' ? 'jpg' : 'png'}`;
  await page.screenshot({
    path: `${outDir}/${name}`,
    type: format,
    ...(format === 'jpeg' ? { quality: 92 } : {}),
  });
  process.stderr.write(`  ${name}\n`);

  const last = await page.evaluate(() => window.Reveal.isLastSlide());
  if (last) break;
  await page.evaluate(() => window.Reveal.next());

  if (i > 500) { process.stderr.write('Safety stop at 500 slides\n'); break; }
}

await browser.close();
console.error(`Done: ${i} slide(s).`);
NODE

SLIDE_URL="$URL" \
SLIDE_OUT="$OUT_DIR" \
SLIDE_W="$WIDTH" \
SLIDE_H="$HEIGHT" \
SLIDE_SCALE="$SCALE" \
SLIDE_FORMAT="$FORMAT" \
  node "$CAPTURE_JS"

echo "Slides written to: $OUT_DIR"
