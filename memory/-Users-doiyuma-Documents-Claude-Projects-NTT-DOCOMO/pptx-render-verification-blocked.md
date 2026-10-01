---
name: pptx-render-verification-blocked
description: この Mac では PowerPoint/Keynote の AppleScript 自動操作が権限ダイアログ待ちでタイムアウトする — pptx の見た目検証は幾何リントで代替
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9ab6bfca-dfb9-490b-a7fd-fe26659a0cb6
---

PowerPoint・Keynote への AppleScript (osascript) は `AppleEvent がタイムアウトしました (-1712)` で失敗する（2026-07-11 確認、3回試行）。原因はおそらく macOS の自動化権限が未許可でダイアログ待ちになるため。soffice(LibreOffice)・pdftoppm も未インストール。

**Why:** pptx 生成後のレイアウト検証をレンダリングで行えない。

**How to apply:** pptx の検証は python-pptx で「テキスト推定幅（全角=fontsize pt、半角=0.55×）÷ ボックス幅 → 行数 → 推定高さ vs ボックス高さ」の幾何リントで行う（スクリプト例: scratchpad/build_deck.py と同セッションの lint）。目視確認はユーザーに依頼するか、システム設定→プライバシーとセキュリティ→オートメーションで Terminal に PowerPoint/Keynote の許可を出してもらう。「Keynote」を AppleScript で指定すると「Keynote Creator Studio」が誤マッチするので bundle id `com.apple.iWork.Keynote` を使う。関連: [[docomo-d2-interview-deck]]
