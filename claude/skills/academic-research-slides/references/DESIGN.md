---
version: alpha
name: Academic-Research-Slides
description: A restrained, high-legibility slide system for Oita University network-security research (darknet / DDoS-detection studies), built for IEICE conference talks and thesis defenses. The system anchors on a pure-white canvas with black bold Meiryo titles, deep-blue diagram boxes, and a single scarce red for conclusions and emphasis. Brand voltage comes from the blue/red split — blue is the color of structure, red is the color of argument, and nothing else competes with them. Type voice runs bold Meiryo throughout, sized large for a lecture hall. 16:9, one message per slide, diagram-driven — never a wall of bullets.

colors:
  primary: "#156082"
  primary-dark: "#0e2841"
  emphasis: "#ff0000"
  emphasis-strong: "#c00000"
  link-blue: "#0070c0"
  ink: "#000000"
  muted: "#818181"
  canvas: "#ffffff"
  on-primary: "#ffffff"
  accent-orange: "#e97132"
  accent-green: "#196b24"
  accent-sky: "#0f9ed5"

typography:
  title-slide-main:
    fontFamily: "Meiryo, メイリオ, Calibri, sans-serif"
    fontSize: 32-40pt
    fontWeight: 700
    lineHeight: 1.2
    align: center
  slide-title:
    fontFamily: "Meiryo, メイリオ, Calibri, sans-serif"
    fontSize: 40pt
    fontWeight: 700
    lineHeight: 1.1
    align: left
  body-lead:
    fontFamily: "Meiryo, メイリオ, Calibri, sans-serif"
    fontSize: 28pt
    fontWeight: 400-700
    lineHeight: 1.3
  body-md:
    fontFamily: "Meiryo, メイリオ, Calibri, sans-serif"
    fontSize: 24pt
    fontWeight: 400
    lineHeight: 1.3
  body-sm:
    fontFamily: "Meiryo, メイリオ, Calibri, sans-serif"
    fontSize: 20pt
    fontWeight: 400
    lineHeight: 1.3
  diagram-label:
    fontFamily: "Meiryo, メイリオ, Arial, sans-serif"
    fontSize: 16-24pt
    fontWeight: 700
    lineHeight: 1.2
  caption-citation:
    fontFamily: "Meiryo, メイリオ, Arial, sans-serif"
    fontSize: 14-16pt
    fontWeight: 400
    lineHeight: 1.25
  slide-number:
    fontFamily: "Calibri, Arial, sans-serif"
    fontSize: 12-14pt
    fontWeight: 400
  latin-in-figures:
    fontFamily: "Arial, sans-serif"
    fontWeight: 400

rounded:
  none: 0
  soft: "roundRect adj 10-20%"
  callout: "red-framed ellipse or rounded rectangle"

spacing:
  slide-size: "16:9 (12192000 x 6858000 EMU)"
  margin: "0.5in minimum, left and right"
  title-zone: "~1.2in top band, title only"
  content-gap: "0.3-0.5in between blocks"
  footer-zone: "~0.5in bottom (left: source / right: page number)"

components:
  title-slide:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.title-slide-main}"
  agenda-slide:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-md}"
  agenda-slide-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.body-md}"
  content-slide:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.slide-title}"
  diagram-box:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.diagram-label}"
    rounded: "{rounded.soft}"
  diagram-box-outline:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.diagram-label}"
    border: "1-2pt {colors.ink} or {colors.primary}"
    rounded: "{rounded.soft}"
  emphasis-arrow:
    shape: straightConnector1
    color: "{colors.emphasis}"
    width: 6pt
  normal-arrow:
    shape: straightConnector1
    color: "{colors.ink}"
    width: 1-2pt
  impact-shape:
    shape: irregularSeal1
    textColor: "{colors.ink}"
  emphasis-text:
    textColor: "{colors.emphasis}"
    fontWeight: 700
  conclusion-text:
    textColor: "{colors.emphasis-strong}"
    fontWeight: 700
  chart-callout:
    shape: "ellipse or rounded rectangle"
    border: "3-6pt {colors.emphasis}, no fill"
  citation-footnote:
    textColor: "{colors.ink}"
    typography: "{typography.caption-citation}"
  slide-number:
    textColor: "{colors.muted}"
    typography: "{typography.slide-number}"
