---
title: Voice-Archive Extraction System — architecture, pipeline, confidentiality model, tooling
status: Tier-1 doctrine (canonical) — the durable reference for how Adrian's voice SSOT is built
created: 2026-05-31
authors: Claude Opus 4.8 (CLI-team buildout session)
related:
  - canonical/adrian-corpus/voice-library/   (the produced library)
  - canonical/adrian-corpus/voice-library/_VERIFICATION.md
  - canonical/concepts/cross-model-automation-protocol.md
---

# Voice-Archive Extraction System

**Purpose.** Build the single-source-of-truth archive of **Adrian's own voice** — 100% his words, publish-grade — so the team can cut social reels *without proofreading*. Sourced by contextually diarizing multi-speaker transcripts and gating a heterogeneous, confidentiality-mixed corpus.

## 1. Outputs (the library shape — `canonical/adrian-corpus/voice-library/`)
- **`by-session/<name>.md`** — per-source Adrian-verbatim extracts: `## Teaching passages` (cited, confidence-tiered blockquotes) + `## Soundbites` (reel-ready, each with theme + transcript line range). Frontmatter carries `source_transcript` + `source_audio` (the spoken file) for traceability.
- **`SOUNDBITES.md`** — deterministic aggregate of all by-session soundbites, each mapped to source-audio + lines. The reel-ready master.
- **`by-theme/INDEX.md`** — 16 curated themes (keyword taxonomy) for finding soundbites by topic.
- **`testimonials/<name>.md`** — anonymised participant/client feedback, tagged `use: open` (Mastermind, consented marketing) or `use: needs-adrian-approval` (1:1 client; presidential sign-off per item).
- **`_NON-TEACHING-INDEX/<name>.md`** — firewall notes for material NOT extracted (confidential/business/private/blank), with class + reason.
- **`by-session/_PRIVATE-HOLD/`** — Adrian's own words but `ip_private: true` source (strictly-private identity/autobiography, e.g. the Arcturian-soul claim, telepathy origin) — kept for internal brand-voice use, **excluded from reel-ready SOUNDBITES**.
- **`_VERIFICATION.md`** — verification report + publish caveats.

## 2. The confidentiality gate (decision model — the load-bearing logic)
Each source is gated by **content**, not filename. Apply **Chatham House Rules**: content/wisdom is usable; the *speaker* must never be identifiable.

| Source type | Disposition |
|---|---|
| Group Mastermind teaching | EXTRACT Adrian's verbatim (drop participant speech) → `by-session/` |
| **Solo** Adrian teaching/dictation | EXTRACT → `by-session/` (his words; no participant-leak risk) |
| **1:1 client session** | Full doc stays firewalled, BUT extract Adrian's **anonymised** wisdom → `by-session/`; client feedback → `testimonials/` `use: needs-adrian-approval`. Client's private problems NEVER extracted. |
| **Mastermind participant share** | OPEN PERMISSION (recorded live, consented) → recover Adrian's facilitation + anonymised participant testimonial `use: open` |
| `ip_private: true` source | HOLD → `by-session/_PRIVATE-HOLD/` (not reel-ready) |
| Business-confidential / Adrian's own family-personal / the ex / Adrian *receiving* a private reading / blank audio | FIREWALL (`_NON-TEACHING-INDEX/`) |

