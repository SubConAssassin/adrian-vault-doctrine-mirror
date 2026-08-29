---
title: M1 Post-Reboot Systems Check — What Must Come Back, What Must Not
type: protocol
status: active
tier: 2
firewall_class: working-internal
version: 1.0
created: 2026-08-18
last_updated: 2026-08-18
authored_by: claude
related:
  - canonical/concepts/crash-resilience-architecture.md
  - canonical/concepts/fleet-presence-protocol.md
  - canonical/concepts/overwatch-daemon-operations.md
  - canonical/concepts/shutdown-protocol.md
  - canonical/concepts/lessons-learned.md
  - AGENTS.md (§7.1 Requested-Notification Registry)
purpose: |
  The standing answer to "I've rebooted the M1 — is everything back up?"
  Restarting everything that was running is the WRONG default: part of the
  roster is supposed to be down, and one class of it must never be revived
  automatically. This protocol separates the three cases and ships a
  read-only script that reports without changing anything.
---

# M1 Post-Reboot Systems Check

## 1. Why "restart what was running" is the wrong instinct

A reboot tempts an operator (or an agent) to restore the previous process list
wholesale. On this fleet that is wrong three times over:

1. **PRESENT mode means grind agents SHOULD be down.** Per
   `fleet-presence-protocol.md`, outside the 00:00–09:00 WITA window the M1 is
   Adrian's workstation and both `com.adrianvault.cloud-pipeline` and
   `com.adrianvault.m1-audio` are deliberately `bootout`'d. Seeing them absent
   at midday is **correct state, not a fault.** Restarting them steals the
   machine back from Adrian and the other four nodes pick up shard 3 anyway via
   steal logic (§7 of that doctrine) — so there is nothing to rescue.
2. **The AG supervisor stack must never be auto-restarted.** `ui-autoloader` /
   `burn-watchdog` / `hive-supervisor` are governed by the HARD rule
   `feedback-ag-down-may-be-intentional.md`. They re-arm only on Adrian's word,
   via `tools/ag-automation.sh resume`.
3. **Some plists are renamed-disabled for cause.** Per LL-2026-07-16-001 the
   convention for retiring a job is renaming its plist
   (`.disabled-YYYYMMDD-…`), precisely because `bootout` alone lets a job
   silently reload. Reviving one blindly reintroduces the incident that
   retired it — `cloud-manifest` overwriting the priority manifest with a
   17,904-file dump is the worked example.

So the check is a **three-way classification**, not a restart sweep:
**should be up · should be down · must not be touched.**

## 2. Check uptime first

LL-2026-08-01-018: when background work has gone silent, `uptime` explains
total silence far more cheaply than reading the script for bugs — and it
immediately tells you whether the real fix is "make this supervised" rather
than "debug this." A launchd-managed job resumes at boot; a manually
`nohup`'d one does not. That distinction is the whole diagnosis.

## 3. What does not self-heal across a reboot

- **`/tmp` is wiped.** `overwatch-daemon-operations.md` flags this explicitly:
  `/tmp/rode_rec_override.txt` (the Bonjour bypass) must be re-written by hand
  after any restart, and `/tmp/overwatch_state.json` is gone. Only relevant if
  the Rode Rec lane is still in use — check before restoring it.
- **Claude Code native scheduled tasks** (`osb-order-monitor`,
  `m2-ultra-192gb-watch`, `ss-mastermind-growth-monitor`) have **no independent
  daemon** — they run only while the app is open and self-heal on next launch
  (LL-2026-08-12-003). Adrian's decision on 2026-08-12 was to **accept this;
  no system-level backstop was built.** Do not re-propose that fix without a
  new triggering event — it is a settled tradeoff, not an open bug.
- **`boot-reconcile`** (`RunAtLoad` + 600s) is the thing that *is* supposed to
  bring grind back within `membudget`. If it did not run, that is the finding.

## 4. Two launchctl gotchas the remediation must respect

- **`kickstart -k` fails on a fully `bootout`'d job**, returning
  `Could not find service … in domain for user gui: 501` and silently doing
  nothing (LL-2026-07-17-004). Any restart path must be
  `kickstart -k … || bootstrap …`.
