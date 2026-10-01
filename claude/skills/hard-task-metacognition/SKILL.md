---
name: hard-task-metacognition
description: How to decompose hard or ambiguous tasks, verify your own work before presenting it, and decide what to do next at each step of a long-running task. Use this skill whenever a task is multi-step, open-ended, has a real chance of partial failure, or will take more than a handful of tool calls — for example large refactors, research syntheses, document pipelines, data analyses, debugging sessions, or anything where you might otherwise dive in and get lost. Also use it when you notice you are looping, stuck, or unsure whether the work is actually done.
---

# Hard-Task Metacognition

A skill for working on hard tasks the way a careful senior practitioner does: break the problem down before touching it, check your work with evidence rather than vibes, and at every fork choose the next action deliberately instead of by momentum.

The three sections below correspond to the three phases you cycle through: **Decompose → Execute-and-Verify → Decide**. On a long task you will loop through Verify and Decide many times; Decompose usually happens once up front and again whenever the plan breaks.

---

## 1. Decomposing hard tasks

### First, establish what "done" means

Before splitting anything into steps, write down (in your reasoning, a todo list, or a scratch file) the *acceptance criteria*: the observable facts that will be true when the task is complete. "The tests pass," "the report answers all four of the user's questions," "the spreadsheet opens without repair warnings." If you can't state acceptance criteria, the task is underspecified — resolve that first, either by making a reasonable assumption and stating it, or by asking the user one targeted question. A vague goal decomposed into steps just produces confidently-executed vagueness.

### Decompose along verification seams, not narrative seams

The most useful place to cut a task is wherever you can *check* something. A good subtask ends in an observable result (a file exists, a query returns rows, a function passes its test), not in a feeling of progress. Compare:

**Weak decomposition** (narrative seams):
1. Understand the codebase
2. Make the changes
3. Clean up

**Strong decomposition** (verification seams):
1. Locate every call site of `parse_config` → *verified by: grep output listing N sites*
2. Change the signature and update all N sites → *verified by: grep shows zero old-style calls*
3. Run the test suite → *verified by: exit code 0*

Each strong step tells you immediately whether you can proceed. Each weak step lets you drift.

### Order steps to kill risk early

Front-load the steps most likely to invalidate the whole plan: unknown APIs, ambiguous requirements, questionable data quality, "does this library even do that?" questions. Ten minutes probing the riskiest assumption beats an hour of polished work built on it. If a task involves a resource you haven't inspected (an uploaded file, an unfamiliar schema, a third-party API), inspecting it is step 1, not step 4 — plans made before looking at the actual data are fiction.

### Size steps to your reliability, not your ambition

A step should be small enough that if it fails, you know *where* it failed. If a single step involves three distinct operations and the output is wrong, you now have three suspects. When working in code, prefer many small run-and-check cycles over one heroic diff. When writing long documents, draft section by section against an outline rather than emitting everything at once.

### Keep a live plan, and treat plan changes as events

Maintain the decomposition somewhere durable (todo tool, scratch file, or an explicit numbered list you restate). When reality diverges from the plan — a step fails, an assumption dies, the user adds a constraint — update the plan *explicitly* before continuing. Silent plan drift is how you end up executing step 6 of a plan whose step 2 turned out to be false.

---

## 2. Verifying your own work

The core stance: **your confidence is not evidence.** Having just written something makes it feel correct; that feeling is worthless as a check. Verification means generating information you didn't have before, from a source other than the process that produced the work.

### Prefer verification in this order

1. **Mechanical checks** — run the code, execute the tests, open the generated file, re-run the query, validate the JSON, render the document. If a machine can check it, let the machine check it. This is the cheapest and most trustworthy tier; use it whenever it exists.
2. **Independent re-derivation** — compute the answer a second way. Sum the column with a different tool, spot-check three rows by hand, re-derive the formula from first principles, count the items instead of trusting the earlier count. The key property is that the second path must not reuse the first path's intermediate results.
3. **Adversarial re-read** — reread your output specifically hunting for the ways it could be wrong: unhandled edge cases, claims without sources, requirements from the original request that quietly disappeared, numbers that don't reconcile with each other. Read as a hostile reviewer, not as the proud author.

Tier 3 alone is weak — it shares your blind spots. Reach for it only when tiers 1 and 2 are unavailable, and say so if the stakes are high ("I've reviewed this but couldn't test it end-to-end").

### Verify against the request, not just against correctness

There are two distinct failure modes: the work is *wrong*, and the work is *not what was asked*. Both need checking. Before presenting anything, reread the user's original message (not your memory of it) and walk through each explicit requirement and each obvious implicit one. Long tasks are where requirements silently fall off — the constraint mentioned in message one that no longer appears anywhere in your context of attention.

### Verify the artifact the user will receive, not your intent

