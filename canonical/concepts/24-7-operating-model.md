---
title: 24/7 Operating Model — Adrian + Claude + Antigravity
type: doctrine
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-05-02
last_updated: 2026-05-02
related:
  - canonical/concepts/claude-antigravity-work-partition.md
  - canonical/concepts/grind-protocol.md
  - canonical/concepts/agent-budget-framework.md
  - procedural/workflows/session-shutdown.md
---

# The 24/7 Operating Model

The vault and agents operate continuously. Adrian's availability is intermittent — he sleeps, goes out, takes calls. The Mac runs always (caffeinated). Work cannot stop because Adrian is not at the keyboard.

This canonical defines the **three states**, the **handover rituals between them**, and the **monitoring/control surface** Adrian uses while away from the machine.

---

## The three states

### State A — Adrian awake AND at the machine

- **Claude:** orchestrates, synthesises, makes recommendations
- **Antigravity:** executes commissioned work; reads handoffs on sight
- **Adrian:** decides, authorises external spend, reviews drafts
- **External APIs (ChatGPT/Grok/etc):** available with per-call presidential authorisation

This is the only state in which presidential decisions can be made (external spend, n8n account creation, vendor contracts, public-blast content sign-off).

### State B — Adrian away, with iPad/iPhone reachability

- **Claude:** offline by default unless Adrian initiates remote prompt via Claude.ai web (iPhone session list broken April 2026 — use web URL fallback)
- **Antigravity:** continues grinding pre-staged commissions; writes progress to `working/handoffs/`
- **Adrian:** monitors via push notifications + remote prompts as needed
- **External APIs:** allowed only if explicit authorisation given before Adrian left the machine

State B is for "I'm out for two hours." AG keeps grinding. Adrian can interrupt remotely if something breaks.

### State C — Adrian asleep (~2am–7am Bali time)

- **Claude:** offline. No autonomous loops while user offline.
- **Antigravity:** runs maximum 8-hour overnight grind on pre-staged commission. CPU + disk only. Zero external API spend (no presidential signal available).
- **Adrian:** unreachable. Push notifications silenced if requested.
- **External APIs:** forbidden. AG must defer any work that would require external spend until State A resumes.

State C is the highest-leverage AG window. Most overnight commissions live here.

---

## Handover rituals

### Ritual 1 — Adrian leaves the machine (State A → B)

Trigger phrase: "I'm going out" / "stepping away" / explicit timer ("back in 2 hours").

Claude executes within 60 seconds:
1. Write current grind state to `working/handoffs/<date>-state-snapshot.md`
2. Confirm AG queue: list any active AG commissions and expected completion times
3. Verify AG heartbeat (most recent entry in `working/_logs/`)
4. Stage any pending Adrian-input items as a "needs presidential decision" list at top of the snapshot
5. Confirm push notification channel works (test ping)

Adrian reads the snapshot in his iPad/iPhone Claude session if he wants to check state.

### Ritual 2 — Adrian goes to sleep (State A → C)

Trigger phrase: "shutting down" / "going to sleep" / "overnight run" — also folded into Session Shutdown Protocol v1.

Claude executes:
1. **Full Session Shutdown Protocol v1** if invoked (`procedural/workflows/session-shutdown.md`)
2. **Stage overnight commission** for AG with 25/25 pre-flight green and zero-external-spend envelope
3. **Write next-thread pickup brief** at `working/handoffs/<date>-next-thread-pickup.md` — comprehensive enough for a fresh Claude session to act on
4. **Confirm AG heartbeat** is alive
5. **Final git push** of vault if Layer 2 backup is wired (currently INCOMPLETE — see blockers.md)

### Ritual 3 — Adrian returns / wakes (State B/C → A)

First message in new session, Claude executes:
1. Read latest `working/handoffs/` files (newer than last snapshot)
2. Read AG completion logs from State B/C window
3. Read `working/blockers.md` for any new blockers raised during grind
4. Read `working/api-usage.jsonl` tail for spend during the away window (should be zero in State C)
5. Generate 1-paragraph "you were away N hours, here's what happened" briefing

