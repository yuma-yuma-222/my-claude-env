---
name: literature-survey-pipeline
description: >-
  An executable pipeline for conducting systematic literature surveys of
  academic papers in networking and security — designing search queries,
  choosing venues (IEEE S&P, CCS, USENIX Security, NDSS, SIGCOMM, IMC,
  IEICE, arXiv, J-STAGE), screening with explicit inclusion criteria,
  backward/forward snowballing, structured per-paper reading notes,
  building comparison matrices and taxonomies, identifying research gaps,
  and maintaining clean BibTeX. Load this skill whenever the task is to
  survey academic literature or position work against it — 「サーベイして」
  「関連研究を調べて」「先行研究をまとめて」, "find papers on X", "write
  the related work section", "what's the state of the art in darknet /
  DDoS-detection research" — even for a quick scan of just a few papers.
  General source-based research goes to expert-research-methodology; this
  skill owns the case where the sources are peer-reviewed papers and the
  output is a survey, comparison, or related-work section.
---

# Literature Survey Pipeline

## Purpose

Literature surveys fail in characteristic ways: searching one database and mistaking it for the field, collecting papers without extracting anything comparable from them, summarizing paper-by-paper instead of synthesizing claim-by-claim, citing abstracts that the full text contradicts, and producing a related-work section that lists neighbors without positioning the author's own work. This pipeline converts each failure into an explicit step with an exit condition. The output standard: a reader can see what was searched, what was excluded and why, what each included paper actually did, and where the gap is — without redoing the search.

## Division of labor

`expert-research-methodology` governs the epistemics of any investigation (source reliability, fact/assumption separation, uncertainty). Load it alongside this skill for large surveys. This skill owns the paper-specific mechanics: where to search, how to screen, what to extract, how to synthesize academic literature. If the deliverable is a full paper containing the survey, `academic-paper-writing` owns the prose; this skill feeds it the material.

---

## Phase 1 — Scope the survey

1. **Write the survey question as a sentence with boundaries.** "Survey DDoS detection" is unworkable; "what methods have been proposed since 2018 for detecting DDoS activity from darknet traffic, and what datasets and metrics do they use?" is executable. The boundaries (time window, subfield, method class) are the inclusion criteria in draft form.
2. **Declare inclusion/exclusion criteria before searching.** Typical axes: publication window, venue tier, must-address topic, must-report evaluation. Criteria written after seeing the papers get bent to fit the papers already found.
3. **Match depth to purpose.** A related-work section needs 15–40 well-chosen papers and positioning; a survey paper needs completeness within stated bounds; a "get me oriented" scan needs 5–10 papers and a map. State which mode you are in — the stopping rule differs.
4. **Know the venue landscape.** For this lab's fields, the core venues are: security — IEEE S&P (Oakland), ACM CCS, USENIX Security, NDSS, RAID, ACSAC, DIMVA, TDSC, TIFS; measurement/networking — IMC, PAM, TMA, SIGCOMM, NSDI, CoNEXT, ToN, Computer Networks; Japan — IEICE Transactions (Commun. / Inf. & Syst.), IEICE technical reports (ICSS, IA), IPSJ journals and SIGs, J-STAGE. arXiv carries preprints of most of the above plus unrefereed work — treat it as a discovery channel, not a quality signal.

**Exit condition:** question, criteria, mode, and venue list written down.

## Phase 2 — Search

1. **Build queries from concept blocks.** Decompose the question into 2–4 concepts and list synonyms per concept (darknet: "network telescope", "darkspace", "unused address space"; DDoS: "denial of service", "amplification attack", "backscatter"). Queries are cross-products of blocks; log every query and where it was run.
2. **Use at least two independent discovery channels.** Good combinations: Google Scholar + DBLP (venue browsing) + Semantic Scholar API; add IEEE Xplore / ACM DL for completeness modes, J-STAGE and IEICE search for Japanese literature. One engine's ranking is not the field.
3. **Seed with known-good papers.** If the user or prior work names 2–3 canonical papers, start from them: their references, their citers, their authors' pages. Seeds are usually higher-precision than any query.
4. **Log the harvest.** Keep a running candidates list: title, venue, year, source-of-discovery. Duplicates across channels are a *good* sign (saturation signal); dedupe by DOI/title.

## Phase 3 — Screen

