---
name: llm-capability-map-2026-07-25
title: The LLM Capability Map — every engine in the stack, what it is best at, and how to prompt it
type: doctrine
tier: 1
status: CURRENT
date: 2026-07-25
author: Claude (Opus 5) — CEO-of-the-stack
as_of_utc: 2026-07-25T09:30:00Z
grounding_mode: web_assisted
supersedes: the model tables in canonical/concepts/model-routing-engine.md (2026-05-29, now historical)
extends: canonical/concepts/delegation-first-operating-doctrine.md §13/§14
cross_references:
  - "canonical/concepts/delegation-first-operating-doctrine.md (the constitution)"
  - "canonical/concepts/cli-prompting-art-per-engine-delivery.md (delivery idioms)"
  - "canonical/concepts/model-orchestration-playbook-2026-06-12.md (role/tier matrix)"
  - "working/_research/2026-07-25-llm-map-refresh/ (raw sourced research)"
---

# The LLM Capability Map — 2026-07-25

**Why this exists.** Between 9 June and 24 July 2026 every vendor in the stack shipped a new
frontier tier. Adrian's routing doctrine was written against Gemini 3.5 Flash, GPT-5.5, Grok 4.3
and Claude Opus 4.8. All four are now superseded. This file is the single current answer to
*"which engine, at what setting, for which job, prompted how."*

**Grounding.** Every figure below was pulled live on 2026-07-25 from vendor primary docs
(platform.claude.com, developers.openai.com, google.dev) plus multi-engine web research, and
cross-checked across at least two independent families. Raw returns:
`working/_research/2026-07-25-llm-map-refresh/`. Figures marked ⚠️ are single-source secondary.

---

## §0 — THE HEADLINE (read this if you read nothing else)

1. **Opus 5 shipped 24 July 2026** — one day before this map. It is the new default on Claude Max
   and it is what this session runs on. It reaches ~within 0.5% of Fable 5's peak coding score at
   **half the price**, and it is the most aligned Claude yet.
2. **The single biggest change is not a model, it is a prompting law.** Every vendor independently
   published the same finding this quarter: **stop over-prompting.** OpenAI measured that stating
   each instruction *exactly once* and deleting repeated rules **raises scores 10–15% while cutting
   tokens up to 66%.** Anthropic says remove verification scaffolding entirely. Our vault doctrine
   is currently the opposite of this — see §6, it is the highest-value action in this document.
3. **The cheap tier got genuinely good.** Sonnet 5 beats Opus 4.8 on Terminal-Bench 2.1 (80.4% vs
   74.6%) at a fifth of the price. Gemini 3.6 Flash does 73.4% SWE-bench Verified at $1.50/MTok.
   Work we used to reserve for the top tier now runs correctly two tiers down.
4. **agy was mis-pinned and is now fixed.** The pin string `"Gemini 3.5 Flash (High)"` matched no
   slug agy actually publishes, so it was not reliably binding. Repinned to the verified
   `gemini-3.6-flash-high`. See §7.1.
5. **codex is down today** — OpenAI-side 503 (`biscuit_baker_service_me_circuit_open`), a vendor
   outage, **not** our quota. Do not read this as the Pro-upgrade trigger.

---

## §1 — ANTHROPIC (Claude 5 generation)

Source: `platform.claude.com/docs/en/about-claude/models/overview` + `/pricing` + `/effort`,
fetched live 2026-07-25.

