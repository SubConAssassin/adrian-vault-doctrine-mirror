---
title: Hive Architecture v3 — Post-Audit, Post-3.5-Flash, Pre-64GB-MacBook
type: architecture-doctrine
tier: 1
date: 2026-05-20
hardware_update: "2026-05-30 — the 64GB MacBook HAS ARRIVED: Apple M1 Max, 64GB, 10-core (8P+2E), verified via system_profiler. All 'incoming/arriving/pre-64GB/gating-on-arrival' framing below is now RESOLVED — the Layer-4 'At 64GB' column is the live state. The 18GB-memory-pressure narrative is historical. Local LLM inference / ECAPA / Whisper-large / vault embeddings / 16x fan-out are now locally feasible (chip is M1 Max not the speculated M3/M4, but RAM is the binding constraint and it's met)."
authored_by: claude (cowork, Phase F.1 — synthesizing 4 discovery subagents + Gemini 3.5 Flash research + Grok/GPT + ChatGPT advisor inputs + my own capabilities)
firewall_class: working-internal
supersedes: |
  - The pre-2026-05-20 implicit architecture (Claude orchestrating AG via GUI keystroke chain + supervisor stack)
  - Resource-partition 3-mode framework (STRATEGY/EXECUTION/PARALLEL-LIGHT) — retired at 64GB
  - Master plan §0 "audit → real work" sequencing (Adrian-amended 2026-05-20 to parallel-track)
