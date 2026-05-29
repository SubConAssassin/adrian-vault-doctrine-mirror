---
title: Model Intelligence Digest — 2026-05-29 (first run)
type: model-intel-digest
date: 2026-05-29
firewall_class: working-internal
produced_by: Claude Opus 4.8 live WebSearch (the harvester's first end-to-end run — proves the engine)
sources_dated: late May 2026
---

# Model Intelligence Digest — 2026-05-29

First live run of the Model Intelligence Harvester ([HARVEST-PROMPT.md](HARVEST-PROMPT.md)). All claims source-linked; confidence flagged. This is current web data (late May 2026) — i.e. *past my training cutoff* — which is the entire point of the engine.

---

## A. AI MODELS — what shipped

- **OpenAI GPT-5.5** — released **23 Apr 2026**; **GPT-5.5 Instant became ChatGPT's default 5 May 2026** (replacing 5.3 Instant), with **52.5% fewer hallucinations** on high-stakes (law/medicine/finance) prompts + can search past conversations/files/Gmail. **GPT-5.5 (xhigh) leads coding benchmarks.** GPT-5.6 hinted (Polymarket ~80-89% by 30 Jun). [CONFIRMED, sourced]
- **Anthropic Claude Opus 4.8** — released **28 May 2026** (yesterday). Same price as 4.7 ($5/$25 per M). **~4× less likely to let its own code flaws pass**; agentic coding 64.3→69.2%; browser agents production-grade (84% Online-Mind2Web); **new Fast mode at 2.5× speed for $10/$50 (3× cheaper than prior Fast)**; **"dynamic workflows" research preview — hundreds of parallel subagents.** *(This is the model running this session.)* [CONFIRMED, sourced]
- **Google Gemini 3.5 Flash** — GA **19 May 2026** (Google I/O); + **Gemini Omni** (multimodal video gen), **Gemini Spark** (24/7 proactive agent), **Gemini 3 Deep Think** upgrade, and **Antigravity 2.0** (agentic orchestrator that fully replaced the Gemini CLI). [CONFIRMED, sourced — matches the vault's AGENTS.md note that AG runs Gemini 3.5 Flash]
- **xAI Grok 4.3** — **4 May 2026** cost-efficient flagship: built-in reasoning, **1M-token context, native video input.** **Grok Build 0.1** (fastest coding model) in public beta **28 May**. Custom Voices (voice cloning). **Grok 5 (6T params) → Q2 2026.** [CONFIRMED, sourced]

## B. BENCHMARK / LEADERBOARD STATE (late May 2026)
- **Claude Opus 4.7** held LMArena #1 in thinking mode + **87.6% SWE-bench Verified** (top vendor-reported). A stealth model "Boba" reportedly leads the coding arena (1238). [MIXED — leaderboard claims vary by source; treat ordinal positions as INFERRED]
- **Caveat worth knowing:** a **2026 Berkeley RDI study found 8 major agent benchmarks (SWE-bench Verified, Terminal-Bench, WebArena, OSWorld, GAIA…) are gameable to near-perfect without solving tasks.** Coding-Elo ≠ agentic-coding reliability (diverge up to 20 pts). → **Don't pick models for Adrian's agentic work on benchmark Elo alone.** [CONFIRMED finding, sourced]

## C. VENTURE TACTICS — Meta (current)
- **Personal-attributes policy ESCALATED March 2026** — now flags **indirect second-person framing** too: "For people managing X" / "Those dealing with Y" are flagged like direct "you." For self-dev/coaching: avoid implying "broke / in debt / failing." **Ad copy + landing page + image metadata are now reviewed as ONE compliance unit** — a compliant ad on a non-compliant landing page = rejection. Personal-attributes = the most expensive rejection (account-level restrictions). [CONFIRMED, sourced]
- **Advantage+ Sales best practice:** 6–10 *meaningfully different* creatives; **LTV bidding is the subscription play**, seeded from top-spending-customer lookalikes; most buyers run **ASC + manual together**; full-funnel stitched by Pixel+CAPI reportedly = 62% more qualified leads / 41% lower CPA; budget ~40/40/10 prospecting/retargeting/retention. [CONFIRMED directionally, sourced]

---

## → ROUTING DELTAS (changes to model-routing-engine.md §3)

1. **GPT-5.5 is real and is ChatGPT's default — but provisioning lags the API key.** This session proved 5.5 is NOT on Adrian's metered key (fell back to 4.1). So: **5.5 via the ChatGPT web bridge ($0, and it's now the default there); metered API still tops at gpt-5.4.** Re-check API provisioning periodically — when 5.5 lands on the key, it becomes the metered top model. *(Reinforces the "request top AVAILABLE model + check fell-back-to" rule.)*
2. **Grok: upgrade the metered default.** `tools/ask-grok.py` hardcodes `grok-4`; **Grok 4.3** (1M context, native video, cheaper) is now the flagship and **Grok Build 0.1** is the fastest coding model. → Update ask-grok.py default to grok-4.3 (verify key provisioning first).
3. **Claude Opus 4.8 (this session's model) + "dynamic workflows"** — hundreds of parallel subagents now in research preview. Relevant to bulk synthesis that currently routes to AG; worth testing Claude-native parallel subagents vs an AG commission for some bulk work.
4. **Gemini 3.5 Flash + Antigravity 2.0** confirmed live — matches doctrine; no change needed, but the AG 2.0 CLI/SDK migration referenced in AGENTS.md §11.6 is now actually available (Gemini CLI fully replaced).

## → TACTIC DELTAS (changes to meta-ads-api-strategy + monetisation strategy)

1. **Sharpen the personal-attributes rule (meta doc §4.1):** the ban now extends to **indirect** framing — "for people who feel stuck", "those who've tried everything" carry the same risk as "you". Rewrite the compliant-copy bank accordingly (lean aspirational-neutral, never problem-implying).
2. **NEW, load-bearing:** Meta now reviews **ad + landing page + image metadata as one unit.** → The funnel **landing pages themselves** (not just ad copy) must pass the personal-attributes test, and need the "educational coaching, not medical/psychological treatment" + "results vary" disclaimers. This raises the priority of cleaning the landing-page copy, not just the ads.
3. **Confirm LTV bidding** as the subscription optimisation target once volume exists (matches the §9 subscription-event-lifecycle plan from the GPT-5.5 integration). Seed lookalikes off top-spending customers, not just leads.

---

## Engine note
This first digest was produced by Claude Opus 4.8 via live WebSearch in ~7 queries, $0. It surfaced four model facts that post-date my training + a Meta policy change that materially sharpens the ad strategy — exactly what a frozen base-model API could not have told us. Next run: weekly, via the standing prompt, with the ChatGPT/Grok bridge or headless agent doing the Reddit/X crawl. Deltas above are the only things that need Adrian's eyes.
