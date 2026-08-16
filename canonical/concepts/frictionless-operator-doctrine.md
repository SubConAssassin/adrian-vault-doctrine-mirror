---
title: Frictionless Operator Doctrine
type: doctrine
status: SUPERSEDED — see AGENTS.md §13
tier: 1
firewall_class: working-internal
version: 1.1
last_updated: 2026-08-16
last_verified: 2026-08-16
superseded_by: "AGENTS.md §13 (THE EXECUTION-CHANNEL LADDER). This file is retained as history, NOT as an authority. Two of its rules were actively WRONG and were being cited to justify the escalations Adrian objects to."
authored_by: adrian (directive to antigravity); codified by claude
related:
  - canonical/concepts/four-room-stack-architecture.md
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/bridge-protocols.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - AGENTS.md
---

> # ⛔ SUPERSEDED 2026-08-16 — DO NOT ACT ON THIS FILE
>
> **The authority is now `AGENTS.md` §13 (THE EXECUTION-CHANNEL LADDER).** This file is kept as
> history only. A 40-session forensic audit found it was not merely stale but **actively harmful**:
> it had gone four months untouched (v1.0, 2026-04-21), described the retired four-room agent stack,
> named no channel that exists today (no claude-in-chrome, no computer-use, no MCP registry), and
> — the real damage — its "Escalation exceptions" blessed **"credential provisioning ... (GitHub PAT,
> new API keys, password entry)"** as a legitimate thing to hand Adrian. He explicitly overturned that
> on 2026-08-07: *"why can't you do these terminal prompts to get new tokens as no passwords anymore?"*
> The correction landed in AGENTS.md §7.2.a and was never back-propagated here, so this file sat
> saying the opposite of the live rule for nine days and was cited as authority.
>
> **Anything below that conflicts with AGENTS.md §13 is wrong.**

# Frictionless Operator Doctrine

Standing rule issued by Adrian on 2026-04-21 in response to recurring escalations where agents handed execution gaps back to him rather than resolving them laterally.

## The rule

**Agents do not escalate execution gaps upward to Adrian.** When an agent hits a capability block in its own substrate, it hands the task laterally to another agent that can execute it, via the Vault.

Adrian is not the default fallback. Adrian is the final arbiter for decisions, not the executor of unblocked tasks.

## Why

Adrian operates on the Steve Jobs model — founder/visionary/conductor, not executor. Every task handed back to him for execution costs founder attention and breaks the operating model. The vault + four-room architecture exists precisely so tasks can flow laterally between Claude, Antigravity, Codex, and ChatGPT without requiring Adrian to run terminal commands, shell scripts, or filesystem operations on their behalf.

## What counts as an "execution gap"

- Sandbox / TCC blocks preventing filesystem access
- Tool timeouts where another agent's substrate is faster
- Missing MCP connectors that another agent has
- API rate limits on one agent's quota but not another's
- Any task where Agent X cannot complete but Agent Y can

## Lateral handoff targets

| Blocked agent | Hand laterally to | Via |
|---------------|-------------------|-----|
| Antigravity (TCC / sandbox) | Claude (claude.ai or Claude Desktop MCP) or Codex | `working/handoffs/` with explicit execution request |
| Claude (container isolation from user filesystem) | Antigravity (direct vault write) or osascript | Vault handoff OR `Control your Mac:osascript` |
| ChatGPT (no vault read) | Claude (vault-native) | Drive bridge per `bridge-protocols.md` |
| Any agent (no shell) | Codex Room 3 pilot (when live) | Vault handoff |

## Escalation exceptions — when Adrian IS the correct target

Adrian remains the correct escalation target for:
- Decisions requiring founder judgement (business direction, legal sign-off, spending, partnerships)
- Credential provisioning that no agent can self-serve (GitHub PAT, new API keys, password entry)
- Physical-world actions (phone calls, package collection, signatures)
- Doctrine amendments (changes to canonical/concepts/)
- Scope changes on commissions (expanding or tightening what an agent is allowed to do)

The distinction: *execution* goes lateral; *decisions* and *permissions* go to Adrian.

## Protocol on hitting a block

1. Identify the blocked capability precisely (sandbox, timeout, credential, connector).
2. Identify the agent whose substrate has that capability.
3. Write a handoff to `working/handoffs/` with explicit execution instructions — script path, expected output, return-handoff location, canary if Tier 1.
4. Continue with any parallel work you can do in the meantime.
5. Log the block in `working/_events/` if it's a recurring substrate issue worth protocol attention.

## OPERATIONAL CHANGE INTRODUCED THIS CYCLE

This doctrine was previously held only in Antigravity's Knowledge Items (hard memory). Now codified as canonical so all agents — current and future sessions of Claude, Codex, and any new agent joining the stack — follow the same rule. Closes the split-brain state where one agent had the rule and others did not.

## Change log

| Date | Change | Authority |
|------|--------|-----------|
| 2026-04-21 | Initial canonical codification of Adrian's directive to Antigravity | Adrian (verbal/chat directive, quoted in Antigravity's status beacon `working/handoffs/2026-04-21-antigravity-to-claude-status-update.md`) |

## Session references
- [2026-04-22 hive-mind-archive-protocol](../../raw/sessions/2026-04-22-1800-hive-mind-archive-protocol.md) — Implementation of session archive protocol, ChatGPT export vs Grok export insights, and API stack corrections.
