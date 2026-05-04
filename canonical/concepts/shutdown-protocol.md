---
title: Shutdown Protocol — Graceful Session Close for Claude Chat Sessions
type: canon
status: canonical
version: 2.0
created: 2026-04-21
last_updated: 2026-05-04
tags: [adrian-os, concurrency, session-management, hivemind, infrastructure]
related:
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/adrian-os-event-bus.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - canonical/concepts/session-archive-protocol.md
  - canonical/team/personas/lior-ben-david-secretary.md
supersedes:
  - canonical/concepts/session-shutdown-protocol.md (v1, 2026-04-24)
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

## The ten-step shutdown sequence

### Step 0 — Process audit (30 seconds)

Before anything else, audit running processes on Adrian's Mac:

```bash
ps aux | grep -E 'python|extract|transcribe|grind' | grep -v grep | awk '{print $2, $3, $10, $11}'
```

Classify each:

| Classification | Action |
|----------------|--------|
| **Healthy daemon** (overwatch, dashboard, grind-assimilation) | LEAVE RUNNING — they survive restart |
| **Active extraction/script** with real CPU | Let finish OR pause-and-resume |
| **Stalled process** (<1s CPU over 5+ min) | KILL — blocked, no purpose |
| **System processes** (Dropbox, etc.) | LEAVE RUNNING |

This drives the safety status in Step 9 (final line). If active critical work is in flight, Adrian needs to know whether closing now loses anything.

### Step 1 — Write session archive (MANDATORY)

Write a full session archive to `raw/sessions/YYYY-MM-DD-HHMM-<slug>.md`.

This is NOT the handoff note. It is the full knowledge capture — reasoning chains, failed attempts, fixes, challenges, breakthroughs, decisions with their full context. See full schema: `canonical/concepts/session-archive-protocol.md`.

Skip only if the session was pure status-check (Adrian ran `u`, Claude reported, nothing else happened).

The archive is written FIRST so that even if subsequent steps fail or the session dies, the knowledge is captured.

### Step 2 — Invoke Secretary (Lior Ben-David) — MANDATORY

Lior captures all action points from this session before any cleanup. This step CANNOT be skipped — even on emergency shutdown.

For each action point identified in the session:

1. Append one line to `working/_secretary/action-register.ndjson` with event `open` (or `update`/`complete` if the session resolved a prior action).
2. Set owner to: persona name, `adrian`, `antigravity`, or `claude-next-session`.
3. Set due date if explicit; otherwise null.
4. Set context to current session id + handoff path.

Then regenerate `working/_secretary/open-actions.md` from the full register, sorted: overdue first, then by due date, then by age.

The Secretary is the firewall against "chat forgotten = work forgotten." If Lior step is skipped, action points die with the chat. No exceptions.

Final shutdown line MUST include Secretary status: `Secretary: N captured, M open, K overdue.`

See: `canonical/team/personas/lior-ben-david-secretary.md`

### Step 3 — Sweep own leases

List `working/_locks/` filtered to `session_id == <this session's id>`. Any found are this session's responsibility.

### Step 4 — Close or hand off each lease

For each own lease:

- **If op is complete** → update `status: completed`, add `completed_at` + `result: ok`, move to `_completed/`.
- **If op is partially complete** → update `status: abandoned`, add `result: partial`, write `output_ref` pointing to what got done, and write a **continuation note** (see Step 5 handoff).
- **If op never started** (claimed lease, then scope changed) → update `status: abandoned`, `result: unused`, move to `_completed/`.

Never leave a lease `active` on shutdown. Ever.

### Step 5 — Write session handoff

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

If nothing material happened, skip Step 5. Routine Q&A sessions with no writes don't need handoffs.

### Step 6 — Promote chat-level decisions to canonical

Per existing doctrine (`adrian-os-event-bus.md`): chat wins over stale canonical. On shutdown, any decision made mid-chat that contradicts or extends canonical gets promoted.

