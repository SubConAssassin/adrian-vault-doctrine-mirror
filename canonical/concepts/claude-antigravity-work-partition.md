---
title: Claude ↔ Antigravity Work Partition Protocol v2
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
version: 2.0
created: 2026-04-23
last_updated: 2026-04-24
related:
  - canonical/concepts/24-7-operating-model.md
  - canonical/concepts/agent-budget-framework.md
  - canonical/concepts/corporate-agent-architecture.md
---

# Claude ↔ Antigravity Work Partition Protocol v2

**Status:** Canonical — SUPERSEDES v1
**Location:** `canonical/concepts/claude-antigravity-work-partition.md`
**Version:** 2.0
**Updated:** 2026-04-24
**Co-authors:** Claude (Anthropic), Antigravity (local agent), ChatGPT (gpt-5.4 consult), Grok (grok-4 consult)
**Applies to:** All dual-agent sessions on Adrian's MacBook Pro M3 Pro 18GB RAM

---

## 0. Version 2 — What Changed From v1

v1 was pure intent: declare a mode, agents behave accordingly. It assumed good adherence and no failure modes outside mode-switching.

v2 is **enforced admission control**. Modes remain, but heavy work now requires passing a pre-flight check. v2 also adds:
- Mandatory pre-flight script (`tools/preflight-check.sh`)
- Workload redirect table (what should leave the laptop entirely)
- No-heavy-work-in-cloud-synced-folders rule (iCloud, Google Drive, Dropbox)
- Staging/scratch pattern (process in local scratch, sync results back)
- Recovery protocol for silent hangs

**Catalyst:** 2026-04-23 silent hang. 1.06GB ChatGPT export was iCloud stub (0 bytes local). Extraction scripts stalled silently on invisible download. Killed both agents. Full reboot required.

---

## 1. Core Principle

> Reliability comes from enforced admission control, not from etiquette or better prompts.

Declaring a mode is the start. Passing the gate is the actual permission.

---

## 2. The Three Modes (retained from v1)

### STRATEGY MODE — Claude heavy, Antigravity paused
- **Trigger:** `mode: strategy`
- **For:** research, writing, voice-dump processing, copy, legal drafting, Wix/Gmail/Calendar API work, multi-tool synthesis
- **Claude:** full streaming, long artifacts, multi-tool; writes specs to `working/handoffs/`
- **Antigravity:** pause all active agents, close unneeded workspaces, read-only reference only

### EXECUTION MODE — Antigravity heavy, Claude minimal
- **Trigger:** `mode: execution`
- **For:** vault rewrites, bulk file ops, code refactors, indexing, local scripts
- **Antigravity:** full parallelism, write results to `working/handoffs/` on completion
- **Claude:** responses <500 words, no artifacts, no streaming; quick lookups only; defer heavy with "Queue for next strategy mode"

### PARALLEL LIGHT — both active, both light
- **Trigger:** default (no mode declared)
- **For:** normal flow, light questions, quick cross-checks
- **Both:** <500 words / <10 files / no full-vault search / no long streams

---

## 3. Pre-Flight Check — THE GATE (new in v2)

Before entering **STRATEGY** or **EXECUTION** mode, run:

```bash
~/Documents/Adrian-Vault/tools/preflight-check.sh
```

The script checks (exit 0 = pass, exit 1 = abort):

| Check | Fail condition |
|---|---|
| Free RAM | <4 GB available |
| Memory pressure | Red (or yellow in STRATEGY mode with long context) |
| Swap usage | >2 GB used |
| iCloud stubs in target paths | Any 0-byte file with `com.apple.icloud.desktop` xattr |
| Zombie processes | Any defunct (Z-state) Claude/Antigravity children |
| Claude Helper renderer CPU | >200% sustained (renderer loop) |
| Cowork VM bundle | Present and auto-mounted while Cowork not in use |
| Duplicate agent instances | >1 Claude Desktop process, >1 Antigravity instance |

If any check fails, the script prints which, suggests the fix, and exits non-zero. Heavy work does not begin until it passes.

---

## 4. Workload Redirect Table (new in v2)

The 18 GB machine should not be doing these at all — route to cloud:

| Workload shape | Redirect to |
|---|---|
| Any archive extraction >500 MB (ZIPs, JSON exports, database dumps) | OpenAI/Anthropic Batch API, or a disposable cloud VM (DigitalOcean / Hetzner / Fly.io) |
| Whole-repo semantic indexing | Cloud-hosted embedding service, or remote dev box |
| OCR, transcript parsing, bulk ETL | Serverless function (Cloudflare Workers, Lambda) |
| Docker builds, multi-browser automation | Remote dev container, GitHub Codespaces, or cloud CI |
| Long-running scrape/crawl jobs | Apify, Browserbase, Firecrawl |
| Embedding generation across corpora | OpenAI Batch API or cloud GPU instance |
| Model inference for custom models | Replicate, Modal, RunPod |
| Heavy pandas / polars analytics on multi-GB data | Databricks, BigQuery, or DuckDB on remote |

