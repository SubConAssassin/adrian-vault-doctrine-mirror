# Productivity Multiplier Reckoning — Before vs After the 2026 Stack Upgrades

**Status:** Tier-1 doctrine. **Supersedes** the loose "22×" and "45×" productivity figures scattered through handoffs and doctrine — those are soft (see §2). Cite THIS document for any "how much faster are we" question.
**Created:** 2026-05-31 (WITA)
**Method:** 7-agent forensic Workflow `wf_26c10c7a-956` — vault-grounding agent + 5 independent per-axis estimators + 1 adversarial refuter whose only job was to refute inflation. Cost **$0** (Claude subagents on subscription; no metered API).

---

## 1. The bottom line

| Frame (vs a solo human) | Multiplier |
|---|---|
| **Machine capacity ceiling** (what the hive *could* produce) | **~30–80×** |
| **Realised end-to-end throughput** (what *actually ships* through the human loop) | **~5×** (range 3–8×) |

- The 2026 upgrades (CI, Opus 4.8, Gemini 3.5 Flash High, headless CLIs, cross-model verification, Workflow fan-out) **roughly doubled realised throughput** (≈2–3× → ≈5×) — driven almost entirely by the **reliability** axis, not by raw model speed.
- **The binding constraint is now Adrian, not the stack.** Amdahl's law at a documented 15–20% human serial fraction caps realised speedup at **~5–7×** regardless of any further model/CI upgrade.
- Naive multiplication of the spec sheets to claim 100×+ is **arithmetically false** — it triple-counts one upgrade and ignores the human bottleneck (§4).

---

## 2. The "22×" baseline is soft — do not cite it as measured

Vault tracing (`2026-05-22-ag-to-claude-COMPLETE-v25-final.md` line 44) shows the **22× was a single Antigravity self-report on one Whisper-transcript integration task** versus a manual-secretary equivalent — **not** a measured hive-vs-solo-Adrian figure, and filed by the same model running ~86% confabulation five days earlier on a different task class.

The genuinely load-bearing number in doctrine is the **45× under-utilisation ratio**: AG burned only **2.2% of its substrate capacity**; 97.8% was wasted (`canonical/concepts/claude-ceo-operating-doctrine.md`, the 2026-05-13 forensic). The "before" state was therefore a machine with a *high ceiling that was being used at one-fortieth of capacity*.

This reframes the entire question: the upgrades attack **two distinct things** — the ceiling, and the fraction of it actually captured. They must be reported separately or the comparison is meaningless.

---

## 3. The five gain axes (independently estimated)

| Axis | Improvement factor | What it really is |
|---|---|---|
| Model speed/capability | 2.5–4× | Gemini 3.5 Flash High ~4× faster; Opus 4.8 1M-context single-pass synthesis. Clean, **capacity-side**. SWE-bench delta (76.2→78%) is negligible — the gain is throughput, not output quality. |
| Parallelism / fan-out | 2.5–5× | 3 headless CLIs (`agy -p`/`grok -p`/`codex exec`) firing in parallel + Workflow fan-out. **16× ceiling is RAM-gated** until the 64GB machine lands; proven safe ceiling ~6–10×. |
| **Reliability / uptime** | **1.7–2.3×** | **The dominant realised lever.** Took the realised fraction from ~20–25% to ~42–47% of capacity by ending the dead-fleet (17 days) / overnight-idle / keystroke-flood / silent-code-break losses. CI + headless CLIs + repaired LaunchAgent fleet. |
| Cost per dollar | 3–5× | Flash High 4–8× cheaper tokens — but only binds the **~20–30%** of work that is metered-API. Most sessions run flat-rate subscription (logs show "API spend $0" almost every session). |
| Quality / rework | 1.4–2.5× | CI + cross-model truth-judge catching code-breaks and confabulation **before** they propagate to canonical (kills the secondary cost: 12-file repointings, multi-hour overnight audits, doctrine-lock sessions). Gated on `cross_verify` reaching production (0 parcels at audit). |

---

## 4. Why it is NOT 100×

Multiply the five low-ends naively: **44.6× improvement × 22 ≈ 981×.** That is the seductive lie. Three things kill it:

