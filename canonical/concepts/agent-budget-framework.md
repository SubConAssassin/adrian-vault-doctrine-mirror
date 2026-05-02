---
title: Agent Budget Framework — The Financial Director Layer
type: doctrine
status: canonical
created: 2026-05-02
last_updated: 2026-05-02
related:
  - canonical/concepts/claude-antigravity-work-partition.md
  - canonical/concepts/24-7-operating-model.md
  - canonical/concepts/api-integration-doctrine.md
---

# Agent Budget Framework

Adrian observed (2026-05-02) that the operation is missing a financial-director layer: tasks get commissioned without budget envelopes, spend gets tracked but not allocated, and there is no reconciliation of "what we planned to spend" vs. "what we actually spent."

This canonical defines the **budget envelope** that every commission carries, the **per-project allocation grid**, and the **reconciliation cadence**.

It does NOT replace the existing presidential-spend rule (`feedback-external-spend-presidential.md`). It complements it — the rule controls AUTHORISATION; the framework controls ALLOCATION.

---

## The three resource pools

| Pool | Unit | Constraint | Top-up cadence |
|---|---|---|---|
| **Claude tokens** | tokens | Max 5x weekly cap (~2–3M tokens, resets Thursday 05:00) | Weekly, scarce |
| **Antigravity tokens** | tokens | Google AI Ultra bundle, effectively uncapped for Adrian's volume | Continuous, abundant |
| **External API dollars** | USD | Presidential per-call ($0.10–$0.20 typical, $0.50 ceiling) | Per-call manual |

The framework treats **Claude tokens as the scarce resource** — that's the bottleneck Adrian observed when he hit 55% weekly burn by Saturday. AG tokens and external API dollars are managed differently.

---

## Per-project allocation grid (initial draft, to be tuned)

Numbers are weekly envelopes. Adjust based on observed burn over 4 weeks.

| Project | Claude (k tokens) | AG (k tokens) | External ($) |
|---|---|---|---|
| OSB (Original Siberian Blue) | 60 | 300 | 5 |
| SS (Subconscious Surgery) | 50 | 250 | 5 |
| AGA Bali | 20 | 100 | 0 |
| Ashta | 30 | 150 | 0 |
| Bodhisvara | 10 | 50 | 0 |
| Personal corpus / voice work | 40 | 200 | 5 |
| Infrastructure (vault, tooling, n8n) | 30 | 200 | 0 |
| Strategic / cross-project synthesis | 30 | — | 5 |
| **Buffer** | 30 | unlimited | 5 |
| **Total per week** | 300 | 1250 | 25 |

Total Claude weekly target: 300k. If the actual cap is ~2M tokens (per Max 5x), the framework leaves significant headroom for unanticipated work. If the cap is ~1M, the grid is already too tight and projects must be ranked.

These numbers are placeholders. First reconciliation (after week 1 of doctrine adoption) tunes them to reality.

---

## How a commission carries a budget envelope

Every commission file (in `working/handoffs/`) MUST include a `budget_class` frontmatter field with one of:

| Class | Means |
|---|---|
| `AG-CPU-only` | Zero Claude tokens, zero external. AG runs locally on CPU/disk. The cheapest envelope. |
| `AG-with-claude-supervision` | AG executes; Claude reads completion handoff and synthesises. Modest Claude burn. |
| `claude-strategy` | Claude-heavy synthesis. Moderate burn. AG may be commissioned downstream. |
| `external-authorised` | Includes a ChatGPT/Grok/paid-API call. Requires presidential per-call approval BEFORE the commission runs. The commission file names the model, max_tokens, and expected dollar cost. |
| `mixed` | Combination — must enumerate sub-budgets explicitly |

A commission without a `budget_class` is malformed. AG should reject it.

---

## Reconciliation cadence

### Daily (AG, automated)

- Read `working/api-usage.jsonl` (Claude usage log)
- Read `working/_logs/` for AG-side metrics
- Read any external API archives (ChatGPT/Grok auto-archive folders)
- Append daily totals to `working/finance/spend-daily.csv` (file to be created on first run)
- Flag any project that has used >50% of its weekly envelope before Wednesday

### Weekly (Claude or AG, on Thursday morning post-reset)

- Generate `working/finance/weekly-reconciliation-YYYY-MM-DD.md` covering:
  - Per-project: planned vs. actual (Claude / AG / external)
  - Variance > 20%: explanation required
  - Top 5 spend drivers of the week
  - Projects under-utilising: candidates for re-allocation
- File to `working/handoffs/` if it surfaces a re-allocation decision needing Adrian

### Quarterly (Claude, with Adrian)

- Re-set the allocation grid based on observed burn patterns
- Retire defunct projects, scale up high-ROI ones
- Update this canonical with the new grid

---

## Roles in the framework

| Role | Played by | Responsibilities |
|---|---|---|
| **Financial Director** | Claude (synthesising) + AG (collecting) | Owns the framework. Surfaces variances. Recommends re-allocation. Cannot authorise external spend. |
| **Accountant** | AG (automated daily run) | Pulls spend data, writes daily CSV, flags overruns |
| **CEO / President** | Adrian | Authorises external spend. Approves quarterly grid resets. Overrides any envelope with explicit "spend whatever it takes." |
| **Auditor** | AG (in forensic-auditor mode, per `feedback-forensic-verification-of-remediation.md`) | Independent check of whether reconciliation reports match raw data |

---

## What goes wrong if this framework is not in place

Observed failures, all from the prior corpus:

1. **The 1,053-API-call session** (catalyst for `feedback-external-spend-presidential.md`) — no budget envelope, runaway agentic loop, $8 burn on a cents-cost task.
2. **AG underutilisation** (2026-05-02 in-thread observation) — Claude tokens at 55% weekly by Saturday, AG sitting idle. No allocation rule pushed work to the abundant resource.
3. **Untracked external-API multiplication** — multiple sessions making one-off $0.20 calls without aggregation; quarterly cost untracked.
4. **No re-allocation when projects pivot** — when AYA was deprecated April 2026, no reclaim of allocated tokens to other projects.

The framework prevents all four by making allocation explicit and auditable.

---

## What this framework is NOT

- NOT an automated brake — Claude won't refuse a request because a project is over budget. Variance is reported, but execution continues at Adrian's CEO discretion.
- NOT a Claude-token cap. The framework is advisory; the actual cap is Anthropic's weekly limit.
- NOT a substitute for presidential authorisation on external spend. Presidential rule remains binding.

---

## First implementation steps

1. Adopt `budget_class` frontmatter convention in all new commissions (Claude does this when writing handoffs)
2. Commission AG to build `working/finance/spend-daily.csv` aggregator script (overnight grind candidate)
3. After 1 week of data, run first weekly reconciliation
4. After 4 weeks of data, retune the per-project grid
