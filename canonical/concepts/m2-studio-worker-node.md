# M2 Max Mac Studio — Worker Node (Operations Reference)
**Status:** Canonical infra reference. **Created:** 2026-06-17 (onboarded + tuned this session).
**Purpose:** Everything a new Claude session needs to know to USE the M2 Studio node from cold. Read this + `working/handoffs/STATE-OF-STACK.md` + `working/_research/2026-06-16-m2-integration/benchmark-results.md` and you are fully oriented.

> ⚠️ The prior session's **episodic (claude-mem) observations do NOT carry to a new Claude account.** This file + the vault are the source of truth. Nothing here depends on episodic memory.

---

## 1. The fleet (who is who)
| Node | Hardware | Role | Reach |
|---|---|---|---|
| **MacBook Pro** (primary / "the brain") | **M1 Max, 64GB, 24-core GPU** | Claude CEO session runs here · CLI team (`agy`/`grok`/`codex`) runs here · orchestration | local |
| **Mac Studio** (NEW worker, this session) | **M2 Max, 32GB, 30-core GPU, macOS 26.5** | local-LLM grind engine · 2nd Claude account · Antigravity · CLI hub · 24/7 | **`ssh studio`** |
| **M3 worker** (`m3worker`) | **M3 Pro, 18GB** (per records) | Whisper/transcription queue | `ssh m3worker` — ⚠️ was OFFLINE/unreachable 2026-06-17 (mDNS didn't resolve; not on LAN) |

Adrian is in Sayan/Ubud (and the Studio sits in the spare/dry room). Hot ambient → laptops thermally throttle; the Studio (desktop cooling) does not.

## 2. Access to the Studio (all set up, key-based, no passwords)
- **Terminal:** `ssh studio` (alias in `~/.ssh/config` on the MacBook → `subconm2@192.168.1.65`, key `~/.ssh/id_ed25519`). Also reachable on **.53** (dual-homed Wi-Fi+Ethernet). Passwordless.
- **GUI / full desktop:** double-click **`~/Desktop/Mac Studio Screen.inetloc`** (or Finder → Connect to Server → `vnc://192.168.1.65`). Screen Sharing is enabled + authorized for all users.
- **Credentials (if ever needed):** macOS user `subconm2`, password `Kian2000`. ⚠️ username is **lowercase** `subconm2`; the *computer name* is `SubConm2` — do not confuse them (cost an hour this session).
- **IPs are DHCP** (.65 / .53) — if they change, re-find via `nc -z` port-22 scan + `ssh subconm2@<ip>`. **TODO (needs Adrian):** Tailscale login on the Studio for a stable name.

## 3. Local LLM — the grind engine (LIVE + TUNED)
- **Ollama runs as a persistent 24/7 LaunchAgent** `com.adrianvault.ollama` (survives reboot: RunAtLoad + KeepAlive). Config: **`OLLAMA_FLASH_ATTENTION=1` + `OLLAMA_NUM_PARALLEL=4`** + `OLLAMA_HOST=0.0.0.0:11434` (LAN-reachable, OpenAI-compatible API).
- **Models pulled:** `qwen2.5:14b` (primary, ~9GB) + `nomic-embed-text` (embeddings). Secondary `qwen2.5:32b` recommended for quality passes (not pulled yet). For *heavy/fast* corpora consider `qwen2.5:7b` (~2× faster, slight quality trade).
- **Endpoint test:** `curl -s http://192.168.1.65:11434/api/tags`. Only **ONE** `ollama serve` should run — if you ever see `bind: address already in use`, kill all (`pkill -9 -f ollama`) and `launchctl load ~/Library/LaunchAgents/com.adrianvault.ollama.plist`.
- **Grind harness:** `tools/studio-grind.py [LIMIT]` — MacBook reads corpus text files, pushes to the Studio endpoint (4-wide concurrent), saves JSON. **Data stays on the MacBook; only inference runs on the Studio (no copy).** Idempotent. Reusable on any corpus (edit SRC_DIR/SYS prompt).

## 4. Performance facts (MEASURED — don't overclaim)
- **Single-stream `qwen2.5:14b`:** Studio ~**28.9 tok/s** · M1 Max MacBook ~**9.8 tok/s** → **~2.95× in practice.** BUT pure silicon is only **~1.5×** (30 vs 24 GPU cores + M2 gen); the extra ~2× is *likely* laptop throttling + config — **UNPROVEN** (would need GPU-clock monitoring). **The honest line: the SETUP delivers ~3× for sustained grind and frees the laptop — route grind to the Studio. The chip isn't 3× better.**
- **Concurrency is task-weight dependent:** light/short tasks ≈ **174 docs/min** at 4-wide (flash-attn +47%); heavy 6KB-input tasks ≈ **16 docs/min** (~1.2× serial — GPU saturates per request). For heavy corpora the lever is a *smaller model*, not more slots.
- **q8 KV-cache HURTS** here (no memory pressure on 32GB) — dropped it. Don't cargo-cult "optimizations"; measure.
- M3 not yet benchmarked (offline). Spec guess only: M3 Pro ~150GB/s vs Studio ~400GB/s → *maybe* ~2.5–3× slower — **unverified, do not state as fact.** Benchmark it when it's on the LAN.

## 5. Work-attribution (how the CEO should use the stack)
- **Claude (primary account, MacBook):** decide / orchestrate / verify ONLY. Scarce — preserve (was RED ~77% weekly this session). Per `delegation-first-operating-doctrine.md`.
- **2nd Claude account (Studio):** Claude-grade work on a SEPARATE weekly pool. ⚠️ usable via the **desktop app + Antigravity** today; **headless `claude` CLI is NOT logged in** (desktop login doesn't carry to the CLI — needs Adrian to run `claude /login` on the Studio once, browser flow). Until then, no headless 2nd-pool jobs.
- **CLI team (`bash tools/cli-ask.sh agy|grok|codex`, $0 flat-rate, on the MacBook):** research / extraction / content / classification. ⚠️ **SANDBOXED** — they write drafts/plans to files, they CANNOT ship code (can't write `~/Documents/localhost/*` repos or bind localhost). Real code changes need Antigravity-IDE or Claude-direct. ⚠️ **Every agy parcel prompt MUST embed the anti-crawl override** ("Do NOT crawl the vault / load AGENTS.md…") or agy dumps doctrine text into the output (caught + fixed this session).
- **Studio local-LLM:** $0 on-silicon grind (classification/extraction/embeddings; Whisper later) — the Studio's unique high-volume engine. Route bulk light classification here.
- **Antigravity:** sustained build/extraction via the PROVEN FEEDER (`working/_feeder/tasks/` + `ag-feeder.py --until`), never a one-shot bounce.

## 6. What's pending (hand to Adrian / next session)
1. **Adrian, ~30s each:** `claude /login` on the Studio (unlocks headless 2nd pool) · Tailscale login on the Studio · review/approve the 8 drafts.
2. **8 SS/Mastermind/Ashta drafts** in `working/drafts-pending/2026-06-16-*.md` (verified clean) — each is a draft + apply-ready patch; the code ones need applying via AG-IDE or Claude-direct after Adrian approves.
3. **Doctrine correction needed:** `delegation-first §10.3` / `hive-architecture-v3` still reference an "M1 Ultra incoming" — that purchase was **CANCELLED**; the M2 Studio (this node) is the real second node now. Update those references.
4. **Studio corpus-grind at scale:** the full Dropbox image corpus (14k images) needs OCR-first (qwen is text-only) — a next-phase pipeline; the 876 already-extracted notes were classified this session (`working/deep-extraction/dropbox-classified-2026/`, 682 OSB / 172 Ashta / 2 SS / 1 AGA).

## 6b. Transcription (Whisper) — the Studio's OTHER workhorse (added 2026-06-17 ~03:00)
- Whisper is installed on the Studio: `whisper-cli` (Homebrew) + `ffmpeg` + model `~/whisper-models/ggml-medium.en.bin` (1.4GB).
- **The proven streaming queue is repointed to the Studio:** `tools/studio-transcribe-queue.py` (a copy of the M3's `m3-transcribe-queue.py`, M3 original untouched). The M1 ffmpeg-demuxes Dropbox media → ships a small wav → Studio runs whisper-cli → `.md` transcript back to `working/deep-extraction/ss-media-transcripts/` (`node: m2-studio`). Idempotent (shares the ~1,774-done dedup), load-guarded.
- **⚠️ LIVE as of 2026-06-17 ~02:25:** a full backlog run is GRINDING (`python3 tools/studio-transcribe-queue.py 1440`, detached nohup, 24h deadline, ~551 pending). **Check it:** `tail -f working/_logs/studio-transcribe-queue.log` · **Stop:** `touch working/_locks/studio-transcribe-queue.stop`. If it's still running when you read this, leave it; if done, the transcripts are in `ss-media-transcripts/`.
- **Speed (measured, clean, same file+model):** M2 Studio ~1.7× the M1 Max and ~5.5× the (offline) M3 at Whisper; ~26× realtime. Detail: `working/handoffs/2026-06-17-m2-vs-m3-whisper-benchmark.md`.
- ⚠️ The Dropbox CloudStorage mount was re-linked (`Dropbox-Adriantaffinder/Adrian Taffinder` → `Dropbox/`); the studio queue remaps paths transparently. 83 list entries point at the old structure (unreachable, flagged, not blocking).

## 7. Hard-won lessons (don't relearn these)
- Verify-before-trust pays: caught agy doctrine-bleed, an overclaimed 2.6×, a port-conflict 500, and a q8-KV slowdown — all by measuring/checking, not assuming.
- `find ~` on the Studio stalls (iCloud dataless traversal) — use targeted paths over SSH, never `find ~`.
- macOS has no `timeout` (use a python/perl alarm or the Bash tool timeout).
- Headless Homebrew needs passwordless sudo (temp `/etc/sudoers.d` entry, removed after) — sudo timestamp doesn't carry into subprocesses over non-TTY SSH.
- Multi-writer drift: CLI agents and sibling Claude sessions BOTH write to `STATE-OF-STACK.md`. Don't assume you're the only writer; re-read before editing.
