---
title: Fleet Presence Protocol — M1 PRESENT/GRIND Modes + Fleet Role Map
type: doctrine
status: active
tier: 1
firewall_class: working-internal
version: 1.0
created: 2026-07-21
last_updated: 2026-07-21
authored_by: claude
related:
  - canonical/concepts/claude-ceo-operating-doctrine.md
  - canonical/concepts/delegation-first-operating-doctrine.md
  - multi-machine-infrastructure (memory)
  - tools/fleet-mode.py
  - tools/fleet-mode.sh
  - working/state/fleet-mode.json
  - tools/pipeline/node-cloud-pipeline.py
purpose: |
  Standing doctrine for every Claude session (and every node in the fleet)
  covering when the M1 MacBook is Adrian's personal workstation vs a grind
  node, how that boundary is set and enforced, and which node owns which
  duty across the 5-node fleet. Mechanised 2026-07-21 — this is not a
  policy of intent, it is the operating manual for a real, running
  mechanism (tools/fleet-mode.py + a LaunchAgent scheduler).
---

# Fleet Presence Protocol

## 1. The problem this solves

The M1 Max MacBook 64GB is BOTH Adrian's personal workstation AND, by
default, a fleet grind node (it runs a real transcription shard —
`com.adrianvault.cloud-pipeline`, shard 3 of the fleet's shard space —
plus `com.adrianvault.m1-audio`). Those two roles compete for CPU, RAM,
fan noise, and thermal headroom. Before 2026-07-21 this was managed by
ad-hoc memory — a Claude session would sometimes remember to throttle
grind when Adrian was working and sometimes wouldn't. Adrian's instruction
2026-07-21 was explicit: **stop depending on ad-hoc memory — mechanise it,
and Claude orchestrates it.**

## 2. The two modes

**PRESENT** — M1 is Adrian's, full stop. Both M1 grind LaunchAgents
(`com.adrianvault.cloud-pipeline`, `com.adrianvault.m1-audio`) are
**booted out** (not just paused — fully unloaded via `launchctl bootout`,
so `KeepAlive=true` on the pipeline plist does not resurrect them). The
other four nodes (M2 Studio, i7, m4 mini, PC) are unaffected and continue
grinding as normal.

**GRIND** — M1 rejoins the fleet as shard 3/5. Both agents are
**bootstrapped** (`launchctl bootstrap`; `RunAtLoad=true` on both plists
means bootstrap alone starts them). M1 competes for its own resources
like any other grind node — this is the correct state when Adrian is
out or asleep.

State lives at `working/state/fleet-mode.json` — modeled on the
`ag-automation.sh` pause-flag convention already standard in this vault
(a small file every consumer reads at the top of its cycle, not a
database). Fields: `mode` (`present`|`grind`), `set_by`
(`adrian`|`claude`|`schedule`), `set_at` (ISO8601, **always +08:00 WITA,
never bare UTC** — this file and every timestamp in it is WITA by
convention), `reason` (free text), `until` (ISO8601 +08:00 or `null` —
for a manual flip, once `until` passes the scheduler treats the override
as expired and reverts to the default window; `null` persists until
explicitly changed again).

## 3. The default schedule

**00:00–09:00 WITA = GRIND by default. Outside that window = PRESENT by
default.** This is Adrian's own stated reliable-free-window, not a
guess. The scheduler (`~/Library/LaunchAgents/com.adrianvault.fleet-mode-scheduler.plist`,
`StartInterval=600` — every 10 minutes, plus `RunAtLoad`) calls
`tools/fleet-mode.py auto-check`, which:

1. Checks for an active manual override (`set_by` = `adrian` or `claude`
   with `until` still in the future, or `until=null`) — if one is active,
   the schedule is skipped entirely and the mechanism just self-heals
   agent state to match whatever mode is currently set (covers the case
   where a LaunchAgent crashed or was manually `launchctl`'d outside the
   tool).
