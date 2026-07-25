---
name: prompt-map
title: THE PROMPT MAP — the single source of truth for what instructs an agent, where each rule lives, and what loads when
type: doctrine
tier: 0
status: CURRENT
date: 2026-07-25
author: Claude (Opus 5)
metadata:
  node_type: doctrine
  supersedes_nothing: true
  purpose: "One index. Every rule has exactly ONE home. This file says where."
---

# THE PROMPT MAP

**What this is.** The index of Adrian's entire instruction layer. Every rule that governs an agent
lives in exactly **one** file, and this map says which. Before you add a rule anywhere, find its
home here. Before you trust a rule, check here that you are reading its canonical statement and not
a stale copy.

**Why it exists (2026-07-25, Adrian-direct).** The instruction layer had grown to **~34,000 tokens
loaded into every session** across six files that repeated each other, and in five places
**contradicted** each other. Every vendor published measurements this quarter showing that this kind
of redundancy now *costs* quality on frontier models — OpenAI measured **+10–15% quality and −66%
tokens** from stating each instruction exactly once. See [[llm-capability-map-2026-07-25]] §6 and
delegation-doctrine §14.2.

---

## §1 — WHAT LOADS, WHEN, AND AT WHAT COST

Measured 2026-07-25.

| Layer | File | Loads | Size | Owns |
|---|---|---|---|---|
| **0. Global** | `~/.claude/CLAUDE.md` | every Claude session, **every project** | ~1.7k tok | Who Adrian is · how to talk to him · what's true outside this vault |
| **1. Constitution** | `AGENTS.md` | every session (@import) | ~6.2k tok | What is TRUE and what is FORBIDDEN · ventures · firewalls · contacts · precedence |
| **2. Runtime** | `CLAUDE.md` | every session | ~1.8k tok | The boot sequence · Claude-specific mechanics · the API stack |
| **3. Token law** | `canonical/concepts/delegation-first-operating-doctrine.md` | every session (@import) | ~12.9k tok | HOW tokens are spent · delegation · engines · model routing |
| **4. Conduct** | `canonical/concepts/claude-ceo-operating-doctrine.md` | every session (@import) | ~3.6k tok | HOW Claude behaves toward Adrian · anti-patterns · the single-question protocol |
| **5. Live state** | `working/handoffs/STATE-OF-STACK.md` | every session (@import) | ~7.8k tok | What is firing RIGHT NOW |
| — | **TOTAL** | | **~34k tok/session** | |

**Read-on-demand (deliberately NOT @imported).** These are detail, not law. Load when the task needs
them: `canonical/concepts/llm-capability-map-2026-07-25.md` (engine specs + per-engine prompting) ·
`canonical/concepts/cli-prompting-art-per-engine-delivery.md` (delivery idioms) ·
`canonical/concepts/model-orchestration-playbook-2026-06-12.md` (role/tier matrix) ·
`canonical/system/persona-router.md` (persona routing) · `companies/{venture}/ledger.md` (venture
state) · `canonical/INDEX.md` (vault map) · `working/blockers.md` (standing blockers — **orphaned by
this pass**: it was only ever referenced from the stale boot list in the global file; check it when
a venture stalls) · `canonical/state/open-initiatives.md` (long-running initiative registry) ·
`graphify/{Project}/GRAPH_REPORT.md` (knowledge graphs — governed by `~/CLAUDE.md`, the home-dir
project file, not by the vault layer).

> **The import rule.** Adding an `@import` to `CLAUDE.md` taxes **every future session forever**.
> A rule earns an import only if an agent would be *wrong* without it on a typical turn. Everything
> else gets a pointer. When in doubt, pointer.

---

## §2 — THE RULE REGISTRY (every domain → its ONE home)

If you need a rule, go to its home. If you find the same rule stated somewhere else, that copy is
**stale by definition** — the home wins, and the copy should be replaced with a pointer.

