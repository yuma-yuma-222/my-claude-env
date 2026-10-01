---
name: debugging-methodology
description: An executable methodology for debugging — reproducing failures, narrowing the search space, generating and testing hypotheses, designing experiments, root cause analysis, validating fixes, preventing regressions, handling intermittent and heisenbug-class failures, seeing through misleading symptoms, estimating confidence, and deciding when a problem is actually solved. Load this skill for any nontrivial defect: crashes, wrong output, hangs, flaky tests, performance regressions, prod-only failures, "it worked yesterday" — and whenever two fix attempts have already failed, which is the signal that guessing has replaced method.
---

# Debugging Methodology

## Purpose

Debugging is the process of converting ignorance into localized, mechanistic knowledge of a failure — and only then changing code. Its failure modes are universal: fixing symptoms instead of causes, staring at code instead of gathering evidence, trying patches instead of testing beliefs, and declaring victory when the error message stops appearing. This procedure replaces all four with a single discipline: **the bug is a hypothesis-testing problem about a system you're partially wrong about, and every step should either shrink where the bug can be or test a belief about what it is.**

Standing rules:

1. **No fix before mechanism.** You may not change the code to fix a bug until you can state the causal chain: trigger → mechanism → observed failure. A fix without a mechanism is a symptom suppressed and a bug relocated.
2. **Evidence outranks plausibility.** What the system *shows* beats what the code *should do*, every time they conflict. The conflict itself is the clue.
3. **One change at a time.** Every experiment varies one thing; every fix lands alone. Two simultaneous changes produce unattributable results.

---

## Part 1 — Reproducing failures

Reproduction is the first milestone and the enabling asset for everything after: a bug you can trigger on demand can be bisected, instrumented, and — critically — *proven fixed*. A bug you can't reproduce can only be theorized about.

1. **Capture the failure's identity before touching anything:** exact error text (copied, not paraphrased), stack trace, timestamps, environment (versions, OS, config, data), and the reporter's actual steps. The verbatim record matters — debugging sessions are routinely derailed by working from a paraphrase of the error rather than the error.
2. **Reproduce it once as reported, faithfully,** before simplifying. Confirm you're chasing the same bug: same error, same location, same conditions. "A similar crash" is not reproduction — different bugs share symptoms constantly (Part 8).
3. **Then minimize.** Iteratively strip the reproduction: smaller input, fewer components, less config, shorter path — re-verifying after each cut that the failure still occurs *and is still the same failure*. The minimal reproduction is worth real investment: every element it still contains is implicated; everything removed is exonerated. Minimization *is* search-space narrowing (Part 2) done early.
4. **Script it.** The reproduction becomes a command you can run in seconds, because you will run it dozens of times (every experiment, every fix candidate, final validation). A 10-minute manual repro makes every hypothesis test cost 10 minutes; that price causes guessing.
5. **If it won't reproduce:** vary the usual suspects deliberately — data (their input, not your test input), state (fresh vs. warmed, empty vs. full), environment (versions, locale, timezone, filesystem case-sensitivity), concurrency (load, parallelism), and timing. Record each attempt: failed reproductions are evidence too — they exonerate the dimensions you varied.
6. **If it still won't reproduce** (prod-only, customer-only): switch modes from experiment to forensics — instrument the real environment (logs, traces, metrics around the suspected region), and treat each production occurrence as one data point in a passive experiment. Never "fix" an unreproduced bug silently; a fix that can't be validated is a hypothesis deployed as a hope, and must be labeled as such (Part 10).

**Exit condition:** a scripted reproduction, or an explicit forensics plan with instrumentation in place and the non-reproducibility recorded.

## Part 2 — Narrowing the search space

Localization beats insight: it's faster to make the haystack small than to be brilliant at spotting needles.