1. **Two-pass screening.** Pass 1 on title+abstract against the written criteria — decisions are include / exclude / unsure, with a one-clause reason for every exclusion. Pass 2 reads the full text of includes and unsures; abstracts routinely overstate scope and hide limitations.
2. **Never cite from the abstract alone.** Any paper that will be named in the output must have had at least its intro, method summary, and evaluation setup actually read. Abstract-only citation is how survey errors propagate through generations of papers.
3. **Keep the exclusion log.** "N found, M screened out (reasons), K included" is one sentence in the output that transforms it from "some papers I found" into an auditable survey.

## Phase 4 — Snowball

1. **Backward:** scan reference lists of included papers for titles matching the criteria — especially of the 2–3 most central papers and any survey/SoK found.
2. **Forward:** use Semantic Scholar or Google Scholar "cited by" on the same central papers, filtered by the time window. Forward snowballing is the only reliable way to find work newer than the seeds.
3. **Stop at saturation.** When a snowball round yields no new papers meeting the criteria, stop. Record the number of rounds. For orientation mode, one round suffices; for survey papers, iterate until dry.

## Phase 5 — Read and extract

1. **Extract into a fixed note structure, one note per paper.** Comparability across papers only exists if the same fields are filled for each:

   ```
   ## [BibTeX key] Authors, "Title", Venue Year
   - Problem: what gap the paper claims to fill
   - Threat model / setting: assumptions about attacker, data, deployment
   - Method: the actual mechanism, 2-4 lines, no marketing language
   - Data: dataset(s), size, time span, public or private
   - Evaluation: metrics, baselines compared, headline numbers
   - Limitations: stated by authors + observed by me (label which)
   - Relation to my work: builds-on / competes / orthogonal / uses-same-data
   ```

2. **Translate claims into the survey's own vocabulary.** Papers name the same thing differently; the note's Method field uses the survey's taxonomy terms, with the paper's own term in parentheses. This is where synthesis actually begins.
3. **Record numbers with their conditions.** "99% detection rate" is meaningless without dataset, attack mix, and false-positive rate alongside. Extract the conditions or don't extract the number.
4. **Flag, don't trust, self-reported comparisons.** A paper's table beating all baselines was made by the paper's authors. Note it as REPORTED, and prefer numbers reproduced by third parties or shared benchmarks when weighing methods.

## Phase 6 — Synthesize

1. **Build the comparison matrix first.** Rows = papers, columns = the axes the survey question cares about (method class, data source, granularity, online/offline, evaluation dataset, key metric). The matrix is built from the notes mechanically; gaps in the matrix are gaps in the reading, so fill or mark them.
2. **Derive the taxonomy from the matrix, not from the first survey found.** Group columns/values that separate the papers into clusters. A good taxonomy makes the gap visible: a cell or region that is empty or thin *and matters for the survey question*.
3. **Write claim-by-claim, not paper-by-paper.** Each synthesis paragraph makes one claim about the field ("flow-level methods dominate because packet payloads are unavailable in darknet data") and cites the papers as evidence. A sequence of paper summaries is notes, not a survey.
4. **State the gap with its evidence.** The gap statement names the empty region, the closest existing works, and why they do not cover it. This is the sentence the user's own research hangs from — it earns the most scrutiny.
5. **For related-work sections:** organize by the 2–4 axes closest to the paper's contribution, end each group by positioning ("unlike these, we…"), and keep the section honest — the strongest competitor gets described accurately, not minimized.

## Phase 7 — Citation hygiene

1. **Pull BibTeX from DBLP** for anything DBLP indexes (it is the cleanest source for CS venues); publisher pages for the rest; never hand-type or trust auto-generated entries from PDF metadata.
2. **Verify each entry once:** author list complete, venue name in the paper's own format, year matches the version cited, DOI present. Cite the published version over the arXiv preprint when both exist, unless the preprint is materially different and that difference matters.
3. **Consistent key scheme** (e.g., `authorYYkeyword`) and one `.bib` file per project; duplicated entries with different keys cause silent citation bugs.

---

## Output formats

- **Orientation scan:** venue-annotated list of 5–10 papers, 2-line summaries, one paragraph "shape of the field", explicit note of what was NOT searched.
- **Survey note:** Phases 1–7 in full — criteria, search log summary, matrix, taxonomy, gap statement, per-paper notes as appendix.
- **Related-work section:** synthesized prose per Phase 6.5, matrix included as a table when the venue's page budget allows.

## Failure modes to check before delivering

- Every named paper actually read beyond the abstract? (Phase 3.2)
- Any REPORTED number presented as established? (Phase 5.4)
- Synthesis organized by claims, or degenerated into per-paper summaries? (Phase 6.3)
- Gap statement still true after the snowball round — or did a found paper already fill it?
- Newest included paper: is it recent enough for the field's pace, or did the search window silently exclude this year?
