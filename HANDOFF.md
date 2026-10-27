# Portfolio Redesign: Session Handoff

_Updated 2026-10-11, late night: the project was exported from its old Dropbox folder into this GitHub-ready repo and reorganized by page. Working notes only. **Only `site/` is ever deployed.**_

**Start a new chat with:** "Read HANDOFF.md, PRODUCT.md and FOR-LATER.md, then continue." Impeccable is installed as `/impeccable <command>`.

## Where things stand

- **The site is `site/index.html`.** It's the motion prototype turned into a standalone page: all 7 "pages" are `<section class="page">` elements in one file, with hash routing (`#home`, `#brew`, …).
  - It is the single source of truth for the design: colors, type, menu, frames, motion and both slide viewers. Edit it directly.
  - Its media live in `site/assets/<page>/`. The originals they were made from are in `sources/<page>/`.
  - The previous prototype files (`site-demo.html` and the Color & Type Explorer) are in `archive/prototypes/`. They're retired, so don't edit or sync them.
- **The real multi-page build hasn't started.** Whether to split the single page into separate pages is still an open decision (see "The user's answers").
- **Not deployed yet.** `.github/workflows/deploy-pages.yml` can publish `site/` to GitHub Pages. It runs only when started by hand, and Pages must first be set to "GitHub Actions" in the repo settings. The host and domain are still the user's call.
- **The user's working style:** fast, visual iteration. They review the page, send screenshots with short notes, and expect each fix to be applied, verified and published. Ask only when a request is genuinely ambiguous.

### Repo layout

| Path | What it holds | Deployed |
|---|---|---|
| `site/index.html` | the whole site | yes |
| `site/assets/home/` | `headshot.jpg` | yes |
| `site/assets/doctors-brew/` | `brew-logo.png` (home card), `brew-box-render.jpg`, `brew-dieline.jpg` | yes |
| `site/assets/buff-life/` | `buff-life-logo.png` (home card), `buff-life-screen.png`, `buff-life-reel-poster.jpg`, `buff-life-reel.mp4` (720p, 22.5MB; not used by the page yet, see FOR-LATER §5) | yes |
| `site/assets/cava-cognition/` | `cava-logo.png` (home card), `slides/cava-slide-01..19.jpg` (1600×900) | yes |
| `site/assets/power-creep/` | `power-creep-logo.png` (home card, 1020×611), `pages/power-creep-page-01..06.jpg` (1236×1600) | yes |
| `site/assets/resume/` | `resume-preview.png` (page 1 of the F26 resume, 1300×1682), `David-Doctor-Resume.pdf` (the download; a copy of `sources/resume/David Doctor Resume F26.pdf`) | yes |
| `sources/home/` | `headshot.jpg` (original) | no |
| `sources/doctors-brew/` | `brew1.png` (front box design), `brew2.jpg` (3D render), `brew3.png` (logo) | no |
| `sources/buff-life/` | `bufflife1.png` (logo), `bufflife2.png` (app design, only 462px wide) | no |
| `sources/cava-cognition/` | `Cava Grill Analysis.pptx` (19 slides), `cava-logo-original.png`, `cava-logo-black-text.png` (the cut-out logo in its original colors) | no |
| `sources/power-creep/` | `Power Creep Final Write Up.pdf` (6 pages), `pokemon-tcg-logo-original.png` (4920×2515, Bulbapedia) | no |
| `sources/roam-ready/` | empty; the capstone's files go here | no |
| `sources/resume/` | `David Doctor Resume F26.pdf` (the current resume) | no |
| `tools/` | `serve.ps1` (local preview server) and the image/PDF scripts listed under "Environment gotchas" | no |
| `archive/` | `old-site/` (the teal/coral 4-page site), `resume-s26/` (superseded resume), `prototypes/` (the retired claude.ai prototype sources). Their relative paths point at the old layout, so they don't render correctly from here | no |
| `.impeccable/` | Impeccable state: `config.json` (`buildPath: comp`), `drafts/`, `critique/`, `live/config.json` (now `site/*.html`), spent `mocks/` and `references/` | no |
| `.claude/launch.json` | the preview server "portfolio" on port 8765 | no |

