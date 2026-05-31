# Cross-Model Automation Protocol

**Status:** ACTIVE — audit-grounded 2026-05-29 (Opus 4.8 / 1M-context, 6-agent workflow audit `wf_a691ad22`).
**Authority:** This is the reconciling source of truth for how Claude, Antigravity, ChatGPT, Grok and Gemini talk to each other and how subscription depth flows into the vault. Where it conflicts with older docs, **this wins** and the older doc must be corrected:
- Supersedes the transport claims in `canonical/concepts/bridge-protocols.md` (the Google Drive courier is RETIRED — GitHub is the live bridge).
- Supersedes the AG-control-reliability framing in `canonical/concepts/hive-architecture-v3.md §5` (the AG CLI/SDK control plane is NOT built; the GUI keystroke feeder is the only live AG driver).
- Narrows/clarifies `canonical/concepts/u-protocol.md` (the cross-model `u` meaning Adrian engineered was dropped — see Backlog T2).

**Last updated:** 2026-05-29T23:55:00+08:00

---

## 0. Why this document exists

Adrian's directive (2026-05-29): *"review all of our system prompts when it comes to automating communications between you and Antigravity, you and ChatGPT MacBook app, and Grok on Google Chrome with your connector… utilise the strengths of the subscription platforms over the APIs… reducing as far as possible human tokens… I think you've missed key points."*

He was right. A grounded 6-agent audit of the actual scripts, plists, logs and the ChatGPT corpus found **one structural disease and eight dropped threads** — including two automations Adrian personally designed and one that was fully built then silently deleted.

This doc fixes the disease's worst symptoms, records the dropped threads so they cannot rot again, states the **honest** capability map (not the aspirational one), and defines the protocol going forward.

---

## 1. The core principle (Adrian's strategy, stated plainly)

> **Lean on the SUBSCRIPTIONS over the metered APIs. Reduce Adrian's manual steps toward zero. Never claim an automation exists when its wiring is dead.**

- The metered APIs (`ask-chatgpt.py`, `ask-grok.py`, `ask-gemini.py`) are easy but (a) cost money per call, (b) cannot reach the subscription-only depth (Deep Research, DeeperSearch, GPT-5.5 Thinking, Gemini Ultra Veo/nano-banana), and (c) can silently fall back to a *worse* model.
- The **subscriptions** (ChatGPT Pro, SuperGrok, Gemini Ultra) carry the real firepower Adrian pays for — and are bridged into the vault, today, by exactly one proven channel: **the GitHub bridge**.
- Therefore the GitHub bridge is the **spine** of cross-model automation and must be treated as critical infrastructure (it was dead for 13 days and nobody noticed — see §2).

---

## 2. The disease: "doctrine claims an automation that isn't wired"

This is Adrian's #1 distrust, and the audit found it is **structural, not incidental**. Five verified instances:

| # | What doctrine claims | Verified reality (2026-05-29) |
|---|---|---|
| 1 | CEO-doctrine §6: a stall fires NUDGE → `com.adrianvault.autoloader` → "AG auto-triggered" | `autoloader_daemon.py` was **demoted to notify-only 2026-05-16** (it only shows a macOS notification). The real keystroker `ui-autoloader.sh` is **not a LaunchAgent** and is **off by default**. So a stall escalates Tier-1→4 + a FORENSIC AUDIT producing handoff files **with nothing listening to type them into AG.** |
| 2 | hive-architecture-v3 §5: an AG 2.0 CLI/SDK "Phase 2 control plane" replaces the keystroke chain | `tools/ag_cli_driver.py` **does not exist.** The pixel-keystroke feeder is the only AG driver, and it still misfires (typed `implement` into a code editor; hit Record instead of Send — STATE-OF-STACK 2026-05-29). |
| 3 | n8n adopted **stack-wide BINDING** 2026-05-02; handoff-alerts-v1 LIVE every-60s 2026-05-06 | **Absent** from AGENTS.md / CLAUDE.md / CEO-doctrine / hive-v3. `infrastructure/n8n/` frozen since 2026-05-06. No decommission record. |
| 4 | `chatgpt-dispatch-protocol.md` documents a built `bin/chatgpt-dispatch.sh` (iPhone/Claude → ChatGPT macOS app, with vault logging) | The **script is deleted**; the doc is still canonical. |
| 5 | `gemini-bridge-live.md` 4h LaunchAgent reads like a Gemini-response bridge | It runs `gemini_bridge_compiler.py` which only **recompiles a context dump** — it never calls Gemini. The actual Gemini Ultra response ferry (`gemini-ferry.py`) is cold/unwired. |

