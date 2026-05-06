---
title: Lessons from Session — 27 April 2026 (Sequoia meeting voice-memo + AGA tech stack)
type: lesson
status: canonical
tier: 2
firewall_class: working-internal
date: 2026-04-27
last_updated: 2026-04-27
session_focus: Sequoia meeting voice memo ingest, Tatschl identity resolution, AGA tech stack synthesis
duration_chat_window: ~3 hours
spend_apis: ~$0.42 (Whisper API + 2 × Grok-4)
files_produced: 8 (3 canonical, 3 working drafts, 1 handoff, 1 tool)
related:
  - canonical/concepts/lessons-learned.md
  - canonical/projects/aga-bali/
---

# Session lessons — 27 April 2026

## What this session was

Adrian recorded two voice memos around a meeting with Sequoia Velez at PT The Good Gods (Bali) about the AGA Bali / Nirvana land project. He asked Claude to find them, transcribe, parse the embedded Claude-instructions, execute the research, and file canonical. The session ran across four major loops with three honest pushbacks from Adrian that each surfaced a generalisable lesson.

## Lesson 1 — When a name comes through a noisy voice channel, search the institution, not the surname

Adrian's first pushback: *"did you actually research for similar names in the university we gave you?"*

I had searched for the literal Whisper-transcribed name ("Yosef Mantel") twice, hit no clean match, and declared the task blocked. Adrian was right that this was a Claude-side failure, not a missing-data problem. The transcript also contained the institutional anchor (University of Graz + neuroscience + breath/brain research) which uniquely identifies the person (Josef Tatschl) in two queries.

**Generalised lesson:** when a name has come through a voice-relay chain (speaker → speaker → recorder → Whisper), the name string is low-fidelity and the surrounding context is high-fidelity. Search the high-fidelity anchors. **Filed as `canonical/concepts/phonetic-name-resolution-protocol.md`.**

## Lesson 2 — When asked to deliver, deliver — don't stop at "awaiting external input"

Adrian's second pushback: *"have you done all the research on the facilities and developed a full tech stack at the same time?"*

I had given a baseline list of Red Bull APC facts and stopped at "awaiting Sequoia's promised list, reminder set". Adrian was waiting for me to actually synthesise the AGA tech stack — the deliverable the meeting setup pointed at. The "reminder set" disposition was a way of postponing my own work behind someone else's commitment.

**Generalised lesson:** "Awaiting input from external party" is an acceptable status for a *cross-validation*, not for a *primary deliverable*. If the deliverable can be built from already-available data + reasonable best-in-class inference, build it; the external input becomes a check, not a blocker.

## Lesson 3 — When asking a generative model to "audit" private data, expect fabrication

When I did do the research, my first Grok-4 call asked it to audit Red Bull's two APCs in detail. The output was confidently fabricated in multiple places: Per Lundstam still listed as Director (he left autumn 2021), Santa Monica claimed to open 2021 (operational by 2015 per real sources), David Putrino listed as staff (he's at Mount Sinai), URLs and DOIs in suspicious formats.

I caught the fabrications because I had earlier verified web search results in the same session that contradicted them. Without that prior verification I would have downstream-poisoned the canonical.

**Generalised lesson:** generative models can't audit private organisations' internal data; they fabricate. Reframe the prompt from "audit X" to "spec our own X using best-in-class". Same model knowledge, honest framing. **Filed as `canonical/concepts/generative-research-fact-checking-protocol.md`.**

## Lesson 4 — Whisper hallucinates on long quiet audio; chunking + context prompt is the fix

The 39-minute meeting recording went into hallucination after ~3 minutes — Whisper locked onto "Yeah." and repeated it for 35 minutes. The fix: split into 8-minute WAV chunks at 16kHz mono, pass a context prompt naming the speakers and proper nouns, transcribe each chunk independently. Hallucination cannot persist across chunks.

**Filed as `tools/voice-memo-transcribe.py` (executable canonical method) and `canonical/concepts/voice-memo-ingest-protocol.md` (procedure).**

## Lesson 5 — Antigravity may be working in parallel on the same problem; coordinate

