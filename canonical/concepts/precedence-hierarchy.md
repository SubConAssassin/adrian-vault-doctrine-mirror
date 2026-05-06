---
title: Precedence Hierarchy
type: doctrine
status: canonical
tier: 1
firewall_class: working-internal
last_updated: 2026-05-03
related:
  - AGENTS.md
  - CLAUDE.md
  - canonical/concepts/doctrine/knowledge-architecture.md
  - canonical/concepts/agent-budget-framework.md
created: 2026-05-03
purpose: Single source of truth resolution order across all vault doctrine and operational artefacts. Prevents skill-level edits from silently overriding global doctrine.
authority: Tier-1 doctrine
---

# Precedence Hierarchy

When multiple artefacts make conflicting claims, **higher tier wins**. Never the reverse.

## The Hierarchy

| Tier | Source | Authority |
|------|--------|-----------|
| 1 | `~/.claude/CLAUDE.md` | Global personal doctrine. Highest authority. |
| 2 | Project / worktree `CLAUDE.md` | Project-specific overlays. Cannot contradict Tier 1. |
| 3 | `procedural/workflows/*.md` | Named protocols (session-shutdown, memory-auto-sync, etc). Cannot contradict Tier 1–2. |
| 4 | Skill `## Rules` section | Hard constraints inside individual SKILL.md files. Cannot contradict Tier 1–3. |
| 5 | Skill `## Learnings` section | Heuristics, patterns, observed improvements. Cannot contradict Tier 1–4. |
| 6 | `episodic/sessions/*.md` | Session-specific context. Lowest binding authority. |

Working memory (`~/.claude/projects/.../memory/`) attaches to whichever tier the memory-type implies (feedback memory ≈ Tier 5, project memory ≈ Tier 6, user memory ≈ Tier 1 reflection).

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
