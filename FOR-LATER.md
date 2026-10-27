# For Later: Claude's Backlog

_Working file. Never deployed (only `site/` is). Last updated 2026-10-11, at the move to the GitHub repo._

These are items noticed but deliberately not done yet. Most need the user's input or OK before acting. Keep this list current: when an item is done, delete it here and record the outcome in HANDOFF.md.

## 1. Cava deck: slide fixes (needs the user's updated deck or an OK to edit it)

**2026-10-11: the user answered "None for now".** Don't raise this again unless the user does.

Source: `sources/cava-cognition/Cava Grill Analysis.pptx`.

- **Slide 15:** the heading says "Project Overview", but the slide covers Artifact Arrangement and People Arrangement. Change it to "Physical Space" (it continues slide 14) or "Artifact & People Arrangement".
- **Slide 17:** the heading says "Physical Space", but the slide is about coordination. Change it to "Coordination".
- **Slide 17:** "when passing an employee passes your bowl" should be "when an employee passes your bowl".
- **Slide 7:** "The drinks on the side also allows people" should be "allow".
- **Slide 19:** "guidelines strategically placed around the establishment allows newcomers" should be "allow".
- **Slide 12:** "available at request" should be "available on request".
- **Slide 3:** add the missing periods after "delivery as well" and "take-out".
- **Photos:** slides 1, 5, 11, 12 and 17 look like CAVA's own product and marketing photos. Ask the user. If they are, add a credit ("Product photos: CAVA") on the slides or once on the page.
- **Privacy:** slide 14 shows an employee's face. Suggest blurring it.
- **Readability:** the body text on most slides is very small for a screen. The visible text panel was removed at the user's request (2026-10-11), so bigger slide text matters more now. The text survives only for screen readers.

**After the deck changes, run the re-export pipeline:**

1. Copy the new pptx over `sources/cava-cognition/Cava Grill Analysis.pptx`.
2. Export the slides with PowerPoint COM: `Presentations.Open(path, -1, 0, 0)`, then `Slide.Export(path, "PNG", 1920, 1080)`. PowerPoint is installed.
3. Resize to 1600×900 JPEG at quality 84 with `System.Drawing` into `site/assets/cava-cognition/slides/cava-slide-NN.jpg`.
4. Embed the origin with `impeccable embed-prompt`.
5. Update the `#deck-data-cava` JSON in `site/index.html`. Its text is verbatim from the slides, so edited slides need edited text.
6. The ticks are generated from the JSON and evenly spaced, so a changed slide count needs nothing else.

## 2. Cava write-up: optional extras (the user hasn't chosen yet)

The page uses a short two-paragraph write-up in the user's voice. The user rewrote P1's opening as a question and set the h1 to "A Fast Casual Business Analysis" (see HANDOFF). If any of the longer draft is used, fit it to that framing. The longer draft is in `.impeccable/drafts/cava-content-draft.md`:

- an intro
- three findings: "The line does the talking", "The room gives the directions", "The work happens before you arrive"
- a recommendation
- a "what I'd do next" section

Items marked [new] there are my interpretations; the user must confirm them:

- "The bowl itself carries the order down the line". This is the strongest distributed-cognition insight.
- Turning the structural pillar into a wayfinding landmark. Open question: is the pillar with the pickup signage on slide 9 the same one as on slide 19?
- Next steps: interviewing staff, and observing at more times of day.

**Other idea:** redraw the hand-sketched floor map (slide 6) as a clean flow map, with numbered information touchpoints along the customer path. It could merge slides 6 and 18. (Section labels under the ticks were dropped: the user wants evenly spaced ticks with no sections.)

## 3. Existing copy (text freeze; needs the user's OK)

**2026-10-11: the user answered "Not yet".** Bring it up again only near launch.

- On the Brew page, the two image alt texts are swapped. The box render and the dieline need each other's alt text.
- The resume page has no heading, and the "Download Resume" link doesn't say it's a PDF.
- Typos in the existing copy:
  - Brew: "Whether its" should be "Whether it's". "hot sauces packaging" should be "hot sauce packaging".
  - Buff Life: "a moments notice" should be "a moment's notice". "frantically login" should be "frantically log in".

## 4. Accessibility debt (found, not fixed)

