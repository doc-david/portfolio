# Power Creep page: content draft (2026-10-11)

This is the copy now live on `#project4` in `site/index.html`, plus alternatives and open questions. Source: the user's PDF, "Final Write Up.pdf" (copied to `sources/power-creep/Power Creep Final Write Up.pdf`), and the resume's "Pokémon Trading Card Analysis" entry (Nov 2024: Python, Pandas, Seaborn, an API and two CSVs). Nothing here is invented. Lines marked **[confirm]** need the user's OK.

## Menu
Power Creep **[confirm]**. Alternatives: "Pokémon TCG", "Pokémon Power Creep" (the second is too long for the sidebar fit rule).

## Home card
- Art: a recreation of the user's cover lockup, white "Power Creep In" in Lexend Bold over the Pokémon TCG logo, without the byline (`site/assets/power-creep/power-creep-logo.png`; the user's request, 2026-10-11).
- Title: Data Analysis
- Description **[confirm]**: A Python data analysis of how much stronger Pokémon cards have gotten from 1999 to 2024.

## Page heading
It's... A Little [Too] Effective? This is the user's wording (2026-10-11), with "Too" highlighted. It replaced my draft, "How Bad Is [Power Creep?]".

## Write-up (live) [confirm]
P1: More health, more damage, more powerful abilities. Every new expansion of the Pokémon Trading Card Game gives you a reason to buy in, but it also pushes older cards further out of the game. It's called power creep, a common game design trap, and it got so bad that official tournaments only allow cards from the newest sets.

P2: This was a final project for my Programming for Information Science class, where I used Python, Pandas, and Seaborn to measure just how strong the cards have gotten. I combined a CSV of every card from 1999 to 2023 with an API for the 2024 releases, then charted the highest HP card of each year by evolution stage. The strongest Basic card of 2024 has more than double the HP of the strongest Stage 2 card from 1999.

Notes:
- P1's list opener comes from the PDF's introduction ("More health, more damage, powerful abilities").
- "Official tournaments only allow cards from the newest sets" restates the PDF's "a cycle format where only cards found from the latest set could be used". It's plural on purpose: the real Standard format rotates in several recent sets, not just one.
- "Final project" is from the PDF's cover. The user confirmed the class: Programming for Information Science (2026-10-11).
- The result in P2's last sentence is from the PDF's results page: Basic 2024 at about 260 HP against Stage 2 1999 at 120 HP on the chart.
- I left the per-set chart out of the write-up because the PDF says the user wasn't happy with it. It's still page 6 of the viewer.

## Viewer
The 6 PDF pages at 1236×1600 (`site/assets/power-creep/pages/power-creep-page-01..06.jpg`). The 6 ticks are evenly spaced. The screen-reader text for each page is verbatim from the PDF, typos included. For the two chart pages, a short "Chart:" description comes first; I wrote it from the charts themselves.

## Typos in the PDF (not fixed; the PDF is the user's)
- p4: "would work together will the set data CSV" should be "while".
- p4: "I combined them and my first visualization" is missing a verb ("and made my first visualization").
- p5: "its clear" should be "it's clear". "in the 2024" should be "in 2024". "Terra Pokemon" is spelled "Tera" (the Tera Pokémon ex mechanic).
- p6: "lowered powered sets" should be "lower-powered sets". "the Pokemon Company carefully select" should be "selects".
- p3: "these card's evolutions" should be "these cards' evolutions".
- p2: "adapt a cycle format" should be "adopt a rotation format".

## Ideas (not done)
- Redraw both charts as on-brand SVG or HTML charts in the site's palette, if the user can share the cleaned data (CSV or notebook). The PDF's matplotlib charts are white rectangles on a dark site. The embedded originals are 585×435 for the line chart and 1606×993 for the bar chart. The bar chart, with roughly 150 sets, would read better as a sorted or grouped chart (promo sets against main sets).
- Offer the PDF itself as a download link under the viewer.
