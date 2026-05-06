---
title: Session Lessons — 2026-04-23/24 Hive Mind Assimilation
type: lesson
status: canonical
tier: 2
firewall_class: working-internal
priority: HIGH — pre-load for any future extraction / scripting / multi-agent work
created: 2026-04-24
last_updated: 2026-04-24
session_duration: ~27 hours including reboot
source_session: Hive Mind Assimilation Phase 1 + Phase 2
related:
  - canonical/concepts/lessons-learned.md
  - canonical/concepts/hive-mind-assimilation-strategy.md
---

# Session Lessons — Hive Mind Assimilation

Retrospective from the 2026-04-23/24 session. Purpose: ensure future Claude sessions do not repeat today's friction.

---

## TOP-LEVEL LESSON

**When scripts hang silently on macOS, the file is probably an iCloud stub. Check `du -sh` before anything else.**

This single fact cost ~4 hours today. It is now lesson #1.

---

## Mistake 1 — iCloud Stub Files Silently Hang Python

### What happened
- `/Users/adriantaffinder/Documents/Adrian-Archive/chat-exports/chatgpt downlod file/*.zip` showed 1.14GB via `ls -la` but 0B via `du -sh`
- Python's `zipfile.ZipFile(path)` hung indefinitely trying to open it
- Multiple processes accumulated, each with <0.2s CPU over 30+ minutes of wallclock
- Terminal output capture looked empty because scripts were blocked BEFORE any print statement executed

### Root cause
`Documents/` folder is iCloud-synced. Files can be evicted from local storage (data removed, metadata kept). Opening them for read triggers iCloud download — which can take minutes to hours depending on connection. Python blocks the entire time.

### Fix (diagnostic)
```bash
du -sh '/path/to/file'
# If 0B but ls shows real size → iCloud stub
```

### Fix (operational — choose one)
1. **`brctl download '/path/to/file'`** — triggers download from iCloud
2. **Right-click in Finder → Download Now**
3. **`mdutil` workaround** — may work
4. **Restart Mac** — often triggers bulk re-sync (this is what fixed it today)

### Pre-check before any heavy file operation
```bash
for f in /path/to/files/*; do
  if [ "$(du -k "$f" | cut -f1)" = "0" ] && [ -f "$f" ]; then
    echo "ICLOUD STUB: $f"
  fi
done
```

---

## Mistake 2 — Assumed Zip Structure Without Checking

### What happened
Original ChatGPT extraction script assumed `conversations.json` at zip root. New ChatGPT export format uses sharded files: `conversations-000.json` through `conversations-008.json`. Script crashed with `KeyError`.

### Fix
Before writing any zip-processing code:
```python
import zipfile
z = zipfile.ZipFile(path)
print(z.namelist()[:20])
```
Always inspect the manifest first. Do not assume structure from prior knowledge.

---

## Mistake 3 — Wrote HTML Parser Without Reading the HTML

### What happened
Instagram DM parser looked for `div` children to find sender names. The actual HTML has sender names in `<h2>` elements. Script produced garbage output: "Unknown Date" for every timestamp, message content showing timestamps, wrong usernames.

### Fix
For any HTML extraction:
1. Read at least one sample file first
2. Identify the actual DOM element structure (classes, tags)
3. Write parser to match what's there, not what you expect

### Correct Instagram DM structure (locked for future reference)
```html
<div class="pam _3-95 _2ph- _a6-g uiBoxWhite noborder">
  <h2 class="_3-95 _2pim _a6-h _a6-i">SENDER NAME</h2>
  <div class="_3-95 _a6-p">
    <div><div></div><div>MESSAGE TEXT</div>...</div>
  </div>
  <div class="_3-94 _a6-o">TIMESTAMP</div>
</div>
```

---

## Mistake 4 — Silent Script Failures (No Per-Iteration Logging)

### What happened
Instagram v1 script ran through all 88 threads but:
- Only printed "Processing 88 DM threads..." once at start
- Then silent
- No per-thread progress
- Crashed on thread 16 with no error trace
- No way to see where it died

