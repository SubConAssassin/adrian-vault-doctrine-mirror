---
title: Session Archive Protocol — Full Chat Knowledge Capture
type: canon
status: canonical
created: 2026-04-22
tags: [adrian-os, hive-mind, knowledge-capture, session-management, archive]
related:
  - canonical/concepts/shutdown-protocol.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
  - canonical/concepts/bridge-protocols.md
---

## Thesis

The handoff note captures *what was decided*. The session archive captures *how we got there*.

Handoff notes are operational continuity. Session archives are institutional memory — the reasoning chains, the failed approaches, the breakthroughs, the challenges, the fixes — everything that makes a future Claude instance genuinely understand *why* things are the way they are rather than just knowing *that* they are.

This is the Claude equivalent of the ChatGPT export. It is the answer to 'wouldn't having all the thought processes help you learn?' — yes, and this is how we capture them.

---

## Where archives live

Adrian-Vault/
  raw/
    sessions/
      YYYY-MM-DD-HHMM-slug.md    <- session archives (raw, permanent record)

Archives are raw material, not canonical. They are the source from which canonical is distilled. Never deleted.

---

## When an archive is written

An archive is written at every session shutdown (Step 0 of Shutdown Protocol) if ANY of:
- A new topic or project was discussed
- A problem was encountered and solved (or failed to solve)
- A decision was made with non-trivial reasoning
- A fix was applied to any system, script, or process
- A challenge blocked progress
- A new approach, framework, or idea was proposed
- A prior assumption was revised

Skip only for pure status-check sessions (Adrian said u, Claude reported, nothing else happened).

---

## Archive schema

---
title: Session Archive — slug
date: YYYY-MM-DD
time_bali: HH:MM ICT
session_id: 4-char hex
projects: [osb, subconscious-surgery, aga-bali, ashta, tri-hita, etc.]
people: [list any person discussed]
concepts: [list any concept, framework, tool, protocol discussed]
status: raw
processed_by_antigravity: false
---

## Topics covered this session
Bulleted list of every distinct topic discussed, 1 line each

## Reasoning chains
For each significant decision: what was the question, what options were considered, what was chosen and WHY, what was rejected and WHY

## What was tried and didn't work
Failed approaches, dead ends, rejected options with the reason they were rejected. As valuable as what succeeded.

## Fixes and solutions found
Technical fixes, process improvements, workarounds. What broke, what fixed it, why it works.

## Challenges encountered
What blocked progress. Still-open blockers. Partial solutions.

## Key decisions made
Decisions with full context — not just the outcome but the situation that produced it.

## Ideas raised (not yet decided)
Proposals, suggestions, possibilities floated but not actioned. Includes unanswered questions.

## Cross-references
Every project, person, concept, tool, external system mentioned — tagged for Antigravity indexing.

## Raw insight (optional)
Anything that felt like a genuine breakthrough, pattern recognition, or realisation worth preserving.

---

## Antigravity cross-referenced ingestion

When Antigravity processes a session archive it:
1. Parses entities — extracts every project, person, concept, tool named
2. Builds backlinks — for each entity with a canonical file, appends a Session references section pointing to this archive
3. Updates cross-reference index — canonical/concepts/session-cross-reference-index.md
4. Tags the archive — sets processed_by_antigravity: true, adds entities_extracted list to frontmatter
5. Flags canonical updates — if archive contains decision that contradicts/extends canonical, writes canonical/_pending/ stub
6. Never modifies archive content itself — raw stays raw

---

## Accessibility — how future sessions surface archives

Three access paths:
1. Via conversation_search — Claude native past-chat search
2. Via canonical backlinks — relevant canonical file Session references section lists every archive touching that topic
3. Via cross-reference index — Antigravity maintains session-cross-reference-index.md as flat lookup: topic -> [archives]

Goal: nothing discussed in any Claude session is ever lost. Future Claude on any topic finds every session where it was discussed, the reasoning, the alternatives, the evolution.

---

## Change log
- 2026-04-22 — Initial canonical. Created per Adrian requirement: when a chat closes, the hive mind is populated with all information, thought processes, fixes, challenges — cross-referenced against everything relative.

## Session references
- [2026-04-22 hive-mind-archive-protocol](../../raw/sessions/2026-04-22-1800-hive-mind-archive-protocol.md) — Implementation of session archive protocol, ChatGPT export vs Grok export insights, and API stack corrections.
