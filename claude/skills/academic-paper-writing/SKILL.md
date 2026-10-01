---
name: academic-paper-writing
description: >-
  An executable workflow for writing academic papers and technical
  manuscripts in the network-security research context — IEICE
  transactions and technical reports (Japanese and English), IEEE/ACM/
  USENIX-style venue papers, theses (卒論/修論), and workshop papers.
  Governs contribution-first planning, the section-by-section craft of a
  security/measurement paper (abstract formula, intro pattern, threat
  model, evaluation, related-work positioning), LaTeX mechanics (venue
  class files, vector figures, booktabs tables, math notation, cleveref),
  Japanese academic prose conventions (だ・である体, 研究会原稿 structure,
  mixed-language references), BibTeX discipline, and submission /
  camera-ready checklists. Load this skill whenever the deliverable is a
  paper or manuscript — 「論文を書いて」「原稿」「研究会に出す」「卒論」
  「修論」「LaTeXで」, "write up these results", "draft the paper",
  camera-ready fixes, or revising a manuscript after review. General
  prose goes to professional-writing-workflow; slides go to
  academic-research-slides; this skill owns the paper.
---

# Academic Paper Writing

## Purpose

Papers are rejected for repairable reasons: contributions the reader cannot find, evaluations that answer questions the introduction never asked, related work that lists instead of positions, threat models implied rather than stated, and manuscripts whose LaTeX friction (broken references, bitmap figures, inconsistent notation) reads as carelessness about the science. This workflow front-loads the decisions that determine acceptance — claims, structure, evidence mapping — and then makes the mechanical layer boring and correct.

## Division of labor

`professional-writing-workflow` governs prose quality in general; load it for the revision passes. `research-committee` red-teams the content before submission. `literature-survey-pipeline` produces the related-work material. `data-analysis-methodology` must already have governed the results being written up — writing cannot repair analysis. This skill owns the paper-specific structure, conventions, and LaTeX layer.

---

## Phase 1 — Before writing a single section

1. **Write the contribution list first, as claims.** 2–4 numbered sentences of the form "we show / we design / we measure X, which was not previously Y." Everything in the paper exists to support these sentences; anything supporting none of them is a cut candidate. If the claims can't be written yet, the problem is the research, not the writing — stop and say so.
2. **Map claims to evidence.** For each contribution: which figure, table, theorem, or section proves it? A claim with no evidence cell is either overclaiming (weaken it) or missing work (do it). This map later becomes the evaluation section's structure.
3. **Fix the venue and its budget before outlining.** Page limit, reference style, single/double column, double-blind or not, artifact expectations. An 8-page NDSS-style paper and a 2-page IEICE 研究会 original are different documents, not scaled versions of one.
4. **Choose the paper's one sentence.** If the reader remembers a single sentence, which? Every section will be checked against it.

## Phase 2 — Structure and section craft

Standard skeleton for a security/measurement paper — deviate deliberately, not accidentally: Abstract, Introduction, Background/Related Work (position varies), Threat Model / Problem Setting, Design/Method, Implementation, Evaluation, Discussion & Limitations, Conclusion.

1. **Abstract (write last, from the formula):** context (1 sentence) → problem/gap (1) → what we did (1–2) → key quantitative result (1) → significance (1). No citations, no undefined acronyms, the headline number included — abstracts are read a hundred times more often than the paper.
2. **Introduction — the six-move pattern:** (i) the area matters; (ii) the specific problem; (iii) why existing approaches fall short (one honest paragraph, details deferred to related work); (iv) our idea and why it should work; (v) explicit contribution list — the Phase-1 claims, often bulleted; (vi) optionally, roadmap. The intro makes every claim the paper makes, in miniature; a reviewer should be able to review the intro and predict the paper.
3. **Threat model / setting — state it, always.** Attacker capabilities and goals, defender visibility, trust assumptions, what is out of scope. In measurement papers the analogue is the observation model (vantage, time window, sampling). The most common substantive reviewer complaint in this field is an implicit threat model.
4. **Method/design:** lead each section with *why* before *how* — the design decision, its alternatives, the reason for the choice. Notation introduced once, at first use, and never reused with a second meaning.
5. **Evaluation:** open with the questions ("EQ1: does X improve detection over Y? EQ2: at what cost?") mapped from the contribution list, then answer them in order. Report the setup completely (data, splits, baselines, hardware where relevant), include the experiments that failed or bound the approach — a limitations-aware evaluation is *more* credible, and reviewers know sanitized results when they see them.
6. **Related work — position, don't enumerate.** Organize by axis (per `literature-survey-pipeline` Phase 6.5), end each group with the difference sentence ("unlike…, we…"). Describe the strongest competitor accurately; the reviewer may be its author.
7. **Discussion & limitations:** say what the results do not show, where the approach breaks, and what generalization requires. Preempting the reviewer's objection in the paper's own voice converts a rejection reason into evidence of judgment.

