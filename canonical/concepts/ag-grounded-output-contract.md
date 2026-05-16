---
title: AG Grounded Output Contract — Phase 1 (claim-record + verifier + promotion)
type: agent-operating-contract
status: authoritative
tier: 1
firewall_class: working-internal
created: 2026-05-16
build_status: "Phase-1 tooling BUILT + TESTED 2026-05-16 (tools/verify_grounded.py, tools/promote_verified.py, tools/prompts/ag_grounded_extract_v1.md, staging dirs, tools/test/* — 12/12 fixtures + promoter e2e green, zero false promotions). PENDING: live AG cutover (redirects active Stefi burn — deliberate go/no-go) + blinded 200-claim human eval before unattended promotion."
authored_by: claude (cowork, dazzling-herschel-dd9ffe) — Adrian-delegated decision, ChatGPT-signed-off
authority: Tier-1 operational doctrine. Both the AG autonomous prompt and verify_grounded.py reference THIS file.
decision_basis:
  - working/external-research-in/_github-cache/inbox/2026-05-15-chatgpt-to-claude-autonomous-hive-system-review.md (Review 1 — control plane)
  - ~/Library/CloudStorage/GoogleDrive-*/ChatGPT-Bridge/chatgpt-to-claude/2026-05-15-1758-UTC-chatgpt-claude-api.md (Review 2 — claim-verifier MVV)
  - ~/Library/CloudStorage/GoogleDrive-*/ChatGPT-Bridge/chatgpt-to-claude/2026-05-15-1810-UTC-chatgpt-claude-api.md (Review 3 — GO sign-off + 5 corrections)
supersedes_for_autonomous_mode: the vague "continue — STANDING ORDER" freeform grind (cause of the ~86% confab day)
---

# AG Grounded Output Contract — Phase 1

**Why:** under vague prompts AG confabulated ~86% of one day's output and it
poisoned the single source of truth. The delivery layer is now fixed (keystroke
coordination, 2026-05-16). This contract fixes the **trust** layer: AG's
autonomous output is constrained to a mechanically verifiable shape, gated
through staging, and only promoted to canonical when every claim is proven
grounded. Behavioural prompt-tuning is a *complement*, not a substitute for this
gate — canonical corruption is asymmetric (one bad note gets cited and
re-ingested; cleanup cost dominates).

This is **Phase 1**. The full SQLite job-queue / lease / heartbeat control
plane is **deferred to Phase 2**, to be decided only on Phase-1 verifier data.

## 1. Autonomous-mode output shape (HARD)

In autonomous mode AG emits **only structured claim records**. Freeform prose
is forbidden in autonomous mode.

`task_type` enum: `extract` | `index` | `crossref`.
**Phase 1 operational reality: `extract` ONLY.** The enum may ship, but the
verifier/promotion path admits only `extract` in the first unattended gate. Do
NOT spend Phase-1 build effort making `index`/`crossref` truly operational.

Each submission = one markdown artifact in `working/inbox/ag-staging/` + a
sidecar manifest `working/inbox/ag-staging/manifest/{submission_id}.json`:

```json
{
  "submission_id": "ag-20260516-1230-<rand>",
  "handoff_id": "<the claude-to-ag handoff this answers>",
  "task_type": "extract",
  "claims": [
    {
      "claim_id": "c1",
      "text": "<one atomic claim, no rhetorical prose>",
      "support": [
        { "file": "raw/<exact vault-relative path>", "line_span": "14-16" }
      ]
    }
  ]
}
```

## 2. Citation-granularity cap (HARD — the single highest-leverage rule)

Per ChatGPT Review 3 §B: this is the one change that most reduces risk per unit
effort. It runs as a *deterministic* check **before** any LLM entailment step,
so it shrinks the space in which a soft judge can rationalize a hallucination.

- Each claim cites **at most 2 support spans**.
- Each span is **≤ 3 sentences AND ≤ 400 characters**.
- A claim whose support is broader than this **FAILS** (no LLM call made).
- Every non-trivial sentence in the claim text maps to ≥1 support span.

## 3. Anti-recursion (HARD — the blind spot)

Provenance tags alone are insufficient. To stop the vault becoming
self-justifying while the gate is being calibrated:

- Every promoted claim must have **≥1 terminal non-AG source** in its support.
- Phase 1: `extract` claim support must resolve to **human-authored or scraped
  source files only**. Promoted AG-authored notes **cannot** ground a new
  `extract` claim in Phase 1.
- Transitive use of promoted AG notes as grounding is a **Phase-2** concern
  (needs explicit transitive-provenance checks). Not now.

Every source file carries a provenance tag: `human` | `scraped` | `prior-ag` |
`unknown`. The verifier reads it; `prior-ag`/`unknown` are not valid terminal
grounding in Phase 1.

