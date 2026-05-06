---
title: Adrian-OS — Event Bus and Hive-Mind Coordination
type: framework
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-04-20
last_updated: 2026-04-20
related:
  - canonical/concepts/corporate-agent-architecture.md
  - canonical/concepts/handoff-frontmatter-conventions.md
  - canonical/concepts/dispatcher-protocol.md
tags: [adrian-os, event-bus, hivemind, architecture, phase-1]
---

## Thesis

The vault is not only shared memory — it is also the event bus for inter-agent
coordination. Every meaningful action writes state to the vault; `fswatch`
(Phase 2) observes state changes and fires triggers; agents act on triggers
relevant to their role.

This replaces polling, manual handoff, and "Claude, did Antigravity finish yet?"

## Directory convention (canonical as of Phase 1)

```
working/
├── intents/             Adrian's inbound instructions (one file per intent)
├── dispatches/          Commissions out to specialists
├── returns/             Completed work from specialists, pending review
├── signals/             Inter-agent pings (small, structured, event-like)
├── _events/             fswatch event log (Phase 2 onwards)
├── chatgpt-dispatches/  ChatGPT-specific dispatch log
├── handoffs/            Legacy agent-to-agent docs (pre-Adrian-OS, still honoured)
├── holding/             Files awaiting categorisation
├── ingestion-briefs/    Pre-vault drafts being formalised
├── deep-extraction/     Long-form transcript / source extractions
└── session/             Active-session working files
```

## Filename convention

`YYYY-MM-DD-HHMM-SHORTID-SLUG.md`

Where SHORTID is the first 8 chars of a UUID. This makes lexical sort = chronological sort.

## Frontmatter convention

Every file in `working/intents/`, `working/dispatches/`, `working/returns/`, `working/signals/`, and `working/chatgpt-dispatches/` has frontmatter with at minimum:

```yaml
---
uuid: full-uuid-here
short_id: first8chars
created_at: ISO-8601
status: pending | in-progress | dispatched | completed | blocked | cancelled
parent_ref: SHORTID-of-parent-if-any
---
```

This enables UUID-based trace chains across multi-agent workflows.

## Governance

- **Canonical writes:** Claude (claude.ai) only. Enforced by convention.
- **Working directory writes:** any agent, any source. No gatekeeping.
- **Promotion from working to canonical:** Claude reviews, Adrian approves.
- **Retention:** `working/` kept indefinitely in Phase 1. Phase 3+ may
  archive older entries to `episodic/`.

## Phase status

- **Phase 1 (installed 2026-04-20 17:34):** directory structure live, ChatGPT dispatch working, canonical docs written. Manual orchestration still.
- **Phase 2 (installed 2026-04-20 17:50):** launchd event bus + hourly stall check + ChatGPT response auto-capture all installed. Uses native launchd `WatchPaths` (no fswatch/brew dependency). **One-time TCC permission required**: grant `/bin/bash` Full Disk Access, else launchd jobs silently fail.
- **Phase 3 (next):** always-on Claude Code orchestrator session in tmux, morning/weekly briefing automations, intent → dispatch auto-routing.
- **Phase 4:** Antigravity, Gemini, Grok, Cowork wired to consume/emit via the same conventions.
- **Phase 5:** auto-promotion rules, governance dial set to "aggressive".

## Notification channel (Phase 1 default)

- **Mac notification:** always fires via `display notification` — appears on iPhone
  via Continuity / Notification Center when Mac is nearby or connected.
- **iMessage-to-self:** fires when `APPLE_ID` is set in `~/.adrian-os.conf`.
  Needs Adrian's Apple ID / iMessage address. Pending.

Future (Phase 2+): scheduled sweeps will generate briefings Adrian's iPhone picks
up via the same iMessage-to-self channel.

## Orchestrator boldness

Governance dial (set 2026-04-20): **balanced**.
- Auto-files: research returns, drafting work, filing tasks
- Auto-escalates to Adrian: external comms, money, legal, canonical promotions,
  irreversible actions, ambiguous intent
- Rule of thumb: if reversing the action would cost more than 2 minutes of Adrian's time,
  ask first. Otherwise act.

## Phase 2 inventory (what's installed)

### Scripts (in `~/Documents/Adrian-Vault/bin/`)
- `chatgpt-dispatch.sh` — send prompt to ChatGPT app, log to vault
- `chatgpt-dispatch-capture.sh <short_id>` — capture ChatGPT response text into vault file
- `adrian-os-event-dispatcher.sh` — scan `working/` for new files, emit events to `_events/inbox.ndjson`
- `adrian-os-stall-check.sh` — find dispatches still `dispatched` after 24h, notify Adrian

### launchd agents (in `~/Library/LaunchAgents/`, source templates in `bin/launchd/`)
- `com.adrianos.watcher.plist` — WatchPaths on `working/{intents,dispatches,returns,signals,chatgpt-dispatches}`, runs event-dispatcher on change (ThrottleInterval 10s)
- `com.adrianos.stall-check.plist` — hourly StartInterval, runs stall-check

### Logs (in `~/Library/Logs/adrian-os/`)
- `dispatcher.log` — every event-dispatcher fire
- `stall-check.log` — every stall-check fire
- `watcher.stderr.log` / `watcher.stdout.log` — launchd-captured stdio for watcher
- `stall-check.stderr.log` / `stall-check.stdout.log` — same for stall-check

## Known gotchas

- **TCC / Full Disk Access required for `/bin/bash`.** launchd-spawned bash runs without access to `~/Documents/` unless granted FDA. Symptom: `watcher.stderr.log` shows `Operation not permitted`. Fix: System Settings → Privacy & Security → Full Disk Access → add `/bin/bash`.
- **Response capture is best-effort.** `chatgpt-dispatch-capture.sh` uses `Cmd+A / Cmd+C` UI automation to grab ChatGPT text; if ChatGPT's UI changes, capture may return partial content. Fallback: read ChatGPT app directly (conversation syncs across devices).
- **ThrottleInterval 10s on watcher.** Rapid successive file drops may not each trigger a separate fire, but the dispatcher scans everything-newer-than-last-run so no events are lost.

## Related
- `canonical/concepts/chatgpt-dispatch-protocol.md`
- `canonical/concepts/hive-mind-resource-map.md`
- `canonical/ecosystem/shared-infrastructure.md`
