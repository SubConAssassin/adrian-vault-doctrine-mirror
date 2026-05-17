---
title: "The Subconscious Surgery Processing-Statement Algorithm (AI-Infrastructure Core)"
type: methodology-algorithm
status: authoritative-internal
tier: 1
firewall_class: strictly-private
firewall_note: "This IS the private mechanism. NEVER public, never client-facing, never in marketing/ads/sales/social. Public framing remains EXACTLY: 'Language is my scalpel / I listen to how you frame what's blocking you / the proof is the outcome.' This file is the internal IP that powers the AI infrastructure — treat like source code."
authored_by: claude (cowork, audit track — Claude-direct reverse-engineering from grounded corpus, Adrian-commissioned 2026-05-17)
grounding_attestation: "Every step is reverse-engineered from real corpus sources read this task. Multi-source corroborated (per feedback-ssot-vs-corroboration). Inferences labelled. Gaps marked GAP."
sources:
  - canonical/projects/subconscious-surgery/consolidated-knowledge-base.md §2.2 (the documented 7-step formula spine)
  - working/deep-extraction/voice-transcripts/ss-client-sessions/Recording 48.md (live construction + chakra ID + under-eye tap)
  - working/deep-extraction/transcripts/voice-memos/2026-01-21_224558_20190702*.md (full end-to-end live build, slot-by-slot, affirmation stay/go testing)
  - working/deep-extraction/voice-transcripts/ss-client-sessions/Gleb.md (diagnostic front-end: empath-somatic testing → body scan → statement → pattern interrupt)
  - canonical/adrian-corpus/mastermind-transcripts-batch/mas40 subcon sur letting go rx.md (verbatim group surgical script + Heart/Crown chakra mapping)
  - working/deep-extraction/transcripts/2018-Dec-14_14-07-36.md (Finding B: muscle-test → "scan your body, find where the language is stored")
corroboration_note: "muscle-testing/empath-surrogate diagnostic is GROUNDED across ≥4 independent sources (2018, Gleb, Recording 48, cristina-2022). This corrects the Stefi/Tristan-scoped 'zero grounding' verdict — see canonical/AUDIT-2026-05-16-MASTER-forensic-report.md §5 update."
related:
  - canonical/concepts/cross-project-methodology-map.md (the grounded principle layer; THIS is its mechanism-layer companion)
---

# The SS Processing-Statement Algorithm

## 0. What this is
The deterministic + intuitive pipeline that converts a client's spoken
problem into (a) a **pain description** and (b) a **processing statement**,
then executes and integrates it. This is the core algorithm the AI
infrastructure (SS AI / Ashta / Bodhisvara) is built to learn and run.
Adrian's design intent (2026-05-17, verbatim): *"the AI infrastructure
algorithm which is going to power all of the platforms. All the other
platforms will be doing is feeding … more and more data and feedback to
either corroborate patterns or debunk patterns … grow and learn to increase
efficacy."* §8 specifies that learning loop.

## 1. Pipeline (six stages)

```
INTAKE → DIAGNOSTIC → STATEMENT CONSTRUCTION → EXECUTION → INTEGRATION → FEEDBACK
(language    (body-source   (slot-grammar +        (pattern    (affirmation   (corroborate/
 capture)     localisation)  causal-chain build)    interrupt)  prescription)  debunk loop)
```

## 2. STAGE 1 — INTAKE (Cognitive-Emotional Download) — deterministic-capturable

- Client gives an unstructured "brain dump" of the problem/frustration/block
  (Gleb: *"give me a download and a brain dump, I'll make a load of notes"*).
