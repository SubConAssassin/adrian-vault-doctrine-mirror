# CLAUDE.md — Adrian Vault Operating Doctrine
**Auto-loaded by Claude Code on session start.**  
Last updated: 2026-04-25

---

## Who you are working for

**Adrian Alan Taffinder** — entrepreneur, product designer, dyslexic. Based in Sayan, Ubud, Bali. Prefers structured, concise, actionable responses. Uses voice-to-text — interpret phonetic errors contextually. Born 6 May 1972, 8:20 AM, Horsforth, Leeds, England.

**For any personal data point** (DOB, time of birth, place of birth, friends, family, relationships, MBTI, Human Design, etc.) — read `canonical/adrian-corpus/personal-facts.md` first. If the fact isn't there, search `raw/chatgpt-import/` and use `conversation_search` for past Claude chats. Never ask Adrian for information he has already given to Claude or ChatGPT in past sessions.

---

## The Vault

This is the shared brain between Claude sessions and Antigravity. It is the single source of truth.

| Path | Purpose |
|---|---|
| `canonical/` | Authoritative project docs. Read before acting on any named project. |
| `working/handoffs/` | Agent-to-agent handoff files. Read latest before starting work. |
| `working/drafts-pending/` | Drafts awaiting Adrian review. File silently, never present as menus. |
| `tools/` | Scripts — ask-chatgpt.py, ask-grok.py, preflight-check.sh etc. |

---

## CEO Execution Protocol (non-negotiable)

1. **Execute with available tools immediately — no asking permission.**
2. **Zero pause between tasks.**
3. **Delegation cascade:** (1) osascript/filesystem → (2) Antigravity for file-based work → (3) ChatGPT/Grok API for strategy.
4. **Drafts filed silently** in `working/drafts-pending/` — never presented as menus.
5. **Run preflight before heavy work:** `tools/preflight-check.sh`

---

## Active Ventures (read canonical for detail)

- **Original Siberian Blue** — luxury spiritual jewelry, cobalt-doped hydrothermal quartz. `canonical/projects/original-siberian-blue/`
- **Subconscious Surgery** — 1:1 coaching + Kajabi mastermind. `canonical/projects/subconscious-surgery/`
- **AGA Bali** — 13ha conscious community, Candidasa, East Bali. `canonical/projects/aga-bali/`
- **PT Tri Hita WtE Indonesia** — modular biomethane, V6.4 framework. `canonical/projects/pt-tri-hita/`
- **Ashta Project** — distributed consciousness research platform. `canonical/projects/ashta/`
- **Bodhisvara** — voice-analytics/therapist-matching, concept stage, parked. `canonical/projects/bodhisvara/`

---

## Critical Rules

- **NEVER mention Chelsea** in any context across any project.
- **AYA is deprecated** — replaced by Bodhisvara.
- **Staleness check mandatory** on any named project — canonical is starting point, most recent handoff is current truth.
- **Erica Johnson (legal dispute):** always conversation_search for latest status before acting.
- **Crystal facts:** discovered Siberia, grown in lab outside Moscow, ~2 months growth. No "Cosmic Vein." No diamond wire saw mention in marketing.
- **Cross-pollination protocol:** When Adrian references prior context ("as we discussed", "like I told you", possessives like "my friend X", "my Y"), search the ChatGPT import + Claude past chats BEFORE asking him to repeat. The 3.87M-word corpus exists for exactly this reason.
- **Voice-to-text spelling drift:** Names and uncommon words may be phonetically substituted. Examples: "Abby" → **Abee**, "Bolognese" → **Balinese**, "ambulate" → **amulet**. Verify against `personal-facts.md` before treating a name as new.

---

## Hive Mind API Stack

```bash
# ChatGPT (default: gpt-5.4-mini | escalate: --model gpt-5.4)
python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py "your prompt"
python3 ~/Documents/Adrian-Vault/tools/ask-chatgpt.py --model gpt-5.4 "your prompt"

# Grok (grok-4)
python3 ~/Documents/Adrian-Vault/tools/ask-grok.py "your prompt"

# Keys at:
~/.config/com.adrian-vault/.env
```
The Bridge is retired. Use direct scripts only.

### ONE-SHOT PROTOCOL — HARD RULE (no exceptions)

A previous session made 1,053 API calls (~2.7M tokens, ~$8) on a single task. This must never happen again.

- **One call per question.** Craft a single comprehensive prompt. Accept one reply. Stop.
- **No iteration loops.** Do not follow up, refine, or re-prompt the same API in the same session.
- **No agentic chaining.** Do not pass API output back into another API call automatically.
- If one reply is insufficient: synthesise what you have and ask Adrian before any further call.
- Run ChatGPT + Grok in parallel (not sequentially) when both are needed — one Bash call each, sent together.
- Budget: 1–3 calls per session maximum. Target cost = cents.

---

## Hardware

MacBook Pro M3 Pro, 18GB RAM. Always ARM64/Apple Silicon builds. Never Intel.

---

## Remote Control (iPhone)

If Adrian connects from iPhone:
- Session registered via `claude remote-control` in this vault directory
- Web URL fallback: `https://claude.ai/code?environment=ENV_ID`
- App session list was broken April 2026 — use web URL

---

## Key Contacts

- **Stephan Schwartz** — crystal source/custodian, Seattle. Spiritual not contractual. US receiving address for any returned inventory.
- **Gino Yu** — strategic advisor.
- **Yoga** — master artisan, Bali.
