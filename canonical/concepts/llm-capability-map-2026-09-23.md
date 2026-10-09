---
title: LLM Capability Map — current evidence board
status: CURRENT
date: 2026-09-23
as_of: 2026-10-10
authority: companion-evidence-board
supersedes: canonical/concepts/llm-capability-map-2026-09-22.md
---

# LLM Capability Map — evidence refreshed 8 October 2026

This existing home remains the companion to the [routing and prompting protocol](token-enriched-delegation-prompting-protocol-2026-09-23.md). It is factual availability evidence, not default-promotion authority. Public release, catalogue, authentication, successful inference and task performance are distinct states. Historical figures never establish current quota.

## Live lane probe — 8 October 2026 (one real call per lane, ~00:45 WITA)

| Lane | Ran on | Result | Note |
|---|---|---|---|
| `codex-astra` (Photon ChatGPT login, default) | Mini | Answered | CLI 0.153.4; latest stable 0.161.0 (7 Oct) |
| `codex-astra` with `CLI_ASK_CODEX_ACCOUNT=osb` | Mini | Answered | OSB ChatGPT pool at 87% of its window per the quota accountant (vendor endpoint), 8 Oct ~01:10 WITA |
| `grok` / `grok-web` | Mini | Answered (`grok-4.7` per session log) | grok-web page reads were cancelled headless until `--allow web_fetch` was added 8 Oct |
| `muse` | Mini | Answered | Muse Code 1.4.3 |
| `local` (Ollama) | Mini | Answered | |
| `agy` (Gemini 3.8 Flash High) | M1 | Answered | Not installed on the Mini; Studio is off CLI work since 6 Oct; CLI notice line now stripped |
| DeepSeek via `tools/ask-trial.py` | M1 (API) | Answered | Pay-per-token trial, §7.2.a; bare `cli-ask.sh deepseek` refuses by design |
| `qwen` | — | Refused (DashScope 403 Unpurchased; Token Plan key 401) | Token Plan terms forbid automated use: keep off the team |
| `cloud` (M1 credit) | — | $21 of $250 on Adrian's claude.ai usage page, 8 Oct 00:33 WITA; $15 floor | Refused synchronous tasks now fall back to codex-astra, then grok |
| `cloud` (OSB credit) | Mini (dispatch) | Not yet usable | $215 on Adrian's screen 6 Oct; git channel blocked by a GitHub 500 on pushes to the workspace repo since ~00:53 WITA 8 Oct |

Research behind the prompting rules: [model prompting field guide, 8 Oct 2026](model-prompting-field-guide-2026-10-08.md).

## OpenAI dots — checked 9 October 2026 (not a lane)

OpenAI launched **dots** on 29 Sep 2026: an always-on GPT-6 Astra agent with its own cloud computer and browser, memory, scheduled tasks, 4,000+ app plugins, reachable in ChatGPT (desktop, web, mobile), Slack and Teams. Source: [Introducing dots](https://openai.com/index/introducing-dots/) and [Help Center 20001530](https://help.openai.com/en/articles/20001530-getting-started-with-your-dot), both read directly 9 Oct ~11:45 pm WITA.

- **Cost:** first dot included in Pro at no extra cost. Conversations with it do not count toward ChatGPT limits; Codex or ChatGPT Work tasks it starts do. Extended deeper-work limits for the first month after launch (to about 29 Oct).
- **Regions:** Pro excludes the EEA, Switzerland and the UK. The Photon ChatGPT account showed "Your dot" in its sidebar on 9 Oct, so it is enabled there. Whether a dot has been created on it: not checked.
- **Not a CLI lane:** no API and no Codex CLI access, so `cli-ask.sh` cannot drive it. It can create Codex cloud tasks and, if allowed, use a connected local computer.
- **Safety fit:** background "proactive research" uses read-only tools. Custom rules (act / act if pre-approved / ask / hand off) govern everything else. Writing into his personal apps stays banned (AGENTS.md section 7) unless he sets that up himself.
- **Account choice:** the OSB ChatGPT subscription ends about 12 Oct and is not renewing, so a dot belongs on Photon only.

## Gemini Spark — checked 10 October 2026 (not a lane)

Google's always-on personal agent in the Gemini app: tasks, reusable skills and schedules, using connected Google apps, a remote browser and computer, and sites you are signed into. Source: [Gemini Apps Help 17094507](https://support.google.com/gemini/answer/17094507), read directly 10 Oct ~12:40 am WITA.

- **Access:** Google AI Pro or Ultra, personal Google account only, 18+, Keep Activity on. Excluded in the EEA, Nigeria, Switzerland and the UK. Codex cites a Google Indonesia post announcing it for Pro and Ultra in late July (not read directly).
- **Surfaces:** Gemini web, mobile and Mac app only. No CLI or API, so agy cannot drive it.
- **Limits:** draws the Gemini app's compute-based usage limits, not agy's pool (see memory gemini-app-pool-separate). Up to 15 tasks at once. Google's page says schedules do not run while Spark is off or the device is off.
- **Local Chrome is US-only:** Spark can browse through your own desktop Chrome (with your logins) only via Chrome auto browse, which requires being in the US ([Help 16821166](https://support.google.com/gemini/answer/16821166), read 10 Oct). From Bali it uses Google's remote browser, which runs whether or not any device is on but has none of your logins. Set up 10 Oct on the Mini's Chrome (Pro account subconassassin144, Spark tab on); a test task confirmed it has no local-browser access.
- **Fit:** overlaps OpenAI dots. Its edge is Google-account context (Gmail, Drive, Sheets, Calendar, Photos). Never let it move or reorganise his files (AGENTS.md section 15).

## Evidence table — 4 October 2026

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
