---
title: Correction to Agent Team CVs — Antigravity Economics
type: lesson
status: superseded
tier: 3
firewall_class: working-internal
superseded_by: canonical/concepts/hive-mind-resource-map.md
superseded_on: 2026-04-24
created: 2026-04-18
last_updated: 2026-04-18
authored_by: claude (claude.ai session, after Adrian correction)
amends: canonical/concepts/agent-team-cvs.md
related:
  - canonical/concepts/agent-team-cvs.md
  - canonical/concepts/hive-mind-resource-map.md
tags: [correction, antigravity, credits, ultra, token-economics]
---

## What was wrong in agent-team-cvs.md

The Antigravity section of `canonical/concepts/agent-team-cvs.md` described Antigravity as "free public preview" with "free Gemini tokens." That was based on Antigravity's November 2025 launch pricing and was out of date by the time I wrote the CV doc on 2026-04-18.

## What's actually true as of April 2026

Antigravity usage is tied to the same Google AI plan tier a user has.

- **Free tier:** exists but was slashed 92% in December 2025 and is now rate-limited aggressively
- **Google AI Pro ($20/mo):** higher rate limits, refreshes every 5 hours
- **Google AI Ultra ($249.99/mo — Adrian's tier):** highest rate limits PLUS 25,000 AI credits/month

Critically, those 25,000 credits are a **shared pool** across:
- Antigravity agent work
- Jules (autonomous coding)
- Gemini CLI / Code Assist
- Flow video generation
- Nano Banana Pro image generation beyond baseline
- Deep Research
- Other Google AI surfaces

When the baseline quota runs out during heavy Antigravity use, the system falls back to burning AI credits — meaning heavy code-agent work trades directly against video and image generation capacity.

## Community-documented problems to be aware of

Google has cut Antigravity quotas four times in four months (December 2025 through March 2026). Ultra subscribers have reported workflows that previously ran 5+ hours hitting 0% quota in 90 minutes after the most recent cut, without warning or official explanation.

This is not a reason to abandon Antigravity. It IS a reason to:
1. Not treat Antigravity as infinite-capacity infrastructure
2. Not design workflows that depend on stable Antigravity quota
3. Track monthly credit burn
4. Reserve Antigravity for tasks where its specific strengths justify the credit spend

## How this changes the routing recommendations

### Before the correction (implicit in `agent-team-cvs.md`)
> "Route grunt work (build, implement, refactor, test) to Antigravity. It's free."

### After the correction
> "Route grunt work to Cowork or Claude Code — these burn your Claude Max allocation, which you're paying for regardless of use and is effectively sunk cost at the margin. Reserve Antigravity for tasks where Gemini 3 Pro's specific strengths matter (multi-file visual reasoning, browser-integrated debugging, parallel-agent workflows) OR for strategic one-offs worth the credit spend (e.g., the Testing Engine architecture doc)."

## Revised credit-aware routing

| Task type | Primary route | Secondary route | Notes |
|---|---|---|---|
| Strategic one-off autonomous work (high value, ~1-2 hr agent time) | **Antigravity** | Cowork | Worth the credit spend for strategic unlocks |
| High-volume autonomous coding (ongoing) | **Cowork / Claude Code** | Antigravity sparingly | Sunk-cost Max budget vs. finite Ultra credits |
| Live interactive coding (pair-style) | **Cowork** | — | Claude Max, no credit burn |
| Code that benefits from integrated browser + terminal | **Antigravity** | — | Gemini 3 Pro's agent IDE is genuinely differentiated here |
| Code that benefits from parallel multi-agent execution | **Antigravity** | — | No Claude surface has this |
| Everything video | **Gemini Ultra** | — | Preserve credits for this; it's the highest-leverage Ultra capability |
| Everything image (bulk) | **Gemini Ultra** | — | Baseline quota usually covers typical volumes |
| Deep Research | **ChatGPT Plus** first, then **Gemini Ultra** | — | ChatGPT has better BrowseComp and doesn't burn Ultra credits |

## Updated token economics

| Agent | Real monthly cost | Marginal cost per heavy session | Pool burn |
|---|---|---|---|
| claude.ai Opus 4.7 | $200 fixed (Max 20x) | Burns Max allocation | Claude-only pool |
| Cowork | Same $200 pool | Burns Max allocation | Claude-only pool |
| Claude Code | Same $200 pool | Burns Max allocation | Claude-only pool |
| Antigravity | Shared $250 Ultra | Burns Ultra baseline, then 25k credits, then top-up ($25-$200) | Shared Google pool |
| Gemini Ultra (images) | Same $250 | Baseline usually sufficient; exceeds burn credits | Shared Google pool |
| Gemini Ultra (video) | Same $250 | Burns credits fast | Shared Google pool |
| Gemini Ultra (Jules) | Same $250 | Burns credits | Shared Google pool |
| ChatGPT Plus | $20 fixed | Generous Plus pool | ChatGPT-only |
| SuperGrok | $30 fixed | Generous SuperGrok pool | Grok-only |

**Revised insight:** The "free lunch" agent on the team was never Antigravity. It's **Claude Max on whichever Claude surface** — claude.ai for strategy, Cowork for live coding, Claude Code for terminal-autonomous coding. The $200 is paid whether you use 1% or 100% of the allocation, so marginal use cost is zero up to the cap.

Ultra's value is concentrated in image, video, and Flow — not Antigravity specifically. Use the Ultra subscription for what's uniquely Ultra.

## What stays true from the original CV doc

- Antigravity is still the most capable autonomous-coding IDE in your stack
- Gemini 3 Pro's workspace + terminal + browser model is genuinely differentiated
- Parallel agent execution via Manager View is unique to Antigravity
- Workspace = folder means vault integration is clean

Antigravity is a real tool, still valuable, still worth using. Just not the "free grunt-work agent" I described.

## Action items for Adrian

1. Check Antigravity Settings → AI Credits balance monthly (via one.google.com/ai/credits)
2. When commissioning Antigravity work, scope the commission tightly and time-bound it
3. If an Antigravity task completes in less than 30 minutes on Ultra, credit spend is negligible. If it runs 2+ hours, it's a real cost — treat like any other budget line.
4. For grunt work Claude Max can do, prefer Cowork or Claude Code over Antigravity

## Related
- `canonical/concepts/agent-team-cvs.md` — main CV doc (now amended by this file)
- `canonical/concepts/agent-team-strategy.md` — strategic overview
- `procedural/workflows/agent-task-routing.md` — tactical routing (may need update)
