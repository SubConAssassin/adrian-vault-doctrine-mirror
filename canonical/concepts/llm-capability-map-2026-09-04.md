---
name: llm-capability-map-2026-09-04
title: The LLM Capability Map — every engine in the stack, what it is best at, and how to prompt it
type: doctrine
tier: 1
status: CURRENT
date: 2026-09-04
author: Claude (Opus 5) — CEO-of-the-stack, with a full 8-way CLI team fan-out + a 30-agent verification workflow
as_of_utc: 2026-09-04T05:20:00Z
grounding_mode: web_assisted + engine_native_probe
supersedes:
  - canonical/concepts/llm-capability-map-2026-07-25.md
  - canonical/concepts/verified-model-map-2026-08-28.md
extends: canonical/concepts/delegation-first-operating-doctrine.md §4/§14
cross_references:
  - "canonical/concepts/delegation-first-operating-doctrine.md (the constitution)"
  - "canonical/concepts/cli-prompting-art-per-engine-delivery.md (delivery idioms)"
  - "canonical/concepts/model-intel/2026-09-04-digest.md (the same morning's news harvest)"
  - "working/_research/2026-09-04-model-refresh/ (raw returns, 8 CLI legs)"
---

# The LLM Capability Map — 2026-09-04

**Why this exists.** Between 28 August and 3 September 2026 four frontier models shipped in six
days: **Claude Fable 5.1** (1 Sep), **Gemini 3.8 Flash** (2 Sep), **Meta Muse Spark 1.3** (2 Sep)
and **GPT-6 Astra** (3 Sep). One of them moved an engine we depend on without us touching anything.
This file is the single current answer to *"which engine, at what setting, for which job."*

**How it was built, so you can weigh it.** Eight parallel briefs to the flat-rate CLI team
(codex ×3, grok-web ×2, agy ×1, qwen ×2), plus a 30-agent Claude workflow doing first-party
verification and then **adversarially trying to refute every conclusion** through three lenses
(evidence, cost, operational risk). **19 of 24 adversarial verdicts came back
NEEDS_QUALIFICATION and 5 came back FAILS. Not one proposition survived unchanged.** The
qualifications are folded in below; where a claim was refuted it has been removed, not softened.
Total cash cost **$0** — every lane used is a subscription we already pay for.

> 🔑 **THE RULE THIS FILE IS BUILT ON: where doctrine, the registry and the machine disagree, the
> machine wins.** Every lane fact below was re-derived from an engine-native probe on 2026-09-04,
> not copied forward. Two headline claims from previous maps did not survive that test and are
> withdrawn in §8.

---

## §0 — THE HEADLINE (read this if you read nothing else)

1. **There is no Opus 5 update. None.** Adrian asked about "a lot of updates to Opus 5" — the
   answer is a confirmed negative, checked across five separate first-party Anthropic pages: only
   one `claude-opus-5` snapshot has ever existed and no `claude-opus-5-x` appears anywhere. The
   post-July capability bump is **Fable 5.1**, a different model. Opus 5 stays the default tier.
2. **GPT-6 Astra is NOT coming to our Codex lane, and the reason is the plan, not the rollout.**
   A live probe returns HTTP 400: *"The 'gpt-6-astra' model is not supported when using Codex with
   a ChatGPT account."* Our `~/.codex/auth.json` reports **`chatgpt_plan_type: plus`**, and
   OpenAI's own help page says Astra is Pro $100 / Pro $200 / Business / Enterprise and is
   **explicitly not included with Plus**. Every session that has been "waiting for the rollout" was
   waiting for something that is not scheduled to arrive. **This is a purchase decision for Adrian,
   not a timing question.** (§2.2)
3. **Our Codex CLI is nine releases behind: 0.144.1 installed, 0.153.2 current.** Separate finding,
   separate fix, and it does *not* unlock Astra (the refusal is account-keyed). (§8, D16)
4. **The agy lane was a generation behind and is now repinned to `gemini-3.8-flash-high`**, verified
   live end-to-end. The failure mode doctrine feared did not apply: **both** slugs were published,
   so the pin was stale, not silently falling back. §14.7's silent-fallback risk is also now
   **fixed by Google in headless mode**, which exits non-zero on an unknown slug. (§3.2)
5. **We have been paying for an image-generation lane and calling it impossible.** Adrian's own
   `~/.bailian/telemetry.jsonl` records an `image generate` call on `wan2.7-image` succeeding in
   16.7s on 2026-08-07, drawing subscription Credits rather than his card. **`AGENTS.md` §7.2 says
   image generation has no flat-rate lane. For images, on his own account, that is false.**
   The video half of the same claim is **withdrawn** as an arithmetic error (§8, D11).
   ⚠️ **The plan's terms forbid the use we would most want** — see §5.3 before anyone wires this.
6. **Three numbers our doctrine treats as facts are wrong.** Grok's "54% hallucination" is a **4.5**
   figure (4.6 measures **34.3%**); Luna's "41.3 on reasoning" is actually **long-context recall
   (MRCR)**, not reasoning; and Sonnet 5's "intro $2/$10 reverting to $3/$15" never reverted —
   **$2/$10 is now the standard price.** (§8)
7. **The sharpest routing correction is that "route big payloads to a big-context lane" was never
   how the harness works.** `tools/cli-ask.sh:217-228` already spills any payload over 100K chars
   to a file and hands the engine a short read-this instruction. **No lane is a big-payload
   destination. Chunk instead.** (§7.3)

---

## §1 — ANTHROPIC (what we orchestrate on)

Every row first-party from `platform.claude.com`, fetched 2026-09-04, and independently corroborated
by the `grok-web` leg.

| | **Fable 5.1** | **Opus 5** | **Sonnet 5** | **Haiku 4.5** |
|---|---|---|---|---|
| API ID | `claude-fable-5-1` | `claude-opus-5` | `claude-sonnet-5` | `claude-haiku-4-5-20251001` |
| Shipped | **1 Sep 2026** | 24 Jul 2026 | 30 Jun 2026 | 15 Oct 2025 |
| Context | 1M | 1M | 1M | 200k |
| Max output | 128k | 128k (**300k** on Batch w/ `output-300k-2026-03-24`) | 128k (300k Batch) | 64k |
| $/MTok in–out | $10 / $50 | **$5 / $25** | **$2 / $10** | $1 / $5 |
| **Cache read** | **$0.25** (0.025×) | $0.50 (0.1×) | $0.20 | $0.10 |
| Cache write 5m / 1h | $12.50 / $20 | $6.25 / $10 | $2.50 / $4 | — |
| Effort | low→max | low→max | low→max | ❌ none |
| Thinking | **always on** (cannot disable) | on by default; disable only at ≤high | on by default, disableable | extended only |
| Knowledge cutoff | **Jun 2026** | **May 2026** | Jan 2026 | Feb 2025 |