| | **Fable 5** | **Opus 5** | **Sonnet 5** | **Haiku 4.5** |
|---|---|---|---|---|
| API ID | `claude-fable-5` | `claude-opus-5` | `claude-sonnet-5` | `claude-haiku-4-5-20251001` |
| Shipped | 9 Jun 2026 | **24 Jul 2026** | 30 Jun 2026 | 15 Oct 2025 |
| Context | 1M | 1M | 1M | 200k |
| Max output | 128k | 128k (300k batch beta) | 128k (300k batch beta) | 64k |
| $/MTok in–out | **$10 / $50** | **$5 / $25** | **$3 / $15** (intro $2/$10 to 31 Aug) | **$1 / $5** |
| Latency class | Slower | Moderate | Fast | Fastest |
| Thinking | Adaptive, **always on** | Adaptive, default on | Adaptive, default on | Extended thinking only |
| Effort levels | low→max + xhigh | low→max + xhigh | low→max + xhigh | ❌ not supported |
| Knowledge cutoff | Jan 2026 | **May 2026** | Jan 2026 | Feb 2025 |

**Also live:** `claude-opus-4-8` ($5/$25, 1M, legacy but current-grade) — still the safe fallback.
`claude-mythos-5` = Fable 5 specs/pricing, invitation-only via **Project Glasswing**, scoped to
**defensive cybersecurity** work. Not available to us.
**Retiring:** `claude-opus-4-1` **retires 5 Aug 2026** — vault pin audit already ran clean (07-24).

### 1.1 What each is actually best at

- **Fable 5** — *the longest, hardest, most autonomous runs.* Anthropic's own framing: "the longer
  and more complex the task, the larger Fable 5's lead." SWE-bench Pro ~80%, the highest of any
  model in this map. **But: 2× Opus 5's price, slower, and it carries strict safety classifiers**
  that fall back to Opus 4.8 and produce false positives on ordinary coding/debug work.
  → Use when the task genuinely runs for hours and correctness dominates cost.
- **Opus 5** — *the new default for everything serious.* Within 0.5% of Fable's peak CursorBench
  score at max effort for **half the cost per task**; SOTA on Frontier-Bench v0.1 and GDPval-AA;
  **ARC-AGI 3 at 3× the next-best model**; best cost/performance on OSWorld 2.0; lowest misaligned-
  behaviour score (2.3) of any recent model. Knowledge cutoff **May 2026** — the freshest in the
  family by four months, which matters for anything current-events adjacent.
  → **This is the default. Reach past it only for a named reason.**
- **Sonnet 5** — *the surprise.* Terminal-Bench 2.1 **80.4%, beating Opus 4.8's 74.6%** ⚠️, at
  $3/$15. SWE-Bench Pro 63.2%. The right engine for the large middle of the work.
  → Builder tier. Plan already decided, execution mechanical-to-moderate.
- **Haiku 4.5** — *volume.* SWE-bench Verified 73.3% at $1/$5. **No effort parameter and only 200k
  context** — those two limits, not quality, are what disqualify it from agentic work.
  → Scribe tier: summaries, changelogs, state compression, classification.

### 1.2 The effort parameter (the real cost lever)

Effort affects **all tokens** — text, thinking, *and tool calls*. Lower effort literally means
fewer tool calls, not just shorter thinking. Default is `high` everywhere; `high` ≡ omitting it.

| Level | Use for |
|---|---|
| `max` | Genuinely frontier problems only. Often big cost for small gain; can cause overthinking. |
| `xhigh` | Long-horizon agentic/coding runs >30 min with million-token budgets. |
| `high` | Default. Complex reasoning, difficult coding. |
| `medium` | Balanced. The step-down that usually holds quality. |
| `low` | Simple tasks, classification, **subagents**. |

**Hard gotchas, all vendor-documented:**
- On Opus 5, `thinking: {"type":"disabled"}` at `xhigh`/`max` returns **400**.
- Changing effort mid-conversation **invalidates prompt caching**. Pick a level and hold it.
- Effort controls *thinking*, not *visible length* — lowering it does **not** reliably shorten
  replies. Prompt for length separately.
- At `xhigh`/`max`, set `max_tokens` large (64k is the suggested starting point) or the model runs
  out of room mid-thought.

### 1.3 Ultracode (Claude Code)

