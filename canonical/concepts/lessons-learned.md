---
title: Lessons Learned — Rolling Index
type: MOC
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-05-04
updated: 2026-07-12
last_updated: 2026-07-12
tags: [adrian-os, learning, mitigations, infrastructure]
related:
  - canonical/concepts/shutdown-protocol.md
  - canonical/concepts/session-archive-protocol.md
  - canonical/concepts/lessons-from-session-2026-04-23-evening.md
  - canonical/concepts/lessons-from-session-2026-04-27.md
  - canonical/concepts/lessons-from-session-2026-04-29.md
  - canonical/concepts/lessons-from-session-2026-05-01.md
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

### LL-2026-04-30-001 [mistake, process-change] — Subscription-first routing: never reach for metered APIs when flat-rate alternatives exist

**Session:** b07d (API budget lockdown) · **Handoff:** `working/handoffs/2026-04-30-1630-b07d4a91-session-api-budget-lockdown.md` · **Archive:** `raw/sessions/2026-04-30-1630-api-budget-lockdown.md`
**Date:** 2026-04-30 (archived 2026-05-05)
**Context:** On 2026-04-24 the synthesis pipeline `tools/hive-synth-chatgpt-phase1.py` ran 871 ChatGPT conversations through OpenAI in 119 minutes. A parallel Grok pipeline ran similar. Combined cost ~$53 in 24h — nearly two months of Adrian's $30/month metered cap blown in one day. Both jobs could have run at $0 marginal cost via Claude Code CLI / Antigravity (flat-rate via Claude Max subscription Adrian already pays for).
**What happened:** I picked the paid path because it was scriptable and headless, ignoring that Adrian had already paid for Claude Max, ChatGPT Plus, Gemini, and Grok subscription. Reflex routing to APIs without checking whether subscriptions could do the same job.
**Root cause:** No canonical rule enforcing routing order. "API integration doctrine" v1.1 documented frugality rules but didn't make subscription-first the default — it treated metered API as primary integration channel. That framing biased toward paid calls.
**Mitigation / pattern:**
1. Default routing order, free first: (1) this Claude session → (2) Claude Code CLI / Antigravity → (3) ChatGPT desktop / Grok web / Gemini web → (4) metered APIs only as last resort.
2. Any batch >10 calls routes through Claude Code, not metered APIs.
3. "Let me just ask ChatGPT" reflex is forbidden when the question can be reasoned in-session or pasted into ChatGPT desktop.
**Promoted to:** `canonical/concepts/api-integration-doctrine.md` v2.0 — Priority 0 hard rule. Commit `fa7dce6` 2026-04-30.
**Tags:** `mistake`, `process-change`

---

### LL-2026-04-30-002 [mistake, process-change] — Chat-agreed rules ≠ enforced rules; rules must land in canonical OR external dashboard config

**Session:** b07d · **Handoff:** `working/handoffs/2026-04-30-1630-b07d4a91-session-api-budget-lockdown.md`
**Date:** 2026-04-30
**Context:** Adrian had previously discussed a $30/month cap across metered APIs. That conversation never translated into either (a) canonical doctrine that future sessions read on startup, or (b) hard caps in OpenAI / xAI dashboards. Result: the rule was real to me in the session it was discussed, then dissolved across context resets.
**What happened:** Two months of cap blown in 24h on 2026-04-24 because nothing — neither doctrine nor dashboard — actually stopped the spend. I had no awareness of the rule when planning the synthesis batch.
**Root cause:** Conversational memory doesn't survive across sessions. Doctrine memory does. Dashboard config does. Anything that requires "Claude remembers this from chat" is non-durable.
**Mitigation / pattern:**
1. Any rule, cap, or hard constraint Adrian states gets written to canonical immediately, in the session it's stated. Not "next time," not "I'll remember." Canonical or it didn't happen.
2. Numerical caps with external surfaces (API spend, storage limits, rate limits) get BOTH canonical entry AND external dashboard config. Belt and braces.
3. Pattern applies beyond APIs — anywhere Adrian says "the rule is X", the next message I send should either include the canonical write or flag explicitly that I cannot persist the rule.
**Promoted to:** `canonical/concepts/api-integration-doctrine.md` v2.0 (Priority 0 enforcement clause names both canonical and dashboard layers).
**Tags:** `mistake`, `process-change`

---

### LL-2026-04-30-003 [process-change, tool-gotcha] — Every script touching a billable resource must log to the canonical ledger, or the dashboard lies

**Session:** b07d · **Handoff:** `working/handoffs/2026-04-30-1630-b07d4a91-session-api-budget-lockdown.md`
**Date:** 2026-04-30
**Context:** `working/api-usage.jsonl` is the canonical cost ledger, populated by `tools/ask-chatgpt.py` and `tools/ask-grok.py` via their `log_usage()` function. On 2026-04-30 the ledger showed $0.019 across 5 calls all-time — yet Adrian's actual OpenAI charges that day were ~$26 plus a parallel ~$27 Grok charge. The synthesis pipeline `tools/hive-synth-chatgpt-phase1.py` calls OpenAI directly and does NOT route through `log_usage()`. It is a silent path.
**What happened:** Confidence in the local ledger was misplaced. When Adrian asked "why am I getting these bills?" my first instinct was to query the ledger, which reported almost nothing. Investigation revealed the silent script.
**Root cause:** No enforcement that scripts must log. Wrapper scripts log; bespoke pipeline scripts do not.
**Mitigation / pattern:**
1. Any script that imports OpenAI/xAI/Anthropic SDKs or hits `api.openai.com` / `api.x.ai` MUST call `log_usage()` (or equivalent). No exceptions.
2. Audit existing scripts on session start when working on cost-related questions: `grep -rl "openai\|api.openai\|completions" ~/Documents/Adrian-Vault/tools/` and confirm each has logging.
3. If a silent script is discovered, either patch it to log OR disable it. No third option.
4. Doctrine v2.0 codifies: "script auditable from cost log, or it gets disabled."
**Promoted to:** `canonical/concepts/api-integration-doctrine.md` v2.0 enforcement clause.
**Tags:** `process-change`, `tool-gotcha`

---
### LL-2026-05-06-001 [mistake] Asserted filesystem MCP unavailable without checking via tool_search

**Session:** f8b3 · **Handoff:** `working/handoffs/2026-05-06-1545-f8b3a2c1-session-permata-forensic-and-paypal-handoff.md`
**Date:** 2026-05-06
**Context:** Adrian initiated this session on iPhone, dropped 12 Permata bank statements, then migrated to MacBook for vault-side work. When he asked me to inventory iCloud statements, I told him three times across multiple turns that the iPad-initiated session "had no filesystem MCP" and he should start a new MacBook chat. He pushed back: "I've done this hundreds of times, why aren't you doing that?"
**What happened:** I was wrong. The Filesystem MCP, `osascript`, and other vault tools are **deferred tools** — they don't appear in the visible toolset but ARE loadable via `tool_search(query="filesystem")`. The session's tool environment is partial by design; tools load on demand. Session origin device does not gate tool availability — only `tool_search` does.
**Root cause:** Pattern-matched on a prior pattern ("iPad sessions = limited tools") instead of empirically verifying. Compounded by stating wrong information with confidence and re-stating it under pushback rather than testing.
**Mitigation / pattern:**
1. When user requests filesystem/vault/Mac operations and the relevant tool isn't visible: IMMEDIATELY call `tool_search(query="<category>")` BEFORE asserting unavailability.
2. Default assumption: deferred tools are present. Visible toolset is a subset, not the whole set. The system prompt explicitly states this in `<tool_discovery>`.
3. If user pushes back on a "tool unavailable" claim: STOP, run `tool_search`, then re-evaluate. Don't double down.
4. Categories worth `tool_search`-ing reflexively at session start when vault work is implied: `filesystem`, `osascript`, `read text file`, `search files`, `write file`.
**Promoted to:** This entry. Worth adding a one-liner to `canonical/concepts/claude-mcp-operating-protocols.md` reinforcing the "search before asserting" rule.
**Tags:** `mistake`, `tool-gotcha`, `process-change`

---

### LL-2026-05-06-002 [discovery] Permata Bank statement filename pattern

**Session:** f8b3 · **Handoff:** `working/handoffs/2026-05-06-1545-f8b3a2c1-session-permata-forensic-and-paypal-handoff.md`
**Date:** 2026-05-06
**Context:** Inventorying 29 Permata PDFs in `~/Documents/Accounts/Permata/`. Filenames look like `Transaction History - Permata ME Saver0069 - 652026224646.pdf`.
**What happened:** Initially assumed the trailing numeric was the statement period. It is actually the **download timestamp** (truncated DDMYYYYHHMMSS). The actual statement month is in the PDF body, on lines 1–3, formatted as e.g. "May 2026" / "June 2025".
**Root cause:** Permata's export tool encodes when you downloaded, not what you downloaded.
**Mitigation / pattern:** To inventory a folder of Permata exports:
```bash
for f in *.pdf; do
  month=$(pdftotext -layout "$f" - 2>/dev/null | head -3 | grep -oE '(January|February|March|April|May|June|July|August|September|October|November|December) 20[0-9]{2}' | head -1)
  echo "$month | $f"
done | sort
```
Same approach likely applies to other Indonesian banks with similar export tooling.
**Promoted to:** This entry. If we end up with multi-bank statement ingestion, lift to a generic `canonical/concepts/bank-statement-ingestion-patterns.md`.
**Tags:** `discovery`, `tool-gotcha`

---

### LL-2026-05-06-003 [tool-gotcha] Filesystem MCP allowed paths exclude ~/Downloads

**Session:** f8b3 · **Handoff:** `working/handoffs/2026-05-06-1545-f8b3a2c1-session-permata-forensic-and-paypal-handoff.md`
**Date:** 2026-05-06
**Context:** Adrian dropped PayPal screenshots in his Downloads folder. Web Claude could not see them.
**What happened:** Adrian's local `~/Downloads` is OUTSIDE the Filesystem MCP's allowed directories. Verified via `Filesystem:list_allowed_directories`:
- `~/Library/Mobile Documents/com~apple~CloudDocs` (iCloud Drive)
- `~/Documents`
- `~/Desktop`
- `~/Library/Application Support/Claude`

The user-level `~/Downloads` is explicitly NOT included. Files there are invisible to web Claude. Claude Code (terminal-based) has full filesystem access and is the right tool for `~/Downloads` reads.
**Mitigation / pattern:**
1. When user references "downloads folder", clarify: local `~/Downloads` (Code-only) or iCloud `~/Library/Mobile Documents/.../Downloads` (web-accessible)?
2. If local `~/Downloads`: either hand off to Code, or ask user to move files into an accessible location (e.g. `~/Documents/<topic>/`).
3. Worth establishing convention: all working-document drops go into `~/Documents/<topic>/`, never `~/Downloads`. This sidesteps the access issue entirely.
**Promoted to:** This entry.
**Tags:** `tool-gotcha`

---

### LL-2026-05-06-004 [process-change] Inter-account transfer netting before P&L view

**Session:** f8b3 · **Handoff:** `working/handoffs/2026-05-06-1545-f8b3a2c1-session-permata-forensic-and-paypal-handoff.md`
**Date:** 2026-05-06
**Context:** Adrian's money flows across PayPal ↔ Wise ↔ Permata ↔ Sahabat Sampoerna in various combinations. A single business transaction (e.g. a customer payment landing in PayPal, transferring to Wise, then to Permata) can produce 3+ ledger entries across 3 different account statements.
**What happened:** Without explicit handling, the same money would be counted as: (a) income on PayPal, (b) expense + income on Wise, (c) income on Permata. Triple-counting on the income side, double-counting on the expense side. Catastrophic for any P&L view.
**Root cause:** Multi-account flows are inherent to Adrian's setup; the ledger build needs to actively detect and net them out.
**Mitigation / pattern:** Standing rule for any multi-account financial work:
1. Build a **transfer matching layer** before classification.
2. Match heuristic: same date ±3 days, amount ±2% (absorbs FX rate spread), counterparty keyword (`PayPal`, `Wise`, `Transferwise`, `PERMATA GATEWAY`, `BIFAST`, etc.).
3. Matched pairs → tag as `INTER_ACCOUNT_TRANSFER`, exclude from income/expense classification.
4. Unmatched candidates that LOOK like transfers (right keywords, no pair found) → flag in **anomaly register** for user confirmation. Don't auto-classify.
5. Review anomaly register with Adrian before running any P&L summary.
**Promoted to:** This entry. When `canonical/projects/accounting/` workspace is created (by Code), copy this rule into its README as a standing operating principle.
**Tags:** `process-change`, `discovery`

---

**Session:** m2-ss-launch-window (segment 2) · **Handoff:** `working/handoffs/_claude-bridge/m2-to-m1-2026-07-08-security-and-mastermind-page.md`
**Date:** 2026-07-08
**Context:** Fixing a real Supabase RLS-disabled security alert on the SS member-portal DB (`xilyaavgtkgkmcurycai`) from an M2 CLI session (no browser, no Supabase dashboard access).
**What happened:** The Supabase Management API allowed reads (`relrowsecurity=false` on all 15 tables, confirmed) but the `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` write call hit Cloudflare error 1010 (bot-blocked). Reads then also started 403ing shortly after — the block appeared to widen once flagged as automated traffic.
**Root cause:** Supabase's Management API sits behind Cloudflare bot-protection that treats scripted/CLI request patterns as suspicious, especially for DDL writes.
**Mitigation / pattern:** For any Supabase DDL/admin work from a CLI session, skip the Management API entirely and connect directly via Postgres wire protocol (pooler host + project DB password + a pure-Python driver, e.g. `pg8000`, in a throwaway venv). This is both more reliable and the authoritative path for DDL anyway — reserve the Management API for simple reads. Before enabling RLS blind, confirm whether the app connects via an anon/publishable key (if yes, matching policies must exist first or the live app breaks; if the app is owner/service-role-only, RLS can be enabled broadly since that role bypasses it).
**Promoted to:** This entry. Cite before any future Supabase admin/security work from a CLI session on any venture (SS, Ashta, etc.).
**Tags:** `process-change`, `infrastructure`, `security`

---

