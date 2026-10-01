---
name: minimax-h3-setup-progress
description: Current state and plan for setting up MiniMax H3 local video generation via the Argus-AiTeam MLX port — chosen route, disk sequencing plan, blockers, and what's done so far.
metadata:
  type: project
---

## Decision: which route
Verified against real repo/HF contents on 2026-09-15 (not just CLAUDE.md's description)
that the two candidates need far more disk than CLAUDE.md assumed:
- Argus INT8 route (chosen): INT8 DiT 37.8GB + MLX-native Turbo 1.6GB + VAE/tokenizer/
  processor ~11GB + **Text Encoder has no pre-quantized download — must download the
  full official BF16 text_encoder (66.7GB) once and quantize it locally to 4bit**
  (`scripts/quantize_text_encoder.py`, truncated to 50 layers) before deleting the BF16
  source. Peak transient need ~84GB if sequenced right (text encoder first, delete BF16
  before downloading DiT), final steady-state ~67–80GB.
- PipeNetwork generic 4bit route (rejected for now): DiT alone is 25.3GB (not 38GB as
  CLAUDE.md said), but VAE+text encoder still come from upstream same as above — no
  disk advantage over the Argus route, and untested by us.
- A handful of third-party community repos exist with smaller bundled/quantized
  transformer+text_encoder+VAE (e.g. antocorr's 2bit-text-encoder bundle, ~34GB total)
  but these are **not vetted, not part of CLAUDE.md's recommended path** — do not switch
  to these without explicit user approval, since quality/compatibility is unknown.

See [[disk_space_ground_truth]] for why the naive size assumptions in CLAUDE.md were
wrong and how real free space (~94–100GB) was established.

## Sequencing plan (to stay under ~94–100GB real free space)
1. Get repo (done — see below, worked around a git blocker).
2. Python venv + `pip install -r requirements.txt` (done).
3. User runs `hf auth login` themselves + accepts MiniMax-H3 license on HF (not done
   by Claude — gated-model auth is explicitly the user's own responsibility per
   project CLAUDE.md).
4. Download **only** `FL2VA/tokenizer`, `FL2VA/processor`, `FL2VA/text_encoder`,
   `FL2VA/video_vae`, `FL2VA/audio_vae`, `FL2VA/model_index.json` from
   `MiniMaxAI/MiniMax-H3` (do NOT pull `FL2VA/transformer` — that's the BF16 DiT,
   66.3GB, not needed for the INT8 route).
5. Run `scripts/quantize_text_encoder.py` to build the 4bit text encoder from the
   downloaded BF16 text_encoder (bits=4, group-size=64, num-layers=50).
6. **Delete the BF16 `FL2VA/text_encoder` directory** to reclaim ~66.7GB before the
   next step.
7. Download `water1234/MiniMax-H3-MLX-Argus-Calibrated-INT8` (revision
   `70505b09c80e298e684d798d8e0f946937dcfad4`) and
   `water1234/MiniMax-H3-Turbo-v4-step600-EMA-MLX` (revision
   `9771f9c606a50671bb94ee57191461602f02d1fc`).
8. Smoke test at 64x64/1s, then real run at 1344x768/5s per the Argus README's
   "更省空间、更快" section (`scripts/generate.py` with `--low-memory --stream-blocks
   --stream-block-group-size 2 --no-block-cache`, 9 steps for the native MLX turbo).

## Environment blockers hit (2026-09-15)
- **git was unusable**: `sudo xcodebuild -license accept` not yet run, blocks
  git/Xcode CLT/Homebrew. Worked around repo fetch via `curl` + tarball instead of
  `git clone` — don't need to wait on this for cloning, but it will still block any
  future `git` usage (e.g. `pip install git+https://...`) until the user runs
  `sudo xcodebuild -license accept`.
- **ffmpeg is broken**: `/usr/local/bin/ffmpeg` is an x86_64 binary and Rosetta 2 is
  not installed on this Mac (`softwareupdate --install-rosetta --agree-to-license`
  not yet run). The generate pipeline needs ffmpeg to mux the final MP4
  (`--require-muxed-mp4`). Asked the user to run both sudo commands themselves
  (require password/interactive agreement, can't be done by Claude).
- Homebrew installed at this machine is only the Intel/`/usr/local` prefix — no
  native `/opt/homebrew`. Once Rosetta is installed the existing x86_64 ffmpeg should
  just work (acceptable — ffmpeg muxing isn't compute-heavy, no need for a full
  native Homebrew reinstall).

## Done so far
- Cloned/fetched repo to `/Users/doiyuma/Desktop/src/minimax/minimax-h3-mac` (via
  tarball, not `git clone`).
- Created `.venv` (Python 3.12), installed `requirements.txt` (mlx, mlx-vlm, numpy,
  pillow, safetensors, huggingface_hub, transformers) successfully.
- Confirmed `scripts/generate.py` and `scripts/quantize_text_encoder.py` exist in the
  repo.

## Update 2026-09-16: milestone reached, environment fully unblocked
- User ran both sudo commands (`sudo xcodebuild -license accept`,
  `softwareupdate --install-rosetta --agree-to-license`) — git, native Homebrew's
  needs, and the x86_64 `/usr/local/bin/ffmpeg` (via Rosetta) all work now.
- `hf auth login` + MiniMax-H3 license acceptance done by the user (account
  `yuma-yuma-222`).
- Disk space turned out to be volatile on this machine beyond what
  [[disk_space_ground_truth]] already covers: **Spotlight indexing** (`mds_stores`)
  was actively chewing through free space while large model files were being
  written under `models/` — adding `models/.metadata_never_index` (an empty file,
  official Spotlight exclusion mechanism, no sudo needed) stopped it and space
  recovered over the following minutes. Do this **before** any large download into
  a new model directory on this machine, not after.
- User has a NAS mounted at `/Volumes/NAS` over SMB (~3.6TB free, but slow: ~6–20MB/s
  measured). Used it to host the 4-bit text encoder (`/Volumes/NAS/minimax-h3-models/
  text_encoder_4bit`, symlinked back into `models/MiniMax-H3-MLX-TextEncoder-4bit`)
  to relieve local disk pressure, since the text encoder is read once per generation
  (conditioning pass only) — acceptable to be slow. The INT8 DiT (read once per
  denoising step, so speed matters) and VAEs stayed on local SSD.
- **Do not use plain `mv`/`cp -p` to move files onto this SMB mount** — it fails with
  `cp: chflags: ...: Invalid argument` because SMB doesn't support BSD file flags,
  and `mv`'s cross-filesystem fallback (`cp` then delete source) aborts, potentially
  leaving a partial copy without deleting the (still-needed) local original. Use
  `rsync -a` instead (works cleanly), then delete the local original only after
  verifying file count + sizes match. Also note macOS BSD rsync 2.6.9 (openrsync,
  what ships on this machine) does **not** support `--info=progress2` — use
  `--progress` instead or it errors out immediately with a usage message (and if
  piped, the pipeline's exit code can mask the real failure — check output content,
  not just `$?`).
- Final disk layout that worked: local free space went 56GB → ~95GB (after the
  Spotlight fix and an AppCleaner run) → down to ~13GA after downloading the INT8
  DiT (35GB) + native MLX Turbo (1.5GB) locally, with the 4-bit text encoder (13GB)
  on NAS.
- **Milestone reached**: ran the smoke test (128x128, 5s, 4 NFE/5 steps) with
  `scripts/generate.py` using `--transformer models/MiniMax-H3-MLX-Argus-Calibrated-
  INT8 --text-encoder models/MiniMax-H3-MLX-TextEncoder-4bit --turbo-lora models/
  MiniMax-H3-Turbo-v4-step600-EMA-MLX`, `--low-memory --stream-blocks --no-block-
  cache --dense-dequant-profile off --require-muxed-mp4`. Completed in 11.9 min
  (8.3–8.9s/step), produced `out/smoke-test.mp4` — verified via `ffprobe`: H.264
  128x128 24fps + AAC 32kHz stereo, muxed correctly. This satisfies CLAUDE.md's
  stated first milestone (local text-prompt → video+audio end to end).

## Update 2026-09-16 (afternoon): 768x448 production run confirmed working, then a real failure + fix
- Ran the full 768x448/5s/9-step production command (prompt: cinematic red panda in
  bamboo forest) — succeeded in 32.1 min (127.8s/step), valid muxed MP4 verified via
  `ffprobe`. This is the reference "known-good" run to compare future runs against.
- **LM Studio conflicts with MLX generation for unified memory.** A second attempt
  at 768x448/5s (different prompt) got through all 8 DiT steps fine but crashed
  during video VAE decode with `RuntimeError: [METAL] Command buffer execution
  failed: Insufficient Memory`. Root cause found via `vm_stat`: LM Studio (a local
  LLM app, was running with a model loaded) had **~27GB wired down** out of 48GB
  unified memory. DiT's per-block streaming tolerated the memory pressure but VAE
  decode needs a larger contiguous Metal allocation (tiled 256x256, multiple
  frames) and didn't fit. Quitting LM Studio's loaded model dropped wired memory to
  ~4.8GB and the identical retry succeeded end-to-end (30.2 min, 141.2s/step).
- **How to apply:** before any `scripts/generate.py` run, especially at 768x448+
  resolution, check `vm_stat` (`Pages wired down` × 16384 bytes) or just ask
  whether LM Studio / other local-LLM or GPU-heavy apps are running with a model
  loaded, and have the user quit/unload it first. DiT steps completing fine is not
  proof there's enough memory — the VAE decode stage at the end has a different,
  larger allocation shape and can still OOM after ~25+ minutes of otherwise-successful
  compute, wasting the whole run. Worth adding a pre-flight memory check next time.
- Generated a personal-use-only test video of a copyrighted/trademarked character
  (Mickey Mouse face closeup) at the user's request — confirmed with the user first
  that it's for private testing only, not for sharing/publishing, given Disney's
  IP. Saved as `out/mickey-face-768x448-5s.mp4`. If asked to generate more
  recognizable copyrighted/trademarked characters, check intended use (private vs.
  shared/published) before proceeding — same reasoning applies generally, not
  specific to this one character.

## Next step when resuming
Both the wiring and a real 768x448 production run are proven end-to-end (twice).
Known-good reference command lives in `scripts/generate.py` invocations documented
above; known failure mode is Metal OOM during VAE decode when another app (e.g. LM
Studio) holds a lot of wired memory — check for that first if a future run fails at
the VAE-decode stage after DiT steps complete successfully. Future work per
CLAUDE.md's "Draft → Preview → Final" idea would be pushing duration toward the
5–15s range or trying `--profile speed`/`--profile balanced` trade-offs; nothing
else is currently blocking.
