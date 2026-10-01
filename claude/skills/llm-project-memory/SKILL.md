---
name: llm-project-memory
description: An executable system for maintaining long-term project memory across many working sessions, built on Markdown memory files (memory.md, project.md, decisions.md, changelog.md). Governs what deserves permanent storage versus what stays temporary, how to summarize completed work, preserve decisions, record assumptions, track open questions and technical debt, maintain project context, update memory files safely, prevent memory drift, and minimize redundancy. Load this skill at the start and end of every session on any multi-session project, whenever memory files exist in the workspace, and whenever you are about to rely on — or contradict — something remembered from a previous session.
---

# LLM Project Memory System

## Purpose

An LLM has no memory between sessions. Everything not written to disk is destroyed when the session ends — every decision's rationale, every dead end explored, every promise made. A project run across many sessions therefore lives or dies on its memory files: they are not documentation *about* the project; they **are** the project's mind. This procedure treats them accordingly.

The failure modes it targets are specific: **amnesia** (redoing solved work, re-exploring known dead ends), **relitigation** (reopening settled decisions because the rationale wasn't stored), **drift** (memory files that slowly diverge from reality until they're confidently wrong — worse than no memory at all), and **bloat** (files so long and redundant that future sessions can't afford to read them, which is amnesia with extra steps).

Standing rules:

1. **If it isn't in the files, it didn't happen.** Any knowledge worth keeping is written before session end. Any plan, promise, or discovery living only in the context window is scheduled for destruction.
2. **The files outrank recollection.** When what you "remember" (from training, from summaries, from inference) conflicts with what the files say, the files win until re-verified against reality.
3. **Reality outranks the files.** When the files conflict with the observable workspace (the code, the data, the artifacts), reality wins — and the files get corrected *in the same session the conflict is found*.
4. **Every write must serve a future read.** Memory files are written for a reader with zero context — usually you, next session, knowing nothing. Write for that reader or don't write.

---

## Part 1 — The file architecture

Four files, four jobs. Keep the set small; every additional file is another thing future sessions must know to read.

| File | Job | Mutability | Read when |
|---|---|---|---|
| `project.md` | What this project IS: objective, scope, constraints, architecture, conventions, key file map | Slow-changing; edited when facts change | **Every session start, in full** |
| `memory.md` | Current working state: now/next/blocked, open questions, assumptions, tech debt, active warnings | Fast-changing; edited every session | **Every session start, in full** |
| `decisions.md` | Why things are the way they are: append-only log of significant decisions with rationale and rejected alternatives | Append-only (supersede, never delete) | On demand: before changing anything covered by a decision |
| `changelog.md` | What happened: append-only, per-session summaries of completed work | Append-only | On demand: when history matters ("when did X change?", "was Y tried?") |

Design properties that make this work:

1. **The hot set is small.** `project.md` + `memory.md` together stay under roughly 300 lines combined, so reading both at session start is always affordable. The append-only files may grow; they're consulted, not re-read.
2. **One home per fact.** Every kind of information has exactly one file that owns it (Part 11). Cross-reference by pointer ("see decisions.md#D-014"), never by copying.
3. **Anchors everywhere:** decisions get IDs (`D-001`), questions (`Q-003`), assumptions (`A-002`), debt items (`TD-005`), changelog entries dates. Pointers need targets.
4. If the project already has memory files under different names or shapes, **adopt the existing system** — consistency with an established convention beats this template. Map the four jobs onto whatever exists; create missing pieces only when no file owns that job.

## Part 2 — What deserves permanent storage

Store permanently (the test: *would next session act differently, or waste time, without this?*):

1. **Identity facts** → `project.md`: the objective in one paragraph; what's explicitly out of scope; hard constraints (deadlines, must-integrate-withs, quality floors); the architecture in a dozen lines; conventions chosen (naming, style, patterns); a map of the key files/directories and what lives where; how to run, test, and deploy.
2. **Decisions with teeth** → `decisions.md`: anything that (a) was genuinely contested or (b) will look arbitrary or wrong later without its reasoning. Schema per entry: `ID | date | decision | why | alternatives rejected (and why) | status (active/superseded-by-D-NNN)`.
3. **Load-bearing assumptions** → `memory.md` (registry section): beliefs the work currently rests on that haven't been verified — each with what happens if it's false, and how/when it could be checked (Part 6).
4. **Dead ends with epitaphs** → `changelog.md` at the session they died, plus a pointer in `decisions.md` if the rejection was a real decision: "tried X for Y; failed because Z" in one or two lines. This is among the highest-value memory there is — re-walking a dead end costs a whole session.
5. **Unresolved questions and owed follow-ups** → `memory.md` (Part 7), and **technical debt** → `memory.md` (Part 8).
6. **Standing warnings**: the fragile module, the test that must run before any schema change, the API that rate-limits — the "things that will bite you" list → `memory.md`, kept short and current.

## Part 3 — What should remain temporary

Do NOT write into memory files (the test: *is this reconstructible, superseded, or session-local?*):

1. **Anything reconstructible from the workspace faster than it can be read**: file contents, directory listings, function signatures. The code is the source of truth about the code; memory files record what code *can't* say — intent, rationale, warnings.
2. **Intermediate reasoning and exploration transcripts**: the fifteen queries tried before the right one. Store the conclusion (and the epitaph if a path died); discard the journey.
3. **Superseded state**: yesterday's "next steps" once done, fixed bugs' details (one changelog line suffices), old versions of plans. Superseded state in a *current-state* file is drift fuel (Part 10) — it moves to the changelog (as history) or gets deleted.
4. **Full tool outputs, logs, stack traces**: store the one-line finding plus, if bulky evidence matters, a pointer to an artifact file (`artifacts/2026-07-07-loadtest.txt`) — never paste bulk into the hot set.
5. **Emotional narration and progress commentary** ("this was tricky!", "great progress today"): zero value to the next reader; pure bloat.

Boundary rule: when unsure whether something is permanent, ask standing rule 4's question — *what will the future reader do with this?* No answer → temporary.

## Part 4 — Session rituals (when memory is read and written)

**Session start (before any work):**
1. Read `project.md` and `memory.md` in full.
2. Read the last 1–2 entries of `changelog.md` (what just happened).
3. **Spot-verify against reality** (standing rule 3, drift defense): check 2–3 verifiable claims from `memory.md` — does the branch exist, does the test still fail, is the blocker still blocked? Pick the claims today's work will lean on.
4. State the session's intent in one or two lines — which items from Now/Next, toward what.
5. Consult `decisions.md` **before** modifying anything a decision covers (search by the area you're touching).

**During the session:**
6. Write discoveries *when discovered*, not at session end: a dead assumption, a new constraint, a decision made — capture in the moment (a scratch note suffices) so the end-of-session write isn't reconstructing from a fading context window.

**Session end (never skipped — budget the last minutes for it):**
7. Append the changelog entry (Part 5's format).
8. Update `memory.md`: Now/Next/Blocked rewritten to be true; questions, assumptions, debt, warnings updated; anything resolved *removed* (not marked "done" and left — see Part 10).
9. Update `project.md` and `decisions.md` only if identity facts changed or decisions were made.
10. Re-read the diff of what you wrote as the zero-context future reader: can they resume from this alone? Fix what fails that test.

An interrupted session that skipped step 7–8 is repaired at the *next* session's start: reconstruct what's recoverable from the workspace, log the gap honestly in the changelog ("session of DATE ended without handoff; state reconstructed from workspace").

## Part 5 — Summarizing completed work

Changelog entries compress a session into what the future needs. Format:

```markdown
## 2026-07-07 — Session 14
**Did:** Implemented CSV import dedupe (case-insensitive email); fixed partial-import
rollback (imports now transactional). Tests: 12 added, all green.
**Learned:** Legacy exports are sometimes latin-1, not UTF-8 → decode fallback added;
assumption A-003 (all-UTF-8) is DEAD, removed from registry.
**Decided:** D-009 — dedupe at ingestion, not query time (see decisions.md).
**Dead ends:** Tried pandas chunked read for streaming — 4× memory of csv module on
our shape; abandoned.
**Next:** Wire the 10k row limit per-account (not per-file) — see Q-006 first.
```

Rules: **outcomes over activity** ("implemented and tested X", never "worked on X"); **learned-line is mandatory** — it's where assumption deaths and reality's surprises are captured, and it's the changelog's most valuable line; **link, don't restate** (decisions by ID); five to ten lines per session as the norm. When a multi-session phase completes, write a one-paragraph **phase summary** at its end in the changelog and update `project.md` if the phase changed identity facts — the phase summary is what lets future readers skip the per-session entries.

## Part 6 — Recording assumptions

Assumptions are the memory type most often lost and most expensive when lost — work built on an unrecorded assumption fails mysteriously when the assumption dies.

1. Registry lives in `memory.md`:
```markdown
### Assumptions (unverified beliefs the work rests on)
- A-004: Vendor API sustains our peak volume (10 rps). If false: need queue+backoff
  redesign. Verify: load test before M3. [added S-11]
```
2. **Capture at the moment of assuming** — the tell is the phrase "presumably", "should be", "I'll assume" appearing in your work. Each occurrence either gets verified now (cheap) or registered.
3. Every entry carries: the belief, **the blast radius if false**, and **the verification path** (how it could be checked, and by when it must be).
4. **Assumptions expire in one of two ways only:** verified → the fact moves to `project.md` (if identity-grade) or just gets removed (if now-moot), with the verification noted in the changelog; falsified → removed from the registry, death recorded in the changelog's Learned line, and dependent work re-examined (list what was built on it before continuing).
5. An assumption registry that only grows is a warning sign: verification work isn't being scheduled. Oldest unverified assumptions get review at each phase boundary.

## Part 7 — Documenting unresolved questions

1. Registry in `memory.md`:
```markdown
### Open questions
- Q-006: Is the 10k import limit per-file or per-account? Blocks: rate-limit task.
  Owner: PM (asked 2026-07-03, chase 07-10). Default if unanswered: per-account
  (conservative).
```
2. Each question carries: what it blocks (a question blocking nothing is a curiosity — changelog it and drop it from the hot set), who can answer it, when it was asked / when to chase, and **the default** that will be taken if no answer arrives — recording the default converts an open question from a stall into a scheduled decision.
3. Questions close by answer (→ often becomes a `decisions.md` entry or a `project.md` fact; removed from the registry) or by default-taken (→ logged as a decision: "D-012: proceeded per-account by default; Q-006 unanswered by deadline").
4. Never let a question be answered *implicitly* by work: if the code now embodies an answer, the question closes explicitly with the answer recorded, or the discrepancy is flagged.

## Part 8 — Tracking technical debt

1. Registry in `memory.md`:
```markdown
### Technical debt
- TD-002: Import errors logged but not surfaced to admin UI. Cost: silent partial
  failures, support burden. Trigger to repay: before GA, or first support ticket.
  Size: S. [taken S-12, deliberately — speed for demo; see D-008]
```
2. Debt is recorded **at the moment it's taken**, with: what shortcut, what it costs while it lives, **the repayment trigger** (an event, not "someday"), rough size, and whether it was deliberate (pointer to the decision) or discovered.
3. Distinguish *deliberate* debt (a decision — gets a `D-` entry with the tradeoff) from *discovered* debt (found, not chosen — registry only). Both are legitimate; only unrecorded debt is a lie.
4. Review the registry at phase boundaries: repay what's triggered, re-justify what's kept, delete what's moot. Debt items also expire honestly — "we're never fixing this and that's accepted" is a decision (`D-` entry), better than an eternal registry entry pretending otherwise.

## Part 9 — Maintaining project context

`project.md` is the context that makes every other file interpretable. Keep it answering, at all times, the zero-context reader's first questions:

1. **What is this and why** (objective paragraph; out-of-scope list — the scope-creep fence).
2. **What's true and immovable** (constraints, quality floors).
3. **How it's shaped** (architecture in ~a dozen lines; the 5–10 key files/dirs and their jobs — a *map*, not a mirror; it points at the code rather than duplicating it).
4. **How we work here** (conventions: style, patterns, test expectations, "always run X before Y").
5. **Where we are** (current phase/milestone, one line — the only fast-changing line in the file).

Update it **when identity facts change** — a constraint added, architecture reshaped, a convention adopted — in the same session the change happens, with a changelog line noting the update ("project.md: architecture section updated per D-011"). A `project.md` that still describes last month's architecture fails standing rule 3 and poisons every session that reads it.

## Part 10 — Preventing memory drift

Drift — files diverging from reality — is the system's fatal disease, because drifted memory is *trusted* and wrong. Defenses, all mandatory:

1. **Trust-but-verify at session start** (Part 4.3): spot-check the claims today's work leans on. A failed spot-check triggers a repair pass on the affected section before work proceeds.
2. **Single home per fact** (Part 11): duplicated facts drift independently; the copy you update is never the copy the next session reads. Deduplication is drift prevention, not tidiness.
3. **Current-state files contain only current state:** nothing in `memory.md` is "done", "obsolete", or "old — ignore". Done things move to the changelog; dead things are deleted (their history is safe in the append-only files — deletion from the hot set loses nothing).
4. **Immediate correction rule** (standing rule 3): any observed file-vs-reality conflict is fixed in the session that observes it, and the correction is changelogged ("memory.md claimed the migration was applied; staging shows otherwise — corrected, cause unknown, added Q-009"). Deferring corrections is choosing drift.
5. **Date-stamp the perishable:** claims that rot ("vendor API is in beta", "team said X") carry their observation date; a future reader can judge staleness. Identity facts don't need dates; status facts do.
6. **Periodic reconciliation:** at phase boundaries, walk `memory.md` line-by-line against the workspace — every claim verified, corrected, or deleted. Budget for it; it's cheaper than one session misled.

## Part 11 — Minimizing redundant information

Bloat is a read-tax charged to every future session; redundancy is drift waiting to happen. Enforcement:

1. **One home per fact** (the ownership table in Part 1): rationale lives in `decisions.md`; history in `changelog.md`; current state in `memory.md`; identity in `project.md`. Anything appearing in two files becomes a pointer in one of them, same session it's noticed.
2. **Point at the workspace instead of mirroring it:** "schema: see `db/schema.sql`" beats a pasted schema that will be false by Friday. Memory files store what the workspace *can't* express — intent, rationale, warnings, plans — and pointers to everything else.
3. **Compress on a schedule, not on impulse:** at phase boundaries, per-session changelog entries older than the phase collapse under the phase summary (Part 5) — the detail is in version control's history of the file if it's ever truly needed; `memory.md` registries get their periodic reconciliation (Part 10.6); `decisions.md` never shrinks but superseded entries get their status flipped so readers stop at "superseded-by-D-NNN".
4. **Hot-set budget is enforced, not aspirational:** when `project.md` + `memory.md` push past the readable budget (~300 combined lines as the default), the response is compression/eviction per the rules above — not "read less of it", which is amnesia by increments.
5. **Write density check at session end** (Part 4.10): each line you're adding — will the zero-context reader *act* on it? Lines that only narrate get cut before commit.

---

## Quick-reference: where does this go?

| You have… | It goes to… |
|---|---|
| A decision with a rationale worth keeping | `decisions.md` (new ID) + one changelog line |
| Work completed this session | `changelog.md` **Did:** line |
| A surprise, a dead assumption, a new constraint discovered | `changelog.md` **Learned:** + update `memory.md`/`project.md` accordingly |
| A belief you're building on but haven't verified | `memory.md` Assumptions (A-ID, blast radius, verification path) |
| A question you can't answer now | `memory.md` Open questions (Q-ID, blocks, owner, chase date, default) |
| A shortcut taken | `memory.md` Tech debt (TD-ID, cost, repayment trigger) + `D-` entry if deliberate |
| A path tried and abandoned | `changelog.md` **Dead ends:** epitaph (1–2 lines) |
| What to do next session | `memory.md` Now/Next — decided now, while context is warm |
| A fact the code already expresses | Nowhere — point at the code if a pointer helps |
| Progress commentary, exploration transcript | Nowhere |

## Session-end checklist (run every session, no exceptions)

- [ ] Changelog entry appended: Did / Learned / Decided / Dead ends / Next — outcomes, not activity
- [ ] `memory.md` Now/Next/Blocked rewritten to be *currently true*; resolved items removed, not annotated
- [ ] New assumptions, questions, debt registered with their required fields (blast radius / default / trigger)
- [ ] Dead assumptions and closed questions removed from registries, deaths recorded in Learned
- [ ] Decisions made this session in `decisions.md` with rationale and rejected alternatives
- [ ] `project.md` updated if any identity fact changed
- [ ] No fact now lives in two places; no bulk output pasted into the hot set
- [ ] Hot set still within budget; compressed if not
- [ ] Final read of the diff as the zero-context reader: resumable from files alone?

---

## Worked micro-example (two sessions, compressed)

**Session 12 (end):** changelog entry: *Did:* CSV importer streaming parser done, tested to 50k rows. *Learned:* Excel exports arrive latin-1 → **A-003 (all-UTF-8) is DEAD**; decode fallback needed. *Decided:* D-008 — ship demo with import errors logged-not-surfaced (deliberate debt → TD-002, trigger: before GA). *Dead ends:* pandas chunked read, 4× memory, abandoned. *Next:* decode fallback first (A-003 fallout), then dedupe. `memory.md`: A-003 removed; TD-002 added; Now = decode fallback.

**Session 13 (start):** reads `project.md` + `memory.md` (40 seconds of context, not 40 minutes of archaeology). Spot-verify: does the importer branch exist, do the 50k-row tests pass? Yes and yes — memory is sound. Intent stated: decode fallback per Now. Mid-session, a teammate's note suggests "just use pandas chunking for this" — **changelog's dead-end epitaph from S-12 answers it in one line, no re-exploration.** Before touching error handling, `decisions.md` search surfaces D-008 — the logged-not-surfaced behavior is deliberate, not a bug to "fix"; relitigation avoided. Session end: ritual runs; Q-006 (limit per-file or per-account?) registered with a chase date and a conservative default.

The signature of the system: session 13 spent its budget on new work, because everything session 12 knew — including what *didn't* work and *why* things are the way they are — was waiting in four small files.