informs: |
  - AGENTS.md §11 amendments (queued Phase F.4)
  - canonical/concepts/antigravity-operating-contract.md v2 (queued Phase F.4)
  - canonical/concepts/hive-mind-resource-map.md v3 (this file's resource section)
  - canonical/concepts/claude-ceo-operating-doctrine.md (extends with v3 clusters)
purpose: |
  Single consolidating architecture document for the Adrian hive-mind stack as of
  2026-05-20. Locks in the architecture changes triggered by:
  - Antigravity now running Gemini 3.5 Flash High (4× faster, 4-8× cheaper, beats 3.1 Pro at coding)
  - Antigravity 2.0 (dynamic subagents, scheduled tasks, CLI, SDK — the Phase 2 control plane)
  - Vault-perfect state achieved (every corpus dispositioned; zero RAW)
  - 64GB Apple Silicon MacBook incoming
  - Adrian's "fully engaged 12h burn" directive
  - 4 parallel discovery subagents grounding the new state
  - Grok/GPT + ChatGPT advisor inputs (filed in working/external-research-in/)
---

# Hive Architecture v3

> "Take all this research, all these recommendations, all these new strategies and techniques and apply them moving forward on all our infrastructure and all our workflow." — Adrian, 2026-05-20 ~16:30 WITA

## 0. Why this document exists

The week of 2026-05-15 → 2026-05-20 changed every major axis of the hive simultaneously:

1. **Model layer:** Antigravity swapped from Gemini 3.1 Pro to Gemini 3.5 Flash High (a structurally faster, cheaper, more capable model — co-designed for agentic workflows).
2. **Platform layer:** Antigravity 2.0 launched (native subagents, scheduled tasks, CLI, SDK — eliminating the keystroke-chain failure mode that caused the 2026-05-19→20 7.5h overnight stall).
3. **Audit layer:** Vault-perfect achieved (50+ corpora dispositioned, catastrophe pattern definitively absent across ~1,500 audited canonical files, 52 §7 quarantine events, zero RAW remaining).
4. **Hardware layer:** ✅ ARRIVED 2026-05-30 — Apple M1 Max, 64GB, 10-core (replaced the 18GB Mac that was in YELLOW-bordering-RED memory pressure). Memory pressure resolved.
5. **Doctrine layer:** Adrian explicitly authorised parallel-track work (audit + product build concurrent, not sequential — master plan §0 amended).

This file is the synthesis: what the hive looks like now, what work routes where, and how to execute the next phase at full velocity.

## 1. State of the hive — verified 2026-05-20

**Corpora — all dispositioned per master plan §0:**

| Layer | State | Source |
|---|---|---|
| 6 GOLD corpora (SS clients 763, michelle/emily/revival 16, WhatsApp 27, Personas 19, Voice memos canonical 273, FB summaries 169) | Forensically grounded | Hive audit Phase A-D + Phase E |
| 6 TRUTH-AUDITED corpora (ChatGPT summaries 1,278, Mastermind synthesis 1-66 + appendix, Mastermind sessions 69, SS doctrine 54, ChatGPT-conversations 855 post-§7, Intel mastermind-transcripts 31) | Catastrophe pattern absent | Wave-1 + Wave-2 verification |
| 14 NORMALIZED-UNVERIFIED corpora (talks, old library, unified records, client folders 172, mastermind batches, session transcripts, self-narrative, working voice memos, audio raw, video transcripts, etc) | Honest UNVERIFIED stamps | Phase A-C |
| 52 §7 quarantine events | Preserved for human disposition | Phases A-D + Phase E |
| Facebook grounding | In progress (~63% at last check) | Phase E + post-reboot restart |
| **Apple Notes (NEW corpus surfaced by Phase F)** | **RAW (40MB dump exists at `working/extraction/icloud/notes-dump-2026-05-04.txt`, 2,558 notes, NEVER canonicalised)** | Phase F.2 builds the ingest |
| DEFERRED-WITH-REASON | Photos.sqlite (Adrian decision), personal-recordings + conversations (acoustic env-blocked), Instagram DMs (54), Dropbox 70%, Stephan email, Tier-0 acoustic | Phase C + roadmap |

**Compute substrate — verified 2026-05-20 ~16:00 WITA:**

| Component | State |
|---|---|
| Antigravity.app | Running (pid 24333), on Gemini 3.5 Flash High |
| Supervisor stack (ui-autoloader / burn-watchdog / hive-supervisor) | DEAD post-reboot — Adrian-gated to resume |
| Real Fix 1 in `tools/ui-autoloader.sh:361` | Applied (clear lock on failed keystroke) |
| Mac RAM | 18GB, **240MB free / 1.22GB swap active / 37% compressed** — at the wall |
| Vault size | 24GB |
| GitHub bridge backup (private mirror) | Fresh — commit `6cf2e28` 2026-05-20 14:56 |
| Encrypted forensic artifact | `~/Documents/Adrian-Vault-encrypted-backups/companies-VERIFIED-FORENSIC-20260519T160155Z.tar.age` (36MB) — needs re-creation after today's vault-perfect milestone |

## 2. The four architectural layers

The hive is no longer "Claude + AG + advisors." It's now a four-layer stack.

### Layer 1: Claude (CEO / Doctrine / Memory Governor / Cross-Verifier)

**Claude-the-model:** Sonnet 4.7 (1M context window).

**What Claude does in v3:**
- Strategic synthesis, doctrine maintenance, vault canonical authority
- Cross-model verification (verify-not-trust AG/ChatGPT/Grok claims)
- Memory governance (claude-mem + MEMORY.md index + canonical/state/)
- Heavy forensic work directly (the 20X plan = forensic engine per HARD memory)
- Multi-subagent fan-out for breadth scans (demonstrated 8x today)
- Final arbitration on Adrian-decision questions (§8 protocol)
- The vault's "single source of truth" gatekeeper

**Tool ecosystem Claude commands:**
- Bash, Read, Write, Edit, WebSearch, WebFetch
- Agent (parallel subagents)
- TaskCreate / TaskUpdate / ScheduleWakeup
- ~200 skills (brand-voice, mkt-*, wiki-self-heal, vault-ingest, voice-persona-curator, memory-hygiene, legal-dispute-mgr, ops-ledger-keeper, etc)
- ~30 MCP servers (Gmail, Calendar, Wix, Apple Notes, iMessage, Apple Calendar, Granola, Bright Data, Apify, Postiz, Adobe, Blender, PDF Tools, computer-use, Claude_in_Chrome, Claude_Preview, mosaic-video-editor, claude-mem, etc — many underused per subagent D audit)

**Token economics:** Max 20X plan. Weekly window. Currently at 53% used / 12h remaining (per Adrian 2026-05-20 ~16:30). Per HARD `feedback-no-scarcity-framing-on-ag.md`: don't ration. Per HARD `feedback-claude-direct-forensic-not-delegate.md`: heavy forensic directly, not delegate.

### Layer 2: Antigravity 2.0 + Gemini 3.5 Flash High (Execution Engine)

**Model:** Gemini 3.5 Flash with `thinking_level=high` (default Antigravity config for serious work).

**Why this layer just got dramatically stronger:**

| Metric | 3.1 Pro (was) | 3.5 Flash High (now) | Hive impact |
|---|---|---|---|
| SWE-bench Verified | 76.2% | 78% | Mastermind product code quality up |
| MMMU Pro multimodal | ~81% | 81.2% | Tied |
| MCP Atlas (tool reliability) | — | 83.6% | TCC sandbox issues should reduce |
| Speed | baseline | **4× faster** (12× optimised) | Loop density unlocked |
| $/M input tokens | $2-4 | **$0.50** (4-8× cheaper) | Subscription-burn ROI compounds |
| Multi-hour autonomy | partial | co-designed for sustained runs | Overnight grind becomes structural, not bolted-on |

**Antigravity 2.0 platform changes:**
- **Dynamic subagents** — AG can fan out work to its own subagents (parallels Claude's pattern; multiplies AG throughput inside AG itself)
- **Scheduled tasks** — native background automation. **This is the killer feature for our hive.** Adrian's directive "stack it up and it will execute all night" is structurally supported now, not held together by the supervisor stack.
- **CLI + SDK** — programmatic/headless control surfaces. **This is the Phase 2 control plane** ChatGPT Pro recommended on 2026-05-15. Migrating to it kills the keystroke-chain failure mode entirely (Fix 1 + Fixes 2-5 from my infra-fix-spec all become obsolete).
- **AI Ultra $100/mo** + $100 bonus Antigravity credits (window expires 2026-05-25 — pure arbitrage if not enrolled)

**Burn-economics doctrine update (AGENTS.md §11.5 will be amended in Phase F.4):**
- Previous: "30M+ tokens/day target"
- v3 math: 4× speed × 4-8× cheaper-per-token = **same dollar/hourly budget covers ~16-32× more effective work**. The "burn as fast as you can" directive is more correct than when written.

**What AG does in v3:**
- Coding swarm work (UI generation, refactoring, repo-wide changes, multi-file edits)
- Long-horizon autonomous loops (Mastermind product build, forward-corrective sweeps)
- Multimodal pipelines (screenshots, diagrams, video understanding via 3.5 Flash multimodal)
- Tool orchestration (MCP Atlas 83.6% reliability)
- Sustained-quality multi-hour runs (overnight grind)
- Repetitive engineering ops at parallel scale

### Layer 3: Subscription Advisors (ChatGPT Pro + SuperGrok)

**Channels:** Filesystem-only bridge at `working/external-research-in/` (Drive bridge RETIRED 2026-05-12; GitHub bridge `SubConAssassin/adrian-hivemind-private/inbox/` for inbound).

**What advisors do in v3:**
- Independent strategic analysis (today's Grok+GPT + ChatGPT inputs on Gemini 3.5 Flash demonstrated value — added "Loop density" framing + concrete experiment patterns)
- Cross-model adversarial review (ChatGPT-builds / Grok-challenges / Gemini-strategic per HARD `feedback-three-model-synthesis.md`)
- Deep research mode that doesn't fit in Claude's session window
- Image/video generation (DALL-E + Sora via ChatGPT Plus; Aurora via SuperGrok)

**Operational rules (HARD memory):**
- Bridge-push claims are hallucinated — verify via filesystem (`feedback-external-bridge-verify-and-filter.md`)
- One-shot protocol — single comprehensive prompt, no iteration loops (HARD §4)
- Bridge research = raw ore, not finished doctrine
- Drive/GitHub-push claims by Grok specifically are 100% unreliable

### Layer 4: Local Substrate (✅ 64GB Apple M1 Max — arrived 2026-05-30; the "At 64GB" column below is now live)

**Current state (18GB):** memory-pressured; cloud-redirect required per resource-partition-protocol.md for: ECAPA acoustic, Whisper large-v3, Photos.sqlite OCR, local LLMs, vault embedding indices, 16x subagent fan-out.

**Post-64GB unlock matrix** (per subagent C):

| Capability | At 18GB | At 64GB | Priority |
|---|---|---|---|
| **Tier-0 acoustic diarization (ECAPA + speechbrain)** | env-blocked + RAM-tight | Comfortable, parallel 4-8 streams | **HIGHEST** — unlocks SS blueprint-method build |
| Whisper large-v3 local | Marginal | Comfortable | Med — better SS transcripts |
| Local LLM (Gemma 27B-Q4) | Impossible | ~16GB headroom | Med — offline/cheap inference |
| Local LLM (Llama 3.3 70B-Q4) | Impossible | ~40GB tight but feasible | Med |
| Subagent fan-out 16x parallel | Risky | Safe | High — forensic acceleration |
| Photos.sqlite Phase 4 OCR | Cloud function | Local | Med — unblocks deferred work |
| Whole-vault embedding/RAG | Cloud-only | Local | Med — no API spend for RAG |

**Honest caveat (per subagent C):** The biggest unlock is **Tier-0 acoustic** + **subagent fan-out at scale**, NOT local LLM hosting. Gemma 27B-Q4 is useful but doesn't compete with Claude/Gemini/ChatGPT for serious reasoning. 64GB **complements** the API/subscription layer; doesn't replace it.

**Things that do NOT change at 64GB:** AG rate limits (API-side), API quotas, GUI keystroke bugs (if not migrated to CLI/SDK), launchd EX_CONFIG failures, network bandwidth, AG sandbox restrictions, the corpus (measured 2026-06-14: **~59.5M words** ingested source / **~147.8M** whole-vault text incl. derived synthesis — the earlier "84M" was an unscoped round number, never a measured `wc`) still needs same forensic discipline.

## 3. The Six Capability Clusters

Per subagent D's self-audit. These are the highest-leverage Claude-side integrations to wire into v3.

### Cluster 1: "Connecting all the strings" (Notes + iMessage + Granola)

**The three corpora Adrian gestured at that have ZERO vault ingest.**

Components:
- **Apple Notes MCP** + `tools/dump_apple_notes.applescript` — dump exists at `working/extraction/icloud/notes-dump-2026-05-04.txt` (40MB, 2,558 notes, 15-year span 2012-2026, **150+ direct project/client/contact title matches**). `raw/notes/` empty.
- **iMessage MCP** + `tools/imessage-discover.py` — texting history with key contacts. Stefi/Tristan/Phil/Ryan/Stephan likely have iMessage threads parallel to WhatsApp.
- **Granola MCP** — meeting transcripts. Mastermind sessions may already exist there with structured speaker tags (vs $0-via-whisper-cpp re-transcription).

**First-use case:** Notes ingest tool (Phase F.2) — 2,558 notes canonicalized to `raw/notes/`, classified, cross-referenced into person timelines.

**Why this matters:** Apple Notes = **the longest continuous Adrian-authored timeline in the vault** (15 years). It connects every other corpus.

### Cluster 2: OSB Visual Production at Scale (Adobe + Blender + canvas-design + mosaic)

Components:
- **Adobe MCP** (`mcp__0ae9cd3b-*`) — image generation, retouch, social variations, design from template
- **Blender MCP** (`mcp__Blender__*`) — 3D photoreal renders of crystal jewelry (Merkaba, Tranquility, Arcturian Navigator pendants)
- **canvas-design skill** — static visual art for marketing
- **mosaic-video-editor** (v1.3.0 installed inert since 2026-05-05) — video editing for OSB launch reels
- **mkt-video-postprod / mkt-ugc-scripts / mkt-social-deploy / mkt-content-repurposing** — the marketing skill suite

**First-use case:** OSB launch kit — 30 assets (5 platforms × 6 angles) for Merkaba + Tranquility, exercising Adobe MCP for the first time.

### Cluster 3: Active-Legal Workflow (PDF Tools + legal:* + DocuSign)

Components:
- **PDF Tools MCP** — fill/sign/merge/split/extract for legal docs
- **legal:* skills** — review-contract, brief, legal-response, signature-request, legal-risk-assessment, vendor-check, compliance-check, meeting-briefing
- **legal-dispute-mgr** (existing custom Adrian skill)
- **DocuSign MCP** — envelope creation, signature workflows
- **pdf-viewer:sign / fill-form** — interactive PDF workflows

**First-use case:** Erica civil-filing bundle assembly — split/merge evidence PDFs, fill court forms, redact §7, prepare signing packet.

### Cluster 4: Multi-Venture Social Deployment (Postiz + mkt-*)

Components:
- **Postiz** (28+ channels: X, LinkedIn, Reddit, IG, FB, Threads, YouTube, TikTok, Pinterest, Bluesky, Telegram, etc)
- **mkt-content-repurposing** — 1 source → 8 platform-native posts
- **mkt-social-deploy** — platform-native deployment + 5-angle ad-test orchestration
- **mkt-ugc-scripts** — 3-variant short-form video scripts

**First-use case:** SS v2.4 reframe cascade — 1 source (the consciousness advisory positioning) → 8 posts × 4 platforms via Postiz, with brand-voice enforcement and persona-routing.

### Cluster 5: Cross-Corpus Knowledge Graph (graphify + enterprise-search)

Components:
- **graphify** — any input → clustered knowledge communities → HTML + JSON + audit report
- **enterprise-search:knowledge-synthesis / digest / search-strategy** — formalized cross-corpus synthesis patterns
- **vault-ingest** — raw → canonical with frontmatter, decisions, entities

**First-use case:** People-x-decisions-x-timeline graph for `canonical/adrian-corpus/biographical-arc.md` grounding — input = 133 people cards + WhatsApp grounded + Mastermind + Notes-once-ingested. Output = navigable knowledge graph.

### Cluster 6: Investor Decks (pptx + canvas-design + investor-pitchman persona)

Components:
- **anthropic-skills:pptx** — slide deck production
- **canvas-design** — visual art for slides
- **investor-pitchman persona** (per `canonical/adrian-corpus/personas/persona-the-investor-pitchman.md`)
- **brand-voice:enforce-voice** — voice consistency

**First-use case:** AGA Bali 2% equity ask — 12-slide PPTX from the existing ledger + Adrian's investor-pitchman voice. (Note: per Adrian's "stop reminding" directive, this is queued for when Adrian engages with AGA decisions, not auto-fired.)

## 4. The Routing Matrix v3

Synthesized from ChatGPT's recommendations + my own analysis + the v3 architecture. **This is the operational truth — what work goes where, why.**

| Task type | Primary layer | Reason | Notes |
|---|---|---|---|
| **Strategic synthesis** | Claude | 1M context, doctrine authority, memory governor | Final read always Claude |
| **Cross-model verification** | Claude | verify-not-trust HARD doctrine | Mandatory before fold to canonical |
| **Deep forensic audit** | Claude direct | 20X plan = forensic engine | Heavy reads + spot-checks; subagent fan-out for breadth |
| **Doctrine / canonical promotion** | Claude | Vault gatekeeper | Per AGENTS.md §6 promotion threshold |
| **Active-legal drafting** | Claude + PDF Tools + legal:* | Multi-source legal-grade synthesis | Adrian-decision gates |
| **Source-of-truth state queries** | Claude + Gmail MCP | feedback-source-of-truth-first HARD | Gmail authoritative on email threads |
| **Coding swarm / app build / refactor** | AG (3.5 Flash High) | 78% SWE-bench beats 3.1 Pro; 4× faster | Mastermind product, web apps, automation |
| **Long-horizon autonomous loops** | AG (3.5 Flash High) | Multi-hour sustained autonomy by design | Scheduled tasks native in 2.0 |
| **Repetitive engineering ops at parallel scale** | AG dynamic subagents | Native fan-out in 2.0 | Forward-corrective sweeps |
| **UI/UX generation** | AG | 78% SWE-bench coding, multimodal input | Antigravity-native strength |
| **Multimodal pipeline** | AG (3.5 Flash multimodal) | 81.2% MMMU Pro | Screenshots, diagrams, video understanding |
| **Acoustic diarization** | Local 64GB (post-MacBook) | ECAPA needs RAM | Currently env-blocked + RAM-tight at 18GB |
| **Whisper large-v3 transcription** | Local 64GB | ~10GB model + activations | Currently faster-whisper-small only |
| **OCR pipelines (Photos.sqlite etc)** | Local 64GB | Pipeline + parallelism | Phase 4 currently HOLD |
| **Subagent fan-out 16x parallel** | Local 64GB | RAM headroom | Currently capped ~4x due to swap thrashing |
| **OSB visual production (image)** | Claude + Adobe MCP | Adobe MCP underused; 1M context for brand context | Cluster 2 |
| **OSB visual production (3D)** | Blender MCP | Photoreal crystal renders | Never attempted |
| **Marketing copy + voice enforcement** | Claude + brand-voice:* | Voice firewall + persona routing | Existing strength |
| **Multi-platform social scheduling** | Claude + Postiz + mkt-content-repurposing | 28+ channels | Cluster 4 |
| **Investor deck production** | Claude + anthropic-skills:pptx + persona | Persona-grounded slide deck | Cluster 6 |
| **Cross-corpus syntheses** | Claude + graphify + enterprise-search:* | Knowledge graph + formal synthesis | Cluster 5 |
| **Deep research (one-shot, large context)** | ChatGPT Pro / SuperGrok | Deep research mode | One-shot protocol HARD |
| **Adversarial strategy review** | ChatGPT (builds) + Grok (challenges) | Three-model synthesis HARD | Three-model panel, weight the challenge |
| **Image/video generation (large)** | ChatGPT Plus (DALL-E + Sora) / SuperGrok (Aurora) | Subscription-covered | Bridge via filesystem |
| **Native macOS app interaction** | computer-use MCP | When no MCP exists for the app | Photos.sqlite, native dashboards |
| **Live web data / SERP / scrape** | Bright Data MCP (HARD doctrine) | Replaces WebSearch/WebFetch | One-shot per query |
| **Real-time competitive intel** | brightdata-plugin:competitive-intel | Live competitor pricing/news | OSB/SS competitor monitoring |

## 5. Reliability Architecture v3

Pre-v3: Claude orchestrates AG via GUI keystroke chain (`ui-autoloader.sh`) supervised by `burn-watchdog.sh` + `hive-supervisor.sh`. Failure modes: Accessibility-permission drops, frontmost-or-abort gating, supervisor death on reboot, launchd EX_CONFIG.

**v3 reliability target: migrate to Antigravity 2.0 CLI/SDK control plane.**

> ⚠️ **REALITY STAMP (2026-05-29, audit `wf_a691ad22`):** `tools/ag_cli_driver.py` is **NOT built.** Everything in this §5 below — the "Phase 2 Control Plane", the failure-modes-eliminated list, the migration plan — is **aspirational and Adrian-approval-gated, NOT live.** The ONLY working AG driver today is the GUI keystroke feeder (`ag-feeder.py` / `ag-feeder-multi.py` / `bounce-to-ag-window.sh`), and it still misfires (typed into a code editor; hit Record instead of Send — 2026-05-29). AG 2.0 does expose a CLI/SDK (obs 5228, 2026-05-26) but it is sandbox-restricted and **unverified for programmatic prompt-injection**. Do NOT route work assuming a reliable programmatic AG control plane exists. The genuine decision — authorise a time-boxed spike to prove the CLI/SDK can drive AG — is tracked in `canonical/concepts/cross-model-automation-protocol.md §8` (the reconciling authority for cross-model automation).

### Phase 2 Control Plane (specced 2026-05-15 by ChatGPT Pro review; now buildable via AG 2.0 CLI/SDK)

Components:
1. **SQLite job queue** — durable task storage (replaces filesystem handoffs as the primary queue; handoffs continue as inter-agent comms but not as primary scheduling layer)
2. **AG CLI/SDK driver** — programmatic AG cycle triggers (replaces ui-autoloader keystroke chain)
3. **Verifier-quarantine gate** — every AG completion runs through `tools/ag_verify.py` (already exists) before fold to canonical
4. **Scheduled tasks (Antigravity 2.0 native)** — overnight grind structurally supported, not bolted-on

**Failure modes eliminated by Phase 2:**
- Accessibility-permission drops (no osascript dependency)
- Frontmost-or-abort gating (CLI works regardless of front window)
- Supervisor death on reboot (no nohup processes needed; AG-native scheduling)
- launchd EX_CONFIG (no LaunchAgents needed)
- Keystroke pile-up coordination races

**Migration plan (Adrian-approval-gated; spec only here, NOT auto-executing):**
1. Install AG CLI / SDK on current Mac (research what's available now post-I/O launch)
2. Build minimal driver: `tools/ag_cli_driver.py` that fires AG cycles via CLI
3. Test against a non-critical commission (e.g., Master Plan §3 item 7 follow-on)
4. Migrate Mastermind synthesis batch 21+ workflow off ui-autoloader onto CLI driver
5. Migrate scheduled tasks off `burn-watchdog.sh` cycle-prompting onto AG 2.0 native scheduling
6. Deprecate the supervisor stack (preserve as fallback for 30 days; then archive)

**Estimated effort:** 1-2 sessions to scope + 2-3 sessions to migrate. Net: permanent reliability fix. Worth gating on the 64GB MacBook arrival so it lands on the fresh setup, not the over-pressured 18GB.

### Interim reliability (while waiting on Phase 2)

- **Fix 1 (applied 2026-05-20 14:47):** `tools/ui-autoloader.sh:361` clears quiet_until on failed keystroke (eliminates the autoloader-gags-watchdog overnight stall pattern).
- **Fixes 2-5 (specced, Adrian-approval-gated):** functional probe in `autoloader_running()`, Accessibility-revocation URGENT escalation, tier-5/6 cumulative-staleness re-fire, doctrine update for Accessibility-revoked failure mode.
- **Supervisor stack on-demand:** `tools/ag-automation.sh resume` re-arms when Adrian says "resume AG". Never auto-restart per HARD `feedback-ag-down-may-be-intentional.md`.

## 6. The "Connect All The Strings" Mission

Adrian's directive: *"everything is true to life as in recorded client sessions along with that chat from Facebook and their notes from my note app and their partition in the Mastermind are all connected referenced and audited for truth."*

This is the cross-corpus truth-grounding mission. Per subagent B's cross-corpus person index baseline, here's the build order:

### Top 7 unified person records (per subagent B's recommendation)

| Priority | Contact | Corpora span | Build leverage |
|---|---|---|---|
| 1 | **Erica Johnson** | 8 corpora (WA absent, FB+VM+Mastermind+SS+OSB-legal+Intel+ChatGPT) + Notes pending | Active civil-filing brief ready; documented non-compliance ground; highest legal stakes |
| 2 | **Stefi/Tristan** | 6 corpora (FB+VM+Mastermind+SS-clients-763+ChatGPT+intel) + Notes pending | Gold-grounded forensic anchor; consolidates the library |
| 3 | **Stephan Schwartz** | 7 corpora (FB+VM+Mastermind+OSB-receiving+intel+ChatGPT+email) + Notes pending | Only contact with full email corpus; OSB crystal source; spiritual-not-contractual |
| 4 | **Lacresha + Emme-Rain** | 5 corpora + legal-evidence preservation videos + Notes pending | Forensic preservation ring-fence; high reconciliation value |
| 5 | **Gino Yu** (§7 WA must unlock first) | 7 corpora + Notes pending | Strategic advisor across all ventures; 157 FB + 144 WA + 28 VM + 3 Mastermind |
| 6 | **Yoga** (§7 WA must unlock first) | 7 corpora + Notes pending | OSB master artisan; 2,168 WA msgs (largest of any contact) + 90 FB + 40 VM |
| 7 | **Marcus Schmieke** | 5 corpora + Notes pending | Bodhisvara biological-resonance lineage; clean dataset; quick win |

### Unified record schema (proposed)

Each becomes `canonical/people/{contact}-unified.md`:

```yaml
---
contact: <name>
slug: <kebab>
firewall_class: <strictly-private-legal-personal | working-internal | etc>
date_built: 2026-05-20
corpora_referenced:
  - whatsapp: <count msgs, grounded path>
  - facebook: <count threads, grounded path>
  - voice_memos: <count, paths>
  - mastermind: <session refs>
  - ss_clients: <path>
  - osb_legal: <path>
  - intelligence: <path>
  - chatgpt_summaries: <count, paths>
  - notes_app: <count, paths>  # post-F.2 ingest
  - email: <count, paths>
relationship_class: <ex | client | business | family | spiritual | etc>
active_legal: <yes/no + status>
section7_disambiguation: <yes/no + ex vs client/3rd-party>
cross_cluster: <Erica-Stephan-Lacresha | Cristina | Phil-isolated | etc>
---
# Unified Timeline for <Contact>

## Provenance attestation

[All claims trace to verbatim source. Method: cross-corpus deterministic join.
§7 firewall respected. Adrian-disambiguation acknowledged where required.]

## Chronological timeline

[Date — Source corpus — Verbatim excerpt or paraphrase — provenance link]

## Cross-reference index

[Per corpus: what's there for this contact, where to find it]

## Active state / pending decisions

[Anything Adrian-action-needed; status per master report v2 §4]

## Truth-audit notes

[Any contradictions across corpora; any §7 disambiguation pending]
```

### Execution plan

- **This session (12h):** build Erica Johnson unified record as proof-of-concept (Phase F.3). This demonstrates the pattern works.
- **Post-MacBook (64GB):** parallelize the remaining 6 via subagent fan-out — each subagent builds one unified record from cross-corpus reads.
- **Standing:** every new corpus ingest (Notes, iMessage, Granola) extends the existing unified records via deterministic join.

## 7. 64GB MacBook Arrival — Day-1 Setup

(Per subagent C's full readiness audit. Summary here for v3 architectural integration.)

### Pre-arrival actions (DO BEFORE PICKUP)
1. Force a fresh `vault-private-backup.sh` run the day before pickup (latest state off-machine via GitHub)
2. Re-create encrypted forensic artifact AFTER today's vault-perfect milestone is captured
3. Copy `~/.config/com.adrian-vault/.env` to encrypted USB (API keys = single point of failure)
4. Copy encrypted forensic artifact + age key to USB (separate from vault)
5. Verify iCloud Photos library fully downloaded (NOT "Optimize Mac Storage")

### Day-1 critical path
1. macOS update → Homebrew → `git python@3.11 python@3.12 ffmpeg gh age cliclick` + **Samba rsync** (NOT openrsync — known bug)
2. Clone vault: `git clone https://github.com/SubConAssassin/adrian-hivemind-private.git ~/Documents/Adrian-Vault`
3. Restore `.env` + encrypted artifact from USB
4. Install Antigravity 2.0 + Claude.app + Claude Code CLI + Obsidian + Adobe CC
5. Build diarize venv (the headline 64GB unlock — `python3.11 -m venv ~/.venvs/diarize && pip install -r tools/requirements-diarize.txt`)
6. Run Adrian-voiceprint smoke test (proves Tier-0 unblocked)
7. Install Ollama + pull Gemma 3 27B-Q4 (second-tier unlock)
8. Sign into MCPs (Wix first — OSB/SS revenue path; then Gmail / Calendar / Apple Notes / iMessage / Granola)
9. Grant Accessibility + Full Disk Access to `osascript`, `/usr/bin/python3`, Terminal, Claude.app
10. **Skip LaunchAgents entirely** per launchd-dead doctrine — use Antigravity 2.0 scheduled tasks
11. **Migrate to AG CLI/SDK** instead of resurrecting ui-autoloader keystroke chain

### Doctrine changes triggered by 64GB
- **Retire `resource-partition-protocol.md` 3-mode framework** (STRATEGY / EXECUTION / PARALLEL-LIGHT). At 64GB the partition is mostly obsolete except cloud-sync rule + work-partitioning between Claude and AG.
- Replace with single "concurrent" mode + unchanged cloud-sync rule + AG-vs-Claude work-partitioning.
- Update `memory/resource-partition-protocol.md` accordingly.

## 8. Self-Capability Exploration (Claude side)

Per Adrian's directive *"explore your own capabilities in the same context."*

### What's underleveraged on the Claude side (per subagent D)

**Hardest gaps to feel — capabilities sitting unused:**
- Apple Notes MCP (raw/notes/ empty despite a 2,558-note dump existing)
- iMessage MCP (never extracted, but a parallel-WhatsApp corpus likely exists)
- Granola MCP (potential pre-existing Mastermind transcripts)
- Adobe MCP + adobe-* skills (OSB visual production at scale — never used)
- Blender MCP (3D crystal renders — never attempted)
- PDF Tools MCP (legal doc workflows — manual)
- Postiz (28-channel social scheduling — never wired)
- anthropic-skills:pptx (investor decks — never produced)
- graphify on the cross-corpus knowledge graph (only used on code project)
- enterprise-search formal synthesis skills (we're doing this manually with subagents)
- mosaic-video-editor (installed 2026-05-05; still inert)
- viz-excalidraw-diagram (zero diagrams produced)

### Subagent patterns I should use more (demonstrated today: 8x parallel breadth-scan)

- Per-persona voice subagents (18 personae × 1 subagent for content QC)
- Per-corpus grounding subagents (WhatsApp/Mastermind/ChatGPT/Notes/iMessage × shared §7 contract)
- Adversarial-review pairs (one drafts, one steel-mans, resolve diff before commit)
- Per-venture forecast subagents (6 ventures × 1 weekly status, ops-ledger-keeper aggregates)

### Honest gaps in my stack
- Long-running pipeline orchestration (Phase 2 SQLite + AG 2.0 scheduled tasks is the fix)
- Cross-machine sync beyond GitHub (multi-machine real-time absent)
- Headless control of Antigravity (AG 2.0 CLI/SDK is the fix — coming soon)
- Persistent vector DB / true embeddings store (claude-mem is the proxy)
- Real-time audio diarization production (pipeline scoped, not wired; 64GB unlocks)
- Calendar-aware planning (Calendar MCP reads, no agent bridges Calendar + open-initiatives)
- Live financial-account reads (Wise/Revolut/Chase not connected — ops-ledger manual-pull)
- Phase 2 SQLite verifier-quarantine control plane (biggest reliability gap — building it is the durable fix)

## 9. Phase 6+ Roadmap

### Immediate (this 12h session)
- **F.1 ✓** Write this Hive Architecture v3 document
- **F.2** Build Apple Notes ingest tool + canonicalize 2,558 notes
- **F.3** Erica Johnson unified person record (proof-of-concept)
- **F.4** AGENTS.md §11 + AG operating contract v2 amendments
- **F.5** 64GB MacBook readiness pack + Master Plan §2 amendments for Notes corpus
- **F.6** FB grounding completion monitor

### Next 7 days (post-MacBook arrival)
- **G.1** Day-1 MacBook setup per §7 critical path
- **G.2** Tier-0 acoustic diarization first smoke test (the 64GB headline unlock)
- **G.3** Antigravity 2.0 CLI/SDK research + install
- **G.4** Phase 2 SQLite control plane prototype (`tools/ag_cli_driver.py` v0.1)
- **G.5** Remaining 6 unified person records (Stefi/Tristan, Stephan, Lacresha/Emme, Gino [§7 first], Yoga [§7 first], Marcus)
- **G.6** iMessage MCP first extract (parallel WhatsApp corpus)
- **G.7** Granola MCP scan for pre-existing Mastermind transcripts

### Next 30 days
- **H.1** Migrate Mastermind synthesis workflow off ui-autoloader → AG 2.0 native scheduled tasks
- **H.2** OSB launch kit via Adobe MCP cluster (30 assets)
- **H.3** SS v2.4 reframe cascade via Postiz cluster
- **H.4** Mastermind product build continues (AG-primary per Adrian parallel-track)
- **H.5** Erica civil-filing or final-chase decision actioned (per master report v2 §4)
- **H.6** AGA 2% equity sign-or-kill actioned
- **H.7** Cross-corpus knowledge graph via graphify (the people-x-decisions-x-timeline build)

### Strategic horizon (next quarter)
- The audit substrate is done; the venture-execution phase begins
- Mastermind Web Application launches (AG-built, Claude-verified)
- OSB launch (Wix + ad variants + lifecycle emails — all drafted, awaiting publication decisions)
- AGA Phase 0 → Phase 1 transition
- Tri Hita WtE supplier outreach landed
- SS v2.4 live + Mastermind product paying tier
- Bodhisvara Tonny/Thomas outreach
- Cross-venture HORMOZI applications

## 10. Doctrine consequences (queued for Phase F.4)

### AGENTS.md amendments
- **§6 amendment:** Add Apple Notes as a recognized vault corpus (`raw/notes/` becomes a first-class raw layer).
- **§11.5 amendment:** Re-frame "30M+ tokens/day" target as "burn rate per dollar" — at 4× speed + 4-8× cheaper, same hourly budget covers 16-32× more effective work.
- **New §12 candidate:** Hive Architecture v3 reference + Antigravity 2.0 migration spec.

### canonical/concepts/antigravity-operating-contract.md v2
- Add explicit `thinking_level=high` for forensic/synthesis/legal/IP work
- Add `thinking_level=medium` for grind/normalization/scaffolding
- Remove temperature/top_p/top_k tuning recommendations (Gemini 3.x docs say default)
- Add Antigravity 2.0 migration path (CLI/SDK + scheduled tasks)
- Reference this doc for routing matrix

### canonical/concepts/hive-mind-resource-map.md v3
- Update for 3.5 Flash envelope (post-3.1 Pro)
- Update for 4-layer architecture (current 3-layer outdated)
- Add Cluster 1-6 capability map

### memory/resource-partition-protocol.md retirement
- Replace 3-mode framework with concurrent + cloud-sync rule (post-64GB)

### Master plan §2 amendment (Phase F.5)
- Add Apple Notes corpus row: `raw/notes/` 2,558 files / 40MB / 2012-2026 / RAW state pending Phase F.2 ingest

## 11. Resource economics summary (v3 burn budget)

**Claude (Layer 1):**
- Max 20X plan, weekly window
- ~12h of focused execution / day estimated viable
- Subagent fan-out at 8x demonstrated; could push 16x at 64GB
- **No rationing per HARD doctrine** — burn it, especially for forensic/synthesis work

**Antigravity 2.0 + Gemini 3.5 Flash High (Layer 2):**
- 30M+ tokens/day historical target → effectively higher with 4× speed + 4-8× cheaper
- "Loop density" framing: more careful iterations per dollar, not just more iterations
- Multi-hour autonomous runs structurally supported (scheduled tasks native)
- $100/mo AI Ultra + $100 bonus credits (Adrian-decision; window 2026-05-25)

**Subscription advisors (Layer 3):**
- ChatGPT Pro + SuperGrok flat subscription rates
- One-shot protocol HARD — single comprehensive prompt
- Bridge via `working/external-research-in/`

**Local substrate (Layer 4):**
- 18GB → 64GB upgrade transforms what's locally feasible
- Free tier (no API spend) for Tier-0 acoustic, Whisper large-v3, local LLM, vault embedding

**Paid API spend (HARD presidential per `feedback-external-spend-presidential.md`):**
- ChatGPT/Grok/Gemini metered API calls = Adrian-only
- Daily cap default $5; per-call cap $1; verify via `tools/spend_estimator.py`

## 12. The "v3 is live" assertion criteria

This document is **doctrine-active** when:
- [x] Written + filed at canonical path
- [ ] AGENTS.md amended (queued Phase F.4)
- [ ] AG operating contract v2 (queued Phase F.4)
- [ ] Master Plan §2 amended for Notes corpus (queued Phase F.5)
- [ ] Apple Notes ingest demonstrated (queued Phase F.2)
- [ ] First unified person record built (queued Phase F.3)
- [ ] Adrian read + ratification (next session)

Until ratified, this is a **strong proposal** — Claude operating as if v3 holds, but doctrine-change protocol §8 of AGENTS.md applies before fully canonical.

---

— Claude, CEO, 2026-05-20 (Phase F.1, post-vault-perfect, pre-MacBook)
