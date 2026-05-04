---
title: Shutdown Protocol — Graceful Session Close for Claude Chat Sessions
type: canon
status: canonical
version: 2
created: 2026-04-21
updated: 2026-05-04
supersedes:
  - canonical/concepts/session-shutdown-protocol.md
tags: [adrian-os, concurrency, session-management, hivemind, infrastructure]
related:
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/adrian-os-event-bus.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - canonical/team/personas/lior-ben-david-secretary.md
---

## Thesis

The Dispatcher Protocol coordinates work across parallel live sessions. But sessions also end — and a session that ends badly is worse than one that never started.

Three specific failure modes the Shutdown Protocol prevents:

1. **Orphaned leases** — a session holds an active lease, Adrian closes the tab, the lease sits in `working/_locks/` until stale cleanup (up to 2× TTL later), blocking sibling sessions from the same target.
2. **Lost context** — significant decisions made in chat never make it to canonical. Next session starts with stale knowledge and repeats wasted thinking.
3. **Silent mid-flight abandonment** — a session writes half of a multi-step op (e.g. 4 of 9 Wix variants) and vanishes; the next session can't tell what's done vs pending.

Shutdown fires explicitly (Adrian triggers it) or implicitly (Claude detects conversation is ending). Either way, it cleans up.

## When it fires

### Explicit triggers

Adrian's message is `shutdown`, `shutdown protocol`, `end session`, `close out`, `done for now`, `bye`, `goodbye`, or similar conversation-ending phrases. See shorthand protocols doc for canonical trigger list.

### Implicit triggers

Claude infers session close when:
- Adrian says "that's all", "we're done", "I'm off", "catch you later", "speak tomorrow", etc.
- No new task is being initiated and the exchange has a clear terminal shape
- Adrian explicitly sends a thank-you that reads as sign-off

Claude **does not fire** on ambiguous signals (e.g. short "ok" or "thanks" mid-work). When uncertain, run `q` first to check what's in flight, then ask if unclear.

### What Claude cannot detect

Tab close, browser crash, network loss, device shutdown. These leave leases dangling. Covered by Dispatcher Protocol's stale lease cleanup (2× TTL rule).

---

## The ten-step shutdown

### Step 1 — Process audit (30 seconds)

Pre-flight check before any cleanup. Confirms nothing important is mid-run that shutdown would clobber.

```bash
ps aux | grep -E 'python|extract|transcribe|grind|whisper' | grep -v grep | awk '{print $2, $3, $10, $11}'
```

Classify each running process:

| Classification | Action |
|----------------|--------|
| **Healthy daemon** (overwatch, dashboard, grind-assimilation idle) | LEAVE RUNNING — they survive restart |
| **Active extraction/script** with real CPU | Let finish OR pause-and-resume pattern |
| **Stalled process** (<1s CPU over 5+ min) | KILL — it's blocked, serves no purpose |
| **System processes** (Dropbox, etc.) | LEAVE RUNNING |

If active extraction would lose >5 min of work on shutdown, surface to Adrian: "Wait X minutes — [process] still running."

### Step 2 — Write session archive

Write a full session archive to `raw/sessions/YYYY-MM-DD-HHMM-<slug>.md`.

This is NOT the handoff note. It is the full knowledge capture — reasoning chains, failed attempts, fixes, challenges, breakthroughs, decisions with their full context. See full schema: `canonical/concepts/session-archive-protocol.md`.

Skip only if the session was pure status-check (Adrian ran `u`, Claude reported, nothing else happened).

The archive is written EARLY so that even if subsequent steps fail or the session dies, the knowledge is captured.

### Step 3 — Invoke Secretary (Lior Ben-David) — MANDATORY

Lior captures all action points from this session before any cleanup. This step CANNOT be skipped — even on emergency shutdown.

For each action point identified in the session:

1. Append one line to `working/_secretary/action-register.ndjson` with event `open` (or `update`/`complete` if the session resolved a prior action).
2. Set owner to: persona name, `adrian`, `antigravity`, or `claude-next-session`.
3. Set due date if explicit; otherwise null.
4. Set context to current session id + handoff path.

Then regenerate `working/_secretary/open-actions.md` from the full register, sorted: overdue first, then by due date, then by age.

The Secretary is the firewall against "chat forgotten = work forgotten." If Lior step is skipped, action points die with the chat. No exceptions.

Final shutdown line MUST include Secretary status: `Secretary captured N actions, M open total, K overdue.`

See: `canonical/team/personas/lior-ben-david-secretary.md`

### Step 4 — Sweep own leases

List `working/_locks/` filtered to `session_id == <this session's id>`. Any found are this session's responsibility.

### Step 5 — Close or hand off each lease

For each own lease:

