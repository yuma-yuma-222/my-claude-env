---
name: disk-space-ground-truth
description: How to determine real free disk space on this Mac — Finder's Storage pane is unreliable, use df/diskutil, and know that writing large files can trigger macOS to auto-purge caches and increase real free space.
metadata:
  type: project
---

On this MacBook Pro (macOS 27 "Golden Gate"), Finder's "About This Mac > Storage" bar
showed **365–368GB free**, but this was **not accurate**. `df -g /` and
`diskutil apfs list` (container-level "Capacity Not Allocated") are the trustworthy,
kernel-reported numbers.

Timeline observed on 2026-09-15:
- Initial `df` reading: only ~56GB free (Data volume 94% used, 908GB used of 926GB).
- Empirically writing files with `dd` until ENOSPC actually succeeded up to ~94GB
  before failing — macOS auto-purged reclaimable/purgeable cache space under pressure
  mid-write, so real free space grew from 56GB to ~95GB during the test itself.
- After the user ran AppCleaner, `df`/`diskutil` settled at **~94–102GB real free
  space**, consistent between the two tools.
- Finder kept showing ~365–368GB throughout, unchanged and not matching reality —
  likely counting iCloud-resident-but-not-local files or other optimistic estimates.

**Why:** Project's CLAUDE.md assumed ~365GB free (probably copied from Finder's
display), which would have been wrong by a factor of ~4x and caused mid-download
disk-full failures if trusted blindly.

**How to apply:** Never trust Finder's Storage pane free-space number on this machine
for planning large downloads. Always verify with `df -g /` and/or `diskutil apfs list`
before committing to multi-GB downloads. If the two disagree, prefer df/diskutil. An
empirical `dd` write test (write 1GB chunks until failure, then delete) is the most
conclusive check when in doubt, and can itself free up space by triggering macOS's
purgeable-cache reclaim. Related: [[minimax_h3_setup_progress]].
