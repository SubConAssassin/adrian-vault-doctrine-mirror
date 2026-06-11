---
name: ai-infrastructure-cluster-roadmap-2026-06-11
description: ChatGPT-synthesised 4-node cluster architecture (Commander/Forge/Bridgekeeper/Lantern). ROADMAP — needs reconciliation against actual current state before treating as binding. Source-grounded chat evidence pending.
status: ROADMAP_PROVISIONAL
metadata:
  type: doctrine
  source: ChatGPT synthesis for Adrian, 2026-06-11
  authority: NOT YET TIER-1 — pending team reconciliation + Adrian ratify
  reconciliation_blockers:
    - M5 Max 128GB not yet acquired (Commander role un-instantiable)
    - M2 Ultra 192GB ~1mo+ from America per [[multi-machine-infrastructure]] (Forge role un-instantiable)
    - Current cockpit IS the M1 Max 64GB (would be demoted to Bridgekeeper in this roadmap)
    - 2014 i7 16GB just activated 2026-06-11 — Lantern role IS instantiable NOW
  binding_now:
    - The 2014 i7 → Lantern role (§7) is the ONE part of this roadmap actionable today
    - Everything else is staged + fires when hardware arrives
  cross_references:
    - "[[multi-machine-infrastructure]]"
    - "[[p0-reliability-layer]]"
    - "canonical/concepts/operating-architecture.md"
    - "canonical/concepts/delegation-first-operating-doctrine.md"
    - "canonical/concepts/hive-architecture-v3.md"
---

# AI Infrastructure Cluster Brief for Claude

**Date:** 2026-06-11
**Source:** ChatGPT synthesis for Adrian
**Audience:** Claude / Antigravity / GitHub Bridge / Obsidian / Grok / CLI agents
**Status:** operative architecture brief (ROADMAP — reconciliation pending)

> ⚠️ **PROVENANCE + ENGINE SELF-KNOWLEDGE NOTE (per delegation-doctrine §6a, 2026-06-10).**
> This brief was authored by ChatGPT (cutoff June 2024) without full access to Adrian's actual vault state (existing memory files, M3 onboarding details, P0 reliability layer, ChromaDB vault search, operating-architecture doctrine, hive-architecture-v3). It is **ChatGPT-generic-best-practice**, not vault-grounded. Several claims need reconciliation against the actual current stack BEFORE acting:
> - "Obsidian over iCloud" — Adrian uses Claude Code with vault at `~/Documents/Adrian-Vault/`, NOT iCloud-synced Obsidian. Memory + handoffs + canonical/ are the actual shared state.
> - "GitHub bridge" — exists in some flows (external-research-in/, Hive CI) but is NOT the primary state spine; `working/state/events.jsonl` + canonical/ + memory/ are.
> - "CLAUDE.md / PROJECT_STATE.md / HANDOFF.md per repo" — Adrian's pattern is `working/handoffs/STATE-OF-STACK.md` (cluster-wide, not per-repo) + `companies/{venture}/ledger.md` per venture.
> - "Multi-Claude account strategy" — Adrian DOES use multiple Claude subs, but rotation is governed by the [[feedback-mechanisms-not-promises-no-repeat-mistakes]] accountant + `working/state/resource-router.json`, not GitHub bridge.
>
> **Action before promotion to Tier-1:** team review (grok + codex), Claude synthesis, Adrian ratify.

---

## 1. Purpose

This document consolidates Adrian's planned local AI infrastructure into one operational architecture.

The target environment is a LAN-based multi-machine AI system using:

- **M5 Max MacBook Pro with 128GB RAM** as the mobile command station.
- **M2 Ultra Mac Studio with 192GB RAM** as the primary dry-room compute node.
- **M1 Max MacBook Pro with 64GB RAM** as the secondary dry-room bridgekeeper node.
- **2014 Intel i7 MacBook Pro with 16GB RAM** as a legacy utility/watchdog node.
- Obsidian vault over iCloud as human-readable shared memory. ⚠️ *Reconcile: Adrian uses Claude Code + vault on filesystem, not iCloud-Obsidian.*
- GitHub bridge as machine-readable shared state between Claude, ChatGPT, Grok, Antigravity, and CLI systems.
- Antigravity and multiple AI CLIs as execution layers.
- NAS / RAID storage plus fast USB4 NVMe SSDs for backup, archive, and operational resilience.

