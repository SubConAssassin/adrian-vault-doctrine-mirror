---
title: Antigravity Crash & Stall Recovery Protocol
type: operations-doctrine
status: active
tier: 1
firewall_class: working-internal
authority: Tier-1 (operational doctrine)
created: 2026-05-15
last_updated: 2026-05-15T15:30+08:00
authored_by: claude-code (mac, with Adrian's direct correction)
related:
  - tools/burn-watchdog.sh
  - tools/ui-autoloader.sh
  - canonical/state/2026-05-14-72h-autonomous-burn-schedule.md
  - feedback-screenshot-before-ui-claims.md
purpose: |
  Adrian's correction 2026-05-15: AG never actually crashes. The previous
  watchdog tier-4 kill+relaunch protocol DESTROYED working state every time
  it fired. This document codifies the CORRECT recovery sequence based on
  Adrian's direct experience operating Antigravity.
---

# Antigravity Crash & Stall Recovery Protocol

## Hard rule

**AG has never actually crashed in observed production.** What looks like a crash is almost always:
1. AG paused waiting for a typed answer (Decision question)
2. AG mid-long-synthesis (looks idle but is actually processing)
3. The user (or watchdog) accidentally closed the agent window

**Killing and relaunching Antigravity destroys the conversation context.** That's the lesson from 2026-05-14 / 2026-05-15: every tier-4 relaunch left AG in a broken default-view state where keystrokes went nowhere useful and the burn idled for 5-7 hours until Adrian manually clicked the right button.

## The correct recovery sequence

### Tier 0 — Routine "blue bug button" press

When AG appears stuck or unresponsive:

1. Bring Antigravity to front (osascript `tell application "Antigravity" to activate`)
2. Look for the **blue "bug" button** on the agent panel — same page as the chat, typically in the top portion of the agent panel
3. **Click the blue bug button**
4. AG often resumes from this single click — particularly effective when a transient render issue or a stuck stream is the cause
5. Wait 30 seconds, check if output resumes

This is the FIRST recovery attempt. ~70% of stalls resolve here per Adrian.

### Tier 1 — Send `u` prompt to AG

If tier 0 doesn't recover:

1. AG's `u` shorthand is mapped to "wake up + read the latest state + continue burning"
2. Type `u` into the AG chat input + Enter
3. AG should ACK and resume the queued burn

This is the SECOND attempt. Another ~20% resolve here.

### Tier 2 — Full Antigravity restart (LAST RESORT)

Only after Tier 0 + Tier 1 both fail.

**Restart sequence:**

1. **Quit Antigravity completely:**
   - Cmd+Q OR menu Antigravity > Quit Antigravity
   - Wait 5 seconds
2. **Reopen Antigravity:**
   - `open -a Antigravity` OR click app icon
3. **A service / welcome window appears.** This is the DEFAULT view — NOT the agent window. The autoloader's `continue` keystrokes go nowhere useful at this point.
4. **CRITICAL STEP — Click "Open Agent Window" button:**
   - The button is at the **top of the service window**, slightly to the right of centre
   - Exact label: "Open Agent Window" or near-equivalent (Adrian's reading from memory)
   - This opens the agent panel where the conversation is restored
5. **Once agent window is open:**
   - Reduce / minimise the original service window
   - Position Antigravity on the **right** half of the screen
   - Position Claude (or whatever workflow window) on the **left** half
   - Side-by-side layout is the operational default
6. AG should now respond to autoloader keystrokes again

**Watchdog has tier-4 (relaunch) DISABLED as of 2026-05-15** specifically because the autonomous version of this sequence cannot reliably click the "Open Agent Window" button without knowing its exact coordinates or label. Until that button-name / coordinates are encoded into the watchdog, **only Adrian or a Claude session with current screen coordinates can complete the Tier-2 restart correctly.**

## What the watchdog DOES handle autonomously

| Tier | Trigger | Action |
|---|---|---|
| 0 PROBE | 15 min stale + OCR keyword match | Targeted Enter keystroke |
| 1 | 20 min stale | Cmd+Enter (Accept-all) |
| 2 | 30 min stale | Cmd+Enter + Enter |
| 3 | 40 min stale | Escape |
| ~~4~~ | ~~60 min stale~~ | ~~DISABLED — was kill+relaunch, broke things more than it fixed~~ |
| 5 | 90 min stale | File URGENT handoff to wake Claude session |
| 6 | 120 min stale | iPhone notification (Pushover or fallback) |

The keystroke tiers (0-3) are harmless if no dialog exists. They don't damage AG state. The dangerous tier was 4 and it's now neutered.

## How a Claude session should respond to a tier-5 URGENT

When a `claude-URGENT-burn-stall-tier5-*.md` handoff fires:

1. Take a screenshot of Antigravity state
2. Look at the screenshot — what's actually on screen?
3. If AG is on a decision question: send the answer via osascript keystroke
4. If AG appears stuck without a dialog: send Tier-0 ("click the blue bug button" — via osascript with appropriate click coordinates)
5. If neither resolves in 5 min: file a tier-6 URGENT for Adrian
6. **DO NOT auto-restart Antigravity from Claude. Wait for Adrian.**

## How to encode tier-0 click into automation (open question)

To make tier-0 autonomous, the watchdog needs to know the blue-bug button's screen coordinates. Two ways:

**Option A — Fixed coordinates** (fragile — breaks if Antigravity window resized)
- Adrian provides X,Y screen coordinates while Antigravity is in standard side-by-side layout
- Watchdog uses `cliclick c:X,Y` to click

**Option B — OCR / Vision-based click** (robust — works at any resolution)
- Watchdog takes screenshot
- Uses Apple Vision API to find the blue button by colour + shape
- Clicks the centre of the detected button
- Already have Screen Recording permission; would need to add Apple Vision detection logic

**Option C — Antigravity keyboard shortcut for "blue bug" action** (cleanest)
- If Antigravity has a Cmd+? shortcut that triggers the same action as the blue bug button, watchdog sends that keystroke
- Requires Adrian to find / check the Antigravity keymap

**Recommendation:** Option C if a shortcut exists; otherwise Option B.

## Practice protocol

Adrian asked for a practice run before depending on this in production. Recommended cadence:

1. Adrian schedules a "controlled crash" — actually closes Antigravity intentionally during a working hour
2. Claude (live session) drives the recovery sequence end-to-end via osascript
3. Verify each step:
   - Quit clean? `pgrep` returns nothing
   - Relaunch? `open -a Antigravity`
   - Service window appears
   - "Open Agent Window" button can be clicked via osascript
   - Agent window opens with prior conversation restored
   - Autoloader `continue` keystroke now reaches the chat input
   - AG resumes producing
4. Encode the working sequence into watchdog as Tier-4 RESTORED (with Adrian's button-coordinate or shortcut)
5. Re-test 24h later by triggering another controlled crash

**Don't run this practice while a high-value burn is mid-flight** — risk losing the conversation context if recovery fails.

## Anti-patterns (do not repeat)

1. **Auto-relaunching AG on assumption of crash** — see watchdog tier-4 disable. AG doesn't actually crash that way. Symptoms of "stuck" almost always = paused on decision, not crashed.
2. **Autoloader skipping cycles when AG is stale** — creates deadlock. Was removed 2026-05-15.
3. **Treating AG as a single-failure-mode system** — there are at least 3 distinct stall shapes (decision question / Accept-all dialog / app-state issue). Each needs different intervention. The watchdog tiers approximate this but aren't perfect.

— Claude Code (Mac, 2026-05-15 15:30 WITA, codifying Adrian's 2026-05-15 direct correction)

---

# Coordinated keystroke authority (2026-05-16, Adrian-commissioned)

## The problem Adrian flagged

Over-prompting was crashing AG. Root cause: **four uncoordinated keystroke
injectors** all typing into the one AG chat input with no shared rate-limit:

| Injector | Was | Problem |
|---|---|---|
| `ui-autoloader.sh` | every 210s, **always "continue"** | only one that click-focuses → only one that lands; never sent `u`, so AG never read fresh handoffs, just ground the old commission forever |
| `autoloader_daemon.py` (launchd) | every 30s, `u`+Enter per claude-to-ag file | no click-focus → fired into the void; uncoordinated |
| `burn-watchdog.sh` | every 60s, Enter/Cmd-Enter/Escape rescue | uncoordinated; piled on mid-synthesis |
| `hive-supervisor.sh` | 120s poll, big AUTO-DISPATCH on idle | uncoordinated; could clobber a priority handoff |

When AG was mid-synthesis (looks idle, is working) these stacked within the
same minute → crash. And the only injector that landed always said "continue",
so a freshly-filed `claude-to-ag-*` handoff sat unread.

## The architecture now (DO NOT regress this)

**`ui-autoloader.sh` is the SOLE primary keystroke authority.** Contract:

- **Shared gate file:** `working/_locks/ag-keystroke.quiet-until` (epoch).
  Every injector that keystrokes AG publishes it after a send; every *other*
  injector MUST NOT keystroke while `now < quiet-until`.
- **ui-autoloader** rotates the directive:
  - `continue` (grind) — default cycles, 210s cadence.
  - `u` (read the hive) — every 5th cycle: tells AG to read AGENTS.md §11.1
    bootup order + `working/handoffs/` + STATE-OF-STACK before continuing.
  - **priority `u`** — when a `claude-to-ag-*.md` is newer than the newest
    `ag-to-claude-*.md` and not yet served: a `u` that NAMES the handoff and
    says it takes precedence over the grind. This is how time-sensitive work
    jumps the queue. After a `u`/priority send it reserves a **420s protected
    settle** so AG can read + act + file an `ag-to-claude` reply uninterrupted.
- **burn-watchdog** — keystroke rescue tiers 0–3 are gated on `quiet-until`
  (skip if inside). Diagnostics (screenshot/OCR) and the non-keystroke safety
  escalations (tier-5 URGENT handoff, tier-6 push) are **NOT** gated — the
  human-wake path always works. Keystroke tiers are deliberately *subordinated*
  to ui-autoloader, not broken.
- **hive-supervisor** — keeps burn-watchdog alive (unchanged, load-bearing).
  Its idle auto-dispatch is gated on `quiet-until` (defers, never clobbers a
  priority handoff). After its own dispatch it publishes a 420s settle.
  **Singleton is now race-free** (atomic `mkdir` lock + trap cleanup at
  `working/_locks/hive-supervisor.lockd`) — the old pidfile check was
  startup-TOCTOU and leaked parallel supervisors = parallel dispatch = the
  exact pile-up. Proven: 5 concurrent launches → 5 guard-rejections, 1 survivor.
- **autoloader_daemon.py** — DEMOTED to notify-only. Never keystrokes AG.

Delivery is **clipboard-paste, not keystroke-typing** (`pbcopy` → Cmd+V) in
ui-autoloader + hive-supervisor — per ChatGPT autonomous-hive review §1.4,
removes dropped-character + AppleScript-quote-parsing fragility.

## Why this is interim, not the final architecture

ChatGPT's 2026-05-15 autonomous-hive review
(`working/external-research-in/_github-cache/inbox/2026-05-15-chatgpt-to-claude-autonomous-hive-system-review.md`)
is correct that the durable fix is a **local control plane** (SQLite job
queue + lease + heartbeat + output quarantine + deterministic verifier +
promotion), not a cleverer GUI nudger. This coordination work is a
*precondition* for that, not a substitute. The job-queue/verifier program is a
separate, Adrian-gated initiative — see `canonical/state/open-initiatives.md`.
Do not silently expand the nudger; build the trust boundary instead when greenlit.

— Claude (Cowork, 2026-05-16 ~01:20 WITA, codifying Adrian's keystroke-cadence
fine-tuning directive + ChatGPT hive-review §1)


## Frontmost-or-abort (2026-05-16 incident + hard rule)

**Incident:** ui-autoloader fired its `continue ... STANDING ORDER` directive
and it pasted + Entered into a *live Claude session* (recurring every ~210s)
because `tell application "Antigravity" to activate` silently failed to raise
AG over the frontmost app (Claude/Electron). The clipboard paste + Return went
to whatever the user had focused.

**Hard rule (now in all three injectors — ui-autoloader.send_directive,
hive-supervisor.dispatch_next_mission, burn-watchdog.attempt_ui_rescue):**
before any click/paste/keypress, `activate` then re-check the frontmost
process name (retry ~6×); proceed ONLY if it is `Antigravity`; otherwise
**abort the cycle and log `abort:not-frontmost:<app>`** — never send. Leaking
a paragraph + Return into the user's focused app is strictly worse than
skipping a prompt. Do not remove this guard to increase AG prompt frequency.
Directive text must be ASCII (the clipboard mangled the em-dash).

**Operational implication (must be understood, not papered over):** with the
guard, AG is only prompted on cycles where Antigravity is frontmost. When the
user is actively in another app, cycles cleanly abort (safe) but AG is not
nudged those cycles; it is still prompted whenever AG is frontmost (its own
Space / user not foregrounding another app). Watchdog tier-5 URGENT + tier-6
push are ungated and still escalate genuine stalls. This is the GUI keystroke
path's structural ceiling and is the strongest concrete argument for the
Phase-2 headless/file-queue control plane — the guard makes the failure *safe*,
not *absent*.
