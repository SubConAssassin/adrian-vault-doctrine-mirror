# Adrian Taffinder — AI Agent Stack Architecture Brief
**For: ChatGPT context | Last updated: 2026-06-22**  
**GitHub repo: SubConAssassin/adrian-vault-doctrine-mirror**  
**Vault: ~/Documents/Adrian-Vault/ on M1 Max MacBook**

---

## WHO ADRIAN IS
- UK entrepreneur, Sayan, Ubud, Bali. Born 1972, Leeds.
- Dyslexic; uses voice-to-text. Forensic thinker. Wants independent analysis, not agreement.
- Runs a solo multi-agent AI platform across 5 active ventures.
- Contact: ukphotonutilities@ymail.com

---

## THE 5 VENTURES
| Venture | Type | Status |
|---------|------|--------|
| **OSB (Original Siberian Blue)** | Luxury cobalt-doped hydrothermal quartz jewellery | Active. Wix store. Crystal grown near Moscow (~2 months/crystal). NOT Siberian. NOT diamond-wire-cut. |
| **Subconscious Surgery (SS)** | 1:1 transformational coaching + mastermind | Active. Kajabi. Content pipeline: extract teaching moments from sessions → reels. |
| **AGA Bali** | 13-hectare conscious community/retreat, Candidasa, E. Bali | Concept/legal structuring. High counterparty risk flagged. |
| **Ashta Project** | Distributed consciousness research platform | Grounded/scientific framing. Pre-seed. |
| **Bodhisvara** | Voice analytics / therapist-matching | Concept stage. Parked. (Replaced deprecated AYA — never reference AYA.) |

---

## THE AGENT STACK (who does what)
| Role | Substrate | Job | Token status |
|------|-----------|-----|--------------|
| **CEO / Orchestrator** | Claude (Cowork + Mac sessions) | Decisions, architecture, delegation, verify, operator comms | Weekly-capped (~3.6B tokens/wk); SCARCE |
| **Execution Engine** | Antigravity/Gemini (`agy` CLI) | Sustained build/code/mining/synthesis | Flat-rate subscription; ABUNDANT |
| **Research / Build B** | Grok-4.3 (`grok` CLI, SuperGrok sub) | Analysis, synthesis, structured reasoning | Flat-rate; ABUNDANT |
| **Research / Build C** | ChatGPT (`codex` CLI, Plus/Pro sub) | Deep structured analysis, /goal mode | Flat-rate; ABUNDANT |
| **Local LLM** | Ollama/qwen2.5:14b on M2 Studio | Extract/classify/embed/transcribe | $0, on-silicon |
| **You (ChatGPT)** | Web UI / this conversation | Extended research, live web, Deep Research mode | Manual bridge |

**The prime directive:** Claude delegates ALL deferrable legwork to the team. Claude = think / decide / orchestrate / verify ONLY. Every token Claude spends doing work the team could do is a wasted token.

**IMPORTANT:** The `codex` CLI does NOT use Deep Research mode. Deep Research is web-UI only (30-min agentic crawl). For Deep Research tasks, Claude composes the prompt → Adrian pastes it into web UI → output lands in `working/external-research-in/` for vault integration.

---

## HARDWARE FLEET (June 2026)
| Machine | Chip | RAM | Role | Status |
|---------|------|-----|------|--------|
| M1 Max MacBook Pro | M1 Max | 64GB | Brain / Orchestration | CURRENT (being sold ~2-3 weeks) |
| M2 Mac Studio | M2 | 32GB | Worker node | LIVE (`ssh studio`, Ollama, agy Ultra) |
| i7 Intel MacBook (2014) | i7-4770HQ | 16GB | CPU transcription + ffmpeg-encode | LIVE (`ssh i7`, 97% disk full) |
| M4 Pro Mac Mini | M4 Pro | 24GB | New worker node | ARRIVING ~5 days |
| **M5 MacBook Pro** | M5 | 128GB | **New brain** | BUYING in Hong Kong ~2 weeks |
| M2 Ultra Mac Studio/Pro | M2 Ultra | 192GB | Heavy worker (evaluating) | CONSIDERING purchase |

