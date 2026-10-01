---
name: review-methodology
description: An executable methodology for reviewing work products — software, architecture, technical documents, research, designs, and specifications. Governs how to find logical errors, identify inconsistencies, detect hidden assumptions, check completeness, analyze edge cases, assess security, maintainability, and readability, prioritize issues, communicate findings constructively, and decide whether work is ready for approval. Load this skill whenever asked to review, critique, audit, or approve anything — a pull request, an RFC, a paper, a spec, a design, a report — and whenever your own completed work deserves a hostile second pass before delivery.
---

# Review Methodology

## Purpose

Review is adversarial verification performed as a service: the reviewer's job is to find what's wrong *now*, while it's cheap, so reality doesn't find it later, when it's expensive. Reviews fail in two symmetric ways: the **rubber stamp** (skim, nitpick a name, approve — the defects ship) and the **gate-keeping performance** (a wall of style opinions that buries the one finding that mattered). Both come from the same root: reviewing without a method, so attention lands on what's easiest to see rather than what's most likely to be wrong. This procedure directs attention deliberately, ranks what it finds, and makes the approval decision explicit and evidence-based.

Standing rules:

1. **Understand before judging.** No issue is filed until you can state what the work is trying to do and why. Half of bad review comments are misunderstandings wearing critique's clothing.
2. **Findings must be specific, located, and consequential.** Every issue names where it is, what's wrong, *what it breaks or costs*, and (where possible) what better looks like. "This seems off" is not a finding.
3. **The severity of your review's tone comes from the finding, not the reviewer.** The same standards apply whether reviewing a stranger's work, a colleague's, or your own — self-review runs this identical procedure.

---

## Part 1 — Establish intent and criteria (before reading in depth)

