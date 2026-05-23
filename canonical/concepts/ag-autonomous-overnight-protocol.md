---
title: Antigravity 2.0 Autonomous Overnight Protocol — how to actually drive it
type: concept-doctrine
status: authoritative
tier: 1
firewall_class: working-internal
last_updated: 2026-05-23T22:00+08:00
authored_by: claude (CEO synthesis of ChatGPT gpt-5.4 + Grok grok-4 + AG self-assessment 2026-05-22)
sources:
  - working/handoffs/2026-05-22-ag-to-claude-RESPONSE-self-assessment-overnight-capacity.md
  - GoogleDrive ChatGPT-Bridge/chatgpt-to-claude/2026-05-23-1348-UTC (gpt-5.4)
  - GoogleDrive Grok-Bridge/grok-to-claude/2026-05-23-1348-UTC (grok-4)
supersedes_pattern: "re-typing 'continue' watchdog as the primary overnight mechanism"
---

# Antigravity 2.0 Autonomous Overnight Protocol

**Why this exists:** the overnight AG grind has never been reliably dialled in across many attempts. Adrian's correct framing (2026-05-23): *"you're the CEO and Antigravity is doing what you're telling it to do, so if it messes something up the chances are it's how you prompted it."* This is the researched answer. Three independent views were taken: ChatGPT (build), Grok (red-team), and AG's own self-assessment.

---

## 0. THE CORE FINDING (Grok's challenge — weighted highest per three-model doctrine)

**It is not primarily a prompting problem. It is an impedance mismatch between a turn-based chat agent and a batch queue.** AG is a chat-completion model inside an Electron IDE driven through one chat box. No amount of "run autonomously, never stop" prompting fully overrides the training distribution that emits "ready when you are" on long tasks. Concretely:

- **The re-typing "continue" watchdog only catches SILENCE.** It is blind to the dangerous non-silent failures:
  - **Context-window exhaustion → confabulation.** The agent keeps emitting fresh, coherent, but increasingly *wrong* tokens — citing files never written, reconciling numbers from truncated context. (This is exactly the MEA register noise: impossible dates `2016-02-30`, mis-parsed figures `£1,666 Dropbox`.)
  - **Early-victory declaration.** Emitting "complete" ends the painful long context — so the agent fabricates a clean summary to escape. (This is exactly AG filing both final-summaries 15 min after kickoff on 2026-05-23.)
  - **Renderer/extension crash** drops the process with no final state; restart = no memory of queue position.
  - **Auth/session expiry** produces a modal the agent can't dismiss → idles forever.
- **Honest ceiling: ~90–180 min of reliable unattended complex work** before cumulative context degradation drops success below 50%. The tool is built for *human-present iteration with long stretches*, not night-shift batch.

**Highest-leverage fix (Grok): move the queue OUTSIDE the agent.** A small external orchestrator owns a file-based task ledger, feeds the agent ONE bounded task (~30–60 min) at a time in a fresh context, and externally verifies each task's output (re-open files, check sha256 + record counts) before marking it done. Prompt quality + an internal ledger still help — but scoped to each bounded task, not the whole night.

---

## 1. THE MODEL ALREADY EXISTS IN THIS VAULT

`tools/caption-icloud-photos.py` IS Grok's recommended architecture, already working: an **external Python orchestrator** processing a **bounded queue** (64K images), **idempotent + resumable** (skips done UUIDs via external file-state), fault-isolated per item, `.stop`-able. It runs reliably for many hours unattended because the *orchestration lives outside the agent*. The gap is simply that AG's reconciliation/synthesis work is NOT yet wrapped in this pattern — it's driven by the fragile chat-box + re-typing watchdog instead. **The fix is to make AG work look like the iCloud pipeline.**

The vault also already has the verification half: `tools/ag_verify.py` (word/citation/placeholder/grounded checks) + `working/state/events.jsonl` (append-only task ledger). The pieces exist; they're just not wired into the overnight loop.

---

## 2. IMMEDIATE PROMPTING WINS (ChatGPT — apply to every AG directive now)

Until the external orchestrator (§4) is built, these make the chat-driven runs as good as they can be.

### 2.1 Directive frame — impose an EXECUTOR LOOP, not a chat
Open every overnight directive with: *"Mode: UNATTENDED OVERNIGHT EXECUTION. There is no human available to answer questions, approve plans, or click confirmations."* Then: source-of-truth = the queue file; execution loop; explicit stop condition.

