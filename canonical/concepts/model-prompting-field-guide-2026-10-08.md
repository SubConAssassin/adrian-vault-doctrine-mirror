---
title: Model prompting field guide, 8 Oct 2026 (per-model profiles, glitches and fixes)
type: concept-reference
status: CURRENT detail annex to token-enriched-delegation-prompting-protocol-2026-09-23 (that file stays the operational SSOT; this is read on demand)
as_of: 2026-10-08
grounding_mode: web_assisted, cross-family audited
supersedes: nothing; extends the protocol's "Per-model profiles"
firewall_class: public-safe (mirrored)
---

# Model prompting field guide — 8 October 2026

**What this is.** Adrian-direct 8 Oct 2026: research the prompt engineering for every model the team uses, from vendor docs and the forums (Reddit, GitHub issues, HN), and update the rulebook and skills. Method: seven topics; each researched by two vendor families with live web (GPT-6 Astra via Codex and Grok 4.7 via grok-web; Gemini 3.8 added a third leg on its own topic); each audited by a third family (Gemini via agy for OpenAI, xAI, DeepSeek/Qwen/local and cross-cutting; Muse Spark for Google and Meta; DeepSeek V4 Flash for Anthropic); each drafted into profiles by GPT-6 Astra; spot-verified by Claude Opus 5.5. Raw research, audits and drafts: `working/_research/2026-10-08-prompt-engineering-refresh/`.

**Status of the claims.** Vendor and community reports here are discovery signals, not routing evidence (protocol, "Evaluation protocol"). Nothing in this file changes a live route pin. "(unverified)" means single-source or not checked by the auditor.

## Orchestrator corrections (Claude, verified 2026-10-08 ~01:25 WITA) — these override the profiles below

1. **Codex CLI 0.161.0 is a STABLE release** (`rust-v0.161.0`, prerelease=false, published 2026-10-07 15:58 UTC, GitHub releases API). The OpenAI profile below calls it alpha; that was true only of `0.161.0-alpha.*`. Latest stable = 0.161.0.
2. **Qwen Token Plan (Individual) forbids our use.** Its terms of use, read directly: use "is limited to interactive use within programming and agent tools", it "must not be used for automation scripts, custom application backends, or any non-interactive batch call scenarios", and out-of-scope calls "may result in subscription suspension or API Key banning". Qwen therefore stays OFF the automated team on the Token Plan. Adrian can still use it interactively.
3. **grok-web headless research was silently broken until 2026-10-08.** Grok's page-reading tool `web_fetch` asks permission; headless runs auto-cancel it (`permission_cancelled` in `~/.grok/sessions/*/events.jsonl`) and the turn ends after one narration line (~300 bytes). Fixed in `tools/cli-ask.sh` with `--allow web_fetch` (only that tool). Search (`web_search`) is server-side and always worked.
4. **Codex web search defaults to CACHED results.** `tools/cli-ask.sh` now passes `-c web_search="live"`; on CLI 0.153.4 and again on 0.161.0 a test returned the previous release (0.160.1) while GitHub already marked 0.161.0 Latest about 10 hours earlier, so Codex's live search index lags fresh events by hours: for anything published in the last day, check the primary source directly. Codex-sourced research before this date used cached search. Codex CLI 0.161.0 (staged on the Mini 8 Oct) is required for GPT-6.1 Sol under ChatGPT sign-in; verified answering.
5. **Effort on the final pass (Adrian, 8 Oct, after this research):** the low/medium-first advice below is for drafts and iterations only. The final pass of critical or complex work always runs at `xhigh` on the strongest available model (live ruling `final-pass-xhigh-critical`).
6. **Coverage gap:** the Meta topic's Grok research leg failed (356 bytes) after the fix, so Meta rests on one research leg (Astra) plus the Muse audit.

---

# Topic R1

_Brief: OpenAI Codex CLI (0.153.x, `codex exec` headless) with GPT-6 Astra (default, reasoning effort xhigh), GPT-6 So..._

#### Codex CLI / `codex exec` (as of 2026-10-08)

**Use for:** Headless execution with saved ChatGPT Pro authentication. Audited stable version: **0.160.1**; 0.161.0 is alpha. Upgrade and validate routes requiring newer models; do not assume 0.153.x supports them. [1]

**Prompt shape:** Send the task card through stdin with `-`; include authorized scope, acceptance criteria, output fields, and relevant file pointers. Inspect global and repository-to-cwd `AGENTS.md`/`AGENTS.override.md` instructions; the combined project-instruction default is 32 KiB. [2][3]

**Settings / token rule:** Pin model and effort. Use `--json` for events, `--output-schema` for the response contract, and `-o` for the final artifact. API-advertised 1,050,000-token context does **not** establish usable headless capacity; current account-specific CLI capacity is **[NOT FOUND]**. Do not encode 272K as an Astra ceiling. [2][4]

**Known glitches -> fixes:**

- Thin stdout → ordinary stdout contains only the final response; progress uses stderr → capture both, or collect JSONL events plus `-o` → documented behavior. [2]
- Empty stdout with exit 0 → detached-TTY bug reported on older builds → test PTY allocation only for a reproduced matching failure → historical single-report workaround; 0.153.x applicability unestablished. [5]
- Exit 0 despite failed work → nested commands can fail independently → validate final artifact, schema, content, and relevant tool outcomes → documented issue; detection, not generation repair. [6]
- Schema-shaped intermediate text → historical schema application behavior → consume the final `-o` artifact after completion, not the first JSON-looking message → documented mechanism plus historical issue. [2][7]
- Stale research → search defaults to cached mode → set `web_search="live"` and verify search events → documented configuration; citations still require checking. [4]
- Quota wall → allowance exhausted → record returned reset information and suspend scheduling; ordinary model switching does not replenish allowance → supported usage guidance; no universal monthly reset established. [8][9]

**Sources:**

1. https://github.com/openai/codex/releases — stable release 2026-10-05.
2. https://raw.githubusercontent.com/openai/codex/main/docs/exec.md — retrieved 2026-10-08.
3. https://developers.openai.com/codex/guides/agents-md — search date 2026-07-08.
4. https://developers.openai.com/codex/config-reference — snapshots 2026-04-02 / 2026-07-08.
5. https://github.com/openai/codex/issues/19945 — 2026-04-28.
6. https://github.com/openai/codex/issues/15536 — 2026-03-23.
7. https://github.com/openai/codex/issues/19816 — 2026-04-27.
8. https://help.openai.com/en/articles/20001516-managing-usage-with-gpt-6-astra-in-work-and-codex — retrieved 2026-10-08; publication date [NOT FOUND].
9. https://www.thinkfacility.com/errors/codex-youve-hit-your-usage-limit/ — 2026-09-23; secondary reading of 0.156.1 source.

#### GPT-6 Astra / Codex CLI (as of 2026-10-08)

**Use for:** Difficult autonomous implementation and synthesis requiring substantial reasoning. [10][11]

**Prompt shape:** “Complete the authorized task through `<acceptance>`. Resolve routine ambiguity with a stated assumption. Continue independent work when blocked. Return results, evidence, and remaining blockers.” Keep skills conditional and remove compulsory whole-repository reading. [11][12]

**Settings / token rule:** Pin `gpt-6-astra`. API efforts: `low`, `medium`, `high`, `xhigh`, `max`; no `none`. Validate client availability. Trial Low/Medium where Sol High previously sufficed; retain xhigh only when evaluation justifies it. Universal xhigh default: **[NOT FOUND]**. Standard 5–10-minute latency: **(unverified)**. [10][11][13]

**Known glitches -> fixes:**

- Premature stops or unnecessary permission requests → strict obedience to approval rules and broad skill triggers → authorize routine work, define completion, audit loaded instructions, and request the exact blocking rule → vendor-backed mitigation, not a permissions bypass. [11][12]
- Excessive latency → unnecessary effort and mandatory reading/testing → reduce effort against acceptance fixtures and remove irrelevant procedural requirements → vendor guidance; no timing guarantee. [12][13]

**Sources:**

10. https://developers.openai.com/api/docs/models/gpt-6-astra.md — retrieved 2026-10-08.
11. https://developers.openai.com/api/docs/guides/latest-model — retrieved 2026-10-08.
12. https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra — 2026-09-11.
13. https://openai.com/index/practical-guide-building-gpt-6/ — 2026-10-02.

#### GPT-6 Sol / Codex CLI (as of 2026-10-08)

**Use for:** Complex implementation and delegated analysis with a settled objective. [13][14]

**Prompt shape:** Bounded outcome, relevant evidence, constraints, and structured deliverable; apply the GPT-6 outcome-and-boundaries guidance. [11]

**Settings / token rule:** Pin `gpt-6-sol`; API efforts `none` through `max`, default `medium`. Evaluate Medium for judgment and High for difficult debugging; raise further only after acceptance failure. API defaults do not guarantee CLI defaults. [13][14]

**Known glitches -> fixes:**

- ChatGPT-login HTTP 400 on CLI below 0.155.0 → client-version gate → upgrade the actual CLI and retest the authenticated route → corroborated provider release notes; upgrade alone does not prove account access. [15]

**Sources:**

14. https://developers.openai.com/api/docs/models/gpt-6-sol.md — retrieved 2026-10-08.
15. https://github.com/ben-vargas/ai-sdk-provider-codex-cli/releases — v2.2.0 dated 2026-09-09; later gate-note date [NOT FOUND].

#### GPT-6.1 Sol / Codex CLI (as of 2026-10-08)

**Use for:** Complex coding and professional work after authenticated route validation. [16]

**Prompt shape:** Bounded implementation card with explicit acceptance and evidence requirements; use the GPT-6 outcome-and-boundaries guidance. [11]

**Settings / token rule:** Pin `gpt-6.1-sol`; API efforts `low` through `max`, default `medium`; no `none`. Validate installed-client support before promotion. [17]

**Known glitches -> fixes:**

- ChatGPT-login HTTP 400 on 0.156.1 → version-dependent model gate → upgrade and run a route acceptance check → confirmed historical report; exact minimum supported version **[NOT FOUND]**. Do not adopt reported client-identity spoofing. [18]

**Sources:**

16. https://openai.com/index/introducing-gpt-6-1-sol/ — 2026-09-29.
17. https://developers.openai.com/api/docs/models/gpt-6.1-sol.md — retrieved 2026-10-08.
18. https://github.com/openai/codex/issues/49396 — 2026-09-29.

#### GPT-5.6 Sol / Codex CLI (as of 2026-10-08)

**Use for:** Established complex professional-work routes. [19]

