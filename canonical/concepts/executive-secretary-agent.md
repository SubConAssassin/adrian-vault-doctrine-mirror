---
title: Executive Secretary Agent — Spec
type: agent-spec
status: v0.1 — APPROVED 2026-05-04 by Adrian; awaiting AG build
version: 0.1
created: 2026-05-04
last_updated: 2026-05-04
authored_by: claude (CEO / Chief of Staff)
related:
  - canonical/system/executive-infrastructure-proposal.md (parent proposal)
  - canonical/concepts/production-manager-agent.md (template pattern)
  - canonical/concepts/corporate-agent-architecture.md
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/ceo-execution-schedule.md
  - canonical/frameworks/bulletproof-entrepreneur-blueprint.md
purpose: |
  The Executive Secretary is the cross-cutting agent that aggregates every
  parked, pending, overdue, or escalated item across the vault into ONE daily
  Adrian-facing briefing file. It exists so that nothing drifts, no decision
  gets buried, and Adrian's daily attention is allocated to the highest-leverage
  CEO actions.
tags: [agent, executive-secretary, drift-prevention, briefing, blueprint, mind-pillar]
---

# 1. Charter

Produce ONE daily file that tells Adrian:
- What decisions are waiting on him
- What's gone dormant and needs attention
- What's overdue
- What risks just moved
- What three things, max, deserve his focus today

Protect human tokens. Surface, don't nag. File, not notification.

The agent owns:
- Daily aggregation across all vault state sources
- Briefing file generation
- Parked-decisions ledger maintenance
- Content pipeline overdue detection
- Risk register surfacing into the briefing

