---
title: Corporate Agent Architecture (Hive Mind v2)
type: doctrine
status: canonical
authority: Tier-2 (project-overlay)
created: 2026-05-04
last_updated: 2026-05-04
lineage: "AG v1 (1:08am 2026-05-04) + Claude governance enhancements (1:18am 2026-05-04) + Adrian approval (1:25am 2026-05-04)"
related:
  - canonical/concepts/precedence-hierarchy.md
  - canonical/concepts/agent-budget-framework.md
  - canonical/system/persona-router.md
  - AGENTS.md
  - CLAUDE.md
---

# Corporate Agent Architecture (Hive Mind v2)

## 1. Operating Model
Adrian (CEO) issues audio mandates. Claude (Chief of Staff) intakes/synthesises/routes. Specialist Departments execute under constrained skill scopes. Antigravity is the labour layer that physically writes/builds inside skill scopes.

**Critical:** Chief of Staff is **orchestration only — not a department.** Claude does not write copy, generate images, deploy ads, draft legal, or run research APIs directly. Claude routes, verifies, synthesises.

## 2. The Org Chart (7 Departments + 1 Orchestrator)

| # | Department | Owns | Skill Stub |
|---|---|---|---|
| 0 | Chief of Staff (Claude) | Routing, verification, synthesis, ledger updates | (no skill — operating doctrine) |
| 1 | Copy & Scripting | Voice-locked sales copy, scripts, sequences | `mkt-copywriting` (exists, extend) |
| 2 | Post-Production & Video | Veo 3, Playwright/Marketing Studio, image gen | `mkt-video-postprod` (new) |
| 3 | Social Media & Marketing | Platform-native posting, 5-angle ad tests, analytics | `mkt-social-deploy` (new) |
| 4 | Voice & Persona Doctrine | `voice-profile.md`, `persona-catalog.md`, firewall classification | `voice-persona-curator` (new) |
| 5 | Research & Cross-Pollination | ChatGPT/Grok one-shot, cross-model synthesis, market scans | `research-crosspollinate` (extend `str-trending-research`) |
| 6 | Legal & Disputes | Erica, parcels, contracts, demand letters | `legal-dispute-mgr` (new) |
| 7 | Finance & Ops | Ledger maintenance, budget reconciliation, AG burn tracking | `ops-ledger-keeper` (new) |

**App integrations route INTO depts (not standalone):**
- TUNED App / Sheldrake telephone telepathy → Ashta venture, Research dept builds the experiment harness
- Voice / Enlightened by Voice → Voice & Persona dept (diagnostic input)
- Angel Numbers Community App → Social Media dept (community deployment)

### Skill Department to Team Role Mapping

The vault maps the 7 corporate-dept skills to `shared/personas/team-roster/` roles:

| Department (skill) | Team Role (persona card) |
|---|---|
| Copy & Scripting (`mkt-copywriting`) | master-scriptwriter |
| Voice & Persona (`voice-persona-curator`) | (Adrian / no team-role — owns Adrian's voice) |
| Post-Production (`mkt-video-postprod`) | production-director |
| Social Marketing (`mkt-social-deploy`) | social-strategist |
| Research (`str-trending-research`) | (no team-role — Grok owns this per blueprint) |
| Legal (`legal-dispute-mgr`) | (need: legal-counsel — flag for future hire) |
| Finance & Ops (`ops-ledger-keeper`) | chief-accountant |

## 3. Per-Department Governance Schema

Every department skill MUST declare in its frontmatter:

```yaml
tier: 4-or-5                          # Skill Rules = Tier 4, Learnings = Tier 5
budget_class: claude-light | ag-heavy | external-presidential
corpus_access: [public | working-internal | strictly-private]   # firewall classes readable
persona_lazy_load: [list-of-allowed-persona-card-ids]  # never auto-loads all
escalation_path: <named-handoff-pattern>
audit_cadence: weekly | per-commission | quarterly
ag_execution: full | write-only | claude-launches
```

`ag_execution: write-only` means AG's sandbox can't run the artefact natively — Claude or Adrian must launch it (per `ag-writes-vs-executes` doctrine). Post-Production and Research are write-only (Veo 3 / Playwright / API CLIs all need terminal launches).

## 4. Default Schema Per Department

| Dept | budget_class | corpus_access | ag_execution | audit_cadence |
|---|---|---|---|---|
| Copy & Scripting | ag-heavy | public + working-internal | full | per-commission |
| Post-Production | ag-heavy | public + working-internal | write-only | per-commission |
| Social Marketing | ag-heavy + external-presidential (ads) | public | write-only | weekly |
| Voice & Persona | claude-light | all 3 incl. strictly-private | full | quarterly |
| Research | external-presidential | working-internal | write-only | per-commission |
| Legal | claude-light | all 3 | full | per-commission |
| Finance & Ops | ag-heavy | working-internal | full | weekly |

## 5. Cross-Department Communication Protocol

Inter-dept comms route through `working/handoffs/` with naming convention:
`YYYY-MM-DD-{dept-from}-to-{dept-to}-{topic}.md`

Departments do NOT call each other directly. Chief of Staff (Claude) reads inbound handoffs and dispatches. Reason: prevents agent-loop chaining (a known failure mode — see ChatGPT one-shot war story).

## 6. Precedence Hierarchy Integration

Department skills sit at **Tier 4–5** of `precedence-hierarchy.md`. Concretely:
- Skill `## Rules` block = Tier 4 (max 5 active rules per skill)
- Skill `## Learnings` block = Tier 5 (max 20 entries, confidence-marked)
- Any rule that contradicts Tier 1–3 = doctrine-impacting → write `working/governance-flags/` and surface to Adrian, do NOT auto-apply

The `context-governance` skill audits all department skills weekly for tier violations.

## 7. Persona Lazy-Load Constraint

**No department auto-loads all persona cards.** Each declares its allowed cards. Examples:
- Copy & Scripting: `siberian-blue-brand-voice`, `subconscious-surgery-spiritual-systems`, `family-bruv` (only when Adrian explicitly authorises informal-register output)
- Voice & Persona: ALL cards (it owns the catalogue)
- Legal: `legal-architect` only
- Research: NONE (research output is voiceless until Copy department reframes it)

## 8. Failure & Escalation Rules

Loud-failure triggers per dept:
- **Copy & Scripting:** voice-QA flag (output reads as agency-slop) → halt, surface
- **Post-Production:** Veo 3 quota exceeded, Playwright sandbox fault → halt, surface
- **Social Marketing:** ad spend > pre-approved cap, platform policy reject → halt, surface
- **Voice & Persona:** firewall violation (private claim leaks public) → halt, surface, RED-TEAM review
- **Research:** API call count > 1 per question → halt, surface (one-shot rule)
- **Legal:** new deadline detected, response window < 48h → surface immediately
- **Finance & Ops:** burn asymmetry (Claude > 60% / AG < 30%) → trigger work shift, surface

## 9. Phase-2 Build Sequence

Recommended order for AG to construct dept skills:
1. **Copy & Scripting (extend existing `mkt-copywriting`)** — highest leverage, voice-locked already
2. **Voice & Persona Doctrine (new)** — owns the source of truth all other depts depend on
3. **Post-Production** — wire to existing Marketing Studio emulator
4. **Social Media** — depends on Copy + Post-Production output
5. **Research & Cross-Pollination** — extends `str-trending-research`
6. **Legal & Disputes** — lowest churn, build last
7. **Finance & Ops** — dovetails with `context-governance` skill build

## 10. What Adrian Decides Now

Single decision: **Approve v2 architecture for Phase-2 build, or request edits.**
If approved → Claude commissions AG to build dept #1 (`mkt-copywriting` extension) tonight.

## 11. What This Does NOT Do
- Does not deploy any department yet — Phase-2 builds the SKILL.md files first
- Does not consume external API budget — internal restructure only
- Does not modify existing skills until each is reviewed under the new schema
- Does not lock TUNED/Voice/Enlightened/Angel Numbers app integrations — those route into depts as concrete builds, sequenced separately
