---
title: 64GB Apple Silicon MacBook — Readiness Pack (incoming)
type: hardware-migration-doctrine
tier: 1
date: 2026-05-20
authored_by: claude (cowork, Phase F.5 — Hive Architecture v3 §7)
firewall_class: working-internal
status: pre-arrival (Adrian's new Mac inbound)
parent_doctrine: canonical/concepts/hive-architecture-v3.md §7
informs:
  - memory/resource-partition-protocol.md (retire 3-mode framework on arrival)
  - canonical/concepts/hive-mind-resource-map.md (4-layer architecture)
  - Master Plan §2 corpus inventory (Apple Notes corpus added in parallel — Phase F.5b)
---

# 64GB Apple Silicon MacBook — Readiness Pack

## 0. Context

Adrian's new MacBook (64GB RAM, Apple Silicon — likely M4 Max given current generation; treated as "64GB Apple Silicon" for spec purposes) is incoming. Current Mac is an M3 Pro with 18GB RAM, currently in **YELLOW-bordering-RED** memory pressure (240MB free, 1.22GB swap active, 6.7GB compressed).

Per Adrian's 2026-05-20 ~16:30 WITA directive: *"prepare for my new MacBook coming with 64GB RAM, M1 Max [sic — likely M4 Max], and then we can really chew and get on with some of this graft and work that we have to do building out all these websites and apps and companies."*

This pack is the concrete migration plan. Output of Phase F.5 in the post-vault-perfect hive audit.

## 1. What 64GB unlocks (per discovery subagent C audit 2026-05-20 ~16:30)

### Tier-1 unlocks (genuinely RAM-bottlenecked at 18GB)

| Capability | At 18GB | At 64GB | Hive value |
|---|---|---|---|
| **ECAPA acoustic diarization** (Tier-0 speaker truth) | env-blocked + RAM-tight | Comfortable, parallel 4-8 streams | **HIGHEST** — unlocks SS blueprint-method build (currently blocked because the 76%-contaminated voice lexicon needs grounded re-derivation, which needs verified speaker truth on Mastermind audio) |
| **Whisper large-v3 local transcription** | Marginal (model ~3GB + activations ~10GB) | Comfortable | Med-High — better SS-client transcripts than current faster-whisper-small |
| **Subagent fan-out 16x parallel** | Risky/forced ~4x | Safe | High — forensic audit acceleration (current 8x demonstrated; 16x feasible) |
| **Concurrent app stack** (AG + Claude + Obsidian + Wix + Adobe + Blender) | Forced swap → reboot risk | Smooth | Med — UX + 24/7 operating model |
| **Photos.sqlite Phase 4 OCR** (73,197 assets) | Cloud function required | Local feasible | Med — unblocks deferred work |

### Tier-2 unlocks (currently env-blocked OR cloud-redirected)

| Capability | At 64GB |
|---|---|
| Local LLM Gemma 27B-Q4 (~16GB) | Comfortable; useful for offline/cheap inference + Adrian-voice diagnostic engine prototype |
| Local LLM Llama 3.3 70B-Q4 (~40GB) | Tight but feasible |
| Whole-vault embedding/RAG indexing | Local (no API spend) |
| Video processing local (Veo emulator + ffmpeg + Blender) | Parallel streams |

### Honest caveat (from subagent C audit)

**The biggest unlock is Tier-0 acoustic + subagent fan-out at scale, NOT local LLM hosting.** Gemma 27B-Q4 is genuinely useful but doesn't compete with Claude / Gemini 3.5 Flash High / GPT-5 / Grok-4 for serious reasoning. **64GB complements the API/subscription layer; doesn't replace it.**

## 2. What does NOT change at 64GB (honest list)

- **AG rate limits** — Antigravity's 1M tokens/hour soft envelope is API-side, not RAM-side. The 30M/day target is independent of local RAM.
- **API quotas** — ChatGPT/Grok/Gemini API spend caps (`SPEND_CAP_USD`, `DAILY_CAP_USD`) unchanged.
- **GUI keystroke chain bugs** — `osascript` Accessibility-permission drops + bundle-id frontmost gate (fixed 2026-05-17) are NOT RAM issues. **Antigravity 2.0 CLI/SDK migration** (Phase 2 control plane) is the durable fix, not more RAM.
- **launchd EX_CONFIG failures** — macOS managed-LWCR rejection from 2026-05-08 is OS-level, not RAM. **Skip LaunchAgents entirely** on new Mac.
- **Network bandwidth** — Bali residential connection caps GitHub pushes, MCP latency, AG cycle bursts. Unchanged.
- **AG sandbox restrictions** — AG still can't exec Python/CLIs directly. Claude-direct execution still required for `os`/`subprocess` work.
- **The 84M-word corpus is still 84M words** — speaker attribution, §7 firewall discipline, anti-confab contract still apply at the same forensic cost.
- **Obsidian indexing 24GB vault** — even with 64GB, indexing is I/O-bound during cold load. The 2026-05-20 `userIgnoreFilters` patch (`.claude/`, `.git/`, `raw/`, `working/_logs/`, `node_modules/`) cut 13k redundant files; that win persists.

## 3. Pre-arrival actions (DO BEFORE PICKUP)

In priority order:

### 3.1 Backup verification (HIGHEST priority — single point of failure prevention)

1. **Force a fresh `vault-private-backup.sh` run THE DAY BEFORE PICKUP** to ensure latest vault state is off-machine in `SubConAssassin/adrian-hivemind-private`. Verify the push landed:
   ```bash
   ~/Library/Application\ Support/Claude/vault-private-backup.sh
   git -C ~/Documents/adrian-vault-private-mirror log -1
   git -C ~/Documents/adrian-vault-private-mirror rev-parse HEAD
   # Cross-check against GitHub remote in browser
   ```
2. **Re-create encrypted forensic artifact** AFTER today's 2026-05-20 vault-perfect milestone is captured. The current artifact `~/Documents/Adrian-Vault-encrypted-backups/companies-VERIFIED-FORENSIC-20260519T160155Z.tar.age` predates today's work (Phase A sweep + cross-corpus person records + Apple Notes ingest). 
   - **Exact Forensic `tar.age` Backup Command Protocol**:
     Use the precise `tar` and `age` sequence to archive and encrypt:
     ```bash
     # Derive recipient public key from the identity key and encrypt the vault
     RECIPIENT=$(age-keygen -y ~/Documents/Adrian-Vault-encrypted-backups/companies-backup-age.key)
     tar -cvf - -C ~/Documents/Adrian-Vault . | age -e -r $RECIPIENT > ~/Documents/Adrian-Vault-encrypted-backups/companies-VERIFIED-FORENSIC-$(date -u +"%Y%m%dT%H%M%SZ").tar.age
     ```
   - **Verification**: Verify round-trip decrypt to a temporary scratch directory before pickup:
     ```bash
     age -d -i ~/Documents/Adrian-Vault-encrypted-backups/companies-backup-age.key ~/Documents/Adrian-Vault-encrypted-backups/companies-VERIFIED-FORENSIC-*.tar.age | tar -t | head -5
     ```
3. **Copy `~/.config/com.adrian-vault/.env` to encrypted USB** (API keys = single point of failure for ChatGPT/Grok/Gemini/Wix/Pushover/Bright Data access; NOT in vault, NOT in cloud).
   - **Precise `.env` File Validation Checks**:
     Ensure all required environment keys are populated and contain no empty/placeholder values:
     ```bash
     # Check for empty variables or placeholders in .env
     grep -E "^[A-Z_]+=\s*$" ~/.config/com.adrian-vault/.env || echo "No empty variables found."
     grep -E "YOUR_|PLACEHOLDER" ~/.config/com.adrian-vault/.env || echo "No placeholder values found in secrets."
     ```
4. **Copy encrypted forensic artifact + `companies-backup-age.key` to USB** (separate from vault; age key should never live in the same place as the encrypted artifact).
   - **Age Key Structure Verification**:
     Ensure the `companies-backup-age.key` is formatted as a valid age private key file:
     ```bash
     # Verify valid AGE key format
     grep -q "^AGE-SECRET-KEY-1" ~/Documents/Adrian-Vault-encrypted-backups/companies-backup-age.key && echo "Valid age secret key structure detected."
     ```
5. **Verify iCloud Photos library is fully downloaded** — confirm "Optimize Mac Storage" is OFF in Photos preferences. Otherwise iCloud-only items are lost at reformat.

### 3.2 GitHub credential verification

Confirm Adrian's GitHub credentials work from a second machine (phone browser or a friend's computer is fine):
- `SubConAssassin/adrian-hivemind-private` (private vault mirror)
- `SubConAssassin/adrian-vault-doctrine-mirror` (public concepts/ mirror)
- Personal repos (osb-website, ss-website, etc)

