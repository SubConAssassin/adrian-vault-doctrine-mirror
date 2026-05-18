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
6. **§7 firewalled-name disambiguation (Adrian-directed 2026-05-18).** The §7 hard-rule name "Chelsea" refers ONLY to Adrian's ex-girlfriend (quarantined personal-relationship material — never surfaced). A **client named Chelsea/Chelsee** appearing in Mastermind / SS-client / talks / coaching content is a DIFFERENT, legitimate person: attribute and process her normally like any student — do NOT redact, skip, or firewall. Context disambiguates; the firewall is the ex only. If genuinely unsure which, STOP-and-ASK Adrian — never guess in either direction.

## 2. Speaker attribution method (tiered)

**Cardinal correction (Adrian, 2026-05-18):** the source data is per-message named. There is *no real ambiguity* for message archives — every voice/text message is individually attributed in the platform export. The `sender: Tristan/Adrian` frontmatter is a **thread-participants placeholder**, NOT a per-message label, and must NEVER be treated as resolved truth or used to guess. AG's failure was ignoring the available source naming and inventing attribution. The tiers, in priority order:

- **Tier S — Source-export join (AUTHORITATIVE, deterministic; the interim path, do NOW).** Every message archive (WhatsApp/iMessage/messenger) has a platform export (`_chat.txt`, format `[DD/MM/YYYY, HH:MM:SS] Sender: text`) that names every message. Resolve each per-message transcript's true sender by **joining it to its export line by timestamp/order**. This is a data join, not inference — zero ambiguity, no acoustic required. Replace the `sender: X/Adrian` placeholder with the joined per-message sender. Prerequisite: locate the source export per archive (the tristan/stefi audio was extracted from an export; the `_chat.txt` must be located/restored — the join key is timestamp).
- **Tier M — Mastermind name-anchor context protocol.** Group sessions are the ONLY genuinely un-named multi-speaker case. Use `canonical/brand/adrian-speaker-attribution-mastermind-protocol.md` (the Adrian-directed 2026-05-17 name-anchor method) + chronology + addressing cues. Interim, pending acoustic verification.
- **Tier 0 — Acoustic (gold standard / verification; NOT a prerequisite for Tier S).** `tools/voiceprint-diarize.py` (ECAPA voiceprint, local, £0). Most accurate; use to *verify* Tier S/M and to resolve genuinely un-named audio. Environment currently blocked (speechbrain/torch need a py3.11 venv; ECAPA model cached). **Do NOT block the named-message corpus on this** — Tier S stands on its own.
- **No guess tier.** Anything not resolvable by S, M, or 0 is `SPEAKER_UNVERIFIED` — flagged, never assigned. The thread-participants placeholder is not a resolution.

Priority where they conflict: Tier 0 (acoustic) > Tier S (source export) > Tier M. In practice Tier S is deterministic and sufficient for message archives; acoustic is confirmation.

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

## 6. Execution plan (Claude-direct forensic; memory-safe)

**Interim track — Tier S (do now, no blocker):**
1. **Locate the source exports.** For tristan-archive / stefi-archive / each message archive, find or restore the platform `_chat.txt` (or messages.json) the audio/messages were extracted from. This is the join key holder.
2. **Build the deterministic join.** Map every per-message transcript → its export line by timestamp/order → write the TRUE per-message sender, replacing the `sender: X/Adrian` placeholder. This is the speaker truth for message archives — no acoustic needed.
3. **Claude-direct grounded re-synthesis** of the joined corpus per §3/§4 (verbatim quotes, true sender, Adrian's hedged language preserved and characterised non-advisory, neutral source-bounded summary, no legal template). Subagents for breadth extraction only; Claude adjudicates every Adrian characterisation.

**Gold-standard / verification track — Tier 0 (parallel, not blocking):**
4. Fix the diarizer env (py3.11 venv, `tools/requirements-diarize.txt`; ECAPA cached), build Adrian's voiceprint, diarize as **verification** of Tier S and as the resolver for genuinely un-named audio. Memory-safe (small batches, write-and-release, ≤2 concurrency, checkpoint — the protocol that held 2026-05-18).

**Mastermind — Tier M:** apply the name-anchor protocol; acoustic-verify later.

**Always-on:** AG contract amendment (§5) is wired. No synthesis ships whose every attribution is not Tier S / M / 0 grounded; the thread-participants placeholder is never a resolution. Tier S is sufficient and is the unblock — do not wait on acoustic for the named corpus.