- **Capture verbatim the client's exact words, metaphors, and framings** — do
  NOT paraphrase. The client's own language is the raw material the entire
  algorithm operates on (CKB §2.1 *"actively listens for the exact
  language/metaphors used"*). 
- Output: `language_corpus` = the verbatim phrase set + flagged emotionally-
  charged tokens (repetition, intensity words, somatic words, self-judgment).
- **AI-automatable now:** transcription + verbatim phrase extraction +
  charge-token tagging (LLM-native).

## 3. STAGE 2 — DIAGNOSTIC (Empathic Body-Source Identification) — intuitive → learned

This is the step Adrian performs by **empath-surrogate muscle testing**
("my body reacts as if it's you … I muscle test you through me", 2018/Gleb —
GROUNDED, not confabulation). Function, abstracted from the mechanism:

- Map the charged language to the **body location holding the charge**
  (a chakra/region), then to the **emotional theme** of that region.
- Grounded body→theme map (CKB §2.2 + corpus):
  | Region | Emotional theme (grounded) |
  |---|---|
  | Sacral | money fears, creative/financial flow |
  | Solar Plexus | unyielding situations, control, personal power |
  | Heart | self-love, relationship-with-self (Recording 48, mas40) |
  | Throat | fear of judgment, "can't say more", self-expression |
  | Crown | trust in divine timing/higher forces, spiritual connection (mas40) |
  | (Root/others) | GAP — extend the map from corpus as data accrues |
- Output: `body_source` (region) + `emotional_theme` + a `root_experience`
  hypothesis (the originating memory the charge traces to).
- **AI design:** this is the part the LLM *learns to approximate* from
  accumulated (language → body_source → confirmed_outcome) tuples. The
  algorithm does NOT need to replicate the somatic mechanism; it needs to
  predict the same body_source/theme the practitioner's testing produces,
  then let the feedback loop (§8) corroborate or debunk. **GAP requiring
  Adrian:** the exact language→region heuristics he tests by — partially
  inferable from corpus, must be enriched by labelled sessions.

## 4. STAGE 3 — STATEMENT CONSTRUCTION (the core IP — fully grammar-able)

The pain description and processing statement are the **same artifact**: the
client's verbatim language re-sequenced into a single causal chain that
*is* the description of the pain with full context and detail.

### 4.1 The slot grammar (canonical formula — CKB §2.2, corpus-confirmed)

```
"I completely love and accept myself,
 even though I [BLOCK],
 which I now realise is [REFRAME],
 which I inherited through [ORIGIN_STORY],
 creating feelings of [EMOTIONAL_CONSEQUENCE],
 taking me back to [ROOT_EXPERIENCE]."
```

### 4.2 The extended causal-chain grammar (live-session corroborated)

Real constructions (2019 full build; Recording 48) show the slots expand
into a **chained causal cascade** — the signature move. Production grammar:

```
I completely love and accept myself,
  [even though|even if] <BLOCK: client's verbatim problem phrase>
  because <PROXIMATE_CAUSE: client's own reason>
  because <DEEPER_CAUSE: client's own deeper reason>
  which comes from <CORE_PATTERN: the inherited paradigm/need>
  making me <FEAR/AVOIDANCE: the behavioural consequence>
  which creates <PRESENTING_SYMPTOM: loops back to the BLOCK>
  which I now realise is <REFRAME: agency-restoring re-statement>
  taking me back to <ROOT_EXPERIENCE>.
```

### 4.3 Construction rules (deterministic — this is the automatable algorithm)

1. **Verbatim-only fill.** Every slot is filled with the client's *own*
   words from `language_corpus`. The practitioner re-sequences; he does not
   invent. (This is why the public claim "language is my scalpel" is literal
   and true.)
2. **The hook is invariant:** every statement opens *"I completely love and
   accept myself"* (CKB; mas40; 2019; Recording 48). Non-negotiable —
   nervous-system safety before any negative content (mas40 clinical note).
3. **Chain by causation, not narrative.** Link clauses with the connective
   set {even though, because, which comes from, making me, which creates,
   which I now realise is, taking me back to}. Each clause must causally
   follow the prior (the 2019 build is the reference exemplar).
4. **Pain→agency pivot is mandatory.** The chain must turn at *"which I now
   realise is …"* — reframing the block from happening-TO-them to a
   pattern they own (Recording 48: *"in reality it is me who needs to be
   more assertive"*). No statement ships without this pivot.
5. **Terminate at the root.** Close on `[ROOT_EXPERIENCE]` or the verbatim
   hook echo. The statement is one continuous spoken breath-able sentence.
6. **Co-construct + confirm.** Read it back slot-by-slot; client confirms or
   corrects each ("can I just check I got that right" — 2019). Correction
   tokens replace slot fills. Iterate until the client *feels* it land.
- **AI-automatable now:** §4.1–4.6 is a constrained generation task over
  `language_corpus` + `emotional_theme` — exactly an LLM-native operation.

## 5. STAGE 4 — EXECUTION (Pattern Interrupt) — deterministic params

- Frequency matched to the identified chakra plays (CKB step 4 — internal).
- Client reads the statement aloud **continuously** while tapping the
  **under-eye / stomach meridian ~5 taps/sec** (Recording 48: *"tapping
  under your eyes and away you go"*; CKB: ~9 min). Loop until charge
  discharges (client report + practitioner test).
- Params are fixed; only duration is adaptive (until discharge).

## 6. STAGE 5 — INTEGRATION (Affirmation Prescription) — grammar-able

- Grounding: deep belly breaths, quiet de-frag (CKB step 6; 2019 "nice deep
  breath … ground all that energy").
- Prescribe **bespoke affirmations** (the positive operating-system
  install). Construction rule: each affirmation is the *inverse* of a chain
  clause, stated as present-tense embodied truth.
- **Stay/Go testing** (2019 + Recording 48): existing affirmation list is
  re-tested item-by-item — each is marked **keep** or **retire**, new ones
  added. (Output: a versioned per-client affirmation set.) Dosage: 8×
  morning + 8× night, mirror, 30–64 days, NO tapping in this phase (CKB §7).

## 7. What is deterministic vs intuitive (the AI-infrastructure map)

| Stage | Class | AI status |
|---|---|---|
| 1 Intake | deterministic | automatable now (ASR + extraction) |
| 2 Diagnostic (body-source) | **intuitive** | the learned core — predict body_source/theme from language; feedback-trained |
| 3 Statement construction | **deterministic grammar** | automatable now (constrained generation, §4) |
| 4 Execution | deterministic params | automatable (delivery) |
| 5 Integration/affirmations | deterministic grammar | automatable (inverse-clause generation + stay/go state) |

The ONLY non-deterministic core is Stage 2. Everything else is a formal
grammar over the client's verbatim language. **The product is buildable now
on Stages 1,3,4,5; Stage 2 is the model that learns.**

## 8. The learning loop (Adrian's LLM-native growth design — verbatim intent)

Every platform session emits a labelled tuple:
`{language_corpus, predicted_body_source, constructed_statement,
client_confirmation_deltas, post-session outcome (charge gone? behaviour
changed?), affirmation stay/go deltas}`.

- **Corroborate:** tuples where predicted body_source + statement →
  positive outcome reinforce the Stage-2 mapping and the §4 grammar weights.
- **Debunk:** negative-outcome or heavily-corrected tuples down-weight the
  pattern and flag it for review.
- Efficacy metric = (charge-discharge rate × durable behaviour change ×
  low correction-delta). The model optimises this over accumulated tuples.
- This is exactly an LLM fine-tuning / RLHF-shaped loop: SS sessions,
  Ashta clusters, Bodhisvara voice-matches all feed the SAME tuple schema.
  Platforms are data/feedback sources; this algorithm is the shared core.

## 9. GAPs (Adrian-input needed; do not invent — per anti-confab contract)
1. Full language→chakra/region heuristic table (Stage 2) — only partially in
   corpus; enrich from labelled sessions or Adrian dictation.
2. Frequency↔chakra exact mapping (Stage 4 step "Pythagorean frequency") —
   referenced, not fully specified in read corpus.
3. The XMAXED / multi-platform Grok+ChatGPT conversations are **not
   ingested** — bridge them into `working/external-research-in/` to
   cross-pollinate (separate from this algorithm, but the same data-loop
   principle applies to every venture's corpus).
4. Outcome-measurement instrument (how "charge gone / behaviour changed" is
   captured per platform) — design needed before the §8 loop can train.

## 10. Firewall (re-stated — load-bearing)
This document is the **mechanism**. It is strictly-private internal IP.
Public/client/marketing framing is and remains ONLY: *"Language is my
scalpel. I listen to how you frame what's blocking you. The proof is the
outcome."* No slot grammar, no muscle testing, no chakra/frequency, no
tapping is ever described externally. This file = source code, not copy.
