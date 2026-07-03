# Crash-Resilience Architecture (M1 / M2 / i7 fleet)

**Status:** Tier-1 doctrine. **Built + verified:** 2026-06-26 (after the M1 OOM hard-hang).
**Owner-question that triggered it (Adrian, 2026-06-26):** *"make this reliable and structurally sound… isn't this the job of the i7 or the M2 to monitor your crash state and fix you if you get broken? So we've got automatic protocols in place that sort these things out."*

---

## 0. The incident this fixes

M1 (64GB) OOM hard-hung overnight and Adrian had to manually reboot. Forensics found a **cascade**, not a single fault:

1. **Both memory guards had been DEAD for 3.27 days.** `mem-sentinel` + `mem-guardian` crash-looped on `OSError(EDEADLK)` because their flock lock lived under the **iCloud-synced** `working/_locks/`. A 2026-06-13 "kickstart" was a band-aid; the lock path was never moved, so it recurred on 06-22 and stayed dead. **The box had zero memory protection when it crashed.**
2. **No admission control.** Two `mlx_whisper` loads + a 30-min full ChromaDB rebuild each grabbed RAM with no central accounting → converged on 64GB.
3. **The guardian couldn't shed the real leaker.** `chroma-mcp` was on a hard DENY list, so the guardian killed the wrong (grind) process while the balloon survived.
4. **Nothing external rescued M1**, and the one witness (i7) was stuck crying-wolf on a stale feed, so a real crash was indistinguishable from the broken feed.

**Root principle learned:** on a unified-memory Mac, **reactive killing is too late** — once you swap, the kernel can't run the killer. The architecture is therefore **prevention-first**, with detection + recovery as the safety net.

---

## 1. The four layers

| Layer | Purpose | Key components | Runs on |
|---|---|---|---|
| **0 — Admission control** | No heavy job starts without headroom; only ONE mlx load fleet-wide | `tools/membudget.py`, `tools/mlx_slot.py` | M1 |
| **1 — Self-protection** | Shed load (incl. restartable "protected" services) before OOM; never hang/crash the guard itself | `tools/mem-sentinel.py`, `tools/mem-guardian.py` | M1 |
| **2 — External detection + remediation** | Independent nodes see M1 die and either auto-restart its guards or page for a reboot | i7 + M2 `lantern-deadman.py`, `tools/heartbeat-fanout-lantern.sh` | i7 + M2 |
| **3 — Recovery** | After a reboot, resume the grind within budget; keep the watchdog roster clean | `tools/boot-reconcile.py`, `tools/overnight-manifest.json`, `tools/watchdog.py` | M1 |

### Layer 0 — Admission control (the structural fix)
- **`membudget.py`** — the single memory-admission authority. `can_admit("heavy", need_gb=6)` gates every heavy job on conservative-available headroom (reuses nightwatch's proven thresholds). CLI: `membudget.py check` → exit 0/70/78 (GO/WAIT/ABORT). Overcommit becomes structurally impossible instead of caught-too-late.
- **`mlx_slot.py`** — the GLOBAL single-slot mutex for mlx/whisper. `with mlx_slot.acquire(...)` around every model load; a second load **blocks** (proven: exit 70 while held). The literal crash mechanism — two mlx loads at once — can no longer happen. Bash wrapper: `mlx_slot.py run --need 6 -- <cmd>`. Burners import it resiliently (no-op fallback if absent on a remote node).
- Locks live under **`~/Library/Application Support/adrianvault/locks/`** (NON-iCloud) — flock under `~/Documents` throws EDEADLK.

### Layer 1 — Self-protection
- **EDEADLK-proof:** guards' locks moved off iCloud; lock acquisition wrapped so a lock error **degrades to no-lock, never crashes** the daemon (the bug that caused the 3.27-day outage).
- **Hang-proof:** each one-shot tick sets a 45s `SIGALRM` watchdog → a hung tick exits clean and launchd respawns fresh. The **heartbeat is written FIRST** in the tick (before the expensive ps scan) so a slow tick under heavy load never starves the beacon.
- **Supervised restart of protected balloons:** when pressure comes from a restartable-but-protected service (`chroma-mcp` / `claude-mem` / RAG server), the guardian now does a **controlled SIGTERM** (they reload on next use) instead of logging "cannot shed" and letting the box die. Truly-never list (live Claude UI, editors, system) is still untouchable.
- **ffmpeg is sheddable** (allowlist) — a runaway 42GB/44-min reel render was observed; restartable renders can be killed as a last resort at EMERGENCY only.

### Layer 2 — External detection + remediation (the answer to "who rescues M1")
- **Producer:** M1 `mem-sentinel` writes `working/state/heartbeat.json` every 60s.
- **Fanout:** `heartbeat-fanout-lantern.sh` scp's it to **BOTH witnesses** every 60s (dual, so a single witness outage doesn't blind detection). The old `$?`-clobber bug (false "SCP_FAIL rc=0" every run) is fixed; the dead-M3 push is repointed to i7.
- **Witnesses:** i7 `lantern-deadman.py` (30s, ntfy topic `av-lantern-deadman-…`) + M2 `lantern-deadman.py` (30s, topic `av-m2-deadman-…`). Each reads the heartbeat **content timestamp** (not file mtime) so a frozen-but-freshly-pushed file is still detected as stale.
- **ARMED remediation (proven live 2026-06-26):** on confirmed staleness the witness SSHes back to M1 and distinguishes:
  - **M1 alive, producer dead** → `launchctl kickstart -k gui/501/com.adrianvault.{mem-sentinel,mem-guardian}` → auto-restarts the guards (the exact 3.27-day failure now self-heals) → pages "guards auto-restarted".
  - **M1 unreachable** → hard-down / OOM-hung → pages "manual reboot needed" (honest: software on another box cannot reboot a kernel-hung Mac).
  - Reverse-SSH keys: i7 reaches M1 via `192.168.1.31`; M2 via `macbook-pro.local` (M2 is on a different subnet + Tailscale was offline). Both keys authorized in M1 `~/.ssh/authorized_keys`.

