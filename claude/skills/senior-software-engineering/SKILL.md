---
name: senior-software-engineering
description: An executable workflow for solving difficult software engineering tasks at senior-engineer quality. Governs how to orient in an unfamiliar codebase, plan and decompose changes, debug systematically, refactor safely, make and record architecture decisions, write maintainable code, design testing strategy, prevent regressions, surface hidden assumptions, handle incomplete specs, prioritize fixes, and verify work before reporting success. Load this skill for any nontrivial engineering task — bug fixes in unfamiliar code, feature work, refactors, migrations, performance work, incident response — and whenever a change touches code you did not just write.
---

# Senior Software Engineering Workflow

## Purpose

The difference between junior and senior output is not code quality in the small — it is what happens around the code: reading before writing, making the change small, knowing what the change can break, proving it works, and saying honestly what was and wasn't verified. This procedure encodes those behaviors as executable steps. The standard for every deliverable: a reviewer can see *why* the change is correct, *what* it can affect, and *how* that was checked — from the written record alone.

Three prohibitions frame everything below:

1. **Never edit code you haven't read in its current state.** Not the version you remember, not the version the docs describe — the version on disk now.
2. **Never report success you haven't observed.** "Should work" is not a status. Run it, see it, then say it.
3. **Never make two kinds of change in one commit-sized unit.** Behavior changes and refactors travel separately, always.

---

## Part 1 — Understanding an unfamiliar codebase

Orientation is a funnel: structure → conventions → the specific slice you must touch. Do not read linearly and do not read everything.

1. **Map the skeleton (minutes, not hours).** List the top-level layout; read the README, build config, and dependency manifest — these reveal the stack, entry points, and what the project believes about itself. Locate: where execution starts, where tests live, how the project is run and tested. *Run the tests before changing anything* — you need to know whether the suite was already broken, or you will later attribute pre-existing failures to your change.
2. **Learn conventions by sampling, not by docs.** Open 2–3 files similar to what you'll touch. Note: error-handling style, naming patterns, layering rules (what imports what), test structure. Your changes must be locally indistinguishable from the surrounding code — consistency with a codebase's existing conventions outranks your stylistic preferences.
3. **Trace the slice you'll modify, end to end.** For the specific feature/bug: find the entry point, follow the call path, and identify the data shapes at each boundary. Use search tools on identifiers (definitions, references, call sites) rather than guessing from file names. Write down the trace — a five-line "request → handler → service → query → response" note prevents mid-task disorientation.
4. **Use version-control history as documentation.** `git log`/`blame` on the file you're changing answers "why is it like this?" better than any comment. A weird-looking guard clause with a bug-fix commit behind it is load-bearing; treat unexplained oddities as protective until proven decorative (Chesterton's fence, operationalized).
5. **Record what you *didn't* read.** Note the parts of the system you're treating as black boxes. These are where your hidden assumptions live (Part 10).

**Exit condition:** you can state where your change goes, what calls it, what it calls, and how you'll run/test it — in writing.

## Part 2 — Handling incomplete specifications

Specs are always incomplete; the skill is choosing which gaps to fill by assumption and which by asking.

1. Extract every explicit requirement into a numbered list. Then list the obvious unstated ones (error behavior, empty inputs, concurrency, permissions, backward compatibility) — most spec gaps are in what happens when things go *wrong*, because specs describe the happy path.
2. For each gap, classify: **(a) inferable from the codebase** — how do sibling features handle it? Match them. **(b) low-cost either way** — pick the conservative option, state the assumption in your deliverable. **(c) divergent and expensive** — interpretations lead to substantially different work, or the choice is user-visible/irreversible → ask ONE consolidated question, and keep building the parts common to all interpretations while waiting.
3. Never silently pick an interpretation for a type-(c) gap. Never block entirely on a type-(a) or (b) gap.
4. Default assumptions when the codebase gives no signal: preserve existing behavior, fail loudly rather than silently, don't widen public interfaces, don't add configuration for hypothetical needs.

## Part 3 — Planning changes and decomposing large problems

