---
name: hard-task-operating-procedure
description: An executable operating procedure for difficult tasks, written for a language model to follow directly. Governs how to decompose tasks, form and test hypotheses, verify outputs, detect and recover from mistakes, choose the next action, and determine completion. Load this skill whenever a task is multi-step, ambiguous, failure-prone, or requires more than a handful of tool calls — debugging, refactoring, data analysis, research synthesis, document generation, migrations. Also load it mid-task the moment you detect looping, repeated failures, or uncertainty about whether work is finished.
---

# Hard-Task Operating Procedure

## Purpose

This document is an operating manual, not reference reading. It specifies the concrete behaviors a language model must execute when working on difficult tasks: what to write down, what to check, in what order, and how to react to each outcome. Following it converts three chronic model failure modes into managed processes:

1. **Plan drift** — continuing to execute a plan whose premises have died.
2. **Confidence-as-verification** — presenting unchecked output because it *feels* correct. Fluent generation feels identical whether the content is right or wrong; the feeling carries zero information.
3. **Loop persistence** — retrying variations of a failed approach because retrying is easier than diagnosing.

Every instruction in this file describes observable behavior: text you emit, tool calls you make, artifacts you produce, conditions you test. If an instruction cannot be executed as a concrete action, treat it as a bug in this document.

---

## When to use this skill

Apply this procedure when ANY of the following holds:

- The task requires more than ~5 tool calls or produces a multi-part deliverable.
- The request is ambiguous, underspecified, or open-ended.
- The task involves debugging, data transformation, migration, or anything where partial failure is likely.
- Correctness matters more than speed (user will act on the output; errors are costly or hard to notice).
- You are already mid-task and notice: a second failure of the same kind, a surprising result, numbers that do not reconcile, or uncertainty about whether you are done.

Do NOT apply the full procedure to trivial tasks (single lookups, one-line edits, direct factual answers). Overhead must scale with stakes; applying heavyweight process to lightweight tasks degrades output. When in doubt, apply Phase 0 only — it is cheap and will tell you whether the rest is needed.

---

## Inputs required

Before starting, confirm you have (or explicitly note the absence of):

| Input | If missing |
|---|---|
| The user's actual request text, re-readable | Always re-read the original message before final delivery; never rely on your summary of it |
| Acceptance criteria (explicit or derivable) | Derive them in Phase 0 and state them; if underivable, ask ONE targeted question |
| Access to all referenced resources (files, URLs, systems) | Verify existence before planning around them; a referenced-but-absent file halts Phase 0 |
| A durable place to keep state (todo tool, scratch file, or restated plan) | Restate the plan in output text at each revision — the conversation itself becomes the durable record |
| Rollback capability for mutable state (git, file copies, saved intermediates) | Create restore points before risky steps; if impossible, flag to the user that changes are hard to undo |

---

## Workflow

Execute phases in order. Phases 2–5 form a loop that repeats per step. Phase transitions are triggered by the explicit conditions given, not by intuition.

### Phase 0 — Establish the target

1. Re-read the user's request. Extract every explicit requirement and every clearly implied one into a numbered list.
2. Write acceptance criteria: observable facts that will be true at completion ("tests exit 0", "report answers requirements 1–4", "output file opens without errors"). Each criterion must be checkable by an action, not a judgment.
3. If acceptance criteria cannot be written because the request is ambiguous: choose the most reasonable interpretation, state it explicitly in your output ("Assuming X; say the word if you meant Y"), and proceed — OR ask one targeted question if the interpretations diverge enough that half the work would be wasted. Never silently pick an interpretation.
4. Inspect every input resource before planning: open the file, list the directory, query the schema, fetch the page. Emit what you observed. Plans written before inspection are systematically wrong.

**Exit condition:** numbered requirements + acceptance criteria exist in writing; all inputs inspected.

### Phase 1 — Decompose

1. Split the task into steps where **each step ends in an observable, checkable result**. "Understand the codebase" is not a step; "list all call sites of `parse_config`, verified by grep output" is.
2. For each step, write its verification method inline: `step → verified by: <action>`.
3. Order steps so the riskiest assumptions are tested first: unknown APIs, data quality, "does this library support X". A plan-killing discovery at step 1 costs minutes; at step 8 it costs everything before it.
4. Size steps so that a failure localizes: no step should bundle multiple independent failure points.
5. Record the plan durably (todo tool if available; otherwise restate it as a numbered list in output).

**Exit condition:** every planned step has an inline verification method; riskiest step is scheduled first or second.

### Phase 2 — Hypothesize (before each nontrivial action)

