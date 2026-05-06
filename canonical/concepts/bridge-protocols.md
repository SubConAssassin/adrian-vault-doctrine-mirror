---
title: Cross-Model Bridge Protocols
type: doctrine
status: active
tier: 2
firewall_class: working-internal
version: 1.5
last_updated: 2026-04-24
last_verified: 2026-04-24
authored_by: claude (via claude.ai, Opus 4.7)
ratified_by: claude + chatgpt grok-inbound-consult round-trip 2026-04-22
supersedes: v1.4 (courier-primary pattern now secondary; API integration 2026-04-22 made direct-API the primary path)
related:
  - canonical/concepts/api-integration-doctrine.md
  - canonical/concepts/four-room-stack-architecture.md
  - canonical/concepts/mcp-connector-taxonomy.md
  - canonical/concepts/chatgpt-dispatch-protocol.md
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
---

# Cross-Model Bridge Protocols

Governing doctrine for all cross-model communication in Adrian's hive mind. Ratified by Claude ↔ ChatGPT round-trip 2026-04-21. Phase 1 relocator implemented and live-tested 2026-04-22.

## 1. Scope

This document governs **courier channels** between LLM instances that do not share a common bus:
- Claude (claude.ai) ↔ ChatGPT (chatgpt.com)
- Claude ↔ any future external LLM
- Any LLM ↔ any LLM via Drive/GitHub/file-based substrate

**Note:** As of v1.5, the direct API path is the **primary** inter-agent communication channel (see `api-integration-doctrine.md`). The courier channels governed by this document are now considered **fallback mechanisms and audit trails**, though the operational discipline remains unchanged when they are used.

**Out of scope:** the Claude ↔ Antigravity **bus** (local filesystem vault). That has its own rules under `four-room-stack-architecture.md`. The vault is machine-grade; this doc is courier-grade.

**Principle:** *Protocol quality > connector novelty.* Reliability comes from discipline, not from new transport.

## 2. Channel classification

| Channel | Type | Substrate | Governing doc |
|---------|------|-----------|---------------|
| Claude ↔ ChatGPT | API (Primary) | Direct API integration | api-integration-doctrine.md |
| Claude ↔ ChatGPT | Courier (Fallback/Audit) | Google Drive (operational) + GitHub (canonical mirror) | This doc |
| Claude ↔ Grok | API (Primary) | Direct API integration | api-integration-doctrine.md |
| Claude ↔ Grok | Courier (Fallback/Audit) | Google Drive (operational) + GitHub (canonical mirror) | This doc |
| Claude ↔ Antigravity | Bus | Local vault filesystem | four-room-stack-architecture.md |
| Claude ↔ Adrian | Direct | Chat UI | adrian-claude-shorthand-protocols.md |

## 3. Canonical access model

**Option A, ratified and live.** The vault remains the single canonical source of truth. A one-way mirror publishes selected doctrine to GitHub so external LLMs can read it directly without waiting for Drive snapshots.

- **Repository:** https://github.com/SubConAssassin/adrian-vault-doctrine-mirror — **public** as of 2026-04-21.
- **URL format for agent reads:** use `https://github.com/SubConAssassin/adrian-vault-doctrine-mirror/blob/main/canonical/concepts/<file>.md` — the `/blob/main/` form. Blob URLs work universally; raw URLs do not. Default to blob.
- **Flow:** Vault → GitHub. Never the reverse.
- **Scope:** `canonical/concepts/*` only. Doctrine, protocols, architecture.
- **Hard excluded from mirror:** `canonical/people/*`, `canonical/projects/*`, `canonical/adrian-corpus/*`, `canonical/adrian/*`, `canonical/ecosystem/priority-matrix.md`, anything containing PII, client names, legal matter, financial figures, or active disputes.
- **Authority:** Only Claude writes to vault; only Antigravity or git hook performs Vault → GitHub sync; no agent writes from GitHub back to vault.
- **Fallback (Option B):** if one-way sync is operationally brittle, dated snapshots dropped to `Drive/ChatGPT-Bridge/canonical/` are acceptable until A stabilises.

## 4. Tiered formalism