**Key principle:** Do not treat all machines as equal AI workers. Use each machine according to its correct class.

## 2. Node Roles

| Node | Hardware | RAM | Location | Primary Role |
|---|---|---:|---|---|
| Commander | M5 Max MacBook Pro | 128GB | Mobile / desk | Human-facing command station and mobile AI workstation |
| Forge | M2 Ultra Mac Studio | 192GB | Dry room | Primary always-on heavy compute node |
| Bridgekeeper | M1 Max MacBook Pro | 64GB | Dry room | Coordination, bridge, monitoring, light/medium CLI work |
| Lantern | 2014 Intel i7 MacBook Pro | 16GB | LAN / dry room | Lightweight dashboard, watchdog, utility, emergency admin terminal |

## 3. Core Architecture

**Strategic principle:**
- M5 Max = cockpit.
- M2 Ultra = engine room.
- M1 Max = nervous system.
- 2014 i7 = dashboard/watchman.

The M2 Ultra should do the heavy work. The M5 Max should remain responsive for Adrian. The M1 Max should coordinate, verify, and bridge. The 2014 Mac should monitor, display, and provide fallback control. The machines should not compete — they should cooperate.

## 4. Commander — M5 Max 128GB MacBook Pro

**Role:** Adrian's personal command cockpit.

**Use it for:** human-facing strategic work · main Claude account · Antigravity UI when actively steering · prompt design · architecture decisions · code review · pull request review · mobile/offline local LLM work while travelling · remote control of dry-room machines · SSH/tmux control of Forge, Bridgekeeper, and Lantern · working on planes/airports/hotels/cafés.

Do not overload Commander with every background job while at home. Keep it fast and responsive.

**Recommended active load:**
- Heavy Claude Code / Antigravity windows: 3–4
- CLI agent sessions: 6–8
- Local LLM workload: 1 major workload when needed
- SSH control terminals: several

**Good tmux layout:**

```
tmux session: commander
0: command
1: review
2: ssh-forge
3: ssh-bridgekeeper
4: ssh-lantern
5: local-agent
6: logs
```

**Use Commander for:** decision-making, review, final approval, high-level architecture, human-in-the-loop command, mobile continuation when away from the LAN, controlling the dry-room machines without physically sitting with them.

## 5. Forge — M2 Ultra Mac Studio 192GB

**Role:** dry-room engine room. Primary heavy AI execution node.

**Use it for:** second Claude account · heavy Claude Code sessions · Antigravity heavy execution · repo-wide refactors · long-context analysis · multi-agent implementation work · local LLM serving/inference · embeddings and indexing · large transcript/content processing · long-running builds · test loops · dataset processing · background AI jobs while Adrian travels.

**Conservative mode:**
- Heavy Claude Code sessions: 4
- Medium CLI agents: 4–6
- Light monitor/background jobs: 4–8

**Aggressive mode (sprints, not permanent):**
- Heavy Claude Code sessions: 6
- Medium CLI agents: 8–12
- Light jobs: 8

**Good tmux layout:**