The agent does **not** own:
- Auto-publishing anything (especially SS — Mind-pillar guard, see §6)
- Sending notifications, push alerts, or interrupts
- Making decisions on Adrian's behalf
- Modifying the Production Manager Agent's domain (OSB pricing — separate specialist)
- Writing content (that's Copy & Scripting department)

# 2. Where this agent sits in the team

Per `canonical/concepts/corporate-agent-architecture.md`: **cross-cutting under Chief of Staff (Claude)**, not a new department. The 7-department org chart stays as is. This agent is to the Chief of Staff what an executive assistant is to a human Chief of Staff — it preps the daily view, it doesn't run a function.

Reporting line: Executive Secretary → Claude (Chief of Staff) → Adrian (CEO).
Lateral peer: Production Manager Agent (OSB pricing domain).
Substrates the role can run on:
- **Preferred:** Python script + LaunchAgent on Adrian's Mac (canonical operational form, same as Production Manager)
- **Fallback:** Antigravity scheduled task
- **Future v0.2:** n8n migration if cross-system triggering becomes needed

# 3. Inputs (what the agent reads)

| Input | Source | Frequency | Form |
|---|---|---|---|
| Dormant drafts | `working/drafts-pending/*.md` | Daily | Filesystem listing + frontmatter parse |
| Pending review handoffs | `working/handoffs/*.md` where `requires_review: true` and no `*-ack.md` companion | Daily | Frontmatter parse |
| Recently closed leases | `working/_locks/_completed/` (last 24h) | Daily | Filesystem listing |
| Claude's queue | `canonical/concepts/ceo-execution-schedule.md` (BLOCKED + QUEUED sections) | Daily | Markdown section parse |
| Dispatcher escalations | `working/_events/inbox.ndjson` | Daily | NDJSON parse |
| Parked decisions ledger | `canonical/state/parked-decisions.json` | Daily | JSON read |
| Content pipeline state (SS) | `canonical/state/content-pipeline-ss.json` | Daily | JSON read |
| Content pipeline state (OSB) | `canonical/state/content-pipeline-osb.json` | Daily | JSON read |
| Risk register RAG state | `canonical/system/predictive-risk-register.md` | Daily | Markdown table parse |
| External deadlines | scan all `canonical/cases/*.md` for `next_deadline` frontmatter field | Daily | Frontmatter parse |
| Production Manager refresh | latest `working/handoffs/*-production-manager-refresh.md` | Daily (if present) | Markdown read |

# 4. State files

The agent maintains three state files:

```
canonical/state/
  ├─ parked-decisions.json       (presidential/parked items + resurface cadence)
  ├─ content-pipeline-ss.json    (SS content state machine)
  └─ content-pipeline-osb.json   (OSB content state machine)
```

## 4.1 `parked-decisions.json` schema

```json
{
  "schema_version": "0.1",
  "last_updated": "2026-05-04T00:00:00+08:00",
  "decisions": [
    {
      "id": "uuid",
      "captured_at": "2026-05-04T00:00:00+08:00",
      "title": "Approve Marcus Schmieke follow-up letter",
      "context_link": "working/drafts-pending/2026-04-22-marcus-schmieke-follow-up.md",
      "type": "presidential",
      "venture": "OSB",
      "blocking": "Investment raise — $250k window closes if no contact made by 2026-05-15",
      "first_surface": "2026-04-22",
      "resurface_cadence": "daily",
      "last_surfaced": "2026-05-03",
      "status": "open",
      "blueprint_pillar": "money",
      "priority_weight": 3
    }
  ]
}
```

`type` enum: `presidential | tactical | parked-idea | overdue-action`
`status` enum: `open | decided | rejected | parked`
`resurface_cadence` enum: `daily | weekly | parked-30d | parked-90d`
`priority_weight`: 1 (highest) → 5 (lowest), used in §5 prioritisation
`blueprint_pillar` enum: `business | money | mind | life`

## 4.2 `content-pipeline-{venture}.json` schema

```json
{
  "schema_version": "0.1",
  "venture": "ss",
  "last_updated": "2026-05-04T00:00:00+08:00",
  "items": [
    {
      "id": "uuid",
      "title": "FB post — Mahala win story",
      "draft_path": "working/drafts-pending/2026-05-04-ss-fb-post-1.md",
      "state": "drafted",
      "state_owner": "adrian",
      "drafted_at": "2026-05-04T20:00:00+08:00",
      "drafted_by": "ag",
      "scheduled_for": null,
      "published_at": null,
      "published_url": null,
      "channel": "facebook",
      "blueprint_pillar": "mind",
      "overdue_threshold_hours": 168,
      "notes": "5-of-5 batch from Tone-of-Voice router (2026-05-04). SS-specific: state transitions adrian-manual per Mind-pillar guard."
    }
  ]
}
```

`state` enum: `drafted | reviewed | scheduled | published | measured | archived`
`state_owner` enum: `adrian | ag | claude`

**Owner-of-transition table (encoded in the script logic, not the state file):**

| Transition | SS owner | OSB owner | Why |
|---|---|---|---|
| drafted → reviewed | adrian | ag | SS review IS the resistance moment |
| reviewed → scheduled | adrian | ag | Same |
| scheduled → published | adrian | adrian (initially) | SS publishing IS the bottleneck. OSB publishing is also Adrian-controlled in v0.1 — automation is a v0.2 question after a clean week. |
| published → measured | claude | claude | Pure read |
| measured → archived | claude | claude | Pure read |

**SS Mind-pillar guard (encoded in script):** any item with `venture: ss` and `state: drafted` does NOT auto-transition under any circumstance. The state machine surfaces it; only Adrian's manual action moves it forward.

# 5. Decision logic — Priority sort for "today's focus"

The agent picks AT MOST 3 items for the "Today's CEO recommended focus" section. Selection rule:

```
Score each candidate item:
  base_score = 100 - (priority_weight * 10)         # priority_weight 1 → 90, 5 → 50
  + 50 if external_deadline within 72h
  + 30 if status is RED on risk register
  + 20 if blocking another item
  + 10 if first_surface > 14 days ago and still open
  - 30 if Mind-pillar guard active for this item
       AND it has been surfaced as focus already this week

Sort descending by score. Take top 3.
```

The "Mind-pillar guard": for `blueprint_pillar: mind` items (the FB resistance, primarily), the agent **must not** put the same item in "Today's focus" more than once per 7-day window. Reason: daily nag-cycling reinforces the resistance pattern and undermines the SS methodology. The item still appears in the "Drafts dormant >48h" section — visible, never hidden — but it consumes a focus slot at most weekly.

# 6. Tools the agent calls

| Tool | Purpose | Auth |
|---|---|---|
| `python3 ~/Documents/Adrian-Vault/tools/executive_secretary_briefing.py` | Daily aggregation + briefing generation | none |
| Filesystem reads (frontmatter parsers) | Input ingestion | none |
| `python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py` | One-shot prioritisation tie-break (rare; only when 2 items have identical scores in top-3 cutoff) | api-key on Mac |
| LaunchAgent plist `~/Library/LaunchAgents/com.adrian-vault.executive-secretary.plist` | Schedule daily 06:00 WITA | none |

The agent **never** writes to anything outside `canonical/state/`, `working/briefings/`, and `working/governance-flags/`. It is read-mostly by design.

# 7. Briefing format

Each daily run writes to `working/briefings/YYYY-MM-DD-executive-briefing.md`:

```markdown
---
type: executive-briefing
date: 2026-05-05
generated_at: 2026-05-05T06:00:00+08:00
agent: executive-secretary
state_summary:
  parked_decisions_open: 7
  drafts_dormant_48h: 5
  overdue_actions: 2
  risk_red: 0
  risk_amber: 1
---

# Executive Briefing — 2026-05-05

## Today's CEO recommended focus (max 3)
1. {item with highest score} — {one-line context}
2. {item with second-highest score} — {one-line context}
3. {item with third-highest score} — {one-line context}

## Decisions awaiting you (presidential)
1. {title} — blocking: {what} — link: {context_link}

## Drafts dormant >48h (review queue)
1. {filename} — channel: {channel} — venture: {venture} — drafted: {n} days ago

## Overdue actions
1. {title} — was due: {date} — venture: {venture} — link: {context_link}

## Risk register movements
- {risk} moved to {colour} — leading indicator: {value} — recommendation: {action}
(Or: "No movements since last briefing.")

## Closed since last briefing (FYI, no action)
1. {title}

## Parked items resurfacing today (cadence-driven)
1. {title} — last surfaced: {date} — context: {link}

## Production Manager status (if present)
- Drift level: {level} — {one-line summary}
- Full refresh: {handoff link}

## Notes
- Briefing generation: OK | issues: {list}
- Next briefing: 2026-05-06 06:00 WITA
```

# 8. The agent's first job (immediately after Adrian sign-off — DONE 2026-05-04)

1. Initialise empty `canonical/state/parked-decisions.json` with `decisions: []`.
2. Initialise empty `canonical/state/content-pipeline-ss.json` and `canonical/state/content-pipeline-osb.json`.
3. Scan `working/drafts-pending/` and populate `content-pipeline-ss.json` with the 5 SS Facebook posts (state: `drafted`, state_owner: `adrian`, blueprint_pillar: `mind`).
4. Scan `working/drafts-pending/` and populate `content-pipeline-osb.json` with anything OSB-tagged (state: `drafted`, state_owner: `ag`).
5. Run the first end-to-end briefing for 2026-05-05 06:00 WITA. Adrian opens; this is the first proof point.
6. From there, daily cadence per §3.

# 9. Failure modes the agent must guard against

| Failure | Mitigation |
|---|---|
| Empty queue (nothing to surface) | Still write briefing. State: "No items today. SS pipeline state: {state}. Continue current focus: {last week's focus}." |
| State file corruption | Halt run. Write `working/governance-flags/YYYY-MM-DD-executive-secretary-corruption.md` with backtrace. Last good state preserved. |
| Same item surfaced 7 days running with no decision → **drift candidate** | Tag in briefing: "DRIFT FLAG — {item} surfaced 7 days no decision. Recommend: decide today, park to 30d, or reject." This is a real warning. |
| Missing input file | Log to briefing notes. Continue with available inputs. |
| LaunchAgent fails to fire | Detected by Claude on session start (briefing for today's date is missing). Manual invocation: `python3 ~/Documents/Adrian-Vault/tools/executive_secretary_briefing.py --date today`. |
| Mind-pillar guard tripped (SS item would be surfaced as focus 2nd time in 7d) | Honour the guard. Item still appears in "Drafts dormant" section. |
| AG hasn't filed `*-ack.md` companion to a `requires_review:true` handoff after 7d | Treat as overdue action. Surface in briefing. |
| Risk register file not yet built (Component C) | Run without it. Section header reads: "Risk register: not yet active (Component C deferred)." |

# 10. Build sequence

| Step | Owner | Output | Status |
|---|---|---|---|
| 1. Spec written | Claude | This file | DONE 2026-05-04 |
| 2. State-file scaffolding | AG | 3 JSON files initialised | Pending |
| 3. Python script | AG | `tools/executive_secretary_briefing.py` | Pending |
| 4. LaunchAgent plist | AG | `~/Library/LaunchAgents/com.adrian-vault.executive-secretary.plist` | Pending |
| 5. Populate SS pipeline (5 dormant posts) | AG | `content-pipeline-ss.json` populated | Pending |
| 6. First test briefing | AG run script | `working/briefings/2026-05-05-executive-briefing.md` | Pending |
| 7. Populate OSB pipeline | AG | `content-pipeline-osb.json` populated | Pending after step 6 |
| 8. Risk Register v0.1 | Claude | `canonical/system/predictive-risk-register.md` | Deferred ~14 days |

AG-estimated effort for steps 2–7: **~55 minutes total** (per AG ack 2026-05-04).

# 11. Why this is in `canonical/concepts/`

Doctrine for how Adrian's daily executive view is constructed is doctrine, not project-state. It belongs alongside:
- `production-manager-agent.md` (peer specialist)
- `corporate-agent-architecture.md` (org chart this agent reports into)
- `dispatcher-protocol.md` (concurrency substrate this agent reads from)
- `ceo-execution-schedule.md` (Claude's view that feeds Adrian's view)

Project-state about specific decisions or content items lives in `canonical/state/` (the JSON files this agent maintains).

# 12. Blueprint alignment (recap)

| Blueprint principle | How this agent honours it |
|---|---|
| Track numbers | The agent IS the tracking instrument |
| One offer nailed | SS Mind-pillar guard preserves the bottleneck where the methodology requires it |
| Stage 3 thinking on Stage 1 reality is dangerous | "Drift candidate" flag (§9) detects this pattern |
| Become the client you want to attract | Adrian operates with a Chief of Staff + Executive Secretary — congruency with HNW positioning |
| Build the right network | This agent is part of the Hive Mind network, not a workaround for it |

# 13. Versioning

- v0.1 (this) — Python LaunchAgent, file-based briefing, three state files
- v0.2 (deferred) — n8n migration if cross-system triggering needed (e.g. Wix scheduled-publish triggers, Calendar integration)
- v0.3 (deferred) — Notification UX (only if 4+ weeks of clean v0.1 operation prove Adrian wants more than file-based)

End of agent spec v0.1.