1. **Bisect on every available axis.** The universal move is halving:
   - **Time/version:** when did it last work? `git bisect` between known-good and known-bad turns history into a binary search — O(log n) builds to the guilty commit. This is often the single fastest path to a root cause and should be considered *first* whenever "it used to work" is true.
   - **Code path:** disable/stub half the pipeline; does the failure survive? Recurse into the failing half.
   - **Data:** delete half the failing input; still fails? Recurse. (This is minimization, continued.)
   - **Configuration/environment:** diff working vs. failing environments; toggle halves of the diff.
2. **Establish the boundary of correctness.** Walk the data through the failing path and find the *last point where values are right* and the *first point where they're wrong*. The bug lives between them. Instrument or inspect at the midpoint; recurse. Most debugging is exactly this, done deliberately instead of haphazardly.
3. **Use differential comparison whenever a working twin exists:** works in staging, fails in prod; works for user A, fails for user B; passes alone, fails in suite. Diff the two situations *systematically* (env, data, versions, timing, order) — the bug is in the difference, and the difference is enumerable.
4. **Trust the exoneration.** When bisection clears a region, stop re-reading it. The pull to keep staring at suspicious-looking-but-exonerated code is strong and pure waste; suspicion is not evidence, and the halving already spoke.

## Part 3 — Hypothesis generation

1. **Generate 2–4 candidate explanations before testing any.** A single hypothesis turns investigation into confirmation-hunting; the discipline of naming rivals is what keeps the evidence honest. Each hypothesis is one sentence with a mechanism: "the cache returns stale entries because invalidation isn't called on the update path" — not "something's wrong with the cache."
2. **Always include the boring candidates**, in rough order of base-rate likelihood: my new code is wrong (overwhelmingly the leader when the bug appeared with your change) → my assumptions about inputs/state are wrong → the environment differs from belief (wrong branch, stale build, cached artifact, wrong config, wrong database) → a dependency is misused → a dependency is broken → the platform/compiler is broken. Suspect the layers in that order; "the framework has a bug" is occasionally true and constantly claimed.
3. **Mine the anomaly.** The best hypothesis generator is the detail that doesn't fit: fails only on Tuesdays, only the second call, only above 1,000 rows, only in Docker. Every "only" is a mechanism's fingerprint — ask what is *different* about that condition and hypotheses fall out.
4. **State each hypothesis's testable prediction** as you form it: "if H1, then disabling the cache eliminates the failure; if H2, it persists." A hypothesis with no discriminating prediction is a vibe, not a hypothesis — reshape it until it forecasts something observable.

## Part 4 — Experiment design

1. **Choose the experiment by information per cost:** prefer the cheapest test that *discriminates between live hypotheses* — where outcome A supports H1 and outcome B supports H2. A test consistent with all hypotheses regardless of outcome costs time and teaches nothing.
2. **Predict the outcome in writing before running.** This is mandatory and is the engine of the whole method: predictions convert results into information. A confirmed prediction strengthens the hypothesis; a surprised prediction *proves a belief was wrong* — and the on-record prediction is what stops you from quietly rationalizing the surprise away ("huh, weird" is the sound of evidence being discarded).
3. **One variable per experiment** (standing rule 3). If you changed the config *and* the input and the behavior changed, you've learned almost nothing.
4. **Prefer falsification-shaped tests:** design to *break* the hypothesis, not to caress it. "If the pool is exhausted, raising the pool size to 100 must eliminate the failure in the repro" is strong because failure-to-eliminate kills H cleanly.
5. **Instrument for observation, minimally and reversibly:** targeted logging at the boundary of correctness (Part 2.2), assertions that make hidden state loud, debugger breakpoints at the midpoint. Tag every temporary instrument (e.g., a `DEBUG-TRACE` marker string) so cleanup (Part 6) is a search, not a memory exercise.
6. **Record results as they land** — a running log of hypothesis → test → prediction → observed → verdict. On any bug worth an hour, this log is what prevents circular re-testing and is the raw material for the confidence statement (Part 10) and the post-fix writeup.