### 3.3 What to leave behind / abandon (do NOT migrate)

- **launchd LaunchAgents** — all `com.adrianvault.*` plists. They've been failing exit-78 since 2026-05-08. Use Antigravity 2.0 scheduled tasks on new Mac.
- **Time Machine state** — per longstanding memory `vault-backup-architecture.md`: 14-month TM gap (last good Jan 2024). **Migration MUST be GitHub-clone, NOT TM-restore.**
- **Old supervisor stack** (`tools/ui-autoloader.sh`, `tools/burn-watchdog.sh`, `tools/hive-supervisor.sh`) — preserve in git for 30 days as fallback, but plan to deprecate post Phase 2 control plane migration.

## 4. Day-1 critical path (in this exact order)

```bash
# 1. macOS update + Homebrew
softwareupdate -ai
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git python@3.11 python@3.12 ffmpeg gh age cliclick

# 2. CRITICAL — install Samba rsync (Apple's openrsync has mmap-deadlock bug — known issue from 2026-05-19 backup repair)
brew install rsync  # this installs Samba rsync 3.x; verify with: rsync --version | head -1

# 3. Clone vault (the PRIVATE mirror has the FULL state)
gh auth login
git clone https://github.com/SubConAssassin/adrian-hivemind-private.git ~/Documents/Adrian-Vault
# NOTE: adrian-vault-doctrine-mirror is PUBLIC concepts only — not enough

# 4. Restore secrets from USB
mkdir -p ~/.config/com.adrian-vault
cp /Volumes/<USB>/com.adrian-vault/.env ~/.config/com.adrian-vault/.env
chmod 600 ~/.config/com.adrian-vault/.env

# 4.1 Validate secrets and keys restored from USB
grep -E "^[A-Z_]+=\s*$" ~/.config/com.adrian-vault/.env || echo "No empty variables found."
grep -E "YOUR_|PLACEHOLDER" ~/.config/com.adrian-vault/.env || echo "No placeholder values in restored secrets."
grep -q "^AGE-SECRET-KEY-1" /Volumes/<USB>/companies-backup-age.key && echo "Valid age secret key structure detected."

# 5. Restore encrypted forensic artifact + key
mkdir -p ~/Documents/Adrian-Vault-encrypted-backups
cp /Volumes/<USB>/companies-VERIFIED-FORENSIC-*.tar.age ~/Documents/Adrian-Vault-encrypted-backups/
cp /Volumes/<USB>/companies-backup-age.key ~/Documents/Adrian-Vault-encrypted-backups/

# 6. Test-decrypt to verify integrity
cd /tmp
age -d -i ~/Documents/Adrian-Vault-encrypted-backups/companies-backup-age.key \
       ~/Documents/Adrian-Vault-encrypted-backups/companies-VERIFIED-FORENSIC-*.tar.age | tar -t | head -5
# Should list files — confirms decrypt works

# 7. Install Antigravity 2.0 + Claude.app + Obsidian + Adobe CC
# (manual GUI installs from each vendor)

# 8. Install Claude Code CLI
# (per Anthropic docs — install + auth)

# 9. Build the diarize venv (THE HEADLINE 64GB UNLOCK)
mkdir -p ~/.venvs
python3.11 -m venv ~/.venvs/diarize
source ~/.venvs/diarize/bin/activate
pip install -r ~/Documents/Adrian-Vault/tools/requirements-diarize.txt
deactivate

# 10. Smoke-test diarize (proves Tier-0 unblocked)
cd ~/Documents/Adrian-Vault
source ~/.venvs/diarize/bin/activate
python3 tools/voiceprint-diarize.py --smoke-test
# Expected: ECAPA model loads, processes a sample audio, produces speaker embeddings

# 11. Install Ollama + pull Gemma 3 27B-Q4 (second-tier unlock)
brew install ollama
brew services start ollama
ollama pull gemma2:27b-instruct-q4_K_M  # ~16GB on disk; uses ~16-20GB RAM at inference

# 12. Sign into MCPs (Wix first — OSB/SS revenue path; then per-MCP)
# Through Claude Code interface

# 13. Grant Accessibility + Full Disk Access (NB: only IF using legacy supervisor stack;
#     skip if migrating directly to Antigravity 2.0 CLI/SDK)
# System Settings → Privacy & Security → Accessibility / Full Disk Access:
#   - osascript (legacy)
#   - /usr/bin/python3 (FDA needed for some vault paths)
#   - Terminal.app
#   - Claude.app
#   - Antigravity.app

# 14. SKIP LaunchAgents — use Antigravity 2.0 scheduled tasks instead

# 15. Smoke-test supervisor stack ONLY IF Phase 2 migration not yet authorised
#     (Adrian-decision: migrate to AG CLI/SDK day-1, or keep ui-autoloader for 30-day overlap?)
```

