---
title: Typed-Links Schema — relationship layer for the vault
type: concept
status: active
tier: 2
created: 2026-05-23
inspired_by: "Hellblazer/nexus (typed links: cites / implements / supersedes)"
tool: tools/typed-links.py
projection: working/state/typed-links.json
firewall_class: working-internal
---

# Typed-Links Schema

## Why this exists
The vault has 53k notes but tracks relationships between them in two weak ways:
**untyped** Obsidian wikilinks (no semantics) and hand-written prose
"`SUPERSEDED 2026-…`" banners (error-prone, impossible to query). Mined from
`Hellblazer/nexus` — the one idea worth taking (the vault already had Nexus's
event-sourcing, SQLite projection, ChromaDB and knowledge graph). This formalises
supersession + key relationships as **typed frontmatter** that can be validated
and queried.

This is a **DERIVED projection**, not a source of truth (same status as
`tasks.db` per AGENTS.md §10): the per-note frontmatter is the source;
`working/state/typed-links.json` is the rebuildable index. Delete it and
`scan` again — nothing is lost.

## Edge types (frontmatter keys; value = note slug / `[[wikilink]]`, scalar or list)
| key | meaning |
|---|---|
| `superseded_by` | this note is replaced by a newer one — **use instead of prose "SUPERSEDED" banners** |
| `supersedes` | this note replaces an older one |
| `implements` | implements a spec / decision / concept |
| `cites` | draws on / quotes a source note |
| `depends_on` | depends on another note (build / logic order) |
| `relates_to` | undirected association |
| `decided_by` | direction set by a named decision record |
| `part_of` | a component of a larger work |

## Target format (HARD rule — fixes dangling links)
A target MUST be a resolvable note **slug** (filename without `.md`) or a
`[[wikilink]]`. **Never free text** — the tool flags free-text targets as dangling.
- ✅ `superseded_by: 2026-05-22-enriched-proposal-whitepaper-v2`
- ✅ `supersedes: [[trailer-storyboard-v3]]`
- ❌ `supersedes: "v1 (2026-05-03)"`  ← unresolvable

## Example
```yaml
---
title: Ashta Whitepaper v1
superseded_by: 2026-05-22-enriched-proposal-whitepaper-v2
---
```
```yaml
---
title: Hive Architecture v3
supersedes: hive-architecture-v2
cites:
  - claude-ceo-operating-doctrine
decided_by: 2026-05-20-architecture-v3-ratification
---
```

## Tool (`tools/typed-links.py`)
- `scan` — rebuild `working/state/typed-links.json`
- `doctor` — stats + dangling-target check + prose-supersession migration backlog
- `query <edge_type> <substring>` — e.g. `query superseded_by ashta`
- `chain <substring>` — follow the supersession chain end to end

## Adoption
- **Going forward:** when you supersede a note, add `superseded_by:` / `supersedes:`
  typed frontmatter (replacing, or alongside, the prose banner). Same for the
  other relationships when they're worth recording.
- **Backlog at creation (2026-05-23 `doctor`):** 88 typed edges already existed
  (now indexed + queryable); 29 were dangling free-text targets (clean to slugs);
  ~335 notes track supersession in prose only — migrate incrementally as touched,
  not in one mass edit.
