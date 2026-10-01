---
name: bases-management-system
description: Category×Status note-management system built with Obsidian Bases in the vault
metadata: 
  node_type: memory
  type: project
  originSessionId: 0699d850-04f0-427f-be1a-98b2d8a96d15
  modified: 2026-08-06T13:56:39.376Z
---

The vault uses a "Category(テーマ) × Status(進捗)" note-management system built on Obsidian Bases (core plugin, enabled; Obsidian 1.9.14).

Shared frontmatter schema on notes:
- `category` (single): folder-derived taxonomy — ネットワーク / セキュリティ / 開発 / 就活 / 研究 / 授業 / 思考 / CTF / Daily (the original generic 7 Private/Mindset/ヘルスケア/資産運用/マイル旅/教育/AI関連 were discarded 2026-07-07 as they didn't fit the actual vault content). ~104 misc notes (90 Archive misc, some MOCs) left blank.
- `status` (single): Hub / Active / Clips / Library / Inbox / Output (Inbox = default for new notes; Output added 2026-08-06 for finished deliverables — see below)
- `section` (list of `[[links]]`): sub-themes within a category
- `ck` (checkbox/bool): processed flag

Layout:
- `.base` files live in `00 Meta/05 Base/` — one per category (Japanese filename, e.g. `セキュリティ.base`; 8 topic categories, no Daily.base) plus `_Index.base` (master: "All by Category" + "Hub一覧" grouped by category).
- Hubs (`status: Hub`) live in `00 Meta/03 MOC/`: existing MOCs reused where present (ネットワークMOC, 研究 MOC, 就活 MOC, CTF MOC — base embed appended) + new `<Category> Hub.md` for セキュリティ/開発/授業/思考. Each embeds `![[<Category>.base]]`.
- Bulk-categorized ~785 existing notes on 2026-07-07 via a path-based script (category from topic in path, status from folder tier: 31 Permanent→Library, 32 Reference→Clips, 40 Project→Active, 90 Archive/10 Daily→Library, 03 MOC→Hub, 22 Inbox→Inbox; section from immediate sub-theme folder). Additive frontmatter injection only.
- New-note default folder `20 Inbox/22 Inbox` auto-applies `00 Meta/01 Tempalets/Inbox テンプレート.md` (Templater), which was extended to add the 4 properties with `status: Inbox`.

Existing legacy notes use Japanese frontmatter (`作成日`, `タグ`) and have no category/status — treated as Inbox; NOT bulk-rewritten (additive only). See [[bases-yaml-syntax]].

**2026-08-06: layered a "capture → use → archive → output" workflow onto `status` instead of building separate physical folders** (user found a note.com article on this 4-box Obsidian method and wanted it adapted). Mapping: Inbox/Clips = 集める, Active = 使う, Library = しまう, Output = 完成品(new). Added to `_Index.base`: "Output一覧" view (`status == "Output"`) and "使う箱・停滞チェック" view (`status == "Active" and file.mtime < now() - "6M"`, sorted oldest-first) — Bases supports `file.mtime`/`file.ctime` as built-in Date properties and duration arithmetic like `now() - "6M"` in filters (verified via obsidian.md/help/bases docs). Created root `/Users/doiyuma/obsidian/doi-vault/CLAUDE.md` (auto-loaded by Claude Code, distinct from the unused placeholder `00 Meta/CLAUDE.md.md`) holding the status-meaning table plus fill-in-blank sections (今のプロジェクト prefilled from `40 Project/` subfolders, 今悩んでる決断/書こうとしてるテーマ left blank for the user, Active/Library/Output criteria). Added 4 project slash commands in `.claude/commands/`: `/tidy-inbox` (sorts Inbox+Clips notes into Active/Library per CLAUDE.md criteria, rewrites in own words), `/decision-brief <topic>`, `/writing-brief <theme>` (both build briefs from Active notes only, no outside info), `/stale-check` (lists Active notes idle 6mo+ as Library-demotion candidates, asks before changing frontmatter). Existing Inbox template's「自分にとっての意味」欄 already satisfies the article's "capture in 30 seconds" idea — no template change was needed there.
