---
title: MCP Connector Taxonomy — Local vs Remote
type: reference
status: canonical
tier: 2
firewall_class: working-internal
last_updated: 2026-04-21
related:
  - canonical/concepts/claude-mcp-operating-protocols.md
  - canonical/infrastructure/
tags: [infrastructure, mcp, claude-desktop, operational-knowledge]
---

# MCP Connector Taxonomy

Claude Desktop on macOS uses two distinct connector mechanisms. They look identical in the UI but have very different removal paths. Knowing which is which saves investigation time.

## Local connectors

**Stored in:** `~/Library/Application Support/Claude/claude_desktop_config.json` or `~/Library/Application Support/Claude/Claude Extensions Settings/*.json`

**Examples:** Filesystem, PDF Tools, PowerPoint (installed locally), community-built servers

**Removal:** Edit config file directly OR UI removal, then ⌘Q restart. Antigravity can do this via filesystem access.

## Remote / account-level connectors

**Stored in:** The user's claude.ai account (server-side), not on the local machine.

**Examples:** Minutes — Meeting Memory for AI, Gmail, Google Drive, Google Calendar, Wix, PubMed, Kiwi.com, Apify, and most first-party cloud connectors.

**Removal:** UI-only. Settings → Connectors → [name] → Remove. Cannot be edited via local filesystem. Antigravity cannot touch these. If "Remove" doesn't appear in Desktop, use claude.ai/settings/connectors in browser.

## Diagnostic rule

If a connector entry is **not present** in `claude_desktop_config.json` AND not in `Claude Extensions Settings/*.json`, it is a remote connector. Stop searching local config. Go to UI.

## Known persistence quirk

After UI removal, a ⌘Q full-quit and relaunch is required. Closing the window is insufficient — the daemon keeps the old connector list cached.

## Relevant past incidents

- **2026-04-18 / 2026-04-19:** "MCP Minutes — Meeting Memory for AI" disconnection banner. Investigated as local config issue, then correctly identified as remote connector by Antigravity. Resolution: UI removal + restart on 2026-04-21.

## Filesystem MCP degradation (separate but related)

The local Filesystem MCP server degrades after sustained use — manifests as multi-file read timeouts (~4 min) in addition to the previously-documented write timeouts. Fix: full Claude Desktop ⌘Q + relaunch. Observed again 2026-04-21 during this same session.