A **session setting, not an API effort level**. `/effort ultracode` sends **`xhigh` effort** *and*
enables **dynamic multi-agent workflow orchestration**. Session-scoped only (unlike low/med/high/
xhigh, it does not persist). Needs Claude Code ≥ v2.1.203 and a model supporting `xhigh` — so
Fable 5, Opus 5, **Sonnet 5**, Opus 4.8, Opus 4.7 all qualify. Billed as xhigh tokens plus the
extra agent turns; there is no separate ultracode price. **Not** the same as the `ultrathink`
keyword, which is a one-turn prompt trick that does not change API effort.

**Practical read for Adrian:** ultracode on **Sonnet 5** is the interesting configuration —
multi-agent orchestration at $3/$15 instead of $5/$25. Worth an eval before defaulting heavy
workflow sessions to Opus.

---

## §2 — OPENAI (GPT-5.6 family, GA 9 July 2026)

| | **Sol** | **Terra** | **Luna** |
|---|---|---|---|
| $/MTok in–out | $5 / $30 | $2.50 / $15 | $1 / $6 |
| Context / max out | 1.05M / 128k | 1.05M / 128k | 1.05M / 128k |
| Knowledge cutoff | 16 Feb 2026 | 16 Feb 2026 | 16 Feb 2026 |
| Positioning | Flagship frontier reasoning | Balanced production | High-throughput classification/routing |

**Effort levels: `none` | `low` | `medium` | `high` | `xhigh` | `max`** — note `none`, which Claude
does not have.

**Benchmarks:** Terminal-Bench 2.1 — Sol **88.8%**, Sol at Ultra effort **91.9%** ⚠️ (the highest
agentic-coding score in this map). Agents' Last Exam — **Sol 53.6, beating Fable 5 by 13.1 points**,
OpenAI's headline claim. But SWE-Bench Pro — **Fable 5 80% vs Sol 64.6%**. Nerova — Sol 91.5,
Terra 89.6, **Luna 41.3**.

**The Luna cliff is the routing fact that matters.** Luna is 89.6→41.3 off Terra on Nerova. It is
*not* a cheap general model; it is a classification/routing engine. Do not hand it reasoning work.

**Weakness:** Sol trails Fable 5 badly on real-repo software engineering (SWE-Bench Pro) while
leading on agentic-exam benchmarks — i.e. it wins at *orchestrated tool sequences* and loses at
*deep code correctness*. Route accordingly.

---

## §3 — GOOGLE (Gemini 3.6 family, 21 July 2026)

The 21 July release was a **trio**: **Gemini 3.6 Flash** (`gemini-3.6-flash`), **Gemini 3.5
Flash-Lite** (`gemini-3.5-flash-lite`), and **Gemini 3.5 Flash Cyber** (`gemini-3.5-flash-cyber`,
government/trusted-partner pilot only — not available to us).

| | **3.6 Flash** | **3.5 Flash** | **3.5 Flash-Lite** | **3.1 Pro** |
|---|---|---|---|---|
| Context / out | 1.05M / 65k | 1M / 65k | 1.05M / 65k | 1M / 65k |
| $/MTok in–out | **$1.50 / $7.50** | $1.50 / $9.00 | **$0.30 / $2.50** | $2/$12 (≤200k), $4/$18 above |

**Gemini 3.5 Pro is still NOT generally available** as of today — limited Vertex enterprise preview,
under quality rebuild. The >1M vault-synthesis lane the vault has been holding open for it stays
parked. This is now more than a week past its rumoured internal date.

**3.6 Flash benchmarks:** SWE-bench Verified **73.4%**, SWE-Bench Pro 58.7%, GPQA Diamond **92.8%**,
Terminal-Bench 2.1 **78.0%**, OSWorld-Verified **83.0%**, MMMU-Pro 83.2%, MLE-Bench 63.9% (up from
49.7% on 3.5). Roughly **17% fewer output tokens** for equivalent work than 3.5.

