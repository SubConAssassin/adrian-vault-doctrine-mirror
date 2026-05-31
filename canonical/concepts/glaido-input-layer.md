# Glaido — the Operator Input Layer (dictation)

**Status:** Tier-2 reference doctrine (operating rule for a tool Adrian uses; not a wired stack component)
**Last updated:** 2026-05-31
**Verdict:** ADOPT for the input layer with a hard confidentiality firewall. Do NOT attempt to wire it into the agent stack — there is nothing to wire.

> Source discipline: pricing + tier features are first-party (glaido.com/pricing, fetched via real browser — the site bot-walls plain fetchers). Privacy facts are grep-verified against the verbatim privacy policy (glaido.com/privacy-policy, dated 14 May 2026). Product behaviour is corroborated across the site + multiple independent reviews. *(This doc was corrected twice on creation day — see revision history — after two synthesized claims were caught and replaced with verified ones.)*

---

## 1. What it is

Glaido is a **macOS-only, hotkey-driven voice-to-text dictation app**. Press a hotkey → speak → polished text appears at the cursor in *any* macOS app (Gmail, Slack, Notion, VS Code, Cursor, ChatGPT, the Claude/AG terminals — anywhere you can type). It is an OS-level **input device that types for the human**. It is not a service, agent, or backend.

- **AI auto-edit:** removes filler words, fixes grammar/punctuation, context-aware formatting. On both tiers.
- **Agent Mode:** voice *commands* — e.g. "make this more formal", "translate to Spanish", "summarise this" — transforms text at the cursor. Listed as a **Free-tier** feature on the live pricing page (some reviews call it Pro/beta — first-party pricing wins).
- 100+ languages; real-time translation to English.
- "Local storage" of dictation history is a listed feature on both tiers.
- Requires **internet** (real-time AI processing). macOS only.

## 2. Pricing (first-party, glaido.com/pricing)

| Plan | Price | Includes |
|---|---|---|
| Free / Basic | $0, no card | **2,000 words/week**, use in any app, AI auto-edits, Agent mode, local storage |
| **Pro** | **$20/mo**, or **annual −17% (≈ $16.60/mo ≈ ~$199/yr)** | Everything in Basic **+ unlimited words + prioritized processing + early access + priority support** |
| Teams | custom | centralized billing + team management |

The Pro upgrade is fundamentally **unlimited words + priority**, not a feature unlock. Payments via Stripe; 7-day money-back (per reviews).

## 3. Where it sits in the architecture — Layer 0 (operator → hive interface)

Glaido is **upstream of everything**. Adrian is dyslexic and runs the entire operation by voice; his dictation is the literal entry point to the hive (Claude CEO → Antigravity builder → ChatGPT/SuperGrok bridges → 6 ventures). It is not part of the swarm; it is the keyboard.

**Why it matters strategically:** [[productivity-multiplier-reckoning]] found the machine ceiling is ~30-80× but realised output is ~5×, and the binding constraint is now **Adrian's own serial fraction** (input speed + decision latency), not the agents. Faster, cleaner dictation attacks that bottleneck directly and reduces the phonetic-error tax downstream agents absorb ("Crowe's"=Grok's, "Abee", "Balinese"). Material, not cosmetic — see `full-stack-capability-map`, `hive-architecture-v3.md`.

## 4. 🔴 The confidentiality firewall (load-bearing)

The app **requires internet + real-time AI processing**: dictated audio — and, when auto-edit/Agent Mode runs, text — is processed **off-device**. Glaido's privacy policy (glaido.com/privacy-policy, dated 14 May 2026; grep-verified verbatim) is actually *specific and reasonable* — it discloses the path:

- **Controller:** GLAIDOVOICE AI SOLUTIONS – FZCO, a UAE (Dubai DIEZ free-zone) company. Explicit international-transfer + law-enforcement-disclosure clauses. Full GDPR + CCPA/CPRA sections.
- **Named AI/cloud sub-processors** (§"Cloud Infrastructure and AI Processing"): **Amazon Web Services**, **Baseten Labs**, **Groq** (AI inference), **Hetzner** (EU/Germany hosting). Analytics: **Google Analytics** + **Dub**. Payments: **Polar** (cards never touch Glaido; PCI-DSS).
- **Protective core (verbatim):** *"Glaido does not store Your dictation text in Our database; a temporary local history is kept only on Your device. User-generated content is not retained by these providers beyond the duration of active processing."* Providers "bound by data processing agreements."
- **But:** HIPAA is *defined in the policy but not offered* as a covered service; **no SOC 2**; protections are **contractual, not architectural**; **no offline mode**.

