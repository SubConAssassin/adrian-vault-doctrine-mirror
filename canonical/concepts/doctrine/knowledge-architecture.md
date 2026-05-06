---
title: Knowledge Architecture Doctrine — Adrian-Vault
type: doctrine
status: canonical
tier: 2
firewall_class: working-internal
authority: Single source of truth for vault organization principles, file structure conventions, frontmatter schema, cross-referencing patterns, indexing strategy, and query interfaces
created: 2026-05-06
last_updated: 2026-05-06
version: v1.0
related:
  - AGENTS.md
  - CLAUDE.md
  - canonical/concepts/precedence-hierarchy.md
  - canonical/concepts/corporate-agent-architecture.md
  - canonical/concepts/agent-budget-framework.md
  - canonical/concepts/handoff-frontmatter-conventions.md
  - canonical/_MOCs/persona-architecture.md
sources:
  - working/drafts-pending/2026-05-06-knowledge-architecture-proposal.md (research foundation, 5,520 words)
adopted_via: |
  Adrian-approved 2026-05-06 ~16:00 WITA per Q1 of architecture proposal sequence.
  All 9 sub-decisions cleared (Q2-Q9 either Adrian-approved or Claude-CEO-decided per
  feedback-functionality-decisions-claude-decides.md rule).
---

# Knowledge Architecture Doctrine — Adrian-Vault

This is the **canonical doctrine** for how Adrian-Vault organizes information. Promoted 2026-05-06 from the research proposal in working/drafts-pending/.

## 1. Core Principle — Single Source of Truth, Densely Linked

Every fact lives in ONE canonical location. Other files REFERENCE it via wikilinks and frontmatter `related:` fields. Never duplicate content — link instead.

**Why:** Per Adrian's 2026-05-06 directive: *"single source of truth that incorporates all of the learning, all of the growth, all of the wisdom, all of the research... reconfigured into one single comprehensive document. Nothing gets lost, nothing gets unlinked."*

## 2. Six-Zone Architecture

The vault is organized into 6 zones based on **how-trusted-the-content-is**. Authority flows downward; lower zones cite higher zones, never the reverse.

| Zone | Authority | What it holds | Lifecycle |
|---|---|---|---|
| **0. Doctrine** | Constitutional | `AGENTS.md`, `CLAUDE.md`, `canonical/concepts/doctrine/*.md` | Immutable except by AGENTS.md §8 doctrine-change protocol |
| **1. Truth** | Canonical state | `companies/{venture}/ledger.md` + per-domain canonicals (`canonical/adrian-corpus/`, `canonical/people/`, `canonical/infrastructure/`) | Source-grounded promotion only |
| **2. Protocols & Lessons** | Operational | `canonical/concepts/protocols/`, `canonical/concepts/lessons/`, `procedural/workflows/` | Iterative; staleness cadence per `precedence-hierarchy.md` |
| **3. Working** | In-flight | `working/handoffs/`, `working/drafts-pending/`, `working/_runtime/`, `working/finance/` | Promotes UP to Truth or Protocols, OR archives DOWN |
| **4. Episodic** | Chronological record | `episodic/sessions/`, `episodic/review/`, `episodic/decisions/`, `episodic/sources/` | Append-only |
| **5. Raw + Archive** | Untouched ingestion / historical | `raw/`, `08-Archive/`, `_archive/` (within each layer) | Read-only after ingestion |

Zone numbers map to authority tiers in `canonical/concepts/precedence-hierarchy.md`.

## 3. Frontmatter Standard

Every Zone-0/1/2 file MUST carry consistent YAML frontmatter. The minimum required:

```yaml
---
title: <short concept-oriented title>
type: doctrine | protocol | lesson | framework | ledger | profile | persona | vision | reference | MOC
status: canonical | active | superseded | deprecated | pending-review
tier: 1 | 2 | 3 | 4 | 5     # Per precedence-hierarchy
firewall_class: public-shareable | working-internal | strictly-private
last_updated: YYYY-MM-DD
related:
  - <path-to-related-file>
---
```

Recommended additions: `created`, `last_verified`, `version`, `supersedes`, `deprecated_by`, `authority`, `sources`, `tags`.

For Zone 3-5 files: lighter frontmatter is sufficient (`title, type, date`).

## 4. Cross-Referencing Pattern

Every canonical note should reference at least 3 others. Three mechanisms:

1. **Frontmatter `related:` array** — machine-readable, used for graph build and link-integrity. **Required.**
2. **Inline wikilinks** `[[canonical-file-name]]` — Obsidian-native, supports backlinks pane, useful for human navigation. **Recommended.**
3. **Generated backlinks** — `tools/link-integrity-check.py` builds a `backlinks.json` per file. **Generated, not authored.**