- **"Loaded" ≠ "working."** A job that `RunAtLoad`'d and immediately died still
  appears in `launchctl list`. Read the **last exit code** column, not just
  presence.

## 5. Doctrine is not a complete inventory

A 2026-07-18 hive audit found the M2 launchd roster **larger than doctrine
claimed**. The same is assumed true of M1. The check therefore dumps every
loaded `com.adrianvault.*` label rather than only testing the ones named here —
anything loaded but undocumented gets reconciled into doctrine or retired.

## 6. The check

Read-only by design: it starts and stops nothing, and prints the exact
remediation command for each gap so the operator decides. Save to
`tools/m1-systems-check.sh` in the local vault (the GitHub mirror deliberately
does not track `tools/`) and run `bash tools/m1-systems-check.sh`.

The authoritative deep check it ends on is
`tools/reliability-selftest.py --quick`, which proves all seven crash-resilience
assertions: contracts present · admission gating · mlx mutex blocks · guardian
armed · heartbeat advancing · lock hygiene · both cross-node witnesses fresh.

```bash
#!/bin/bash
# m1-systems-check.sh — post-reboot systems check for the M1 Max (READ-ONLY)
#
# Verifies what SHOULD be running after an M1 reboot, per vault doctrine, and
# reports what is not. It NEVER starts, stops, or restarts anything: it prints
# the exact command for each gap so the operator decides. This is deliberate —
# `feedback-ag-down-may-be-intentional.md` is a HARD rule that the AG supervisor
# stack must never be auto-restarted, and several agents here are intentionally
# down in PRESENT mode.
#
# Usage:  bash tools/m1-systems-check.sh
# Source of truth for the roster: canonical/concepts/{crash-resilience-architecture,
# fleet-presence-protocol,overwatch-daemon-operations}.md + AGENTS.md §7.1

set -uo pipefail
VAULT="${VAULT:-$HOME/Documents/Adrian-Vault}"
UID_N="$(id -u)"
PASS=0; FAIL=0; WARN=0; SKIP=0
ok(){   printf '  \033[32mOK\033[0m    %s\n' "$1"; PASS=$((PASS+1)); }
bad(){  printf '  \033[31mDOWN\033[0m  %s\n' "$1"; FAIL=$((FAIL+1)); }
warn(){ printf '  \033[33mWARN\033[0m  %s\n' "$1"; WARN=$((WARN+1)); }
skip(){ printf '  \033[90mSKIP\033[0m  %s\n' "$1"; SKIP=$((SKIP+1)); }
fix(){  printf '        \033[36m↳ %s\033[0m\n' "$1"; }
hdr(){  printf '\n\033[1m== %s ==\033[0m\n' "$1"; }

# Is a launchd label loaded in the gui domain? Also surfaces its last exit code,
# because "loaded" and "working" are different things — a job that RunAtLoad'd
# and immediately died still shows up in `launchctl list`.
svc(){ # svc <label> <expect: up|down> <description>
  local label="$1" expect="$2" desc="$3" line status
  line="$(launchctl list 2>/dev/null | awk -v l="$label" '$3==l{print $1"\t"$2}')"
  if [ -z "$line" ]; then
    if [ "$expect" = "down" ]; then ok "$label — not loaded (correct: $desc)"
    else
      bad "$label — NOT LOADED ($desc)"
      if [ -f "$HOME/Library/LaunchAgents/$label.plist" ]; then
        fix "launchctl bootstrap gui/$UID_N ~/Library/LaunchAgents/$label.plist"
      else
        local dis
        dis="$(ls "$HOME"/Library/LaunchAgents/"$label".plist.disabled-* 2>/dev/null | head -1)"
        [ -n "$dis" ] && fix "plist is RENAMED-DISABLED ($(basename "$dis")) — retired for cause, confirm before reviving" \
                       || fix "no plist at ~/Library/LaunchAgents/$label.plist — never installed on this box"
      fi
    fi
    return
  fi
  status="$(printf '%s' "$line" | cut -f2)"
  if [ "$expect" = "down" ]; then
    warn "$label — LOADED but should be DOWN ($desc)"
    fix "launchctl bootout gui/$UID_N/$label"
  elif [ "$status" = "0" ] || [ "$status" = "-" ]; then
    ok "$label — loaded, last exit $status ($desc)"
  else
    bad "$label — loaded but LAST EXIT=$status ($desc)"
    fix "launchctl kickstart -k gui/$UID_N/$label || launchctl bootstrap gui/$UID_N ~/Library/LaunchAgents/$label.plist"
  fi
}

hdr "0. Reboot confirmation (LL-2026-08-01-018: check uptime before debugging code)"
uptime
echo "  Booted: $(sysctl -n kern.boottime 2>/dev/null | sed 's/.*} //')"
echo "  Now:    $(date '+%Y-%m-%d %H:%M:%S %Z') (WITA)"

hdr "1. Fleet mode — the gate that decides which agents SHOULD be down"
HOUR=$(date +%-H)
if [ "$HOUR" -ge 0 ] && [ "$HOUR" -lt 9 ]; then EXPECT_MODE=grind; else EXPECT_MODE=present; fi
echo "  Schedule default for ${HOUR}:00 WITA → $EXPECT_MODE  (00:00-09:00 = GRIND, else PRESENT)"
if [ -f "$VAULT/working/state/fleet-mode.json" ]; then
  MODE=$(python3 -c "import json;print(json.load(open('$VAULT/working/state/fleet-mode.json')).get('mode','?'))" 2>/dev/null || echo '?')
  echo "  fleet-mode.json says: $MODE"
  python3 - "$VAULT/working/state/fleet-mode.json" <<'PY' 2>/dev/null
import json,sys
d=json.load(open(sys.argv[1]))
print(f"  set_by={d.get('set_by')}  set_at={d.get('set_at')}  until={d.get('until')}  reason={d.get('reason')}")
PY
  [ "$MODE" != "$EXPECT_MODE" ] && warn "live mode ($MODE) != schedule default ($EXPECT_MODE) — OK only if a manual override is active (see set_by/until above)"
else
  MODE="$EXPECT_MODE"; warn "fleet-mode.json missing — assuming schedule default ($EXPECT_MODE)"
fi
if [ "$MODE" = "present" ]; then GRIND_EXPECT=down; else GRIND_EXPECT=up; fi

hdr "2. M1 grind agents (PRESENT ⇒ booted out is CORRECT, not a fault)"
svc com.adrianvault.cloud-pipeline "$GRIND_EXPECT" "transcription shard 3/5"
svc com.adrianvault.m1-audio       "$GRIND_EXPECT" "M1 audio/transcription"
svc com.adrianvault.fleet-mode-scheduler up "10-min PRESENT/GRIND auto-check — must ALWAYS be up"

hdr "3. Crash-resilience stack (the layer that makes a reboot survivable)"
svc com.adrianvault.boot-reconcile up "RunAtLoad+600s — resumes grind within membudget after reboot"
svc com.adrianvault.watchdog       up "30-min infra-health monitor (the only one)"

hdr "4. Authorised daily notifications (AGENTS.md §7.1 registry — the complete set)"
svc com.adrianvault.balinese-day-brief  up "06:30 WITA ntfy push → adrianvault-content"
svc com.adrianvault.daily-reading-note  up "06:35 WITA Apple Notes 'Daily Reading'"

hdr "5. Other agents doctrine names as live"
svc com.adrianvault.deadline-watcher    up "4h T-48/24/6 deadline escalator"
svc com.adrianvault.ag-auto-verify      up "WatchPaths on handoffs — auto-verify AG completions"
svc com.adrianvault.agtoclaudewatcher   up "ag-to-claude handoff auto-wake"
svc com.adrianvault.inboxfeedtail       up "inbox-feed tail notifier"
svc com.adrianvault.manifest-keepalive  up "touches M1+i7+mini manifests"
svc com.adrianvault.model-intel-weekly  up "Mon 05:00 WITA model-intel harvest"
svc com.adrianvault.priority-transcribe up "priority transcription queue"
svc com.adrianvault.icloud-video-watchdog up "iCloud video lane watchdog"

hdr "6. Full loaded roster (doctrine is NOT a complete inventory — LL-2026-07-18)"
echo "  Every com.adrianvault.* actually loaded right now:"
launchctl list 2>/dev/null | awk '$3 ~ /^com\.adrianvault\./ {printf "    pid=%-8s exit=%-5s %s\n",$1,$2,$3}' | sort -k3 \
  || echo "    (none)"
echo "  Anything above NOT covered in sections 2-5 is undocumented — reconcile it into doctrine or retire it."
echo
echo "  Disabled-for-cause plists (renamed; do NOT revive without checking why):"
ls "$HOME"/Library/LaunchAgents/*.disabled-* 2>/dev/null | sed 's/^/    /' || echo "    (none)"

hdr "7. Reboot casualties in /tmp (these do NOT self-heal)"
if [ -f /tmp/rode_rec_override.txt ]; then ok "/tmp/rode_rec_override.txt present"
else
  if launchctl list 2>/dev/null | grep -q com.adrianvault.overwatch; then
    bad "/tmp/rode_rec_override.txt GONE and overwatch is loaded — Bonjour override lost on reboot"
    fix "get IP:Port from Rode Rec app → Wi-Fi Transfer, then: echo '<IP>:<PORT>' > /tmp/rode_rec_override.txt"
  else
    skip "/tmp/rode_rec_override.txt absent, but overwatch not loaded — only needed if the Rode Rec lane is still in use"
  fi
fi
[ -f /tmp/overwatch_state.json ] && ok "/tmp/overwatch_state.json present" \
  || skip "/tmp/overwatch_state.json absent (rebuilt by the daemon on next cycle)"

hdr "8. Deliberately NOT restarted — confirm these are still down"
echo "  AG supervisor stack (ui-autoloader / burn-watchdog / hive-supervisor):"
echo "    HARD rule 'feedback-ag-down-may-be-intentional.md' — NEVER auto-restart."
echo "    Re-arm only on Adrian's word:  tools/ag-automation.sh resume"
pgrep -fl 'ui-autoloader|burn-watchdog|hive-supervisor|ag-feeder' 2>/dev/null | sed 's/^/    RUNNING: /' \
  || echo "    (none running — expected)"
[ -f "$VAULT/working/state/ag-automation.pause" ] \
  && ok "ag-automation.pause flag present (AG automation paused since 2026-07-15)" \
  || warn "ag-automation.pause flag NOT found — check whether AG automation is meant to be armed"

hdr "9. Claude Code native scheduled tasks (app-dependent, no daemon)"
echo "  osb-order-monitor / m2-ultra-192gb-watch / ss-mastermind-growth-monitor"
echo "  These run only while Claude Code is open; they self-heal on next launch."
echo "  Adrian decided 2026-08-12: accept this, no system-level backstop. No action needed."

hdr "10. Fleet reachability (the other 4 nodes are unaffected by an M1 reboot)"
for N in studio i7 m4 pc; do
  if ssh -o BatchMode=yes -o ConnectTimeout=6 "$N" 'echo up' >/dev/null 2>&1; then ok "ssh $N reachable"
  else bad "ssh $N unreachable"; fi
done
command -v tailscale >/dev/null && { tailscale status 2>/dev/null | head -8 | sed 's/^/    /'; } || skip "tailscale CLI not on PATH"

hdr "11. Deep verification (the authoritative check — 7 assertions)"
if [ -f "$VAULT/tools/reliability-selftest.py" ]; then
  echo "  Running reliability-selftest.py --quick ..."
  ( cd "$VAULT" && /opt/homebrew/bin/python3 tools/reliability-selftest.py --quick 2>&1 | tail -25 | sed 's/^/    /' )
else
  warn "tools/reliability-selftest.py not found at $VAULT"
fi

hdr "12. Vault → GitHub mirror sync"
if [ -d "$VAULT/.git" ]; then
  ( cd "$VAULT" && echo "    last local commit: $(git log -1 --format='%cI %s' 2>/dev/null)" )
else
  warn "no git repo at $VAULT"
fi

printf '\n\033[1m== SUMMARY ==\033[0m\n  OK:%d  DOWN:%d  WARN:%d  SKIP:%d\n' "$PASS" "$FAIL" "$WARN" "$SKIP"
[ "$FAIL" -gt 0 ] && echo "  → Review each DOWN above. Restart commands are printed inline; nothing was changed by this script."
exit 0
```