## 5. Doctrine changes triggered by 64GB

### 5.1 Retire 3-mode resource-partition framework

`memory/resource-partition-protocol.md` currently mandates 3 modes (STRATEGY / EXECUTION / PARALLEL-LIGHT) with cloud-sync rules + RAM gates. At 64GB the partition is largely obsolete.

**Replace with:** single "concurrent" mode + unchanged cloud-sync rule + AG-vs-Claude work-partitioning (per Hive Architecture v3 §4 routing matrix). Update `memory/resource-partition-protocol.md` on Day-1 of new Mac.

### 5.2 Tier-0 acoustic doctrine activates

The forensic-speaker-attribution-and-language-standard.md currently lists Tier-0 (acoustic) as authoritative but **env-blocked at 18GB**. Once the diarize venv smoke-test passes on 64GB:
- Mark Tier-0 as **ACTIVE** in canonical/concepts/forensic-speaker-attribution-and-language-standard.md
- Begin diarizing Mastermind audio backlog (per master plan §2.1.3 — currently per-turn UNVERIFIED, anchor-grounded only)
- The 76%-contaminated voice lexicon (canonical/brand/adrian-distinctive-vocabulary.md) can be re-derived from acoustically-grounded Adrian-only speech segments
- SS blueprint-method build (which was blocked on the contaminated lexicon) unblocks