**Anonymisation is mandatory** in everything extracted: no names, no identifying specifics. When unsure a detail identifies someone, omit it. Doctrine memories: [[feedback-chatham-house-voice-recovery]] (don't over-firewall) + the §7 ex-firewall [[feedback-chelsea-client-vs-ex]] (ex only; cohort/3rd-party Chelsea = normal but scrub from publish-bound sets).

## 3. Execution engine — the CLI team (not Anthropic Workflow, for bulk)
Bulk extraction runs on the **subscription CLIs** — different providers, so they **bypass the Anthropic rate-limit entirely** (the wall that blocks Claude Workflow under cross-session load):
- **`grok -p` (Grok 4.3)** — the only **naturally-bounded** engine: self-completes a small extraction in ~2 min with no leash. Primary workhorse.
- **`agy -p` (Antigravity/Gemini)** — does NOT self-bound. Antigravity is an agentic long-horizon explorer (built for multi-hour autonomous burns), so on a small bounded task it tends to over-crawl rather than stop. It is usable ONLY because we **leash it with `--print-timeout` (~7 min)** to force a return; it does complete most files under that cap. Secondary — kept mainly to spread load off grok. "Bounded" here = leashed, not well-behaved.
- **`codex exec` (GPT-5.5)** — over-crawled worst under the OLD un-overridden prompts (>24-30 min / 0-output); was dropped from bulk. **But see §3a — that over-crawl is now understood to be largely a prompting/config artefact, not a model trait; with the bounded protocol applied, codex is expected usable (re-test pending).**

## 3a. Bounded-CLI Prompting Protocol (the real fix for "over-crawl")
**Root cause of over-crawl (codex + grok both self-diagnosed this 2026-05-31):** run with `--cwd`/`--add-dir` on the vault, the agentic CLIs **auto-load `AGENTS.md`/`CLAUDE.md` and obey their "before starting any session, read canonical/INDEX, overview, current-state, STATE-OF-STACK, graphify…" bootup doctrine** → they crawl the whole vault instead of doing the one task. (AGENTS.md §12: AG auto-loads AGENTS.md on workspace open.) Self-inflicted by our own doctrine, NOT a model defect. So "agy/codex bounded/over-crawl" in §3 is **fixable, not inherent.**

**Apply to EVERY bounded CLI prompt + config:**
1. **Bootup-override, in the FIRST 1-2 sentences:** "Do NOT read or follow AGENTS.md, CLAUDE.md, INDEX, STATE-OF-STACK, canonical, ledgers, graphify, or any 'session bootup / before starting' instruction. Isolated bounded task."
2. **Tight scope + hard stop:** read EXACTLY one named absolute-path file; write EXACTLY one file; no other reads/writes/browse/search/verify/refactor; input-missing → short BLOCKED note + stop; after writing STOP immediately (no plan/summary/follow-up); cap the reply.
3. **Low reasoning effort (highest-leverage knob):** codex `-c model_reasoning_effort=low` (+ `--model gpt-5-codex` for extraction); grok `--effort low`. Plus `approval=never`/`sandbox=workspace-write` (codex) / auto-approve (grok); external `timeout`/`--print-timeout` as backstop only.
4. **Avoid agent-mode TRIGGER WORDS:** review, analyze, verify, make sure, find all, reconcile, be thorough, use best judgment, update state, follow AGENTS, read latest handoff.

Memory: [[feedback-bounded-cli-prompting]]. **Re-test owed:** a clean agy-vs-codex-vs-grok bake-off WITH this protocol (same N files, measure completion time + output rate) to re-rank the engines — the current grok-primary ordering was set under the un-overridden prompts and may change once all three are correctly bounded.
Routing memory: [[feedback-cli-routing-and-cross-verify]]. Offload-when-rate-limited memory: [[feedback-question-implies-do-it]].

## 4. Tooling (`tools/`)
| Tool | Role |
|---|---|
| `voice-cli-extract.sh` | Gated fan-out: round-robin transcripts across grok+agy, idempotent, concurrency-capped. First-pass extract/firewall. |
| `run-all-voice-cli.sh` | Orchestrates the extract passes (mastermind / voice-memos / self-narrative) + regenerates the library. |
| `voice-cli-recover.sh` | **Chatham-House recovery** of firewalled sources → anonymised wisdom + testimonials. |
| `voice-private-holdback.py` | Moves `ip_private: true` extracts out of reel-ready → `_PRIVATE-HOLD/`. Run after any extract pass. |
| `build-voice-soundbites.py` | Deterministic aggregate → `SOUNDBITES.md`. |
| `build-voice-themes.py` | 16-theme curated `by-theme/INDEX.md`. |
| `verify-voice-verbatim.py` | Verbatim gate: substring-checks every soundbite vs source. **A fabrication tripwire, not a style checker** — a low contiguous score reflects legit cleaning (filler-trim / span-joins) IF component phrases exist in-source; a TRUE fabrication has none. |

Gate prompts live in `/tmp/voice-*-gate.txt` during a run (regenerable from this doc + the tool comments).

## 5. Hard-won engineering lessons (obey on any future fan-out)
1. **No-schema for big extractions.** Forcing a StructuredOutput schema makes Sonnet "complete without calling StructuredOutput" on long contexts → the item is dropped, nothing written. Have agents WRITE the file and return plain text; verify on disk.
2. **Shell fan-out stdin trap.** A `while read < list` loop whose child CLIs inherit FD 0 → the children consume the list and the loop dies early (the "input=6" bug). Fix: children `< /dev/null` + loop reads on a dedicated FD (`<&3 … 3< list`).
3. **One big Sonnet/Anthropic workflow at a time.** Concurrent Anthropic fan-outs (incl. across sibling sessions) trip server rate-limiting. CLI team sidesteps this (separate providers).
4. **Idempotency is the cross-session coordinator.** Drivers skip files already produced → two sessions can co-work the same corpus without clobbering (verified 0 collisions).
5. **Privacy is a post-filter, not just a gate.** Deterministic `ip_private` holdback + a HARD-rule grep (Chelsea/names) on the publish-bound outputs catches what the gate's judgment misses.
6. **Verify on disk, not on the orchestrator's self-report.** Filesystem is ground truth.

## 6. Operate / reproduce
- Extract a batch: `MAXJOBS=4 bash tools/voice-cli-extract.sh <basenames-file>` (set `SRC_DIR`).
- Recover firewalled: `bash tools/voice-cli-recover.sh <source-paths-file>`.
- After any pass: `python3 tools/voice-private-holdback.py --apply && python3 tools/build-voice-soundbites.py && python3 tools/build-voice-themes.py && python3 tools/verify-voice-verbatim.py`.
- Collision check: any basename in BOTH `by-session/` and `_NON-TEACHING-INDEX/` → resolve.

## 7. Status at creation (2026-05-31)
Library ~245 reel-ready sessions / ~2,670 soundbites (from an 81/955 baseline) after the CLI-team mastermind+voice-memo sweep; ~291 firewalled sources under Chatham-House recovery (in flight). Confidentiality verified: 0 Chelsea in reel-ready, ip_private held back, 1:1 client material anonymised/approval-gated. Full session detail: `episodic/sessions/2026-05-31-voice-archive-cli-team-buildout.md` + STATE-OF-STACK 2026-05-31 entries.