1. **Determine what the work claims to do:** read the stated purpose (PR description, abstract, spec's goal section, design brief) *first*, and restate it in one sentence. The review evaluates the work against its own claims plus the applicable standards — not against the work you would have produced instead. "I'd have done it differently" is only a finding when *differently* is demonstrably better on a criterion that matters.
2. **Establish the review's own scope and stakes:** what kind of review is wanted (correctness gate? design feedback? pre-submission polish?), what depth the stakes warrant (a payment-path change and a README fix deserve different budgets), and what you are — and aren't — able to verify (can you run it? access the data? check the citations?). State unverifiable areas rather than silently skipping them.
3. **Gather the criteria:** the requirements/ticket/spec the work answers to, applicable standards (style guides, security baselines, house conventions), and the interfaces/contracts it must honor. Completeness checking (Part 5) is meaningless without this list in hand.
4. **Record your priors and conflicts:** if you already like or dislike the approach, note it privately — then require the same evidence for your prior as for its opposite.

## Part 2 — Multi-pass reading

Attention is the review's scarce resource; passes allocate it. Never try to catch everything in one pass — each pass has one job, and mixing them means each job is done badly.

1. **Pass A — Comprehension (no judging):** read end-to-end to build the model: what it does, how it's organized, how the pieces relate. Note questions, not verdicts. For code: trace the main path. For documents: the skim path (headings + first sentences). If comprehension fails, that is itself a top-tier finding (Part 9) — but distinguish "unclear" from "unfamiliar to me": re-read once before filing.
2. **Pass B — Correctness (the adversarial pass):** now hunt, using Parts 3–8 as the checklist of *where to aim*. Read as the hostile expert: assume there is at least one significant defect and your job is to find it — because at base rates, there is.
3. **Pass C — Fitness (zoom out):** does the whole meet its intent and criteria (Part 1)? Is the *approach* right, not just the execution? Approach-level findings discovered only in Pass C but reported first (Part 10) — nothing wastes more goodwill than approving the bricks and then condemning the wall.
4. **Depth allocation within passes:** spend adversarial attention where defects concentrate — the novel parts (boilerplate is low-yield), the boundaries (interfaces, error paths, format conversions), anything the author flagged as tricky, anything touching money/data/security, and *the parts that were hardest to comprehend in Pass A* (confusion clusters with defects).

## Part 3 — Finding logical errors

Logical errors are internal: the work contradicts itself or its reasoning doesn't hold. Hunt by category:

1. **Invalid inference:** the conclusion doesn't follow — check each "therefore"/"so"/"which means" by asking *what would have to also be true for this step to hold?* The unstated bridge premise is either fine (leave it), an assumption (Part 4), or false (finding).
2. **Inverted or incomplete conditions:** off-by-one boundaries (`<` vs `<=`), negation errors, De Morgan slips (`!(A && B)` ≠ `!A && !B`), case analyses that don't cover the space (what happens when *neither* branch matches?), and conditions that can never be true or never false (dead logic — usually a mangled intent).
3. **Order-of-operations and state errors:** things used before established, invalidated-then-used, checked-then-changed (TOCTOU shape — also a security smell, Part 7), aggregations applied in an order that changes the answer (filter-then-average vs. average-then-filter).
4. **Quantifier and scope slips:** "all"/"any"/"each" confusions ("all users with role A or B" — does the *all* bind both?), a property proven for one case silently generalized to all cases, statistics about groups applied to individuals.
5. **Circularity and proof-by-assertion:** the conclusion appears among its own premises; the benchmark validates against data the method was tuned on; the doc says "clearly" or "obviously" precisely where the argument is weakest (treat those words as flags planted on graves).
6. **Technique — independent re-derivation:** for any load-bearing calculation, transformation, or inference chain, re-derive it yourself without looking at the author's steps, then compare. Divergence localizes the error to one side; this beats reading their derivation nodding, which imports their mistake into your check.

## Part 4 — Detecting hidden assumptions

Hidden assumptions are the defects that pass every test the author wrote — because the author's tests share the author's assumptions. The reviewer's independence is precisely the asset here.

1. **Interrogate every input's provenance:** for each input/precondition, ask *who guarantees this?* Sorted? Non-null? Unique? Valid UTF-8? Already authenticated? In this timezone? If nothing enforces it, it's an assumption — the finding is either "enforce it" or "document it and handle its violation."
2. **Interrogate the environment:** what does this silently require of its world — single-threaded execution? A filesystem that's case-sensitive? Clock monotonicity? Network reliability? Deployment order? English locale? The assumption catalog of "works on my machine" applies to designs and specs too.
3. **Interrogate scale and time:** at what size does this stop working (the O(n²) hiding in a nested lookup, the "load it all into memory")? What happens in a year (the enum that will grow, the date math at DST, the "current" that rots)? Works-now-fails-later is an assumption about the future.
4. **Interrogate the happy path's popularity:** the deepest assumption in most work is *that things go right* — the API responds, the file parses, the user cooperates, the concurrent writer doesn't exist. For each external interaction, ask: what's the behavior when this fails, hangs, or half-succeeds? Silence is a finding.
5. **Use the "new-reader" advantage deliberately:** anything you had to assume to make sense of the work in Pass A is an assumption the work makes without stating. Your comprehension notes are a hidden-assumption detector — mine them.

## Part 5 — Completeness checking

Completeness is checked against lists, never against impressions — absence is invisible to free reading.

1. **Walk the requirements list** (Part 1.3) item by item: each requirement maps to something in the work, or its absence is a finding. Then walk the *work* against the requirements: significant pieces serving no requirement are scope creep or missing-spec — either way, a question.
2. **Walk the case space:** for each categorical input or state, are all values handled (every enum variant, every state transition, every user role)? For each numeric domain: empty, one, many, maximum, negative, zero?
3. **Walk the lifecycle:** creation is always specified — check update, failure, retry, cancellation, deletion, migration, rollback. Specs and designs are systematically complete about beginnings and silent about endings.
4. **Walk the promises:** every "see section X" resolves; every "TODO"/"TBD" is a finding (in work submitted as done); every claim in the summary exists in the body; every interface consumed is actually provided somewhere.
5. **Check the completeness of the *tests/evidence*, not just the artifact:** does the test suite/evaluation/appendix cover the risky parts (Part 2.4), or does it cluster on the easy ones? Untested claimed behavior is unverified behavior.

## Part 6 — Edge case analysis

Run the standard sweep against every boundary the work owns; for each, the question is "handled, rejected, or unaddressed?" — only the third is a finding:

1. **Quantity edges:** empty, single, duplicate, maximum, one-past-maximum, negative-where-only-positive-expected.
2. **Content edges:** null/missing vs. present-but-empty (different!), whitespace, unicode (combining characters, RTL, emoji), extremely long values, injection-shaped content (also Part 7), malformed encodings.
3. **Numeric edges:** zero, negative zero where it exists, overflow/underflow, precision loss (floats for money is a finding on sight), division-by-zero paths, rounding direction at .5.
4. **Temporal edges:** DST transitions, leap years/seconds, timezone-naive vs -aware mixing, clock skew, events in the "wrong" order, timestamps from the future.
5. **Concurrency edges:** two of them, simultaneously — two users, two requests, two instances of the job. Check-then-act windows, idempotency of retried operations, partial failure between two writes that must agree.
6. **Sequence edges:** operations invoked out of intended order, re-invoked (double-submit), invoked after teardown, resumed after interruption.
7. For each edge marked "handled," **spot-verify one or two** — read the actual handling or run the actual case. "Handled" in a comment or spec bullet is a claim, not evidence.

## Part 7 — Security considerations

Review everything through the attacker's read, scaled to exposure (an internal script and an internet-facing endpoint get different depth — but *data* flows make internal things external fast):

1. **Trust boundaries first:** identify every point where data crosses from less-trusted to more-trusted (user input, third-party APIs, files, inter-service calls) and check validation *at the boundary* — not deep inside where it's sometimes bypassed.
2. **The injection family:** anywhere data becomes code or commands — SQL built by concatenation, shell invocations with interpolated input, HTML rendered from user content, deserialization of untrusted bytes, path construction from user input (traversal). Pattern-match these shapes on sight.
3. **AuthN vs. authZ, checked separately:** the work knows *who* is calling — but does it check *whether they may* do this to *this specific object* (the missing per-object check is the classic hole)? Are there paths around the check (direct object references, internal endpoints, batch jobs)?
4. **Secrets and sensitive data:** credentials in code/config/logs; tokens in URLs; sensitive data in error messages, logs, or analytics; encryption at rest/in transit where the data class requires it; and *retention* — collected data that never needed collecting.
5. **Failure-mode security:** what does it do when the auth service is down — fail open or closed? Do error paths leak internals (stack traces to users)? Do retries amplify (no backoff = self-DoS)? Rate limiting on anything expensive or brute-forceable?
6. **Dependency and supply-chain posture** (for software/architecture): known-vulnerable versions, unnecessary privileges, overly broad network/file permissions — least privilege as the default question.
7. Findings here are **located and exploit-sketched** ("user-controlled `path` reaches `open()` at L142 without normalization → arbitrary read"), because a security finding without a concrete path gets argued instead of fixed.

## Part 8 — Maintainability and readability

The reader outnumbers the writer; review on their behalf:

1. **Comprehension cost is measurable — use your Pass A experience:** where did you have to re-read, hold three things in your head, or jump between distant locations to understand one behavior? Each such point is a maintainability finding with the evidence built in ("I needed L40, L200, and the config file to understand this branch").
2. **Change cost:** to make the *likely next change* (one more variant, one more field, one more rule), how many places must be touched, and would a newcomer find them all? Duplicated knowledge (the same rule in two places) is a future inconsistency with a date on it.
3. **Blast-radius legibility:** can a maintainer tell what's safe to change? Interfaces vs. internals distinguishable; invariants stated where they must be preserved; the *why* documented at the weird parts (the workaround, the magic constant, the deliberate suboptimality) — because undocumented weirdness gets "fixed" into a regression.
4. **Naming and structure tell the truth:** names describe behavior (a `validateUser` that also creates a session is a finding); structure matches the domain's shape; conventions match the surrounding corpus — consistency with the codebase/house style outranks the reviewer's personal aesthetics, and style opinions contradicting no standard are offered as optional or not at all (Part 9).
5. **Operational maintainability** (software/architecture): when this misbehaves at 3 a.m., what will the responder see? Logs/metrics at the failure points, errors that name their cause, health visible from outside.

## Part 9 — Identifying inconsistencies and prioritizing issues

**Inconsistency sweep** (mechanical, run across the whole artifact): terms — one name per concept throughout; numbers — every figure appearing twice agrees, totals sum, percentages add up; claims — the abstract/summary promises only what the body delivers, no section contradicts another; behavior — similar cases handled by similar means (two error paths, two styles = a finding); formatting — conventions uniform. Search-based checks beat eyeballing for all of these.

**Prioritization — every finding gets a severity, and the review leads with the highest:**

- **[Blocker]** — incorrect results, data loss/corruption risk, security vulnerability, breaks the stated requirements, or the approach cannot meet the intent. Approval is impossible while these stand.
- **[Major]** — significant defect with a workaround, missing important case, misleading documentation, serious maintainability trap. Fix before or immediately after ship, by explicit agreement.
- **[Minor]** — real but small: awkward structure, gaps in non-critical coverage, unclear naming. Batch-fixable; may ship.
- **[Nit/Optional]** — style preferences and polish, labeled as such, never repeated per-instance (state the pattern once), and never allowed to outnumber substance in visual weight.

Severity attaches to **consequence, not effort-to-fix nor certainty-of-the-reviewer**: a one-character fix to a boundary condition is a Blocker; a large refactor suggestion is Optional. When unsure whether something is a defect, file it as a **[Question]** — "what happens when X?" — which is honest, and routinely more effective than a wrong assertion.

## Part 10 — Communicating findings

1. **Structure the review as: verdict → summary → findings by severity → questions → nits.** The first three lines carry the decision (Part 11) and the top findings; nobody should excavate the Blocker from beneath twelve nits.
2. **Every finding in four parts** (standing rule 2): *location* (file:line, section, figure), *observation* (what is), *consequence* (what it breaks, costs, or risks — this is what makes it persuasive and prioritizable), *suggestion* (what better looks like — or an honest "I don't have a fix, but this can't stand as-is").
3. **Critique the work, never the author:** "this branch drops the error" not "you forgot"; questions phrased as genuine questions; and where the author's context might explain a choice, ask before asserting ("was returning early here deliberate? If so, worth a comment — if not, L88 never runs").
4. **Report what's good, specifically, when it's true** — not as padding but as information: the pattern worth repeating, the test that caught your attempted counterexample, the doc section that made review fast. Reviews teach in both directions.
5. **State the review's own limits** (from Part 1.2): what you verified by execution vs. reading, what you couldn't check, where you're outside your expertise. A review that hides its blind spots converts them into the author's false confidence.
6. **Right-size the channel:** approach-level concerns and anything potentially sensitive (security, "this whole design may be wrong") merit conversation before a written wall; line-level findings belong inline where they're actionable.

## Part 11 — Deciding whether work is ready for approval

The decision is explicit, criterion-based, and one of four:

- **Approve** — no Blockers, no Majors (or Majors resolved), the intent is met, and *you verified rather than assumed* the risky parts. Approval means you're personally satisfied it's fit for purpose: sign it as if your name ships with it, because it does.
- **Approve with conditions** — no Blockers; specific named Majors/Minors to be fixed, with the follow-up mechanism stated (who checks, when). Conditions vaguer than "fix X by Y" are rubber stamps with extra steps.
- **Request changes** — Blockers or unresolved Majors exist; each is filed per Part 10.2 so the path back to approval is concrete and finite. Re-review scope stated: full, or deltas-only.
- **Reject / escalate the approach** — Pass C concluded the approach cannot meet the intent, or the work solves the wrong problem. This verdict goes to a conversation, with the reasoning and the alternative (or the honest absence of one).

Decision rules: **unresolved Blockers make approval impossible regardless of pressure** — schedule pressure changes what gets descoped, never what gets waved through; **"I ran out of review time" yields "approved the parts I reviewed, listed here" — never a whole-artifact approval**; and if you cannot articulate what the work does and why it's correct, the honest verdict is Request Changes on clarity or a declared inability to review, not a shrugging approve.

---

## Artifact-type modules (deltas from the core method)

**Software (code review):** run it where possible — reviewed-by-reading is a declared limit. Priority order: correctness > security > tests > maintainability > style. Check the tests as hard as the code (do they fail without the change? cover the edges from Part 6?). Diff-focus but with blast-radius: read the *callers* of changed functions, not just the diff. Verify the change does what the description claims — no more (scope creep in diffs hides bugs), no less.

**Architecture:** review the *decision*, not just the diagram: were alternatives (including "do nothing") genuinely considered? Interrogate the -ilities against stated requirements — scale, failure modes (what happens when each box in the diagram dies?), data consistency across boundaries, operational story (deploy, migrate, roll back, observe). The killer question: *what requirement change would make this design wrong, and how likely is it?* Hidden assumptions (Part 4) dominate this artifact class.

**Technical documents (RFCs, reports, analyses):** verify the load-bearing numbers by re-derivation (Part 3.6); check every claim's classification — sourced, derived, or asserted-as-opinion — and flag asserted claims wearing sourced clothing. Walk the skim path; check conclusions follow from the presented evidence and the summary matches the body (Part 9's claims sweep).