**Plus the spine itself was dead:** the GitHub bridge (`hivemind-sync.sh`) had not completed a clean cycle since **2026-05-16** — a corrupt-packfile + a stale `HEAD.lock` the recovery code never cleaned + the LaunchAgent dropping out of scheduling (almost certainly the 2026-05-26 macOS crash). 22 subscription deposits were stranded for up to 16 days, including the Erica California civil white paper and ChatGPT's own autonomous-hive-architecture reviews. **Repaired + hardened 2026-05-29 (see §6).**

### Three reliability laws that follow from the disease
1. **SENT ≠ ENGAGED ≠ PRODUCED.** The feeder marks a parcel "sent" on keystroke; nothing in the live loop proves AG accepted it or wrote output. Verify/reconcile/quality-gate are all manual post-hoc. (2026-05-29: 4 SENT, 0 files produced.)
2. **Duration is solved; depth is not.** The run-to-end-time fix works, but AG only burns if the **queue has depth** — and filling the queue is a manual operator lever.
3. **Connection state is fluid and under-monitored.** computer-use disconnected mid-audit; the bridge died for 13 days; the Chrome extension + Gemini ferry are asserted from stale memory. The watchdog only watches *AG output* — it was blind to all of these. **Fix: pre-flight every surface before asserting it's live; alarm on staleness (§6).**

---

## 3. The honest routing matrix (capability as it ACTUALLY is)

The one load-bearing rule: **computer-use locks every browser to "read" (screenshot only).** The only autonomous in-browser surface is the **Claude-in-Chrome extension** (`mcp__Claude_in_Chrome__*`). Native apps (ChatGPT Mac app) are "full" tier and drivable by computer-use — but computer-use costs an approval tap per call and can disconnect.

> ✅ **PROVEN OPERATIONAL on ALL THREE 2026-05-30:** Claude drove Adrian's logged-in **Gemini**, **Grok/SuperGrok**, AND **ChatGPT (Plus)** end-to-end via the Chrome extension — navigate → type → submit → extract answer as text — **no paste, no API cost, no taps.** Proof: Gemini named itself; Grok "I am Grok built by xAI"; ChatGPT answered as **GPT-5.5 Thinking** — a model the metered API key CANNOT reach, so this path beats the API for depth, not just cost. This is the no-paste subscription "depth tier" Adrian asked for and the recommended default for cross-model prompting whenever the Mac + Chrome are on and the extension is paired. Step-by-step: `procedural/workflows/chrome-subscription-driving-runbook.md`. Metered API is the headless fallback when the extension is unpaired/blocked. (ChatGPT account is **Plus**, not Pro — Pro-only Deep Research depth is not present, but GPT-5.5 Thinking IS.)

| Target | Best driver TODAY | Autonomy | Hard limits | Still needs a human |
|---|---|---|---|---|
| **ChatGPT Pro** (depth) | GitHub bridge round-trip (paste prompt+Deposit Footer → repo → `hivemind-sync` → vault) | partial | the in-UI paste + connector Confirm is not scripted | paste prompt; press Confirm |
| **ChatGPT Mac app** | computer-use (native "full" tier) | partial | per-call approval tap; can disconnect (did, this session); **no driver script exists** | initial approval; login |
| **ChatGPT / Grok / Gemini web** | Claude-in-Chrome extension (navigate→form_input→get_page_text) | partial | only autonomous web surface; flaky pairing (Yahoo/Max acct, email+code login); **bot-walled SPAs defeat it** | login; CAPTCHA |
| **SuperGrok** (depth) | GitHub bridge (`source: supergrok`, lands in `chatgpt-text/`) | partial | Grok's own push-claims are 100% unreliable — git is the only truth | paste prompt; Confirm |
| **Gemini Ultra** (Veo/nano-banana/deep) | `gemini-ferry.py` human-paste ferry (currently COLD) OR Claude-in-Chrome | manual | ferry is unwired (missing folders + instructions); Ultra is **NOT API-billable** (double-pay if you use the API instead) | paste `@file` into Gemini |
| **Antigravity** | `ag-feeder.py` / `bounce-to-ag-window.sh` (osascript+cliclick keystroke) | partial | **only** driver; misfires on window move; frontmost-or-abort; idle-VSZ crash | start AG; keep it frontmost |
| **Metered APIs** (quick lookups) | `ask-chatgpt.py` / `ask-grok.py` / `ask-gemini.py` | full | $0.10 guardrail; subscription-only depth unreachable; surface-before-spend gate | per-call approval (presidential) |