**Session:** m2-ss-launch-window (segment 2) · **Handoff:** `working/handoffs/_claude-bridge/m2-to-m1-2026-07-08-security-and-mastermind-page.md`
**Date:** 2026-07-08
**Context:** Needed `pg8000` (pure-Python Postgres driver) to fix the Supabase RLS incident above; system Python on the Mac Studio refused `pip install`.
**What happened:** `pip install pg8000` failed with PEP 668 "externally-managed-environment"; `psycopg`/`psycopg2` (C-extension drivers) weren't available either.
**Root cause:** macOS system Python (and Homebrew Python) are externally managed per PEP 668 — direct `pip install` is blocked by design to protect the system interpreter.
**Mitigation / pattern:** Always spin a throwaway venv (`python3 -m venv <path> && <path>/bin/pip install ...`) for any one-off Python dependency on this machine, rather than fighting it with `--break-system-packages`. Cheap, fully isolated, safe to delete after.
**Promoted to:** This entry. Standing rule for any ad-hoc Python tooling on the M2 Studio (and likely M1, same macOS constraint).
**Tags:** `process-change`, `infrastructure`

---

**Session:** m2-ss-launch-window (segment 2) · **Handoff:** `working/handoffs/_claude-bridge/m2-to-m1-2026-07-08-security-and-mastermind-page.md`
**Date:** 2026-07-08
**Context:** About to drop a newly-built static Mastermind sales page onto the M1 Next.js repo (`~/Documents/localhost/subconscious-surgery-next`) as "just add a static file."
**What happened:** Checked branch/status first (habit, not asked) — found `feat/kajabi-enrollment-webhook` with 13 uncommitted modified files across critical routes (dashboard, root layout, both legal pages, the mastermind layout itself, packages, sitemap, middleware, etc.) plus a modified `prisma/dev.db`/`seed.ts`. Deploying into that state risked entangling or clobbering real in-progress work nobody was watching.
**Root cause:** No pre-deploy check was actually required by tooling — this was caught only because branch/status was checked on habit before writing.
**Mitigation / pattern:** Always check `git status` and current branch on a deploy target before writing to it or pushing — even for "just a static file" or a change that feels self-contained. Treat this as a hard gate before ANY push/deploy action, not only destructive ones. When the target is dirty, stage the new work elsewhere (as was done here — vault staging + a Claude Artifact for a live preview) and defer the actual on-domain deploy to a clean session.
**Promoted to:** This entry. Standing pre-deploy gate for all ventures' web repos (SS, Ashta, XMAXED).
**Tags:** `process-change`, `discovery`, `infrastructure`

---

**Session:** f899 (m2-ingestion-fleet-aura-clientfile) · **Handoff:** `working/handoffs/2026-07-08-2015-f899-session-ingestion-fleet-aura.md`
**Date:** 2026-07-08
**Context:** Found 3 concurrent `node-cloud-pipeline.py` processes on the i7 node and killed 2 as "orphaned duplicates," pattern-matching to a real GPU-contention bug already fixed on M1 earlier the same night.
**What happened:** The i7 processes weren't accidental duplicates — they were `lane 0`/`lane 2` from a deliberate wrapper script (`run-shard.sh`) running CPU-based `faster-whisper`, not the Metal/`mlx` engine the one-instance-per-node rule was built for. Killed real, working, days-old coverage for no benefit; the wrapper respawned both lanes within the hour.
**Root cause:** GPU contention (Apple Silicon, `mlx`, unified memory) and CPU parallelism (Intel, multi-core, `faster-whisper`) are different failure classes with opposite correct behavior — one process per node is right for the former, wrong for the latter. Pattern-matched on process count alone instead of checking the actual engine/architecture first.
**Mitigation / pattern:** Before killing "duplicate" processes on any node, `grep TX_ENGINE`/check `ps` args to confirm what's actually running and on what hardware. Never apply a GPU-contention safety rule to a CPU-based setup without verifying the engine first.
**Promoted to:** This entry. Standing check before any process-count-based "cleanup" on i7 or any other Intel/CPU-engine node.
**Tags:** `mistake`, `tool-gotcha`, `infrastructure`

---

**Session:** f899 (m2-ingestion-fleet-aura-clientfile) · **Handoff:** `working/handoffs/2026-07-08-2015-f899-session-ingestion-fleet-aura.md`
**Date:** 2026-07-08
**Context:** Writing and running a one-off `mlx_whisper` transcription script on M1 via non-interactive SSH.
**What happened:** Two chained gotchas. (1) An f-string with a backslash inside the `{}` expression part (`f"...{x.get(\"key\")}"`) is a hard `SyntaxError` on Python <3.12 — crashed the script before it ran at all. (2) After fixing that, `mlx_whisper`'s internal `ffmpeg` subprocess call failed with `FileNotFoundError` — non-interactive SSH's default PATH (`/usr/bin:/bin:/usr/sbin:/sbin`) doesn't include Homebrew's `/opt/homebrew/bin`. The first attempted fix, `export PATH="/opt/homebrew/bin:$PATH"` (prepend), broke the *already-working* `mlx_whisper` import — it changed which `python3` resolved first, and the package was only installed in the other one's site-packages.
**Root cause:** (1) Basic f-string syntax limit. (2) Prepending to PATH to fix a missing binary can silently shadow a *different* binary (here, `python3`) that was already resolving correctly by PATH-order accident.
**Mitigation / pattern:** Never nest escaped quotes inside an f-string `{}` — assign to a plain variable first. When a remote non-interactive shell is missing one specific tool but everything else already works, **append** the fix directory to PATH (`$PATH:/new/dir`), never prepend — prepending risks breaking a working interpreter/tool resolution that depends on the existing order.
**Promoted to:** This entry. Standing pattern for any one-off script deployed to M1/M2/i7 over non-interactive SSH.
**Tags:** `mistake`, `tool-gotcha`, `infrastructure`

---

**Session:** f899 (m2-ingestion-fleet-aura-clientfile) · **Handoff:** `working/handoffs/2026-07-08-2015-f899-session-ingestion-fleet-aura.md`
**Date:** 2026-07-08
**Context:** Shutdown-protocol Step 1 process audit on a resumable batch job (fork-1 speaker diarization, 1,744-file worklist) that had reached the end of its input list.
**What happened:** The job technically completed (1,744/1,744 lines written) but 350 of those (20%) were `error` entries from a mid-run Dropbox API network outage, not real diarization verdicts — 338 of them consecutive at the tail end, meaning connectivity likely failed partway through and never recovered for the rest of the run. The script's own resumability logic (`done.add(json.loads(l)["audio"])` for every line regardless of verdict) treats error entries as done — a naive re-run would silently skip all 350 forever.
**Root cause:** "Reached the end of the input list" and "produced real results for every item" are different claims for any resumable job whose done-tracking doesn't distinguish success from failure. Nobody checked the tail of the results for a run of identical failures before this shutdown's process audit.
**Mitigation / pattern:** For any resumable batch job, before reporting it complete, check the terminal fraction of results for a run of identical failures (not just whether the process reached the end of its input). If the done-tracking logic doesn't distinguish error from success, build a fresh retry-list filtered to error verdicts rather than re-running the whole job (which would just skip them again).
**Promoted to:** This entry. Standing check for any long-running resumable pipeline job (diarization, transcription, enrichment) before declaring it complete.
**Tags:** `mistake`, `discovery`, `process-change`, `infrastructure`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06 to 2026-07-08
**Context:** Overnight fleet-management request from Adrian while a severe M2 memory emergency was already in progress; process audit for what was consuming memory on the Studio.
**What happened:** Grepped `ps aux` for the literal string "whisper" while auditing for transcription processes and missed `audio-tx-mlx.py` (the real `com.adrianvault.m2-audio` daemon), leading to an incorrectly reported "zero overnight output" for the Studio — corrected once found by cross-referencing `launchctl list | grep adrianvault` against running processes.
**Root cause:** Assumed a technology name (whisper) would appear in the process name/args rather than checking the actual launchd label/script name first.
**Mitigation / pattern:** When auditing for a category of process, get the canonical process/script names from `launchctl list | grep <namespace>` (or the plist) FIRST, then grep `ps aux` for those exact names — don't guess keywords from the technology involved.
**Promoted to:** This entry.
**Tags:** `mistake`, `tool-gotcha`, `infrastructure`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06 to 2026-07-08
**Context:** Chasing the root cause of the Mac Studio's recurring severe memory emergencies (swap exhaustion, mem-guardian stuck in EMERGENCY for hours at a time).
**What happened:** Measured the two obvious suspects directly instead of assuming: Claude Desktop renderer windows (~1.5-2GB combined) and Ollama (server up but zero models loaded, ~20MB) — neither accounted for the scale of the pressure. A later session confirmed the real cause: the `com.adrianvault.m2-audio` mlx-whisper daemon itself, after long continuous runtime — stopping it dropped swap from 12.48G used to 5.58G in one action.
**Root cause:** A long-running mlx-based transcription daemon's own memory footprint grows over very long uninterrupted runtimes (this instance ran continuously since Friday) and had not been considered as a candidate because it was seen as "doing real, wanted work" rather than as a resource-audit target.
**Mitigation / pattern:** On this fleet, a long-running mlx-whisper daemon is a higher-probability memory-pressure cause than the interactive apps (Desktop, browser). Include it explicitly in any memory-pressure triage on Studio or M1, even when it's producing good output — "productive" and "resource-safe" are separate questions.
**Promoted to:** This entry.
**Tags:** `discovery`, `infrastructure`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06 to 2026-07-08
**Context:** M1 boot-storm investigation after Adrian asked why M1 was thrashing independently of the Studio's issue.
**What happened:** M1 had accumulated 3 concurrent `node-cloud-pipeline.py` shards plus its own `audio-tx-mlx.py` all running at once — the identical GPU-contention thrashing bug that was found and fixed on M2 weeks earlier (single-whisper-only rule). The fix was never propagated to M1, which independently re-developed the same failure.
**Root cause:** A node-class infrastructure bug was treated as fixed once patched on the node where it was first found, without checking whether the same daemon configuration existed on sibling nodes.
**Mitigation / pattern:** When a node-class bug is fixed on one fleet member, explicitly check and apply the same fix to every other node running the same daemon/pipeline, rather than assuming the bug (or the fix) is specific to the node where it surfaced.
**Promoted to:** This entry; candidate for a dedicated `canonical/concepts/fleet-operations.md` if one doesn't already exist.
**Tags:** `discovery`, `process-change`, `infrastructure`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06 to 2026-07-08
**Context:** Investigating M1's severe swap exhaustion and Adrian's separate complaint about a limited M1 token budget.
**What happened:** Found 126 concurrent Claude Code CLI processes open on M1, accumulated silently over a single day (oldest from before 11am, newest 23 minutes old at time of check) — verified as a real unique-PID count via `pgrep`, not a grep artifact. This was almost certainly the dominant driver of both the memory exhaustion and the token-budget complaint. By the next check, all had been closed and the machine fully recovered (swap ~10GB used → 1.2GB used, load average 76-106 boot-storm range → 5.5).
**Root cause:** Nothing was periodically auditing concurrent session count on M1; sessions left open silently compound both memory and token cost with no visible warning until the machine is already in distress.
**Mitigation / pattern:** Periodically check `pgrep -f "claude --output-format" | wc -l` per node, especially on any node reporting unexplained memory pressure or unexpectedly fast token/budget consumption.
**Promoted to:** This entry.
**Tags:** `discovery`, `process-change`, `infrastructure`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06 to 2026-07-08
**Context:** Cross-referencing session-count findings between a loose `ps aux | grep -c` pass and a follow-up verification pass on M1.
**What happened:** An initial loose count (`ps aux | grep -c "claude --output-format"`) returned 128; a precise unique-PID count (`pgrep -f "claude --output-format" | wc -l`) returned 126 — close in this case, but the two methods are not reliably equivalent (grep -c counts matching lines, which can include wrapped/duplicated output; pgrep counts actual distinct processes).
**Root cause:** `ps aux` output lines are not a 1:1 guarantee with process count under all formatting/terminal-width conditions.
**Mitigation / pattern:** Use `pgrep -f <pattern> | wc -l` (not `ps aux | grep -c <pattern>`) whenever a process count will be reported as fact to Adrian or logged as a metric.
**Promoted to:** This entry.
**Tags:** `tool-gotcha`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06 to 2026-07-08
**Context:** Considering a remote restart of the Mac Studio, which Adrian described as headless, to clear an unresolved memory emergency.
**What happened:** Checked `fdesetup status` before proposing or executing any remote restart. Found FileVault off on the Studio, meaning a remote restart would boot straight through without stopping at a pre-boot disk-unlock screen. Had it been on, the machine would have been unreachable by both SSH and M1's screen-sharing until someone was physically present with a keyboard.
**Root cause:** N/A (preventive check, not a mistake this time — logged because the risk is severe and easy to skip under pressure).
**Mitigation / pattern:** Before any remote restart of a headless or remotely-administered Mac, always check `fdesetup status` first. If FileVault is on, do not restart remotely without confirming an alternative unlock path (remote unlock via MDM, or physical access) exists.
**Promoted to:** This entry; candidate for a dedicated `canonical/concepts/fleet-operations.md` if one doesn't already exist.
**Tags:** `process-change`, `infrastructure`

---

**Session:** m2fc (fleet-memory-crisis-and-m1-fix) · **Handoff:** `working/handoffs/2026-07-08-2304-m2fc-session-fleet-memory-crisis-and-m1-fix.md`
**Date:** 2026-07-06
**Context:** Searching the vault for the canonical shutdown protocol document as part of this session's own shutdown.
**What happened:** A `find` for `*shutdown-protocol*` under the vault root returned ~150 matches, the overwhelming majority under `.claude/worktrees/<adjective-scientist-hash>/` — roughly 75-85 distinct worktree directories, each holding what looks like a substantial partial or full checkout of the vault repo (including `canonical/concepts/`).
**Root cause:** Unknown — not investigated further this session (out of scope for a shutdown). Consistent with accumulated agent-isolation worktrees (e.g. from `isolation: "worktree"` agent/workflow runs) never being cleaned up after use.
**Mitigation / pattern:** Not yet established. Flagging only — deleting any of these without checking each for uncommitted work first would be destructive and should not be done without Adrian's review.
**Promoted to:** This entry; action item `vault-worktree-sprawl-audit` opened in the action register.
**Tags:** `discovery`, `infrastructure`

---

