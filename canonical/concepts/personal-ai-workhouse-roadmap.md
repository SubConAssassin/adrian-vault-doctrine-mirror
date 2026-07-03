# Personal AI Workhouse — Infrastructure & Growth Roadmap
**Status:** Canonical strategic doctrine (Tier-1). Author: Claude (CEO synthesis). Created 2026-06-21 from Adrian-direct vision dump.
**One-liner:** Build a multi-node Apple-Silicon "workhouse + playroom" that (1) catalogues & understands ALL of Adrian's content, (2) turns it into punchy multi-venture social content on demand, (3) automates the businesses, (4) hosts trained LLMs, (5) scales into a rentable product — growing organically, cash-gated, with resellable machines.

> ChatGPT's older multi-node cluster doc was **LOCATED 2026-06-26** — it is the `working/external-research-in/chatgpt-text/` architecture SERIES (no single master doc; 6 docs: hivemind-decision-intelligence-architecture, autonomous-hive-architecture-response, local-llm-and-mac-infrastructure, networking-and-ai-infrastructure, m3-node-a-setup, + Drive's AI-stack-role-allocation). Fully folded into the cluster spec draft `working/drafts-pending/personal-ai-workhouse-cluster-spec-DRAFT.md` (Part A tiers + Part D reconciliation) and §5a below.

---

## §1 — The intention (Adrian-direct 2026-06-21, verbatim intent)
"Completely catalogue every bit of content I've got on any drive" — the plugged-in hard drives, iCloud, Dropbox, **other hard drives that may exist**, any file anywhere — to the point where Adrian can say *"I need 10 reels about this topic"* and the system finds the relevant video/audio, edits it, formats it, applies retention-psychology pan/scan, overlays generated graphics/images/video, and outputs finished punchy content — for **Mastermind/Subconscious-Surgery, Original Siberian Blue, the Ashta Project, X-Maxed, and the rest.** Simultaneously: run the businesses (shops, inventory, supplier automation), vibe-code (house, jewellery), and train his own LLMs. Then **productise** the whole rig for others.

---

## §2 — HONEST scope correction on "how long" (the 7-day question)
- The earlier **~7 days** estimate was ONLY: transcribe the **1,513 remaining video files on the ONE hard drive currently plugged into M2**, on a single mlx engine, 24/7 (real measured avg 6.6 min/file, range 1s–138 min).
- It did **NOT** include iCloud, Dropbox, other drives, or files elsewhere — those add an unknown, larger total (must be discovered first).
- **Transcription ≠ "completely understood / topic-searchable."** Going from transcript → "find me clips about X" needs a second layer: **embeddings + semantic index** (ChromaDB) so every asset is retrievable by topic. That layer is lighter than transcription but is additional work.
- **Therefore:** "everything everywhere, topic-searchable" is a *program*, not a 7-day job — but it is fully achievable and the pipeline below makes it systematic. Single-node M2 is the bottleneck; nodes are the accelerant (a 2nd Apple-Silicon mlx engine ≈ halves transcription time).

---

## §3 — The pipeline (the content-intelligence engine)
1. **INGEST + CATALOGUE** — unified intake across ALL sources (plugged drives, iCloud, Dropbox, other drives, vault). Transcribe audio/video (mlx-whisper on Apple GPU; CPU faster-whisper on i7), extract docs/images, then **embed + index** into one searchable catalogue. Goal: *know exactly what content exists and what it's about.* (fleetfeed + drive-grinder + transcript-indexer + ChromaDB are the seeds of this.)
2. **UNDERSTAND + RETRIEVE** — semantic search over the catalogue: "find clips/audio about topic X" → returns assets + timestamps. (ChromaDB + embeddings.)
3. **PRODUCE** — the reel/clip engine: retrieve clips → vibe-edit (cut, format) → **pan/scan per "Advanced Real Psychology"** (eye-movement / retention dynamics) → overlay generated graphics/images/video → punchy finished output, per venture. Plus the **script→record→edit loop**: Claude writes scripts → Adrian records (audio/video) → Claude edits → YouTube videos / snippets / memes.
4. **DISTRIBUTE** — social-media content engine: schedule + post across platforms for every business (Postiz + mkt-* skills).
5. **AUTOMATE BUSINESS** — shops, inventory, supplier-integration automation per venture (OSB Shopify, SS Kajabi/Stripe, etc.).

---

