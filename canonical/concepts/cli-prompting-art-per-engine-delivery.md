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
- **codex (GPT-5.6 sol/terra/luna)** — `codex exec -m …`, prompt as argv. ~1.05 M ctx / 128 K out. Handled the 116 KB bundle inline in one shot this session (strongest single audit). Smallest pool → sparing on sol.
- **agy (Gemini 3.5 Flash High)** — `agy-ask.py`, prompt as argv (PTY). 1 M ctx. ⚠️ **Small pool since the 2026-07-29 Ultra→base downgrade** (was "biggest pool / default grind" — see the 2026-08-04 note at the end of this file); still the $0 vision lane. Reads serials/images.

## The fix baked into `tools/cli-ask.sh` (2026-07-18)
The non-web grok branch is now **size-gated** (`CLI_ASK_GROK_INLINE_MAX`, default 40 000 bytes):
- **≤ threshold →** inline single-turn (`--max-turns 1`) — unchanged, proven, no agentic drift.
- **> threshold →** payload written to a `grokdata` file; grok told to **Read it in full** with `--permission-mode bypassPermissions --max-turns 12`. This is the Test-C idiom, automated. No caller change needed — big grok prompts now just work.
- Regression guard: `cli-ask-selftest.sh` **P5** (200 KB → file-read path delivers full) + **P5b** (5 KB → inline path) — both green, 14/14.

## Prompting best practices (all engines — the reliability levers)
1. **Match the idiom to the delivery.** Do NOT tell an engine "read file X" while also dumping X inline — the conflict confuses agentic CLIs (this was half the original grok failure). Either inline-with-"content-below" framing, OR file-read-with-a-path — never both.
2. **Prescriptive structure** (from [[delegation-first-operating-doctrine]] §6): ROLE / CONTEXT (exact paths) / DO / DON'T / OUTPUT (exact format) / GROUNDING ("[NOT FOUND] not invention") / VERIFY (print count + first lines).
3. **Output-mode preamble** for agentic CLIs: "write your COMPLETE answer as plain text to stdout; no plan mode; no subagents; no file writes" — stops the agent from going off to write a file and emitting 0 bytes.
4. **Route by payload size:** >400 K tokens → agy/codex (1 M-class), never grok (500 K). Big single bundles → codex/agy inline, or grok via the file-read path.
5. **Reserve grok for what it's best at:** bounded verification, cross-audit, `grok-web` live research — not 100 KB solo reads. It excelled at the 22 KB cross-audit (23 confirmations + 12 gaps) the same session it failed the 116 KB solo.
6. **Verify-before-trust every large return:** confirm the engine actually ingested the whole payload (ask it to echo a count/marker) before believing a "clean" audit — a truncated-input audit looks identical to a complete one.

## 2026-07-25 UPDATE — the prompting law inverted, and the current engine strings

Companion: **[[llm-capability-map-2026-07-25]]** (full specs/benchmarks/pricing) + delegation-doctrine **§14**.

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