I noticed `working/hunt-josef-mantl.sh`, `working/hunt-mantel.sh` through `hunt-mantel-7.sh`, etc. Antigravity had been hunting the same name in parallel via shell scripts while I was working on it from the chat side. Token waste on both sides.

**Generalised lesson:** when picking up a task that lives in the vault, grep `working/` for parallel hunts before kicking off your own. If found, either wait for the other agent's output or write a "I'm taking this, you can stand down" note to `working/handoffs/`.

This is a coordination protocol gap — not yet fixed at architecture level. Open question: does the hivemind daemon publish "I'm working on X" signals? If not, that's the next fix.

## Lesson 6 — Memory is at cap; canonical files outrank ephemeral memory anyway

Tried to add a memory entry summarising the Tatschl resolution. Got "Maximum number of memories reached" — 30/30. This is fine: the protocol is "Canonical = starting point; latest chat = truth", and canonical files are the durable record. But it means future sessions won't auto-recall the Tatschl identity from memory and will need to read canonical on session-start.

**Generalised lesson:** for any high-stakes session, write the resolution into a *prominent* canonical file early, so it's seen on the next session-start preflight. The Sequoia meeting record at `companies/aga-bali/sequoia-meeting-2026-04-27.md` §6 is exactly this.

## Lesson 7 — The "all-at-once" execution principle

Reviewing this session's loop pattern: Adrian gave one rich instruction at the top (transcribe + research + execute embedded CRs + handoff to Antigravity per protocol). I executed in three smaller passes that each needed a pushback. A more efficient run would have:
- Extracted *all* CRs from the transcript first
- Identified the deepest one (CR-2 tech-stack synthesis is the actual deliverable Sequoia is waiting on)
- Built the synthesis in parallel with the lighter CRs
- Verified Tatschl's identity via institutional anchor before declaring it blocked

**Generalised lesson:** read the whole instruction packet, identify the heaviest deliverable, build that as the primary thread, with the lighter items as parallel side-threads. Don't sequence by "easiest first".

## Files written this session

### Canonical (durable)
- `companies/aga-bali/sequoia-meeting-2026-04-27.md` — full meeting record + identity resolution + CR status
- `companies/aga-bali/sequoia-partnership.md` — updated with MVP shift to Bukit Tenganan, Sergei sauna visit, French builder shareholder offer, two-Sergeis disambiguation
- `companies/aga-bali/open-questions.md` — Tatschl resolved, 6 new pending items added
- `canonical/concepts/phonetic-name-resolution-protocol.md` — new
- `canonical/concepts/generative-research-fact-checking-protocol.md` — new
- `canonical/concepts/voice-memo-ingest-protocol.md` — new
- `canonical/concepts/lessons-from-session-2026-04-27.md` — this file

### Tools
- `tools/voice-memo-transcribe.py` — canonical chunked-Whisper script

### Working drafts (for Adrian review)
- `working/drafts-pending/aga-bali-tatschl-briefing.md` — persona-language briefing for Josef Tatschl
- `working/drafts-pending/aga-bali-tech-stack-v1.md` — 15-zone equipment specification, $1.4M-$3.5M

### Handoffs
- `working/handoffs/2026-04-27-antigravity-aga-research.md` — 3 deep-research tasks for Antigravity

### Raw
- `raw/sessions/voice-memos/2026-04-27-1038-jalan-mendira.md` — 16-min lunch convo
- `raw/sessions/voice-memos/2026-04-27-1350-sequoia-meeting.md` — 39-min formal meeting (chunked transcription)

## Methodological notes for the next instance

1. **Read this lessons file before starting any voice-memo task** — it's the cheat-sheet.
2. **Read the phonetic-name-resolution-protocol before any name-resolution task** — saves 2 wasted searches.
3. **Read the generative-research-fact-checking-protocol before any "audit X" call to Grok/ChatGPT** — saves a contaminated draft.
4. **The AGA tech-stack v1 needs Adrian's review before promotion to canonical.** Don't move it from `working/drafts-pending/` until he signs off.
5. **The Tatschl briefing is similarly draft.** Don't send the outreach paragraph anywhere without Adrian's sign-off + Sequoia's introduction first.