## 4. Deterministic verifier (`tools/verify_grounded.py`) — check order

Cheap/deterministic first; the LLM entailment verdict is last and gated by all
prior checks passing:

1. **Manifest completeness** — required fields present.
2. **Source existence** — every cited `file` exists in the vault.
3. **Span validity** — `line_span` resolves, is non-empty.
4. **Citation-granularity cap** — §2 (≤2 spans, ≤3 sentences/≤400 chars).
5. **Provenance / anti-recursion** — §3 (terminal non-AG source present).
6. **Novel-structure restriction** — reject headings/entities absent from the
   cited source unless `task_type` explicitly allows synthesis (not in P1).
7. **Citation coverage** — every non-trivial sentence maps to ≥1 support.
8. **Claim entailment** — for each surviving claim: direct substring of the
   cited span, OR one tight LLM verdict in **verifier role only**, returning
   per-claim `{verdict, rationale, exact_cited_text}`. Auditable, not magical.

**Promotion rule:** ALL claims pass → promote the artifact to the canonical
proposal path. ANY claim fails/ambiguous → artifact stays in staging, a report
is written to `working/inbox/ag-staging/reports/{submission_id}.md`, and **zero
canonical bytes are written**. Hard quarantine by default until verifier
precision is characterized (§6).

## 5. Feedback loop (correction, not silent relax)

- Per-submission dataset: per-claim verdict
  (`supported`/`unsupported`/`ambiguous`/`bad-citation`) + correction category
  (`invented-fact` / `overgeneralization` / `bad-merge` / `stale-source` /
  `contract-failure`).
- Rolling compact `working/feedback/ag-corrections.md` (top current failure
  modes + banned behaviours + the current contract pointer) — NOT a transcript.
- Versioned prompt templates in `tools/prompts/ag_grounded_extract_vN.md`.
- Tiered judge: machine verifier first; Claude adjudicates **only** fails over
  a threshold; AG **never** self-approves. Max **1** automatic retry, targeting
  only the failed claims; re-verify only changed claims. Daily adjudication
  budget cap → on exceed, backlog grows; standards are **never** silently
  relaxed.

## 6. Acceptance test — gate to unattended promotion (LOCKED)

Before unattended promotion is enabled, run a blinded human-labelled eval:

- **200 claims**, sampled from *real* autonomous Phase-1 submissions (not
  handpicked), representative easy/hard mix.
- Each claim labelled independently against only its cited span(s).
- Verifier runs the production promotion rule unchanged.

Pass/fail:
1. **Unsupported-or-ambiguous claims promoted to canonical: 0 / 200.** One
   false promotion = FAIL. This is the absolute gate.
2. Precision on `supported` verdicts ≥ **99%**.
3. Recall on human-supported claims ≥ **80%** (Phase-1 conservatism is fine —
   leave more in staging).
4. Bad-citation detection recall ≥ **95%**.

If (1) fails even once → not trustworthy unattended; promotion stays disabled.
High precision via near-zero promotion is acceptable initially.

## 7. Build sequencing (LOCKED — do not reorder)

The mistake most likely to waste this build is tuning AG prompt behaviour
before the verifier is proven on real messy output. Correct order:

1. Restrict output shape (this contract + the autonomous prompt template).
2. Build staging + `verify_grounded.py` + promotion.
3. Generate messy *real* autonomous submissions.
4. Measure the verifier against human labels (§6).
5. **Only then** tune prompts / expand task classes / build the correction loop richer.

Do **not** spend cycles on richer autonomy, `index`/`crossref`, or a smarter
correction loop until there is a measured false-promotion rate on real samples.

## 8. Scope boundary

Phase 1 = §1–§7. **Deferred to Phase 2** (decided on Phase-1 data only):
SQLite job queue, lease/heartbeat, the resilient supervisor control plane,
moving supervision scripts off `Documents/`, launchd→minimal-anchor rework,
transitive-provenance for AG-grounding-AG. The 2026-05-16 keystroke
coordination (`antigravity-crash-recovery-protocol.md` §"Coordinated keystroke
authority") is the delivery precondition this builds on.

## 9. Related doctrine (layered, not competing)

This is the **operational implementation** layer of the trust gate:
- `canonical/concepts/verify-before-trust-gate.md` — the *conceptual* gate (what must be true: existence, textual grounding, firewall). This file is its Phase-1 mechanical implementation.
- `canonical/concepts/antigravity-operating-contract.md` — the *behavioural* layer (what AG must do at generation time). Complementary; the gate is the mechanical floor regardless of behaviour.
- `canonical/concepts/ag-workspace-persistence-protocol.md` — orthogonal (AG must export state to the vault; unrelated to grounding verification).

