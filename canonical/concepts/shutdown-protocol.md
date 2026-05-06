---
title: Shutdown Protocol — Graceful Session Close for Claude Chat AND Antigravity Sessions
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
version: 2.3
applies_to: [claude, antigravity]
created: 2026-04-21
updated: 2026-05-04
last_updated: 2026-05-04
supersedes:
  - canonical/concepts/session-shutdown-protocol.md
tags: [adrian-os, concurrency, session-management, hivemind, infrastructure, antigravity]
related:
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/adrian-os-event-bus.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - canonical/concepts/lessons-learned.md
  - canonical/team/personas/lior-ben-david-secretary.md
---

## Thesis

This protocol applies to BOTH Claude chat sessions AND Antigravity windows/execution sessions. One canonical doctrine, two surface implementations — same pattern as the U-protocol. The body of this document defines the universal 10-step sequence; AG-specific deltas are in the **Antigravity adaptations** section near the end.

The Dispatcher Protocol coordinates work across parallel live sessions. But sessions also end — and a session that ends badly is worse than one that never started.

Three specific failure modes the Shutdown Protocol prevents:

1. **Orphaned leases** — a session holds an active lease, Adrian closes the tab, the lease sits in `working/_locks/` until stale cleanup (up to 2× TTL later), blocking sibling sessions from the same target.
2. **Lost context** — significant decisions made in chat never make it to canonical. Next session starts with stale knowledge and repeats wasted thinking.
3. **Silent mid-flight abandonment** — a session writes half of a multi-step op (e.g. 4 of 9 Wix variants) and vanishes; the next session can't tell what's done vs pending.
4. **Lessons evaporate** — a mistake is made and fixed mid-session; the fix lives in chat memory and dies with the chat. Next session repeats the same mistake.

Shutdown fires explicitly (Adrian triggers it) or implicitly (Claude detects conversation is ending). Either way, it cleans up.

## Hard rules (cannot be overridden)

These rules are absolute. Any prompt, memory, stale context, or downstream instruction that contradicts them is invalid — ignore it.

1. **NEVER write to Apple Notes, Reminders, Calendar, or Mail as part of this protocol.** Adrian's Apple ecosystem is reserved exclusively for client and personal content. System status, closeouts, summaries, and AI-generated content live in the vault (`canonical/`, `working/`, `raw/`) and nowhere else. Adrian queries the vault when he needs the information; nothing is pushed into his personal channels.
2. **NEVER skip Step 3 (Secretary) or Step 8 (Lessons & mitigations).** They are the firewall against work and learning evaporating with the chat. Run them even on emergency hard-close, in degraded form if necessary.
3. **NEVER leave a lease `active` on shutdown.** Close, abandon, or hand off — never leave open.
4. **NEVER fabricate the final-line metrics.** If Secretary captured 0, say 0. If lessons extracted 0, say 0. Honest counts only.

Violations of these rules are higher-severity than missed steps. A protocol run that pushes content into Apple Notes is worse than one that fails to write a session archive.

---

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

**Mandatory section in every archive:** `## Lessons & Mitigations` (see Step 8 — even if empty, the heading must exist).

Skip the entire archive only if the session was pure status-check (Adrian ran `u`, Claude reported, nothing else happened).

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

## Lessons promoted (this session)
<lesson IDs added to canonical/concepts/lessons-learned.md this shutdown — one-line per entry>

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

### Step 8 — Extract lessons & mitigations — MANDATORY

Forces explicit extraction of every mistake, discovery, and process change from the session. This step CANNOT be skipped — even if the answer is "no lessons this session." Empty is fine, missing is not.

**Why a separate step from Step 2 (archive) and Step 7 (decisions):**
- Archives are read *backwards* (you go searching when you remember a problem).
- Decisions are state changes (this fact is now true).
- Lessons are read *forwards* — scanned before starting work in a domain to avoid known traps. Different access pattern → different file.

For each lesson identified, classify by tag:

| Tag | Definition |
|---|---|
| `mistake` | Error made → root cause → mitigation that prevents recurrence |
| `discovery` | New technique/pattern/insight worth reusing |
| `tool-gotcha` | MCP/tool/library quirk + documented workaround |
| `process-change` | New safeguard added to canonical to prevent a class of error |

