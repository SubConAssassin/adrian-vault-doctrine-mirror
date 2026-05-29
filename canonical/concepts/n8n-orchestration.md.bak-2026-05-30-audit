---
title: n8n Orchestration Architecture
type: framework
status: canonical
tier: 2
firewall_class: working-internal
last_updated: 2026-04-24
related:
  - canonical/concepts/n8n-cheatsheet-reference.md
  - canonical/concepts/publishing-connectors.md
  - canonical/concepts/handoff-frontmatter-conventions.md
---

# n8n Orchestration Architecture

## Overview
n8n is the central nervous system of the Adrian-Vault. It bridges the gap between agentic reasoning (Claude/Antigravity) and external execution (publishing, analytics, notifications). Rather than writing brittle Python scripts for every API, n8n provides visual, webhook-driven workflows that are durable and observable.

## Hosting & Execution
- **Environment:** Local Docker deployment on Mac Studio (ARM64). Avoids monthly cloud fees and keeps API keys strictly local.
- **Port:** 5678
- **Persistence:** Volume mounted to `~/.n8n` to retain workflows across restarts.

## Naming & Versioning Conventions
- Workflow files exported as JSON and stored in `tools/n8n-workflows/`.
- Name format: `{trigger}-{action}.json` (e.g., `handoff-watcher.json`).
- Secrets are NEVER stored in the JSON. They are environment variables loaded from `~/.config/com.adrian-vault/.env`.

## Integration Points
1. **Handoff Watcher:** Monitors `working/handoffs/` for new files via filesystem watch. Triggers iMessage/notification to Adrian.
2. **Skill Output Router:** Listens to `working/drafts-pending/` and automatically queues the next stage of the content pipeline.
3. **Publishing Gate:** A stub that halts execution, sends an approval request to Adrian's phone, and waits for a "Presidential Go" before triggering the external API connectors.
