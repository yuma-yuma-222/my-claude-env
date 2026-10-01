---
name: data-analysis-methodology
description: >-
  An executable methodology for rigorous data analysis — auditing data
  quality before trusting it, exploratory analysis, forming hypotheses
  before testing them, choosing appropriate statistics, avoiding the
  classic traps (data leakage, p-hacking, multiple comparisons,
  Simpson's paradox, outlier-driven effects, correlation read as
  causation), sensitivity checks, honest visualization, and reporting
  conclusions with calibrated uncertainty. Load this skill whenever the
  task involves drawing conclusions from data — analyzing a CSV, log, or
  measurement dataset, evaluating experiment results, computing
  statistics, making charts to support a claim, 「データ分析して」
  「集計して」「相関を見て」「検定して」「実験結果をまとめて」 — even if
  the user only asks for a number or a chart. File mechanics belong to
  the xlsx skill; this skill governs whether the conclusion is true.
---

# Data Analysis Methodology

The gap between an amateur and an expert analyst is not statistical
knowledge — it is discipline about order and doubt. Amateurs compute
first and look at the data never; experts look first, compute later, and
attack their own result before reporting it. A wrong-but-confident
number is the worst output this skill exists to prevent: it looks
identical to a right one and gets acted on.

Works within `claude-fable`'s evidence discipline; this skill adds the
domain. For .xlsx/CSV file mechanics, combine with the xlsx skill.

## 1. Fixed order of work

Never reorder these; each exists because the next one lies without it.

1. **Question.** Write one sentence: what decision or claim will this
   analysis inform? An analysis without a question drifts into fishing.
2. **Audit** the data (Section 2). No statistic before the audit.
3. **Explore** (Section 3). Look at distributions before summarizing.
4. **State the hypothesis** — before running the confirmatory test.
5. **Test** with an appropriate method (Section 4).
6. **Attack the result** (Section 5). Sensitivity and robustness.
7. **Report** with uncertainty and stated limitations (Section 7).

Exploration is allowed to generate hypotheses; it is never allowed to
*confirm* them. A pattern found while exploring must be tested as if new
— ideally on data not used to find it (held-out split, later time
window). Confirming a pattern on the same data that suggested it is the
single most common way analyses go wrong.

## 2. Data audit (before any statistic)

Run and record, for every dataset:

1. Shape: row/column counts. Do they match expectations? A join that
   doubled rows poisons everything downstream.
2. Look at actual rows: head, tail, and 10 random rows. Eyes on raw
   data — the fastest anomaly detector available.
3. Per relevant column: type, missing count, distinct count, min/max.
   Check min/max against physical reality (negative durations, ports
   > 65535, timestamps in the future, ages of 999).
4. Duplicates: exact and by key. Decide and record how they arose.
5. Units and encodings: bytes vs packets, ms vs s, local vs UTC,
   0/1 vs labels. Unit confusion produces plausible-looking wrong
   numbers — the dangerous kind.
6. Missingness pattern: is it random, or concentrated in one group,
   sensor, or time range? Missingness that correlates with the variable
   of interest biases every downstream comparison.

Any data exclusion (outliers, bad rows, time ranges) must be recorded:
what was removed, how many rows, by what rule, and why. Silent dropping
is falsification, even when well-intentioned.

## 3. Exploratory analysis

- Plot the distribution of every variable that will appear in a
  conclusion — histogram or ECDF, not just mean ± sd. Means without
  distributions hide bimodality and heavy tails, both common in network
  and performance data.
- For claimed relationships, plot the raw scatter/time series before
  computing any correlation or fit. Anscombe's quartet is the standing
  warning: identical statistics, wildly different data.
- Check heavy-tailed variables (traffic volumes, latencies, counts) on
  a log scale; report medians and percentiles, since means are dominated
  by the tail.
