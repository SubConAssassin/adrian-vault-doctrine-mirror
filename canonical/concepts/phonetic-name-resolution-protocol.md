---
title: Phonetic Name Resolution Protocol
type: canonical-procedure
priority: HIGH — applies any time a name comes via voice-relay (Sequoia/Adrian/Whisper chain)
created: 2026-04-27
distilled_from: "Yosef Mantel" → Josef Tatschl resolution (Sequoia meeting voice memo)
---

# Phonetic Name Resolution Protocol

## The failure mode

Names in voice memos arrive through a multi-hop transmission that introduces consistent drift:

1. **Original speaker** says the name in their native phonetic register (e.g. Sequoia, an Oklahoma-American who lived 10 years in Austria, says "Josef Tatschl" with softened German consonants).
2. **Adrian** repeats the name into his own recorder, hearing it through his English-language ear and producing the closest English match (Josef → "Yosef").
3. **Whisper** (English acoustic model) transcribes Adrian's repetition, locking onto the closest English-phonetic word for the unfamiliar surname (Tatschl → "Mantel").
4. **Claude** receives "Yosef Mantel" with no flag that the surname is unverified.

Result: a name that sounds plausible, has zero web presence, and stalls research if Claude searches the literal string.

## The wrong move (what I did first)

Search the literal transcribed string. Web search returns a Vienna PR consultant (different Josef Mantl) who half-matches and confuses things further. After two empty queries Claude declares "no match, blocked, awaiting Adrian's clarification."

This is **the failure** — Claude is sitting on enough side-channel information to crack it without Adrian's help.

## The right move

**Pivot from the consonant cluster to the institutional anchor.** Every voice-memo name comes attached to context: an institution, a discipline, a city, a role, a research topic. That context is high-fidelity (it survives the voice-relay chain because it's described, not pronounced) while the name string itself is low-fidelity. Search the high-fidelity context, not the low-fidelity string.

For "Yosef Mantel": the recording also said "University of Graz", "neuroscience / brain-wave research", "Red Bull head coach", "documentary on Netflix". Searching `"Universität Graz" sport psychology neuroscience breath` returns Josef Tatschl in the top results — a phonetic neighbour of "Mantel" once you see it side-by-side, with a perfect topical match (resonance breathing × cardiac vagal activity, Section for Health Psychology).

## The protocol

When a name from a voice-memo source returns no clean web hits in two searches:

### Step 1 — Catalogue the side-channel anchors

From the surrounding transcript, list:
- **Institution** (university, company, hospital, lab)
- **Discipline / topic** (neuroscience, breath research, structural engineering, etc.)
- **City / region** (Graz, Klagenfurt, Salzburg)
- **Role / title** (head coach, principal investigator, founder)
- **Notable artefacts** (documentary, paper, product, athlete connection)

### Step 2 — Search the strongest anchor pair

Skip the name entirely. Search `<institution> <discipline>` or `<discipline> <city> <role>`. Most academic and professional contexts are unique enough that two anchors return the right person without the surname.

### Step 3 — Phonetic neighbour check

Once a candidate is in hand, sanity-check the phonetic distance:
- Cluster substitutions (Tatschl ↔ Mantel: both are 6-letter consonant-heavy German surnames; soft "tsch" can collapse to "nt" via voice relay)
- First-letter drift (Yosef = Josef in German)
- Vowel preservation (almost always preserved; consonant clusters are what mangle)

### Step 4 — Triangulate with one more anchor

Don't lock the identification on one match. Verify with one more side-channel anchor before committing. For Tatschl: confirmed by his ICBM 2025 award and his published methods aligning exactly with the meeting description ("breath ↔ brain", "data set across athletes").

### Step 5 — File the lesson, not just the answer

Write the resolution to canonical with the phonetic chain made explicit, so the next instance of Claude sees the pattern, not just the corrected spelling.

## Common voice-relay drift patterns to watch for

| Original | Drifts to | Trigger |
|---|---|---|
| German "Josef" | "Yosef" | English-speaking ear |
| German "tsch" cluster | "nt" / "mt" / "nch" | Whisper acoustic model |
| Indonesian "ng" | dropped | American accent |
| Indonesian "Bukit Tenganan" | "Bukit Tannerman" | English approximation (Adrian self-corrected this one mid-recording) |
| Russian "ei" diphthong | "ay" | English vowel mapping |
| French "u" | "oo" | English vowel mapping |
| Sanskrit retroflex consonants | English alveolars | Always |

## The general principle

**Side-channel data is more reliable than direct data when the direct data has been through a noisy channel.** Adrian's voice memos are noisy channels. The transcript content (what was said about the topic) is high-fidelity. The transcript phonetics (how unfamiliar names were spelled) are low-fidelity. Trust the content, not the phonetics.

This applies beyond names: place names, technical terms, song titles, foreign-language phrases — anything that crosses a phonetic boundary in the chain has been corrupted and needs the same anchor-search treatment.

## Cross-references

- `canonical/projects/aga-bali/sequoia-meeting-2026-04-27.md` §6 — full Tatschl resolution case study
- `tools/voice-memo-transcribe.py` — chunked Whisper pattern with context prompt; the context prompt itself is a partial defence against this drift (Whisper anchors on names in the prompt vocabulary)
- `canonical/concepts/lessons-from-session-2026-04-27.md` — session-level lessons including this one