**Prompt shape:** Retain the established compact card, relevant evidence, and explicit verification requirements. September-specific format changes: **[NOT FOUND]**. [11]

**Settings / token rule:** Pin `gpt-5.6-sol`; API efforts `none` through `max`, default `medium`. Compare the established effort with one level lower against the same acceptance criteria. [13][19]

**Known glitches -> fixes:**

- Model-specific headless defect and remedy → **[NOT FOUND]** → apply the shared CLI acceptance gates → no model-specific reliability claim.

**Sources:**

19. https://developers.openai.com/api/docs/models/gpt-5.6-sol.md — retrieved 2026-10-08.

#### GPT-5.6 Terra / Codex CLI (as of 2026-10-08)

**Use for:** Routine code changes, document analysis, and reporting. [20]

**Prompt shape:** Bounded assignment with explicit deliverables; no demonstrated Terra-specific XML advantage. [13][20]

**Settings / token rule:** Pin `gpt-5.6-terra`; API efforts `none` through `max`, default `medium`. Trial lower effort for routine work. [13][20]

**Known glitches -> fixes:**

- Empty final after successful tool activity → empty model completion reported in ChatGPT-backed Pi → resume the specific session with a continuation instruction and a bounded retry budget → single-report workaround, not a native `codex exec` reproduction; retry bound is an operational recommendation. [21]

**Sources:**

20. https://developers.openai.com/api/docs/models/gpt-5.6-terra.md — retrieved 2026-10-08.
21. https://github.com/openai/codex/issues/32389 — 2026-07-11.

#### GPT-5.6 Luna / Codex CLI (as of 2026-10-08)

**Use for:** Focused extraction, classification, short edits, and structured summaries; account-dependent Luna Reserve fallback. [13][22][23]

**Prompt shape:** Narrow goal with required output fields and a schema contract. [2][13]

**Settings / token rule:** Pin `gpt-5.6-luna`; API efforts `none` through `max`, default `medium`. Trial Low for routine extraction. Reserve is separately limited and selectively available. [22][23]

**Known glitches -> fixes:**

- Reserve advertised but headless execution fails → reported interactive acceptance handshake has no working headless equivalent → mark Reserve unavailable to scheduling until a real headless probe succeeds → confirmed historical issue, not proof every current account fails. Force-enable flag: **[NOT FOUND]**. [24]

**Sources:**

22. https://developers.openai.com/api/docs/models/gpt-5.6-luna.md — retrieved 2026-10-08.
23. https://help.openai.com/en/articles/20001499-luna-reserve-in-codex-and-chatgpt-work — retrieved 2026-10-08; publication date [NOT FOUND].
24. https://github.com/openai/codex/issues/45132 — 2026-09-12.

#### GPT-6 Luna / Codex CLI (as of 2026-10-08)

**Use for:** Efficient repeated extraction, classification, and structured preparation. [13][25]

**Prompt shape:** Bounded task and required fields; use `--output-schema` for machine-consumed results. [2][13]

**Settings / token rule:** Pin `gpt-6-luna`; API efforts `none` through `max`, default `medium`. Trial Low for routine extraction. No established fixed Pro quota multiplier; this model is **not** the documented Luna Reserve route. [23][25]

**Known glitches -> fixes:**

- Model-specific headless defect and remedy → **[NOT FOUND]** → apply shared CLI validation and account-access checks → no model-specific reliability claim.

**Sources:**

25. https://developers.openai.com/api/docs/models/gpt-6-luna.md — retrieved 2026-10-08.

### Changes versus our current rulebook

- **ADD** Shared CLI artifact/event validation; process exit 0 is insufficient. [2][6]
- **CHANGE** Astra effort policy: test Low/Medium instead of treating xhigh as mandatory. [11][13]
- **CHANGE** GPT-6 Sol prompting: use applicable GPT-6 persistence guidance when the assignment requires autonomy. [11]
- **CHANGE** GPT-6.1 Sol promotion requires upgraded-client and authenticated-route validation; retain the existing alias until validated. [18]
- **ADD** Separate GPT-5.6 Sol, Terra, and Luna profiles, including Terra empty-completion and Reserve limitations. [19]–[24]
- **REMOVE** Mandatory Luna example counts and categorical long-input exclusions as sourced vendor rules; supporting evidence **[NOT FOUND]**.
- **ADD** API context and pricing thresholds do not establish Pro CLI capacity or quota multipliers. [8][10]

### Operational fixes for our scripts

- Use a fresh run directory: `codex exec -m gpt-6-astra -c 'model_reasoning_effort="medium"' -c 'approval_policy="never"' -c 'web_search="live"' --sandbox read-only --json --output-schema schema.json -o final.json - < task.md > events.jsonl 2> stderr.log`. [2][4]
- For authorized repository edits, select `--sandbox workspace-write`; prompt authority cannot override sandbox restrictions. [2]
- Require a fresh, nonempty final artifact, valid schema, acceptance checks, and completion events; classify failures separately from successful completion. [2][6]
- Inspect `web_search` events; require returned source URLs, dates, and unavailable-source disclosure. [2][4]
- Record quota errors and reset details; use version-specific clock/date parsing only as a fallback, not a universal reset schedule. [9]
- App-server `account/rateLimits/read` polling is described in the inputs, but an audit-valid protocol URL is **[NOT FOUND]**; verify the protocol before implementation.
- Configure `model_auto_compact_token_limit` only against validated runtime behavior; do not hard-code 272K as an Astra ceiling. [4]
- Audit loaded instruction files whenever cwd changes; changing `CODEX_HOME` alone does not remove repository instructions. [3]

---

# Topic R2

_Brief: xAI Grok 4.7 via the Grok Build CLI (1.0.46, headless) on a SuperGrok Plus consumer subscription (not the API)..._

#### Grok 4.7 / Grok Build CLI 1.0.46, SuperGrok Plus headless (as of 2026-10-08)

**Use for:** live web/X research with external citation verification, knowledge-work synthesis, and evaluated coding or adversarial-review tasks. Treat it as a challenger whose findings require acceptance checks.

Benchmark evidence favors GPT-6 Astra and Claude for some coding and factual-knowledge tasks: Grok scores approximately 31–32 on AA-Omniscience versus Astra’s 44 and Opus 5.5’s 46. Coding results vary by harness. Gemini comparisons do not establish a universal research winner; subscription-CLI head-to-head tests and adversarial-review win rates are [NOT FOUND]. These results do not justify replacing the existing conductor or coding routes. [14–17]

**Prompt shape:** use a compact task card specifying source scope, requested web/X retrieval, contradictory evidence, and the deliverable. Require claim → exact URL → supporting passage records, with separate `confidence` and `unverified` fields. Put durable grounding/output rules in `--rules`, which appends to the system prompt; reserve `--system-prompt-override` for deliberate harness replacement. Leave `--disable-web-search` unset for live research. A standalone flag forcing X search is [NOT FOUND]. [2–4]

Use native `--prompt-file` for large task payloads. For referenced corpora, require coverage markers and end-of-file evidence before synthesis. File delivery can still trigger offloading and further reads; it does not establish full ingestion. [3,8–10]

**Settings / token rule:** discover the subscription model with `grok models`, then pin it with `-m`; the documented API identifier is `grok-4.7`. Supported model efforts are `low`, `medium`, `high` (default), and `xhigh`. Retain `high` as the current production baseline; evaluate explicit `--effort medium` on representative fixtures before changing it. Escalate to `xhigh` only after recorded acceptance failure. The published 500,000-token context is a model specification, not a guaranteed subscription-session allocation. [1,18]

Prefer standard serving when latency permits: Fast is plan-billed at documented token-rate multipliers of 2× standard or 1.5× for long context. Conversion into weekly-pool percentage is [NOT FOUND]. Bound agent turns with `--max-turns`, allowing for reading and execution separately. [1,3]

The subscription has a shared, compute-weighted weekly pool across Chat, Imagine, Voice, and Build; no fixed public token allowance exists. Record Settings → Usage percentage and account-specific reset time before/after representative runs. At exhaustion, paid features pause; exact running-job termination behavior is [NOT FOUND]. Missing cost or zero accounting buckets must not be interpreted as free execution. [3,5]

**Known glitches -> fixes:**

- Fabricated citations → offline recall can invent identifiers; one study reported 6/129 invented DOIs **(unverified)** → resolve identifiers, check bibliographic metadata, and have a different-family verifier inspect source support → useful validation procedure; no established prompt-only cure or live-search error rate. [6]
- Real URLs supporting the wrong claim → API citation lists can include encountered sources not used in the answer; identical CLI semantics are unestablished → verify claim-level entailment against retrieved passages → stronger than link-existence checks; comparative success rate [NOT FOUND]. [7]
- Stale or opaque usage readings → shared compute weighting and incomplete/stale local accounting → use Settings → Usage as reference; optionally inspect the latest billing entry in `~/.grok/logs/unified.jsonl` → unofficial log utility may lag until another billing fetch; it is not a contractual quota API. [5,12]
- HTTP 426 → gateways documented a minimum version of 1.0.13 on 2026-09-30 → check/update the native CLI and smoke-test before batches; update any bridge generating stale client headers separately → historical floor confirmed; future floor is not guaranteed. [2,13]
- Large prompt incompletely read → prompt offloading, bounded `read_file` responses, and insufficient turns → pass `--prompt-file`, preserve read access, follow continuation offsets, and verify coverage → source on mutable `main` shows 25,000-token/1,000-line read limits and 40,000-byte tool-output cap; these are distinct limits, not a universal 40 KB prompt threshold. Historical end-of-file tests do not establish 1.0.46 reliability. [8–10]
- JSON looks valid but work is unfinished → intermediate output and format-specific envelopes can be mistaken for final findings → use `--json-schema`, a required `working`/`final` discriminator, an accepted completion stop reason, and external validation → shape enforcement does not establish factual correctness or completion; handle `error_max_structured_output_retries` explicitly. [3,10]
- Parser misses structured results → Messages-compatible documentation uses `structured_output`, while older ordinary-output tests observed `structuredOutput` → fixture-test the selected output format and parse its actual envelope → historical casing observations are not a universal 1.0.46 contract. [3,10]
- Quality flags rejected → `--best-of-n` and self-check `--check` were removed in CLI 1.0 → remove them; use host-controlled candidates and external acceptance when justified → audit confirms rejection; `grok update --check` remains a separate update command. [2,11]
- Headless goal invocation unavailable → `/goal` is a TUI slash command; native headless `--goal` is [NOT FOUND] → implement host timeout, persistence, and acceptance checks → no supported headless goal invocation, budget-unit contract, or reliability study established. [3,19]

