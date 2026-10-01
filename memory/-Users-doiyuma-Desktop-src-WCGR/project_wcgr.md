---
name: project-wcgr
description: WCGRプロジェクトの概要と現在の状況
metadata: 
  node_type: memory
  type: project
  originSessionId: b57312ef-e7e5-45f2-a527-2cda59e08de6
---

W杯史における選手の偉大さを測る独自指標「WCGR（World Cup Greatness Rating）」のWebサイト。

**Why:** 単なる得点王・出場回数ではなく、大会への主人公的貢献・時代補正・相手強度・歴史的影響を統合してペレ〜メッシを同一軸で比較したい。

**現在の状態（2026-06-27）:**
- Phase 1〜3完了: Next.js 16 + TypeScript + Tailwind プロジェクト構築済み
- 初期20選手のデータ入力完了（pele, maradona, messi, beckenbauer, zidane, cruyff, garrincha, ronaldo-r9, mbappe, modric, iniesta, romario, rossi, charlton, eusebio, puskas, muller-gerd, kocsis, fontaine, zagallo）
- 計算エンジン完成（14テスト全通過）
- UI完成（ランキングページ、選手詳細、公式解説）
- `npm run build` で24ページ静的生成済み

**スコープ:** TOP 100選手（現在20人でスタート）

**次のステップ:** 
1. `git init` → GitHub push
2. Vercel デプロイ
3. 残り80人の選手データ入力

**How to apply:** データ追加の際は `src/data/performances/[slug].ts` を作成して `src/data/performances/index.ts` にimport追加するだけ。
