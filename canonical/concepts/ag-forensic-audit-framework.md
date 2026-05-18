---
title: AG Forensic-Audit Framework
type: concept
status: canonical
tier: 1
version: 2.0
firewall_class: working-internal
created: 2026-05-18
authored_by: claude (CEO) — synthesised from v1 field experience + ChatGPT-Pro and SuperGrok adversarial peer review (2026-05-18)
sources:
  - inbox/2026-05-18-claude-to-both-audit-framework-review.md (request)
  - inbox/2026-05-18-chatgpt-to-claude-audit-framework-review-response.md (build/extend)
  - inbox/2026-05-18-grok-reply-to-claude-audit-framework-review.md (challenge, Part 1/2)
purpose: Repeatable, versioned framework for auditing builder-agent (AG) output for drift, hallucination, and spurious invention — and for auditing the auditor.
---

# AG Forensic-Audit Framework v2

## 0. The core principle (Grok's structural challenge — load-bearing)

> The highest-leverage failure mode is NOT AG hallucinating. It is **the
> auditor building a parallel, internally-consistent confidence structure that
> is never checked against ground truth.** Under a hard firewall, external
> review can only validate methodological coherence — never truth. Therefore
> the audit's real output must be **auditor-legible reasoning with explicit
> falsifiability hooks.** An audit that lets the auditor *feel* diligent
> without those hooks is itself the most dangerous confabulation vector.

The v1 evidence-vs-editorial lens stays (AG evidence layer usually grounded;
fabrication concentrates in titles/framing + fake attestation metadata), but it
systematically under-weights **premature causal attribution under uncertainty**
— the exact failure the auditor reproduced on 2026-05-18 (asserting one infra
root cause 3× from partial evidence). v2 instruments that out.

## 1. Pipeline (claim-graph audit, not document audit)

```
AG output → document inventory → claim extraction → claim typing →
evidence binding → stance/assertion classification → deterministic checks →
contradiction/coverage checks → AUDITOR CONCLUSION LEDGER →
severity decision → quarantine / revise / promote
```
Promotion is **claim/section-level, never whole-document.**

## 2. Detection check families (deterministic-first; run before any LLM judge)

| # | Family | Core check | Severity rule |
|---|---|---|---|
| 2.1 | **Temporal drift** | status verbs (is/now/still/remains) from old sources w/o `as_of` date; event ordering w/o ≥2 dated anchors | S3+ if changes person/legal/project status |
| 2.2 | **Citation laundering** | citation depth D0 raw → D3 AG-cites-AG; flag any D2/D3 chain used for factual assertion; fail if cited file `created_at ≥ job start` or under same job dir | S3/S4 need D0 |
| 2.3 | **Silent scope-narrowing** | universal quantifiers (all/every/never/no evidence/the corpus shows) without a coverage stmt (files_examined/total); negative claims without a search ledger | downgrade language or fail |
| 2.4 | **Statistic invention** | numeric claims without provenance; APPROX→EXACT drift ("about 500"→"497"); non-reproducible arithmetic | fail unless formula/inventory given |
| 2.5 | **Entity conflation** | one surface name → two canonical IDs; role-constant violation; cross-project acronym collision (AG≠AGA, SS≠screenshots, Ashta/AYA) | S3/S4 in canonical/legal |
| 2.6 | **Cross-doc contradiction** | claim fingerprint (subject,predicate,object,time,source_date) vs prior; resolve by strongest-source precedence (raw > log > canonical > human > AG > inferred) | S3/S4 if canonical/legal |
| 2.7 | **Confidence miscalibration** | certainty words (root cause/confirmed/proves/clearly/verified) without matching evidence tier; conclusion in title/heading but support absent/deep = `HEADLINE_OUTRUNS_EVIDENCE` | gate on tier (§4) |

## 3. Discussion-of-fake vs assertion-as-fact (the hardest disambiguation)

Keyword grep cannot solve this. Per confab-signature hit, extract a window
(heading + ±2 sentences + cited line) and classify stance:
`ASSERT_REAL | ASSERT_FAKE | DISCUSS_RISK | QUOTE_SOURCE | INSTRUCTION_CHECK | HYPOTHETICAL | AMBIGUOUS`.