2. If no override is active, computes the default mode for the current
   WITA hour and flips state + enforces agents if it differs from the
   live mode.
3. GRIND→PRESENT at the 09:00 boundary always applies immediately — no
   interlock needed, handing the machine back to Adrian is always safe.
4. PRESENT→GRIND at the 00:00 boundary goes through the idle interlock
   (§4) first.

## 4. The idle interlock — why it exists

An **auto-scheduled** flip from PRESENT into GRIND must never yank the
machine out from under Adrian mid-use just because the clock crossed
midnight. Before any *scheduled* PRESENT→GRIND flip, the mechanism reads
M1's real human-input idle time via `ioreg -c IOHIDSystem` HIDIdleTime
(nanoseconds). If idle time is **under 300 seconds (5 minutes)**, Adrian
is judged actively at the machine: the flip is deferred, logged, and
re-checked on the next 10-minute cycle. If the idle read itself fails
(`ioreg` error, unparseable output), the mechanism fails safe — it does
**not** flip, and logs the failure. The interlock exists ONLY on the
auto-scheduled PRESENT→GRIND path.

**A manual flip bypasses the interlock entirely.** If Adrian says he's
going out, that is honoured immediately regardless of what the idle
clock says — see §5.

## 5. How Adrian triggers a manual flip — exact commands + trigger phrases

Exact CLI (either form is equivalent; `.sh` is the wrapper pinned to the
FDA-cleared interpreter `tools/rag/.venv/bin/python3`, matching the
proven fix already used for `cloud-manifest`/`vaultmap` — always prefer
the `.sh` wrapper in any headless/scripted context):

```bash
tools/fleet-mode.sh grind   [--until HH:MM] [--reason "TEXT"] [--by adrian|claude]
tools/fleet-mode.sh present [--reason "TEXT"] [--by adrian|claude]
tools/fleet-mode.sh status
```

**Trigger phrases a Claude session MUST treat as "flip to GRIND now"** —
these are natural-language statements, not literal commands, and a
session must act on the intent, not wait for Adrian to type the CLI
himself:

- "I'm going out" / "heading out" / "I'll be out for a bit/couple hours"
- "I'm going to bed" / "going to sleep" / "I'm off to sleep"
- "let it grind" / "let the fleet grind" / "put M1 on the grind" /
  "reallocate M1" / "M1 can grind now"
- Any statement that Adrian will be away from the machine for a
  identifiable-or-estimable stretch, even if he doesn't say "grind"

**Trigger phrases for "flip to PRESENT now":**

- "I'm back" / "I'm at the machine" / "I need M1"
- "I'm working on the M1" / starting a session where Adrian is visibly
  interactively engaged and the machine feels sluggish
- Any statement that contradicts an active GRIND override (e.g. Adrian
  says he's about to do focused work while GRIND is still set)

**What a Claude session MUST do on hearing a trigger phrase, immediately,
without being asked twice:**

1. Run `tools/fleet-mode.sh grind --reason "<what Adrian said>" --by adrian
   [--until HH:MM if he gave a timeframe]` (or `present` for the return
   trigger). Always pass `--by adrian` when the instruction came directly
   from Adrian in chat, not `--by claude` — `--by claude` is for a Claude
   session flipping the mode on its own initiative (e.g. correcting drift),
   which should be rare and always logged with a clear reason.
2. If Adrian gave an estimate ("a couple hours," "back by 9") convert it
   to `--until HH:MM` so the mechanism self-reverts even if nobody
   remembers to flip it back. If he gave no estimate, leave `--until`
   unset (`null` — persists until explicitly changed).
3. Read back the CLI's own confirmation output (it prints the mode,
   reason, expiry, and per-agent enforcement result) — do not claim
   success without having seen this.
4. Do NOT ask Adrian for permission first. The stated instruction IS the
   authorization — this is a routine operational flip, not a decision
   requiring the §8 CEO-doctrine protocol-question pattern.

## 6. Fleet role map (post-migration, 2026-07-21)