If you produced a file, open the actual file. If you produced code, run the actual code. If you generated a chart, look at the rendered chart. The gap between "what I meant to create" and "what exists on disk" is a top source of embarrassing failures: the docx that won't open, the script with the typo introduced in the final edit, the export that silently truncated. The last edit you made is the least-verified thing in the whole task — never ship immediately after an unchecked change.

### Calibrate verification depth to cost of error

Not everything deserves tier-2 scrutiny. Scale effort to blast radius:

- **Irreversible or high-stakes** (deleting data, sending messages, financial/medical/legal claims, anything the user will act on immediately): verify thoroughly, and prefer showing the user before acting.
- **Load-bearing intermediate results** (a number every later step depends on, a parsing step feeding the whole pipeline): verify at tier 1 or 2 *now*, because an error here multiplies.
- **Cheap-to-fix cosmetics**: a fast tier-3 pass is fine.

### Report verification honestly

Tell the user what you checked and what you couldn't. "Tests pass and I spot-checked the output against the source data" and "I could not run this, so treat it as a draft" are both fine; unmarked confidence about unverified work is not. If you found and fixed an error during verification, that's a sign the process worked — no need to hide it or to flagellate over it.

---

## 3. Deciding what to do next

At every step boundary you are at a fork, whether or not you notice it. The failure mode is momentum: doing the next thing because it's next, not because it's still right.

### The standing checkpoint questions

After each meaningful step (especially after any tool result), ask:

1. **Did that step actually succeed?** Check the evidence, not the intention. A tool call that returned *something* is not the same as a tool call that returned what you needed.
2. **Did it change the plan?** New information may invalidate later steps, reveal a shortcut, or surface a question for the user.
3. **What is the single highest-value next action?** Sometimes it's the next planned step. Sometimes it's an unplanned probe of something suspicious. Sometimes it's stopping to ask.

### Recognize the stuck-loop and break it deliberately

You are in a loop when you attempt the same class of fix a third time. The rule: **two similar failures earn a strategy change, not a third attempt.** When you hit this trigger, stop and diagnose rather than iterate:

- Restate what you *know* (observed facts) versus what you've been *assuming*.
- Actively test the assumption most likely to be false — usually the one you've never checked because it seemed too obvious.
- Widen the frame: is the bug upstream of where you're looking? Is the whole approach wrong, not the implementation?
- Consider a different tool or path entirely (different library, manual approach, simplified version of the goal).

Repeating a failed action with minor variations feels like effort but produces no new information. Diagnosis produces information.

### Know when to come back to the user

Return to the user rather than pushing forward when:

- **A decision is theirs to make**: taste, priorities, tradeoffs with no objective answer, anything irreversible or side-effectful (sending, publishing, deleting, purchasing).
- **An assumption you made turned out wrong** in a way that changes what they'd want.
- **The task is 80% done and the last 20% is ambiguous**: deliver the 80% with the specific question, rather than guessing and forcing rework.
- **Cost has ballooned**: the task is turning out much larger than either of you expected, and they may want to rescope.

Conversely, do *not* come back for questions the context already answers, for permission to do the obviously-intended thing, or to narrate progress with nothing decision-relevant in it. Interruptions are expensive too.

### Know when to stop

Stopping criteria matter as much as starting criteria. Stop when the acceptance criteria from section 1 are met and verified — not when you run out of ideas for further polish. Endless improvement passes past the point of "verified done" add risk (each edit is a chance to break something) without adding value. Declare done, state what was verified, note any known limitations, and hand it over.

### A worked micro-example

> Task: "Clean this sales CSV and give me revenue by region."
>
> **Decompose:** (1) Inspect the file — columns, row count, obvious junk *(verified by: actually viewing head/tail and dtypes)*. (2) Define cleaning rules from what's observed, list them for the user if any are judgment calls. (3) Apply rules; *(verified by: before/after row counts and a sample of dropped rows)*. (4) Aggregate; *(verified by: grand total matches sum of raw revenue column within cleaning-explained difference)*. (5) Deliver with the reconciliation stated.
>
> **Checkpoint in action:** Step 4's total is 12% below the raw sum, but cleaning only dropped 2% of rows. That fails verification → don't proceed to step 5, don't re-run the aggregation hoping for different output. Diagnose: the discrepancy is information. (Likely suspect: a currency or type-coercion issue turning some values to NaN — an assumption from step 2 that was never tested.)

That is the whole skill in miniature: cut where you can check, check with evidence, and let the evidence — not momentum — pick the next move.

---

## Quick self-audit (use mid-task when uneasy)

- Can I state, right now, what "done" looks like? If no → back to section 1.
- What evidence do I have that the last step worked? If "it seemed fine" → section 2.
- Have I tried essentially this same fix twice already? If yes → strategy change, section 3.
- Is there a requirement in the user's original message I haven't touched in a while? Reread it.
- If I shipped the current state right now, what would embarrass me? Check that thing first.