---

## Overview

These slides are the most restrained, most legible surface in the research-presentation category. The base atmosphere is a **pure-white canvas** (`{colors.canvas}` — #ffffff) — deliberately not the tinted or templated backgrounds that most academic decks reach for. Titles run **bold Meiryo** at 40pt, sized to carry to the back of a lecture hall, never a delicate serif. The whole system is built around one demand: the audience reads the slide's claim in three seconds.

Brand voltage comes from the **blue + red split** — blue (`{colors.primary}` — #156082) is the signature structural color, used on every diagram box, the active agenda band, and the base tone of charts; red (`{colors.emphasis}` — #ff0000) is scarce and reserved for the argument. The blue is a calm, low-saturation steel-blue, never a bright cyan — the color of systems and networks. The red is the only color allowed to shout, and it earns that by appearing almost nowhere else.

The system has three roles that never blur into one another:
1. **White + black** (`{colors.canvas}` / `{colors.ink}`) — canvas and body, the information floor
2. **Blue** (`{colors.primary}`) — structure: diagram nodes, agenda highlight, chart base
3. **Red** (`{colors.emphasis}` / `{colors.emphasis-strong}`) — argument: conclusions, keywords, attack-flow arrows, chart callouts

The blue is where the deck shows its structure — the diagrams, the pipelines, the tables. The red is where it makes its point. The white-vs-blue-vs-red separation is the deck's whole grammar; add a fourth color and the grammar breaks.

**Key Characteristics:**
- Pure-white canvas (`{colors.canvas}` — #ffffff) with pure-black text (`{colors.ink}` — #000000). No background tint, no texture, no template chrome. The restraint is the point.
- Blue structural color (`{colors.primary}` — #156082). Used generously on diagram fills and the agenda band, never as a text color.
- Scarce red emphasis (`{colors.emphasis}` — #ff0000). Deployed in exactly three places — keyword text, flow arrows, chart callouts — and nowhere else. The scarcity is what gives each red its voltage.
- Bold Meiryo titles at 40pt, black, left-aligned — the title position is fixed on every slide. Body sits at 24pt (28pt for lead lines); 20pt is the floor.
- Diagram-first. Every slide carries a figure, chart, or table — never a plain title-plus-bullets. Attack-flow figures pair blue-fill nodes (`{colors.primary}`) against white-outline nodes to build a reading order.
- Arrows carry meaning by weight: a thin black line (`{colors.ink}`) is a normal flow; a 6pt red line (`{colors.emphasis}`) is the flow to watch.
- The agenda re-shows at every section, one item lit as a blue band (`{colors.primary}`) with white text — a running "you are here."
- Citations are non-negotiable: superscript [n] inline, full source at the slide foot. Academic honesty made visible.
- A page number sits bottom-right on every slide but the cover — the deck expects to be interrogated by slide number in Q&A.

## Colors

### Structure & Argument
- **Blue / Primary** (`{colors.primary}` — #156082): The signature structural color. Fills diagram boxes, the active agenda band, and the bars of self-made charts. Office theme accent1. A low-saturation steel-blue — deliberately not a bright cyan. It is an **area color**, used on fills and almost never on text. The most-recognized color in the deck outside of the red.
- **Blue Dark** (`{colors.primary-dark}` — #0e2841): The gradient-base / darker-border variant. Rarely appears on its own.
- **Red / Emphasis** (`{colors.emphasis}` — #ff0000): The argument color, and the most frequent one in the whole system. Confined to three uses: red-bold keywords in text, 6pt attack-flow arrows, and no-fill frames circling a region of interest on a chart. Nowhere else.
- **Red Strong** (`{colors.emphasis-strong}` — #c00000): The heavier variant for the single most important line on a summary slide — one weight past #ff0000.
- **Link Blue** (`{colors.link-blue}` — #0070c0): An exceptional blue-toned text emphasis (URLs, the odd blue word). Do not let it drift into structural use.

### Surface & Text
- **Canvas** (`{colors.canvas}` — #ffffff): The default slide floor. Pure white — no tint, ever.
- **Ink** (`{colors.ink}` — #000000): All titles and body. Pure black.
- **Muted** (`{colors.muted}` — #818181): Inactive agenda items, supplementary captions, the page number.
- **On Primary** (`{colors.on-primary}` — #ffffff): White text on blue boxes and the blue agenda band.

### Supplementary Accents
Used only when a single diagram needs to separate distinct tracks — reach for these before you reach for a fourth idea.
- **Accent Orange** (`{colors.accent-orange}` — #e97132): A second diagram track (e.g. a different protocol's path). Office accent2.
- **Accent Green** (`{colors.accent-green}` — #196b24): Normal / allowed states only. Office accent3.
- **Accent Sky** (`{colors.accent-sky}` — #0f9ed5): An added chart series only. Office accent4.

As a rule, one slide carries **three color families at most: black + blue + red**. When a fourth becomes necessary, split the figure rather than the palette.

## Typography

### Font Family
The system runs **Meiryo** for everything Japanese — titles, body, and in-figure labels alike — chosen because its bold weight stays crisp and legible from the back of a hall. **Arial / Calibri** handles Latin script: protocol names (DNS, QUIC), IP addresses, and formulas inside figures are unified in Arial. **Wingdings** supplies the bullet glyphs via theme defaults.

The register is deliberately plain:
- Meiryo bold (40pt) → slide titles and the cover title
- Meiryo regular / bold (20-28pt) → body, leads, and diagram labels
- Arial → all alphanumerics inside figures

### Hierarchy

| Token | Size | Weight | Use |
|---|---|---|---|
| `{typography.title-slide-main}` | 32-40pt | 700 | Cover research title (2-3 lines, centered) — Meiryo |
| `{typography.slide-title}` | 40pt | 700 | Each slide's title (black, left) — Meiryo |
| `{typography.body-lead}` | 28pt | 400-700 | Main message / first-level bullet |
| `{typography.body-md}` | 24pt | 400 | Standard body / second level — the most-used size |
| `{typography.body-sm}` | 20pt | 400 | Supplementary notes, in-figure text |
| `{typography.diagram-label}` | 16-24pt | 700 | Labels inside diagram nodes |
| `{typography.caption-citation}` | 14-16pt | 400 | Sources, references |
| `{typography.slide-number}` | 12-14pt | 400 | Page number |

### Principles
Body type holds a **20pt floor** — anything smaller is reserved for sources and the page number, because a lecture hall is unforgiving of fine print. Emphasis is **red plus bold**, and only that; the system never leans on underline, italic, or a size bump to make a word matter. Text volume per slide caps at a 1-2 line lead plus 3-5 bullets — past that, the slide splits. Alphanumerics stay half-width throughout; a stray full-width "DNS" reads as off-brand.

### Note on Font Substitutes
Meiryo assumes a Windows presentation machine. On macOS or LibreOffice it is silently substituted (typically with Hiragino), which shifts line spacing and can pull text out of its box — so a dry run on the actual presentation PC is not optional. If a substitute is unavoidable, **BIZ UDPGothic** or **Yu Gothic** hold the closest metrics; never fall back to a Mincho serif, which breaks the plain, high-contrast voice.

## Layout

### Spacing System
- **Slide size:** 16:9.
- **Margins:** 0.5in minimum on the left and right edges.
- **Title zone:** ~1.2in reserved at the top for the title alone, separated from the body by a thin divider line — fixed on every slide so the eye never hunts for it.
- **Content gaps:** 0.3-0.5in between blocks, held consistently.
- **Footer zone:** ~0.5in at the foot — source [n] on the left, page number on the right.

### Grid & Container
- **The base form:** "lead line up top → diagram below." The diagram is drawn large, spanning the content width.
- **Diagrams:** Blue-fill nodes and white-outline nodes laid out to carry a reading order left-to-right or top-to-bottom.
- **Tables:** Blue header row (`{colors.primary}` + white text), black-outline body cells, red only on the one figure that matters.

### Whitespace Philosophy
The white canvas plus large type plus a single dominant figure create a lecture-hall pacing — the slide reads as one clear claim, not a dense handout. When whitespace opens up, the answer is to **enlarge the figure, not to add text**. Not-over-packing is the discipline; a half-empty slide that lands in three seconds beats a full one that lands in thirty.

## Elevation & Depth

| Level | Treatment | Use |
|---|---|---|
| Flat | No fill, no border | Body text |
| Outline | 1-2pt black or blue border | White-fill diagram nodes, tables |
| Filled | `{colors.primary}` fill + white text | Primary diagram nodes (gradient allowed) |
| Callout | 3-6pt `{colors.emphasis}` border, no fill | The region of interest on a chart or table |

The elevation philosophy is **fill-first, shadow rare**. Depth comes from the presence or absence of a blue fill and the thickness of a border — not from drop shadows, which the system generally omits. The one exception is the red callout frame, which sits over a chart to earn its emphasis by contrast alone.

### Decorative Depth
- The **explosion shape** (`irregularSeal1`) marks damage or impact — "resource exhaustion" bursting off a targeted server. It is the one expressive shape the system permits.
- Diagram figures carry their own internal detail: flat clip-art of PCs, servers, and attackers; blue-fill process nodes; black and red arrows threading between them.
- No photography, no gradients-as-decoration, no template flourish. The figures do the work.

## Shapes

### Shape Vocabulary

| Shape | Value | Use |
|---|---|---|
| Rounded rectangle | `roundRect` (adj 10-20%) | The standard diagram node — blue fill + white text |
| Rectangle | `rect` | Tables, text boxes, white-fill nodes |
| Straight connector | `straightConnector1` | Flow arrows — thin black for normal, 6pt red for the flow to watch |
| Explosion | `irregularSeal1` | Damage / impact ("resource exhaustion") |
| Red-framed ellipse | ellipse / roundRect, no fill | Callouts over charts and screenshots |

### Figures & Illustrations
The deck rarely uses photography. Instead it uses:
- Flat clip-art (PNG/SVG) for the cast of a figure — PC, server, attacker.
- Self-made charts on a blue base, with only the data point of interest filled red or ringed by a red frame.
- Screenshots of external data (Cloudflare reports and the like), always carrying an explicit source line.
- Attack-flow and analysis-pipeline diagrams — the dominant "hero" treatment on a content slide.

When a figure is quoted from a paper or report, the source travels with it. No borrowed figure appears bare.

## Components

### Cover

**`title-slide`** — White canvas. The research title sits centered, bold 32-40pt, broken across 2-3 lines. Below it, the presenters: ◎ marks the speaker, followed by name and contact, then co-authors, with affiliations matched by `*` / `**`. The date, conference name, and session number close the slide at the foot. No page number here.

### Agenda

**`agenda-slide`** + **`agenda-slide-active`** — An "Agenda" title over a six-item list (Background → Objective → Related Work → Methods → Results → Summary & Future Work). The slide **re-shows at the start of every section**, lighting only the current item as a `{colors.primary}` horizontal band with white text; inactive items stay black or `{colors.muted}`. It is the deck's running "you are here" — the audience always knows where in the whole they stand.

### Content

**`content-slide`** — Title (40pt black bold, left) → divider line → lead line (28pt) → diagram. Page number bottom-right. The base unit of the deck; one message, one figure.

### Diagram Nodes

**`diagram-box`** — The primary node. Blue fill (`{colors.primary}`, gradient allowed), white bold label, rounded corners. Carries the load-bearing elements of a figure — attacker, server, the step that matters.

**`diagram-box-outline`** — The supporting node. White fill, 1-2pt black or blue border, black label. Mixed against the blue-fill node inside one figure to build a visual priority order — the blue node is where the eye goes first.

### Arrows

**`emphasis-arrow`** — A 6pt straight red arrow (`{colors.emphasis}`). Reserved for attack paths and the data flow you want watched. **Three or more thick red arrows on one slide means the figure needs rethinking** — the red stops meaning "watch this" once it's everywhere.

**`normal-arrow`** — A thin 1-2pt black arrow (`{colors.ink}`) for ordinary flow. The quiet default against which the red arrow reads loud.

### Impact

**`impact-shape`** — The explosion shape (`irregularSeal1`) carrying a short label like "resource exhaustion." Marks the consequence of an attack — the one place the deck lets a shape be dramatic.

### Text Emphasis

**`emphasis-text`** — Figures and keywords set red-bold (`{colors.emphasis}`), 1-2 spots per slide at most. The inline voltage.

**`conclusion-text`** — The single most important line on a summary slide, set deep-red bold (`{colors.emphasis-strong}`). One weight past the inline red — used once, at the end.

### Chart Callout

**`chart-callout`** — A no-fill red frame (ellipse or rounded rectangle, 3-6pt) ringing the "look here" region of a chart, table, or screenshot. The chart itself is left untouched; the frame plus a spoken line does the guiding.

### Citation

**`citation-footnote`** — Superscript `[n]` inline, with `[n] Author, "Title," URL` set 14-16pt at the slide foot, left-aligned. Attached to every borrowed figure without exception.

### Page Number

**`slide-number`** — Bottom-right, `{colors.muted}`, 12-14pt. On every slide but the cover.

## Do's and Don'ts

### Do
- Anchor every slide on the white canvas. A tint or template reads as "any other academic deck"; the plain white is the discipline.
- Set every title in bold Meiryo at 40pt. Hold body at 20pt or larger — a lecture hall is unforgiving of fine print.
- Keep the roles clean: **blue = structure, red = argument**. Diagrams are always based on `{colors.primary}`.
- Reserve `{colors.emphasis}` (red) for keyword text, flow arrows, and chart callouts. Nowhere else.
- Put a figure, chart, or table on every slide. Show the real diagram, not a paragraph describing it.
- Re-show the agenda per section, lighting the current item — the audience should never lose their place.
- Attach [n] and a source to every borrowed figure. Put a page number on every slide but the cover.

### Don't
- Don't tint the background or lay a template on it. White is the brand.
- Don't spread red around. The more red there is, the less each red means — three thick red arrows on a slide is a signal to rethink the figure.
- Don't put four or more color families on one slide. Split the figure before you split the palette.
- Don't build a text-only slide. A title plus bullets with no figure is the thing this system exists to avoid.
- Don't emphasize with underline, italic, or a size bump. Emphasis is red-bold, and only that.
- Don't nest bullets three levels deep. Two is the floor of the figure and the ceiling of the list.
- Don't set Japanese in Mincho or a novelty face. Meiryo throughout — the plain, high-contrast voice is the point.
- Don't design around animation. The slide must still land when printed or exported to PDF.

## Iteration Guide

1. Build a new slide by duplicating an existing one of the same type (`content-slide`, `agenda-slide`) and swapping the contents — title position, fonts, and page number stay consistent for free.
2. Draft a figure skeleton-first: white-fill nodes and black arrows for the whole structure, then fill only the lead node blue and turn only the flow-to-watch red. Structure before emphasis, always.
3. Add the red last. When the slide is otherwise done, set red-bold the single point you most want made — and stop there.
4. When a slide feels thin, cut text and enlarge the figure. Never pad with prose.
5. Before adding a color, check whether black + blue + red (plus gray) already covers it. A fourth color is a last resort, and usually a sign the figure should split.
6. When in doubt about emphasis: a bigger figure before a louder color.

## Known Gaps

- Meiryo assumes a Windows presentation machine. macOS / LibreOffice substitutes it and shifts line spacing — verify on the actual PC before the talk. Substitutes and the no-Mincho rule are noted in the typography section.
- Chart styling (matplotlib / Excel formatting) is out of scope beyond the one principle: blue base, red on the point of interest only.
- Animation and reveal timing (sequential display of arrows and boxes, seen in the existing decks) is not formalized here.
- Illustration assets (PC / server / attacker clip-art) carry their own sources and licenses, managed per figure rather than as a system token.
- Exact coordinates for the title divider line and the agenda highlight band are not tokenized — duplicate the relevant slide from an existing deck and reuse them.