**Sources:** numbered URLs below are copied from the inputs. Retrieval date for all: 2026-10-08; publication dates are listed where supplied.

1. https://docs.x.ai/developers/release-notes — Grok 4.7 entry 2026-09-21.
2. https://docs.x.ai/build/cli/reference — updated 2026-07-21.
3. https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-pager/docs/user-guide/14-headless-mode.md — mutable `main`; publication [NOT FOUND].
4. https://x.ai/build/changelog — 1.0.46 dated 2026-09-30.
5. https://docs.x.ai/grok/faq — updated 2026-08-27.
6. https://truestandard.ai/releases/grok-4-7 — experiment 2026-09-22; publication [NOT FOUND].
7. https://docs.x.ai/developers/tools/citations.md — publication [NOT FOUND].
8. https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-tools/src/implementations/grok_build/read_file/mod.rs — mutable `main`; publication [NOT FOUND].
9. https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-shell/src/session/acp_session_impl/prompt_offload.rs — mutable `main`; publication [NOT FOUND].
10. https://github.com/Nuruvala/grok-build-to-claude/blob/main/CLAUDE.md — tests 2026-08-16–17; publication [NOT FOUND].
11. https://github.com/pedroknigge/grok-build-skill/blob/main/CHANGELOG.md — 2026-08-09; update 2026-08-30.
12. https://github.com/13scoobie/grok-build-usage/blob/main/README.md — publication [NOT FOUND].
13. https://github.com/router-for-me/CLIProxyAPI/issues/6249 — 2026-09-30.
14. https://artificialanalysis.ai/articles/benchmarking-grok-4-7 — 2026-09-21.
15. https://evals.report/benchmarks/aa-omniscience — 2026-09-22.
16. https://artificialanalysis.ai/models/comparisons/grok-4-7-vs-gemini-3-8-flash — publication [NOT FOUND].
17. https://forum.cursor.com/t/grok-4-7-is-now-live/172526 — 2026-09-21.
18. https://github.com/dorukardahan/headless-relay/blob/main/references/cli-reference.md — publication [NOT FOUND].
19. https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-pager/docs/user-guide/04-slash-commands.md — mutable `main`; publication [NOT FOUND].
20. https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-tools/src/lib.rs — mutable `main`; publication [NOT FOUND].
21. https://x.ai/docs/build/cli/headless-scripting — 2026-06-10.

### Changes versus our current rulebook

- **ADD:** distinguish subscription authentication, weekly-pool accounting, and session context from API specifications. [1,3,5]
- **CHANGE:** retain `high` pending evaluation; make `medium` a measured candidate rather than an asserted optimum. [1]
- **CHANGE:** expand file/byte/marker coverage into verified continuation and end-of-file coverage after offloading. [8–10]
- **CHANGE:** replace generic structured-output/function-calling guidance with the headless `--json-schema` contract and format-specific parsing. [3,10]
- **ADD:** require claim-level source entailment checks; citation presence and link resolution are insufficient. [6,7]
- **ADD:** document version-floor preflight, obsolete quality flags, and unavailable headless goal invocation. [2,11,13,19]
- **REMOVE:** “Batch is not supported” from this consumer-CLI profile; applicable supporting evidence in the inputs is [NOT FOUND].
- **CHANGE:** qualify coding/research routing by evaluator, harness, effort, and missing subscription-workflow comparisons. [14–17]

### Operational fixes for our scripts

- Authenticate the subscription through `grok login --device-auth` when needed; do not silently switch to `XAI_API_KEY`, the metered API path. [3]
- Run `grok update --check`, perform `grok update` when required, record `grok version`, and smoke-test before batches. [2]
- Probe installed help before using `--no-auto-update`; its supplied scripting reference predates CLI 1.0. [21]
- Discover with `grok models`; persist the selected `-m`, `--effort`, version, elapsed time, output size, and acceptance result. [1,18]
- Pass large payload paths through `--prompt-file`; do not expand their contents into argv. [3,10]
- Use `--json-schema` with `--output-format json`; validate envelope, schema, final discriminator, stop reason, and acceptance separately. [3,10]
- For `streaming-json`, retain tool evidence and stderr separately; never feed raw progress events directly into the final-result consumer. [3,10]
- Configure `--max-turns` plus a host timeout; reserve turns for reads and return structured incomplete outcomes when coverage fails. [3,10]
- Delete `--best-of-n`, self-check `--check`, and assumed `--goal` invocations. [11,19]
- Record usage snapshots with timestamps; treat absent accounting as unknown and pause for reset at exhaustion. [3,5,12]
- Do not hard-code the audit’s one-stream ceiling or broken OAuth-refresh behavior: supporting source URLs in the inputs are [NOT FOUND].

---

# Topic R3

_Brief: Google Gemini 3.8 Flash (thinking level high) via the Antigravity CLI `agy` (1.2-1.3.x) on a Google AI Pro con..._

#### Gemini 3.8 Flash (as of 2026-10-08)

**Use for:** Multimodal analysis and bounded research tasks with independently validated evidence. API ID: `gemini-3.8-flash`; documented `agy` selections include `gemini-3.8-flash-high` and `gemini-3.8-flash-medium`. Confirm availability with `agy models`. [1][2]

**Prompt shape:** Keep the existing XML task card, but treat XML as a convention, not a performance requirement; Markdown headings are also supported. Order: behavioral constraints and output contract → referenced context or supplied data → specific task/questions. Use consistent delimiters. For large supplied data, put execution directions after it. Do not request a visible plan for ordinary tasks. No validated Gemini-3.8-specific prompt length or few-shot count was found. [3]

For research cards, add: “Cite only exact URLs returned by tools. Never construct URLs. If supporting evidence is unavailable, return `[NOT FOUND]`.” This is an operational adaptation of the grounding documentation; external verification remains required. [6]

**Settings / token rule:** Pin the requested high-thinking route explicitly. Supported API thinking levels are `low`, `medium`, `high`; `minimal` is rejected and the model default is `medium`. Model limits are 1,048,576 input tokens and 65,536 output tokens—not Pro subscription allowances. [1][2]

Medium as a quota-saving substitute for routine work is **(unverified)**; evaluate it on accepted-output rate and measured usage before changing this high-thinking route. [7]

API per-part `media_resolution` allocations are approximately low 280, medium 560, high 1,120 and ultra-high 2,240 image tokens; resolutions can be mixed within a request. Use lower resolution for simple visual context and higher resolution for fine detail where the interface supports it. An `agy` per-part resolution flag or documented image-count ceiling: **[NOT FOUND]**. Do not prescribe 10–20-image batches as a quota-safe CLI rule. [4][2]

**Known glitches -> fixes:**

- Poor adherence with large context → instruction placement can matter → place constraints first and questions after the data; enforce machine-consumed output through the CLI schema facility → vendor-backed guidance, not an accuracy guarantee. [3][2]
- Expected vision savings unavailable in Pro CLI → API resolution controls are not documented as `agy` controls → establish supported image ingestion and measure usage before selecting batch sizes → API token table confirmed; CLI exposure **[NOT FOUND]**. [4][2]

**Sources:**

1. https://ai.google.dev/gemini-api/docs/models/gemini-3.8-flash — updated 2026-09-02.
2. https://antigravity.google/docs/cli/headless/ — date **[NOT FOUND]**; accessed 2026-10-08.
3. https://ai.google.dev/gemini-api/docs/prompting-strategies — updated 2026-09-17.
4. https://ai.google.dev/gemini-api/docs/media-resolution — updated 2026-09-23.
5. https://ai.google.dev/gemini-api/docs/image-understanding — updated 2026-09-23.
6. https://ai.google.dev/gemini-api/docs/google-search — updated 2026-09-23.
7. https://www.reddit.com/r/GeminiAI/comments/1w7bldp/you_should_probably_set_gemini_38_flash_thinking/ — exact date **[NOT FOUND]**; accessed 2026-10-08.

#### Antigravity CLI `agy` / Google Search grounding on Google AI Pro (as of 2026-10-08)

**Use for:** Authenticated headless Gemini execution and source-backed research, with the orchestrator validating completion and evidence. Search output is a candidate answer until its citations pass verification. Complete API-equivalent grounding metadata in CLI stdout is **[NOT FOUND]**. [1][7]

**Prompt shape:** Send the compact Gemini task card through headless `-p`; use `--json-schema` with a valid root `"type": "object"`. Validate the delivered object externally. Include exact-source requirements and `[NOT FOUND]` for unavailable evidence. Preconfigure narrowly scoped tool permissions: an unavailable approval can soft-deny a tool while the process still exits `0`. [1][2][7]

**Settings / token rule:** Record the installed version and available model slug. Reported latest `1.3.1`, dated October 7, is **(unverified)** because the research snapshots disagree; do not infer installed behavior from it. [2][3]

Set `--print-timeout` explicitly and add an external process watchdog: the headless guide says five minutes, while 1.2.6 release notes say unlimited. Capture stdout and stderr separately. Agent/model failures gained `AGY_ERROR` diagnostics and exit `3` in 1.2.6; partial-response failures changed from exit `0` to `3` in 1.2.10. Neither establishes that every blank response now fails correctly. [1][2]

Pro allowance refreshes every five hours **until the weekly limit is reached**; consumption depends on work performed. Gemini and Claude/GPT have separate pools. Numerical Pro allowances, rollover rules, weekly reset anchor and universally safe request rate: **[NOT FOUND]**. Schedule from reported quota/reset information; pacing cannot replenish exhausted weekly allowance. [4][5]

**Known glitches -> fixes:**

- Blank output with successful status → JSON-heavy macOS subscriber failure reported in #840 **(unverified)** → reject empty terminal results; reduce/chunk the payload and retest; stdin did not fix that reproduction → blank detection is deterministic; workaround and current-version fix are unverified. [6]
- `429 Individual quota reached` with repeated retries → older consumer-quota retry-loop report **(unverified)** → classify the error, stop account dispatch and honor the reported reset → allowance model confirmed; a fix covering every Pro case is **[NOT FOUND]**. [4][8]
- Timeout followed by successful retry → fresh-process recovery reported by one wrapper author **(unverified)** → explicit CLI timeout plus outer watchdog; permit a bounded fresh-process retry for read-only work, excluding explicit quota exhaustion → anecdotal recovery, no measured success rate. [1][9]
- Successful answer despite missing required tool work → headless permission soft-denial → inspect stderr/tool outcomes and require evidence that mandatory tools completed → documented behavior; exit code alone is insufficient. [1]
- Missing or invented search citations → reported `enterpriseWebSearch`/`googleSearch` mismatch and missing grounding metadata **(unverified)** → accept only source URLs present in tool evidence, fetch their pages and verify supporting passages/dates → validation procedure confirmed; HTTP `200` alone does not establish support. No CLI flag forcing `googleSearch`: **[NOT FOUND]**. [7][10]
- `search_web` returns “no summary returned from GenerateContent” → leading thought-part handling was reportedly fixed in 1.2.4 **(unverified)** → check installed release behavior and fail the research result when evidence is absent → changelog-backed report, not proof that later grounding failures are resolved. [2]
- Authentication fails on an SSH-only Mac → missing cached authorization or inaccessible macOS Keychain → run initial `agy` interactively over SSH, open its printed URL locally, paste the returned code into SSH; unlock/authorize the destination Keychain if needed → vendor-documented workflow, not a guaranteed cure for every stall. [11][12]

