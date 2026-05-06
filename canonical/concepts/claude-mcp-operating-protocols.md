---
title: Claude MCP Operating Protocols
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-04-24
last_updated: 2026-04-24
related:
  - canonical/concepts/claude-session-operating-rules.md
  - canonical/concepts/mcp-connector-taxonomy.md
---

# Claude MCP Operating Protocols
**Created:** 2026-04-24
**Source:** Hard lessons from session 2026-04-23/24 where MCP degraded mid-session causing ~1hr of token burn with zero output.

---

## MCP HEALTH CHECK — RUN FIRST, ALWAYS

Before any work in a new session:
```applescript
do shell script "echo MCP_OK"
```
If this returns `MCP_OK` → proceed.
If it hangs or errors → **restart Claude Desktop before doing anything else**.

---

## FAILURE MODE MAP

### Failure 1: `Filesystem:read_multiple_files` hangs 4 minutes then times out
- **Cause:** MCP server connection leaks mid-session
- **Fix:** Use osascript single-file reads for up to 3 files. Restart Claude Desktop if persistent.
- **Protocol:** Never call `read_multiple_files` with more than 3 files in one call.

### Failure 2: `osascript` errors on complex shell strings
- **Cause:** AppleScript `do shell script` cannot handle nested quotes, backticks, `$()`, `<<EOF` heredocs inside the AppleScript string.
- **Fix:** Write all complex logic to a `.py` or `.sh` file first via `Filesystem:write_file`, then execute the file:
  ```applescript
  do shell script "nohup /opt/homebrew/bin/python3 /path/to/script.py > /tmp/out.log 2>&1 &"
  ```

### Failure 3: osascript times out on long-running commands
- **Cause:** AppleScript has an implicit ~60s timeout on `do shell script`.
- **Fix:** Always suffix long commands with `&` (background). Read output from a log file, not stdout return value.

### Failure 4: ask-chatgpt.py / ask-grok.py calling convention unknown
- **Known:** Scripts exist at `~/Documents/Adrian-Vault/tools/ask-chatgpt.py` and `ask-grok.py`
- **API keys at:** `~/.config/com.adrian-vault/.env`
- **Models:** gpt-4.1 (ChatGPT), grok-4 (Grok)
- **Verify calling convention first:** Run with `--help` argument, capture to /tmp, read back.
- **Staging pattern:** Write prompt to a file → pass file path to script (or pipe via stdin if confirmed).
- **Always run background with nohup** — API calls take 10–60s, osascript will timeout otherwise.

---

## SAFE OSASCRIPT PATTERNS

```applescript
-- SAFE: simple command
do shell script "ls /path/to/dir"

-- SAFE: background long process, read log later
do shell script "nohup /opt/homebrew/bin/python3 /Users/adriantaffinder/Documents/Adrian-Vault/tools/ask-chatgpt.py /tmp/prompt.txt > /tmp/cg_out.log 2>&1 &"

-- SAFE: check a PID
do shell script "ps -p 14894 -o pid,stat,command"

-- UNSAFE: nested quotes
do shell script "python3 -c \"print('hello')\""  -- FAILS

-- UNSAFE: heredoc
do shell script "cat << 'EOF'\nhello\nEOF"  -- FAILS

-- UNSAFE: $() subshell in string
do shell script "echo $(date)"  -- UNPREDICTABLE
```

---

## TOKEN CONSERVATION: THE 2-FAIL RULE

If any tool fails **twice in a row**:
1. STOP all tool calls immediately.
2. Run `do shell script "echo ok"` to test MCP health.
3. If that fails → tell Adrian "MCP degraded, restart Claude Desktop and say retry."
4. Do NOT keep retrying. Each 4-min timeout = significant token burn = zero value.

---

## WRITE-FIRST DOCTRINE

`Filesystem:write_file` is the most reliable MCP tool — it has never failed in production.

For any complex operation:
1. **Write** the logic to a file (`.py`, `.sh`, `.md`) via `Filesystem:write_file`
2. **Execute** via osascript pointing at the file path
3. **Read** results from a log file via `do shell script "tail -20 /tmp/logfile.log"`

Never try to embed multi-line logic directly in an osascript string.

---

## HIVEMIND API CALL PATTERN (verified working approach)

```
1. Write prompt to: working/overwatch_prompt.txt (via Filesystem:write_file)
2. Stage runner script to: working/hivemind-replies/run_hive.sh (via Filesystem:write_file)
   Content:
     #!/bin/bash
     /opt/homebrew/bin/python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py "$1" > ~/Documents/Adrian-Vault/working/hivemind-replies/chatgpt-reply.md 2>&1
     /opt/homebrew/bin/python3 ~/Documents/Adrian-Vault/tools/ask-grok.py "$1" > ~/Documents/Adrian-Vault/working/hivemind-replies/grok-reply.md 2>&1
3. Execute:
   do shell script "nohup bash ~/Documents/Adrian-Vault/working/hivemind-replies/run_hive.sh ~/Documents/Adrian-Vault/working/overwatch_prompt.txt > /tmp/hive_run.log 2>&1 &"
4. Wait 60-90 seconds, then read output files.
```

---

## RELATED DOCS

- `working/overwatch_prompt.txt` — staged Overwatch Daemon brief (Bonjour, self-healing, LaunchAgent)
- `working/handoffs/2026-04-24-0000-session-closeout-mcp-lessons-overwatch.md` — full session closeout
- `canonical/infrastructure/hive-mind-toolchain.md` — tool/credential/gotcha reference
