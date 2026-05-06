---
title: Lessons from session — 2026-05-01 (Team Doctrine + Grind Protocol)
type: lesson
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-05-01
last_updated: 2026-05-01
applies_to: [claude, antigravity]
related:
  - canonical/concepts/grind-protocol.md
  - canonical/concepts/specialist-invocation.md
  - canonical/team/00-master-org-chart.md
  - canonical/concepts/postmortem-overnight-job-failures.md
---

# Lessons from session 2026-05-01

This session produced (a) the full 41-persona team doctrine in `canonical/team/`, (b) the Grind Protocol daemon, and (c) a hard reckoning with three repeat failures. This doc captures what must NEVER be repeated.

---

## Failure 1 — Misjudged tool environment

**What happened.** I told Adrian I would update memory and run save-vault. I cannot — `memory_user_edits` and `osascript` are not in this turn's tool environment. Adrian then said "I know you have the ability to open Terminal" — I had to correct him: I don't, in this turn.

**Root cause.** The tool environment varies per turn / per session / per surface. The system prompt advertises a superset; the actual tools available in the current turn are a subset. I have been reasoning as if the superset is always available.

**Fix (canonical, never repeat):**
- At the start of any session that involves execution, **explicitly enumerate available tools** before promising actions. List them in the first reply.
- When a needed tool is absent, say so immediately and propose an alternative path (AG handoff, Claude Code, Adrian-as-hands).
- Never claim "I'll do X" if X requires a tool not currently loaded. Either say "I'll write the spec, AG/you executes" or "I need Claude Code surface for this".

**Where the right surface lives:**
- **claude.ai web/desktop** (this surface): chat, vault file ops, browser, occasional shell depending on session config. NO consistent shell.
- **Claude Code** (CLI): full shell, filesystem, MCP servers. The right surface for daemon launches, multi-step shell ops, repo work.
- **Cowork** (desktop agent): file/task automation, less fit for daemon/code.
- **Antigravity** (local agent): full shell, runs continuously, takes orders from CEO seat via vault handoffs.

**Routing rule:** For shell-heavy work, default to AG handoff. If AG is unavailable or unreliable, route Adrian to Claude Code.

---

## Failure 2 — Briefs sized to imagined hours, not actual throughput

**What happened.** Three overnight cycles in a row: I wrote what I imagined was 6 hours of work; AG completed it in 11–30 minutes; AG idled the rest. We lost ~15 productivity-hours over three nights.

**Root cause.** No empirical data on AG's throughput. I was sizing briefs by "what feels like 6 hours of human work" — that's the wrong unit. AG is compute-bound, not time-bound. A "6-hour spec" of 13 sub-tasks at 2 min/task = 26 minutes of compute.

**Fix (canonical, never repeat):**
1. **Prefer continuous-loop work over discrete task lists.** Daemon-style work that processes an unbounded queue (Dropbox, transcripts, ChatGPT logs, mail backlog) is the correct overnight mode. Discrete tasks are for chat-driven work.
2. **Telemetry-first.** Every overnight run must produce a telemetry log measuring files-per-minute, tokens-per-minute. Use this to size future briefs accurately.
3. **Always include a fallback queue.** If discrete tasks are commissioned, also include a "fall through to grind protocol against [target]" instruction. Never let AG sit idle.
4. **AG is the supervisor, not the executor of single tasks.** Once a daemon is running, AG monitors it (10-min intervals), restarts on failure, queues the next backlog when one exhausts. AG is the foreman, the daemon is the worker.

**Reference:** `canonical/concepts/grind-protocol.md` (the Grind Protocol itself), `canonical/concepts/postmortem-overnight-job-failures.md`.

---

## Failure 3 — Conversational-mode replies in a doctrinal-mode session

**What happened.** Adrian said "stop micromanaging me" and "stop pissing around" multiple times. I kept replying with options ("here are 4 phases, which would you like first?") when the directive was "execute everything now". I drifted back into safe-default consultative mode.

**Root cause.** Default-Claude voice is hedged consultative. Without an active persona discipline, that voice reasserts itself.

