---
name: codex-delegation
description: Orchestrate delegation to the Codex MCP tool and review what comes back. Use whenever work is about to be handed to Codex — "implement this", "have codex do it", "delegate to codex" — and always immediately before calling any mcp__codex__* tool, including follow-up calls inside an existing Codex session. Also use when evaluating, accepting, or sending revisions on output Codex has just returned. This skill owns the review pass and the sequencing; prompt construction belongs to the make-prompt-for-codex skill, and diagnosing repeated failures belongs to the debugging-methodology skill. Not for implementation Claude is doing itself, and not for other MCP tools or subagents.
---

# Codex Delegation

## The premise everything follows from

**Codex sees the prompt and the repository. Nothing else.**

No conversation history, no memory of a rejected approach, no idea which file was
pasted, no recollection of last week's refactor. Phrases like "that function," "the
approach we discussed," "like we did before," or "the existing pattern" arrive as
empty pointers.

Codex does not fail loudly on missing context. It fills gaps with plausible guesses and
returns confident, well-formatted, wrong work. The cost lands later, during review or
after merge, and always exceeds the cost of writing the prompt properly.

This holds for follow-up turns too. Even inside a live Codex session, restate the
constraint being violated rather than assuming earlier turns are still governing
behavior — attention to a constraint stated once decays over a long session.

Both halves of this skill rest on that premise: prompts must be built deliberately, and
review must assume nothing was inferred correctly.

---

## Deciding whether to delegate at all

Delegation is not the default for every implementation task — judge it every time,
before touching make-prompt-for-codex.

**The axis:** delegation cost (prompt construction + round-trip + review) against
implementation cost (the tokens and iteration Claude would burn writing it directly).
Delegate only when delegation cost is clearly lower, or total token spend is expected
to drop.

**Delegate — hand it to Codex:**
- The change spans multiple files, or is boilerplate-heavy.
- Requirements are already clear enough to implement in one pass, no exploration or
  back-and-forth needed first.
- The work needs a write → test → fix loop. Running that loop in Codex's own context
  avoids burning Claude's context on the iteration.
- The root cause of a bug is already identified and the fix itself is a substantial
  implementation.

**Handle directly — do not delegate:**
- Small changes: a few lines, a config tweak, a typo fix. The round-trip costs more
  than just making the edit.
- Requirements are still ambiguous and need a clarifying exchange with the user first.
  Re-judge with the criteria above once they're clear — don't delegate the
  clarification itself.
- The investigation phase of a bug. Diagnose first; only delegate the fix once found,
  and only if the fix itself is substantial enough to clear the bar above.
- Reviewing Codex's own output. That is always Claude's job, never Codex's.

**Workflow:**
1. On any implementation request, judge delegate-or-not against the criteria above.
2. If delegating: make sure requirements are settled, then build the prompt with
   **make-prompt-for-codex**.
3. Call `mcp__codex__codex` (or `codex-reply` for follow-ups) — the rest of this skill.
4. Review the response critically: design decisions, edge cases, security — see below.
5. If review fails: send Codex the feedback and let it re-implement. Never rewrite the
   output directly instead of sending it back.
6. If not delegating: implement directly, to completion, without a round trip.
7. Report the final result to the user.

**Why this matters:** without an explicit judgment step, delegation drifts toward one
of two failure modes — everything gets delegated regardless of size (paying the
round-trip tax on trivial changes), or nothing gets delegated because deciding feels
like its own overhead (defaulting to writing everything directly, even sprawling
multi-file work). The criteria above exist to make the token/time-efficient call the
reflexive one, not a matter of mood.

---

## The loop

Once delegation is the chosen path:

1. **Construct the prompt** → use the **make-prompt-for-codex** skill.
   `/Users/doiyuma/Documents/Claude/SKILLS/skills/make-prompt-for-codex/SKILL.md`
   Invoke it before every `mcp__codex__*` call — including follow-ups in an existing
   session, where a terse continuation is most tempting and least reliable. Don't
   re-derive a checklist or template here; that skill owns both.

2. **Call the tool.**

3. **Review the response** → the rest of this file.

4. **Accept, revise, or escalate.** Revision guidance is below. Repeated failure hands
   off to **debugging-methodology**.

---

## Reviewing the response

Review the diff, not the summary. Codex's prose describes what it intended; the diff
records what it did, and the two diverge in exactly the cases review exists to catch.

Write the review itself as tight, information-dense bullets — no scene-setting, no
restating the diff before critiquing it. Every criterion below is still checked every
round; only the prose describing the check gets terser.

### Review criteria

**Scope adherence**
- *Pass:* every changed file appears in Target Files. Nothing in Do Not Touch is
  modified, including whitespace and import reordering.
- *Fail:* any unlisted file is modified — even trivially, even improvingly. An
  unrequested import reorder in an untouched file is a fail, because it signals Codex
  treated the boundary as advisory, which means the rest of the boundary is also suspect.

**Non-goal violations**
- *Pass:* no work beyond the objective. Latent problems Codex noticed are *reported*,
  not fixed.