```
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

**Use Forge for:** actual heavy coding, background implementation, multi-hour AI tasks, local model experiments, large repo analysis, repetitive execution loops, heavy build/test cycles, large dataset and model processing, long-running jobs that should continue while Commander travels.

Forge is the machine that should keep working even when Adrian is on the M5 Max or away from the dry room.

## 6. Bridgekeeper — M1 Max 64GB MacBook Pro

**Role:** system coordinator. Not primarily a third heavy coding machine.

Adrian currently observes the M1 Max practically handles ~4 CLI connections and ~2 heavy coding windows. Once Forge and Commander are online, the M1 Max should be deliberately repurposed as the reliability and coordination layer.

**Use it for:** Obsidian vault sync verification · GitHub bridge checks · handoff verification · shutdown protocol audits · session registry · backup job monitoring · watchdog scripts · light research agents · small CLI jobs · cross-model bridge tasks between Claude, ChatGPT, Grok, and Antigravity · checking whether other agents actually wrote their updates · checking whether Git commits were made · checking whether iCloud created conflicts or stale files · checking whether project state has been updated · checking whether agents are stuck or running stale instructions.

**Recommended active load:**
- Heavy AI/code windows: 1–2 maximum
- Medium CLI agents: 3–4
- Light monitoring/background jobs: 4–6

**Good tmux layout:**

```
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

**Bridgekeeper responsibilities — verify every serious AI session ends correctly:**
- Did the AI write a proper handoff?
- Did the AI update Obsidian?
- Did the AI update the GitHub bridge?
- Did the AI commit relevant code?
- Did the AI leave uncommitted changes?
- Did tests pass?
- Are there blockers?
- Has iCloud synced correctly?
- Are there conflict files?
- Are backups running?
- Are active sessions registered?
- Is the latest bridge packet classified correctly?
- Does another AI account need rehydration?

Bridgekeeper is the nervous system.

## 7. Lantern — 2014 Intel i7 / 16GB MacBook Pro

**Role:** low-load utility/watchdog node on the LAN. Still useful, but NOT a heavy AI machine.

**Do NOT use Lantern for:** heavy Claude Code sessions · Antigravity heavy IDE windows · local LLM inference beyond tiny experiments · large repo indexing · big builds · multi-agent orchestration · critical write-heavy workflows · anything requiring high RAM or sustained CPU.

**Use Lantern for:** always-on dashboard display · SSH terminal into Forge · SSH terminal into Bridgekeeper · SSH terminal into the NAS · LAN health monitoring · NAS status monitoring · backup progress screen · Obsidian read-only reference if needed · emergency admin terminal · ping checks · log tailing · router/network admin · fallback terminal if all newer machines are busy · lightweight uptime scripts · displaying current blockers / active sessions.

**Good tmux layout:**

```
tmux session: lantern
0: lan-health
1: forge-ssh
2: bridgekeeper-ssh
3: nas-status
4: backup-tail
5: bridge-readonly
```

**Example lightweight LAN health script:**

```bash
#!/bin/bash
DATE=$(date)
echo "# LAN Status" > ~/lan-status.md
echo "Updated: $DATE" >> ~/lan-status.md
echo "" >> ~/lan-status.md
for HOST in forge-m2-ultra.local bridgekeeper-m1.local nas.local github.com; do
  if ping -c 1 -W 1 "$HOST" >/dev/null 2>&1; then
    echo "- $HOST: OK" >> ~/lan-status.md
  else
    echo "- $HOST: DOWN" >> ~/lan-status.md
  fi
done
```

**Security caution:** older Intel Mac → do NOT expose to internet · LAN-only or Tailscale-only access · disable unnecessary services · keep patched as far as practical · do NOT store primary credentials · do NOT make it a single point of failure · prefer read-only dashboard duties where possible.

**Lantern is not for horsepower. It is for visibility, resilience, and low-level control.**

## 8. CLI Capacity and Pipeline Strategy

| Node | Heavy AI/code | Medium CLI | Light monitor | Notes |
|---|---:|---:|---:|---|
| Commander — M5 Max 128GB | 3–4 | 6–8 | 2–4 | Keep responsive for live command |
| Forge — M2 Ultra 192GB | 4–6 | 8–12 | 4–8 | Primary heavy worker |
| Bridgekeeper — M1 Max 64GB | 1–2 | 3–4 | 4–6 | Coordination + verification |
| Lantern — 2014 i7 16GB | 0 | 0–1 very light | 1–3 | Dashboard/watchdog only |

**Conservative starting mode** (measure memory pressure, swap, temperature, responsiveness, API limits, build bottlenecks, iCloud sync, LAN/NAS speed, handoff discipline):

