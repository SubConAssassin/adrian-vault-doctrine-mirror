---
title: Session Shutdown Protocol
type: canonical-procedure
priority: MEDIUM — run when Adrian signals session end or restart
created: 2026-04-24
distilled_from: 2026-04-23/24 Hive Mind Assimilation session
---

# Session Shutdown Protocol

Standard procedure when Adrian signals end of session, or wants to restart Claude/Mac.

---

## Step 1 — Process Audit (30 seconds)

```bash
ps aux | grep -E 'python|extract|transcribe' | grep -v grep | awk '{print $2, $3, $10, $11}'
```

Classify each running process:

| Classification | Action |
|----------------|--------|
| **Healthy daemon** (overwatch, dashboard) | LEAVE RUNNING — they survive restart |
| **Active extraction/script** with real CPU | Let finish OR pause-and-resume pattern |
| **Stalled process** (<1s CPU over 5+ min) | KILL — it's blocked, serves no purpose |
| **System processes** (Dropbox, etc.) | LEAVE RUNNING |

---

## Step 2 — Save Unsaved Work

Any output sitting only in Claude's context window is lost on restart. Before shutdown:

- ✅ All new canonical files written to `canonical/`?
- ✅ All handoffs/completions written to `working/handoffs/`?
- ✅ Any in-progress corpus/analysis saved to disk?
- ✅ Any decisions or facts that emerged this session captured somewhere persistent?

---

## Step 3 — Lessons Extraction

If meaningful lessons emerged this session (technical discoveries, procedural fixes, voice insights):

→ Write to `canonical/concepts/session-lessons-YYYY-MM-DD.md` (or append to existing)

If only routine work occurred: skip.

---

## Step 4 — Canonical Updates

Check if any canonical files were contradicted or superseded by session work:

- Memory changes? → Already handled via `memory_user_edits` during session
- Facts changed? → Update relevant `canonical/*.md`
- Project status changed? → Update relevant project canonical

---

## Step 5 — Closeout Handoff

Write a brief closeout file at `working/handoffs/YYYY-MM-DD-session-closeout-[name].md`:

```markdown
---
title: Session Closeout — [name]
date: YYYY-MM-DD
status: complete / paused / incomplete
---

## Work done this session
- ...

## Files written
- canonical/...
- working/...

## Outstanding / unresolved
- ...

## Safe to restart?
YES / NO + reason

## For next session
- Pre-load: [list of files]
- First action: [what to do first]
```

---

## Step 6 — Apple Note

Short, searchable, findable from phone:

```
Title: SESSION CLOSEOUT YYYY-MM-DD — [topic]
Body:
- 2-3 bullet points of what was done
- 1 bullet for outstanding items
- File path to full closeout report
```

---

## Step 7 — Safety Confirmation

Give Adrian a one-line safety status:

- **"Safe to restart. [reason]"** → all work saved, no active critical processes
- **"Wait X minutes. [extraction/etc] still running — will lose N minutes of work"** → active work in progress
- **"Unsafe — [reason]. Let me [action] first"** → something about to complete

---

## Shutdown Anti-Patterns (Don't)

- Don't run long, nested osascript chains during shutdown — simple `ps aux` + `ls` is all you need
- Don't narrate what you're about to check — just check
- Don't produce a long summary of the session in shutdown — that's for the closeout handoff file, not the chat response
- Don't ask Adrian "are you sure you want to restart?" — if he said restart, confirm safety and move on
- Don't kill daemons (overwatch, dashboard) — they're designed to survive restart

---

## Restart Recovery Checklist (for the NEXT session to use)

At session start after a restart:

1. Run `ps aux | grep overwatch; ps aux | grep dashboard` — confirm daemons running
2. Read `working/handoffs/YYYY-MM-DD-session-closeout-*.md` — the last closeout
3. Pre-load the files listed in "For next session"
4. Execute the first action listed