**Research:** the central question — *does the evidence support the claims at the strength claimed?* Check: method actually tests the hypothesis; baselines/controls fair (strawman baselines are the field's favorite defect); data supports the effect size language; limitations section honest vs. ornamental; statistics used validly (multiple comparisons, p-hacking shapes, correlation-causation leaps); citations say what they're cited for (spot-check the load-bearing ones — miscitation rates are high everywhere).

**Designs (UX/visual/product):** review against the user and task, not personal taste: can the target user accomplish the core task — walk it step by step as that user? Check states the mockup skips: empty, loading, error, overflow-length content, smallest supported screen. Accessibility floor: contrast, keyboard paths, screen-reader sanity. Consistency with the established system beats novelty; deviations need reasons.

**Specifications:** the reader of a spec is an implementer who will build *exactly what it says* — review by attempted implementation: walk through building it and log every point where you had to guess (each guess is an ambiguity finding). Check testability (could a third party verify conformance?), modal-verb discipline (must/should/may used per stated convention), completeness of the lifecycle (Part 5.3), and that no two requirements conflict. A spec's edge cases (Part 6) are its main content — silence on an edge is a decision delegated, invisibly, to every implementer separately.

---

## Comprehensive final review checklist

Run before delivering any review verdict; every unchecked box is either resolved or explicitly declared as a limit of the review.

**Grounding**
- [ ] The work's intent stated in one sentence; review conducted against it + criteria, not against "how I'd do it"
- [ ] Requirements/criteria list obtained and walked item-by-item (Part 5.1)
- [ ] Depth of review matched to stakes; high-risk areas received the adversarial budget (Part 2.4)

**Detection**
- [ ] Comprehension pass completed before judgment; confusion points harvested as assumption/readability leads
- [ ] Logical-error hunt run by category (inference, conditions, ordering, quantifiers, circularity) on load-bearing reasoning
- [ ] Load-bearing calculations/derivations independently re-derived, not just read
- [ ] Hidden-assumption interrogation run: input provenance, environment, scale/time, failure-of-the-happy-path
- [ ] Completeness walked against lists: requirements, case space, lifecycle, promises/references, evidence coverage
- [ ] Edge-case sweep run: quantity, content, numeric, temporal, concurrency, sequence — "handled" spot-verified
- [ ] Security pass run at trust boundaries: injection shapes, authZ per-object, secrets, failure-open/closed, exposure-scaled
- [ ] Maintainability/readability assessed with evidence from the comprehension pass; likely-next-change cost considered
- [ ] Inconsistency sweeps run mechanically: terms, numbers, claims, behavior, formatting

**Judgment**
- [ ] Every finding has location, observation, consequence, suggestion — and a severity from consequence, not fix-effort
- [ ] Blockers/Majors verified (re-checked, reproduced, or re-derived) — not filed from first impression
- [ ] Uncertain findings filed as Questions, not assertions
- [ ] Nits labeled, batched, and outnumbered by substance in the review's visual weight

**Communication & verdict**
- [ ] Review leads with verdict and top findings; severity ordering enforced
- [ ] Tone check: work critiqued, author respected; genuine strengths noted specifically
- [ ] The review's own limits declared: what was executed vs. read, what couldn't be checked
- [ ] Verdict is one of the four, its conditions (if any) specific and owned
- [ ] The approval standard met: you could defend this verdict, finding-by-finding, to a third party — and would sign it with your name attached

---

## Worked micro-example (compressed)

Review request: "Approve this PR — adds bulk user import from CSV."

- **P1:** Intent restated: admins upload CSV → accounts created. Criteria gathered: ticket requires dedupe by email + a 10k-row limit. Stakes: writes to prod user table → correctness/security budget high.
- **P2A:** Comprehension pass; one confusion note: "why does `import_users` catch and continue on row errors?" — harvested for later.
- **P2B hunts:** *Logic:* dedupe uses `==` on raw email — case-sensitivity makes `Bob@` ≠ `bob@` → duplicate accounts. **[Blocker]**, verified by running the parser on a two-row case. *Assumptions:* CSV assumed UTF-8 — Excel exports often aren't; unhandled decode error aborts mid-import → *partial import with no rollback* (the lifecycle walk, P5.3, catches that halfway-failure leaves N users created, no record of which). **[Blocker]**. *Edge cases:* 10k limit enforced — but per-file, and the endpoint allows concurrent uploads (two-of-them test) → **[Major]**. *Security:* CSV values rendered in the admin result page unescaped → stored XSS via display name; exploit path sketched. **[Blocker]**. Comprehension note resolves into a finding: swallowed row errors are also *unlogged* → **[Major]** (operational blindness).
- **P9/P10:** Findings written location-observation-consequence-suggestion; one genuine strength noted (the streaming parser — memory-safe on big files — worth keeping through the fixes). Three nits batched, labeled optional.
- **P11:** Verdict: **Request changes** — three Blockers listed with concrete paths back; re-review scope: deltas + a rerun of the dedupe and XSS checks. Declared limit: "did not test against the real admin UI, only the template — XSS finding verified at the template level."

The signature of the method: every Blocker came from a directed hunt (a category sweep, a lifecycle walk, a two-of-them test) — none from vibes — and the verdict is a decision with a path, not a grade.