**Sources:**

1. https://antigravity.google/docs/cli/headless/ — date **[NOT FOUND]**; accessed 2026-10-08.
2. https://github.com/google-antigravity/antigravity-cli/blob/main/CHANGELOG.md — retrieved 2026-10-08; cited September–October releases.
3. https://github.com/google-antigravity/antigravity-cli/releases/latest — reported 1.3.1, 2026-10-07.
4. https://antigravity.google/docs/plans/ — retrieved 2026-10-08; publication date **[NOT FOUND]**.
5. https://antigravity.google/docs/models.md — retrieved 2026-10-08; publication date **[NOT FOUND]**.
6. https://github.com/google-antigravity/antigravity-cli/issues/840 — 2026-08-20.
7. https://ai.google.dev/gemini-api/docs/google-search — updated 2026-09-23.
8. https://github.com/google-antigravity/antigravity-cli/issues/1018 — 2026-09-14.
9. https://github.com/andyleimc-source/agy-mcp — date **[NOT FOUND]**; accessed 2026-10-08.
10. https://github.com/google-antigravity/antigravity-cli/issues/1086 — 2026-09-23.
11. https://antigravity.google/docs/cli/install — retrieved 2026-10-08; publication date **[NOT FOUND]**.
12. https://antigravity.google/docs/cli/troubleshooting/ — retrieved 2026-10-08; publication date **[NOT FOUND]**.

### Changes versus our current rulebook

- **CHANGE:** Split the combined Flash/Live entry; this update covers Flash through `agy`, and provides no new Live rules.
- **CHANGE:** Retain XML task cards as the house convention; remove any implication that XML outperforms Markdown. [Flash 3]
- **ADD:** Require object-root `--json-schema`, external schema validation, nonempty completion and required-tool evidence. [CLI 1–2]
- **ADD:** Model limits, API image tokens and Pro subscription allowances are separate controls. [Flash 1,4; CLI 4]
- **ADD:** Stop dispatch on exhausted individual quota; resume from actual reset information. [CLI 4,8]
- **ADD:** Validate exact cited passages and dates, extending the existing external-evidence rule. [CLI 7]
- **REMOVE:** No further deletion from the supplied excerpt is justified; exclude the research’s refuted pacing rates, automation-freeze explanation and guaranteed fixes.

### Operational fixes for our scripts

- Select an available `gemini-3.8-flash-high` slug after `agy models`; record the installed version with each evaluation. [Flash 2]
- Pass an object-root `--json-schema`; reject blank, malformed, error-bearing or incomplete results regardless of exit status. [CLI 1–2,6]
- Keep stdout/stderr separate; parse `AGY_ERROR`, preserve diagnostics and reject required-tool soft-denials. [CLI 1–2]
- Set `--print-timeout` explicitly; independently terminate overdue processes with the runner’s wall-clock watchdog. [CLI 1–2]
- Centralize account quota/reset state; suppress retries for `Individual quota reached`; do not hard-code “12–15 seconds” or “20 calls/hour.” [CLI 4,8]
- Make fresh-process timeout retry bounded and read-only; recovery evidence remains **(unverified)**. [CLI 9]
- Extract citation URLs, match them to returned evidence, fetch page bodies and check claim support/date before acceptance. [CLI 7,10]
- Install from `https://antigravity.google/cli/install.sh`; bootstrap authorization once through the documented SSH URL/code flow. [CLI 11]
- If Keychain access fails, unlock the destination login Keychain and authorize `agy`; a supported cross-Mac token-copy recipe or named device-code flag is **[NOT FOUND]**. [CLI 11–12]
- Add no `agy media_resolution` flag or fixed image batch ceiling: documented CLI support is **[NOT FOUND]**. [Flash 2,4–5]

---

# Topic R4

_Brief: Meta Muse Spark (1.3) via the Muse Code CLI (`muse exec`, 1.4.x) on the $5/month Everyday plan, used headless ..._

#### Meta Muse Spark 1.3 (as of 2026-10-08)

**Use for:** Bounded second opinions and cross-family audits, as a provisional routing choice based on practitioner anecdotes **(unverified)** [3][4]. Both `muse-spark-1.3` and `muse-spark-1.3-contributor` have 1,048,576-token context; dependable exhaustive reading at that capacity: **[NOT FOUND]** [1]. Keep targeted file selection and external acceptance checks.

Matched evidence establishing superiority over GPT-6 or replacement of current Claude routes: **[NOT FOUND]**. The supplied vendor comparisons concern GPT-5.6 Sol and Opus 5. General superiority over Gemini or Grok: **[NOT FOUND]**; the cited single-task community comparison cannot establish a fleet ranking [5].

**Prompt shape:** Retain the existing compact task card. Spark-specific benefit from explicit goal/scope/stop/output is anecdotal **(unverified)** [3][4]. Suggested rulebook adaptation:

```text
ROLE: Independent read-only reviewer.
SCOPE: <named files and claim IDs>
TASK: Check each claim; identify counterexamples and missing evidence.
AUTHORITY: Read only; no edits, shell execution, or delegation.
STOP: After checking listed claims; report inaccessible evidence as a blocker.
OUTPUT: Per claim: verdict; file:line evidence; counterexample; unresolved gap.
GROUNDING: Separate observed facts from inference.
```

This is an operational template, not a benchmarked optimum. Spark-specific evidence favouring XML, JSON, a prompt length, or few-shot prompting: **[NOT FOUND]**. The task card’s authority statement must be backed by CLI controls.

**Settings / token rule:** Pin the exact model ID. Supported reasoning tiers: `minimal`, `low`, `medium`, `high`, `xhigh`; `max` is Standard-only; `none` is unsupported [1]. Proposed starting policy: `low` for extraction and `medium` for bounded audits, subject to the existing acceptance-based escalation rule. The claimed vendor recommendation of `low` for simple lookups is **(unverified)** [2].

Higher effort increases reasoning tokens and latency [2]; reasoning tokens are billed as output in the API [6]. Neither API billing nor Contributor’s cheaper API prices establishes its subscription allowance multiplier.

Use Standard for sensitive, confidential, or personal material: Standard is not used for training; Contributor permits training on prompts/completions and prohibits those inputs [1][7]. Personal-account coverage under organization-level zero-data-retention rules is **(unverified)**; do not promise ZDR [8].

**Known glitches -> fixes:**

- Missed instructions or shortcuts in long conversations -> practitioner-reported context-load/default-prompt association, without controlled diagnosis -> separate bounded reviews and require evidence for each claim -> **anecdotal (unverified)** [3][4].
- Invalid or inconsistent effort selection -> reported documentation drift, while model tiers reject `none` -> constrain configuration to the model-supported tiers above; validate discovery before use -> **supported tier list; drift diagnosis (unverified)** [1][2].
- Contributor selected to stretch Everyday allowance -> API discounts mistaken for subscription discounts -> retain Standard unless Contributor data use is acceptable and matched meter measurements justify switching -> **subscription savings [NOT FOUND]**.

**Sources:**

1. https://dev.meta.ai/docs/models — undated; research accessed 2026-10-08.
2. https://dev.meta.ai/docs/reasoning — undated; research accessed 2026-10-08.
3. https://www.reddit.com/r/opencode/comments/1wflp5r/any_muse_user_here_that_uses_it_as_a_subagent/ — 2026-09-13.
4. https://www.reddit.com/r/opencode/comments/1wk2dex/which_model_for_general_opencode_use/ — relevant comments 2026-09-18.
5. https://dev.meta.ai/models/muse-spark — undated; research accessed 2026-10-08.
6. https://docs.litellm.ai/blog/muse_spark_1_3 — date **[NOT FOUND]** in supplied audit.
7. https://dev.meta.ai/help/policies-and-privacy/contributor-tier — undated; research accessed 2026-10-08.
8. https://dev.meta.ai/help/policies-and-privacy/zero-data-retention — undated; research accessed 2026-10-08.

#### Muse Code CLI 1.4.x / Everyday (as of 2026-10-08)

**Use for:** Signed-in, headless, bounded read-only reviews. Everyday’s reported $5/month and 10–50 prompts per five-hour window are **(unverified)**; exact weekly token budget and allowance-weighting formula: **[NOT FOUND]** [9]. “Latest 1.4.2 / build `1.4.2-R4684.1`” is **(unverified)**; record the installed version rather than assuming that release [10][16].

**Prompt shape:** Pass the current task through `--prompt-file`; retain durable constraints in `AGENTS.md`. Flag behaviour and workspace-trust-gated instruction loading are **(unverified)** [11]. Until validated locally, do not assume repository instructions loaded successfully. Require per-claim evidence and explicit blocked/failed outcomes.

**Settings / token rule:** Enforce read-only execution with **both** `--disable-write --disable-shell`; approval mode `never` alone does not enforce read-only [12]. Separate control of mutating MCP tools is a reported adapter caveat **(unverified)** [13].

Proposed pacing: bound each review, avoid unnecessary context, and increase effort only after acceptance failure. `--max-model-steps`, no-prompt protocol `usage/read`, `usage/changed`, and model-specific tiers through `model/list` are **(unverified)** pending local validation [10][14]. Monitor both five-hour and weekly windows if these interfaces work.

One subscriber reported approximately 78.8M weekly tokens, including 73.4M cached input, followed by over 100M on Standard **(unverified)** [15]. This supports neither a fixed quota nor a Contributor advantage. What consumes allowance fastest, including relative weights for cached input, reasoning, tools, and subagents: **[NOT FOUND]**. Measure matched-job meter deltas; do not convert API prices into subscription forecasts.

**Known glitches -> fixes:**