Process:
- Identify decisions made this session that touch canonical subjects (businesses, people, projects, concepts, frameworks, ecosystem).
- For each, either: update the relevant canonical file directly, or write a `canonical/_pending/` stub if the decision needs Adrian's review before full promotion.
- Governance dial from event bus is "balanced" — routine updates auto-promote, irreversible or ambiguous ones go to `_pending/`.

### Step 7 — Log shutdown event

Append a line to `working/_events/inbox.ndjson`:

```json
{"ts":"<ISO-8601>","category":"session","session_id":"<sid>","status":"shutdown","handoff":"<path if any>","leases_closed":<N>,"canonical_updated":<N>}
```

This makes shutdown activity visible to the launchd watcher and to future `u` sweeps.

### Step 8 — Apple Note (phone-findable summary)

Write a short Apple Note so Adrian can find this session from his phone without opening the vault:

```
Title: SESSION CLOSEOUT YYYY-MM-DD — <topic>
Body:
- 2-3 bullets of what was done
- 1 bullet for outstanding items
- File path to full handoff
- Secretary: N open, K overdue
```

Use `Read and Write Apple Notes:add_note`. Folder: default ("Notes").

Skip this step only on emergency-close.

### Step 9 — save-vault (git commit + push)

Commit all session writes and push to remote:

```bash
osascript -e 'do shell script "/bin/zsh -c \"source $HOME/.zshrc; cd ~/Documents/Adrian-Vault && save-vault\""'
```

This is the last write action. After save-vault returns, no further vault edits this session.

### Step 10 — Final line to Adrian

One line, this exact shape:

```
🟢 session closed. N leases released, archive at <path>, handoff at <path>. Safety: <safe-to-restart | wait X min for Y | unsafe>. Secretary: K captured, J open, L overdue.
```

After the final message, Claude does not initiate further action in that session unless Adrian explicitly re-engages.

---

## Anti-patterns (don't)

- **Don't run long, nested osascript chains during shutdown** — `ps aux` + `ls` is all the audit needs.
- **Don't narrate what you're about to check** — just check.
- **Don't produce a long summary of the session in the shutdown chat response** — that's what the archive and handoff are for. Final line is one line.
- **Don't ask Adrian "are you sure you want to restart?"** — if he triggered shutdown, confirm safety and move on.
- **Don't kill daemons** (overwatch, dashboard, grind-assimilation) — they're designed to survive restart.
- **Don't skip Secretary** even if it "feels like nothing happened." If you spent 5+ min talking, there's at least one capturable action.
- **Don't write the handoff before the archive.** Archive first = knowledge survives even if handoff write fails.

---

## Emergency / hard-close path

If the session is being closed because something is broken (MCP stack unresponsive, tool errors preventing clean-up, Adrian explicitly saying "just get out"), execute a degraded shutdown:

1. **Skip** lease-by-lease cleanup. Just write one emergency note to `working/_events/` naming the session and what was in flight.
2. **Skip** canonical promotion. Note in the emergency file: "canonical promotion pending — next session, review this session's chat log."
3. **Skip** handoff schema. Free-text note is fine.
4. **Skip** Apple Note.
5. **STILL DO** Secretary capture if at all possible — the action register is the most critical artefact.
6. **Log** emergency shutdown to inbox.ndjson with `status: emergency-close`.
7. **Try** save-vault; if it fails, tell Adrian explicitly so he can run it manually.

Stale lease cleanup (Dispatcher Protocol Rule 4) will handle the dangling leases on a 2× TTL timeline.

---

## What shutdown does not do

- Does not close or supersede leases held by **other** sessions. Only own.
- Does not delete or archive prior handoffs. Historical trail stays intact.
- Does not send notifications beyond the single final chat line + Apple Note. Mac notifications / iMessage-to-self fire only if an emergency shutdown happened (via event bus launchd rules).
- Does not extract "lessons learned" as a separate file by default. If meaningful technical/procedural lessons emerged, write them to `canonical/concepts/session-lessons-YYYY-MM-DD.md` as part of Step 6 (canonical promotion).

