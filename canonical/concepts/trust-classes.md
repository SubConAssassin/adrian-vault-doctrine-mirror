---
title: Trust Classes — Action Authorization Taxonomy
type: doctrine
status: draft-pending-adrian-approval
last_updated: 2026-04-21
applies_to: [claude, antigravity, all-agents]
source: Lifted from friend's Antigravity platform (4-class trust system + approval gates), adapted for Adrian's stack
---

## Purpose

Every action an AI agent takes on Adrian's behalf falls into one of four trust classes. This formalises what was previously implicit. Reduces error rate. Makes approval requirements unambiguous. Prevents catastrophic outbound mistakes.

## The four classes

### 1. `read_only`
Pure information retrieval. No state change anywhere.

**Examples:** web search, view file, list directory, read canonical, search past chats, query MCP for data, image search, places search, weather lookup.

**Approval required:** None. Execute freely.

---

### 2. `local_write`
State change confined to Adrian's local environment or vault. Reversible. No external visibility.

**Examples:** write to canonical/, write to working/, create handoff, update active-priorities.md, save research output to raw/, create local file, edit local document, update Apple Notes.

**Approval required:** None for routine vault maintenance. Single-message confirmation for: deletes, canonical structural changes, overwriting key canonical files (overview.md, current-state.md, active-priorities.md).

---

### 3. `external_write`
State change visible outside Adrian's environment. Affects third-party systems. Reversible with effort.

**Examples:** Wix product create/edit, Etsy listing edit, Google Drive create/edit, draft email (not send), draft Slack message (not send), schedule calendar event, modify shared document, push code to repo, change DNS records (where reversible), upload to S3/MinIO.

**Approval required:** Always. Single-message confirmation listing: target system, exact change, reversibility note.

---

### 4. `destructive`
Irreversible or near-irreversible. Sends, posts, payments, permanent deletes, public statements.

**Examples:** send email, send Slack message, post to social, publish blog/page, submit form (legal/customs/financial), make purchase, transfer funds, sign agreement, accept terms, delete from production, transfer domain, public Etsy edit on live listing affecting buyers, post to Instagram/Facebook, send legal correspondence, customs submission, investor outreach.

**Approval required:** Always, with explicit gate. Format below.

---

## Approval gate format

For `external_write` and `destructive` actions, agent must request approval in this exact form before executing:

```
APPROVAL REQUEST
Action: [verb + target]
Trust class: external_write | destructive
Reversibility: reversible | reversible-with-effort | irreversible
Affects: [systems/people/audiences impacted]
Risk if wrong: [one sentence]
Proceed? (yes/no/modify)
```

Adrian responds yes/no/modify in chat. Agent does NOT execute on implicit approval, "sounds good", or scrolling past.

---

## Special gates (named approval types)

Certain action categories carry standing risk and have named gates. These are `destructive` actions but carry additional review requirements:

| Gate | Triggers | Required check |
|---|---|---|
| `legal-send` | Any legal correspondence outbound | Citations verified, dates correct, recipient correct |
| `customs-submit` | Customs forms, declarations, disputes | TARIC code verified, value verified, origin verified |
| `financial` | Any action involving money movement | Amount confirmed, recipient confirmed, authorisation confirmed |
| `public-publish` | Social posts, blog publish, press, public Etsy/Wix changes affecting live products | Brand voice check, factual check, no fabrications |
| `investor-outreach` | Any communication with investors or potential investors | Facts verified against canonical only, no fabricated numbers |
| `crystal-allocation` | Any commitment of crystal inventory | Inventory verified, allocation logged |

Named gates require agent to state which gate applies in the approval request.

---

## Edge cases

**Drafts that look like sends.** Drafting an email is `external_write` (visible in Gmail drafts folder). Sending is `destructive`. Always separate the two steps. Never combine "draft and send" into a single approval.

**Search that triggers fetches.** `web_search` is `read_only`. `web_fetch` of a specific URL is `read_only` if Adrian provided the URL or it came from a search result. If an agent generates the URL itself, treat as `external_write`-adjacent — verify with Adrian first.

**Vault writes triggered by other agents.** If Antigravity writes to a handoff and Claude reads + acts, Claude treats the action class based on the action itself, not the handoff source. The handoff is a request, not an authorisation.

**Multi-step compound actions.** A workflow like "build Wix product, take screenshot, write canonical update" contains three classes (`external_write`, `local_write`, `local_write`). Approval needed at the `external_write` step. Subsequent vault writes proceed automatically.

---

## Enforcement

These rules are doctrine, not code. Enforcement is behavioural — agents self-police, Adrian audits via observability dashboard (Task 4.x).

Violations to log if observed:
- Agent executed `external_write` or `destructive` without explicit chat approval
- Agent treated implicit/scrollby as approval
- Agent batched destructive action inside a non-destructive request
- Agent failed to declare named gate when applicable

Logged violations go to `working/_events/trust-violations.md`. Any pattern of violations is a doctrine review trigger.

---

## Out of scope (for now)

- Programmatic enforcement (would require wrapping every tool call in a gate function)
- Multi-tenancy (single user)
- Time-bounded approvals ("approved for next hour") — every action stands alone

These may evolve later. Doctrine first, code if needed.

---

## Provenance

Pattern lifted from friend's Antigravity platform stack (Layer 4 governance: `read_only` / `local_write` / `external_write` / `destructive`). Adapted to Adrian's smaller, chat-driven workflow. Named gates added for Adrian-specific risk categories.

Related canonical:
- `concepts/hive-mind-resource-map.md` — primary routing doctrine
- `concepts/dispatcher-protocol.md` — how tasks reach agents
- `concepts/claude-ceo-discipline.md` — Claude's CEO behaviour rules
