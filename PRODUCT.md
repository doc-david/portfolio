# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Primary: people evaluating David Doctor for **UX / product design** roles, meaning recruiters, hiring managers and design team members. He is looking for both **internships** and **new-grad full-time roles** (graduating May 2027). They judge fit from the work, the thinking behind it, and the resume.

## Product Purpose

The personal portfolio of David Doctor, an Information Science student at the University of Colorado Boulder (B.S., College of Media, Design and Information; minor in Japanese and in Creative Technology and Design; expected May 2027). It exists to get him UX/product design interviews. Success means a visitor understands what he designs, looks at the work, and reaches the resume or LinkedIn.

## Positioning

He describes himself on the site as "a designer, developer, and analyst" with interests in "branding, UI design, and digital experiences." His resume backs a range that most student design portfolios don't have:

- professional product design: a Video Product internship at Spectrum (Jun–Aug 2026). He redesigned user flows and UI components in the Spectrum TV streaming app, audited competitor platforms for usability gaps, and wrote project requirements.
- user research: campus surveys and interviews for Buff Life, and a field study of Cava Grill using distributed cognition
- high-fidelity prototyping in Figma
- visual and brand craft: Doctor's Brew
- data analysis and dashboard work: Tableau, Power BI, Qualtrics, Python. On the site, that's the Power Creep project, a Python analysis of Pokémon TCG card data.

Cava Cognition is the portfolio's clearest research evidence. It shows observation, mapping and analysis through a named framework.

_Open:_ a sharper one-line positioning statement hasn't been written with the user yet.

## Operating Context

- **The site** is `site/index.html` in this repo: 7 pages in one file with hash routing. Home, Doctor's Brew, Buff Life, Cava Cognition, Power Creep, Roam Ready (the senior capstone, a placeholder for now), and Resume.
- **The previous site** (the teal/coral 4-page version) is archived in `archive/old-site/`. The original portfolio is also backed up in git elsewhere.
- Visitors leave the site for LinkedIn (`linkedin.com/in/davidrdoctor/`) and the resume PDF.
- **Not deployed yet.** The repo can publish `site/` to GitHub Pages through a manual workflow. The host and domain are still undecided.
- **Source control:** moved from a Dropbox folder (no git) to a GitHub repo on 2026-10-11. The Dropbox folder remains as a legacy copy.

## Capabilities and Constraints

- **Stack:** static HTML and CSS, plus a small amount of vanilla JavaScript for the motion system: the menu plate and cursor, the page-change blot, and the two slide viewers. There's no build step and no package manager. Fonts load from Google Fonts. The site is a single file with hash routing; the real build may become separate pages using cross-document View Transitions (undecided).
- **Content phase:**
  - Existing copy is frozen until the user lifts it: the Home, Brew, Buff Life and Resume text, page titles and alt text.
  - New projects are being added on the user's request. They're written in the user's voice (see Brand Commitments) and confirmed with them.
- **Projects:** Doctor's Brew, Buff Life, Cava Cognition and Power Creep (the Pokémon card analysis), plus Roam Ready, the user's senior capstone (a placeholder for now).
  - Other candidates on the resume:
    - the Spectrum internship work, probably under NDA, so ask before showing anything
    - dashboard work
    - Social/event graphics were on the S26 resume but aren't on F26.
  - Whether any of these can be shared is undecided.
- **Design-system approach:** don't adopt a heavyweight design system such as Material or Carbon. Grow the project's own tokens instead. The current system is documented in HANDOFF.md until DESIGN.md is written at the finish.
- **Media:** the site uses web-ready copies in `site/assets/<page>/`, at about 2× display size.
  - The Buff Life reel is 720p (22.5 MB) with a preview image. The Cava slides are 1600×900 JPEGs; the Power Creep pages are 1236×1600.
  - The originals live in `sources/<page>/` and are never deployed. The 89.7 MB full-length reel stays outside the repo.
  - `sources/buff-life/bufflife2.png` is only 462px wide, so a 2× re-export from Figma is needed.
- **Private working files:** everything outside `site/`: `HANDOFF.md`, `PRODUCT.md`, `FOR-LATER.md`, `DESIGN.md` (when written), `sources/`, `tools/`, `archive/`, `.impeccable/` and `.claude/`. Only `site/` is deployed.
- **Undecided:** host and domain; content for Roam Ready (project 5); whether more projects follow; copy changes to existing pages; whether the repo is public.