- **Phone menu height:** with 7 bars, the phone top band is about 223px tall, roughly 27% of the screen. Consider a compact phone menu (smaller bars, or a horizontal scroller in the same plate style).
- **Image-only slides:** the slides are pictures of text. Keep the screen-reader-only slide text (`#deck-data-cava`, `#deck-data-power-creep`) in sync with any deck edits.
- **Power Creep page text is small:** on the page, the PDF's body text renders at about 16px at 1920×1080 but only about 10px at 1366×768. Full screen and the screen-reader text cover it. Natively redrawn charts (§6) would help more than anything else.

## 5. Assets

- `sources/buff-life/bufflife2.png` (the app screen) is only 462px wide, and `site/assets/buff-life/buff-life-screen.png` looks soft. Ask the user for a 2× re-export from Figma (924px or wider).
- 7 older files in `site/assets/` have no embedded origin: the headshot, the Brew logo, box render and dieline, and the Buff Life logo, screen and poster. Run `impeccable embed-prompt --scan site/assets` and embed their origins.
- **The Buff Life reel can play now.** The claude.ai artifact couldn't hold the 22.5MB file, so the page shows a poster with a fake play button and the caption "On the live site the 2:24 captioned reel plays here; this demo shows its preview frame." GitHub Pages can serve `site/assets/buff-life/buff-life-reel.mp4`.
  - Swap the poster for a `<video controls preload="none" poster=…>` in the same `shape-chamfer` frame, with the captions burned in.
  - Drop or rewrite the caption. The wording needs the user's OK.

## 6. Projects 4 and 5

**Project 4, Power Creep (built 2026-10-11 from the user's PDF).** Open items:

- **Needs the user's OK:** P1, the card description and the menu label "Power Creep". The user has already set the h1 ("It's... A Little Too Effective?") and named the class (Programming for Information Science). The text and alternatives are in `.impeccable/drafts/power-creep-content-draft.md`.
- **PDF typos** are listed in the draft. Like the Cava slide fixes, they need the user's updated PDF; then re-run `tools/render-pdf-pages.ps1` into `site/assets/power-creep/pages/` and update `#deck-data-power-creep`.
- **Idea:** redraw the two charts as on-brand SVG or HTML charts if the user can share the cleaned data. The matplotlib charts are white boxes on the dark site, and the per-set bar chart is hard to read, as the user says themselves.
- **Idea:** a "Download the write-up (PDF)" link under the viewer. It would need a web copy in `site/assets/power-creep/`.

**Project 5 is "Roam Ready", the user's senior capstone.** The menu bar, card title and h1 use the name. The card and page text read "Senior Capstone Placeholder", and the art is still the placeholder box. When the content arrives (originals go in `sources/roam-ready/`, web copies in `site/assets/roam-ready/`):

- **Menu fit:** recheck that every bar fits the sidebar when selected and enlarged. The method is in HANDOFF.md.
- **Menu offsets:** keep them in the 0.1 to 1.1rem range in an irregular order, with no drift.
- **Frames:** give each new frame a shape class that differs from its neighbors.
- **Containment:** recheck that every picture stays inside its plate.
- **Writing:** match the user's two-paragraph voice (see HANDOFF.md, "Writing new project copy").

## 7. Before launch

- **Deploy only `site/`.** The Pages workflow already does that. Nothing in `sources/`, `archive/`, `tools/` or the notes should ever be published.
- **The reel caption** (§5) mentions "this demo".
- **Missing page metadata:** no `<meta name="description">`, favicon or social preview image (`og:image`) yet. All three need the user's wording or art.
- **Repo visibility:** if the repo is public, these notes are public too, including candid notes about copy, typos and open questions. Prefer a private repo. GitHub Pages from a private repo needs GitHub Pro, which students get free through the GitHub Student Developer Pack. Otherwise, move the notes out before making it public.
- Choose a host and domain (both undecided; GitHub Pages works, with a custom domain later if wanted).
- **Impeccable finish:** finish review, then DESIGN.md plus `.impeccable/design.json` via the `impeccable-documenter` subagent. Run `detect` on the final pages.

## 8. Housekeeping

- **The Color & Type Explorer is retired** (2026-10-11): its source is `archive/prototypes/color-type-explorer.html`, and the claude.ai artifact stays online as is. Under its "Demo black & white" palette the slide counter was near-invisible, and that was the only `detect` finding. It no longer matters.
- **The spent direction round:** `.impeccable/mocks/decision/` and the 8 reference boards in `.impeccable/references/` are spent material. Keep them; don't act on them.
- **The old Dropbox folder** (`D:\Dropbox\Job Stuff\Portfolio`) can be retired once the repo is set up and the user is happy with it. Keep it until then, because it also holds the 89.7MB reel.
