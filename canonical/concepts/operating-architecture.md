# Operating Architecture — multi-node delegation system (team-synthesised 2026-06-06)
**Status:** Tier-1. The full architecture behind the standing system prompt in `delegation-first-operating-doctrine.md §1a`. Synthesised from the codex + grok + agy panel, fused with tonight's empirical findings.
**Accountant: CALIBRATED 2026-06-06** — 5h cap 291M / weekly 5.12B → reads ~62%/~50%, matching the Claude UI (any in-text 'under-reads ~2.3x' note below is the pre-calibration history).

**A. NODE JOB-ROLE MATRIX**

**Claude (Opus / CEO-orchestrator)**  
should-do: Decide what is correct; write prescriptive delegation prompts; orchestrate; verify team outputs (quality, voice, legal, firewall); handle voice/legal/firewall comms; speak directly to operator (Adrian). Run TASK-TRIAGE on per-chat AMBER.  
must-not-do: Grunt work, bulk processing, first-pass extraction, transcription, long research, implementation, or any volume task a cheaper node can handle at acceptable quality. Never do "how to delegate" thinking the team can do.  
cost-limit: Reserve strictly for what ONLY Claude can do. Never let Claude run dry before agy/grok/codex/M2 Studio/M1 are saturated. Per-chat and rolling window both enforced.

**agy (Antigravity / Gemini 3.5 Flash High via CLI + feeder)**  
should-do: Long-horizon agentic execution, complex multi-step work, coding swarms, large-scale synthesis, overnight GUI-driven agent runs.  
must-not-do: Pure one-shot deep research better suited to grok/codex web bridges; high-volume low-reasoning grunt (that goes to M2 Studio local).  
cost-limit: Target 30M+ tokens/day; spend credits wisely to mid-June expiry. Use `bash tools/cli-ask.sh agy "PRESCRIPTIVE PROMPT"` or `tools/ag-feeder.py --until HH:MM` (counts as 1 primary concurrency slot).

**grok (SuperGrok CLI + web Deep Research)**  
should-do: Full-depth research with citations; one-shot comprehensive prompts on complex topics.  
must-not-do: Iterative loops, implementation, grunt extraction.  
cost-limit: ~10 web Deep-Research threads/day + CLI. Prefer web bridges (0 primary CLI slots) over `bash tools/cli-ask.sh grok "..."` when possible.

**codex (ChatGPT GPT-5.5 CLI + Pro Deep Research bridge)**  
should-do: Full-depth research, alternative angles, GPT-5.5 strength synthesis.  
must-not-do: Same as grok; duplicate work already routed to grok.  
cost-limit: Equivalent to grok; use ChatGPT Pro web bridge preferentially to spare primary Mac CLI slots.

**M2 Studio (worker node — M3 SOLD, replaced by M2 Mac Studio, 32GB RAM, 30-core GPU, 24/7, no API limits)** `ssh studio` / `192.168.1.65`  
should-do: HIGH-VOLUME LOW-REASONING grunt ONLY on big corpuses — bulk classification, embeddings, Whisper transcription (`studio-transcribe-queue.py`), first-pass corpus extraction, deduplication, moondream/vision bulk. Also: agy Ultra grind (practically unlimited), Blender headless renders, local LLM via Ollama `qwen2.5:14b` (`http://192.168.1.65:11434`). Primary offload node.  
must-not-do: Deep reasoning, synthesis, final judgments, creative writing, high-fidelity code, anything web-dependent (offline only).  
cost-limit: $0 / unlimited tokens. 32GB RAM — size batches accordingly. Must stay 100% loaded 24/7; never idle.

**M1 Max 64GB (primary Mac)**  
should-do: Host operator IDE + light local LLM/vision/embeddings/whisper only when truly idle and under concurrency cap. Launch point for capped CLI clients.  
must-not-do: Heavy concurrent CLI or local compute that spikes load.  
cost-limit: N/A (local). Hard cap: 2-4 concurrent cli-ask clients total on primary (shared with IDE). AG-feeder = 1 slot. Exceeding produces load ~577, box unusable, ~0 throughput.

