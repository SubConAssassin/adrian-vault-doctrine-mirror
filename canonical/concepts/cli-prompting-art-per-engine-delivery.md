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
- **agy (Gemini 3.5 Flash High)** — `agy-ask.py`, prompt as argv (PTY). 1 M ctx. Biggest pool / default grind + $0 vision. Reads serials/images.

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

## Grok 4.5 context window — the live-verified fact (settles a recurring confusion)
**500 000 tokens.** Confirmed 2026-07-18 via WebSearch across xAI docs + OpenRouter + LLMReference + DataNorth + Kingy. This is a **regression from Grok 4.3's 1 M**. Released 2026-07-08. Pricing $2/$6 per M (tiered ×2 above 200 K prompt). Adrian's recollection of "4.5 went to 1 M" is incorrect — it was 4.3 that was 1 M. Sources filed in `working/_research/2026-07-18-cli-prompting-research/`.
