# 02 — CLI Capacity and Pipeline Strategy

## Purpose

Define how many AI/CLI windows each machine should run and how to route work across the LAN cluster.

This is based on practical operational load, not theoretical maximum process counts.

## Practical capacity estimates

| Node | Heavy AI/code sessions | Medium CLI agents | Light monitor jobs | Notes |
|---|---:|---:|---:|---|
| Commander — M5 Max 128GB | 3–4 | 6–8 | 2–4 | Keep responsive for Adrian's live command work |
| Forge — M2 Ultra 192GB | 4–6 | 8–12 | 4–8 | Primary heavy worker; best place for long-running jobs |
| Bridgekeeper — M1 Max 64GB | 1–2 | 3–4 | 4–6 | Use mainly for coordination and verification |
| Lantern — 2014 i7 16GB | 0 | 0–1 very light | 1–3 | Dashboard/watchdog only |

## Conservative starting mode

Begin with conservative limits and measure memory pressure, swap, thermal load, and subscription/API limits.

| Node | Heavy | Medium | Light |
|---|---:|---:|---:|
| M5 Max | 2–3 | 3–5 | 2–4 |
| M2 Ultra | 4 | 4–6 | 4–8 |
| M1 Max | 1 | 2–3 | 4–6 |
| 2014 i7 | 0 | 0 | 1–3 |

Only move to aggressive mode after stability is proven.

## Aggressive mode

| Node | Heavy | Medium | Light |
|---|---:|---:|---:|
| M5 Max | 4 | 4–6 | 4 |
| M2 Ultra | 6 | 8–12 | 8 |
| M1 Max | 2 | 3–4 | 6 |
| 2014 i7 | 0 | 0–1 | 3 |

Aggressive mode should be used for sprints, not as a permanent default.

## Pipeline roles

### Commander assigns

Adrian works primarily from the M5 Max.

Commander should:

- Decide strategy.
- Define task packets.
- Assign work to Forge and Bridgekeeper.
- Review diffs and final outputs.
- Avoid doing all background work locally when Forge is online.

Example instruction:

```text
Forge: refactor backend auth flow.
Bridgekeeper: monitor Git changes, verify Obsidian state updates, and confirm shutdown protocol compliance.
Commander: review final diff, tests, and blockers only.
```

### Forge executes

Forge should run the heavy sessions.

Recommended tmux sessions/windows:

```text
tmux session: forge
0: forge-lead
1: backend-worker
2: frontend-worker
3: tests
4: research-worker
5: local-llm
6: indexer
7: git
8: logs
```

Heavy jobs for Forge:

- Repo-wide refactors.
- Test/build loops.
- Local model inference.
- Vector indexing.
- Large transcript/content processing.
- Multi-agent code execution.
- Long context analysis.

### Bridgekeeper verifies

Bridgekeeper should not compete with Forge for heavy coding.

Recommended tmux sessions/windows:

```text
tmux session: bridgekeeper
0: status
1: obsidian-sync
2: git-audit
3: handoff-check
4: backup-watch
5: light-agent-1
6: light-agent-2
7: logs
```

Bridgekeeper duties:

- Check whether Forge updated the required files.
- Check whether Git commits were made.
- Check whether tests passed.
- Detect uncommitted work.
- Detect iCloud/Obsidian sync conflicts.
- Maintain active session registry.
- Summarise what changed since last handoff.

### Lantern watches

Lantern should be low-friction and always available.

Recommended usage:

```text
tmux session: lantern
0: lan-health
1: nas-status
2: forge-ping
3: bridgekeeper-ping
4: backup-tail
```

Possible jobs:

- `ping` checks.
- NAS web dashboard.
- SSH terminal.
- log tailing.
- backup job progress.
- simple uptime scripts.
- display-only status board.

## CLI routing principle

Route tasks by resource requirement:

| Task type | Best node |
|---|---|
| Live strategy / prompt design | Commander |
| Heavy coding/refactor | Forge |
| Repo-wide tests/builds | Forge |
| Local LLM / embeddings | Forge or Commander when travelling |
| Git audit | Bridgekeeper |
| Obsidian handoff validation | Bridgekeeper |
| Backup monitoring | Bridgekeeper or Lantern |
| LAN/NAS status display | Lantern |
| Emergency terminal access | Lantern |

## Session registry

Maintain a shared file, ideally in Obsidian and/or GitHub bridge:

```text
AI-OPS/ACTIVE_SESSIONS.md
```

Example structure:

```markdown
# Active Sessions

## Forge
- Session: backend-worker
- Tool/account: Claude account 2
- Task: Refactor auth flow
- Status: Running
- Last verified: 2026-06-11 20:30
- Blocker: none
- Next check: 21:00

## Bridgekeeper
- Session: git-audit
- Tool/account: local scripts / light CLI
- Task: Check uncommitted changes and bridge updates
- Status: Running
- Last verified: 2026-06-11 20:32
- Blocker: none
```

## Shutdown requirement

Every serious AI/CLI session must end by updating shared state.

Minimum shutdown writes:

- Task completed.
- Files changed.
- Commands run.
- Tests passed/failed.
- Decisions made.
- Blockers.
- Next action.
- Verification/read-back result.

Bridgekeeper should police this.