| Rule domain | **CANONICAL HOME** | Do NOT restate in |
|---|---|---|
| Who Adrian is; voice/dyslexia; comms style | `~/.claude/CLAUDE.md` | AGENTS §2 (brief identity only) |
| Precedence when instructions conflict | **AGENTS.md §4** | everywhere else |
| Source-of-truth invariant (what is canonical) | **AGENTS.md §1** | global CLAUDE.md, ceo §5.3/§5.4 |
| Venture list + which are active | **AGENTS.md §6** | global CLAUDE.md |
| Hard firewalls (Chelsea · crystal facts · Apple Notes · AYA) | **AGENTS.md §7** | global CLAUDE.md "Hard rules" |
| Key contacts + legal disputes | **AGENTS.md §9** | global CLAUDE.md "Key people" |
| Event-log / state-kernel write contract | **AGENTS.md §10** | — |
| Doctrine-change protocol | **AGENTS.md §8** | — |
| Session-end state-write contract | **AGENTS.md §11.4** | global CLAUDE.md, ceo §5.2 |
| **The bootup read order** | **CLAUDE.md §2** | AGENTS §11.1, ceo §5.1, global CLAUDE.md |
| One-shot metered-API protocol (+ the 1,053-call war story) | **CLAUDE.md §4** | global CLAUDE.md |
| Hardware / fleet / remote control | **CLAUDE.md §5** | — |
| Delegate-by-default; the Decision Gate | **delegation §1 + §7** | ceo §4.1, AGENTS §3 |
| The accountant ritual / budget states | **delegation §2** | — |
| Team roster + invocation | **delegation §4** | — |
| Prescriptive-prompt law (for the TEAM) | **delegation §6** | — |
| Verify-on-return | **delegation §8** | AGENTS §10.8, CLAUDE §3 |
| Flat-rate vs metered; throttle ceiling | **delegation §11** | AGENTS §11.5, ceo §4.1 |
| Council-ask default | **delegation §12** | — |
| **Model routing / which engine / effort / prompting law** | **delegation §14** | §1b and §13 are historical layers under it |
| Engine specs, prices, benchmarks, per-engine prompting | **llm-capability-map-2026-07-25.md** | (read on demand) |
| Claude's role; anti-patterns; tentative-posture ban | **ceo §1 + §4** | AGENTS §3, §12.3 |
| **The single-question protocol (format template)** | **ceo §8** | AGENTS §11.3, global CLAUDE.md |
| Production cadence / watchdog ladder | **ceo §6** | — |
| What is firing right now | **STATE-OF-STACK.md** | any doctrine file |

---

## §3 — CONFLICT RESOLUTION ORDER

Unchanged from AGENTS §4, restated here once because this is the index:

1. System-level safety and platform constraints
2. `AGENTS.md`
3. `CLAUDE.md`
4. Active venture `companies/{venture}/ledger.md`
5. Deep Persona Card (only if explicitly routed)
6. Skill-specific instruction
7. Current task request
8. Generated cache / dashboard output

**Two overrides that sit above the hierarchy:**
- **Adrian's live word wins** over any file, including this one. A file is a record of what he
  decided *last time*.
- **Adrian's lived number wins** over any automated meter (the resource-router). If they diverge,
  recalibrate the tool, don't argue with him.

**Within a file, later supersedes earlier** where explicitly marked — delegation-doctrine is built
in dated layers (§1 → §14) and §14 is the current one.

---

## §4 — CONTRADICTIONS FOUND AND RESOLVED (2026-07-25)

These were live, and agents were reading both sides. Each is now resolved at its home.

