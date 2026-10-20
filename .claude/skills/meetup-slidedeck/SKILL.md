---
name: meetup-slidedeck
description: Build or extend a Claude Community meetup slide deck in this repo as a single self-contained Reveal.js index.html (YYYY-MM-DD/index.html). Use when the user asks to create, scaffold, restyle or add slides to a meetup deck, turn talk notes (NOTES.md / TALK.md / AGENDA.md) into slides, or add doodle SVG animations, QR closing slides or screenshots to a deck.
---

# Meetup slide deck (Reveal.js)

Distilled from the eight decks in this repo (2026-02-19 through 2026-10-09). The
newest deck, `2026-10-09/index.html`, is the reference implementation: copy its
`<head>`, frame slides and script block when starting a new deck, then replace
the talk content.

## 1. Folder and file layout

```
YYYY-MM-DD/
  index.html     # the whole deck: HTML + inline <style> + inline <script>
  NOTES.md       # talk narrative, written first (or TALK.md)
  AGENDA.md      # speakers / running order, when it is a community night
  assets/        # screenshots, QR codes, logos, background art
  .gitignore     # assets/*.otf and assets/*.woff2 (see section 3)
YYYY-MM-DD-slide.png   # title-slide thumbnail for README.md, at repo root
```

- One folder per meetup, named by ISO date. Each deck is fully self-contained:
  no build step, no shared stylesheet, no npm. Open it via a local HTTP server
  (the markdown plugin fetches files, so `file://` is not reliable).
- Reveal.js is loaded from jsDelivr, pinned to `reveal.js@4.6.1` (core,
  `white.css` theme, monokai highlight, plus the markdown, highlight and notes
  plugins). Keep the pin identical across decks.
- After a meetup: add a session entry to `README.md` (newest first, title,
  venue, edition, speakers with LinkedIn links) with the
  `YYYY-MM-DD-slide.png` thumbnail. `./capture-slides.sh YYYY-MM-DD` exports
  every slide to PNG at 1280x720 @2x.

## 2. Reveal setup

```js
Reveal.initialize({
  width: 1280,
  height: 720,
  margin: 0,
  hash: true,
  transition: "slide",
  transitionSpeed: "default",
  plugins: [RevealMarkdown, RevealHighlight, RevealNotes],
  autoPlayMedia: true,
});
```

- Fixed 1280x720 canvas, so absolute positioning (title layout, floating
  doodles) is predictable and matches `capture-slides.sh`.
- `hash: true` together with section ids gives readable, shareable URLs.

## 3. Fonts: never commit them

The Anthropic fonts (`AnthropicSansDisplay-*.otf`, `AnthropicSerifDisplay-*.otf`)
and the talk fonts (Gotham, DINPro `.woff2`) are licensed and must **never
enter git**.

- Reference them via `@font-face` from `assets/` and always give a system
  fallback stack (`Arial, Helvetica, sans-serif` / `Georgia, serif` /
  `ui-monospace, Menlo`), so a fresh clone without fonts still renders.
- Every deck folder that references fonts locally gets its own `.gitignore`:
  ```
  assets/*.otf
  assets/*.woff2
  ```
  The root `.gitignore` entry `assets/*.otf` is anchored to the root
  `assets/` folder only; it does **not** cover `2026-xx-xx/assets/`. Older decks
  (2026-09-10) point to `../assets/*.otf` in the ignored root folder instead.
- Before every commit: `git status --short | grep -Ei '\.(otf|woff2?|ttf)$'`
  must print nothing. Never `git add -A` without checking this.

## 4. Deck structure: meetup frame around the talk

Every deck has two visual worlds:

1. **Meetup frame** (Claude Community branding): terracotta `#d97757`
   background, `claude-world.jpg` bottom-left, Anthropic Serif/Sans fonts.
2. **Talk** (`class="talk"`): the speaker's own palette and fonts (warm or cool
   gray background, Gotham / DINPro), "no Anthropic branding".

Fixed running order:

| id | slide |
|----|-------|
| `welcome` | `.title-layout`: Claude spark top-left, Node globe right, kicker ("Claude Community"), h1, date line. Elements absolutely positioned in percentages. |
| `meetups` / `agenda` | community nights only. Agenda lists speakers, Q&A, closing and drinks, plus a photo-consent line ("We're taking photos tonight. Tell us if you'd rather not be in them.") |
| `about-me` + `ambassador` | vertical stack: short bio bullets, then the ambassador image with a `link-footer` URL |
| `<!-- ===== SLIDES START ===== -->` | marker comment |
| `talk-title` | `.talk` title slide with `.mono` kicker, h1, `.sub` tagline, `.mono.plain` name + date |
| chapters | the talk itself (section 5) |
| `takeaway(s)` | 3 numbered items in an `<ol>` |
| `<!-- ===== SLIDES END ===== -->` | marker comment |
| `call-for-speakers` | community nights: LinkedIn QR + "Reach out" link |
| `thanks` | closing slide with **two QR codes** (section 8) |

