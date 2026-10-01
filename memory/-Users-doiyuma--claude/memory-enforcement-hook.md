---
name: memory-enforcement-hook
description: "A global Stop hook now forces at least one MEMORY.md touch per session in every project, instead of leaving it to model judgment"
metadata: 
  node_type: memory
  type: project
  originSessionId: a97dd0ea-0d28-44b9-99c7-6b688ae289a3
  modified: 2026-09-11T05:04:59.195Z
---

A `Stop` hook in `~/.claude/settings.json` blocks Claude from ending a response until the current project's auto-memory `MEMORY.md` (`~/.claude/projects/<sanitized-cwd>/memory/MEMORY.md`) has been touched at least once in that session. Per-session state (so it only blocks once, not every turn) is tracked via marker files in `~/.claude/.session-memory-state/<session_id>.start` / `.done`.

**Why:** User asked (2026-09-11) whether MEMORY.md gets saved every session, and wanted this guaranteed rather than dependent on the model deciding something was worth saving. Chose global scope (applies to every project, not just this one) and hard-block enforcement over a soft end-of-session reminder.

**How to apply:** Don't disable, weaken, or bypass this hook without asking the user first — it was explicitly requested as a deliberate constraint on the model's own behavior. If a session has nothing memory-worthy, the hook's own reason message says a one-line "nothing notable this session" note is an acceptable way to satisfy it — don't invent padding content just to pass the check.