| Node | Heavy | Medium | Light |
|---|---:|---:|---:|
| Commander | 2–3 | 3–5 | 2–4 |
| Forge | 4 | 4–6 | 4–8 |
| Bridgekeeper | 1 | 2–3 | 4–6 |
| Lantern | 0 | 0 | 1–3 |

**Aggressive sprint mode** (not permanent):

| Node | Heavy | Medium | Light |
|---|---:|---:|---:|
| Commander | 4 | 4–6 | 4 |
| Forge | 6 | 8–12 | 8 |
| Bridgekeeper | 2 | 3–4 | 6 |
| Lantern | 0 | 0–1 | 3 |

## 9. Work Routing

**Commander assigns** — decide strategy, define task packets, assign work to Forge and Bridgekeeper, review diffs and final outputs, avoid doing all background work locally when Forge is online.

Example:
> Forge: refactor backend auth flow.
> Bridgekeeper: monitor Git changes, verify Obsidian state updates, confirm shutdown protocol compliance.
> Commander: review final diff, tests, and blockers only.

**Forge executes** — heavy jobs: repo-wide refactors · test/build loops · local model inference · vector indexing · large transcript/content processing · multi-agent code execution · long context analysis · big documentation restructuring · backend/frontend implementation · long-running Antigravity jobs.

**Bridgekeeper verifies** — did Forge write the files? did tests pass? did Obsidian update? did GitHub receive commits? are there uncommitted changes? is there a blocker? did Claude/Grok/ChatGPT need rehydration? are there merge conflicts? is iCloud sync stale? are shutdown files updated? are bridge packets written? are active session statuses current?

**Lantern watches** — is Forge online? is Bridgekeeper online? is NAS online? are backups running? is the LAN healthy? are there obvious stuck jobs? is a dashboard visible? is there emergency terminal access?

## 10. Obsidian + GitHub Bridge Protocol

Adrian already has: Obsidian installed · vault synchronized over iCloud · Graphify / graph-style vault tooling · full shutdown protocol · lessons saved into Obsidian · architecture/system files updated after work sessions · shared memory between Antigravity and other tools · GitHub used as bridge between ChatGPT, Claude, Grok, and CLI systems · CLI access for multiple AI systems.

The task is to make every machine and every AI instance obey the existing system consistently.

**Memory layers:**

| Layer | Tool | Purpose |
|---|---|---|
| Human-readable knowledge | Obsidian vault | Doctrine, lessons, architecture, decisions, operating wisdom |
| Machine-readable bridge | GitHub | Shared state between ChatGPT, Claude, Grok, Antigravity, CLIs |
| Code truth | GitHub repos | Source of truth for code changes |
| Large operational data | NAS | Archives, datasets, model libraries, backups |
| Fast active data | Internal SSD / USB4 NVMe | Active working sets and fast clone backups |

**Principle:** Claude's internal memory should not be treated as the authoritative project state. The authoritative state should be (1) Obsidian for human memory and doctrine, (2) GitHub for code and machine-readable bridge packets, (3) repo-local markdown files for task-specific operational state, (4) NAS / external backup for durable archive.

## 11. Start Protocol for Every AI Session

Minimum start sequence:
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

No AI worker should begin major changes from stale memory.

## 12. Shutdown Protocol for Every AI Session

Mandatory and auditable:
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

**Minimum shutdown report:**

```
Shutdown Report
Date:
Machine:
AI/tool:
Project:
Session:

Work completed
Files changed
Commands run
Tests/checks completed
Decisions made
Blockers
Next action
Verification/read-back result
```

## 13. Recommended Repo File Pattern

```
/project-root
  CLAUDE.md
  PROJECT_STATE.md
  CURRENT_TASK.md
  HANDOFF.md
  DECISION_LOG.md
  CHANGELOG_AI.md
  BLOCKERS.md

  /AI-OPS (optional)
    ACTIVE_SESSIONS.md
    AGENT_ASSIGNMENTS.md
    DAILY_STATUS.md
    SHUTDOWN_LOG.md
    VERIFICATION_LOG.md
```