The talk background color is set in JS on `section.talk`, and a `slidechanged`
listener toggles `.in-talk` on `.reveal` so controls and progress bar follow the
talk palette:

```js
document.querySelectorAll("section.talk").forEach((s) => {
  s.dataset.backgroundColor = "#e4e6e7";
});
const syncTalkChrome = (slide) =>
  document.querySelector(".reveal").classList.toggle("in-talk", slide.classList.contains("talk"));
Reveal.on("ready", (e) => syncTalkChrome(e.currentSlide));
Reveal.on("slidechanged", (e) => syncTalkChrome(e.currentSlide));
```

## 5. Slides: ids, chapters, content

- **Every slide gets an `id`**, kebab-case and semantic, prefixed by its
  chapter: `vanguard-signs`, `vanguard-heavy-use`, `foster-licenses`,
  `guardrails-bigquery`. Screenshot companions get a `-shot` suffix
  (`antipode` / `antipode-shot`). Never number ids (`slide-7`): ids must
  survive reordering, since they are the URL hash.
- Horizontal section = chapter; vertical sections = its steps. Precede each
  chapter with an HTML comment (`<!-- 3 — who might be the hidden AI vanguard -->`).
- First slide of a chapter carries a `.mono` kicker with chapter number and
  short label: `<p class="mono">3 · spot them</p>`. Follow-up slides in the
  chapter omit it.