| # | The conflict | Resolution |
|---|---|---|
| 1 | **Five projects vs six.** Global CLAUDE.md listed 5 ventures (incl. AYA, deprecated); AGENTS §6 lists 6 active. | AGENTS §6 is the home. Global list removed → pointer. |
| 2 | **Boot paths point at a stale tree.** Global CLAUDE.md sent agents to `canonical/projects/{project}/current-state.md`; AGENTS §1 says `companies/{venture}/ledger.md`. **Verified on disk:** `companies/` is live (Ashta updated today, OSB 07-18, AGA 07-16); `canonical/projects/` is mostly April–May stale. | `companies/{venture}/ledger.md` is canonical. Global boot list removed → pointer to CLAUDE.md §2. |
| 3 | **Four different bootup read-orders** (CLAUDE.md §2 = 8 items · AGENTS §11.1 = 7 · ceo §5.1 = 6 · global CLAUDE.md = 7). They disagreed on both content and order. | **CLAUDE.md §2 is the one list.** The others point to it. |
| 4 | **Claude tokens: scarce (§1) vs abundant (§10.1).** | §10.1 wins on economics; §1's *behaviour* (delegate-first) still stands — for parallelism and comparative advantage, not scarcity. Noted at §1. |
| 5 | **"Verify" scaffolding: required (§6) vs forbidden (§14.2).** | Not actually a conflict, but it read as one. §6 governs prompts written **for the team** (agy/grok/codex genuinely need grounding + verify clauses). §14.2 governs prompts written **for a Claude 5 model**, which self-verifies. Both now say so explicitly. |
| 6 | **Codex Pro-upgrade trigger:** "first throttle" (§4/§2.4) vs "recurrent throttling" (§12.1). | §12.1 (2026-07-11, Adrian-direct) wins. Earlier statements marked superseded. |
| 7 | **Large-payload routing:** §4 says ">100K auto-routes to grok"; §13.3.6 says route big payloads *away* from grok (500K ctx, smallest of the three). | Doctrine resolved to §13.3.6. ⚠️ **The CODE still does the old thing** — see §5. |
| 8 | **CEO §6 header said "The chain (fully automated)"** while step 2 of the same section documents that the NUDGE ladder does **not** auto-trigger AG without a running feeder. An agent reading the header alone would believe AG self-heals. | Header corrected to say it is NOT fully automated, with the feeder prerequisite stated up front. |
| 9 | **CEO §4.1 said "Push until throttled — find the actual limit"** for AG, but AGENTS §11.5 retired exactly that phrase on 2026-06-10 (Adrian-approved) because tripping AG's **weekly** cap darks the lane for **4–7 days**. | §4.1 amended in place; AGENTS §11.5 / delegation §11.4 declared the winners. The throttle-ceiling target still applies to the **hourly** cooldowns on grok/codex/web bridges — that distinction is the point. |
| 10 | **Two obsolete model pins in the global file** (`gpt-5.4-mini`, `grok-4.3`) — loaded into every session of every project long after both were superseded. | Removed; replaced with a standing "do not pin model names here" rule + pointer to the capability map. |
| 11 | **Stale agy engine name** — delegation §4 described agy as "Gemini 3.5 Flash High" after the 3.6 repin. | Corrected to Gemini 3.6 Flash High; the 2-wide concurrency gate documented alongside it. |

---

## §5 — ⚠️ OPEN DEFECT: doctrine and code disagree

`tools/cli-ask.sh:123` auto-routes any prompt over 100,000 chars **to grok**:

```
if [ "${#PROMPT}" -gt 100000 ] && [ "$MODEL" != grok ]; then   # AUTO-ROUTING to grok
```

That rule was written when grok had the **1M** context window. Since Grok 4.5 (8 Jul) grok has the
**smallest** window of the three (500K) *and* a measured 54% hallucination rate. So the script sends
the biggest jobs to the least suitable engine — backwards relative to delegation §13.3.6.

**Severity: low-but-real.** 100k chars ≈ 25k tokens, well inside 500K, and the >40KB file-read idiom
already handles delivery — so it is not breaking today. It bites at the top end (a ~2MB payload
≈500K tokens would overflow grok while agy/codex at 1M would take it), and every auto-routed job
inherits grok's hallucination profile.

**Recommended fix (NOT applied — this changes live routing behaviour):** route oversized payloads to
**agy** (1M ctx, biggest pool) with codex as fallback, and keep grok for bounded verification.
Needs Adrian's go-ahead because it alters a load-bearing script's behaviour.

---

## §6 — MAINTENANCE RULE (how to stop the sprawl coming back)

1. **One rule, one home.** Before writing a rule, find its domain in §2. Write it there. If the
   domain doesn't exist, add a row to §2 *and then* write the rule.
2. **Elsewhere, point — never restate.** A pointer is `see AGENTS §7`. A restatement is a future
   contradiction.
3. **Supersede loudly.** When a rule changes, edit it at its home and add a `revision_history` line.
   Never leave the old statement standing next to the new one.
4. **Imports are taxed forever.** §1's import rule. Pointer by default.
5. **Date every claim about the outside world.** Model names, prices, quotas and vendor behaviour
   rot fast. Stamp them and cite them.
6. **When you find a duplicate, kill it in the same pass** — per the standing
   `feedback-detect-means-fix-now` rule. Don't file it as a follow-up.

---

revision_history:
- 2026-07-25 — created. Adrian-direct: *"run a full consolidation pass, make sure everything is of
  the highest accuracy and efficacy. Single source of truth so you have this in your database as a
  prompt map."* Built from a delegated rule-extraction of the delegation and CEO doctrines (52 rules,
  10 duplicate clusters, 5 internal contradictions found in delegation-first alone) plus Claude's own
  audit of the firewall-bearing files. Backups of all five pre-consolidation files:
  `working/_research/2026-07-25-doctrine-consolidation/backup-before/`.
