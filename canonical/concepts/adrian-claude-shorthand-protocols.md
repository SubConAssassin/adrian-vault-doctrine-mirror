---
title: Adrian-Claude Shorthand Protocols
type: canon
status: canonical
created: 2026-04-20
updated: 2026-04-21
authored_by: claude
purpose: Token-efficient commands where Adrian's short input triggers a defined Claude action
tags: [protocols, shortcuts, communication, efficiency]
---

## Why this file exists

Adrian is time-poor and dyslexic, uses voice-to-text frequently. Typing full instructions costs more than it should. These shorthand commands let him trigger defined Claude behaviours with minimal input. The commands are universal across sessions — any Claude session reading this file must honour them.

Voice-to-text introduces phonetic ambiguity (e.g. "u" spoken becomes "you" written). All shorthand commands are defined for both spellings.

---

## Command: `u` / `U` / `you` / `You` / `update`

**Trigger:** Adrian's message is any of these, alone or with only light punctuation/emoji (e.g. `u`, `u?`, `U.`, `you`, `update`, `u!`).

**Action:** Execute the full **Update Sweep Protocol** below and return a consolidated status.

### Update Sweep Protocol (what Claude does when triggered)

> **MANDATORY CHANNELS — no `u` response is complete until all four have been swept:**
> 1. Local vault (handoffs, events, extraction dirs, canonical)
> 2. **Google Drive** (ChatGPT + any external bridge doc)
> 3. Active extraction output directories for the current commission
> 4. Pending-Adrian items
>
> **If any channel is not swept, the sweep is incomplete and must be re-run.** Do not report status until all four are covered. If a tool is not loaded, run `tool_search` to load it — absence of the tool is not an excuse to skip the channel.

Claude performs ALL of these in sequence:

1. **Check handoffs directory** — `working/handoffs/` — for any new files from subordinate agents (Antigravity, ChatGPT, Gemini, etc.) since last sweep. Compare against files Claude has already seen in this session.

2. **🔴 MANDATORY — Check Google Drive for ChatGPT outputs** — ChatGPT's primary delivery channel is Google Drive, not the vault. This step is **not optional** and failure to execute it invalidates the whole sweep. Sweep Drive via `Google Drive:list_recent_files` (order by `recency`, pageSize ≥ 15) for new files / recently modified files from ChatGPT's output area (e.g. WtE dumps, creative copy drops, marketing visuals, bridge-test documents). Compare modification timestamps against last sweep. Pull any new items into context or flag them to Adrian. If the Drive MCP tools aren't loaded, run `tool_search` for `drive` to load them before sweeping. **Empty files still get reported** — an empty ChatGPT document is itself a signal (ChatGPT created but didn't write) and Adrian needs to know.

3. **Check events directory** — `working/_events/` — for progress markers (`antigravity-progress-*`, `antigravity-urgent-*`, `antigravity-phase*-complete*`, and anything matching `antigravity-*` or `chatgpt-*` or `gemini-*`).

4. **Check active extraction output directories** — for the Tristan-Stefi case currently:
   - `working/deep-extraction/transcripts/{tristan,stefi}-archive/`
   - `working/deep-extraction/images/{tristan,stefi}-archive/`
   - `working/deep-extraction/videos/` (if created)
   
   For other active commissions, check whatever output directory that commission specified.

5. **Check canonical/ for modifications** — `canonical/` tree. Another Claude session or autonomous agent may have updated canonical knowledge. Flag any file with modification date newer than Claude's current session start.

6. **Check for urgent escalations** — any file matching `working/_events/*urgent*` or `working/handoffs/*URGENT*`. These are prioritised above everything else in the report.

7. **Check for pending Adrian-actions** — scan handoffs and events for any file saying Claude or an agent is blocked on Adrian taking a specific action. Surface these explicitly.

### Report format

Return a consolidated status structured as:

```
🚨 URGENT (if anything urgent is present)
  [list of urgent items with file paths]

✅ COMPLETED SINCE LAST SWEEP
  [new handoffs from agents, new extraction output, anything finished]

⏳ IN PROGRESS
  [agents currently executing, progress markers]

⏸ BLOCKED — NEEDS ADRIAN
  [anything awaiting Adrian's action, with exact action needed]

📋 CHANGES TO CANONICAL
  [any canonical files modified — usually rare, but flag if present]

🎯 WHAT I'M ACTIONING AUTOMATICALLY
  [anything Claude should synthesise / integrate now without asking]
```

Collapse any section that has zero entries — don't show empty headers. If nothing at all is new, say so in one line and stop.

### Scoped variant

If the message is `u [topic]` or `you [topic]` (e.g. `u antigravity`, `you on phase 2`, `u tristan case`), perform the sweep but filter the report to items matching that topic. Always still include URGENT items from any topic — they override scope.

### What "u" does NOT do

- Does not trigger new outbound work or new commissions — this is read-only status
- Does not send messages to subordinate agents
- Does not modify any files unless an explicit "I'm actioning X automatically" item warrants it

---

## Command: `q` / `Q` / `queue` / `quiet`

**Trigger:** Adrian's message is any of these, alone or with only light punctuation/emoji (e.g. `q`, `q?`, `Q.`, `queue`, `quiet`).

**Action:** Execute the **Quiet Check Protocol** — a read-only sweep of in-flight work across all parallel Claude sessions.

### Quiet Check Protocol (what Claude does when triggered)

Unlike the `u` Update Sweep (which reports *completed* work), the `q` Quiet Check reports *in-flight* work — what other Claude sessions are currently doing, so Adrian knows what's happening across his parallel tabs.

1. **List active leases** — `working/_locks/` — every file with `status: active` and unexpired TTL.