- **Kept outside the repo:** the full-length `Buff Life Captioned Reel.mp4` (89.7MB). It came in the export zip's `NOT-FOR-GITHUB-large-originals/` folder and also stays in the old Dropbox folder. GitHub warns above 50MB and the web uploader stops at 25MB.
- **The old Dropbox folder** (`D:\Dropbox\Job Stuff\Portfolio`) is the legacy working copy with the old flat layout (`media/`, originals in the root, `.impeccable/prototypes/`). Once the repo exists, work here, not there. Keep the git clone **outside** Dropbox, because Dropbox and `.git` folders conflict.

## Artifacts on claude.ai (private review links; the user shares them from the Share menu)

- **Portfolio Motion Prototype**, pinned, version 26 (tab title "David Doctor Portfolio" since v26): https://claude.ai/artifact/L29t96tdQ7fWdWfTzU4R2k
  - Until now it was published from the old `.impeccable/prototypes/site-demo.html`, with media uploaded at the old `media/…` paths and the resume uploaded as `resume.pdf`.
  - **To keep using it from the repo:** read it first, then publish `site/index.html` to that URL with `files` mapping every `assets/…` path the page uses. The first publish from the repo must upload them all, because the artifact holds them under the old names.
  - The 22.5MB reel can't be uploaded (the per-file limit is 15MB).
  - Once the site is on GitHub Pages, the Pages URL can replace this as the review link. Ask the user.
- **Color & Type Explorer**, version 23: https://claude.ai/artifact/7WGCMUMxXNUok92UDHoBrH. Retired on the move: the palette and fonts are chosen. It stays online as is; its source is `archive/prototypes/color-type-explorer.html`. Favorites store: empty.
- **Persona UI Study**, pinned: https://claude.ai/artifact/EvRPjAtBSfmrWsrMb19orC. A motion reference only; its source is gone.

## The design system as built (the user's standing decisions; don't reopen without a reason)

