#!/bin/bash
# 新しいPCで実行: bash install.sh
set -e
H=$(cd "$(dirname "$0")" && pwd); C=~/.claude
mkdir -p "$C"
for f in CLAUDE.md AGENTS.md lessons.md 運用マニュアル.md settings.json; do
  [ -f "$C/$f" ] && cp "$C/$f" "$C/$f.bak-$(date +%Y%m%d)"
  cp "$H/claude/$f" "$C/$f"
done
rsync -a "$H/claude/skills/" "$C/skills/"
rsync -a "$H/claude/session-notes/" "$C/session-notes/"
# プロジェクトメモリ(パスはユーザー名/フォルダが同じ場合のみ有効)
for d in "$H"/memory/*/; do n=$(basename "$d"); mkdir -p "$C/projects/$n/memory"; rsync -a "$d" "$C/projects/$n/memory/"; done
echo "完了。残り手動: README.md 参照(MCP/プラグイン/ログイン)"
