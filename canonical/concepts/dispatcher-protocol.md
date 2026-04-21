---
title: Dispatcher Protocol — Concurrency Control for Parallel Claude Sessions
type: canon
status: canonical
created: 2026-04-21
tags: [adrian-os, concurrency, locking, hivemind, infrastructure]
related:
  - canonical/concepts/adrian-os-event-bus.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - canonical/concepts/claude-ceo-discipline.md
---

## Thesis

Multiple Claude chat sessions run in parallel with no shared in-flight awareness. Without coordination, two sessions can write the same vault file, edit the same Wix product, send duplicate emails, or chain MCP calls that collide — producing hangs, duplicate work, and inconsistent state.

The Dispatcher Protocol layers a **lease-based concurrency control** on top of the existing Adrian-OS event bus. Before any write or external side-effect, a session claims a lease declaring what it is about to touch. Sibling sessions read the lease table before acting. Conflicts are resolved silently where safe, escalated only when a destructive collision is unavoidable.

This protocol is **silent by default**. Adrian is not notified of normal lease-and-release activity; he is only interrupted when a genuine conflict requires his decision (which, by design, should be rare).

## Relationship to the Event Bus

- **Event bus (`adrian-os-event-bus.md`)** records *what has happened* — files dropped into `working/intents/`, `working/dispatches/`, etc. fire launchd watchers.
- **Dispatcher (this doc)** records *what is about to happen* — leases declare intent before execution, so parallel sessions avoid collision.

The two layers are complementary. Event bus = past tense / completed state. Dispatcher = present tense / in-flight state.

## Directory layout

```
working/
├── _locks/                 # active leases (this doc)
│   ├── _completed/         # closed leases (audit trail, rotated weekly)
│   └── YYYY-MM-DD-HHMM-SHORTID-<slug>.md   # one file per in-flight op
└── _events/                # existing event bus log (unchanged)
```

Lease filename follows the existing Adrian-OS convention: `YYYY-MM-DD-HHMM-SHORTID-<slug>.md`. Lexical sort = chronological sort.

## Lease file schema

```yaml
---
uuid: <full-uuid>
short_id: <first-8-chars>
session_id: <4-char hex, unique per chat>
created_at: <ISO-8601>
ttl_minutes: <integer, default 30>
status: active           # active | completed | abandoned | superseded
intent: <one-line summary>
targets:
  - <resource-uri>         # see URI scheme below
ops: [read, write, send, publish, delete, pay]
blocking_against: []       # short_ids of leases this one waited on
---

## Notes
<free text — context, rationale, anything that would help another session
understand what this lease is about>

## Completion
completed_at: <ISO-8601 — added on close>
result: ok | failed | partial
output_ref: <path or URI of the thing produced, if any>
```

## Resource URI scheme

Targets are declared as stable URIs so conflict detection is deterministic.

| Surface | URI pattern | Example |
|---|---|---|
| Vault file | `fs:<absolute-path>` | `fs:/Users/adriantaffinder/Documents/Adrian-Vault/canonical/concepts/dispatcher-protocol.md` |
| Wix site | `wix:site:<siteId>` | `wix:site:09900b91-7201-452d-ba19-7bd969550434` |
| Wix product | `wix:site:<siteId>:product:<productId-or-slug>` | `wix:site:09900...:product:merkaba-pendant` |
| Etsy listing | `etsy:listing:<listingId>` | `etsy:listing:1234567890` |
| Gmail thread | `gmail:thread:<threadId>` | `gmail:thread:18f4a2b...` |
| Gmail compose | `gmail:compose:<to-address>` | `gmail:compose:erica@example.com` |
| Drive file | `drive:file:<fileId>` | `drive:file:1AbC...` |
| Calendar event | `gcal:event:<calId>:<eventId>` | `gcal:event:primary:abc123` |
| Domain (broad) | `*:<surface>` | `*:wix-site-write` (used for serialising all Wix writes if needed) |

New surfaces are added here as they're encountered. Unknown surfaces default to treating any overlap as a conflict.

## The four rules

### Rule 1 — Sweep before any write or external call

Before executing a write, send, publish, or external API call, list `working/_locks/` and load every lease file whose `status: active` and whose `created_at + ttl_minutes` is still in the future.

**Not required** for: searches, reads, `conversation_search`, local reasoning, chat-only replies.

### Rule 2 — Conflict test

For each active sibling lease, compute target overlap:

- **No overlap** → proceed. Claim own lease (Rule 3).
- **Read vs read** → proceed.
- **Read vs write on same target** → proceed, but re-read the target immediately before writing (TOCTOU guard).
- **Write vs write on same target** → conflict. See resolution below.
- **Any op on a `delete` / `publish` / `send` / `pay` target** → conflict. See resolution below.

### Rule 3 — Claim a lease

Write a new lease file to `working/_locks/` per the schema above before executing. Set `ttl_minutes` to the longest plausible duration for the op (default 30; up to 120 for long Wix batch writes; keep short for email sends).

The write to `_locks/` is itself exempt from Rule 1 (otherwise infinite regress). It is a small, idempotent append operation.

### Rule 4 — Close the lease

On completion, update `status: completed`, add `completed_at` and `result`, and move the file to `working/_locks/_completed/`. On failure, set `status: abandoned` with a one-line reason.

## Conflict resolution

