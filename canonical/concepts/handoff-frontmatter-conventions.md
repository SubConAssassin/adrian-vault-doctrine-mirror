---
title: Handoff Frontmatter Conventions — Decision Gates + Auto-Loop Discipline
type: doctrine
status: active
tier: 2
firewall_class: working-internal
version: 1.0
created: 2026-05-06
last_updated: 2026-05-06
authority: Adrian directive 2026-05-06 + ChatGPT CEO assessment of BridgeBus paper
related:
  - canonical/concepts/agent-budget-framework.md
  - canonical/infrastructure/hivemind-iphone-bridge.md
  - tools/handoff-notify/ag-to-claude-auto-wake.sh
  - working/coordination/current-work-allocation.md
---

# Handoff Frontmatter Conventions — Decision Gates + Auto-Loop Discipline

## Why this exists

As of 2026-05-06, an auto-wake watcher (`tools/handoff-notify/ag-to-claude-auto-wake.sh` + `com.adrianvault.agtoclaudewatcher` LaunchAgent) monitors `working/handoffs/` and is wired to invoke Claude via `claude -p` when AG-to-Claude handoffs land. The watcher currently runs in **DRY_RUN mode by default** — it logs intent but does not fire.

To make this safe to flip to live mode, every handoff MUST carry the frontmatter fields below. The watcher honours these as hard gates.

Per ChatGPT/Adrian assessment of the BridgeBus paper (2026-05-06): *"any auto-loop must respect [the api-budget-lockdown rule] ... Need a `requires_adrian: true` flag in handoff frontmatter that pauses the auto-loop ... Don't auto-loop on anything Stephan-related, Erica-related, or financial — those are decision domains, not execution."*

## Required frontmatter fields

### Existing (already in use)

```yaml
---
title: <short title>
type: handoff
direction: claude-to-ag | ag-to-claude | claude-to-adrian | claude-self | etc.
date: YYYY-MM-DD
priority: HIGH | MEDIUM | LOW | SUPERSEDED
budget_class: claude-self | claude-strategy | ag-file-work | ag-with-claude-supervision | external-authorised | mixed
purpose: <one-line purpose statement>
---
```

### NEW (effective 2026-05-06) — decision gates

```yaml
requires_adrian: true | false   # default: false
```

- **`requires_adrian: true`** → auto-wake watcher SKIPS this handoff. Item lands in Adrian's decision queue (surfaced via inbox-feed notification + iPhone bridge). Use for any handoff that:
  - Asks Adrian a question
  - Proposes architecture changes
  - Touches external spend
  - Touches financial / legal / strategic-relationship domains (Stephan / Erica / Marcus / etc.)
  - Affects published-facing brand / customer copy without prior approval

- **`requires_adrian: false`** (default) → eligible for auto-wake processing. Use for routine execution work where Claude/AG can iterate without per-step approval.

### Topic locks (HARD-CODED in the watcher — apply regardless of `requires_adrian`)

The watcher refuses to auto-wake on any handoff whose **filename or title** matches the LOCKED_TOPICS regex:

```
erica | stephan | financial | legal | wira | daniel-kang
```

These are decision domains, not execution domains. Even with `requires_adrian: false`, handoffs touching these topics route to Adrian's queue, not to auto-loop.

To add or remove a locked topic: edit `LOCKED_TOPICS` in `tools/handoff-notify/ag-to-claude-auto-wake.sh`. This is intentionally stored in code (not config) — adding/removing a locked topic is a presidential-class decision.

## Cost guardrails

Hard daily cap on auto-invocations (current default: **20 per UTC day**). Configured via `DAILY_INVOCATION_CAP` env var in the LaunchAgent plist.

When the cap is hit, additional handoffs:
- Are NOT marked as processed (so they fire when the cap resets next UTC day)
- Are logged to `working/_secretary/auto-loop-ledger.jsonl` with `action: SKIP_DAILY_CAP`

To raise the cap: `launchctl setenv DAILY_INVOCATION_CAP <N>` then unload+load the plist. To make permanent: edit the plist's `EnvironmentVariables` block.

Every invocation (including SKIP variants) is logged to the ledger:

```jsonl
{"timestamp": "2026-05-06T12:00:00Z", "date": "2026-05-06", "file": "<basename>", "action": "INVOKED|DRY_RUN|SKIP_ADRIAN_GATED|SKIP_LOCKED_TOPIC|SKIP_DAILY_CAP|FAILED_NO_CLAUDE_CLI", "...": "..."}
```

Audit the ledger before flipping DRY_RUN → 0 to verify the watcher would fire on the right things and skip the right things.

## Modes

| Mode | DRY_RUN env | Behaviour |
|---|---|---|
| **Default — dry-run** | `1` | Log to ledger; do not invoke Claude. Safe for audit. |
| **Live** | `0` | Invoke `claude -p "process handoff at <path>"` for eligible handoffs, up to the daily cap. |

**To flip to live (per Adrian):**
```bash
launchctl unload ~/Library/LaunchAgents/com.adrianvault.agtoclaudewatcher.plist
# Edit plist: change DRY_RUN value to "0"
launchctl load ~/Library/LaunchAgents/com.adrianvault.agtoclaudewatcher.plist
```

**To pause:**
```bash
launchctl unload ~/Library/LaunchAgents/com.adrianvault.agtoclaudewatcher.plist
```

## Caffeinate dependency

Per `canonical/concepts/sleep-time-protocol.md` (or equivalent overnight-grind doctrine), the Mac sleeps unless `caffeinate` is running. The auto-wake watcher only fires when the Mac is awake (LaunchAgent + WatchPaths require an active OS scheduler).

This is acceptable — the loop catches up when the Mac wakes. AG handoffs that landed during sleep will be processed in the order they arrived once the system resumes. Marker files (`working/_secretary/auto-wake-markers/`) ensure no double-firing.

For overnight grind sessions where AG is producing handoffs and Claude should process them in real time, ensure `caffeinate` is active for the duration.

## Recommended first live test (per ChatGPT)

> *"Test on one non-critical workflow first (the YouTube-Acuna transcription pipeline already in your open-actions is a good candidate) before generalising."*

When ready to flip live: pick the YouTube-Acuna transcription handoff as the first ag-to-claude that auto-fires. Audit the ledger entry and the resulting Claude session. If clean, expand confidence.

## What this is NOT

- Not a replacement for the inbox-feed-tail notification daemon (`com.adrianvault.inboxfeedtail`) — that runs in parallel and gives Adrian Mac/iPhone notifications regardless of whether the auto-wake fires.
- Not a substitute for `requires_adrian` discipline — the gate is at the source (frontmatter authoring), not at the consumer.
- Not a budget-tracking system — the daily invocation cap is a circuit breaker, not a financial accounting layer. Real spend tracking lives in `agent-budget-framework.md` reconciliation.

## Open items

- **Live-mode flip:** awaiting Adrian's go after dry-run audit.
- **Cost-cap calibration:** 20/day is a starting estimate. After 1 week of live operation, calibrate against observed AG output rate + actual Claude API spend.
- **Failure-mode handling:** if an auto-invoked Claude session itself produces wrong output, the marker file prevents re-firing — but does NOT undo the bad output. Add a "reverse" step? Or accept and rely on Adrian's session-end review? (Adrian decides.)
- **Locked-topic expansion:** consider adding `marcus`, `gino`, `yoga` (suppliers/key-person dependencies) once we've operated live for a week and seen what breaks.

— Created 2026-05-06 ~12:15 WITA by Claude (Chief of Staff), in response to Adrian dispatch + ChatGPT CEO assessment of the BridgeBus paper.