This is the inverse of the snapshot ritual.

---

## Remote control surface

Adrian's iPhone/iPad access vectors:

| Vector | Use case | Status |
|---|---|---|
| Claude.ai web at `https://claude.ai/code?environment=ENV_ID` | Remote prompt while away | ✅ working |
| iPhone Claude app session list | Resume specific local session | ❌ broken since April 2026 — use web URL |
| HIVEMIND iPhone bridge daemon | Fire-and-forget remote work via iCloud-courier handoff | ✅ Phase 1 LIVE (since 2026-04-25) |
| Push notifications | Wake Adrian when something breaks or completes | Conditional — depends on tool/MCP availability |

For frictionless monitoring without prompting, the HIVEMIND iPhone bridge (`canonical/infrastructure/hivemind-iphone-bridge.md`) is the right path — it lets Adrian drop a one-line directive on iPhone that gets picked up by the daemon and routed to Claude or AG.

---

## What can be deferred to which state

A decision tree for choosing where work goes:

| Work type | Best state | Why |
|---|---|---|
| Forensic extraction (Dropbox manifest, hashing, OCR) | C (AG overnight) | CPU-bound, deterministic, no decisions |
| Bulk transcription (whisper batch) | C (AG overnight) | CPU/GPU-bound, no decisions |
| Vault rewrites at scale | C (AG overnight) | Mechanical, idempotent |
| n8n workflow JSON authoring | C (AG overnight) | AG can write JSON; Adrian imports next morning |
| Strategic synthesis / planning | A (Claude with Adrian) | Requires Adrian context + decision |
| External-spend research (ChatGPT/Grok consults) | A (Adrian present) | Presidential authorisation required |
| Investor/partner-facing copy review | A (Adrian present) | Final sign-off needed |
| Persona card canonisation | A (Adrian forensic-verifies first) | Judgment call |
| Routine vault hygiene (link checking, dead-link prune) | C (AG overnight) | Mechanical |
| Blocker resolution requiring credentials | A (Adrian present) | Cannot delegate auth |

---

## Anti-patterns

1. **Idle Mac.** If AG is not commissioned and Adrian is asleep, the machine is wasted. Always stage at least one overnight grind before sleep.
2. **Claude burning tokens on AG-grindable work.** If a task is mechanical and CPU-bound, Claude writing the implementation directly is a waste. Commission it.
3. **Synchronous prompts during State B.** Don't prompt Claude on iPhone unless something needs intervention. State B is meant to be hands-off.
4. **Overnight commissions that need presidential authorisation mid-run.** Either pre-authorise the entire envelope or split into two commissions.
5. **No heartbeat.** A grind without periodic logs to `working/_logs/` is invisible. Always require a heartbeat cadence.

---

## Sequencing principle

Whenever there is more than one valid order in which to do work, prefer the order that **maximises non-overlapping use of all three actors** (Adrian / Claude / AG).

Example: tonight, Adrian is awake and asking Claude to plan the Dropbox audit. The plan is being written (Claude). The commission is being staged (Claude). At sleep, AG starts the manifest grind (State C). Adrian wakes to a finished manifest. Next thread, Claude consumes the manifest and sequences Phase 2.

Three-actor-non-overlap is the gold standard. Two-actor sequential (Claude → AG → Claude → AG) is the floor. One-actor serial (Claude only, or AG only) is the failure mode.

---

## Open infrastructure gaps (block full 24/7)

1. **Layer 2 private mirror** (`working/blockers.md`) — vault not version-controlled offsite. If overnight AG corrupts something, no rollback.
2. **OAuth offline flow for Dropbox** — token expires every 4h, blocks sustained API work without refresh-mid-grind logic.
3. **No automated push notifications from AG to iPhone** — currently Adrian has to pull state, not get pushed.
4. **Dashboard server not persistent** — dies on Mac restart, no LaunchAgent yet.

These are the actual blockers to a fully frictionless 24/7 model. Each is a discrete commission.
