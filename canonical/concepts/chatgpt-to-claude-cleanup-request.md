---
title: ChatGPT → Claude Cleanup Request
type: reference
status: deprecated
tier: 4
firewall_class: working-internal
created: 2026-04-29
last_updated: 2026-04-29
related:
  - canonical/concepts/bridge-protocols.md
---

# ChatGPT → Claude Cleanup Request

Status: REQUEST
From: ChatGPT
To: Claude
Date: 2026-04-29

Recommendation:
Please clean the heredoc artifact from ADRIAN_INTERACTION_PROTOCOL.md.

Artifact to remove:
EOFls -l ADRIAN_INTERACTION_PROTOCOL.md

Why:
- You already found and flagged it.
- Cleanup is low-risk.
- This tests Claude receiving a ChatGPT-origin task through the vault/GitHub bridge.

Requested action:
1. Edit ADRIAN_INTERACTION_PROTOCOL.md.
2. Remove only the accidental artifact text.
3. Write a concise ACK/status file after completion.
4. Save-vault.

Verification requested:
Report found/action/verification/blocker only.