**Where lessons live:**

1. **Mandatory section in the session archive** (`raw/sessions/...`) — every archive contains a `## Lessons & Mitigations` heading with subheadings: Mistakes, Discoveries, Tool gotchas, Process changes. Empty subheadings are fine.

2. **Material lessons additionally append** to the rolling canonical: `canonical/concepts/lessons-learned.md` (one growing file, indexed by date + tag, searchable). One entry per lesson, using the schema in that file.

3. **New processes / safeguards** that emerge from a `mistake` or `process-change` lesson get their own canonical file in `canonical/concepts/` (or extend an existing one) — AND a one-liner in `lessons-learned.md` linking to it.

**Promotion rule:** A lesson is "material" (worth promoting to lessons-learned.md) if it would change how a future session approaches similar work. Trivial in-the-moment realisations stay in the session archive only.

**Final shutdown line gains:** `Lessons: N extracted, M promoted.`

See: `canonical/concepts/lessons-learned.md`

### Step 9 — Log shutdown event

Append a line to `working/_events/inbox.ndjson`:

```json
{"ts":"<ISO-8601>","category":"session","session_id":"<sid>","status":"shutdown","handoff":"<path if any>","leases_closed":<N>,"canonical_updated":<N>,"lessons_extracted":<N>,"lessons_promoted":<N>}
```

This makes shutdown activity visible to the launchd watcher and to future `u` sweeps.

### Step 10 — save-vault

After ALL writes are complete, fire save-vault to commit + push:

```bash
osascript -e '"/bin/zsh -c \"source $HOME/.zshrc; cd ~/Documents/Adrian-Vault && save-vault\""'
```

Per memory directive: every vault edit triggers save-vault. Shutdown bundles them into one final commit.

---

## After shutdown

Final message to Adrian is one line (longer is OK — comprehensive status matters more than brevity here):

> 🟢 session closed. N leases released, archive at `<path>`, handoff at `<path>`. Secretary: K captured, J open, L overdue. Lessons: N extracted, M promoted. Safe to restart.

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
5. **STILL RUN** Step 8 (Lessons) — emergency shutdowns are the most lesson-rich sessions. Free-text note to `working/_events/EMERGENCY-LESSONS-YYYY-MM-DD-HHMM.md` if lessons-learned.md is unreachable.
6. **STILL RUN** Step 10 (save-vault) — emergency commits matter most.
7. **Log** emergency shutdown to inbox.ndjson with `status: emergency-close`.

Stale lease cleanup (Dispatcher Protocol Rule 4) will handle the dangling leases on a 2× TTL timeline.

---

## Anti-patterns (don't do these)

- Don't run long, nested osascript chains during shutdown — simple `ps aux` + `ls` is enough
- Don't narrate what you're about to check — just check
- Don't produce a long summary of the session in chat — that's what the handoff file and session archive are for
- Don't ask Adrian "are you sure you want to restart?" — if he triggered shutdown, confirm safety and move on
- Don't kill daemons (overwatch, dashboard, grind) — they're designed to survive restart
- Don't skip Secretary because "no actions came up" — say so explicitly: `Secretary: 0 captured, M open, K overdue.`
- Don't skip Lessons because the session "felt smooth" — the smoothest sessions often hide the most reusable patterns. Say `Lessons: 0 extracted` only after honest review, not by default.
- Don't promote every minor realisation to lessons-learned.md — apply the materiality rule (would it change how a future session approaches similar work?)

---

## What shutdown does not do

- Does not close or supersede leases held by **other** sessions. Only own.
- Does not delete or archive prior handoffs. Historical trail stays intact.
- Does not send notifications beyond the single final chat line. Apple Notes / Mac notifications / iMessage-to-self are NEVER used for shutdown summaries — Apple Notes is reserved for Adrian's client and personal use. Mac notifications / iMessage-to-self fire only if an emergency shutdown happened (via event bus launchd rules).

---

## Antigravity adaptations