- **If op is complete** → update `status: completed`, add `completed_at` + `result: ok`, move to `_completed/`.
- **If op is partially complete** → update `status: abandoned`, add `result: partial`, write `output_ref` pointing to what got done, and write a **continuation note** (see Step 6).
- **If op never started** (claimed lease, then scope changed) → update `status: abandoned`, `result: unused`, move to `_completed/`.

Never leave a lease `active` on shutdown. Ever.

### Step 6 — Write session handoff

If anything material happened this session — canonical written/updated, in-flight work paused, decisions made that future sessions need to know — write a handoff file:

**Path:** `working/handoffs/YYYY-MM-DD-HHMM-SHORTID-session-<slug>.md`

**Schema:**

```yaml
---
uuid: <full-uuid>
short_id: <first-8-chars>
session_id: <4-char hex>
created_at: <ISO-8601 session start>
closed_at: <ISO-8601 now>
status: completed               # completed | partial | emergency-close
tags: [session-handoff, <domain tags>]
---

## What this session did
<bulleted summary, 3-8 lines>

## Canonical changes
<paths to any canonical/ files written or updated this session, one-line per change>

## In-flight work (if any)
<list any lease marked abandoned/partial with pointer to continuation>

## Decisions made (promote to canonical)
<any decisions Adrian and Claude made that are not yet in canonical — next session should read + promote>

## Open threads
<anything Adrian flagged as "think about this" or "pick up later" without concrete next step>

## Next session should
<explicit next actions in priority order>
```

If nothing material happened, skip Step 6. Routine Q&A sessions with no writes don't need handoffs.

### Step 7 — Promote chat-level decisions to canonical

Per existing doctrine (`adrian-os-event-bus.md`): chat wins over stale canonical. On shutdown, any decision made mid-chat that contradicts or extends canonical gets promoted.

Process:
- Identify decisions made this session that touch canonical subjects (businesses, people, projects, concepts, frameworks, ecosystem).
- For each, either: update the relevant canonical file directly, or write a `canonical/_pending/` stub if the decision needs Adrian's review before full promotion.
- Governance dial from event bus is "balanced" — routine updates auto-promote, irreversible or ambiguous ones go to `_pending/`.

### Step 8 — Log shutdown event

Append a line to `working/_events/inbox.ndjson`:

```json
{"ts":"<ISO-8601>","category":"session","session_id":"<sid>","status":"shutdown","handoff":"<path if any>","leases_closed":<N>,"canonical_updated":<N>}
```

This makes shutdown activity visible to the launchd watcher and to future `u` sweeps.

### Step 9 — Apple Note (phone-findable summary)

Short, searchable summary so Adrian can find this session from his phone without opening the laptop.

```
Title: SESSION CLOSEOUT YYYY-MM-DD — [topic]
Body:
- 2-3 bullet points of what was done
- 1 bullet for outstanding items
- File path to full closeout report (handoff path)
- Secretary line: N captured, M open, K overdue
```

Use `Read and Write Apple Notes:add_note` tool. Folder default: `Notes`.

### Step 10 — save-vault

After ALL writes are complete, fire save-vault to commit + push:

```bash
osascript -e '"/bin/zsh -c \"source $HOME/.zshrc; cd ~/Documents/Adrian-Vault && save-vault\""'
```

Per memory directive: every vault edit triggers save-vault. Shutdown bundles them into one final commit.

---

## After shutdown

Final message to Adrian is one line:

> 🟢 session closed. N leases released, archive at `<path>`, handoff at `<path>`. Secretary: K captured, J open, L overdue. Safe to restart.

After the final message, Claude does not initiate further action in that session unless Adrian explicitly re-engages.

## Safety confirmation

Append one of these to the final line:

- **"Safe to restart."** → all work saved, no active critical processes
- **"Wait X minutes — [process] still running, will lose N minutes."** → active work in progress
- **"Unsafe — [reason]. Let me [action] first."** → something about to complete that shouldn't be killed

---

## Emergency / hard-close path

If the session is being closed because something is broken (MCP stack unresponsive, tool errors preventing clean-up, Adrian explicitly saying "just get out"), execute a degraded shutdown:

1. **Skip** Steps 1, 4, 5 (process audit, lease sweep, lease close). Just write one emergency note to `working/_events/` naming the session and what was in flight.
2. **Skip** Step 7 (canonical promotion). Note in the emergency file: "canonical promotion pending — next session, review this session's chat log."
3. **Skip** Step 6 schema. Free-text note is fine.
4. **STILL RUN** Step 3 (Secretary) — actions must survive. If even Secretary is broken, write actions to a free-text file at `working/_secretary/EMERGENCY-YYYY-MM-DD-HHMM.md` for next session to ingest.
5. **STILL RUN** Step 10 (save-vault) — emergency commits matter most.
6. **Log** emergency shutdown to inbox.ndjson with `status: emergency-close`.

