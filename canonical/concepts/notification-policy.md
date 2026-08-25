# Notification Policy — what is allowed to reach Adrian's phone

**Status:** Canonical. This is the ONE home for the rule governing operational push
notifications. Registered in `canonical/system/prompt-map.md` §2.
**Created:** 2026-08-25, Adrian-direct.
**Mechanism:** `tools/notify-gate.py` (this doc describes it; the code enforces it).

---

## 1. The instruction

> *"I keep getting push notifications saying M2 is 2GB, it's about to stall, and I'm just
> getting notifications all the time of what's happening to the memory pressure of whatever
> node, and it doesn't seem to mean anything to me. We talked about this before with the cry
> wolf situation. He's sending me loads of push notifications that I'm not supposed to act
> upon. In fact, the whole systems are supposed to act upon it and manage it themselves. I
> should only be informed when there's actually something to deal with, not just generally
> what's happening in the background."*

## 2. What was actually happening (measured, not assumed)

Polled from the ntfy server-side cache on 2026-08-25, an 8.7-hour window:

| count | title | cadence | why it was noise |
|---:|---|---|---|
| 105 | `M2 pipeline` | every 5 min | "M2-Storage at 2GB free" — same condition, 9h. And `remaining=0`: ingestion was **not** stalling. |
| 18 | `Fleet coordination needs attention` | every 30 min | the SAME 37 items, oldest unacked **355 hours** |
| 4 | `mem-guardian EMERGENCY — cannot shed` | every 2h | body itself said *"no killable/restartable target"* |
| 11 | fleet recovered / stalled / WAN / bridge | mixed | status chatter |
| **138** | **= 382/day** | | |

`adrianvault-content` — the bus carrying the things he asked for (sales, the Balinese
brief) — sent **zero** in the same window. So 100% of the noise was ops chatter, and none
of it named an action he could take.

## 3. The root cause, which is not "thresholds"

Every notifier was **level-triggered and stateless**:

```bash
[ "$STORE" -lt 8 ] && alert "M2-Storage at ${STORE}GB free"
```

That re-fires on every polling pass for as long as the condition holds. A cooldown does not
fix it, it only slows the repeat. **The gate is edge-triggered: a condition is reported when
it BECOMES true, not every time it is still true.**

Two subtleties the implementation had to handle, both found by testing rather than reasoning:
- **Numeric drift defeats naive dedup.** "2GB free" then "3GB free" are the same condition.
  The fingerprint therefore strips digits; a genuine escalation is signalled by an explicit
  `--tier`, never by a number wobbling.
- **A suppression is not a failure.** The gate exits 10 when policy suppresses. Shell
  callers written as `alert ... || fallback` will fire the fallback on that exit code. Any
  wrapper must return 0 for a policy suppression, or the state gets reset every pass and the
  edge-trigger silently stops working.

## 4. The policy

Reaches the phone:

| class | what it means | repeat |
|---|---|---|
| `money` | a sale or refund; real money moved | once per event |
| `requested` | something he asked to receive (AGENTS.md §7.1 registry) | per its cadence |
| `action-required` | needs HIS hands only: password, 2FA, card, signature, physical act | once, then 24h |
| `node-down` | a whole node gone, self-healing already failed | once, then 12h |
| `data-risk` | sole-copy originals at risk, or corruption (AGENTS.md §15) | once, then 24h |
| `bridge` | M1↔M2 coordination (CEO doctrine §5.5) — delivery unchanged, duplicates collapsed | 6h |

Logged, never pushed: `ops` (disk, memory, CPU, stalls, queues, mounts, coordination
staleness), `progress` (counts, "ingestion complete", backups finished), `recovery` (only
ever sent as the paired clear of an onset that was itself pushed).

Also enforced: quiet hours 22:00–08:00 (only `money` and `node-down` break through), and a
12/day phone cap as a backstop against a novel spam source, from which `money`,
`requested` and `node-down` are exempt.

## 5. The rule for anyone adding a notifier

> **Before you make anything push to Adrian, answer in one sentence: what will he DO when
> this arrives at 3am?** If the answer is "look at it", "be aware", "know that", or "check
> later" — it is class `ops`. If it names no action only he can take, it is not essential.
>
> A notification is not a log line with a siren attached. If the system can act, the system
> acts (AGENTS.md §14: a fault you discover is a fault you own). If nobody can act, it is a
> dashboard row.

**Never post to ntfy directly.** Route through `tools/notify-gate.py`. A direct curl bypasses
every protection here and is how the 382/day came back. Nothing is lost by gating: every
suppressed message is written to `~/.local/state/adrianvault/notify-gate/notifications.jsonl`.

## 6. Commands

```
python3 tools/notify-gate.py --digest --hours 24   # what the fleet said, and what was withheld
python3 tools/notify-gate.py --status              # live state, active conditions, policy
python3 tools/notify-gate.py --selftest            # 12 regression probes
python3 tools/notify-gate.py --clear --key <key>   # condition resolved
```

## 7. Deliberately NOT gated

`osb-order-monitor.py` (sales), `ss-engagement-monitor.py`, `balinese-day-send.py` /
`daily_reading.py` (the §7.1 registry brief), `astro_members.py` / `member_profiles.py`
(per-member topics, not Adrian's phone), `bin-free-m1-after-verify.sh` (hand-run).
These are either what he asked for or not aimed at him. Left untouched on purpose.

---
revision_history:
- 2026-08-25 — created. Adrian-direct after 382 pushes/day, 100% of them ops chatter.
  Ships with `tools/notify-gate.py` + 12 regression probes; 12 senders rewired across M1
  and M2. Every original backed up as `*.pre-notify-gate-20260825` (AGENTS.md §15).