- Segment by the obvious grouping variables (time, source, protocol,
  class). An aggregate trend that reverses within every subgroup
  (Simpson's paradox) is a real and frequent failure — check before
  reporting any aggregate comparison.

## 4. Hypothesis testing and estimation

1. Write the hypothesis and the analysis choice (test, model, metric)
   *before* looking at the answer. If choices were made after seeing
   results, say so in the report — that analysis is exploratory, not
   confirmatory.
2. Report effect size with a 95% interval, not a bare p-value.
   "p < 0.05" without magnitude answers no real question; a tiny effect
   can be significant at large n and meaningless in practice.
3. Check test assumptions against Section 3's plots (normality,
   independence, variance). With skewed data or group n < 30, prefer
   nonparametric tests or bootstrap intervals over t-tests.
4. Independence check: repeated measures from the same host, flow, or
   session are not independent samples. Treating them as such inflates
   n and manufactures significance — aggregate to the independent unit
   first.
5. Multiple comparisons: count every test you ran, including the ones
   that "didn't work." Past ~5 tests, control for it (Bonferroni or FDR)
   or present results as exploratory.
6. Baselines: a metric means nothing alone. Compare against the naive
   baseline (majority class, last value, random) before claiming a
   method works. For classification on imbalanced data, accuracy is
   forbidden as the headline number — use precision/recall, F1, or AUC,
   and state the class balance.
7. Leakage: any feature, scaling, or selection computed on data that
   includes the test portion invalidates evaluation. Split first,
   compute inside the training portion only. For time-ordered data,
   split by time — random splits let the future leak into the past.

## 5. Attack your own result (before reporting)

Tripwires — any hit means stop and investigate, not report:

- **Too clean.** A result that confirms the hypothesis perfectly on the
  first try earns *more* scrutiny, not less. Check for leakage, a join
  bug, or a duplicated column before celebrating.
- **Outlier-driven.** Rerun the analysis without the top and bottom 1%
  (or the single most extreme points). If the conclusion flips, the
  finding is about those points — report it that way.
- **Choice-sensitive.** Rerun with one or two alternative reasonable
  choices (different threshold, window, aggregation level). A
  conclusion that survives only one specific configuration is a fact
  about the configuration.
- **Magnitude sanity.** Estimate the answer's order of magnitude
  independently (back-of-envelope from known totals). A 40% effect in a
  system you know is stable is more likely a bug than a discovery.
- **Denominator shift.** When a rate or ratio moves, check whether the
  numerator or the denominator moved. Half of all "the metric improved"
  stories are denominator artifacts.
- **Causal language.** Observational data supports "is associated
  with," not "causes." Causal claims require design (randomization,
  natural experiment, explicit causal assumptions) — name the design or
  drop the claim.

## 6. Visualization rules

- The chart's job is the claim: one message per chart, stated in the
  title as a sentence when possible.
- Bar charts of means must show the underlying spread (points, box, or
  CI); a "dynamite plot" hides exactly what matters.
- Y-axis starts at zero for bar charts; if truncation is necessary for
  a line chart, mark it visibly.
- Log scales for heavy-tailed data, labeled as such.
- Never let a chart imply a comparison the statistics don't support.

## 7. Reporting

Structure findings as: claim → evidence (numbers, with n, effect size,
interval) → how it was checked (the Section 5 attacks run and their
outcome) → limitations (exclusions made, assumptions, what was NOT
tested). Calibrate language: verified → state plainly; exploratory →
"suggests, needs confirmation"; assumption-dependent → say which
assumption. Include enough method detail (splits, thresholds, exclusion
rules) that the analysis could be rerun by someone else.

## 8. Self-check before delivering

1. Was the audit run, and are all data exclusions recorded with rule
   and count?
2. Did I look at raw rows and distributions before summarizing?
3. Is every headline number accompanied by n, effect size, and an
   uncertainty interval — and compared against a baseline?
4. Were hypotheses and analysis choices fixed before seeing results, or
   is the analysis labeled exploratory?
5. Did the result survive the Section 5 attacks (outliers, alternative
   choices, magnitude sanity, denominator check)?
6. Is any causal wording backed by design, and any leakage path checked
   (splits, time ordering, feature computation)?
7. Do the charts show spread and start axes honestly?

Any "no" sends you back to the numbered section that owns it.
