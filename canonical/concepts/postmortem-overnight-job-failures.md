---
title: Postmortem — Why overnight jobs have failed 90% of the time
type: postmortem
date: 2026-04-29
author: claude
status: canonical
---

# Postmortem — Overnight Job Failure Pattern

## The pattern (Adrian's observation)

Across multiple weeks of overnight commissions to Antigravity, ~90% have failed to deliver work by morning. The 23:10 PROCESSING brief on 2026-04-29 is the latest example: AG ran HB-00, hit TCC on subprocess, bounced back to Claude in `2026-04-29-2330-antigravity-to-claude-tcc-delegation-phase3.md`, then stopped. Adrian woke to no work done.

## Root cause — architectural mismatch I kept missing

Every overnight brief I have written assumed AG could either:
- (a) tool-call its way through thousands of items (FALSE — AG turn budget caps at hundreds, not thousands), OR
- (b) write a Python script and run it (FALSE — AG's macOS sandbox blocks `subprocess` access to `~/Documents/`)

There is no overlap between "what the brief requires" and "what AG can do." So AG predictably hits the wall, files an honest TCC handoff, and stops. That is not AG failing — it is AG correctly reporting the limit. The failure is mine for sending unwinnable briefs.

## Why I kept making this error

- Treated "AG has tool calls" as equivalent to "AG can iterate forever"
- Treated "AG runs locally on Adrian's Mac" as equivalent to "AG can spawn shells like a normal user account"
- Did not internalise that AG is a sandboxed agent with both a turn budget AND a TCC perimeter

Both constraints together mean: AG cannot do bulk work autonomously. It can only do small-batch synthesis where N items × tool-call cost fits inside one session budget.

## The correct architecture going forward

Three execution lanes, each with a clearly bounded job:

| Lane | Who | What it CAN do | What it CANNOT do |
|---|---|---|---|
| **Bulk processing** | Native Python in Adrian's shell (or `hive` later) | Iterate thousands of files, native shell, FDA on Documents | Requires Adrian to launch (until launchd FDA granted) |
| **Small-batch synthesis** | AG via tool calls | Read 5–20 files, write 1–5 outputs, real reading/judgment | Cannot subprocess, cannot iterate thousands of items |
| **Strategic + script-authoring + handoffs** | Claude (me) via web MCP | Write scripts, write briefs, file handoffs, read vault | Cannot spawn long jobs on Adrian's Mac, no shell |

## The fix

1. **Bulk overnight jobs ALWAYS run as native Python launched from Adrian's shell.** Single-command launcher (`run-overnight-grind.sh`). Idempotent. Self-heartbeating. Adrian pastes one command, walks away.
2. **AG briefs ONLY contain small-batch synthesis tasks** sized to fit one session budget. Witness brief deepening, status reports, copy reviews, single-source matrices. Never "process 1,724 items."
3. **My briefs explicitly state the lane.** "This is a Phase X bulk job — runs in Adrian's shell, AG is not involved" OR "This is an AG synthesis batch — N reads, M writes, fits one session."
4. **No more bouncing.** When AG hits a sandbox limit, it logs and continues with the next sub-task in its budget, not a delegation handoff back. Briefs to AG must include enough alternatives that there's always something it can do.
5. **For unsupervised time windows, work goes in the lane that fits the window:**
   - Adrian away 2 hours, awake → AG synthesis batch
   - Adrian asleep all night → bulk shell job, pre-launched

## Path to true autonomy

Two unlocks would let overnight bulk jobs launch without Adrian:
- **Grant Full Disk Access to `/bin/zsh`** in System Settings → Privacy & Security → Full Disk Access. Then a launchd LaunchAgent can run `run-overnight-grind.sh` on a schedule.
- **`hive` invocation from agent context** — `hive` already has unrestricted shell on Adrian's Mac per his memory. If I or AG could trigger a `hive` call, that bypasses the sandbox. (Investigating whether Claude.ai web MCP can reach the local `hive` socket.)

Until either unlock is in place, the human-in-the-loop is one paste of one command before sleep. Acceptable cost; failure mode of the previous architecture (no work done overnight) was unacceptable.

## What's been built today (2026-04-29 morning)

- `working/extraction/phase1_chatgpt_atoms.py` (NEW)
- `working/extraction/phase2_facebook_atoms.py` (NEW)
- `working/extraction/phase3_fingerprint.py` (existed, AG-authored, kept)
- `working/extraction/phase4_duplicates.py` (NEW)
- `working/extraction/phase5_colonise.py` (NEW)
- `working/extraction/phase6_entity_index.py` (NEW)
- `working/extraction/phase7_whatsapp.py` (existed, AG-authored, kept)
- `working/extraction/run-overnight-grind.sh` (NEW master runner)
- `OVERNIGHT-LAUNCH-INSTRUCTIONS.md` at vault root (NEW)
- `working/handoffs/2026-04-29-0930-claude-to-antigravity-fitable-batch-window.md` (NEW — AG re-task for waking-hours window)

— Claude, 2026-04-29 09:45 WITA
