---
name: poster-review-workflow-feedback
description: How this user likes to work through reviewer-comment revisions on the ICETC2026 poster (and similar LaTeX poster/paper revision tasks)
metadata:
  node_type: memory
  type: feedback
  originSessionId: 673ebbb8-c274-4eee-ac03-9d7c1543a08b
  modified: 2026-09-30T01:28:48.084Z
---

When revising a paper/poster against reviewer comments, this user wants to go through
points one at a time interactively rather than having everything applied at once.
**How to apply:**
- First list every correction point with the *reason* behind it (not just old→new text),
  separating points that came from different sources (e.g. docx tracked changes vs. PDF
  annotations) since the user may want to scope work to just one source first
  ("一旦まずはpdfの内容を変更したい。ピックアップして").
- When asked to rank/prioritize, group into tiers (must-fix grammar errors > affects
  meaning/consistency > pure style) rather than one flat list — this user acts directly
  on that tiering ("D1とD5だけ確実に直し...").
- Exploratory questions ("どっちがいいだろう", "本当に？") get a short reasoned answer with
  a recommendation, not a full re-litigation — but push back/clarifying questions from
  the user (e.g. questioning whether "tshark tool" needs an article) deserve a real
  grammatical justification, not just re-asserting the claim.
- After applying edits to a LaTeX poster with a strict page limit (this one is A4/1 page,
  IEICE format), always recompile and check the page count — this user caught an overflow
  from experience ("コンパイルして確認しました。オーバーしました") and later asked for a
  second full self-review pass ("指摘された修正点以外に変な変更がないかと、修正後おかしく
  なっているところがないかを確認して"). That kind of hostile self-check (diff for
  unintended changes + re-reading for new awkwardness introduced by an edit, e.g. a
  duplicated "show...show") should be done proactively before/after batches of edits,
  not only when asked.
