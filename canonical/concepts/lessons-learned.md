---
title: Lessons Learned — Rolling Index
type: canon
status: canonical
created: 2026-05-04
updated: 2026-05-04
tags: [adrian-os, learning, mitigations, infrastructure]
related:
  - canonical/concepts/shutdown-protocol.md
  - canonical/concepts/session-archive-protocol.md
---

## Purpose

Append-only index of lessons extracted from session shutdowns. Read **forwards** — scanned before starting work in a domain to avoid known traps.

This is distinct from:
- **Session archives** (`raw/sessions/`) — read backwards when chasing a remembered problem.
- **Decisions canonical** (`canonical/businesses/...`, `canonical/projects/...`) — state changes about the world.
- **Process canonical** (`canonical/concepts/`, `canonical/frameworks/`) — how we work; lessons cite these when a `process-change` is promoted into one.

## How entries get here

Step 8 of the shutdown protocol (`canonical/concepts/shutdown-protocol.md`). Material lessons from each session are appended below. Trivial lessons stay in the session archive only.

## Entry schema

```markdown
### LL-YYYY-MM-DD-NNN [tag1, tag2] — One-line title

**Session:** <session_id> · **Archive:** [path]
**Date:** YYYY-MM-DD

**Context:** <2-3 sentences — what was being attempted>

**What happened:** <observation — the mistake / discovery / gotcha>

**Root cause:** <only for `mistake` / `tool-gotcha` — why it happened>

**Mitigation / pattern:** <the reusable takeaway>

**Promoted to:** <canonical file path if a new process/safeguard was created or extended, else "—">

**Tags:** `mistake` | `discovery` | `tool-gotcha` | `process-change` (one or more)
```

## Tag taxonomy

| Tag | Definition | Example |
|---|---|---|
| `mistake` | Error made → root cause → mitigation | Skipped a tool_search and assumed parameter names; tool failed silently |
| `discovery` | New technique/pattern worth reusing | `read_multiple_files` halves latency vs sequential reads on small files |
| `tool-gotcha` | MCP/tool/library quirk + workaround | Wix variant API silently drops variants if `option` field omitted |
| `process-change` | New safeguard added to canonical | Added Step 8 Lessons to shutdown protocol after gap noticed |

Multiple tags allowed (e.g. a `tool-gotcha` may also be a `process-change` if a canonical guard is added).

## Domain index

Search this file with `grep -i <domain>` to filter relevant lessons before starting work. Common domain keywords to grep for:

- `wix`, `etsy`, `meta-ads` — channel-specific
- `osb`, `subconscious-surgery`, `aga`, `wte` — business-specific
- `mcp`, `filesystem`, `apple-mail`, `osascript` — tooling
- `secretary`, `shutdown`, `dispatcher`, `u-protocol` — protocol-level

## Promotion threshold

A lesson is worth appending here if a future Claude session scanning this file before similar work would change its approach. If the answer is "no, this is one-off," the lesson stays in the session archive only.

When unclear, err toward including. Cost of one extra entry is low; cost of repeating a mistake is high.

---

## Lessons

### LL-2026-05-04-001 [process-change, mistake] — Shutdown protocol existed in two duplicate canonical files

**Session:** 2026-05-04 shutdown-protocol consolidation · **Archive:** (this session)
**Date:** 2026-05-04

**Context:** Adrian asked Claude to lay out the shutdown protocol "as you have it." Claude found two canonical files (`shutdown-protocol.md` and `session-shutdown-protocol.md`) covering the same procedure with different step numbering and partially overlapping content.

**What happened:** Both files were marked `status: canonical`. Neither pointed to the other. A shutdown trigger would force Claude to reconcile two docs in real time — fragile, slow, prone to dropped steps.

**Root cause:** When the second file was written 2026-04-24 (3 days after the first), the author did not search for an existing canonical of the same name/purpose. No pre-write canonical search was enforced.

**Mitigation / pattern:**
1. Merged into single canonical (`shutdown-protocol.md` v2), marked the second superseded.
2. Before writing any new `canonical/concepts/*.md` file, grep for similar titles AND scan the related-frontmatter graph of nearest neighbours.
3. Add to dispatcher protocol's silent pre-write sweep: also check for canonical-name collisions.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` (v2 merge), this entry.

