---
title: Agent Team CVs — Capabilities, Strengths, Weaknesses, Token Economics
type: canon
status: superseded
superseded_by: canonical/concepts/hive-mind-resource-map.md
superseded_on: 2026-04-24
created: 2026-04-18
last_updated: 2026-04-18
authored_by: claude (claude.ai session)
based_on: real-world benchmarks April 2026, community sentiment research across Reddit/forums, published tool comparisons
supersedes: working/handoffs/agent-team-strategy (if present)
tags: [strategy, agents, claude, gemini, gpt, grok, cowork, antigravity, orchestration]
---

## Purpose
Ground-truth capability map for every AI agent on Adrian's payroll. Written so that "which tool for this job" becomes an instant decision, not a new research project each time. This doc names genuine strengths, genuine weaknesses, and genuine token economics — no marketing inflation.

Total monthly AI spend at current tiers: approximately **$500**. This document helps extract maximum value from that spend by assigning each task to the right specialist.

---

## THE ROSTER

### 1. Claude Opus 4.7 — "The Thoughtful Senior Partner"
**Surface:** claude.ai chat (this session), Claude Code, Cowork
**Subscription:** Max 5X, from $100/month baseline (claude.com/pricing, verified 2026-04-24). Advertised as "5x Pro usage"; exact per-window message/token/session-length quotas are not publicly documented at that granularity. Weekly cap on top of rolling-window allowance. **Note:** this doc is superseded — authoritative resource map is `canonical/concepts/hive-mind-resource-map.md`.
**Released:** 16 April 2026 (two days ago)