## §4 — The fleet architecture (the load-bearing principle)
**Two capacity pools, dual-use, resellable:**
- **PLAYROOM (interactive, swappable, transient):** machines Adrian drives himself for vibe-coding — house (Blender), jewellery, designs. The principle he stated: *prompt one machine while another renders* — never wait. High-RAM (Blender/CPU-heavy). **When he walks away, this capacity is handed to the grind.**
- **GRIND FARM (autonomous 24/7):** transcription, render, embedding, content production — runs nonstop under Claude's control while Adrian sleeps/works.
- **LLM HOSTS:** high-RAM nodes running local LLMs (the research models + the trained-on-Adrian model).
- **ORCHESTRATOR:** M1 + Claude — the brain; dispatches, monitors, runs the fleetfeed/coordinator layer.
- **MANAGEMENT/PORTAL minis:** lightweight coordination + the team portals (§6).

**Hard constraint learned 2026-06-21:** each Apple-Silicon node runs **ONE mlx-whisper engine at a time** (2-in-process SIGABRTs; 2 processes shed-churn). So per node: one heavy job. Throughput scales by NODES, not by stacking on one box.

**Current → target fleet:**
| Tier | Have now | Incoming | Target (cash-gated) |
|---|---|---|---|
| Orchestrator / brain | M1 Max 64GB | — | M5 128GB MacBook Pro (main terminal) |
| Playroom (interactive) | M1 (doubles as this today) | M4 Apple-Silicon (3–4 days, reputable store) | **M3/M4 Ultra for 256GB+** personal workstation (⚠️ M2 Ultra caps at 192GB — "M2 Ultra 256GB" is NOT a real config; 256/512GB = M3 Ultra era). M2 Ultra 192GB = resell-safe entry option |
| Grind farm | M2 Studio 32GB (full, grinding) | i7 Intel (tomorrow — CPU transcribe/encode/janitor, NO mlx) | M2s 64GB ×few; minis |
| LLM hosts | — | — | M2 Ultra 192GB ×2–3 (research models + own-LLM) |

---

## §5 — The LLM layer (own-model training)
- **Train Adrian's own LLMs**: the biggest **DeepSeek**, trained on himself (his corpus).
- **Specialized research models** for the Ashta multi-node system: one trained as the **Skeptic**, one as the **Scientist**, one to find **pulse positives/negatives**, etc. — each a distinct role, cross-examined (maps to the §10.4 Council-Rotation method, but on owned local models).
- These need the high-RAM Ultra hosts (§4). The ChatGPT cluster doc is now located + folded in (see §5a + the cluster spec draft).

---

## §5a — The Sovereign Cognition Core (Adrian decision 2026-06-26)

**DECISION (Adrian-direct):** acquire a **second-hand M3 Ultra 512GB** to host the **full DeepSeek flagship (R1 671B-class, ~480–490GB at a usable quant)** resident in memory, as the **Executive Cognition Core**. **Driver = DATA SOVEREIGNTY.** This is the deliberate endgame (ChatGPT's Phase-4 "Executive Cognition Core"), not a throughput buy.

**This OVERRIDES §8's "avoid maxed 512GB" resale-caution — for this box specifically — because:**
- The goal is **sovereignty, not throughput/resale.** The 512 is the ONLY config the full 671B fits in (256 cannot hold it). Apple pulled the 512 SKU March 2026 → second-hand is the route (which is the plan).
- The "two 256s > one 512" finding applies to the **research-model society** (many models in parallel), NOT to holding the single biggest model resident. **Endstate = one 512 for the flagship + 256-class Ultras for the Skeptic/Scientist/pulse society (§5).**

**The significant benefits (why it was highly recommended — the affirmative case):**
1. **Total data sovereignty** — frontier reasoning over the most sensitive data (Bodhisvara voice/inferred-health under GDPR Art-9 + Indonesia PDP; SS client sessions; life-corpus; legal) with **zero bytes leaving Adrian's control.** The only architecture that lets him process data he can't ethically/legally put through a public API. The reason.
2. **Zero marginal cost forever** — own it, every token free; run 24/7 (corpus churn, always-on research models, the decision graph) with no meter.
3. **No rate limits / throttling / lockouts / deprecation** — unlike Claude weekly caps, AG 5–7-day lockouts, subscription cooldowns. Owned capability can't be nerfed or retired out from under him.
4. **Whole knowledge ecosystem resident** — 512GB holds the big model + huge retrieval context + the memory graph + embeddings at once = the sovereign second brain, not a chatbot.
5. **Runs the Ashta research-model society locally** — Skeptic/Scientist/pulse models as parallel instances, cross-examined (Council-Rotation §10.4), private, $0.
6. **Frontier capability as an owned asset** — near-top-tier reasoning on the balance sheet; the prototype for the rentable rig (§7).
7. **Resilience** — Bali internet drop, provider ban, lapsed sub → core intelligence keeps working.

**Honest nuances (recorded so the upgrade is eyes-open):**
- **Batch-grade speed:** 671B even on 512 generates ~5–20 tok/s (MoE helps) — a deep-reasoning/overnight engine, not a snappy interactive chat. Its job is *cognition core*, not *fast assistant*.
- **"Trained on himself" = host the 671B + LoRA-fine-tune a 14–32B on his corpus.** Apple Silicon cannot pre-train/full-fine-tune a 671B; full training (if ever) → rented cloud GPU, the fleet then hosts the resulting adapter. The "trained-on-me" model and the flagship are two different things on the box.
- **The model is the engine; the memory graph is the fuel** — the 512's value switches on only once the corpus is catalogued → embedded → graphed (§3 + Tier-4 of the cluster spec). Hardware first with an empty data layer = an expensive local chatbot. The data layer is the build that starts now (free).

**Sequencing unchanged:** M2 Ultra 192GB is still the FIRST cash buy (frees the M1, first LLM host); the M3 Ultra 512 sovereign core is the destination. Full benefits + reconciliation: `working/_research/2026-06-21-bodhisvara-infra-blueprint-SYNTHESIS.md` §8–9 + the cluster spec draft Part A/D.

---

## §6 — Team portals (as the team grows)
Role-scoped portals INTO the multi-node infrastructure: **social-media manager** → social tools only; **accountant** → financials only; **coder** → code/dev only. Each person plugs into Adrian's AI structure through a narrow, permissioned portal. Build as the team is hired.

---

## §7 — Productisation
The personal workhouse is the prototype for a **rentable product**: emulate the setup for other people / open the facility's spare capacity for a fee. The transient playroom capacity (idle when Adrian's away) is the rentable surplus.

