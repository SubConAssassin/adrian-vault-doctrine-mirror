---
title: Voice Memo Ingest Protocol
type: canonical-procedure
priority: HIGH — applies any time Adrian references "the voice memo I just made"
created: 2026-04-27
distilled_from: Sequoia meeting voice memo (39 min, hallucinated on first pass, recovered via chunking)
---

# Voice Memo Ingest Protocol

When Adrian references a voice memo he's recorded — typically with phrasing like "I just made a voice memo about X" or "find the recording from this morning" — execute this protocol.

## Step 1 — Locate

Apple Voice Memos lives at:
```
~/Library/Group Containers/group.com.apple.VoiceMemos.shared/Recordings/
```

Recording metadata is in the SQLite DB at:
```
~/Library/Group Containers/group.com.apple.VoiceMemos.shared/Recordings/CloudRecordings.db
```

Get the most recent recordings with their custom labels:
```bash
sqlite3 ~/Library/Group\ Containers/group.com.apple.VoiceMemos.shared/Recordings/CloudRecordings.db \
  'SELECT ZCUSTOMLABEL, ZENCRYPTEDTITLE, ZPATH, ZDATE, ZDURATION
   FROM ZCLOUDRECORDING ORDER BY ZDATE DESC LIMIT 8;'
```

Match by:
- **Topic** if Adrian named the recording (label column)
- **Time** if he didn't (ZDATE is Apple-epoch — seconds since 2001-01-01 UTC)
- **Duration** as a sanity check

If multiple recordings could match (e.g. one before and one after a meeting), transcribe both — Adrian almost always wants the surrounding context too.

## Step 2 — Stage

Copy to scratch dir off the iCloud-synced path:
```bash
mkdir -p ~/scratch/whisper-YYYY-MM-DD
cp '/path/to/file.m4a' ~/scratch/whisper-YYYY-MM-DD/<descriptive-name>.m4a
```

Don't transcribe in-place from the Voice Memos directory — iCloud sync can move/rewrite files mid-read.

## Step 3 — Transcribe with the chunked pattern

Use the canonical tool:
```bash
python3 ~/Documents/Adrian-Vault/tools/voice-memo-transcribe.py \
  ~/scratch/whisper-YYYY-MM-DD/<file>.m4a \
  ~/Documents/Adrian-Vault/raw/sessions/voice-memos/YYYY-MM-DD-HHMM-<topic>.md \
  --context "Custom context naming the speakers, topics, proper nouns relevant to this recording"
```

**Critical:** for any recording over 10 minutes OR with sustained quiet/noisy passages, use the chunked tool — never single-shot Whisper. Single-shot will hallucinate "Yeah." or similar tokens for the entire quiet section. Chunking forces a fresh init every 8 minutes.

**Context prompt construction.** The prompt anchors Whisper's vocabulary. Always include:
- Adrian's name + key collaborators expected in the recording
- 3-5 proper nouns that would otherwise mangle (especially non-English names)
- The topic / project name
- Place names if relevant

Example for a Sequoia meeting:
```
Meeting between Adrian Taffinder and Sequoia Velez at PT The Good Gods office in Bali
about the AGA Bali land development project in Candidasa. Topics include waste-to-energy,
biomethane, biohacking centre, Red Bull, Swarovski, equity stake, villa entitlement,
sauna, Austria, Tenganan, Bukit Hanuman, Bukit Tenganan, Josef Tatschl, University of Graz.
```

## Step 4 — Read for instructions to Claude

Adrian frequently embeds direct instructions to Claude inside meeting recordings ("Claude, research X", "Claude is going to do all the research on Y"). Scan the transcript for:
- Direct address ("Claude, ...")
- Third-person reference ("Claude is going to / Claude will / get Claude to ...")
- Implicit handoffs ("we need someone to look into X" said in a context where Adrian is alone or talking to a non-Claude collaborator)

Catalogue these as numbered Claude-Requests (CR-1, CR-2, ...) inside the meeting record's §2.

## Step 5 — File to canonical

Two artefacts per meeting:

1. **Raw transcript** at `raw/sessions/voice-memos/YYYY-MM-DD-HHMM-<topic>.md`
   — the verbatim Whisper output. Permanent.

2. **Meeting record** at `canonical/projects/<project>/<topic>-YYYY-MM-DD.md` — structured summary with:
   - Front-matter (date, location, participants, voice_memos paths)
   - §1 Material updates by topic
   - §2 Claude-attributed instructions (CR-1, CR-2, ...) with status per CR
   - §3 Open clarifications needed from Adrian
   - §4 Action queue
   - §5 Memory updates filed
   - §6+ Identity resolutions or other reference material

## Step 6 — Execute the CRs

For each CR identified, execute or route per the Partition Protocol:
- Token-work / web research → Claude (this session)
- Long-running file work / bulk processing → Antigravity (handoff to `working/handoffs/`)
- Strategy / second-opinion → Grok or ChatGPT API call

Do not stop at "blocked / awaiting clarification" without attempting at least 3 search angles for any unverified name or fact (see `canonical/concepts/phonetic-name-resolution-protocol.md`).

## Step 7 — Clean up scratch

After successful transcription, delete the WAV chunks (they're large and bandwidth on the M3 Pro is precious):
```bash
rm -rf ~/scratch/whisper-YYYY-MM-DD
```

The original m4a in the staging dir can stay if Adrian might want to re-listen.

## Cross-references

- `tools/voice-memo-transcribe.py` — the canonical chunked Whisper script
- `canonical/concepts/phonetic-name-resolution-protocol.md` — what to do when names get mangled
- `canonical/concepts/generative-research-fact-checking-protocol.md` — how to research the people / topics named in the memo without hallucinating
- `canonical/concepts/claude-antigravity-work-partition.md` — how to split CRs between Claude and Antigravity
