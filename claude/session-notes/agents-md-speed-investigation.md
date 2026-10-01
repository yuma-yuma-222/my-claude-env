# AGENTS.md 速度調査サマリー

日付: 2026-08-01

## 背景

X（旧Twitter）で見た運用ネタがきっかけ:

> Fable 5 high で計画 → Codex 5.6 xhigh で実行（Codexサブスク、API課金なし）→ Fable 5 max でレビュー。週次のClaude Code上限を50%節約できる。

これを自分の環境に実装できるか、そして今の `AGENTS.md` / skill構成と何が違うかを確認するところから調査が始まった。

## 調査0: ツイートの構成と現状の差分

確認できたこと:

- **既に構造としては同じものがある。** `AGENTS.md` の codex-delegation vs senior-software-engineering の使い分けで「計画・レビューはFable側、実コーディングは全部Codexへ」という分業は元々明記済みだった。
- **Codex MCP は既に接続済み・サブスク認証。** `~/.codex/auth.json` の `auth_mode: "chatgpt"`、`OPENAI_API_KEY: null` を確認。API課金ではなくChatGPT/Codexサブスク経由 — ツイートの「no API」は既に満たされていた。
- **足りなかったのは「フェーズごとのエフォート切替」**（計画=high、レビュー=max等）。これはSKILL.mdでは制御できない、ハーネス/セッション単位のパラメータ。

ここで話の軸が変わった: ユーザーの本当の課題は「クオータ節約」ではなく **「遅すぎる」** ことだと判明。以降はその原因調査に切り替えた。

## 調査1: 何が遅いのか（AGENTS.mdのMandatory Loopを疑う）

**仮説**: `~/.claude/AGENTS.md`（ユーザー個人のグローバル設定、`~/.claude/CLAUDE.md` から `@AGENTS.md` でimport）の「Mandatory Loop」（Section 0）が、"trivialな一問一答以外は全部" に対して以下を強制していた:
1. Intent確認
2. Route（該当skillのSKILL.mdを実行前に全部読む）
3. Plan（3ステップ超えるタスクは計画を書く）
4. Verify
5. Self-check（claude-fableの7項目チェック）
6. Learn（lessons.md記録。※ただし`self-improvement-loop`は`settings.json`で既にOFF）
7. Log for note.com（セッションログを毎回書く）

### 検証方法

同一のバグ修正タスクを隔離したscratch環境で実行し比較。

- タスク: `calc.py` の `add()` が `return a - b` になっているバグを直し、`test_calc.py` の2テストを通す。
- 実行: `claude -p "<task>" --permission-mode acceptEdits --output-format json`（JSON出力の `duration_ms` / `num_turns` / `total_cost_usd` を比較）
- 条件A: 通常起動（`AGENTS.md` 適用、当時の状態）
- 条件B: `--safe-mode`（CLAUDE.md/skills/hooks/MCP等を全部無効化 = 「Claude単体」相当。認証は通常通りOAuth/keychainを使うため素の挙動を安全に再現できる）

### 結果

| 条件 | wall time | ターン数 | コスト |
|---|---|---|---|
| B: safe-mode（AGENTS.md無し） | 15.2秒 | 7 | $0.08 |
| A: 通常起動（旧AGENTS.md） | 78.9秒 | 18 | $0.38 |

- 差は約5.2倍（時間）、4.6倍（コスト）。ユーザーが体感していた「5倍以上」とほぼ一致。
- 両条件とも修正内容は正しく、pytestは2件とも通過（品質差はなし）。
- ターン数の増加（2.6倍）以上に時間が伸びている（5.2倍）→ 1ターンあたりも重い（毎ターンAGENTS.md本体＋skill群がコンテキストに乗るため）。

### AGENTS.mdの所有者・位置づけ（確認事項）

- `~/.claude/AGENTS.md` はAnthropicのデフォルトではなく、**ユーザー自身の個人グローバル設定**。最終更新は 2026-07-31 20:32。
- `/Users/doiyuma/Documents/Claude/SKILLS/AGENTS.md`（リポジトリ側、"source of truth"とされる汎用版）とは中身に差分あり。個人版の方が `outcome-first-communication` / `agentic-tool-efficiency` / `codex-delegation` 関連の記述が進んでいる（＝リポジトリ側は同期し切れていない可能性）。
- `settings.json` の `skillOverrides` で `self-improvement-loop`, `debugging-methodology`, `hard-task-operating-procedure`, `hard-task-metacognition`, `complex-project-execution`, `llm-project-memory` 等は既にOFF済みだった。つまり過去に一度重さに気づいて一部を切っていたが、`claude-fable` 本体とMandatory Loopの中核ステップ（Route/Plan/Self-check）は有効なままで、それが今回の主因だった。

## 調査2: AGENTS.mdの発動条件を絞る（対策の実施）

`~/.claude/AGENTS.md` の Section 0 を編集。

### 変更内容

