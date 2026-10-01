---
name: expert-research-methodology
description: An executable methodology for conducting expert-level research on difficult scientific, technical, business, and strategic questions. Governs how to define research objectives, decompose complex questions, identify missing information, evaluate source reliability, separate fact from assumption, compare competing explanations, quantify uncertainty, synthesize findings, and verify conclusions before reporting. Load this skill for any nontrivial research task — literature reviews, market and competitive analysis, technical due diligence, strategic assessments, root-cause investigations, forecasting — and whenever a question cannot be answered well from a single source or from existing knowledge alone.
---

# Expert Research Methodology

## Purpose

Research fails in characteristic ways: answering a different question than the one asked, mistaking the first plausible narrative for the correct one, treating source count as evidence strength, laundering assumptions into conclusions, and reporting confident syntheses of material that was never verified. This procedure converts each failure mode into an explicit checkpoint. The output standard is a conclusion a hostile expert reviewer could audit: every claim traceable to a source or marked as inference, every uncertainty quantified, every rejected explanation named with the reason for rejection.

## When to use this skill

Apply when ANY of: the question spans multiple sources or disciplines; the answer will inform a decision with real cost; sources may conflict or be biased; the question involves forecasting, causation, or contested facts; or an initial search reveals disagreement. Do not apply the full procedure to simple lookups — a single authoritative source answering a factual question needs verification, not methodology.

---

## Phase 1 — Define the research objective

1. **Rewrite the question as a decision or claim.** Research questions hide their real objective. "Research the solid-state battery market" is unactionable; "should we expect commercially viable solid-state EV batteries before 2030, and who is best positioned?" is researchable. Ask: *what decision will this research inform, and what answer would change that decision?* If the user's framing doesn't reveal this, either infer it and state the inference, or ask one targeted question.
2. **Set the resolution standard.** Define what a sufficient answer looks like *before* searching: the claims that must be supported, the precision required (order of magnitude vs. exact figure), the time horizon, the geography/scope, and the confidence level the decision needs. A strategy decision may only need "more likely than not"; a safety claim needs much more.
3. **Declare the prior.** Write down what you currently believe and how strongly, before gathering evidence. This is the reference point that makes later updating honest — without it, evidence gets absorbed into whatever narrative forms first.
4. **Set a research budget.** Estimate the number of sources/searches proportionate to stakes. State it. Budgets prevent both premature stopping and infinite descent.

**Exit condition:** objective restated as a decision-relevant claim; resolution standard, prior, and budget written down.

## Phase 2 — Decompose the question

1. **Split into sub-questions that are independently answerable and evidence-typed.** Each sub-question should name what kind of evidence would answer it: a measurement, a market figure, an expert consensus, a regulatory text, a benchmark. Example decomposition of the battery question: (a) current energy density and cycle-life of announced solid-state cells vs. lithium-ion [measurements]; (b) manufacturing scalability and cost curves [industry data, plant announcements]; (c) OEM commitments and timelines [primary statements, contracts]; (d) historical base rate of battery-tech timelines slipping [historical record].
2. **Identify load-bearing sub-questions.** Mark which sub-answers the conclusion is most sensitive to. These get the deepest sourcing; peripheral color gets the least. Sensitivity, not curiosity, allocates the budget.
3. **Include at least one outside-view sub-question.** For forecasts and strategic claims, always include a base-rate question: how often have similar claims/technologies/entrants succeeded historically? Inside-view analysis systematically overweights the specifics of the current case.
4. **Order by informativeness:** answer first the sub-question most likely to change the overall conclusion or kill the inquiry.

## Phase 3 — Identify missing information

1. Maintain a **known/unknown ledger** with four columns: established facts (with source), working assumptions (unverified), known unknowns (identified gaps), and questions the evidence raised that weren't in the original decomposition.
2. After each research pass, update the ledger. The unknowns column is the search plan for the next pass.
3. **Distinguish three kinds of missing information**, because they demand different responses:
   - *Findable*: exists somewhere; keep searching with reformulated queries and different source types.
   - *Nonpublic*: exists but inaccessible (private financials, unpublished trial data). Note it, seek proxies (filings, job postings, patents, supplier statements), and mark conclusions that depend on the proxy.
   - *Nonexistent*: nobody knows (future outcomes, unmeasured quantities). Do not keep searching; switch to estimation with stated method and bounds.
4. **Absence-of-evidence check:** before treating "I found nothing" as informative, verify the search was adequate — reformulated queries, synonyms, the non-English or pre-digital literature where relevant, and the places this information would live if it existed. Only then may absence carry weight, and how much depends on how thoroughly the space was searched.

## Phase 4 — Evaluate source reliability

Assess every load-bearing source on these dimensions; record the assessment, not just the citation:

1. **Position in the evidence chain.** Primary (the measurement, filing, transcript, dataset, paper) beats secondary (reporting on it) beats tertiary (aggregation of reporting). Always try to walk citations upstream to the primary source; secondary sources routinely distort effect sizes, drop caveats, and misstate scope. If a claim appears in five outlets, check whether it is five sources or one press release echoed five times — **independence, not repetition, is what multiplies evidential weight.**
2. **Incentive analysis.** Ask what the source gains from you believing it: vendors overstate capability, executives talk their book, researchers favor their own results, short-sellers and competitors favor the negative. Incentive doesn't disqualify a source; it determines what the source is *good evidence for* (a company's own announcement is strong evidence of intent, weak evidence of feasibility).
3. **Track record and methodology.** Prefer sources with checkable prior accuracy and stated methods. For scientific claims: sample size, controls, replication status, and whether the field has known reproducibility problems. For business figures: how the number was constructed (survey? extrapolation? actuals?) — a precise-looking figure from an undisclosed method is a weak source wearing a strong costume.
4. **Recency vs. stability.** Match source age to the volatility of the fact. Market shares need this quarter; thermodynamic limits do not.
5. **Reliability is claim-relative.** Grade each source per claim, not globally. A rating like "strong for X, weak for Y" is the normal case.

## Phase 5 — Separate facts from assumptions

1. In all working notes and the final report, **tag every substantive statement** with its epistemic type: OBSERVED (sourced fact), INFERRED (derived from facts by stated reasoning), ASSUMED (taken without evidence), REPORTED (someone claims it; not independently verified).
2. **Assumptions are permitted; unlabeled assumptions are not.** Every ASSUMED item must appear in the ledger with a note on how the conclusion changes if it is false.
3. **Audit for laundering.** Before synthesis, re-scan notes for statements that entered as REPORTED or ASSUMED and are now being treated as OBSERVED. This drift is the single most common corruption in long research tasks — repetition converts hearsay into fact unless actively resisted.
4. **Quantify with provenance.** Every number in the output carries its source and construction method inline or in a footnote. A number without provenance is an assumption in disguise.

## Phase 6 — Compare competing explanations

1. **Generate rivals before evaluating anything.** For any causal, diagnostic, or strategic question, list the plausible explanations *first* — including the boring ones (measurement error, selection effects, coincidence, base-rate effects) that narrative-driven analysis skips. A conclusion reached without rivals is a first impression with citations.
2. **Test evidence for discrimination.** For each piece of evidence, ask which hypotheses it actually distinguishes. Evidence consistent with all rivals has near-zero weight no matter how vivid. Structure this as a simple matrix: hypotheses × evidence items, marking supports / undermines / neutral per cell.
3. **Hunt disconfirmation deliberately.** For the currently favored explanation, run at least one search specifically for the strongest counter-case: the critical review, the failed replication, the bear thesis, the dissenting expert. If you cannot state the best argument against your conclusion, you have not finished researching it.
4. **Apply parsimony last, not first.** Prefer the simpler explanation only after the evidence matrix, not as a substitute for it.
5. **Record the rejects.** The final report names the explanations considered and why each was rejected. This is what lets a reviewer audit the reasoning rather than re-do it.

## Phase 7 — Identify and quantify uncertainty

1. **Locate the uncertainty:** for each conclusion, state whether the residual uncertainty is in the data (measurement quality), the model (does the causal story hold?), the future (irreducible), or the scope (does this generalize?). Different locations demand different hedges — data uncertainty may be reducible with more research; future uncertainty is not.
2. **Use calibrated language mapped to numbers.** Adopt one scale and use it consistently, e.g.: very likely (>90%), likely (70–90%), more likely than not (55–70%), roughly even (45–55%), unlikely (10–30%), very unlikely (<10%). Never use "may," "could," or "possible" as load-bearing conclusions — they are compatible with any probability and therefore say nothing.
3. **Give ranges, not points, for estimates** — with the estimation method stated. A defensible range beats a falsely precise point.
4. **Flag correlated failure.** Where several conclusions rest on the same source, assumption, or method, say so: they will be wrong together, and the report should not present them as independent confirmations.

## Phase 8 — Synthesize

1. **Synthesis is weighing, not summarizing.** Do not proceed source-by-source ("A says… B says…"); proceed claim-by-claim, stating the best-supported answer to each sub-question, the evidence for it, the credible dissent, and the residual uncertainty.
2. **Resolve conflicts explicitly.** When sources disagree, adjudicate: is the disagreement about facts (someone is wrong — check primacy and method), definitions (reconcile scopes; "market size" figures usually differ by definition, not error), or vintage (the facts changed)? An unexplained "sources vary" is unfinished work.
3. **Reconnect to the Phase-1 objective.** The synthesis must answer the decision-relevant question as posed, at the resolution standard set. Check for drift: long research tasks reliably end up answering an adjacent, easier question.
4. **Compare against the prior.** State how and why the conclusion moved from the Phase-1 prior. If evidence didn't move it, confirm that reflects the evidence rather than anchoring.