1. State the working hypothesis in one sentence: "I believe X because of evidence Y."
2. Name at least one rival hypothesis. If no rival can be named, treat the hypothesis as an assumption and mark it for testing.
3. Choose the cheapest test whose outcomes discriminate between the hypotheses — a test where result A supports H1 and result B supports H2. Prefer tests that can falsify.
4. **Write the predicted outcome before executing the test.** This is mandatory. Predictions convert results into information: a surprising result proves a belief was wrong, and cannot be quietly rationalized if the prediction is on record.

**Exit condition:** hypothesis, rival, test, and prediction are all stated in output or working notes.

### Phase 3 — Execute

1. Perform one step. Small steps: prefer many run-and-check cycles over one large batch of changes.
2. Before any risky mutation (schema change, large edit, destructive command), create a restore point (commit, copy, saved intermediate) and note its location.
3. Never chain a second mutation onto an unverified first one.

### Phase 4 — Verify

Apply the highest available tier. Never substitute a lower tier when a higher one is available.

- **Tier 1 — Mechanical:** run the code, run the tests, open the generated file, re-execute the query, validate the format, render the document. Machine-checkable beats model-checkable, always.
- **Tier 2 — Independent re-derivation:** produce the same result via a path sharing no intermediates with the first (different tool, hand-checked sample, formula re-derived from scratch, direct count).
- **Tier 3 — Adversarial re-read:** re-read the output hunting for failure — edge cases, unsourced claims, dropped requirements, internally inconsistent numbers. Tier 3 shares the blind spots of the process that produced the work; when it is the only tier applied to something important, disclose that limitation to the user.

Verification always covers TWO independent questions:
- **Correctness:** is the work right?
- **Fidelity:** is it what was asked? Check by walking the Phase-0 requirements list against the actual output — not against your memory of either.

**Artifact rule:** verify the thing the user receives, after the final edit. Open the actual file. Run the actual code. The most recent edit is always the least-verified element in the task; never deliver immediately after an unchecked change.

**Exit condition:** the step's inline verification method (from Phase 1) executed and passed → proceed to Phase 5. Failed → Failure Recovery section.

### Phase 5 — Decide next action

After every verified step, execute this check before continuing:

1. Did the result change anything about the plan? If yes, update the plan explicitly (edit the todo/list, state the change) before proceeding. Silent divergence between plan and reality is prohibited.
2. Consult the decision heuristics below to pick the next action.
3. If all acceptance criteria are met → Final Completion Checklist. Otherwise → Phase 2 for the next step.

---

## Decision heuristics

### Next-action selection

```
Last step verified?
├─ NO → do not proceed; enter Failure Recovery
└─ YES → plan still valid given the new result?
    ├─ NO  → update plan explicitly; re-check step ordering
    └─ YES → all acceptance criteria met?
        ├─ YES → Final Completion Checklist
        └─ NO  → is the next planned step still highest-value?
            ├─ YES → Phase 2 on that step
            ├─ NO  → insert the higher-value step; record the plan change
            └─ BLOCKED on something only the user has
                   → deliver partial work + ONE specific question
```

### Verification-depth selection

```
Irreversible or side-effectful (send/delete/publish/purchase/overwrite)?
├─ YES → Tier 1–2 AND surface to the user before acting
└─ NO → later steps depend on this result?
    ├─ YES → Tier 1 or 2 NOW (errors here multiply downstream)
    └─ NO → user will act on it directly (medical/legal/financial/operational)?
        ├─ YES → Tier 1–2, plus a source for every claim
        └─ NO  → Tier 3 pass is sufficient
```

### When to ask the user vs. proceed

ASK when: interpretations diverge enough to waste half the work; a decision is genuinely theirs (taste, priorities, irreversible actions); an assumption you stated turned out wrong in a way that changes what they want; scope has grown far beyond the original request.

PROCEED (stating your assumption) when: the context already implies the answer; the choice is easily reversible; you would be asking for permission to do the obviously-intended thing. Batch questions; never ask more than one at a time; always deliver whatever partial work exists alongside the question.

### Effort calibration

Total process overhead must be proportional to (probability of error) × (cost of error). A one-off exploratory script warrants Phase 0 and Tier 1 only. A production migration warrants every phase at full depth. State your calibration when it is non-obvious.

---

## Verification checklist

Run before presenting any substantive intermediate or final output:

- [ ] Every load-bearing result verified at Tier 1 or 2 (not Tier 3)
- [ ] The actual deliverable opened / executed / rendered AFTER the last edit
- [ ] Phase-0 requirements list walked item-by-item against the actual output
- [ ] All numbers reconcile: totals match sources, counts consistent across steps, deltas explained
- [ ] Every factual claim traceable to an observation, a source, or an explicitly flagged assumption
- [ ] Edge inputs considered for code (empty, huge, malformed, unicode, boundary values)
- [ ] Anything unverifiable is flagged as such in the delivery text, not silently omitted

---

## Failure recovery

### Loop-detection trigger (mandatory)

Count failures by *class*, not by exact repetition. **On the second failure of the same class, a third similar attempt is prohibited.** Execute the recovery procedure instead. Rewording, reordering, or lightly modifying a failed approach is the same class.

### Recovery procedure

1. **Freeze.** No further mutations until steps 2–4 are complete.
2. **Split knowledge from assumption.** Write two lists: (a) facts actually observed, with the observation that established each; (b) beliefs assumed but never tested. The cause is almost always in list (b), usually the item that seemed too obvious to check ("the file I'm editing is the file being executed", "the data loaded at all", "I'm in the environment I think I'm in").
3. **Test the most obvious untested assumption first.** Cheapest test, executed immediately.
4. **Widen the frame:** Is the failure upstream of where you are looking? Is the approach wrong rather than the implementation? Would a simpler version of the goal bypass the problem?
5. **Select a recovery mode:**

```
Cause now understood?
├─ YES → plan still valid? → fix, re-verify, continue
│        plan invalid?     → return to Phase 1 from current reality
└─ NO →
    ├─ untested assumption remains        → test it (back to step 3)
    ├─ alternative method exists          → pivot; record a one-line epitaph
    │                                        for the dead approach
    ├─ approach fundamentally doubtful    → roll back to last verified-good
    │                                        state; re-decompose
    └─ blocked on user-held info/decision → escalate: what you tried,
                                             what you observed, what you need
```

6. **Contamination check.** When a mistake is found, before fixing it, list everything built on top of it. Fix upstream, then re-verify all downstream dependents. Patching the symptom at the point of discovery is prohibited when the cause is earlier.
7. **Record the epitaph.** One or two lines on why each abandoned approach failed. Prevents re-walking dead ends; include in the final handoff.
8. **Ignore sunk cost.** Time already spent on an approach is never a reason to continue it. State this out loud if you notice reluctance to abandon.

---

## Common mistakes

Each entry: the mistake → the observable symptom → the countermeasure.

1. **Planning before inspecting.** Symptom: plan references columns/functions/endpoints that turn out not to exist. Countermeasure: Phase 0 step 4 is unconditional.
2. **Treating "returned something" as "succeeded".** Symptom: empty results, truncated output, or wrong-shaped data flowing into later steps. Countermeasure: every verification method names the *expected shape* of success, not just non-error.
3. **Confidence-as-verification.** Symptom: delivery text contains certainty ("this works", "all cases handled") with no named check behind it. Countermeasure: every confident claim in delivery text must be traceable to a Tier 1/2 check; otherwise soften it and flag.
4. **The unverified final edit.** Symptom: "one small fix" applied after testing, then shipped. Countermeasure: any edit resets the verified state of the artifact; re-run the relevant check.
5. **Fixing without understanding.** Symptom: an error disappears after a change and you cannot say why. Countermeasure: treat as an open failure — the bug has moved, not died; diagnose before building further.
6. **Rationalizing anomalies.** Symptom: phrases like "probably just rounding", "likely a fluke" attached to unexplained discrepancies. Countermeasure: any unexplained inconsistency in numbers is a hard stop until explained or explicitly escalated.
7. **Requirement decay.** Symptom: a constraint from the original message is absent from the final output. Countermeasure: fidelity walk in the verification checklist — against the original message text, not memory.
8. **Third attempt of the same class.** Symptom: minor variations of a failed fix. Countermeasure: loop-detection trigger is mandatory, not advisory.
9. **Contaminated downstream results.** Symptom: fixing step 3 while keeping step 5's outputs computed from the broken step 3. Countermeasure: contamination check in recovery step 6.
10. **Over-polish past done.** Symptom: continued edits that serve no acceptance criterion. Countermeasure: each post-criteria edit must name the criterion it serves; if it cannot, stop.
11. **Question flooding.** Symptom: multiple clarifying questions before any work. Countermeasure: one targeted question maximum, always accompanied by whatever work can proceed under a stated assumption.
12. **Avoided checks.** Symptom: noticing a check you could run but keep deferring. Countermeasure: reluctance marks the likely error location; run that check first.

---

