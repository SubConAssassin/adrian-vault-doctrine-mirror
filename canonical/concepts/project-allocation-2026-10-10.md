---
title: Project allocation by model and lane
date: 2026-10-10
status: active until superseded
method: research-before-astra (Gemini + Grok drafts from the 10 Oct research, Claude Opus via agy audit, Gemini wrote PROMPT.md, GPT-6 Astra xhigh final, Claude corrected 4 points against live data)
sources: working/_research/2026-10-10-project-allocation/
---

Live rulings beat this file. Pools change: re-check the token secretary before relying on a capacity figure. Google is on AI Ultra 5x since 10 Oct (ruling google-ai-ultra-5x).

## Project allocation

Through 15 Oct at 05:00 WITA, Claude Max handles decisions, card writing and one decision-changing source probe only. It does no legwork or routine dispute tracking. Legal material and dispute numbers stay with Claude Max in CORE, never with agy or external lanes.

Astra works only from PROMPT.md, with no research. Reserve 70% of Photon capacity for Ashta complex builds. All non-Ashta Photon work, including reviews and finals, waits until 16 Oct.

agy-Claude is strictly for audits and PROMPT.md authoring. It is never a fallback for builds, legal work or general tasks.

Model-created work requires a verifier from another model family. Tests, regex filters, linters and same-family reviews do not qualify. Where a row lacks an independent reviewer, that verification gate remains unmet.

Studio is available only for browser fallback and media processing, never CLI. Browser tests run first on Mini at 1440 and 390, then claimed idle Studio, then M1 headless with a stated reason (G19). Repeating monitoring jobs stay off M1 (G18).

### Ashta

| Task Type | Primary | Fallback | Verifier |
|---|---|---|---|
| Release builds: R21 D7 sweep, meeting-2 merge, SPK-1, CI code defects | Photon Astra xhigh, from the card | Wait for Photon; agy Gemini only after a capability test | Required tests, Mini CI on final SHA, agy Gemini High review |
| Routine non-release fixes | DeepSeek v4-pro high | Codex Terra low, sharing the Photon capacity limit | Astra review before merge and tests; Terra still requires another-family review |
| Branch merges / conflicts | Grok 4.7 high on Mini | Photon Astra | Mini CI on exact SHA; independent review gate also applies |
| CI watch | Deterministic script with exact-SHA checks | Cloud credits only for reproduced failures, above $15 floor, after account authority resolves [UNCERTAIN] | Re-run on same SHA |
| Deploy / go-no-go | Guarded deploy script; Claude Max decides | Stop unless CI is green | Adrian |
| Web checks | Mini headless Chrome at 1440 and 390 | Claimed idle Studio, then M1 headless with stated reason | Check output |

### Subconscious Surgery

| Task Type | Primary | Fallback | Verifier |
|---|---|---|---|
| Transcription / staging | PC Whisper; Studio feeder; M1 rclone staging | None | Pipeline logs |
| Teaching mining | Grok 4.7 high | agy Flash High | agy quote check against transcripts; Flash output requires another-family review |
| Keyframes | PC local-vision, idle-only; high latency / LlamaServerPC [UNCERTAIN] | agy Flash High on samples | agy sample audit; Flash output requires another-family review |
| B-roll match | real_broll.py | None | Sample checked against source photos |
| Social / story copy | agy Flash High draft | Grok draft | Other family against voice rubric; Astra xhigh final from 16 Oct, followed by independent verification |
| IG/FB DM drafts | Grok Bot trial, Ask-first, on-demand billing off; pool sharing [UNCERTAIN] | Manual | Adrian |

### OSB

| Task Type | Primary | Fallback | Verifier |
|---|---|---|---|
| Etsy messages | OpenAI dot on Photon (set up 10 Oct; waits on Adrian's confirm in the dot chat and his Etsy sign-in); no Codex tasks | Manual | Adrian |
| Product / site copy | agy Flash High | Grok | Other family plus Claude Max decision-level canon check: keep KGB origin, no Cosmic Vein; Astra xhigh final from 16 Oct, followed by independent verification |
| Wix catalogue, not in log | Codex Terra low from 16 Oct | DeepSeek v4-pro | agy Gemini schema check |
| Disputes | Deterministic deadline tracking within CORE; Claude Max synthesises only a redacted decision | None to other lanes | Adrian |
| Reels social | mini-osb-reels, OSB Claude social pipeline only | Fail closed | Approved boards |

### X-Maxed

| Task Type | Primary | Fallback | Verifier |
|---|---|---|---|
| Code | DeepSeek v4-pro for routine work | Astra xhigh from 16 Oct | Astra review from 16 Oct or agy review, plus tests; Astra-built work requires agy review |
| Browser tests | Mini headless at 1440 and 390 | Claimed idle Studio, then M1 headless with stated reason | Test output |

### AGA / Tri Hita

| Task Type | Primary | Fallback | Verifier |
|---|---|---|---|
| Research / regulatory, excluding legal material | Research pipeline: grok-web high and agy Flash High | DeepSeek audit | agy-Claude Opus medium audit |
| Final synthesis | Astra xhigh on PROMPT.md only, from 16 Oct and subject to Ashta reserve | Wait for 16 Oct and available reserved capacity | Grok premise challenge; Claude Max decides within its active window |
| Financial mechanics | Deterministic Python model | agy Flash High | Independent recalculation script; Flash output also requires another-family verification |

Legal material within AGA / Tri Hita stays exclusively with Claude Max in CORE. No successor decision lane is allocated after Claude Max’s active window.

### Fleet

| Task Type | Primary | Fallback | Verifier |
|---|---|---|---|
| Monitoring | Deterministic Mini service | Bounded diagnostic lane after sustained fault | Health checks and receipts |
| Research | Research pipeline | DeepSeek audit; Gemini writes card | Different family; Claude Max decision-only spot-check |
| Bulk extraction, over 200 items | Text-only Ollama qwen3.5:9b; requires think:false [UNCERTAIN] | agy Flash High | Schema check and other-family sample |
| Boot / rule registry | Hold until Adrian decides; Photon registry harness waits until 16 Oct | agy review | Grok or DeepSeek, from a different family than creator |
| Backup failure | Wait for next logged run; Astra low patch if needed, from 16 Oct | DeepSeek flash | agy diff review |

### Spend plan

- Photon had 28% of the week left at 3:20 pm WITA on 10 Oct (live token secretary) and resets 16 Oct 5:32 pm WITA. Preserve the 70% Ashta reserve. The OSB ChatGPT account is cancelled and is never routed.
- Preserve Claude Max for its restricted work through 15 Oct, 05:00 WITA. agy-Claude (Opus/Sonnet 5.5) is a separate Antigravity pool, now on Ultra 5x: on Pro it ran out after about 7 Opus calls; after the upgrade a 200 KB audit ran fine. Measure before bulk use.
- Muse has $5 via CORE [CONFIRMED] and failing status [CONFIRMED]. Count zero capacity until lane-health.sh returns clean output.
- Run DeepSeek v4-pro through metered-guard.py preflight. Antigravity AI credit overage stays off without Adrian's approval (AGENTS.md 7.2).
- Grok Bot requires Ask-first approval and on-demand billing off. Zero additional fee and pool-sharing impact remain [UNCERTAIN].
- Keep cloud credits outside the runner. Account authority is unresolved [UNCERTAIN]. Use only for reproduced CI failures once resolved, while remaining above $15. M1 had about $6 above that floor on 8 Oct.
- Block gpt-6-sol because local access is unverified. New pins require live probes.