## 14. Bridge Packet Format

```
Bridge Packet
Date:
Authoring system:
Classification: action | status | doctrine | blocker | handoff | irrelevant
Project:
Machine:
Session:

Findings
Actions taken
Verification
Blockers
Recommendation / next action
```

**Classification rules:**
- **action** — requires or records a concrete execution step.
- **status** — reports state with no immediate action required.
- **doctrine** — updates operating principles or architecture.
- **blocker** — records blocked execution requiring human/external intervention.
- **handoff** — passes task continuity to another AI/machine/session.
- **irrelevant** — no operational relevance.

## 15. Multi-Claude Account Strategy

Adrian runs multiple Claude subscriptions because high-volume coding consumes tokens quickly.

**Weakness:** Claude account 1 does not automatically share episodic memory with Claude account 2. A second Claude account can come in cold unless rehydrated. Context can diverge if each account acts without reading current state.

**Solution:** Do not rely on Claude account memory. Use Obsidian + GitHub bridge as the shared external memory. Force every Claude account/session to read the start files. Force every Claude account/session to write shutdown files. Bridgekeeper should verify that this happened.

**Recommended setup:**

| Account | Machine |
|---|---|
| Claude account 1 | Commander / M5 Max |
| Claude account 2 | Forge / M2 Ultra |
| Shared memory | Obsidian + GitHub |
| Verification | Bridgekeeper / M1 Max |
| Dashboard | Lantern / 2014 i7 |

**Account continuity protocol:**
1. The outgoing account writes a shutdown report.
2. The outgoing account updates HANDOFF.md.
3. Bridgekeeper verifies read-back.
4. The incoming account reads the current bridge/vault state.
5. The incoming account summarizes what changed.
6. The incoming account continues only after rehydration.

## 16. Remote Control Strategy

**LAN control via SSH + tmux** (primary).

From Commander:
```bash
ssh adrian@forge-m2-ultra.local
tmux attach -t forge

ssh adrian@bridgekeeper-m1.local
tmux attach -t bridgekeeper

ssh adrian@lantern-2014.local
tmux attach -t lantern
```

**Persistent sessions:**
```bash
tmux new -s forge
tmux new -s bridgekeeper
tmux new -s lantern

# Detach without killing:
Ctrl-b d

# Reattach:
tmux attach -t forge
```

**GUI fallback:** Apple Screen Sharing, Remote Desktop, Tailscale if away from LAN.

Terminal + tmux should be the main control layer because it is stable, low-bandwidth, and persistent.

## 17. Session Registry

Maintain shared file `AI-OPS/ACTIVE_SESSIONS.md`:

```
Active Sessions

Forge
- Session: backend-worker
- Tool/account: Claude account 2
- Task: Refactor auth flow
- Status: Running
- Last verified: 2026-06-11 20:30
- Blocker: none
- Next check: 21:00

Bridgekeeper
- Session: git-audit
- Tool/account: local scripts / light CLI
- Task: Check uncommitted changes and bridge updates
- Status: Running
- Last verified: 2026-06-11 20:32
- Blocker: none
```

Bridgekeeper should update or verify this. Lantern can display it. Commander can use it as the cockpit overview.

## 18. Storage and Backup Architecture

**Three separate needs (do not confuse):**
1. Fast active storage.
2. Long-term redundant archive.
3. Disaster recovery/offline backup.

**Recommended layers:**

| Layer | Hardware | Purpose |
|---|---|---|
| Fast active drive | USB4/Thunderbolt NVMe SSD, 4–8TB | Active AI projects, model shuttle, fast clone |
| Redundant archive | 4- or 6-bay NAS with NAS HDDs | Long-term, snapshots, shared LAN data |
| Offline backup | External HDD/SSD stored unplugged | Protection from ransomware, accidental delete, electrical |
| Cloud/GitHub | GitHub / cloud storage | Code, markdown state, small critical files |

## 19. Fast SSD Recommendation

