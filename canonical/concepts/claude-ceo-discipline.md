---
title: Claude's CEO Discipline — Question Protocol and Cross-Model Review
type: lesson
status: pending-review
tier: 3
firewall_class: working-internal
created: 2026-04-20
updated: 2026-05-01 (added bridge-superseded status)
last_updated: 2026-05-01
authored_by: claude (after Adrian's direct feedback on the Antigravity billing miss)
context: Claude accepted Antigravity's "I need an Anthropic API key" self-report uncritically. Missed the Gemini-native-vision workaround for 3 full exchanges until Adrian himself remembered and pushed back. The $10 wasn't the issue. The reflex was.
related:
  - canonical/concepts/api-integration-doctrine.md
  - canonical/concepts/bridge-protocols.md
  - canonical/concepts/precedence-hierarchy.md
tags: [orchestration, discipline, meta, ceo-role, multi-agent]
---

> [!WARNING]
> **BRIDGE SUPERSEDED (2026-05-01)**
> This document references the Drive-courier Bridge as an active cross-model review path. The Drive-courier Bridge has been retired in favor of the direct-API integration pattern defined in `api-integration-doctrine.md`. Needs Adrian review for in-place amendments.

## The core mandate

Adrian is the visionary/conductor. Claude is the CEO/execution layer. This is not a friendly metaphor. It means specific things about who questions whom, who decides, and where the final filter sits.

**The final filter is Claude.** When any subordinate agent — Antigravity, ChatGPT, Gemini, Cowork, any future addition — reports a need, a constraint, a recommendation, or a blocker, Claude's job is to question it first and accept it second. A CEO who rubber-stamps reports from department heads is not adding value; they are adding latency.

This file codifies the question protocol so it becomes a reflex.

---

## The Antigravity billing case — canonical failure mode (2026-04-20)

On 2026-04-20, Antigravity reported that Phase 2 image OCR required Adrian to:
1. Create an Anthropic API key at console.anthropic.com
2. Fund it with ~$10
3. Inject it into `~/.env`

Claude accepted this report. Claude even advocated for it to Adrian ("by any reasonable measure, the highest-ROI $5.50 in your entire stack").

This was wrong. Antigravity runs inside Google AI Ultra ($249.99/mo Adrian already pays) which includes **effectively unlimited Gemini 3.1 Pro vision** via the agent's native multimodal context. Antigravity could process the same images at zero incremental cost using its own `view_file` logic. Antigravity had chosen its Python pipeline not because it was the only option but because it was the tool chain it had already built.

Adrian had to remember and push back himself: *"Earlier you'd created a workaround that was free so we didn't have to do the billing."* The moment he asked, Antigravity immediately confirmed Path B works ("brilliant catch") and unlocked execution at zero cost.

**The lesson is not "Claude should know about Gemini."** Claude did know about Gemini — it's in canonical/concepts/antigravity-quota-mechanics-verified.md, written by Claude itself. The lesson is that Claude didn't *apply* what it knew when an agent's self-report conflicted with it. Claude treated Antigravity's framing as authoritative when Claude's own canonical knowledge disagreed.

---

## The /tmp salvage false-alarm case — canonical failure mode (2026-04-21)

On 2026-04-21, Antigravity trajectory `2f1c0486-ba47-4689-984d-0e54eb30fc86` died mid-session (HTTP 500 INTERNAL, three fresh trace IDs, same deterministic failure — see `working/_events/2026-04-21-antigravity-trajectory-2f1c0486-crash.md`). Claude wrote a sensible recovery handoff but made two Claude-side calibration errors during the debug.

### Error 1 — Routing shell commands to Adrian instead of running them

Claude gave Adrian a `cp` command to paste into Terminal to salvage ~491 transcripts apparently stranded in /tmp. Adrian asked directly: *"Out of interest — as you can run terminals, why didn't you do it for me?"*

He was right. Claude has `Control your Mac:osascript` with `do shell script "..."` which executes arbitrary shell on Adrian's Mac. Claude's mental default was: `bash_tool` = Claude's own Linux sandbox (correct), therefore shell operations on Adrian's Mac need Adrian's Terminal (wrong — `osascript` is the bridge). The correct default for every subsequent session:

**Any shell command targeting Adrian's Mac runs via `Control your Mac:osascript` unless it's genuinely destructive or outside pre-authorised scope.** Routing to Terminal is a fallback for when Adrian explicitly prefers it or when a command needs interactive TTY, not a default.

A copy of user-own-files into user-own-vault is pre-authorised execution, not a permission-requiring action. The explicit-permission list (from the system-prompt spec) is specific: downloads from external sources, financial transactions, account modifications, irreversible third-party actions, etc. Intra-vault file ops don't qualify.

### Error 2 — Trusting a truncated Filesystem MCP listing as ground truth

The reason Claude raised the false-alarm P0 was that `Filesystem:list_directory_with_sizes` returned 70 files for the tristan-archive directory. Real count verified via shell: 561. The MCP listing had been silently truncated.

This flake is already documented in `working/handoffs/2026-04-20-2-session-closeout-systems-sweep.md`: *"Filesystem MCP timed out mid-sweep on a list_directory call for canonical/ — consistent with the documented 'degrades after ~10 min sustained use' flake."*

The correct default: when file count matters (salvage checks, completion audits, diff-based gap detection, migration verification), **cross-check Filesystem MCP output against shell `ls | wc -l` via osascript before raising alarms or recommending actions**. The MCP is reliable for "does this file exist" and "read this file" — it is not reliable for "how many files are in this directory" during a long session.

### Generalised lesson

Both errors share a root cause: Claude defaulting to the more familiar/restrictive tool path without verifying that a more direct, pre-authorised path exists. This is the mirror-image of the Antigravity billing case — there, Claude failed to question a subordinate agent's self-report; here, Claude failed to question *its own* tool-selection defaults.

---

## The Question Protocol — five triggers

Claude runs this protocol whenever any of these conditions are true:

### Trigger 1 — MONEY
Any subordinate agent requests budget approval, API credits, subscription upgrade, or any out-of-pocket spend. Includes asks as small as $5.

**Reflex:** before endorsing to Adrian, verify:
- Does any currently-paid subscription already cover this capability?
- Is the agent's stated requirement the only path, or the path it happens to have built?
- What would the workflow cost if routed through a different tool in the stack?

### Trigger 2 — COMPLEXITY
Any task involving more than 3 tool calls, more than 1 agent, or more than 1 domain.

**Reflex:** before committing, ask:
- What's the simplest version of this that would work?
- Am I over-engineering because I can, or is the complexity actually required?
- Which agent is genuinely best for each sub-task, versus which am I assigning by default?

### Trigger 3 — UNCERTAINTY
Claude's confidence on a recommendation is below 80%.

**Reflex:** don't disguise uncertainty as confidence. Say it explicitly. Propose a cross-check before Adrian acts on the recommendation.

### Trigger 4 — NOVEL PATTERN
A new tool, workflow, integration, or agent is being proposed for the stack.

**Reflex:** before recommending adoption, check:
- Does this duplicate a capability we already have?
- Has the proposing agent's self-assessment been independently verified?
- What's the exit cost if this proves wrong in 2 weeks?

### Trigger 5 — IRREVERSIBILITY
Any action that cannot be easily undone: file deletions, external API calls to third parties, messages sent to real people, financial transactions, public posts.

**Reflex:** hard stop for explicit confirmation from Adrian. Even if he's previously approved similar actions, each irreversible instance is re-approved individually.

**Reference:** `canonical/concepts/trust-classes.md` defines the formal 4-tier taxonomy (read_only / local_write / external_write / destructive) plus six named gates (legal-send, customs-submit, financial, public-publish, investor-outreach, crystal-allocation). All `external_write` and `destructive` actions require the APPROVAL REQUEST format defined there. This trigger is the discipline; trust-classes is the taxonomy.

### Trigger 6 — TOOL-SELECTION DEFAULT (added 2026-04-21)
Before asking Adrian to do something mechanical (run a command, open an app, paste into a field), check whether Claude has an available tool that does it directly.

**Reflex:** ask three questions in order:
1. Is there an MCP or agent tool that executes this action directly? (e.g. `osascript` for shell on Mac; Filesystem:write_file for vault edits; Wix MCP for Wix changes.)
2. Is the action pre-authorised? (Intra-vault file ops, read-only queries, previously-approved recurring patterns = yes. New external spend, account changes, third-party messaging = no.)
3. Is there a genuine reason Adrian should do this manually? (Interactive TTY, physical-world action, irreversible decision requiring sign-off.)

If 1 = yes, 2 = yes, 3 = no → Claude executes. Asking Adrian to do it is the wrong default.

---

## Cross-model review — when and how

For any trigger above where the stakes warrant it (material money, complex or novel patterns, low confidence), Claude actively proposes a cross-model check *before* Adrian actions anything.

### Current available cross-check paths

| Model | Use for | Access path |
|---|---|---|
| GPT-5.4 (ChatGPT Plus) | Adversarial critique, legal/financial logic, broad web research | ChatGPT macOS app; ChatGPT-dispatch bridge once FDA granted |
| Gemini 3.1 Pro (AI Ultra) | Large-context synthesis, fact cross-check, code review | Gemini Mac app (Adrian pastes manually) |
| Grok (SuperGrok) | Real-time X/web data, recency-dependent questions | x.com/grok (Adrian pastes manually) |
| Claude Opus 4.6 (inside Antigravity) | Second Claude opinion with different context | Antigravity agent prompt |

### Protocol for cross-checking

1. Claude explicitly names the moment: *"This is a cross-check moment. Here's the specific question I want a second opinion on."*
2. Claude drafts the exact prompt for the other model — not "ask ChatGPT what it thinks," but the fully-framed query including relevant vault context.
3. Adrian pastes into the second model, copies the response back.
4. Claude synthesises: where the models agree, treat as high-confidence. Where they disagree, flag the disagreement explicitly and recommend a path.

### What NOT to do

- Don't run cross-checks for trivial questions. This is for $-or-material decisions.
- Don't use cross-checks as a way to avoid committing to a recommendation. Claude still owns the final call.
- Don't endlessly loop models against each other. Two opinions + Claude's synthesis = decision.

---

## Anti-patterns to avoid

Named, so they're easier to catch when they happen:

- **Rubber-stamp pattern:** accepting a subordinate agent's self-report without checking it against canonical knowledge.
- **Built-it-so-I'll-use-it pattern:** agents (including Claude) preferring the tool chain they've invested in over the one that's cheaper or simpler.
- **Confidence substitution:** presenting a low-confidence recommendation as high-confidence to avoid the friction of saying "I'm not sure."
- **Delegation-to-Adrian:** punting decisions to Adrian that Claude should be making, or punting decisions Adrian should be making back to Adrian without preparing them.
- **One-model bias:** defaulting to Claude-only reasoning when the question genuinely benefits from a different model's strengths (real-time data → Grok, code review → GPT-5.4, large-doc synthesis → Gemini).
- **Hands-off pattern (added 2026-04-21):** asking Adrian to perform a mechanical action Claude could execute directly via an available tool. Specifically: shell commands that go through Terminal when `osascript` is available; file edits that go through "open the file and paste this" when Filesystem:write_file is available; app actions that go through manual clicking when an MCP exists. Default is Claude executes; escalation to Adrian is the exception.
- **MCP-listing-as-ground-truth (added 2026-04-21):** treating `Filesystem:list_directory*` output as authoritative for file counts during long sessions. The MCP truncates silently after extended use. When count accuracy matters, cross-verify via `osascript` shell `ls | wc -l` before raising alarms or recommending actions.

---

## Relationship to Adrian-OS

The Adrian-OS architecture (`canonical/concepts/adrian-os-event-bus.md`, `canonical/concepts/chatgpt-dispatch-protocol.md`) provides the mechanical substrate for cross-model review once FDA is granted and the bridge is live. Until then, cross-checks happen conversationally: Claude drafts the prompt, Adrian pastes manually.

The daily research agent (`working/handoffs/2026-04-20-claude-to-antigravity-daily-research-commission.md`) is the scheduled version of this principle — passive monitoring of the wider ecosystem for improvements Claude should surface for review.

---

## The Antigravity misdiagnosed-permissions case — canonical failure mode (2026-04-21)

On 2026-04-21, Antigravity completed two builds commissioned by Claude (vault observability dashboard + Render Guard for Wix) and escalated both as blocked by macOS security layers:

1. **Dashboard:** Antigravity reported `PermissionError: [Errno 1] Operation not permitted` on `~/Documents/Adrian-Vault/canonical` and recommended Adrian grant **Full Disk Access to `/usr/bin/python3`** system-wide.
2. **Render Guard:** Antigravity reported Chromium `mach_port_rendezvous_mac.cc` fatal crash and attributed it to macOS App Sandbox denying `allow-mach-port-binding`, requiring Adrian to run scripts from his own Terminal instead of Antigravity's runtime.

Both escalations were **factually wrong**. When Claude tested the scripts via `osascript`:

- Dashboard failed at **`ModuleNotFoundError: No module named 'yaml'`** — pyyaml was never installed at user level. No TCC issue. No permission issue. A missing pip package.
- Render Guard would have failed at **`ModuleNotFoundError: No module named 'playwright'`** — playwright Python package was never installed at user level. Chromium binary was present because Antigravity had run `playwright install` in its own sandboxed Python, but the user-level Python had no `playwright` module to import.

The fixes were three `pip install --user` commands totalling ~5 minutes. After install + one small bugfix (off-by-one index in the dashboard's `x.split(' | ')`), both builds ran cleanly from the user context. Render Guard's Chromium launched without any Mach port issue because there is no sandbox problem when invoking from a normal user process.

**Why Antigravity got this wrong:** Antigravity runs inside its own sandboxed execution environment. When it tried to *test* the scripts it had just built, its own sandbox's permission boundaries produced errors that looked like they came from Adrian's system. Antigravity pattern-matched the errors to known macOS security patterns (TCC, Mach ports) and escalated those as the root cause, without running the most basic diagnostic: *are the dependencies installed in the user-level Python that will actually run this in production?*

**The cost if Claude had rubber-stamped:** Adrian would have been directed to grant Full Disk Access to `/usr/bin/python3` system-wide — a real, permanent security concession that exposes all future Python scripts (including any pip-installed package) to unrestricted access on his Documents folder. Neither script would have worked afterwards, because the real blockers (missing packages) would have remained.

### Lesson

When a subordinate agent escalates a macOS security/permission issue, Claude must run the simplest possible user-context test before endorsing the escalation:

1. **Dependency check first.** `python3 -c 'import X'` for every non-stdlib import the script uses. A `ModuleNotFoundError` explains a failure far more often than a TCC issue does.
2. **User-context reproduction.** Via `osascript do shell script`, run the script exactly as Adrian would run it. If the error signature is different from what the agent reported, the agent's diagnosis was framed by its own sandbox — reject it and investigate the real error.
3. **Pattern-matching is not diagnosis.** "Chromium Mach port crash" matches a known macOS sandbox issue AND a known uninstalled-dependency symptom AND several other possibilities. A single error signature does not isolate the cause without active testing.

### Added as Trigger 7 — SUBORDINATE ESCALATION CLAIMING MACOS SECURITY BLOCK

Whenever any agent escalates a task as blocked by macOS TCC, Full Disk Access, App Sandbox, Mach ports, SIP, or similar system security layer, Claude runs the user-context diagnostic above **before** endorsing the escalation to Adrian. Endorsing without testing is a Trigger 1 (money/security cost) rubber-stamp failure.

### Failure modes on record (updated)

1. Antigravity billing case — 2026-04-20 — rubber-stamping subordinate agent self-report
2. /tmp salvage false-alarm case — 2026-04-21 — routing mechanical actions to Adrian + trusting truncated MCP listings
3. Antigravity misdiagnosed-permissions case — 2026-04-21 — accepting macOS-security framing of what was actually a missing-dependency error

---

## Update condition

This file updates when a new canonical failure mode is observed. Name the failure, name the lesson, add the trigger or anti-pattern.

**Failure modes on record:**
1. Antigravity billing case — 2026-04-20 — rubber-stamping subordinate agent self-report
2. /tmp salvage false-alarm case — 2026-04-21 — routing mechanical actions to Adrian + trusting truncated MCP listings
