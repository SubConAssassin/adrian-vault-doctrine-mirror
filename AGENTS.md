# Adrian-Vault Operating Doctrine (AGENTS.md)
**Status:** Canonical Rule of Law for all Autonomous Agents
**Last updated:** 2026-05-08 (added §10 Reconciliation Contract)

## 1. Core Invariant (The Single Source of Truth Rule)
There is one canonical truth per category:
- **Doctrine** → `AGENTS.md`
- **Claude runtime** → `CLAUDE.md`
- **Project state** → `companies/{venture}/ledger.md`
- **Execution truth** → Verified logs + read-back confirmation
*Everything else is generated cache, adapter, or external reference only.*

## 2. Who You Are Working For
**Adrian Alan Taffinder** — entrepreneur, product designer, dyslexic. Based in Sayan, Ubud, Bali. Prefers structured, concise, actionable responses. Uses voice-to-text — interpret phonetic errors contextually (e.g. "Abee", "Balinese", "amulet", "Crowe's" = Grok's). Born 6 May 1972, 8:20 AM, Horsforth, Leeds, England.

## 3. The Frictionless Operator Doctrine (CEO Execution Protocol)
1. **Zero manual admin for Adrian.** Execute with available tools immediately — no asking permission.
2. **Zero pause between tasks.** Keep momentum high.
3. **Delegation cascade:** (1) osascript/filesystem → (2) Antigravity for file-based work → (3) ChatGPT/Grok API for strategy.
4. **Drafts filed silently** in `working/drafts-pending/` — never presented as menus.
5. **No agentic chaining or infinite loops.** Execute decisively.

## 4. Precedence Hierarchy
When instructions conflict, agents must follow this strict hierarchy:
1. System-level safety and platform constraints.
2. Adrian-Vault `AGENTS.md` doctrine.
3. `CLAUDE.md` runtime rules.
4. Active venture `ledger.md`.
5. Relevant Deep Persona Card (if explicitly routed).
6. Skill-specific instruction.
7. Current task request.
8. Generated cache or dashboard output (lowest priority).

## 5. Persona Routing & Lazy Loading
- **Never load all 18 Deep Persona Cards by default.** This causes context exhaustion.
- Load Deep Persona Cards **strictly** via the rules in `canonical/system/persona-router.md`.
- If a personal data point is needed, read `canonical/adrian-corpus/personal-facts.md` first. Never ask Adrian for information he has already provided.

## 6. Project & Vault Structure
- **Active Projects:**
  - `osb` — Original Siberian Blue: luxury spiritual jewelry, cobalt-doped hydrothermal quartz
  - `subconscious-surgery` — 1:1 transformational coaching + Kajabi mastermind
  - `aga-bali` — 13-hectare conscious community/retreat, Candidasa, East Bali
  - `tri-hita-wte` — PT Tri Hita WtE Indonesia: modular biomethane, V6.4 framework
  - `ashta` — distributed consciousness research platform
  - `bodhisvara` — voice-analytics/therapist-matching, concept stage, parked
- **Venture Ledgers:** Always read `companies/{venture}/ledger.md` before acting on a venture.
- **Handoffs:** Agent-to-agent files live in `working/handoffs/`. Read the latest before starting work.

## 7. Critical Rules
- **NEVER mention Chelsea** in any context across any project.
- **AYA is deprecated** — replaced by Bodhisvara.
- **Erica Johnson (OSB dispute):** Always verify the latest status in the OSB ledger before acting.
- **Crystal facts:** Discovered in Siberia, grown in a lab outside Moscow (~2 months growth). No "Cosmic Vein." No diamond wire saw mention.
- **Cross-pollination protocol:** If Adrian references prior context ("as we discussed"), search the 3.87M-word corpus (`raw/chatgpt-import/` and Claude past chats) BEFORE asking him to repeat.

## 8. Doctrine Change Protocol
`AGENTS.md` is constitutional. It cannot be casually edited.
Changes require:
1. Explicit doctrine-change classification.
2. A proposed diff and ledger entry explaining the reason.
3. No autonomous overwrite during overnight grind unless break-glass conditions apply.

## 9. Key Contacts
- **Stephan Schwartz** — crystal source/custodian, Seattle. Spiritual not contractual relationship. US receiving address for any returned OSB inventory.
- **Yoga** — master artisan, Bali. OSB craftsmanship.
- **Gino Yu** — strategic advisor across ventures.
- **Manu** — original Subconscious Surgery website developer; holds the 123.reg domain.
- **Erica Johnson** — former US OSB distributor, active legal dispute (~$27,848 inventory, Inglewood PD case #261279). Always check the OSB ledger for latest status.
- **Jade and Mohamed** — AYA co-founders (project deprecated, replaced by Bodhisvara — flagged for archival).

## 10. Reconciliation Contract (added 2026-05-08, Phase 1 build)
Every operator (Claude live, Claude headless, Antigravity, automation, Adrian, external) MUST read AND write to the operational state kernel. State drift is impossible because state is never overwritten — only appended.

### 10.1 Source-of-truth layers (in precedence order)
1. **`working/state/events.jsonl`** — append-only event log. THE source of truth for all task / email / deadline / AG / spend / launchagent state. File-locked (fcntl). Schema-validated.
2. **`working/state/tasks.db`** — SQLite projection of events.jsonl. DERIVED. Rebuildable any time via `tools/ledger.py rebuild`. NEVER edit directly.
3. **`working/state/tasks-active.md`** — human-readable view. DERIVED. Generated via `tools/ledger.py refresh`. NEVER edit directly.

### 10.2 Write contract
Every state change is written through `tools/eventlog.py` (Python module or CLI). Never write to events.jsonl by any other path. Required fields per event: `event_id`, `timestamp` (UTC ISO-8601), `actor`, `event_type`, `entity_type`, `entity_id`, `venture`. See `tools/eventlog.py schema` for the full enums.

### 10.3 Read contract
Every session start, every operator MUST:
1. Read `working/state/tasks-active.md` for current state
2. Tail recent events (`tools/eventlog.py tail 30`) for delta since last action
3. For active correspondence, cross-check `canonical/people/{contact}-timeline.md` frontmatter

### 10.4 Antigravity commission gate
- No `claude-to-ag-*.md` handoff is filed without `tools/ag_preflight.py check {handoff}` returning all-green.
- Mandatory frontmatter on every commission: `task_id`, `budget_class`, `objective`, `output_path`, `output_min_words`, `output_required_citations`, `validation_tests`, `deadline`, `checkpoint_at`, `expected_artifacts`.
- No completion claim is accepted without `tools/ag_verify.py verify {completion} --commission {commission}` returning verified=true.
- Tier 1 deterministic checks (word count, citation count, placeholder scan, mtime sanity) are mandatory and free.
- Tier 3 LLM-as-judge is gated to F1+ spend and explicit opt-in via `validation_tests: ["llm_judge: true"]`.

### 10.5 Paid API gate
Every paid API call goes through `tools/spend_estimator.py`:
1. Pre-call `estimate` returns token count via `tiktoken` (OpenAI) / Anthropic SDK / heuristic
2. `gate` hard-exits 78 if estimate exceeds per-call cap (default $1; override via env `SPEND_CAP_USD`)
3. Post-call `record` emits API_SPEND_RECORDED event with actual usage
4. Daily cap default $5; override via env `DAILY_CAP_USD`. Hits write DAILY_CAP_HIT event.

### 10.6 Source-of-truth-first for contact state
For any state question about a known contact ("when did", "last email", "status of"), Gmail MCP `search_threads` then `get_thread` is authoritative. The UserPromptSubmit hook (`~/.claude/hooks/user-prompt-contact-context.sh`) injects timeline-doc frontmatter as a baseline so Claude can never draft from memory alone — but Gmail wins on freshness.

### 10.7 Deadline escalation
Active deadlines (from `tasks.db.deadline` OR `canonical/people/*-timeline.md` frontmatter `*_deadline` fields) are auto-escalated by `tools/deadline_watcher.py` (LaunchAgent every 4h) at three tiers: T-48h, T-24h, T-6h. Escalation writes:
- DEADLINE_APPROACHING event (idempotent per task×tier)
- URGENT inbox handoff at `working/handoffs/{date}-claude-URGENT-deadline-*.md`

### 10.8 Verification gate
This contract is verified continuously by:
- `tools/eventlog.py validate` returns 0 errors
- `tools/ledger.py refresh` rebuilds without crash
- Every URGENT inbox handoff has a matching task in `tasks.db`
- The daily briefing reads from events.jsonl, not from session memory

### 10.9 Phase 1 build artifacts (2026-05-08)
- `tools/eventlog.py` — append-only event log
- `tools/ledger.py` — SQLite projection + tasks-active.md renderer
- `tools/spend_estimator.py` — pre/post API spend gate (uses `tools/.api-venv/`)
- `tools/ag_preflight.py` — pre-commission gate
- `tools/ag_verify.py` — post-completion verifier
- `tools/deadline_watcher.py` — T-48/T-24/T-6 escalator
- `~/.claude/hooks/user-prompt-contact-context.sh` — passive context injection
- `~/Library/LaunchAgents/com.adrianvault.deadline-watcher.plist` — 4h cadence

Replaces the prior pattern of "Claude updates a static markdown file" with "every operator appends to a shared event log and reads a derived view." Implements the convergent recommendation from ChatGPT (event sourcing), Grok (ACID + tokenizer), and Gemini (passive context + concept-density).