### Fix
For any batch process (>10 iterations):
```python
import sys
for i, item in enumerate(items):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] [{i+1}/{len(items)}] {item.name}", flush=True)
    # ...
    # Use flush=True or sys.stdout.flush() — critical
```

---

## Mistake 5 — No Try/Except Per Iteration

### What happened
One bad HTML file killed the entire Instagram run at thread 16/88. Lost all 16 prior files of work (they'd been written but to a directory that was mid-processing).

### Fix
Wrap each iteration unit in its own try/except:
```python
for i, item in enumerate(items):
    try:
        process_single(item)
    except Exception as e:
        log(f"  FAIL: {e}")
        log(traceback.format_exc())
        # continue — don't crash the whole run
```

---

## Mistake 6 — Terminal `do script` + `tee` Doesn't Capture Output Reliably

### What happened
Multiple attempts used:
```applescript
tell application "Terminal"
  do script "python3 script.py 2>&1 | tee log.txt"
end tell
```
Log files stayed 0 bytes even when Terminal windows showed output scrolling. Caused false conclusions about scripts being hung when they were running fine.

### Fix
Two reliable approaches:

**Approach A — `tee` inside Terminal works IF:**
- Script uses `python3 -u` flag (unbuffered)
- Python code uses `flush=True` on prints
- No intermediate shell wrapping

**Approach B — redirect via `do shell script`:**
```applescript
do shell script "python3 -u script.py > log.txt 2>&1 &"
```
Works for background jobs. File permissions must allow it (some paths hit TCC).

**Approach C — verify output directly:**
```bash
ls -la log.txt  # check size > 0
tail -5 log.txt  # check content
```

Don't trust the Terminal UI showing output. Verify log file actually has bytes.

---

## Mistake 7 — CPU Time Is the Real "Stuck" Indicator

### What happened
Multiple times I saw processes "running" in `ps aux` but assumed they were working. They weren't — they were blocked on I/O.

### Fix
Check the TIME column (CPU time accumulated):
- `0:00.04` after 5 minutes wallclock = **BLOCKED** (kill it)
- `0:00.14` after 20 minutes = **BLOCKED**
- `2:30.00` after 5 minutes = **WORKING HARD**
- `15:00.00` after 10 minutes = **POSSIBLE INFINITE LOOP**

Rule: if CPU time < 1 second and wallclock > 30 seconds, it's blocked. Kill and diagnose.

---

## Mistake 8 — `do shell script` vs. `tell Terminal do script` Have Different TCC Permissions

### What happened
`do shell script` hit TCC (Transparency, Consent, Control) walls when accessing `Adrian-Archive/`. `tell application Terminal do script` ran with Terminal's permissions (which had Full Disk Access).

### Fix
- **Simple shell commands** (checking files, running quick scripts): `do shell script`
- **Long-running scripts or anything touching protected folders**: `tell application Terminal do script`
- **Background daemons**: `nohup ... &` via `do shell script` works IF the command has permissions

---

## Mistake 9 — Did Not Use Direct API When Stuck

### What happened
Spent significant time spinning on the iCloud/TCC issue, trying variations of osascript approaches. Adrian had to tell me to use the direct ChatGPT API for technical advice.

### Fix
**When stuck on a technical problem for more than 15 minutes of retries, use the direct API immediately:**
- `~/Documents/Adrian-Vault/tools/ask-chatgpt.py "<technical problem description>"`
- `~/Documents/Adrian-Vault/tools/ask-grok.py "<technical problem description>"`

The Bridge is RETIRED. Use direct API scripts only.

---

## Mistake 10 — Over-Hedging and Stalling

### What happened
Adrian noticed I was "stalling a lot." Instead of executing or diagnosing decisively, I was producing long status updates about what I was trying.

### Fix
- Execute or kill, don't narrate
- One brief status update per action, not ongoing commentary
- When a thing fails, diagnose in one step, then fix. Don't try 5 variations of the same broken approach.

---

## Mistake 11 — Referenced the Retired Bridge

### What happened
Mentioned "Bridge" in my flow. Adrian corrected me — Bridge is retired.

### Fix
Memory updated. Locked in:
- Direct API scripts only: `ask-chatgpt.py`, `ask-grok.py`
- Keys at `~/.config/com.adrian-vault/.env`
- Never reference the Bridge in any context, ever again

---

## Mistake 12 — Filesystem MCP Timeouts

### What happened
`Filesystem:read_multiple_files` and other Filesystem tool calls timed out during the session, breaking the flow. Fell back to osascript successfully.

### Fix (workaround)
- If Filesystem MCP times out, use `do shell script "cat file"` via osascript
- For large files, use `head -N` or `tail -N` to get chunks
- If osascript hits size limits (string escape nightmares), write a small Python/bash script to a file and execute it

---

## Mistake 13 — Tried to Use Backslash-Escape Python One-Liners via osascript

### What happened
Multi-line Python inline in `do shell script "python3 -c '...'"` kept failing due to nested quote escaping (AppleScript strings ⇄ shell strings ⇄ Python strings = three layers of hell).

### Fix
**Never inline non-trivial Python in osascript.** Always:
1. Write the script to a file with `Filesystem:write_file`
2. Execute the file with `do shell script "python3 /path/to/script.py"`

One layer of escaping max.

---

## Mistake 14 — Did Not Catch "Facebook Extraction Status" Early

### What happened
Phase 1 commission asked Antigravity to check whether the 2026-04-18 Facebook extraction was complete. This never got confirmed. Completion report noted it as "unconfirmed" rather than resolving it.

### Fix
For any multi-part commission with a "status check" component, verify the status check actually returned an answer before marking the commission complete.

---

## MASTER PRE-FLIGHT CHECKLIST (for future extraction work)

Before starting any file-based extraction on Adrian's Mac:

1. ✅ **Check iCloud status**: `du -sh /path/to/target` — if 0B, trigger download
2. ✅ **Inspect source structure**: List zip contents / read sample HTML / preview JSON schema
3. ✅ **Write script with verbose per-iteration logging**: `print(..., flush=True)` every unit
4. ✅ **Wrap each iteration in try/except**: One bad input cannot kill the run
5. ✅ **Use `python3 -u`**: Unbuffered output
6. ✅ **Redirect output to log file**: `> log.txt 2>&1`
7. ✅ **Launch via `tell Terminal do script`** for long jobs, or `nohup` for background
8. ✅ **Verify progress**: Check log file size growing, check `ps aux` for real CPU time
9. ✅ **Kill-and-diagnose rule**: If CPU <1s after 30s wallclock → it's blocked
10. ✅ **Use direct API (not Bridge) if stuck >15 min**

---

## MASTER SHUTDOWN PROTOCOL (for any Claude session)

When Adrian signals session end or restart:

1. **Save all unsaved work** — write to vault, not just context
2. **Run process audit** — `ps aux | grep python` — identify active tasks
3. **Preserve healthy daemons** (overwatch, dashboard) — don't kill
4. **Kill any stalled extraction processes** — anything with <1s CPU over 5+ min
5. **Write completion/status report** to `working/handoffs/YYYY-MM-DD-[session-name]-closeout.md`
6. **Write lessons to canonical** if any emerged this session
7. **Write Apple Note** — brief, findable, searchable
8. **Update relevant canonical files** if memory/facts changed
9. **Tell Adrian**: safe/unsafe to restart + one-line status

---

## Files to pre-load at start of future sessions

Based on what was useful this session:

| Session type | Pre-load these |
|--------------|----------------|
| Any extraction/scripting work | THIS file (session-lessons.md) |
| Any copy/content work | voice-profile.md + sales-language.md |
| Any project-specific work | chatgpt-project-intelligence.md section for that project + relevant canonical |
| Any customer communication | voice-profile.md + reasoning-patterns.md |
| Multi-agent coordination | AGENTS.md + relevant recent handoff files |

---

## One-Line Summary

> **On macOS, files in iCloud-synced folders can be stubs. Always `du -sh` before heavy ops. Always log per-iteration with `flush=True`. Always wrap each iteration in try/except. If stuck >15 min, use the direct API. The Bridge is retired.**
