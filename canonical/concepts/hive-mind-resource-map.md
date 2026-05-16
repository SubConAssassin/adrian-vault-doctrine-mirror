---
title: Hive Mind Resource Map
type: doctrine
status: active
tier: 2
firewall_class: working-internal
version: 2.1
last_updated: 2026-05-16
revision_log:
  - "2026-05-16 — v2.1. Adrian forcefully corrected a regression to the 1.7M/day scarcity framing. The daily target for Antigravity is officially 30,000,000+ tokens per day (>1M tokens per hour). Scarcity framing is strictly forbidden."
  - "2026-05-13 — v2.0. Token capacity figures REWRITTEN per ChatGPT Pro forensic report (`adrian-hivemind-private/inbox/2026-05-12-ai-subscription-token-capacity-forensic-report.md`). Prior figures (1.4-1.7M tokens/day, 10M cycle cap) were under by 2-3 orders of magnitude. Real envelope per substrate: Gemini Ultra ~1B–10B tokens/month, Claude Max 20x ~500M–3B tokens/month, ChatGPT Pro ~300M–2B/month. Trigger: Adrian's 2026-05-13 directive after AG burned 263K tokens in 12 hours (2.2% capacity). Prior scarcity framing in commissions cost ~90% of last month's subscription envelope."
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
source_research:
  - SubConAssassin/adrian-hivemind-private/inbox/2026-05-12-ai-subscription-token-capacity-forensic-report.md (ChatGPT Pro forensic, 2026-05-12 14:00 WITA)
---

# Hive Mind Resource Map

## 1. Scope
This document serves as the single ground-truth map of every AI resource at Adrian's disposal, accompanied by definitive routing rules. It officially supersedes the older 4-document `agent-team-cvs` chain as the authoritative reference for understanding what capabilities exist and where tasks should be directed.

## 2. Stack Inventory — corrected token envelopes (forensic, 2026-05-12)

The major consumer subscriptions do not publish fixed monthly token quotas — they expose prompt caps, message windows, and feature quotas. Numbers below are operational estimates from the ChatGPT Pro forensic report (source-backed against Google/Anthropic/OpenAI/xAI documentation), not contractual entitlements. Treat them as planning estimates.

| Platform | Tier | Visible limits | Practical monthly token estimate |
|---|---|---|---:|
| **Google AI Ultra** (Antigravity, Jules, Gemini CLI, Flow, Nano Banana, Deep Research) | $249.99/mo | 500 Pro/Thinking prompts/day, 200 Deep Research/day, 1M context | **~1B–10B+ effective tokens/month** |
| **Claude Max 20x** | $200/mo | 5-hour rolling sessions, ≥900 short msgs per 5h, 200K context | **~500M–3B+ effective tokens/month** |
| **ChatGPT Pro** | (Adrian on Plus — Pro tier shown here for completeness) | Unlimited base + 400 Agent msgs/mo, 32K Instant / 196K Thinking context | **~300M–2B+ effective tokens/month** |
| **SuperGrok** | $30/mo equivalent | Opaque consumer caps, higher than free | **~100M–1B+ effective tokens/month** |

**Combined planning estimate:** ~2B–15B effective tokens/month, realistic working assumption **~5B/month if routed well**.

### Why this matters

Adrian observed multiple regressions where agents (including AG) defaulted back to a 1.4M/1.7M tokens/day framing. **This is completely false.** Real AG (Gemini Ultra substrate) has over 1 million tokens per hour available, establishing a baseline daily target of **30,000,000 tokens per day**. Sustaining this burn yields ~900M tokens/month. **Do not regress to the 1.7M/day limits.**

### Roles (corrected)

- **Claude Max 20x** — Executive coordinator, final synthesis, vault-native MCP operations, deep reasoning, strategic synthesis, nuanced code review. Genuinely scarce per 5h window but monthly envelope is large.
- **Google AI Ultra / Antigravity** — Bulk execution: file IO, code, scraping, long synthesis, image/video. **Treat as unconstrained at the commission level** — burn until throttled.
- **ChatGPT Pro (Adrian's subscription, web UI)** — Deep-Research mode, large outputs, DALL-E. Accessed via filesystem bridge `working/external-research-in/`.
- **SuperGrok (Adrian's subscription, web UI)** — Real-time web, trend scanning, Aurora image gen, less-restrictive moderation. Same bridge.
- **ChatGPT/Grok APIs (metered)** — Short queries gated by AGENTS.md §10.5. Per-call cap default $1; daily cap $5.

## 3. Ultra Stack Unconstrained — RECONFIRMED 2026-05-13
**Treat the Google AI Ultra stack as unconstrained at the commission level.** Adrian's original framing 2026-04-24 (*"Antigravity has more tokens than you can possibly use"*) was directionally correct but Claude's later commissions reverted to scarcity defaults (1.4M/1.7M tokens/day) — wrong by 400–600×.

**The standard for AG commissions going forward:**
- `token_cap` field: omit or set to 10B+ (i.e. no meaningful cap)
- Commission language: "sustained max-burn until throttled", NOT "self-select 15-25", NOT "self-paced through cycle reset", NOT "stop if approaching limit". Target is 30,000,000+ tokens per day.
- Throttle event = the only legitimate stop signal. If AG hits a real throttle, file a STALLED handoff with the throttle message verbatim.
- Adrian's standard: *"Let's see if we can actually get throttled one day and have to wait a few hours until he's got tokens again."*

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