| Node | SSH alias | Role | Grind participation |
|---|---|---|---|
| M1 Max MacBook 64GB | local | Adrian's workstation. Fleet's **LARGE-model seat** during grind windows — the only node with enough unified memory for a ~70B-class quantized model (higher quality, slower, ~10 tok/s). Orchestrator (Claude runs here). | Shard 3/5, PRESENT/GRIND-gated per this doctrine — the only node whose grind participation is conditional |
| M2 Max Studio 32GB | `ssh studio` | Headless, always-on. **Grind orchestrator** — per Adrian's stated protocol, M2 is the node that should be managing i7 + m4 mini + PC so M1 doesn't have to reconfigure the rest of the fleet when it steps in/out of PRESENT. (Orchestrator role is a standing designation; the steal-based sharding already means no active reshard command is needed when M1 leaves — see §7.) | Always grinding, own shard, unconditional |
| i7 Intel MacBook 2014 16GB | `ssh i7` | Specialist offload — CPU transcription, ffmpeg encode, janitor/backup-staging. No Metal/MLX, cannot run local LLM inference. | Always grinding, own shard, unconditional |
| M2 Pro Mac mini 16GB | `ssh m4` | GPU transcription node (mlx). | Always grinding, own shard, unconditional |
| Windows RTX 5080 PC | `ssh pc` | Fleet's **FAST-model seat** — Qwen3.5-9B at ~135 tok/s on the RTX 5080, llama-server OpenAI-compatible endpoint. CUDA transcription shard also live. | Always grinding once the shard 4/5 wiring is confirmed, unconditional |

All five nodes on Tailscale. Vault at
`/Users/adriantaffinder/Documents/Adrian-Vault` is M1-local and canonical
— every other node mounts or pulls, never treats its own copy as source
of truth. Never auto-sync the state kernel (`events.jsonl`,
`STATE-OF-STACK.md`, `fleet-mode.json`) across machines via
iCloud/Dropbox — documented drift bomb.

## 7. Why M1 stepping out of GRIND needs no fleet-wide reshard

Verified directly against `tools/pipeline/node-cloud-pipeline.py`
(2026-07-21, not assumed): `STEAL_ENABLED=1` in the real
`cloud-pipeline.plist`. Each node computes
`shard_of(stem) = md5(stem) % NUM_SHARDS` for its own claimed pool, then
also works an "other" (steal) pool once its own shard drains. The moment
M1 stops claiming shard 3 (agents booted out), the remaining four nodes'
steal logic picks up shard-3 items automatically as part of their normal
cycle. **`fleet-mode.py` therefore only ever needs to start/stop the two
M1-local LaunchAgents — it never needs to touch `NUM_SHARDS` or push a
reshard command to the other four nodes.** This was proven by code-path
inspection, not just asserted.

## 8. Two seats, not competitors — M1 (LARGE) vs PC (FAST)

During a GRIND window, the fleet has two distinct local-LLM-inference
seats and they are not interchangeable:

- **M1 (LARGE seat):** 64GB unified memory is enough headroom to run a
  ~70B-class quantized model. Higher quality reasoning, slower —
  roughly **~10 tok/s**. Use for: anything where output quality/reasoning
  depth matters more than latency (synthesis, judgment-adjacent batch
  work, anything that would otherwise queue for a premium Claude call).
- **PC (FAST seat):** RTX 5080 16GB VRAM running Qwen3.5-9B-Q4_K_M,
  measured **~135 tok/s** generation (verified via live cross-machine
  call from M1, not just local benchmark — `http://100.102.175.8:8080`,
  OpenAI-compatible `/v1/chat/completions`). Use for: high-volume,
  low-reasoning grunt work where throughput matters more than depth —
  classification, extraction, first-pass triage, anything in the
  §1b MODEL-ROUTING LAW "never on premium tokens" category that can run
  local instead of burning a team CLI call.

