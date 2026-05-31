# Glaido — the Operator Input Layer (dictation)

**Status:** Tier-2 reference doctrine (operating rule for a tool Adrian uses; not a wired stack component)
**Last updated:** 2026-05-31
**Verdict:** ADOPT as the default voice-input layer. One narrow confidentiality hold (verbatim client-therapy audio); everything else green. Do NOT attempt to wire it into the agent stack — there is nothing to wire (no public API).

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

## 4. Confidentiality stance (one narrow hold, otherwise green)

The app **requires internet + real-time AI processing**: dictated audio — and, when auto-edit/Agent Mode runs, text — is processed **off-device**. Glaido's privacy policy (glaido.com/privacy-policy, dated 14 May 2026; grep-verified verbatim) is actually *specific and reasonable* — it discloses the path:

- **Controller:** GLAIDOVOICE AI SOLUTIONS – FZCO, a UAE (Dubai DIEZ free-zone) company. Explicit international-transfer + law-enforcement-disclosure clauses. Full GDPR + CCPA/CPRA sections.
- **Named AI/cloud sub-processors** (§"Cloud Infrastructure and AI Processing"): **Amazon Web Services**, **Baseten Labs**, **Groq** (AI inference), **Hetzner** (EU/Germany hosting). Analytics: **Google Analytics** + **Dub**. Payments: **Polar** (cards never touch Glaido; PCI-DSS).
- **Protective core (verbatim):** *"Glaido does not store Your dictation text in Our database; a temporary local history is kept only on Your device. User-generated content is not retained by these providers beyond the duration of active processing."* Providers "bound by data processing agreements."
- **But:** HIPAA is *defined in the policy but not offered* as a covered service; **no SOC 2**; protections are **contractual, not architectural**; **no offline mode**.

**Net (corrected 2026-05-31 — earlier draft was overcautious):** the no-retention claim materially *lowers* the everyday risk. The only mechanical caveat is that audio must transit third parties to be transcribed (there is no offline mode), then is deleted. For the overwhelming majority of Adrian's work that is fine and equivalent to how he already uses cloud email/Slack/transcription. Use Glaido as the default input across essentially everything.

**The ONE genuine hold — verbatim client therapy session audio.** Not because Glaido is distrusted, but because that is the *client's* confidential clinical disclosure (not Adrian's to risk), and health-adjacent data has a higher bar (HIPAA/SOC 2) that "we delete after processing" does not meet. So: Adrian's own *notes about* a session → fine via Glaido; a client's *actual recorded words* → keep off it.

**Everything else = Adrian's judgment, default GREEN:**
- **Active litigation (Erica) / legal drafting** — fine. A DPA-bound tool that deletes after processing does not realistically blow privilege (lawyers use third-party transcription routinely). Earlier "red zone" framing was overstated; downgraded to use-freely.
- **Strictly-private personal (Arcturian-soul etc.)** — comfort call, not a legal risk. If Adrian is comfortable it deletes, use it.
- **Public marketing, general comms, research notes, code, ops, prompts to the agent stack** — green, no question.

Rule of thumb (revised): *Glaido is fine for everything except a third party's confidential clinical material (verbatim client-session audio). When in doubt on that one category, type it or use a non-cloud path.*

## 5. "Implementation" — what it honestly means here

Glaido exposes **no public API / CLI / webhook / MCP** (multiple reviews confirm "no API"). It therefore **cannot be wired as a stack component**. Treating it as a programmable agent node would be architectural error. "Implementing it into the infrastructure" correctly means:

1. **This doctrine note** (Layer-0 input tool + the firewall) — done.
2. **Memory** [[glaido-input-layer]] so every future session knows the tool exists, honours the one narrow hold, and does not hallucinate an API.
3. **Adoption recommendation:** testing on the **Free tier first** (Adrian's choice 2026-05-31 — run it on real work until it throttles, using known phonetic-error words as live accuracy tests; Claude acts as the accuracy meter on incoming dictation). Upgrade to **Pro ($20/mo, cancel anytime)** when the free 2k-words/week wall is hit AND accuracy has proven better than the prior tool; annual (~$199/yr) only after that. The win is unlimited + priority.
4. **Watch-item:** if/when Glaido ships an API, revisit for *real* programmatic integration (pipe cleaned dictation / Agent-Mode output into the pipeline). Until then there is nothing to build.

## 6. Interaction with existing doctrine (NOTE — not an edit)

The "interpret phonetic errors contextually" rule (AGENTS.md §2, CLAUDE.md) stays **as-is**. Glaido *reduces* phonetic errors but (a) Adrian will not always be on Glaido, and (b) cloud auto-edit can confidently mis-clean (wrong homophone, wrong proper noun). Do not relax the interpret-errors discipline on the assumption input is pre-cleaned. Any change to that constitutional line is a §8 doctrine-change decision for Adrian, not an inference.

## Revision history
- 2026-05-31 — Created. First-party research (glaido.com pricing/FAQ via real-browser fetch) + cross-model consult (Grok 4.3). Verdict: adopt for input layer; hard red-zone firewall; no technical integration possible (no API). — Claude (CEO)
- 2026-05-31 — **Correction 1:** removed synthesized sub-processor names (Deepgram/OpenAI/Anthropic/Groq); fixed pricing (Pro $20/mo or annual −17% ~$199/yr, not $12/$144); fixed Agent-Mode tier (Free, not Pro). — Claude (CEO)
- 2026-05-31 — **Correction 2:** removed a second synthesized set ("speech-recognition providers / Stripe / no-train") written before the policy body was read.
- 2026-05-31 — **Correction 3 (grounded):** policy body grep-verified verbatim. It is NOT boilerplate — dedicated "Cloud Infrastructure and AI Processing" section naming **AWS, Baseten, Groq, Hetzner** (+ Google Analytics, Dub, Polar payments), an explicit no-DB-storage line, GDPR+CCPA sections, HIPAA *defined but not offered*. — Claude (CEO)
- 2026-05-31 — **Correction 4 (stance recalibrated, Adrian-prompted):** Adrian rightly flagged that the verbatim no-retention line ("temporary, deleted after processing, only saved if instructed") makes the earlier three-item "red zone" overcautious. Downgraded active-litigation + strictly-private from RED to GREEN/your-call; retained ONE narrow hold = verbatim client-therapy session audio (third party's clinical material, higher bar). §4 reframed from "firewall" to "one narrow hold, otherwise green." Verdict + memory + index updated to match. Also recorded: Adrian is testing on the FREE tier first (not Pro) — run-until-throttle with Claude as live accuracy meter. — Claude (CEO)