**Net:** the path is disclosed and reasonable for ordinary use, but **dictated content leaves the device through third-party AI processors under contractual (not technical) protection, with no offline mode, no SOC 2, and no HIPAA coverage** — keep the confidential corpus off it.

**RED ZONE — never dictate via Glaido (free or Pro):**
- Subconscious Surgery **1:1 client therapy** material (client confidentiality; HIPAA defined-but-not-offered, no SOC 2).
- **Active litigation** — Erica Johnson dispute (~$27.8k, civil filing drafted, Inglewood PD #261279). Routing legal strategy/correspondence through third-party AI processors (UAE controller, cross-border transfer, "disclose on legal request") risks privilege and creates copies that could become discoverable. Same for the German/US parcel-seizure matters.
- **Strictly-private personal** — the "Arcturian soul" identity claim and any family/personal-private content.

**GREEN ZONE — use freely:** public marketing copy (OSB/SS), general comms, research notes, code, non-confidential ops, and prompts to the agent stack that contain no red-zone content.

Rule of thumb: *if it would be damaging in a subpoena or a breach, type it (or use a verified non-cloud path) — do not speak it into Glaido.*

## 5. "Implementation" — what it honestly means here

Glaido exposes **no public API / CLI / webhook / MCP** (multiple reviews confirm "no API"). It therefore **cannot be wired as a stack component**. Treating it as a programmable agent node would be architectural error. "Implementing it into the infrastructure" correctly means:

1. **This doctrine note** (Layer-0 input tool + the firewall) — done.
2. **Memory** [[glaido-input-layer]] so every future session knows the tool exists, honours the red-zone firewall, and does not hallucinate an API.
3. **Adoption recommendation:** trial **Pro monthly ($20)** first (Free's 2k-words/week is far too small for a heavy voice operator to evaluate); go annual (~$199/yr) only if it measurably beats his current dictation. The win is unlimited + priority.
4. **Watch-item:** if/when Glaido ships an API, revisit for *real* programmatic integration (pipe cleaned dictation / Agent-Mode output into the pipeline). Until then there is nothing to build.

## 6. Interaction with existing doctrine (NOTE — not an edit)

The "interpret phonetic errors contextually" rule (AGENTS.md §2, CLAUDE.md) stays **as-is**. Glaido *reduces* phonetic errors but (a) Adrian will not always be on Glaido, and (b) cloud auto-edit can confidently mis-clean (wrong homophone, wrong proper noun). Do not relax the interpret-errors discipline on the assumption input is pre-cleaned. Any change to that constitutional line is a §8 doctrine-change decision for Adrian, not an inference.

## Revision history
- 2026-05-31 — Created. First-party research (glaido.com pricing/FAQ via real-browser fetch) + cross-model consult (Grok 4.3). Verdict: adopt for input layer; hard red-zone firewall; no technical integration possible (no API). — Claude (CEO)
- 2026-05-31 — **Correction 1:** removed synthesized sub-processor names (Deepgram/OpenAI/Anthropic/Groq); fixed pricing (Pro $20/mo or annual −17% ~$199/yr, not $12/$144); fixed Agent-Mode tier (Free, not Pro). — Claude (CEO)
- 2026-05-31 — **Correction 2:** removed a second synthesized set ("speech-recognition providers / Stripe / no-train") written before the policy body was read.
- 2026-05-31 — **Correction 3 (final, grounded):** policy body grep-verified verbatim. It is NOT boilerplate — it has a dedicated "Cloud Infrastructure and AI Processing" section naming **AWS, Baseten, Groq, Hetzner** (+ Google Analytics, Dub, Polar payments), an explicit no-DB-storage line, GDPR+CCPA sections, and HIPAA *defined but not offered*. §4 rewritten to that verified truth; firewall now rests on the sharper, correct reasons (contractual-not-technical, no offline mode, no SOC 2/HIPAA-coverage, UAE controller + legal-disclosure) rather than a false "non-disclosure" claim. Three synthesis errors this session = the lesson: ground specifics against the source *body*, never its summary. — Claude (CEO)
