---
title: Publishing & Analytics Connectors
type: reference
status: canonical
tier: 2
firewall_class: working-internal
last_updated: 2026-04-24
related:
  - canonical/concepts/n8n-orchestration.md
  - canonical/concepts/api-integration-doctrine.md
---

# Publishing & Analytics Connectors

## Overview
This defines the architecture for interacting with external APIs (Meta, TikTok, LinkedIn, X, GA4). The `mkt-social-deploy` skill delegates execution to these Python modules.

## API Tiering & Costs
- **Meta Graph API (FB/IG):** Free tier. Requires OAuth long-lived tokens.
- **LinkedIn API:** Free tier (Basic).
- **TikTok Content API:** Free tier.
- **X (Twitter) API:** Paid Basic Tier ($100/mo). All functions locked behind `# REQUIRES PRESIDENTIAL GO`.
- **GA4 Analytics:** Free tier.

## Credential Management
Credentials live strictly in `~/.config/com.adrian-vault/.env`. Scripts load them dynamically. Never hardcode tokens in the python files.

## Presidential Go (The Spend Gate)
Any script or function that executes a paid ad spend, or interacts with a paid API tier (like X), MUST raise a `PresidentialApprovalRequired` exception by default. Adrian must manually override this exception via the n8n approval flow to allow the spend.
