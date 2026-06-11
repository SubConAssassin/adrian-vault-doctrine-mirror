# 01 — Node Roles

## System overview

Adrian's planned AI cluster should be treated as a LAN-based heterogeneous worker system, not as a group of equal laptops.

The machines differ in memory, thermals, network position, mobility, and operational trust.

## Node table

| Node | Hardware | RAM | Location | Primary role |
|---|---|---:|---|---|
| Commander | M5 Max MacBook Pro | 128GB | Mobile / desk | Human-facing command station and mobile AI workstation |
| Forge | M2 Ultra Mac Studio | 192GB | Dry room | Primary always-on heavy compute node |
| Bridgekeeper | M1 Max MacBook Pro | 64GB | Dry room | Coordination, bridge, monitoring, light/medium CLI work |
| Lantern | 2014 Intel i7 MacBook Pro | 16GB | LAN / dry room | Lightweight dashboard, watchdog, utility, emergency admin |

## Commander — M5 Max 128GB MacBook Pro

Use for:

- Human-facing strategic work.
- Main Claude account and/or highest-priority Claude Code session.
- Antigravity UI when Adrian is actively steering.
- Prompt design, architecture decisions, review, and merge decisions.
- Mobile/offline local LLM work when travelling.
- Remote control of dry-room machines via SSH, tmux, screen sharing, or Tailscale.

Do not overload Commander with every background process while at home. Keep it responsive.

Recommended active load:

- 3–4 heavy Claude Code / Antigravity windows.
- 6–8 CLI agent sessions.
- 1 local LLM workload if travelling or disconnected.
- Several SSH control terminals to Forge / Bridgekeeper / Lantern.

## Forge — M2 Ultra Mac Studio 192GB

Use for:

- Second Claude subscription/account.
- Heavy Claude Code sessions.
- Repo-wide refactors.
- Multi-agent implementation work.
- Local model serving/inference.
- Embeddings/indexing.
- Long-running builds, tests, and analysis.
- Dataset processing.
- Persistent background agent work while Commander travels.

Recommended active load:

- Conservative: 4 heavy Claude Code sessions, 4–6 medium agents, 4–8 light/monitor jobs.
- Aggressive: 6 heavy sessions, 8–12 medium agents, 8 light jobs.

Forge is the engine room.

## Bridgekeeper — M1 Max 64GB MacBook Pro

Adrian currently observes that this machine practically handles around:

- 4 CLI connections.
- 2 heavy coding windows.

Once Forge and Commander are online, do not use Bridgekeeper as a third heavy refactor machine except when necessary.

Use for:

- Obsidian vault sync verification.
- GitHub bridge checks.
- Handoff verification.
- Session registry.
- Backup job monitoring.
- Watchdog scripts.
- Light research agents.
- Small CLI jobs.
- Cross-model bridge tasks between Claude, ChatGPT, Grok, and Antigravity.

Recommended active load:

- 1–2 heavy windows maximum.
- 3–4 CLI connections.
- 4–6 light monitoring/background jobs.

Bridgekeeper is the nervous system.

## Lantern — 2014 Intel i7 MacBook Pro 16GB

This machine should not be used for heavy Claude Code, Antigravity, or local LLMs.

Use it as a low-load utility node:

- Always-on dashboard display.
- SSH terminal into Forge / Bridgekeeper.
- Uptime monitor.
- LAN health monitor.
- NAS status monitor.
- Backup progress screen.
- Obsidian read-only reference station if needed.
- Emergency admin terminal if newer machines are busy or locked.
- Lightweight scripts such as ping checks, rsync status checks, log tailing, and notification relays.

Recommended active load:

- 0 heavy AI sessions.
- 0–1 browser window if necessary.
- 1–3 lightweight terminal sessions.
- Dashboard / monitoring only.

Lantern is the utility light, not the engine.

## Strategic principle

Assign roles by machine strength:

- M5 Max = cockpit.
- M2 Ultra = engine room.
- M1 Max = nervous system.
- 2014 i7 = dashboard/watchman.

This prevents high-value machines from being wasted on low-value monitoring and prevents low-memory machines from being overloaded with work they cannot do efficiently.
