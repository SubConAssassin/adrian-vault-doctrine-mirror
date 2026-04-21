---
title: Tooling Preference Doctrine
type: canonical-doctrine
status: active
version: 1.0
last_updated: 2026-04-21
last_verified: 2026-04-21
authored_by: adrian (directive); codified by claude
related:
  - canonical/concepts/frictionless-operator-doctrine.md
  - canonical/concepts/mcp-connector-taxonomy.md
  - canonical/concepts/bridge-protocols.md
---

# Tooling Preference Doctrine

Standing rule issued by Adrian on 2026-04-21 when choosing between OpenAI Whisper API (paid, per-minute) and local `whisper-cpp` (free after install).

## The rule

**When choosing between a paid-per-use API and a locally-runnable tool of comparable quality, install and use the local tool.**

Adrian's framing: *"if we're ever gonna do anything and it can be run locally without an API cost by using some kind of connector or software, then we shall do that first."*

## Decision criteria

Choose local-first when **all** of the following hold:

1. **Repeated use expected.** The task (transcription, image generation, embedding, OCR, etc.) will run more than a handful of times across Adrian's ventures — not a one-off.
2. **Local quality is comparable.** Local model or tool produces output that is functionally equivalent for the use case. Not identical — functionally equivalent. A local transcription that catches 95% of words versus a cloud transcription that catches 97% is a rounding error; the 2% delta does not justify ongoing per-minute costs.
3. **Install cost is one-time and modest.** Binary install + model download under ~10GB, install time under an hour, compute requirement fits Adrian's hardware (M3 Pro, 18GB RAM).
4. **No specialised data required.** If the cloud tool has proprietary training data or capabilities the local tool lacks, cloud may win. Example: cloud models that can browse the live web beat local models for current-events reasoning.

If any criterion fails, reconsider and pick the cloud tool for that specific use case.

## Known local tools in the stack (2026-04-21)

| Capability | Local tool | Model | Location |
|---|---|---|---|
| Audio transcription | `whisper-cli` (brew `whisper-cpp`) | `ggml-large-v3.bin` | `~/Library/Application Support/Claude/whisper-models/` |
| Video/audio download | `yt-dlp` (brew) | N/A | `/opt/homebrew/bin/yt-dlp` |
| Image generation | *(not yet installed)* | — | — |
| Embedding models | *(not yet installed)* | — | — |
| OCR | *(via Claude vision currently; consider tesseract for batch)* | — | — |

Extend this table as new local tools are added.

## When cloud beats local anyway

Non-exhaustive list of tasks where cloud wins:
- **Frontier LLM reasoning** — Claude Opus, GPT-5, etc. Local LLMs exist but lag by 12–18 months.
- **Image generation at photorealistic quality** — cloud (Imagen, DALL-E, Midjourney) leads.
- **Voice cloning with minutes of reference audio** — cloud (ElevenLabs) is SOTA; local is behind.
- **Very large model inference** — anything requiring >200B params won't fit Adrian's hardware.

When cloud is the right choice, prefer **usage-metered APIs over subscriptions** unless usage is consistently high. Keep credentials in Keychain / Antigravity `mcp_config.json`, never in vault handoffs (see `bridge-protocols.md` §5 + `frictionless-operator-doctrine.md`).

## First application

The immediate trigger for this doctrine: Antigravity requested Whisper large-v3 transcription of a Stephan Schwartz YouTube interview for the OSB cinematic trailer (see `working/handoffs/2026-04-21-antigravity-to-claude-osb-trailer-phase1-delegation.md`). Two paths were offered: OpenAI Whisper API (~$0.006/min) or local `whisper-cpp`. Adrian directed local-first. This doctrine codifies the choice as a standing rule rather than a one-off decision.

Concrete outcome: `whisper-cpp` + `yt-dlp` installed via Homebrew, `ggml-large-v3.bin` downloaded to `~/Library/Application Support/Claude/whisper-models/`. Usable for any future transcription across Tristan voice notes, podcast episodes, interviews, ceremony recordings, etc.

## OPERATIONAL CHANGE INTRODUCED THIS CYCLE

- First canonical doctrine governing tool-selection between cloud and local. Previously implicit; now explicit.
- Establishes a shared tool inventory at `~/Library/Application Support/Claude/` as the non-TCC-restricted install location for models and binaries that agents need.

## Change log

| Date | Change | Authority |
|------|--------|-----------|
| 2026-04-21 | Initial canonical codification | Adrian (chat directive during OSB trailer transcription choice) |