## Phase 9 — Produce evidence-based conclusions with confidence estimation

Structure every major conclusion as:

```
CONCLUSION: [the claim, stated at the precision the evidence supports]
CONFIDENCE: [calibrated term + % band from the Phase-7 scale]
BASIS: [the 2–4 strongest evidence items, with sources]
KEY ASSUMPTIONS: [what was taken on faith; what breaks if each is wrong]
BEST COUNTER-CASE: [the strongest argument against, and why it doesn't prevail]
WOULD CHANGE MY MIND: [the specific observable evidence that would flip this]
```

Confidence estimation rules:
- Confidence tracks the *weakest necessary link*, not the average strength of the evidence. A conclusion resting on four strong facts and one shaky assumption inherits the assumption's fragility.
- Independent lines of evidence raise confidence multiplicatively; repeated echoes of one origin do not raise it at all.
- Outside-view base rates cap inside-view enthusiasm: if similar predictions have historically succeeded 20% of the time, a >70% confidence claim requires stating what makes this case exceptional.
- Never report higher confidence to the user than exists in the working notes. Polish the prose, not the probability.

## Phase 10 — Verification before final reporting

Run this checklist on the draft report before delivery:

- [ ] Every factual claim traced back to its source — against the source text itself, not memory of it (misremembered citations are the top error in synthesis)
- [ ] Every number checked for provenance, units, vintage, and transcription
- [ ] Epistemic tags audited: no ASSUMED or REPORTED item reads as established fact
- [ ] Each conclusion's counter-case genuinely searched for, not constructed as a strawman
- [ ] Quotes and paraphrases checked against originals for scope distortion (dropped qualifiers, "may" → "will")
- [ ] Internal consistency: numbers reconcile across sections; no conclusion contradicts another without comment
- [ ] The original question, re-read from the user's message, is what the report answers — at the resolution standard from Phase 1
- [ ] Confidence language in the report matches the working-notes assessment exactly

## Phase 11 — Recognize when more research is required

**Continue researching when any of:** a load-bearing sub-question rests on a single source or a single line of evidence; the evidence matrix has a live rival the current evidence cannot discriminate against; new sources are still changing conclusions (the update rate has not flattened); a checkable claim central to the conclusion remains unchecked; the confidence achieved is below what the Phase-1 decision requires.

**Stop researching when:** additional sources are repeating known material (saturation); remaining unknowns are nonexistent-type (further search cannot help; estimation and hedging are the correct tools); the confidence achieved meets the decision's requirement; or the budget is exhausted — in which case report *at the confidence actually achieved* and state precisely what additional research would buy and what it would cost.

**Never resolve "more research needed" by silently lowering the resolution standard.** If the standard can't be met, report that explicitly: what was established, at what confidence, and what stands between here and the standard.

---

## Worked micro-example

Question: "Is quantum computing a near-term threat to our RSA-based product security?"

- **Phase 1:** Decision restated: "do we need to begin post-quantum migration within 24 months?" Resolution standard: likely/unlikely at the 70% level suffices — migration is costly but not existential. Prior: unlikely to be *forced* within 24 months (~80%), based on general awareness of qubit-count gaps.
- **Phase 2:** Sub-questions: (a) qubits + error rates required to break RSA-2048 [published cryptanalysis]; (b) best current hardware and credible roadmaps [primary: lab papers, vendor roadmaps — noting vendor incentive]; (c) harvest-now-decrypt-later exposure for *our* data lifetimes [internal facts + threat reporting]; (d) regulatory/customer timelines (e.g., migration mandates) that bind regardless of physics [primary: standards bodies]. Sub-question (c) and (d) marked load-bearing — the answer can be "migrate soon" even if the physics threat is distant.
- **Phases 4–6:** Vendor roadmap claims tagged REPORTED, strong for intent, weak for feasibility; academic resource estimates walked to primary papers. Rival explanations for "urgent threat" headlines: genuine progress vs. funding-cycle hype vs. journalists compressing "logical qubits" into "qubits" — the evidence matrix shows most headlines don't discriminate.
- **Phases 7–9:** Conclusion: cryptanalytically-relevant quantum computers within 24 months: very unlikely (<10%); BUT migration pressure within 24 months: likely (70–90%), driven by sub-questions (c)/(d), not physics. Would change my mind: demonstrated error-corrected factoring of even small RSA-scale semiprimes, or a mandated compliance deadline inside the window.
- **Phase 11:** Physics side is saturated; the open load-bearing unknown is internal (data lifetime exposure) — flagged as requiring information only the user holds, not more external research.

Note the shape of the outcome: the decomposition surfaced that the decision hinges on a different sub-question than the headline question — which is the typical signature of the method working.