## Part 5 — Root cause analysis

1. **Distinguish the three layers of every bug:** the *symptom* (what was observed), the *fault* (the code/config defect that must change), and the *root cause* (why the fault existed and survived — missing validation, wrong mental model of an API, absent test, process gap). Fixing the fault resolves the incident; addressing the root cause prevents the family.
2. **Walk the causal chain with "why" until you hit choices, not mysteries:** the request times out *because* the handler exceeds the queue's visibility timeout *because* a gateway call blocks without a timeout *because* the client library's default is infinite *because* our wrapper never sets one. Each link must be *verified* (observed or tested), not narrated — a plausible chain with an unverified link is a story.
3. **The mechanism test (gate for standing rule 1):** you understand the bug when you can (a) state the full trigger→failure chain, (b) predict exactly which variations of the repro will and won't fail — and be right, and (c) ideally, *re-break it on demand*: revert the fix or recreate the condition and watch the original failure return. The ability to summon the bug is the strongest proof you've found it.
4. **Explain every symptom.** The root cause must account for *all* observed behavior — the intermittency pattern, the "only on Tuesdays," the specific corrupted values. A candidate cause that explains 80% of the symptoms is either incomplete or wrong; the unexplained 20% is where a second bug or a deeper cause hides (Part 9).
5. **Check the blast radius of the cause, not the symptom:** where else does this same fault pattern exist? A missing timeout found in one wrapper is usually missing in its siblings. Search for the pattern; fix or file for each instance found.

## Part 6 — Validating fixes

A fix is validated by this sequence, executed in full, on the final state of the code:

- [ ] **The original scripted reproduction now passes** — the *original*, unmodified repro, not a paraphrase of it, and not only the new unit test. This is the single non-negotiable check; a "fix" never run against the original repro is unvalidated by definition.
- [ ] **The fix can be turned off:** revert the fix (or flag it off) and confirm the failure *returns*. This closes the loop — it proves the fix, and not some incidental change or environmental drift, is what resolved it. Skipping this step is how coincidence gets shipped as a fix.
- [ ] **A regression test is added that fails without the fix and passes with it** — verified by actually running it both ways, not by inspection. A test never seen red may be testing nothing.
- [ ] **The surrounding suite passes,** compared against the pre-investigation baseline (you recorded which tests already failed before you started — new failures are yours).
- [ ] **The fix's own failure modes are exercised:** if the fix adds a timeout, force the timeout and observe the handling; if it adds validation, feed it the invalid input.
- [ ] **All temporary instrumentation removed** — searched for by its tag (Part 4.5), not recalled.
- [ ] **The diff re-read cold:** only the intended change is present; no debug remnants, no drive-by edits.
- [ ] For intermittent bugs, the statistical validation of Part 8 replaces the single-run check in item 1.

## Part 7 — Preventing regressions

1. **Every diagnosed bug leaves a pinning test behind** (Part 6, item 3) — placed at the lowest level that can express the failure (unit if possible; integration if the bug lived between components, which is where unit tests are blind).
2. **Fix the family:** the pattern-search from Part 5.5 either fixes sibling instances now or files them explicitly — silent knowledge of a latent twin is a scheduled incident.
3. **Convert the diagnosis into guardrails:** the assertion that would have made this loud, the validation that would have rejected the input, the lint rule or type that makes the fault class unrepresentable. The best regression prevention makes the bug *impossible*, the second best makes it *immediate*, and only the third best makes it *tested*.
4. **Make recurrence observable:** if the bug was invisible in production (silent corruption, slow leak), add the metric or alert that would have caught it — validated by confirming the alert fires on the reproduced condition.
5. **Record the mechanism** where the next debugger will look: the commit message and the regression test's comment carry the causal chain, the "only" conditions, and the exoneration list. Two lines of "why" in the right place saves the next session's first hour.

## Part 8 — Handling intermittent bugs