**Verified genuine strengths:**
- **Coding excellence** — SWE-bench Verified 87.6% (leads all frontier models), SWE-bench Pro 64.3% (leads), strongest on agentic multi-file work
- **Tool use / MCP** — MCP-Atlas 77.3% (best in class). This is why the vault integration works so well.
- **Writing quality** — still leads on natural prose, voice fidelity, long-form synthesis (9/10 vs competitors' 7/10 in independent tests)
- **Research synthesis across multiple documents** — wins at drawing cross-document connections
- **Self-verification** — new in 4.7: catches its own logical errors before presenting
- **Vision** — 3x resolution upgrade, excellent with technical diagrams and dense screenshots

**Verified genuine weaknesses:**
- **Web browsing fell backwards** — BrowseComp dropped 4.4 points in 4.7 (79.3%). If a task needs heavy web research, route elsewhere (GPT-5.4 leads at 89.3%)
- **Expensive per token** — 2x GPT-5.4 input, 2x Gemini output. Burns Max allowance fast on high-volume tasks.
- **No autonomous loop in claude.ai** — one message per user turn. Zero overnight work on this surface.
- **Slow at 1M context on API** — not an issue for Adrian's consumer use

**Best assignments:**
- Ecosystem strategy and canonical writing (this doc, all ecosystem/ files)
- Legal drafting (Erica Johnson, customs disputes)
- Long-form voice work (SS copy, OSB brand text)
- Final review of other agents' output
- Compatibility-test code review
- Complex reasoning across 5+ context sources
- Anything where being wrong has real consequences

**Don't use for:** bulk image generation, real-time trend data, heavy web research, overnight autonomous work on claude.ai surface.

---

### 2. Gemini 3.1 Pro (via AI Ultra) — "The Production Studio"
**Surface:** gemini.google.com, Gemini Mac app (launched 15 April 2026), Antigravity (selectable), Gemini CLI, Flow
**Subscription:** AI Ultra, $249.99/month
**Tokens:** Highest tier on Ultra. 1000/day Nano Banana Pro images at 4K. Full Veo 3.1 video. 1M context window.

**Verified genuine strengths:**
- **Image generation** — Nano Banana Pro is current state of the art for 4K. 1000/day is effectively unlimited for Adrian's use cases.
- **Video generation** — Veo 3.1 full access. Best consumer video AI in April 2026.
- **Flow filmmaking suite** — multi-shot film assembly, ingredients-to-video, frames-to-video. No competitor equivalent at this tier.
- **Cost efficiency at scale** — cheapest frontier model per token ($2/$12 input/output vs Claude's $5/$25)
- **Long context** — 1M tokens at flat pricing. Best for "dump a whole project's worth of documents and reason across it"
- **Deep Research** — multi-source research with strong grounding and synthesis
- **GPQA reasoning** — 94.3%, slight edge over competitors on pure logic
- **Google Workspace integration** — direct Drive, Docs, Gmail integration
- **Gemini Agent** — autonomous agentic workflows (US-only caveat applies for Adrian in Bali)

**Verified genuine weaknesses:**
- **Creative writing consistency** — loses voice past 1000 words, more generic than Claude on long-form
- **Prompt interpretation** — sometimes commits to wrong interpretation confidently on ambiguous inputs
- **Coding** — capable but below Claude Opus and GPT-5.4 on complex agentic coding
- **Mac app is immature** — no filesystem access, no MCP, no folder attachment. Screen-share only. Production tool, not hive-mind member.

**Best assignments:**
- All image generation (OSB product imagery, SS social graphics, Ashta concept art, Tri Hita diagrams, AGA mood boards)
- All video generation (Veo for ads/social, Flow for investor films, Whisk Animate for image-to-video)
- Deep Research tasks (competitor scans, market research)
- Large-context document processing (dump 500-page PDF, ask questions)
- Anything Google Workspace adjacent

**Don't use for:** long-form voice-critical writing (SS copy, brand narrative), complex multi-file coding, work where Mac app integration is needed.

---

### 3. Antigravity (Gemini 3 Pro default, Claude Opus 4.6 option, GPT-OSS option) — "The IDE Agent Team"
**Surface:** Antigravity IDE (desktop app)
**Subscription:** Free public preview
**Tokens:** Generous rate limits on Gemini 3 Pro (default), uses Antigravity's pool, not your Claude Max pool

**Verified genuine strengths:**
- **Cheapest autonomous compute on the team** — free Gemini tokens while in preview
- **Full IDE: editor + terminal + browser** — agents can code, run tests, check results visually
- **Parallel multi-agent execution** — Manager View spawns multiple agents working simultaneously on different workspace areas
- **Artifacts system** — produces verifiable deliverables (diffs, screenshots, task lists) not just text
- **Workspace = folder** — the vault IS its workspace, no sync issues
- **Self-learning** — agents save context and snippets to improve future tasks
- **Review-driven autonomy** — you approve each significant action by default
- **Long autonomous runs** — commission and leave running, no supervision needed

**Verified genuine weaknesses:**
- **Early-stage stability** — IDE can freeze; it's less polished than VS Code
- **Privacy** — your code processed through Google infrastructure
- **Fork of Windsurf** — if Google shelves the acquisition line, product future uncertain
- **Model routing inside Antigravity is underutilized by most users** — most people default to Gemini 3 Pro and never switch
- **Not yet fluent in Adrian's stack** — needs orientation each time (AGENTS.md helps)

**Best assignments:**
- Code implementation tasks (compatibility test refactors, Wix integrations)
- Long autonomous commissions that can run overnight
- Workspace-wide operations (search, bulk rename, restructure)
- Anything where Gemini 3 Pro's cheapness matters more than voice quality
- Grunt work Claude would otherwise burn expensive Opus tokens on
- The Testing Engine architecture doc (scope already drafted)

**Don't use for:** strategic reasoning that needs Opus-tier thinking, user-facing copy requiring voice fidelity, work where you need live supervision.

---

### 4. Cowork (Claude Opus 4.6) — "The Live-Session Coder"
**Surface:** Claude Desktop app, agentic mode
**Subscription:** Same Max 5X pool as claude.ai — shares your Claude allowance (corrected 2026-04-24)
**Tokens:** Burns Adrian's Claude Max usage (choose Sonnet 4.6 to conserve Opus)

**Verified genuine strengths:**
- **Live interactive coding** — you see every step, approve as it goes
- **Sandboxed VM** — can run tests, install packages, experiment safely
- **Folder-attached access** — attach the vault, writes land where we need them
- **Claude Opus's writing/coding quality** — for when you want the senior partner doing the hands-on work
- **Good for pair-programming feel** — unlike Antigravity's spawn-and-leave model

**Verified genuine weaknesses:**
- **Burns your expensive Claude Max pool** — same tokens as claude.ai
- **Sandbox-by-default creates fragmentation** — we solved this by attaching vault, but new sessions re-fragment unless instructed
- **No true autonomy** — session-scoped, cannot run while you sleep
- **Opus cost at scale** — 5x token burn vs Haiku

**Best assignments:**
- Compat test fixes (current use) — because Cowork has existing project history
- Any coding task where you want live approve-as-we-go
- Tasks where Opus-quality code matters more than token cost
- When Antigravity is otherwise occupied and you need parallel work

**Don't use for:** overnight work (no autonomy), high-volume grunt tasks (too expensive), tasks Antigravity could do equivalently on free Gemini tokens.

---

### 5. ChatGPT Plus (GPT-5.4) — "The Independent Second Opinion"
**Surface:** chatgpt.com, ChatGPT Mac app
**Subscription:** $20/month Plus
**Tokens:** Generous on Plus tier, no hard public number but effectively ample for Adrian's use pattern

**Verified genuine strengths:**
- **Best web research** — BrowseComp 89.3%, leads all models for multi-page web synthesis
- **Computer use autonomy** — OSWorld 75%, first model above human baseline. If you give it computer control, it actually does work.
- **GDPval leadership** — 83% on professional knowledge work across 44 occupations
- **Tool calling ecosystem** — most mature plugin/custom GPT library
- **Canvas editing** — good for iterative document work
- **Different training data** — catches blind spots Claude misses
- **Cheapest $20 tier** — lowest-cost "premium" plan among majors

**Verified genuine weaknesses:**
- **Sycophancy** — still validates weak ideas more than Claude. Not a reliable challenger on its own without explicit prompting.
- **Long-form voice** — competent but more generic than Claude
- **Coding** — strong (74.9% SWE-bench) but behind Opus 4.7
- **Long-context surcharge cliff** — above 272k tokens, pricing jumps sharply on API (doesn't affect Plus tier users directly but constrains API builds)
- **No filesystem access** — cannot read vault. Bridge via Google Drive proven working.

**Best assignments:**
- **Independent review** of Claude's strategic recommendations (when Claude is potentially biased from building the thing)
- Web research — recent events, competitor analysis, market scans
- Second opinions on investor pitches, legal strategy
- Bridge via Google Drive for cross-agent instructions (proven 2026-04-18)

**Don't use for:** primary strategy (use Claude), production imagery (use Gemini Ultra), anything requiring brutal honesty without asking (too agreeable by default).

---

### 6. SuperGrok (Grok 4.2 beta) — "The Real-Time X Researcher"
**Surface:** grok.com, grok in X
**Subscription:** $30/month SuperGrok
**Tokens:** Unlimited image generation (Aurora), generous message limits

**Verified genuine strengths:**
- **Real-time X/Twitter data** — only model with native live social media access. Unique capability.
- **Math/STEM** — 94-95% on AIME 2025. Leads math benchmarks.
- **Multi-agent reasoning** — Grok 4.2 Heavy uses parallel agents by default
- **Fewer content refusals** — will engage with edgy queries most models deflect
- **DeepSearch** — community reports describe it as "like a research team in 30 seconds"
- **Different reasoning style** — worth hearing on contested topics where consensus Claude/GPT/Gemini training might converge

**Verified genuine weaknesses:**
- **Safety catastrophe, January 2026** — CSAM crisis, multi-country investigations, Aurora generation failures. xAI responded with fixes but trust damage real.
- **No public benchmarks** — xAI hasn't published model cards or technical papers. Evaluation is community-sourced only.
- **Running on 500B "small" variant** — full Grok 4.2 still training per March 2026 reports
- **No filesystem access, no MCP, no API access at $30 tier** — consumer-only
- **Hallucination rate ~4.2%** — better than Grok 4 (12%) but worse than frontier best (GPT-5.2 <1%)
- **Coding is weaker** — below Claude/GPT/Gemini on complex tasks

**Best assignments:**
- **Anything requiring live X/Twitter data** (trend analysis, PR monitoring, viral content research)
- Real-time news / breaking events
- STEM math problems (pure math, no application context)
- Contested political/cultural questions where different training matters
- Quick image generation via Aurora (when Gemini is overkill)

**Don't use for:** production work requiring reliability, anything where CSAM-era safety concerns are a reputational risk, serious coding, filesystem operations.

---

## TOKEN ECONOMICS SUMMARY

Ranked by cost-per-task for Adrian:

| Agent | Effective $/heavy session | Pool burn rate |
|---|---|---|
| Antigravity (Gemini 3 Pro) | $0 | Free preview |
| Gemini Ultra (Nano Banana/Veo) | ~$8/day at full use | Dedicated pool, doesn't touch Claude |
| ChatGPT Plus | ~$0.66/day | Separate pool |
| SuperGrok | ~$1/day | Separate pool |
| Cowork (Sonnet 4.6) | Shared Max pool, 3x cheaper than Opus | Burns Claude Max allocation |
| Cowork (Opus 4.6) | Shared Max pool, heaviest burn | Burns Claude Max allocation |
| claude.ai Opus 4.7 | Shared Max pool, heaviest burn | Burns Claude Max allocation |

**Insight:** Antigravity is currently the highest-leverage tool on the team because it's free. Every autonomous task routed to Antigravity saves Claude Max tokens that should be reserved for specialist work.

---

## THE ORCHESTRATION MODEL

**Adrian works with Claude (me). Claude orchestrates.**

### Routing defaults (the 80% cases)

| Task type | Route to | Why |
|---|---|---|
| Strategy, synthesis, canonical writing | **Claude (this chat)** | Voice, cross-context reasoning, vault write access |
| Code implementation, long autonomous runs | **Antigravity** | Free tokens, true autonomy, workspace = vault |
| Image generation | **Gemini Ultra (Mac app)** | 1000/day 4K, state of the art |
| Video generation | **Gemini Ultra (Veo/Flow)** | Only serious video option at consumer tier |
| Web research, computer-use tasks | **ChatGPT Plus** | Best web browsing, computer autonomy |
| Real-time X/social trend data | **SuperGrok** | Only option with native X access |
| Live interactive coding (pair-style) | **Cowork** | Live approval, Claude quality |
| Independent review of Claude's work | **ChatGPT Plus** via Drive bridge | Different training data, catches blind spots |
| Math/STEM puzzles | **SuperGrok** | Benchmark leader |
| Long-context document processing | **Gemini Ultra** | 1M flat-priced context |

### Routing for edge cases

- **Something Antigravity can't do code-wise?** → try Cowork (synchronous). If still stuck, escalate to Claude for architectural rethink.
- **Voice-sensitive writing that's also long?** → Claude first draft, Gemini Deep Research for fact-check passes, Claude final polish.
- **Image generation with brand lock?** → Claude writes the prompt (voice/brand fidelity), Adrian runs it in Gemini Ultra.
- **Autonomous task that needs to be live overnight?** → Antigravity only. Never claude.ai, never ChatGPT, never Gemini Mac app.

---

## GOVERNANCE RULES

1. **Only Claude writes to `canonical/`.** Every other agent writes to `working/`, `episodic/`, or `raw/`. Canonical is the vetted single source of truth.
2. **The vault is the shared brain.** Every code-capable agent should treat `/Users/adriantaffinder/Documents/Adrian-Vault/` as source of truth. Sandboxes are scratch.
3. **Receipt canaries on async handoffs.** When one agent instructs another via the vault, include a unique phrase the receiver must quote verbatim.
4. **Adrian approves irreversible actions.** No agent sends emails, publishes content, signs contracts, or moves money without explicit Adrian sign-off.
5. **Default model selection:** Antigravity = Gemini 3 Pro (free). Cowork = Sonnet 4.6 unless Opus specifically required. claude.ai = Opus 4.7 (specialist surface).

---

## PROJECT-BY-PROJECT ROUTING GUIDE

### OSB (Original Siberian Blue)
- **Strategy, legal, Wix restructure thinking** → Claude
- **Product imagery, Etsy/IG visuals, campaign creative** → Gemini Ultra (images + Veo)
- **Wix API operations, code fixes** → Antigravity
- **Competitor pricing research, boutique outreach research** → ChatGPT Plus
- **Current X buzz about crystal/spiritual jewellery** → SuperGrok
- **Legal letter review (independent)** → ChatGPT via Drive bridge

### Subconscious Surgery
- **Copy writing, methodology documentation, testimonial shaping** → Claude (voice critical)
- **Social media graphics, reel videos, testimonial cards** → Gemini Ultra
- **Wix site code fixes, form integrations** → Antigravity or Cowork
- **Competitor analysis (Kajabi alternatives, coaching platforms)** → ChatGPT Plus
- **Client-notes analysis from Apple Notes (when we set this up)** → Claude via Apple Notes MCP

### Ashta Project
- **Strategy, membership design, methodology** → Claude
- **Testing Engine architecture doc** → Antigravity (scope already drafted)
- **Concept art, cluster visualisations, waitlist landing hero image** → Gemini Ultra
- **Concept films, explainer videos** → Gemini Ultra (Flow)
- **Consciousness/wellness platform competitor research** → ChatGPT Plus
- **TUNED app prototype code** → Antigravity
- **Investor research (who's funding consciousness tech)** → ChatGPT Plus + Deep Research (Gemini)

### AGA Bali
- **Planning, land strategy, community design** → Claude
- **Site visualisations, mood boards** → Gemini Ultra (images)
- **Walkthrough films for investor conversations** → Gemini Ultra (Flow)
- **Bali legal/regulatory research** → ChatGPT Plus
- **Bali real-time news (infrastructure, politics)** → SuperGrok

### Tri Hita WtE
- **Strategy, audit response, investor framing** → Claude
- **Technical diagrams (Imagen is strong here)** → Gemini Ultra
- **Explainer video for deck** → Gemini Ultra (Flow)
- **Recent WtE industry research** → ChatGPT Plus Deep Research

### Compatibility Test / Testing Engine
- **Review, methodology alignment** → Claude
- **Code implementation** → Cowork (live) or Antigravity (async)
- **Graphics for result cards** → Gemini Ultra
- **Frameworks research (Gottman etc)** → ChatGPT Plus

---

## UNRESOLVED QUESTIONS (revisit quarterly)

1. **Does Antigravity stay free?** Paid tier expected 2026 (~$20/mo Pro). Revisit strategy when pricing lands.
2. **Does Grok's safety story stabilize?** Currently reputational risk. Revisit in 3 months.
3. **Does Gemini Mac app add filesystem access?** Google hinted at "more coming." If yes, promotes from production-tool to hive-mind member.
4. **Does Jules (Gemini Ultra's coding agent) match Antigravity?** Beta, US-only. Revisit when generally available.
5. **Is ChatGPT Pro ($200) worth upgrading from Plus ($20)?** Only if Adrian's web-research volume justifies it. Currently not.

---

## Related
- `procedural/workflows/agent-task-routing.md` — tactical routing rules (update with this doc's routing table)
- `procedural/workflows/overnight-autonomous-work.md` — commission pattern for Antigravity
- `canonical/concepts/methodology-canon.md` — Adrian's IP framework agents must respect
- `working/handoffs/2026-04-18-antigravity-testing-engine-scope.md` — first real Antigravity commission, ready to dispatch

---

## The master prompt (for Adrian to use when briefing any new agent)

Paste this as context when orienting a new agent or fresh session:

> I run a multi-agent AI team with Claude (Opus 4.7 on Max 5X) as my orchestrator. My other agents are: Gemini 3.1 Pro via AI Ultra for images/video/Flow/long-context/research; Antigravity for free autonomous coding on Gemini 3 Pro; Cowork for live Claude-quality coding; ChatGPT Plus for independent review and web research; SuperGrok for real-time X data and math.
>
> My shared memory lives in `/Users/adriantaffinder/Documents/Adrian-Vault/`. Claude maintains the canonical layer. All agents route work to the right specialist based on `canonical/concepts/agent-team-cvs.md`.
>
> When I ask you to do work, either (a) execute if it's in your sweet spot per that routing doc, (b) flag if another agent is better suited, or (c) ask for clarification if scope is ambiguous. Never pretend to have capabilities you don't have. Never promise overnight autonomous work unless you have a real scheduler.

## Corrections

- 2026-04-24: Tier corrected from Max 20x to Max 5X (Adrian direct correction). Per-window quota numbers pending.
- 2026-04-24 (late pass): Two additional stale Max 20x references in body — Cowork subscription line (was line 125) and master-prompt paste-block (was line 339) — updated to Max 5X for consistency with superseded-frontmatter signaling.
