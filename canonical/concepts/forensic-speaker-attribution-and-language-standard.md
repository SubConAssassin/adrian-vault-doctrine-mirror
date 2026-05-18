---
title: Forensic Speaker-Attribution & Language Characterisation Standard
type: concept-doctrine
status: canonical
tier: 1
firewall_class: working-internal
created: 2026-05-18
authority: Adrian-directed (2026-05-18) after the AG confabulated-legal-apparatus incident
owner: Claude (forensic auditor — Adrian-designated, Claude-direct, non-delegable adjudication)
governs:
  - the rebuild of the Stefi/Tristan (and all SS-client) corpus from RAW transcripts
  - canonical/concepts/antigravity-operating-contract.md (AG prompting amendment)
  - all future synthesis of Adrian's coaching/client material
supersedes_practice: the quarantined AG "Forensic Synthesis" template (episodic/review/2026-05-18-AG-confabulated-stefi-library-QUARANTINE/)
---

# Forensic Speaker-Attribution & Language Characterisation Standard

## 0. Why this exists

On 2026-05-18, Claude-direct verification proved Antigravity had built a **fabricated legal-accusation apparatus** over benign coaching audio: ~89% of quotes unattributable, raw multi-party transcripts undiarized, ~110+ files imposing an invented "UPL / malpractice / financial-fraud / stalking" template, with contamination propagated into `legal/` aggregates about named real people. That library is quarantined. This standard is the corrected method. It is **Tier-1 canonical** and binds every operator (Claude, AG, automation).

The corpus, read correctly, is **exculpatory**: it shows Adrian was deliberately non-advisory and autonomy-preserving. The forensic job is to establish that truth rigorously — not to manufacture a case for or against anyone.

## 1. Cardinal rules (non-negotiable)

1. **Zero false attribution.** No utterance is attributed to a speaker unless that attribution is acoustically grounded (Tier 0) or Tier-1 high-confidence. Everything else is explicitly marked `SPEAKER_UNVERIFIED` — never silently guessed into false certainty.
2. **Zero confabulated framing.** Every characterisation must cite the exact verbatim source line. If a word/claim/intent is not in the source, it cannot be written. No inferred intent, no escalatory verbs absent from source.
3. **Preserve, do not recast, Adrian's hedged language.** See §3. Recasting conditional/non-advisory speech as "advice", "instruction", "legal strategy", "UPL", "malpractice", or any accusatory frame is **confabulation** and is rejected on sight.
4. **No "case" construction.** Synthesis produces neutral, source-bounded summaries. It does NOT assemble accusations, "legal materiality", "admissions registers", or "malpractice schemas". Legal characterisation is a human/lawyer act on grounded evidence, never an AI synthesis default.
5. **STOP-and-ASK over infer.** Any ambiguity in speaker or intent → flag and ask. Never resolve ambiguity by fabrication.

## 2. Speaker attribution method (tiered; acoustic is authoritative)

The raw transcripts are undiarized Whisper dumps (`sender: Tristan/Adrian`, no per-utterance labels). Text alone CANNOT yield correct attribution — proven. Therefore:

- **Tier 0 — Acoustic (authoritative, overrides all text tiers).** `tools/voiceprint-diarize.py`: build Adrian's ECAPA voiceprint from his known-solo clips (`working/deep-extraction/transcripts/voice-memos/*`), then per-turn "Adrian vs not-Adrian" by embedding similarity on every multi-speaker recording. Local, £0. **Environment prerequisite (currently blocked):** speechbrain/torch require a Python 3.11 venv (`tools/requirements-diarize.txt`); system Python is 3.14. ECAPA model already cached at `~/.cache/huggingface/.../spkrec-ecapa-voxceleb`. Fixing this env is the first execution step.
- **Tier 1 — Text fallback (only where audio is genuinely unavailable).** `canonical/brand/adrian-speaker-attribution-lexicon.md` + `adrian-speaker-attribution-mastermind-protocol.md` + chronological echo resolution + role/greeting cues. Whisper Americanises British speech → the spelling channel is INVALID for audio-derived text (lexicon §3). Output an explicit confidence; anything below high-confidence = `SPEAKER_UNVERIFIED`.
- **Tier 2 — none.** There is no "reasonable guess" tier. Unprovable = flagged, not assigned.

