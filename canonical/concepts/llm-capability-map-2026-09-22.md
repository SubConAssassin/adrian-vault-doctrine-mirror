---
title: LLM Capability Map — verified refresh
type: doctrine-reference
tier: 1
status: CURRENT
date: 2026-09-22
supersedes:
  - canonical/concepts/llm-capability-map-2026-09-04.md
purpose: Current model facts, authenticated lane state, and routing eligibility
---

# LLM Capability Map — 22 September 2026

## Read this first

This is the current routing reference. A vendor launch is not a production-routing change. Every candidate moves through four distinct gates:

`vendor release → documented API capability → authenticated lane availability → task evaluation`

Only the fourth gate changes a default. The first three allow a bounded research or cross-audit use, subject to existing spending and safety rules. Advertised context is not delivered context: use the actual harness ceiling and file-read/chunking protocol.

## Evidence and limits

- **First-party verified today:** xAI Grok 4.7 launch/model documentation; Google Gemini model catalogue and 3.8 Live announcement; OpenAI Astra launch page; Anthropic newsroom/release notes.
- **Authenticated locally today:** Codex model catalogue, default configuration, and Codex CLI version. These prove availability/configuration for this user, not server-side model selection for an individual inference.
- **Not re-probed in this refresh:** Claude Max lane, agy model catalogue, Qwen entitlement/catalogue, local-model health, and Grok Build subscription entitlement. Preserve the last verified state for those lanes and require a fresh probe before using a model-specific claim operationally.
- **No paid API calls were made.** xAI, OpenAI, Google, Anthropic and Meta APIs remain subject to `AGENTS.md` §7.2.

## Current model and lane state

| Family / lane | Current verified fact | Routing rule |
|---|---|---|
| **Claude** | No newer general Claude model was found after Fable 5.1. Fable 5.1 remains an access/compatibility-sensitive ceiling model; Opus 5, Sonnet 5 and Haiku 4.5 keep their established roles. | Opus for orchestration/final review; Sonnet for bounded implementation; Haiku for low-stakes compression; Fable only after an Opus ceiling is demonstrated and its retention/tool-choice constraints fit. |
| **Codex** | Local authenticated catalogue (refreshed 15:51 WITA) contains `gpt-6-astra`, `gpt-5.6-sol`, `gpt-5.6-terra`, and `gpt-5.6-luna`. Actual local default is **Terra / low**; Codex CLI is **0.153.4**. | Never assume a bare Codex invocation is Sol/xhigh. Pin Sol/Terra/Luna/Astra explicitly whenever the task depends on model or effort. Astra is catalogue-available, but production eligibility requires a real-task evaluation. |
| **Google / agy** | `gemini-3.8-flash` remains the general multimodal/long-context model. Google added stable **Gemini 3.8 Live** and **Gemini 3.8 Live Extended Thinking** on 15 Sep. | Keep Flash as the text/multimodal candidate. Live is for interruption-tolerant voice interaction; it is not a replacement for a long static brief or a reason to change the agy pin without a live catalogue probe. |
| **xAI / Grok** | **Grok 4.7 released 21 Sep.** `grok-4.7` is documented with text/image input, 500K context, function calling, structured outputs, reasoning efforts low/medium/high/xhigh, and $2/$0.50-cached/$6 per-M token pricing below the higher-context threshold. Batch API is unsupported. | Replace 4.6 as the **candidate** Grok research/cross-audit model after an authenticated lane probe. Do not make it a default based on vendor benchmarks. Preserve different-family verification and the large-bundle file-read protocol. |
| **Meta** | No post-4-Sep first-party general-model delta that changes routing was found in this refresh. Muse Spark remains metered and its contributor tier permits training on prompts/completions. | No route for client/venture material without explicit approval and a data-governance decision. |
| **Qwen / DeepSeek / local** | Last detailed local/Qwen facts remain from the 4 Sep map; the 21 Sep digest separately flags Qwen CLI patch/security uncertainty. | Local is first choice for high-volume, low-stakes structured work. Keep Qwen and DeepSeek behind their existing entitlement/spend/security gates until re-probed. Do not use them to fill a model-fashion gap. |

## Prompt architecture that now governs every lane

