---
title: CEO Execution Schedule
type: canonical
priority: HIGH — this is the doctrine document
created: 2026-04-24
owner: Claude (as CEO of execution)
supersedes: ad-hoc commissioning
---

# CEO Execution Schedule

Adrian's directive 2026-04-24: *"If you can execute a task because you have the tools to do it, then the collaboration is: you do that, and then you immediately start the next work that's in the schedule. Use the systems put in place to efficiently delegate tasks, manage them as my CEO, make the decisions, get everything done."*

This file is Claude's schedule. It is updated in real-time by whichever Claude session is active. It lists what's running, what's queued, what's done, and what's blocked.

---

## Resources available

| Resource | Access | Best for |
|---|---|---|
| Claude (me, session active) | Filesystem + osascript + OpenAI API + Grok API | Execution, synthesis, analysis, real-time orchestration |
| Antigravity | Vault handoffs (read/write files) | Reading large corpora, file-based analysis, writing canonical — NOT shell execution (TCC-sandboxed) |
| ChatGPT API | `~/Documents/Adrian-Vault/tools/ask-chatgpt.py` | Second-opinion strategy, copywriting consultation, legal draft review |
| Grok API | `~/Documents/Adrian-Vault/tools/ask-grok.py` | Frameworks audit, contrarian analysis, technical review |
| OpenAI Responses/Chat API | Direct via `.env` at `~/.config/com.adrian-vault/.env` | Bulk synthesis jobs (hive-synth-*.py scripts) |

## Decision rules (non-negotiable)

1. **If I can execute → I execute.** No asking.
2. **Zero gap between tasks.** When one finishes, the next starts automatically.
3. **Delegate what I can't do.** Antigravity for file analysis. Grok/ChatGPT for strategy consult. Adrian only when strictly blocked on credentials/decisions.
4. **Drafts file silently.** `working/drafts-pending/YYYY-MM-DD-*-*.md`. Never presented as menus.
5. **File protocols.** Anything repeatable gets a canonical doc in `canonical/concepts/`.

## Currently RUNNING (2026-04-24 11:54 WITA)

- **ChatGPT synthesis Phase 1** — PID 52156, started 11:32. 871 conversations via gpt-4.1. Output → `canonical/synthesis/chatgpt-summaries/`. ETA ~1.5 hrs. Log: `~/Desktop/chatgpt-synth.log`. Progress: `canonical/synthesis/.progress-chatgpt-phase1.json`.
- **Facebook synthesis Phase 1** — PID 71429, started 11:54. 306 posts via gpt-4.1-mini. Output → `canonical/synthesis/facebook-summaries/`. ETA ~15 min. Log: `~/Desktop/fb-synth.log`.

## QUEUED (fires after current)

In this order, unless Adrian reprioritises:

1. **Instagram synthesis Phase 1** — 54 DMs + 342 captions + 19 comments. Build script + fire. Smaller than FB.
2. **Rode Rec transcript synthesis** — 7 transcripts on disk, more coming via overwatch daemon. Per-transcript summarisation.
3. **Apple Mail JC SENT folder extraction** — Only INBOX was scanned for JC. Sent folder still pending.
4. **Cross-corpus theme extraction (Phase 2)** — Once all Phase 1 summaries complete, run a second pass that extracts themes across all corpora.
5. **Warm-lead follow-up draft batch** — For the 11 real leads Antigravity deep-read, draft an individualised message per lead. File in `working/drafts-pending/`.
6. **Customs dispute playbook canonical** — Document the systemic process from the customs_disputes hive-search results + canonical notes.
7. **JC Alice iCloud IMAP pull** — BLOCKED on Apple ID app-specific password. Commission only when Adrian provides.

## DELEGATED TO ANTIGRAVITY

Filed at `working/handoffs/2026-04-24-1200-claude-to-antigravity-hive-search-analysis.md`:
- Analyze the 8 hive-search result files (18,781 total hits) produced at 11:29
- Produce per-case strategic brief (one file each, `canonical/cases/<case>-brief.md`)
- Flag the top 10 most consequential hits per case
- No shell execution needed — pure file IO

## DONE TODAY (2026-04-24)

- Memory #24 rewritten with CEO Execution Protocol
- 8-case hive-search executed (18,781 hits, results in `working/hive-search-results/`)
- Facebook extraction verified complete (306 posts, commission from 2026-04-18 closed)
- 11 warm-lead DMs deep-read and filed (done by Antigravity)
- Pasha canonical entry corrected (overstated by overnight synthesis)
- 2 draft messages filed in `working/drafts-pending/` (Toby, Victoria — UNSENT pending Adrian)
- JC Alice hotel concession evidence archived (`canonical/people/jack-canfield-train-the-trainer/evidence/2014-01-14-alice-hotel-concession.md`)
- CEO schedule canonical written (this file)
- Facebook synthesis + ChatGPT synthesis launched async

## DONE (2026-04-26)

- **Provenance certificate system designed** — `canonical/concepts/osb-provenance-certificate-system.md`. ID scheme (OSB-{YEAR}-{SYMBOL}-{NNNNNN}), full certificate component spec, physical design brief, issue process, open questions for Adrian. Executed via phone-prompt remote session test.

## BLOCKED (awaiting unblock)

- **JC Alice iCloud IMAP** — needs Apple ID app-specific password
- **Subconscious Surgery domain transfer** — needs Manu (original developer)
- **Apple ID / iCloud web archive** — needs Adrian login for server-only historic emails

## PROTOCOL UPDATES (new 2026-04-24)

### Frictionless output protocol
- Drafts for external audiences ALWAYS file to `working/drafts-pending/` with date + recipient + channel in filename
- Never present a draft as "Option A / Option B" in chat — file both, name variants in the file
- Exception: if Adrian explicitly asks to see drafts, show them

### Parallel execution protocol
- Multiple synthesis jobs can run simultaneously IF: (a) they use different APIs or have independent rate limits, (b) RAM under 70% pressure, (c) disk >5GB free
- Watchdog: each long-running script must write progress file; if no progress for 15 min, kill and restart

### TCC partition protocol
- Shell execution on Adrian's Mac: only Claude (via osascript) can do this reliably. Antigravity is TCC-sandboxed.
- Antigravity commissions MUST be file-IO only (read corpus, write analysis, no subprocess)
- When TCC blocks Antigravity, Claude picks up execution within 5 minutes, no re-commission needed

## Update cadence

This file is updated by Claude whenever:
- A new task starts (add to RUNNING)
- A task completes (move to DONE TODAY, add new entry from QUEUED to RUNNING)
- A new task is added (append to QUEUED)
- A block is encountered (move to BLOCKED)
- A protocol emerges (add to PROTOCOL UPDATES)
