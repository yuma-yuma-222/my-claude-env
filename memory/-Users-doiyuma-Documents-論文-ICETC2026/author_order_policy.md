---
name: author-order-policy
description: Author ordering rule and per-file status for ICETC2026 submission (paper vs poster)
metadata:
  type: project
---

Hikaru Ichise should be listed as the **second author** in this ICETC2026 work.

- `poster/icetc2026-latex-template/ICETC2026_poster.tex` already has the correct order: Doi → Ichise → Ikebe → Yoshizaki. No change needed there.
- `IEEE-ICETC_revison.tex` (the camera-ready/revision paper) must **NOT** be edited for author order — the user explicitly said not to touch this file's author list, even though it currently lists Doi → Ikebe → Ichise → Yoshizaki (Ichise third, not second). This was a deliberate instruction, not an oversight, on 2026-09-24.

**Why:** The user asked to make Ichise second author, but after seeing the poster already had it right, redirected: leave the revision paper alone and instead proofread/edit the poster.

**How to apply:** If asked again to reorder authors, apply changes only to the poster file, not `IEEE-ICETC_revison.tex`, unless the user explicitly says to change the revision file too. Any request to "proofread the poster" (添削) refers to `poster/icetc2026-latex-template/ICETC2026_poster.tex`.