- “Read-only” job writes files -> approval posture permits writes -> combine `--disable-write --disable-shell` -> **audit-confirmed controls; MCP coverage is not established** [12][13].
- Headless job waits for trust/approval -> interactive decision cannot be answered -> for already-authorized workspaces, validate `--trust-workspace` and `--disable-approval`; retain read-only controls -> **documented in research, audit-unverified** [11][14].
- Session-log suppression mistaken for privacy protection -> local logging conflated with provider data use -> validate `--no-session-log`, capture required stdout/stderr separately, retain the Standard/Contributor policy -> **local flag semantics (unverified)** [11].
- Worker appears signed out -> reported macOS Keychain access failure may mimic absent credentials -> check credentials in the worker account and recover with `muse login` -> **unofficial recovery (unverified); expiry lifetime and guaranteed unattended refresh [NOT FOUND]** [19].
- `EMFILE`, including child-process failures -> reported descriptor accumulation on macOS 1.4.2 -> restart the session; raising the descriptor limit only delays reported failure -> **issue report (unverified); permanent fix [NOT FOUND]** [16].
- `model stream idle timeout after 180000ms` -> root cause **[NOT FOUND]** -> return failed execution; no validated workaround -> **issue report (unverified)** [17].
- `function_call_arguments.done name mismatch` aborts run -> reported stream-protocol failure -> reject the incomplete audit -> **issue report (unverified); confirmed repair/retry remedy [NOT FOUND]** [18].
- JSON parsing fails or exit `0` is accepted as audit success -> reported confusion between JSONL events, final-answer constraints, and completion -> validate final output externally; reported `--json` emits JSONL and `--output-schema` constrains the final answer -> **CLI semantics (unverified); external acceptance already required by rulebook** [10][14].

**Sources:**

9. https://dev.meta.ai/help/subscriptions/what-is-a-muse-code-subscription?project_id=1661600634933790&team_id=2096920474558192 — undated; research accessed 2026-10-08.
10. https://dev.meta.ai/docs/muse-code/changelog — undated release entries; research accessed 2026-10-08.
11. https://dev.meta.ai/docs/muse-code/configuration — undated; research accessed 2026-10-08.
12. https://github.com/timwuhaotian/the-pair/blob/HEAD/docs/plans/2026-09-19-muse-cli-support.md — path dated 2026-09-19; revision date **[NOT FOUND]**.
13. https://github.com/BrokkAi/muse-acp — undated README; research accessed 2026-10-08.
14. https://dev.meta.ai/docs/muse-code/extending — undated; research accessed 2026-10-08.
15. https://www.reddit.com/r/opencode/comments/1w7o67y/muse_spark_13_contributor_muse_code_headless/ — comments 2026-09-06 onward; edits undated.
16. https://github.com/meta-models/muse-code-sdk/issues/77 — 2026-10-02.
17. https://github.com/meta-models/muse-code-sdk/issues/58 — 2026-09-27.
18. https://github.com/meta-models/muse-code-sdk/issues/89 — 2026-10-05.
19. https://github.com/RandyNorthrup/muse-spark-code — undated README; research accessed 2026-10-08.

### Changes versus our current rulebook

- **ADD:** Spark as a provisional bounded second-opinion route; promotion requires evaluated acceptance, not family rankings.
- **ADD:** Exact Spark IDs, supported reasoning tiers, Standard-only `max`, and rejection of `none`.
- **ADD:** Standard/Contributor training distinction; no assumed Contributor subscription advantage.
- **ADD:** Muse read-only enforcement requires both write and shell restrictions.
- **ADD:** Track five-hour and weekly allowance separately once meter interfaces are validated **(unverified)**.
- **CHANGE:** Apply context-by-reference to Spark’s 1M capacity; require evidence coverage before claiming exhaustive review.
- **REMOVE:** Nothing in the supplied excerpt; retain its external-validation, escalation, and interruption rules.

### Operational fixes for our scripts

- Add `--disable-write --disable-shell` to every read-only `muse exec` invocation [12].
- Disable mutating MCP access separately until extension coverage is verified **(unverified)** [13].
- Reject `none`, reject Contributor `max`, and record exact model ID and effort [1].
- Validate installed support before enabling `--prompt-file`, `--max-model-steps`, `--no-session-log`, or approval/trust flags **(unverified)** [11][14].
- Integrate `usage/read` and `usage/changed` only after capability validation; record before/after window values **(unverified)** [10].
- Validate JSONL event parsing and final-schema handling against a fixture; never use exit `0` as acceptance **(unverified CLI semantics)** [10][14].
- Convert reported timeout, protocol-mismatch, and `EMFILE` signatures into structured failures; never return partial text as a passed audit **(unverified signatures)** [16–18].
- Route authentication failures to worker-account credential recovery with `muse login`; do not silently substitute API-key billing **(unverified recovery)** [9][19].

---

# Topic R5

_Brief: (a) DeepSeek's current API models (pay-per-token, small monthly budget): IDs, thinking vs non-thinking modes, ..._

#### DeepSeek Flash / Pro API (as of 2026-10-08)

**Use for:** `deepseek-flash` (V4.1-Flash) as the budget candidate for mechanical checks and bounded, evidence-contained review; `deepseek-v4-pro` (V4-Pro-0813) as an evaluated escalation. Cross-family auditor reliability is **(unverified)**: require reproducible findings and local calibration before relying on either model for acceptance.

**Prompt shape:** Stable role, review rubric, and output instructions in `system`; evidence and changing task in `user`. For JSON, explicitly include “json” and one representative output object. Use the same compact task card across modes; a current mode-specific XML or prompt-length advantage is [NOT FOUND].

**Settings / token rule:** Both IDs advertise 1M context and 384K maximum output; these are ceilings, not task budgets. Thinking defaults to `high`; supported efforts are `low`, `high`, `max`. Recommended starting policy: disable thinking for mechanical tasks with Python SDK `extra_body={"thinking":{"type":"disabled"}}`; evaluate `low` for bounded reasoning. Thinking ignores `temperature`, `presence_penalty`, and `frequency_penalty`.

Use `response_format: {"type":"json_object"}`, cap `max_tokens`, and validate against the business schema externally; `json_schema` enforcement is unsupported. USD/million tokens, **off-peak / peak**:

| Model | Cached input | Uncached input | Output |
|---|---:|---:|---:|
| Flash | $0.003 / $0.006 | $0.15 / $0.30 | $0.60 / $1.20 |
| Pro | $0.022 / $0.044 | $0.66 / $1.32 | $1.98 / $3.96 |

Peak: Monday–Friday 01:00–04:00 and 06:00–10:00 UTC, excluding Chinese public holidays. Everything else is off-peak. Keep reusable prefixes first; caching is best-effort and a shared prefix may become reusable only on a third request.

**Known glitches -> fixes:**

- Empty JSON, even with `finish_reason: stop` -> documented empty-content behavior -> reject empty/invalid/schema-failing answers, revise the prompt, and use bounded retries -> vendor mitigation; no guaranteed success rate.
- Truncated JSON -> insufficient output allowance -> detect `finish_reason: length` and retry within the spending limit with adequate allowance -> documented cause; schema validation remains necessary.
- HTTP 400 during tool continuation -> adapter stripped prior `reasoning_content` -> preserve and replay it for tool conversations -> vendor-documented protocol requirement.
- Unexpected cache misses -> matching middle spans or unpersisted prefix units -> preserve the initial prefix and inspect cache-hit/miss usage -> documented behavior; no guaranteed hit.

**Sources:**

1. https://api-docs.deepseek.com/updates/ — release 2026-09-10; amendment date [NOT FOUND].
2. https://api-docs.deepseek.com/quick_start/pricing — 2026-09-24.
3. https://api-docs.deepseek.com/guides/thinking_mode — 2026-09-24.
4. https://api-docs.deepseek.com/guides/json_mode — publication [NOT FOUND]; retrieved 2026-10-08.
5. https://api-docs.deepseek.com/api/create-chat-completion — 2026-09-24.
6. https://api-docs.deepseek.com/guides/kv_cache — 2026-09-24.
7. https://github.com/deepseek-ai/DeepSeek-V3/issues/1673 — 2026-09-24.

#### Qwen 3.8 / Qwen Code CLI (as of 2026-10-08)

**Use for:** `qwen3.8-max` and `qwen3.8-flash` coding/review through an eligible account route. **Individual Token Plan excludes automated orchestrators and non-interactive batch scripts.** Headless CLI support does not override this restriction. An applicable Team-plan exception is [NOT FOUND]; keep this orchestrator route disabled until eligibility is established.

**Prompt shape:** Supply the task through stdin or `qwen -p`. Use `--append-system-prompt` for standing review constraints. `--system-prompt` replaces the main prompt, but `QWEN.md` still appends unless `--safe-mode` is used. Safe mode also suppresses memory, hooks, skills, and MCP; use it only when those dependencies are unnecessary.

**Settings / token rule:** Pin Qwen Code v0.25.0, released October 5. Pair a Token Plan `sk-sp-` key with its subscription’s regional endpoint:

- Singapore: `https://token-plan.ap-southeast-1.maas.aliyuncs.com/compatible-mode/v1`
- Beijing: `https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode/v1`

Use `BAILIAN_TOKEN_PLAN_API_KEY`; provider configuration supplies `envKey` and `baseUrl`. Put API extras in the selected provider’s `generationConfig.extra_body`; provider entries do not inherit missing generation fields from top-level settings.

Qwen3.8 defaults to thinking at `xhigh`; supported efforts are `low`, `medium`, `xhigh`. General API supports `enable_thinking:false`, but disabled thinking needs route-specific verification on Token Plan. Do not combine `thinking_budget` and `reasoning_effort`. `max_completion_tokens` bounds reasoning plus answer; `max_tokens` bounds only the answer.

Set `--max-session-turns` and `--max-wall-time`; defaults are unlimited. For eligible usage, the reported promotion discounts Max/Flash credit consumption 60% during 22:00–08:00 UTC+8. Fixed tokens-to-credits conversion: [NOT FOUND].

**Known glitches -> fixes:**

- Authentication failure or unintended billing route -> mismatched plan key/base URL -> bind credentials, region, and provider together; prevent automatic endpoint fallback -> vendor-documented configuration requirement.
- Disabled thinking rejected -> historical Token Plan restriction in CLI side queries -> test the exact endpoint/version; retain an accepted setting if rejected -> current persistence **(unverified)**; July report.
- Parser mistakes session metadata for an answer -> `--output-format json` emits a message array -> check exit status and terminal result, then parse and validate its answer payload separately -> documented envelope; no business-schema guarantee.
- Unexpected repository instructions -> `QWEN.md` survives main-prompt replacement -> use `--safe-mode` when an isolated run is intended -> documented behavior.

