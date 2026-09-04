# The Art of Prompting Through the CLI Team — Per-Engine Delivery Idioms
**Status:** Tier-2 reference (operational). **Created:** 2026-07-18 (Adrian-commissioned after the grok-audit truncation). **Owner:** Claude.
**Companion to:** [[delegation-first-operating-doctrine]] §4/§6/§13, `tools/cli-ask.sh`, [[feedback-bounded-cli-prompting]].

## The question that produced this
Grok failed 3× to audit a 116 KB source bundle, then succeeded on a 22 KB cross-audit. Adrian asked: *is this a bundling or a prompting problem, and can we bundle so grok accepts it?* Answered **empirically on-box**, not by asking an LLM.

## The verdict: it is a DELIVERY-IDIOM problem, not context and not "bundling"
- **NOT a context-window limit.** 116 KB ≈ ~29 K tokens vs grok-4.5's **500 K** window (live-verified 2026-07-18 — see below). 17× headroom.
- **NOT a raw size cap on the transport.** `cli-ask.sh` already delivers grok prompts via grok's native `--prompt-file` (no argv limit).
- **The real mechanism (PROVEN):** grok is an **agentic coding CLI ("Grok Build")**, not a text-completion endpoint. When you hand it a *large inline* `--prompt-file`, its harness **offloads and truncates the inline view** and expects the model to retrieve the remainder with a tool call. Headless, single-turn, no tool-permission → it can't → it silently audits only the head.
  - Test A (116 KB inline `--prompt-file`): grok saw **3 of 18 files**, noted *"message body was mid-truncated after join route ... per offload note."*
  - Test C (116 KB delivered as an **on-disk file grok READS with its own tool**, `--permission-mode bypassPermissions --max-turns 12`): **all 18/18 files enumerated, exact byte count, RC=0.**

## The three delivery idioms (pick by engine + size)
| Idiom | How | Best for |
|---|---|---|
| **Inline argv / prompt-file** | content is IN the prompt | Small prompts (grok ≤ ~40 KB; codex/agy ≤ ~100 KB) |
| **File-read (agentic)** | write content to a file; tell the agent "Read `<path>` in full, then …"; grant tool permission + turns | **grok with large content**; any agentic CLI |
| **File-path pointer** | pass a real repo path and let the agent's own tools walk it | code tasks where the agent should explore, not be spoon-fed |

