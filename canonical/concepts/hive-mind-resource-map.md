---
title: Hive Mind Resource Map
type: doctrine
status: active
tier: 2
firewall_class: working-internal
version: 1.0
last_updated: 2026-04-24
supersedes: 
  - canonical/concepts/agent-team-cvs.md
  - canonical/concepts/agent-team-cvs-correction-2026-04-18.md
  - canonical/concepts/agent-team-allocation-ratios.md
  - canonical/concepts/antigravity-quota-mechanics-verified.md
related:
  - canonical/concepts/api-integration-doctrine.md
  - canonical/concepts/bridge-protocols.md
  - canonical/concepts/frictionless-operator-doctrine.md
  - canonical/concepts/tooling-preference-doctrine.md
---

# Hive Mind Resource Map

## 1. Scope
This document serves as the single ground-truth map of every AI resource at Adrian's disposal, accompanied by definitive routing rules. It officially supersedes the older 4-document `agent-team-cvs` chain as the authoritative reference for understanding what capabilities exist and where tasks should be directed.

## 2. Stack Inventory

- **Claude Max 5X (from $100/mo per claude.com/pricing, verified 2026-04-24):** Accessed via claude.ai, Claude Code, and Cowork. Anthropic advertises this tier as "5x Pro usage" — exact per-window message/token/session-length quotas are not published at that granularity; treat "5x Pro baseline" as the planning heuristic. Weekly cap exists on top of the rolling-window allowance.
  - *Role:* The scarce, high-judgement, long-form resource. Ideal for vault-native MCP operations, deep reasoning, strategic synthesis, and nuanced code review.
- **Google AI Ultra ($249.99/mo - Adrian's tier):** Encompasses Antigravity, Jules, Gemini CLI/Code Assist, Flow, Nano Banana Pro, and Deep Research. Powered by a shared pool of 25,000 AI credits per month.
  - *Role:* The abundant execution engine. Ideal for high-volume execution, image/video generation, and extensive research and coding grunt work.
- **ChatGPT API (gpt-5.4 / gpt-4.1):** Direct API integration.
  - *Role:* Cross-reference, secondary review, and deep internet research. See `api-integration-doctrine.md` for usage details.
- **Grok API (grok-4, image, video):** Direct API integration.
  - *Role:* Unfiltered divergent thinking, capability probing, and alternative image/video generation. See `api-integration-doctrine.md` for usage details.

## 3. Ultra Stack Unconstrained
**Treat the Google AI Ultra stack as unconstrained for planning purposes.**
As established by Adrian on 2026-04-24: *"Antigravity has more tokens than you can possibly use."* Tier math is no longer the binding constraint. By default, route heavy processing, grunt work, high-volume tasks, and long-running autonomous jobs to the Ultra stack (primarily Antigravity).

## 4. Routing Rules (Capability-First, Budget-Second)

Routing decisions should be based on capability fit first, then economy.

- **Scarce Resource (Claude 5X):**
  Reserve for work where Claude's specific strengths are load-bearing. This includes long-form writing, vault-native MCP operations, extended architectural thinking, and high-stakes code review where nuance is required.
- **Abundant Resource (Ultra Stack / Antigravity):**
  Default target for file-I/O intensive work, complex synthesis, broad research, bulk processing, and scheduled autonomous jobs. Use this capacity freely.
- **Cross-Reference Resources (ChatGPT & Grok APIs):**
  Call these APIs when a second opinion, capability probe, or divergent thinking would improve the final answer. These are part of an explicit collaboration doctrine designed to prevent echo chambers, not merely fallback options.

## 5. Cost Snapshot (Approximate, 2026-04-24)
- **Google AI Ultra:** $249.99/mo
- **Claude Max 5X:** From $100/mo baseline (claude.com/pricing, verified 2026-04-24). "5x Pro usage" per Anthropic; exact per-window quotas not publicly published.
- **External APIs (ChatGPT / Grok):** ~$1-5/mo per API
- **Grok Subscription:** $10/mo for 3 months (may cancel)
