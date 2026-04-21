---
title: Cross-Model Bridge Protocols
type: canonical-doctrine
status: active
version: 1.0
last_updated: 2026-04-21
last_verified: 2026-04-21
authored_by: claude (via claude.ai, Opus 4.7)
ratified_by: claude + chatgpt round-trip 2026-04-21 (canary "indigo pelican")
supersedes: none
related:
  - canonical/concepts/four-room-stack-architecture.md
  - canonical/concepts/mcp-connector-taxonomy.md
  - canonical/concepts/chatgpt-dispatch-protocol.md
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
---

# Cross-Model Bridge Protocols

Governing doctrine for all cross-model communication in Adrian's hive mind. Ratified by Claude ↔ ChatGPT round-trip 2026-04-21.

## 1. Scope

This document governs **courier channels** between LLM instances that do not share a common bus:
- Claude (claude.ai) ↔ ChatGPT (chatgpt.com)
- Claude ↔ any future external LLM
- Any LLM ↔ any LLM via Drive/GitHub/file-based substrate

**Out of scope:** the Claude ↔ Antigravity **bus** (local filesystem vault). That has its own rules under `four-room-stack-architecture.md`. The vault is machine-grade; this doc is courier-grade.

**Principle:** *Protocol quality > connector novelty.* Reliability comes from discipline, not from new transport.

## 2. Channel classification

| Channel | Type | Substrate | Governing doc |
|---------|------|-----------|---------------|
| Claude ↔ ChatGPT | Courier | Google Drive (operational) + GitHub (canonical mirror) | This doc |
| Claude ↔ Antigravity | Bus | Local vault filesystem | four-room-stack-architecture.md |
| Claude ↔ Adrian | Direct | Chat UI | adrian-claude-shorthand-protocols.md |

## 3. Canonical access model

**Option A, ratified.** The vault remains the single canonical source of truth. A one-way mirror publishes selected doctrine to GitHub so external LLMs can read it directly without waiting for Drive snapshots.

- **Flow:** Vault → GitHub. Never the reverse.
- **Scope:** `canonical/concepts/*` only. Doctrine, protocols, architecture.
- **Hard excluded from mirror:** `canonical/people/*`, `canonical/projects/*` (OSB, SS, AGA, Ashta, legal), `canonical/ecosystem/priority-matrix.md`, anything containing PII, client names, legal matter, financial figures, or active disputes.
- **Authority:** Only Claude writes to vault; only Antigravity or git hook performs Vault → GitHub sync; no agent writes from GitHub back to vault.
- **Fallback (Option B):** if one-way sync is operationally brittle, dated snapshots dropped to `Drive/ChatGPT-Bridge/canonical/` are acceptable until A stabilises.

## 4. Tiered formalism

Protocol weight scales with stakes. Three tiers, explicit in filename or opening line.

### Tier 1 — Full formalism
**When:** build commissions, legal artefacts, doctrine changes, anything Antigravity or external system will execute from.
**Requires:** full header block (Message ID, From, To, Date/time, Tier, Status), canary token, status lifecycle, read-back verification, diagnostic companion on any failure, approval gate if material.

### Tier 2 — Header-only
**When:** operational handoffs, test results, architecture proposals, bridge replies, diagnostic reports.
**Requires:** sender, recipient, timestamp, subject, tier, status. No canary unless requested.

### Tier 3 — Freeform
**When:** conversational exchange, quick questions, acknowledgements.
**Requires:** nothing. Chat-native.

### Promotion rule (ratified by ChatGPT 2026-04-21)
An artefact can be promoted upward in tier, **never silently**. The document must explicitly state the new tier and the reason. Demotion is not permitted — once Tier 1, stays Tier 1.

## 5. Read-after-write verification

**Universal rule, no exceptions.** A write is not "done" until it has been read back from the destination and verified to contain the intended content.

### Verification sequence
1. Create the artefact with a plain, neutral title (ornate titles trip safety blocks).
2. Capture the returned file/message ID.
3. Write content against the exact ID.
4. Read back the content.
5. Confirm presence of required markers: title, ID, canary (if Tier 1), requested action, status field.
6. Only then announce success and transition status to `READ-BACK VERIFIED`.