**Tags:** `process-change`, `mistake`

---

### LL-2026-05-04-002 [discovery, process-change] — Lessons need their own forward-readable file, separate from archives

**Session:** 2026-05-04 shutdown-protocol consolidation · **Archive:** (this session)
**Date:** 2026-05-04

**Context:** Adrian asked whether the shutdown protocol captured mistakes and learnings so processes could be improved over time. Initial v2 protocol relied on session archives to hold lessons implicitly.

**What happened:** Audit revealed that actions (Secretary), decisions (Step 7 promote), and outputs (Step 6 handoff) were each given dedicated steps and dedicated files — but lessons were buried in the archive's free-form body. No forward-readable index. No way for a future session to grep "what gotchas have we hit on Wix" without reading every archive that mentioned Wix.

**Root cause:** Conflated two access patterns. Archives are read *backwards* (chasing a remembered problem). Lessons should be read *forwards* (scanned before starting domain work). Same content, different file, different index.

**Mitigation / pattern:**
1. Added Step 8 to shutdown protocol — mandatory lessons extraction, even if `0 extracted`.
2. Created this file as the rolling canonical. Append-only, indexed by date + tag + domain keywords.
3. Restart Recovery Checklist (in shutdown-protocol.md) updated: next session greps this file by domain before starting work.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` (Step 8 added), this file (created).

**Tags:** `discovery`, `process-change`

---

### LL-2026-05-04-003 [discovery, process-change] — One-doctrine-two-surfaces pattern for cross-surface protocols

**Session:** 5db0 shutdown-protocol-v2-2-build · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-04

**Context:** Adrian asked to extend shutdown protocol to Antigravity. Naive read = write a parallel AG-shutdown-protocol.md. That would have created the exact duplication problem just resolved by LL-2026-05-04-001.

**What happened:** Recognised the u-protocol already solved this — single canonical doc with `applies_to: [claude, antigravity]` frontmatter and a deltas section. Adopted the same shape for shutdown-protocol.md v2.2.

**Mitigation / pattern:** When a doctrine touches both Claude and AG, write ONE canonical with:
1. `applies_to: [claude, antigravity]` in frontmatter
2. Universal body (the protocol body works for both surfaces)
3. `## <SecondSurface> adaptations` section near the end documenting deltas (triggers, step behaviours, final-line format, edge cases)
4. Cross-surface coordination subsection (what happens when both surfaces run the protocol concurrently)

Reusable for any future cross-surface doctrine. Don't duplicate.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` v2.2 (uses pattern), this entry.

**Tags:** `discovery`, `process-change`

---

### LL-2026-05-04-004 [discovery, process-change] — Handoff acknowledgment loop = telemetry for doctrine integration

**Session:** 5db0 shutdown-protocol-v2-2-build · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-04

**Context:** Per u-protocol authoring rules, handoffs must be self-executing with a defined "done" state. But "doctrine integration" handoffs have no tangible output — the work is internalisation, not file production.

**What happened:** Resolved by requiring the receiving surface to write an acknowledgment file as the only telemetry. File path pattern: `working/handoffs/YYYY-MM-DD-HHMM-<receiver>-to-<sender>-<doctrine-slug>-integrated.md`. File existence IS the proof of integration. Acknowledgment file content includes: confirmation of read, list of internalised triggers/behaviours, optional dry-run results, and — critically — proposed deltas if the receiver sees gaps based on its operational reality.

**Mitigation / pattern:** Canonical pattern for ANY cross-surface doctrine push:
1. Authoring side writes self-executing handoff to working/handoffs/
2. Receiving side reads the handoff (via `u` or explicit instruction)
3. Receiving side writes acknowledgment file back to working/handoffs/ with confirmation + proposed deltas
4. Authoring side reads ack on next session, marks Secretary action complete, applies any proposed deltas to canonical