---

## Worked example

Session `a1b2` spent 40 minutes updating Merkaba pendant variants on Wix and making two canonical edits. Adrian says "shutdown".

```
# Step 0 — process audit
ps aux | grep python → grind-assimilation running (healthy daemon, leave). No stalled procs.

# Step 1 — session archive
raw/sessions/2026-04-21-1810-merkaba-variant-update.md (full chain, decisions, fixes)

# Step 2 — Secretary
2 actions captured: "propagate sterling silver baseline to Tranquility (owner: claude-next-session, due: 2026-04-22)" + "review Wix variant pricing display (owner: adrian, due: null)"
Open-actions.md regenerated. 4 total open, 0 overdue.

# Step 3 — sweep own leases
Found 1 active lease: 7f3a2c19-wix-merkaba-pendant-update (session a1b2)

# Step 4 — close it
Op complete. Lease → _completed/. Result: ok.

# Step 5 — write handoff
working/handoffs/2026-04-21-1812-c4d5e6f7-session-merkaba-pendant-update.md
  summary: Updated 9 Merkaba variants, chain pricing applied, descriptions rewritten
  canonical_changes:
    - canonical/businesses/osb/products/merkaba-pendant.md (updated variants, pricing)
  in-flight: none
  decisions: sterling silver baseline confirmed at $988 Large; propagate to other pendants
  next session should: propagate pricing rule to Tranquility and Arcturian Navigator

# Step 6 — promote decision
Updated canonical/businesses/osb/pricing-rules.md with sterling silver baseline rule.

# Step 7 — log
inbox.ndjson += {"ts":"...","category":"session","session_id":"a1b2","status":"shutdown","handoff":"...","leases_closed":1,"canonical_updated":2}

# Step 8 — Apple Note
"SESSION CLOSEOUT 2026-04-21 — Merkaba variants" → Notes folder

# Step 9 — save-vault
git commit -m "session a1b2: merkaba variant update" + push → ok

# Step 10 — final line
🟢 session closed. 1 lease released, archive at raw/sessions/2026-04-21-1810-merkaba-variant-update.md, handoff at working/handoffs/2026-04-21-1812-c4d5e6f7-session-merkaba-pendant-update.md. Safety: safe-to-restart. Secretary: 2 captured, 4 open, 0 overdue.
```

---

## Restart recovery checklist (forward-pointer)

This belongs in the session-startup protocol but is duplicated here so a future Claude reading this file knows what happens AFTER shutdown:

1. Run `ps aux | grep overwatch; ps aux | grep dashboard; ps aux | grep grind` — confirm daemons running
2. Read newest `working/handoffs/*-session-*.md` — the last closeout
3. Pre-load files listed in handoff's "Next session should"
4. Check Secretary: `working/_secretary/open-actions.md` — overdue items first
5. If U-protocol triggered, report CEO-style only

---

## Change log

- **2026-04-21** — v1.0. Initial canonical version. Paired with Dispatcher Protocol v1. Installed in response to Adrian's "shutdown protocol" command.
- **2026-05-04** — v1.1. Step 0.5 Secretary integration added.
- **2026-05-04** — v2.0. Merged with `session-shutdown-protocol.md` (File B, 2026-04-24). Added Step 0 process audit, Step 8 Apple Note, Step 9 explicit save-vault, anti-patterns section, restart recovery forward-pointer. File B marked superseded. Renumbered all steps to flat 0–10 (no half-steps).

## Session references
- [2026-04-22 hive-mind-archive-protocol](../../raw/sessions/2026-04-22-1800-hive-mind-archive-protocol.md) — Implementation of session archive protocol, ChatGPT export vs Grok export insights, and API stack corrections.
- [2026-05-04 secretary-shutdown-integration](../../raw/sessions/2026-05-04-1455-secretary-shutdown-integration.md) — Secretary persona promotion and shutdown wiring.
