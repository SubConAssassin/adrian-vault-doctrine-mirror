---
title: Deep Corpus Pass Methodology — for Voice/Persona Synthesis
type: process-doctrine
created: 2026-05-02
status: active
authorisation: Adrian's direct instruction 2026-05-02 — *"once we've processed all the audios that we already had in the transcriptions and integrated it fully using all of the advice and techniques and learning that we've had from this session we can then do the same with the new information and build on it and build on it and build on it"*
---

# Deep Corpus Pass Methodology

A repeatable process for ingesting audio/transcription material into Adrian's voice/persona architecture. Designed for incremental application — each wave of new uploads gets the same treatment, building on prior synthesis without losing prior work.

## When to invoke this process

- New batch of audio recordings transcribed and landed in `raw/sessions/` or sub-folders
- New batch of mastermind/client/teaching material added to `canonical/adrian-corpus/`
- Discovery of corpus material that was never deep-processed (the 2026-05-02 audit revealed 64 such files)
- Adrian explicitly requests "do the same with the new information and build on it"

## Phase 1 — Survey

Goal: know the scope before reading. Never claim coverage you haven't verified.

**Steps:**
1. List all new files in the corpus. Output: filename, date, file size, location.
2. Quick categorisation — sample-read first 30-50 lines of each. Categorise as:
   - **SS-1on1** (Adrian doing 1:1 SS session with client)
   - **SS-cohort** (group teaching / mastermind cohort)
   - **SS-methodology-Q&A** (someone asking about methodology / supervision)
   - **Self-narrative** (Adrian dictating to himself)
   - **Sales call** (intake / discovery / commercial)
   - **Other** (specify)
3. Cross-reference hashes with previously-processed files to avoid re-reading. Maintain a running ledger at `canonical/adrian-corpus/_corpus-coverage-ledger.md`.
4. Flag firewall classification per file in advance:
   - Client-specific session content → STRICTLY PRIVATE
   - Methodology teaching → WORKING-INTERNAL
   - Philosophy framing → WORKING-INTERNAL → public-shareable subtly

**Honesty rule:** if you sample, mark as sampled. If you deep-read, mark as deep-read. Never overclaim coverage.

## Phase 2 — Deep-read pass (parallel agents)

Goal: extract voice/persona features at scale without overwhelming a single context window.

**Steps:**
1. Partition the corpus by category and size. Aim for 7-15 files per agent.
2. Spawn parallel general-purpose agents (NOT Explore — Explore reads excerpts only). Each agent gets:
   - The corpus subset to read
   - The existing canonical context to compare against (`personas/persona-the-{slug}.md`, `voice-profile.md`, `persona-catalog.md`, `personal-facts.md`, `belief-system.md`)
   - The extraction brief (below)
   - Output destination: `working/handoffs/2026-MM-DD-deep-corpus-pass-{batch-name}.md`
3. Run agents in background; do non-overlapping work while waiting.

**Per-file extraction brief (binding for every agent):**
1. Date and context (audience type, mode)
2. **8-12 verbatim quotes** that capture distinctive voice (no paraphrasing)
3. **Vocabulary** — technical terms, phrases, metaphors not already in canonical
4. **Authority moves** observed — credibility-establishment patterns
5. **Loop rhetoric instances** — open-excursion-close patterns with quoted passages
6. **Philosophy chain references** — Arcturian / Quan Yin / Christ Consciousness / Sheldrake / Burning Man / Venus Project / Ashta / synchronicity / oneness / telepathy / unconsciousness frame
7. **Banned phrases NOT used** (negative space) — what does Adrian conspicuously avoid?
8. **Sub-register identification** — does this reveal a mode the existing card collapses?

**Per-agent synthesis (binding):**
9. Where existing card is wrong/weak — quote what should change
10. Sub-register identification — propose if 2-4 distinct modes emerge
11. Any new persona not in catalog
12. Firewall classifications applied

**Style binding for all agents:**
- Forensic, corpus-grounded, no flattery
- If existing claims are wrong, say so with quotes
- Adrian's standard: "genuine independent analysis, not polite agreement"

## Phase 3 — Synthesis & integration

Goal: integrate agent findings into canonical without losing prior work.

