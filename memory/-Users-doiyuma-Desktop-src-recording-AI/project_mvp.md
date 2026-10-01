---
name: project-mvp
description: "MVP implementation details — stack decisions, file layout, key constraints"
metadata: 
  node_type: memory
  type: project
  originSessionId: e74be8de-4344-46fd-bb22-a6a6cf674ffa
---

MVP が実装済み（2026-06-10）。

**スタック確定事項:**
- バックエンド: FastAPI + SQLite + MLX Whisper (`mlx-community/whisper-large-v3-mlx`) + Ollama (`qwen2.5:14b`)
- フロントエンド: Vanilla HTML/CSS/JS、PWA対応（manifest.json + sw.js）
- 接続: Tailscale経由のみ、ポート8000でリッスン

**ファイル構成:**
- `backend/main.py` — FastAPI エントリーポイント、全APIルート
- `backend/job_manager.py` — asyncio.Queue による逐次ジョブ処理、SSE進捗通知
- `backend/transcriber.py` — MLX Whisper ラッパー（ffmpeg前処理付き）
- `backend/summarizer.py` — Ollama呼び出し、map-reduce（8000文字/チャンク）
- `frontend/` — index.html + app.js + style.css

**Why:** 16GB RAM制約でモデル同時常駐不可 → ジョブキューで逐次処理
**How to apply:** 新機能追加時も並列処理は避け、キューに通す設計を維持

次フェーズ (v1): 話者分離（pyannote）、ライブラリ検索、PWA完全対応、ファイル取り込みUI改善