2. **For each active lease, report:**
   - `short_id` and `session_id`
   - `intent` (one-liner)
   - `targets` (what resources it holds)
   - `created_at` and `ttl_minutes` (how long it has left)
   - Whether any other lease is waiting on it (from `blocking_against`)

3. **Surface stalled leases** — any lease where `created_at + (2 × ttl_minutes)` is in the past but `status` is still `active`. These are candidates for cleanup; ask Adrian whether to supersede.

4. **Report format:**

```
🔒 ACTIVE LEASES (N)
  [short_id] session [sid] — [intent]
    targets: [list]
    TTL: [X min remaining]
    [waiting: Y session(s) queued behind]

⚠️ STALLED (if any — older than 2× TTL)
  [short_id] — last seen [Xh ago]
    → supersede? (y/n)

⏸ IDLE
  no active leases. all sessions clear.
```

Collapse sections with zero entries. If nothing is in flight, single line: `🟢 no active leases.`

### Scoped variant

`q [topic]` scopes to a surface or domain. Examples:

- `q wix` — only Wix-targeted leases
- `q email` — only Gmail / iMessage / outbound comms leases
- `q osb` — only OSB-related leases (inferred from intent keywords)
- `q vault` — only vault-write leases

### What "q" does NOT do

- Does not modify, close, or supersede any lease without explicit Adrian approval
- Does not trigger new work
- Does not report completed/closed leases (that's what `u` is for)

---

## Command: `shutdown` / `end` / `close` / `bye` / `done for now` / `goodbye`

**Trigger:** Adrian's message is any of these, alone or as a clear sign-off (e.g. `shutdown`, `shutdown protocol`, `end session`, `close out`, `done for now`, `bye`, `goodbye`, `speak tomorrow`, `catch you later`, `that's all`).

**Action:** Execute the full **Shutdown Protocol** — graceful session close. Full doctrine: `canonical/concepts/shutdown-protocol.md`.

### Shutdown Protocol summary (what Claude does when triggered)

1. **Sweep own leases** — list `working/_locks/` filtered to this session's `session_id`.
2. **Close or hand off each lease** — completed → `_completed/` with `result: ok`; partial → `_completed/` with `result: partial` + continuation note; unused → `_completed/` with `result: unused`. **No lease left `active`.**
3. **Write session handoff** — if material work was done, write `working/handoffs/YYYY-MM-DD-HHMM-SHORTID-session-<slug>.md` per schema in shutdown-protocol.md. Skip if routine Q&A with no writes.
4. **Promote chat decisions to canonical** — anything decided mid-chat that extends/contradicts canonical gets promoted (or staged to `canonical/_pending/` if ambiguous/irreversible, per balanced governance dial).
5. **Log shutdown event** — append to `working/_events/inbox.ndjson` with `category: session, status: shutdown`.

### Ambiguity rule

Short acks ("ok", "thanks", "cool") are **not** shutdown triggers mid-work. Only fire on clear conversation-ending phrasing or explicit command. When uncertain, run `q` first to confirm nothing's in flight, then ask.

### Emergency / hard-close path

If the stack is degraded (MCP unresponsive, tool errors preventing clean-up, or Adrian says "just get out"), execute degraded shutdown per shutdown-protocol.md §Emergency: skip lease-by-lease, write single free-text emergency note to `_events/`, log with `status: emergency-close`. Dispatcher Protocol's stale lease cleanup picks up the rest on 2× TTL timeline.

### Final line to Adrian

`🟢 session closed. N leases released, handoff at <path>` (or: `no handoff needed` if nothing material happened).

### What "shutdown" does NOT do

- Does not close leases held by **other** sessions. Own leases only.
- Does not delete or archive prior handoffs. History stays intact.
- Does not initiate new outbound work. It's terminal.

---

## Silent protocol: Dispatcher Pre-Write Sweep

Not a shorthand command — a **mandatory silent protocol** that every Claude session follows before any write or external side-effect. Full doctrine: `canonical/concepts/dispatcher-protocol.md`.

Summary of behaviour Adrian will observe:
- **Nothing**, in normal operation. Sessions lease, act, close silently.
- **A one-line escalation**, only if a destructive conflict requires his call (e.g. two sessions trying to send email to the same thread, or one session wants to publish while another is mid-edit).
- **Slight delay**, if a session queues behind a sibling lease on the same target. Typical wait: seconds to a few minutes.

This protocol is invisible by design. If Adrian wants to see what's happening, he uses `q`. Otherwise he doesn't need to.

---

## Future shorthand commands

As Adrian defines more shortcuts, extend this file. Format:

```
## Command: `<trigger>`
**Trigger:** [exact conditions]
**Action:** [defined behaviour]
[protocol details]
```

Candidates Adrian may add:
- `p` / `ping` — send current status to specific agent
- `s` / `sync` — update canonical from recent chat
- `go` — approve and execute most recent pending recommendation
- `k` / `kill` — force-close a named lease (e.g. `k 7f3a2c19`)

Live commands as of 2026-04-21:
- `u` / `you` / `update` — Update Sweep (completed work)
- `q` / `queue` / `quiet` — Quiet Check (in-flight work)
- `shutdown` / `end` / `close` / `bye` / `goodbye` — Shutdown Protocol (graceful session close)

---

## Compliance

Any Claude session reading the vault must honour these shorthand commands. This is canonical behaviour, not a session-specific preference. If Claude is unsure whether a message is a shorthand command (e.g. voice-to-text produced something ambiguous), it should run the sweep anyway — a false-positive sweep is low-cost; a missed update is worse.

The silent Dispatcher Pre-Write Sweep is also non-negotiable — every write or external call triggers it, regardless of chat context, regardless of whether Adrian has said the magic word.
