---
title: Overwatch Daemon — Operations Manual
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-04-23
last_updated: 2026-04-24
related:
  - canonical/concepts/dispatcher-protocol.md
  - canonical/infrastructure/
---

# Overwatch Daemon — Operations Manual
**Established:** 2026-04-23/24
**Script:** `working/overwatch_daemon.py`
**LaunchAgent:** `~/Library/LaunchAgents/com.adrianvault.overwatch.plist`
**Log:** `working/handoffs/rode-rec-transcription/overwatch_daemon.log`
**State:** `/tmp/overwatch_state.json`
**DB:** `working/overwatch_jobs.sqlite3`

---

## Start / Stop / Restart
```bash
# Start
launchctl load ~/Library/LaunchAgents/com.adrianvault.overwatch.plist

# Stop
launchctl unload ~/Library/LaunchAgents/com.adrianvault.overwatch.plist

# Restart (always unload first)
launchctl unload ~/Library/LaunchAgents/com.adrianvault.overwatch.plist && sleep 1 && launchctl load ~/Library/LaunchAgents/com.adrianvault.overwatch.plist
```

## Bonjour Override (use when mDNS blocked by router)
```bash
# Set override — bypasses Bonjour entirely
echo "192.168.1.18:49512" > /tmp/rode_rec_override.txt

# Remove to re-enable auto-discovery
rm /tmp/rode_rec_override.txt
```
**CRITICAL:** /tmp/ clears on reboot. Must re-write override file after any Mac restart.

When Rode Rec is open on iPhone, get current IP:Port from Rode Rec app → Wi-Fi Transfer screen.

## Kill Hung Processes
```bash
pkill -9 -f "ffmpeg"
pkill -9 -f "transcribe_worker.py"
pkill -9 -f "overwatch_daemon.py"
```

## Check Status
```bash
tail -30 ~/Documents/Adrian-Vault/working/handoffs/rode-rec-transcription/overwatch_daemon.log
cat /tmp/overwatch_state.json
ps aux | grep -E 'overwatch|transcribe|whisper|ffmpeg' | grep -v grep
```

## State Machine
```
DISCOVERING → DOWNLOADING → TRANSCRIBING → IDLE
                    ↓
            PAUSED_PHONE_SLEEP (if phone unreachable)
                    ↓
            QUARANTINING (if max retries exceeded)
```

## Tier Configuration
- **Tier 1:** Recording IDs [99,67,64,62,61,71,70,69,91,97,98,105,73,79,93,94,83,84,85,87]
- **Tier 2:** Recording IDs [41,42,46,49,50,55,57,58,59,38,37,40,44,47,53]
- Run Tier 1 first, Tier 2 after CPU frees

## Known Issues Fixed
1. **ffmpeg -nostdin missing** → caused background hang. Fixed in transcribe_worker.py (Antigravity).
2. **f-string double-brace** → `{{len(text)}}` not `{len(text)}` inside f-string template. Fixed 2026-04-24.
3. **Bonjour router isolation** → override file workaround. Fixed 2026-04-24.
4. **Stale partial downloads** → daemon wipes .caf.part on failure. Built in.

## Output Locations
- Transcripts: `raw/sessions/rode-rec-transcripts/Recording N.md`
- Staging: `~/Downloads/rode-rec-staging/Recording N.caf` (auto-cleaned after transcription)
- Quarantine: `working/extraction/quarantine/`
