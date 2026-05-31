---
title: Lessons from session — 2026-05-05 (Phone Remote Test)
type: lesson
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-05-05
last_updated: 2026-05-31
applies_to: [claude, antigravity]
related:
  - canonical/concepts/claude-session-operating-rules.md
  - canonical/concepts/chatgpt-dispatch-protocol.md
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/overwatch-daemon-operations.md
  - canonical/concepts/apple-mail-access-protocol.md
---

# Lessons from session 2026-05-05 (Phone Remote Test)

Adrian attempted to operate the hive mind remotely from his phone while out. This session exposed several gaps and produced one significant architectural discovery.

---

## Lesson 1 — The vault mirror is doctrine only, not the full hive mind

The `adrian-vault-doctrine-mirror` GitHub repo syncs `canonical/concepts/` only. It does NOT contain `canonical/projects/`, `canonical/people/`, `canonical/synthesis/`, `canonical/cases/`, or `working/`. Any Claude session connected to this repo can reason about protocols but cannot answer questions about specific contacts (e.g. Erica Johnson), project state, or synthesised intelligence.

**Fix:** Mac-native Claude Code session (or Remote Control) is the required endpoint for anything touching people/projects/working data.

---

## Lesson 2 — Claude Code Remote Control is the native solution for phone→Mac access

Anthropic released **Claude Code Remote Control** in February 2026. Run `claude remote-control` in Terminal on the Mac; the Claude iOS/Android app then connects directly to that session with full vault access, all MCP servers, and all local tools. Outbound HTTPS only — no open ports, no router config.

Constraint: Terminal must stay open and Mac must stay awake and networked. Sessions time out after ~10 min offline. Use tmux for persistence.

**Note:** `claude remote-control` has a trust-dialog gotcha — if it errors "Workspace not trusted", the fix is a direct JSON edit: `~/.claude.json` → `projects.<path>.hasTrustDialogAccepted: true`. Do not fight the interactive prompt. See `claude-session-operating-rules.md` for the canonical fix.

---

## Lesson 3 — Dispatcher is concurrency control, not access control

When asked "can I set this up through dispatch?" — the answer is no. The Dispatcher Protocol manages write conflicts between sessions that already have vault access. It does not grant or route access to the Mac's local environment. Dispatch (`chatgpt-dispatch.sh`) routes prompts to ChatGPT — a different thing entirely.

Architecture clarity:

| Mechanism | What it does | Mac needed? |
|---|---|---|
| Claude app (mobile/web) | Full Claude on Anthropic servers | No |
| Claude Code Remote Control | Mobile Claude app gains Mac vault + tools | Yes — stays on |
| chatgpt-dispatch.sh | Routes task to ChatGPT via AppleScript | Yes — runs script |
| Dispatcher Protocol | Concurrency control between sessions | Pre-existing access assumed |
| Local LLM (iPad) | Small offline model on device | No |

---

## Lesson 4 — Email monitoring daemon does not exist

The overwatch daemon covers Rode Rec transcription only. No email watcher exists. An email from a key contact (Erica Johnson) sat unread for several days with no alert and no draft response.

**Fix:** Build email monitoring daemon using `apple-mail-access-protocol.md` as the access layer. Watch for `.emlx` changes from key contacts, generate alert + auto-draft, file to `working/drafts-pending/`. Commission to Antigravity when Mac session is active.

---

## Superseded content from this session

- **Mac Studio spec research** (M4 Max 128GB, ~$2,200–2,600 secondhand) — superseded by `64gb-macbook-readiness-pack.md`. Adrian is getting a 64GB Apple Silicon MacBook instead.
