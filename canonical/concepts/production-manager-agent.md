---
title: Production Manager Agent — Spec
type: agent-spec
status: v0.1 — proposed; awaiting Adrian sign-off on rule constants in production-cost-architecture.md §9
version: 0.1
created: 2026-04-30
last_updated: 2026-04-30
authored_by: claude
related:
  - canonical/projects/osb/production-cost-architecture.md (the rules this agent operates)
  - canonical/concepts/agent-team-cvs.md (where this agent sits in the wider team)
  - canonical/concepts/four-room-stack-architecture.md
  - canonical/concepts/frictionless-operator-doctrine.md
purpose: |
  The Production Manager is the agent-employee responsible for ensuring OSB
  retail prices stay aligned with current input prices (silver, gold, IDR/USD,
  gem and labour costs) without consuming founder attention. It exists to make
  the August 2024 silver-spike-without-retail-adjustment scenario impossible
  to recur silently.
tags: [agent, osb, pricing, production-manager, automation]
---

# 1. Charter

Keep OSB retail prices coherent with current input prices, on a defined cadence, with hard floor-margin alarms that cannot be missed.

The agent owns:
- Daily silver/gold spot pull
- Daily drift computation against the rule baselines
- Weekly full SKU sheet regeneration
- Monthly outlay-row maintenance (Yoga invoice intake, gem cost intake)
- All alerting

The agent does **not** own:
- Multiplier rule changes (R1, R2). Those are doctrine, owned by Adrian.
- Pushing retail changes to Wix unilaterally — proposes only, Adrian approves (within optional auto-approval band, see §6).
- Quoting solid-gold custom pieces — those are bespoke and stay with Adrian.

# 2. Where this agent sits in the team

Per `canonical/concepts/agent-team-cvs.md`, OSB's existing agent stack is generalist (Claude as CEO, Antigravity as builder, ChatGPT as specialist, Codex as shell pilot). This adds **a domain-specialist role** under OSB that any of those generalists can invoke or run as.

Reporting line: Production Manager → Adrian (founder/CEO).
Lateral peers: nobody currently — this is the first specialist role in the agent team.
Substrates the role can run on:
- **Preferred:** Antigravity (file-IO + scheduled tasks, persistent across sessions)
- **Fallback:** Claude Code in a daily scheduled task
- **Cloud-side:** A small Python script invoked by `cron` or `launchd` on Adrian's Mac (the canonical operational form)

# 3. Inputs (what the agent reads)

| Input | Source | Frequency | Form |
|---|---|---|---|
| Silver spot USD/oz, USD/g | metalpriceapi.com (free tier) or kitco.com scrape | Daily 09:00 WITA | JSON |
| Gold spot USD/oz, USD/g (14 kt, 22 kt, 24 kt premiums) | same | Daily | JSON |
| IDR/USD FX | exchangerate-api.io (free tier) | Daily | JSON |
| Bali silver-bullion local premium % | Manual update from Yoga's invoice intake | Monthly | Text |
| Gem wholesale prices (sapphire, tanzanite, ruby, fire opal, topaz) | Manual update on each new wholesale buy | Per-batch | Text |
| Yoga's labour invoice (per piece by metal type) | Manual update from invoice screenshots | Monthly | OCR + manual entry |
| Current Wix retail (per SKU) | Wix API (when wired) or manual paste | Weekly | CSV |
| Markup rules R1, R2 | `canonical/projects/osb/production-cost-architecture.md` §3 | On change only | Markdown |
| `silver_baseline_at_write` and last reset date | `working/extraction/_pricing-state/silver-spot.json` | Updated after Adrian-confirmed reprice | JSON |

# 4. State files

The agent maintains three state files:

```
working/extraction/_pricing-state/
  ├─ silver-spot.json          (daily history, baseline anchor, drift)
  ├─ outlay-current.json       (per-SKU outlay components, refreshed monthly)
  └─ sku-sheet-current.json    (per-SKU computed retail, refreshed weekly + on hard alert)
```

`silver-spot.json` schema:

```json
{
  "baseline": {
    "silver_USD_per_g": 0.95,
    "gold_USD_per_g": 81.6,
    "IDR_per_USD": 16100,
    "set_at": "2026-04-30",
    "set_by": "adrian"
  },
  "current": {
    "silver_USD_per_g": 0.95,
    "gold_USD_per_g": 81.6,
    "IDR_per_USD": 16100,
    "fetched_at": "2026-04-30T09:00:00+08:00"
  },
  "drift": {
    "silver": 1.00,
    "gold": 1.00,
    "IDR": 1.00,
    "level": "normal"
  },
  "history": [
    {"date": "2026-04-30", "silver_USD_per_g": 0.95, "drift": 1.00}
  ]
}
```

# 5. Decision logic (drift bands)

| Silver drift | Action | Channel |
|---|---|---|
| ≤ 1.10 | Log only, no alert | history file |
| 1.10 < drift ≤ 1.25 | **Soft alert.** Regenerate sku-sheet at the next weekly cycle. | Adrian's chosen channel |
| 1.25 < drift ≤ 1.50 | **Hard alert.** Regenerate sku-sheet within 48 h. Propose new Wix prices. | Hard alert channel |
| drift > 1.50 | **Stop-loss alert.** Pause new orders on affected SKUs until retail repriced. | Hard alert channel + Wix flag |