**Steps:**
1. Read all agent reports.
2. **Per persona card:**
   - Identify confirmed features (multiple agents corpus-grounded the same observation)
   - Identify disputed features (one agent's claim contradicts another)
   - Identify NEW features (in agent reports, not in current card)
   - Identify weakened claims (existing card overstates what the corpus actually supports)
3. Update the persona card:
   - Preserve confirmed features
   - Add new features with corpus citations
   - Revise/remove weakened claims with notes on what changed
   - Add sub-register sections if 2+ agents identified the same sub-mode
4. Update `voice-profile.md` if cross-persona patterns emerge.
5. Update `persona-catalog.md` if new persona is justified or existing one needs reframing.
6. Update `_corpus-coverage-ledger.md` to mark processed files.

**Honesty rule:** corpus citations are mandatory for any new claim. Filename + (where possible) line range.

## Phase 4 — Build-on-it (incremental)

Goal: each new wave of uploads compounds the synthesis without restarting.

**When new corpus arrives:**
1. Run Phase 1 survey on the NEW material only
2. Run Phase 2 deep-read pass on the NEW material with **the most recent persona card as comparison baseline**
3. Run Phase 3 synthesis as a **revision**, not a rewrite — cumulative additions, with version log

**Versioning rule:** each persona card gets a revision-log section documenting what each corpus pass contributed. So the lineage of every claim is traceable.

## Anti-patterns (never do these)

| Anti-pattern | Why it's wrong |
|---|---|
| Claim "12 transcripts deep-read" when 3 were deep-read and 9 sampled | Overclaiming coverage produces false confidence in synthesis |
| Spawn one agent for 64 files | Single context overflow; agent will sample-read late files |
| Skip Phase 1 survey | You don't know what's there; can't partition; can't dedupe |
| Use Explore agent for deep extraction | Explore is for pattern search, not synthesis; reads excerpts only |
| Write canonical updates without corpus citations | Future sessions can't verify; doctrine drifts |
| Rewrite persona card from scratch each pass | Loses incremental synthesis; breaks build-on-it pattern |
| Treat agent output as authoritative without verification | Agents synthesise; their claims need cross-check against quotes they cite |

## Specific corpus locations to monitor

| Location | Likely content | Last processed |
|---|---|---|
| `canonical/adrian-corpus/mastermind/` | SS group/cohort teaching, intake calls, business consulting | 2026-05-02 (full pass) |
| `canonical/adrian-corpus/session-transcripts/by-date/` | SS sessions + self-narrative + other 2019–2026 | 2026-05-02 (full pass) |
| `canonical/adrian-corpus/session-transcripts/by-client/` | (empty as of 2026-05-02) | — |
| `canonical/adrian-corpus/self-narrative/` | Adrian's own dictations | Ongoing — 2026-05-02 dictation 3 most recent |
| `raw/sessions/rode-rec-transcripts/` | Rode-recorded SS sessions | 2026-05-02 (full pass) |
| `raw/sessions/phone-app-uploads/` (incoming) | Adrian's phone-app recorded SS material | Awaiting upload 2026-05-02 |
| `raw/web-clips/subconscious-surgery/` | (empty as of 2026-05-02) | — |

## How to invoke this process

Adrian's trigger: **"do the same with the new information"** or any variant of "process the new audios" / "build on it" / "integrate the new material."

Claude executes:
1. Phase 1 survey (filesystem + ledger check)
2. Spawn parallel agents per Phase 2
3. Synthesize per Phase 3
4. Update ledger per Phase 4
5. Report integration changes to Adrian

## Provisional status of persona cards

A persona card is **PROVISIONAL** if it claims corpus coverage that has not been verified per Phase 1 + Phase 2. Provisional status must be flagged in card frontmatter (`status: provisional pending deep corpus pass`).

A persona card becomes **STABLE** when:
- All corpus locations the card claims to source from have been deep-read (not sampled) by at least one agent or Claude directly
- Each major claim has a verifiable quote citation
- Cross-persona patterns the card asserts are documented in voice-profile.md

A persona card becomes **CANONICAL** when:
- Adrian has reviewed and accepted

The corpus coverage ledger tracks which cards are at which stability level.

---

*Methodology authorised by Adrian 2026-05-02. Filed by Claude. Apply to all subsequent voice/persona synthesis work.*