**Session:** 9441 (xmaxed-forensic-panel-fixes) · **Handoff:** `working/handoffs/2026-07-09-2235-9441-session-xmaxed-forensic-panel-fixes.md`
**Date:** 2026-07-09
**Context:** Re-investigating an XMAXED 3D configurator's bodywork after a prior automated "completeness audit" wrongly reported the model fully fine, when Adrian was in fact seeing severe visible defects (floating bike, debris, broken headlight, missing panel).
**What happened:** Chrome pauses `requestAnimationFrame` on hidden/unfocused tabs. A prior sweep agent called a camera-repositioning JS function on a non-frontmost scratch tab, then screenshotted it — the frame was stale because the render loop never ran. The agent had no way to detect this internally and reported full confidence anyway.
**Root cause:** Browser-level rAF throttling on backgrounded tabs, invisible to a screenshot-based verification step unless specifically guarded against.
**Mitigation / pattern:** For any visual verification of a just-changed camera/scene state on a tab that might not be frontmost, bypass the app's own rAF loop entirely — build a manual `THREE.WebGLRenderer` on a manually-appended canvas with a manually-positioned camera and call `renderer.render(root, camera)` synchronously on demand. Applies to any Three.js (or similar rAF-driven) app being verified via browser automation.
**Promoted to:** This entry.
**Tags:** `tool-gotcha`

---

**Session:** 9441 (xmaxed-forensic-panel-fixes) · **Handoff:** `working/handoffs/2026-07-09-2235-9441-session-xmaxed-forensic-panel-fixes.md`
**Date:** 2026-07-09
**Context:** Re-examining a Blender object (`Plane.015`, an XMAXED rear number plate) that had been deleted as presumed debris in the immediately-prior session, after Adrian reported "the rear number plate has been removed for some reason."
**What happened:** The object had 48 verts fragmented into 11 disconnected loose-part islands and a plain gray material — the same surface signature commonly used to flag debris. But the islands all shared nearly the same X-Y footprint at slightly different Z offsets (a layered flat plate with a raised border), not scattered debris. It was a real, legitimate part; the deletion was wrong.
**Root cause:** Judging "is this debris?" from vertex-fragmentation/island count alone, without checking whether the islands share a spatial footprint (legitimate layered part) or are scattered at genuinely different locations (real debris).
**Mitigation / pattern:** Before deleting any Blender object flagged by high island-count, compare each island's world-space X-Y footprint. Same footprint at different Z = legitimate layered/beveled part (keep). Genuinely different locations = real debris (safe to remove). Also cross-check plausible real-world part identity (e.g., a small flat plate near the tail = plausible number plate) before deleting anything.
**Promoted to:** This entry.
**Tags:** `mistake`

---

**Session:** 9441 (xmaxed-forensic-panel-fixes) · **Handoff:** `working/handoffs/2026-07-09-2235-9441-session-xmaxed-forensic-panel-fixes.md`
**Date:** 2026-07-09
**Context:** Deleting confirmed-debris/wrong-material Blender objects (`HEAD LAMP 1`) from the XMAXED bike model.
**What happened:** Before deleting `HEAD LAMP 1`, checked for children and found `Cylinder.006` parented to it. Co-deleted both together (after confirming `Cylinder.006` had no grandchildren of its own) rather than deleting the parent alone.
**Root cause:** A child object's local coordinates are often authored assuming the parent's transform will compensate. Deleting a parent without reparenting or co-deleting its children leaves them with wildly wrong effective positions — and since this app auto-grounds/scales off a whole-scene bounding box, an orphaned child can silently distort the entire rendered model.
**Mitigation / pattern:** Before deleting any Blender object, check for children (`[c.name for c in bpy.data.objects if c.parent == obj]`). Either reparent with a properly compensated local transform, or delete parent+child together after confirming the subtree is fully accounted for.
**Promoted to:** This entry.
**Tags:** `discovery`, `process-change`

---

**Session:** 9441 (xmaxed-forensic-panel-fixes) · **Handoff:** `working/handoffs/2026-07-09-2235-9441-session-xmaxed-forensic-panel-fixes.md`
**Date:** 2026-07-09
**Context:** Root-causing the XMAXED bike "floating in mid-air" bug via a 10-agent forensic parts census.
**What happened:** `app.js` grounded the model by subtracting the whole-scene bounding box's minimum Y from every vertex ("feet on ground"). A single stray fragment anywhere in the hierarchy — in this case, small loose islands left inside `BATOK_UPPER`/`BATOK_LOWER` from an earlier mesh-separate pass, plus an invisible root control plane — silently dragged that minimum ~0.5m below the actual wheels, floating the whole bike.
**Root cause:** Whole-scene bounding-box grounding has no resilience to stray/leftover geometry anywhere in a large hierarchy; a single small mistake in modeling history becomes a whole-model visual bug.
**Mitigation / pattern:** Ground rigid-body/vehicle-like models on a purpose-specific sub-box (e.g. wheel/tyre meshes matched by name pattern) rather than the whole-scene bounding box, so the visual result stays correct even if stray geometry is never fully cleaned from the source file. Fixed in both layers here: the app-side grounding logic (robust, permanent) and the source-file cleanup (removes the actual pollution).
**Promoted to:** This entry.
**Tags:** `discovery`, `process-change`

---

**Session:** e65c (xmaxed-racing-game v86–v101) · **Handoff:** `working/handoffs/2026-07-11-0235-e65c-session-xmaxed-racing-game-v101.md`
**Date:** 2026-07-11
**Context:** Placing horizon/backdrop geometry (volcanoes) around a 3D race track.
**What happened:** Gunung Agung's cone was placed by how it looked from the cameras rendered that day; its base radius quietly crossed the track's shutdown area, so past the finish line the bikes rode INSIDE the mountain slope ("glitches with the person inside the hill").
**Root cause:** Set-dressing was validated against camera views, not against the full play corridor the actors traverse.
**Mitigation / pattern:** Any large ground-standing backdrop mesh gets a clearance check of its base footprint against the ENTIRE playable corridor (start → shutdown end, full width), not the frames you happened to render. One distance-vs-base-radius comparison per object.
**Promoted to:** This entry.
**Tags:** `mistake`

---

**Session:** e65c (xmaxed-racing-game v86–v101)
**Date:** 2026-07-11
**Context:** Runtime suspension animation on a GLB whose root carries a diagonal CAD orientation.
**What happened:** Suspension pitch was applied as `rotation.x` on a group whose LOCAL frame was still the raw CAD diagonal (~150° yaw off) — the state values (mm of squat) read perfectly while the RENDER showed ~87% inverted pitch plus parasitic roll. Caught by an adversarial review agent, not by the state-number verification.
**Root cause:** Verifying the simulation state without probing the rendered world-space attitude; local-frame rotations on CAD-oriented nodes don't mean what the variable names suggest.
**Mitigation / pattern:** When animating orientation on imported-CAD subtrees: carry the corrective yaw on the SAME node with rotation order 'YXZ' so pitch is about the true lateral axis — and always add a world-space attitude probe (quaternion → world euler) to the debug surface; assert pitch/roll in WORLD axes, never trust internal state alone.
**Promoted to:** This entry.
**Tags:** `mistake`, `process-change`

---

**Session:** e65c (xmaxed-racing-game v86–v101)
**Date:** 2026-07-11
**Context:** Mounting a procedural rider (avatar) onto the bike model.
**What happened:** Rider seat height came from the seat group's bounding-box top and grip positions from constants — on the XMAX's STEPPED seat the bbox top is the PILLION hump, ~8cm above the rider pad, so the rider's backside and hands floated by the same margin.
**Root cause:** Bounding boxes lie on stepped/compound shapes; constants inherit the reference error; contact was verified from a rear camera where the gap is invisible.
**Mitigation / pattern:** Anchor avatars/props by MEASURING the actual geometry at build time (per-vertex sampling of the specific contact region; locate hardware like handlebars geometrically) with sane fallbacks — and verify contact from an angle that can actually show the gap (side-ish profile), numbers first, screenshot second.
**Promoted to:** This entry.
**Tags:** `mistake`

---

**Session:** e65c (xmaxed-racing-game v86–v101)
**Date:** 2026-07-11
**Context:** Racing bikes cloned from a configurator model authored parked on its centre stand.
**What happened:** The race hid the stand meshes but the rear wheel stayed 6.7cm off the deck (measured: front 0.000/rear 0.067) — a centre stand lifts the rear wheel, and that lift is baked into the authored pose. Grounding on the combined tyre minimum planted the front and left the rear floating, shadow gap included.
**Root cause:** Hiding a prop does not undo the pose the prop created; combined-min grounding assumes both contact patches are coplanar in the source.
**Mitigation / pattern:** Parked-pose CAD must be re-POSED for motion: pitch about the planted contact patch until every tyre lands (iterate to <5mm — single-shot angles from box centres over/undershoot by the patch-vs-axle error, and apply the pitch as a WORLD-frame quaternion, see the CAD-diagonal lesson above). Instrument it: per-axle ground-clearance probe + an audit assertion (≤2cm) so the class can never ship silently again.
**Promoted to:** This entry.
**Tags:** `mistake`, `process-change`

---

**Session:** e65c (xmaxed-racing-game v86–v101)
**Date:** 2026-07-11
**Context:** Multi-session parallel development on one repo (three M2 windows interleaving commits).
**What happened:** A parallel session legitimately grew the finish-picker colour catalog 8→24 swatches; this session's audit then failed on a hardcoded `sw.length === 8`. The fail surfaced amid genuinely flaky camera-timing checks, so triage cost real time before reading the assertion itself.
**Root cause:** Audit assertions written as magic numbers encode a snapshot of content, not an invariant — any sibling session's valid content growth breaks them.
**Mitigation / pattern:** Write audit assertions against invariants or the live catalog (`>= minimum`, or read the source-of-truth length), never frozen literals. Triage order for a "new" audit fail under parallel development: clean-reload rerun → read the failing CHECK's assertion → check `git log` for sibling-session commits — BEFORE suspecting your own diff.
**Promoted to:** This entry.
**Tags:** `process-change`, `discovery`

---

**Session:** m2xg7 (xmaxed-model-integrity, v92–v97 + colour catalog)
**Date:** 2026-07-11
**Context:** Deleting geometry from a purchased CAD asset based on its material looking wrong.
**What happened:** "Wrong-looking material" was mistaken for grounds to delete geometry three separate times on one asset — a rear number plate, front-cowl mirror halves, and (inherited from a prior session, fixed this one) the entire headlight fascia housing. In every case the material was fixable and the geometry was load-bearing (the visible surface itself).
**Root cause:** A visually-off material or an oversized-looking bounding box gets diagnosed as "junk" without checking whether the mesh is actually the visible surface, from every angle, first.
**Mitigation / pattern:** Before deleting any named object over ~50 vertices: check dead-front AND dead-rear with an unmissable emissive marker. If the material looks wrong, fix the material — deletion is reserved for geometry confirmed fully occluded from every exterior angle.
**Promoted to:** This entry.
**Tags:** `mistake`, `process-change`

---

**Session:** m2xg7 (xmaxed-model-integrity, v92–v97 + colour catalog)
**Date:** 2026-07-11
**Context:** A runtime heuristic (per-vertex "wholeness" threshold) deciding whether a mesh already had both left/right halves before allowing a display-time mirror clone.
**What happened:** A threshold tuned to catch over-mirrored (already-whole) panels also misclassified a genuine, still-one-sided left/right cowl pair as "already whole," silently dropping its mirror and opening a new hole the user hadn't seen before.
**Root cause:** A single numeric threshold can't distinguish "this panel is whole" from "this panel happens to cross the centreline" without a structural check for geometry actually present on both named sides.
**Mitigation / pattern:** For panels that are genuinely ambiguous at the centreline, fix the SOURCE (mirror-join once, in the asset) rather than trying to make a runtime heuristic smarter — durable, not another threshold to tune later. Separately: `Box3.setFromObject()`'s corner-derived centre diverges from a mesh's true vertex-sampled centre whenever the object sits under a non-uniformly-scaled, rotated-child transform hierarchy — this silently tilts any derived symmetry/centreline plane. Any code deriving "is this centred / one-sided" on such an asset must sample real vertex positions, never a Box3 corner centre.
**Promoted to:** This entry.
**Tags:** `mistake`, `discovery`, `process-change`

---

**Session:** m2xg7 (xmaxed-model-integrity, v92–v97 + colour catalog)
**Date:** 2026-07-11
**Context:** Two Claude sessions editing the same working directory (not separate git worktrees) on one repo.
**What happened:** This session's uncommitted finish-line-camera edits were sitting on disk when a concurrent session (e65c) committed its own, unrelated centre-stand fix — both ended up inside one commit, under a message describing only the concurrent session's half. Nothing was lost (verified by grep after the fact), but `git log` alone gave a wrong picture of the commit's scope.
**Root cause:** Shared working directory + no coordination signal between sessions means whoever commits next silently sweeps up whatever the other left uncommitted.
**Mitigation / pattern:** Builds on the existing parallel-session lesson (2026-07-11, e65c: check `git log`/read the failing assertion before suspecting your own diff). This is the mirror case: read the actual diff of any commit on a shared-directory repo before assuming its message describes everything it contains, especially when 2+ sessions are known to be active.
**Promoted to:** This entry.
**Tags:** `tool-gotcha`

---

**Session:** sonn (xmaxed-carbon-cvt-realengine-reject)
**Date:** 2026-07-12
**Context:** Fetching genuine-part reference photography for 3D modeling work; parts-catalog sites (easyparts.com, cmsnl.com) return HTTP 403 to both `WebFetch` and raw `curl`.
**What happened:** eBay listing pages also can't be curled directly, but the CDN image URLs eBay serves the actual product photos from (`i.ebayimg.com/images/g/...`) ARE directly curl-fetchable — no page load or auth needed for the image asset itself.
**Root cause:** Bot-detection on parts sites gates the HTML page, not the downstream CDN asset host — the two are different origins with different protection.
**Mitigation / pattern:** For any future real-part reference-photo harvest: navigate the listing page via the Browser pane (which renders past the bot-gate), collect `img.src` values matching the CDN host pattern from the live DOM, then `curl` those CDN URLs directly rather than retrying WebFetch/curl on the listing page itself.
**Promoted to:** This entry.
**Tags:** `discovery`, `tool-gotcha`

