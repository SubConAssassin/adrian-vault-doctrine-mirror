---
title: Verify-Before-Trust Gate
type: protocol
status: authoritative
tier: 1
date: 2026-05-16
---

# Verify-Before-Trust Gate

## 1. The Core Issue
High-throughput generation without strict grounding leads to systemic confabulation. Agents inherently attempt to fulfill requests by generating plausible data when actual data is missing or out of context. This leads to the fabrication of citations, mechanisms, and historical records.

## 2. The Verification Gate Protocol
Before trusting, merging, or publishing any AI-generated synthesis, the following automated or manual gate MUST be passed:

1. **Existence Verification:** Does the cited path or ID actually exist? Any ID generated must be validated against the known floor/ceiling of the corpus (e.g., Stefi transcripts start at `00000033`).
2. **Textual Grounding:** For any specific claim of methodology (e.g., "muscle testing", "HRV"), a `grep_search` against the verbatim transcripts must yield positive hits. If zero hits are found, the claim MUST be rejected as confabulation.
3. **Cross-Project Firewall Check:** Does the synthesis violate established brand separations? (e.g., merging OSB crystal properties into Subconscious Surgery methodologies).

## 3. Implementation in Prompts
Every agent prompt designed for data extraction or synthesis must include the following explicit directive:

> **GROUNDING (non-negotiable):** Ground every claim in a source you actually read in this task. Mark gaps as GAP. NEVER invent files, IDs, quotes, modalities, or identities. Honor all project firewalls. Confabulated output is an immediate failure condition.

## Implementation

Phase-1 mechanical implementation of this gate: `canonical/concepts/ag-grounded-output-contract.md` (claim-record contract, `tools/verify_grounded.py` deterministic verifier, `tools/promote_verified.py` promotion, citation-granularity cap, terminal-non-AG anti-recursion, 0/200-false-promotion acceptance gate). BUILT + TESTED 2026-05-16.

