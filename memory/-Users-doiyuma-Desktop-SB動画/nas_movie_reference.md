---
name: nas-movie-reference
description: Where the NAS "movie" storage is mounted and how this project's video files are organized on it
metadata:
  type: reference
---

The NAS is mounted at `/Volumes/NAS` (SMB share `.../mini/NAS`, 3.6Ti total). It contains a `movie` folder (`/Volumes/NAS/movie`) used as general video storage, holding a large mix of unrelated video/audio files (not organized into subfolders before this project's copy).

Files from `/Users/doiyuma/Desktop/SB動画` (21GB, 19 files: .mov/.mp4/.pdf) were copied into a new subfolder `/Volumes/NAS/movie/SB動画` on 2026-09-18, per user request to create a new folder rather than dump into the shared `movie` root.

**How to apply:** For future "NASのmovieに入れて" requests from this project, mount point is `/Volumes/NAS`, and prefer creating a dedicated subfolder under `/Volumes/NAS/movie/` (named after the source project) rather than copying loose files into the shared root, matching what the user asked for here.