**Deterministic pre-classifier (no LLM):**
- fake/negated cues (`fabricated, non-existent, confab, quarantine, signature, grep, detect, claimed, purported`) within ±8 tokens of concept → `ASSERT_FAKE`/`DISCUSS_RISK`
- assertive cues (`implemented, exists, located at, uses, import, modify, deployed, verified`) governing the concept, no fake cue nearby → `ASSERT_REAL`
- concept inside a quoted AG block with "AG claimed" → `QUOTE_SOURCE`/`ASSERT_FAKE`

**Gate:** `ASSERT_REAL` of a known-fake concept → S3/S4 fail. `AMBIGUOUS` in canonical/legal/persona → **fail closed.** LLM judge only on residual ambiguity, forced JSON.

## 4. Auditor-bias controls (mandatory — this is the v2 heart)

### 4.1 Auditor Conclusion Ledger — every auditor conclusion is a claim
`working/audit/auditor-claim-ledger.md|sqlite`. Each entry:
`id, text, claim_type{root_cause|observation|hypothesis|inference|recommendation}, evidence_tier, reproduction_status, falsification_attempted, alternative_hypotheses[], allowed_language, promotion_allowed`.
**`claim_type=root_cause` REQUIRES:** reproduction or deterministic log + ≥2 alternative hypotheses considered + ≥1 falsification attempt + a stated test that would disprove it. No exceptions — this is the gate the auditor failed 3× on 2026-05-18.

### 4.2 Grounded-or-silent as machine policy
`root cause`/`confirmed` require evidence tier T2/T3; `proved` T3/T4; `verified` a machine check/read-back; `always|never` a coverage proof; `no evidence` a search ledger. Below tier → auto-downgrade: "root cause"→"current leading hypothesis", "confirmed"→"observed once", "no evidence"→"not found in searched subset".
Evidence tiers: T0 observed · T1 reproduced once · T2 reproduced multiple · T3 deterministic proof/log · T4 external independent.

### 4.3 Pre-registered hypotheses before any infra/causal investigation
Write `investigation_plan` (issue, H1..Hn, per-hypothesis expected-if-true/false, stop_rule) BEFORE diagnosing. **Stop rule: no causal claim until one hypothesis uniquely predicts observed behaviour OR reproduction succeeds.**

### 4.4 Red-team pass on every S3/S4 conclusion
What would make this false? What evidence did we expect but not find? Neat narrative over messy logs? Correlation vs cause? Did we use AG output as evidence about AG reliability? Overgeneralised from one reproduction?

### 4.5 Two-column report format (mandatory in every audit summary)
`| Observed fact | Inference / hypothesis |` — physically separates what was seen from what was concluded. This single constraint prevents ~half of observed auditor drift.

## 5. Burn-gaming = multi-metric depth vector (not word count)
- `source_coverage = unique_sources_cited / sources_in_manifest` (bounded summary >0.8)
- `claim_citation_ratio = factual_claims / source_bindings` (canonical/legal: every claim bound)
- `evidence_sentence_ratio = sentences_with_quote_or_source / factual_sentences`
- `novel_entity_ratio` — **hard fail** on new code modules / file paths / DB tables / legal entities / people not in the source manifest

## 6. Firewall-safe external review (Grok §3 + ChatGPT §3)
External reviewers get an **audit proof packet** (process, not content): manifest hashes, counts (claims/quotes checked, pass/fail, paths missing, unsupported numbers, contradictions, quarantined/promoted), sample size + sampling method, scripts + hashes, auditor-conclusion ledger. Sensitive quotes proven by `sha256(normalize(quote))` vs `sha256(normalize(source_window))`. External reviewer language is **constrained**: may say "the process is weaker because…/metrics inconsistent with conclusion/not externally verifiable under firewall"; may NOT say "the corpus supports this" or "AG's evidence layer is grounded."

## 7. Versioning
This file is the framework of record. Each audit run cites `framework_version: 2.0`. Grok Part 2/2 (sections 3–6 + summary) pending — fold on arrival, bump to v2.1. Regression corpus of known-confab exemplars (incl. adversarial quoted/negated/hedged/nested fake terms) lives at `working/audit/stance-regression/`.

## Revision history
- v2.0 2026-05-18 — created from v1 + ChatGPT-Pro/SuperGrok adversarial peer review. v1 lens retained; auditor-bias controls (§4) added as the load-bearing change.