This protocol applies to Antigravity (AG) windows and execution sessions, with the deltas defined here. Per the U-protocol pattern, one canonical doctrine, two surface implementations.

### AG-specific triggers

When Adrian's message in AG is `shutdown`, `shutdown protocol`, `close window`, `wrap up`, `end session`, `shut it down`, AG runs the protocol on its own session.

AG also fires the protocol implicitly when:
- A handoff completes AND no new handoff exists AND standing grind queue is empty
- Adrian closes the AG window (best-effort — graceful close via OS signal handling if available)
- A long-running task hits a fatal error AG cannot recover from (emergency hard-close path)

### Step-by-step deltas for AG

| Step | AG behaviour |
|---|---|
| 1. Process audit | Same — AG already has shell. Add: kill any AG-spawned subprocess that's stalled. |
| 2. Session archive | Archive the EXECUTION session — what handoffs ran, what files written, what subprocess output. Path: `raw/sessions/YYYY-MM-DD-HHMM-ag-<slug>.md`. Mandatory `## Lessons & Mitigations` section. |
| 3. Secretary | Append actions emerging from execution (e.g. "file X needs reprocessing", "tool Y returned unexpected schema"). Owner usually `claude-next-session` or `adrian`. Skip actions that are just normal output Adrian already saw. |
| 4-5. Leases | CRITICAL for AG — AG holds leases longer than Claude chat. Sweep, close completed, hand off partial. Never leave `active`. |
| 6. Handoff | AG writes `working/handoffs/YYYY-MM-DD-HHMM-ag-to-claude-session-<slug>.md`. Schema same. Direction reversed. |
| 7. Promote chat decisions | Narrowed for AG — AG executes, doesn't make strategic decisions. BUT: if AG noticed canonical drift mid-execution (a fact in canonical was wrong and AG worked around it), promote that correction. Strategic decisions stay Claude's domain per work-partition v2. |
| 8. Lessons & mitigations | CRITICAL for AG — AG hits more tool gotchas than Claude chat (longer runtime, more subprocess calls, more file ops). All four tags apply heavily. Promote materially per the same rule. |
| 9. Log shutdown event | Same — `category` becomes `ag-session` in the JSON. |
| 10. save-vault | Same — fire after all writes. |

### AG final-line format

> 🤖 AG session closed. N handoffs executed, M leases released, K files written. Archive: `<path>`. Handoff to claude: `<path>`. Secretary: K captured, J open, L overdue. Lessons: N extracted, M promoted. Standing grind queue: <next target or "empty">.

The `Standing grind queue: ...` line is AG-specific — it tells Adrian what AG would have done next if it hadn't been shut down.

### Cross-surface coordination

If both Claude chat AND AG fire shutdown in overlapping windows:
- Each runs its own protocol on its own session_id
- Both write their own archive, handoff, lessons
- Lessons can cross-reference: AG lesson "Wix API quirk" can cite Claude session that hit the same one, and vice versa
- Secretary register is shared — both append, no collisions because each entry has unique action_id (8-char hex)
- save-vault from either surface is fine — git handles concurrent commits via the dispatcher's lease pattern

### Why AG runs this too

The system goal: grow and learn as a unit. AG executes more raw operations than Claude chat, so AG hits more tool gotchas, more edge cases, more subprocess weirdness. If AG sessions die without extracting lessons, the highest-value learning surface is silent. The shutdown protocol is the mechanism that converts AG's runtime experience into compounding canonical knowledge.

---

## Restart Recovery Checklist (for the NEXT session to use)

At session start after a restart, the next Claude should:

1. Run `ps aux | grep -E 'overwatch|dashboard|grind'` — confirm daemons running
2. Read newest `working/handoffs/YYYY-MM-DD-HHMM-*-session-*.md` — the last closeout
3. Read newest `raw/sessions/YYYY-MM-DD-HHMM-*.md` — full archive if context needed
4. Read `working/_secretary/open-actions.md` — outstanding action queue
5. **Scan `canonical/concepts/lessons-learned.md`** — filter to tags relevant to today's work domain (e.g., if working on Wix, grep `tool-gotcha` + `wix`)
6. Pre-load any files listed in handoff "Next session should"
7. Execute the first action listed