Stale lease cleanup (Dispatcher Protocol Rule 4) will handle the dangling leases on a 2× TTL timeline.

---

## Anti-patterns (don't do these)

- Don't run long, nested osascript chains during shutdown — simple `ps aux` + `ls` is enough
- Don't narrate what you're about to check — just check
- Don't produce a long summary of the session in chat — that's what the handoff file and session archive are for
- Don't ask Adrian "are you sure you want to restart?" — if he triggered shutdown, confirm safety and move on
- Don't kill daemons (overwatch, dashboard, grind) — they're designed to survive restart
- Don't skip Secretary because "no actions came up" — say so explicitly: `Secretary: 0 captured, M open, K overdue.`

---

## What shutdown does not do

- Does not close or supersede leases held by **other** sessions. Only own.
- Does not delete or archive prior handoffs. Historical trail stays intact.
- Does not send notifications beyond the single final chat line + Apple Note. Mac notifications / iMessage-to-self fire only if an emergency shutdown happened (via event bus launchd rules).

---

## Restart Recovery Checklist (for the NEXT session to use)

At session start after a restart, the next Claude should:

1. Run `ps aux | grep -E 'overwatch|dashboard|grind'` — confirm daemons running
2. Read newest `working/handoffs/YYYY-MM-DD-HHMM-*-session-*.md` — the last closeout
3. Read newest `raw/sessions/YYYY-MM-DD-HHMM-*.md` — full archive if context needed
4. Read `working/_secretary/open-actions.md` — outstanding action queue
5. Pre-load any files listed in handoff "Next session should"
6. Execute the first action listed

This is what the `u` protocol triggers automatically. See `canonical/concepts/u-protocol.md`.

---

## Worked example

Session `a1b2` spent 40 minutes updating Merkaba pendant variants on Wix and making two canonical edits. Adrian says "shutdown protocol".

```
# Step 1 — process audit
ps aux clean. No active extractions.

# Step 2 — session archive
raw/sessions/2026-04-21-1810-merkaba-variant-update.md written (1.2k words, full reasoning chain)

# Step 3 — Secretary
2 actions captured: "Propagate sterling silver baseline to Tranquility" (owner: claude-next-session, due: tomorrow), "Update Arcturian Navigator pricing" (owner: adrian, due: null)
Register: 6 open total, 0 overdue.

# Step 4 — sweep own leases
Found 1 active lease: 7f3a2c19-wix-merkaba-pendant-update (session a1b2)

# Step 5 — close it
Op complete. Lease → _completed/. Result: ok.

# Step 6 — write handoff
working/handoffs/2026-04-21-1812-c4d5e6f7-session-merkaba-pendant-update.md
  summary: Updated 9 Merkaba variants, chain pricing applied, descriptions rewritten
  canonical_changes:
    - canonical/businesses/osb/products/merkaba-pendant.md
  decisions: sterling silver baseline confirmed at $988 Large
  next session should: propagate pricing rule to Tranquility and Arcturian Navigator

# Step 7 — promote decision
Updated canonical/businesses/osb/pricing-rules.md with sterling silver baseline rule.

# Step 8 — log
inbox.ndjson += {"ts":"...","category":"session","session_id":"a1b2","status":"shutdown",...}

# Step 9 — Apple Note
"SESSION CLOSEOUT 2026-04-21 — Merkaba pendant variants" added to Notes folder.

# Step 10 — save-vault
Commit f3a2c19 pushed.

# Final line to Adrian
🟢 session closed. 1 lease released, archive at raw/sessions/2026-04-21-1810-merkaba-variant-update.md, handoff at working/handoffs/2026-04-21-1812-c4d5e6f7-session-merkaba-pendant-update.md. Secretary: 2 captured, 6 open, 0 overdue. Safe to restart.
```

---

## Change log

- **2026-04-21 (v1)** — Initial canonical version. Paired with Dispatcher Protocol v1. Installed in response to Adrian's "shutdown protocol" command.
- **2026-05-04 (v1.1)** — Secretary integration added as Step 0.5 (mandatory action capture via Lior Ben-David).
- **2026-05-04 (v2)** — Merged `session-shutdown-protocol.md` into this file. Added: Step 1 process audit, Step 9 Apple Note, Step 10 save-vault, Restart Recovery Checklist appendix, Anti-patterns section, Safety confirmation line. Renumbered cleanly 1–10. File B marked superseded.

## Session references
- [2026-04-22 hive-mind-archive-protocol](../../raw/sessions/2026-04-22-1800-hive-mind-archive-protocol.md) — Implementation of session archive protocol, ChatGPT export vs Grok export insights, and API stack corrections.
- [2026-05-04 secretary-shutdown-integration](../../raw/sessions/2026-05-04-1455-secretary-shutdown-integration.md) — Secretary persona promotion and shutdown integration.