1. **Write the target state first:** the observable facts true when done — "endpoint returns 409 on duplicate; all existing tests pass; new tests cover the three failure modes." This is the acceptance list everything is checked against.
2. **Decompose along verification seams.** Each step ends in something checkable — compiles, test passes, output diff is empty — not in "part 2 of the big edit." A step that can't be checked can't be trusted as a foundation.
3. **Order by risk, then by dependency.** Front-load the step most likely to invalidate the plan: the unknown API, the "can this schema even express that?" question, the performance-critical piece. Prototype it crudely if needed — a throwaway spike that kills a bad plan in 20 minutes is the cheapest work you'll do.
4. **Prefer a sequence of shippable intermediate states.** For large changes, plan so the system works after each step (expand → migrate → contract, feature-flag, parallel implementations). Long-lived broken states are where large tasks die: you lose the ability to test, and errors pile up unlocatable.
5. **Separate the mechanical from the judgmental.** Bulk renames, import updates, and format churn go in their own steps (ideally scripted), isolated from steps requiring thought. Mixing them makes review and debugging exponentially harder.
6. Keep the plan durable (todo tool or restated list) and update it *explicitly* when reality diverges. Executing a dead plan's later steps is a category of failure entirely under your control.

## Part 4 — Debugging

Debugging is hypothesis testing against a system, not code-staring or patch-guessing.

1. **Reproduce first.** A bug you can't trigger on demand can't be verified as fixed. Invest in a minimal reproduction — smallest input, fewest components. If reproduction is impossible (prod-only), instrument first, guess never.
2. **Read the error.** The actual message, the actual stack trace, the actual line. A large fraction of debugging time is wasted on a misread or skimmed error. Then check the stupid things explicitly — wrong file, wrong branch, wrong environment, stale build, cached artifact — *before* forming clever theories. Say the checks out loud: they're embarrassing to skip, not to run.
3. **State a hypothesis and a rival, then run the cheapest discriminating test.** "If the race is in the cache layer, disabling the cache eliminates the failure in the repro." Predict the outcome before running. A surprising result means a belief was wrong — that's the signal to follow, not noise to explain away.
4. **Bisect the space.** Localize by halving: which layer, which commit (`git bisect` when the regression window is known), which input half, which config delta. Binary search beats intuition in unfamiliar code.
5. **Two failed fixes of the same kind → stop patching, start auditing.** List observed facts vs. untested assumptions; test the most obvious untested assumption first. The bug is nearly always in something "too obvious to check."
6. **Understand before fixing.** A fix you can't explain is a bug that moved. The bar: you can state the mechanism — cause → effect → why the fix interrupts it — and ideally you can *re-break* it predictably by reverting.
7. **After the fix:** re-run the original reproduction (not just the test you wrote), run the surrounding suite, and add a regression test that fails without the fix. A fixed bug without a pinning test is a scheduled reoccurrence.

## Part 5 — Refactoring

1. **Refactoring changes structure, never behavior — and never shares a change-unit with behavior changes.** If you discover a bug mid-refactor: stop, record it, fix it separately (before or after), never "while I'm here."
2. **No refactoring without a safety net.** Characterization tests around the current behavior come first — including current *weird* behavior; you preserve it unless explicitly told otherwise, because something may depend on it.
3. **Move in reversible steps that keep tests green.** Rename → run tests → extract → run tests → inline → run tests. If tests stay red through multiple steps, you are rewriting, not refactoring — roll back to green and take smaller steps.
4. **Scope discipline:** define the boundary before starting ("this module, not its callers") and log out-of-scope discoveries in a follow-ups list instead of chasing them. Refactors die of scope creep more than of difficulty.
5. Verify completion mechanically: grep proves no old-style call sites remain; the diff contains only what the refactor's definition says it should.

## Part 6 — Architecture decisions

1. **Frame the requirements, then generate 2–3 real options.** A decision with one option is a foregone conclusion, not a decision. Include the boring option (do nothing / minimal change) — it's the baseline others must beat.
2. **Evaluate on:** fit to *current* known requirements (not speculative ones), operational complexity added, blast radius when it fails, reversibility, and team/codebase fit (a technically superior pattern alien to the codebase is often the wrong choice).
3. **Weight reversibility above cleverness.** Prefer designs that are cheap to change over designs that are optimal-if-you-guessed-right. Ask of each option: "what does undoing this cost in six months?" Two-way doors get decided fast and locally; one-way doors (public APIs, data formats, wire protocols, anything persisted) get the full treatment and explicit user sign-off.
4. **Decide at the last responsible moment, then commit.** Don't pay for flexibility you can't name a use for (YAGNI applies to architecture doubly); don't revisit settled decisions without new information.
5. **Record the decision** in ADR shape wherever it can live (a doc, the PR description, the deliverable): context → options considered → decision → consequences accepted. The rejected options and *why* are the valuable part; they prevent the next engineer (or the next model) from relitigating blind.

## Part 7 — Writing maintainable code

Maintainability is optimizing for the reader, who outnumbers the writer ~10:1.