Local stays fit for: single-file edits, small scripts, focused refactors inside a scoped workspace, writing, reasoning, API orchestration. **Everything else leaves the laptop.**

---

## 5. The Cloud-Sync Rule (new in v2)

**No heavy work in iCloud / Google Drive / Dropbox folders. Ever.**

These folders silently evict files to stubs. Scripts that target them hang without warning while macOS tries to re-download. This is what killed the session on 2026-04-23.

**Staging pattern:**
1. Create a plain local scratch directory: `~/scratch/` (NOT in any synced folder)
2. `rsync` or `cp` inputs into scratch with explicit size check — `du -sh` before and after must match
3. Process in scratch
4. `rsync` results back to vault
5. Delete scratch working files

**How to detect an iCloud stub fast:**
```bash
xattr -p com.apple.metadata:com_apple_backup_excludeItem /path/to/file 2>/dev/null
# OR
ls -la@ /path/to/file  # look for @ flag and icloud xattrs
# OR force the download
brctl download /path/to/file
```

---

## 6. Sacrificial Execution Environment (new in v2, optional)

For Antigravity jobs over 30-minute runtime or heavy subprocess spawning, consider running Antigravity inside:
- A remote dev box (Hetzner €5/month CX22, or DigitalOcean droplet)
- A local VM (OrbStack / UTM / Lima) with repo mounted
- GitHub Codespaces for anything repo-centric

Benefits: isolation from UI responsiveness, disposable failure, CPU/RAM budget separate from laptop. Adrian's MacBook hosts only Claude + terminal + browser during those jobs.

---

## 7. Mode-Switch Mechanics with Guardrails (upgraded from v1)

v1 used declared phrases. v2 adds enforcement:

1. Adrian declares: `mode: strategy` (or execution / parallel / emergency)
2. Receiving agent runs `preflight-check.sh`
3. If pass: agent confirms mode and begins
4. If fail: agent reports which gate failed and what to fix; does not begin heavy work
5. Outgoing agent writes current state to `working/handoffs/` and goes quiet

**Hard guardrails (not etiquette) baked into each agent's session-start:**
- Claude: on session start, read latest file in `working/handoffs/` before responding to new instruction
- Antigravity: on session start, run `preflight-check.sh` unconditionally
- Both: refuse heavy work when preflight fails; escalate to Adrian with the specific fix

---

## 8. Failure Recovery Protocol (new in v2)

When a silent hang occurs (per 2026-04-23 pattern):

1. **Don't force quit blindly.** First run `brctl status ~/Library/Mobile\ Documents/` and `du -sh` on the target path — this reveals iCloud downloads in progress.
2. If iCloud fetch is active, wait — `brctl log --wait` shows progress. macOS reboot is only required if the fetch deadlocks.
3. After reboot, before resuming: run preflight, confirm files are fully local, explicitly disable iCloud for the working directory (`brctl evict` in reverse — keep local).
4. Write a post-mortem handoff to `working/handoffs/` naming the root cause. Future sessions read this as part of session start.

---

## 9. Handoff Trigger Phrases (retained)

| Phrase | Meaning |
|---|---|
| `mode: strategy` | Claude heavy, Antigravity pauses, preflight runs |
| `mode: execution` | Antigravity heavy, Claude minimal, preflight runs |
| `mode: parallel` | Both light, default |
| `handoff to antigravity` | Claude writes spec, flips to execution |
| `handoff to claude` | Antigravity writes result, flips to strategy |
| `emergency strategy` | Antigravity stops mid-task, Claude takes priority |
| `redirect cloud` | Route this workload off the laptop per section 4 |

---

## 10. Exceptions

- Erica Johnson legal / urgent legal matter → always strategy mode
- Update sweeps (`u` / update) → read-only, runs in any mode
- Short factual lookups → parallel light regardless of stated mode
- System emergency → override all modes, heaviest capable agent leads

---

## 11. Hardware Upgrade Threshold

Protocol relaxes when Adrian moves to ≥36 GB unified memory. Parallel heavy mode becomes viable. Until then: serialise and redirect.

---

## 12. Next Steps (actions pending)

1. Antigravity installs `preflight-check.sh` and runs it at session start
2. Claude reads latest `working/handoffs/` at session start (already doctrine)
3. Both agents adopt the workload redirect table as reflex
4. Adrian migrates large-archive work out of iCloud'd vault folders into `~/scratch/`
5. Consider Hetzner CX22 or DigitalOcean droplet for extraction jobs >500 MB (~€5/mo)

---

**End v2.**