**Sources:**

1. https://docs.qwencloud.com/token-plan/personal/token-plan-personal-overview — publication [NOT FOUND]; retrieved 2026-10-08.
2. https://www.alibabacloud.com/help/en/model-studio/base-url — updated 2026-09-28.
3. https://qwenlm.github.io/qwen-code-docs/en/users/configuration/auth/ — 2026-09-18.
4. https://qwenlm.github.io/qwen-code-docs/en/users/features/headless/ — updated 2026-10-01.
5. https://github.com/QwenLM/qwen-code/releases — v0.25.0, 2026-10-05.
6. https://docs.qwencloud.com/developer-guides/text-generation/thinking — publication [NOT FOUND]; retrieved 2026-10-08.
7. https://docs.qwencloud.com/api-reference/chat/openai-chat — publication [NOT FOUND]; retrieved 2026-10-08.
8. https://docs.qwencloud.com/developer-guides/clients-and-developer-tools/qwen-code — publication [NOT FOUND]; retrieved 2026-10-08.
9. https://qwenlm.github.io/qwen-code-docs/en/users/configuration/settings/ — publication [NOT FOUND]; retrieved 2026-10-08.
10. https://github.com/QwenLM/qwen-code/issues/7359 — 2026-07-20.

#### qwen3.5:9b / Ollama 0.34.x (as of 2026-10-08)

**Use for:** Local extraction and classification with externally validated structured output. Production success rate on this exact model/runtime combination: [NOT FOUND].

**Prompt shape:** Focused extraction/classification instruction, necessary source content, and the output schema. Include the schema in the prompt and pass the actual JSON Schema object in `format`; avoid agentic file-read instructions.

**Settings / token rule:** Use `/api/chat`, `stream:false`, `options.temperature:0`, and an explicit, consistent `options.num_ctx`. Test top-level `think:false`; do not put `think` inside `options`. Inspect `ollama show qwen3.5:9b` for thinking capabilities and `ollama ps` for allocated context. Within 0.34.x, prefer evaluating v0.34.4’s single-pass structured-output change.

**Known glitches -> fixes:**

- Empty answer after spending output allowance -> historical misplaced thinking control -> move `think:false` to the request’s top level and test adequate output allowance -> placement documented; current failure frequency [NOT FOUND].
- Schema-invalid answer -> model/backend-specific structured-output behavior -> supply schema through `format` and prompt, validate externally, and regression-test v0.34.4 -> documented mechanism; exact 9B reliability **(unverified)**.
- Reload delays -> alternating `num_ctx` changes runner requirements -> standardize context across clients -> historical maintainer diagnosis; no 0.34.x Mac benchmark supplied.

**Sources:**

1. https://ollama.com/library/qwen3.5:9b — publication [NOT FOUND]; retrieved 2026-10-08.
2. https://docs.ollama.com/capabilities/structured-outputs — 2026-10-07.
3. https://github.com/ollama/ollama/issues/14793 — 2026-03-12.
4. https://github.com/ollama/ollama/releases/tag/v0.34.4 — 2026-09-23.
5. https://github.com/ollama/ollama/issues/7773 — 2024-11-21.
6. https://github.com/ollama/ollama/releases/tag/v0.34.3 — 2026-09-19.
7. https://docs.ollama.com/context-length — 2026-10-07.

#### bge-m3 / Ollama 0.34.x (as of 2026-10-08)

**Use for:** Local embeddings of pre-sized text, JSON, and code chunks.

**Prompt shape:** Plain input strings or arrays of strings; no system/user conversation wrapper.

**Settings / token rule:** Use `/api/embed` with `input`; consume plural `embeddings`. Pin `options.num_ctx:8192` consistently and verify runtime allocation with `ollama ps`. BGE-M3’s maximum is 8,192 tokens regardless of generation-model capacity. Size chunks with the matching tokenizer, allowing for tokenizer-added tokens; test with `truncate:false`. Inspect `prompt_eval_count` and `load_duration`.

**Known glitches -> fixes:**

- Context overflow despite character trimming -> dense content exceeds loaded/token context -> tokenize, split oversized records, and submit pre-sized chunks -> supported diagnosis; exact-corpus reliability requires testing.
- Overflow despite `truncate:true` -> reported truncation edge cases -> pre-chunk; do not rely on server truncation as protection -> historical failures documented; universal fix not established.
- Migration/parser failure -> deprecated `/api/embeddings` uses `prompt` and singular `embedding`, with no documented `truncate` -> migrate request and response handling together -> documented interface difference.
- Reload thrash -> inconsistent `num_ctx` -> use one context setting across processes; configure `keep_alive` for idle gaps -> `keep_alive` alone cannot resolve context mismatch.
- Unexpected effective context -> contradictory default-context documentation -> explicitly configure and inspect runtime state -> no universal default established.

**Sources:**

1. https://ollama.com/library/bge-m3 — publication [NOT FOUND]; retrieved 2026-10-08.
2. https://docs.ollama.com/api/embed — publication [NOT FOUND]; retrieved 2026-10-08.
3. https://docs.ollama.com/api — publication [NOT FOUND]; retrieved 2026-10-08.
4. https://github.com/ollama/ollama/issues/14186 — 2026-02-10.
5. https://docs.ollama.com/context-length — 2026-10-07.
6. https://docs.ollama.com/faq — 2026-10-07.
7. https://docs.ollama.com/modelfile — 2026-10-07.
8. https://github.com/ollama/ollama/issues/7773 — 2024-11-21.

### Changes versus our current rulebook

- ADD — DeepSeek budget profile and evaluation gate for cross-family auditing.
- ADD — Qwen regional credential binding and Individual Token Plan automation exclusion.
- CHANGE — “Explicit control plane”: distinguish model controls, CLI limits, and subscription eligibility.
- CHANGE — “Stable prefix”: DeepSeek cache reuse is best-effort; measure actual hits.
- CHANGE — Local/small profile: separate generation schemas from embedding chunk/context requirements.
- REMOVE — No explicit excerpt rule requires removal; retain external validation and structured failure outcomes.

### Operational fixes for our scripts

- DeepSeek: persist tool-turn `reasoning_content`; enforce JSON/schema checks, bounded retries, token caps, and the documented pricing schedule.
- Qwen: disable Individual Token Plan orchestration; eligible headless routes must set model, turn/time limits, and parse the terminal JSON result.
- Ollama generation: send schema in `format`, top-level `think:false`, `stream:false`, and temperature `0`; regression-test the exact runtime.
- Ollama embeddings: migrate to `/api/embed`, pin `num_ctx:8192`, tokenize/chunk before calls, and detect overflow with `truncate:false`.
- Ollama scheduling: standardize per-model context settings across clients and log `load_duration` to detect reloads.

---

# Topic R6