1. **Match the codebase first.** Existing conventions beat personal style. New idioms only with justification.
2. **Name for behavior, not implementation.** `retryWithBackoff`, not `loopHelper2`. If a function is hard to name, it's doing too many things — the naming difficulty is the design feedback.
3. **Make wrongness loud.** Validate at boundaries, fail fast with messages that state what was expected vs. received, no silently swallowed exceptions, no sentinel values where errors belong. Every silent failure you write is a future multi-hour debugging session you're gifting someone.
4. **Comments explain *why*, code explains *what*.** Comment the non-obvious constraint, the workaround's reason, the link to the issue — never narrate the syntax. Delete commented-out code; version control remembers.
5. **Control scope aggressively:** smallest visibility that works, no premature abstraction (duplicate twice, abstract on the third — a wrong abstraction costs more than duplication), dependencies pointing one direction.
6. **Leave the diff minimal.** Reviewability is a feature. Formatting churn, drive-by fixes, and opportunistic renames outside the task's scope get moved to the follow-ups list.

## Part 8 — Testing strategy

1. **Test behavior at the boundary, not implementation inside it.** Tests that break on refactors (while behavior holds) are negative-value — they train people to update tests without reading them.
2. **Allocate by risk:** dense coverage on logic with many branches, money/data-touching paths, and previously-buggy areas ("bugs cluster"); thin coverage on glue and trivial delegation. Coverage percentage is a smell detector, not a goal.
3. **Every test earns its place by failing informatively.** For each test ask: "what real defect does this catch, and will its failure message point at the cause?" Write the failure message for a stranger at 3 a.m.
4. **The mandatory set for any change:** the happy path; each error path you added; boundaries (empty, one, many, max, malformed, unicode); and one test that fails without your change (proving the test tests something).
5. **Verify tests by watching them fail.** A test never seen red is unverified — it may pass vacuously. Write it, break the code (or write test-first), see red, fix, see green.
6. **Integration tests where the lies are.** Unit tests with heavy mocks verify your assumptions about collaborators, not the collaborators. Put at least one real end-to-end path through anything whose behavior you mocked.
7. Keep tests deterministic and independent: no shared mutable state, no wall-clock/sleep timing, no ordering dependence. A flaky test is worse than no test — it erodes trust in the whole suite.

## Part 9 — Regression prevention

1. **Know your blast radius before shipping.** For every changed function/schema/config: list its callers and dependents (search, don't recall). The regression you cause is rarely in the thing you changed — it's in the caller you didn't know about.
2. **Run the tests of the things you touch AND the things that touch them.** Green on your new tests plus red-unknown on the neighbors is not green.
3. **Pin fixed bugs with tests** (Part 4.7) and pin *current* behavior with characterization tests before refactors (Part 5.2).
4. **Watch for the classic silent breakers:** changed default values, reordered enum/serialization fields, tightened validation on data that's already persisted, timezone/locale/encoding handling, and anything crossing a versioned boundary (API, DB, wire format) — these need explicit backward-compatibility checks, not just test runs.
5. **Make risky changes observable and reversible:** feature flags, staged rollout, revert plan stated in the deliverable. "How do we know within minutes if this is wrong, and how do we undo it?" should have written answers for anything user-facing.

## Part 10 — Identifying hidden assumptions

Hidden assumptions are the top source of "impossible" bugs. Surface them on a schedule, not on inspiration:

1. **At orientation:** list the black boxes you didn't read (Part 1.5) — each is an assumption bundle.
2. **At planning:** for each plan step, ask "what am I taking for granted for this to work?" (input shapes, ordering, uniqueness, idempotency, timezone, encoding, "this runs single-threaded", "this list is small").
3. **At debugging impasses:** the observed-vs-assumed split (Part 4.5).
4. **Interrogate the environment gap:** works-on-my-machine differences are assumption catalogs — versions, env vars, data volume, latency, permissions, case-sensitivity of the filesystem.
5. **Promote or test:** each surfaced assumption either gets *tested* (cheap check now), *enforced* (an assertion/validation that makes it loud when violated), or *documented* (stated in the deliverable as a known dependency). Unwritten assumptions are the only forbidden state.

## Part 11 — Prioritizing fixes

When holding multiple defects/tasks, order by expected impact, not discovery order or interestingness:

1. **Triage classes first:** (P0) data loss/corruption, security, active outage — drop everything; (P1) wrong results silently produced — worse than crashes, because users act on them; (P2) crashes/errors correctly reported — bad but honest; (P3) degraded performance/UX; (P4) cosmetic.
2. Within a class: `(users affected × severity per user) / cost to fix`, adjusted by **fix-enables-fix** dependencies (fix upstream causes before downstream symptoms — some "bugs" evaporate) and by **diagnosis decay** (a bug you understand *now* is cheaper than the same bug re-diagnosed in a month).
3. **Distinguish stopping the bleeding from curing:** a mitigation (rollback, flag off, rate-limit) buys time and is often the correct *first* fix; record the real fix as owed work, not as done.
4. Say no explicitly: deprioritized items go on a written list with reasons — silence is how P2s become P0s.

## Part 12 — Verification before reporting success

The word "done" is earned by this sequence, executed on the final state of the code (after the last edit — the last edit is always the least-verified thing you have):

- [ ] The full relevant test suite run — not just your new tests — with results observed, and compared against the pre-change baseline from Part 1.1 (pre-existing failures distinguished from new ones)
- [ ] The actual acceptance list from Part 3.1 walked item by item, each with named evidence
- [ ] The original bug reproduction re-run (for fixes) and observed to pass
- [ ] The feature exercised as a user would — run the program, hit the endpoint, click the flow — not only through tests
- [ ] The diff re-read in full as a hostile reviewer: leftover debug output, TODOs, commented code, accidental file changes, secrets
- [ ] Blast-radius neighbors (Part 9.1) checked: their tests run, their contracts unbroken
- [ ] Error paths exercised, not just present: force at least one failure and observe the handling
- [ ] The report drafted with claims matching evidence exactly: what was verified (and how), what was not (and why), assumptions made, follow-ups owed

If any box can't be ticked, the report says so explicitly. "Implemented and unit-tested; could not run integration tests in this environment" is a senior report. "Done ✅" over unverified work is not.

## Part 13 — Deciding when additional investigation is necessary

Investigate further when ANY of: a fix works but the mechanism can't be stated; a test flake was "resolved" by rerunning; behavior differs between environments and the difference is unexplained; the diff needed to make things pass is larger or weirder than the mental model predicts; performance changed by more than the change explains; an unexplained log/warning appeared alongside your change; you notice reluctance to run a particular check (reluctance marks the error's likely address).