| Conflict type | Default resolution | Escalate to Adrian? |
|---|---|---|
| Write vs write, same vault file, reversible | **Queue** — wait up to 2× sibling TTL, then proceed. | No |
| Write vs write, same Wix product | **Queue** — serialise. | No |
| Write vs write, same Etsy listing | **Queue** — serialise. | No |
| Any op vs in-flight `send` / `publish` / `pay` / `delete` | **Stop and escalate.** | Yes |
| Sibling lease is `abandoned` or TTL-expired | **Supersede** — mark the old one `superseded`, proceed. | No |
| Sibling lease is active but stalled (>2× TTL still active) | **Flag + escalate** before superseding. | Yes |
| Ambiguous resource (target URI can't be compared) | **Default to conflict, escalate.** | Yes |

Escalation uses the Adrian-OS notification channel (Mac notification / iMessage-to-self per event-bus Phase 1 defaults). One-line escalation: "Conflict on `<target>`: session `<A>` vs `<B>`. Waiting for your call."

## Governance alignment

This protocol respects the "balanced" governance dial from the event bus doctrine:

- **Auto-queue, auto-supersede, auto-proceed** on reversible vault writes, drafts, research filings, routine Wix product edits.
- **Auto-escalate** on: external comms (Gmail send, iMessage, Slack), money (Stripe, PayPal, any payment API), legal (signed demand letters, filings), canonical promotions, irreversible actions (Etsy delete, Wix publish to live, file move/delete), and any op where reversing would cost Adrian more than 2 minutes.

Rule of thumb inherited from event bus: **if reversing the action would cost more than 2 minutes of Adrian's time, the conflict path escalates.**

## Stale lease cleanup

Any lease where `created_at + (2 × ttl_minutes)` is in the past and `status` is still `active` is presumed **stalled** (crashed session, lost connection, user closed the tab mid-op).

Cleanup policy:
1. A subsequent session encountering a stalled lease **does not force-unlock silently**.
2. It emits a single escalation — "stalled lease `<short_id>` on `<target>`, older than 2× TTL, supersede?" — and proceeds only on Adrian's say-so.
3. On explicit supersede, the stalled lease is moved to `_completed/` with `status: abandoned`, `result: stalled-timeout`.

Weekly cleanup sweep (future launchd job): move `_completed/` entries older than 14 days to `episodic/dispatcher-leases/YYYY-MM/`.

## Session ID generation

Each Claude chat session generates a 4-char hex `session_id` on first lease claim, derived from a hash of: current ISO timestamp + random nonce. The session_id persists across all leases claimed by that chat. This makes it easy to see "session `a1b2` is the one running the Wix cleanup right now."

## Writing discipline

- **Lease first, act second, close third.** No exceptions for "just a quick edit."
- **One lease per logical op, not per tool call.** A 20-step Wix product update is one lease, not 20.
- **Short TTLs by default.** A lease held longer than needed blocks siblings unnecessarily. If the op finishes early, close the lease immediately — don't wait for TTL.
- **Close on failure too.** A half-finished op left `active` will stall siblings for 2× TTL. On any error, close the lease with `status: abandoned` and a one-line reason.
- **Silence by default.** Normal lease-and-release activity is not reported to Adrian. Conflicts that auto-resolve via queueing are logged to `_events/inbox.ndjson` but not surfaced. Only Rule-2 escalations reach Adrian's notifications.

## Shorthand integration

In addition to existing `u`/`U` (Update Sweep):

- **`q`** — Quiet Check. List `working/_locks/` and report active sessions, targets, and TTLs. Read-only, no acts. Useful when Adrian wants to know "what's in flight right now across all my tabs."
- **`q <topic>`** — Quiet Check scoped to that topic/surface (e.g. `q wix`, `q email`).

## Worked example

Session A (chat 1) starts a Wix product update on Merkaba pendant.

```
# Rule 1 sweep → working/_locks/ empty.
# Rule 3 — claim lease:
working/_locks/2026-04-21-1432-7f3a2c19-wix-merkaba-pendant-update.md
  uuid: 7f3a2c19-...
  short_id: 7f3a2c19
  session_id: a1b2
  ttl_minutes: 45
  status: active
  intent: "Update Merkaba pendant variants, chain pricing, description"
  targets:
    - wix:site:09900...:product:merkaba-pendant
  ops: [read, write]
```

Session B (chat 2), started 3 minutes later, wants to edit the same product.

```
# Rule 1 sweep → finds lease 7f3a2c19, TTL 45 min, target matches.
# Rule 2 conflict test → write-vs-write on same Wix product → queue.
# Silently waits. Polls _locks/ every 30s.
```

Session A finishes in 12 minutes, closes lease → moved to `_completed/`.

Session B's next poll sees the target free, claims its own lease, proceeds. Adrian sees neither the wait nor the handoff — it just works.

## What this protocol does not cover

- **Claude Desktop MCP server crashes / hangs** (root-level infrastructure failure, unrelated to lease logic). Covered separately under operating-infrastructure notes.
- **Antigravity-side concurrency.** Antigravity agents participate in the vault but write their own handoffs; they are expected to honour this protocol but enforcement is not automated until Phase 4 of the event bus roadmap.
- **Adrian himself editing vault files manually** while Claude has a lease. Adrian is trusted to do whatever he wants; Claude will detect the mid-op change on re-read (TOCTOU guard) and re-plan.

## Change log

- 2026-04-21 — Initial canonical version. Installed by Claude in response to hang/conflict symptoms across parallel chats. Directory scaffolding (`working/_locks/`, `working/_locks/_completed/`) created concurrently.
