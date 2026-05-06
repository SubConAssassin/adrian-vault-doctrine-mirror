---
title: Lessons — Session 4e7b2a9c (ORGONE launch + doctrine declaration)
type: lesson
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-04-23
last_updated: 2026-04-23
tags: [lessons, vtt-phonetics, handoff-discipline, primitive-reuse, adrian-patterns]
related:
  - canonical/concepts/shutdown-protocol.md
  - canonical/frameworks/unified-processing-engine.md
  - canonical/concepts/adrian-claude-shorthand-protocols.md
---

## Purpose

Durable, agent-facing lessons extracted from session 4e7b2a9c. Written so future Claude / Antigravity / Grok / ChatGPT sessions don't repeat the same mistakes. Each lesson is phrased as a rule, not a story.

---

## Lesson 1 — Voice-to-text phonetic drift is constant, not occasional

Adrian inputs primarily via voice-to-text. VTT consistently produces approximate renderings of proper nouns, project names, and folder names. Prior sessions have confirmed this is a structural feature of his input, not a one-off.

**Rule:** When Adrian references a named entity (folder, person, project, product) that doesn't match any vault canonical exactly, do NOT fail-fast with "not found." Scan the likely parent directory and fuzzy-match phonetically before declaring absence.

**Known phonetic variants (extend this list as discovered):**

| Adrian said (VTT) | Actual canonical name |
|---|---|
| orgon | ORGONE (folder on disk: `ogrone`) |
| Bodhya Svara | Bodhisvara |
| Ollie | Olly (e.g. Olly Zavadsky) |

When a new variant is confirmed, add it to this table.

---

## Lesson 2 — Adrian's opening ask is often the surface entry to a deeper strategic reveal

Repeated pattern: Adrian's turn 1 is a narrow, tactical request. Turn 2, after Claude executes turn 1 cleanly, expands to the real strategic scope — often including canonical architecture declarations.

**Rule:** Execute turn 1 cleanly but structure artefacts so turn 2 can extend them without throwaway rework. Specifically:
- Use project-folder patterns even for one-off tasks.
- Write handoffs with schemas that can grow, not fixed scopes.
- Don't over-engineer turn 1 pre-emptively — wait for the reveal, then extend.

---

## Lesson 3 — Doctrine moments must be captured immediately and verbatim

Adrian occasionally drops canonical architecture declarations mid-conversation ("they all use the same engine underneath"). These are not metaphors, not speculation — they are binding architectural claims.

**Rule:** When Adrian makes a statement of the form "all of X use the same Y" or "X, Y, Z are the same thing executed differently," treat it as a canonical framework declaration. Write it to `canonical/frameworks/` within the same session. Do not paraphrase away the strong claim.

---

## Lesson 4 — "No major rush" ≠ "do it later"

Adrian's "no rush" / "no major rush" signals desired operating mode, not schedule. He wants the work automated and off his cognitive load, running in the background. He still expects handoff / delegation / scheduling to happen in the current session.

**Rule:** "No rush" means: execute the handoff now, schedule the actual work for a non-blocking tier, don't interrupt Adrian with status pings.

---

## Lesson 5 — Verify pipeline health before extending it

Symptoms of a silently-failing pipeline:
- Transcription logs complete in &lt; 5 seconds per file (physically impossible for real Whisper, even on `base`)
- Output directory contains empty files or has fewer files than claimed
- Prior session flagged a fix but never confirmed the fix landed

**Rule:** Before commissioning a new job that builds on an existing pipeline, spot-check the latest outputs for non-zero length and recency. If suspect, flag to the executing agent as a prerequisite verification step — don't pile new work on a broken base.

Quick health check one-liner:
```bash
wc -l ~/Documents/Adrian-Vault/raw/sessions/rode-rec-transcripts/*.md 2>/dev/null | tail -10
```

If most files show near-zero lines, the pipeline is silent-failing.

---

## Lesson 6 — Grep for existing primitives before commissioning new ones

Before specifying "build a new utility for X" in a handoff, check:
```bash
ls ~/Documents/Adrian-Vault/bin/
ls ~/Documents/Adrian-Vault/tools/
grep -r "<keyword>" ~/Documents/Adrian-Vault/bin/ ~/Documents/Adrian-Vault/tools/
```

The ecosystem has built dozens of primitives across prior sessions. Reuse is cheaper than rediscovery. This is also required by the Unified Processing Engine doctrine — **build once, ship three ways**.

---

## Lesson 7 — Superseding handoffs must annotate their predecessor

When writing a v2 handoff that supersedes a v1 in the same session (or prior), do NOT leave v1 unannotated. Antigravity (or any other execution agent) may grab v1 first and execute the narrower scope.

**Rule — two-step supersession:**
1. Edit v1's first line (or add a header block) to: `> **SUPERSEDED BY** <path to v2>. Do not execute this file — use v2.`
2. Then write v2.

Never leave a stale handoff executable.

---

## Lesson 8 — The Unified Processing Engine doctrine is now binding

See `canonical/frameworks/unified-processing-engine.md`. Summary as it applies to execution agents:

- ORGONE/Bodhisvara, Subconscious Surgery, and Ashta share one engine.
- New capabilities for any of the three are built as **generic engine primitives**, not venture-specific helpers.
- New primitives are registered under `Adrian-Vault/bin/` or `tools/` and documented in the doctrine note.
- If a proposed build would only serve one venture, question the design before proceeding.

---

## Lesson 9 — Canonical changes made mid-session should be promoted in real time, not batched for shutdown

Shutdown protocol Step 4 handles leftover promotions. But real-time promotion (writing directly to `canonical/` during the session) is preferred when the decision is unambiguous. Session 4e7b2a9c promoted the doctrine note mid-flow, which worked well — shutdown had nothing canonical-pending to handle.

**Rule:** If Adrian makes a clear, unambiguous architecture declaration, write it to `canonical/` immediately. Reserve `_pending/` for decisions that need Adrian's review before commitment.

---

## Change log

- 2026-04-23 — Initial version. Extracted from session 4e7b2a9c shutdown.