**Anti-pattern (HARD):** never copy content between canonical files. If two files state the same fact, one is canonical and the other links + summarises (Matuschak's "transclusion via link" pattern; Obsidian supports `![[file#section]]` embed syntax for live transclusion).

## 5. Three-Layer Indexing Strategy

| Layer | Tool | Use case | Cost |
|---|---|---|---|
| **L1: Maps of Content (MOCs)** | `canonical/INDEX.md` + per-domain `canonical/_MOCs/*.md` | Human + agent navigation, "where does X live?" | Zero |
| **L2: Frontmatter index** | `tools/build-inventory.py` (when built) → generates `canonical/state/vault-inventory.json` weekly | Faceted query, "all `tier:1` files modified in last 30 days where `firewall_class:public-shareable`" | Cheap |
| **L3: Knowledge graph** | `graphify` extended to whole vault → `graphify-out/vault-wide/` | Semantic query, god-node detection, community discovery | Moderate |
| **L4: RAG (semantic search)** | Local Qdrant + BGE-M3 via Ollama (in build per Adrian-approval 2026-05-06) | Semantic search across full corpus including raw WhatsApp/FB/papers | Zero recurring (local-only) |

L1-L3 land in Phases 1-3. L4 RAG was Adrian-approved 2026-05-06 — local build via Qdrant + BGE-M3, zero external spend.

## 6. Query Access Order for Agents

Agents read the vault in this order of preference:

1. **Read `canonical/INDEX.md` first** — boot sequence (already enforced per CLAUDE.md)
2. **Use `canonical/_MOCs/{domain}.md`** for domain-specific entry
3. **Use `canonical/state/vault-inventory.json`** for faceted queries
4. **Use `graphify-out/{venture-or-domain}/GRAPH_REPORT.md`** for cross-cluster questions
5. **Use RAG (`search_vault` MCP tool)** for semantic queries across full corpus
6. **Fall back to filesystem grep** only when 1-5 don't answer

This is the navigation hierarchy — agents short-circuit at the first layer that resolves the query.

## 7. Architecture Decision Records (ADRs)

Every architectural choice gets an ADR file written to `episodic/decisions/{YYYY-MM-DD}-{decision-slug}.md`:

```yaml
---
type: ADR
status: proposed | accepted | superseded
date: YYYY-MM-DD
---

# {Decision title}

## Context
## Options considered
## Decision
## Consequences
## Status
```

Industry-standard pattern (Michael Nygard 2011, ThoughtWorks Tech Radar). Adrian-approved 2026-05-06 Q3.

## 8. Stable Identifier per Entity

Every person, venture, dispute, artefact gets a slug ID in frontmatter (e.g. `person:erica-johnson`, `venture:osb`, `dispute:erica-2026-04`). When the file moves, the ID survives. Critical for graph build + RAG metadata.

## 9. Phase Plan

**Phase 1 (mostly complete 2026-05-06):**
- Companies/ migration ✓
- Doctrine update ✓
- Templates consolidation ✓
- Persona architecture MOC ✓

**Phase 2 (in flight):**
- Frontmatter standardization across canonical (AG commission to follow)
- Link-integrity check tool build
- `cloud_assimilated/` triage (AG batches)
- ADR template + ADR backlog (today's decisions get ADR'd)

**Phase 3 (next 2-4 weeks):**
- Graphify extended vault-wide
- RAG (Qdrant + BGE-M3) build per `working/handoffs/2026-05-06-claude-to-ag-rag-build-local-commission.md`
- Per-venture cross-reference READMEs (post-migration follow-up)

**Phase 4 (later):**
- L4 RAG MCP server registration
- Backlinks generation automation
- Auto-update on file changes daemon

## 10. What This Doctrine Is NOT

- Not a tool catalogue. Tools come and go — principles persist.
- Not a one-shot migration spec. The principles guide ALL future content additions, not just today's restructure.
- Not a constraint on Adrian. Adrian retains full CEO override on any element.
- Not exhaustive. New patterns emerge; promote them via ADR + update this file.

## 11. Doctrine Maintenance

Updates to this file follow AGENTS.md §8 doctrine-change protocol:
1. Explicit doctrine-change classification
2. Proposed diff + ledger entry
3. Adrian-go before commit (or autonomous if explicitly delegated)

Cross-reference: `agent-budget-framework.md`, `precedence-hierarchy.md`, `corporate-agent-architecture.md`.

— Promoted to canonical doctrine by Claude (Chief of Staff), 2026-05-06 ~16:55 WITA, per Adrian Q9 approval (proposal-to-canonical) and full architecture proposal sequence.
