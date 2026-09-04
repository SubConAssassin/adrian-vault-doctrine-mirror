# VERIFIED MODEL MAP, 2026-08-28

> ⛔ **SUPERSEDED 2026-09-04** by `canonical/concepts/llm-capability-map-2026-09-04.md`, which
> re-derived every lane from an engine-native probe on that date.
>
> 🔴 **ONE CLAIM BELOW IS WITHDRAWN, NOT JUST STALE.** §4's *"`wan-video` is on the Token Plan …
> doctrine §7.2 is now false"*, citing a price of `0.45`, was an **arithmetic misread**: that figure
> sat under a `price /Mtok` column, but **video is billed per SECOND of output**
> (`video_ratio_480p`). Alibaba's Token Plan Personal table lists video as `happyhorse-1.1-t2v/i2v/r2v`;
> Wan **video** IDs are pay-as-you-go. **A catalogue appearance never proved plan coverage.**
> The IMAGE half of that finding turned out to be true and is now proven on Adrian's own account
> (`~/.bailian/telemetry.jsonl`, `wan2.7-image`, 2026-08-07, success in 16.7s, drawing Credits).
> See the current map §5.2 and §5.3.
>
> Also corrected since: bare `codex` resolving to `gpt-5.6-sol` is **right**, because `gpt-reserve`
> carries `visibility: hide`; and the `qwen` lane is **working**, not blocked.


**Every row below was read from the engine's own live catalogue or proven by a probe on 2026-08-28.
Nothing here is copied from prior doctrine.** That is the point: the previous map said `codex` was
GPT-5.5, and it had not been GPT-5.5 since 2026-07-10.

**Adrian-direct:** *"make sure you've got an updated map of all the models because it seems like you
had 5.5 instead of the new 5.6."*

**How to re-verify, and do this before trusting any row:**

```
python3 tools/lane-doctor.py
```

---

## 1. ChatGPT / codex  (flat-rate subscription, `auth_mode: chatgpt`)

Read from `~/.codex/models_cache.json`, cache written 2026-08-28 00:18. **Priority is the
provider's own ordering, and priority 1 is what a call with no `-m` flag gets.**

| priority | slug | display | context |
|---|---|---|---|
| **1** | **gpt-5.6-sol** | GPT-5.6-Sol | 272,000 |
| 2 | gpt-5.6-terra | GPT-5.6-Terra | 272,000 |
| 3 | gpt-5.6-luna | GPT-5.6-Luna | 272,000 |
| 3 | gpt-reserve | GPT-Reserve | 272,000 |
| 7 | gpt-5.5 | GPT-5.5 | 272,000 |
| 16 | gpt-5.4 | GPT-5.4 | 272,000 |
| 23 | gpt-5.4-mini | GPT-5.4-Mini | 272,000 |
| 43 | codex-auto-review | Codex Auto Review | 272,000 |

🔴 **Bare `codex` resolves to `gpt-5.6-sol`.** `cli-ask.sh` passes no `-m`, so the provider default
applies. Proven twice: `lane-doctor` resolved it live, and `~/.codex/state_5.sqlite` shows gpt-5.5's
last thread was **2026-07-10 02:21** with zero of the 1,065 threads since on 5.5.

⚠️ **Two doctrine claims this breaks.**
1. Doctrine reserves Sol as the scarce arbitration tier and says *never batch it*. **Sol is what a
   generic call GETS.** Terra, the pin doctrine calls "everyday", carried 3% of threads.
2. Doctrine says `~1.05M ctx` and to *"route >400K-token payloads to agy/codex"*. **The real
   context is 272,000** (runtime granted 353,400). Codex cannot accept a 400K payload.

**CONCURRENCY: codex is UNGATED in `cli-ask.sh`.** No per-engine cap exists, so it is the widest
lane we have. The box-wide discipline number is ~10-12 concurrent CLI clients total.

---

## 2. Gemini / agy  (flat-rate subscription, Antigravity)

**Live pin verified 2026-08-28: `gemini-3.7-flash-high`.** `lane-doctor` resolved it from the CLI's
own `Resolving model` log line, which is emitted only after auth and is therefore proof the pin bound.

⚠️ `agy models` returns **nothing** headlessly, so the catalogue cannot be enumerated the way
codex's can. The pin is set in `tools/agy-ask.py` and overridable with `AGY_MODEL`.
⚠️ **`tools/lanes.py` was stale here**, still claiming Gemini 3.6 Flash High, 13 days after the
2026-08-14 repin. The registry is not automatically right either.

