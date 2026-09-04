---
name: llm-capability-map-2026-09-04
title: The LLM Capability Map — every engine in the stack, what it is best at, and how to prompt it
type: doctrine
tier: 1
status: CURRENT
date: 2026-09-04
author: Claude (Opus 5) — CEO-of-the-stack, with a full 8-way CLI team fan-out + a 30-agent verification workflow
as_of_utc: 2026-09-04T02:00:00Z
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

- **It is a Covered Model requiring 30-day data retention.** It **400s on every request** under
  zero-data-retention.
- **It 400s on forced `tool_choice`** (`any` / `tool`), including via `count_tokens` and Batches.
- **No Priority Tier. No fast mode.**
- **On Max it is included but capped at 50% of the weekly usage limit.** On Pro it is not included
  in plan limits at all. **This is the number that matters to us**: half our weekly ceiling.
- **Requires Claude Code v2.1.255+.**
- Thinking cannot be disabled at any effort.

**The cost picture, stated honestly because two legs disagreed.** Artificial Analysis measures
Opus 5 at index **63 for ~$2.34/task** against Fable 5.1's **66 for ~$3.76** — 95% of the score for
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

### 2.1 What our account actually has

Read from `~/.codex/models_cache.json` (cache written 2026-09-03 19:27) and a live banner probe.

| Priority | Slug | Context (CLI) | Role |
|---|---|---|---|
| 3 | `gpt-reserve` | 272,000 | **`visibility: hide`** — see below |
| 6 | **`gpt-5.6-sol`** | 272,000 | **what a bare `codex` call gets** |
| 7 | `gpt-5.6-terra` | 272,000 | balanced everyday |
| 8 | `gpt-5.6-luna` | 272,000 | classification / extraction |
| 12 | `gpt-5.5` | 272,000 | previous generation |
| 16 / 23 | `gpt-5.4`, `gpt-5.4-mini` | 272,000 | legacy |
| 43 | `codex-auto-review` | 272,000 | approval review |

**`gpt-reserve` is solved, from our own cache.** It carries `"visibility": "hide"`,
`supported_in_api: true`, a `Fast` service tier (1.5× speed), efforts low→max, and it appears in
**no** public OpenAI catalogue. Because it is hidden, it does **not** win the picker despite its
low priority number — which is exactly why a bare `codex` call correctly lands on **Sol**, verified
by the CLI banner. **Treat it as an opaque private alias. Do not route work to it.**

**⚠️ The context number is the CLI's, not the API's.** The API lists ~1.05M for the GPT-5.6 family.
The Codex CLI caps the session at **272K raw** (400K minus 128K reserved output), roughly 258K
usable, and auto-compacts near 200K. **Route against the harness limit, never the spec sheet.**

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

> **Do not write Astra into the engine board. Do not plan around it. It is a plan-tier decision for
> Adrian (§9), not a rollout we are waiting on.** If he does upgrade, note that Codex reportedly
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
Image token maths: ≤384×384 costs a flat 258 tokens; larger images tile into 768×768 crops at 258
tokens per tile, bounded at 3072×3072. PDFs rasterise per page (258–1,032 tokens/page). Video
samples at 1fps, ~263 tokens/second, so a one-hour video consumes ~947K tokens and nearly fills the
window. Up to **3,000 images per request** via the File API; **20MB** inline payload ceiling.

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
> **Trigger for dropping to `-medium`: any rise in the THIN rc=0 rate on this lane.** That signal is
> quota exhaustion (§8, D2), and it is the thing to watch this week.

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

**`grok-composer-2.5-fast` is retired and no vendor named a successor** (confirmed by two legs).
The `composer` lane is dead as named. Replacement for fast mechanical edits: **`codex-terra` at low
effort**, which is a bigger and ungated pool.

**Grok 4.7** is a claim on X by Musk (~12 Sep, 2.1T params). No release note, no model card, no
benchmark. **Watch item, not a planning input.**

**Live account state:** the Grok Build usage meter has been at HTTP 402 since 26 Aug and the OAuth
token lapsed 27 Aug. Neither is fixable by a model release. The `grok-web` research lane works.

---

## §5 — ALIBABA / QWEN (the `qwen` lane, via `bl`)

### 5.1 The models, read live from `bl model list` on Adrian's own account

