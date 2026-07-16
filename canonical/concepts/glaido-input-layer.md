# Glaido — the Operator Input Layer (dictation)

**Status:** Tier-2 reference doctrine (operating rule for a tool Adrian uses; not a wired stack component)
**Last updated:** 2026-07-16 (tier corrected to **PRO** Adrian-direct; §5a local-diagnostics + error decoder added after a live incident)
**Verdict:** ADOPT as the default voice-input layer. One narrow confidentiality hold (verbatim client-therapy audio); everything else green. Do NOT attempt to wire it into the agent stack — there is nothing to wire (no public API). **BUT it IS diagnosable — it ships first-party local logs: see §5a before troubleshooting anything.**
**Tier:** **PRO** (Adrian-direct 2026-07-16) — unlimited words, prioritized processing. The free 2k/week cap is irrelevant to him.

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
| Free / Basic | $0, no card | **2,000 words/week**, use in any app, AI auto-edits, Agent mode, local storage — ⚠️ **NOT Adrian's tier, does not apply to him** (see §5.3) |
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
3. **Tier — ✅ ADRIAN IS ON PRO (confirmed Adrian-direct 2026-07-16).** This SUPERSEDES the 2026-05-31 "testing on the Free tier first / run-until-throttle" plan below, which is now historical only. Upgrade date unknown — [NOT FOUND], not worth chasing. Operating consequences: **the 2,000-words/week cap does NOT apply to him** — never diagnose a Glaido problem as a word-cap or throttle issue, and never suggest he upgrade. He has **unlimited words + prioritized processing**. Corollary used in the 2026-07-16 diagnosis: because Pro *is* the priority lane, a backend failure while on Pro is affirmative evidence of a **service-side incident**, not of throttling.
   *(Historical, superseded: testing on the Free tier first was Adrian's choice 2026-05-31 — run on real work until it throttles, using known phonetic-error words as live accuracy tests, with Claude as the accuracy meter on incoming dictation.)*
4. **Watch-item:** if/when Glaido ships an API, revisit for *real* programmatic integration (pipe cleaned dictation / Agent-Mode output into the pipeline). Until then there is nothing to build.

## 5a. ⚠️ IT IS DIAGNOSABLE — local logs + DB (discovered 2026-07-16, corrects §5's implication)

"No public API" ≠ "nothing to inspect." Glaido is a **Tauri/Rust** app (`glaido_core_lib`, single 38MB `glaido-core` binary) that writes **first-party local diagnostics**. When Adrian says Glaido is glitching, READ THESE FIRST — do not guess, and do not blame his internet because the app's error text says so (its "check your internet connection" message fires on backend-side failures too):

- **Daily logs:** `~/Library/Application Support/com.glaido.app/logs/glaido.YYYY-MM-DD.log` — plaintext, one file/day, **no timestamps in-line** (correlate by file order + startup markers + file mtime). Startup blocks (`diagnostics initialized` → `Startup settled`) delimit each app run.
- **Dictation history DB:** `~/Library/Application Support/com.glaido.app/glaido.db` — **encrypted** (not SQLite plaintext; header is random bytes, `sqlite3` reports "file is not a database"). Not readable; do not treat as corrupt.
- **Force-quit record:** `~/Library/Application Support/CrashReporter/glaido-core_*.plist` (`ForceQuitDate` = when Adrian rage-quit it).
- **Update channel:** `https://releases.glaido.com/update/darwin/aarch64/{version}` → **HTTP 204 = on latest**, JSON = update available.
- **Health check:** `https://api.glaido.com/v1/health` → 200 = backend up. (Root `/` = 404 and `/v1/auth/refresh` = 405/422 on a bare probe — both NORMAL, not faults.)

**Error-signature decoder (empirically grounded 2026-07-16):**

| Log signature | Means |
|---|---|
| `settings_sync Failed to fetch settings from backend: Request failed with HTTP 503` | **Glaido's backend is down.** Server-side. Connection succeeded; their service returned 503. Not Adrian's network. |
| `auth::client api_transport_error path="/auth/refresh" is_timeout=false is_connect=true` | TCP connect never completed. `is_connect=true`+`is_timeout=false` = **instant** connect failure (backend refusing, or broken-IPv6 egress — see below), NOT slow internet. |
| `ws_connect_error` / "Could not connect. Please check your internet connection" | Dictation session failed to open its websocket. **The user-facing text is misleading** — verify the link before accepting it. |
| `Server error code="too_short"` | Backend rejected the recording as too short — audio capture was truncated, typically **CPU starvation** losing the start of speech. |
| `Credential store operation timed out label="load_tokens"` | macOS **Keychain** timed out → box starvation. |
| `Core init timed out after 10s` / `Entering recovery mode: Startup timed out` | Severe starvation at launch. |
| `Denoiser not returned, rebuilding` / `Aborting stale recording start pipeline` | Downstream noise from a failed session; not a root cause. |

**Known failure mode — it does NOT self-heal.** On 2026-07-16 the backend recovered (`/v1/health` = 200) but the app stayed latched in a broken auth state, retrying `/auth/refresh` 36× and failing every dictation. **Fix = restart Glaido** (`osascript -e 'quit app "Glaido"'` → `open -a Glaido`); a clean run logs ~10 INFO lines and zero errors. Restarting is cheap, reversible, and the correct first move.

**Two environment landmines on the M1 Max that break Glaido independently of Glaido:**
1. **Box overload.** Glaido is real-time audio + a live cloud socket = the most starvation-sensitive app in the stack, so it fails first and loudest. It is a *canary for the load problem*, not the disease. See the §1a hard cap (2–4 concurrent CLI clients; 12 = load 577 = box dead).
2. **Broken IPv6 (latent, unfixed as of 2026-07-16).** 8 phantom IPv6 default routes via Tailscale `utun0-7`, but **no global IPv6 on `en0`** (Bali ISP is v4-only) → every IPv6 connect fails instantly, box-wide (verified against Cloudflare/Google/Groq/Glaido). `curl` survives via Happy-Eyeballs v4 fallback; a Rust/reqwest client may not — which matches `is_connect=true` exactly. Not proven to be Glaido's root cause, but a standing fragility worth fixing.

## 6. Interaction with existing doctrine (NOTE — not an edit)

The "interpret phonetic errors contextually" rule (AGENTS.md §2, CLAUDE.md) stays **as-is**. Glaido *reduces* phonetic errors but (a) Adrian will not always be on Glaido, and (b) cloud auto-edit can confidently mis-clean (wrong homophone, wrong proper noun). Do not relax the interpret-errors discipline on the assumption input is pre-cleaned. Any change to that constitutional line is a §8 doctrine-change decision for Adrian, not an inference.

## Revision history
- 2026-07-16 — **Correction 5 (tier) + §5a added (diagnostics), after a live "glaido is glitching" incident.** (a) **TIER: Adrian is on PRO, not Free** — Adrian-direct, supersedes the 2026-05-31 run-until-throttle-on-Free plan. Never diagnose his Glaido issues as word-cap/throttle; never suggest upgrading. (b) **§5's "no API" was being read as "nothing to inspect" — wrong.** Glaido (Tauri/Rust) writes daily plaintext logs to `~/Library/Application Support/com.glaido.app/logs/`, plus an encrypted history DB and a force-quit plist. §5a adds the paths + an empirically-grounded error-signature decoder. (c) **Incident findings:** Glaido's *backend* returned **HTTP 503** (`settings_sync`), degrading to `is_connect=true` auth failures and 6 dictation sessions dead with `ws_connect_error`; Adrian restarted the app 4× and rebooted the Mac (23:02) chasing it. Backend had recovered (`/v1/health` = 200) but **the app does not self-heal** — it stayed latched in a broken auth state until restarted (restart → clean, 0 errors; fix verified). (d) **Its "check your internet connection" text is misleading** — his link was fine (31ms, 0% loss, −45dBm); the fault was server-side. (e) **0.1.4 is current** (update endpoint 204). (f) Two standing environment landmines documented: **box overload** (load hit **215** on a 10-core Mac 4 min after boot; Glaido's `too_short`×15 / Keychain-timeout×5 / recovery-mode×2 are starvation fingerprints — Glaido is the canary, not the disease) and **box-wide broken IPv6** (8 phantom v6 default routes via Tailscale utun0-7, no global v6 on en0 → instant v6 connect failures; matches `is_connect=true`; unfixed). (g) Trailing-random-word artifact is unrelated (cloud STT hallucination) — see [[feedback-glaido-stt-trailing-word-artifact]]. — Claude (CEO)
- 2026-05-31 — Created. First-party research (glaido.com pricing/FAQ via real-browser fetch) + cross-model consult (Grok 4.3). Verdict: adopt for input layer; hard red-zone firewall; no technical integration possible (no API). — Claude (CEO)
- 2026-05-31 — **Correction 1:** removed synthesized sub-processor names (Deepgram/OpenAI/Anthropic/Groq); fixed pricing (Pro $20/mo or annual −17% ~$199/yr, not $12/$144); fixed Agent-Mode tier (Free, not Pro). — Claude (CEO)
- 2026-05-31 — **Correction 2:** removed a second synthesized set ("speech-recognition providers / Stripe / no-train") written before the policy body was read.
- 2026-05-31 — **Correction 3 (grounded):** policy body grep-verified verbatim. It is NOT boilerplate — dedicated "Cloud Infrastructure and AI Processing" section naming **AWS, Baseten, Groq, Hetzner** (+ Google Analytics, Dub, Polar payments), an explicit no-DB-storage line, GDPR+CCPA sections, HIPAA *defined but not offered*. — Claude (CEO)
- 2026-05-31 — **Correction 4 (stance recalibrated, Adrian-prompted):** Adrian rightly flagged that the verbatim no-retention line ("temporary, deleted after processing, only saved if instructed") makes the earlier three-item "red zone" overcautious. Downgraded active-litigation + strictly-private from RED to GREEN/your-call; retained ONE narrow hold = verbatim client-therapy session audio (third party's clinical material, higher bar). §4 reframed from "firewall" to "one narrow hold, otherwise green." Verdict + memory + index updated to match. Also recorded: Adrian is testing on the FREE tier first (not Pro) — run-until-throttle with Claude as live accuracy meter. — Claude (CEO)