### Layer 3 — Recovery
- **`boot-reconcile.py`** + **`overnight-manifest.json`** (LaunchAgent `com.adrianvault.boot-reconcile`, RunAtLoad + 600s): after a reboot, reads the manifest of grind jobs and restarts any that should be running **gated through `membudget`** (serialised, within budget) — replaces the "nightwatch stays dead until 22:00" hole. Real jobs are `enabled:false` by default until Adrian populates them.
- **Watchdog roster cleaned:** 5 obsolete watchdogs archived to `tools/_archive/` (dead 2026-05 commissions / sold-M3); `watchdog.py` (the only infra-health monitor, dead 18 days) restored with TCC-safe logs; `team-watchdog.sh` PGID group-kill (killed innocent siblings) fixed; `fleet-aggregator` (cross-node down/hung detector) re-enabled instead of building a 15th watchdog.

---

## 2. What Adrian gets (the before/after)

| If M1… | Before | After |
|---|---|---|
| a daemon dies | dead for days, silently | **self-heals on-box** (EDEADLK-proof + 60s relaunch); i7/M2 also restart it remotely; Adrian paged |
| a memory balloon grows | killed wrong process, box hung | admission control prevents it; guardian sheds it (incl. chroma/ffmpeg) |
| OOM hard-hangs | stuck until Adrian noticed | **prevented** by admission control; if it ever happens, i7+M2 page the phone within ~5 min |
| reboots | grind stays dead | boot-reconcile resumes it within budget |

**The honest limit:** a *hard* kernel hang can freeze M1 so completely that SSH dies — no software on another Mac can reboot it. That's why Layer 0 (never reach the hang) is load-bearing; Layers 2–3 are the net for everything softer (a dead daemon, a panic, a wedged process, a reboot). A true auto-power-cycle would need hardware (a smart plug) — flagged as a future option, not built.

---

## 3. Verify it any time

`/opt/homebrew/bin/python3 tools/reliability-selftest.py` — proves all 7: contracts present · admission gating · mlx mutex blocks · guardian armed · heartbeat advancing (catches the 3-day-dead failure) · lock hygiene (nothing flock'd under iCloud) · both cross-node witnesses fresh. (`--quick` skips the 70s heartbeat-advance wait.)

## 4. Known follow-ups (not blocking)
- M2's Tailscale was offline (last seen 22h) → M2 remediates via Bonjour for now; reconnect Tailscale for the stable route.
- `coord-sync` rsyncs to a stale M2 address (192.168.1.53 vs current 10.0.1.2 / Bonjour).
- `embed_chromadb` needs its launchd interpreter to resolve `chromadb` (a venv, not bare `/opt/homebrew/bin/python3`).
- Reel/video pipeline should adopt `membudget` admission like the transcribers (a sibling's domain).
- Quarantine-tree RAG hygiene (whether `episodic/review/` quarantine holds belong in search) is a separate decision — left out of the photos-path exclusion deliberately.