The proposed-deltas slot is critical — prevents the receiver from silently working around gaps in the doctrine. Surfaces operational mismatches for canonical update.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` (handoff to AG used this pattern), this entry. Worth lifting into a standalone `canonical/concepts/cross-surface-doctrine-integration.md` if used two more times.

**Tags:** `discovery`, `process-change`

---

### LL-2026-05-04-005 [tool-gotcha] — /working/ is gitignored; save-vault output silent about it

**Session:** 5db0 shutdown-protocol-v2-2-build · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-04

**Context:** Wrote a handoff to `working/handoffs/` then ran save-vault. Output only listed the modified canonical file in the commit summary; new handoff file was not mentioned. Initially looked like a write failure.

**What happened:** Verified file existed on disk (6059 bytes, correct path, correct content). `git status` showed "nothing to commit, working tree clean." `git ls-files | grep <handoff>` returned empty. Investigation: `.gitignore` rule `/working/` excludes the entire working directory per `bridge-protocols.md` rule that only canonical/ syncs to the public-facing GitHub mirror.

**Root cause:** save-vault is a thin wrapper around `git add -A && git commit && git push`. It honours .gitignore. Handoffs in /working/ are deliberately local-only. AG reads them via filesystem MCP, not git. So the gitignore is correct behaviour. But save-vault's output gives no signal that working/ files were skipped — it's silent.

**Mitigation / pattern:**
1. Don't read save-vault silence about working/ files as failure. Verify with `ls` or `git check-ignore -v <path>` before assuming a write failed.
2. For any handoff-write workflow, add a post-write `ls -la <handoff-path>` to confirm the file exists, since save-vault won't tell you.
3. If you ever need a working/ file in git for any reason, you'd need to override the gitignore explicitly (`git add -f`) — but think hard about whether it should be in canonical/ instead.

**Promoted to:** This entry. Worth adding to `canonical/concepts/bridge-protocols.md` as a known operational consequence of the gitignore rule.

**Tags:** `tool-gotcha`

---

### LL-2026-05-05-006 [mistake, process-change] — Don't co-opt user notification channels for system status

**Session:** 5db0 shutdown-protocol-v2-2-build (post-shutdown amendment) · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-05

**Context:** Shutdown protocol v2.2 included Step 10 — write an Apple Note as a phone-findable session summary. Walked the talk on this session and added one. Adrian immediately flagged: Apple Notes is for clients and personal use, NOT for system status clutter.

**What happened:** The Apple Note step felt like a smart UX add (phone-findable summary). It actually polluted Adrian's personal-and-client notes folder with system-generated content he doesn't read. Adrian only realised the cost AFTER seeing the first one fire. The step was inherited from session-shutdown-protocol.md (the superseded file B) without questioning whether the channel was appropriate.

**Root cause:** Conflated two distinct concepts:
1. "Where can system status live so it's queryable on demand?" → vault files (canonical, working/, raw/) already cover this
2. "Where can system status be pushed so the user is notified?" → wrongly assumed Apple Notes was option 2

Vault is BOTH. There's no need for a push channel — the user knows where to look. Pushing to a personal channel adds noise without value.

**Mitigation / pattern:**
- Removed Step 10 (Apple Note) from canonical shutdown-protocol.md (v2.3)
- Deleted the offending note from Apple Notes
- New principle: **notification channels owned by the user (Notes, Reminders, Calendar, Mail) are NEVER used for system status, closeouts, or AI-generated summaries.** System status stays queryable in vault. Push only when there is a hard real-time deadline the user must act on — and even then, prefer iMessage-to-self over personal channels.
- Generalisation: before any new protocol step that writes to a user-facing channel, ask "Is this channel currently used by Adrian for anything other than system content?" If yes → don't write there.
- Memory edits are full — this preference lives in canonical only. Future sessions reading lessons-learned.md before starting protocol work will encounter it.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` v2.3 (Step removed), this entry. Worth a separate doctrine file `canonical/concepts/notification-channel-rules.md` if this principle comes up twice more.

**Tags:** `mistake`, `process-change`

---

### LL-2026-05-05-007 [process-change, mistake] — Stale chats must verify current canonical before promoting anything on shutdown

**Session:** 2601 (chat opened 2026-05-01, briefly re-engaged 2026-05-05 for close-out) · **Handoff:** working/handoffs/2026-05-05-stale-chat-close-team-doctrine-grind-protocol-origin.md
**Date:** 2026-05-05