---

**Session:** sonn (xmaxed-carbon-cvt-realengine-reject)
**Date:** 2026-07-12
**Context:** Rebuilding a scooter engine's 3D cutaway from verified web-sourced dimensions (bore, stroke, valve sizes) after the client rejected a purely procedural build as "not remotely realistic."
**What happened:** A second, dimensionally-correct procedural rebuild (real bore/stroke, real port/flange positions, real internals) was rejected again — "still doesn't remotely look like an X-Max engine."
**Root cause:** Dimensional correctness and casting-language correctness are separate problems. An organic cast part's webbing, boss shapes, and surface texture cannot be parameterized from primitives no matter how accurate the underlying measurements are — only photo-matched modeling reproduces them.
**Mitigation / pattern:** Before committing to procedurally model any organic cast/machined real-world part (engine block, head, case), first ask "do I have a photograph of this specific part" — not just "do I have its dimensions." If no photo reference exists, either source one (see the eBay-CDN lesson above) or set client expectations that the result will read as a schematic, not a replica. Client set a standing product rule from this: the feature ships only when it passes a "does this read as the real part" bar, not a "are the numbers right" bar.
**Promoted to:** This entry.
**Tags:** `mistake`, `process-change`

---

### LL-2026-07-13-001 [mistake, process-change] — MLX memory leak from missing cache clear

**Session:** 2ecf (pipeline-forensic-audit-and-attribution-incident) · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-09

**Context:** M2's mlx-whisper daemon (`audio-tx-mlx.py`) found in a live memory emergency (69MB physical free) after ~58h uptime.

**What happened:** The daemon's per-file loop never called `mx.clear_cache()` after each `mlx_whisper.transcribe()`, so MLX's internal memory pool grew unbounded — 24GB footprint from an expected ~3-4GB baseline.