- Short headings phrased as a claim or a question ("Heavy use is not always
  good use", "Who might be the hidden AI vanguard?").
- 3 to 5 bullets, each one line, max one nesting level. Nested bullets are
  for quotes from real people ("I was fed up with doing X, so I built skill Y").
- One punchline per slide max, as `.big` or `.sub` below the list
  ("Serve the food on the plate, not in the mouth").
- Prompts the audience could type go in `<blockquote class="prompt">` (rendered
  with a `›` prefix); case studies side by side go in `.flow > .step`.
- Links appear as a short `link-footer` without protocol
  (`vibes.vincentbruijn.nl/antipode`).

## 6. No fading bullets

Do **not** use `class="fragment"` on bullets, list items, steps or images. The
whole slide appears at once; the talker controls pacing by voice, and
`capture-slides.sh` exports stay faithful. (2026-06-18 and 2026-09-10 still
used fragments; 2026-10-09 dropped them entirely.) If an idea needs a reveal,
make it a next vertical slide instead.

## 7. Balancing images and text

The decks evolved from image-first (2026-02-19: screenshot after screenshot,
60 to 85vh, often without text) to a clear split:

- **Text slide, then image slide.** A bullet slide (`antipode`) is followed
  by a vertical `-shot` slide holding just the screenshot: `class="shot-img"`,
  `max-height: 72vh`, rounded corners plus shadow, and a `.mono.plain` caption
  (usually the URL) underneath.
- **When text and image share a slide**, the text stays short (heading plus
  a tagline or 1 to 2 lines) and the image shrinks: 40 to 58vh. The ambassador
  image is 45vh; QR codes are 26 to 28vh.
- **Before/after comparisons**: `.compare` flex row, both images `44vh`,
  `max-width: 48%`.
- Every `<img>` has a descriptive `alt`; decorative ones (`spark`, `globe`)
  use `alt=""`.
- When a screenshot is still missing, park a dashed `.shot` placeholder or
  an HTML comment (`<!-- IMAGE 2 -->`) rather than leaving a gap; resolve or
  remove them before presenting.
- In the latest deck, raster images are nearly gone from the talk itself:
  doodles carry the visual weight (section 9), screenshots are reserved for
  proof (real tools, real output).

## 8. Closing slide: two QR codes

```html
<section id="thanks">
  <h2>Thanks</h2>
  <div class="two-col" style="justify-content: center">
    <div class="strategy-card" style="font-size: 0.7em; text-align: center">
      <p class="b">repo</p>
      <img src="assets/github_y-a-v-a_repo.png" alt="GitHub QR — y-a-v-a" style="max-height: 26vh; max-width: 100%" />
      <p class="small">github.com/y-a-v-a</p>
    </div>
    <div class="strategy-card" style="font-size: 0.7em; text-align: center">
      <p class="b">site</p>
      <img src="assets/www_vincentbruijn_nl.png" alt="vincentbruijn.nl QR" style="max-height: 26vh; max-width: 100%" />
      <p class="small">vincentbruijn.nl</p>
    </div>
  </div>
  <p class="small" style="margin-top: 20px">
    <span class="b">Vincent Bruijn</span> · Claude Community Ambassador
  </p>
</section>
```

Always exactly two cards (repo + site), each: label, QR (26vh), the plain URL
in `.small`. The LinkedIn QR belongs on `call-for-speakers`, not here. Copy the
QR PNGs into the new deck's `assets/`.

## 9. From emoji to SVG doodles

Emoji usage dropped steadily: 2026-03-27 had ~84 in the body, 2026-06-18 ~75,
2026-09-10 ~24, 2026-10-09 zero. Do not decorate headings or bullets with
emoji (`🙏 Thanks` became `Thanks`). Visual accents are hand-drawn SVG
"doodles" instead.

**Doodle system (from 2026-10-09):**

- One hidden `<svg>` at the top of `<body>` defines the `#doodle-rough`
  filter (`feTurbulence` + `feDisplacementMap`, scale ~3.5): it gives every
  stroke a wobbly, hand-inked look. Wrap doodle content in `<g class="rough">`.
- Two placements:
  - `svg.doodle.inline`: centered under the content, ~340 to 600px wide.
  - `svg.doodle.float`: `position: absolute`, placed with an inline
    `style="right: 50px; bottom: -120px"` in the slide's empty corner,
    ~170 to 280px. Pick the corner the bullets do not use.
- Always `aria-hidden="true"`; the doodle illustrates, it never carries
  information that is not in the text.
- Style vocabulary (CSS classes, no inline colors): `.ink` (3px round
  stroke in `--talk-text`), modifiers `.thin` `.thick` `.soft` `.dots`
  `.dashes`, fills `.paper` `.shade` `.glass` `.solid`, `.glint` highlights,
  `text` in DINPro mono. Recurring motif: a four-point sparkle (Claude spark)
  drawn as a `Q`-curve star.
- **Draw-on animation**: a small script tags every shape before
  `Reveal.initialize`. Stroked shapes get `pathLength="1"` and `.draw`
  (animated `stroke-dashoffset`, fill fades in at the end); the rest get
  `.fade`. `--i` (index, overridable with `data-i`) staggers them by 0.05s.
  Animations only run on `section.present`, so they replay on every visit.
- Extra one-off motions: `.typing` dots (staggered with `--d`), `.sweep`
  (radar), `.ping`, `.hop` + `.hop-shadow`.
- Wrap all animation rules in
  `@media (prefers-reduced-motion: no-preference)`.
- Doodles follow the talk's metaphor literally: a magnifying glass over a
  crowd for "vanguards", a token fuel gauge for "runs out of tokens", a
  guardrail on a curved road for "guardrails".

## 10. Notes first, slides second

Each talk starts as prose in `NOTES.md` / `TALK.md` with numbered chapters
that map 1:1 onto slide chapters. Slides compress each paragraph to 3 to 5
bullets; the original prose goes verbatim into `<aside class="notes">` on the
matching slide (as in 2026-09-10), so the speaker view (`S`) holds the story
the bullets only hint at. Keep wording consistent between notes and slides.

## 11. Before presenting: checklist

- [ ] Every slide has a unique, semantic `id`
- [ ] No `class="fragment"`, no emoji in the talk
- [ ] No leftover `TODO`, `IMAGE n` placeholders, `.shot` boxes or empty `<li>`
- [ ] Every `<img>` has `alt`; screenshots compressed (aim < 500 KB each)
- [ ] `thanks` has exactly two QR codes; QR files present in `assets/`
- [ ] No `.otf` / `.woff2` / `.ttf` staged; deck `.gitignore` present
- [ ] Spell-check bullets (typos slip into nested quotes easily)
- [ ] Run `./capture-slides.sh YYYY-MM-DD` and flip through the PNGs for overflow

## 12. Suggested improvements (not yet applied)

1. **Prune inherited CSS.** Each deck copies the previous `<style>` block,
   so dead rules accumulate (`.fragment` opacity, `.quote`, `.claude`,
   `.highlight`, `.code-block`, `.date-text` are unused in 2026-10-09). Start a
   new deck by deleting anything not referenced in its body, and drive the talk
   background from one token: the JS hard-codes `#e4e6e7` while `--talk-bg`
   says `rgb(227, 218, 204)`; read the variable via `getComputedStyle` instead.
2. **Bring speaker notes back.** 2026-09-10 had 17 `<aside class="notes">`;
   2026-10-09 has none, although `NOTES.md` holds richer material (the
   translation and Excel-SaaS anecdotes, the "hired 3 to 4 people" story).
   Copy the relevant paragraph into each slide's notes.
3. **Optimize assets.** Several PNGs are around 2 MB (`Anthropic-ambassador.png`,
   `mand.png`, `antipode.png`), copied into every deck. Resize to ~1600px wide
   and compress (or use WebP); replace the base64-encoded G-STAR logo `<img>`
   with an inline `<svg>` using `currentColor`, so it follows the talk palette.
4. **Make the font ignore global.** Replace the root `.gitignore` line
   `assets/*.otf` with `**/assets/*.otf` and `**/assets/*.woff2`, so a new
   deck folder is protected even before its own `.gitignore` exists.

## 13. Self-learning

When the user explicitly steers the output while creating or editing a slide
deck ("don't do X", "always do Y", "move this", "I prefer Z"), apply the change
**and update this SKILL.md accordingly**: add or adjust the relevant rule in the
section it belongs to, so the next deck starts from the corrected pattern.
