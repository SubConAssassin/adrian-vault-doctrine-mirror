# Glaido — the Operator Input Layer (dictation)

**Status:** Tier-2 reference doctrine (operating rule for a tool Adrian uses; not a wired stack component)
**Last updated:** 2026-05-31
**Verdict:** ADOPT for the input layer with a hard confidentiality firewall. Do NOT attempt to wire it into the agent stack — there is nothing to wire.

> Source discipline: pricing + tier features below are first-party (glaido.com/pricing, fetched via real browser — the site bot-walls plain fetchers). Product behaviour is corroborated across the site + multiple independent reviews. **The privacy/data-path section is deliberately conservative: the authoritative policy (glaido.com/privacy-policy) could not be retrieved this session (bot-walled), so no specific sub-processors are asserted.**

---

## 1. What it is

Glaido is a **macOS-only, hotkey-driven voice-to-text dictation app**. Press a hotkey → speak → polished text appears at the cursor in *any* macOS app (Gmail, Slack, Notion, VS Code, Cursor, ChatGPT, the Claude/AG terminals — anywhere you can type). It is an OS-level **input device that types for the human**. It is not a service, agent, or backend.

- **AI auto-edit:** removes filler words, fixes grammar/punctuation, applies context-aware formatting (writes "like an email" in an email field). On both tiers.
- **Agent Mode:** voice *commands* not just dictation — e.g. "make this more formal", "translate to Spanish", "summarise this" — transforms text at the cursor. Listed as a **Free-tier** feature on the live pricing page (some third-party reviews call it Pro/beta — first-party pricing wins).
- 100+ languages; real-time translation to English.
- "Local storage" of dictation history is a listed feature on both tiers.
- Requires **internet** (real-time AI processing). macOS only.

## 2. Pricing (first-party, glaido.com/pricing)

| Plan | Price | Includes |
|---|---|---|
| Free / Basic | $0, no card | **2,000 words/week**, use in any app, AI auto-edits, Agent mode, local storage |
| **Pro** | **$20/mo**, or **annual −17% (≈ $16.60/mo ≈ ~$199/yr)** | Everything in Basic **+ unlimited words + prioritized processing + early access + priority support** |
| Teams | custom | centralized billing + team management |

The Pro upgrade is fundamentally **unlimited words + priority** — not a feature unlock. Payments via Stripe; 7-day money-back (per reviews).

## 3. Where it sits in the architecture — Layer 0 (operator → hive interface)

Glaido is **upstream of everything**. Adrian is dyslexic and runs the entire operation by voice; his dictation is the literal entry point to the hive (Claude CEO → Antigravity builder → ChatGPT/SuperGrok bridges → 6 ventures). It is not part of the swarm; it is the keyboard.

**Why it matters strategically:** [[productivity-multiplier-reckoning]] found the machine ceiling is ~30-80× but realised output is ~5×, and the binding constraint is now **Adrian's own serial fraction** (input speed + decision latency), not the agents. Faster, cleaner dictation attacks that bottleneck directly and reduces the phonetic-error tax downstream agents currently absorb ("Crowe's"=Grok's, "Abee", "Balinese"). That is a *material* lever, not cosmetic — see `full-stack-capability-map`, `hive-architecture-v3.md`.

## 4. 🔴 The confidentiality firewall (load-bearing)

Per Glaido's privacy policy (glaido.com/privacy-policy, last updated April 2026, retrieved verbatim):
- **Audio** is sent to third-party **speech-recognition providers** for real-time transcription — it leaves the device, but is "not retained after processing" (their claim).
- **Text** is stored locally **until you use auto-edit or Agent Mode**, at which point "the relevant text is sent to our AI service providers." So even ordinary dictation with auto-edit ON routes your words through a third-party LLM; audio goes to STT regardless.
- The policy names **no specific sub-processors except Stripe** (categories only: "speech recognition providers", "AI language model providers", "cloud hosting providers"). "We do not permit our service providers to use your content to train their models" is a **contractual** assurance, not a technical guarantee. No GDPR/SOC2/HIPAA certification is claimed.

**Net: dictated content leaves the device.** That is the operative risk for Adrian's confidential corpus — and a fully-offline path does not exist today.

**RED ZONE — do NOT dictate via Glaido (free or Pro) until/unless the data path is verified safe:**
- Subconscious Surgery **1:1 client therapy** material (client confidentiality).
- **Active litigation** — Erica Johnson dispute (~$27.8k, civil filing drafted, Inglewood PD #261279). Routing legal strategy/correspondence through an unverified cloud path risks privilege and creates copies that could become discoverable. Same for the German/US parcel-seizure matters.
- **Strictly-private personal** — the "Arcturian soul" identity claim and any family/personal-private content.

**GREEN ZONE — use freely:** public marketing copy (OSB/SS), general comms, research notes, code, non-confidential ops, and prompts to the agent stack that contain no red-zone content.

Rule of thumb: *if it would be damaging in a subpoena or a breach, type it (or use a verified non-cloud path) — do not speak it into Glaido.*

## 5. "Implementation" — what it honestly means here

Glaido exposes **no public API / CLI / webhook / MCP** (multiple reviews confirm "no API"). It therefore **cannot be wired as a stack component** today. Treating it as a programmable agent node would be architectural error. "Implementing it into the infrastructure" correctly means:

1. **This doctrine note** (Layer-0 input tool + the firewall) — done.
2. **Memory** [[glaido-input-layer]] so every future session knows the tool exists, honours the red-zone firewall, and does not hallucinate an API.
3. **Adoption recommendation:** Pro annual (~$199/yr) — the free 2k-words/week cap throttles a heavy voice operator fast; the real win is unlimited + priority.
4. **Verify-then-watch:** (a) read glaido.com/privacy-policy (or the in-app policy) to confirm the data path before any borderline use; (b) if/when Glaido ships an API, revisit for *real* programmatic integration (e.g., piping cleaned dictation / Agent-Mode output into the pipeline). Until then there is nothing to build.

## 6. Interaction with existing doctrine (NOTE — not an edit)

The "interpret phonetic errors contextually" rule (AGENTS.md §2, CLAUDE.md) stays **as-is**. Glaido *reduces* phonetic errors but (a) Adrian will not always be on Glaido, and (b) cloud auto-edit can confidently mis-clean (wrong homophone, wrong proper noun). Do not relax the interpret-errors discipline on the assumption input is pre-cleaned. Any change to that constitutional line is a §8 doctrine-change decision for Adrian, not an inference.

## Revision history
- 2026-05-31 — Created. First-party research (glaido.com pricing/FAQ via real-browser fetch) + cross-model consult (Grok 4.3). Verdict: adopt for input layer; hard red-zone firewall; no technical integration possible (no API). — Claude (CEO)
- 2026-05-31 — **Corrected same day:** removed unverified sub-processor names (Deepgram/OpenAI/Anthropic/Groq) that were synthesized, not sourced; fixed pricing (Pro = $20/mo or annual −17% ~$199/yr, not $12/$144); fixed Agent-Mode tier (first-party lists it under Free). Firewall conclusion unchanged. — Claude (CEO)
- 2026-05-31 — **Privacy policy then retrieved verbatim** (glaido.com/privacy-policy, April 2026): §4 rewritten to sourced facts — audio → speech-recognition providers; text → AI providers whenever auto-edit OR Agent Mode is used; only Stripe named specifically; no-training is contractual; no compliance certs claimed. Mechanism (auto-edit + Agent Mode send text off-device) now first-party confirmed. — Claude (CEO)