Acoustic (Tier 0) overrides any conflicting text inference, always.

## 3. Adrian's language signature — the characterisation rubric

Adrian's directive, 2026-05-18, verbatim intent: *he never offered advice (legal or medical) and repeatedly stated he could not; he offered his thoughts/feelings on the prediction of outcomes based on his testing process; ultimately the client must make their own decision; he discusses it carefully in that frame.*

The forensic standard for every Adrian turn:

- **Preserve the exact hedging verbatim.** Quote, do not paraphrase, his qualifying language: "I can't advise you", "this is only my thoughts/feelings", "based on my testing process", "this is potential / a possibility", "what I would do if I were in that position", "ultimately you have to make your own decision".
- **Characterise it accurately** as: non-advisory, conditional/hypothetical, prediction-of-outcome framed, client-autonomy-preserving.
- **PROHIBITED characterisations** (any of these applied to Adrian's hedged speech = confabulation, auto-reject): "advice", "advised", "legal/medical advice", "instructed", "directed", "strategy", "unlicensed practice of law / UPL", "malpractice", "coercion", "weaponising", "exploitation" — unless the **source verbatim itself** unambiguously contains the act, in which case quote it and characterise neutrally, never escalate.
- **The test:** if a synthesis sentence about Adrian were read back to him, would he recognise it as a faithful, non-escalated rendering of what he actually said? If not, it fails.

## 4. Output contract (per-conversation rebuild)

Each rebuilt file:
- Frontmatter: real provenance (`source_audio`, `source_transcript`, `diarization_method: tier0|tier1`, `firewall_class: strictly-private-legal-personal`). No boilerplate `grounding_attestation` — attestation must state the actual method used or say `UNVERIFIED`.
- Verbatim quotes only, each tagged with grounded speaker + tier + confidence.
- A neutral, source-bounded summary. Adrian's turns characterised per §3.
- Explicit `GAP:`/`SPEAKER_UNVERIFIED:` markers wherever provenance or speaker is not grounded.
- **No** "Legal Materiality", "Relational Dynamics" accusation, "Malpractice", or "Admissions" sections. Those are removed from the template entirely.

## 5. Antigravity prompting amendment

`canonical/concepts/antigravity-operating-contract.md` is amended: AG is **prohibited** from (a) assigning a speaker without Tier-0 grounding, (b) applying any legal/accusatory template, (c) inferring intent or escalating source language. On any speaker/intent ambiguity AG must STOP-and-ASK via an `ag-to-claude` question, never synthesise through it. AG produces extraction + neutral summary only; all characterisation of Adrian's language follows §3. (To be wired in full as a follow-on step in this mission.)

## 6. Execution plan (Claude-direct forensic; massive resource use; memory-safe)

1. **Fix the Tier-0 environment** — create the py3.11 venv, `pip install -r tools/requirements-diarize.txt`, smoke-test `voiceprint-diarize.py` on one recording. (Honest blocker today; first task.)
2. **Inventory the real audio corpus** — confirm what is actually in `working/deep-extraction/transcripts/audio/` and which raw transcripts have recoverable audio (Tier 0 eligible) vs text-only (Tier 1, lower-confidence, flagged).
3. **Build Adrian's voiceprint reference** from known-solo clips.
4. **Diarize all multi-speaker recordings**, memory-safe (small batches, write-and-release, ≤2 concurrency, checkpoint each batch — the protocol that held on 2026-05-18; the earlier crash was memory pressure).
5. **Claude-direct re-synthesis** per §3/§4 — Claude adjudicates every Adrian characterisation; subagents only for breadth extraction, never for the attribution/characterisation judgement.
6. **Wire the AG contract amendment** (§5) so this can never recur.

Sequence is fixed. Speaker truth (Tier 0) precedes any synthesis. No synthesis ships before this standard's checks pass.