For the M2 Ultra Mac Studio, a direct USB4/Thunderbolt NVMe SSD is best for speed.

**Pattern:** 1 × 4TB or 8TB USB4 NVMe drive for active backup/work mirror. Prefer fan-cooled or thermally competent enclosure for multi-terabyte transfers. Avoid ordinary USB 3.x HDDs or SATA SSDs for high-speed active work.

**Build:** USB4/Thunderbolt 40Gbps NVMe enclosure + 4TB NVMe SSD (Lexar NM790, WD SN850X non-heatsink, Samsung 990 Pro, or comparable).

**Cautions:** factory heatsink SSDs may not fit slim enclosures · verify enclosure supports macOS and 40Gbps mode · verify actual selected listing stock.

## 20. NAS Recommendation

**Baseline:** 4-bay NAS · 4 × 8TB or 4 × 12TB NAS HDDs · RAID 5 / SHR · UPS · snapshots enabled · Ethernet, ideally 10GbE.

**Stronger:** 6-bay NAS · 6 × 8TB or 6 × 12TB NAS HDDs · RAID 6 / SHR-2 · UPS · 10GbE · snapshot schedule.

**Capacity examples:**

| Drives | RAID mode | Usable capacity | Fault tolerance |
|---|---|---:|---|
| 4 × 8TB | RAID 5 / SHR | ~24TB | 1 drive failure |
| 4 × 12TB | RAID 5 / SHR | ~36TB | 1 drive failure |
| 4 × 16TB | RAID 5 / SHR | ~48TB | 1 drive failure |
| 6 × 8TB | RAID 6 / SHR-2 | ~32TB | 2 drive failures |
| 6 × 12TB | RAID 6 / SHR-2 | ~48TB | 2 drive failures |
| 6 × 16TB | RAID 6 / SHR-2 | ~64TB | 2 drive failures |

## 21. NAS vs Direct SSD

| Feature | USB4 NVMe SSD | NAS |
|---|---|---|
| Speed | Very high, direct-attached | Moderate to high, depends on Ethernet |
| Cost per TB | High | Lower |
| Redundancy | None unless duplicated | Built in with RAID/SHR |
| Portability | Excellent | Poor |
| Multi-machine access | Manual / single machine | Excellent |
| Best use | Active project mirror | Archive, backup, shared storage |

**Important rule: RAID is not backup.** RAID protects against drive failure. It does NOT protect against accidental deletion, corrupted files, ransomware, theft, fire, water damage, electrical damage, bad sync propagating to all copies. Therefore: NAS RAID is one layer · offline backup is another · GitHub/cloud for critical small files is another.

## 22. Backup Routing by Data Type

| Data type | Primary location | Backup route |
|---|---|---|
| Code repos | Local SSD + GitHub | GitHub + NAS snapshot |
| Obsidian vault | iCloud + local | GitHub doctrine mirror + NAS backup |
| AI models | Forge local SSD / external SSD | NAS archive if expensive to reacquire |
| Client/business docs | Local + Obsidian/NAS | NAS + offline encrypted backup |
| Media/transcripts | NAS | Offline drive or second NAS/cloud if critical |
| Active project mirror | USB4 NVMe SSD | NAS after each session |

## 23. Backup Rhythm

**Daily:** Git push important code changes · Bridgekeeper checks uncommitted work · Obsidian/iCloud sync check · NAS snapshot · update session registry · update daily bridge status if active.

**Weekly:** external offline backup rotation · verify one restore sample · check SMART/drive health · check NAS free space · check iCloud conflict files · check GitHub bridge stale state.

**Monthly:** full archive snapshot · review old model/data folders · test disaster recovery path · clean obsolete generated files · review storage capacity · confirm all four machines still have correct roles.

## 24. Dry-Room Hardware Layout

**Ideal physical layout:**
- M2 Ultra Mac Studio wired Ethernet.
- M1 Max Bridgekeeper wired Ethernet if stationary.
- NAS wired Ethernet.
- UPS shared by NAS + Mac Studio + network switch/router where practical.
- M5 Max docked on Ethernet when at desk; Wi-Fi when mobile.
- 2014 i7 on Wi-Fi or Ethernet as low-load dashboard.

