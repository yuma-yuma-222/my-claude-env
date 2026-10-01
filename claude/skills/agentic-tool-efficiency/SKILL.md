---
name: agentic-tool-efficiency
description: >-
  An executable discipline for economical tool use and context-window
  management in agentic work: deciding whether a tool call is needed at all,
  batching independent calls in parallel, reading only the parts of files
  you need, filtering large outputs at the source, delegating heavy
  exploration to subagents, keeping state across long sessions, and reading
  errors before retrying. Load this skill whenever a task will take more
  than a handful of tool calls — codebase exploration, multi-file edits,
  data processing, long-running investigations — and whenever you notice
  context filling with raw dumps, repeated reads, or retries of the same
  failing call.
---

# agentic-tool-efficiency: Tool & Context Economy

Every tool call spends time and every result spends context. Context spent
on dumps and re-derivation is context unavailable for reasoning. This skill
governs how to buy the most evidence for the least spend.

## 1. Know what each call is for

1. Before any tool call, name (internally) the question it answers. If you
   cannot, don't make the call.
2. If the answer is already established in this session — from an earlier
   read, a tool result, or the user — use it. Never re-derive known facts.
3. Prefer the call that answers the question directly over the call that
   produces material you would then search by eye.

## 2. Parallelize independent calls

1. When the next calls do not depend on each other's results, issue them
   together in one response — multiple reads, searches, and status checks
   batch naturally.
2. Sequence calls only when a later call needs an earlier call's output.
3. Before each response with tool calls, ask: "does anything here depend on
   anything else here?" If no, batch it all.

## 3. Read surgically

1. For large files, locate first (search, grep, outline), then read only
   the relevant range. Do not read 2000 lines to use 30.
2. Do not re-read a file you just wrote or edited to "verify" the edit —
   the write would have errored if it failed. Re-open artifacts only for
   the final as-the-user-sees-it inspection before claiming completion.
3. Do not re-read files whose relevant content is already in context and
   unchanged.
4. Use dedicated file and search tools over shell equivalents (`cat`,
   `head`, `sed`, `find` pipelines) — they are structured, safer, and
   render better for the user.

## 4. Filter large outputs at the source

1. Anticipate output size before running. Commands that can flood context
   (logs, test suites, list operations, JSON APIs) get filters at the
   source: `head`, `grep`, `--max-count`, `jq`, `--quiet`, limits and
   pagination.
2. When a huge or truncated result arrives anyway, extract the needed facts
   into a short note immediately — then work from the note, not by
   re-scrolling the dump.
3. Never paste large tool output or file contents back into your own
   messages; reference the source and quote only the load-bearing lines.

## 5. Delegate heavy exploration

1. When a question requires sweeping many files or directories and you need
   only the conclusion — not the file contents — delegate to a search or
   exploration subagent if one is available, so the dumps land in its
   context instead of yours.
2. Delegate work products, not vague missions: state the question, the
   scope, and the form of the answer you need back.
3. Do not delegate what one or two direct calls would answer — spawning an
   agent that starts cold costs more than a targeted read.

## 6. Keep state across long sessions

1. For multi-step work, maintain a short written state block — goal,
   constraints, decisions, current step, open questions — and update it at
   milestones. After an interruption, compaction, or a large output,
   restate it before continuing.
2. Store intermediate results in scratch files, not in conversation
   text. Files persist and can be re-read selectively; conversation
   context degrades and truncates.
3. Re-read the original request before declaring completion — long tool
   sessions drift from the anchor.

## 7. Read errors before retrying

1. When a call fails, read the error before acting. The error usually names
   the fix; retrying blind discards that evidence.
2. Never retry an identical failed call verbatim. Change something the
   error implicates — arguments, path, tool, precondition — or run a
   diagnostic first.
3. Two failed attempts at the same approach means the third action must be
   a different approach or a diagnostic step, never the same move again.
4. A denied permission is the user declining that action — adjust course;
   do not re-request the same call unchanged.

## 8. Final check

Run when a tool-heavy stretch ends or feels effortful. Any "yes" to 1–3 or
"no" to 4 means stop and correct.

1. **Waste:** Am I re-reading, re-deriving, or dumping things already
   known?
2. **Serial drag:** Did I sequence calls that could have run in parallel?
3. **Blind retries:** Have I repeated a failing call without changing
   anything?
4. **Anchored:** Can I state the goal, current step, and remaining steps
   without scrolling back?
