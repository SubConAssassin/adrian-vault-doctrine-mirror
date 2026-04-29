---
title: Sleep-Time Protocol — Overnight Autonomous Multi-Agent Work
type: canonical-doctrine
status: active
version: 1.0
created: 2026-04-30 (1:30 AM WITA)
last_updated: 2026-04-30
authored_by: claude (Claude Code, CTO mode, post-renderer-pause iteration 11)
purpose: Codify what actually works for overnight unattended work across Claude Code + Antigravity + Terminal sequencer + external APIs, and capture the failure modes that have caused past overnight attempts to deliver nothing while Adrian slept.
related:
  - canonical/concepts/claude-antigravity-work-partition.md (partition v2)
  - canonical/concepts/frictionless-operator-doctrine.md
  - canonical/concepts/api-integration-doctrine.md
  - canonical/concepts/session-lessons-2026-04-24.md (mistake catalogue)
  - canonical/roadmaps/hive-mind-implementation-plan-2026-04-24.md
  - working/handoffs/2026-04-30-2055-claude-loop-paused-renderer-runaway-recurrence.md
tags: [sleep-protocol, overnight, frictionless, multi-agent, partition-v2-companion]
---

## 1. Architectural truth (what each agent can/cannot do unattended)

| Agent | Survives Mac sleep? | Survives Claude Code terminal close? | Permission-blocked? | Sandbox limits? |
|---|---|---|---|---|
| **Claude Code (this session)** | No (laptop sleep suspends terminal) | No (loop dies with session) | Yes — Bash patterns not in `.claude/settings.local.json` block on prompt | None inside session, but ~5h token window |
| **Antigravity (Cowork)** | Maybe (depends on caffeinate + Cowork app foreground) | Yes (independent app) | Yes — TCC + Cowork sandbox | **Cannot run shell scripts in vault tree** (TCC) |
| **Terminal sequencer (Adrian-launched bash script)** | Yes if `caffeinate` running | Yes (independent process) | No (runs with Terminal's TCC, full disk access if granted) | None beyond what bash can do |
| **External APIs (ChatGPT/Grok)** | Yes (cloud-side) | Yes | No — direct API key, no UI prompt | Cannot write to local FS without local agent |

**Implication:** **Claude Code is the weakest substrate for unattended overnight work.** Real overnight graft goes to AG (file-IO) and Terminal sequencer (shell). Claude Code is a steerer, not a workhorse.

## 2. Failure modes observed (canonised — do not relearn)

| ID | Failure | Diagnosis | Mitigation |
|---|---|---|---|
| **F1** | iCloud stubs hang Python silently | File appears present (`ls`) but `du -sh` returns 0; `zipfile.ZipFile()` blocks waiting for invisible iCloud download | `du -sh` before any heavy op; `brctl download <path>` to force-pull; never run heavy ops on iCloud-synced folders without staging to `~/scratch/` first |
| **F2** | macOS sleeps mid-job | Laptop sleeps after idle; all agents suspend | `caffeinate -i &` in a separate Terminal before bed; or System Settings → Battery → Prevent sleeping when display is off |
| **F3** | Claude Desktop renderer-runaway | Helper Renderer CPU climbs 100% → 250%+ over 5–15 min; pauses Claude Code work | Close all Claude Desktop tabs except active one; quit Cowork if not in use; disable polling-heavy MCP servers; if recurrent, the renderer's likely stuck on a specific long-history conversation (close that tab) |
| **F4** | Bash permission prompt blocks loop | New Bash pattern not in `.claude/settings.local.json` allow list triggers user-approval UI; loop blocks | Stick to Bash patterns already used and approved this session; pre-add anticipated patterns to settings BEFORE bed |
| **F5** | Token exhaustion | Natural; not preventable | Loop terminates cleanly; completion report flushes state |
| **F6** | Fabricated overnight commission completes in seconds | "Review the canonical and tell me what you think" = 5-second AG output, not 6 hours of work | Commissions MUST specify scale: 100+ files / full-corpus operation / cross-source synthesis / batch API processing. See §5. |
| **F7** | AG TCC sandbox blocks shell | AG cannot run bash/python in vault tree | File-IO-only commissions for AG; shell work goes to Terminal sequencer |
| **F8** | Cowork VM bundle auto-regenerates | After delete, Cowork recreates the 9.7GB bundle on next Claude Desktop launch | Disable Cowork in Claude Desktop Settings if not actively using; or delete bundle as last act before sleep |

## 3. Pre-sleep checklist (Adrian — run every step or skip overnight work)

Before saying "I'm going to sleep":

1. ✅ **`caffeinate` is auto-launched by Claude Code at loop start** (Adrian no longer manual). Implementation: `Bash(caffeinate -i &)` with `run_in_background=true` as the first action of any sleep-window loop session. Lives until Claude Code session ends. Adrian only manually launches `caffeinate` if running a Terminal sequencer alone (no Claude Code involved).
2. ✅ **Quit Claude Desktop** (or close all non-active tabs and Cowork). Pre-empts F3 renderer-runaway.
3. ✅ **Verify Antigravity has a substantive commission** — at least one of the §5 scale-shapes.
4. ✅ **Verify Claude Code `/loop` is firing** — `ls -t working/handoffs/ | head -3` should show recent loop iteration outputs OR the loop is in `pending` state with a defined task list in `working/_loop-state/`.
5. ✅ **Pre-download any iCloud-synced target files** — `for f in /path/to/files/*; do brctl download "$f"; done`. F1 mitigation.
6. ✅ **Pre-approve anticipated Bash patterns** in `.claude/settings.local.json`. F4 mitigation. Common patterns: `bash <vault>/tools/*.sh`, `python3 <vault>/tools/*.py`, `du`, `find`, `grep`, `ls`, `wc`, `mkdir`, `head`, `tail`, `sort`, `uniq`.
7. ✅ **Verify settings.local.json allow list** covers everything the loop / sequencer / AG-shell-fallback might need.
8. ✅ **Confirm wakeup signal locations:** AG ack files in `working/handoffs/<date>-antigravity-ack-*.md`; Claude completion report in `working/handoffs/<date>-overnight-claude-completion-report.md`; pause notices in `working/handoffs/<HHMM>-claude-loop-paused-*.md`.

If any item is `❌`, treat as blocker — do NOT expect overnight productivity from that agent.

## 4. Working patterns (what does deliver hours of real work)

- **W1. AG file-IO commission** — 1–4 hours of structured graft. Examples in §5.
- **W2. Terminal sequencer (`~/Desktop/overnight-run-YYYY-MM-DD.sh`)** — Adrian launches `caffeinate -i bash ~/Desktop/overnight-run.sh > ~/Desktop/overnight.log 2>&1 &` before bed. Survives every failure mode except disk-full and external API auth expiry.
- **W3. Claude Code `/loop` self-paced** — best-effort 1–3 hours; will pause on F3 renderer-runaway or end on F5 token exhaustion. Always writes a completion report when it stops cleanly.
- **W4. External-API async research** — Deep Research, ChatGPT batch, Grok query batch. Results land in Drive bridge folders or via direct API archive; orthogonal to local agents.

**The right overnight is parallel — pick 2 of W1+W2+W3 simultaneously, never just W3 alone.**

## 5. How to spec a real overnight AG commission (anti-F6)

A 6-hour AG job has at least ONE of these scale-shapes:

- **Multi-hundred file operation** — e.g. process every file in `working/extraction/staging/*` (currently 200+ unprocessed staging files) into canonical synthesis with frontmatter normalisation.
- **Full-corpus cross-reference** — e.g. cross-reference all 871 ChatGPT summaries against all 169 Facebook summaries for date-coincidence event clustering; output one new canonical/synthesis/cross-source-event-clusters.md.
- **Batch external-API synthesis** — e.g. send 100 raw transcript files to ChatGPT API for individual synthesis (one-shot per question = one-shot per file in this batch); structure the responses into a per-file canonical doc.
- **Build full vault search index** — extract every canonical file's frontmatter + first 500 chars + tag set + last_modified into a single queryable JSON; serves the long-term "Internet of Adrian" goal.
- **Sacred-site geotag enrichment** — extract every photo's GPS coordinates from EXIF, cross-reference against a sacred-sites database (lat/long lookup), tag photos with sacred-site proximity.
- **Photo facial-recognition clustering** — group all photos by detected face, label clusters using existing canonical/people/ profiles, surface unmatched faces as `needs-adrian` candidates.
- **Spiritual symbol / jewellery design corpus extraction** — across photos, identify and tag every Arcturian / sacred-geometry / pendant motif; build symbol catalog with photo references.

**Anti-pattern (F6):** "review canonical/concepts/ and propose improvements" — 5 seconds, no graft.

## 6. The "Internet of Adrian" long-term goal

Per Adrian's stated long-term vision: every piece of content (Dropbox 4TB, iCloud, hard drives when plugged in, Google folder, ChatGPT archive 871 convos, Facebook 169 posts, Instagram, Rode Recordings, voice memos, photos, jewellery designs, sacred site visits, every business across 5 ventures) **fully simulated, cross-referenced, wiki-built like the Internet** — so any question pulls every relevant detail.

This is **Phase A++ of `canonical/roadmaps/hive-mind-implementation-plan-2026-04-24.md`** — comprehensive corpus assimilation. Each overnight that delivers W1+W2+W3 in parallel chips meaningfully at this corpus.

The 5-business stack work depends on this corpus being mostly-complete; the businesses cannot be built cleanly until the founder's full operating context is queryable. **Sleep-time protocol is therefore strategically critical, not merely operational hygiene.**

## 7. The 64 GB upgrade — what changes

Per `claude-antigravity-work-partition.md` §11, hardware ceiling currently 18 GB. At 64 GB:

- **F3 renderer-runaway** less likely (more headroom; same Electron process, but less swap pressure)
- **AG can run heavier in parallel** with Claude Code without collision
- **Cowork VM bundle** can stay mounted without RAM pressure
- **Larger archive operations** become feasible locally (>500 MB extractions stay home, no cloud-VM redirect)
- **BUT:** AG TCC sandbox still applies (F7) — 64 GB doesn't unlock shell access
- **BUT:** macOS sleep (F2), iCloud stubs (F1), permission prompts (F4), token exhaustion (F5) all unchanged
- **Sleep-time protocol §1-§6 ALL still apply at 64 GB.** Only the resource margins change.

Investment value: removes one major failure mode (F3) but does not make the protocol obsolete. Keep this doc canonical post-upgrade.

## 8. The wakeup signal — what Adrian reads first

In order, when Adrian opens the laptop in the morning:

1. **`ls -lt working/handoffs/ | head -10`** — most-recent files first. Spot any pause notices (filename includes "paused"), AG acks (filename includes "antigravity-ack"), Claude completion reports (filename includes "overnight-claude-completion-report").
2. **Read the latest pause notice if any** — diagnose before re-launching.
3. **Read the AG ack(s)** — confirm work was real (file count, byte deltas, time elapsed). F6 detection.
4. **Read the Claude completion report** — what landed, what remains.
5. **Read any new canonical/* files modified overnight** — `find canonical -newer working/_loop-state/hive-mind-execution-2026-04-24.md -type f -name '*.md'`.

## 9. Lessons committed (do not relearn)

- **Claude Code is the steerer; AG is the workhorse on file-IO; Terminal sequencer is the workhorse on shell.** Match agent to substrate, never invert.
- **Real overnight work has scale.** If it can be done in 5 seconds it cannot be done in 6 hours — pick another commission.
- **The pre-sleep checklist is non-negotiable.** Every item or no overnight productivity.
- **Renderer-runaway is now its own failure class** — diagnose specifically (F3 mitigations) rather than rebooting blindly.
- **`caffeinate` is the cheapest highest-leverage overnight habit.** One command before bed.
- **The completion report at `working/handoffs/<date>-overnight-claude-completion-report.md` is the contract** — Claude Code writes this when its loop terminates cleanly, signalling the wakeup state.

## 10. Tonight's specific state (2026-04-30 → 2026-05-01)

- **Antigravity:** running photo extraction job per Adrian's note (substantive — passes §5 scale test).
- **Claude Code (me):** re-issuing `/loop` to grind through T11.2–T17 (OSB book outline, marketing copy templates × 5, CLAUDE.md amendment, edit-lease protocol, SSoT audit, validator run, final completion report). ~7 light iterations. Will terminate on token exhaustion or F3 renderer-runaway, whichever first. Will write completion report on terminate.
- **Terminal sequencer:** none active tonight (no shell graft queued).
- **External APIs:** none scheduled async tonight.
- **Adrian's pre-sleep checklist tonight:** `caffeinate` recommended before bed; quit Claude Desktop tabs except this one; settings.local.json already approves Bash patterns the loop needs.

End of sleep-time protocol v1.0. Iterate as more overnight failure modes are observed.
