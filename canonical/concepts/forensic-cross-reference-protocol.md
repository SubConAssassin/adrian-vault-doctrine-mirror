---
title: Forensic Cross-Reference Protocol
type: doctrine
priority: critical
created: 2026-04-29
status: active
applies_to: [claude, antigravity, all-future-instances]
trigger: multi-source topics, legal disputes, financial exposure, contract/negotiation, anything where subtle nuance changes the posture
---

# Forensic Cross-Reference Protocol

**The default Claude behaviour is to answer from whatever context is in the chat window. That default is wrong for legal, financial, and multi-source topics. This doctrine overrides it.**

The metaphor Adrian uses: behave as though the entire history is **synapses in your mind**, not a database you query reactively. Cognized, internalised, embodied — not looked up after being corrected.

---

## When this protocol activates

Apply this protocol whenever ANY of the following conditions are met. If in doubt — apply it.

1. **Named legal dispute or party** is mentioned (Erica, customs, BMN, any new dispute).
2. **Financial exposure or contractual obligation** is in play.
3. **Three or more vault files** touch the topic.
4. **Adrian uses words like** "review", "assess", "analyse", "strategise", "evaluate", "what should I do about", "is this right".
5. **A new external document** lands (inbound letter, email, PDF) that needs cross-referencing against existing case context.
6. **Adrian flags a possible error** in prior reasoning (e.g. "didn't we already discuss this", "you forgot that", "I already gave you").
7. **Multiple sources may contradict each other** (canonical vs raw chat vs recent inbound).

If activated: **execute steps 1–11 below BEFORE responding substantively.** Do not skim. Do not skip.

---

## The eleven steps

### 1. Inventory all sources
Find every file in the vault that touches the topic. Use shell `find` with multiple keywords. Cover at minimum:
- `canonical/people/` (contact cards)
- `canonical/cases/` (case briefs)
- `canonical/projects/<project>/` (project canonical)
- `canonical/projects/<project>/legal/` if legal
- `raw/chats/` and `raw/chatgpt-import/` (chat exports)
- `raw/sessions/` (session notes)
- `episodic/sources/` (ingestion briefs)
- `working/handoffs/` (cross-agent handoffs)
- `working/drafts-pending/` (in-flight drafts)
- `transcripts/` (audio transcripts)
- `working/extraction/staging/` (pre-extracted document text)
- Any folder outside vault that holds case docs (`Siberian blue promo/`, `Adrian-Archive/`, `Downloads/`)

**Print the inventory.** Don't proceed until it's visible.

### 2. Read each source fully
Not headers. Not first 20 lines. Full read on every relevant file. If a file is huge, read in chunks but read it all. Multiple sources beats one source even if reading them is slower.

### 3. Cross-reference past chats
Run `conversation_search` with at least three different angles on the topic:
- The named party / project
- The specific event or document under discussion
- Any technical or legal term that might surface relevant prior reasoning

If a chat result references a fact, verify the fact against canonical. If they disagree, **the chat usually wins** (canonical files fossilise).

### 4. Extract any new external inputs
If Adrian provides a PDF, email, letter, screenshot — extract the text immediately into vault. Use pypdf, pdftotext, or extraction-staging. Save the extracted text in a discoverable location (e.g. `canonical/projects/<project>/legal/<party>/inbound-letters/`). Don't analyse from memory; analyse from extracted text.

### 5. Staleness check
Compare canonical files against latest chat reality. Flag any contradictions explicitly. **The canonical does not get the benefit of the doubt against fresh chat evidence.** If a canonical file says "police report filed" and chat says "police report rejected today," the chat wins and canonical gets corrected immediately.

### 6. Contradiction scan
Where two sources disagree, surface that explicitly. Don't pick one and move on silently. Examples:
- Canonical says A, raw chat says B → flag, ask Adrian, fix the loser
- Two canonical files give different figures → flag, ask Adrian, fix the loser
- Adrian's stated position now differs from his stated position 3 weeks ago → flag, ask which is current

### 7. Build a master synthesis
For any dispute or multi-source topic of consequence, write a single MASTER file at `canonical/<scope>/MASTER-CASE-FILE.md` (or topic-appropriate name). This file:
- Has a TL;DR
- Has a HARD RULES block at the top (immutable rules that future sessions must not violate)
- Maps all parties
- Has a full timeline
- Has an evidence chain with file paths or "TBC" markers
- Has a track-by-track legal/financial/strategic position section
- Has a current-status section
- Has an open-questions section
- Has cross-references to all subsidiary files

The master file is the single source of truth. If anything else contradicts it, the master wins until corrected.

### 8. Hard-rules block
Extract any immutable rule (something that, if violated, materially harms Adrian) into a top-of-file numbered list. These never get drowned in prose. They get re-stated, in full, every time the master file is updated. Examples from the Erica case:
- "Never cite Recording 68."
- "OSB and SS are separate businesses; no netting."
- "Ganesha pendants are resolved; never raise."

A hard rule that lives only in prose is a hard rule that will be forgotten under load.

### 9. Point obsolete files at the master
Older case briefs, scattered notes, and partial summaries get a `canonical_pointer:` field in their frontmatter pointing at the master. Their TL;DR notes they are superseded. Do not delete — keep for audit trail. Do not let them be read as authoritative.

### 10. Persist immutable rules across sessions
For any rule that must survive context loss:
- Add to `memory_user_edits` (lives across all Claude sessions)
- Write a dedicated `rule-<name>.md` file in the vault (lives across all Antigravity sessions and any other vault-aware agent)

A rule held only in chat memory will not survive. A rule held only in vault may not survive a new chat that starts before vault is read. Both belts and braces.

### 11. Report comprehensively
After steps 1–10, report to Adrian with:
- What was found (sources read)
- What was corrected (errors that had been carried)
- Where the new master file lives
- Open questions / gaps
- Recommended next actions, ranked

Do not present analysis as if it were complete if step 1–10 weren't actually done. Honesty about coverage matters more than appearance of authority.

---

## Failure modes this protocol prevents

The Erica session of 29 April 2026 surfaced these failure modes — all of which this protocol exists to prevent:

1. **Asking for information that's already in the vault** — happens when step 1 (inventory) is skipped.
2. **Citing a contested recording in a draft filing** — happens when step 8 (hard rules at top) wasn't being maintained.
3. **Conflating two separate businesses into one ledger** — happens when step 6 (contradiction scan) is skipped.
4. **Reporting "police report filed" when it was rejected** — happens when step 5 (staleness check) is skipped.
5. **Giving half-cooked analysis from partial context** — happens when step 2 (full read) is skipped.

Every one of these is a **legal-exposure** failure mode. None of them is theoretical.

---

## What "synapses in your mind" actually means in practice

When Adrian uses this metaphor, he is saying: do not treat the vault as an external database to query reactively. Treat it as your own internalised memory — present, accessible, weighted by relevance, available to all reasoning without explicit lookup.

Mechanically, Claude cannot literally do this. The vault is in fact external. But Claude can simulate it by:
- Reading proactively, not reactively
- Holding the full context in working memory while reasoning
- Refusing to answer multi-source topics from chat-window context alone
- Treating any "I don't have that" instinct as a signal to search, not to ask

The test: would a human lawyer with full file knowledge make the response Claude is about to make? If the response only works because of something Claude doesn't actually know, the response is wrong.

---

## Cross-references

- `companies/original-siberian-blue/legal/erica/MASTER-CASE-FILE.md` — first instance of this protocol applied
- Memory edit #28 — pointer to this doctrine
- `working/handoffs/2026-04-29-session-closeout-erica-deep-synthesis.md` — session that produced this doctrine
