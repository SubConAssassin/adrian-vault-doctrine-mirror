---
title: Session Lessons — 2026-05-05 Phone Remote Test
type: session-lessons
created: 2026-05-05
session: phone-prompt remote test (Adrian out, bike)
---

## Lesson 1 — The vault mirror is not the full hive mind

The `adrian-vault-doctrine-mirror` GitHub repo contains `canonical/concepts/` only — 34 doctrine files. It does NOT contain `canonical/projects/`, `canonical/people/`, `canonical/synthesis/`, `canonical/cases/`, or `working/`. Any Claude session connected to this repo cannot answer questions about specific people (e.g. Erica), project status, or synthesised intelligence. It can only reason about protocols and doctrine.

**Fix required:** Either (a) Mac-native Claude Code session is the endpoint for all phone prompts, or (b) a broader vault mirror is maintained with non-sensitive project/people data included.

## Lesson 2 — Phone → Mac remote execution is not yet working

The chatgpt-dispatch-protocol and CEO execution schedule assume a Claude Code session is running on the Mac and reachable. This session (Linux server) is not that. When Adrian is remote, there is currently no bridge to the Mac's local execution environment. The Mac cannot receive or execute commands.

**Fix required:** Tailscale + persistent Claude Code session on the Mac, OR a proper remote-access daemon. This needs to be set up and verified while Adrian is physically at the Mac before next trip.

## Lesson 3 — Email monitoring daemon does not exist

The overwatch daemon covers Rode Rec transcription only. There is no email watcher. An email from Erica sat unread for several days with no alert and no draft response generated.

**Fix required:** Build email monitoring daemon using the existing `apple-mail-access-protocol.md` as the access layer. Watch for emails from key contacts, generate alert + draft response, file to `working/drafts-pending/`. Commission to Antigravity when Mac session is active.

## Lesson 4 — Dispatcher protocol is concurrency control, not access control

When Adrian asked "can I set this up through dispatch?" — the answer is no. The Dispatcher Protocol assumes vault access already exists; it manages write conflicts between sessions that have it. It does not grant or route access to the Mac's local environment.
