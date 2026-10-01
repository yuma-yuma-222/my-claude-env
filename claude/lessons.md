# Lessons

## L-001 | pattern: skipped-codex-delegation-for-net-new-code
- first_seen: 2026-07-29 / last_seen: 2026-07-29 / occurrences: 1
- status: active
- context: wrote daily_brief.py (net-new script, no reference implementation) directly with Write/Edit/Bash instead of routing through codex-delegation, because the task required interactively probing free APIs (weather, RSS, macOS Calendar AppleScript, `say` TTS) one at a time to discover a working design (e.g. calendar query speed) before the shape of the code was even known.
- root_cause: AGENTS.md routing was read but not applied at the moment of writing the file — exploratory API probing bled directly into implementation without a checkpoint to switch tools.
- rule: when a net-new implementation task begins with unknown/unverified external interfaces (APIs, AppleScript, CLI tools), do the interactive discovery/spike directly, but once the working approach is confirmed, hand the actual file-writing off to codex-delegation instead of continuing to Write/Edit it inline — don't let momentum from the spike carry through to the deliverable.
- owner_skill: codex-delegation / AGENTS.md §"codex-delegation vs senior-software-engineering"

## L-002 | pattern: codex-sandbox-cannot-verify-xcode-builds
- first_seen: 2026-08-18 / last_seen: 2026-08-18 / occurrences: 1
- status: active
- context: delegated 3 SwiftUI feature changes to Codex (Tsumugu iOS prototype). Every one of Codex's own completion-criteria build runs failed inside its sandbox — no CoreSimulator runtimes available, DerivedData under ~/Library not writable — even though the code was correct each time. Re-running the identical `xcodegen generate && xcodebuild ... build` command myself, outside Codex's sandbox, succeeded all 3 times.
- root_cause: Codex's workspace-write sandbox on this machine can't reach CoreSimulator/DerivedData, so it structurally cannot self-verify an Xcode build no matter how the prompt is worded — this isn't a prompt defect to fix by asking harder for real output.
- rule: for Xcode/iOS delegations, treat a Codex-reported build failure as inconclusive rather than a real signal until the orchestrator re-runs the exact build command locally — Codex's own "BUILD FAILED" text may be an environment artifact, not a code defect. Don't send a revision round based on Codex's build failure alone; check locally first.
- owner_skill: codex-delegation (add as an Xcode/iOS-specific caveat to the "Completion criteria actually verified" review criterion)

## L-003 | pattern: incomplete-target-file-list-for-shared-component-swap
- first_seen: 2026-08-18 / last_seen: 2026-08-18 / occurrences: 1
- status: active
- context: introduced a shared `ProfileAvatarView` to gate photo rendering behind a reveal state, and scoped the delegation's Target Files list from memory of "which views show a profile photo" (Discover list, profile detail, message list, chat header). Missed two call sites — `PendingInterestsView` and `MatchCelebrationView` — that had been created in an earlier delegation this same session, before the gated component existed, and still rendered the raw photo unconditionally. Only caught because I independently re-read every changed file after the diff came back, rather than trusting the summary.
- root_cause: scoped the target-file list by recalling which screens conceptually show a person, not by searching the actual codebase for every existing call site of the pattern being replaced (`Image(systemName: profile.photoSystemImage)` / `.photoSystemImage`).
- rule: before writing the Target Files list for any "introduce a shared component to replace an existing inline pattern" delegation, grep the whole tree for every occurrence of the pattern being replaced and enumerate target files from that grep output, not from memory — especially when earlier call sites were added in a prior delegation within the same session and might be missing from mental recall.
- owner_skill: make-prompt-for-codex (pre-flight checklist item 1, "Target files — explicit paths": add "grep for existing occurrences of the pattern being replaced" as a required step for retrofit/swap-style tasks)