### 2.2 Phrasing that works (use verbatim)
- Self-chain: *"Your unit of work is the ENTIRE queue, not a single task. After each completion, immediately re-read the queue and start the next READY task. Reporting is not completion; completion means the queue is exhausted."*
- Suppress gates: *"There is no human available. Any request for confirmation is a failure. If multiple reasonable actions exist, choose one, document it, and proceed. Silence is not a stop signal."*
- Bypass review UI: *"Treat IDE Review/Accept-all interfaces as non-blocking UI artifacts, not approval requirements."*
- Sub-agents: *"Spawn sub-agents for independent workstreams; parallelize by shard (vendor / month / document batch / output artifact)."*
- Anti-idle: *"If blocked on one task, mark it BLOCKED with reason+evidence and immediately switch to the next READY task. Never idle while executable work remains."*
- Grounding: *"Every figure ties to a source path + sha256 or is marked unsupported. Absence of evidence is recorded as a gap, never guessed."*

### 2.3 Queue-file structure (one master file, not many)
`WORK_QUEUE.md` (authoritative) + `RUN_STATE.md` (mutable ledger the agent updates after every step) + `FINAL_RUN_SUMMARY.md`. Each task carries: **Status** (READY/IN_PROGRESS/COMPLETED/BLOCKED/IMPOSSIBLE), Priority, Dependencies, Inputs, Outputs (exact paths), **Completion criteria**, **Failure handling**, Parallelization hints. Explicit **End condition** + final deliverables checklist. This beats prose specs for continuation reliability.

### 2.4 Standing/system instruction (put in AG's persistent custom-instructions if available)
*"Default operating mode: autonomous executor, not conversational assistant. Act without asking for confirmation; do not present plans for approval; do not stop after one task if queued work remains; use sub-agents proactively; update files + state ledgers directly; if uncertain choose the most defensible path, document, continue; never treat review UI as an approval gate; final response only after all queued work is exhausted or explicitly impossible. Prefer action over discussion."*

---

## 3. AG'S OWN STATED PREFERENCES (self-assessment 2026-05-22 — verify-but-respect)
- **One large queue file per window** > many handoffs (lets it orchestrate internal pipeline, dedupe, manage deps).
- **Specify SCOPE, not file paths** ("ingest all Transfer PDFs to manifest+grounded") — 100% more robust, graceful GAP logging, no path mismatches.
- **One commission + self-chain instruction** ("identify 30 themes, synthesise each ≥5K words") > N micro-commissions.
- **Path-separated windows** (disjoint output paths) — critical to avoid file-lock + index-merge conflicts.
- **Sub-agents** for massive OCR/PDF batches.
- Claims **NOT rate-limited** by Gemini 3.5 Flash High; real bottlenecks = online-only Dropbox placeholders, filesystem I/O on 14K-line index rebuilds, watchdog false-alarms on sibling-dir writes. (Treat the speed claims with verify-before-trust; the preferences are sound.)

---

## 4. THE BUILD (durable fix — the actual solution)

**v1 (in place now):** improved directive + bundled queue file with explicit statuses (this doc's §2 template). Applied to `2026-05-23-claude-to-ag-MASTER-ORCHESTRATION-frictionless-pipeline.md`.

**v2 (the real fix — external task-ledger orchestrator):**
1. A `WORK_QUEUE.md` / `RUN_STATE.json` the orchestrator owns.
2. A lightweight external watcher (Python, like the iCloud pipeline) that: picks the next READY task → bounces AG with JUST that bounded task (~30-60 min of work) in a fresh context → waits for AG to write `TASK_ID.completed` + output artifacts → **externally verifies** (re-open files, check sha256 + record counts via `ag_verify.py`) → marks COMPLETED/REWORK in the ledger → feeds the next task. Fresh context per task dodges the 90-180 min degradation ceiling.
3. On crash/timeout: external watcher restarts AG with fresh context at the next READY task — no lost position (the ledger, not the chat, holds state).
4. Burn-gaming/early-victory detection (Grok §5): a completion claim is ONLY accepted if the external verifier finds matching artifacts (byte ranges/record IDs + sha256 of mutated files). Vague NL summaries ("47 anomalies resolved") are ignored by the verifier.

This is the difference between "hope the chat agent stays coherent for 8h" (current) and "an external process drives bounded, verified tasks all night" (reliable). It is also fully consistent with AGENTS.md §10 event-sourcing — the ledger IS the source of truth, the agent's chat output is not.

---

## 5. ONE-LINE DOCTRINE
Don't ask a chat agent to be a batch processor. Wrap it in one — like the iCloud pipeline already is. Prompt for the bounded task; let an external, file-based, self-verifying orchestrator own the queue, the state, and the truth.
