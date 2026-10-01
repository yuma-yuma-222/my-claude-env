---
name: note-session-log
description: >-
  Writes a Japanese Markdown session note into the current project,
  capturing what the user wanted, what was tried, where it got stuck,
  and the outcome — raw material for note.com articles about working
  with Claude Code. Runs as a standing behavior (part of the Mandatory
  Loop's end-of-task steps in AGENTS.md), not something the user needs
  to ask for each time, and applies in every project. No separate LLM
  call is spawned — the currently running Claude writes the note itself
  as part of its normal final output, so it costs nothing beyond the
  session already in progress. Load this whenever a nontrivial task is
  wrapping up, to decide whether to create or update a note file, and
  to follow the note's structure and naming convention.
---

# Note Session Log

Material for a note.com article decays fast: by the next session, the
specific dead ends, the exact error messages, and the "why did we try
that" are gone. This skill's job is to capture them at the moment a
piece of work concludes, before they evaporate — cheaply, using the
output the current turn is already generating rather than a separate
paid call.

## When to write a note

At the end of any nontrivial task (the same bar `self-improvement-loop`
uses: more than a couple of tool calls, some back-and-forth, a bug
chased, a design decided) — not for one-line answers or trivial
lookups. This check runs standing, in every project, without the user
asking for it by name.

If the conversation is one long continuous piece of work, don't spawn a
file per turn — update the same file as the work continues. Start a new
file when the topic changes or a new day begins.

## Where it goes

Inside the current project's working directory (the `cwd` for this
session), under:

```
.claude/session-notes/YYYY-MM-DD_HHMM_<short-kebab-slug>.md
```

Create the directory if it doesn't exist. If the project is a git repo
and `.claude/session-notes/` is not already tracked or ignored, mention
to the user once that they may want to add it to `.gitignore` (personal
working notes, not something teammates need) — but don't block on it or
edit their `.gitignore` without asking.

If `cwd` is not inside a git repo, still write the note there under the
same relative path — the convention doesn't depend on git. Special
case: if `cwd` *is* `~/.claude` itself (global config, not a project),
there's no nested project `.claude/` to put notes under — write
directly to `~/.claude/session-notes/` instead of doubling the
`.claude` segment.

## Note structure

Write in Japanese (this is note.com article material). Use this
template; omit a section only if genuinely empty (e.g. no real
struggle happened):

```markdown
---
project: <project directory name>
date: <YYYY-MM-DD>
started: <HH:MM, if inferable from the conversation, else omit>
duration_estimate: <rough estimate like "約40分", or "不明" if timestamps aren't available>
---

# <一言タイトル：何をした回か>

## やりたかったこと
ユーザーが本当に達成したかったこと。表面的な依頼文だけでなく、その背景・目的も一言添える。

## やったこと
実際に行った作業を時系列で。技術的な詳細は必要な分だけ（後で記事にする時に要約しやすい粒度）。

## 躓いた点・試行錯誤
うまくいかなかったこと、遠回りしたこと、なぜその選択をしたか。ここが note 記事で一番読まれる部分なので具体的に：エラーメッセージ、間違った仮説、それを捨てた理由。

## 結果
最終的にどうなったか。未解決なら「未解決」と明記。

## 学び（あれば）
次に同じことをするときに役立つ気づき。ないなら省略可。
```

## Duration estimation

There is no wall-clock timer available. Infer roughly from context:
timestamps visible in tool output, the number of turns/tool calls, or
explicit time references the user gave. When genuinely unknown, write
`不明` — don't fabricate a number.

## What NOT to do

- Don't ask the user for permission each time — this is a standing
  background behavior, like the self-improvement-loop capture check.
  Just write the file and mention it briefly in the final summary
  ("session-notes に記録しました" or similar), not as a big
  announcement.
- Don't duplicate content already in `lessons.md` (system-behavior
  lessons) or project memory files — those serve future *sessions*;
  this note serves a future *article*, so keep the narrative angle
  (what happened and why) rather than the distilled rule.
- Don't let this become a second full transcript — summarize, don't
  paste raw tool output or long code diffs. A reader of the eventual
  article needs the story, not the logs.
- Don't skip writing just because the task succeeded cleanly — smooth
  sessions are valid article material too ("ここは思ったよりすんなり
  いった" is a useful data point); the struggle section can be short or
  absent for these.