## Brand Commitments

- **Name:** David Doctor (full name David Rafael Doctor, on the resume).
- **Voice:** first person, warm and casual ("Hey! I'm David Doctor").
  - Project pages use two short paragraphs: a casual hook that speaks to the reader, often opening with a list ("Schedules, grades, events, clubs, there's plenty to keep track of…"), then first-person context ("This was a … project…").
  - Plain words, no headings or bullet points in the write-ups.
- **Doctor's Brew** is a fictional beer brand David created. It's a pepper beer based on a Filipino family recipe made with Saling Labuyo peppers. The concept is fictional; present it as a design project, not a real company.
- **Cava Cognition** studies a real restaurant (Cava Grill) as an observer and customer. Present it as a class field study, not as work for CAVA.
- **Power Creep** analyzes public Pokémon TCG card data. Present it as a student data project, not as work for The Pokémon Company. The logo on its card identifies the subject.

## Evidence on Hand

All paths are in `sources/` unless noted.

- **Headshot:** `home/headshot.jpg`
- **Doctor's Brew:**
  - `doctors-brew/brew3.png` (logo)
  - `doctors-brew/brew1.png` (front box design)
  - `doctors-brew/brew2.jpg` (3D render)
  - Project copy: the `#brew` page in `site/index.html`, from the old `archive/old-site/brewpage.html`
- **Buff Life:**
  - `buff-life/bufflife1.png` (logo)
  - `buff-life/bufflife2.png` (app design)
  - `Buff Life Captioned Reel.mp4` (the full-length captioned prototype reel, 89.7 MB, kept outside the repo; the web copy is `site/assets/buff-life/buff-life-reel.mp4`)
  - Project copy: the `#bufflife` page, from the old `archive/old-site/bufflife.html`
  - The resume says it was a Figma high-fidelity prototype informed by surveys and interviews across campus. No research artifacts for it are in the project yet.
- **Cava Cognition:**
  - `cava-cognition/Cava Grill Analysis.pptx` (19 slides): his field photos, a hand-sketched floor map, and analyses of social, physical and temporal space and of how representational states move through the restaurant
  - `cava-cognition/cava-logo-original.png` (logo)
  - The page write-up was drafted with the user's direction (2026-10-11)
  - Some slide photos may be CAVA's own marketing images; that's unconfirmed
- **Power Creep:**
  - `power-creep/Power Creep Final Write Up.pdf`, 6 pages, the user's final project write-up (Nov 2024). It has an introduction, the research question, the process (a CSV of cards from 1999 to 2023 plus an API for 2024, cleaned with Pandas), and two charts: the highest HP per year by evolution stage, and the highest HP per set.
  - The cover is a screenshot of the Pokémon TCG Pocket app, with the card game's logo. The card photos in the PDF are official Pokémon card art.
  - It was the final project for **Programming for Information Science** (the user, 2026-10-11).
  - The page write-up was drafted from the PDF (2026-10-11). The user set the h1 ("It's... A Little Too Effective?") and named the class; P1 and the card text haven't been explicitly confirmed.
  - The home-card art recreates the user's cover lockup ("Power Creep In" over the Pokémon TCG logo, without the byline). The clean logo comes from Bulbapedia (`power-creep/pokemon-tcg-logo-original.png`), downloaded with the user's OK.
- **Roam Ready:** nothing yet; the capstone's files go in `roam-ready/`.
- **Resume:** `resume/David Doctor Resume F26.pdf`, the current one, supplied 2026-10-11. The site serves a copy as `site/assets/resume/David-Doctor-Resume.pdf`, and `site/assets/resume/resume-preview.png` is rendered from it. Its summary reads "Designer and analyst focused on user experience. Working end to end, from user research and interface design to front-end and back-end implementation." The older S26 resume is in `archive/resume-s26/`.
- **None of these exist:** testimonials, client work, measured project outcomes, or interviews with Cava staff. Don't invent quotes, metrics, research results or testimonials.

## Product Principles

1. **Built for UX/product design reviewers.** Every decision should help a reviewer judge David as a UX/product designer quickly.
2. **The site is evidence too.** A designer's hand-built portfolio gets judged on its own craft, accessibility and performance, not just the projects it shows.
3. **Foundation before content.** Build a system that holds today's projects well and takes more later without restructuring.
4. **Only real evidence.** Show what exists, and leave gaps visible rather than filling them with made-up process or results.