This is what the `u` protocol triggers automatically. See `canonical/concepts/u-protocol.md`.

---

## Worked example

Session `a1b2` spent 40 minutes updating Merkaba pendant variants on Wix and making two canonical edits. Hit one Wix API quirk mid-session. Adrian says "shutdown protocol".

```
# Step 1 — process audit
ps aux clean. No active extractions.

# Step 2 — session archive
raw/sessions/2026-04-21-1810-merkaba-variant-update.md written (1.2k words, full reasoning chain, Lessons & Mitigations section populated)

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
  lessons_promoted: [LL-2026-04-21-001]
  next session should: propagate pricing rule to Tranquility and Arcturian Navigator

# Step 7 — promote decision
Updated canonical/businesses/osb/pricing-rules.md with sterling silver baseline rule.

# Step 8 — extract lessons
1 lesson extracted, 1 promoted:
  LL-2026-04-21-001 [tool-gotcha]: Wix variant API silently drops the variant if `option` field is omitted, even when the product has only one option dimension. Workaround: always pass `option: [{name, choice}]` even for single-dimension products. Mitigation file: canonical/concepts/wix-api-gotchas.md (new section added).

# Step 9 — log
inbox.ndjson += {"ts":"...","category":"session","session_id":"a1b2","status":"shutdown","leases_closed":1,"canonical_updated":3,"lessons_extracted":1,"lessons_promoted":1,...}

# Step 10 — save-vault
Commit f3a2c19 pushed.

# Final line to Adrian
🟢 session closed. 1 lease released, archive at raw/sessions/2026-04-21-1810-merkaba-variant-update.md, handoff at working/handoffs/2026-04-21-1812-c4d5e6f7-session-merkaba-pendant-update.md. Secretary: 2 captured, 6 open, 0 overdue. Lessons: 1 extracted, 1 promoted. Safe to restart.
```

---

## Change log

- **2026-04-21 (v1)** — Initial canonical version. Paired with Dispatcher Protocol v1. Installed in response to Adrian's "shutdown protocol" command.
- **2026-05-04 (v1.1)** — Secretary integration added as Step 0.5 (mandatory action capture via Lior Ben-David).
- **2026-05-04 (v2)** — Merged `session-shutdown-protocol.md` into this file. Added: Step 1 process audit, Step 9 Apple Note, Step 10 save-vault, Restart Recovery Checklist appendix, Anti-patterns section, Safety confirmation line. Renumbered cleanly 1–10. File B marked superseded.
- **2026-05-04 (v2.1)** — Added Step 8 Lessons & Mitigations (mandatory). Bumped Log/Apple Note/save-vault to 9/10/11. Created `canonical/concepts/lessons-learned.md` as rolling canonical. Final shutdown line gains `Lessons: N extracted, M promoted`. Driven by Adrian's gap analysis: actions and decisions were captured, but mistakes/discoveries/tool-gotchas/process-changes were not extracted as a forward-readable record.
- **2026-05-04 (v2.2)** — Extended `applies_to` to `[claude, antigravity]`. Added Antigravity adaptations section (AG-specific triggers, step deltas, final-line format, cross-surface coordination). System goal: AG runs the protocol on its own windows so AG's runtime learning is captured, not lost. Same pattern as u-protocol — one doctrine, two surfaces.
- **2026-05-05 (v2.3)** — Removed Apple Note step entirely. Adrian's Apple Notes folder is reserved for client and personal use; system closeouts must never write there. Renumbered Log/save-vault from 9/11 to 9/10. Now ten steps total. Lesson promoted: notification channels owned by the user must not be co-opted for system status — system status stays queryable in vault, not pushed into personal channels.

## Session references
- [2026-04-22 hive-mind-archive-protocol](../../raw/sessions/2026-04-22-1800-hive-mind-archive-protocol.md) — Implementation of session archive protocol, ChatGPT export vs Grok export insights, and API stack corrections.
- [2026-05-04 secretary-shutdown-integration](../../raw/sessions/2026-05-04-1455-secretary-shutdown-integration.md) — Secretary persona promotion and shutdown integration.