**CONCURRENCY: gate is 2** (`CLI_ASK_AGY_MAX`). Above that it wedges every lane.

---

## 3. Grok  (flat-rate Grok Pro subscription)

| model | note |
|---|---|
| **grok-4.6** | default |
| grok-4.5 | available |

🔴 `grok-composer-2.5-fast` is **RETIRED** by the vendor and appears zero times in 6,179 recorded
sessions. The `composer` lane pin now resolves against the live list and falls back loudly.

🔴 **State on 2026-08-28: `grok models` reports "You are not authenticated"** — the OAuth token in
`~/.grok/auth.json` had `expires_at 2026-08-27T14:26Z` and has lapsed. Separately the **Grok Build
usage meter is exhausted** (402 since 2026-08-26 04:23Z, after 1,539 sessions on 25 Aug alone).
**The Grok Pro subscription itself is ACTIVE and its chat quota is 40/40 unused** — reachable via
the web bridge, which is how ident 9 was built.

**CONCURRENCY: gate is 2** (`CLI_ASK_GROK_MAX`).

---

## 4. Qwen / `bl`  (flat-rate Model Studio **Token Plan**, Singapore)

Read live from `bl model list`. **10 models.** Invocation is `bl text chat`, NOT the DashScope API.

| model | context | capabilities | price /Mtok |
|---|---|---|---|
| **qwen3.8-max** | 1,000,000 | Reasoning, Vision, Text | 12 |
| **qwen3.8-flash** | 1,000,000 | Text, Vision, Reasoning | **0.8** |
| qwen3.8-opensource | 1,000,000 | Text, Reasoning, Vision | 12 |
| qwen3.7-plus / max / flash | 1,000,000 | Text, Reasoning, Vision | 12 (max) |
| qwen3.6-plus / flash | 1,000,000 | Reasoning, Vision, Text | |
| qwen3.6-max | 262,144 | Reasoning, Text | |
| **wan-video** | n/a | **Video generation** | 0.45 |

🔑 **TWO FINDINGS THAT CHANGE ROUTING.**
1. **`wan-video` is on the Token Plan.** Doctrine §7.2 states *"image and video GENERATION have no
   flat-rate lane"* and that such work must therefore ask Adrian, go procedural, or use the PC.
   **That is now false** — there is a subscription video lane. It needs its own verification pass
   before use, and changing §7.2 requires an AGENTS.md §8 doctrine change, so this is **reported,
   not actioned.**
2. **`qwen3.8-flash` is 1M context at 0.8/Mtok in the Token Plan catalogue**, but the plan is
   expressly interactive-only. It is useful for interactive classification, not an automated
   bulk backend. A 10,000-item batch must use the pay-as-you-go API (metered, §7.2 approval) or the
   local fleet; “already paid for” must never be used to justify wiring the Token Plan into batch.

**CONCURRENCY: gate is 2** (`CLI_ASK_QWEN_MAX`).

---

## 5. Local  (free, unmetered, our own hardware)

- **M2 Studio Ollama**: bge-m3, moondream, nomic-embed-text, qwen2.5:14b, qwen3.5:9b.
  ⚠️ **Deliberately STOPPED while M2 transcribes** — Ollama and mlx_whisper contend for Metal and
  SIGABRT. A DEAD `local` row is usually correct, not a fault.
- **PC RTX 5080 vision**: `qwen2.5-vl-7b`, OpenAI-compatible, needs `PC_VISION_API_KEY`.
  Fixed 2026-08-28; one image per request, concurrency 1 (the build crashes on concurrent decode).
- **PC ComfyUI**: Wan 2.2 i2v 14B, Wan 2.1 t2v, wan_alpha RGBA LoRA, SeedVR2, BiRefNet, SAM 3.1.
  81 frames with alpha in ~102s.

---

## 6. Metered, deny-by-default

`deepseek-v4-flash` (trial, $2.01 of $20 used) · `kimi-k3` (at its $20 cap, resets 1 Sept) ·
openai / gemini / anthropic / perplexity / xai APIs — all gated by `tools/metered-guard.py`.
⚠️ **DeepSeek's effective monthly ceiling is $40, not $20**: `ask-deepseek.py` and `ask-trial.py`
each enforce their own cap against their own ledger, blind to each other. Reported, not adjusted.

---

## 7. The rule this map exists to enforce

**Where the registry, the doctrine and the wiring disagree, the machine wins.** Resolve a model from
engine-native evidence, never from what was asked for: codex rollout JSONL,
`~/.grok/sessions/*/summary.json`, `~/.bailian/telemetry.jsonl`, agy's `Resolving model` line.