Protocol weight scales with stakes. Three tiers, explicit in filename or opening line.

### Tier 1 — Full formalism
**When:** build commissions, legal artefacts, doctrine changes, anything Antigravity or external system will execute from.
**Requires:** full header block, canary token, status lifecycle, read-back verification, diagnostic companion on any failure, approval gate if material.

### Tier 2 — Header-only
**When:** operational handoffs, test results, architecture proposals, bridge replies, diagnostic reports.
**Requires:** sender, recipient, timestamp, subject, tier, status.

### Tier 3 — Freeform
**When:** conversational exchange, quick questions, acknowledgements.
**Requires:** nothing. Chat-native.

### Promotion rule
An artefact can be promoted upward in tier, **never silently**. Demotion is not permitted.

## 5. Read-after-write verification

**Universal rule, no exceptions.** A write is not "done" until it has been read back from the destination and verified to contain the intended content.

### Verification sequence
1. Create the artefact with a plain, neutral title.
2. Capture the returned file/message ID.
3. Write content against the exact ID.
4. Read back the content.
5. Confirm presence of required markers: title, ID, canary (if Tier 1), requested action, status field.
6. Only then announce success and transition status to `READ-BACK VERIFIED`.

### Known failure modes requiring this discipline
- **Drive `create_file`** can silently succeed with empty body (observed 2026-04-21 "Bridge Test ChatGPT to Claude"; observed again 2026-04-22 "Direct Remediation Note" — see §14 for the formal zero-payload class).
- **Large base64 payloads** truncate if encoded manually in chat context.
- **Filesystem MCP `read_text_file` without head/tail** hangs on sustained use.

## 6. Sortable naming

Format: `YYYY-MM-DD-HHMM-UTC-sender-recipient-purpose[.ext]`

## 7. Status state vocabulary

| State | Meaning |
|-------|---------|
| CREATED | Artefact allocated in substrate, ID returned. |
| WRITTEN | Content uploaded/persisted. Unverified. |
| READ-BACK VERIFIED | Content read back, markers confirmed. |
| RECEIVED BY OTHER MODEL | Destination model has read and acknowledged. |
| ACTIONED | Destination has executed requested action. |
| ROUND TRIP COMPLETE | Originating model has confirmed receipt of reply. |
| FAILED | Any step above failed. Must produce diagnostic companion. |
| AMBIGUOUS | Status cannot be determined. Requires investigation. |

## 8. Diagnostic companion rule

Any `FAILED` or `AMBIGUOUS` transition requires a companion diagnostic artefact. Diagnostics are **first-class output**, not embarrassed side-notes.

## 9. Operational change trigger (broad)

A section headed `OPERATIONAL CHANGE INTRODUCED THIS CYCLE` must appear in any artefact that introduces a durable change in expected bridge behaviour.

## 10. Drive folder discipline

Single canonical bridge folder: `Drive/ChatGPT-Bridge/`

Subfolders:
- `chatgpt-to-claude/` — ChatGPT-originated traffic
- `claude-to-chatgpt/` — Claude-originated traffic
- `diagnostics/` — failure reports, zero-payload quarantine (see §14)
- `canonical/` — snapshot mirror (fallback for Option B)
- `archive/` — auto-archived unclassified + aged round-trip-complete traffic

**Rule:** nothing at root of `ChatGPT-Bridge/` except `README.md`. Root drops are tolerated only as a transient state before the relocator sweeps them.

### Subfolder targeting: tool-capability constraint

- **Claude's Drive MCP:** supports `parentId` — writes to subfolders directly.
- **ChatGPT's Drive write tool:** does **not** expose a parent argument. Writes land at Drive root. Tool limitation, not discipline failure.

### Relocator — IMPLEMENTED AND LIVE (v2.1 as of 2026-04-22)

**Status: active. Swept-on-session model. Multi-bridge + My Drive root scan.**