### Known failure modes requiring this discipline
- **Drive `create_file`** can silently succeed with empty body (observed 2026-04-21, "Bridge Test ChatGPT to Claude" file).
- **Large base64 payloads** truncate if encoded manually in chat context. Mitigation: write to local disk, encode via `base64 -w 0`, upload complete file.
- **Filesystem MCP `read_text_file` without head/tail** hangs on sustained use (~4 min timeout). Mitigation: small `head:` reads; Cmd-Q restart for full recovery.

## 6. Sortable naming

Format: `YYYY-MM-DD-HHMM-UTC-sender-recipient-purpose[.ext]`

Examples:
- `2026-04-21-1305-UTC-chatgpt-claude-bridge-architecture-reply-v2`
- `2026-04-21-1620-UTC-claude-antigravity-utilities-4-phase-commission.md`

All cross-model artefacts use this format. Ad-hoc titles create retrieval noise and break chronological sorting.

## 7. Status state vocabulary

Eight states. Messages transition through them; each transition is logged in the status field.

| State | Meaning |
|-------|---------|
| CREATED | Artefact allocated in substrate, ID returned. |
| WRITTEN | Content uploaded/persisted. Unverified. |
| READ-BACK VERIFIED | Content read back from substrate, markers confirmed. |
| RECEIVED BY OTHER MODEL | Destination model has read and acknowledged. |
| ACTIONED | Destination has executed requested action. |
| ROUND TRIP COMPLETE | Originating model has confirmed receipt of reply and verified it. |
| FAILED | Any step above failed. Must produce diagnostic companion. |
| AMBIGUOUS | Status cannot be determined. Requires investigation before advancing. |

## 8. Diagnostic companion rule

Any `FAILED` or `AMBIGUOUS` transition requires a companion diagnostic artefact containing:
- Observed failure
- Exact step where it failed
- Evidence available
- Likely cause with confidence rating
- Fix attempted
- Result of fix
- Protocol change proposed (if any)

Diagnostics are **first-class output**, not embarrassed side-notes. They are the highest-leverage learning signal in the multi-model system.

## 9. Operational change trigger (broad)

A section headed `OPERATIONAL CHANGE INTRODUCED THIS CYCLE` must appear in any artefact that introduces a durable change in expected bridge behaviour. Ratified scope (ChatGPT 2026-04-21): **broad trigger**.

Fires on:
- Method changes (how a write is performed)
- Doctrine amendments (what the protocol says)
- Naming convention changes
- Tiering changes
- Verification changes
- Routing or folder changes

Does not fire on: routine traffic that follows existing doctrine without modification.

## 10. Drive folder discipline

Single canonical bridge folder: `Drive/ChatGPT-Bridge/`

Subfolders (to be created by Antigravity commission):
- `chatgpt-to-claude/` — ChatGPT-originated traffic awaiting Claude read
- `claude-to-chatgpt/` — Claude-originated traffic awaiting ChatGPT read
- `diagnostics/` — failure reports and protocol diagnostics
- `canonical/` — snapshot mirror (fallback for Option B)
- `archive/` — round-trip-complete traffic older than 7 days

**Rule:** nothing at root of `ChatGPT-Bridge/` except an index/README. Root drops produce retrieval noise and break audit trail.

## 11. Division of labour

| Role | Function |
|------|----------|
| ChatGPT | Tactical bridge proposals, live-tool diagnostics, incident debugging, multi-source synthesis |
| Claude | Canonical doctrine arbitration, ecosystem coherence, long-horizon system design |
| Antigravity | Implementation of doctrine-driven infrastructure (folders, sync, observability, schedules) |
| Adrian | Final arbiter, non-delegable decisions, direction correction |

Doctrine changes that produce implementation work graduate from Claude/ChatGPT discussion into an Antigravity commission with receipt canary.

## 12. API mediator trigger (parked)

Custom API mediator is premature given current traffic volume. Revisit trigger:
- Cross-model handoff volume exceeds ~10/week sustained for 4 weeks, OR
- A specific machine-to-machine workflow emerges that courier flow cannot deliver (programmatic callbacks, structured JSON orchestration).

Until either fires, courier is sufficient.

## 13. Change log

| Date | Change | Authority |
|------|--------|-----------|
| 2026-04-21 | Initial doctrine ratified via Claude ↔ ChatGPT round-trip | canaries "indigo pelican" (CtoGP) + "silver kingfisher/amber octopus" (infra test) |
