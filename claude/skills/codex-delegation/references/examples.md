# Codex Delegation — Worked Examples

Three fully worked scenarios (bug fix, multi-file feature, refactor) — each with the
prompt in force, a passing review, a failing review, and a full revision message.
Referenced from the main [SKILL.md](../SKILL.md) `## Worked examples` section.

Each scenario below shows what passing and failing review look like against a prompt
already built via make-prompt-for-codex. Scenario details are given only as far as
review needs them — the constraints being checked against.

### Example 1 — Bug fix, single file

*Prompt in force:* fix an intermittent 500 in `src/api/middleware/rateLimit.ts` where a
first-time API key with no usage record hits a throw. Target files: `rateLimit.ts` and
its test file. `src/services/quotaStore.ts` is do-not-touch — its throw-on-missing
behavior is intentional. Non-goal: the identical latent bug in `src/jobs/quotaReport.ts`
and `src/admin/usage.ts`, deliberately left for next sprint's replacement.

*Passing review:* the diff touches only `rateLimit.ts` and its test; the catch is
narrowed to `NotFoundError`; a new test confirms a `quotaStore` connection error still
surfaces as a 500, and it fails if the catch is widened; command output is pasted.

*Failing review:* the diff also fixes `quotaReport.ts` — a non-goal violation, and a
fail even though the fix is correct. Or the catch is a bare `catch` returning zero on
any error: it passes the missing-record test while silently converting connection
failures into wrong quota decisions. That second one is a hidden behavior change — tests
pass, production breaks — and is the more dangerous of the two precisely because it
looks clean.

*Revision message:*

> **Hidden behavior change** in `rateLimit.ts`, the catch around the `quotaStore.get`
> call. It's a bare `catch` treating every error as zero usage. The constraint: catch
> `NotFoundError` specifically. A broad catch swallows the store's connection errors,
> which must keep propagating as 500s — a connection failure silently becoming "zero
> usage" gives every caller unlimited quota.
>
> **Non-goal violation:** the diff also modifies `src/jobs/quotaReport.ts`. Revert it.
> That file has the same bug on purpose — it's being replaced next sprint. Target files
> are exactly `src/api/middleware/rateLimit.ts` and
> `src/api/middleware/__tests__/rateLimit.test.ts`.
>
> The missing-record test is good; keep it as written.
>
> Done means: `git diff --stat` shows those two files only, the catch is typed to
> `NotFoundError`, and a test asserts a connection error still yields a 500 — that test
> must fail if the catch is widened back.

### Example 2 — New feature across multiple files

*Prompt in force:* webhook delivery for `order.created` and `order.shipped`. Context
established that a queue-backed implementation was **rejected** (no infra budget this
quarter) in favor of in-process retry with exponential backoff at 1s/4s/16s, three
attempts, 5-second per-attempt timeout, fire-and-forget so delivery never fails the
order operation.

*Passing review:* the approach summary states 1s/4s/16s backoff before any code, so it's
checkable against Context immediately. All five required test cases are present, and the
order-not-failed test genuinely fails if error containment is removed. Changes to
`orders.ts` are limited to two call sites.

*Failing review:* the retry loop is correct, but the summary mentions "a small in-memory
queue for pending deliveries". A queue was explicitly ruled out and has been reintroduced
under another name — this is the characteristic failure, because the rejected design is
usually the obvious one. Separately: the tests mock `httpClient` so completely that the
timeout is never exercised; the timeout test asserts the mock was *called with*
`timeoutMs: 5000` rather than that a slow endpoint is abandoned. That test passes even if
the timeout is never enforced.

*Revision message:*

> **Correctness against objective.** `src/webhooks/deliver.ts` introduces a pending-
> delivery queue. Remove it. A queue-backed implementation was ruled out — it needs
> infrastructure we don't have budget for this quarter, and that applies to an in-memory
> queue too, not just a broker. Deliver inline: attempt, back off 1s/4s/16s, three
> attempts, then log and give up. No pending-state structure between calls.
>
> **Test quality.** `deliver.test.ts` asserts `httpClient.post` was called with
> `timeoutMs: 5000`. That verifies the argument, not the behavior — it passes whether or
> not the timeout does anything. Replace it with a test using an endpoint that never
> resolves, asserting the attempt is abandoned and the retry proceeds.
>
> The backoff schedule and the fire-and-forget containment in `orders.ts` are both
> correct — leave those alone.
>
> Done means: no queue or pending-set in the diff, `npm test -- webhooks orders` shown
> passing, and the timeout test fails if the timeout is removed from the client call.

### Example 3 — Refactor

*Prompt in force:* route four `src/reports/` modules through the existing `QueryBuilder`,
with **byte-identical generated SQL** as a hard requirement — these queries are
performance-tuned against known plans on very large tables. `src/db/queryBuilder.ts` is
do-not-touch. The prompt's If Blocked instruction: if the builder can't produce identical
SQL, stop and report which module and which construct.

*Passing review:* before/after SQL shown per module and identical; one module reported as
blocked on a window-function construct the builder can't express, the other three
complete. Partial completion with a clear blocker is the correct outcome — the If Blocked
instruction did its job, and pushing for four-of-four would have meant accepting changed
SQL.

*Failing review:* all four converted, with a note that one query's SQL is "semantically
equivalent but formatted slightly differently by the builder". That's a fail against the
hard requirement, and the note's casual framing is part of the failure. Also failing:
`queryBuilder.ts` gained a method to support the fourth query — a do-not-touch violation
that additionally puts new untested code in a file every report depends on.

*Revision message:*

> **Do Not Touch violation.** The diff adds `whereRaw()` to `src/db/queryBuilder.ts`.
> Revert that file completely. It's shared by every report and analytics module; new
> untested code there is a much larger risk than the refactor itself.
>
> **Correctness against objective.** `src/reports/cohorts.ts` produces SQL described as
> semantically equivalent but formatted differently. That's a fail — byte-identical
> output is the hard requirement, whitespace included. These queries are tuned against
> known plans on tables in the hundreds of millions of rows, and we're not re-validating
> plans as part of a readability refactor.
>
> `cohorts.ts` is the blocked case: revert it and report which construct `QueryBuilder`
> can't express. Three-of-four converted with one blocker is the expected outcome here.
>
> `revenue.ts`, `usage.ts`, and `churn.ts` all show identical SQL — leave them exactly as
> they are.
>
> Done means: `queryBuilder.ts` unchanged in `git diff`, `cohorts.ts` unchanged, the
> other three showing identical before/after SQL, and `npm test -- reports` passing.