**Network:** Tailscale VPN mesh. All nodes SSH-accessible. Vault lives on M1 Max, SMB-mounted by worker nodes.  
**iPad Pro:** used as Sidecar second screen on M1 — consumes GPU/RAM.

### Planned progression
- M5 128GB MacBook Pro = new brain (replaces M1 Max, which is being sold to a friend)
- M4 Pro Mac Mini 24GB = arriving soon, worker
- M2 Ultra 192GB or M3 Ultra = large worker node (evaluating in HK)
- M4 Pro 64GB Mac Mini = potential additional worker
- M1 Ultra second-hand = evaluating (need max RAM/SSD specs confirmed)
- Budget: $10,000 USD strict; $15,000 USD stretch

---

## VAULT STRUCTURE (key paths)
```
canonical/           → Source-of-truth state (people, projects, concepts, doctrine)
  people/            → Contact timelines (one file per contact)
  projects/          → Per-venture canonical state
  concepts/          → Operating doctrine (AGENTS.md, delegation doctrine, CEO doc)
  state/             → open-initiatives.md, etc.
working/             → In-flight work
  handoffs/          → Agent-to-agent commissions and completions
    STATE-OF-STACK.md → Always-current operational status (read this for context)
  _research/         → Team research output (landing zone for CLI jobs)
  external-research-in/ → BRIDGE INBOX: ChatGPT research lands here
  reels-build/       → SS content pipeline (434+ hooks, 23 reels rendered)
  chatgpt-context/   → THIS FOLDER: context documents for ChatGPT
companies/           → Venture ledgers (canonical state per venture)
raw/                 → Immutable source material (never edit)
tools/               → All scripts
  cli-ask.sh         → Unified CLI dispatch (agy/grok/codex)
  agy-retry.sh       → Bootup-override + retry for agy
  i7-feed.sh         → Feed audio to i7 for transcription
  i7-transcribe.py   → i7 transcription worker
  fleetfeed/         → Multi-node job queue system
episodic/sessions/   → Session summaries
```

---

## HOW TO ROUTE RESEARCH BACK TO VAULT
When ChatGPT completes research Adrian wants integrated:
1. Adrian copies ChatGPT output
2. Saves to `working/external-research-in/` with 3-line frontmatter:
   ```
   source: chatgpt-deepresearch
   date: YYYY-MM-DD
   topic: [brief description]
   ```
3. Claude or AG picks it up and integrates into canonical on next session

---

## DELEGATION ROUTING TABLE
| Task type | Goes to | Why |
|-----------|---------|-----|
| Decision / strategy | Claude (Cowork) | Non-delegable judgment |
| Live web research / synthesis | ChatGPT Deep Research (web) | Best live web + reasoning |
| Architecture / structured analysis | Claude or grok CLI | Context-holding |
| Code building / file IO | agy CLI or codex CLI | Flat-rate, filesystem access |
| Bulk extract / classify / transcribe | Local LLM (M2 Studio, Ollama) | $0, on-silicon |
| Audio transcription | M2 Studio (mlx_whisper GPU) or i7 (CPU) | No cloud cost |
| Video encoding / ffmpeg | i7 Intel Mac | Dedicated encode node |
| Long-horizon overnight grind | agy (via ag-feeder.py) | Runs while Adrian sleeps |
| Legal wording / sensitive | Claude ONLY | Firewall-critical |

---