### Look
- **Dark only,** whatever the system setting. There's no theme switch and no light palette; the user rejected the light versions.
- **Palette: "Turf War, Yellow vs Blue"** (Splatoon 3's ink pair), chosen by the user. Tokens:

  | Token | Value | Used for |
  |---|---|---|
  | `--paper` | `#0d0e14` | page background |
  | `--paper-2` | `#1d1f2b` | frames and plates behind pictures |
  | `--ink` | `#f3f3f6` | text |
  | `--ink-2` | `color-mix(ink 74%, paper)` | secondary text |
  | `--plate` | `#4b3df0` | sidebar and buttons; text on it is `--plate-ink` `#ffffff` |
  | `--accent` | `#e8f53a` | selected menu item and triangle cursor; text on it is `--accent-ink` `#14160a` |
  | `--mark` | `var(--accent)` | name highlight and text selection |
  | `--blot` | `var(--accent)` | page-change blot |

  Contrast: body 17.4:1, menu 6.5:1, selected item 15.3:1.
- **Fonts:** headings are Archivo (weight 900, width ~118%, slight tilt); body is Atkinson Hyperlegible; small notes are Martian Mono. All load from Google Fonts.
- **Scaling on big monitors:** `html { font-size: clamp(100%, 0.45vw + 0.58rem, 112.5%) }`, which gives 16px at 1440 and 18px by about 1940.

### Layout
- **Sidebar:**
  - Always visible, `--side-w: 18.5rem`, clipped with a slanted right edge `polygon(0 0, 89% 0, 100% 100%, 0 100%)`.
  - On phones (≤760px) it becomes a sticky top band whose bars wrap.
  - The page area runs full-bleed under it (`.page { padding-left: var(--side-w) }`) so the blot can grow from behind the menu.
- **Content column:** `.page-inner { max-width: 78rem; margin-inline: auto }`. The resume page caps at 54rem.
- **Home project cards:** two-up when the container is at least 60rem, art above text, with every second card dropped 3.5rem. Narrower screens show stacked rows with cascading `--x` offsets.
  - **No "View Project" buttons** (the user removed them on 2026-10-11). Each card's title is the link: `<h3 class="h3"><a class="proj-link" href="#page">`. The art plate is the same link for mouse users (`tabindex="-1" aria-hidden="true"`).
  - Hover pairing: hovering the art underlines the title, and hovering the title lifts the art 3px (`:has()`, hover devices only).
- **Box sizing:** `*, *::before, *::after { box-sizing: border-box }` is required. Without it, the sidebar drew 76px wider than its space and the buttons gained extra bottom space.
- **No sideways scrolling:** `.page { overflow-x: hidden }`, because tilted plates poke a few pixels past phone edges.

### Menu ("the mix": Persona 3 Reload geometry with some Persona 5 angle)
- **The 7 bars, in order:** Home, Doctor's Brew, Buff Life, Cava Cognition, Power Creep, Roam Ready, Resume.
- **Placement:** the bars sit on **one straight vertical line with irregular offsets**, not a cascade. The user explicitly asked for this.
  - Offsets: `.6, .15, .95, .1, 1.05, .35, .75rem`. Drift is 0.8px per 100px.
  - Angles run from −3° to −8°. Text is 1.15rem Archivo 800; the gap between bars is 0.85rem.
- **Selected item:** a yellow plate stamps in with an overshoot. Its corners re-randomize every **250ms within a small range**, each corner moving 0–3% sideways and 0–10% up or down. The user rejected the original 120ms with wide ranges as too sporadic.
- **Deselecting:** the old plate drops out **immediately**, with no transition. Running the overshoot easing on the way down flashes an inverted sliver on the old bar, which the user spotted. The overshoot transition lives only on the `.is-on` rules.
- **Cursor:** a triangle that snaps between bars in held steps with a small overshoot, then pops.
- **Fit rule:** every bar, selected and scaled (about +8% width), must clear the sidebar's slanted edge. Recheck this whenever a label changes (method under "How to work").
  - "Cava Cognition" is the tightest, with 20px to spare at 1366×768.
  - "Power Creep" has at least 45px to spare at 1366, 1562 and 1920.
  - "Roam Ready" has 59px at 1366×768 and 70px at 1920×1080. The phone band stayed 223px.

### Pictures and frames
- **Pictures and body text stay straight.** Only the plates behind them are angled.
- **Frame shapes vary:**
  - Shape classes set `--clip`: `shape-lean`, `shape-quad`, `shape-cut`, `shape-step`, `shape-wedge`, `shape-chamfer`. Neighboring frames never repeat one.
  - Cuts, steps and wedges are **fixed pixel sizes**, never percentages, because percentages balloon on tall frames.
  - Tilts mix directions. Tall frames tilt at most ±1.5°.
  - `.layered` adds a second plate in the sidebar blue, offset and tilted against the first.
- **Pictures must stay fully inside their plates** (the user's rule).
  - Frame padding is `max(5%, 34px) max(6%, 30px)`.
  - Verify with the geometry check. Last run, every corner had at least 7px to spare at 1920, 1562, 1280 and 375. The F26 resume preview clears its step plate by at least 25px at 1920×1080.
- **Headshot:** the upright photo fills an angular "shard", `clip-path: polygon(0 4%, 68% 0, 100% 7%, 95% 100%, 5% 95%)`, with no plate and no tilt.
  - Rejected: a tilted photo, an upright photo over a dark tilted plate, a parallelogram clip, a two-corner chamfer clip, an all-yellow plate, and a blue plate with a yellow sliver.
- **Project cards (`.proj-art`):** every card wears the stepped plate plus the blue plate behind it, tilted 2°. It's the default for the class, so new cards inherit it.
- **Placeholder art:** `.ph-art` is a dashed box reading "Project image coming soon".

### Buttons and keyboard focus
- **`.btn`** (My LinkedIn in the sidebar and the intro, Download Resume):
  - The slanted plate is drawn by `.btn::before`, with `clip-path: polygon(0 0, 100% 0, 93% 100%, 0 100%)` and its color from `--btn-bg` (default `--plate`). `.on-plate` sets `--btn-bg: var(--plate-ink)`.
  - The button itself is **not** clipped, so its focus ring can show.
  - **Focus ring:** `.btn:focus-visible` chains 8 `drop-shadow`s. That draws a 3px gap in the surface color, then a 3px `--accent` ring, both following the slant.
  - The gap color is `--btn-gap`: it defaults to `--paper`, and `.side .btn` sets `--plate`. A button on any other surface needs `--btn-gap` set to match it.
  - Don't move `clip-path` back onto `.btn`; that would clip the ring again.
- **LinkedIn "pocket" buttons** (the user's request, 2026-10-11):
  - Both LinkedIn links are `.btn.btn-big`: 1.08rem text, `min-height: 3.25rem`, about 15% bigger.
  - Each sits in a `<span class="pocket pocket-up|pocket-right">` wrapper with an svg `.pocket-icon`: LinkedIn's "in", `fill: var(--accent)`, with the letters cut out (`fill-rule="evenodd"`).
  - The icon sits behind the plate, fully hidden: at least 4px of plate around it, checked at 800×680.
  - On hover (hover devices) or keyboard focus it slides out in held frames: steps(3) to a 14% overshoot, then settles, 200ms in total. Leaving drops it back at once, like the menu plate.
  - `pocket-up` (sidebar): pops up above the button, rotated −8°, with 32% still tucked under.
  - `pocket-right` (Home intro): slides out of the right edge, rotated +8°, with 32% tucked under the slanted lip.
  - With keyboard focus, `--lift: 6px` pushes the icon 6px further, so the focus ring doesn't cover the "in".
  - The wrapper keeps the icon outside `.btn`, so the focus ring's `filter` doesn't outline the icon. `data-in` sits on the intro wrapper.
- **Small clipped controls** use a color swap instead: `.deck-btn` goes from blue to yellow; `.lb-close` goes from yellow to blue with white ✕ (yellow to white was only 1.2:1). Any new swap must change contrast by at least 3:1.

### Motion
- **Held frames everywhere** (stepped easing).
- **Page change:** Persona 3 Reload's blot. A yellow circle with an SVG turbulence wobble grows from the clicked link in 10 steps over 500ms. The new page clips in through a growing circle 90ms behind, then its `[data-in]` elements enter in steps, 50ms apart.
- **Buttons** lift 2px on hover (hover devices only, inside `@media (hover: hover)`).
- **Reduced motion:** the user said "no reduced-motion setting", meaning no on-page toggle. The code still honors the OS `prefers-reduced-motion` preference by skipping animations; keep that.
- **Not wanted:** guide lines, ambient sway, bubbles, the shatter effect, and literal Persona 4 elements (the TV dial, the power-on effect).

### Slide viewers: one script, two decks
- The deck script runs once per `.deck[data-deck="NAME"]`. Each deck has its own full-screen `<dialog id="lb-NAME">` and its own JSON `<script id="deck-data-NAME">`.
- Attributes on `.deck`:
  - `data-src`: the image pattern, with `{n}` as the two-digit number, e.g. `assets/cava-cognition/slides/cava-slide-{n}.jpg`.
  - `data-unit`: the word used in labels. It defaults to "slide"; the Power Creep deck uses "page".
- Aspect ratio: `--deck-ar` (default `16 / 9`) feeds the page viewer's width cap, the `aspect-ratio` of `.deck-open` and `.lb-shot`, and the full-screen width formula. `--deck-h` (default `50dvh`) is the height budget for the image.
- **Carousel (`.deck`):**
  - Each slide sits straight on an angled plate with a `.layered` blue plate behind.
  - Slide changes on the page use a 6-step diagonal clip wipe, led by a yellow skewed slash.
  - Prev and next are blue plate buttons with triangle arrows. The counter reads "01 / 19".
  - **Ticks are evenly spaced** at 24px steps, on every deck. The user asked for consistent spacing on every progress bar on 2026-10-11, so the old section gaps are gone; don't re-add them. The current tick is a yellow plate with the 250ms jitter, which only runs while its deck's page is current or its full-screen view is open.
  - Arrow keys and swiping both page through the slides.
  - **No visible text panel:** the user removed "Read this slide's text" on 2026-10-11. The verbatim slide text from the deck's JSON stays in a screen-reader-only `.sr-only.deck-text-body`, headed "Slide N text: …", so the image-only slides keep a text alternative.
- **Full screen (`<dialog class="lightbox">`):**
  - Opening grows the blot from the click point; closing shrinks the view back into the slide.
  - Esc, ✕, or a click outside the slide closes it, and focus returns to the slide.
  - Both views share one current slide.
  - **No wipe in full screen** (the user's rule): slide changes cut straight to the next image, with no slash.
  - **Containment:** the plate cut is a fixed `--cut` (8px, or 16px from 900px wide), tilted .6°. The padding is `--py --px` (10px 16px, or 20px 30px from 900px wide), and the width formula uses the same variables. The slide clears the plate by at least 7.5px at 375, 10px at 1920×1080 and 8px at 2560×1440.
  - Animation completion uses `animation.finished.then(...)`, not `onfinish`, because `onfinish` never fires when frames don't render.
- **Pinned grid columns:** both grids use `grid-template-columns: minmax(0, 1fr)`. Without it, the 19 ticks widened the full-screen view on phones and shifted it 90px.

### Cava page (`#project3`)
- **Layout:** the h1 reads "A Fast Casual Business [Analysis]", with Analysis on the yellow highlight (the user's wording, 2026-10-11). Below it, `.deck-split` puts the two-paragraph write-up on the left and the viewer on the right when the container is at least 52rem; narrower screens stack them. From a 68rem container up, the text column widens to 26rem.
- **Fits one screen (the user's rule):** at 1920 wide the page must not scroll. `.page-inner.fit` trims the bottom padding to `clamp(24px, 4vh, 48px)` on screens wider than 760px. The content ends at 734px, so it fits any viewport at least about 780px tall. At 1536×730 (a 1080p laptop at 125% scaling) it still scrolls about 68px, because the h1 wraps to two lines; tighten that only if the user asks.
- The viewer is capped at `min(100%, 50dvh × 16/9 + 4.5rem)`, so the slide and its controls fit in one view.

### Power Creep page (`#project4`)
- **Layout:** the same as Cava, also `.fit`.
- **Portrait pages:** `.deck-portrait` sets `--deck-ar: 612 / 792` (US Letter) and `--deck-h: max(22rem, calc(100dvh - 18rem - var(--head-h)))`, so the page and its controls fit one screen.
  - `--head-h` is the h1's real height. The deck script measures it with a ResizeObserver, so a headline that wraps to two lines (it does at 1366 wide) shrinks the page image instead of making the page scroll. Any h1 length works.
  - On screens up to 60rem tall: `max(18rem, calc(100dvh - 21.5rem - var(--head-h)))`. There the narrower viewer can wrap its ticks onto a second row, and the extra space pays for it.
  - Measured with no vertical scroll at 1920×1080, 1920×970, 1562×900, 1536×730, 1440×960 and 1366×768. At 1280×800 the layout stacks and scrolls, the same as Cava.
- **Ticks:** 6, evenly spaced.
- **Containment:** the page image clears the angled plate by at least 9.7px on the page at every width checked. In full screen it clears by 10.1px at 1920 and 6.1px at 375.

### Content rules
- **Existing copy is frozen.** That covers the Home, Doctor's Brew, Buff Life and Resume text, page titles and alt text. The pending fixes are listed in FOR-LATER §3.
- **New project content is added only when the user asks.** Placeholder copy must say it's a placeholder.
- **Writing new project copy:** match the user's own pattern. Two short paragraphs, no headings or bullets.
  - First: a casual second-person hook, often a list opener ("Schedules, grades, events, clubs, there's plenty to…").
  - Second: first-person context ("This was a … project for…", "I created…").
  - Plain words, about 45–85 words per paragraph.
  - Don't invent facts, metrics or quotes. Mark any interpretation as new and get it confirmed.

## Projects

| Page (hash) | Menu label | Assets | Status |
|---|---|---|---|
| `#home` | Home | `home/` | Intro with headshot, plus 5 project cards |
| `#brew` | Doctor's Brew | `doctors-brew/` | Existing copy and images. Frames: box render `shape-quad`, dieline `shape-lean` +1.5° |
| `#bufflife` | Buff Life | `buff-life/` | Existing copy, reel poster `shape-chamfer`, app screen `shape-wedge layered` +1.5° |
| `#project3` | Cava Cognition | `cava-cognition/` | Done |
| `#project4` | Power Creep | `power-creep/` | Built 2026-10-11 from the user's PDF; some copy awaits the user's OK |
| `#project5` | Roam Ready | none yet | The user's senior capstone, still a placeholder. Card title "Roam Ready"; card text and page text both read "Senior Capstone Placeholder" (the user's wording); h1 "Roam [Ready]"; placeholder art in a `shape-cut` frame |
| `#resume` | Resume | `resume/` | Resume preview and PDF download (F26) |

The hashes are historical (`#project3` is Cava). Changing them breaks nothing internally, but keep them stable once the site is public.

**Cava Cognition** is a field study for the user's **Information Ecosystems** class (CU Boulder).
- **Deck:** `sources/cava-cognition/Cava Grill Analysis.pptx`, 19 slides, analyzed through distributed cognition.
- **Home card:** title "User Research". Description (the user's text): "A deep analysis on how information moves physically and cognitively at Cava Grill."
- **Logo:** `site/assets/cava-cognition/cava-logo.png`, with the white background removed and the black type reversed to white for the dark site. `sources/cava-cognition/cava-logo-black-text.png` keeps the original colors.
- **Page write-up** (drafted from the user's direction in their voice; the user rewrote P1's opening):
  - P1: "How does a fast-casual restaurant like Cava design the flow of information to keep things efficient for both the consumer and the employee? Between the assembly line, the menus, and the signs around the store, everything is set up so you can go from the door to your bowl without anyone having to explain a thing."
  - P2: "This was a research project for my Information Ecosystems class, where I looked at a fast casual restaurant as an information system. I visited during the dinner rush and again in the afternoon, took pictures, sketched a map of the store, and ordered my own bowl to see the whole process from the customer's side. Using distributed cognition, I broke down how the space, the staff, and the timing all work together to keep the line moving."
- **Open items:** the slide fixes and the optional longer write-up are in FOR-LATER §1–2.

**Power Creep** is the user's Nov 2024 "Pokémon Trading Card Analysis" (resume): Python, Pandas and Seaborn on an API plus two CSVs, written up as "Power Creep in Pokémon Trading Card Game".
- **Source:** `sources/power-creep/Power Creep Final Write Up.pdf`, 6 pages (a Google Docs export of the user's "Final Write Up.pdf").
  - Pages: cover, Introduction, How Bad Is Power Creep?, The Process, and two Results pages with a line chart and a bar chart.
  - They were rendered with Windows.Data.Pdf to `site/assets/power-creep/pages/power-creep-page-01..06.jpg` at 1236×1600, JPEG q86. Origins are embedded.
- **Class:** Programming for Information Science (the user, 2026-10-11).
- **Home card:** title "Data Analysis". Description: "A Python data analysis of how much stronger Pokémon cards have gotten from 1999 to 2024." I drafted it; it awaits the user's OK.
- **Card art:** `site/assets/power-creep/power-creep-logo.png`, 1020×611. It recreates the user's cover lockup, minus the "David Doctor / Final Project Write Up" byline (the user's request).
  - The title is the white text "Power Creep In", drawn from the PDF's own embedded Lexend Bold glyph outlines with the PDF's kerning.
  - The logo is Bulbapedia's "Pokémon_TCG_logo.png", from Pokémon's official TCG rulebook, downloaded with the user's OK: `sources/power-creep/pokemon-tcg-logo-original.png`.
  - Rebuild with `tools/power-creep-lockup.ps1 -Pdf <pdf> -Logo <png> -Out <png> [-LogoWidth 1000] [-Color '#ffffff']`.
- **Page:** h1 "It's... A Little [Too] Effective?", the user's wording, with "Too" on the yellow highlight. P2 opens "This was a final project for my Programming for Information Science class, where I used…". The text, alternatives and the PDF's typos are in `.impeccable/drafts/power-creep-content-draft.md`.
- **Open:** the user's OK on the menu label, card text and P1. They edited the h1 and P2 directly, which suggests the rest is accepted, but they haven't said so.

## How to work on the site

- **Edit `site/index.html` only.** There's no second copy to keep in sync any more.
- **Previewing:** `preview_start` with "portfolio" serves `site/` on port 8765. Open `http://localhost:8765/?v=N#page`.
  - Change `?v=N` on every reload: a URL that differs only by its hash doesn't reload, so the page stays stale.
  - Without Claude: `powershell -ExecutionPolicy Bypass -File tools/serve.ps1`, then open http://localhost:8765/.
- **Publishing:** commit and push. To deploy, run the "Deploy site to GitHub Pages" workflow (Actions tab), once Pages is set to "GitHub Actions" in the repo settings. To keep the claude.ai artifact in step, see "Artifacts" above.
- **Concurrent sessions:** the user sometimes runs several Claude sessions at once; `ListAgents` shows them.
  - Before committing or publishing, check `git status` and `git diff`, so you never sweep another session's half-finished edit into your commit.
  - If two sessions must touch the same file, message the other one with `SendMessage` first. Keep edits targeted; a whole-file rewrite can drop another session's edit made in the same moment.
  - Example from 2026-10-11: one session removed the tick section gaps on purpose, at the user's request. Another session nearly re-added them from an older live version.
- **Checks to run after visual changes** (scripts via `javascript_tool`):
  - **Containment:** rebuild each `::before` plate polygon from computed `clip-path`, `rotate` and the inset box. Confirm all 4 image corners are inside, with their distance in px. The step plate (`shape-step`) isn't convex, so test with point-in-polygon plus the distance to each segment, not the distance to the edge lines.
  - **Menu fit:** compare each bar's `right + 8%` of its width with the sidebar's slant edge at the bar's top, `side.left + side.width × (0.89 + 0.11 × (y − side.top) / side.height)`. Drift is a linear regression of the bars' left edges against y.
  - **Sideways overflow:** `page.scrollWidth − clientWidth` should be 0.
  - **No vertical scroll on the deck pages** at 1920×1080 (Cava, Power Creep).
  - **Widths:** desktop at the pane's own width, 1920×1080, 1366×768, 1280×800, and the mobile preset at 375.
  - **Detector:** `C:/Users/Owner/.claude/skills/impeccable/scripts/impeccable detect --json site/index.html` once after UI edits. The hooks are off. Last run (2026-10-11, on the exported `site/index.html`): clean.
  - **Focus check:** press Tab with the `computer` key action. Programmatic `.focus()` only shows `:focus-visible` after a real keyboard event. For a 1:1 screenshot, emulate 800×680; the pane downscales larger viewports.
  - **Broken references:** every `src`/`href` in `index.html` should resolve under `site/`, and each deck's `data-src` should expand to all its numbered files. The export was checked this way: 14 images, 19 slides, 6 pages and the PDF, with no console errors.

## Environment gotchas

- **This PC has no Node or Python.** No ffmpeg, ImageMagick or cwebp either. What works:
  - **Images:** PowerShell `System.Drawing`, plus inline C# through `Add-Type` for pixel work.
  - **Removing a white background:** color-to-alpha. Alpha = max over channels of (255 − c); unmix each channel; crop to the artwork plus 10px.
  - **PDF to PNG:** `tools/render-pdf.ps1 -Pdf <pdf> -Out <png> -Width 1300` renders page 1 with Windows.Data.Pdf through WinRT. Run it in Windows PowerShell 5.1.
  - **Every PDF page to JPEG:** `tools/render-pdf-pages.ps1 -Pdf <pdf> -OutDir <dir> -Prefix <name-> [-Height 1600] [-Quality 86]`.
  - **Images embedded in a PDF:** `tools/pdf-images.ps1 -Pdf <pdf> -OutDir <dir>`. DCTDecode streams are plain JPEGs. When an image has a FlateDecode gray `/SMask`, the script writes a PNG with that alpha. Google Docs exports put each picture in as its own XObject.
  - **Cutting a logo off a busy light background:** `tools/logo-cutout.ps1 -Src -Out -X -Y -W -H [-HoleMaxY n] [-Clear @(x,y,w,h)]`.
    - It flood-fills the light pixels reachable from the crop edge, makes enclosed light holes above `HoleMaxY` transparent too (letter counters), and unmixes the background from a 2px edge band.
    - Call it in-process with `& script.ps1 ... -Clear @(0,0,150,62)`. Through `powershell -File`, an `[int[]]` argument silently falls back to its default.
  - **Text from a Google Docs PDF:** it uses subset fonts with no `cmap`. To redraw it, read the glyph outlines from the embedded `glyf` table and map characters through the font's ToUnicode CMap, as `power-creep-lockup.ps1` does.
  - **Embedded origins:** `impeccable embed-prompt <image> --prompt "Origin: …"` writes provenance into a raster; `--read` shows it; `--scan <dir>` lists files without one.
  - **Slides:** PowerPoint COM is installed and exports slides (pipeline in FOR-LATER §1).
  - **Video:** the WinRT `MediaTranscoder`.
- **The browser pane:**
  - Animations stall while the pane isn't drawing. To check end states, call `document.getAnimations().forEach(a => a.finish())`. Don't trust mid-animation screenshots.
  - `ResizeObserver` callbacks stall the same way, e.g. the deck's `--head-h`. After a resize, take a screenshot to force a frame before measuring, or you'll read the previous size's value.
  - `localStorage` survives reloads; use it to keep check scripts across navigations.
  - The local server doesn't answer HEAD requests reliably, so a HEAD `fetch` can hang the script. Use GET with an AbortController timeout. Awaiting `img.decode()` can also hang while the pane is hidden.
- **PowerShell:** `R` is a built-in alias (Invoke-History), so don't name a function `R`.
- **Bash:** heredocs containing curly quotes inside a larger command can break the quoting. Use the Write tool for data files. In `s{}{}` Perl substitutions, unbalanced braces in CSS break compilation; use `s###`.
- **Blocked sites:** Reddit is blocked in the browser pane and in WebFetch. The Splatoon wiki (Inkipedia) returns 403 to WebFetch.
- **Figma `generate_image`:** available on plan `team::1519250510214569063`. It spends Figma AI credits.

## Impeccable process state

- **PRODUCT.md:** current (updated 2026-10-11 for the repo).
- **DESIGN.md:** not written yet, by design. It's written at the finish, at the repo root, by the `impeccable-documenter` subagent, from the built site.
- **Direction round:** closed without a pick. The user pinned the prototype's own world instead, so don't re-run concept rolls or direction rounds.
- **For the real build:** no surface brief or direction contract exists yet. Recommended: treat `site/index.html` as the approved visual reference, write a short direction contract from the system above, then build. Confirm this with the user first; `config.json` says comp-first, but the prototype now plays the comp's role.

## The user's answers (2026-10-11)

- **Copy freeze:** "Not yet". The §3 fixes stay on hold; don't ask again until the user brings it up or the build is near launch.
- **Cava deck fixes:** "None for now". Leave the pptx and the slides as they are.
- **Projects 4 and 5:** Project 4 became Power Creep from the user's PDF. Project 5 is "Roam Ready", the user's senior capstone, with "Senior Capstone Placeholder" as its content until they send material.
- **Tick spacing:** evenly spaced on every progress bar; no section gaps.
- **Build structure:** still open. The user asked whether separate pages would be as smooth as the demo. My answer:
  - Everything inside a page is identical, because it's the same code.
  - Page changes in Chrome, Edge and Safari can match the demo closely using cross-document View Transitions (Chrome/Edge 126+, Safari 18.2+). The old page stays on screen, so the blot and the reveal can still overlap.
  - Firefox has only same-document View Transitions (since 144). Cross-document is on the Interop 2026 list but wasn't confirmed shipped. Firefox would fall back to a JS handoff: the blot covers the page, then the next page opens out of the yellow, sequentially, about 0.2s longer.
  - Risk: the live SVG turbulence wobble may need replacing with a pre-shaped wobbly `clip-path` polygon or mask inside a view transition.
  - My recommendation: separate pages, but first build a two-page transition test for the user to judge. Waiting on their reply.

## Next steps

1. **Set up the repo** if the user hasn't yet: create it (private is recommended while these notes are in it; see README), commit everything, and optionally enable Pages with the workflow. Then retire the Dropbox copy.
2. **Before anything goes public** (FOR-LATER §7): the reel caption still says "this demo shows its preview frame", and that wording needs the user's OK. (The tab title is done: "David Doctor Portfolio", the user's wording, 2026-10-11.)
3. **Power Creep copy:** still unconfirmed: P1, the card description and the menu label "Power Creep" (FOR-LATER §6).
4. **Get the user's build-structure call** (above). If they say yes to the test, build a two-page transition spike, for example `site/_vt-test-a.html` and `site/_vt-test-b.html` (ignored by git), using the real sidebar and blot. Preview it via "portfolio", then delete it.
5. **Remaining accessibility debt** (FOR-LATER §4): the phone menu height needs a design proposal for the user; with 7 bars kept, it doesn't get shorter.
6. **The real build:** separate pages with cross-document View Transitions plus a JS fallback for Firefox, or keep single-page hash routing if the user prefers. Shared CSS and vanilla JS; the motion, the menu and the slide viewers need JS.
7. Finish: polish, the finish review, then DESIGN.md plus `.impeccable/design.json` via the documenter.
