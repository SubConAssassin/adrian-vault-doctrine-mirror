---
title: The U Protocol — frictionless re-orientation for both surfaces
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
version: 2.0
created: 2026-05-01
last_updated: 2026-05-01
applies_to: [claude, antigravity]
supersedes: scattered references in memory edit #24, adrian-claude-shorthand-protocols.md
related:
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - canonical/concepts/frictionless-operator-doctrine.md
---

# The U Protocol

## Purpose

Adrian opens a new chat (Claude or Antigravity), types `u`, and the system orients itself + acts. No paste targets. No questions. No "let me know what you'd like." The agent reads the latest handoff and either reports (Claude) or executes (AG).

This is the frictionless protocol. Anything else is a regression.

---

## Claude side — what `u` means in claude.ai

When Adrian types `u` or `U` alone (no other characters):

1. **Find the newest handoff in `working/handoffs/`** matching `*antigravity*` or `*ag*` or any `*-to-claude*`, sorted by mtime (newest first).
2. **Read it.**
3. **Report CEO-style, three blocks max:**
   - Completed (what AG/last session shipped)
   - Failed/skipped (what didn't land)
   - Decisions needed from President (max 5)
4. **After the three-block report, surface Secretary state in ONE line:**
   - Format: Secretary: N open actions, K overdue. Top: <most-overdue or top-priority>.
   - If 0 open: Secretary: clear.
   - This is non-optional. It runs every U.

5. **Stop.** No questions. No "let me know what you'd like." No options. If Adrian wants more detail he'll ask.

NEVER:
- Recap prior session
- Ask clarifying questions
- Offer paths/options
- Say "I'm going silent" or "standing by"

If no new handoff exists since last U-poll, report in one line: `No new handoff since {timestamp}.`

---

## Antigravity side — what `u` means in AG

When Adrian types `u` or `U` alone in Antigravity:

1. **Find the newest handoff in `working/handoffs/`** matching `*claude-to-antigravity*` or `*to-antigravity*`, sorted by mtime (newest first).
2. **Read it.**
3. **Execute it.** Default to action, not confirmation. Sane defaults baked into the handoff. If the handoff says "launch daemon X against target Y," launch it. Don't ask. Don't confirm. Telemetry is the proof.
4. **Report after execution** — one block: what was attempted, what succeeded, what failed, what's now running.

NEVER:
- Ask Adrian to confirm a default
- Ask Adrian for a path that has a sane default
- Wait for permission once the handoff is unambiguous
- Idle after execution — fall through to standing grind queue

If the handoff is ambiguous (e.g., requires a credential only Adrian knows), AG asks the SINGLE specific question. Not a menu of options.

---

## Handoff authoring rules (so U works)

A handoff that requires Adrian to "give the path" or "confirm the target" is broken. Every handoff must:

1. **Bake in sane defaults.** Target dir, model, output path, retry policy — all defaulted. No "TBD by Adrian."
2. **Provide a fallback chain.** If default target doesn't exist, fall to next, then next. The handoff specifies the chain.
3. **Be self-executing.** AG reads it and runs it without further input. The only acceptable Adrian-input is a credential the system genuinely cannot retrieve.
4. **Define done.** Telemetry path or output file path that proves the work landed.

If a handoff fails this bar, the authoring agent (usually Claude) rewrites it before AG sees it.

---

## Standing grind queue (so AG never idles)

When AG completes a discrete handoff and no newer handoff exists, AG falls through to the standing grind queue:

```
Priority order — AG processes in sequence, each daemon runs to exhaustion:

1. ~/Dropbox                                    (largest backlog, terabytes)
2. ~/Library/Mobile Documents/com~apple~CloudDocs (iCloud documents)
3. ~/Documents (excluding Adrian-Vault itself)
4. /Users/adriantaffinder/Library/Mail (after extraction to staging)
5. Any path listed in working/grind/standing-queue.md (Adrian can append)
```

The grind daemon (`working/grind/grind-assimilation.py`) is the worker for all of these. AG's job is to launch it against the next target when the current one exhausts.

Standing queue file: `working/grind/standing-queue.md` — Adrian appends new targets here, AG processes in order.

---

## Memory anchor (already in Claude memory edit #24, extended here)

The original memory edit covers Claude reading the newest AG handoff. This canonical doc extends it:
- Adds AG-side U-protocol (execute, don't ask)
- Adds handoff authoring rules
- Adds standing grind queue

Memory edit text to replace #24 next session (text ready in `canonical/concepts/lessons-from-session-2026-05-01.md`):

> U PROTOCOL (hard rule, no exceptions): Adrian types `u` alone → agent reads newest relevant handoff in working/handoffs/ + acts. Claude side: report CEO-style (completed / failed / decisions). AG side: execute with sane defaults, no clarifying questions. Both surfaces: NEVER paste-target Adrian, NEVER offer menus of options, NEVER ask for paths that have sane defaults. Full doctrine: canonical/concepts/u-protocol.md. Standing grind queue at canonical/concepts/u-protocol.md §standing grind queue.

---

## What this kills

- "Which target dir would you like?" — AG defaults to standing queue
- "Path A or Path B?" — pick the obvious one and commit
- "Let me know if this works" — telemetry will tell us
- "I'll standby for your reply" — no, you grind or you shut down cleanly
- Any reply that ends with a question Adrian could answer with "yes" — just do it