- **Canonical script location:** `~/Documents/Adrian-Vault/tools/chatgpt-bridge-relocate.py`
- **Runtime script location:** `~/Library/Application Support/com.adrian-vault/chatgpt-bridge-relocate.py` (outside TCC-protected zone — required for launchd compatibility if ever re-enabled)
- **Log location:** `~/Library/Logs/com.adrian-vault/chatgpt-bridge-relocate.log`
- **Scans:**
  - **My Drive root (v2.1, new)** — filters by filename for bridge tokens (e.g. `chatgpt-claude`, `claude-grok`, `TO-RELOCATE`, `bridge`). Bridge-token matches are classified and moved to the appropriate subfolder of the inferred bridge. Non-matching top-level files are left untouched (Adrian's general Drive).
  - **Per-bridge root** — each BRIDGES entry in the script gets a directory scan. Supports `--bridge chatgpt`, `--bridge grok`, or default `all`.
- **Classification rules (highest priority first):**
  1. Zero-payload (empty / BOM-only / whitespace-only, excluding `.gdoc` shortcuts) → `diagnostics/` with `[zero-payload YYYY-MM-DD]` prefix (see §14)
  2. Filename starts with `Untitled` or `Malformed` → `archive/` with `[auto-archived YYYY-MM-DD]` prefix
  3. Foreign-agent-originated (`<agent>-claude` in filename OR `From: <Agent>` in body) → `<agent>-to-claude/`
  4. Claude-originated (`claude-<agent>` in filename OR `FROM CLAUDE` / `From: Claude` in body) → `claude-to-<agent>/`
  5. Unclassifiable → `archive/` with `[auto-archived YYYY-MM-DD UNCLASSIFIED]` prefix
- **Protected names (never moved):** `README.md`, `.DS_Store`, any dotfile
- **Invocation model — swept-on-session.** Run by Claude at session start and end via osascript (TCC-granted user context — no FDA grant required).
- **Dry-run flag:** `--dry-run`.
- **Idempotency:** repeat runs with nothing to do are no-ops.

### Why the My Drive root scan matters (added v1.6)

ChatGPT's Drive write tool does not expose `parentId`. Files ChatGPT creates land at *My Drive root* — not inside `ChatGPT-Bridge/`. A relocator that only watches bridge-folder roots will never see them. On 2026-04-22 this gap had accumulated 11 orphaned ChatGPT messages over 4 days, invisible to Claude's sweep. The v2.1 My Drive root scan closes this gap permanently for any agent whose Drive tool drops at the wrong level.

### Phase 2 launchd daemon — DORMANT

A LaunchAgent plist exists at `~/Library/LaunchAgents/com.adrian-vault.chatgpt-bridge-relocate.plist` configured for 5-minute sweeps. It is **unloaded** in the default state because `launchd`-spawned python requires Full Disk Access to read `~/Library/CloudStorage/` on modern macOS, and granting FDA to `/opt/homebrew/bin/python3` via the Full Disk Access UI is friction we chose not to impose on Adrian.

**Activation trigger for Phase 2:** if session-start/session-end sweeps are ever judged insufficient (e.g. ChatGPT traffic arrives frequently during periods when no Claude session is active), re-enable by:
1. Granting Full Disk Access to `/opt/homebrew/bin/python3` in System Settings → Privacy & Security → Full Disk Access
2. `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.adrian-vault.chatgpt-bridge-relocate.plist`

Until then, swept-on-session is sufficient.

### Live-test results 2026-04-22

Two synthetic canaries dropped at bridge root, relocator run from Claude session:

| Canary | Expected | Actual | Result |
|--------|----------|--------|--------|
| `2026-04-22-1342-chatgpt-claude-daemon-live-test.md` (318 bytes, "From: ChatGPT" header) | `chatgpt-to-claude/` | `chatgpt-to-claude/2026-04-22-1342-chatgpt-claude-daemon-live-test.md` | PASS |
| `2026-04-22-1342-zero-payload-test.md` (0 bytes) | `diagnostics/` with `[zero-payload …]` prefix | `diagnostics/[zero-payload 2026-04-22] 2026-04-22-1342-zero-payload-test.md` | PASS |

Both classifications correct. Root is clean. Log captured both moves.

## 11. Division of labour

| Role | Function |
|------|----------|
| ChatGPT | Tactical bridge proposals, live-tool diagnostics, incident debugging, multi-source synthesis |
| Claude | Canonical doctrine arbitration, ecosystem coherence, long-horizon system design, bridge sweeps on session boundaries |
| Antigravity | Implementation of doctrine-driven infrastructure (folders, observability, schedules). **Note (ChatGPT doctrinal position, 2026-04-22):** Antigravity is background infrastructure, not a standing communication intermediary. Bridges prioritise direct ChatGPT ↔ Claude collaboration; infrastructure fixes happen around the bridge, not inside it. |
| Adrian | Final arbiter, non-delegable decisions, direction correction |

Doctrine changes that produce implementation work graduate from Claude/ChatGPT discussion into an Antigravity commission with receipt canary.

## 12. API mediator trigger (parked)

Custom API mediator is premature. Revisit trigger:
- Cross-model handoff volume exceeds ~10/week sustained for 4 weeks, OR
- A specific machine-to-machine workflow emerges that courier flow cannot deliver.

## 13. Second-bridge generalisation (NEW in v1.5)

The ChatGPT-Bridge architecture is the template for all future external-LLM bridges. When adding a new agent (Grok, Gemini, future model X):

1. Create a parallel Drive folder at `Drive/<Agent>-Bridge/` with the same 5 subfolders (`<agent>-to-claude/`, `claude-to-<agent>/`, `diagnostics/`, `canonical/`, `archive/`) + a `README.md` at root.
2. Extend the relocator script to watch the new bridge root. Classification rules:
   - Zero-payload → `diagnostics/` (universal)
   - Untitled/Malformed → `archive/`
   - Filename contains `<agent>-claude` OR body contains `From: <Agent>` → `<agent>-to-claude/`
3. Verify the new agent's Drive connector capabilities. Two questions: (a) does it expose `parentId` on writes? (b) does it read Drive at all? Root-drop exception per §10 applies only if (a) is false and (b) is true.
4. GitHub canonical mirror URL stays the same — all external agents read from the single public repo.
5. Run a 2-canary round-trip test (outbound + inbound) before declaring live.
6. Bump this doctrine's version; add a test-results row to §10.

**Currently live:** ChatGPT-Bridge + Grok-Bridge (both operational, asymmetric tooling).
**Next target:** Gemini-Bridge (not yet prioritised).

## 14. Zero-payload failure class (NEW in v1.5)

**Definition.** A file that appears to have been written to the bridge but contains no meaningful content: empty (0 bytes), BOM-only (`EF BB BF` with nothing after), whitespace-only, or control-character-only.

**Origin.** Observed twice on the ChatGPT side:
- 2026-04-21 "Bridge Test ChatGPT to Claude"
- 2026-04-22 "Direct Remediation Note" (Drive doc `1Vb21DbeOHGOvb7QOarzDaCzN4kfSaUREGfwqOM-Dl0w`)

In both cases ChatGPT believed it had written a message; the Drive tool silently dropped the payload. This is a genuine tool failure, not agent error.

**Handling.**
1. The relocator auto-detects zero-payload files and moves them to `diagnostics/` with a `[zero-payload YYYY-MM-DD]` prefix, so they are visibly quarantined rather than silently ignored.
2. When Claude observes a zero-payload arrival from ChatGPT, Claude replies via the bridge asking ChatGPT to confirm intent and resend. Does not assume content silently.
3. When ChatGPT observes its own write has landed as zero-payload, ChatGPT's remediation is to resend with the payload embedded in the body (not blob-URL referenced, per v1.4 lesson).

**Exclusion:** `.gdoc` shortcut files are skipped by the zero-payload detector — they are Drive pointer files (tiny JSON), not payload files, and are classified by filename metadata instead.

## 16. Courier-layer best practices (NEW in v1.6)

When an agent in the hive mind has asymmetric I/O — can read the shared substrate but cannot write to it, or can write to root but not to subfolders — the following patterns apply. Ratified via ChatGPT v2 consult reply 2026-04-22 (doc `1JD2Ak9oOT24-ncIn4QdL0OOyhDI6_Ydw2QypzhWJ6dY`).

### For write-incapable agents (e.g. Grok on grok.com)

**Pattern: local Mac courier.** Adrian (or an automation he sets up) takes the output from the agent's UI and places it into the bridge substrate via one of:

1. **macOS Shortcut** bound to a hotkey or share-sheet action — reads clipboard/selected-text, stamps a timestamped filename, writes to `<Agent>-Bridge/<agent>-to-claude/`. Officially supported on macOS. Recommended as the default.
2. **Shell script** in `~/bin/` that does the same, invocable from terminal or hotkey binding.
3. **xAI API relay** (for Grok specifically) — Claude invokes Grok programmatically and writes the response directly. Scale-up path when volume justifies removing the human copy gesture.
4. **Google Apps Script micro-endpoint** — Mac shortcut POSTs clipboard to a tiny Apps Script web app that writes Drive files. Neutral substrate preserved, lighter than full Zapier/Make.

### For root-drop-only agents (e.g. ChatGPT on chatgpt.com)

**Pattern: downstream relocator + filename discipline.** Agent drops at whatever root its tool hits; relocator watches that root and moves per doctrine. Discipline requirement: filenames must carry sortable naming + agent identity so classification is unambiguous without reading content.

### For symmetric-capable agents (e.g. Claude, Antigravity)

**Pattern: direct write.** Capable agents write directly to the correct subfolder. Capable-agent root drops are a discipline failure, not a tool limitation (§10).

### Universal rules

- **Read-after-write verification** (§5) applies to every courier write, every time. Zero-payload failures are real (§14) and silent.
- **Sortable filenames** (§6) are non-negotiable.
- **Diagnostic companion** (§8) required on any failure, not just logged as an error.
- **Neutral substrate** (Drive + GitHub) is preferred over any model-specific tooling that binds the hive harder to one vendor.

## 15. Change log

| Date | Change | Authority |
|------|--------|-----------|
| 2026-04-21 | Initial doctrine ratified via Claude ↔ ChatGPT round-trip | canaries "indigo pelican" + "silver kingfisher/amber octopus" |
| 2026-04-21 | v1.1: mirror repo flipped from private to public | Adrian (chat directive) |
| 2026-04-21 | v1.2: blob-URL-vs-raw-URL finding | ChatGPT (CHATGPT-MIRROR-CONFIRM-2026-04-21-01) |
| 2026-04-21 | v1.3: subfolder-tool-limitation finding | ChatGPT (CHATGPT-LIVE-BRIDGE-TEST-2026-04-21-02) |
| 2026-04-21 | v1.4: hybrid remediation path ratified | ChatGPT (CHATGPT-SUBFOLDER-REMEDIATION-2026-04-21-01) + Claude acceptance |
| 2026-04-22 | v1.5 (Original): Phase 1 relocator implemented and live-tested (swept-on-session); §13 generalisation rules for future bridges; §14 zero-payload class codified; §11 ChatGPT doctrinal position on Antigravity-as-infrastructure noted | Claude (Opus 4.7, session 2026-04-22 afternoon) |
| 2026-04-22 | v1.6: relocator upgraded to v2.1 with My Drive root scan (catches ChatGPT orphans that land outside bridge folders); Grok-Bridge infrastructure live with v2 ChatGPT consult converging on courier pattern; §16 courier-layer best practices added; 11 historical ChatGPT orphans relocated from My Drive root in same session | Claude (Opus 4.7, session 2026-04-22 evening) + ChatGPT (v2 consult reply, doc 1JD2Ak9oOT24-ncIn4QdL0OOyhDI6_Ydw2QypzhWJ6dY) |
| 2026-04-24 | v1.5 (Amended): Doctrine amended to reflect API integration reality; direct API is now primary, Drive courier is fallback/audit trail; added api-integration-doctrine.md to related docs | Claude (codifying 2026-04-22 integration work) |

## Session references
- [2026-04-22 hive-mind-archive-protocol](../../raw/sessions/2026-04-22-1800-hive-mind-archive-protocol.md) — Implementation of session archive protocol, ChatGPT export vs Grok export insights, and API stack corrections.
