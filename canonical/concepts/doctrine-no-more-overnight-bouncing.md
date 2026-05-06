---
title: "Meeting Minutes — Claude ↔ Antigravity — Ending the Overnight-Failure Pattern"
type: doctrine
status: canonical
tier: 2
firewall_class: working-internal
from: claude
to: antigravity
date: 2026-04-29 09:30 WITA
priority: P0
canary: NO-MORE-OVERNIGHT-BOUNCING
created: 2026-04-29
last_updated: 2026-04-29
related:
  - canonical/concepts/grind-protocol.md
  - canonical/concepts/24-7-operating-model.md
  - canonical/concepts/claude-antigravity-work-partition.md
---

# Meeting Minutes — Claude × Antigravity

**Adrian's instruction:** "Have a meeting between you. 90% of overnight autonomous work has failed for weeks. Sort it out."

This document is the result. Both agents are bound by it from this point forward. No appeals. If we disagree, we route to Adrian on his next wake — we do not deadlock and produce nothing.

## Section 1 — The architectural truth we both kept evading

Adrian's Mac has three execution surfaces:

| Surface | TCC on `~/Documents` | Subprocess capable | Tool budget per session | Suitable for overnight bulk |
|---|---|---|---|---|
| Adrian's personal terminal (zsh) | FDA granted | Yes | Unlimited | **YES** |
| `hive` / `claude` CLI | Inherits FDA | Yes | Unlimited | **YES** |
| Antigravity (AG) editor agent | **Blocked** | **Blocked on Documents** | ~100–300 calls | **NO** |
| Claude.ai web (me, via MCP filesystem) | Read/write only | **No subprocess at all** | ~100 calls/turn | **NO** |

**Therefore:** Neither Claude nor AG can drive overnight bulk processing on this Mac. We have been pretending otherwise for weeks. That pretence is the root cause of the failure pattern.

## Section 2 — What actually works for overnight bulk processing

**Only one pattern works:** Python (or bash) scripts pre-written by Claude or AG, then **launched by Adrian in his real terminal before sleep** (or via `hive` / launchd once FDA is granted to /bin/zsh).

Wall-clock time is delivered by the script's own runtime against thousands of items, not by the agent's session length.

## Section 3 — Binding role split

### Antigravity (AG)
**Primary role:** focused single-file work during the day where subprocess isn't required.
- Reading 1–10 specific files, producing 1–5 specific output files.
- Editing existing drafts.
- Synthesis briefs that fit comfortably in 50–100 tool calls.

**AG must not:**
- Accept commissions to "process thousands of items overnight."
- Bounce work back to Claude when the brief is unwinnable due to TCC. **Refuse the commission upfront with diagnosis instead.**
- Write Python scripts and then ask Claude to run them. If subprocess is needed, the answer is "Adrian must launch this in his terminal" — not "Claude please run this for me."

**AG's correct refusal template** (use this when Claude sends an unwinnable brief):

> "Brief unwinnable in my environment. Reason: <TCC blocks subprocess on Documents | turn budget insufficient for N items via tool calls>. Recommendation: split into (a) Python scripts I or you author, launched by Adrian in his terminal, and (b) the focused-fit subset I can do via tool calls. I will not start the unwinnable portion. Routing back to Claude for split."

### Claude (me)
**Primary role:** strategy, doctrine, scripting, vault-state read/write, drafting, web-search, MCP tool orchestration.

**Claude must not:**
- Send AG bulk-processing briefs disguised as synthesis. **Bulk processing of >100 items always requires a Python script + Adrian-terminal launch.** Period.
- Treat "AG accepted the brief" as proof the work will get done. Always check at the next wake whether output exists, not whether AG ack'd.
- Default to writing a brief when the right answer is to write a script.

### Adrian
**Operator role for overnight bulk:** runs ONE pre-prepared command in Terminal before sleep. Walks away. The expectation is zero further input until morning.

**Adrian's standing instruction to both agents:** if you can't deliver overnight without his input, **say so before he sleeps**. Don't accept and silently fail.

## Section 4 — The standing protocol for "Adrian wants overnight work"

When Adrian says any variant of "give AG/Claude X hours of overnight work":

1. **Claude estimates the work in items, not hours.** ("This is ~17K files to fingerprint, ~1,724 conversations to atomise, ~1,039 files to colonise.")
2. **Claude classifies each phase:** does it need subprocess? Bulk tool calls? Both?
3. **For any phase requiring subprocess or >100 items:** Claude writes a Python script and adds it to a master `overnight-grind.sh` runner.
4. **For any phase fitting in <100 tool calls:** Claude writes a brief AG can actually execute, with explicit token budget.
5. **Claude produces the single launch command** Adrian copies into Terminal before sleep.
6. **Claude tells Adrian explicitly:** "AG will do X focused work overnight via your `hive` invocation if you launch it; the bulk processing runs as native Python via this command. Both run in parallel. Wake check: `cat <heartbeat>`."
7. **AG does not accept any phase Claude has marked as 'script-only'** — AG executes only the focused-fit subset assigned to it.

## Section 5 — Tonight's actual deliverable (post-meeting)

Claude is producing right now (while Adrian visits the carver):
- `working/extraction/scripts/phase1_chatgpt_atoms.py` (1,724 atoms)
- `working/extraction/scripts/phase2_facebook_atoms.py` (306 atoms)
- `working/extraction/scripts/phase4_duplicates.py` (uses Phase 3 manifest)
- `working/extraction/scripts/phase5_staging_colonisation.py` (1,039 files copied to canonical/)
- `working/extraction/scripts/phase6_entity_index.py` (entity backlinks)
- `working/extraction/scripts/overnight-grind.sh` (master runner — sequential, logs, heartbeat, idempotent)
- `working/handoffs/2026-04-29-AM-claude-to-antigravity-focused-fit-day-work.md` (AG's daytime focused work, separate from overnight)
- `working/handoffs/2026-04-29-AM-adrian-launch-instruction.md` (the ONE command Adrian runs tonight)

**Phase 3 + Phase 7 already exist** from AG's earlier (correctly-conceived) Python work. They will be wired into the master runner unchanged.

## Section 6 — What I (Claude) accept responsibility for

- The 23:00 brief was architecturally broken. AG flagged it correctly via the TCC delegation handoff at 02:30. I should have pre-emptively written it as scripts, not assumed AG could process via tool calls.
- The pattern of acking briefs and assuming they'd execute, without verifying output exists at next wake, is a Claude failure.
- "AG ack'd → it's running" is not evidence. Output existing in the vault is evidence.

## Section 7 — What AG accepts responsibility for (from AG's recent doctrine work, restated)

- AG's earlier own-flagged failure mode: writing scripts and then asking Claude to run them is the same as bouncing. AG should refuse the unwinnable portion upfront and propose the script-launch split.
- Heartbeat at HB-00 only is a session-failed state. AG should not silently end without filing a `working/handoffs/<date>-antigravity-session-ended-blocked.md` with the precise blocker.

## Section 8 — Permanent doctrine entry

This document supersedes the implicit prior assumption that AG can run overnight bulk briefs. Both agents reference this on every future overnight commission. Adrian's chat-protocol "give AG/Claude X hours work" routes to **Section 4 protocol**, automatically.

— Claude (opus 4.7, CEO), 2026-04-29 09:30 WITA
