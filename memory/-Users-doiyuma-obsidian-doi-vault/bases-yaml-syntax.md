---
name: bases-yaml-syntax
description: Verified Obsidian Bases .base YAML key names (view sort/groupBy/order/filters)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0699d850-04f0-427f-be1a-98b2d8a96d15
---

Verified against Obsidian API type defs (`obsidianmd/obsidian-api` obsidian.d.ts) and help docs for Obsidian 1.9.x Bases:

Top-level `.base` keys: `filters`, `formulas`, `properties`, `summaries`, `views`.

Per-view keys: `type` (e.g. `table`), `name`, `limit`, `filters`, `order` (list of columns/props to display), `groupBy` (`{ property, direction: ASC|DESC }`), `sort` (list of `{ property, direction: ASC|DESC }` — `BasesSortConfig`), `summaries`.

Key gotchas:
- It's `groupBy` (camelCase), NOT `group_by`.
- sort sub-key is `property` (NOT `column`) + `direction: ASC|DESC`.
- Frontmatter props are referenced as `note.<prop>` in `order`/`groupBy`/`sort`; filename as `file.name`.
- Filter expressions are strings, e.g. `- 'category == "ヘルスケア"'` (single-quoted whole expression, bare property name inside).
- `properties:` block display names use bare prop name (`status:`) or `file.name:`.

Related: [[bases-management-system]].
