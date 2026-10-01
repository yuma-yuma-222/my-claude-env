# my-claude-env
~/.claude の移行用バンドル(2026-10-01作成)。

## 復元
1. 新PCで Claude Code をインストールしログイン
2. `bash install.sh`(既存の設定ファイルは .bak-日付 で退避)

## 手動で再設定するもの
- MCP: `claude mcp add codex -- codex mcp-server`(Codex CLIも要インストール)
- プラグイン: `/plugin install rust-analyzer-lsp@claude-plugins-official` と `swift-lsp@claude-plugins-official`
- claude.ai コネクタ(Notion, Claude Docs)・Chrome拡張: アカウント側で再接続
- settings.json の skillOverrides / hooks は複製済み(hooksは jq が必要: `brew install jq`)

## 含めていないもの
会話履歴(projects/*.jsonl, history.jsonl)、認証情報(~/.claude.json)、cache、telemetry。
memory/ はプロジェクト別メモリのみ。フォルダのパスが旧PCと違う場合は効きません。

## 使い方(復元後)
- `~/.claude/CLAUDE.md` が `@AGENTS.md` を読み込み、AGENTS.md の指示で skills が自動的に選ばれる。普段は意識せず普通に依頼すればよい。
- スキルの選択表・使い分けは `claude/AGENTS.md` の Section 1〜3 を参照。トリガー例:
  - 「実装して」→ codex-delegation / 「バグ」「直して」→ debugging-methodology
  - 「レビューして」→ review-methodology / 「調べて」→ expert-research-methodology
  - 「サーベイ」→ literature-survey-pipeline / 「論文」「原稿」→ academic-paper-writing
  - 「教えて」→ deep-learning-tutor / 「スキル化して」→ skill-creation-methodology
  - 「pcap」「ダークネット」→ network-traffic-analysis / 「CVE」→ vulnerability-analysis
- 明示的に呼ぶ場合は `/スキル名`(例: `/review-methodology`)。
- 簡単な作業は Fast path(計画・ログを省略)、複雑な作業は Full loop(7ステップ)で動く(AGENTS.md Section 0)。
- 作業後は `lessons.md`(教訓)と各プロジェクトの `.claude/session-notes/`(note.com用ログ)が自動で書かれる。
- 詳細な運用ルールは `claude/運用マニュアル.md`。
- スキルを追加/削除したら AGENTS.md の表も同時に更新する(Section 5)。
# my-claude-env
