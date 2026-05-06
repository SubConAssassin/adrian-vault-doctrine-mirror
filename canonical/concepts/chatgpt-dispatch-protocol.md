---
title: ChatGPT-Dispatch Protocol
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-04-20
last_updated: 2026-04-20
related:
  - canonical/concepts/api-integration-doctrine.md
  - canonical/concepts/bridge-protocols.md
  - canonical/concepts/dispatcher-protocol.md
tags: [hivemind, chatgpt, dispatch, protocol, adrian-os]
---

## What this is

The local AppleScript bridge that allows Adrian — from iPhone via Claude Code, or from any agent on the stack — to send a prompt to the ChatGPT macOS app and record it in the vault.

- **Installed script:** `~/Documents/Adrian-Vault/bin/chatgpt-dispatch.sh`
- **Vault dispatch log:** `working/chatgpt-dispatches/`
- **Default mode:** `new` (fresh ChatGPT conversation per dispatch)
- **Notification:** Mac notification always; iMessage-to-self if `APPLE_ID` set in `~/.adrian-os.conf`

## Why the script lives in the vault (not ~/bin)

Three reasons:
1. Every agent with vault access can call it without special PATH setup.
2. It is part of Adrian-OS doctrine; versioned and audited alongside the canonical docs.
3. If Adrian wants a shorter invocation path, a single symlink covers it: `ln -s ~/Documents/Adrian-Vault/bin/chatgpt-dispatch.sh ~/bin/chatgpt-dispatch`.

## Invocation patterns

### From Claude Code session on Mac
```bash
~/Documents/Adrian-Vault/bin/chatgpt-dispatch.sh --mode deep-research "Research X with full sources."
```

### From Adrian via iPhone Claude mobile app
Adrian says one sentence: *"Dispatch to ChatGPT deep-research: [intent]."*
Claude Code session translates to the script call above.

### Modes
- `new` (default): opens a fresh ChatGPT chat before sending
- `continue`: appends to whatever conversation is currently open in ChatGPT
- `deep-research`: same as `new` but prompt is pre-formatted to invoke Deep Research
- `work-with-apps`: same as `new` but assumes ChatGPT's Work-with-Apps mode is already active on a target editor

## What's recorded

Every dispatch creates a file in `working/chatgpt-dispatches/` named
`YYYY-MM-DD-HHMM-SHORTID-MODE.md` with:
- UUID and short_id
- Timestamp
- Mode
- Status (`pending` → `dispatched` → `completed` in Phase 2)
- Optional `intent_ref` linking back to a `working/intents/` file
- Full prompt text
- Response placeholder (filled by capture script in Phase 2)

## Response retrieval (Phase 1)

For now: ChatGPT conversation syncs across your logged-in devices automatically.
Read it in the ChatGPT iPhone app or Mac app. Phase 2 will auto-capture via
GUI scripting and fill the `## Response` section of the dispatch file.

## Rules

1. Every dispatch lands in the vault. No exceptions. No fire-and-forget.
2. `status: pending` means script started but UI automation hasn't completed.
3. `status: dispatched` means the prompt was successfully pasted and submitted.
4. `status: completed` (Phase 2 only) means the response has been captured.
5. On first run, grant Accessibility + Automation permissions to Terminal
   AND the calling process (Claude Code) for ChatGPT target.
6. If `APPLE_ID` is configured in `~/.adrian-os.conf`, dispatches also send
   an iMessage-to-self. Otherwise Mac notification only.

## Failure modes

- ChatGPT.app not installed → script exits 2
- No Accessibility permission → AppleScript errors; script exits 3
- ChatGPT window not focused (rare, can happen if another modal is open) →
  paste goes to wrong window. Mitigation: script calls `set frontmost to true`.
- Mac locked → UI automation fails silently. Mitigation: don't let Mac lock.
- Rate limit / quota hit → ChatGPT shows error in UI; dispatch file still
  marked `dispatched`. Phase 2 capture script will detect and update status.

## Related

- `canonical/concepts/hive-mind-resource-map.md` (Routing doctrine)
- `canonical/concepts/adrian-os-event-bus.md` (vault event conventions)
- `canonical/ecosystem/shared-infrastructure.md` (§ 4 vault + shared brain)
- `procedural/workflows/dispatch-chatgpt.md` (tactical how-to for Adrian)
