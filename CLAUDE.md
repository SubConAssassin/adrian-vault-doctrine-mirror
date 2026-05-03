# CLAUDE.md
**Claude-specific runtime loader for Adrian-Vault.**
**Last updated:** 2026-05-03

## 1. Bootloader & Primary References
Primary doctrine lives in:
@AGENTS.md

Project canonical state lives in:
`@canonical/projects/{active_project}/_project-ledger.md`

Persona routing rules live in:
`@canonical/system/persona-router.md`

## 2. Startup Boot Logic
- **Silent Success:** Do not produce a greeting or unprompted system analysis when everything is working. Maintain operator frictionlessness.
- **Loud Failure:** You MUST halt and report a loud failure if any of the following occur:
  - `AGENTS.md` fails to load.
  - `_project-ledger.md` is missing for the active project.
  - Broken bridge or unavailable API paths.
  - Safe git branch rules violated.
  - Context monitor exceeds thresholds without preservation.
  - Write verification fails.

## 3. Runtime Operating Rules
- **Check the ledger:** Always check the relevant `_project-ledger.md` before acting.
- **Verify writes:** Verify writes by read-back before claiming success. Do not allow a bridge write or file edit to go unverified.
- **Lazy Load Personas:** Do not load all persona cards by default. Load them only through the persona routing manifest.
- **State Sovereignty:** Do not treat generated cache, dashboard output (`.runtime/`), or external imports (`.planning/`) as canonical state.

## 4. Hive Mind API Stack
You have terminal execution rights. Use the following scripts to query ChatGPT or Grok (The Bridge is retired).

```bash
# ChatGPT (default: gpt-5.4-mini | escalate: --model gpt-5.4)
python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py "your prompt"
python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py --model gpt-5.4 "your prompt"

# Grok (grok-4)
python3 ~/Documents/Adrian-Vault/tools/ask-grok.py "your prompt"
```

### ONE-SHOT PROTOCOL (Hard Rule)
- **One call per question.** Craft a single comprehensive prompt. Accept one reply. Stop.
- **No iteration loops.** Do not follow up or re-prompt the same API in the same session.
- **No agentic chaining.** Do not pass API output back into another API call automatically.
- Run ChatGPT + Grok in parallel (not sequentially) when both are needed — one Bash call each.
- Budget: 1–3 calls per session maximum.

### Why ONE-SHOT exists (war story)
A previous session made 1,053 API calls (~2.7M tokens, ~$8) on a single task. This rule prevents that recurrence. If one reply is insufficient, synthesise what you have and ask Adrian before any further call.

### Keys location
API keys live at: `~/.config/com.adrian-vault/.env`

## 5. Hardware & Remote Control
- **Hardware:** MacBook Pro M3 Pro, 18GB RAM. Always ARM64/Apple Silicon builds. Never Intel.
- **Remote Control (iPhone):** If Adrian connects from iPhone, the session is registered via `claude remote-control` in this vault directory. Fallback URL: `https://claude.ai/code?environment=ENV_ID`.

## Legacy Reference Compatibility
Any old reference in this vault to "CLAUDE.md doctrine" now means:
- `AGENTS.md` for doctrine.
- `CLAUDE.md` for Claude-specific runtime.
- `_project-ledger.md` for canonical project state.
- Verified logs for execution evidence.