Route work to whichever seat's tradeoff fits the job. Do not default
everything to one seat because it's "the good one" — that's the same
mistake as routing everything to Opus. The PC seat has **no API
key/auth configured** as of 2026-07-21 (LAN + Tailscale range only,
firewall-scoped, not open internet) — flag to Adrian before treating it
as a hardened production endpoint.

## 9. What is built vs what is designed intent (as of 2026-07-21)

**Built and verified live:**
- `working/state/fleet-mode.json` state file
- `tools/fleet-mode.py` — full CLI (`status`/`grind`/`present`/`auto-check`)
- `tools/fleet-mode.sh` — FDA-cleared-interpreter wrapper
- `com.adrianvault.fleet-mode-scheduler` LaunchAgent — 10-min auto-check,
  confirmed ticking and reading vault state headlessly with zero TCC errors
- `mem-guardian.py` mode-awareness — widens its EMERG/CRIT/WARN thresholds
  automatically when `fleet-mode.json` reads GRIND (present-mode
  thresholds are byte-identical to pre-change, verified by diff)
- The idle interlock, the schedule boundary logic, the real
  bootstrap/bootout enforcement path — all unit- and live-tested (see
  the 2026-07-21 build session for the specific test log; not repeated
  here since this file is doctrine, not a build log)

**Designed intent, not yet a standalone script:** M2 Studio's role as
"grind orchestrator" for i7 + m4 mini + PC (§6) is a standing
designation per Adrian's stated protocol and is functionally already
true via the steal-based sharding (§7) — but there is no dedicated
M2-side orchestrator script that actively commands the other three nodes
today. If that gap ever needs closing (e.g. per-node health checks,
active reshard on a genuine node failure rather than passive steal),
build it on M2, not M1, and update this section when it lands.

**Never live-tested during the 2026-07-21 build, by deliberate
instruction:** the real PRESENT→GRIND flip of the real M1 agents was not
exercised live (only a disposable substitute LaunchAgent was used to
prove the code path). The mechanism's first real autonomous flip happens
on its own after 00:00 WITA per its own design — **check
`tools/fleet-mode.sh status` and `~/Library/Logs/adrianvault/fleet-mode.log`
the morning after this doctrine is first read** to confirm the first
live auto-flip landed cleanly, and strike this paragraph once confirmed.

## 10. Standing blocker (as of 2026-07-21)

M2's SSH public key
(`ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTzTKVSv+FvLOYj24rkP1M8A1LP3ebUIZz7S2c/uC6F m2-witness-remediation`)
is not yet in the PC's `authorized_keys`
(`%USERPROFILE%\.ssh\authorized_keys` on `DESKTOP-G882Q54`,
`desktop-g882q54.tail51f5fb.ts.net`, user `USER`). M1→PC SSH works; M2→PC
does not, which matters for the M2-as-orchestrator designation in §6.
Remediation is a one-line append to that file on the PC — a security-ACL
change on a remote system, deliberately not made unilaterally. Flag to
Adrian or action it in a session with direct PC desktop access. Strike
this section once resolved.

## 11. When this doctrine is wrong

If a Claude session reads this and finds it conflicts with what Adrian
just said, current instructions win — the mechanism reads
`working/state/fleet-mode.json` first regardless of what this doctrine
says the default should be, because live state always beats a doc.
Update this file, bump version, add a revision_history line, continue.
This is doctrine, not law — it evolves with operating experience, same
as `claude-ceo-operating-doctrine.md`.

---

revision_history:
- 2026-07-21 — created (Adrian-direct, 2026-07-21 20:3x WITA session): mechanised the PRESENT/GRIND boundary after Adrian's explicit instruction to stop depending on ad-hoc memory. Documents `tools/fleet-mode.py` + scheduler LaunchAgent + mem-guardian mode-awareness, the 00:00-09:00 WITA default window, the idle interlock, the manual-flip trigger-phrase contract, the 5-node role map, the M1-LARGE/PC-FAST two-seat split, and the standing M2→PC SSH-key blocker.

— Claude, CEO of the stack, 2026-07-21