**Corrections to the previous map, all first-party:**
- **Sonnet 5 is $2/$10 permanently.** The scheduled 1 Sep rise to $3/$15 **did not happen**. Our
  July map's "$3/$15 (intro $2/$10 to 31 Aug)" is wrong and wrong against our interest.
- **Opus 5's minimum cacheable prompt dropped to 512 tokens** (from 1,024 on Opus 4.8).
- **Effort can now be changed mid-conversation without invalidating the prompt cache**
  (beta `mid-conversation-output-config-2026-07-01`). **This retires delegation-doctrine §14.3's
  "changing effort mid-conversation invalidates prompt caching — pick one and hold it."**

### 1.1 Fable 5.1 — better, and constrained in ways that decide the routing

Fable 5.1 is genuinely the strongest model on the board (Artificial Analysis index 66, #1).
It is still **not** our default, and the adversarial pass showed the *reason* we had written down
was the weak one. The cost argument is contested; the **compatibility** argument is not:

- **It is a Covered Model requiring 30-day data retention by default.** A request from an
  organization or workspace configured for zero-data-retention **400s unless Anthropic has
  expressly authorized Fable under that arrangement** (including eligible Enterprise Frontier
  Safeguards customers).
- **It 400s on forced `tool_choice`** (`any` / `tool`), including via `count_tokens` and Batches.
- **No fast mode**; Opus 5 has it. **Priority Tier is not a difference**: the current service-tier
  table excludes both Fable 5.1 and Opus 5.
- **Published API token throughput is 4× lower than Opus 5** in the standard rate-limit table:
  500k ITPM / 100k OTPM for Fable 5.x versus 2M / 400k for Opus 5 (RPM is 1,000 for both).
  Fable 5.1 also shares its bucket with Fable 5; Opus 5 has a separate bucket.
- **On Max it is included but capped at 50% of the weekly usage limit.** On Pro it is not included
  in plan limits at all. **This is the number that matters to us**: half our weekly ceiling.
- **Requires Claude Code v2.1.251+. Use v2.1.260+ in practice:** Anthropic's API rejects older
  clients with `claude_code_version_too_old` and explicitly names 2.1.251 as the floor. There was
  no 2.1.255 release. Anthropic's 2.1.260 changelog
  fixes Fable-specific failures where `model: fable` subagents ignored `[1m]` and silently ran at
  200K, the model picker omitted Fable, post-tool-result cache reads were missed, and `/effort`
  changes invalidated the prompt cache.
- Thinking cannot be disabled at any effort.

**Opus 5 → Fable 5.1 harness breakpoints, first-party migration guide:** forced `tool_choice`
(`any` / `tool`) becomes a 400 · `thinking.disabled` becomes a 400 at every effort · Fable thinking
blocks are unreadable by Opus and are silently dropped on a switch back unless transformation
reporting is enabled · replayed Fable thinking is bound to the byte-identical preceding system,
tools and message prefix (400 or opt-in drop on a mismatch) · narration between tool calls moves
from visible `text` blocks to normally-empty `thinking` blocks · refusal classifiers expand beyond
Opus's cyber-only surface, so HTTP-200 `stop_reason: refusal`, partial-output discard and fallback
handling become materially more important · ZDR is unavailable without express authorization.
The Fable-specific behaviour guide also warns of less parallel tool batching in implied long loops,
fewer progress messages, and fewer search/retrieval calls at `low` effort.

**The cost picture, stated honestly because two legs disagreed.** Artificial Analysis measures
Opus 5 at index **63 for ~$2.34/task** against Fable 5.1's **66 for ~$3.69** — 95% of the score for
62% of the cost — and AA's Fable entry is a *"with fallback"* system that routed ~4% of its output
tokens to Opus 4.8/5 on safety escalations. **The widely-repeated "1.7× output tokens, +20% cost per
task" claim is secondary-sourced and was NOT FOUND in Anthropic's own material by three independent
legs. Do not encode it as a routing constant.** Fable 5.1's cache reads are genuinely half Opus 5's
in absolute dollars ($0.25 vs $0.50), which cuts the other way on long cached sessions.

> **ROUTING: Opus 5 remains the default orchestration tier.** Reach for Fable 5.1 when evals on
> Opus 5 at `xhigh` or `max` still fall short — a demonstrated capability ceiling, not a stopwatch.
> Anthropic's own guidance assigns multi-hour autonomous coding agents to Opus 5 and says to start
> there. **Note the Max 50% cap before committing a long Fable run.**

**Mythos 5.1** shares Fable 5.1's specs, price and cache rate exactly; it is the same model with
looser safeguards, invitation-only via Project Glasswing (Cyber / Life Sciences Verification
Programs, US organisations). **Not available to us.** Its one behavioural difference: it does not
run the preserved-thinking history-editing check Fable 5.1 enforces.

### 1.2 Tier assignments (delegation-doctrine §14.5, restated)

| Role | Engine | Why |
|---|---|---|
| Architect / final verify | **Opus 5** | Default. 1M ctx, May-2026 cutoff, ZDR-compatible, forced tool_choice works. |
| Builder | **Sonnet 5 @ medium** | Now **$2/$10 permanently**. The biggest cost win inside Claude. |
| Scribe | **Haiku 4.5** | No effort param, 200k ctx. Summaries, changelogs, classification. |
| Capability ceiling | **Fable 5.1** | Only when Opus at xhigh/max demonstrably falls short. Watch the 50% Max cap. |
| Auditor | **a different model family** | Never the family that produced the work. |

---

## §2 — OPENAI (the `codex` lane)

### 2.0 🟢 PLAN CHANGE: ChatGPT Pro 5x (2026-09-04, Adrian-direct)

Adrian upgraded mid-session. Verbatim: *"ChatGPT is now on a Pro 5X so we've got phenomenally more
usage… let's utilize that fully."* **The `codex` lane is therefore the BIGGEST pool in the team, not
the smallest, and three standing rules are retired: the "~10% batch share" cap, "never batch Sol",
and "Terra is the everyday pin".** Sol is now the default at `xhigh`, batching it is correct, and the
lane should be saturated rather than rationed.

**Measured the same day, not assumed:** 20 concurrent codex clients at Sol/xhigh produced **zero
provider throttles**; the binding constraint is **latency and the box**, not quota (mean call 289s at
8-wide → 338s at 20-wide). A sustained quota-exhaustion burn is running to find the actual wall.

⚠️ **The upgrade did NOT buy the market leader, and this file will not pretend otherwise.** On
Artificial Analysis: **Fable 5.1 = 66 (#1)**, Opus 5 = 63, **GPT-5.6 Sol = 61**, GPT-6 Astra = 61.
Sol is the strongest model in the **$0 CLI team**; the best model on the board is **Fable 5.1 via
Claude Max**. And **Astra is still refused on this account after the upgrade** (§2.2).

### 2.1 What our account actually has

Read from `~/.codex/models_cache.json` (latest cache fetch 2026-09-04 06:32 UTC) and a live banner probe.

| Priority | Slug | Context (CLI) | Role |
|---|---|---|---|
| 3 | `gpt-reserve` | 272,000 | **`visibility: hide`** — see below |
| 6 | **`gpt-5.6-sol`** | 272,000 | **what a bare `codex` call gets** |
| 7 | `gpt-5.6-terra` | 272,000 | balanced everyday |
| 8 | `gpt-5.6-luna` | 272,000 | classification / extraction |
| 12 | `gpt-5.5` | 272,000 | previous generation |
| 16 / 23 | `gpt-5.4`, `gpt-5.4-mini` | 272,000 | legacy |
| 26 | `gpt-5.3-codex-spark` | 128,000 | ultra-fast, text-only, real-time coding preview |
| 43 | `codex-auto-review` | 272,000 | approval review |

**`gpt-reserve` is solved, from our own cache.** It carries `"visibility": "hide"`,
`supported_in_api: true`, a `Fast` service tier (1.5× speed), efforts low→max, and it appears in
**no** public OpenAI catalogue. Because it is hidden, it does **not** win the picker despite its
low priority number — which is exactly why a bare `codex` call correctly lands on **Sol**, verified
by the CLI banner. **Treat it as an opaque private alias. Do not route work to it.**

**⚠️ The context number is the CLI's, not the API's.** The API lists ~1.05M for the GPT-5.6 family.
The Codex CLI caps the session at **272K raw** (400K minus 128K reserved output), roughly 258K
usable, and auto-compacts near 200K. **Route against the harness limit, never the spec sheet.**

#### `gpt-5.3-codex-spark` — interaction-speed specialist, not the default workhorse

OpenAI launched Spark on 2026-02-12 as a **research-preview, smaller version of
GPT-5.3-Codex**, and its first model designed for real-time coding. OpenAI states **more than
1,000 output tokens/second**, text-only input, 128K context, ChatGPT Pro access, separate
model-specific limits that do **not** count against standard Codex limits, and no API access at
launch. It is a separate model, not GPT-5.3-Codex or a current model with Fast mode enabled.
Official sources: [launch entry](https://learn.chatgpt.com/docs/changelog) ·
[speed distinction](https://learn.chatgpt.com/docs/agent-configuration/speed) ·
[current model card](https://learn.chatgpt.com/docs/models).

Our 2026-09-04 ChatGPT-auth catalogue confirms: `supported_in_api: false`; text input only;
efforts `low|medium|high|xhigh` with **high default**; unified shell, apply-patch and search tool
support; **128,000 raw context with a 95% effective-window setting (~121,600)**; no extra speed
tier because Spark itself is the speed tier. Its model-specific harness prompt says sampling is
~1,500 tokens/second and deliberately optimizes for synchronous pairing: few tool calls, minimal
exploration, one-shot patches, and no tests/verification unless explicitly requested. Treat the
1,500 figure as catalogue configuration, not an independently measured SLA.

**Routing:** use Spark when human-turn latency is the dominant constraint and the task is tightly
bounded — small UI/CSS tweaks, a precise local edit, a short bug fix, a small test or snippet, or
rapid pair-programming iterations. Do **not** route architecture, ambiguous diagnosis, repository-
wide discovery, migrations/refactors, security review, long autonomous jobs, image-dependent work,
or verification-heavy/high-stakes changes to it. Use Sol for complex/open-ended work, Terra for
the everyday all-rounder, and Luna for clear repeatable/high-volume work. Spark's separate quota
makes it a useful extra interactive lane; it does not replace the Sol default.

**Pricing correction:** OpenAI first-party lists **GPT-5.6-Sol at $4.00 in / $0.40 cached / $20.00
out**, flagged promotional at least through 21 Nov 2026. Terra is $2/$12, Luna $0.20/$1.20. Our
July map's Sol figures were wrong. *(Academic for us — this lane is flat-rate — but it is what makes
"Sol is expensive, ration it" a claim about OpenAI's rate card and not about our bill.)*

### 2.2 GPT-6 Astra — the answer is "not on this plan"

`gpt-6-astra`: **1,050,000 context** (max input 922,000), **128,000 output**, knowledge cutoff
**30 April 2026**, efforts low→max (no `none`). API $10/$50, cached $1. Above 272K input the
**entire request** bills at 2× input and 1.5× output.

**On our machine, live, 2026-09-04:**

```
codex exec -m gpt-6-astra  →  HTTP 400
"The 'gpt-6-astra' model is not supported when using Codex with a ChatGPT account."
```

`gpt-6-astra-codex`, `gpt-6-codex` and `gpt-6-astra-preview` return the same. Our
`chatgpt_plan_type` is **`plus`**. OpenAI's help page states Astra appears as **GPT-6 Pro** for
**Pro $100 / Pro $200 / Business / Enterprise** and is **not included with Plus**.

> 🔴 **UPDATED 2026-09-04 ~11:35 WITA, AFTER ADRIAN UPGRADED TO PRO. THE PLAN WAS NOT THE BLOCKER.**
> The token refreshed live to `chatgpt_plan_type: prolite`, the Codex CLI was upgraded 0.144.1 →
> **0.153.2** (0.153.1 explicitly added Astra support), and the model cache was deleted and rebuilt
> — it DID refresh, surfacing a new model (`gpt-5.3-codex-spark`), which proves entitlements flow
> through. **Astra is still absent from the catalogue and still returns the same 400.** So the
> "plan-tier gate" reading was wrong or incomplete. Remaining candidates: the Codex *surface* has
> not rolled Astra out at any tier, or it needs Pro $200 rather than `prolite`. **Unresolved — do
> not assert either.** The distinguishing check is Adrian's ChatGPT model picker: if **GPT-6 Pro**
> appears there, the entitlement is live and Codex is simply behind.
> **Do not write Astra into the engine board and do not plan around it.** If he does upgrade, note that Codex reportedly
> does **not** apply the >272K long-context multiplier and does not charge cache writes, which
> would make Astra's 96.3% MRCR retrieval in the 512K–1M band genuinely useful rather than theatre.

### 2.3 Capabilities that are new and that we do not use

- **Programmatic tool calling** — the model writes JavaScript that invokes tools and processes
  intermediate results in a hosted runtime.
- **Explicit prompt-cache breakpoints** alongside automatic caching, plus `prompt_cache_key`.
- **Persisted reasoning across turns**, and conversation compaction.
- **Parallel subagents** — the Codex picker exposes an `ultra` effort tier described as subagents.
- **Computer use**, and `original`/`auto` image detail.
- **Structured outputs** (schema-constrained) — API-level; a normal interactive `codex` reply is not
  schema-enforced.
- **MCP connectors** (Drive, SharePoint) plus local MCP/plugin management in CLI 0.144.1.
- Sandbox modes `read-only` / `workspace-write` / `danger-full-access`.

---

## §3 — GOOGLE (the `agy` lane)

### 3.1 Gemini 3.8 Flash

`gemini-3.8-flash`, GA **2 September 2026**. Context **1,048,576**, max output **65,536**.
Thinking `low` / `medium` / **`high`**, default **medium** (`minimal` errors). Inputs: text, image,
video, audio, PDF. Intro pricing **$0.75 / $3.75** per MTok through **31 Dec 2026**, then
**$1.50 / $7.50**. Cached input $0.075 intro. **Identical pricing to 3.7 and 3.6.**

**The capability delta that matters to us** is not the headline benchmark, it is
**per-part `media_resolution` control (LOW / MEDIUM / HIGH within a single request)**. That is the
lever for cheap batch vision: downsample background assets, keep resolution only where it counts.
For an explicit Gemini 3 `media_resolution`, Google documents approximately **280 / 560 / 1,120**
tokens per image at LOW / MEDIUM / HIGH (ULTRA_HIGH: 2,240). A separate raw-size token-counting
rule says an image already ≤384×384 is 258 tokens and larger images tile into 768×768 crops at 258
tokens per tile; do not substitute that raw-size rule when costing an explicitly selected
`media_resolution`. Video LOW/MEDIUM samples at ~70 tokens/second; HIGH at ~280 tokens/second.
Up to **3,600 images per request** via the File API; **20MB** inline payload ceiling. Batch and Flex
are 50% of standard token rates; Batch targets completion within 24 hours, while Flex targets
1–15 minutes but is best-effort/sheddable.

Agentic reliability improved materially (Terminal-Bench 2.1 **81.6% → 90.8%**), with stricter
tool-call verification and less loop degradation over long horizons.

**3.8 Flash Cyber** is Fairwind-Program-only (government, critical infrastructure, maintainers).
Not available to us, no published public slug, and its rate card is **[NOT FOUND]** — do not assume
3.8 Flash pricing applies.

### 3.2 The repin — done, and what the adversarial pass changed about it

`agy models`, run live 2026-09-04, publishes:

```
gemini-3.8-flash-high / -medium / -low
gemini-3.7-flash-high / -medium / -low
gemini-3.6-flash-high / -medium / -low
gemini-3.1-pro-high / -low
claude-sonnet-4-6 · claude-opus-4-6-thinking · gpt-oss-120b-medium
```

**`tools/agy-ask.py` is repinned `gemini-3.7-flash-high` → `gemini-3.8-flash-high`, verified live
end-to-end (clean reply, rc=0).** Backup at `tools/agy-ask.py.bak-20260904-prerepin`.

**Two corrections the refutation pass forced, both recorded in the file's own comment block:**
- **The pin was STALE, not broken.** Both slugs are published, so the old pin still bound. The
  DELTAS handoff's inference that we might be on an unknown fallback was reasonable but wrong.
- **§14.7's silent-fallback hazard no longer applies to this path.** Google's current headless docs
  say an unknown `--model` **exits non-zero with an ERROR listing available models**. The sticky
  last-selected behaviour is an *interactive UI* property. The pin still matters — it stops us
  drifting a generation behind — but a wrong slug now fails loudly.

> ⚠️ **OPEN WATCH ITEM, and it is a real one.** One adversarial leg argued for
> `gemini-3.8-flash-**medium**` instead, on the grounds that Google states 3.8 does more work per
> call by design and advises lower effort for everyday tasks — and `agy` is our **most
> quota-fragile lane** since the Ultra→base downgrade. That is a fair point and it is unmeasured.
> I changed **one variable** (3.7-high → 3.8-high) to keep the comparison clean.
> **Trigger for testing a drop to `-medium`: any rise in confirmed quota errors on this lane.** A
> direct exhaustion response is `RESOURCE_EXHAUSTED` / 429 with `Individual quota reached` and a
> reset timer. Empty success is `AMBIGUOUS_EMPTY`, not proof of quota exhaustion (§8, D2).

**Google Search grounding is a metered surface inside a flat-rate lane.** 5,000 free grounding
queries/month across Gemini 3.x, then **$14 per 1,000 requests**, billed separately from tokens.
Worth knowing before anyone saturates agy with grounded research.

---

## §4 — xAI (the `grok` lane)

`grok-4.6`, released 12 Aug 2026. Context **500,000** (a regression from 4.3's 1M). Text + image in,
text out. Efforts low / medium / **high** (default) / xhigh. Knowledge cutoff **1 Feb 2026**.
Pricing: prompts **<200K** are $2 in / $0.50 cached / $6 out; **≥200K** the *entire request* bills
at $4 / $1 / $12. Batch not supported. Cached input rose from 4.5's $0.30 to $0.50, so agent loops
got *more* expensive on cache, not less.

**The 54% hallucination figure in our doctrine is stale.** It is a Grok **4.5** number. The
re-measurement, attributed to Artificial Analysis AA-Omniscience (26–27 Aug snapshot):

| Model | Accuracy | Hallucination | Omniscience Index |
|---|---|---|---|
| Grok 4.5 | 52% | **54%** | 26 |
| **Grok 4.6 (high)** | 48.2% | **34.3%** | 30.5 |

⚠️ **Sourcing caveat that must travel with this number.** Both legs that found it reached it
through an *aggregator*; the direct AA-Omniscience row for 4.6 was **[NOT FOUND]**. xAI's own model
card points the *other way* on an internal factuality eval (4.6 worse than 4.5). **So: replace the
number, keep the rule.** 34.3% is still high, the sourcing is second-hand, and the vendor disagrees
with the direction. **The different-family cross-check before promotion stands.**

**`grok-composer-2.5-fast` has been withdrawn from the live xAI Grok Build catalogue returned to
this account, but a global retirement by xAI is not verified.** A direct selection returned
`unknown model id` on 2026-08-21; the server-fetched subscription catalogue at
`~/.grok/models_cache.json` (origin
`https://cli-chat-proxy.grok.com/v1/models`, fetched 2026-09-04 05:17Z) contains only `grok-4.5`
and `grok-4.6`. xAI's [June launch post](https://x.ai/news/composer-2-5) remains online, while the
[current Grok Build documentation](https://docs.x.ai/build/overview) says `grok-4.6` powers the
product. Its [retirement notice](https://docs.x.ai/developers/migration/may-15-retirement) and
[release notes](https://docs.x.ai/developers/release-notes) do not name Composer. Therefore
"retired" is valid operational shorthand for the dead model ID, **not a verified formal xAI
designation or proof of a global withdrawal**. The underlying model itself is still live in
[Cursor's current Composer 2.5 documentation](https://prod.cursor.com/docs/models/cursor-composer-2-5),
including its Fast variant. xAI has named **no Composer successor**; `grok-4.6` is the current de
facto Grok Build replacement, not an announced successor in the Composer lineage. The local
`composer` lane is dead as named. Replacement for fast mechanical edits: **`codex-terra` at low
effort**, which is a bigger and ungated pool.

**Grok 4.7** is a claim on X by Musk (~12 Sep, 2.1T params). No release note, no model card, no
benchmark. **Watch item, not a planning input.**

**Live account state:** the Grok Build usage meter has been at HTTP 402 since 26 Aug and the OAuth
token lapsed 27 Aug. Neither is fixable by a model release. The `grok-web` research lane works.

---

## §5 — ALIBABA / QWEN (the `qwen` lane, via `bl`)

### 5.1 The models, read live from `bl model list` on Adrian's own account

| Model | Ctx | Capabilities | Plan-catalogue in–out | Cache read |
|---|---|---|---|---|
| **`qwen3.8-max`** | 1,000,000 | Reasoning, Vision, Text | 12 / 36 | 1.0 |
| **`qwen3.8-flash`** | 1,000,000 | Text, Vision, Reasoning | **0.8 / 2.7** | **0.1** |
| `qwen3.8-opensource` | 1,000,000 | Text, Reasoning, Vision | 12 / 36 (also 3 / 12) | 0.3 |
| `qwen3.7-max` | 1,000,000 | Reasoning, Text, Vision | 12 / 36 | 1.2 |
| `wan-video` | n/a | **Video generation** | see §5.2 ⚠️ | — |
| `qwen3.7-plus`, `qwen3.7-flash`, `qwen3.6-plus`, `qwen3.6-flash` | 1,000,000 | mixed | | |
| `qwen3.6-max` | 262,144 | Reasoning, Text | | |

`qwen3.8-max` is a **2.4T-parameter MoE**, snapshot `qwen3.8-max-0902`, max input 991,808, max
output 131,072. Singapore first-party pricing is **$2 in / $6 out**, implicit cache $0.25 — note
this differs from the account catalogue's figures above, which are the plan's own credit units.

For **`qwen3.8-flash` pay-as-you-go**, first-party Singapore/International pricing is
**$0.15 input / $0.47 output per MTok**. Global deployments in Germany, Japan, the US and Hong
Kong are $0.113 / $0.382. Vision input is
approximately `height × width / (32 × 32) + 2` tokens after preprocessing, so 512×512 is about
258 image tokens. The Singapore real-time limit is 15,000 RPM / 2,000,000 TPM. Alibaba's current
pricing table marks `qwen3.8-flash` for a 50% Batch discount in **China (Beijing)**, but not in
**Singapore/International**; do not apply the discount to Adrian's Singapore route unless that
region's support table changes.

**The lane works.** Two research briefs returned rc=0 with 17KB each this session. Doctrine's
"qwen BLOCKED, needs a reissued key" is **stale** — the 2026-08-27 rewire to `bl` fixed it.

### 5.2 ⚠️ WITHDRAWN CLAIM: `wan-video` does not prove a flat-rate video lane

`verified-model-map-2026-08-28.md` §4 recorded *"`wan-video` is on the Token Plan… doctrine §7.2 is
now false"* and cited a price of **0.45**. **That claim is withdrawn.** The 0.45 was read under a
`price /Mtok` column heading, but **video is billed per SECOND of output**, not per token
(`video_ratio_480p=0.45` is a per-second-class rate). Alibaba's Token Plan Personal Edition model
table lists video as **`happyhorse-1.1-t2v` / `-i2v` / `-r2v`**; Wan **video** IDs are documented as
pay-as-you-go. The catalogue appearance alone never proved plan coverage.

### 5.3 ✅ CONFIRMED: image generation IS covered, and is proven on Adrian's account

The image half is real and is not an inference. **`~/.bailian/telemetry.jsonl` records an
`image generate` call with model `wan2.7-image` on 2026-08-07 returning `"success": true` in 16.7s,
drawing Credits rather than the card.** Token Plan Personal lists `wan2.7-image`,
`wan2.7-image-pro` and `qwen-image-3.0-pro`.

> 🔴 **BEFORE ANYONE WIRES THIS.** Alibaba's Token Plan terms, verbatim: *"This plan is intended for
> interactive use only within coding tools and agent tools… It must not"* be used for automation or
> batch backends. It is **Singapore-only** and **single-device**. **Pointing a fleet script at this
> key is a terms violation**, and one leg found guidance that a mismatched key or Base URL can be
> *"routed to the pay-as-you-go channel (causing unexpected charges)"* — that half could not be
> confirmed first-party, so design against it rather than repeating it as established.
> **`dashscope-intl.aliyuncs.com` is the pay-as-you-go host and must never be a silent fallback.**

**Consequence for `AGENTS.md` §7.2:** the sentence *"image and video GENERATION have no flat-rate
lane"* is **false for images and true-in-practice for video**. Correcting it is an §8 doctrine change
and therefore **Adrian's**, not an agent's (§9).

---

## §6 — EVERYONE ELSE, and the local fleet

- **Meta Muse Spark 1.3** (2 Sep). `muse-spark-1.3`, 1,048,576 ctx. Standard **$1.25 / $4.25**,
  cached $0.15. **Contributor tier $0.10 / $0.20. Meta's exact Contributor term is:**
  *“Heavily discounted token pricing in exchange for permission to use your prompts and completions
  to train future Meta models. It lowers the barrier to entry for prototyping, testing integrations,
  and scaling experiments where training on your data is acceptable.”* The shorter product-card
  label is *“Used to improve our products.”* This is a training permission covering prompts and
  completions, not a published retention, confidentiality, human-review or deletion guarantee.
  Source: [Meta Model API pricing and rate limits](https://dev.meta.ai/docs/pricing-rate-limits/)
  (authenticated Meta page; wording independently reproduced by TechCrunch on 3 Sep 2026).
  AA index 61 (xhigh) / 62 (max, partner preview). **On AA's own cost-to-run-index it buys index 61
  for $0.55 against Sol max's $0.95 — the cheapest route to that score anywhere.** It is a **metered
  API outside §7.2's approved list**, and the contributor terms interact with client and venture
  material. **Flagged for Adrian. Not wired. No token minted.**
- **GLM-5.3 flagship** open weights (28 Aug): **753B MoE**. Its smallest shipped Unsloth GGUF,
  `UD-IQ1_S`, is **216.7GB before runtime overhead**; therefore no flagship quant fits below
  100GB, the M1 Max 64GB, or a 192GB Studio. [Unsloth GGUF sizes](https://huggingface.co/unsloth/GLM-5.3-GGUF)
- **CORRECTION, later 4 Sep:** the separate **GLM-5.3-Flash** (320.6B total / 17.3B active) now
  has a genuinely sub-100GB route. The hand-mixed `AJ-IQ2_XXS` is **87.35GB** and has been
  measured fully resident on a 96GB RTX PRO 6000 (also 11.55 tok/s using 24GB VRAM + 64GB RAM).
  The cost is severe: against BF16 on a matched 30-chunk Wikitext-2 run, perplexity is **1.883x**,
  KLD **0.707**, and the same top token is selected only **73.2%** of the time. The next useful
  rung, `AJ-IQ3_XXS`, is 112.4GB and improves those figures to **1.341x / 0.356 / 81.77%**.
  [build, memory and matched quality data](https://huggingface.co/aj9o9/GLM-5.3-Flash-GGUF)
  Unsloth also publishes 93.1GB and 97.6GB 1-bit files, but runtime needs approximately 100GB+
  and the open llama.cpp integration currently reports repeated-token garbage for `UD-IQ1_M` on
  M1 Ultra; upstream Flash support remains an open PR. Treat every sub-100GB build as experimental,
  low-temperature/greedy-only, not a production agent. A 50%-expert-pruned 72–99GB GGUF family also
  exists, but pruning alone agrees with the parent on only 84.25% of top tokens (code 91.9%, generic
  prose 58.0%) before the unmeasured extra quantisation loss. It is a domain-biased experiment, not
  a clean substitute. [llama.cpp status](https://github.com/ggml-org/llama.cpp/pull/27752) ·
  [REAP50 evidence](https://huggingface.co/patrickbdevaney/GLM-5.3-Flash-REAP50-GGUF)
  **Fleet verdict remains NO:** none fits the current 64GB Mac; a 96GB-class device can technically
  run Flash only with a large quality haircut. The earlier blanket claim that Flash was equally out
  of reach below 100GB is withdrawn.
- **Best post-July open-weight model that genuinely fits 64GB Apple Silicon: Qwen3.8-27B**
  (14 Aug, Apache-2.0). Use the Apple-native **8-bit MLX AWQ/affine quant** with its BF16 vision
  tower and MTP head preserved: independently measured at **28.1GB peak for load + short probe**
  and **34.46GB whole-process peak at 16K context with BF16 KV cache** on an Apple M3 Ultra. Its
  hardware fit is separately confirmed on the exact fleet class: an 8-bit oMLX run on an **M1 Max
  64GB** measured **28.3GB at 1K, 29.6GB at 4K, 30.1GB at 8K, and 30.9GB at 16K**. That second run
  is a generic Qwen3.8-27B 8-bit build, not proof of the exact Alis tensor mix, so retain the
  exact-build **34.46GB** figure as the conservative 16K planning number. Its
  ≈103K-token English/Korean/code perplexity was statistically indistinguishable from BF16, while
  the BF16 reference itself peaked at 51.1GB before meaningful context and is therefore a paper fit,
  not a sensible 64GB operating point. At the native 262K window, use 4-bit KV cache: cache alone is
  16.8GB in BF16 versus 4.2GB at 4-bit. Sources: [official model card](https://huggingface.co/Qwen/Qwen3.8-27B),
  [measured Apple-Silicon MLX quant](https://huggingface.co/avlp12/Qwen3.8-27B-Alis-MLX-8bit),
  [M1 Max 64GB oMLX measurement](https://omlx.ai/benchmarks/performance/5you1zwa),
  [independent AA score](https://artificialanalysis.ai/models/releases/qwen3-8-27b). The stronger
  on-paper Qwen3.8-Flash-Next does not cross the line: its smallest published Unsloth GGUF is
  **72.5GB before runtime overhead**, so it cannot reside in 64GB.
- **Local, confirmed on our fleet:** M2 Studio Ollama (`bge-m3`, `qwen2.5:14b`, `qwen3.5:9b`,
  `nomic-embed-text`, `moondream`) and the PC RTX 5080 vision lane (`qwen2.5-vl-7b`, one image per
  request, concurrency 1 — the build crashes on concurrent decode).
  ⚠️ **`cli-ask.sh` pins `CLI_ASK_LOCAL_CTX=16384`.** The local lane is a **16K** window, not a
  large-context lane. Anyone writing "cheap 1M flat-rate lane" is conflating `local` with `qwen`.
- **Local video, documented but still untested here:** Wan 2.2 TI2V-5B (Apache-2.0,
  720p/24fps) has an official ComfyUI-native route that says the 5B workflow should fit in **8GB
  VRAM with native offloading**, so the PC's RTX 5080 16GB is sufficient. This is distinct from
  Wan's own `generate.py` path, which documents **24GB minimum** at 1280x704 with model offload,
  dtype conversion and T5 on CPU. The ComfyUI assets are a 10GB FP16 diffusion model, 6.74GB FP8
  text encoder and 1.41GB VAE (about 18.15GB on disk); the components are loaded/offloaded rather
  than held in VRAM together. The official quick-start template uses 1280x704, 41 frames and 30
  steps; its own note identifies 121 frames (5.04 seconds at 24fps) as the intended full clip.
  Wan reports **under 9 minutes** for a 5-second 720p clip on a single consumer GPU without special
  optimisation, but publishes no RTX 5080-specific result. Until measured locally, budget roughly
  **6-10 minutes** for the 30-step 121-frame ComfyUI job and **2-4 minutes** for the 41-frame preview;
  those two ranges are planning estimates, not measured fleet facts.
  [official Wan runner and timing](https://github.com/Wan-Video/Wan2.2#run-wan22) ·
  [official ComfyUI workflow and 8GB statement](https://docs.comfy.org/tutorials/video/wan/wan2_2) ·
  [official 5B workflow JSON](https://comfyanonymous.github.io/ComfyUI_examples/wan22/text_to_video_wan22_5B.json)
  LTX-2.3 via MLX on the M1 Max remains only a lead.

---

## §7 — THE ROUTING TABLE (2026-09-04)

**Flat-rate means zero marginal cash, not unlimited capacity.** Idle subscription quota expires
nightly and is destroyed, not saved. Keep ~2 clients free under the **10–12 box-wide** ceiling.
Enforced gates: **codex ungated · agy 2 · grok 2 · qwen 2 · deepseek 1 · local 3.**

| Job | Lane → model | Effort | Note |
|---|---|---|---|
| Orchestration, architecture, final verify | **Claude Opus 5** | high (xhigh for hard) | The default. ZDR-safe, forced tool_choice works. |
| Capability ceiling, genuinely hard | **Claude Fable 5.1** | xhigh/max | Only when Opus at xhigh/max demonstrably falls short. **Eats 50% of the weekly Max cap.** |
| Builder / mechanical implementation | **Sonnet 5** | medium | **$2/$10 permanently.** |
| Scribe, summaries, compression | **Haiku 4.5** | n/a | No effort param, 200k ctx. |
| Hard single-shot arbitration | **`codex-sol`** | xhigh | $0 marginal on our flat-rate plan. Pin it explicitly. |
| Everyday coding, mechanical edits | **`codex-terra`** | medium (low for edits) | **The `composer` replacement.** Make this the everyday codex default. |
| Schema-bound classification, short docs | **`codex-luna`** | low | **Never reasoning, never long-context recall.** |
| Bulk classification/extraction, big corpus | **`local` → `qwen3.5:9b`** first, escalate residue | lowest | Route by **token volume and per-item stakes**, not item count. 16K ctx: chunk. |
| Vision / OCR batch | **Gemini 3.8 Flash Batch API** with `media_resolution: LOW`/`MEDIUM`, or **`qwen3.8-flash` pay-as-you-go API**; PC vision serial | low | Both cloud routes are metered and require §7.2 per-job approval. The Alibaba Token Plan is interactive-only and MUST NOT back an automated batch (§5.3). |
| Live-web research with citations | **`grok-web`** | high | Then a **different-family** check before anything promotes. |
| Large single payload | **chunk it — see §7.3** | — | No lane is a big-payload destination. |
| Image generation | **Alibaba Token Plan** (`wan2.7-image`, `qwen-image-3.0-pro`) | — | ⚠️ **Interactive use only.** Read §5.3 first. |
| Video generation | **PC ComfyUI** (local, unrestricted) | — | Token Plan video is `happyhorse-1.1-*` and is interactive-only. |

**Healthy full-load allocation:** 4–6 codex (mostly Terra/Luna, at most 1–2 Sol) · 2 qwen ·
1–2 grok · 0–2 agy *while it returns valid bodies* · 1 local text worker · the serial PC vision
worker. Ceiling 10–12.

### 7.3 The big-payload rule, corrected

The old rule — *"route >400K-token payloads to agy/codex"* — was wrong twice over. It named a lane
whose CLI caps at 272K, and it misdescribed the mechanism: **`cli-ask.sh:217-228` already spills any
payload over `CLI_ASK_BIG_MAX` (100K chars) to a data file and hands the engine a short instruction
to read it.** The engine ingests it in pieces; nothing is stuffed into a context window.

> **Replacement rule.** *No lane is a big-payload destination. A payload too large for the target
> window gets CHUNKED with deterministic retrieval and evidence pointers, not re-routed to a bigger
> advertised window. Genuine 1M windows exist on `qwen3.8-max/flash` and `agy`; use them for
> analysis that truly needs breadth, never as an excuse to skip retrieval.*

---

## §8 — DEFECT DISPOSITION (what a new release actually fixed)

| ID | Defect | Disposition |
|---|---|---|
| D1 | agy pinned a generation behind | ✅ **FIXED.** Repinned `gemini-3.8-flash-high`, verified live. Risk model corrected: headless now errors on an unknown slug. |
| D2 | agy wrapper masked CLI failures as THIN rc=0 | ✅ **FIXED LOCALLY 2026-09-04.** The direct CLI already reported `RESOURCE_EXHAUSTED` / 429, `Individual quota reached`, and a reset timer; since v1.1.1 print mode writes server failures to stderr and exits non-zero. `agy-ask.py` discarded the PTY child status and did not propagate its own status; both layers now preserve non-zero exits. Empty-success remains `AMBIGUOUS_EMPTY`, never a quota diagnosis. |
| D3 | agy fabricates citations | ❌ **NO FIX.** 3.8 makes no such claim. Mitigation: read links from `groundingChunks` metadata, not from generated inline markdown. **Keep must-cite research on `grok-web`.** |
| D4 | "Grok 54% hallucination" | 🔧 **NUMBER STALE.** 4.6 measures **34.3%** (aggregator-sourced, vendor disagrees on direction). **Replace the number, keep the cross-check rule.** |
| D5 | Grok Build 402 + lapsed OAuth | ❌ **NO MODEL FIX.** Account state. Do not route around it via a metered xAI key. |
| D6 | `composer` lane dead | ✅ **REPLACED LOCALLY** by `codex-terra` at low effort. xAI named no Composer successor; current Grok Build uses `grok-4.6`, a de facto product replacement rather than an announced successor. |
| D7 | ">400K payloads to codex" impossible | ✅ **RULE REWRITTEN** (§7.3). Chunk, do not re-route. |
| D8 | "Never batch Sol" vs bare codex → Sol | ✅ **RESOLVED.** `gpt-reserve` is `visibility: hide`, so Sol is the correct bare resolution. **Fix: never call bare `codex` in automation — pin terra/luna/sol explicitly.** |
| D9 | "Luna 41.3 on reasoning" | 🔧 **MISLABELLED.** 41.3 is **MRCR v2 8-needle long-context recall**, not reasoning (Sol 91.5 / Terra 89.6 on the same test). Luna is fine for short-document classification, bad at needle-in-haystack. **Doctrine §14.6 must say MRCR.** |
| D10 | Engines cannot self-identify | ❌ **NO FIX**, and our remedy needed sharpening (§8.1). |
| D11 | Flat-rate image/video lane | 🔧 **SPLIT.** **Images: CONFIRMED** on Adrian's own account. **Video: claim WITHDRAWN** (per-second billing misread as per-token). Both gated by interactive-only terms. §7.2 change is Adrian's. |
| D12 | Cheap bulk classification | ✅ **IMPROVED.** `local` first, then `qwen3.8-flash` **pay-as-you-go only with §7.2 approval**. The Token Plan cannot serve automation/batch. Route by token volume and stakes, not item count. |
| D13 | Fable 5.1 output-token cost | 🔧 **REFRAMED.** The 1.7×/+20% claim is unverified in first-party material. The real constraints are the **50% Max cap**, ZDR incompatibility and forced-tool_choice 400s. |
| D14 | Multimodal batch bottleneck | ✅ **IMPROVED.** Gemini 3.8's per-part `media_resolution` is the new lever; `qwen3.8-flash` pay-as-you-go is the cheaper high-concurrency alternative. The 2-wide Token Plan lane is interactive-only, not a batch backend. |
| D15 | Prompt caching barely used | ✅ **ACTIONABLE.** Stable-prefix architecture: doctrine → project facts → tool schemas → corpus, then an append-only tail. Gemini implicit caching starts at 4,096 common-prefix tokens, Qwen at 1,024, Opus 5 at 512. **And effort is now changeable mid-conversation without invalidating the cache.** |
| **D16** | **Codex CLI nine releases behind (0.144.1 vs 0.153.2)** | 🆕 **NEW, found this pass.** Does not unlock Astra (account-keyed refusal), but it is real drift. |
| **D17** | **ChatGPT plan is Plus, not Pro** | 🆕 **NEW.** Gates Astra entirely. Adrian's decision (§9). |

### 8.1 Model identity — the sharpened rule

Our doctrine says *"resolve from CLI banners, session logs or catalogue files."* The refutation pass
showed that lumps together **what the client REQUESTED** and **what the server SERVED**, and only the
second is evidence. Ranked:

1. **Server-returned session metadata** (e.g. `~/.grok/sessions/*/signals.json` → `primaryModelId`),
   or a provider-side alias resolution endpoint. This is the only real evidence.
2. **A live catalogue query** (`agy models`, the codex models cache) — proves the slug exists.
3. **Client-side config and CLI banners** — record intent, not outcome.
4. **The model's own prose. Never evidence.** Proven again this session: a bare `codex` call whose
   banner read `gpt-5.6-sol` replied that it was "gpt-5.3-codex".

⚠️ **`agy` has no response-derived identity artifact at all.** For that lane, tier 2 is the ceiling.

---

## §9 — WHAT IS ADRIAN'S CALL, NOT AN AGENT'S

Each of these clears delegation-doctrine §7.0 and `AGENTS.md` §16.4 as a genuine decision.

1. **ChatGPT plan: Plus → Pro?** This is the *only* thing standing between us and GPT-6 Astra on the
   codex lane, and Astra's 96.3% MRCR at 512K–1M is the first credible long-context retrieval on the
   board. Cost is his money (§7.2), so it is his call.
2. **`AGENTS.md` §7.2's image/video sentence is now factually wrong for images.** Correcting a
   safety gate is an §8 doctrine change and explicitly never an agent's edit. Proposed replacement
   wording is in the handoff.
3. **Meta Muse Spark 1.3's contributor tier** — index 61 at a tenth of the price, paid in training
   data over client and venture material. Flagged, not wired.
4. **Grok Build's 402 balance** — a spend decision.

---

## §10 — WHAT CHANGED IN THE DOCTRINE FILES

- `tools/agy-ask.py` — repinned to `gemini-3.8-flash-high`, verified live.
- `delegation-first-operating-doctrine.md` §4/§14 — engine board, the Grok number, the Luna
  mislabel, the big-payload rule, the effort/cache claim.
- `tools/lanes.py` — registry drift (Grok 4.5→4.6, dead `composer`, stale hallucination figures).
- `~/.claude/skills/prompt-tuning/SKILL.md` — the routing skill Adrian calls with `/prompt-tuning`.
- `llm-capability-map-2026-07-25.md` and `verified-model-map-2026-08-28.md` — marked superseded.

**Raw returns, all eight CLI legs:** `working/_research/2026-09-04-model-refresh/out/`