Intermittency is not randomness; it is determinism through variables you aren't yet controlling. The method extends, not changes:

1. **Hunt the hidden variable first.** Enumerate what genuinely varies between runs: thread/async scheduling, wall-clock time and timezones, iteration order of unordered collections, uninitialized memory, network latency and retries, test execution order and shared state, data-dependent paths, GC pauses, caching. The reproduction question becomes: *which of these, when pinned, makes it deterministic?* Pin them one at a time (fixed seed, frozen clock, forced ordering, serial execution) — when pinning X makes the bug vanish or become constant, X is implicated.
2. **Amplify instead of waiting:** run the repro in a tight loop (hundreds/thousands of iterations), under load, with added contention or injected delays at suspected race windows (a deliberately inserted `sleep` at a suspected interleaving point is a legitimate experimental instrument). Turn "sometimes" into a *failure rate* you can measure.
3. **Measure the base rate before changing anything.** "Fails ~7/100 runs" is the baseline that makes fix validation possible at all. Without it, "I ran it three times and it passed" is indistinguishable from luck — which is exactly how flaky-test "fixes" are hallucinated.
4. **Validate statistically:** the fix must drive the failure rate to 0 over a run count where the *old* rate would have produced many failures (e.g., old rate 7/100 → new evidence 0/1,000 is strong; 0/20 is nothing). State the numbers in the confidence report.
5. **Never resolve a flake by rerunning until green.** A rerun that passes is a sample, not a fix. Flaky tests are real bugs in either the code or the test — both are worth diagnosis, and the hidden-variable hunt (item 1) applies identically to both.
6. For heisenbugs (observation changes behavior — debugger or logging makes it vanish): the observation that *suppresses* the bug is itself localizing evidence — it changed timing or memory layout, which tells you the bug lives in a race or in undefined behavior. Switch to lower-impact observation: post-mortem state capture, hardware watchpoints, event tracing, or record-replay tooling where available.

## Part 9 — Identifying misleading symptoms

Symptoms mislead in systematic ways; check for each pattern explicitly when progress stalls:

1. **Distance between fault and failure.** The crash site is where damage became *visible*, not where it occurred — corruption travels (bad write here, crash there, three seconds later). When the code at the failure site looks innocent, it usually is: shift from "why did this line fail?" to "who damaged the state this line trusted?" and trace backward along the data (Part 2.2's boundary walk, run upstream).
2. **The first error is the real one; the rest are cascade.** A failure storm's later errors are consequences (half-initialized state, exhausted resources, poisoned caches). Sort by timestamp, take the earliest, ignore the noise until it's fixed — then see what remains.
3. **Error messages report the reporter's confusion, not the cause:** "file not found" (wrong working directory), "connection refused" (the *dependency's* dependency is down), "type error" (the wrong value arrived long before it was used). Treat the message as the failure's *location*, never its explanation.
4. **Coincidence wears causation's clothes.** "It broke when we deployed X" — verify, don't assume: did it actually start then (check logs before the deploy), and does reverting X actually clear it? Time-correlation is a hypothesis generator, not a verdict.
5. **Two bugs, one symptom.** When evidence seems self-contradictory — the fix helps sometimes, the repro shifts shape, exonerated code re-implicates — seriously entertain multiple overlapping bugs. The move: pin one variant precisely (exact error + exact conditions), fix it in isolation, re-run the full repro matrix, and re-diagnose what's left as a *new* investigation rather than forcing it into the old theory.
6. **Your fix changed the symptom, not the state.** If the error message changed after a fix attempt, that's progress *only if* the mechanism predicted it. An unpredicted symptom shift means you perturbed the system, not repaired it — revert and reassess rather than chasing the new shape.

## Part 10 — Determining confidence levels

State confidence explicitly at hand-off, derived from the evidence log, using this ladder:

