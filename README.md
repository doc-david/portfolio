# David Doctor — Portfolio

The UX and product design portfolio of David Doctor, an Information Science student at the University of Colorado Boulder.

It's a hand-built static site: HTML, CSS and a little vanilla JavaScript, with no build step and no dependencies beyond Google Fonts.

## What's where

| Folder | What it holds | Published |
|---|---|---|
| [`site/`](site/) | The website. `index.html` holds all seven pages; `assets/` holds their images, slides and files, one folder per page | **Yes, this folder only** |
| [`sources/`](sources/) | The original files the web assets were made from (artwork, decks, PDFs, logos), one folder per page | No |
| [`tools/`](tools/) | PowerShell helpers: a local preview server and image and PDF converters | No |
| [`archive/`](archive/) | Superseded material: the previous site, an older resume, and the earlier prototype files | No |
| `HANDOFF.md`, `PRODUCT.md`, `FOR-LATER.md` | Working notes: the design system and current state, product context, and the backlog | No |
| `.impeccable/`, `.claude/` | Design-tool state and the preview configuration | No |

### Pages

| Page | Link | Assets | Originals |
|---|---|---|---|
| Home | `#home` | `site/assets/home/` | `sources/home/` |
| Doctor's Brew | `#brew` | `site/assets/doctors-brew/` | `sources/doctors-brew/` |
| Buff Life | `#bufflife` | `site/assets/buff-life/` | `sources/buff-life/` |
| Cava Cognition | `#project3` | `site/assets/cava-cognition/` | `sources/cava-cognition/` |
| Power Creep | `#project4` | `site/assets/power-creep/` | `sources/power-creep/` |
| Roam Ready | `#project5` | (coming soon) | `sources/roam-ready/` |
| Resume | `#resume` | `site/assets/resume/` | `sources/resume/` |

## Preview locally

Serve the `site/` folder with any static web server. On Windows, with nothing else installed:

```powershell
powershell -ExecutionPolicy Bypass -File tools/serve.ps1
```

Then open http://localhost:8765/.

## Publish with GitHub Pages

1. In the repository's **Settings → Pages**, set **Source** to **GitHub Actions**.
2. Open the **Actions** tab, choose **Deploy site to GitHub Pages**, and click **Run workflow**.

The workflow publishes `site/` and nothing else. It only runs when started by hand. To publish on every push to `main`, add a `push` trigger to `.github/workflows/deploy-pages.yml`; the comment in that file shows how.

## Not in this repository

The full-length Buff Life reel (89.7 MB) is kept outside the repository. The site uses its 22.5 MB web version in `site/assets/buff-life/`.
