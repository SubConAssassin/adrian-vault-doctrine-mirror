# AI Infrastructure Cluster Brief for Claude

Date: 2026-06-11
Source: ChatGPT synthesis for Adrian
Audience: Claude / Antigravity / GitHub Bridge / Obsidian operators
Status: operative architecture brief

## Purpose

This folder consolidates Adrian's planned local AI infrastructure into a clear machine-role, CLI-pipeline, memory-bridge, and backup architecture.

The target environment is a LAN-based multi-machine AI system using:

- M5 Max MacBook Pro with 128GB RAM as the mobile command station.
- M2 Ultra Mac Studio with 192GB RAM as the primary dry-room compute node.
- M1 Max MacBook Pro with 64GB RAM as the secondary dry-room bridgekeeper node.
- 2014 i7 MacBook Pro with 16GB RAM as a legacy utility node.
- Obsidian vault over iCloud as human-readable shared memory.
- GitHub bridge as machine-readable shared state between Claude, ChatGPT, Grok, and other CLI tools.
- Antigravity and multiple AI CLIs as execution layers.
- NAS / RAID storage plus fast USB4 NVMe SSDs for backup, archive, and operational resilience.

## Core conclusion

Do not treat every machine as an equal coding workstation.

Use each machine according to its correct class:

| Machine | Codename | Primary role |
|---|---|---|
| M5 Max 128GB MacBook Pro | Commander | Human-facing command station and mobile heavy workstation |
| M2 Ultra 192GB Mac Studio | Forge | Primary heavy AI execution node in the dry room |
| M1 Max 64GB MacBook Pro | Bridgekeeper | Coordination, Git/Obsidian bridge, monitoring, light agents |
| 2014 i7 16GB MacBook Pro | Lantern | Low-load utility, dashboard, watcher, fallback admin terminal |

## Folder contents

1. `01-node-roles.md` — role assignment for each machine.
2. `02-cli-capacity-and-pipelines.md` — CLI/window limits and pipeline strategy.
3. `03-obsidian-github-bridge-protocol.md` — shared memory and shutdown/startup protocol.
4. `04-legacy-2014-macbook-role.md` — useful role for the old 2014 i7/16GB MacBook Pro.
5. `05-storage-and-backup-architecture.md` — NAS, USB4 SSD, redundancy, and backup design.
6. `06-implementation-checklist.md` — practical deployment steps for Claude/Antigravity.

## Immediate recommendation

When the M2 Ultra and M5 Max are online, configure the dry room as follows:

- M2 Ultra: heavy Claude Code / Antigravity / local LLM / indexing node.
- M1 Max: bridgekeeper, session registry, Git/Obsidian audit, backup monitor.
- 2014 MacBook Pro: dashboard, ping/watchdog, SSH terminal, fallback control surface.
- M5 Max: personal command cockpit, review station, mobile compute, remote controller.

Claude should ingest this folder before making further infrastructure decisions.