**10GbE priority** (if NAS is part of active workflow):
1. NAS with 10GbE or upgrade card.
2. Mac Studio 10GbE.
3. 10GbE switch.
4. Ethernet adapter/dock for M5 Max when docked.
5. Bridgekeeper wired connection if possible.

Without 10GbE, NAS is still useful for backup/archive, but less suitable for active heavy files.

## 25. Final Storage Recommendation

**Minimum serious setup:** 1 × 4TB/8TB USB4 NVMe SSD for active fast work · 1 × 4-bay NAS with 4 × 8TB or 4 × 12TB drives · 1 × offline external backup drive.

**Better setup:** 2 × USB4 NVMe SSDs, one active and one rotated/offline · 6-bay NAS with RAID 6 / SHR-2 · UPS · 10GbE · monthly offline backup.

**Best conceptual answer:** SSD for speed · NAS for capacity and redundancy · offline backup for true safety.

## 26. Implementation Checklist

**Phase 1 — Network and access foundation:**
- Give every machine a clear network name: commander-m5, forge-m2-ultra, bridgekeeper-m1, lantern-2014, nas.
- Enable SSH on Forge, Bridgekeeper, Lantern.
- Install and test tmux on all active CLI machines.
- Confirm Commander can SSH into Forge, Bridgekeeper, Lantern.
- Add Tailscale if remote access outside LAN is needed.
- Keep GUI screen sharing as fallback, not primary control.

**Phase 2 — Tool installation by node:**
- Commander (M5 Max): Claude/Claude Code/Antigravity primary UI · GitHub CLI · Obsidian · AI CLIs · SSH config · local LLM tooling for travel.
- Forge (M2 Ultra): Claude Code under 2nd account · Antigravity heavy · Git · GitHub CLI · local LLM tooling · embedding/indexing tools · tmux · build/test dependencies.
- Bridgekeeper (M1 Max): Git · GitHub CLI · Obsidian access · bridge scripts · backup monitoring · tmux · lightweight AI CLIs only.
- Lantern (2014 i7): SSH client · tmux if supported · lightweight browser/dashboard · ping/monitor scripts · NAS dashboard bookmark · no heavy AI dependencies.

**Phase 3 — Shared memory and bridge:**
- Confirm Obsidian sync on Commander + Bridgekeeper.
- Decide whether Forge gets full Obsidian access or only GitHub bridge/repo state.
- Add `AI-OPS/ACTIVE_SESSIONS.md` to vault or bridge.
- Add `AI-OPS/DAILY_STATUS.md`, `BACKUP_STATUS.md`, `BLOCKERS.md`.
- Ensure every project has CLAUDE.md, HANDOFF.md.
- Ensure shutdown protocol requires read-back verification.

**Phase 4 — Storage:**
- Buy/build 4TB or 8TB USB4 NVMe SSD.
- Choose NAS (4-bay baseline or 6-bay stronger).
- Choose RAID/SHR mode.
- Add UPS.
- Add NAS snapshots.
- Add offline backup rotation.
- Test restore.

**Phase 5 — Operating discipline:**
- Commander assigns. Forge executes. Bridgekeeper verifies. Lantern watches.
- Every AI session starts by reading project state.
- Every AI session ends with shutdown report.
- Every important write is read back before being treated as successful.
- Bridgekeeper audits daily.
- Commander reviews only high-level summaries, diffs, blockers, decisions.

## 27. Claude Operating Instruction

Claude should treat this document as the current infrastructure doctrine. When working inside this system, Claude should:

1. Identify which machine role it is operating as (Commander, Forge, Bridgekeeper, Lantern).
2. Read relevant project state before acting.
3. Avoid assuming its own chat memory is authoritative.
4. Write operational state to Obsidian/GitHub bridge.
5. Verify every write by read-back.
6. Use Bridgekeeper for audit and continuity.
7. Avoid giving heavy work to Lantern.
8. Avoid overloading Commander when Forge is available.
9. Prefer Forge for heavy execution.
10. Prefer Bridgekeeper for monitoring, verification, and handoff policing.

