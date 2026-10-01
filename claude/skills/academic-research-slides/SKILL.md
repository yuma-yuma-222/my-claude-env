---
name: academic-research-slides
description: >-
  An executable design system for building academic research presentation
  slides (PowerPoint / .pptx) in the Oita University network-security lab
  style — IEICE conference talks, thesis and defense presentations, lab
  seminars, and progress reports on darknet / DDoS-detection research.
  Governs colors (white canvas, steel-blue structure, scarce red argument),
  typography (bold Meiryo, 20pt floor), layout (title zone, one message +
  one figure per slide), diagram construction (blue-fill vs outline nodes,
  red attack-flow arrows), agenda "you are here" slides, citations, and
  page numbers. Load this skill whenever the user asks for research slides,
  a conference deck, 学会発表スライド, 卒論/修論発表, 中間発表, ゼミ資料,
  or any .pptx about their research — even if they never mention design.
  Always combine with the pptx skill for file mechanics.
---

# Academic Research Slides

A restrained, high-legibility slide system for research talks. The audience
must read each slide's claim in three seconds from the back of a lecture
hall. Every rule below serves that goal — when improvising, choose whatever
maximizes legibility and figure-first communication.

This skill governs *design decisions*. For the mechanics of creating or
editing .pptx files, use the pptx skill alongside this one.

Full design tokens (exact colors, sizes, spacing, component specs):
`references/DESIGN.md`. Read it before building a deck from scratch.

## 1. The three-color grammar

The entire system is three roles that never blur:

1. **White + black** — canvas and text. Pure white background (#ffffff, no
   tint, no template), pure black text (#000000). This is the information
   floor.
2. **Blue = structure** (#156082, steel-blue). Fills diagram nodes, the
   active agenda band, table headers, chart bases. An *area* color — almost
   never a text color.
3. **Red = argument** (#ff0000; #c00000 for the single strongest line).
   Exactly three uses: red-bold keywords in text, 6pt attack-flow arrows,
   no-fill callout frames on charts. Nowhere else.

One slide carries at most these three families (plus gray #818181 for muted
items). If a diagram truly needs a fourth track, use the supplementary
accents (orange #e97132, green #196b24, sky #0f9ed5) — but first consider
splitting the figure instead. The scarcity of red is what gives it power:
three or more thick red arrows on one slide means the figure needs
rethinking, not more red.

## 2. Typography

- Everything Japanese in **Meiryo**; all alphanumerics inside figures
  (DNS, QUIC, IPs, formulas) in **Arial**, half-width always.
- Slide titles: Meiryo bold 40pt, black, left-aligned, same position every
  slide.
- Body: 24pt standard, 28pt for the lead line, 20pt absolute floor.
  Only sources (14–16pt) and page numbers (12–14pt) may go smaller.
- Emphasis is **red + bold, and only that** — never underline, italic, or
  a size bump.
- Text volume cap: one 1–2 line lead + 3–5 bullets. Past that, split the
  slide. Bullets nest at most two levels.
- Meiryo assumes Windows. If the deck may be presented from macOS, warn the
  user to dry-run on the actual PC; acceptable substitutes are BIZ
  UDPGothic or Yu Gothic, never a Mincho serif.

## 3. Layout

- 16:9. Margins ≥ 0.5in left/right.
- Fixed anatomy of a content slide, top to bottom: title zone (~1.2in, title
  only, thin divider line below) → lead line (28pt) → **one large figure,
  chart, or table** → footer (~0.5in: source left, page number right).
- One message per slide. Never a title-plus-bullets slide with no figure —
  that is the failure mode this system exists to prevent.
- When a slide feels thin, enlarge the figure; never pad with prose.

## 4. Diagrams (the deck's core)

Build figures skeleton-first, emphasis last:

1. Lay out all nodes as white-fill rounded rectangles with 1–2pt black or
   blue borders, connected by thin (1–2pt) black arrows. Get the structure
   and reading order (left→right or top→bottom) right first.
2. Fill only the load-bearing nodes blue (#156082, white bold Meiryo label,
   16–24pt). The blue node is where the eye goes first.
3. Turn only the flow-to-watch into a 6pt red arrow (attack path, the data
   flow the argument depends on).
4. Mark damage/impact with the explosion shape (`irregularSeal1`) carrying
   a short label like "resource exhaustion" — the one dramatic shape
   allowed.
5. Cast of characters (PC, server, attacker) uses flat clip-art, no
   photography.

Tables: blue header row with white text, black-outline body cells, red only
on the one figure that matters. Charts: blue base series; the point of
interest either filled red or ringed by a 3–6pt no-fill red frame
(`chart-callout`) — leave the chart itself untouched.

## 5. Deck structure

- **Cover:** centered bold title 32–40pt over 2–3 lines; ◎ marks the
  speaker; co-authors with affiliations matched by * / **; date, conference
  name, session number at the foot. No page number.
- **Agenda:** six items (Background → Objective → Related Work → Methods →
  Results → Summary & Future Work). **Re-show the agenda at the start of
  every section**, lighting only the current item as a blue band with white
  text; inactive items black or gray. This is the running "you are here."
- **Content slides:** as in Section 3.
- **Summary slide:** the single most important line set in deep-red bold
  (#c00000) — used once in the whole deck.

## 6. Citations and page numbers (non-negotiable)

- Every borrowed figure, screenshot, or external data (e.g. Cloudflare
  reports) carries superscript [n] inline and a full source line
  `[n] Author, "Title," URL` at 14–16pt, slide foot, left-aligned. No
  borrowed figure appears bare.
- Page number bottom-right in gray on every slide except the cover — the
  deck will be interrogated by slide number in Q&A.

## 7. Workflow

1. Get the content first: research message, section structure, what figures
   exist or must be drawn. One claim per slide; write each slide's lead
   line before designing it.
2. Read `references/DESIGN.md` for exact tokens; load the pptx skill for
   file mechanics.
3. Build slides by duplicating a same-type slide and swapping contents, so
   title position, fonts, and page numbers stay consistent for free.
4. Draw figures skeleton-first (Section 4). Add red last: when a slide is
   otherwise done, red-bold the one point that matters most, then stop.
5. Self-check every slide before delivery: white canvas? title 40pt bold
   Meiryo? body ≥ 20pt? exactly one figure? ≤ 3 color families? red used
   ≤ 2 spots? sources on borrowed material? page number present? Does the
   claim land in three seconds? Fix any "no" before moving on.
6. The deck must land when exported to PDF — never design around animation.