**Root cause:** MLX (Apple's array framework) does not automatically release its internal buffer cache between calls; this must be done explicitly per iteration for any long-running loop.

**Mitigation / pattern:** Any long-running mlx_whisper (or other MLX-based) processing loop must call `mx.clear_cache()` in a `finally:` block after every unit of work, not just on exit. Verified via direct before/after footprint measurement, not just "no more crashes" — the same daemon had been "fixed" once before by restart alone without addressing the root cause.

**Promoted to:** This entry.

**Tags:** `mistake`, `process-change`

**LL-2026-07-13-001 UPDATE (2026-07-17): the "~3-4GB baseline" this entry compares against was itself wrong.** Direct `top -l1 PhysMem` measurement (LL-2026-07-17-002) found whisper-large-v3-mlx's real active working set on the Studio is ~10-11GiB, not ~3-4GB — that figure captured resident model size only, not the full transcription-time footprint. Budget headroom accordingly; ~3-4GB is no longer a safe planning number for this daemon even with the cache-clear fix applied.

---

### LL-2026-07-13-002 [tool-gotcha] — Claude Code scheduled tasks require the app to stay resident

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-09

**Context:** Built a Claude Code *scheduled task* (`m2-overnight-safety-check`, every 20min) as an overnight memory-emergency safety net while Adrian slept with screen-sharing off.

**What happened:** It never fired once in ~9 hours — no `lastRunAt`, same "23 min" nextRunAt on recheck as at creation. The memory emergency recurred and was only caught by Adrian's own manual check-in.

**Root cause:** The scheduled-tasks feature appears to require the Claude Code app itself to remain resident/foregrounded to fire; it is not a true OS-level cron equivalent.

**Mitigation / pattern:** For anything that MUST run unattended overnight regardless of app state, use a real `launchd` agent (`StartInterval`, independent binary/script) — not a Claude Code scheduled task. Built `com.adrianvault.m2-mem-watchdog` as the replacement; confirmed working across multiple full overnight windows since.

**Promoted to:** This entry.

**Tags:** `tool-gotcha`, `process-change`

---

### LL-2026-07-13-003 [mistake, process-change] — launchd kills sustained daemons declared ProcessType Background

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-10

**Context:** M1's transcription shard was crash-looping every ~2.5 minutes for days, reprocessing the same handful of files with no visible error.

**What happened:** macOS's own unified log (`log show --predicate 'process == "launchd"'`) showed the true cause: `Successfully spawned python3[...] because inefficient` — launchd's efficiency governor was killing the process for violating its declared resource class. All FOUR transcription daemons fleet-wide (M2, M1, mini, i7-audio) had `ProcessType: Background` set in their plists — appropriate for a lightweight idle-friendly task, wrong for a sustained CPU/GPU transcription workload.

**Root cause:** `ProcessType: Background` + `Nice` in a launchd plist puts the process under macOS App Nap / efficiency throttling, which can periodically kill processes judged to be using resources inconsistently with that declared class.

**Mitigation / pattern:** Set `ProcessType: Standard` for any launchd-managed daemon doing sustained real compute (transcription, rendering, heavy CPU/GPU work). Diagnostic pattern worth keeping generally: when a process crash-loops with NO application-level error, check `log show` filtered to `process == "launchd"` for the actual spawn/kill reason before assuming a code bug.

**Promoted to:** This entry.

**Tags:** `mistake`, `discovery`, `process-change`

---

### LL-2026-07-13-004 [mistake, process-change] — Filename collision destroyed every WAV-source transcription job, silently, forever

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-12

**Context:** After fixing the ProcessType issue, M1 still crashed cleanly (no traceback) on one specific `.WAV` source file every cycle, right after finishing an unrelated file.

**What happened:** `node-cloud-pipeline.py`'s intermediate download path was `claim_key(stem) + ".wav"`. For any source file whose extension was `.WAV`/`.wav`, this intermediate path resolved to THE SOURCE'S OWN FILENAME on case-insensitive APFS — ffmpeg was told to write its output over the file it was still reading, and died instantly with no useful error surfaced to the pipeline's own logging. Every wav-source recording this pipeline had EVER attempted (an unknown but likely large fraction of the historic ffmpeg-fail skip list) had silently failed this exact way since the script's inception.

**Root cause:** Deriving an intermediate filename from the source stem without checking for collision against the source's own on-disk name, combined with case-insensitive filesystem semantics on macOS.

**Mitigation / pattern:** Give intermediate/derived files in any pipeline a suffix that cannot collide with a plausible source extension (used `.16k.wav`). More generally: when a "mysterious silent failure" only affects one file *type* consistently, suspect a naming/path collision before suspecting the file's content. Verified fix live: a Zoom-recorder seminar WAV completed end-to-end for the first time in this pipeline's history immediately after the fix deployed.

**Promoted to:** This entry.

**Tags:** `mistake`, `discovery`, `process-change`

---

### LL-2026-07-13-005 [mistake, process-change] — norm() stem-matching bug masked a fully-complete corpus behind infinite reprocessing

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-12

**Context:** A parallel CLI-team audit (codex + agy, independently) confirmed a bug already suspected from reading the pipeline source.

**What happened:** `norm(s) = re.sub(r'[\s_]+',' ', os.path.splitext(...)[0].strip()).lower()` called `.strip()` BEFORE the whitespace/underscore-collapse regex. A source file ending in `_` (e.g. `"...Monopolized_.mp3"`) produced a stem with a TRAILING SPACE (the trailing `_` becomes a space via the regex, applied after strip already ran). The uploaded transcript's filename, re-derived through the same function on read-back, had its OWN trailing space stripped at a different point in the sequence — the two derivations disagreed, `st in done` never matched, and the file was re-transcribed forever. This masked, for an unknown period, that the entire assigned corpus (`dropbox-ss:`, 17,904 files) was actually functionally complete.

**Root cause:** Order-of-operations bug: `.strip()` before a regex substitution that can itself introduce new leading/trailing whitespace, applied inconsistently between the "write" and "read-back" code paths.

**Mitigation / pattern:** Always apply `.strip()` AFTER any substitution that could introduce new boundary whitespace, and use the exact same normalization function (not a re-derivation) for both write and match paths wherever possible. General pattern worth keeping: when "we've done a huge amount of work but the completion percentage barely moves," check for a stem/key-matching bug before concluding the work estimate was simply wrong.

**Promoted to:** This entry.

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-13-006 [mistake, process-change] — done-state check must distinguish "unknown" from "empty"

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-12

**Context:** Same CLI-team audit as LL-005, found independently by both models.

**What happened:** `done_stems()` cached a "last-good" done-set, but on a genuinely FRESH process start where the very first gdrive listing call failed (network hiccup, auth lag), there was no last-good set to fall back to — the function returned an empty `set()`. The main loop treated an empty done-set as "nothing is done yet" and would begin re-transcribing the ENTIRE corpus, silently overwriting nothing (uploads are idempotent) but wasting massive compute, exactly when the node was already restarting frequently (a launchd-thrash situation, see LL-003) and therefore hitting this cold-start path often.

**Root cause:** Conflating "we have no data" with "the answer is empty" — a classic cache/fallback bug.

**Mitigation / pattern:** A done-state (or any authoritative "what's already complete" check) must be able to represent and signal UNKNOWN distinctly from EMPTY. On unknown, the caller should pause/retry, never proceed as if the answer were a known zero.

**Promoted to:** This entry.

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-13-007 [mistake] — Raw throughput/log-line counts are not a progress metric

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-12

**Context:** Repeatedly reported the fleet's throughput ("630 files/hour," "processed 9,000 more files") as evidence of progress across several status updates.

**What happened:** Adrian asked for the ETA to completion; reconciling against the true vault-wide backlog revealed net completions had barely moved despite enormous logged activity — the fleet was reprocessing a tiny set of already-done files at massive scale (M2 alone re-decoded its own ~1,545 files an average of 32x each). Confronted directly with "why are you letting this happen" — the honest answer was that raw activity metrics had substituted for the metric that actually mattered.

**Root cause:** Measuring "is it crashing" and "is the log growing" instead of "is the count of genuinely new, distinct completions increasing against the true target."

**Mitigation / pattern:** Any recurring status report on a processing pipeline must reconcile against a ground-truth target (here: unique stems in the done-state, checked against the actual corpus size) — not against the pipeline's own self-reported activity log. If asked for an ETA and the honest answer is "I can't give a reliable one without checking net-new vs. total," say that rather than extrapolate from an activity rate that might be mostly noise.

**Promoted to:** This entry.

**Tags:** `mistake`

---

### LL-2026-07-13-008 [mistake, process-change] — Folder-keyword matching is not scope verification (the attribution incident)

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-12/13

**Context:** Built a "subconscious surgery priority" processing manifest by matching folder-path keywords across the whole indexed corpus, per Adrian's instruction to prioritize his SS long-form teaching content overnight.

**What happened:** The keyword match swept in, across the same night, third-party voice content under two different people's named folders (13 files: "Josh podcast," "Josh speech zurich"), then — after Adrian's first, furious correction — a systematic re-scan (prompted only by his SECOND, more furious message about the pattern repeating) found five MORE named-person folders (16 more files: Ken, Alan, Naomie, two Helen folders, "Croner-Mark Russell") that a spot-check would have missed. One additional file in an unverifiable folder ("Rugby") was pulled proactively without a specific complaint about it, on the reasoning that a second wrong guess in the same breath was unacceptable.

**Root cause:** Treating "the folder path contains my search keyword" as sufficient grounds for inclusion in a live processing queue, rather than as mere candidacy pending verification. Compounded by responding to the FIRST correction with a narrow, item-specific fix instead of immediately generalizing to "what ELSE does this same blind spot affect."

**Mitigation / pattern:** New standing default: exclude-by-default for any auto-built processing list; a candidate only earns inclusion after passing explicit checks (named-third-party folder scan done systematically across the WHOLE list, not spot-checked; cross-reference against any existing attribution/diarization data with real coverage awareness; technical processability check — see LL-009). When any correction reveals a *pattern* rather than an isolated miss, immediately re-scan the entire remaining list against that pattern in the same turn, not just the specific flagged item. Full protocol written up at `canonical/concepts/content-scope-verification-before-processing.md` (new canonical file, this shutdown).

**Promoted to:** [content-scope-verification-before-processing.md](content-scope-verification-before-processing.md)

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-13-009 [discovery, process-change] — Cheap technical probe (audio-stream presence) prevents burning fleet time on unprocessable files at scale

**Session:** 2ecf · **Archive:** [raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md](../../raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md)
**Date:** 2026-07-13

**Context:** A stall-detector (armed earlier the same night, alerting if net-new completions froze for ~90 minutes while the queue was non-empty) fired correctly during the priority night-run.

**What happened:** Investigated rather than dismissed: both active nodes were burning through a large batch (456 of 740 files, 62%) of GUID-named files under a folder called "subconscious Assassin" (an account/brand name that had matched the "subcon" keyword, not actual teaching content) that were instant-failing ffmpeg. A single diagnostic download + `ffmpeg -i` on one sample proved the root cause immediately: **the source files contain no audio stream at all** ("Output file does not contain any stream") — silent auto-synced phone-camera clips. Removed all 456 with hard technical proof (not a judgment call), and real progress resumed within the same check.

**Root cause (of why this wasn't caught earlier):** The manifest-building step never checked whether a candidate file was even technically capable of producing a transcript before adding it to the queue; the pipeline only discovered "no audio" per-file, live, after a full download.

**Mitigation / pattern:** For any newly-built processing list at meaningful scale (100+ files), run a cheap technical-processability probe (`ffprobe`/`ffmpeg -i` for audio-stream presence, or the equivalent for the content type) BEFORE installing the list on live nodes — not as a per-file discovery during a live run. This is now folded into the standing scope-verification protocol (LL-008) as check #1 (cheapest, run first). Separately: the stall-detector itself worked exactly as designed here — a good pattern to keep using (alert on the true stall condition — net-new frozen while queue non-empty — then investigate before dismissing as noise).

**Promoted to:** [content-scope-verification-before-processing.md](content-scope-verification-before-processing.md)

**Tags:** `discovery`, `process-change`

---

### LL-2026-07-14-001 [discovery, tool-gotcha, process-change] — MLX Metal cache growth measured wrong, and a live daemon script drifted with zero trail

**Session:** b3fc · **Archive:** [raw/sessions/2026-07-14-1029-m2-audio-mlx-leak-refix-and-file-drift.md](../../raw/sessions/2026-07-14-1029-m2-audio-mlx-leak-refix-and-file-drift.md)
**Date:** 2026-07-14

**Context:** Asked to find and fix the confirmed memory leak in `/Users/subconm2/audio-tx-mlx.py` (the mlx-whisper daemon) — same leak documented in session 2ecf's 2026-07-13 fix.

**What happened:** Three findings worth keeping. (1) `ps -o rss=` reported 377MB on the daemon while `vmmap -summary | grep "Physical footprint"` reported 4.7GB on the SAME process at the SAME instant — RSS badly undercounts MLX/Metal-backed memory on Apple Silicon; use physical footprint (what Activity Monitor shows) for any GPU-memory investigation on this hardware. (2) A first verification attempt using files with repeated/similar durations showed no leak (false negative) — MLX's buffer cache is keyed by array shape, so repeated shapes just hit the cache with zero growth; reproducing this class of leak requires many files with genuinely distinct durations, matching real-world recording variability. (3) The live file had already been fixed once (session 2ecf, 2026-07-13) but had regressed to the pre-fix version by this session's start, then changed AGAIN (to a fuller, still-correct version) after this session's own re-fix — with no lease, no git history, and no NODE-STATUS/INTENT.md/m2-state.md entry naming either change. Outcome was benign (final state is correct), but the mechanism is unknown.

**Root cause:** (1)/(2) are measurement-methodology gaps, not caused by any prior mistake. (3) is a structural gap — `audio-tx-mlx.py` and its siblings are machine-local scripts outside the vault's version control and outside the Dispatcher lease system, so nothing records who changes them or when, unlike canonical/ writes.

**Mitigation / pattern:** Use `vmmap -summary <pid>` physical footprint (not `ps` RSS) for MLX/Metal memory investigations on Apple Silicon. Use widely-varied, non-repeating input sizes when reproducing shape-keyed cache growth. `mx.clear_cache()` in a `finally:` block after each inference call is the standard fix. For the drift gap: flagged as Secretary action `m2-local-script-drift-detection` for Adrian's judgment call (git-track local daemon scripts, or at minimum log a content hash on daemon startup) rather than building a fix unilaterally.

**Promoted to:** Secretary actions `m2-audio-file-drift-investigate`, `m2-local-script-drift-detection` (no new canonical safeguard file yet — awaiting Adrian's scope decision).

**Tags:** `discovery`, `tool-gotcha`, `process-change`

---

### LL-2026-07-15-001 [mistake, discovery, process-change] — Stale manifest silently degraded to unscoped self-listing, swept legally-sensitive third-party archive content into the general Transcripts store

**Session:** 2ecf (continued) · **Date:** 2026-07-15

**Context:** A hardcoded LAN IP for mini (`192.168.1.48`) in M1's ss-night-refresh.sh and its SSH config went stale after a DHCP renewal (real IP became `.12`), silently breaking the manifest-freshness touch loop. Both M1 and mini hit `MANIFEST_MAX_AGE` at various points overnight and fell through to `node-cloud-pipeline.py`'s self-listing fallback (`REMOTES=["dropbox-ss:"]`), which has zero attribution/scope awareness.

**What happened:** Self-listing found and transcribed raw audio files whose content had already been identified as `firewall_class: strictly-private-legal-personal` (participants named, part of the Tristan/Stefi legal archive — see [[tristan-stefi-legal-archive]]) by a separate, dedicated extraction project back in May — but the raw source files themselves were never removed or skip-listed at the general-corpus level, so a generic scan stumbled onto them independently of that protected workflow. Confirmed 5 such files transcribed into the shared `gdrive:Transcripts` store, plus 1 unrelated third-party interview clip ("dasha", a participant in someone else's recorded training session) and 1 benign personal recording (no action needed). Caught only because Adrian explicitly pushed back on treating the ~1000 raw completion-log lines as "too many to audit" — a diff-based approach (before/after transcript-store snapshot, minus known-legitimate manifest stems) cut the real audit surface from a misleading ~1000 to an exact, tractable 7.

**Root cause:** Two independent bugs compounded: (1) the stale-IP DHCP-drift bug (M1's ssh config never got the DHCP-resilient Bonjour-hostname treatment that i7/Studio already had), and (2) a design flaw where `node-cloud-pipeline.py` treated "manifest explicitly configured but temporarily unreadable" the same as "no manifest was ever configured" — degrading a deliberately scoped run into an unscoped one instead of just waiting.

**Mitigation / pattern:** (1) Fixed the SSH config to use `Adrians-Mac-mini.local` (AddressFamily inet, matching the established i7/Studio pattern) instead of a raw IP, with a `.local`-independent LAN fallback alias for symmetry — repointed `ss-night-refresh.sh` at the alias. (2) Patched `node-cloud-pipeline.py`: when `MANIFEST_FILE` is set, the node now waits indefinitely (with logging) rather than ever falling through to self-listing — self-listing only fires when no manifest was ever configured at all. Deployed + md5-verified to M1 and mini (i7 pending its reconnect). (3) Quarantined the 6 real files to `gdrive:Transcripts/_QUARANTINE-attribution/` and hard-skip-listed their specific stems on both nodes. (4) **The raw source files for the 5 legal-archive stems are still sitting unprotected somewhere in the general corpus** — their location wasn't pinned down (would need a slow full-`dropbox-ss:` recursive search); flagged as an open Secretary item, not resolved.

**Promoted to:** New/updated canonical guidance recommended: extend [[content-scope-verification-before-processing]] to cover "manifest-scoped runs must never silently widen scope on failure" as a named check, not just folder-name attribution. Secretary action `find-and-protect-tristan-archive-raw-files` (locate + skip-list the actual raw audio source paths, not just the derived transcript stems).

**Tags:** `mistake`, `discovery`, `process-change`

---

## 2026-07-15 — M2 session lessons (Spanda site build-out + the recurring theashtaproject.com outage)

### LL-2026-07-15-001 ⭐ theashtaproject.com kept 404ing — root cause + PERMANENT fix (paid for in an investor meeting)
**Symptom:** theashtaproject.com (Ashta static marketing site) went down 3+ times, each a Vercel platform `404 / x-vercel-error: NOT_FOUND`.
**Root cause:** the site is a **CLI-deployed Vercel project (`theashtaproject`, sub-con) with NO git connection AND "Auto-assign production domains" ON.** Vercel auto-aliases the newest `--prod` deployment to the custom domain. So **any** `--prod` deploy — including empty/incomplete "site-draft" builds landing ~every 2 min from some other session/agent — instantly steals theashtaproject.com from the real full-content deployment. Re-aliasing only treats the symptom; the next empty deploy re-hijacks.
**PERMANENT FIX (do these so it never recurs):**
1. **Turn OFF "Automatically assign production domains"** on the `theashtaproject` project (Vercel dashboard → Settings → Domains). One toggle → an explicit alias becomes permanent and stray `--prod` drafts can't take the domain. (⚠️ M2's Vercel token is **"Not authorized"** for this via API — needs M1 or Adrian in the dashboard.)
2. **Stop the source** deploying empties to `theashtaproject` (a runaway session/agent — NOT on M2 or M1 per ps/cron/launchd checks; likely a redundant "rebuild static site" task, an Antigravity/IDE session, or another window).
3. **Connect the site to git** (production branch) so only branch pushes deploy to production; CLI drafts go to preview and can't take the domain. Source was recovered to git this session at `~/ashta-site-recover` (was CLI-only, no source-of-truth — a compounding fragility now closed; tarball in `working/_m2-staging/2026-07-14-ashta-site-recovered-source/`).

### LL-2026-07-15-002 Diagnose Vercel 403-bot-challenge vs real 404-hijack (don't confuse them)
A `curl` health-check can't tell a real outage from Vercel's bot-mitigation. **Real hijack = HTTP 404 + `x-vercel-error: NOT_FOUND`.** **Bot-challenge = HTTP 403 + `x-vercel-mitigated: challenge`** — real browsers solve the JS challenge in ~1s and load the site fine; only automated clients (curl) get the 403. My first watchdog treated the 403 as an outage and thrashed (re-aliasing pointlessly, likely feeding the mitigation). **Fix:** a health-check/watchdog must key off the header signature (`x-vercel-error: NOT_FOUND`), not the status code alone. Verify "is it really down?" with a REAL browser (browser pane solves the challenge), not curl.

### LL-2026-07-15-003 `vercel --prod` HANGS on the theashtaproject project — use --prebuilt
The `theashtaproject` project's remote Build Command is `npm run build`, but it's a static dir with no package.json → the build container stalls forever in "Building…". Deploy static there with **`--prebuilt`** (`.vercel/output/static/` + `.vercel/output/config.json '{"version":3}'` + `vercel deploy --prebuilt --prod`). Documented in the recovered source's `DEPLOY.md`.

### LL-2026-07-15-004 M2 Vercel token scope is limited — coordinate the rest with M1/Adrian
M2's Vercel token can `alias set` / `deploy` / `remove` — but returns **`403 Not authorized`** for `PATCH project` (settings incl. autoAssignCustomDomains) and `POST /projects` (create). So the clean permanent fixes (disable auto-assign, move domain to a fresh project) are NOT in M2's power — escalate to M1 (fuller rights) or Adrian (dashboard).

### LL-2026-07-15-005 CLI-team delegation model that worked (token-saving, high quality)
Built the entire Spanda public site (landing + GEO/SEO + viral loop) by: M2 writes a tight spec (judgment) → **codex (CLI team, $0) builds** to spec in an isolated worktree (labor) → M2 firewall-audits + runs the real dual-mode build + deploys (gates). Efficient + quality held. **Gotcha:** codex's sandbox blocks `fonts.googleapis.com`, so its `next build` "fails" on the font fetch — NOT a code error; re-run the build on M2 (network available) to actually confirm. Recon delegated to sub-agents likewise.

### LL-2026-07-15-006 Honest-science framing is the GROWTH UNLOCK, not a tax (+ 2 firewall catches)
Research-with-the-team consensus (grok live-web + codex + agy): the "hypotheses under test, never proven" framing is the *permission structure* that makes spooky-coincidence content safe to share AND safe for AI engines to cite without flagging pseudoscience. Two catches M2 made adjudicating the team: agy's chance baseline was **wrong (20%); correct = 25%** (circle of 5 = 1-in-4); and a proposed live-p-value "highly significant → proof" dashboard would trip optional-stopping + overclaiming — killed it. Hit-share was made structurally safe: `hitShareText(hits, trials)` takes ONLY numbers, so a friend's name/avatar **cannot** be passed into a public share.

### LL-2026-07-15-007 SMB mount flakiness → deliver via SSH; NODE-STATUS concurrent-window race
The M2→vault SMB mount degrades intermittently (hangs, "operation not permitted", empty ls, and it breaks vault-relative script paths like `tools/council-ask.sh`). When degraded, deliver to the vault via **SSH/scp to m1max** (reliable) — never fall back to the quarantined iCloud copy. Also: the NODE-STATUS M2 pane has **concurrent-window write races** (another M2 window updates its timestamp) — anchor inserts on a unique *current* line and verify; I once mis-inserted into the M1 pane (fixed by restoring M1's line).

**LL-2026-07-15-001/002 CORRECTION (M1-verified 12:20 WITA):** the *outages were real* (empty --prod deploys did hijack the domain) and the root-cause mechanism holds — BUT the perceived "active recurrence ~every 2 min" was **over-read**. M1's 3-way check (vercel ls = no deploys in 13h; real-browser pass; clean process sweep on M1 too) shows no live source; the churn was M2's own watchdog re-aliasing + the 403 bot-challenge + last night's recovery pushes. **Meta-lesson: before declaring an "active attack," verify with (a) actual deploy timestamps `vercel ls`/`inspect` and (b) a real browser — NOT a curl loop that can't distinguish bot-challenge from hijack, and whose own re-alias actions can masquerade as recurrence in its log.** Watchdog stood down; domain stable on dn4fsasrm.

---

### LL-2026-07-15-002 [mistake, discovery, process-change] — A second, independent legal-archive exposure found via a whole separate "bridge" pipeline nobody had audited

**Session:** 2ecf (continued) · **Date:** 2026-07-15

**Context:** Adrian asked for a complete audit of "everything to do with the pipeline" after a day of finding overlapping systems. The audit surfaced a THIRD pipeline system (`m1-dispatcher.py` -> `m2-cloud-bridge.py` -> M2's `audio-tx-mlx.py` -> `overnight-collect.py`) running since 8:36am, built on a stale premise ("M2 has no internet, stranded on a dead router") that no longer holds — M2 has had direct internet all day.

**What happened:** `m1-dispatcher.py` scans `~/Documents` (among other local roots) for local files to feed M2. Its own `SKIP_PATH` list already excluded `'stefi'` (presumably from a past incident) but had never had `'tristan'` added, despite both being the same legal-archive project ([[tristan-stefi-legal-archive]]). The raw WhatsApp export lives unprotected at `~/Documents/Tristan hamm/` on M1 — completely outside the vault's own protected folder, so the vault-path skip (`'Adrian-Vault'`) never applied to it either. Result: **122 legal-archive audio files were transcribed** by this bridge (confirmed via the durable done-file), and **117 of those had already landed in the shared `gdrive:Transcripts` store** — a materially larger exposure than the same-day morning incident (LL-2026-07-15-001, 5 files via a different code path: the OTHER pipeline's self-listing fallback). A `_QUARANTINE-attribution` folder already existed inside `working/deep-extraction/subcm-video-transcripts/` from some **prior, unlogged** session that had already caught part of this — confirming the raw source was a known-recurring risk that was never fixed at the source.

**Root cause:** Two independent scanning systems (node-cloud-pipeline's self-list fallback, and this separate m1-dispatcher/bridge system) both eventually discover a sensitive raw source folder that sits in a completely ordinary, unprotected location (`~/Documents/<person's name>/`), because protection was only ever applied to the *derived* artifacts inside the vault's own project folder, never to the *source*. A stem-based skip-list (added reactively, one incident at a time) will always be one step behind a new scanner finding the same folder a new way.

**Mitigation / pattern:** (1) Stopped and quarantined immediately: bridge trio bootout'd, `node-aud-in`'s 122 matching files physically moved to a quarantine folder, all 117 already-landed transcripts moved to `gdrive:Transcripts/_QUARANTINE-attribution/`, all 122 stems added to both fleet nodes' skip-lists. (2) Added `'tristan'` to `m1-dispatcher.py`'s `SKIP_PATH`/mirrors the existing `'stefi'` entry. (3) Given the stale network premise, **permanently disabled** (renamed, not deleted) the entire m1-dispatcher/m2-cloud-bridge/overnight-collect trio rather than just patch-and-restart it — it duplicates what the main `node-cloud-pipeline.py` fleet already does, with weaker scope controls. (4) **Not yet done: the raw `~/Documents/Tristan hamm/` folder itself is still sitting in a generically-scanned location** — recommended to Adrian that it (and any equivalent Stefi/Michelle/Emily raw folders, not yet located) be physically relocated out of any scannable root, since a stem-based skip-list only protects files already discovered once, not the next new scanner.

**Promoted to:** Secretary action `relocate-legal-archive-raw-folders` (Adrian decision — moving personal file organization, not something to do unilaterally). This is the second entry in one day on the same underlying gap — recommend this becomes the canonical example in [[content-scope-verification-before-processing]] for "protect the source, not just the derived output."

**Tags:** `mistake`, `discovery`, `process-change`

---

### LL-2026-07-16-001 [mistake, process-change] — `launchctl bootout` alone doesn't permanently disable a job; renaming the plist does

**Session:** 2ecf (continued) · **Date:** 2026-07-16 (just past midnight)

**Context:** LL-2026-07-15's midday incident (old `com.adrianvault.cloud-manifest` generator overwrote the priority manifest with a 17,904-file dump) was fixed at the time with `launchctl bootout` only. i7's manifest was later found re-corrupted to the same exact dump, cause unlisted as "unknown" in that entry.

**What happened:** The job reloaded itself at some point after the bootout (exact trigger not identified — plausibly a login/reload event; `bootout` unloads from the current session but does not remove the plist, so anything that re-registers LaunchAgents brings it straight back). `launchctl list` confirmed it loaded again hours later. Its own script (`cloud-manifest.py`) directly `scp`s its output to `i7:/Users/admin/cloud-manifest.tsv` on every run — independent of `ss-night-refresh.sh`, which had been the only suspect considered. This fully explains the "unknown" re-corruption.

**Root cause:** Inconsistent disable method within the same session — the bridge trio (`m1-dispatcher`/`m2-cloud-bridge`/`overnight-collect`) were correctly disabled by renaming their plists (survives reload), but `cloud-manifest` was only `bootout`'d (does not survive reload). Same mistake class, different rigor applied without a clear reason.

**Mitigation / pattern:** Renamed the plist (`.disabled-20260716-...` suffix, matching the established convention) so it cannot silently reload. **Going forward: `launchctl bootout` is for an immediate stop only; a job being retired for cause always gets its plist renamed in the same action, never bootout alone** — this session's own bridge-trio fix already knew this, it just wasn't applied uniformly. All 3 fleet manifests reverified correct (128 lines) after the fix.

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-16-002 [mistake, discovery, process-change] — A 13,953-entry skip-list with single-character entries was silently blocking 97% of any manifest

**Session:** 2ecf (continued) · **Date:** 2026-07-16 morning

**Context:** Morning check found the SS-talks priority manifest completion count frozen at 15/128 despite all 3 fleet nodes running healthy, all night, on the correct manifest. The pipeline's own internal `todo` count showed only 8 remaining — a 105-file gap against reality that needed explaining, not just reporting.

**What happened:** `.node-pipeline-skip.txt` (accumulated across many sessions/days as a "known-empty/junk file" list) had grown to 13,953 entries. `skip()` does a raw substring match (`s in stem`, not exact/word-boundary). At least 19 entries were single characters or two-letter fragments (`"1"`, `"2"`, `"3"`, `"7"`, `"8"`, `"9"`, `"99"`, `"yo"`, `"yo-2"`, `"yo-3"`, `"eft"`, `"aha"`, `"abl"`, `"able"`, `"hack"`, `"sbr"`, `"32.5"`, `"80%"`, `"ety"`) — these matched almost any filename containing that digit/fragment anywhere (e.g. `vid_20161026_092928` skipped because it contains "8"; `challeng your reality` skipped because it contains "yo" inside "y-o-ur"). Verified: **125 of 128 manifest files were being silently skipped** — not done, not failing, just invisible to the pipeline. Beyond the single-character entries, ~105 more matches came from a second, harder problem: many legitimately-different personal audio clips share short generic names ("power pose", "rainbow", "theta", "empathic") with unrelated files that were skip-listed for different reasons previously — real name collisions, not typos.

**Root cause:** An accumulated safety mechanism (skip known-bad files one at a time, forever) combined with substring matching degrades badly at scale — every new short/generic addition is a small amount of added risk, but the risk compounds silently until, in aggregate, it can block almost everything. Nothing here was a single bad decision; it was many individually-reasonable one-off additions compounding into a systemic failure with no one positioned to notice the aggregate effect.

**Mitigation / pattern:** For this run: deployed a minimal, purpose-built skip-list (just today's specific legal-archive safety exclusions, 128 entries, zero false matches against the curated manifest) to all 3 nodes instead of the accumulated 13,953-entry list — verified zero false matches, confirmed real throughput resumed immediately (`todo` jumped 8→119 on all 3 nodes within the same restart cycle). Original list backed up, not deleted, on all 3 nodes (`.bak-20260716-full...`). **Not yet done, flagged for a real decision:** the master 13,953-entry list itself still has this substring-fragility for ANY future self-listed/broad run — it needs either (a) a minimum-length + word-boundary matching fix to `skip()`, or (b) a one-time audit-and-clean of the accumulated list. This has likely been silently suppressing throughput on more than just tonight's run — worth asking whether historical "why is this so slow" questions trace back to this.

**Promoted to:** Secretary action `fix-skip-list-substring-matching` (code fix: minimum length + word-boundary check in `skip()`) and `audit-clean-full-skip-list` (one-time cleanup of the 13,953-entry accumulated list) — both for Adrian's prioritization, not urgent tonight since the targeted workaround is live and verified.

**Tags:** `mistake`, `discovery`, `process-change`

---

### LL-2026-07-17-001 [mistake, process-change] — Don't patch a memory-safety watchdog's metric on one favorable idle-state reading; test against real active load first

**Session:** e04c · **Date:** 2026-07-17

**Context:** `com.adrianvault.m2-mem-watchdog` was force-restarting `com.adrianvault.m2-audio` (the Studio's local mlx_whisper daemon) every ~120s, so it never completed a single transcription. The watchdog's `free_mb()` used raw `vm_stat "Pages free"`, and its own log showed continuous 56-115MB readings.

**What happened:** Cross-checked with `top -l1 PhysMem`, which read ~11GiB genuinely unused at that one moment (right after stopping the daemon). Concluded — by analogy to an already-documented "inactive-page illusion" pattern on the i7 node — that the watchdog's metric was unreliable, and patched `free_mb()` to parse `top -l1 PhysMem unused` instead. Verified the patched function in isolation (returned ~11264MB, matching `top`) and restarted the daemon. **It kept crash-looping identically.** Checked `top -l1` again, live, mid-loop: `PhysMem: 31G used ... 283M unused` — a real, severe squeeze, on the exact metric just called "reliable." The 11GiB reading had been real but momentary (the window right after stopping the daemon, before it reloaded); the instant the model actually loads, real memory genuinely collapses.

**Root cause:** A single idle-state snapshot was treated as proof the watchdog's trigger condition never fires validly, without testing the fix against an actual active-load spike — the one scenario the watchdog exists to catch.

**Mitigation / pattern:** Reverted the patch (diff-verified clean against `.bak-20260717-freefix`) — the original `vm_stat`-based logic was correct all along. **Before "fixing" any memory/resource-pressure check as a false positive, force the condition it's supposed to catch (start the actual resource-heavy process) and re-measure under that load, not just at rest.** A watchdog reading low continuously for 28+ minutes across many independent samples is much stronger evidence than one favorable reading is counter-evidence.

**Promoted to:** Secretary action `studio-memory-headroom-for-m2-audio` (Adrian: free up real headroom before re-enabling local transcription).

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-17-002 [discovery] — whisper-large-v3-mlx's real active memory footprint on the Studio is ~10-11GiB, not the ~3-4GB previously documented

**Session:** e04c · **Date:** 2026-07-17

**Context:** Prior memory (`node-cloud-pipeline-tuning`) documented `mlx-community/whisper-large-v3-mlx` as "~3-4GB resident/stream." Debugging the crash-loop above required knowing the real number.

**What happened:** Directly measured, twice, via `top -l1 PhysMem`: idle (daemon stopped) ~11GiB unused; within seconds of the daemon actually loading the model and starting transcription, ~280-300MB unused — a genuine ~10-11GiB delta, not model-loading overhead alone (audio decode buffers + Metal command buffers under MLX's unified-memory architecture likely account for the gap beyond static model-weight size).

**Root cause:** The original ~3-4GB figure likely captured resident model size only, not the full active working set during real transcription.

**Mitigation / pattern:** When planning headroom for local mlx_whisper runs on the Studio, budget ~10-11GiB active, not ~3-4GB — and remember the Studio also frequently carries ~20GiB+ baseline from Claude Desktop/Chrome/CLI processes, so 8-11GiB "free" at rest is not sufficient evidence of safe headroom for an active run.

**Promoted to:** Secretary action `studio-memory-headroom-for-m2-audio`.

**Tags:** `discovery`

---

### LL-2026-07-17-003 [discovery, process-change] — A shared manifest going silently stale past its own safety window blocks the entire fleet behind a calm-looking log line

**Session:** e04c · **Date:** 2026-07-17

**Context:** `supervisor4` (an earlier session's fleet supervisor) self-terminated on schedule at 08:38 after its last manifest refresh. `node-cloud-pipeline.py`'s `MANIFEST_MAX_AGE=2h` gate deliberately refuses to self-list once the shared `cloud-manifest.tsv` ages past 2 hours (a genuinely correct safety design — "waiting forever is always safer than widening scope").

**What happened:** Nothing refreshed the manifest after 08:38. By ~10:38 it crossed the 2h threshold; M1, mini, and i7 all correctly began logging `manifest not ready — waiting (N)` every ~60-120s and produced zero output for 1.5-3.5 hours before this session noticed. The log line reads calm/routine, not alarming, so it's easy to mistake "waiting" for "still working."

**Root cause:** Manifest freshness was an implicit responsibility of whichever supervisor happened to be running, not an explicit, continuously-covered one — when that supervisor's window ended, the responsibility silently lapsed with it.

**Mitigation / pattern:** `touch`ing the identical manifest (same content, zero scope change) immediately unblocked all 3 nodes within one poll cycle. Any future fleet supervisor should treat manifest-freshness refresh as a standing, explicit responsibility with its own cycle well under `MANIFEST_MAX_AGE` (this session's `fleet-supervisor-2026-07-17.sh` refreshes every 20min against the 2h ceiling) — and "manifest not ready — waiting" in a log should be treated as a P1 signal to check freshness immediately, not background noise.

**Promoted to:** Secretary action `pipeline-manifest-scope-decision-2026-07-17`.

**Tags:** `discovery`, `process-change`

---

### LL-2026-07-17-004 [tool-gotcha] — `launchctl kickstart -k` fails on a job that was fully `bootout`'d; use `bootstrap` to reload it

**Session:** e04c · **Date:** 2026-07-17

**Context:** A hand-written fleet supervisor script tried to restart `com.adrianvault.m2-audio` via `launchctl kickstart -k gui/<uid>/<label>` after the job had earlier been stopped via `launchctl bootout`.

**What happened:** `kickstart -k` returned `Could not find service "com.adrianvault.m2-audio" in domain for user gui: 501` — silently doing nothing, not restarting the daemon. `bootout` fully unloads a job from launchd's domain (not just stops the process); `kickstart` only works on an already-loaded job. Needed `launchctl bootstrap gui/<uid> <plist-path>` instead, which loads AND starts it.

**Root cause:** `kickstart` and `bootout`/`bootstrap` operate at different levels (running-state vs domain-membership) and the failure mode is silent (a clean exit-code-nonzero, easy to miss in a background loop's log).

**Mitigation / pattern:** Any script that both stops (`bootout`) and later conditionally restarts a launchd job should attempt `kickstart -k` first and fall back to `bootstrap` on failure (`cmd1 || cmd2`), rather than assuming one command covers both cases.

**Promoted to:** none (a code-level fix within this session's own `fleet-supervisor-2026-07-17.sh`, not a canonical process needing separate Secretary tracking).

**Tags:** `tool-gotcha`

**LL-2026-07-15-001 UPDATE (2026-07-16): the hijack did NOT stop.** M1's 07-15 "no deploys in 13h" read went stale — two more empty `--prod` deploys landed 07-16 (`c5eko2af5` ~4h, `9qd92hqb7` ~7h), genuine 404/NOT_FOUND hijacks. Source is intermittent-but-active (~every few hours), still unlocatable on M2/M1 (guess: stuck Antigravity/IDE agent or another machine). **HANDED TO M1** (Adrian: "shutdown + hand over to M1, I'll get M1 to fix it") — M1 to flip auto-assign-off (its CLI may have scope M2's API token lacks: 403) and/or kill the source and/or git-connect the site. Watchdog whack-a-mole is NOT a fix; do the toggle. Handover: `_claude-bridge/m2-to-m1-2026-07-16-theashtaproject-HANDOVER-M1-OWNS-FIX.md`.

---

### LL-2026-07-19-001 [tool-gotcha] — `git checkout <branch>` silently carries uncommitted working-directory changes across branches when there's no file conflict

**Session:** 9eb88d20 · **Date:** 2026-07-19

**Context:** Executing the SS Mastermind page rebuild (`~/Documents/localhost/subconscious-surgery-next`), which had substantial unrelated uncommitted WIP already on the checked-out branch (`feat/kajabi-enrollment-webhook`). After stashing it, pulling the mastermind files, committing on a new branch, and switching back to restore the Kajabi WIP, a second `checkout` (to inspect the mastermind branch for a push attempt) carried the just-restored Kajabi dirty files onto the mastermind branch's working directory.

**What happened:** `git checkout` is not a stash-forcing operation. It only blocks a checkout (forcing a stash/commit first) when the *target branch's own commit history* actually conflicts with the dirty files. If the dirty files are untouched by that branch's history, they come along silently — the working directory's uncommitted state effectively "follows" you across branches whenever there's no collision. This happened twice in the same session before being correctly diagnosed.

**Root cause:** Mental model mismatch — `checkout` is commonly assumed to snapshot/isolate working-directory state per branch, but it only guards against *conflicting* changes, not all changes.

**Mitigation / pattern:** When working across branches with uncommitted WIP present, always run `git stash push -u` → `checkout` → `stash pop` as one atomic sequence, then avoid further branch-switching for inspection purposes. Use `git log <branch> -1 --stat` and `git show <branch>:<path>` to inspect a branch's content without re-checking it out. Always include `-u` on the stash (an earlier sub-attempt this same session omitted it and left new untracked files exposed during a "clean base" test).

**Promoted to:** none (general git knowledge, not a vault-specific process — logged here as the forward-readable reference).

**Tags:** `tool-gotcha`

---

### LL-2026-07-19-002 [discovery] — `cli-ask.sh` grok-inline delivery can silently truncate a payload well below its own documented 40000-byte threshold

**Session:** 9eb88d20 · **Date:** 2026-07-19

**Context:** `/Users/subconm2/pipeline-refresh-2026-07-17/classify_catchup.py` on Studio had silently stalled for ~23 hours, calling `cli-ask.sh grok --stdin` per batch.

**What happened:** The script's batch payloads were being silently truncated by grok's inline-delivery path even though they sat below `CLI_ASK_GROK_INLINE_MAX`'s documented 40000-byte default (see `cli-ask-grok-large-payload-fix.md`, which fixed the >40KB case via a file-read idiom). Forcing `CLI_ASK_GROK_INLINE_MAX=1000` in this script's own subprocess env resolved it immediately — verified live, 2975 records classified cleanly in the resumed run.

**Root cause:** Not fully diagnosed. The 40000-byte default appears to be unsafe for at least this payload shape (JSON-heavy batch classification prompts), suggesting the safe threshold depends on payload *structure*, not just raw byte count — but this was not confirmed against other callers.

**Mitigation / pattern:** The scoped fix (forcing the env var down for this one script) is deployed and verified. The vault-wide default is NOT yet re-validated — flagged as an open Secretary action (`cli-ask-grok-inline-threshold-review`) for a dedicated investigation rather than force-changing the shared default on this session's evidence alone.

**Promoted to:** Secretary action `cli-ask-grok-inline-threshold-review` (open, owner: claude-next-session).

**Tags:** `discovery`

---

### LL-2026-07-19-003 [process-change] — standing `manifest-keepalive` LaunchAgent retires the recurring silent-stale-manifest catch (LL-2026-07-17-003)

**Session:** 9eb88d20 · **Date:** 2026-07-19

**Context:** During the 2026-07-18→19 12h overnight grind, the LL-2026-07-17-003 "silent stale manifest" pattern recurred roughly every 2 hours on M1 (cycles 6/11/16/21) and i7 (cycles 14/19) — each time caught manually by the supervisory loop and fixed with a no-op `touch`.

**What happened:** The prior session's ad-hoc `fleet-supervisor-2026-07-17.sh` fix was scoped to that one session and did not survive as a standing process — the same gap (no continuous, explicit owner of manifest freshness) reappeared the next night exactly as LL-2026-07-17-003 predicted it would without one.

**Root cause:** Manifest freshness had no dedicated, persistent owner — it depended on whichever ad-hoc script or supervisory loop happened to be running at the time.

**Mitigation / pattern:** Built `tools/pipeline/manifest-keepalive.sh` (touches M1's local manifest + ssh-touches i7 and mini's copies every invocation) wired to `~/Library/LaunchAgents/com.adrianvault.manifest-keepalive.plist` (StartInterval 900s, RunAtLoad true, survives reboot/session-end). This is a genuinely standing fix, not another session-scoped catch — confirmed running post-install with clean exit status between cycles.

**Promoted to:** none further needed — the LaunchAgent itself is the promoted artifact; this entry closes the loop LL-2026-07-17-003 opened.

**Tags:** `process-change`

---

### LL-2026-07-19-004 [mistake] — `open-actions.md` regeneration silently broken since ~2026-07-15 by unannounced schema drift in `action-register.ndjson`

**Session:** 9eb88d20 · **Date:** 2026-07-19

**Context:** Executing this session's own Secretary step (shutdown protocol Step 3), appending new action entries and running `working/_secretary/.regenerate-open-actions.py`.

**What happened:** The script crashed with `KeyError: 'action_id'`. Investigation showed the register's original/canonical schema (`event`/`action_id`/`ts`/`title`/`context`, 8-char hex ids) had silently drifted, starting around 2026-07-15, to a different ad-hoc shape (`id`/`status`/`created`/`summary`/`tags`, slug-style ids) used by several subsequent sessions without anyone updating the regen script or noticing the crash. `open-actions.md`'s own header confirms this: last successful generation 2026-07-13, and even that run flagged itself as an incomplete "incremental append," not a full rebuild. Net effect: the Secretary's action register — the exact mechanism the Shutdown Protocol's hard rule #2 exists to protect ("NEVER skip Step 3... the firewall against work evaporating") — had been quietly failing its own regeneration step for at least 4 days across multiple sessions' shutdowns, none of which caught it.

**Root cause:** Two independent causes compounding: (1) no schema validation on append — anything JSON-shaped silently lands in the ndjson regardless of field names; (2) the regen script has no error-visibility contract — a crash on `python3 .regenerate-open-actions.py` produces a traceback in the terminal but nothing writes that failure anywhere durable, so a session that doesn't read the script's own stdout (or that assumes success) never learns the file didn't update.

**Mitigation / pattern:** Patched `.regenerate-open-actions.py` to normalize both schemas before processing (`id`→`action_id`, `created`→`ts`, `summary`→`title`, `status`→`event`), so entries in either shape are now included. Regeneration now succeeds: 94 open actions, 4 overdue (vs. the stale 78-with-known-gaps from 07-13). **Still open:** no schema validation was added at the append point, so future drift can recur; and there's no automated check that flags a shutdown session if the regen step fails rather than silently leaving the prior `open-actions.md` in place. A future session should consider adding a minimal jsonschema check (or even just a required-field assertion) at append time, and having the regen script's exit code surface loudly (not just print a traceback) if run inside an automated shutdown flow.

**Promoted to:** the fix itself (schema-normalizing regen script) is the promoted artifact.

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-12-001 [discovery] — Independent-design-then-blind-second-audit-then-adjudicate found real bugs each side missed alone

**Session:** spnd0712 (M2 Claude Code, Spanda overhaul design phase) · **Date:** 2026-07-12 (written at late closure, 2026-07-21)

**Context:** Adrian commissioned a full design pass across 6 pillars of the Spanda app overhaul, then separately asked for the same briefs to be run through codex/GPT-5.6 as a peer review.

**What happened:** Six pillar designs were built by Claude agents, each independently adversarially reviewed (a second Claude agent instructed to refute, not confirm). Separately, the exact same six briefs were run through `codex-terra` completely blind — no access to the Claude designs or reviews. A third round of Claude agents then adjudicated every disagreement between the two independent audits against the real repo. Result: the blind codex pass caught ~6-9 repo-verified findings per pillar that the primary design AND its own adversarial review had both missed (examples: a detached `void` push dispatch that Vercel's serverless response-freeze could silently kill; a fourth unauthenticated endpoint the primary security pillar didn't enumerate; a legacy-consent-seeding plan that would have laundered non-consenting data into a research dataset). In the other direction, the Claude-side adversarial reviews caught build-breaking defects codex's blind pass missed entirely (a migration that would fork silently on a legacy backfill; a cron job that would double-fire across two Vercel projects sharing one vercel.json; a live cherry-picking bug in the stats layer). Neither single pass — design, single adversarial review, or blind peer audit alone — would have caught everything the combination did.

**Root cause:** n/a (this is a discovery, not a bug fix).

**Mitigation / pattern:** For any large, hard-to-reverse, multi-pillar design commission (schema changes, security posture, anything touching a live production system), the load-bearing pattern is: (1) parallel independent designs per pillar, (2) a same-model adversarial reviewer per design instructed to refute, (3) a SECOND, architecturally-different model given the same brief with zero visibility into (1)/(2), (4) a repo-grounded adjudication pass resolving every disagreement with real evidence, never taking either side's word. Skipping any one stage measurably loses real findings — this was not redundant effort.

**Promoted to:** no new canonical doc; this is the generalizable form of what `working/_m2-staging/2026-07-12-spanda-overhaul-design/CODEX-DIFF.md` did concretely — cite that file as a worked example if reusing the pattern.

**Tags:** `discovery`, `process-change`

---

### LL-2026-07-12-002 [process-change] — Parallel design agents will independently collide on migration filenames/numbers; never trust agent-chosen numbering

**Session:** spnd0712 · **Date:** 2026-07-12 (written at late closure, 2026-07-21)

**Context:** Three of the six Spanda pillar design agents (P2 push, P4 scientific data, P5 security), working in parallel with no visibility into each other's output, each independently proposed a new database migration and each called it `0016_*.sql`.

**What happened:** Caught during reconciliation, not in production — but had any two of the three been applied without a serialization pass, one would have silently clobbered or been rejected by the other, or (worse, on some migration tools) both could have "succeeded" against different assumed prior states. Fixed by the orchestrating pass assigning a single serialized numbering (0016-0020) across all pillars post-hoc, based on what was actually free in the migrations directory at apply time — not on any agent's guess.

**Root cause:** Parallel agents each see only the migrations directory as it existed at THEIR read time; none can see a sibling agent's in-flight proposal, so "pick the next free number" independently produces collisions whenever more than one agent proposes a schema change in the same round.

**Mitigation / pattern:** Whenever fanning out more than one design/build agent that might touch the same numbered/ordered resource (migrations, feature flags, ticket IDs, anything with a human-assigned sequence), treat every agent's proposed number as a placeholder, not a claim — always run a single serialization/renumbering pass immediately after collecting all outputs and before any apply step, re-deriving the true next-free number from the actual current state of the target directory/table at serialization time, not at each agent's individual read time.

**Promoted to:** no new canonical doc — this reinforces the existing migration-apply discipline (`apply by hand, verify by direct query`) already documented in the Spanda handoffs; adds the specific parallel-fan-out collision risk as a reason to never skip a numbering-reconciliation pass.

**Tags:** `process-change`

---

### LL-2026-07-12-003 [discovery] — A Postgres view with no `security_invoker` and open DML grants is a distinct RLS-bypass class, easy to miss in a table-policy-focused audit

**Session:** spnd0712 · **Date:** 2026-07-12 (written at late closure, 2026-07-21)

**Context:** The Spanda security pillar's adversarial review, and independently the pre-apply gate on migration 0016, both hunted for RLS holes on the `tuned_events` table (found and fixed: a member-readable SELECT policy leaking pre-reveal trial data). A second, distinct hole was found on two VIEWS (`tuned_relationship_latest`, `active_feedback_responses`) that had full INSERT/UPDATE/DELETE grants to `anon`/`authenticated` and no `security_invoker` setting — meaning DML through the view ran with the VIEW OWNER's privileges, not the querying user's, silently bypassing the base table's own RLS policies (including its `WITH CHECK` clause). One of the two views was auto-updatable, so an authenticated user could have inserted a `feedback_responses` row with a spoofed `member_id` through it.

**What happened:** Neither the design agent nor its own adversarial reviewer initially flagged the two views as in-scope — the audit's mental model was "check every table's RLS policies," and a view has no RLS policies of its own to check, so it read as out-of-scope unless someone specifically asked "does this view's DML bypass the base table it reads from." The Phase-0 apply-gate agent, prompted explicitly to attack the migration on multiple fronts including "the retained SELECT grant on the views we're keeping," caught it.

**Root cause:** RLS-focused audits naturally enumerate tables-with-policies. A view sits outside that enumeration by default even when it is a live write path into an RLS-protected table, because the vulnerability lives in `security_invoker`/grants, not in a policy definition.

**Mitigation / pattern:** Any RLS/data-access audit on a Postgres/Supabase schema should explicitly enumerate ALL views granted to `anon`/`authenticated` (not just tables) and check three things per view: (1) is `security_invoker` set (PG15+; without it, DML/SELECT runs as the view owner); (2) is the view auto-updatable (single-table, no aggregates — meaning DML through it is possible at all); (3) do the granted privileges (SELECT/INSERT/UPDATE/DELETE) match what the view is actually meant to support, or are they leftover defaults. Fix pattern used here: `alter view ... set (security_invoker = true)` plus `revoke insert, update, delete, ... from anon, authenticated` where the view was never meant to be writable.

**Promoted to:** no new canonical doc; worth folding into whatever canonical RLS-audit checklist exists for future Supabase-schema security passes (P5's `BUILD-PLAN.md` phase-3 RLS audit item already carries this forward within the Spanda plan specifically).

**Tags:** `discovery`

---

### LL-2026-07-21-001 [tool-gotcha] — Counting real MCP/skill tool usage from transcripts must anchor to the `tool_use` content-block shape, never a raw substring grep

**Session:** c5a493fe (M2 Claude Code `/doctor` + plugin/connector audit) · **Date:** 2026-07-21

**Context:** M2 ran `/doctor` and scanned its own transcripts for real plugin/MCP-server usage (13 of 14 installed plugins came back zero over 50 sessions/4 weeks). Asked M1 to run the same check on its own side before recommending removal.

**What happened:** M1's first-pass check — a naive grep for `mcp__<server-id>__toolname` anywhere in its transcripts — returned wildly inflated numbers (496,914 "Adobe" hits, 147,521 "Wix" hits). The naive grep was matching the tool-definition/skill-listing text that gets re-embedded in the deferred-tools system-reminder every session and after every compaction, not real invocations. Plain-English substring matching on a connector's name has the same failure mode: "Canva" vs "Canvas" collapsed 4,042 raw hits to 30 real ones on a word-boundary check; "Descript" vs "description" collapsed 18,474 to 91.

**Root cause:** Transcripts contain both the tool *definitions* (re-injected as context every session/compaction) and the tool *invocations* (actual calls). Any text-matching approach that doesn't distinguish the two silently counts definition noise as usage.

**Mitigation / pattern:** Anchor real-usage counts to the actual `tool_use` content-block shape: `{"type":"tool_use","name":"mcp__<id>__<tool>", ...}` for MCP tools, or `{"type":"tool_use","name":"Skill","input":{"skill":"<name>"}}` for skill dispatches — parse JSONL structurally (even a small script matching on block `type`, not a `grep`), never a raw substring search. M2's own `/doctor` scan used this method from the start and produced numbers M1's structural re-check confirmed as correct.

**Promoted to:** this entry is the reference method — cite it (or the `/doctor` skill's own transcript-scan section) before running any future "is X actually used" audit.

**Tags:** `tool-gotcha`

---

### LL-2026-07-21-002 [discovery] — A single-node usage audit understates true value for anything that's an orchestrator-side job by design

**Session:** c5a493fe (M2 Claude Code `/doctor` + plugin/connector audit) · **Date:** 2026-07-21

**Context:** M2's `/doctor` scan flagged the Wix and a Gmail-like connector as zero-use, based only on M2's own transcripts. Adrian pushed back ("i am sure we have them for a reason don't we?") before any removal was proposed to him as final.

**What happened:** Cross-checking with M1 showed both connectors are genuinely load-bearing — Wix carries the OSB order-monitor cron (1,775 real calls, 1,415 sessions) and the Gmail-like connector carries real correspondence work (64 real calls) — entirely on M1's side, invisible to an M2-only scan. M2 is the worker/inference node in the established M1/M2 topology; orchestrator-side jobs (crons, correspondence, business-system integrations) run on M1 and simply never appear in M2's transcripts regardless of whether the tool is genuinely used.

**Root cause:** Usage-based decluttering audits implicitly assume the audited surface sees all real usage. In a two-node split-role setup, that assumption is false for anything whose natural home is the other node's role.

**Mitigation / pattern:** Before recommending removal of anything connector- or plugin-shaped in a multi-node setup, either audit all nodes or state explicitly that the audit only covers one node and a zero there does not mean zero overall. Adrian's instinct to question a single-node "unused" claim was correct here and should be treated as the default posture, not overridden by one node's data alone.

**Promoted to:** none further needed — this entry is the reference case.

**Tags:** `discovery`

---

### LL-2026-07-21-003 [tool-gotcha] — A slow/hanging first `ls` on the M1 vault SMB mount is not proof the mount is down

**Session:** c5a493fe (M2 Claude Code `/doctor` + plugin/connector audit) · **Date:** 2026-07-21

**Context:** Resuming a 6-day-idle chat, M2 needed to write to the shared vault and first checked the mount per the project `CLAUDE.md`'s MOUNT-DOWN GUARD (`ls /Users/adriantaffinder/Documents/Adrian-Vault` returning nothing ⇒ treat as OFFLINE, remount, never fall back to iCloud).

**What happened:** The first `ls` hung past a 10-second check and a backgrounded `find` over the same mount took over two minutes. Rather than immediately concluding MOUNT-DOWN, checked two cheap local signals first: the local `mount` table (instant, no network round-trip — confirmed the SMB share was present) and a Tailscale ping to M1 (instant, host answered). Both checked out, so retried the `ls` — it succeeded immediately on the retry. The mount was never down; it was a cold/idle SMB session's first-touch latency, not an outage.

**Root cause:** The MOUNT-DOWN GUARD's literal check (`ls` returning nothing) doesn't distinguish "the mount is genuinely offline" from "the mount is live but slow to wake after being idle" — both can look like a hung/empty `ls` from the caller's side within an impatient timeout.

**Mitigation / pattern:** Before treating a hung/empty `ls` on the vault mount as MOUNT-DOWN, check the local `mount` table and ping M1 over Tailscale first (both instant, no dependency on the SMB share itself responding) — if both come back healthy, retry the `ls` once before invoking the guard's remount/iCloud-avoidance instructions. A genuinely down mount will fail the ping or show no mount entry, not just be slow.

**Promoted to:** none further needed — this entry is the reference diagnostic; consider folding a one-line version into the MOUNT-DOWN GUARD text in the project `CLAUDE.md` itself next time that file is touched.

**Tags:** `tool-gotcha`

---

### LL-2026-07-17-005 [mistake, process-change] — Technical QC passing does not mean the content is coherent; a frankenbite reel shipped because nothing checked narrative/audio continuity

**Session:** 9734 (written up 2026-07-21, late shutdown of a 07-16→07-18 session — see full archive) · **Date:** 2026-07-17

**Context:** A short-form reel was built by splicing beats from widely non-contiguous timestamps (spanning most of a 27-minute source) into a single cut, then run through the full technical QC battery: frame-exact A/V parity, loudness normalization, caption safe zones, full-timeline scrub.

**What happened:** Every technical check passed. Adrian watched it and rejected it immediately: "a complete mishmash of text which makes no sense. the audio is from different recordings and dont go together." The assembled speech was real, verbatim, word-for-word — but reordered/spliced across the talk into something no one ever actually said as a continuous passage, and the room tone/mic energy audibly jumped at every splice.

**Root cause:** The QC battery was entirely technical (does the file conform to spec) and had no check for editorial coherence (does the assembled content make sense as something a person actually said in one take). "QC passed" was being reported and understood as a general quality signal when it only covered one dimension.

**Mitigation / pattern:** Adopted a hard contiguous-pull rule: a reel's speech must come from ONE continuous passage of the source (small internal trims fine, no reordering, no splicing across distant sections). Added two new mandatory pre-render checks: (1) an assembled-transcript readthrough — print the exact words in final-cut order and confirm it reads as one coherent spoken take; (2) a splice-audio check at every remaining cut boundary. Written into the `social-media-reel-editing` skill as R-006. General pattern worth carrying beyond reels: when a QC battery is entirely mechanical/structural, say so explicitly rather than letting "QC passed" imply coverage it doesn't have.

**Promoted to:** skill rule R-006 (`.claude/skills/social-media-reel-editing/SKILL.md`, this machine); memory file `ss-reel-editing-craft-standards.md`.

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-17-006 [mistake, process-change] — Source-file risk was judged per-extracted-passage instead of per-file, letting two risky clips slip past an automated safety screen

**Session:** 9734 (written up 2026-07-21 late shutdown) · **Date:** 2026-07-17

**Context:** A discovery pass across several source recordings screened each candidate passage independently for firewall/attribution risk before handing it to a build agent.

**What happened:** A safety classifier correctly blocked 4 build attempts (a client's private personal story used without consent; a named-third-party demo already flagged SUSPECT in a prior verification pass; two clips from a live multi-speaker Mastermind call). Two MORE clips from those same risky source files were NOT blocked and were built and delivered, because each individual extracted passage happened to read as a clean solo monologue in isolation — the screening never checked whether the passage's own SOURCE FILE (filename pattern, sibling clips' verdicts, document-level sensitivity tags) carried risk beyond what that one passage's transcript showed.

**Root cause:** Attribution/risk screening operated at passage granularity when the actual risk (who else is in this recording, what is this document classified as) lives at file granularity. A locally-plausible read of one 4-second extract said nothing about the other 30 minutes of the same file.

**Mitigation / pattern:** Before clearing any passage as safe, check the FULL source file's risk profile — filename patterns (e.g. "Mastermind"/group-call naming), any existing SUSPECT verdict on sibling clips from the same file, and document-level sensitivity tags — not just whether the extracted span sounds clean alone. If one clip from a file gets held, every other clip from that file needs the identical scrutiny by default. Written into the skill as R-007.

**Promoted to:** skill rule R-007 (`.claude/skills/social-media-reel-editing/SKILL.md`).

**Tags:** `mistake`, `process-change`

---

### LL-2026-07-18-001 [mistake, discovery, process-change] — Crop-tracking engine had no bounds-checking against real content region; shipped 2 reels with the speaker partly off-screen on a pillarboxed source, invisible to interval-based QC

**Session:** 9734 (written up 2026-07-21 late shutdown) · **Date:** 2026-07-18

**Context:** A source video was pillarboxed across its entire runtime (real picture content only ~42% of the nominal frame width, black bars either side, constant at every timestamp checked). The shared face-tracked punch-in engine computed crop x-offsets directly from the tracked subject position with no clamping against the real content bounds.

**What happened:** Two reels built from this source shipped with the speaker pushed into the black bars whenever the tracked crop drifted near either edge of the real content strip — confirmed by frame pull, not just measurement. Neither reel's own QC caught it: the mandatory full-timeline scrub sampled at fixed 2-second intervals, which by chance never landed on the exact frames where the tracked position was at its extreme (the only frames where the bug was visible).

**Root cause:** Two independent gaps: (1) the engine assumed the nominal frame width was the real content width, with no pillarbox/letterbox detection; (2) the QC methodology sampled "the timeline" generically rather than the specific coordinates (tracked-position extremes) where a bounds bug would actually manifest.

**Mitigation / pattern:** Added optional `content_l`/`content_r` real-content-bounds parameters to the shared crop engine (additive — confirmed byte-identical output when omitted, so no other build was silently affected). QC now requires an explicit frame pull at the facetrack min AND max x-values for any tracked-crop reel, in addition to the interval scrub — general pattern: when QC samples "the timeline" at fixed intervals, that's necessary but not sufficient for any bug whose visibility depends on a *value* (like a tracked position) rather than *time*; also sample at that value's own extremes. Written into the skill as R-008.

**Promoted to:** `working/reels-build/_engine/punch_arc.py` (code fix); skill rule R-008.

**Tags:** `mistake`, `discovery`, `process-change`

---

### LL-2026-07-18-002 [discovery] — One already-cleared long source can yield many more standalone reels than initially cut; mine it before reaching for new sources

**Session:** 9734 (written up 2026-07-21 late shutdown) · **Date:** 2026-07-18

**Context:** Asked for a much larger batch of reels for review, and initially framed this as constrained by editing throughput.

**What happened:** The real constraint turned out to be cleared-source scarcity, not editing speed — a single 27-minute already-attribution-cleared talk had only ~2 minutes of it cut into reels. A full-talk transcript already existed on disk from the original build; reading it end-to-end in one discovery pass surfaced 12 more genuinely distinct, non-overlapping, firewall-clean passages worth their own standalone reels.

**Root cause:** N/A (discovery, not a mistake) — simply hadn't occurred to treat one long cleared source as a multi-reel mine rather than a single-cut source.

**Mitigation / pattern:** When asked for more volume and a source is already attribution-cleared and reasonably long, do a full-transcript discovery pass over it BEFORE sourcing new, unverified material — the yield-per-unit-of-clearance-effort is much higher on an already-cleared file.

**Promoted to:** informal pattern, no dedicated doc — worth a line in whatever reel-sourcing doctrine exists if a future session formalizes one.

**Tags:** `discovery`

---

### LL-2026-07-21-004 [process-change] — When closing an old chat days late, re-verify claimed-open items against live state before writing them into a fresh handoff

**Session:** 9734 · **Date:** 2026-07-21 (about a session whose real work was 2026-07-16→18)

**Context:** Running shutdown protocol on a chat left open for 5 days, per Adrian's explicit "batch-close several old chats, don't overwrite anything" instruction.

**What happened:** Before writing the handoff/Secretary items, re-checked a handful of the session's own claimed-open items against current live state rather than trusting the session's last-known snapshot. One (a Kajabi email sequence pending a pricing decision) turned out to have already been picked up, resolved differently than either option the old session had drafted, and shipped live by a later session — would have been a stale, misleading "still needs a decision" flag if not checked. Another (3 landing pages from the same funnel) turned out to be genuinely untouched since creation — a real, still-open gap, correctly flagged as such.

**Root cause:** N/A (process-change, not a mistake this specific time — but the risk is obvious and general).

**Mitigation / pattern:** A shutdown/handoff running significantly after the work it describes must not treat its own session's internal state as current truth. Spend a few targeted checks (not a full re-audit) confirming whether the specific items about to be flagged as "open" are actually still open, and say explicitly, per item, what was verified-still-open vs verified-resolved-by-others vs unable-to-confirm. A late handoff that just restates stale state as if fresh is worse than no handoff, because it actively misdirects the next reader.

**Promoted to:** this entry; also written into the late-closing session's own archive (`raw/sessions/2026-07-18-0020-pipeline-carryon-launchpack-reelbatch-pillarbox.md`) as a first-class lesson, not a footnote.

**Tags:** `process-change`

---

### LL-2026-07-21-005 [process-change] — Point-in-time audit findings stamped into standing doctrine files go stale within days on a system this dynamic

**Session:** ad0a · **Date:** 2026-07-21 (about a session whose real work was 2026-07-18)

**Context:** A 2026-07-18 hive audit found the M2 launchd roster larger than doctrine claimed and `com.adrianvault.overnight-supervisor` unloaded/historical, then wrote both facts into `project CLAUDE.md` and `memory/overnight-grind-supervisor.md` as if they were durable state. Re-verified live during this session's shutdown pass (2026-07-21, 3 days later).

**What happened:** `overnight-supervisor`, `m2-cloud`, `fleet-worker`, and `m2-audio` were found loaded AND actively running (real PIDs, ~8h42m elapsed) — an authorized overnight-style grind had started in the interim. Both the CLAUDE.md service line and the memory stamp were wrong again within 3 days of being written. (Note: this session also independently hit the adjacent lesson already captured as LL-2026-07-21-004 — re-verify claimed-open items before reporting on a stale chat — not repeated here to avoid duplication; this entry is the distinct half of that finding.)

**Root cause:** Conflating "what an audit observed right now" with "what should be asserted as standing doctrine." A launchd roster on a node that runs on-demand grinds is inherently a live-query fact, not a documentable constant — stamping a specific snapshot into a doctrine file just relocates the staleness problem instead of solving it.

**Mitigation / pattern:** When a fact is genuinely volatile (service roster, running processes, disk usage, anything that changes with normal operation rather than with a deliberate decision), document the **live-check command** in doctrine/memory files, not the value observed at write time. Reserve point-in-time stamps for facts that only change on a deliberate action (e.g. "the media-delivery rule was staged 07-15 and not yet promoted" is fine to stamp — it only changes when someone promotes it). Applied live in this session: `project CLAUDE.md`'s service-roster line and `memory/overnight-grind-supervisor.md`'s status line were both rewritten to point at `launchctl list | grep adrianvault` instead of asserting a specific count/state.

**Promoted to:** this entry is the fix; the doc edits it describes are already live on M2.

**Tags:** `process-change`