## Phase 3 — LaTeX mechanics

1. **Use the venue's class file untouched.** No margin/font/spacing hacks — chairs check. Get the current class (IEEEtran, acmart, usenix, IEICE's cls) from the venue, not from an old project.
2. **Figures are vector (PDF), generated by committed scripts,** fonts embedded, sized so the smallest label ≥ roughly footnote size *at print size*. One message per figure; caption states the takeaway ("X grows linearly with Y"), not just contents ("X vs. Y") — many readers read only figures and captions.
3. **Tables with `booktabs`** (`\toprule`/`\midrule`/`\bottomrule`, no vertical rules), right-aligned numbers with consistent decimals; bold the best value only if the metric's direction is stated.
4. **References that never break:** label conventions (`sec:`, `fig:`, `tab:`, `eq:`) + `cleveref` (`\cref`); every citation via BibTeX, keys from DBLP (per `literature-survey-pipeline` Phase 7); compile to zero warnings about undefined/multiply-defined references before any human reads a draft.
5. **Notation table for math-heavy papers,** and `\newcommand` for every recurring symbol so notation changes are one-line edits.
6. **Reproducible builds:** `latexmk`, committed `.bib`, figures regenerable — the camera-ready deadline is not the time to discover the plot script is gone.

## Phase 4 — Japanese manuscripts (和文)

1. **Register:** technical prose is だ・である体, uniformly — mixed です・ます sentences are the most common style rejection in student drafts. Prefer short sentences; a 3-line Japanese sentence hides its own subject.
2. **IEICE 研究会/全国大会 originals** have fixed compact structure: あらまし (和文, ~100–200字) + Abstract, キーワード both languages, tight page budget (often 2–8 pages). The six-move intro compresses to 3 moves: 背景・課題・本稿の貢献.
3. **Mixed-language references:** cite Japanese literature in Japanese, English in English, in one consistent reference format (the IEICE style files handle both); never translate titles.
4. **Terminology discipline:** pick one Japanese term per concept (検知/検出, 攻撃者/攻撃元…), keep a terms table for the project, give the English in parentheses at first use for non-established terms.
5. **卒論/修論:** the department template rules; chapters follow the same claim→evidence discipline, with the addition that background chapters teach (the examiner checks understanding, not just novelty).

## Phase 5 — Revision and submission

1. **Revise in ordered passes, not one giant pass:** (i) structure — does each section earn its space against the contribution list; (ii) paragraph — one point per paragraph, first sentence carries it; (iii) sentence — load `professional-writing-workflow`; (iv) numbers — every number in prose re-checked against its table/figure/script; (v) mechanics — references, citations, spelling of proper nouns.
2. **Run the hostile pass** with `research-committee` or `review-methodology` before submission, on the PDF, not the source — reviewers see the PDF.
3. **Double-blind hygiene where required:** no author-revealing self-citations phrased as "our prior work", no acknowledgments, no institution-identifying dataset descriptions, metadata scrubbed from the PDF and figures.
4. **Submission checklist:** page limit including/excluding references (venues differ), abstract length limit, mandatory sections (ethics statement — increasingly required at security venues; artifact appendix), correct anonymization state, compilable source if required.
5. **Camera-ready:** apply the meta-data exactly (title case per venue, author order confirmed), copyright block, final reference sweep for "to appear" entries that have since appeared, and one full read of the PDF — the camera-ready is the version that exists forever.

## Rebuttals and revisions (when reviews arrive)

Extract every distinct reviewer point into a table (point / valid? / action / where addressed). Answer the strongest objection first and honestly — a rebuttal that dodges the central criticism loses the champion reviewer. Distinguish misunderstanding (fix the paper's clarity — the misreading is evidence) from disagreement (argue with evidence, courteously) from correct criticism (concede and state the fix). Never claim a change that isn't in the revision.

## Failure modes to check before delivering

- Can a reader find the contribution list within one minute? Does every section trace to it?
- Threat model / observation model explicit?
- Evaluation questions asked before answered, and matched to the intro's claims?
- Any number in prose that disagrees with its own table or figure?
- Captions carry takeaways? Smallest figure text legible at print size?
- Zero LaTeX reference warnings; every citation compiled from the .bib?
- For 和文: register uniform, terminology table respected?
