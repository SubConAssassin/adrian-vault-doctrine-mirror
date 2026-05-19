---
title: Session Lessons — 2026-05-05 Phone Remote Test
type: session-lessons
created: 2026-05-05
session: phone-prompt remote test (Adrian out, bike)
---

## Lesson 1 — The vault mirror is not the full hive mind

The `adrian-vault-doctrine-mirror` GitHub repo contains `canonical/concepts/` only — 34 doctrine files. It does NOT contain `canonical/projects/`, `canonical/people/`, `canonical/synthesis/`, `canonical/cases/`, or `working/`. Any Claude session connected to this repo cannot answer questions about specific people (e.g. Erica), project status, or synthesised intelligence. It can only reason about protocols and doctrine.

**Fix required:** Either (a) Mac-native Claude Code session is the endpoint for all phone prompts, or (b) a broader vault mirror is maintained with non-sensitive project/people data included.

## Lesson 2 — Phone → Mac remote execution: native solution exists

**UPDATED 2026-05-19:** The fix is simpler than originally recorded. Anthropic released **Claude Code Remote Control** in February 2026. Run `claude remote-control` in Terminal on the Mac; the Claude iOS/Android app then connects directly to that session. Full vault access, all MCP servers, all local tools — through the mobile Claude app. Outbound HTTPS only, no open ports, no router config.

**One constraint:** Terminal must stay open and awake on Mac. Session times out after ~10 min offline. For the Mac Studio setup, this means leaving it always-on at home with `claude remote-control` running in a persistent tmux window.

**Tailscale** remains the backup/complement — install on both Mac and iPad, then SSH via Blink Shell or Termius for pure terminal access when Remote Control isn't needed.

**Action:** Set up and test `claude remote-control` on the Mac before the America trip. Verify from iPad. Then it's solved.

## Lesson 3 — Email monitoring daemon does not exist

The overwatch daemon covers Rode Rec transcription only. There is no email watcher. An email from Erica sat unread for several days with no alert and no draft response generated.

**Fix required:** Build email monitoring daemon using the existing `apple-mail-access-protocol.md` as the access layer. Watch for emails from key contacts, generate alert + draft response, file to `working/drafts-pending/`. Commission to Antigravity when Mac session is active.

## Lesson 4 — Dispatcher protocol is concurrency control, not access control

When Adrian asked "can I set this up through dispatch?" — the answer is no. The Dispatcher Protocol assumes vault access already exists; it manages write conflicts between sessions that have it. It does not grant or route access to the Mac's local environment.