Same bands apply to **gold drift** (affects gold-plate uplift and solid-gold quotes) and **IDR drift** (affects the USD value of Yoga's labour cost).

# 6. Auto-approval band (configurable by Adrian)

| Mode | Behaviour |
|---|---|
| `auto_off` (default for v0.1) | Every retail change proposed via handoff; Adrian explicitly approves; agent then writes to Wix or hands the new sheet back. |
| `auto_inside_band` | If drift is 1.00–1.25 and the proposed new retail differs from current Wix retail by ≤ 8%, the agent applies it directly to Wix (when API access is wired) and notifies Adrian post-fact. Outside the band, fallback to `auto_off`. |
| `auto_full` (not recommended) | Agent always pushes its computed retail. Used only after several months of confirmed clean operation. |

Adrian's choice goes in `canonical/projects/osb/production-cost-architecture.md` §9 item 4.

# 7. Tools the agent calls

| Tool | Purpose | Auth |
|---|---|---|
| `mcp__workspace__bash` (or local `cron`) | Run the daily fetch + drift compute | none |
| `python3 /Users/adriantaffinder/Documents/Adrian-Vault/tools/production_manager_pull.py` | Daily fetch script | none |
| `mcp__961cf566-...__ManageWixSite` (Wix MCP) | Push retail changes to Wix when in `auto_*` mode | Adrian-side OAuth |
| `mcp__dispatch__send_message` | Send alerts to Adrian's Cowork session | session-bound |
| `python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py` | One-shot consultation when an outlay-row needs second opinion (e.g. "is $90 a reasonable wholesale tanzanite price for this size?") | api-key on Mac |

The agent **never** moves money, never executes a Wix transaction, never modifies the multiplier rules.

# 8. Refresh handoff format

Each refresh writes a handoff at `working/handoffs/<date>-production-manager-refresh.md`:

```markdown
---
type: handoff
from: production-manager-agent
to: adrian
date: <ISO>
status: proposal | applied
drift_level: normal | soft | hard | stop-loss
---

# Production Manager refresh — <date>

## Inputs

- Silver spot: <USD/g> (baseline <USD/g>, drift <factor>)
- Gold spot: <USD/g> (baseline <USD/g>, drift <factor>)
- IDR/USD: <rate> (baseline <rate>, drift <factor>)

## Drift verdict
<level>: <one-line reason>

## SKU changes proposed
| SKU | Current Wix retail | Proposed retail | Δ % | Reason |
|---|---|---|---|---|

## SKU changes applied (auto-band only)
(empty for v0.1)

## Outstanding questions for Adrian
1. ...

## Next refresh
<scheduled date>
```

# 9. The agent's first job (immediately after Adrian sign-off)

1. Adrian fills in §9 of `production-cost-architecture.md` (the 8 open items).
2. Agent ingests those answers, sets `silver_baseline_at_write` and the multipliers in `silver-spot.json`.
3. Agent fetches current spot prices.
4. Agent computes the drift from the baseline Adrian just set (drift ≈ 1.00).
5. Agent generates the first `sku-sheet-current.md` with all 18 published Wix variants priced.
6. Agent writes the first refresh handoff.
7. From there, daily/weekly/monthly cadence per §3 of the architecture doc.

# 10. Failure modes the agent must guard against

| Failure | Mitigation |
|---|---|
| Spot-price API returns stale or wrong data | Cross-check two providers; if disagreement > 2 %, hold (don't refresh), alert Adrian |
| FX rate stale | Same: dual-source |
| Wix API rate-limited | Queue and retry with backoff; never partially update a SKU sheet |
| Yoga labour-cost data hasn't been entered for > 60 days | Soft alert to Adrian: "Yoga invoice ingest overdue" |
| Multiplier rule changed without re-baselining | Refuse to refresh until Adrian confirms baseline |
| Network outage | Use cached last-known spot; flag as "stale snapshot" in the handoff |

# 11. Build sequence (when Adrian says go)

1. Adrian completes the 8 open items in §9 of the architecture doc.
2. I (Claude) write `tools/production_manager_pull.py` — daily script.
3. I write `tools/production_manager_compute.py` — drift + SKU sheet generator.
4. I write the LaunchAgent plist for daily 09:00 WITA execution.
5. First end-to-end self-test: agent generates a refresh handoff for the 18 published Wix variants. Adrian reviews. If the numbers track expected retail to within 5%, the agent goes live.
6. v0.2 adds Wix MCP write capability (currently read-only proposals).

# 12. Why this is in `canonical/concepts/`

Doctrine for how the OSB pricing engine is run is doctrine, not project-state. It belongs alongside:
- `frictionless-operator-doctrine.md` (agents do not escalate execution gaps to Adrian)
- `agent-team-cvs.md` (the team this agent joins)
- `four-room-stack-architecture.md` (the substrate ladder this agent runs across)

Project-state about specific SKUs lives in `canonical/projects/osb/`.

End of agent spec v0.1.
