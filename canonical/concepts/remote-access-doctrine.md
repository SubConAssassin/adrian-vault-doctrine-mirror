---
title: Remote Access Doctrine — iPad/Phone → Mac
type: canonical-doctrine
status: active
created: 2026-05-19
authored_by: claude (tidy-up session)
distilled_from: session-lessons-2026-05-05.md + session 2026-05-05 phone remote test
tags: [remote-access, claude-code, tailscale, ipad, mobile, mac-studio]
related:
  - canonical/concepts/chatgpt-dispatch-protocol.md
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/hive-mind-resource-map.md
  - canonical/concepts/overwatch-daemon-operations.md
---

# Remote Access Doctrine — iPad/Phone → Mac

Governing reference for how Adrian accesses the Mac and the hive mind from mobile devices. Distilled from a live test session (2026-05-05) where the remote setup was found to be incomplete.

---

## Architecture clarity (read first)

Three things that are often confused:

| | What it is | Mac involved? | Vault access? |
|---|---|---|---|
| **Claude app on iPad/iPhone** | Full Claude running on Anthropic's servers | No | Doctrine mirror only |
| **Claude Code Remote Control** | Claude app connects to a live Mac Terminal session | Yes — Mac stays on | Full vault + MCP + tools |
| **Dispatch (chatgpt-dispatch.sh)** | Routes a task to ChatGPT via AppleScript on Mac | Yes — Mac runs script | Not applicable |
| **Local LLM on iPad** | Small AI model running on iPad chip offline | No | None |
| **SSH via Tailscale** | Terminal access to Mac from anywhere | Yes — Mac stays on | Full filesystem |

**Key point:** When Adrian talks to Claude via the mobile app with no Remote Control active, the Mac is not involved at all. Anthropic's servers do all the work. The iPad is just a display.

---

## The native solution — Claude Code Remote Control

Released February 2026. Built into Claude Code CLI. No third-party tools required.

### Setup (one-time, on Mac)

Ensure Claude Code is up to date:
```bash
claude --version
```

### Running it

On the Mac, in a Terminal window (or tmux pane — recommended for persistence):
```bash
claude remote-control
```

That's it. The Mac makes outbound HTTPS connections to Anthropic's servers. No open inbound ports. No firewall changes. No router config.

### Connecting from iPad/iPhone

Open the Claude app → connect to the running Remote Control session. The mobile session now has:
- Full Mac filesystem access
- All configured MCP servers
- All tools and scripts in the vault
- The same capabilities as a local Mac Claude Code session

### Constraint

Terminal must stay open and the Mac must stay awake and networked. If offline for ~10 minutes, session times out. Restart with `claude remote-control` again.

**For Mac Studio:** run in a tmux window so the session persists across disconnections and is easy to reattach.

---

## Backup — Tailscale + SSH

For pure terminal access (no GUI, lower overhead):

1. Install [Tailscale](https://tailscale.com) on Mac and iPad — free for personal use
2. Both devices join the same private tailnet automatically
3. From iPad: use **Blink Shell** or **Termius** (SSH apps) to SSH into the Mac via its Tailscale address
4. Run `claude` in that SSH session — full Claude Code with vault access

Benefits over Remote Control:
- More robust to network drops (SSH + tmux survives disconnection)
- Lower overhead
- Works even if Claude Code Remote Control times out

Use both: Remote Control for Claude sessions, Tailscale SSH for terminal/script work.

---

## Local LLM on iPad (context only)

Apps exist to run quantised models entirely on iPad M4 chip (16GB RAM required):
- **Private LLM** — Llama, Gemma, Mistral, Qwen
- **LLM Farm** — llama.cpp based, broad model support
- **Pocket LLM** — Apple MLX optimised

Viable for offline/private simple tasks. Not Claude-grade for strategic reasoning, synthesis, or vault work. Not part of the primary stack — noted here for completeness.

---

## What needs to happen before the America trip

1. `claude --version` on Mac — confirm Remote Control is available
2. Run `claude remote-control` in a tmux window — test connection from iPad Claude app
3. Install Tailscale on Mac — verify iPad can SSH in
4. Leave Mac Studio always-on with both running
5. Test full vault access (read a canonical file, run a script) from iPad before departing

---

## What dispatch is NOT

The `chatgpt-dispatch.sh` script routes prompts to ChatGPT via AppleScript. It is a task router to a different AI model, not a remote access mechanism. It requires a Mac session to be active and cannot be used to establish or replace remote access. See `canonical/concepts/chatgpt-dispatch-protocol.md`.

The Dispatcher Protocol (`canonical/concepts/dispatcher-protocol.md`) is concurrency control between sessions that already have vault access. It does not grant access.
