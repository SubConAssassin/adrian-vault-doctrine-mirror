---
title: Agent Team — Workload Allocation Ratios and Principles
type: framework
status: superseded
tier: 2
firewall_class: working-internal
superseded_by: canonical/concepts/hive-mind-resource-map.md
superseded_on: 2026-04-24
created: 2026-04-18
last_updated: 2026-04-18
authored_by: claude (claude.ai session, after Adrian corrective framing)
supersedes_framing_in: canonical/concepts/agent-team-cvs-correction-2026-04-18.md
related:
  - canonical/concepts/hive-mind-resource-map.md
  - canonical/concepts/agent-budget-framework.md
tags: [strategy, agents, ratios, allocation, workload, orchestration]
---

## The right frame

Adrian's AI spend across all subscriptions is approximately **$500/month**. These are subscription fees — tokens don't roll over. Every unused message, credit, or generation this month is lost forever.

**Therefore the optimization target is not token conservation. It is talent-fit utilization.**

Previous drafts of team strategy over-indexed on "how do we conserve the Antigravity credits" and "which tool is cheapest per task." That framing was wrong. Subscription tokens are sunk cost. The real question is: which agent will produce the highest-quality result for each task, spreading load across pools so no single pool is unused while another is overworked.

## Estimated monthly team capacity

| Agent | Estimated heavy sessions/month |
|---|---|
| Claude Max 20x (across claude.ai, Cowork, Claude Code) | 90-120 |
| Google AI Ultra (across Gemini app, Antigravity, Jules, Flow, image/video gen) | 80-100 |
| ChatGPT Plus | 40-60 |
| SuperGrok | 60+ |
| **Total team capacity** | **270-340 heavy sessions/month** |

Adrian, as a solo operator orienting/reviewing agent output, can probably process 4-6 agent hours per day of active work — roughly 120-180 agent sessions/month maximum. **The bottleneck is Adrian's review capacity, not tokens.**

This means on any given day, the team has meaningful unused capacity. The goal is to spread work across agents so:
1. Work gets to the best-fit specialist
2. No single pool runs out while others are idle
3. Adrian's review time isn't the blocker

## Target workload ratios

These are the intended proportions of total agent work across a typical month. Not per-task rules — orchestration directional markers.

### Claude (claude.ai + Cowork + Claude Code): 35%
**Why the largest share:**
- Orchestration role — every task touches Claude somewhere (scoping, review, integration)
- Canonical writing — only Claude writes to `canonical/`
- Voice-critical work (SS copy, OSB brand text, investor narrative, all user-facing writing)
- Complex reasoning across 5+ context sources
- Legal drafting and strategic analysis

**What Claude receives first:**
- Strategy sessions on any project
- All ecosystem-level synthesis
- User-facing text where voice fidelity matters
- Final review of other agents' output
- Coding where quality trumps cost (Opus 4.7 now leads SWE-bench)

### Gemini Ultra (images, video, Flow, Deep Research): 25%
**Why this share:**
- Only consumer-tier source for serious video (Veo 3.1)
- State-of-the-art image generation at 4K (Nano Banana Pro, 1000/day baseline)
- Flow is uniquely capable for multi-shot filmmaking
- Deep Research has 1M-token context window
- Visual production is a real ongoing need across OSB, SS, Ashta, AGA, Tri Hita, compatibility test

**What Gemini Ultra receives first:**
- All image generation (product imagery, social graphics, concept art, mood boards, diagrams)
- All video generation (product films, testimonial reels, explainer videos, investor films)
- Flow projects (multi-shot sequences, ingredient-based films)
- Large-context document processing (dump a 500-page PDF, reason across it)

### Antigravity (Ultra credits): 15%
**Why this share:**
- Genuinely differentiated capability: parallel multi-agent execution with IDE + terminal + browser
- Gemini 3 Pro's strengths specifically for visual reasoning over code
- Workspace = folder model fits vault architecture cleanly
- Adrian has 25,000 Ultra credits/month; using some of them on agentic coding is rational
- Too underused at 0% would waste the capability; too used at 30%+ crowds out video/image credits

