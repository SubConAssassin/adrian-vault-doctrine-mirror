---
title: Generative Research Fact-Checking Protocol
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
priority: HIGH — applies any time a generative model (Grok, ChatGPT, Claude itself) is used to "audit" external entities
created: 2026-04-27
last_updated: 2026-04-27
distilled_from: Grok-4 first-pass Red Bull APC audit (multiple verifiable fabrications, discarded)
related:
  - canonical/concepts/forensic-cross-reference-protocol.md
  - canonical/concepts/api-integration-doctrine.md
---

# Generative Research Fact-Checking Protocol

## The failure mode

When you ask a generative model to "audit" or "research" a private/semi-private organisation's internal details (Red Bull's APC equipment, a competitor's tech stack, a private company's staff), the model has three failure modes:

1. **Hallucinated specifics.** Fabricated brand/model combinations, fabricated URLs (often with implausible patterns like `pubmed.ncbi.nlm.nih.gov/equipment-redbull-2025` instead of numeric PMIDs), fabricated DOIs (suspicious round-number tails like `10.1080/02640414.2024.123456`).
2. **Stale cached facts presented as current.** Names and roles from training data presented as 2026-current when the person actually moved jobs years ago. Grok placed Per Lundstam at Red Bull in 2026 — verified web search shows he left in autumn 2021 to return to US Ski & Snowboard.
3. **Conflation of external collaborators with employees.** Researchers who appeared on a single co-authored Red Bull paper (David Putrino at Mount Sinai) presented as Red Bull staff.

These failures are *confident*, *plausible*, and *cite-able*. They look exactly like real research output. Building on them is downstream poisoning.

## The wrong move

Take Grok's "Red Bull APC equipment audit" output, polish it, and file it as canonical. This is what I almost did before catching the Lundstam contradiction against my own earlier verified web research.

## The right move

**Reframe the prompt from "audit X" to "spec our own X informed by best-in-class".** Generative models are honest when asked to recommend; they are dishonest when asked to report on inaccessible private information. The same brand/model knowledge that produces fabricated "Red Bull uses [model]" claims produces accurate "best-in-class for elite athletic facilities is [model]" claims, because the second framing is a recommendation drawing on industry-standard knowledge rather than a fabricated peek into a closed system.

## The protocol

### Step 1 — Detect the audit-trap framing

Before sending any "research X's internal details" prompt, ask: *can the model actually know this from public information?*

| Framing | Detection signal | Action |
|---|---|---|
| Audit private org's exact equipment | Equipment lists for closed facilities are not public | Reframe to spec |
| Audit competitor's exact tech stack | Tech stacks are partially public, not exhaustively | Reframe + flag uncertainty |
| Identify who currently holds an internal role | Roles change frequently | Web-search verify |
| Recommend best-in-class equipment for [purpose] | Generative + recommendation = honest | Proceed |
| Spec our own facility informed by industry standards | Generative + specification = honest | Proceed |

### Step 2 — Build anti-hallucination guardrails into the prompt

For any research-type call to Grok / ChatGPT / Claude, include:

```
ANTI-HALLUCINATION RULES — STRICT:
- DO NOT invent URLs. If you cannot cite a real retrievable URL, write nothing (no fake URL).
- DO NOT invent DOIs.
- If you do not know the current best-in-class for a category, write "RESEARCH NEEDED" — don't guess.
- For each brand named, you must be confident the brand and model exist as of [current year].
- Distinguish [VERIFIED] (named in a real source you can quote), [INDUSTRY-STANDARD]
  (widely used, common knowledge), and [SUGGESTED] (your recommendation, not necessarily
  attested at any specific facility).
```

This significantly reduces fabrication rate but does not eliminate it.

### Step 3 — Cross-check against verified anchors

After receiving any generative-research output, cross-check at least three high-stakes claims against either:
- Earlier Claude-verified web search results in this session
- Official institutional websites (university faculty pages, company about-pages, government registers)
- Cross-references in the existing vault

If any one of the three checks fails, **discard the output** and rerun with stricter guardrails or a different framing. Do not "patch" a fabricating model's reply — fabrications cluster, where there's one there are usually more.

### Step 4 — Tag provenance in the deliverable

Every fact in the final document gets a tag:
- `[VERIFIED]` — anchored in a real source quoted/cited
- `[INDUSTRY-STANDARD]` — common knowledge in the relevant field
- `[SUGGESTED]` — Claude or the generative model's recommendation, not externally validated
- `[RESEARCH-NEEDED]` — gap; verify before use

### Step 5 — File the methodology note in the source-provenance section

The deliverable explicitly notes:
- Which generative model was used
- Which call was discarded and why
- Which framing was used in the second/successful call
- Which claims have which tags

This way the next instance of Claude reading the deliverable sees the epistemic structure and doesn't downstream-poison from the `[SUGGESTED]` tier.

## Concrete signals of fabrication to watch for

- **URL patterns that don't match the platform's real format.** PubMed uses numeric IDs (e.g. `pubmed.ncbi.nlm.nih.gov/12345678/`), not slug-style descriptors.
- **DOIs with suspicious round-number tails.** `10.xxxx/journal.2024.123456` or `10.1234/abc.2025.012345`.
- **Confident specifics for inherently private information** — exact square footage, exact brand of equipment behind closed doors, exact internal staff structure.
- **Names of staff with publication counts that are weirdly round** ("100+ pubs", "200+ pubs") with no specific top-cited paper title.
- **Dates that align too neatly** with the current year — facilities all "opened 2021", studies all "published 2024".
- **Cross-link inconsistencies** — Grok said Putrino is "Neuro Consultant, part-time" but his actual affiliation (Mount Sinai, NYC) was missing.

## The general principle

**Generative models are reliable for what they can know. Unreliable for what they can only guess.** The honest framing makes the model use its strength (industry knowledge, best-practices recommendations) and avoid its weakness (fabricating insider information). Reframe before retrying.

## Cross-references

- `canonical/concepts/api-integration-doctrine.md` — when to use which API (this protocol overlays on it)
- `companies/aga-bali/sequoia-meeting-2026-04-27.md` §2 CR-2 — case study (rejected first pass, successful second pass)
- `working/drafts-pending/aga-bali-tech-stack-v1.md` source-provenance section — example of methodology note
- `canonical/concepts/lessons-from-session-2026-04-27.md`