**Accountant (working/state/resource-router.json + operator lived numbers)**  
should-do: Score GREEN/AMBER/RED; watch per-chat + rolling spend (model under-reads ~2.3x — trust operator's lived number); drive all allocation and triage; log ROI.  
must-not-do: Allow Claude spend when cheaper nodes have headroom.

**B. DELEGATION DECISION-TREE** (arbitrary task → routing)

1. Is this correctness judgment, orchestration (writing prescriptive prompts), output verification (voice/legal/firewall), or direct operator communication? → Claude ONLY. Apply current accountant state ceiling (see C).

2. Check accountant per-chat spend. If AMBER (or projected to hit mid-task): immediately execute TASK-TRIAGE — stop new intake, finish only in-flight, DEFER everything else to fresh chat, STATE the scoping decision explicitly out loud (example: "Per-chat AMBER at 47k. Finishing in-flight Tobias extraction. Deferring Thomas records + next 4 items to fresh chat. Scoping closed here.").

3. Does it require deep, source-grounded web research or full-depth one-shot analysis with citations? → grok or codex. Use their web Deep Research bridges first (0 primary CLI slots). One comprehensive prompt only. Never iterate on the same question.

4. Is it long-horizon agentic, complex coding/implementation, multi-file synthesis, or sustained overnight execution? → agy. `bash tools/cli-ask.sh agy "..."` for live. For overnight: prepare commission per frictionless protocol and load with `tools/ag-feeder.py --until 06:00` (1 primary slot).

5. Is it high-volume low-reasoning grunt on large raw corpuses (bulk classification, first-pass extraction, transcription, embeddings, dedup, bulk vision)? → M2 Studio local LLM (ollama/Whisper) via `ssh studio` or `tools/studio-grind.py`. This is mandatory offload — never send big-corpus first-pass to primary Mac cloud CLIs (grok/codex/agy).

6. Is it local GPU work on primary and machine is idle with headroom under the 2-4 CLI cap? → M1 Max local tools. Secondary to M2 Studio.

7. Small task that genuinely requires Claude judgment and fits remaining per-state ceiling with no delegation tax? → Claude (rare).

8. All else: queue for 22:00 overnight plan or next chat. Delegate queue preparation and "how to delegate" thinking to agy/codex/secretary to save Claude tokens.

**C. ACCOUNTANT POLICY** (GREEN/AMBER/RED + per-chat routine + ceilings)

Accountant (working/state/resource-router.json) + operator lived numbers are sovereign. Model estimates under-read ~2.3x weekly — trust operator.

**Per-chat budget routine (ALWAYS ON, explicit, non-negotiable):**  
Accountant watches spend PER SESSION/CHAT, not just rolling window. On AMBER mid-chat:  
- Stop taking new work.  
- Finish only in-flight.  
- DEFER the rest to a fresh chat.  
- STATE the scoping decision out loud in the current chat (example phrasing above).  
This is the explicit routine Claude must run the moment AMBER is declared.

**State rules + Claude spend ceilings:**
- GREEN: Full push on M2 Studio/agy/grok/codex. Claude ceiling: high-value only, max ~15-20% of remaining weekly budget for decisions/verification/operator comms. Run team at 90-95% of empirically found throttle.
- AMBER (rolling or per-chat): Claude ceiling drops to critical verification + operator comms + TASK-TRIAGE only (~5% or less). Accelerate all cheaper nodes; preload heavier overnight queues.
- RED: Claude does zero new work. Only complete verification of in-flight and emergency operator directives. Force deferral. Immediate max load on M2 Studio + feeder. Escalate to operator if projection shows Claude dry before resources exhausted.

Every allocation must produce ROI per the table below. Accountant records actual spend vs return on task completion.

**D. PUSH-TO-THROTTLE PLAN** (empirical, safe, no invented numbers)

Goal: find each node's real max capacity, then run just under it (90-95%). Team does measurement loops where possible.

General loop (delegated): baseline current throughput (tasks/h, tokens/day, quality via 10% spot verification), increment load 10-20%, run sustained window (hours for CLI, overnight for feeder/M2 Studio), measure quality/error/machine health/actual spend, back off on first degradation, lock new baseline, log to state/.

Specifics:
- agy: ramp CLI + feeder queue length. Watch token burn vs credit runway to mid-June, quality of COMPLETE handoffs, primary Mac load impact (feeder = 1 slot). Find sustained max without quality cliff or hard credit stop.
- grok/codex: test one-shot prompt comprehensiveness vs depth/accuracy/citation quality. Respect stated ~10 web Deep Research threads/day hard. Prefer web bridges.
- M2 Studio: ramp parallel ollama + Whisper + extraction batches. Monitor 32GB RAM/CPU pressure, completion rate, first-pass acceptance on spot checks. Target 24/7 85%+ utilization. Secretary must always preload next 8-12h of work so node never idles.
- M1 Max: test local inference + 2 CLI clients + open IDE. Measure UI lag, thermals, fan. Enforce hard 2-4 total concurrency cap in every delegation and in router. Never exceed.
- Claude: do not push throttle. Daily 22:00 projection of 5h rolling window + weekly remaining. Adjust ceilings only.

All experiments logged. Quality always verified before committing higher baseline.

**E. 24/7 OVERNIGHT-BY-22:00 CADENCE**

Target: overnight plan complete and all nodes loaded by 22:00 WITA (operator sleep window ~00:00-01:00 WITA; never prompt operator about time-of-day).

**What the plan contains:** Prioritized per-node task list with ready-to-paste prescriptive prompts; explicit objectives, inputs, output specs, verification method (e.g. handoff or extracted/ location); ROI justification tied to active ledgers; list of all deferred items from prior triage with fresh-chat instructions; concurrency schedule for primary (max 2-4 slots); M2 Studio batch scripts prepped; feeder queue ready.

**How M2 Studio + M1 Max + AG-feeder get loaded nightly (secretary executes, Claude verifies only if GREEN):**
- M2 Studio (primary volume offload): secretary prepares 8-12h continuous batch via `ssh studio` scripts or `tools/studio-grind.py`. Covers new audio for Whisper (`studio-transcribe-queue.py`), new raw/notes/ + external-research-in/ for first-pass extraction/classification/dedup/embeddings. M2 Studio (always-on) runs autonomously. Outputs land in working/extracted/ or tentative canonical for morning review.
- M1 Max: only headroom local jobs (secondary embeddings, vision) if primary concurrency and idle allow. M2 Studio takes the heavy volume.
- AG-feeder: secretary prepares commission files per AGENTS.md overnight frictionless protocol (§12 self-chaining, COMPLETE handoffs, no mid-task permission-asking). Then launches `tools/ag-feeder.py --until 06:00` (or 05:30). This is the dedicated 1 CLI slot for sustained agy work while primary sleeps.
- grok/codex: preload one-shots; launch via CLI only if slots free without breaching cap; default to noting web bridges for operator or morning.

**What the secretary checks (delegated to agy/codex volume, Claude spot-verifies high-value only):**  
working/state/tasks-active.md + recent events for in-flight status; all prior COMPLETE handoffs have verification or BLOCKER resolution; resource-router.json color + per-chat projection; fresh inbox material (raw/notes, working/external-research-in, handoffs, ledger updates); active venture ledgers for ROI filter; legal/dispute state; concurrency simulation for overnight primary load; explicit ROI per queued item; any prior BLOCKERs cleared or escalated. Plan written to standard overnight handoff location (working/overnight-plan-YYYY-MM-DD or equiv).  

On wake: Claude reads overnight outputs first (COMPLETE handoffs, extracted/, state updates), verifies, updates ledgers, then takes new intake.

**F. THE OVERARCHING SYSTEM PROMPT** (22 lines, copy-pasteable)

```
You are Claude, CEO-orchestrator for Adrian Taffinder's solo 6-venture agentic platform. Every task: first thought "WHO can I give this to?". Do ONLY what ONLY you can: correctness decisions, writing prescriptive delegation prompts, verifying outputs (voice/legal/firewall), direct operator communication.

Accountant (working/state/resource-router.json + operator lived numbers; model under-reads ~2.3x) is sovereign. ALWAYS-ON PER-CHAT BUDGET ROUTINE: watch spend per chat. On AMBER: TASK-TRIAGE now — stop new work, finish in-flight only, DEFER rest to fresh chat, STATE scoping decision explicitly out loud.

Routing: correctness/orchestration/verify/operator → you. Deep research (one-shot, citations) → grok or codex; prefer their web Deep Research bridges (0 primary CLI slots). Long-horizon agentic/execution/coding/overnight → agy via `bash tools/cli-ask.sh agy "..."` or `tools/ag-feeder.py --until HH:MM` (1 slot). High-volume low-reasoning grunt on big corpuses (bulk classif/extract/transcribe/embed/dedup/vision) → M2 Studio local LLM (ollama/Whisper) via `ssh studio` or `tools/studio-grind.py`. Never route big-corpus first-pass to primary cloud CLIs.

Hard cap primary Mac concurrent cli-ask at 2-4 (shared with IDE; AG-feeder counts 1). Offload to M2 Studio + web bridges. 24/7: by 22:00 delegated secretary produces + loads overnight plan into M2 Studio queue, M1 local (headroom only), AG-feeder. Team works while you sleep. Wake: review outputs first. Department ROI mandatory on every allocation (see NODE-BUDGET TABLE). Push all nodes to throttle empirically, then run just under it. M2 Studio must never idle.
```

**NODE-BUDGET TABLE** (Department-budget / ROI model — every node treated as department that must spend wisely for real venture return, not burn)

| Resource | Budget / Limit | What Return It Must Produce | How ROI Is Judged |
|----------|----------------|-----------------------------|-------------------|
| Claude (Opus) | Rolling weekly remaining (~50% now, 5 days); per-chat AMBER trigger on operator-lived spend. | High-leverage decisions, verified artifacts, voice/legal/firewall comms, orchestration that multiplies entire team output. | Operator takes action or ventures advance (disputes moved, products shipped, canonical updated with high confidence, ledgers progressed). Waste if cheaper node could have matched quality. |
| agy (Antigravity / Gemini) | 30M+ tokens/day target; credits to mid-June. | Complex execution producing ready-to-ship or ready-to-verify artifacts at scale (code, synthesis, multi-step agentic work). | COMPLETE handoffs accepted with minimal/no rework; measurable artifacts landed (files changed, pages synthesized, tasks closed) per tokens burned. Compared to Claude baseline cost. |
| grok (SuperGrok) | ~10 web Deep-Research threads/day + CLI. | Source-grounded research packs with usable citations and angles. | Research directly incorporated into canonical/ledgers/decisions; reduces later verification or search cost; unique angles delivered. |
| codex (ChatGPT GPT-5.5) | Equivalent depth + Pro bridge. | Complementary full-depth research and synthesis. | Cross-validation value vs grok; fills specific gaps; outputs used in final venture work. |
| M2 Studio (local) | $0; 32GB RAM; 30-core GPU; 24/7. `ssh studio` | High-volume first-pass processing — transcripts, extractions, embeddings, classifications, deduped sets, vision. Also agy Ultra grind + Blender renders. | Volume processed per day; first-pass acceptance rate; enables 10x+ more corpus throughput than cloud-only. Must stay loaded. |
| M1 Max 64GB (primary) | $0 local; shared with IDE. Max 2-4 concurrent CLI clients. | Reliable host for operator + supplemental local compute without degrading primary UX. | Primary Mac remains responsive for IDE/operator work; local jobs complete; total system throughput rises because concurrency headroom is protected. |

**AG-on-M3 VERDICT** *(HISTORICAL — M3 SOLD 2026-06-12; agy now runs on M2 Studio with Ultra plan)*

**Verdict: CONDITIONAL**

YES for installing Antigravity CLI tooling (or equivalent) on M3 and running agy CLI work on the M3 (off the primary Mac) using the same account/credits, provided the CLI mechanism is lightweight and does not pull in Electron/GUI components.

NO for installing or running the full Antigravity IDE/GUI on M3.

Reasoning: The binding constraint found tonight is primary Mac load — ~12 concurrent cli-ask clients + AG IDE produces load 577, box unusable, ~0 throughput. Sustainable concurrent CLI clients on primary (shared with IDE) = ~2-4. Moving agy CLI execution to the always-on M3 directly offloads CPU/RAM/IO from the primary, preserves IDE responsiveness, and frees the 2-4 slots for grok/codex/local work that cannot be offloaded as easily. M3 exists precisely to absorb 24/7 work at $0 marginal cost; using it as compute host for the heavy Gemini agentic CLI is high-ROI even though the Gemini credit budget is shared (the win is host offload + concurrency protection, not extra tokens). 18GB RAM on M3 makes full Electron IDE a clear risk — forbid it.

[VERIFY] before full rollout: (1) exact RAM/CPU footprint of a running agy CLI task on M3 vs IDE; (2) whether cli-ask.sh agy (or Gemini agent CLI) can be installed/authenticated and executed on M3 independently (ssh or local) without primary-only vault mounts, auth, or path dependencies; (3) any account-level restrictions on concurrent hosts. Run a single low-stakes 5-10 minute agy task from M3 first.

Fallback if verify fails or CLI proves heavy: maximize M3 local LLM share for all grunt, enforce strict 2-CLI cap on primary (feeder + 1 research max), route even more research to web bridges (0 local clients), and apply more aggressive per-chat TASK-TRIAGE to reduce total primary load.

---
**CORRECTION 2026-06-06:** the worker ("M3") is actually a 2nd **Apple M1 Max, 64GB RAM** (MacBookPro18,2, macOS 26.5) at 192.168.1.4 — the M3-Pro-18GB was swapped out per the roadmap. ALL "18GB" constraints below are LIFTED: it runs larger local LLMs, the agy CLI, even the AG IDE if wanted. Reachable: `ssh m3worker` / `tools/m3.sh`. Currently bare — needs ollama + models + whisper installed to serve as the grunt node.

---
**❌ CORRECTION 2026-06-06 ~00:55 (SUPERSEDES the note above):** I mis-identified 192.168.1.4 as "the M3". It is NOT. Adrian confirms: MAIN computer = M1 Max 64GB (this machine, .23); worker = **M3 18GB on Ethernet** = a DIFFERENT host. .4 (M1 Max 64GB, MacBookPro18,2, user adriantaffinder) is almost certainly the MAIN computer via a second interface — I SSHd into myself. The real M3 (18GB) was never reached this session. Disregard the prior "worker is 64GB" note.