**Context:** A 4-day-old chat was briefly re-opened so Adrian could close it cleanly. The chat had originally produced large drafts (canonical/team/* 41-persona doctrine, original grind daemon, original u-protocol). In the 4 days since, parallel AG sessions had refined or superseded much of it (corporate-agent-architecture.md replaced the team model operationally; lessons-learned.md replaced the one-off lessons file; GCS pivot replaced the grind-as-primary approach; Apple Notes was forbidden from system status). Adrian's instruction: "some of this information might be old. Some still might not be set in stone."

**What happened:** Default shutdown-protocol behaviour (Step 7 Promote chat-level decisions to canonical) would have re-promoted stale doctrine from this chat over canonical that had moved on. Caught by Adrian's explicit prompt before any auto-promotion fired.

**Root cause:** Shutdown-protocol v2.3 assumes a session is fresh and its decisions are current. It has no clause for "this chat is days old; verify current canonical state before promoting anything."

**Mitigation / pattern:**
1. **Stale-chat detection rule:** if `created_at` of the chat (from frontmatter or earliest message) is more than 24h before `closed_at`, treat as stale. Stale-chat shutdown SKIPS Step 7 (canonical promotion) by default. Promotion requires explicit Adrian confirmation per item.
2. **Pre-shutdown state diff:** for stale chats, before any handoff write, scan canonical for files modified more recently than the chat's `created_at` and that share keywords with the chat's draft topics. List them in the handoff under "What is SUPERSEDED."
3. **Handoff schema add:** stale-chat handoffs include explicit `## What is SUPERSEDED` and `## What is STILL CURRENT` sections so the next session can disambiguate at a glance.
4. Hard-rule violations from earlier in the chat (e.g. Apple Notes writes pre-dating the v2.3 ban) get logged in the handoff with a manual-cleanup note for Adrian.

**Promoted to:** This entry. Candidate for a future v2.4 amendment to shutdown-protocol.md adding a "Stale chat" section between "When it fires" and "The ten-step shutdown." Not adding now — one occurrence is signal, two would justify the doctrine extension.

**Tags:** `process-change`, `mistake`

---

### LL-2026-05-05-008 [process-change, discovery] — Re-scan handoffs/ after any long background task before reporting state

**Session:** a228 (Gemini bridge + Apple Notes corpus + infrastructure sweep) · **Handoff:** `working/handoffs/2026-05-05-0117-eb94c46e-session-gemini-bridge-and-infrastructure-sweep.md`
**Date:** 2026-05-05

**Context:** Session ran a 1h 46min Apple Notes dump as a backgrounded osascript task. While that task was running, four new AG handoffs and one parallel-Claude completion landed in `working/handoffs/`. When Adrian later asked for a "presidential overview" of the chat's state, the naive answer would have flagged issues that had already been resolved by parallel work — the Gemini bridge privacy firewall and the LaunchAgent refresh daemon (exactly the two flags I'd raised hours earlier).

**What happened:** Caught it because I ran `ls -lt working/handoffs/` before composing the overview. Found the parallel completions, read them, integrated into the status report. The risk was: presenting stale flags as live decisions for Adrian, wasting his attention.

**Root cause:** Session-start protocol (read latest handoffs before responding) is canonical. The equivalent rule for long mid-session background tasks is not. A backgrounded task that runs for >5 min is functionally a small session-pause — parallel agents can drop work during it.

**Mitigation / pattern:**

1. **Hard pre-flight before any "what's the state" answer following a long task:** run `ls -lt working/handoffs/ | head -10` and read anything mtime-newer than the task's start time.
2. **Doctrine extension candidate:** add a "Mid-session handoff re-scan" clause to U-protocol or session-shutdown protocol — fire this whenever a Bash background task with `run_in_background: true` and runtime >5 min completes.
3. Same logic applies to AG: AG sessions running long tool calls should re-scan AG-to-claude and claude-to-AG queues on completion.

**Promoted to:** This entry. Candidate for a future amendment to U-protocol or shutdown-protocol adding mid-session handoff re-scan as a hard pre-flight.

**Tags:** `process-change`, `discovery`

---