## 28. Final Architecture Summary

**Commander — M5 Max 128GB:** cockpit. Human interface · main strategy · review · mobile compute · remote control · high-value AI session.

**Forge — M2 Ultra 192GB:** engine room. Heavy AI · 2nd Claude account · Antigravity execution · local LLMs · refactors · builds · indexing · background processing.

**Bridgekeeper — M1 Max 64GB:** nervous system. Obsidian/GitHub bridge · shutdown verification · Git audit · backup watch · active session registry · light agents · continuity between Claude accounts and other AI systems.

**Lantern — 2014 i7 16GB:** watchman. Dashboard · SSH terminal · LAN monitor · NAS monitor · backup display · emergency access.

**Storage:** USB4 NVMe SSD for speed · NAS for capacity/redundancy · offline backup for true disaster safety · GitHub/Obsidian for shared memory and doctrine.

**Core doctrine:**
> Commander decides. Forge builds. Bridgekeeper verifies. Lantern watches.
> Obsidian remembers. GitHub bridges. NAS preserves.

---

## Reconciliation worklist (Claude, 2026-06-11)

Items to reconcile against actual vault state before any phase fires:

- [ ] **Hardware reality:** M5 Max not yet acquired; M2 Ultra ~1mo+ away. Until then, M1 Max IS the cockpit + nervous system + only heavy node. 2014 i7 → Lantern role IS instantiable today.
- [ ] **State spine reality:** vault uses `working/state/events.jsonl` (append-only event log per AGENTS.md §10) + `working/handoffs/STATE-OF-STACK.md` + `companies/{venture}/ledger.md` + memory/. NOT a GitHub bridge as PRIMARY state. Hybrid: GitHub for external-research-in/ + Hive CI + code repos; vault for doctrine + state.
- [ ] **Obsidian reality:** Adrian works in vault via Claude Code, not iCloud-Obsidian. The "iCloud Obsidian" pattern is ChatGPT's guess. ChromaDB vault search ([[queryable-database-chromadb]]) is the actual fast-read layer.
- [ ] **Multi-Claude reality:** sub-rotation is governed by accountant + resource-router, not by GitHub bridge files. [[feedback-mechanisms-not-promises-no-repeat-mistakes]] + Adrian's lived number win.
- [ ] **Watchdog reality:** P0 layer already exists ([[p0-reliability-layer]]) — M1 mem-sentinel + M3 deadman + ntfy phone alerts. Lantern adds a 3rd witness, doesn't replace.
- [ ] **M3 reality:** the existing M3 Pro 18GB dry-room worker has its OWN role (heavy-AI batch engine, ollama Metal, jewelry-ID grind). The roadmap doesn't mention it — needs incorporating: M3 likely STAYS until the M2 Ultra arrives, then M3→2nd-M1-Max-64GB swap was the prior plan (see [[multi-machine-infrastructure]] + productivity-multiplier-reckoning §8). Roadmap's "Bridgekeeper = M1 Max" demotion assumes M2 Ultra is online.
- [ ] **AGENTS.md reality:** vault has a Cardinal Rule (grounded or silent), per-venture ledgers, presidential-secretary protocol, source-of-truth-first for contacts (Gmail before vault docs). The brief's "Start Protocol" §11 should map to AGENTS.md §10 + §11.
- [ ] **Storage reality:** Dropbox→GDrive migration in flight (2,388 files this cycle); 5TB-of-video keep/discard decision pending. NAS purchase NOT yet made. SSD purchase NOT yet made. The brief's storage plan is a future state, not current.

---

revision_history:
- 2026-06-11 — created as ChatGPT-synthesised ROADMAP. Team review fired (grok + codex) for reality-reconciliation. Promotion to Tier-1 doctrine awaits Adrian ratify post-synthesis.