### 5.3 Phase 2 control plane migration becomes day-1-feasible

Antigravity 2.0 CLI/SDK + a clean 64GB install = ideal moment to migrate from the GUI keystroke chain (supervisor stack) to native AG control surfaces. Per `canonical/concepts/hive-architecture-v3.md` §5, this is Adrian-approval-gated. The new Mac arrival is the optimal trigger.

Estimated migration: 1-2 sessions to scope + 2-3 sessions to migrate = ~5 sessions to permanent operational reliability.

## 6. Per-venture impact estimate (per subagent C)

| Venture | Direct impact | Why |
|---|---|---|
| **SS (Subconscious Surgery)** | **HIGH** | Tier-0 acoustic diarization across 262 voice memos + 778 audio files + Mastermind audio unblocks the SS blueprint-method build. Currently the #1 blocker. |
| **Mastermind product build** | **HIGH** | Local LLM (Gemma 27B) hosts private "Adrian-voice diagnostic engine" prototype without exposing client data to OpenAI/Anthropic |
| **Ashta** | Med | Distributed consciousness research = pre-seed; local R&D scales to bigger models/datasets |
| **OSB** | Low direct | Wix MCP + Adobe ops are API/cloud-bound; marginal win on local Marketing Studio previews + parallel UGC video |
| **AGA Bali** | Low | Concept-phase = people/paperwork, not compute |
| **Tri Hita WtE** | Low | Supplier outreach + V7.0 framework = document + LLM-API work |
| **XMAXED** | Low | Rental fleet + custom shop = operations and relationships |
| **Bodhisvara** | Med | Local LLM enables on-device voice-analytics prototype |