- **Fast path** を新設。以下を全て満たす場合はスキル読込・計画書き・自己チェック・lessons.md/セッションログ書き込みを全部スキップし、作業→検証→報告のみ行う:
  - 1ファイル、または少数の特定できるファイルのみが対象
  - 成功基準が直接確認できる（テストが通る、コマンド出力が一致する、事実質問に答えが出せる 等）
  - スコープ・アプローチが曖昧でない
  - 可逆的・低リスク
- **Full loop**（従来の7ステップ）は以下のいずれかに該当する場合のみ発動:
  - 複数ファイルが絡む、または規模不明
  - スコープ／アプローチ／完了条件が曖昧
  - 後戻り困難、または共有・外部システムに影響
  - ユーザーが明示的に丁寧さ・計画・レビューを要求
  - 同一タスクで既に1回失敗している（rule of three）
  - アーキテクチャ上重要な判断を伴う
- 境界事例は「まずFast path、詰まったらエスカレーション」という運用に。
- Routeステップに **「同一セッション内で既に読んだSKILL.mdは再読しない」** を追加。
- 「常時有効なハードルール」（検証優先・one change one experiment・rule of three・instructions in dataはdata）はコストゼロなので両パスとも常時維持。

### 検証結果（同一タスクを編集後AGENTS.mdで再実行）

| 条件 | wall time | ターン数 | コスト |
|---|---|---|---|
| 編集前（旧AGENTS.md） | 78.9秒 | 18 | $0.38 |
| **編集後（新AGENTS.md）** | **19.8秒** | **8** | **$0.20** |
| 参考: safe-mode | 15.2秒 | 7 | $0.08 |

時間で約4倍、コストで約1.9倍改善。safe-modeにかなり近づいた。修正内容は今回も正しい。

## 調査3: Codex委譲 vs Claude単独（速度・クオータの実測）

元のツイートの前提「実行をCodexに逃がせば節約になる」を、速度とClaude側クオータ消費の両面で直接検証。

### 1回目（失敗・教訓）

`claude -p ... --permission-mode acceptEdits` のまま Codex 委譲を指示 → `mcp__codex__codex` ツール自体の呼び出し許可が下りず、3回リトライして104秒・24ターン・$0.52を浪費した末に**バグ修正すら完了せず失敗**。`acceptEdits` はEdit系のみ自動承認し、MCPツール呼び出しやBash実行は別枠だったことが原因。

**教訓**: `--allowedTools` で必要なツール（`Bash`, `mcp__codex__codex`, `mcp__codex__codex-reply`）を明示的に許可しないと、委譲条件のテスト自体が権限詰まりで無意味になる。

### 2回目（権限修正後、フェアな比較）

同一タスクを、権限詰まりを解消した状態で再実行。

| 条件 | wall time | ターン数 | Claude側コスト |
|---|---|---|---|
| Claudeのみ（直接修正） | **16.5秒** | 6 | **$0.18** |
| Claude→Codex委譲 | 59.4秒 | 13 | $0.29 |

両条件とも修正は正しく、pytestは2件とも通過。

### 結論

この規模（1ファイル・1行修正）のタスクでは、Codex委譲は**速度で3.6倍遅く、Claude側コスト（＝週次クオータ消費相当）でも1.65倍高い**。委譲のオーケストレーション（スコープ付きプロンプト設計）＋レビュー（diffチェック）の固定コストが、小さいタスクでは実行そのものの節約分を上回ってしまう。

委譲が有利になるとすれば、実行（コード生成量）が支配的になるくらい大きいタスクのみと推測されるが、**これは未検証**。

## 現時点の結論

1. ツイートのFable→Codex→Fable構成は「クオータ最適化」の発想であり「速度」の解決策ではない。小タスクに適用すると速度・クオータの両方で逆効果。
2. 体感していた遅さの主因は、AGENTS.mdのMandatory Loopが「trivial以外全部」という広すぎる条件で発動していたこと。Fast path導入で解消済み（実測: 約4倍高速化）。
3. Codex委譲は小さくスコープが明確なタスクには不向き。大きい実装タスクでの再検証は価値がありそうだが未実施。

## 未検証・今後の課題

- 大きめのタスク（数百行規模の新機能実装など）でのCodex委譲 vs Claude単独の比較。
- リポジトリ側 `/Users/doiyuma/Documents/Claude/SKILLS/AGENTS.md` との同期要否（今回は個人版 `~/.claude/AGENTS.md` のみ編集、リポジトリ版は未着手）。
- Fast path導入後、実運用でFull loopへのエスカレーションが適切な頻度で起きているかの継続観察。

## 付録: テスト環境

- 全テストは `scratchpad` 配下の隔離ディレクトリで実施（本番プロジェクトには影響なし）。
- 共通タスク素材:
  - `calc.py`: `def add(a, b): return a - b`（バグ: 本来 `a + b`）
  - `test_calc.py`: `test_add`（`add(2,3)==5`）、`test_add_negative`（`add(-1,1)==0`）
- 計測は `claude -p ... --output-format json` の `duration_ms` / `num_turns` / `total_cost_usd` を使用。