| Model | Ctx | Capabilities | $/MTok in–out | Cache read |
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
  cached $0.15. **Contributor tier $0.10 / $0.20 — where the discount is paid in training data.**
  AA index 61 (xhigh) / 62 (max, partner preview). **On AA's own cost-to-run-index it buys index 61
  for $0.55 against Sol max's $0.95 — the cheapest route to that score anywhere.** It is a **metered
  API outside §7.2's approved list**, and the contributor terms interact with client and venture
  material. **Flagged for Adrian. Not wired. No token minted.**
- **GLM-5.3** open weights (28 Aug): **753B MoE**. **Does not fit** the M1 Max 64GB or a 192GB
  Studio at any useful quantisation; deployment targets are vLLM / SGLang, i.e. GPU-server shaped.
  GLM-5.3-Flash at 320B is equally out of reach. **Closed as a negative so nobody re-derives it.**
- **Local, confirmed on our fleet:** M2 Studio Ollama (`bge-m3`, `qwen2.5:14b`, `qwen3.5:9b`,
  `nomic-embed-text`, `moondream`) and the PC RTX 5080 vision lane (`qwen2.5-vl-7b`, one image per
  request, concurrency 1 — the build crashes on concurrent decode).
  ⚠️ **`cli-ask.sh` pins `CLI_ASK_LOCAL_CTX=16384`.** The local lane is a **16K** window, not a
  large-context lane. Anyone writing "cheap 1M flat-rate lane" is conflating `local` with `qwen`.
- **Local video, newly plausible and untested here:** Wan 2.2 TI2V-5B (Apache-2.0, 720p/24fps) on
  the RTX 5080, and LTX-2.3 via MLX on the M1 Max. Recorded as a lead.

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
| Vision / OCR batch | **`agy` (3.8 Flash) with `media_resolution: LOW`**, or `qwen3.8-flash`; PC vision serial | low | The `media_resolution` lever is new and is the cost win. |
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
| D2 | agy quota exhaustion looks like auth failure (THIN rc=0) | ❌ **NO FIX.** No vendor change. Operator-side: treat empty-success as `AMBIGUOUS_EMPTY`, retry once, then probe auth separately. **This is the signal to watch after the repin.** |
| D3 | agy fabricates citations | ❌ **NO FIX.** 3.8 makes no such claim. Mitigation: read links from `groundingChunks` metadata, not from generated inline markdown. **Keep must-cite research on `grok-web`.** |
| D4 | "Grok 54% hallucination" | 🔧 **NUMBER STALE.** 4.6 measures **34.3%** (aggregator-sourced, vendor disagrees on direction). **Replace the number, keep the cross-check rule.** |
| D5 | Grok Build 402 + lapsed OAuth | ❌ **NO MODEL FIX.** Account state. Do not route around it via a metered xAI key. |
| D6 | `composer` lane dead | ✅ **REPLACED** by `codex-terra` at low effort. No vendor successor exists. |
| D7 | ">400K payloads to codex" impossible | ✅ **RULE REWRITTEN** (§7.3). Chunk, do not re-route. |
| D8 | "Never batch Sol" vs bare codex → Sol | ✅ **RESOLVED.** `gpt-reserve` is `visibility: hide`, so Sol is the correct bare resolution. **Fix: never call bare `codex` in automation — pin terra/luna/sol explicitly.** |
| D9 | "Luna 41.3 on reasoning" | 🔧 **MISLABELLED.** 41.3 is **MRCR v2 8-needle long-context recall**, not reasoning (Sol 91.5 / Terra 89.6 on the same test). Luna is fine for short-document classification, bad at needle-in-haystack. **Doctrine §14.6 must say MRCR.** |
| D10 | Engines cannot self-identify | ❌ **NO FIX**, and our remedy needed sharpening (§8.1). |
| D11 | Flat-rate image/video lane | 🔧 **SPLIT.** **Images: CONFIRMED** on Adrian's own account. **Video: claim WITHDRAWN** (per-second billing misread as per-token). Both gated by interactive-only terms. §7.2 change is Adrian's. |
| D12 | Cheap bulk classification | ✅ **IMPROVED.** `local` first, then `qwen3.8-flash`. Route by token volume and stakes, not item count. |
| D13 | Fable 5.1 output-token cost | 🔧 **REFRAMED.** The 1.7×/+20% claim is unverified in first-party material. The real constraints are the **50% Max cap**, ZDR incompatibility and forced-tool_choice 400s. |
| D14 | Multimodal batch bottleneck | ✅ **IMPROVED.** Gemini 3.8's per-part `media_resolution` is the new lever; `qwen3.8-flash` is a second 2-wide multimodal lane. |
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