_Brief: Anthropic Claude Opus 5.5, Sonnet 5.5, Haiku 4.5 and Fable 5.1 as used in Claude Code (2.1.28x CLI and desktop..._

Audit scope: “confirmed” means agreement between the supplied reports, **not independent URL verification**. Below, undated sources have publication date **[NOT FOUND]**, accessed 2026-10-08. Prices are input/output dollars per million tokens, not per-session tariffs.

#### Claude Opus 5.5 / Claude Code (as of 2026-10-08)

**Use for:** Difficult migrations, repository audits, architecture, and sustained implementation; escalate effort against explicit acceptance failures. [1][2]

**Prompt shape:** Compact task card naming deliverable, required checks, completion condition, and permitted blockers. Put unattended-work persistence rules in the initial standing instructions. Request brief decisions, not internal reasoning. [2]

**Settings / token rule:** Pin `claude-opus-5-5`; start `medium`. Evaluate `low` for mechanical work; use `high` after a failed acceptance check. Reserve `xhigh` for demanding long-running work and `max` for measured gains. Thinking is always enabled. Context/output: 1M/128K; prices $4/$20, cache reads $0.20. [1][2]

**Known glitches -> fixes:**

- Unfinished work appears complete -> text-only `end_turn` may be a progress report -> independently check acceptance; cap automatic continuations at two or three -> vendor guidance reported in one input **(unverified)**. [2]
- Excess reasoning at inherited settings -> effort calibration differs from Opus 5 -> retain medium as the evaluation baseline, not a guaranteed equivalent to Opus-5-high -> exact equivalence **(unverified)**. [2]

**Sources:**

1. https://www.anthropic.com/claude-opus-5-5 — 2026-09-22.
2. https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5 — undated.

#### Claude Sonnet 5.5 / Claude Code (as of 2026-10-08)

**Use for:** Well-specified everyday coding and bounded agentic implementation; use higher effort for harder or longer work. [3][4]

**Prompt shape:** Name the required test/build/type-check and say: “When the requested work is done and its checks pass, stop and report. Do not launch reviewer subagents unless requested.” Bound the final report separately from reasoning effort. [4]

**Settings / token rule:** Pin `claude-sonnet-5-5`; start `medium` for specified agentic coding, then `high` when needed. API default is `high`; Claude Code’s default is unresolved in the supplied evidence **(unverified)**, so set it explicitly. Context/output: 1M/128K; prices $2/$10, cache reads $0.20. [3][4]

**Known glitches -> fixes:**

- Completion without testing -> `low` can omit verification -> require the named check and its result -> documented mitigation, not guaranteed compliance. [4]
- Extra reviews, files, or reviewer agents -> `xhigh`/`max` thoroughness -> bound scope and stop after required checks -> vendor test reported roughly one-third lower cost at `max`; not a general savings estimate. [4]
- Parseable but incomplete JSON -> thinking can exhaust output allowance -> reject `stop_reason: "max_tokens"` if exposed; evaluate `high` for reasoning-heavy JSON -> single-report guidance **(unverified)**; this is not a CLI flag. [4]

**Sources:**

3. https://www.anthropic.com/claude-sonnet-5-5 — 2026-09-28.
4. https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5-5 — undated.

#### Claude Haiku 4.5 / Claude Code (as of 2026-10-08)

**Use for:** Bounded extraction, reconnaissance, classification, and compact evidence summaries with externally checkable results. This is an operating application of the documented cheaper-subagent route. [5][6]

**Prompt shape:** Specify the bounded search/extraction target and returned evidence. A Haiku-specific optimal prompt length or XML-versus-JSON advantage: **[NOT FOUND]**. [5][6]

**Settings / token rule:** Pin `claude-haiku-4-5-20251001`; alias `claude-haiku-4-5`. Omit effort: Haiku does not support that parameter. Context: 200K; prices $1/$5. [5]

**Known glitches -> fixes:**

- Invalid effort configuration -> shared Opus/Sonnet template supplies unsupported controls -> omit effort for Haiku -> documented model limitation. [5]
- Short prefix fails to cache -> reported 4096-token minimum -> inspect cache usage; do not assume a short card caches -> **(unverified)** because the audit marks this detail inconsistently across rows. [7]

**Sources:**

5. https://platform.claude.com/docs/en/models/haiku-4-5/overview — undated.
6. https://code.claude.com/docs/en/sub-agents — 2026-10-07 page stamp.
7. https://platform.claude.com/docs/en/build-with-claude/prompt-caching — undated.

#### Claude Fable 5.1 / Claude Code (as of 2026-10-08)

**Use for:** Demanding reasoning and long-horizon work after higher-effort Opus fails the task’s evaluation. Universal evidence that its premium pays off: **[NOT FOUND]**. [8][9]

**Prompt shape:** Explicitly request whole-task completion, targeted edits, required searches, and independent tool-call batching. Specify unwanted prose patterns and a short final explanation; bound test additions. These prompting details are single-report guidance **(unverified)**. [10]

**Settings / token rule:** Pin `claude-fable-5-1`; default `high`, with `xhigh`/`max` requiring measured benefit. Thinking is always enabled. Context: 1M; prices $10/$50. Compare accepted-task cost including retries and verification before promotion. [8][9]

**Known glitches -> fixes:**

- Preserved reasoning becomes unusable -> earlier history changed -> keep history append-only -> reported vendor guidance; precise Fable behavior **(unverified)**. [10]
- Unnecessary premium spend -> expensive route selected without demonstrated advantage -> require evaluated Opus failure first -> supported routing policy; no universal savings guarantee. [8][9]

**Sources:**

8. https://platform.claude.com/docs/en/models/overview — undated.
9. https://platform.claude.com/docs/en/about-claude/models/choosing-a-model — undated.
10. https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1 — undated.

#### Claude Code CLI / desktop (as of 2026-10-08)

**Use for:** Headless execution of compact task cards and desktop supervision of the same model routes. [11]

**Prompt shape:** Stable rules in `--append-system-prompt-file`; task-specific instructions in the user prompt. This placement is reported vendor guidance **(unverified)**. Capture with `--output-format json`; use `--json-schema` for final structure and `--max-turns` for bounded execution. [11]

**Settings / token rule:** Latest release verified by the supplied reports: 2.1.292, 2026-10-06. Opus requires ≥2.1.280; Sonnet ≥2.1.284. Separate desktop build number: **[NOT FOUND]**. Preserve stable model, tools, and prefix; current subscription caching can survive effort changes, subject to provider/configuration exceptions. [12][13]

**Known glitches -> fixes:**

- Revised standing instructions do not apply on resume -> initial system snapshot persists until compaction -> start a new session for changed standing rules -> documented behavior. [11]
- Cache rebuilds -> model or exact prefix changes -> append task updates and keep tools stable -> documented mechanism. [13]
- Desktop/Remote Control subagent display or cloud thinking persistence fails -> reported earlier bugs -> evaluate 2.1.292 fixes -> specific fixes **(unverified)**. [12]

**Sources:**

11. https://code.claude.com/docs/en/cli-reference — 2026-10-07 page stamp.
12. https://github.com/anthropics/claude-code/releases/tag/v2.1.292 — 2026-10-06.
13. https://code.claude.com/docs/en/prompt-caching — 2026-10-06 page stamp.

#### Claude Code subagents (as of 2026-10-08)

**Use for:** Scoped workers whose compact results reduce parent-context burden; separate context does not provide separate quota. [6]

**Prompt shape:** Give each worker one bounded deliverable, required evidence, and a stopping condition; avoid duplicate verification work. [6]

**Settings / token rule:** Model precedence: invocation override → frontmatter `model` → `CLAUDE_CODE_SUBAGENT_MODEL` → parent. Frontmatter `effort` overrides session effort, but `CLAUDE_CODE_EFFORT_LEVEL` overrides frontmatter. Invocation-level Agent-tool effort arrives in 2.1.292. [6][12]

**Known glitches -> fixes:**

- Weekly allowance drains unexpectedly -> worker requests share the parent’s pool -> pin worker models and account for aggregate work -> documented; net savings are workload-dependent. [6]
- Differentiated effort is ignored -> inherited global effort overrides workers -> remove that variable from launches needing per-agent effort -> documented precedence. [6]
- Cache expires during long checks -> default worker TTL is 5m -> evaluate `"subagentPromptCacheTtl": "1h"`; per-agent configuration belongs under `experimental.cacheTtl` -> documented; per-agent `1h` is ignored while usage credits pay. [13]

**Sources:**

6. https://code.claude.com/docs/en/sub-agents — 2026-10-07 page stamp.
12. https://github.com/anthropics/claude-code/releases/tag/v2.1.292 — 2026-10-06.
13. https://code.claude.com/docs/en/prompt-caching — 2026-10-06 page stamp.

#### Claude Code cloud sessions (as of 2026-10-08)

**Use for:** Scoped remote work with explicit completion evidence and billing-meter checks. [14][15]

**Prompt shape:** Name the sole deliverable, allowed exploration, checks, and stopping condition. Batching related work that shares context is a cost-control proposal **(unverified)**; controlled savings: **[NOT FOUND]**. [15]

**Settings / token rule:** Sessions share account limits; no separate VM compute charge. Exact conversion of this account’s prepaid balance into session charges: **[NOT FOUND]**. Start with the model/effort justified by the task, not a presumed fixed session price. [14][15]

**Known glitches -> fixes:**

- Short task costs about $5 -> repeated context processing can dominate visible output -> inspect input, output/thinking, cache reads/writes, turns, and worker usage -> $4.74 Fable example is a single report **(unverified)**; universal $5 tariff **[NOT FOUND]**. [16]
- Dispatched effort differs or “idle” appears before completion -> reported propagation/status behavior -> verify cloud-side settings and acceptance evidence -> single practitioner report **(unverified)**. [17]

**Sources:**

14. https://code.claude.com/docs/en/claude-code-on-the-web — 2026-10-07 page stamp.
15. https://code.claude.com/docs/en/costs — 2026-10-06 page stamp.
16. https://www.reddit.com/r/ClaudeAI/comments/1woj0m5/free_250_cloud_credit_on_5x_max_plan_thanks/ — 2026-09-23.
17. https://cver.net/devlog/spending-cloud-credit-from-a-terminal/ — 2026-09-29.

### Changes versus our current rulebook

- **ADD** Sonnet, Haiku, Fable, subagent, and cloud profiles with explicit quota and configuration rules. [3–17]
- **CHANGE** Opus medium remains the baseline; Opus-5-high equivalence becomes **(unverified)**. [2]
- **CHANGE** Stable-prefix guidance distinguishes supported Claude Code effort changes from model/prefix changes. [13]
- **REMOVE** Unqualified forced-tool prohibition; retain only as **(unverified)** if needed: https://platform.claude.com/docs/en/models/opus-5-5/overview — release 2026-09-22.
- **REMOVE** Uncorroborated interface assertions about HTTP-200 refusals and thinking-channel progress pending evidence; supporting audit finding **[NOT FOUND]**.

### Operational fixes for our scripts

- Pin full model IDs; omit effort for Haiku; CLI `--model`/`--effort` syntax is **(unverified)** under the audit’s bundled flag verdict. [5][8][11]
- Capture `--output-format json`, validate `--json-schema` results externally, and bound runs with `--max-turns`. [11]
- Remove inherited `CLAUDE_CODE_EFFORT_LEVEL` when worker frontmatter must control effort. [6]
- Version-gate Agent-tool invocation effort at 2.1.292. [12]
- Configure worker TTL separately; use `experimental.cacheTtl` for per-agent settings and account for the usage-credit exception. [13]
- Require acceptance evidence before completion; bounded continuation handling for Opus remains **(unverified)**. [2]
- Record token categories and reconcile the actual prepaid meter; do not infer billing from reply length. [14–16]

---

# Topic R7

_Brief: Cross-model practice in 2026 for running several frontier models from headless CLIs as one team: multi-model "..._

#### GPT-6 Astra / Sol / Luna / GPT-6.1 Sol / Codex (as of 2026-10-08)
**Use for:** Astra: autonomous coding with explicit completion criteria. Sol: complex production work. Luna: repeatable preparation. Treat these as routing baselines requiring local acceptance tests; a vendor default change does not promote a fleet route.

**Prompt shape:** Shared task card below; for Astra, remove compulsory preliminary reading and redundant verification instructions. State authorized continuation and observable completion.

**Settings / token rule:** Codex 0.161.0 defaults to `gpt-6.1-sol`; pin the intended model. Astra and GPT-6.1 Sol reject effort `none`; use `low` when appropriate. Sol/Luna support `none`, `low`, `medium`, `high`, `xhigh`, `max`. Configure effort outside the card.

**Known glitches -> fixes:**
- Premature review stop -> restrictive or redundant instructions -> specify continuation authority and completion criteria -> vendor guidance; savings are not guaranteed.
- JSON parsing fails -> `--json` emits JSONL events -> parse events individually; use `--output-schema` and `-o` for the final payload -> documented.
- Empty `aggregated_output` with exit 0 on Linux (unverified) -> cause unresolved -> independently check required artifacts/output -> detection safeguard; general fix [NOT FOUND].

**Sources:**
1. https://learn.chatgpt.com/docs/changelog — 2026-10-07.
2. https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra — 2026-09-11.
3. https://developers.openai.com/api/docs/guides/reasoning — 2026-10-07.
4. https://learn.chatgpt.com/docs/non-interactive-mode — accessed 2026-10-08; publication [NOT FOUND].
5. https://github.com/openai/codex/issues/48346 — experiments 2026-09-23–25; publication [NOT FOUND].

#### Claude Opus 5.5 / Sonnet 5.5 / Fable 5.1 / Claude Code (as of 2026-10-08)
**Use for:** Opus/Sonnet: scoped agentic execution and review. Fable-specific assignment evidence: [NOT FOUND].

**Prompt shape:** Put persistence and scope boundaries in system instructions: finish requested work, verify it, then stop. Explicitly request current-source lookup when necessary. Do not request printed reasoning.

**Settings / token rule:** Opus defaults to `medium`; Sonnet API defaults to `high`, but vendor guidance recommends starting well-specified agentic work at `medium`. Re-evaluate inherited effort settings. Opus thinking cannot be disabled. Keep subscription execution out of `--bare`, which requires `ANTHROPIC_API_KEY`.

**Known glitches -> fixes:**
- Missing schema payload -> reading `.result` instead of `.structured_output` -> extract `.structured_output` -> documented.
- Invalid email or other formatted value passes schema -> `format` annotations are not enforced -> validate formats externally -> documented limitation.
- HTTP 529 overload -> service overload -> configure `CLAUDE_CODE_OVERLOADED_RETRY_BASE_DELAY_MS` in 2.1.292 -> documented backoff; recovery not guaranteed.

**Sources:**
1. https://github.com/anthropics/claude-code/releases — 2026-10-06.
2. https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5 — accessed 2026-10-08; publication [NOT FOUND].
3. https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5-5 — accessed 2026-10-08; publication [NOT FOUND].
4. https://code.claude.com/docs/en/headless — 2026-10-06.

#### Gemini 3.8 Flash / Antigravity CLI; Gemini CLI (as of 2026-10-08)
**Use for:** Schema-constrained processing through `agy` for individual Free/Pro/Ultra accounts. Gemini CLI remains applicable to enterprise Code Assist/API-key routes.

**Prompt shape:** Concise instructions; place the specific question after large supplied context. Use a real output schema. A mandatory universal XML layout: [NOT FOUND].

**Settings / token rule:** Pin `gemini-3.8-flash`; keep temperature 1.0. Supported thinking levels: `low`, `medium` default, `high`. Antigravity 1.2.14 includes schema and hang fixes; default `--print-timeout` is 5m.

**Known glitches -> fixes:**
- Individual subscription unavailable in Gemini CLI -> June 18 migration -> use `agy` with cached authentication -> documented.
- Loops/degradation or invalid thinking setting -> lower temperature or `minimal` -> temperature 1.0 and supported level -> vendor guidance/documented compatibility.
- Premature success -> `WAITING`/`RUNNING` mistaken for completion -> retain incomplete state until terminal outcome -> documented.

**Sources:**
1. https://github.com/google-gemini/gemini-cli/discussions/28017 — 2026-06-18.
2. https://ai.google.dev/gemini-api/docs/latest-model — updated 2026-09-23.
3. https://ai.google.dev/gemini-api/docs/generate-content/gemini-3 — accessed 2026-10-08; publication [NOT FOUND].
4. https://antigravity.google/docs/changelog?tab=cli — release 2026-09-30.
5. https://www.antigravity.google/docs/cli/headless/ — accessed 2026-10-08; publication [NOT FOUND].

#### Grok 4.7 / Grok Build CLI (as of 2026-10-08)
**Use for:** Evidence-seeking challenger within the proposed cross-family review workflow; comparative auditor superiority is [NOT FOUND].

**Prompt shape:** Direct task, source scope, required evidence and structured deliverable. Model-specific XML or optimal example count: [NOT FOUND].

**Settings / token rule:** Pin `grok-4.7`; effort supports `low`, `medium`, `high` default, `xhigh`. Evaluate lower effort for bounded work; reasoning cannot be disabled. Add `--no-auto-update` in automation.

**Known glitches -> fixes:**
- Apparently empty ACP answer -> reading completion metadata only -> collect text from `session/update`, not only `session/prompt` -> documented.
- Multi-turn Responses failure -> omitted encrypted reasoning -> return `reasoning.encrypted_content` unchanged -> documented.

**Sources:**
1. https://docs.x.ai/developers/grok-4-7 — updated 2026-09-28.
2. https://docs.x.ai/developers/model-capabilities/text/reasoning — 2026-09-29.
3. https://docs.x.ai/build/cli/headless-scripting — updated 2026-06-10.

#### Muse Spark 1.3 / Muse Code (as of 2026-10-08)
**Use for:** Bounded coding tasks with external acceptance checks.

**Prompt shape:** Task in the user prompt; project rules through `AGENTS.md` in trusted workspaces. Include file paths and a done condition.

**Settings / token rule:** Select `muse-spark-1.3` explicitly because configuration documentation still names 1.2. Lower supported effort reduces tokens/latency; `none` returns HTTP 400, and `max` is standard-tier 1.3 only. Bound execution with `--max-model-steps`.

**Known glitches -> fixes:**
- Unsupported effort accepted by CLI parser -> CLI/model capabilities differ -> validate against model-supported values before launch -> documented incompatibility.
- Failed tests reported as successful execution -> exit 0 means turn completion -> require acceptance checks -> documented.
- Startup abort -> required MCP server failed -> mark genuinely optional servers `optional` -> documented.

**Sources:**
1. https://research.meta.ai/blog/introducing-muse-spark-1-3 — 2026-09-02.
2. https://dev.meta.ai/docs/muse-code/configuration — accessed 2026-10-08; publication [NOT FOUND].
3. https://dev.meta.ai/docs/reasoning — accessed 2026-10-08; publication [NOT FOUND].
4. https://dev.meta.ai/docs/muse-code/extending — accessed 2026-10-08; publication [NOT FOUND].

#### DeepSeek V4.1-Flash / V4-Pro / API (as of 2026-10-08)
**Use for:** JSON-producing API work when separately authorized. Subscription-backed headless CLI: [NOT FOUND].

**Prompt shape:** Include “json,” explicit desired keys and a compact output example; validate the resulting object externally.

**Settings / token rule:** `deepseek-flash` selects V4.1-Flash. V4-Pro remains distinct according to the audit’s corrected routing verdict. `medium`/`high`/`xhigh` map to `high`; use `low` or `none` when appropriate.

**Known glitches -> fixes:**
- Empty JSON content despite successful response -> acknowledged JSON-mode defect -> reject empty payload, modify prompt, retry within a bounded policy -> vendor mitigation, not guaranteed.
- Effort reduction has no effect -> `medium` maps to `high` -> select an actual supported lower level -> documented.

**Sources:**
1. https://api-docs.deepseek.com/updates/ — page 2026-09-24; launch entry 2026-09-10.
2. https://api-docs.deepseek.com/api/create-chat-completion/ — 2026-09-24.
3. https://api-docs.deepseek.com/guides/thinking_mode — 2026-09-24.
4. https://api-docs.deepseek.com/guides/json_mode — 2026-09-24.

#### Local Qwen3.6 / Qwen Code (as of 2026-10-08)
**Use for:** Local first-pass processing after hardware/task qualification; newest suitable Mac checkpoint: [NOT FOUND].

**Prompt shape:** Use the checkpoint’s chat template; separate thinking from final output. Supply necessary content through the actual pipeline. Qwen Code supports `--append-system-prompt`.

**Settings / token rule:** For `Qwen/Qwen3.6-35B-A3B` coding-thinking: temperature 0.6, `top_p=0.95`, `top_k=20`, `presence_penalty=0.0`. Bound Qwen Code with `--max-session-turns`, `--max-wall-time`, `--max-tool-calls`.

**Known glitches -> fixes:**
- Thinking switches ineffective -> Qwen3.6 does not support `/think` or `/nothink` -> use checkpoint-supported controls -> documented.
- Unattended retry never terminates -> `QWEN_CODE_UNATTENDED_RETRY=1` retries 429/529 indefinitely -> enforce outer deadline; do not treat retry as quota recovery -> documented behavior; deadline is proposed control.

**Sources:**
1. https://huggingface.co/Qwen/Qwen3.6-35B-A3B — accessed 2026-10-08; publication [NOT FOUND].
2. https://github.com/QwenLM/qwen-code/releases/tag/v0.25.0 — 2026-10-05.
3. https://qwenlm.github.io/qwen-code-docs/en/users/features/headless/ — 2026-10-01.
4. https://qwenlm.github.io/qwen-code-docs/en/users/configuration/settings/ — accessed 2026-10-08; publication [NOT FOUND].

### Changes versus our current rulebook

- **ADD:** Proposed shared card: `ROLE | INPUTS | TASK | EXCLUSIONS | DONE | GROUNDING | OUTPUT | BUDGET`; translate settings and extraction per harness.
- **CHANGE:** Record GPT-6.1 Sol as Codex’s bundled default; retain explicit fleet pins and separate route promotion.
- **CHANGE:** Replace blanket Grok `high` starts with measured task-class baselines.
- **CHANGE:** Replace mandatory Gemini XML with concise instructions, schema and question-after-context placement.
- **CHANGE:** Replace universal local temperature 0 with checkpoint-specific sampling.
- **ADD:** Blind initial answers, anonymized/shuffled critique and an outside judge; qualify auditors on relevant error classes [C2].
- **ADD:** Citation existence and metadata checks before claim-support review; resolving URLs alone are insufficient [C1].
- **ADD:** Schedule qualified subscription routes using account/window/reset telemetry, preserve auditor reserve and treat unreadable telemetry as unknown [C3].
- **REMOVE:** No existing excerpt rule corresponds to the refuted repositories or DeepSeek rerouting claim; exclude them from this update.

### Operational fixes for our scripts

- Codex: `codex exec --model <id> --json --output-schema <schema-file> -o <output-file>`; parse JSONL separately.
- Claude: `claude -p … --output-format json --json-schema …`; validate `.structured_output` and formats.
- Antigravity: `agy -p … --json-schema … --output-format stream-json`; configure `--print-timeout`.
- Grok: `grok -p … --output-format json --no-auto-update`; use ACP updates when applicable.
- Muse: `muse exec --prompt-file … --json --max-model-steps …`; require independent acceptance.
- Qwen: `qwen -p … --output-format json`; apply native limits plus an outer process deadline.
- Proposed wrapper: require terminal success, nonempty valid payload and acceptance; distinguish quota, transient overload, authentication, schema and timeout failures before bounded retries.
- Proposed citation pipeline: deduplicate/cache URLs, compare DOI/title/author/year, preserve network failures as unresolved, then audit claim–passage support [C1].
- Proposed scheduler: ingest CodexBar/native telemetry; compare qualified routes using account-specific windows, not raw cross-provider percentages; never silently substitute paid APIs [C3].

Cross-cutting sources:

1. **C1:** https://github.com/tvquynh/citation-verifier — accessed 2026-10-08; publication [NOT FOUND].
2. **C2:** https://github.com/nasimubd/claude-council/blob/main/plugins/council/README.md — accessed 2026-10-08; publication [NOT FOUND].
3. **C3:** https://github.com/steipete/CodexBar/blob/main/docs/cli.md — accessed 2026-10-08; publication [NOT FOUND].

Audit-only MCP/CVE/cache-discount additions lack supporting URLs in the inputs: [NOT FOUND]; no script changes adopted.
