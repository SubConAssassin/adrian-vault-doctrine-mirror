---
title: LLM Capability Map — current evidence board
status: CURRENT
date: 2026-09-23
as_of: 2026-10-04
authority: companion-evidence-board
supersedes: canonical/concepts/llm-capability-map-2026-09-22.md
---

# LLM Capability Map — evidence refreshed 4 October 2026

This existing home remains the companion to the [routing and prompting protocol](token-enriched-delegation-prompting-protocol-2026-09-23.md). It is factual availability evidence, not default-promotion authority. Public release, catalogue, authentication, successful inference and task performance are distinct states. Historical figures never establish current quota.

| Family / route | Vendor evidence | Local evidence observed 4 Oct WITA | Status |
|---|---|---|---|
| Claude Opus 5.5 / Sonnet 5.5 / Fable 5.1 | Current documented family; Sonnet 5.5 released 28 Sep | Studio Claude CLI auth confirms OSB Max; wrapper defaults to alias `sonnet`; exact served model/effort not probed | Candidates subject to existing ownership; Ashta override retained |
| GPT-6 Astra | Official current model | Commissioned Studio turn metadata says `gpt-6-astra` high; OSB local auth; catalogue lists Astra | Active-session availability evidenced; no backend response ID exposed |
| GPT-6 Sol / GPT-6.1 Sol / GPT-6 Luna | 6 Sol/Luna released 22 Sep; 6.1 Sol 29 Sep | Not in inspected Studio catalogue; `codex-sol` and `codex-luna` still map to 5.6 IDs | Documented candidates; local access unverified |
| GPT-5.6 Sol/Terra/Luna; 5.3 Codex Spark | Existing dispatcher pins | Studio catalogue lists 5.6 family; Spark pin not listed | Catalogue is not a fresh inference result |
| Grok 4.7 / 4.6 | Current documented models | Both Mini and Studio catalogues print unauthenticated despite exit 0; defaults differ | Auth gate unresolved |
| Gemini 3.8 Flash / agy | Official static multimodal text-output model | `agy models` lists pinned `gemini-3.8-flash-high`; quota/identity not established | Catalogue evidence only |
| Gemini 4 Argon | Google announcement 30 Sep; restricted initial rollout | No Gemini 4 in examined agy catalogue | Not an evidenced fleet route |
| Qwen 3.8 Max / 3.7 Plus | Token Plan model documentation | `bl` route pins these IDs; direct PATH-qualified auth probe reports configured Token Plan model key; identity/edition/allowance unknown | Account edition/access unverified; Personal interactive-only boundary retained |
| Meta Muse Spark 1.3 | Standard and contributor models documented separately | Mini binary exists; wrapper pins standard and prohibits contributor/API-key use | Fresh login/capacity unverified; review-only wrapper retained |
| DeepSeek legacy v4-flash | Official page says legacy alias now serves V4.1 Flash | Existing metered wrapper still requests legacy alias; no API call | Gated; old version/price comments stale |
| Local Qwen text/vision | Upstream model cards | Studio installed model list observed; PC vision not probed | Resource and task-quality gates unchanged |
| Cloud dispatcher | Existing Claude Code cloud adapter | Status reads stale 28 Sep zero-balance observation below stop floor | Not evidenced funded capacity; no dispatch |

**Account rule:** the same OSB login on Studio and Mini is one vendor pool. “28x” remains an unverified user expression, not a vendor tier or token balance. API price ratios and concurrent-call tests do not prove a weekly subscription budget.

**Interface findings:** CLI catalogue reports 272K context for the examined OpenAI models; public API limits are separate. Initial Claude wrapper telemetry reported requested effort without passing it to the CLI; the refresh includes a targeted tested repair, whose deployment state is in its receipt. The `composer` alias can substitute a Grok model; do not use it for exact-model/no-fallback commissions. Existing default pins remain unchanged; exact versioned opt-in aliases and effort forwarding are covered by the separate repair receipt.

Full evidence, configured-lane matrix, source dates and limitations: [4 October refresh](../../working/_m2-staging/2026-10-04-model-refresh-01a102d2/REPORT.md), [matrix](../../working/_m2-staging/2026-10-04-model-refresh-01a102d2/CLI-ACCOUNT-MODEL-MATRIX.md), [opened sources](../../working/_m2-staging/2026-10-04-model-refresh-01a102d2/SOURCES.md).

Primary references: [OpenAI changelog](https://developers.openai.com/api/docs/changelog), [Claude releases](https://platform.claude.com/docs/en/release-notes/overview), [Google Argon](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-4-argon/), [Grok 4.7](https://docs.x.ai/developers/models/grok-4.7), [Token Plan terms](https://www.alibabacloud.com/help/en/model-studio/token-plan-personal-overview), [Muse](https://dev.meta.ai/lp/muse-code), [DeepSeek pricing](https://api-docs.deepseek.com/quick_start/pricing).

Prior board content is preserved in the refresh package's `backups/`; earlier dates remain historical evidence. No model is newly marked approved-default.
