---
name: self-improvement-loop
description: >-
  An executable loop that makes this skill system improve itself: capture
  lessons when work produces a surprise (a user correction, a failed
  attempt, a discovered workaround, an unrecorded preference), record
  them in lessons.md with a generalized rule, count recurrences, and at
  three occurrences graduate the lesson into a skill edit or a new skill
  via skill-creation-methodology. Load this skill at the END of any
  substantive task to run the capture check, at the START of a task to
  scan relevant lessons, whenever the user corrects you or says
  「違う」「またそれ」「前も言った」, whenever you notice the same class
  of mistake or the same successful trick twice, and on any request like
  「振り返って」「反省して」「改善して」「学習させて」. Project-specific
  facts belong to llm-project-memory; this skill owns lessons about how
  the SYSTEM should behave.
---

# Self-Improvement Loop

A skill library that never changes after deployment slowly rots: the
same mistakes recur, the same workarounds get rediscovered, and user
corrections evaporate at session end. This skill closes the loop —
execution feeds back into the skills themselves — so the system gets
better every time it is used, without waiting for a human to notice a
pattern.

The design has two opposing failure modes, and every rule below guards
one of them: **amnesia** (lessons never captured, or captured and never
read) and **noise** (a diary of trivia that buries the few lessons that
matter, or skills overfitted to single incidents).

## 1. The loop at a glance

```
task ends → capture check → lessons.md entry (with generalized rule)
                                  │ same pattern recurs
                                  ▼
                     occurrences reaches 3 → GRADUATE:
                     edit the owning SKILL.md, or create a new skill
                     (via skill-creation-methodology) → validate.sh
                     → mark lesson as graduated
```

`lessons.md` lives at the repository root, next to AGENTS.md.

## 2. When to capture (and when not to)

Run this check at the end of every substantive task. Capture a lesson
ONLY if at least one of these fired — **no surprise, no lesson**:

1. The user corrected the output or the approach ("違う", "そうじゃなくて",
   a redo request, an edit that reverses your choice).
2. Verification caught a real error before delivery.
3. An approach failed twice before a different one worked — the working
   approach and the dead end are both lessons.
4. You discovered a workaround, environment quirk, or non-obvious
   procedure that took real effort to find.
5. The user expressed a lasting preference that no skill or memory file
   records.
6. A skill misfired: the wrong skill triggered, a needed one didn't, or
   a skill's instruction was wrong or ambiguous in practice.

Do NOT capture: routine successes, one-off facts about a specific
project (those go to memory.md under `llm-project-memory`), or anything
already covered by an existing skill rule — if a skill already says it
and you didn't follow it, the lesson is about *triggering*, not content.

## 3. How to write a lesson

Before writing, search lessons.md for the same pattern. If an entry
already covers it, increment its `occurrences`, update `last_seen`, and
add one line of context — do not write a duplicate. Duplicates destroy
the counting that drives graduation.

Entry format (10 lines maximum — the rule matters, the story doesn't):

```markdown
## L-007 | pattern: premature-completion-claim
- first_seen: 2026-07-10 / last_seen: 2026-07-10 / occurrences: 1
- status: active            # active | graduated | archived
- context: claimed a script worked without running it; user found it broken
- root_cause: skipped verification because the change "looked trivial"
- rule: no completion claim without executing the artifact, even for
  one-line changes — triviality is judged after running, not before
- owner_skill: claude-fable §7   # or "none" if no skill owns this yet
```

Writing discipline:

- The `rule` must be the *generalized* class, not the incident. Ask:
  what family of situations does this represent? ("check units on
  column C" → "verify units before any cross-column computation").
- The `pattern` tag is how future sessions find it — use a stable,
  searchable phrase.
- If the lesson is a user preference, confirm scope with the user
  before recording it as permanent ("いつもこの形式にしますか？") —
  preferences are user-owned decisions.

## 4. When to read lessons

- At the start of any substantive task, after selecting skills: scan
  lessons.md `pattern` tags and `owner_skill` fields for entries
  matching the task type. Treat matching active lessons as binding
  instructions for this task.
- A lesson at 2 occurrences is a warning shot: mention it in your plan
  explicitly ("known failure mode here: X — mitigating by Y").

## 5. Graduation (the self-improvement step)

When an entry's `occurrences` reaches 3 (failures or successes alike):

1. Decide the destination:
   - An existing skill owns this territory → add the rule to that
     SKILL.md, phrased per `skill-creation-methodology` Section 5
     (imperative, with the why, with thresholds). Usually it belongs in
     the skill's tripwires or self-check.
   - No skill owns it and the pattern is a recurring task class → create
     a new skill via `skill-creation-methodology` in full.
   - It's about skill *selection* (wrong skill fired) → fix the
     description frontmatter or the AGENTS.md routing table instead.
2. Run the skill-creation quality gates on the edit — especially the
   overfitting check: would this rule have helped in situations *other*
   than the three observed? If it only fits the incidents, generalize
   further before writing.
3. Run `bash scripts/validate.sh`.
4. Update the lesson: `status: graduated`, note the destination
   (`→ debugging-methodology §5`). Keep the entry — it is the audit
   trail for why the skill says what it says.
5. Tell the user in one line what was learned and where it went. Skill
   edits change future behavior everywhere; they should never be silent.

Never graduate on a single incident, however painful — a rule written
from one data point encodes the incident, not the pattern. If something
is urgent enough to fix immediately, ask the user to confirm the edit
instead of waiting for three occurrences.

## 6. Hygiene (prevent the diary failure mode)

- Keep at most ~30 `active` entries. When the count exceeds that, the
  least valuable entries (single occurrence, >3 months since
  `last_seen`) move to `status: archived` in a section at the bottom.
- An entry untouched for 6 months with `occurrences: 1` gets archived —
  one-time flukes are not lessons.
- Never let a lesson restate `claude-fable` doctrine or an existing
  skill rule verbatim; reference it instead ("see claude-fable §9") or
  record only the *delta*.
- Monthly (alongside the validate.sh maintenance pass): scan for
  entries at 3+ occurrences that were never graduated, and near-
  duplicate patterns that should merge.

## 7. Self-check

1. Did I run the capture check at task end, and capture only genuine
   surprises?
2. Did I search for an existing entry before writing a new one?
3. Is the recorded rule the generalized class, ≤10 lines, with a
   searchable pattern tag?
4. Did any entry hit 3 occurrences — and if so, did I graduate it
   (skill edit + validate.sh + status update) rather than let it sit?
5. Were user-preference lessons confirmed with the user, and skill
   edits announced in one line?
6. Is lessons.md still ≤30 active entries?

Any "no" sends you back to the numbered section that owns it.