**Routing rule of thumb:** *Depth → subscription via GitHub bridge (or Chrome extension). Quick factual lookup → metered API one-shot. Bulk execution/build → Antigravity. Image/video → Gemini Ultra app or SuperGrok Aurora, never the metered image API.*

Empirical anchor (2026-05-29): Adrian's **GPT-5.5 Thinking web paste beat the metered gpt-5.4 API** for deep strategy. The subscription is genuinely better for depth — this is why the bridge matters.

---

## 4. The frictionless cross-model protocol (how work flows)

### 4.1 Subscription research round-trip (the spine)
1. Claude drafts a prompt ending in the **Deposit Footer** (verbatim block in `procedural/workflows/chatgpt-grok-bridge-runbook.md` — instructs the model to commit its reply to `SubConAssassin/adrian-hivemind-private/inbox/` with `source:` frontmatter).
2. Adrian pastes it into ChatGPT Pro / SuperGrok / Gemini, runs it (Deep Research / DeeperSearch ON), presses the connector **Confirm**.
3. `hivemind-sync.sh` (LaunchAgent `com.adrian-vault.hivemind-sync`, every 300s) pulls the deposit into `working/external-research-in/chatgpt-text/`.
4. Claude ingests, **verifies via `git` (not the model's "I pushed it" claim — that hallucinates), CEO-filters, and folds into canonical.**

This is the **only proven subscription-ingest path.** Keep it alive. ChatGPT and Grok both land in `chatgpt-text/` (the `grok-text/` folder is legacy-manual — do not route new work there).

### 4.2 Antigravity execution (until the CLI driver exists)
- Unattended/overnight work = **the FEEDER, never a single bounce** (`tools/ag-feeder.py --until HH:MM --restart-every 8`). Many small bounded parcels, one at a time, deterministic output-gated READY-GATE.
- A single `bounce-to-ag-window.sh` is a **supervised nudge only**, not an overnight engine.
- Always: AG frontmost or it silently no-ops; restart AG every ~8 parcels (idle-VSZ crash); reconcile + quality-gate the outputs before trusting them.

### 4.3 The verify-before-trust law (all surfaces)
- Bridge deposits: confirm with `git`, not the model's claim.
- AG completion: confirm the `WRITE TO:` file exists, is non-thin, and passes `ag_verify.py` / `quality-gate.py`.
- "Extension connected" / "AG running": pre-flight with `list_connected_browsers` / `pgrep -fi antigravity` before asserting.

---

## 5. The honest capability bright spot

Cost discipline is genuinely solid and should be preserved as-is: every metered tool hard-refuses >$0.10 without `FORCE_API_OVERRIDE=1`; `gemini-image.py` hard-guards metered image spend; the surface-before-spend hook fires reliably. **The weakness is on the reliability/wiring axis, not the spend axis.** Do not "fix" the guardrails.

---

## 6. What changed tonight (2026-05-29, implemented + verified)

1. **GitHub bridge REPAIRED.** Ran `hivemind-sync.sh` manually → pulled **22 stranded deposits** (13–16 days behind); `chatgpt-text/` 19→41 files; state.json green. Reloaded the `com.adrian-vault.hivemind-sync` LaunchAgent → cadence restored.
2. **Bridge hardened against the root cause.** `hivemind-sync.sh §3` rewritten to clean **all** stale `.git` locks (`HEAD.lock`, ref locks, `packed-refs.lock`) — not just `index.lock`. The unhandled stale `HEAD.lock` was the 2026-05-18 wedge. (bash-3.2 safe.)
3. **`ask-chatgpt.py` fallback bug FIXED** (tonight's confirmed failure). Tiered fallback now degrades an unavailable model to the **best available** (`gpt-5.4`) on the same Responses API — never silently to a worse `gpt-4.1`. Fallback now prints a **loud stderr warning**. `DEFAULT_MAX_TOKENS` 1500→4000 (the old cap truncated budgeted answers).
4. **This protocol document** created as the reconciling authority.

(Doctrine reality-stamps on hive-v3 §5, CEO-doctrine §6, and the README Grok-routing line accompany this — see the commit / STATE-OF-STACK entry.)

---

## 7. Recovered dropped threads — the anti-rot backlog

These are the "key points Adrian missed." Each is verbatim-grounded in the corpus. **Status is tracked here so they cannot silently die again.** Ordered by leverage.

| ID | Thread | Adrian's ask (grounded) | Status | Next action |
|---|---|---|---|---|
| **T1** | **Auto-summary-every-chat → bridge** | "every chat I have with you, a summary is kept up-to-date in the hive mind… Claude scans that file, retrieves it and actions it" (2026-04-19, 2026-04-20) | NOT built. Transport now exists (repaired bridge). | Add a standing ChatGPT Custom-Instruction/Project that appends a 1-screen delta to `inbox/` at each chat's end; existing `hivemind-sync` ingests. **S-effort, low-risk. The single biggest frictionless win.** |
| **T2** | **Cross-model `u` trigger** | "all I want to do is type U… you will execute the bridge read immediately" — set in ChatGPT Custom Instructions (2026-04-22) | DRIFTED. `u-protocol.md v2.0` narrowed `u` to Claude+AG; the ChatGPT meaning was dropped. | Restore the ChatGPT-side `u = read bridge + execute` block, OR explicitly retire it in `u-protocol.md`. Decide; don't leave it split. |
| **T3** | **AG CLI/SDK driver** (`ag_cli_driver.py`) | hive-v3 §5: replace the keystroke chain | ASPIRATIONAL, unbuilt. **The one genuine decision — see §8.** | Time-boxed spike (Adrian-gated). |
| **T4** | **ChatGPT Mac app driver** | "leave my MacBook on… execute a prompt… on my MacBook" (2026-04-19/20) | NOT built (computer-use can drive it; no skill operationalises it). | Build a supervised computer-use skill: open app → type prompt+footer → toggle Deep Research → press Confirm → poll bridge. M-effort. |
| **T5** | **Claude-in-Chrome for grok.com / gemini.google.com** | the autonomous, zero-API-spend way to pull SuperGrok/Gemini depth | NOT operationalised (extension exists, asserted-connected). | Short runbook: `list_connected_browsers` (step 0) → navigate → form_input → get_page_text → Write; fallback to GitHub/ferry when bot-walled. M-effort. Verify pairing first. |
| **T6** | **Gemini Ultra ferry** (`gemini-ferry.py`) | the $0-marginal Ultra channel (Veo/nano-banana/deep) | BUILT-but-COLD (missing `_instructions` + queue/responses/archive folders). | Revive (create folders + instructions + one canary round-trip) OR formally retire and waive the Ultra-first doctrine for text. M-effort. |
| **T7** | **One shared remote MCP for both ecosystems** | "the most strategically important medium-term point" (ChatGPT, 2026-04-15) | NOT done. `adrian-vault-rag` MCP exists but is Claude-only. | Expose a firewall-safe slice of the vault RAG as a remote MCP so ChatGPT/Grok read canonical state directly (no paste). M-effort, gated to working-internal content. |
| **T8** | **n8n / Goose / Codex execution layers** | n8n stack-wide (BINDING, abandoned); Goose subscription-as-provider headless; Codex Room-3 pilot slot | DROPPED / never piloted. | Doctrine decision: revive or formally decommission n8n + the HIVEMIND iCloud bridge + `chatgpt-dispatch.sh` (stamp SUPERSEDED). Pilot Goose/Codex only after T3. |

---

## 8. The one genuine decision for Adrian

> **RESOLVED 2026-05-30 — all three engines have PROVEN headless CLIs; the AG keystroke feeder is obsolete.** No `ag_cli_driver.py` needed — Google shipped it. All three tested live on Adrian's subscriptions, $0/sub-billed, no GUI, no keystrokes, no taps:
> - **Antigravity / Gemini** → `agy -p "<prompt>"` (Antigravity 2.0 CLI v1.0.3 at `~/.local/bin/agy`, already authed via the IDE's Google login, runs **Gemini 3.5 Flash**). Flags: `--dangerously-skip-permissions`, `--continue`/`-c`, `--conversation`, `--add-dir`, `--sandbox`, `--print-timeout`. Install: `curl -fsSL https://antigravity.google/cli/install.sh | bash`. **THIS REPLACES THE ENTIRE cliclick KEYSTROKE FEEDER** — the single biggest reliability win in the stack.
> - **Grok** → `~/.grok/bin/grok -p "<prompt>"` (SuperGrok, **Grok 4.3**) — `--effort max`/`--agents`/`--best-of-n`/`--output-format json`/`--mcp`/worktrees. Auth: `~/.grok/auth.json` (device-code, driven via Chrome).
> - **ChatGPT** → `codex exec "<prompt>"` (ChatGPT **Plus**, **GPT-5.5**) — `--skip-git-repo-check`, `-m model`, `--sandbox`, MCP. Auth: `~/.codex/auth.json` (browser OAuth, driven via Chrome).
>
> The §8 decision below (spike an AG CLI?) is **RESOLVED: it exists and works.** Remaining work is *migration*, not a spike: route AG execution through `agy -p` (one parcel = one `agy -p` call, capture stdout, verify) and retire the keystroke feeder + its watchdog/nudge/autoloader scaffolding. Keep the feeder as a 30-day fallback per standard migration discipline. **Cross-model verification is now trivial too:** use `codex exec`/`grok -p` to adversarially fact-check `agy` output against its cited sources — finally a real Tier-3 truth-judge (the one that's been a stub).

Everything in §6 is done. Everything in §7 except **T3** is CEO-decidable and will be sequenced without needing Adrian. **T3 is the one real fork**, because it is L-effort, explicitly Adrian-gated in hive-v3 §5, and carries real uncertainty (AG 2.0's CLI/SDK prompt-injection + headless filesystem access is asserted-but-unproven; observation 5228 flags sandbox restrictions).

**Recommended:** authorise a **time-boxed spike** (not a full migration) — one throwaway commission driven end-to-end via the AG CLI/SDK to prove programmatic prompt-injection + headless write, **keeping the keystroke feeder as the live engine until the spike passes.** If it works, migrate with the feeder as a 30-day fallback. If the spike fails, we keep hardening the feeder and stop pretending the control plane is coming.

This is the single highest-leverage reliability move in the stack: it would eliminate the GUI-keystroke fragility class that recurs across the whole AG layer.

---

## 9. Reliability invariants (standing rules for every agent)
- **Pre-flight before asserting "live":** `pgrep -fi antigravity`; `list_connected_browsers`; check `hivemind-sync.state.json` `last_run` freshness.
- **Bridge staleness alarm:** the watchdog now alerts if `hivemind-sync.state.json.last_run` is older than ~30 min (added 2026-05-29) — so a dead spine is caught in minutes, not 13 days.
- **AG: feeder not bounce; `--restart-every 8`; reconcile + quality-gate before trusting; AG frontmost or it no-ops.**
- **Bridge: GitHub is the live transport. Drive courier is RETIRED. ChatGPT+Grok → `chatgpt-text/`. Verify with `git`, not model claims.**
- **Metered API: subscription-first; one-shot; surface-before-spend; degrade to the best available model, never a worse one.**

---

## 10. Shipped implementation (2026-05-30) — the "migrate + verify" build

Two tools retire the fragile keystroke feeder and finally fill the Tier-3 truth-judge. Both built + tested live 2026-05-30.

**`tools/ag_cli_dispatch.py` — headless AG dispatch (replaces the cliclick feeder).**
- `python3 tools/ag_cli_dispatch.py --prompt "<task, incl. WRITE TO: path>" --output <path>` → runs `agy -p … --dangerously-skip-permissions --add-dir <vault>`, captures stdout, verifies the output file (PRODUCED ≥300 B / THIN / MISSING; exit 0/3/4).
- `--parcel <file>` reads prompt + `output_path`/`WRITE TO:` from an existing feeder parcel (drop-in).
- `--verify codex|grok` chains a cross-model fact-check on the output (exit 5 if fabrications).
- PROVEN: `agy` did the work + wrote a vault file headless in 18.5 s, rc=0, verified. No GUI, no coordinates, no frontmost requirement, no idle-crash.

**`tools/cross_verify.py` — cross-model truth-judge (the real Tier-3).**
- `python3 tools/cross_verify.py --content <file> --sources <file|dir|glob> --verifier codex|grok` → a DIFFERENT model fact-checks every verifiable claim against the sources; JSON verdict; exit 5 if `fabrications_found`.
- PROVEN: codex (GPT-5.5) caught both planted fabrications (a fake testimonial + a fake "$24,997 Founder tier / 50 spots") and passed the 2 real claims.
- Run it on AG's generative output (AG/Gemini writes → codex/grok verifies) — catches invented testimonials/pricing that the form-only Tier-1 verifier misses by design.

**Migration:** point AG parcels at `ag_cli_dispatch.py --verify codex`; once a few real parcels run clean, retire `ag-feeder.py` / `ag-feeder-multi.py` + the watchdog/nudge/autoloader scaffolding (keep as a 30-day fallback per migration discipline). This is the end of the keystroke era.

## Revision history
- **2026-05-29** — Created from the 6-agent cross-model automation audit (`wf_a691ad22`). Repaired + hardened the GitHub bridge, fixed the `ask-chatgpt.py` fallback bug, recovered 8 dropped threads, established the honest routing matrix. Reconciling authority over `bridge-protocols.md` (transport) and `hive-architecture-v3.md §5` (AG control reliability). — Claude (Opus 4.8, CEO)


---

## Workflow orchestration reliability + 3-CLI team leverage (appended 2026-05-31)
*Validated by a live GPT-5.5 (codex) + Grok-4.3 (grok) + Gemini (agy) consult — all $0 subscription CLIs, all responded richly in ONE parallel ~5-min call with no throttling. The 3-CLI team is a fast, free, robust collaborative resource — lean on it heavily.*

### Multi-agent fan-out reliability (Claude Workflow tool) — two failures hit + fixed + team hardening
- **Serialize big batches.** Two large Sonnet workflows concurrently → provider rate-limit → agents fail "completed without calling StructuredOutput". Run ONE big fan-out at a time. Stage concurrency 2-4 → semaphore + full-jitter exponential backoff; if success-rate <92%, halve concurrency 5 min; client token-bucket ~80% of tier.
- **File-write, not big returns.** Agents returning large structured payloads (many long quotes) fail to emit. Workers WRITE artifacts to files + return a TINY envelope `{job_id,status,output_path,counts,errors_path}`.
- **Separate extraction from synthesis.** Workers extract grounded facts→files; a later reader synthesizes from compact normalized outputs. Don't make fan-out workers discover+quote+reason+write-prose in one job.
- **Shard by TOKEN budget, not item count.** Keep each worker's structured output small (<~800 tokens); long extraction = many small jobs, not one heroic job.
- **Idempotency + content-addressable checkpoints.** Hash task payload → UUID; skip if `checkpoints/[UUID].json` exists → resume-on-failure is free, zero waste. Tiny JSONL ledger {task_id,status,model,started,completed,output_path}; on crash replay only pending/stuck-too-long.
- **Tolerant fan-out + dead-letter queue.** Quorum threshold (proceed at ~85% success); failed tasks → quarantine/DLQ, re-route to a DIFFERENT model or delayed retry — never abort the whole batch on one failure.
- **Workflow-tool specifics:** `args` does NOT bind reliably inside the script — INLINE the data array. `timeout` cmd is absent on macOS — use the Bash tool's own timeout param.

### The 3-CLI team — division of labour (consensus of all three)
- **Gemini (`agy -p`) = bulk Cartographer** — fast long-context ingestion, whole-dir scans, dedup, timelines, first-pass reduce. Reduce, then hand off.
- **GPT-5.5 (`codex exec`) = structured Assembler/arbiter** — best schema adherence, code, strict JSON, final compile + tie-break.
- **Grok-4.3 (`grok -p`) = adversarial Inquisitor** — least sycophantic; "what's actually true / where's it fragile"; gap-analysis. NOT first-draft on messy input. (grok = grok-build coding agent; frame "advisory/writing task, no tools".)

### Ensemble patterns that beat single-model (use for anything canonical / decision-grade)
- **Triangulation:** Gemini draft/reduce → Grok refute (gap-analysis vs sources) → GPT-5.5 synthesize/arbitrate → Claude final. The three failure modes (hallucination / over-structure / shallow reasoning) are poorly correlated across providers, so the ensemble cancels them.
- **Consensus routing:** run 2 in parallel; agree → auto-approve; diverge → 3rd as tie-breaker.
- **When:** ≥2 models for anything promoted to canonical or driving a costly decision; solo/Gemini-only for mechanical/low-stakes.
- **Prompt discipline:** schema + failure-modes up front; "output only the JSON, no prose"; embed a self-critique ("before emitting, list the top 2 ways this is wrong"); temp 0-0.2 for verification.
- **Posture at $0 marginal cost:** over-verify until residual risk is acceptable — do NOT optimise for speed.

---

## §11. Reliable headless CLI invocations (2026-05-31 — the team-reliability fix)

All three subscription CLIs had distinct headless bugs; all fixed + wrapped in **`tools/cli-ask.sh <codex|grok|agy> [--timeout N] "prompt"|--stdin`** (the canonical reliable interface). Principle (Adrian): *a flaky team member is a bug to FIX, never a thing to route around; confirm real content (not 0–1 bytes) before "done."*
- **codex** (`codex exec`) blocks on stdin → hangs → alarm-dies at 0 bytes → fix: **`</dev/null`**.
- **grok** returns EMPTY on long `-p` args → fix: **`grok --prompt-file <PATH>`** (+ `</dev/null`); short `-p` is fine.
- **agy/Gemini** writes the full answer to a brain-dir artifact + prints only a summary → **`tools/agy-ask.py`** runs it under a PTY + `--dangerously-skip-permissions` AND parses the printed `file://…/brain/….md` path to append the full artifact.

### §11.1 Hardened + acid-tested + the reliability loop (2026-06-01)

`tools/cli-ask.sh` is now hardened and **`tools/cli-ask-selftest.sh` is its adversarial regression suite** (16 probes — empty/whitespace/unknown-model guards · metacharacter-as-data · 200KB prompt · timeout→124 · missing-binary-not-silent · empty/thin→exit 3 · retry-recovers · concurrency · agy PTY wiring · 3 live calls — **16/16 green**).

Guarantees beyond the per-CLI fixes: exit-0-but-empty/thin (<20 non-space bytes) → **exit 3** (never a silent pass) · **one bounded retry** on flake · hard timeout → **124** · missing binary → non-zero (was a silent 0; fixed via `exec … or exit 127`) · prompt passed as **data** (never eval'd) · binaries **env-overridable** (`CLI_ASK_CODEX`/`CLI_ASK_GROK`/`AGY_BIN`). Exit contract: `0` ok · `2` usage · `3` thin-after-retries · `124` timeout · else = the CLI's own code.

**THE RELIABILITY LOOP** (Adrian, 2026-06-01 — applies to the shipped product too, not just the CLIs): adversarial self-test → break it → fix → keep as a **permanent regression gate** → re-run on every change → **add each new field-failure as a new probe**. `bash tools/cli-ask-selftest.sh [--live]`. Recommended: wire it into the periodic `hive-ci` sweep so the harness is re-verified automatically.