- **Proven (highest):** mechanism stated and verified link-by-link; fix validated per Part 6 *including* the revert-restores-failure check; for intermittents, statistical validation with stated numbers. → Report as fixed, plainly.
- **Strongly supported:** mechanism stated; original repro passes; revert-check or full statistical run not performed (justify why). → Report as fixed with the named gap: "validated against the repro; did not re-induce by revert."
- **Probable:** fix follows from a coherent mechanism but the repro was weak or partial (e.g., prod-only bug, fix validated only against a reconstruction). → Report as *probable fix, monitoring required*, with the specific signal that will confirm or refute it in production and a date to check.
- **Speculative:** no reproduction; fix targets the best available hypothesis. → Must be labeled as such, shipped with instrumentation that will adjudicate it, and tracked as open — a speculative fix that silently closes the ticket is the dishonest end of debugging.

Confidence rules: it tracks the **weakest link in the causal chain**, not the average; unexplained symptoms cap confidence at *probable* no matter how well the rest fits (Part 5.4); and the report never claims one level up from the evidence — the phrase "should be fixed" is banned in favor of naming which level applies and why.

## Part 11 — Deciding when the problem is actually solved

"The error stopped appearing" is not solved. Solved is ALL of:

- [ ] Root cause stated as a verified causal chain (Part 5), with every observed symptom accounted for — including the intermittency pattern and every "only"
- [ ] Full fix-validation sequence executed (Part 6) — original repro, revert-check, red-then-green regression test, suite vs. baseline, instrumentation removed
- [ ] For intermittents: statistical validation with before/after rates stated (Part 8.4)
- [ ] The fault *family* addressed or filed (Parts 5.5, 7.2)
- [ ] Guardrails and/or observability landed where warranted (Parts 7.3–7.4)
- [ ] Confidence level declared per Part 10, with its evidence — and for anything below *proven*, the monitoring signal and follow-up owed are written down
- [ ] The mechanism recorded where the next person will find it (Part 7.5)

If any box is unticked, the honest status is "mitigated," "probable," or "open — monitoring," never "solved." Declaring the true state costs a sentence; declaring victory early costs the next incident plus the credibility of every future "fixed."

---

## Worked micro-example (the method, compressed)

Symptom: a nightly batch job "randomly" fails ~once a week with `KeyError: 'user_id'`.

- **Reproduce (P1):** verbatim traceback captured; fails on last Tuesday's input file, reliably — *not random*: deterministic per-input. Minimized: 40M rows → one 3-row snippet still failing, same error. Scripted.
- **Narrow (P2):** boundary walk: rows correct after parsing, wrong after the merge step — one row lacks `user_id` post-merge. `git bisect` unnecessary; differential comparison of the 3 rows: the failing row's join key contains a trailing space.
- **Hypotheses (P3):** H1: upstream export started emitting unstripped keys; H2: our parser stopped stripping; H3 (boring): it always could happen, and this week's data merely contained the first such row. Prediction (P4): if H2, `git log` on the parser shows a recent change — *observed: no change in 14 months* → H2 dead; export logs show trailing spaces present for years → H1 dead; H3 stands: latent fault, data-triggered.
- **Root cause (P5):** chain verified: unstripped key → failed join → merge emits row without `user_id` → downstream `KeyError`. *Symptom misled (P9.1/9.3):* the error named the crash site, four steps after the fault. "Once a week" fully explained: frequency of dirty keys in real data. Family check: three other join sites share the pattern — filed.
- **Fix + validate (P6):** normalize keys at ingestion + *fail loudly* on post-merge nulls (guardrail: the silent variant is now impossible). Original 3-row repro passes; full Tuesday file passes; fix reverted → `KeyError` returns on demand → re-applied. Regression test seen red, then green. Suite vs. baseline: clean. Instrumentation removed by tag-search.
- **Confidence + closure (P10–11):** *Proven* — mechanism verified, re-breakable, all symptoms (including the weekly cadence) explained; sibling joins filed; commit message carries the chain. Status: solved — and the word is now earned.
