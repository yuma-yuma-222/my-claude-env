---
name: nas-downloads-archive
description: "Layout and organization convention of the user's NAS downloads archive (/Volumes/NAS/downloads), and how it relates to the local Mac Trash/Downloads folders"
metadata: 
  node_type: memory
  type: project
  originSessionId: 119bda02-bbaa-4997-9c47-5a3113210848
  modified: 2026-09-16T04:14:52.910Z
---

The user maintains a personal file archive at `/Volumes/NAS/downloads` on a
NAS mounted at `/Volumes/NAS` (an AFP/SMB share, ~3.6TB, ~3.5TB free as of
2026-09-16). This is unrelated to the MiniMax H3 project itself — this
working directory is also used by the user for general Mac/NAS file
administration tasks.

**Structure (as of 2026-09-16):** organized as `<YEAR>/<MONTH>/` folders.
- Items whose exact date is known (e.g. from the host Mac's `~/Downloads`,
  using `kMDItemDownloadedDate` / `kMDItemFSCreationDate` / mtime as
  fallbacks in that priority order) live under `<YEAR>/<MONTH>/`.
- Older items bulk-imported from the local Trash (`~/.Trash`) where only
  the year was known live as loose files directly under `<YEAR>/` (no
  month subfolder) — years 2015, 2018, 2020, 2021, 2022, 2023 exist this
  way.
- Filename collisions when merging same-month items were resolved by
  appending `__DD` (source day-of-month) before the extension, e.g.
  `foo__15.pdf`.

**Trash vs NAS Trash — do not confuse these:**
- `~/.Trash` (local Mac user trash) is a real, populated directory (hundreds
  of files/apps) — this is what "ゴミ箱" normally refers to for this user.
- `/Volumes/NAS/.Trashes/501` (the NAS volume's own deleted-items trash) is
  a separate thing and was found empty — it is NOT where deleted local
  files end up.

**Why:** User asked to reconcile/merge `~/.Trash` and `~/Downloads`
content into the NAS archive, then reorganize the flat date folders into
a Year/Month hierarchy for easier browsing.

**How to apply:** If the user again asks to add files to, audit, or
reorganize the NAS downloads archive, assume this Year/Month convention
and the collision-naming scheme described above rather than re-deriving
it from scratch. Also remember `mdls -raw -name kMDItemDownloadedDate`
returns a parenthesized multi-line list even for a single value — extract
the date with a regex, don't naively split/cut the raw output.