## 7. Recommended day-1 work order (the actual critical path)

1. **Verify GitHub auth → clone private mirror to `~/Documents/Adrian-Vault/`** (everything else depends on this)
2. **Restore `.env` + encrypted artifact from USB** (API access)
3. **Install Homebrew + git + python@3.11 + ffmpeg + age + cliclick + Samba rsync**
4. **Install Claude.app + Claude Code CLI + Antigravity 2.0 + Obsidian**
5. **Build diarize venv** (the headline 64GB unlock)
6. **Run Adrian-voiceprint smoke test** on `voiceprint-diarize.py` (proves Tier-0 unblocked)
7. **Install Ollama + pull Gemma 3 27B-Q4** (second-tier unlock: offline reasoning)
8. **Sign into MCPs** (Wix first — OSB/SS revenue path; then Gmail / Calendar / Apple Notes / iMessage / Granola / Bright Data / Adobe / Blender / PDF Tools / Postiz)
9. **Grant Accessibility/FDA permissions** (only if running legacy supervisor stack during overlap)
10. **Adrian-decision:** Phase 2 control plane migration day-1 OR 30-day overlap?

## 8. Migration completion criteria

- [ ] Vault cloned + verified `git log` matches GitHub state
- [ ] `.env` restored + tested (ChatGPT/Grok script runs)
- [ ] Encrypted artifact decrypts successfully
- [ ] Diarize venv smoke-test passes
- [ ] Ollama runs Gemma 27B at >10 tokens/sec
- [ ] Claude Code CLI authenticates + accesses vault
- [ ] Antigravity 2.0 installed + signed in
- [ ] Wix MCP authenticates + reads OSB+SS sites
- [ ] Gmail MCP authenticates
- [x] Apple Notes MCP lists 2,558 notes (completed: 2,551 standard notes parsed to raw/notes/by-id/ and 7 quarantined notes safely isolated; master indexes generated)
- [ ] One full forensic-audit subagent runs at 16x parallelism without swap

## 9. Backup state snapshot (2026-05-20 ~16:30 WITA — pre-migration baseline)

Per subagent C disk verification:
- **Off-machine private vault:** `~/Documents/adrian-vault-private-mirror/` last commit `6cf2e28` at **2026-05-20 14:56 WITA** — fresh, pushed to `SubConAssassin/adrian-hivemind-private`. ✅
- **Off-machine doctrine mirror:** `SubConAssassin/adrian-vault-doctrine-mirror` — auto-sync cadence runs hourly. ✅
- **Encrypted forensic artifact:** `companies-VERIFIED-FORENSIC-20260519T160155Z.tar.age` (36 MB) — needs re-creation after today's 2026-05-20 vault-perfect milestone + Phase F deliverables.
- **Time Machine:** **DO NOT TRUST** — 14-month gap.

Action item before pickup day: force one more vault-private-backup push + re-encrypt forensic artifact.

— Claude (cowork, Phase F.5, 2026-05-20)
