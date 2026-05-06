---
title: API Integration Doctrine
type: doctrine
status: active
tier: 2
firewall_class: working-internal
version: 2.0
last_updated: 2026-04-30
last_verified: 2026-04-30
authored_by: claude (v2.0 cash-flow lockdown 2026-04-30 — Adrian directive after $53 OpenAI+Grok overspend in 24h)
related:
  - canonical/concepts/bridge-protocols.md
  - canonical/concepts/frictionless-operator-doctrine.md
  - canonical/concepts/tooling-preference-doctrine.md
  - canonical/concepts/hive-mind-resource-map.md
---

# API Integration Doctrine

## ⛔ PRIORITY 0 — SUBSCRIPTION-FIRST ROUTING (HARD RULE)

**Adrian already pays flat-rate for: Claude Max, ChatGPT Plus, Gemini, Grok subscription. These are pre-paid. Metered APIs cost extra cash on top. Cash flow is tight.**

**Default routing (free first):**

1. **This Claude session** — already paid for. Use it for thinking, drafting, analysis.
2. **Claude Code CLI / Antigravity** — flat-rate via Claude Max. Use for batch/headless/automation work. **All multi-file or multi-call jobs route here, not the API.**
3. **ChatGPT desktop app / Grok web / Gemini web** — flat-rate. Use for second opinions via manual paste-in.
4. **Metered APIs (OpenAI, xAI/Grok, Anthropic) — LAST RESORT.** Only when:
   - The task is a single technical query that genuinely cannot be answered without a model call from inside a script
   - AND there is no path to do it via a subscription-backed tool
   - AND the projected cost is under $0.10 for the single call

**Hard monthly cap across all metered APIs combined: $30/month** (= equivalent to one Claude Max subscription, Adrian's stated ceiling). Daily soft cap: $1. If projected spend would exceed either, **stop and surface the cost to Adrian in chat before any call**.

**Forbidden patterns:**
- ❌ Batch processing N>10 files through ask-chatgpt.py / ask-grok.py. Route through Claude Code.
- ❌ "Let me just ask ChatGPT" reflex when the question can be reasoned in-session or pasted into ChatGPT desktop.
- ❌ Unattended cron/launchd jobs hitting metered APIs without an explicit cost ceiling.
- ❌ Multi-round conversations through the API. One concierge prompt → one comprehensive answer. If a follow-up is needed, write a new comprehensive prompt; do not loop.

**Enforcement:**
- OpenAI dashboard hard cap: $5 (Adrian to set at platform.openai.com/settings/organization/limits)
- xAI/Grok dashboard hard cap: $5 (Adrian to set at console.x.ai)
- All API wrapper scripts must log every call to `working/api-usage.jsonl` — no exceptions, no silent paths
- Any script making OpenAI/Grok calls must be auditable from the cost log, or it gets disabled

**Failure mode this rule prevents:** 2026-04-30 incident — synthesis pipeline processed 871 conversations through OpenAI ($26) and a parallel Grok job ($27), totalling $53 in one day = ~2 months of monthly cap. Both jobs could have run free through Claude Code. This must never recur.

---

## Core Principles (subordinate to Priority 0)

1. **Zero-relay principle:** Claude calls ChatGPT/Grok APIs directly when an API call is justified under Priority 0. No manual forwarding from Adrian.
2. **Frictionless operation:** True frictionless design means zero recurring manual action by Adrian. When an API call is justified, the direct API is primary; the Drive courier/bridge acts purely as audit trail and fallback.

## Infrastructure and Security

### Key Storage
API keys are stored centrally in a single `.env` file to ensure a single source of truth and avoid leakage in canonical documentation or scripts.
- **Path:** `~/.config/com.adrian-vault/.env`
- **Keys contained:** `OPENAI_API_KEY`, `XAI_API_KEY`

### Bridge Tool Invocations
Agents with shell capabilities can invoke the APIs directly using canonical wrapper scripts — **but only when Priority 0 permits**:

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

## Capability Routing (when an API call IS justified under Priority 0)

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
- **Hard monthly budget:** $30 total across all external metered APIs (OpenAI + Grok + Anthropic API). Adrian directive 2026-04-30. Equivalent to one Claude Max subscription.
- **Daily soft cap:** $1.
- **Per-call ceiling without surfacing:** $0.10. Anything projected above this requires explicit Adrian go-ahead in chat.

### Pricing (per 1M tokens)
| Model | Input | Cached Input | Output | Notes |
|---|---|---|---|---|
| gpt-5.5 | $2.50 | $0.25 | $15.00 | Flagship — reserve for frontier reasoning |
| gpt-5.4 | $1.25 | $0.125 | $7.50 | Escalation only |
| **gpt-5.4-mini** | **$0.375** | **$0.0375** | **$2.25** | **Default — frugal workhorse** |
| grok-4 | $3.00 | — | $15.00 | Grok divergent / capability probing |

**Batch API (OpenAI):** -50% on all rates; use for non-urgent bulk work.

### Frugality Rules (apply when API call is already justified)
1. **Default to mini.** Escalate only with explicit reason.
2. **One comprehensive prompt > many round-trips.** Output tokens cost 4-6x input.
3. **Cap `--max-tokens`** to what's actually needed (default 800).
4. **Cache prefixes.** Stable context at TOP of long prompts.
5. **Pipe via `--stdin`** for long context.
6. **Batch non-urgent work** via OpenAI Batch API (50% off).
7. **Local-first override** — if a local tool exists, use it before any paid API.

## Session-Start Check (mandatory)

Every Claude session start, before any work that could touch a metered API, verify:
1. Read this doctrine. Confirm Priority 0 is active.
2. Run `python3 ~/Documents/Adrian-Vault/working/usage_report.py` to see current month-to-date spend.
3. If spend > $25/month, **all metered API calls suspended** until Adrian explicitly authorises.
