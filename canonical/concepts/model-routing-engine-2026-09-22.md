---
title: Hive-Mind Model Routing Engine — current
status: CURRENT
date: 2026-09-22
supersedes: canonical/concepts/model-routing-engine.md
companion: canonical/concepts/llm-capability-map-2026-09-22.md
---

# Hive-Mind Model Routing Engine — 22 September 2026

## The routing decision

Route on four axes, in this order:

1. **Authority:** Does the task need live facts, a source record, a specific entitlement, or a trusted local corpus?
2. **Work shape:** Is it high-stakes reasoning, bounded implementation, high-volume extraction, multimodal analysis, or realtime dialogue?
3. **Delivery:** Is the input short, a file/repository, or a corpus requiring deterministic retrieval?
4. **Control:** What model/effort is actually pinned, and what write/spend/publish boundary applies?

Do not route by brand familiarity, leaderboard rank alone, or advertised context length.

## Current defaults

| Need | Route | Guardrail |
|---|---|---|
| Current, citable information | Live-web research, then independent-family check | A model’s training cutoff is not current research. |
| Strategy/architecture/final acceptance | Claude Opus 5 | Use Fable only after an evidenced ceiling; audit with another family. |
| Everyday code change | Explicitly pinned Codex Terra/effort or the assigned Claude builder | The live default is Terra/low; never infer Sol/xhigh. |
| Hard coding/arbitration | Explicitly pinned Codex Sol | Escalate effort only after a measured need. |
| Candidate frontier coding/knowledge audit | Grok 4.7 after authenticated probe | Batch unsupported; different-family validation remains mandatory. |
| Multimodal static work | Gemini 3.8 Flash after live lane probe | Agy requires its structured abstention schema. |
| Realtime voice/visual dialogue | Gemini 3.8 Live or Extended Thinking, when a live-agent job actually exists | Do not substitute it for Flash in long-document work. |
| Bulk structured work | Local model first | JSON schema, temperature 0, abstention value, sampled QA. |
| Oversized input | File-read/chunk-and-retrieve | Require coverage evidence; no big-context shortcut. |

## Non-negotiable execution rules

- Pin model and effort when reproducibility or routing matters.
- Declare source paths, output schema, acceptance criteria, and authority boundaries once.
- Use `NOT_FOUND`/`unknown` as valid required output, never a prose disclaimer.
- Validate structured outputs and tool results outside the model.
- A client catalogue proves available selection, not that an inference used that model.
- No model launch changes spending, subscriptions, security posture, retention terms, or production automation without the existing authorisation gates.

## Refresh process

For each material release, create a dated model-intel entry with first-party links, then update the capability map only after recording: vendor/API facts, local entitlement/catalogue evidence, task evaluation, and the routing delta. Historical digests retain their original claims; do not rewrite history to make it look current.

See [the current capability map](llm-capability-map-2026-09-22.md) for model evidence, prompt profiles, known limitations, and Grok 4.7’s evaluation gate.