## Quality standards

Deliverables produced under this procedure meet ALL of the following:

- **Evidence-backed:** every claim of success names its check ("tests pass: 42/42", "totals reconcile to within documented drops").
- **Fidelity-complete:** every requirement from the original request is addressed in the output or explicitly listed as out of scope / blocked, with reason.
- **Honestly bounded:** unverified aspects, assumptions taken, and known limitations appear in the delivery text. Absence of caveats implies full verification — make that implication true.
- **Reproducible:** another agent could re-derive the result from what is written (steps taken, decisions made, sources used), without access to your internal state.
- **Clean:** no scaffolding remains — debug output, scratch files, commented-out experiments, abandoned code paths.
- **Proportionate:** process visible in the output scales with stakes; trivial tasks are answered directly, not wrapped in ceremony.

---

## Examples

### Example 1 — Debugging with hypothesis discipline

Task: "API requests intermittently time out in production."

- Phase 0: acceptance criterion = "the captured failing request class completes reliably; cause identified and stated."
- Phase 1: (1) capture a reliable trigger → verified by a reproduced failing request; (2) localize the layer; (3) fix; (4) re-run the original trigger.
- Phase 2: H1 = connection-pool exhaustion; rival H2 = slow downstream service. Discriminating test: pool metrics during a timeout. **Prediction: pool exhausted.**
- Result: pool healthy. Prediction failed → H1 dead on record, no rationalizing. H2 test: downstream latency normal → H2 dead.
- Two dead hypotheses = same-class failure count at 2 → recovery procedure triggers instead of a reflexive H3. Assumptions list surfaces one never-tested item: "the timeout fires where I think it does." Test: it is the *client-side* 2s timeout tripping on a legitimately slow 2.5s endpoint.
- The mechanism to reproduce: the on-record failed predictions forced the assumptions audit that a third guess would have skipped.

### Example 2 — Data pipeline with reconciliation

Task: "Clean this sales CSV and give me revenue by region."

- Phase 0 inspection: view head/tail, dtypes, row count before any plan.
- Phase 1: cleaning step verified by before/after row counts plus a sample of dropped rows; aggregation step verified by reconciliation — grand total vs. raw column sum, difference fully explained by documented drops.
- Execution: aggregate total lands 12% under the raw sum; cleaning dropped only 2% of rows. Reconciliation fails → hard stop (common mistake #6 countermeasure). Not re-run in hope; the 10% gap is treated as information.
- Tier 2 re-derivation (sum in a second tool) reproduces the gap → loss is in cleaning, not aggregation. Dropped-value inspection: European-format numbers ("1.234,56") coerced to NaN.
- Fix applied at the cleaning step; contamination check forces the aggregation to be re-run and re-reconciled from scratch, not patched.
- Delivery states the reconciliation: "Total X; differs from raw sum by Y, fully accounted for by Z documented invalid rows (list attached)."

### Example 3 — Long-form document with fidelity walk

Task: "15-page market analysis covering competitors, pricing, regulation, and a go/no-go recommendation."

- Phase 0: four named components become requirements 1–4; requirement 5 (implied) = the recommendation must be supported by the other three.
- Phase 1: outline maps every section to a requirement; verified before drafting that no requirement lacks a section.
- Verification fidelity walk against the original message finds: "regulation" was drafted as background, but the request's framing implies regulatory *risk to the recommendation*. Content is correct but not what was asked — the fidelity failure mode, invisible to correctness checks. Section revised to link regulation to the go/no-go.
- Completion: a tempting fifth addition ("add a SWOT?") is tested against acceptance criteria, serves none → omitted; the omission and its reason recorded in the handoff.

---

## Final completion checklist

Run in full before declaring any task done. "Out of ideas for improvement" is not completion; this checklist passing is.

- [ ] Every Phase-0 acceptance criterion met, with the specific evidence named next to each
- [ ] Original request re-read (the text itself); every requirement addressed or explicitly flagged with a reason
- [ ] Final deliverable verified AFTER the last edit made to it
- [ ] Verification checklist (above) passed on the final state
- [ ] All scaffolding removed; workspace contains only deliverables
- [ ] Assumptions, limitations, and unverified aspects stated in the delivery text
- [ ] Dead-end epitaphs and decision rationale included where they affect the user's understanding
- [ ] No further edits pending — if an improvement idea remains, it either maps to an acceptance criterion (then it is not done) or it does not (then do not make it)
- [ ] Handoff written so that a different agent, reading only the conversation and deliverables, could continue the work

Deliver, state what was verified and what was not, and stop.
