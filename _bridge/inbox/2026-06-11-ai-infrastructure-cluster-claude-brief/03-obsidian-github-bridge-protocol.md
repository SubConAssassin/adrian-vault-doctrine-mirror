# 03 — Obsidian + GitHub Bridge Protocol

## Current known system

Adrian already has:

- Obsidian installed.
- An Obsidian vault synchronized over iCloud.
- Graphify / graph-style vault tooling.
- A full shutdown protocol.
- Lessons saved into the Obsidian vault.
- Architecture/system files updated after work sessions.
- Shared memory between Antigravity and other agents.
- GitHub used as a bridge between ChatGPT, Claude, Grok, and CLI systems.
- CLI access for multiple AI systems.

Therefore, the task is not to create a memory system from zero.

The task is to make every machine and every AI instance obey the existing memory/bridge system consistently.

## Memory layers

| Layer | Tool | Purpose |
|---|---|---|
| Human-readable knowledge | Obsidian vault | Doctrine, lessons, architecture, decisions, operating wisdom |
| Machine-readable bridge | GitHub | Shared state between ChatGPT, Claude, Grok, Antigravity, CLIs |
| Code truth | GitHub repos | Source of truth for code changes |
| Large operational data | NAS | Archives, datasets, model libraries, backups |
| Fast active data | Internal SSD / USB4 NVMe | Active working sets and fast clone backups |

## Principle

Claude's internal memory should not be treated as the authoritative project state.

The authoritative state should be:

1. Obsidian for human memory and doctrine.
2. GitHub for code and machine-readable bridge packets.
3. Repo-local markdown files for task-specific operational state.
4. NAS / external backup for durable archive.

## Required start protocol for every AI session

Before acting, each AI worker should read the relevant shared state.

Minimum start sequence:

```text
1. Read CLAUDE.md or equivalent repo doctrine.
2. Read PROJECT_STATE.md.
3. Read CURRENT_TASK.md if present.
4. Read HANDOFF.md.
5. Read DECISION_LOG.md.
6. Read BLOCKERS.md.
7. Read relevant Obsidian vault notes if available.
8. Check Git branch/status.
9. Summarize current state.
10. Infer next action.
11. Execute only after state is understood.
```

## Required shutdown protocol for every AI session

Adrian already performs a shutdown protocol. This brief recommends making the following items mandatory and auditable.

Minimum shutdown sequence:

```text
1. Update task outcome.
2. Update files changed.
3. Update architecture changes.
4. Update lessons learned.
5. Update decisions made.
6. Update blockers.
7. Update next recommended action.
8. Commit/push code changes if appropriate.
9. Write bridge status packet for other AIs.
10. Read back the written files.
11. Report verification result.
```

## Recommended file pattern inside repos

Each serious project should contain:

```text
/project-root
  CLAUDE.md
  PROJECT_STATE.md
  CURRENT_TASK.md
  HANDOFF.md
  DECISION_LOG.md
  CHANGELOG_AI.md
  BLOCKERS.md
```

Optional:

```text
/AI-OPS
  ACTIVE_SESSIONS.md
  AGENT_ASSIGNMENTS.md
  DAILY_STATUS.md
  SHUTDOWN_LOG.md
  VERIFICATION_LOG.md
```

## Bridge packet format

When ChatGPT, Claude, Grok, or Antigravity writes to the GitHub bridge, use a compact packet:

```markdown
# Bridge Packet

Date:
Authoring system:
Classification: action | status | doctrine | blocker | handoff | irrelevant
Project:
Machine:
Session:

## Findings

## Actions taken

## Verification

## Blockers

## Recommendation / next action
```

## Classification rules

- `action` — requires or records a concrete execution step.
- `status` — reports state with no immediate action required.
- `doctrine` — updates operating principles or architecture.
- `blocker` — records blocked execution requiring human/external intervention.
- `handoff` — passes task continuity to another AI/machine/session.
- `irrelevant` — no operational relevance.

## Multi-account Claude issue

Adrian runs multiple Claude subscriptions because high-volume coding consumes tokens quickly.

The weakness is that Claude's episodic memory does not travel between accounts.

Solution:

- Do not rely on Claude account memory.
- Use Obsidian + GitHub bridge as the shared external memory.
- Force every Claude account/session to read the start files.
- Force every Claude account/session to write shutdown files.
- Bridgekeeper should verify that this happened.

## Machine-specific bridge responsibilities

### Commander — M5 Max

- Read latest bridge packet before assigning work.
- Write high-level decisions into Obsidian/GitHub.
- Review final outputs.

### Forge — M2 Ultra

- Write implementation changes and technical handoff.
- Commit code and tests.
- Update repo-local operational files.

### Bridgekeeper — M1 Max

- Verify shutdown protocol.
- Audit Git status.
- Audit Obsidian sync state.
- Maintain active session registry.
- Create bridge status packets.

### Lantern — 2014 i7

- Display status.
- Run lightweight health checks.
- Provide fallback terminal access.
- Do not write critical doctrine unless explicitly instructed.

## iCloud caution

Obsidian over iCloud is convenient, but active multi-machine AI work can create:

- sync delays;
- file conflicts;
- stale reads;
- duplicated conflict files;
- partial writes if a machine sleeps mid-sync.

Mitigation:

- Use GitHub as the authority for code.
- Use Obsidian for doctrine and human notes.
- Use read-back verification after every important write.
- Bridgekeeper should check for iCloud conflict files.
- Do not run simultaneous heavy writes to the same Obsidian note from multiple machines.

## Verification standard

No write should be treated as successful until read back.

Valid write:

1. File written.
2. File read back.
3. Expected content confirmed.
4. Commit/hash/status recorded where available.

Invalid write:

- empty file;
- zero-payload;
- wrong folder;
- unverified content;
- stale/conflicted copy;
- unclear repository/branch;
- tool returned success but file cannot be fetched/read.