- *Fail:* the same bug fixed at other call sites, speculative caching, added
  configurability, docs updated, dependencies added.

**Completion criteria actually verified**
- *Pass:* each command was run and the actual output appears in the response.
- *Fail:* future or conditional tense — "the tests should now pass", "this should
  satisfy lint". That's a prediction. Treat unverified as failed, not as probably fine.

**Convention conformance**
- *Pass:* new code is indistinguishable in style from the named exemplar file — same
  error handling, naming, structure, test placement.
- *Fail:* a foreign pattern imported wholesale — throwing where the codebase returns,
  a new test directory, a different assertion library, a differently shaped module.

**Correctness against the stated objective**
- *Pass:* the diff implements what the Objective describes, including edge cases named
  in Context.
- *Fail:* it implements something adjacent — the happy path only, the general case when
  a specific one was asked for, a behavior the Context explicitly ruled out.

**Test quality**
- *Pass:* tests fail if the change is reverted. They assert on behavior, cover the
  cases named in Completion Criteria, and use real boundaries.
- *Fail:* tautological assertions, mocks so complete the test exercises only the mock,
  a single happy-path test where error cases were requested, or tests asserting on
  implementation details that will break on any refactor.

**Hidden behavior change**
- *Pass:* behavior outside the objective is identical.
- *Fail:* changed defaults, altered error messages other code matches on, changed
  ordering, tightened or loosened validation, modified public signatures. These are the
  most expensive misses because they pass tests and surface in production.

### Writing the revision message

A failed review is a prompt defect at least as often as a Codex defect. Before writing
feedback, identify which — if the constraint was never stated, restate it as a
constraint rather than as a correction.

**A revision message needs four things:**

1. **Which criterion failed**, named.
2. **Where**, specifically — file and function, or the exact line of the diff.
3. **The constraint that was violated**, restated in full. Not referenced. Codex's
   attention to a constraint stated once, many turns back, is unreliable.
4. **What done looks like**, as an observable — a command that passes, a diff that
   contains only the listed files, a behavior that holds.

Write it dense: short bullets, no preamble, no closing pleasantries. All four
components above must still appear in full for every failed criterion — this changes
form, not content.

Keep everything still-valid from the original prompt in force by restating it, and
say explicitly what to leave alone this time — including the parts that were correct,
which otherwise get "improved" during revision.

**Vague — do not send:**

> This isn't quite right, can you clean it up and try again? Also it touched some files
> it shouldn't have. Make sure it follows our conventions this time.

Nothing here is actionable. "Not quite right" names no criterion, "some files" names no
files, "our conventions" names no exemplar. Codex will guess at all three and will
regenerate broadly — including the parts that were already correct.

**Actionable — send this:**

> Two issues, both scope.
>
> 1. **Scope adherence.** The diff modifies `src/api/users/handler.ts` and
>    `src/api/orders/handler.ts`. Both are outside the target list and must be reverted
>    to their original state. Target files are exactly: `src/api/middleware/rateLimit.ts`
>    (new), `src/api/router.ts`, `src/config/limits.ts`.
> 2. **Completion criteria not verified.** The response says the tests should pass. Run
>    `npm test -- middleware` and `npm run typecheck`, and include the actual output.
>
> Everything in `rateLimit.ts` is correct — the sliding window implementation and the
> enterprise-exempt path both look right. Leave that file as is apart from any changes
> needed to revert the two handlers.
>
> Done means: the diff touches exactly the three target files, and both commands are
> shown passing.

Before re-sending, check the repository state. Failed rounds leave partial edits, and
revising on top of a half-applied change produces diffs nobody can review. Revert to
clean first.

---

## When review keeps failing

Hand off to **debugging-methodology**:
`/Users/doiyuma/Documents/Claude/SKILLS/skills/debugging-methodology/SKILL.md`

**Trigger signal:** the same criterion fails twice in a row, different criteria fail on
each round, or the failures concentrate on judgment rather than execution — the design
keeps coming back subtly wrong rather than mechanically wrong. Any of these means
another clarification round has poor odds, and the question is now diagnostic (why does
this keep failing?) rather than corrective. That's that skill's job, not this one's.

One round of failure is normal and doesn't warrant escalation — write the revision
message and re-send.

---

## Worked examples

Three fully worked scenarios (bug fix, multi-file feature, refactor) — each with the
prompt in force, a passing review, a failing review, and a full revision message — are
in `references/examples.md`. Read it when a concrete pattern to model against would
help; it is not required reading for every review.

---

## Quick reference

- Before delegating at all → weigh delegation cost against implementation cost (see
  "Deciding whether to delegate at all"). Small, unambiguous, or investigation-only
  work stays with Claude.
- Before any `mcp__codex__*` call → **make-prompt-for-codex**. No exceptions for
  follow-ups.
- On the response → review the **diff**, not the summary. Unverified means failed.
- On a revision → name the criterion, the location, the full restated constraint, and
  what done looks like. Say what to leave alone. Revert partial edits first.
- Same criterion failing twice, or failures about judgment rather than execution →
  **debugging-methodology**.
