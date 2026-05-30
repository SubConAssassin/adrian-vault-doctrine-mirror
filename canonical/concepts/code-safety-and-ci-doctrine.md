---
title: Code Safety & CI Doctrine — the single source of truth for how the stack prevents breaks
type: architecture-doctrine
tier: 1
date: 2026-05-31
authored_by: claude (cowork — built the system 2026-05-30→31, consolidated here on Adrian's instruction to amalgamate into one SSOT)
firewall_class: working-internal
status: CEMENTED — live and verified
consolidates: |
  The information previously scattered across: tools/hive-ci/* (7 files), 2 LaunchAgent plists,
  2 GitHub workflow files, the hive-ci-system.md memory, and 8 STATE-OF-STACK.md entries.
  THIS is now the authoritative doctrine; those remain the operational implementation.
related: |
  - tools/hive-ci/README.md — operational/usage detail (this doc = doctrine; README = how-to)
  - canonical/concepts/verify-before-trust-gate.md — AG output trust gate (adjacent, not superseded)
  - canonical/concepts/cross-model-automation-protocol.md — the CLIs the AI-review layer drives
  - canonical/concepts/ag-grounded-output-contract.md — AG grounding contract (content-side gate)
  - canonical/concepts/hive-architecture-v3.md — the 4-layer stack this sits inside (Layer 1/4)
---

# Code Safety & CI Doctrine

> **If you read one thing:** the stack now has an automatic guard against code and content
> breaks. The command is **`hive-ci`**. This document is the single source of truth for what
> exists, what it covers, what's live, and what's old. Operational how-to lives in
> [`tools/hive-ci/README.md`](../../tools/hive-ci/README.md); this is the doctrine.

## 1. Why this exists

Before 2026-05-30 the stack had **zero** automated break-prevention. AI agents (Claude + Antigravity)
wrote code and content fast; nothing verified it; breaks surfaced days later by accident. Two of three
code repos weren't even version-controlled. The vault owned a rich library of gate tools that **nothing
ever ran**. The cost was real: a crashed spend-gate, a backup that lied for 17 days, a firewall-redaction
safety script broken-and-silent since May, fabrications caught only by expensive manual overnight audits.

This doctrine cements the system that closes that gap. The principle: **a break is caught at the moment
it happens, by an automatic gate — not days later, by a human.**

## 2. The unified gate map (the amalgamation)

Every break-prevention gate across the stack, in one place. This table is the SSOT inventory.

| Surface | What breaks | Gate | Status | Where |
|---|---|---|---|---|
| `subconscious-surgery-next` (live website) | build / type errors | hive-ci `ss-next` + git hooks + cloud CI | ✅ live | localhost repo |
| `osb-inventory-kernel` (financial) | syntax / schema errors | hive-ci `osb-kernel` + git hooks + cloud CI | ✅ live | localhost repo |
| vault `tools/` (220-script spine) | syntax / crash | hive-ci `vault-tools` | ✅ on-demand | `hive-ci vault-tools` |
| LaunchAgent fleet (automation) | silent death (the 17-day class) | hive-ci `infra` | ✅ scheduled 4h | `com.adrianvault.hive-ci-infra` |
| vault draft content | §7 / OSB-rule / methodology firewall leaks | hive-ci `vault-content` (wraps `firewall_scan.py`) | ✅ scheduled daily | `com.adrianvault.hive-ci-vault-content` |
| AG output (extraction/synthesis) | confabulation / thin output | `ag_verify.py` + `quality-gate.py` + verify-before-trust-gate | ✅ wired (AG pipeline) | per `ag-auto-verify` LaunchAgent |
| event/state integrity | drift / corruption | `eventlog.py validate` + `ledger.py refresh` | ⚠️ on-demand only | run manually / shutdown |
| vault link integrity | broken cross-links | `link-integrity-check.py` | ❌ not gated (270k-noise — needs scoping) | deferred cleanup |

**Two families of gate:** *code-safety* (hive-ci — syntax/build/test) and *content-safety*
(firewall_scan, ag_verify, grounded-output-contract — fabrication/firewall/grounding). Both are
"don't let a break ship." This doctrine owns the code-safety family and the scheduling that finally
activated the dormant content-safety tools.

## 3. Hive CI — the code-safety system (NEW, cemented)

Native macOS (no Docker — code runs native via LaunchAgents, so native parity beats container parity;
at 64GB RAM, `act`/Docker is viable if exact cloud parity is ever wanted, but native is the right default).
One command: **`hive-ci [target] [--ai-review]`**.

**Five tiers:**
1. **pre-commit hook** — every `git commit`: fast (syntax, typecheck, secret-scan, lint). Blocks broken commits.
2. **pre-push hook** — every `git push`: full (+ build + tests).
3. **manual runner** — `hive-ci [vault-tools|ss-next|osb-kernel|infra|vault-content|all|stack]`.
4. **GitHub Actions** — `.github/workflows/ci.yml` in each code repo; activates on first push to a remote.
5. **scheduled** — `infra` (4h) + `vault-content` (daily 06:30) LaunchAgents; **delta-aware, alert only on NEW problems**.

**The blocking rule (do not change — it's what keeps CI trusted):** typecheck / build / syntax /
schema / tests **block**; **lint is advisory** (never blocks — else agents `--no-verify` around it and CI dies).

**AI-review (`--ai-review`):** on a red build, routes the failing diff + error to:
- **local model** (`ollama` / `qwen2.5-coder:14b`) — **primary, free, offline, private** (the 64GB M1 Max runs it).
- **Grok 4.3** — adversarial second opinion, always ($0).
- **GPT-5.5** (`codex`) — fallback if no local model, or escalation with `--deep`.
- **Gemini** (`agy`) — optional headless auto-apply (`--apply`).

This is the same cross-model pattern as `cross-model-automation-protocol.md`, applied to CI.

## 4. Version-control foundation

`subconscious-surgery-next` and `osb-inventory-kernel` were `git init`'d 2026-05-30 (they had no history —
no undo when an agent broke something). Both now have first commits + hooks. The **vault repo deliberately
has NO blocking hook** — it's a doctrine mirror that gitignores `tools/` and has an hourly auto-sync commit;
a blocking hook would risk wedging the auto-sync. vault-tools is protected via the manual runner.

## 5. What's CEMENTED vs what's OLD (the tidy)

**CEMENTED (current truth):**
- Hive CI 5-tier system + AI-review (local-first) — this doc + `tools/hive-ci/`.
- Scheduled `infra` + `vault-content` gates (delta-aware, logs in `~/Library/Logs/adrianvault/`).
- Hardware: **Apple M1 Max, 64GB** (verified 2026-05-30) — enables local-model inference.

**OLD / RESOLVED (tidied):**
- *"The vault gate library is dormant — nothing runs it."* — **RESOLVED.** `firewall_scan.py` is now
  scheduled via `vault-content`. `eventlog/ledger` validation remains on-demand (low-risk; run at shutdown).
- *`link-integrity-check.py` as a gate* — **NOT adopted.** It reports ~270k wikilink "breaks" corpus-wide;
  too noisy to gate. Logged as a standalone cleanup project, not part of CI.
- *"M3 Pro / 18GB" hardware + "Docker too heavy"* — **superseded** (see §3; corrected across CLAUDE.md,
  AGENTS.md, hive-architecture-v3.md on 2026-05-31).

**ADJACENT (not superseded — they own their own domains; this doc references them):**
`verify-before-trust-gate.md`, `ag-grounded-output-contract.md`, `cross-model-automation-protocol.md`,
`hive-architecture-v3.md`. This doc is the **code-safety SSOT**; those cover AG-trust, grounding,
cross-model transport, and the overall stack respectively.

## 6. How the team uses this

- **Before committing code** (any agent or Adrian): hooks run automatically. To check manually: `hive-ci <target>`.
- **To check the whole stack:** `hive-ci stack` (all 5 targets).
- **On a red build:** `hive-ci <target> --ai-review` for a free local diagnosis + fix.
- **Scheduled gates run themselves** — they file `working/handoffs/{date}-hive-ci-{target}-ALERT.md`
  **only when something new breaks** (no noise). Check there, or `~/Library/Logs/adrianvault/`.
- **Adding a repo to CI:** `git init` → add `check_<name>()` in `run.sh` + register in `config.sh` →
  `install-hooks.sh <repo> <name>` → optionally add `.github/workflows/ci.yml`.

## 7. Open / deferred (not blocking — Adrian-gated)

- **Cloud-tier activation** — needs Adrian OK to `gh repo create` private remotes for the two apps + push
  (outward-facing publish of business code). Workflows auto-activate on push.
- **`link-integrity-check.py` 270k cleanup** — its own project.
- **`localhost/` mangled-path artifacts** — a recurring AG output-path bug created garbage-named dirs holding
  real content: `ashta-app-recovered/` (505MB Ashta deliverables + app + corpus — recovered, needs canonical
  home, likely `companies/ashta/`), and `localhost/Users/` (256 Kajabi PDFs, likely stray dups of `SubConMaster/`
  — verify before deleting). **Pattern worth a guard:** AG commissions should validate `output_path` is real.

## 8. Revision history

- **2026-05-30** — Hive CI built + installed + proven (caught 2 latent broken files on first run, incl. the
  §7 firewall-redaction tool silent since May). git foundation for 2 repos. AI-review proven live.
- **2026-05-30 (audit)** — stack-wide gate audit; added `infra` + `vault-content` targets; found the dormant-gate library.
- **2026-05-31** — scheduled the two stack-health gates (delta-aware LaunchAgents); wired local-model AI-review
  (qwen2.5-coder, free/offline at 64GB); hardware fact corrected (M1 Max 64GB); **this SSOT doctrine cemented.**
