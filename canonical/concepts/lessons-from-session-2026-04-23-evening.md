---
title: Lessons — 2026-04-23 Evening Session
type: lessons
session_date: 2026-04-23
duration: ~90 min
theme: pipeline diagnosis discipline + MCP fragility
---

## Six durable lessons from the Rode Rec resurrection + Overwatch brief intake session.

### 1. "Silent streaming" ≠ frozen
**Pattern:** a log file that hasn't updated in 10 minutes LOOKS identical to a crashed process but is very often a large file mid-download or mid-transcription.

**Diagnostic rule — all three must be zero before declaring "hung":**
- Staging directory byte growth over 3–5s sample (`ls -lh` twice, diff)
- `nettop -P` throughput on the worker PID
- Process CPU% from `ps aux`

**Corollary:** any script that downloads files >100 MB needs progress logging. The `reporthook` pattern (log every ~8 MB) shipped this session — retain in all future ingestion workers.

### 2. Log duplication = stdout double-capture
If every log line appears twice, the script is writing via both `print()` AND `f.write()` while `nohup` is also capturing stdout to the same file. Cosmetic not functional — fix by picking one channel (prefer `f.write` + `logger`, not `print`).

### 3. nohup via AppleScript: verify spawn, don't trust errors
`osascript do shell script "nohup ... &"` frequently returns an error to the caller but DOES spawn the background process. Never trust the return code — always verify with `pgrep -af <script_name>` immediately after launch. If you get N PIDs when you expected 1, kill them all and relaunch cleanly.

### 4. MCP transport is not infrastructure-grade
Both Control-your-Mac (osascript) and Filesystem MCP servers can stall simultaneously mid-session. Observed this session: two successive tool calls hung for 4+ min each with no recovery.

**Mitigation:**
- At session start, do a lightweight MCP health check (`ls` one known file). If it returns fast, you're good. If it hangs, tell Adrian to cycle MCP before proceeding.
- Background local processes (pipelines, daemons) run independently of MCP and keep flowing. Don't panic-kill them because MCP is down.
- Write any important draft content to the chat window as well as attempting vault writes — chat is the durable channel when MCP is flaky.

### 5. CEO discipline > expert diagnosis
Antigravity's dispatch declared "frozen ghost processes — kill them and relaunch." Evidence check revealed the pipeline was actually streaming at 4 MB/s. Claude ran the evidence check BEFORE executing the kill, then did kill cleanly (because zombies from earlier nohup attempts genuinely existed) AND corrected the frozen-diagnosis in the ACK.

**Rule:** treat other LLMs as consults, not directors. Their diagnosis is input, not command. When their diagnosis contradicts evidence you can see directly, trust the evidence and document the correction.

### 6. Hive mind round-trip is real
Suggested `reporthook` progress-logging in ACK at 20:15. Observed it shipped in production code by 21:03 — same session. Propose in one agent, ship in another. This is the working pattern, not the exception — keep proposing concrete patches in ACKs rather than just describing problems.

## Meta-lesson

The session's single biggest leverage-per-minute action was NOT executing the dispatch — it was **refusing to execute the wrong part of it**. "Kill the zombies" was correct; "pipeline is frozen" was wrong. Executing both blindly would have killed a working worker and delayed Tier 1 by another hour. Reading evidence before acting saved that hour.

This is the CEO role. Execution is cheap; correct diagnosis is expensive.
