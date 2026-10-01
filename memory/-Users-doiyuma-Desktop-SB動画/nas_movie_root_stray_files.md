---
name: nas-movie-root-stray-files
description: Leftover 0-byte files found in /Volumes/NAS/movie root that duplicate SB動画 filenames — likely a prior failed/interrupted copy attempt
metadata:
  type: project
---

On 2026-09-18, before this session's copy ran, `/Volumes/NAS/movie` (the shared root, not the new `SB動画` subfolder) already contained several 0-byte files whose names matched files in `/Users/doiyuma/Desktop/SB動画` (e.g. `1分調節版.mov`, `iinnekore.mov`, `nps.mov`, `SB試し音声.mov`, `SB動画ver1.mov`, `インターンよろしくお願いいたします.mov`, `一旦いい感じ動画.mov`, `仮.mov`, plus two PDFs), all timestamped ~21:29 the same day.

**Why:** This looks like a prior attempt (manual or automated) to copy these files directly into the `movie` root failed or was interrupted, leaving empty placeholder files. It was not something this session created.

**How to apply:** These stray 0-byte files were left untouched (not deleted, since not asked). If the user later mentions confusion about duplicate/empty files in `/Volumes/NAS/movie`, this explains their origin — they predate the `SB動画` subfolder copy and are not part of it. Worth flagging to the user if noticed again, since they may want them cleaned up.

**Root cause confirmed:** `cp -p` (preserve mode/flags) against this NAS's SMB mount fails on `chflags` ("Invalid argument") because SMB doesn't support BSD file flags. `cp` reports this as an error and the background task shows `failed`/exit code 1, but the actual file DATA still copies correctly — verified by comparing byte sizes of all 19 files against source, all matched. So a `chflags` failure here is cosmetic, not a real copy failure; always verify with a size/checksum comparison rather than trusting the exit code. Likely explains the earlier 0-byte stray files too, though those may have had a different/incomplete cause. Prefer plain `cp` (no `-p`) or `rsync` when copying to this NAS to avoid the spurious error noise.
