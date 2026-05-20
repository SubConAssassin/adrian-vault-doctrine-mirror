---
title: AG Bootup-Reload Prompt
type: doctrine
status: active
firewall_class: working-internal
last_updated: 2026-05-20
purpose: |
  Single self-contained prompt Adrian pastes into the Antigravity chat at the
  start of any new session to force AG to re-bootload the hive doctrine.
  Use when AG seems to have forgotten its role, missed handoffs, or is
  behaving as if it hasn't read AGENTS.md (common after model upgrades like
  the 2026-05-19 Gemini 3.5 Flash High rollout).
---

# AG Bootup-Reload Prompt

## When to use

Paste the prompt below into the Antigravity chat panel as your **first message** in a new session, OR any time AG seems to have lost the bootup protocol (didn't check handoffs, didn't read AGENTS.md, confabulated, used scarcity framing, etc.).

## Why this is needed

Antigravity workspace is currently `~/Documents/localhost/`. AG auto-loads `AGENTS.md` from workspace root — a pointer file now lives there as of 2026-05-20 — but in-flight sessions started BEFORE that file existed won't pick it up until you reload. This paste-and-go prompt forces a re-bootload mid-session without restarting AG.

## The prompt (copy below as a single block, paste into AG chat)

---

```
Bootup-reload directive. Before doing anything else this session, execute the following in order and acknowledge each step:

1. Read /Users/adriantaffinder/Documents/localhost/AGENTS.md (workspace pointer).
2. Read /Users/adriantaffinder/Documents/Adrian-Vault/AGENTS.md (full operating doctrine).
3. Read /Users/adriantaffinder/Documents/Adrian-Vault/canonical/concepts/antigravity-operating-contract.md (anti-confabulation contract — read IN FULL, this is mandatory).
4. Read /Users/adriantaffinder/Documents/Adrian-Vault/canonical/concepts/hive-architecture-v3.md (4-layer routing matrix and your lane).
5. Read the top 3 entries of /Users/adriantaffinder/Documents/Adrian-Vault/working/handoffs/STATE-OF-STACK.md (current operational state).
6. List /Users/adriantaffinder/Documents/Adrian-Vault/working/handoffs/ for any *claude-to-ag-*.md and *claude-to-adrian-*.md from the last 24 hours. Read each one. Identify which are pending action.

Then reply with a single short paragraph containing:
- Confirmation: "Bootup-reload complete."
- The N pending Claude-to-AG handoffs you found, listed by filename + one-line purpose.
- Your understanding of your role in Hive Architecture v3 (one sentence).
- The §7 firewall rule (one sentence — what is and isn't quarantine-class).
- What Adrian asked you to do most recently in this chat (one sentence).

After acknowledgement, work the pending Claude handoffs in priority order before continuing on whatever else was in the chat.

Critical reminders that broke post-3.5-upgrade:
- The handoffs directory is canonical. Chat is volatile. Always check handoffs before starting work.
- Burn is unlimited (1B-10B token/month envelope). Never use scarcity framing.
- §7 firewall: ex-girlfriend "Chelsea" = quarantine. Client/3rd-party "Chelsea" = attribute normally.
- Anti-confabulation: never invent citations, speaker attributions, or "Forensic Synthesis"/"Legal Materiality" framings. If you can't ground a claim from a real source file, mark [GAP] or [UNVERIFIED] — never fabricate.
- Verify-before-trust: run deterministic checks (file count, frontmatter, banned-boilerplate scan, §7 scan) BEFORE declaring COMPLETE. File token accounting in your COMPLETE handoff.
- When you need Adrian's input, file a claude-to-adrian-*.md handoff. When you need Claude's input, file an ag-to-claude-QUESTION-*.md handoff. Don't only reply inline — the chat is volatile.
```

---

## Notes for Adrian

- This prompt is ~500 words. AG should process it in one turn without truncation.
- The pointer file at `~/Documents/localhost/AGENTS.md` means future *new* AG sessions auto-load doctrine without you needing to paste this. Use this prompt for:
  - Already-open sessions (like right now)
  - Sessions where AG is behaving badly mid-flow
  - Confirming AG is bootloaded before a high-stakes task
- If AG's acknowledgement reply is short/lazy or invents content, paste again with: "Re-do step N — your previous answer was [specific defect]."
- If AG continues to misbehave even after a clean reload, that's evidence the Memories system needs population (separate fix — to be built when AG exposes a Memories write API or Adrian can paste into the Memories UI panel).

## Future-proofing

Per the Gemini 3.5 Flash High upgrade pattern, future Google releases may again reset agent preferences and instruction-following weights. When that happens:
1. Run `python3 tools/ag-prefs.py dump` to confirm whether `agentPreferences` got reset.
2. Re-apply `python3 tools/ag-prefs.py patch all-permissive` if so.
3. Paste this bootup-reload prompt at AG.
4. Verify AG acknowledges all 6 steps.

This is the standard recovery sequence for any AG model upgrade.

— 2026-05-20
