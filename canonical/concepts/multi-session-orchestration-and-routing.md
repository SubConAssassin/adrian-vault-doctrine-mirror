# Multi-Session Orchestration & Cloud/Local Routing

**Status:** Tier-1 doctrine. **Created:** 2026-06-01 from hard lessons in the 2026-05-31→06-01 uplift-campaign session (multi-window collisions, CLI over-crawl, a near-miss file archive, RAM-blind routing). Read this before launching any workflow, CLI burn, or heavy/local job. Companion to `cross-model-automation-protocol.md` (transport) and `model-routing-engine.md` (cognitive routing).

## 0. The core problem
Adrian runs many parallel sessions (Cowork desktop, Mac terminal, mobile, headless `claude -p`, + sibling sessions) and each can spawn workflows + CLI burns. With no coordination they **collide**: SOS edit-collisions, CLI/RAM contention, duplicated or competing work, near-miss destructive ops. This file is the coordination contract.

## 1. Coordinate BEFORE you launch (mandatory pre-flight)
**One command runs this whole section:** `bash ~/Documents/Adrian-Vault/tools/preflight.sh` — it reports the active sibling state (SOS top entry), running engines + local grinds, RAM/load/free, AG pause state, and prints a **GO / CAUTION / HOLD verdict with the cloud-vs-local routing call**. Run it before any heavy job. Manual checklist if the script is unavailable:

Before any heavy job (workflow, CLI burn, local grind, bulk file op):
1. **Read the SOS top entries** — what is another session firing *right now*? (e.g. a "CLI-TEAM SWEEP" entry = a sibling owns the CLI team.)
2. **Check live processes:** `pgrep -f 'agy |grok |codex |whisper|diariz|moondream'` and look for running workflows. Count PIDs with `pgrep -f PATTERN | wc -l` — **never `pgrep -fl … | wc -l`** (it counts newlines in multi-line command-lines; this session it reported "33 agy" for 2 real processes).
3. **If a sibling owns an active sweep on the same engines → HOLD or pick a non-overlapping engine/domain.** Do not pile a second CLI burn onto the same engines. Contention + tangled state is the highest-cost failure mode.
4. Verify environment facts before trusting doctrine (see §5) — e.g. RAM, which agents are live.

## 2. Don't fight the SOS — use dedicated handoffs
- `STATE-OF-STACK.md` is newest-on-top and is often being actively written by whichever session "owns" the live narrative. **Two sessions prepending to the top collide.**
- **Rule:** record your session's work in a dedicated `working/handoffs/{date}-{session}-{topic}.md` (collision-free). Only edit the SOS for genuine shared live-state, and **if the edit collides, back off** — the sibling owns it; your dedicated handoff is the durable record.
- One owner per file. Never have two sessions editing the same canonical/people/ or ledger file concurrently.

## 3. Cloud vs Local routing (spare the RAM)
The decisive axis when something is already running locally: **does this new work add LOCAL footprint, or is it cloud?**

| Engine / job | Footprint | Use when |
|---|---|---|
| **grok** (`grok -p`, xAI) | **Cloud** — network inference, tiny local footprint | DEFAULT for concurrent/bounded work, esp. while a local grind runs. Fast (~116s). File-read inconsistent → keep an Opus-read fallback. |
| **Claude subagents / Workflow** (Anthropic) | **Cloud** — light local orchestration only | DEFAULT for fan-out + verification. Does NOT stress local RAM/GPU. |
| **agy** (Antigravity CLI, Gemini) | **Hybrid** — runs a LOCAL agent harness (file workers) + cloud model; **over-crawls** | Long-leash deep extraction ONLY, when box is otherwise idle. Never bounded/concurrent. |
| **codex** (Codex CLI, GPT-5.5) | **Hybrid** — local harness + cloud model; **over-crawls** (>24min on a planning task) | Deep technical/legal ONLY, scoped tight + long timeout. Never quick passes. |
| **Whisper / faster-whisper / diarization** | **LOCAL — heavy GPU/RAM** | Schedule alone; this is usually the sibling's overnight grind. |
| **moondream / local LLM (Qwen etc.) / ffmpeg transcode** | **LOCAL — heavy** | Only when box is idle; never alongside another local grind. |

**Rule:** when a LOCAL grind is running (Whisper/moondream/transcode), route ALL new work to CLOUD engines (grok, Claude subagents). The verification leg in particular should be cloud — it adds zero local load. Reserve agy/codex (local harness) for when the box is free.

**RAM reality (verify, don't assume):** the Mac is now **64 GB** (upgraded from 18 GB — confirm via `sysctl -n hw.memsize`). At 64 GB, cloud fan-out concurrency is comfortable; the constraint is local-grind GPU/RAM, not cloud calls.

## 4. CLI engine routing (empirical, 2026-05-31)
- **Bounded/quick task → grok or a Claude subagent.** grok = fast reliable one-shot workhorse.
- **Long deep-extraction → agy/codex, with a hard leash** (scope + timeout) and NOT while other heavy work runs.
- **Always cross-verify:** generate with one model, verify with a **different** model (cloud-preferred), with an Opus-read fallback if the CLI verifier can't read files. The cross-check caught a real over-claim and a 490-file miscount this session — it is not optional.

## 5. Workflow & scripting safety rules (from this session's glitches)
1. **Bound every CLI call.** macOS has no `timeout`; use agy's `--print-timeout`, keep scope small, and add a kill-after backstop. The backstop must **kill the CLI process by pattern (`pkill -f`), not just the wrapping subshell** — killing the subshell orphans the child CLI (it reparents and keeps running). Verify it's actually dead.
2. **Never gate a file/destructive op on a check whose own success you haven't confirmed.** This session a `grep --include=*.md` silently errored (zsh glob-expanded the unquoted `*.md`) → returned empty → read as "0 references" → I nearly archived 1,387 referenced files. **Quote globs: `--include='*.md'`. Echo the check's output and confirm it ran (non-empty, no error) before acting on it.**
3. **`run_in_background` + inner `&`:** don't background subshells inside a `run_in_background` Bash that returns immediately — you lose the completion signal and orphan the children. Let the actual command be the foreground of the background Bash.
4. **Workflows default to Claude subagents (cloud).** Only shell a CLI from a stage when you genuinely need model-variant benefit or credit-burn — and bound it per (1).
5. **Reversible-first for bulk ops:** archive (mv) not delete; reference-check (correctly, per (2)) first; leave a tombstone/`_ARCHIVE-NOTE.md`; verify counts after.

## 6. Stale-instruction hygiene
Stale doctrine causes wrong behaviour. Known reconciliations as of 2026-06-01:
- **CLAUDE.md §5 hardware: 18 GB → 64 GB** (upgrade landed; this file + CLAUDE.md updated).
- The 2026-05-25 **keystroke-feeder** protocol is **superseded** by headless CLIs (`agy -p` etc., 2026-05-30). Do not revive the cliclick feeder for unattended work.
- `watchdog.py` now **respects the `ag-automation.pause` flag** (2026-05-31 fix) — it no longer floods stall/NUDGE/ESCALATED handoffs against a paused AG.
- When doctrine and live environment disagree, **verify the environment** (`sysctl`, `pgrep`, `ls`) and update the doctrine, don't act on the stale claim.

## Revision history
- 2026-06-01 — created from the uplift-campaign session retrospective. Codifies multi-session coordination, cloud/local RAM-aware routing, empirical CLI behaviour, and workflow-safety rules.
