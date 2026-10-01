---
name: icetc2026-poster-review-status
description: "Current review/revision status of the ICETC2026 poster (which reviewer comments have been applied, which were deferred, and where the latest version lives)"
metadata:
  node_type: memory
  type: project
  originSessionId: 673ebbb8-c274-4eee-ac03-9d7c1543a08b
  modified: 2026-09-30T01:28:34.493Z
---

ICETC2026 poster (`poster/verN/ICETC2026_poster_vN.tex`, IEICE `icetc.cls`, A4 1 page,
Summary/Keywords sections removed per project CLAUDE.md) is being revised against
reviewer feedback found in `poster/コメント/`:
- `ICETC2026_poster_v4.docx` — tracked-changes (w:ins/w:del) English proofreading edits,
  no comments.xml (no bubble comments), extracted with a custom XML parser
  (no pandoc/libreoffice available in this environment).
- `poster.pdf` — 3 annotation comments (pypdf `/Annots`, cross-referenced to text
  position via pdfplumber): (1) "substantial？" near l.48 (substantive→substantial typo),
  (2) "observed in" near l.94 (missing preposition), (3) Japanese note asking the main
  text to explain the AbuseIPDB "malicious score" range/meaning.

**Latest version: `poster/ver6/ICETC2026_poster_v6.tex`** (+ `.pdf`, `poster.pdf`),
compiled with `uplatex` (run twice to resolve refs) then `dvipdfmx`, confirmed 1 page.

Applied so far (ver4 → ver5 → ver6):
- ver5: PDF-comment fixes ①substantive→substantial, ②"observed"→"observed in",
  ③ added a sentence after l.89 explaining AbuseIPDB's abuseConfidenceScore
  (0–100, higher = more malicious activity — confirmed via https://docs.abuseipdb.com/).
  ③ initially caused a 1-line overflow to page 2; fixed by also compressing the
  duplicate-IP-removal sentence (l.84–87) into one sentence (kept "numbers" plural,
  the "numbers→number" question below was deliberately left alone).
- ver6: applied the docx-derived items ranked as genuine grammar errors: D1 (DDoS
  attack(s) has/have, in/on the Internet, l.29–31), D5 ("significant"→"important" +
  simplified "distinguish legitimate from malicious DNS and QUIC traffic", l.57–59),
  D6 (missing articles: "the tcpdump command" / "the tshark tool", removed misused
  "respectively", l.67–70), D10 (fixed a real grammar gap — "reveal X perform Y" had
  no "that"-clause; became "reveal that ... performed", l.93–95; note first drafted
  as "show that" but that duplicated "Table 1 shows" in the preceding sentence, so
  it was changed to "reveal that" instead).

Explicitly decided NOT to change:
- The "numbers"→"number" question (l.85): kept plural "numbers" — three respective
  values follow ("were 67,395, 16, and 102"), so plural reads more correctly than
  the docx's proposed singular.
- D2, D3, D4, D7, D9, D11: pure style/economy rewrites with no grammar error;
  user decided these are optional polish, not required. D3's docx suggestion also
  contained a typo ("sufficiency" for "sufficiently") — flagged, never applied.
- D8 (see above, same as the numbers/number item).

**How to apply next time:** if resuming this task, read `ver6/ICETC2026_poster_v6.tex`
as the current baseline, not `ver4`. If further edits are requested, follow the same
loop: edit → `uplatex` twice → `dvipdfmx` → check page count stays 1 → `cp` to
`poster.pdf` in the same folder. Bump to a new `verN` folder when a batch of accepted
edits should be snapshotted (as done ver5→ver6); apply single follow-on fixes in place
otherwise (as done within ver6 for D10/D6 and the show/show repetition fix).
