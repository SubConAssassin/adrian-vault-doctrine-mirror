# AG IDE auth: the two-field record (and why the popup kept coming back)

**Status:** operational doctrine + runbook
**Created:** 2026-07-29
**Scope:** the **Antigravity IDE desktop app** only. The `agy` CLI (`cli-ask.sh agy`) is a
**separate** auth system with a separate token and a separate keepalive — see §5. Do not conflate
them; they fail independently and have been confused repeatedly.

---

## 1. The one fact everything else follows from

The IDE keeps its Google session in **one SQLite row**:

```
~/Library/Application Support/Antigravity IDE/User/globalStorage/state.vscdb
  → ItemTable, key = "antigravityUnifiedStateSync.oauthToken"
```

That row's value is base64 → protobuf, and it contains **TWO independent sentinel entries**:

| sentinel key | holds | who maintains it |
|---|---|---|
| `oauthTokenInfoSentinelKey` | `access_token`, `refresh_token`, expiry | the IDE **and** our keepalive |
| `authStateWithContextSentinelKey` | `{"state":"signedIn"\|"loginError"\|"signedOut",...}` | **the IDE only** |

**The IDE decides whether to launch a browser OAuth flow from the SECOND field, not from token
expiry.** A perfectly fresh access_token does not prevent the "copy this code" popup if the
auth-state field says the login failed.

## 2. How that produced ~6 weeks of forced re-logins

1. **2026-07-19 12:58:51** — a real login failure; the IDE wrote `"state":"loginError"` into the
   auth-state field.
2. `tools/agy-ide-token-ensure.py` knew only about `oauthTokenInfoSentinelKey`. Each cycle it
   refreshed the token and rewrote the row — copying the `loginError` verdict straight through,
   because `replace_sentinel_value()` substitutes only the one key it is handed.
3. Its post-write verification compared **only its own token bytes**, then logged
   `✅ ... (write verified)`.
4. So: token genuinely fresh, ~29 writes/day, perfect health reports — while the record beside it
   said "this login failed" continuously, and **every cold start** (reboot, quit, crash, update)
   read that and demanded a browser sign-in.

**Why it looked intermittent:** a *running* IDE holds `signedIn` in **memory** (so AG IDE works
fine between restarts) and never flushes that healthy state to disk. The symptom therefore fires on
cold start, not on a schedule — which is why codes clustered around restarts.

**The keepalive was not re-poisoning the record.** Its read→write window is ~1 second, so it
faithfully *preserved* a value already on disk; it did not create or re-lay it. The fault was
blindness plus a falsely reassuring health report, not a write race.

## 3. What is now detected (2026-07-29)

`agy-ide-token-ensure.py` reads the auth-state field every cycle and returns **exit 6
(SESSION POISONED)** when an unhealthy verdict persists **2 consecutive cycles** (~100 min; the
strike counter prevents false alarms on transitional states). `agy-ide-token-keepalive.sh` handles
6 with a rate-gated ntfy alert (1h → 4h → daily) and keeps the normal 50-min cadence because the
token itself is fine.

Exit-code map: `0` ok · `1` transient · `2` never signed in · `3` refresh_token revoked ·
`4` parse regression on a previously-healthy install · `5` post-write verify failed ·
**`6` token fresh but session poisoned**.

Quick check any time — this is the authoritative health question, not the log's ✅:

```bash
python3 ~/Documents/Adrian-Vault/tools/agy-ide-token-ensure.py --check-only
# status: VALID | expires_in=28min | auth_state=signedIn   <- auth_state is the one that matters
```

**We deliberately never WRITE the auth-state field.** Forging a `signedIn` verdict the IDE did not
itself reach is untested and would mask genuine auth failures. Clearing it is a human re-auth.

## 4. RUNBOOK — clearing a poisoned session (the only fix)

Order matters. Re-authenticating while the keepalive is loaded lets it re-persist the record it read
moments earlier, which is very likely why at least one past re-auth appeared not to stick.

```bash
# 1. Pause the second writer (revokes/deletes NOTHING)
launchctl bootout gui/501/com.adrianvault.agy-ide-token-keepalive
launchctl list | grep agy-ide-token-keepalive     # expect: no output
```
2. **Quit Antigravity IDE fully** (Cmd-Q). Confirm:
   `pgrep -f "Antigravity IDE.app/Contents/MacOS"` → empty.
3. **Reopen `/Applications/Antigravity IDE.app`** and complete the Google sign-in. This is the one
   time the "copy this code" flow is the correct answer rather than the symptom.
4. **Verify before re-enabling anything:**
```bash
python3 ~/Documents/Adrian-Vault/tools/agy-ide-token-ensure.py --check-only
```
   Expect `auth_state=signedIn`. **If it still says `loginError`, STOP** and investigate — do not
   re-enable the keepalive, because that freezes whatever state is on disk.
5. Re-enable:
```bash
launchctl bootstrap gui/501 ~/Library/LaunchAgents/com.adrianvault.agy-ide-token-keepalive.plist
```

### Never do these
- **Never delete `state.vscdb`** (or its `.bak*`) — the refresh_token lives only there; deleting it
  *guarantees* the forced login.
- **Never revoke/rotate the Google credential** to "reset" this. The refresh_token has worked for
  8+ days / ~230 refreshes with zero `invalid_grant`; revoking converts a recoverable state problem
  into a hard lockout.
- **Never treat `✅ ... (write verified)` as session health** — it means only "my token bytes
  landed". Use `--check-only` and read `auth_state`.
- **Never deploy these keepalives to M2 blindly.** M2's IDE is `signedIn` and M2 runs live
  transcription; installing the same machinery there before it is proven just adds a second writer
  to a working machine.

## 5. The other, separate system (do not confuse)

| | AG IDE (this doc) | `agy` CLI |
|---|---|---|
| credential | `state.vscdb` (2-field row above) | `~/.gemini/antigravity-cli/antigravity-oauth-token` |
| keepalive | `agy-ide-token-keepalive.sh` → `agy-ide-token-ensure.py` | `agy-token-keepalive.sh` → `agy-token-ensure.py` |
| symptom when broken | "copy this code" popup in the IDE on cold start | `agy -p` opens a browser / CLI calls fail |

**A trap that wasted real investigation time:** the CLI lane's `agy-token-ensure.py` used to map
*every* refresh exception to exit 3 = "refresh_token revoked, browser re-auth needed". Measured:
**104 of 104** such alarms were `<urlopen error [Errno 8] nodename nor servname provided>` — the
laptop simply had no DNS. It was telling Adrian to go and re-authenticate when nothing was wrong,
manufacturing the very manual login it exists to prevent. Fixed 2026-07-29: only a genuine
`invalid_grant` returns 3; network/DNS/TLS/5xx return 1 (silent retry).

## 6. Known-unknown

**What first knocked the session over in mid-June is UNVERIFIED.** The IDE's own auth logs begin
`20260627T105452`, *after* the cluster. Datable context only: app v2.1.1 bundle 06-17, IDE 5h quota
100% on 06-18, M2 became a second IDE tenant 06-18 16:28, v2.2.1 bundle 06-24. The stable period
before it was structural, not clever — one machine, one writer, one long-lived refresh token, left
alone. Do not let anyone record a specific mid-June culprit as fact.

---
*Origin: 2026-07-29 session. Adrian: "I remember that we had a solution to this before… for the last
six weeks it's been completely unstable… Can we resolve this finally." Root cause verified by
decoding the live record, not inferred. Mechanism rediscovered 3× before this note existed
(07-17, 07-27, 07-29) — that is why it is written down.*
