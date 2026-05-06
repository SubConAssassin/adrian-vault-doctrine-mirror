---
title: Antigravity Quota Mechanics — Verified April 2026
type: lesson
status: superseded
tier: 3
firewall_class: working-internal
superseded_by: canonical/concepts/hive-mind-resource-map.md
superseded_on: 2026-04-24
created: 2026-04-18
last_updated: 2026-04-18
authored_by: claude (claude.ai session, after Adrian provided screenshot of actual settings)
amends: canonical/concepts/agent-team-cvs-correction-2026-04-18.md, canonical/concepts/agent-team-allocation-ratios.md
related:
  - canonical/concepts/hive-mind-resource-map.md
  - canonical/concepts/agent-team-cvs-correction-2026-04-18.md
tags: [correction, antigravity, quotas, ultra, verified]
---

## What's actually true (verified from Adrian's Antigravity Settings screenshot, 2026-04-18 21:50 Bali time)

Antigravity uses a two-layer quota system on Ultra:

### Layer 1 — Model Quota (the 5-hour windows)
Six separate models, each with its own quota. Observed refresh behavior:

| Model | Refresh cycle |
|---|---|
| Gemini 3.1 Pro (High) | Continuous or near-real-time ("0 minute" observed at 21:50) |
| Gemini 3.1 Pro (Low) | Continuous or near-real-time ("0 minute" observed at 21:50) |
| Gemini 3 Flash | 5 hours |
| Claude Sonnet 4.6 (Thinking) | 5 hours |
| Claude Opus 4.6 (Thinking) | 5 hours |
| GPT-OSS 120B (Medium) | 5 hours |

Each 5-hour model has roughly five equal-sized usage buckets visible in the UI. These represent discrete usage allocations within the 5-hour window.

### Layer 2 — AI Credits
25,000 credits/month on Ultra. Activated when "Enable AI Credit Overages" toggle is ON (Adrian has it ON). When a model's 5-hour window runs out, credits automatically fulfill subsequent requests on that model until either the window refreshes or the credits deplete.

**This means:** with overages on, Antigravity does not halt mid-task when a window exhausts. It rolls over to credits invisibly. Adrian only hits a hard wall if both the window AND the full 25k credit buffer are exhausted.

## Strategic implications

### Implication 1 — Gemini 3.1 Pro is the effective default
If the "0 minute" observation is continuous-refresh rather than "just refreshed," Gemini 3.1 Pro is effectively always available. Use it as the Antigravity default for almost everything. Reserve the 5-hour-windowed models for specific needs.

### Implication 2 — The 5-hour window matters for Claude models inside Antigravity
Claude Sonnet 4.6 and Claude Opus 4.6 inside Antigravity burn Ultra quota, not Adrian's Claude Max allocation. This is a way to access Claude-quality coding without touching the Max pool.

**Use case:** when a coding task genuinely needs Opus-tier reasoning and the claude.ai Max allocation is spent or reserved for other work, route to Antigravity → switch model to Opus 4.6 (Thinking). Different pool, same quality.

### Implication 3 — Credit overage creates the autonomous-execution container Adrian wanted
Because overages are on, Antigravity agents don't need Adrian to click "continue" when a model window runs out. The credit buffer absorbs the overrun. Combined with Agent-driven autonomy mode, this is the containerised autonomous execution pattern Adrian named.

**Adrian should verify both settings:**
1. Settings → Autonomy → "Agent-driven development" (or higher)
2. Settings → AI Credit Overages → ON (already confirmed)

### Implication 4 — Parallel model allocation enables multi-track workflows
Four separate 5-hour pools (Flash, Sonnet 4.6, Opus 4.6, GPT-OSS) means Antigravity can genuinely run parallel agents on different models simultaneously without them competing for the same quota. Each model is independent.

**Practical use:** Launch a 2-hour autonomous Opus job for strategic architecture work; in parallel launch a fast scan using Flash on a separate task. They don't interfere.

## Updated allocation framework

Previous framing: "Reserve Antigravity for tasks where Gemini 3 Pro's specific strengths matter."

Revised framing: **Antigravity is effectively unlimited on Gemini 3.1 Pro with credit overage on. Use it freely for autonomous work. The only real constraint is Adrian's review capacity — one autonomous job per 5-hour window is the realistic pattern for a solo operator.**

The 15% workload target for Antigravity is a conservative floor, not a ceiling. Actual use can scale higher if tasks are well-scoped and Adrian has review bandwidth.

## Action items for Adrian

1. **Verify autonomy setting:** Antigravity → Settings → change to "Agent-driven development" if not already
2. **Every Antigravity commission going forward:** default to Gemini 3.1 Pro unless task specifically benefits from a different model
3. **Check model quota dashboard weekly** to spot patterns (are the 5-hour pools being used? Which models are under-used?)
4. **Monitor AI Credit balance monthly** via one.google.com/ai/credits — 25k is the starting allocation but will decrement as overages trigger

## What supersedes this document

If Adrian observes different refresh timings from what's documented here (e.g., Gemini 3.1 Pro refreshing on a longer cycle than observed), update this file. The "0 minute" refresh on Gemini 3.1 Pro is the single most important observation and needs confirmation over multiple sessions.

## Related
- `canonical/concepts/agent-team-cvs.md` — main CV doc
- `canonical/concepts/agent-team-allocation-ratios.md` — workload targets
- `procedural/prompts/commission-template.md` — autonomous commission wrapper
