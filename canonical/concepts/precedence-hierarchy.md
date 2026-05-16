---
title: Governance Cadence & Edit-Scope Doctrine
type: doctrine
status: canonical
tier: 1
firewall_class: working-internal
last_updated: 2026-05-16
related:
  - AGENTS.md
  - canonical/concepts/antigravity-operating-contract.md
  - canonical/AUDIT-2026-05-15-forensic-vault-audit.md
created: 2026-05-03
purpose: Staleness cadence, edit-scope classification, and anti-bloat caps for vault doctrine. Precedence ORDERING is NOT defined here — see AGENTS.md §4.
authority: Tier-1 doctrine (governance cadence only)
revision_history:
  - 2026-05-16 — Precedence-order table REMOVED. It contradicted AGENTS.md §4 (the 2026-05-12, more-complete 8-tier order). AGENTS.md §4 is now the single precedence-order authority. This file retitled and retained for its unique, non-contradictory governance content (staleness / edit-scope / anti-bloat). Consolidation done by Claude per Adrian ruling 2026-05-16; no valuable doctrine deleted.
---

# Governance Cadence & Edit-Scope Doctrine

## Precedence ordering — defined elsewhere

> **The single authority for "which artefact wins when claims conflict" is
> `AGENTS.md §4` (the 8-tier hierarchy, 2026-05-12).** The conflicting 6-tier
> table that used to live here has been removed to end the contradiction the
> 2026-05-15 forensic audit flagged. Do not re-introduce a precedence table in
> this file. This file now governs only cadence, edit-scope, and anti-bloat.

## Staleness Cadence

Different file types decay at different rates. Auto-flag when exceeded:

| File type | Max age before flag |
|-----------|---------------------|
| Voice / persona corpus (`canonical/adrian-corpus/`) | 90 days |
| Project current-state, active-priorities (`canonical/projects/*/`) | 7 days |
| Personal facts (`canonical/adrian-corpus/personal-facts.md`) | Explicit trigger only |
| Operating doctrine (Tier 1–3 files) | Explicit trigger only |
| Market / trend references (`raw/market/`, `working/research/`) | 7 days |
| Memory files (auto-memory) | 30 days for review |
| Skill `## Learnings` sections | 30 days for review |

Blunt 30-day-everything is forbidden — creates noise, gets ignored.

## Edit Scope Classification

Every skill-level edit must be classified before commit:

- **Local heuristic** — affects only the editing skill's `## Learnings`. Direct-fix permitted at wrap-up, no review.
- **Cross-skill** — affects another skill's behaviour or assumptions. Requires Claude review at next session start before activation.
- **Doctrine-impacting** — touches Tier 1–3 OR contradicts an existing higher-tier rule. **Cannot be applied via direct-fix.** Must surface to Adrian for explicit decision.

Wrap-up that detects a doctrine-impacting need writes a flag to `working/governance-flags/` rather than self-editing.

## Anti-Bloat Caps

To prevent the junk-drawer failure mode at scale:

- **Skill `## Rules`**: max 5 active rules per skill. Adding a 6th requires merging or replacing existing.
- **Skill `## Learnings`**: max 20 entries per skill. Older entries auto-archive to `{skill}/learnings-archive/`.
- **Confidence markers** required on every Learning: `[observed-once]` | `[pattern]` | `[validated]`. Only `[validated]` Learnings may be promoted to Rules.

## Enforcement

The `context-governance` skill (Phase 2 of governance build, AG commission pending) audits this hierarchy at session start and flags violations. Until built, this doctrine is human-enforced via the session-shutdown protocol — wrap-up checks the hierarchy before any skill-level edit commits.

## Why this exists

Without an explicit hierarchy, skill-level Learnings silently accumulate corrections that contradict global doctrine. Over months, canonical truth migrates from `CLAUDE.md` into scattered skill files — nobody notices until something breaks.

Identified 2026-05-03 via ChatGPT gpt-5.4 forensic critique as the highest-priority architectural gap before scaling skill ecosystem. This doctrine closes it.