**Best at:** genuine 1M-token single-turn ingestion, native multimodal (interleaved video/audio/PDF),
**live Google-Search grounding with citations**, and raw cost-per-token throughput. Flash-Lite at
$0.30/$2.50 is the cheapest competent engine anywhere in the stack.

**Worst at / failure modes** (all of these are why §6's prescriptive-prompt law exists):
instruction drift over long threads · attention-sink degradation where recent context overwrites
earlier instructions · **"false completeness"** — long, detailed, confident output that is
logically empty · **"imagined completions"** — claiming a file was written or a build run when it
was not. Thinking control is `thinking_level: low|medium|high`; the old `thinking_budget` is
deprecated and passing both errors.

**Antigravity: 2.3.1** (16 Jul 2026). Ships Gemini 3.6 Flash, 3.5 Flash, 3.1 Pro, Claude Sonnet 4.6,
Claude Opus 4.6-thinking, and gpt-oss-120b. **AI Ultra ($200) = 20× the Pro ($20) tier.** Flash and
Pro draw on **one unified compute pool**; tripping the weekly baseline is a hard lockout for the
**remainder of the 7-day window (4–7 days)** — which is exactly why §11.4 of the doctrine protects
the AG weekly quota while pushing every other engine to its hourly ceiling.

---

## §4 — SPACEXAI (Grok 4.5, 8 July 2026)

Context **500K** (a regression from 4.3's 1M — do not route >400K payloads here; prompts >200K bill
at a higher tier). **$2 / $6**, cached input **$0.30** (docs.x.ai) — the cheapest frontier-adjacent
engine in the stack. SWE-Bench Pro **64.7%**, which slots it *between Sonnet 5 (63.2%) and Opus 4.8
(69.2%)*, well behind Fable 5's ~80%. **Terminal-Bench 2.1 83.3%** (x.ai) — genuinely strong, above
Gemini 3.6 Flash's 78.0% though below Sol's 88.8%. Artificial Analysis ranks it **#4 overall at 54**,
behind Fable 5, GPT-5.5 and Opus 4.8, and puts it on the cost-efficiency Pareto frontier
(~$0.31 per Intelligence-Index task).

**The disqualifying number:** Artificial Analysis measured Grok 4.5's **hallucination rate at 54%,
more than double Grok 4.3's 25%** — alongside a genuine accuracy gain. It got both more right *and*
more confidently wrong. **No Grok-sourced fact promotes to canonical without a different-family
cross-check.** This is not a style preference; it is a measured 54%.

`grok-composer-2.5-fast` (Cursor's coding model, 200K ctx) rides in Grok Build for fast mechanical
coding. Grok's live-web lane (`grok-web`) **works and cites** — it produced the best single research
return in this session's fan-out.

---

## §5 — THE CROSS-VENDOR BOARD

| Model | Ctx | $/M in–out | Headline coding | Best at | Worst at |
|---|---|---|---|---|---|
| **Fable 5** | 1M | 10 / 50 | SWE-Pro ~80% | Longest autonomous runs | Price, latency, classifier false-positives |
| **Opus 5** | 1M | 5 / 25 | ~Fable at ½ cost | **Best all-round value at the frontier** | Verbose; over-delegates; over-verifies |
| **Sonnet 5** | 1M | 3 / 15 | T-Bench 80.4% | Speed×intelligence sweet spot | Literal instruction-following |
| **Haiku 4.5** | 200k | 1 / 5 | SWE-V 73.3% | Volume scribe work | No effort param; 200k ctx |
| **GPT-5.6 Sol** | 1.05M | 5 / 30 | T-Bench 88.8% | Agentic tool sequences; hard arbitration | Deep repo correctness (SWE-Pro 64.6%) |
| **GPT-5.6 Terra** | 1.05M | 2.50 / 15 | Nerova 89.6 | Everyday production | — |
| **GPT-5.6 Luna** | 1.05M | 1 / 6 | Nerova **41.3** | Classification/routing ONLY | Anything requiring reasoning |
| **Gemini 3.6 Flash** | 1.05M | 1.50 / 7.50 | SWE-V 73.4% | Multimodal, grounding, throughput | Drift, false completeness |
| **Gemini 3.5 Flash-Lite** | 1.05M | 0.30 / 2.50 | — | Cheapest competent engine | Low-reasoning only |
| **Grok 4.5** | 500K | 2 / 6 | SWE-Pro 64.7% · TB2.1 83.3% | Cheap bounded verification, live web | **54% hallucination rate** |

**Cross-check note:** the Grok leg of this research was run on grok-web, i.e. Grok profiling itself.
Its numbers were therefore checked against vendor primaries (docs.x.ai, x.ai/news) and an
independent Artificial Analysis reading before landing here. The Anthropic leg was likewise
grok-sourced and was re-verified by Claude directly against `platform.claude.com` — it held up,
with the Sonnet 5 intro-pricing nuance confirmed rather than corrected.

---

## §6 — THE PROMPTING LAW (the most actionable section in this file)

Every vendor converged on the same finding this quarter, independently. **Modern frontier models
want LESS instruction, not more.** Instructions that helped in 2025 now actively cost quality.

**OpenAI's measured result:** stating each instruction *exactly once* and deleting repeated rules
from old prompts **raised scores 10–15% and cut tokens by up to 66%.** Their guidance headline is
literally "stop over-prompting."

**Anthropic's version:** remove anti-laziness scaffolding, remove "verify everything" instructions,
remove "double-check your answer" — on Opus 5 these *compound with behaviour the model already has*
and add cost with no quality gain.

### 6.1 The universal rules

| Do | Don't |
|---|---|
| State each instruction **exactly once** | Repeat the same rule in three places |
| Positive instructions ("do X") | Long "never do Y" lists |
| Documents at the **top**, query at the **end** | Bury the ask in the middle |
| Prompt explicitly for **length** | Assume low effort shortens output |
| Give **intent / why**, not just steps | Prescriptive step-lists on frontier models |
| One delivery idiom per prompt | "Read file X" *while also* inlining X |

### 6.2 Per-engine specifics

**Claude Opus 5** — *remove* verification instructions, subagent-verify instructions, and
"double-check" prompts (all cause over-verification). *Add* an explicit conciseness line, a
narration-cadence line, a written-deliverable length calibration, and a subagent-delegation cap.
It expands scope and delegates readily; constrain both explicitly. With thinking disabled it can
leak tool-calls-as-text and internal XML tags — keep thinking on at `low` effort instead of
disabling it.

**Claude Sonnet 5** — **literal.** "Only report high-severity issues" will genuinely suppress
findings. State scope explicitly ("every section"). Effort maps roughly: Sonnet 5 `medium` ≈ Sonnet
4.6 `high`; Sonnet 5 `high` ≈ Sonnet 4.6 `max`. Non-default `temperature`/`top_p`/`top_k` → **400**.

**Claude Fable 5** — brief instructions are usually enough; give it *intent*. **Never ask it to echo
or show its reasoning** — that trips a `reasoning_extraction` refusal. Prescriptive skill-files
tuned for older models can actively degrade it.

**GPT-5.6** — already more concise than 5.5, so **old "be brief" instructions now over-correct** and
produce answers that are too short. Use the `verbosity` parameter globally and override per task.
When migrating, keep your current effort as baseline then test **one level lower** — 5.6 usually
holds quality for fewer tokens.

**Gemini 3.6** — the one engine that still needs prescriptive structure. XML semantic boundaries
(`<instructions>`, `<context>`, `<data>`); behavioural rules at the **top**, execution directions
*after* large data blocks to avoid dilution; API-level **JSON response schemas** rather than
"output JSON" in prose; anchor framing — *"Based only on the provided text…"* — to suppress
confabulation. Don't mix XML tags and markdown fences in one prompt.

**Grok 4.5** — good at bounded verification and cross-audit, bad at long solo reads. Deliver >40KB
via the **file-read idiom** (already automated in `cli-ask.sh`). Never promote its facts unchecked.

### 6.3 ⚠️ What this means for our own vault

Our doctrine files repeat the same rules many times across `AGENTS.md`, `CLAUDE.md`,
`delegation-first-operating-doctrine.md` and `claude-ceo-operating-doctrine.md` — and they are all
loaded into **every session**. On the 2025-era models that redundancy was insurance. On the Claude 5
generation, the vendors' own measurements say it is **costing quality and burning tokens**.

**This is a real, measurable, unrealised saving and it is the top follow-up from this map.** It is
deliberately NOT actioned in this pass — consolidating constitutional files is a doctrine change
under `AGENTS.md` §8 and needs Adrian's explicit go-ahead. See §8.

---

## §7 — ROUTING CONSEQUENCES (what actually changes)

### 7.1 Applied this session
- **agy repinned** `"Gemini 3.5 Flash (High)"` → **`gemini-3.6-flash-high`** in `tools/agy-ask.py`.
  Fixes both a stale model and a **wrong-format pin string that was not reliably binding**.
  Verified live.

### 7.2 The new routing table

| Job | Engine | Why |
|---|---|---|
| Default Claude session | **Opus 5** @ `high` | Frontier quality, half Fable's cost, freshest cutoff |
| Hours-long autonomous run | **Fable 5** @ `xhigh` | Lead grows with task length |
| Builder subagent | **Sonnet 5** @ `medium` | Beats Opus 4.8 on Terminal-Bench at ⅕ price |
| Scribe subagent | **Haiku 4.5** | $1/$5; no effort param needed for this work |
| Batch grind / vision / multimodal | **agy** (3.6 Flash) | Biggest pool, $0 vision, 17% leaner |
| Cheapest bulk classification | Gemini 3.5 Flash-Lite | $0.30/$2.50 |
| Live-web research | **grok-web** | Cites in-CLI; best return in today's fan-out |
| Hard arbitration / council tiebreak | **codex-sol** @ xhigh | T-Bench 88.8%; smallest pool, use sparingly |
| Mechanical coding | `composer` | Keeps premium tokens out of mechanical edits |
| >400K payload | agy or codex | Grok is 500K only |

### 7.3 Unchanged
6:3:1 batch proportions (agy:grok:codex) — agy still has the biggest pool. Council-ask stays 1:1:1.
AG weekly-quota protection (§11.4) stands: 4–7 day lockout confirmed again today.

---

## §8 — OPEN / NOT ACTIONED

1. **Prompt-redundancy consolidation across the constitutional files** (§6.3). Measurable 10–15%
   quality and up to 66% token saving on vendor numbers. Doctrine change → needs Adrian.
2. **Gemini 3.5 Pro** still not GA, >1 week past its rumoured date. The >1M synthesis lane stays parked.
3. **Ultracode-on-Sonnet-5** as the default heavy-workflow config — needs an eval before adopting.
4. **codex outage** (OpenAI 503, vendor-side). Re-test before concluding anything about quota.
5. **`claude-opus-4-1` retires 5 Aug 2026** — vault pin audit clean as of 07-24; re-check before the date.

---

revision_history:
- 2026-07-25 — created (Adrian-direct: "updated LLM map for all the new models… so we can reconfigure
  the Team Utilization Architecture… and learn how to prompt them as well"). Live-sourced from vendor
  primary docs + multi-engine fan-out; codex lane down vendor-side so its two legs were rerouted to
  grok-web/agy and cross-checked by Claude's own WebFetch against platform.claude.com. agy repin
  applied and verified. Raw research: `working/_research/2026-07-25-llm-map-refresh/`.
