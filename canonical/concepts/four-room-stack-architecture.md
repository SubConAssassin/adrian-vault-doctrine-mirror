---
title: Four-Room Stack Architecture — OpenAI Stack Role Assignment
type: canon
status: canonical
created: 2026-04-21
supersedes: working/handoffs/2026-04-19-chatgpt-ai-stack-role-allocation.md
tags: [hivemind, openai, atlas, codex, chatgpt, architecture, doctrine, adrian-os]
---

## Core doctrine

The OpenAI stack is not one assistant. It is **four specialised operational rooms**. Role assignment is by substrate, not by brand.

| Room | Product | Substrate | Owns |
|---|---|---|---|
| 1 | ChatGPT Atlas | The web browser | Browser intelligence, page-aware analysis, bounded browser actions |
| 2 | ChatGPT macOS app (Work with Apps) | Active local apps | IDE/terminal/Notes inspection, selected-text reasoning, voice-assisted desk-side |
| 3 | Codex | Repo + computer | Multi-agent execution, parallel workstreams, long-running build/debug loops |
| 4 | Projects / Tasks / Connectors | Persistence layer | Cross-session continuity, linked artifacts, recurring work |

## Routing rules — by substrate

- **Web-native intelligence** → Room 1 (Atlas)
- **Local active-pane context** → Room 2 (macOS app + Work with Apps)
- **Heavy execution** → Room 3 (Codex)
- **Persistence / retrieval / repeatability** → Room 4. ***IN ADRIAN-OS: Adrian-Vault IS Room 4.*** OpenAI Projects are fallback, not primary. Vault outranks.

## How this maps onto Adrian-OS

Adrian-OS already fills all four rooms with native primitives. The OpenAI stack is evaluated as **alternative or additive**, not default.

| Room | OpenAI product | Adrian-OS native fill | Verdict |
|---|---|---|---|
| 1 | Atlas | Claude-in-Chrome MCP + web_search + web_fetch | Stick native. Atlas is marginal alternative. |
| 2 | macOS Work with Apps | Control-your-Mac + Filesystem MCP + Claude Desktop | Stick native. ≈ parity. |
| 3 | Codex | Antigravity (primary) + Claude orchestrator | **Genuine capability gap.** Codex earns a pilot slot. |
| 4 | Projects / Tasks / Connectors | Adrian-Vault (canonical + working/ + handoffs/) | Vault wins. Sovereignty + shared-brain with Antigravity. |

## Codex pilot slot — single-scope A/B

Codex is the only genuine capability upgrade in the four-room stack. Evaluate against Antigravity on a bounded pilot.

- **First candidate:** TUNED app / Ashta MVP sub-component (Sensie API, React prototype, multi-file iteration)
- **Criteria to expand Codex scope:** measurable delta over Antigravity on parallel sub-agent execution, long-running refactors, or repo-scale coherence
- **Not candidates for Codex:** OSB / Subconscious Surgery Wix work (stays with Claude via Wix MCP); anything Antigravity handles cleanly via vault handoffs

## Security doctrine — non-negotiable

Browser agents and computer-use agents are **high-risk surfaces**. Applies equally to Atlas Agent mode, Codex computer-use, AND Claude-in-Chrome.

1. **Explicit approval gates** for any send / post / purchase / permission-change / irreversible action
2. **Bounded instructions only** — no open-ended "browse and decide" delegations without a defined stop condition
3. **Explicit source/account trust assumptions** — prompt injection via page content is a live threat
4. **Atlas Agent mode constraints** (per OpenAI): cannot run code, cannot download files, cannot access filesystem, cannot read/write memories, cannot use saved passwords. Do not model it as an unconstrained operator.
5. **Enterprise/privacy caveat:** Atlas is beta for Business/Enterprise. Do not use for regulated or high-sensitivity work until governance matures.

## Operational consequence for Claude (orchestrator)

When Adrian hands execution work, Claude's first move is to **route by room**, not default to doing it in chat.

- Room 1 task? → delegate to Claude-in-Chrome MCP (or Atlas if explicitly chosen)
- Room 2 task? → use Control-your-Mac / Filesystem MCPs (or macOS app if explicitly chosen)
- Room 3 task? → write spec to `working/handoffs/` for Antigravity (or Codex if pilot-scoped)
- Room 4 task? → read/write canonical + working/ directly; never default to OpenAI Projects

## Cross-room handoff convention

Every output that crosses a room boundary ends with:

1. **Assumptions** made
2. **Sources** consulted
3. **Confidence** level
4. **Next actions** identified
5. **Delegation target** (which room/agent owns the next step)

## Routing map for active workstreams (as of 2026-04-21)

- OSB Wix variants → Room 3 (Claude via Wix MCP; Antigravity for heavier lifts)
- OSB Etsy audits, boutique research, Marcus Schmieke background → Room 1
- Erica Johnson legal, customs disputes, investor outreach state → Room 4 (vault + canonical)
- Customs/legal drafting → Claude; sending → Adrian
- Subconscious Surgery site/copy → Room 3 (Claude via Wix MCP)
- TUNED app / Ashta MVP build → Codex pilot slot (Antigravity primary; Codex A/B on one sub-component)
- White papers, strategy, consciousness research → Claude orchestration
- AGA / WtE regulatory → Claude + vault

## Related

- `canonical/concepts/chatgpt-dispatch-protocol.md` — tactical Room 1/2 dispatch bridge
- `canonical/concepts/agent-team-strategy.md` — higher-level agent allocation
- `canonical/concepts/agent-team-allocation-ratios.md` — quota/ratio targets
- `canonical/concepts/claude-ceo-discipline.md` — orchestrator discipline
- `canonical/ecosystem/shared-infrastructure.md` — vault as Room 4 substrate
- Superseded: `working/handoffs/2026-04-19-chatgpt-ai-stack-role-allocation.md`

## Doctrine summary (one line)

> Assign work by substrate, not by tool tribalism. Rooms 1–2 have native Adrian-OS fills and need no switch. Room 3 is the one genuine gap and earns Codex a pilot slot. Room 4 is owned by the vault, period.