1. **Deliver, then reason.** Use exactly one delivery idiom: small content inline, or a path/file-read instruction, or repository exploration. Never say “read this file” while also inlining it.
2. **Large corpus is a retrieval problem, not a model-window contest.** Chunk deterministically; provide IDs/paths; require coverage evidence. The Codex CLI’s practical window is not an API spec sheet, and Grok’s advertised 500K does not prove its Build harness read every byte.
3. **One instruction, not repeated control language.** Give role, source paths, scope, output schema, a single grounding rule, and acceptance checks. Do not multiply “verify” directives merely to make a task feel safer.
4. **Require abstention mechanically.** Research/schema tasks need `NOT_FOUND`/`unknown` plus an explicit unverified-fields list. Enumerate model IDs, filenames, URLs, SKUs, or columns that must be cited.
5. **Treat effort as a measured cost/quality dial.** Start at the lowest effort that has passed the task class; escalate one level only after a recorded failure. Pin model and effort in automated or reproducible calls.
6. **Separate source proof from model output.** Server-returned metadata is strongest; catalogue data proves a slug exists; client config proves only requested intent; a model naming itself is never evidence.
7. **Keep human/agent authorization visible.** State no-write/no-spend/no-publish boundaries in the task itself. Stronger long-horizon models raise, rather than remove, the value of clear stop conditions.

## Routing table

| Task shape | First route | Promotion / fallback condition |
|---|---|---|
| System architecture, final acceptance, consequential synthesis | Claude Opus 5 | Fable only after an Opus capability failure and compatibility check; use a different family for audit. |
| Bounded implementation or mechanical refactor | Codex Terra, explicitly pinned; Sonnet where the Claude lane owns the build | Use Sol/Astra only when task difficulty or a measured failure warrants it. |
| Hard ambiguous coding or arbitration | Codex Sol, explicitly pinned at chosen effort | Astra is a research candidate, not an assumed default. |
| Short, schema-bound classification | Codex Luna or local structured pass | Escalate only residue that fails schema/confidence checks. |
| High-volume, low-stakes extraction/tagging | Local with fixed JSON schema and temperature 0 | Cloud only for an evidenced capability gap. |
| Current facts requiring sources | Live-web research plus a different-family verification | Grok 4.7 may be used after an access probe; never promote a single-model report directly. |
| Multimodal static analysis | Gemini 3.8 Flash after live pin/catalogue confirmation | Use Live variants only for a genuine realtime voice/visual dialogue job. |
| Large source bundle | File-read or deterministic chunks, then coverage check | No reroute merely because another model advertises a larger window. |
| Sensitive/regulated or client material | A lane whose retention, tool behavior, and contractual terms are verified | Do not use Meta contributor tier or any unapproved metered API. |

## Grok 4.7 evaluation gate

Before changing a Grok route, one owner must capture:

1. The authenticated account surface and server/catalogue model ID.
2. A fixed structured-output fixture: schema validity, abstentions, tool/result validation, wall time and usage/cost evidence.
3. The existing large-bundle file-read fixture: expected file count, bytes/markers read, coverage list, omissions, and final output.
4. A same-fixture comparison against the current Claude and explicitly pinned Codex routes.

Promotion requires a material, repeatable advantage on a named task class. If this cannot be shown, keep Grok as a research/cross-audit lane.

## Superseded claims

- Grok 4.7 is no longer a watch item or an X-only claim.
- The 4 Sep map’s claimed Codex default (Sol/xhigh) is not current local configuration; observed default is Terra/low.
- The 4 Sep map’s CLI-version freshness claims are historical observations, not current version facts.
- The legacy `model-routing-engine.md` points to a July map and must not be used for prices, model names, or availability.

## Sources

- [xAI: Introducing Grok 4.7](https://x.ai/news/grok-4-7)
- [xAI: Grok 4.7 model documentation](https://docs.x.ai/developers/models/grok-4.7)
- [Google: Gemini API model catalogue](https://ai.google.dev/gemini-api/docs/models)
- [Google: Gemini 3.8 Live and Extended Thinking](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-8-live-gemini-3-8-live-extended-thinking/)
- [OpenAI: GPT-6 Astra](https://openai.com/index/gpt-6-astra/)
- [Anthropic newsroom](https://www.anthropic.com/news)
- `canonical/concepts/model-intel/2026-09-21-digest.md` for the preceding weekly source-bound findings.