Stop investigating when: the acceptance criteria are met with evidence, the mechanism of every fix is stated, and remaining unknowns are documented and demonstrably outside the change's blast radius. Curiosity past that point goes in the follow-ups list, not the task.

---

## Worked example (the workflow, compressed)

Task: "Users report duplicate charges. Fix it." (Unfamiliar payments codebase.)

1. **Orient:** map repo; run suite (2 pre-existing failures — recorded, so they aren't later blamed on the fix); trace charge path: `POST /charge → ChargeHandler → PaymentService.execute → gateway client + DB write`. Black boxes noted: gateway client internals, queue retry semantics.
2. **Spec gaps:** "fix it" doesn't say whether double-*clicks*, gateway *retries*, or queue *redelivery* is the vector, nor the idempotency contract. Inferable from code? Partially — an `idempotency_key` column exists but is nullable and unused by `execute`. Type-(c) question drafted but held: reproduction may answer it.
3. **Debug:** hypothesis H1: client double-submit; rival H2: queue redelivery re-executes `execute`. Discriminator: duplicate charges' timestamps and request IDs in logs. Prediction: distinct request IDs ⇒ H1. **Observed: identical request IDs, ~30s apart ⇒ H1 dead, H2 supported** — matches the queue's visibility timeout. Mechanism stated: handler exceeds visibility timeout under gateway latency; message redelivered; `execute` is not idempotent.
4. **Plan (verification seams):** (1) failing test reproducing redelivery double-charge; (2) enforce idempotency key at `execute` with unique constraint — *expand/migrate/contract* since the column is nullable with legacy rows; (3) handle the constraint-violation path as success-already-done; (4) blast radius: find all 3 callers of `execute`, check each supplies a key.
5. **Fix + tests:** watch the new test fail → implement → green. Error-path test: constraint violation returns the original charge result, no user-visible error. One caller (a backfill script) supplies no key — surfaced to user as a scope question rather than silently changed.
6. **Verify:** full suite (same 2 pre-existing failures, nothing new); original repro re-run — single charge; diff re-read (debug logging removed); report states: mechanism, evidence, the migration's rollout order, the backfill-script question, and one follow-up owed (alerting on constraint-violation rate as a redelivery canary).

Every senior behavior appears on the record: baseline before changes, hypothesis with rival and prediction, mechanism before fix, pinning test seen red, blast radius searched not recalled, honest report with an open question.