---

## §8 — Organic, gentle scaling (cash-gated)
**Cash gate:** the twins (Aura + Sky mastermind) pulling the trigger, OR other sales. Until then: **scale gently, buy machines that hold resale value** (mid/high-tier Apple Silicon) so any redundant node can be sold with ~no loss.
- **NOW:** M1 = playroom + brain; M2 = grind (full); i7 (tomorrow) = CPU offload. The **incoming M4 (3–4 days)** = a 2nd Apple-Silicon node → either Adrian's swappable interactive machine (solves "I only have M1") OR a 2nd grind/mlx engine (≈halves transcription). Decide on arrival per what's more urgent.
- **FIRST cash purchase:** one **high-RAM Ultra** = playroom workstation #1 (frees M1) + LLM host when idle. Entry = **M2 Ultra 192GB** (sourced, resell-safe); for 256GB+ it must be an **M3/M4 Ultra** (M2 Ultra has no 256GB SKU). Dual-use, resellable.
- **THEN:** add Ultra(s) for the LLM cluster (research models + own-model training) + grind-farm nodes (M2 64GB, minis).
- **Principle:** every machine is dual-use (Adrian's playroom by day / grind+LLM by night) and resellable → low-risk, organic growth that tracks cash flow.

---

## §9 — Immediate next actions (Claude-owned)
1. Build the **audio↔video coordinator** so M2 is never idle (audio first, then drive-video, hands-off) — the "24/7 grind machine" piece (pending Adrian's go).
2. Extend the catalogue to ALL sources (iCloud, Dropbox, other drives) once discovered — unified intake.
3. ✅ DONE (2026-06-26) — ChatGPT cluster doc LOCATED (the `chatgpt-text` architecture series, no master doc) + folded into §5a + the cluster spec draft. Remaining: promote the cluster spec draft to canonical once the Phase-0 `events.jsonl` rsync-exclude + fleetd-lease checks pass.
4. Stand up the embedding/index layer so the corpus is topic-searchable (the "find me clips about X" capability).
5. Fix the fleetd over-lease before any 2nd node joins (multi-node correctness).

revision_history:
- 2026-06-21 — created from Adrian's full vision dump (catalogue-everything → content engine → business automation → own-LLM cluster → team portals → productise; playroom-vs-grind fleet principle; gentle cash-gated resellable scaling; M4 incoming 3–4 days from reputable store). ChatGPT cluster doc pending team search.
- 2026-06-26 — §5a added (Adrian decision, shutdown-save): M3 Ultra 512GB **sovereign cognition core** hosting the full DeepSeek flagship; driver = **DATA SOVEREIGNTY** — overrides §8 avoid-512 for THIS box (512 needed to hold 671B resident; 256-class Ultras for the research society). 7 benefits + honest nuances recorded for the upgrade. ChatGPT cluster doc **LOCATED** (chatgpt-text series, no master doc; searched GitHub bridge + raw import + Google Drive) — top-note + §9 updated. Sequencing unchanged (M2 Ultra 192GB first).