## Per-engine cheat-sheet (verified 2026-07-18)
- **grok (grok-4.5, Grok Build TUI)** — `--single/-p` (small), `--prompt-file` (small→medium), `--prompt-json`, `--json-schema` (structured out), `--max-turns`, `--permission-mode {default,acceptEdits,auto,dontAsk,bypassPermissions,plan}`, `--tools`, `--disable-web-search`. **Context 500 K (regressed from 4.3's 1 M).** Large content → **file-read idiom** (now automated in cli-ask, see below). Confident-hallucinator → never promote grok facts without a different-family cross-check.
- **codex (GPT-5.6 sol/terra/luna)** — `codex exec -m …`, prompt as argv. The API models advertise ~1.05 M context / 128 K output, but the ChatGPT-auth Codex CLI exposes **272 K raw context**. ChatGPT Pro 5x makes this the team's biggest subscription pool; Sol/xhigh is the explicit default and may be used freely at depth.
- **agy (Gemini 3.8 Flash High)** — `agy-ask.py`, prompt as argv (PTY). 1 M ctx. ⚠️ **Small pool since the 2026-07-29 Ultra→base downgrade** (was "biggest pool / default grind" — see the 2026-08-04 note at the end of this file); still the $0 vision lane. Reads serials/images.

## The fix baked into `tools/cli-ask.sh` (2026-07-18)
The non-web grok branch is now **size-gated** (`CLI_ASK_GROK_INLINE_MAX`, default 40 000 bytes):
- **≤ threshold →** inline single-turn (`--max-turns 1`) — unchanged, proven, no agentic drift.
- **> threshold →** payload written to a `grokdata` file; grok told to **Read it in full** with `--permission-mode bypassPermissions --max-turns 12`. This is the Test-C idiom, automated. No caller change needed — big grok prompts now just work.
- Regression guard: `cli-ask-selftest.sh` **P5** (200 KB → file-read path delivers full) + **P5b** (5 KB → inline path) — both green, 14/14.

## Prompting best practices (all engines — the reliability levers)
1. **Match the idiom to the delivery.** Do NOT tell an engine "read file X" while also dumping X inline — the conflict confuses agentic CLIs (this was half the original grok failure). Either inline-with-"content-below" framing, OR file-read-with-a-path — never both.
2. **Prescriptive structure** (from [[delegation-first-operating-doctrine]] §6): ROLE / CONTEXT (exact paths) / DO / DON'T / OUTPUT (exact format) / GROUNDING ("[NOT FOUND] not invention") / VERIFY (print count + first lines).
3. **Output-mode preamble** for agentic CLIs: "write your COMPLETE answer as plain text to stdout; no plan mode; no subagents; no file writes" — stops the agent from going off to write a file and emitting 0 bytes.
4. **Do not route by advertised window size:** no lane is a big-payload destination. `cli-ask.sh` spills inputs over 100 K characters to a file already; chunk oversized corpora with deterministic retrieval. Use agy's genuine 1 M window only when the analysis itself needs that breadth; the ChatGPT-auth Codex CLI is capped at 272 K raw context.
5. **Reserve grok for what it's best at:** bounded verification, cross-audit, `grok-web` live research — not 100 KB solo reads. It excelled at the 22 KB cross-audit (23 confirmations + 12 gaps) the same session it failed the 116 KB solo.
6. **Verify-before-trust every large return:** confirm the engine actually ingested the whole payload (ask it to echo a count/marker) before believing a "clean" audit — a truncated-input audit looks identical to a complete one.

## 2026-07-25 UPDATE — the prompting law inverted, and the current engine strings

Companion: **[[llm-capability-map-2026-09-04]]** (full specs/benchmarks/pricing) + delegation-doctrine **§14**.

**The big inversion: STOP OVER-PROMPTING.** Everything above about *delivery idioms* still holds — but the guidance on *how much* to instruct has flipped for the frontier models. Every vendor published the same finding in Q3-2026. **OpenAI measured that stating each instruction exactly once and deleting repeated rules raises scores 10–15% while cutting tokens up to 66%.** Anthropic's Opus 5 guidance says to *remove* "verify everything" / "double-check" / "use a subagent to verify" outright. The §6 prescriptive-prompt law is **not** repealed — it exists because agy/grok confabulate without exact paths and grounding clauses — but it should now be applied as **structure, not volume**: exact paths, exact output format, one grounding clause. Not the same rule three times.

**Per-engine prompting deltas (2026-07-25):**
- **Claude Opus 5** — remove verification/double-check/subagent-verify instructions (they compound with behaviour it already has). Add: an explicit conciseness line, a narration-cadence line, a written-deliverable length calibration, and a subagent-delegation cap — it expands scope and delegates readily. Keep thinking ON at `low` effort rather than disabling it (disabled thinking leaks tool-calls-as-text and internal XML tags).
- **Claude Sonnet 5** — **literal**. "Only report high-severity issues" genuinely suppresses findings. State scope explicitly ("every section"). Non-default `temperature`/`top_p`/`top_k` → **400**.
- **Claude Fable 5** — brief is enough; give intent/why. **Never ask it to echo or show its reasoning** — trips a `reasoning_extraction` refusal.
- **GPT-5.6** — already terser than 5.5, so legacy "be brief" now **over-corrects**. Use the `verbosity` parameter; on migration test **one effort level lower** than the 5.5 baseline. Effort adds `none` below `low`.
- **Gemini 3.6** — the one engine that still wants full prescriptive structure: XML semantic boundaries (`<instructions>`/`<context>`/`<data>`), behavioural rules at the TOP but execution directions AFTER large data blocks (prevents dilution), API-level **JSON response schemas** rather than "output JSON" in prose, and anchor framing *"Based only on the provided text…"*. Don't mix XML tags and markdown fences in one prompt. Failure modes to prompt against: instruction drift, attention-sink overwrite, **false completeness** (confident but logically empty), **imagined completions** (claims a file was written when it wasn't).
- **Grok 4.5** — hallucination rate is a **measured 54%** (Artificial Analysis; 2× Grok 4.3's 25%). Different-family cross-check before any promotion is now numeric policy, not taste.

**The file-read idiom is now GENERALISED to all three engines (2026-07-25).** It was grok-only. The
per-engine table above said agy/codex handle "≤ ~100KB" inline — true, but what happened *above* that
was the real problem: `cli-ask.sh` silently **rerouted the job to grok**, swapping the model behind
the caller's back and sending the biggest payloads to the smallest-context, highest-hallucination
engine. Now every engine keeps its own oversized payloads: the content goes to a data file and the
engine gets a ~400-char argv instruction to read it in full. **Verified** with a 126,228-char payload
carrying a canary *only at the very end* — agy and codex both returned the canary plus an exact body
count (`TOKEN=ZEBRA-9174-OMEGA COUNT=2000`), proving full ingestion. Guards: selftest **P14/P14b**,
now 16/16. Knobs: `CLI_ASK_BIG_MAX` (default 100000), `CLI_ASK_LEGACY_GROK_REROUTE=1` to revert.
*Idiom rule #1 still applies — never tell an engine to read a file while also inlining it.*

**Current engine strings (verified live 2026-07-25):**
- `agy models` → `gemini-3.6-flash-{high,medium,low}` · `gemini-3.5-flash-{high,medium,low}` · `gemini-3.1-pro-{high,low}` · `claude-sonnet-4-6` · `claude-opus-4-6-thinking` · `gpt-oss-120b-medium`.
- **`AGY_MODEL` repinned to `gemini-3.6-flash-high`.** The previous default `"Gemini 3.5 Flash (High)"` matched **no** published slug — wrong format, so the pin was not reliably binding and agy could fall back to its last-selected model. Note the slug format when pinning anything here.
- **codex was down vendor-side on 2026-07-25** (OpenAI 503, `biscuit_baker_service_me_circuit_open`) — an outage, not a quota signal.

## Grok 4.5 context window — the live-verified fact (settles a recurring confusion)
**500 000 tokens.** Confirmed 2026-07-18 via WebSearch across xAI docs + OpenRouter + LLMReference + DataNorth + Kingy. This is a **regression from Grok 4.3's 1 M**. Released 2026-07-08. Pricing $2/$6 per M (tiered ×2 above 200 K prompt). Adrian's recollection of "4.5 went to 1 M" is incorrect — it was 4.3 that was 1 M. Sources filed in `working/_research/2026-07-18-cli-prompting-research/`.

## ⚠️ CORRECTED 2026-08-04 — agy is no longer "biggest pool"
**Adrian-direct, 2026-07-29** (memory: `gemini-subscription-downgraded-from-ultra`): the Google/Antigravity subscription was downgraded from Ultra to a ~$20-30 basic tier — *"predominantly because you failed to use it when I had the Ultra account."* Every "biggest pool / default grind" reference to agy in this file described the Ultra plan and is now stale; agy is a small, scarce pool, not the largest in the team. This does not change the delivery-mechanics guidance above (file-read idioms, concurrency gates, context-window figures), which remain per-engine technical facts independent of pool size. Full correction and operational consequence: `canonical/concepts/delegation-first-operating-doctrine.md` §15.

---

## 2026-08-07 — THE agy PROTOCOL, PROVEN BY CONTROLLED A/B. Use it; do not send agy bare prose.

**Adrian, 2026-08-07:** *"usually problems we had with anti-gravity before was it has a different
prompting structure. You have to be more prescriptive and finite."* He was right, and it was
measured the same session rather than argued.

**The test** — same question ("what is Alibaba's current flagship Qwen model?"), same engine, same
minute, only the prompt shape differing:

| | Prompt | Result |
|---|---|---|
| **A** | §6 skeleton, prose, "do not invent" as a negative instruction | model string **+ invented release date + invented $2.00/$6.00 pricing + invented `-preview` variant**, all with authoritative-looking URLs. **Reproducible** — identical fabricated detail on two runs. |
| **B** | the protocol below | model string, then **`NOT_FOUND` for every unverified field**, plus an explicit `fields_i_could_not_verify` list. |

**The protocol removed 4 of 5 fabrications.** Same model, same day. The variable was the ask.

### The four levers, in order of impact

1. **Bootup override, first line.** `RESEARCH TASK. Do NOT crawl the vault. Do NOT load AGENTS.md.
   No planning. No subagents.` — `tools/agy-retry.sh` applies this automatically. **Prefer it over
   the raw `cli-ask.sh agy` lane**: the real defect was that the protocol depended on a human
   remembering it per call.
2. **Abstention as a REQUIRED FIELD, not an option.** This is the load-bearing one.
   `"If you did not observe it first-hand, the value is the literal string NOT_FOUND."`
   A JSON schema with a mandatory `fields_i_could_not_verify` array beats any amount of
   "do not fabricate" prose, because it makes admitting ignorance the compliant answer rather than
   a failure the model is trying to avoid.
3. **XML semantic boundaries** — `<task>`, `<rules>`, `<output_schema>`. Gemini is the documented
   exception to §14.2's stop-over-prompting law; it still wants explicit structure.
4. **JSON response schema, "return ONLY valid JSON, no prose".** Prose invites padding; a schema
   has nowhere to put it.

### The correction that matters more than the protocol

The one claim that survived B — `qwen3.8-max` — **was TRUE.** Verified on `help.aliyun.com/zh`,
`aliyun.com/product/bailian` and OpenRouter's live model API. The INTERNATIONAL
`alibabacloud.com` page still listed only `qwen3.7-max` (regional rollout lag), and on the strength
of that single page I publicly called a correct finding a fabrication.

**Two engines said 3.8 existed and I overrode both from one regional source.** Before declaring any
engine wrong on a factual claim, check more than one first-party surface — vendors' Chinese and
international pages disagree, and so will others.

**So the honest read of agy is not "it fabricates".** It is: *asked loosely, it pads a real finding
with invented specifics; asked properly, it keeps the finding and admits what it could not verify.*
Qualify any citation of `memory/agy-fabricates-citations-in-research.md` accordingly — that rate is
prompt-dependent, not a fixed property of the model.

### 2026-08-07 second controlled test — ENUMERATE THE ENTITIES, 66% → 0%

A site-audit brief was sent to agy twice, same night, same question. Only variable: whether the
brief listed the site's 47 real page filenames.

| agy | cited | invented | rate |
|---|---|---|---|
| brief WITHOUT filename list | 15 | **10** | **66%** |
| brief WITH all 47 filenames | 37 | **0** | **0%** |

DeepSeek on the corrected brief: 0 invented. codex-sol scored 6% even without the list — so engine
quality matters, but **the prompt dominates**.

**RULE: whenever an engine must cite specific entities — filenames, model strings, URLs, columns,
SKUs — enumerate them IN the prompt.** Describing the domain and leaving the model to supply
identifiers is what manufactures confident, plausible, wrong specifics. It is not lying; it is
filling a gap you left. This is the same mechanism that produced the invented `arXiv:2403.04619`
and the invented `qwen3.8-max` release date and pricing earlier the same session.

---

# 2026-08-23 — THE SIX-LANE TEAM, AND THE SATURATION LAW

**Adrian-direct, this session:** *"there are six CLI lanes. Have you forgotten about the other
three?"* · *"There shouldn't be any of the lanes that are outside the CLI-ask. They should all be in
the CLI-ask. They are part of the team ... same ruling."* · *"every day if we're not throttling them
we're losing tokens, we're losing throughput of work."*

Two faults were live when he said it. **First**, a session opened by declaring "three lanes idle"
and loaded four of the six `cli-ask` lanes. **Second — the one that actually cost throughput — the
free, unlimited local lane was not in `cli-ask.sh` at all**, so it was invisible to every routing
decision and had been sitting at zero utilisation while cloud lanes were treated as the whole team.
A lane that is not in the dispatcher does not exist.

## §S1 — The roster, with LIVE status measured 2026-08-23

| # | Lane | Engine | Economics | Cap | Status measured today |
|---|---|---|---|---|---|
| 1 | `codex` `codex-sol` `codex-terra` `codex-luna` | GPT-5.6 | ChatGPT sub, flat | — | ✅ LIVE. 77 KB single-shot audit, rc=0 |
| 2 | `grok` `grok-web` `composer` | Grok 4.6 | SuperGrok sub, flat | 2 | ✅ LIVE. 42 KB cited web brief, rc=0 |
| 3 | `agy` | Gemini 3.7 Flash High | Antigravity sub, **small pool** | 2 | ✅ LIVE. 76 KB architecture, rc=0 |
| 4 | `qwen` `qwen-plus` | Qwen3.6-Plus, 1 M ctx | Alibaba Model Studio | 2 | ❌ **BLOCKED — see §S2** |
| 5 | `deepseek` | DeepSeek-V4-Flash, 1 M ctx | **metered**, $0.14/$0.28 per 1 M | 1 | ⚠️ Gated. $20/mo trial cap, signed token required |
| 6 | `local` `local-fast` `local-vision` | qwen2.5:14b · qwen3.5:9b · Qwen2.5-VL-7b | **$0, unmetered, unlimited** | 3 | ✅ LIVE, was at **zero utilisation** |

All six now dispatch through `tools/cli-ask.sh` and inherit the identical hardening the original
three had: concurrency gate that WAITS rather than stacks, hard wall-clock via `run-bounded.py`,
empty/thin-output detection (a 0-byte "success" can never read as an answer), bounded retry, and
shell-metacharacter safety. Adding a lane means adding it *there*, never calling a binary directly
from a session.

## §S2 — Lane 4 is blocked on an account entitlement, not on code

Measured 2026-08-23, both keys tested against `dashscope.aliyuncs.com/compatible-mode/v1`:

- The key inside `~/.qwen/settings.json` (`sk-sp-…`) returns **401 Invalid API-key**.
- The vault key `DASHSCOPE_API_KEY` (`sk-ws-…`) **authenticates**, but every model tested —
  `qwen3.6-plus`, `qwen3-max`, `qwen-max`, `qwen-plus`, `qwen-turbo`, `qwen3-coder-plus`,
  `qwen-flash`, `qwen3.5-plus` — returns `AccessDenied.Unpurchased`.

So the account has a valid credential and **no model entitlement at all**. This is an Alibaba Model
Studio activation, which only Adrian can do. The lane is wired and will work the moment a key with
entitlement exists; `cli-ask.sh qwen` fails loudly (exit 1) until then, never silently.
Do not re-diagnose this as an auth bug — it is a purchase state.

## §S3 — THE SATURATION LAW (the rule this session was missing)

> **A flat-rate lane left idle is throughput destroyed, not throughput saved.**
> Subscription quota does not accrue. It expires nightly. The only wrong number of concurrent
> lanes is fewer than the caps allow.

The aggregate ceiling is fixed by the gates, not by judgement:
**codex unbounded · grok 2 · agy 2 · qwen 2 · deepseek 1 · local 3.**
That is the shape of a fully-loaded day. Before ending any working session, the question is not
"did I use the team" but **"which of the six is at zero, and what should have gone there?"**

### Where the work actually belongs

The routing mistake that wastes the most is sending bulk work to a scarce cloud lane. Route by the
*kind* of job, not by which lane you happened to remember:

| Job shape | Lane | Why |
|---|---|---|
| Bulk classification / extraction / tagging / dedup over thousands of rows | **`local`** | $0 and unmetered. This is the doctrine's stated home for big-corpus first-pass. Cost of a 20,000-row pass is electricity. |
| Vision at volume (scene tags, b-roll, serials, stills) | **`local-vision`** (PC Qwen2.5-VL) | Measured 2,196 img/hr, 0 failures in 300 — vs agy's 576 img/hr at 35–90% batch failure post-downgrade |
| Live-web facts, anything after a model cutoff | **`grok-web`** | Only lane with in-CLI search + mandatory citations |
| One genuinely hard reasoning shot, or arbitrating a split council | **`codex-sol --effort xhigh\|max`** | Strongest single model in the $0 team; the Pro 5x pool is not scarce |
| Everyday reasoning / drafting / audit | **`codex-sol --effort xhigh`** | Explicit default after the Pro 5x upgrade; use Terra only for deliberate down-tiering |
| Mechanical code edits, refactors, migrations | **`codex-terra --effort low`** | Replacement for the dead `composer` lane |
| Multimodal, image reading, Google-grounded lookups | **`agy`** | Still the best tool-use reliability — but a **small pool**, so spend it deliberately |
| Oversized corpora / documents | **Chunk + deterministic retrieval** | No lane is a big-payload destination; Codex CLI is 272 K, and file-read is delivery rather than guaranteed full recall |
| Short schema-bound classification / extraction | **`codex-luna`** | Its 41.3 is **MRCR v2 8-needle long-context recall**, not reasoning; avoid needle-in-a-haystack work |

**The reflex to build:** when a task involves judging N items where N > ~200, the first question is
"why is this not on `local`?" — and the answer has to be a real one (needs live web, needs 1 M
context, needs frontier reasoning), not "I forgot the lane existed."

## §S4 — Prompt idioms for lanes 4–6

The three delivery idioms above still govern. What is new:

**`local` (Ollama over HTTP).** Not agentic. No tools, no file reads, no plan mode — so the whole
output-mode preamble that agentic CLIs need is *noise* here and should be omitted. The prompt goes
inline at any size (HTTP has no argv limit), which is why `cli-ask.sh` deliberately exempts this
lane from the file-read rewrite: telling a non-agentic endpoint to "read the file at /tmp/x" asks
for something it cannot do, and it will hallucinate a plausible answer rather than fail.
- Pin the context window explicitly: `CLI_ASK_LOCAL_CTX` (default 16384). A 14b model silently
  truncates past its window; it does not error.
- **Always demand JSON with `"format":"json"`-shaped instructions and a fixed key set.** A 14b model
  free-writing prose drifts; the same model filling a schema is reliable. This is the same lever
  that took agy from 66% invention to 0% — it matters *more* on a small model, not less.
- Include an explicit abstention value in the schema (`"unknown"`, `NOT_FOUND`). Without it a small
  model will pick the least-bad label rather than decline, which is exactly how keyword-style
  classification manufactured 131 fake XMAX records from the word "exhaustion".
- Temperature 0 for anything you intend to aggregate.

**`deepseek`.** Routed deliberately through `tools/ask-deepseek.py` so `metered-guard.py` and the
$20/mo trial cap still apply. **`cli-ask` must never become a way around the spend gate** — if a
future change makes the deepseek lane callable without the guard, that is a defect, not a
convenience. Prompt it like codex; it scored 0 invented citations on the corrected 2026-08-07 brief.

**`qwen`.** Agentic (`-p PROMPT --yolo`), so it takes the standard output-mode preamble and the
file-read idiom for large payloads. Key precedence is env → vault `.env`, because the CLI's own
settings file was the invalid one.

## §S5 — What did NOT change

§6.1–§6.3, the agy protocol (§four levers), and the ENUMERATE-THE-ENTITIES rule apply to all six
lanes without exception. Enumerating identifiers in the prompt matters *most* on the smallest model
in the team, which is now `local`. Nothing here authorises metered spend: lane 5 stays gated, and
the §11.1a presidential-approval rule is untouched.

## Revision history
- 2026-08-23 — §S1–§S5 added (Adrian-direct: six lanes, all inside `cli-ask`, same ruling).
  `tools/cli-ask.sh` extended with `qwen` / `deepseek` / `local` / `local-fast` / `local-vision`
  (backup: `tools/cli-ask.sh.bak-20260823-sixlanes`). Lane statuses in §S1 are measured, not
  assumed. Classification: ADDITION — no existing rule weakened or reinterpreted.