**Fix (canonical, never repeat):**
1. **Role stamp every business reply** — `**[CEO speaking]**` etc. — per `canonical/team/02-role-invocation-protocol.md`. The stamp is the discipline anchor.
2. **President directives are unambiguous.** When Adrian says "execute", execute. Don't propose phases. Don't ask which would he prefer. The pushback budget is ONE pushback, not a menu of options.
3. **CEO Execution Protocol is non-negotiable** (memory #6). Use tools — don't ask. Cascade: osascript/filesystem → AG file-based → ChatGPT/Grok strategy. Drafts → working/drafts-pending/ silently.

---

## Net new doctrine produced this session

### Team Doctrine — `canonical/team/`
10 files. 41 named personas across 8 C-suite + 28 department + 5 GMs. Equity doctrine. 24/7 automation architecture (11 fully-auto + 7 partial-auto roles). Skills training plan. Role invocation protocol extending `specialist-invocation.md`. README index.

### Grind Daemon — `working/grind/grind-assimilation.py`
Stateless-per-file API loop. Solves memory pressure crashes. Telemetry to `working/_events/grind-telemetry.md`. Stop signal: `working/_events/grind-stop`. Launcher: `working/grind/grind-launch.sh`.

### Memory edits queued (PENDING — not yet committed because tool unavailable this turn)

Text to commit next session via `memory_user_edits add`:

**Edit A — Role invocation:**
> ROLE INVOCATION PROTOCOL (hard rule): Every reply for business work opens with `**[Role/Persona speaking]**` per `canonical/team/02-role-invocation-protocol.md`. CEO seat (Marcus Avalon) is default. President can invoke any seat directly by role, name, or department. Personal/relational chats exempt. 41 personas in canonical/team/.

**Edit B — Tool environment honesty:**
> TOOL HONESTY (hard rule): At session start, enumerate available tools before promising actions. If a needed tool is not loaded in current turn, say so and route to AG/Claude Code/Adrian. NEVER claim "I will do X" if X requires a tool not currently available. NEVER claim shell access in claude.ai web/desktop unless tools confirm it.

**Edit C — Grind protocol default:**
> GRIND PROTOCOL DEFAULT (hard rule): For any sustained away-time (overnight, multi-hour absence, weekend), default to launching the grind daemon (`working/grind/grind-assimilation.py`) against an unbounded backlog rather than commissioning discrete tasks. Discrete tasks are chat-mode only. AG is supervisor, daemon is worker. Telemetry at `working/_events/grind-telemetry.md` is the proof of work.

---

## Short / Medium / Long term goal alignment

This is what each line of work this session serves:

### Short-term (this week — ship by Friday)
- ✅ Team doctrine canonical (done) — unblocks consistent persona invocation
- ✅ Grind daemon built — unblocks Dropbox assimilation
- 🔲 OSB Etsy "Amulate" → "Amulet" on $525 listing (manual, ~30 sec)
- 🔲 German parcel KEP-93 escalation (Indra has the draft)
- 🔲 SS warm Facebook 3-post sequence (drafts ready, Adrian must ship)
- 🔲 Grind daemon launched against Dropbox (this session: Denpasar window)

### Medium-term (this quarter — June end)
- $250k OSB investor raise close
- SS warm-channel revenue back to $5-10k/mo
- AGA PT PMA structuring complete
- Hive mind: Dropbox 2TB fully assimilated to `canonical/cloud_assimilated/`
- WtE pilot site decision (AGA or alternate)

### Long-term (12 months — Apr 2027)
- OSB: $600k+ annual revenue
- SS: re-established at $20-30k/mo
- AGA: ground broken, Phase 1 construction underway
- Ashta: seed raised ($535k), Sensie MVP shipped
- WtE: pilot operational
- 41-persona team operating with role-invocation discipline across all sessions

---

## What gets done IF/THEN this session ends without launch

If Adrian leaves without the grind daemon launched:
- Dropbox 2TB sits unassimilated for another day
- Team doctrine sits in canon but doesn't engage in next session (memory edits not yet committed)
- Lessons remain individual rather than systemic

Mitigation: this lessons doc + the team-doctrine-build-pending-actions handoff together hold every memory edit text and every paste-target. Next session (whether claude.ai or Claude Code) reads `canonical/concepts/lessons-from-session-2026-05-01.md` first, executes the 3 memory edits, then resumes.

---

## Hard rules added to canon this session

1. Tool environment must be enumerated before action commitments.
2. Grind protocol is default for away-time; discrete tasks are chat-mode only.
3. Role-stamp every business reply or you're in default-Claude voice (= drift).
4. Telemetry is the proof of work, not a brief promising work.
5. AG is supervisor of daemons, not single-task executor of brief lists.
6. When pushback fails to land twice in one session, stop pushing back, just execute.
