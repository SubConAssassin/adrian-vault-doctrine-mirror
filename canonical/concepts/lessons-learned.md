---
title: Lessons Learned — Rolling Index
type: MOC
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-05-04
updated: 2026-05-04
last_updated: 2026-05-04
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