**What Antigravity receives first:**
- Strategic autonomous coding tasks (Testing Engine architecture, compatibility test refactors)
- Multi-file refactors where workspace-wide awareness matters
- Tasks benefiting from parallel agents working different parts simultaneously
- Browser-integrated debugging and testing flows
- One-off architectural work rather than ongoing grunt

### ChatGPT Plus: 15%
**Why this share:**
- Best web research model (BrowseComp 89.3% vs Claude 79.3%)
- Computer use above human baseline (OSWorld 75%)
- Different training data catches Claude's blind spots
- Under-utilised today — Adrian has this subscription and barely touches it
- Drive bridge proven working for async handoffs

**What ChatGPT receives first:**
- All meaningful web research (competitor analysis, market scans, investor research, current-state fact-checking)
- Independent review of Claude's strategic recommendations
- Computer-use tasks (filling forms, multi-step web workflows)
- Second opinions on contentious decisions

### SuperGrok: 10%
**Why this share:**
- Narrower use case than other agents
- Real-time X data is uniquely valuable for OSB (consumer jewellery trends), Ashta (consciousness-tech buzz), AGA (Bali news)
- Math/STEM excellence relevant for Tri Hita WtE calculations
- Different-enough training to serve as a third opinion on contested topics

**What SuperGrok receives first:**
- Real-time X/Twitter trend research
- Breaking news relevance checks (Bali politics affecting AGA, WtE industry news)
- STEM calculations (WtE efficiency modelling, Ashta testing engine math)
- Contested political/cultural questions where diverse training matters

## The spread-load principle

When a task could reasonably go to two or more agents, route to whichever pool has seen less use this week. This prevents any one pool from being depleted while others sit idle.

**Example application:**
- "Research current consciousness-tech startup funding" — could go to ChatGPT (web), Gemini (Deep Research), or SuperGrok (X trends). If ChatGPT is under-used this week, route there. If you need real-time social sentiment, route to SuperGrok. If you need long-context synthesis across many docs, route to Gemini.
- "Refactor frameworks.js into JSON pack" — could go to Antigravity, Cowork, or Claude Code. If Antigravity has been untouched this week, route there. If Ultra credits already heavily used on video this week, route to Cowork on Max budget.
- "Write the Ashta waitlist landing copy" — Claude only. Voice fidelity is non-negotiable. No routing decision.

## Anti-patterns to watch for

1. **Claude-only gravity** — defaulting every task to me because I'm the orchestrator. Don't. Route genuine grunt work to other agents.
2. **Gemini credit burn** — if you're at 80% Ultra credit use by day 15 of the month, you've probably been routing image/video work that could have gone to simpler tools, or Antigravity work that could have gone to Claude Code.
3. **Unused ChatGPT** — a $20/month subscription should produce at least 15-20 real work sessions/month. If it's sitting at 2-3, you're not routing web research to it.
4. **Neglected SuperGrok** — $30/month for a real-time X data source. If you're not using it at least weekly, either cancel it or route appropriately.

## Checking the ratios

**Monthly retrospective question:** "Roughly, did I use Claude 30-40% of the time, Gemini 20-30%, Antigravity 10-20%, ChatGPT 10-20%, Grok 5-15%?"

If any pool is dramatically off target:
- **Claude over 50%** — you're under-using the team; route more grunt work and research out
- **Gemini over 35%** — you're either producing huge creative volumes (fine) or routing Antigravity work to Gemini unnecessarily
- **Antigravity over 25%** — check Ultra credit balance; reserve Antigravity for IDE-specific strengths
- **ChatGPT under 10%** — you're missing the best web-research tool in the stack
- **Grok under 5%** — use it weekly or cancel the $30 subscription

## What this replaces

This allocation framework replaces the earlier "conserve Antigravity credits" framing in:
- `canonical/concepts/agent-team-cvs-correction-2026-04-18.md`

The correction about Antigravity's pricing is still true (it burns Ultra credits, not free tokens). But the framing that this means "avoid Antigravity" was wrong. The correct framing is "use Antigravity in its 15% share of team workload for tasks matching its strengths."

## Related
- `canonical/concepts/agent-team-cvs.md` — individual agent capabilities
- `canonical/concepts/agent-team-cvs-correction-2026-04-18.md` — Antigravity credit economics
- `procedural/workflows/agent-task-routing.md` — tactical per-task routing