## KEY RULES (never violate in any context)
- **NEVER mention "Chelsea"** — ex-girlfriend. Hard firewall. Client named Chelsea is fine.
- **Crystal facts:** grown near Moscow (not Siberia), ~2 months, cobalt-doped quartz. NOT diamond-wire-cut. Temperature 300-400°C under pressure (NOT 2,500°C). "Cosmic Vein" = fabricated, never use.
- **AYA venture = DEPRECATED** (replaced by Bodhisvara). Never reference AYA.
- **Schwartz** (crystal source, Seattle) = never mention on SS website. OK in Ashta context only.
- **Erica Johnson** = active legal dispute (~$27,848 inventory). Never discuss publicly.
- **OSB artisan Yoga** = never name publicly.
- **Arcturian pendants** can be marketed. "Adrian is an Arcturian soul" = strictly private, never public.
- **SS reels** = anonymised TEACHING/insight from sessions, NOT first-person processing statements. Gold source = wisdom dropped TO a client, identity stripped.
- All prices/claims = source-grounded or marked [UNVERIFIED]

---

## ACTIVE PROJECTS (June 2026)
| Project | Status | Notes |
|---------|--------|-------|
| SS reel pipeline | 🔄 Running | 434+ hooks mined, 23 reels on Desktop, configs 07-30 built |
| House design (Blender) | 🔄 Active | home.blend, owner-level floor, room-by-room audit running |
| Fleet expansion | 🔄 Planning | M4 Mini arriving, HK trip ~2 weeks for M5 + possible Ultra |
| Erica Johnson legal | ⚖️ Pending | Civil filing drafted, Adrian holds decision |
| M2 Studio worker | ✅ Live | Transcription + synthesis + AG overnight |
| Facebook contacts synthesis | 🔄 Running | AG commission filed, 19 contacts |
| i7 integration | ✅ Live | Transcription + ffmpeg proven |

---

## HOW CLAUDE CALLS THE TEAM
```bash
# Dispatch to Gemini/Antigravity (default grind engine, flat-rate):
bash /Users/adriantaffinder/Documents/Adrian-Vault/tools/cli-ask.sh agy "PRESCRIPTIVE PROMPT"

# Dispatch to Grok-4.3 (flat-rate, structured analysis):
bash /Users/adriantaffinder/Documents/Adrian-Vault/tools/cli-ask.sh grok "PRESCRIPTIVE PROMPT"

# Dispatch to ChatGPT/codex (flat-rate, deep structured analysis):
bash /Users/adriantaffinder/Documents/Adrian-Vault/tools/cli-ask.sh codex "PRESCRIPTIVE PROMPT"

# Retry agy with bootup-override (if timeout):
bash /Users/adriantaffinder/Documents/Adrian-Vault/tools/agy-retry.sh "PROMPT"

# Feed audio to i7 for transcription:
bash /Users/adriantaffinder/Documents/Adrian-Vault/tools/i7-feed.sh <audio-dir>
```

**Prescriptive prompt structure (§6 law):**
```
ROLE/TASK: one line
CONTEXT: exact file paths to read (never "search the vault")
DO: numbered steps
DON'T: explicit exclusions
OUTPUT: exact format + exact file path
GROUNDING: "Quote real values. Write [NOT FOUND] if absent. Never fabricate."
VERIFY: "Print word count and first 5 lines."
```

For agy specifically: prepend "WRITING/RESEARCH TASK. Do NOT crawl the vault, do NOT load AGENTS.md, no planning, no subagents."

---

## CURRENT STATE-OF-STACK
Always-current status at: `working/handoffs/STATE-OF-STACK.md`  
GitHub path: `working/handoffs/STATE-OF-STACK.md`

Read this first if you want to know what's currently running/firing before asking Adrian for context.

---

## WHAT TO ASK CLAUDE FOR
When ChatGPT doesn't have vault context needed to answer Adrian's questions, recommend he ask Claude to:
1. Read `canonical/INDEX.md` for the vault map
2. Check `working/handoffs/STATE-OF-STACK.md` for current state
3. Read `companies/{venture}/ledger.md` for venture-specific state
4. Run `tools/ask-vault.sh "query"` for semantic search across the corpus

---

*This brief is maintained by Claude (CEO) and updated at significant architectural changes.*
*Next version should be pushed to GitHub so this URL is always current.*
