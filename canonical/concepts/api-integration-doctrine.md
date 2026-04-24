---
title: API Integration Doctrine
type: canonical-doctrine
status: active
version: 1.1
last_updated: 2026-04-24
last_verified: 2026-04-24
authored_by: claude (codifying 2026-04-22 integration work; v1.1 budget-frugality 2026-04-24)
related:
  - canonical/concepts/bridge-protocols.md
  - canonical/concepts/frictionless-operator-doctrine.md
  - canonical/concepts/tooling-preference-doctrine.md
  - canonical/concepts/hive-mind-resource-map.md
---

# API Integration Doctrine

This document outlines the API integration principles and operational patterns for direct cross-model and external access in the hive mind. It supersedes older courier-primary methods, establishing direct API usage as the primary inter-agent communication channel.

## Core Principles

1. **Zero-relay principle:** Claude calls ChatGPT/Grok APIs directly. There is no manual forwarding step required from Adrian.
2. **Frictionless operation:** True frictionless design means zero recurring manual action by Adrian. The direct API is always primary; the Drive courier/bridge mechanism acts purely as an audit trail and fallback.

## Infrastructure and Security

### Key Storage
API keys are stored centrally in a single `.env` file to ensure a single source of truth and avoid leakage in canonical documentation or scripts.
- **Path:** `~/.config/com.adrian-vault/.env`
- **Keys contained:** `OPENAI_API_KEY`, `XAI_API_KEY`

### Bridge Tool Invocations
Agents with shell capabilities can invoke the APIs directly using canonical wrapper scripts:

- **ChatGPT:** `python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py "prompt"`
  - **Default Model:** `gpt-5.4-mini` (via Responses API endpoint) — frugal, ~6x cheaper than full 5.4
  - **Escalation Model:** `gpt-5.4` (via `--model gpt-5.4`) — use only when reasoning demands it
  - **Flagship Model:** `gpt-5.5` (via `--model gpt-5.5`) — when released; for frontier reasoning only
  - **Fallback Model:** `gpt-4.1` (via Chat Completions endpoint) — automatic on Responses API failure
  - **Flags:** `--max-tokens N` (default 800), `--stdin` (pipe long context for comprehensive single-shot prompts)
  
- **Grok:** `python3 ~/Documents/Adrian-Vault/tools/ask-grok.py "prompt"`
  - **Primary Model:** `grok-4`
  - **Additional capabilities:** The same xAI key unlocks `grok-imagine-image` and `grok-imagine-video`.

### Shadow Copies
For agents that operate in contexts without access to `~/Documents/` (e.g. strict sandboxes), shadow copies of the tools exist:
- `~/Library/Application Support/com.adrian-vault/ask-chatgpt.py`
- `~/Library/Application Support/com.adrian-vault/ask-grok.py`

### Archive Pattern
Every API call automatically writes its interaction to Google Drive to maintain a persistent audit trail.
- **ChatGPT calls:** Saved to `Google Drive/ChatGPT-Bridge/chatgpt-to-claude/`
- **Grok calls:** Saved to `Google Drive/Grok-Bridge/grok-to-claude/`

## Capability Routing

Different APIs serve specific purposes based on their strengths:

- **ChatGPT:**
  - Long-form reasoning cross-reference
  - Second opinion on architecture
  - Broad knowledge checking and multi-page web synthesis

- **Grok:**
  - Capability probing
  - Divergent thinking and unfiltered perspectives
  - Image and video generation

- **Both:**
  - Cross-referencing technical claims according to the collaboration doctrine. Used intentionally to check biases and blind spots.

## Cost Context

### Budget
- **Monthly budget:** $40 total across all external APIs (Adrian directive, 2026-04-24).
- **ChatGPT credits:** $10 loaded on 2026-04-22; $8.62 consumed by 2026-04-24 (bulk spent on Apr 24).

### Pricing (per 1M tokens)
| Model | Input | Cached Input | Output | Notes |
|---|---|---|---|---|
| gpt-5.5 (coming) | $2.50 | $0.25 | $15.00 | Flagship — reserve for frontier reasoning |
| gpt-5.4 | $1.25 | $0.125 | $7.50 | Escalation only |
| **gpt-5.4-mini** | **$0.375** | **$0.0375** | **$2.25** | **Default — hive-mind workhorse** |
| grok-4 | $3.00 | — | $15.00 | Grok divergent / capability probing |

**Batch API (OpenAI):** -50% on all rates; use for non-urgent bulk work.

### Headroom at $40/month
- gpt-5.4-mini standard: ~100M tokens/month
- gpt-5.4-mini batch: ~200M tokens/month
- gpt-5.4 full standard: ~13M tokens/month (tight)

### Frugality Rules
1. **Default to mini.** Escalate only with explicit reason (reasoning depth proven insufficient on mini).
2. **One comprehensive prompt > many round-trips.** Output tokens cost 4-6x input.
3. **Cap `--max-tokens`** to what's actually needed (default 800).
4. **Cache prefixes.** Put stable context (doctrine, voice profile, project state) at the TOP of long prompts — OpenAI auto-caches after first call, cutting cached input to 10% of full rate.
5. **Pipe via `--stdin`** for long context — avoids re-encoding in subsequent calls and keeps prompts single-shot.
6. **Batch non-urgent work** via OpenAI Batch API (50% off) — currently manual via dashboard, not yet wired into ask-chatgpt.py.
7. **Local-first override** — if a local tool exists (see `tooling-preference-doctrine.md`), use it before any paid API.