1. **Triple-counting one upgrade.** Speed (4×) and cost-efficiency (4–8×) are *the same Gemini 3.5 Flash High event* — AGENTS.md §11.5.a even states them as one combined "16–32× work per dollar/per hour." For any given task either the clock binds or the budget binds, never both. Counting them as independent multipliers bills the same hardware twice.
2. **Shared credit.** Reliability and parallelism both claim the LaunchAgent-fleet restoration. Reliability and quality both claim the freed confab-remediation bandwidth. The same recovered hour cannot be collected in two columns.
3. **Amdahl's law — unpriced by every axis.** At audit the stack had **~15 items on Adrian's serial attention** (stock take gating the inventory kernel, Etsy callback URL, Erica label send, Stephan send, Stripe Products, Meta tokens, pricing-anchor call, KGB lore decision, the three-brothers conversation, …). Several are **multi-day external waits** (Erica's reply, Etsy approval, bank exports), not 15-minute decisions. At a 15–20% serial fraction, the realised-speedup ceiling is **~5–7×** no matter how fast the machine gets.

After de-duplication: the genuine *capacity* improvement over the pre-upgrade hive is **~2–4×** (dominated by model speed once double-counts are stripped); the genuine *realised* improvement is **~2×** (reliability being the lever).

---

## 5. The lever — where the next multiple actually is

There is now a **~10× gap between the ceiling (30–80×) and what is realised (~5×). That gap is the human serial bottleneck.**

The next multiple is **not** in a better model, more CLIs, or more CI — those have hit diminishing returns against a ~5–7× Amdahl ceiling. It is in **shrinking Adrian's serial fraction**:

1. **Batch decisions** into one daily pass instead of per-blocker interrupts.
2. **Pre-authorise** spend bands and approval thresholds so the hive doesn't stall waiting for a "yes."
3. **Clear external-dependency waits off the critical path** (Etsy approval, bank exports, client/legal replies) by parallelising or pre-staging them.

Squeeze the serial fraction from ~15–20% toward ~5% and the realised ceiling moves from ~5× to **~15–20×** — a bigger jump than the entire 2026 upgrade cycle just delivered.

**Corollary for CI specifically:** the CI rollout (the work in the sibling window) *is* the highest-leverage stack investment, precisely because it lives on the reliability axis — it converts already-paid-for wasted capacity into shipped output. But it is a realised-fraction lever, not a ceiling lever; it cannot break the Amdahl wall.

---

## 6. Sources (vault-grounded)

- `working/handoffs/2026-05-22-ag-to-claude-COMPLETE-v25-final.md` (the 22× self-report)
- `canonical/concepts/claude-ceo-operating-doctrine.md` (45× under-utilisation, line ~157)
- `AGENTS.md` §11.5.a (Gemini 3.5 Flash High economics)
- `canonical/concepts/hive-architecture-v3.md` §4 (16× fan-out RAM-gating)
- `working/handoffs/2026-05-20-ag-to-claude-BENCHMARK-REPORT-v5.md` (self-invalidated 86.52× benchmark — do not use)
- `working/handoffs/STATE-OF-STACK.md` (fleet-repair, CI build, confab-strip, keystroke-flood incidents)
- `episodic/sessions/2026-05-13-ag-accountability-and-token-doctrine-correction.md` (15M-token overnight idle)

## 7. Method / provenance

Estimated by adversarial workflow rather than freehand, specifically to defeat sycophantic inflation of a multiplier (the principal distrusts polite numbers). Five estimators worked in parallel and blind to each other; a sixth adversary saw all five and was instructed to refute. The capacity/realised split and the Amdahl ceiling are the adversary's corrections to the estimators' optimism. Numbers are defensible ranges, not precision claims — confidence is **medium-high** on the *shape* (machine-fast, human-bound), **medium** on the exact figures.

## 8. Addendum — 2026-06-03: post-audit re-measure + the M3→M1Max-64GB worker-swap verdict

**Status of this addendum:** single-read CEO estimate (Claude Opus 4.8), **NOT** the 7-agent adversarial workflow that produced §1–§7. Confidence: medium on *shape*, low–medium on exact figures. The adversarial re-run (5 blind per-axis estimators + 1 refuter) remains the higher-rigour option — **recommended to fire at swap-time** to stress-test these numbers before money moves.

**Frame:** local-compute unit anchored M3-18GB-solo = **100**, M1 Max 64GB = **300** (3×; per `AGENTS.md` §11.6 / the networking paper — the *hardware* axis only, distinct from the whole-stack multiplier in §1).

### 8a. What the upgrades SINCE the 2026-05-31 audit added
New since §1–§7: **Opus 4.8 + fast-mode** (faster output, same model — used often), the **3-engine headless CLI team matured + proven** (agy/grok/codex, 16/16 selftest, $0, parallel), the **M3 rejoined as an always-on dry-room worker** (213K-chunk corpus index = proof of real utilisation), and a **213K-chunk semantic retrieval index** (grep → semantic search).

| Axis | Last audit (M1 Max + AG2.0/Flash) | Now (post-upgrades) | Δ |
|---|---|---|---|
| Local compute units | 300 | 400 (M1 Max 300 + M3 node 100, concurrent) | +33% + always-on utilisation |
| Reliable parallel engines | ~1–2 | ~4–5 ($0 CLI ×3 + M3 + AG), deterministic | ~3–4× + reliability |
| Orchestrator | Opus 4.7 | Opus 4.8 + fast-mode | ~1.7–2× output wall-clock |
| Retrieval | grep | 213K-chunk semantic index | step-change |
| Marginal grind cost | metered $ | $0 (subscription CLIs) | rationing removed |

Three honest numbers — **do not conflate**: **ceiling** ~50× → ~100–150× (more capacity stranded above the bottleneck); **task-level speedup** ~5× → ~6.5× (Amdahl-capped — only fast-mode + retrieval touch Adrian's critical path); **daily work-units produced** ~2–3× (NEW categories now flow at $0/parallel — the corpus index + 6-venture cross-ref + 250 person-matches in one 2026-06-03 session are the proof; infeasible in the M3-18GB / keystroke-AG era). The §1–§5 conclusion **holds and is more true**: the upgrades bought **ceiling + reliability**, not proportional realised throughput — the binding constraint is still Adrian's serial fraction, and the new capacity sits off his critical path.

### 8b. The M3-18GB → 2nd-M1-Max-64GB worker-swap verdict (workload-specific)
Question: swap the dry-room M3 worker for a 2nd M1 Max 64GB — gain vs the current (M1 Max + M3-node) config, against Adrian's stated next-30-days workload.

**Local compute:** 400 → **600 units (+50%; worker alone 100 → 300 = 3×).**

**Next-30-days workload, classified by whether the worker touches it:**
- ❌ **Cloud/CLI/AG — swap does ~nothing:** building all the websites; vault audit *reasoning*; jewelry / X-Max design *generation*; Hero-to-Zero narrative *writing*.
- ✅ **Worker-bound — swap directly helps:** processing all iCloud/Dropbox photos+videos (batch vision); **close pendant ID + match descriptions + Etsy/site links** (flagship, revenue-gating); Hero-to-Zero photo-understanding + EXIF-travel + transcript/client/timeline correlation; corpus re-embedding.

**Verdict: SWAP IS WORTH IT — but NOT for the +50% nameplate.** Three real reasons:
1. **3× throughput** on the dominant local job (batch vision over ~64K+ photos + videos).
2. **Accuracy phase-change, 64GB-gated.** The M3 18GB **cannot hold an accurate 7–13B VLM alongside an image-embedding model** — it forces a tiny model or slow serial model-swapping. Adrian explicitly needs "descriptions match the actual piece" + correct purchase links → that accuracy is a capability the 18GB can't deliver, and bad IDs are a rework loop that eats his serial time. The pendant→description→link DB becomes **usable-for-revenue without hand-correction**.
3. **Decoupling.** This month runs website builds AND the photo/pendant batch concurrently. With the M3 as worker, heavy-accuracy vision either can't run or gets pushed onto the **primary** M1 Max (contending with the build/design work). A 2nd 64GB worker runs the batch fully parallel, off the primary.

**Realised, month-level:** Amdahl over the worker-bound fraction (~40% of gating work) at ~3× + accuracy-rework removal → **the month compresses ~1.4× (≈ +35–55% total output)**, and the highest-value deliverable (the accurate pendant DB) lands ~3× sooner + correct. **NOT 3× across the board** — websites + audit-reasoning + design-gen are cloud/Adrian-bound and unaffected; if the month *feels* slow, that axis is where it'll be, not the worker.

**M3-18GB capability blockers (concrete):** 27–32B local reasoning = can't load (16–20GB weights alone); accurate 7–13B VLM + embedding model resident together = no; concurrent vision+embedding+reasoning pipelines = needs the 64GB headroom; raw batch-vision throughput = M1 Max 24-core GPU ≈ 3× the M3 Pro's.

**Cost:** ≈ break-even per the resale roadmap (sell M3 + ~$300–400 → 2nd M1 Max; ~1mo interim until the M2 Ultra 192GB; resell ≈ par). Bar trivially cleared — **the decision is *capability*, not the throughput percentage.**

### 8c. Trigger rule (locked)
**Worker = 64GB before any corpus-scale vision / pendant-ID / 27B-class local run — not before.** If the next stretch is only embeddings + small-model batch (which the M3 already clears overnight with headroom), the swap buys a faster *idle* box (+50% stranded above the bottleneck). Decide on the workload commitment, not the nameplate.

---

## Revision history
- 2026-05-31 — created from Workflow `wf_26c10c7a-956`; supersedes loose 22×/45× citations.
- 2026-06-03 — added §8: post-upgrade re-measure (Opus 4.8 fast-mode + 3-CLI team + M3 node + semantic index) and the workload-specific M3→2nd-M1Max-64GB worker-swap verdict (GO) + locked trigger rule. Single-read CEO estimate (not adversarial-workflow grade — flagged for swap-time re-run).
