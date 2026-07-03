# Content Archive — Single Source of Truth Map

**Status:** Canonical audit + architecture. Grounded against the live catalogues 2026-07-03.
**Author:** Claude (Opus), 2026-07-03. Mechanised by `working/forensic-db/content-archive-ssot.db` (`tools/content-archive-ssot.py`).
**Purpose:** answer, for every piece of content Adrian owns — *what did we start with, where is it, and how deeply has it been understood?* — and lay the ladder from raw file → story-ready clip. Extends [[personal-ai-workhouse-roadmap]] and the [[2026-06-28-digital-librarian-architecture]] (which covers L0–L1 only).

---

## 0. The problem in one line

There is no single source of truth today. There are **six** overlapping catalogues, each true about a different slice, none authoritative:

| Catalogue | Covers | Rows | Has what the others don't |
|---|---|---|---|
| `master-file-index.db` | M1 vault, Dropbox, M1-bin, 2× GDrive | 399,367 | processing_state (transcription) |
| `inventory-2026-05-05.db` | Seagate "AdriansDrive" (825k) + Dropbox | 941,689 | **sha256 hashes — Dropbox rows only** (Seagate rows unhashed) |
| `footage-catalogue.db` | iCloud video, Dropbox video, M2-SSD video | 11,134 clips | **place + captured_date + Vision scene labels + face flags** |
| `icloud-indexed.db` | a 185-file sub-slice | 185 | — |
| `dropbox-icloud-manifest.db` | Dropbox/iCloud manifest | — | — |
| `facebook-manifest.jsonl` | Facebook **text posts** (2013→) | 6,521 | early written voice corpus |

The unification (`content-archive-ssot.db`) folds these into one `assets` table (one row per physical copy) + a `sources` registry, carrying the processing-depth ladder below. It does **not** hash-dedup yet — that is a later phase (the Librarian's Janitor). It preserves every copy so nothing is silently merged.

---

## 1. The source inventory (where everything is)

Grounded counts, 2026-07-03. "Copies" = physical file rows (duplication is real and large — e.g. the 64 GB `C0010.MP4` master exists 3×; Dropbox is mirrored into a GDrive backup).

| # | Source | Node | Mount state | Copies | Size | Deepest layer reached |
|---|---|---|---|---:|---:|---|
| 1 | **M1 vault** | M1 Max | 🟢 online | 209,421 | 84 GB | L1 partial |
| 2 | **Dropbox** | cloud mount (M1) | 🟢 online | 115,505 | 5.3 TB | L1 partial |
| 3 | **M1 bin / Trash** | M1 Max | 🟢 online | 55,141 | 0.8 TB | dedup candidates |
| 4 | **GDrive — subconassassin** | cloud | 🟢 online | 19,266 | 0.75 TB | L1 partial |
| 5 | **GDrive — ukphoton** | cloud | 🟢 online | 34 | ~0 | L0 |
| 6 | **iCloud Photos — videos** | Apple | 🟢 cloud (metadata) | 9,645 | metadata-only | **L3/L4** (geo + scene) |
| 7 | **iCloud Photos — stills** | Apple | ⚠️ **uncatalogued** | unknown | unknown | **gap** |
| 8 | **Seagate "AdriansDrive"** | i7 (external) | 🔴 **OFFLINE** (May snapshot) | 825,757 | 3.0 TB | L0 · **not hashed** |
| 9 | **M2 "ADRIANS DRI" + "M2-Storage"** | M2 Studio | 🟡 online, **counted — ingest pending** | 181,591 + 57,463 | ~4.8 TB | not yet in SSOT DB |
| 10 | **Facebook** (text posts) | export | n/a | 6,521 posts | text | corpus (separate track) |

**Headline (unified DB, verified):** **1,241,290 catalogued file-copies**, **10.2 TB** of media before dedup. Folding the offline Seagate in raised the real media counts far above what `master-file-index` alone showed — **video 61,966 · audio 12,180 · image 294,161** (vs 23k/8k/164k in the base index). Three honesty flags: (a) the 825k-file Seagate is **only a May snapshot — the drive is not currently mounted**, so it is inventoried but not re-verifiable right now; (b) the **iCloud stills library is not catalogued at all** — only the videos were pulled; (c) **nothing is content-hashed** in the unified view (the only hashes we have are the Dropbox rows inside the May inventory), so cross-drive dedup has not run. All three must be closed before "single source of truth" is literally true.

---

## 2. The processing-depth ladder (how deeply each file is understood)

Adrian's ask defines six rungs. Every asset sits on exactly one top rung; the SSOT stores a flag per rung so we can query "everything at L2 but not L3", etc.

| Rung | Name | Question it answers | Method | Applies to |
|---|---|---|---|---|
| **L0** | Catalogued | Where is it, how big, what hash? | filesystem walk + sha256 | all |
| **L1** | Speech | What is being **said**? | Whisper (mlx large-v3) → transcript | audio, video |
| **L2** | Soundscape | What **sounds** are there — birds, ships, cars, crowd, music, silence? | audio-tagging model (YAMNet / PANNs / CLAP) on the extracted WAV | audio, video |
| **L3** | Vision | What is **physically on screen** — objects, setting, people, activity? | keyframe sampling → vision-caption model | video, image |
| **L4** | Place | **Where** was this shot; what landmark/building is it; does the scene match the geography? | EXIF/Apple geo → reverse-geocode → vision cross-check ("is this the temple expected at these coords?") | video, image |
| **L5** | Story | Which **story/theme** does it serve; where on the nomad timeline? | theme tagging + journey timeline + extraction index | all media |

### Current coverage (unified DB, verified 2026-07-03)

| Rung | Video (n=61,966) | Audio (n=12,180) | Image (n=294,161) | Notes |
|---|---:|---:|---:|---|
| L0 Catalogued | 100% | 100% | 100% | everything indexed |
| L1 Speech | 6,010 · 9.7% | 2,500 · 20.5% | — | **8,510 / 74,146 A+V = 11.5%** |
| L2 Soundscape | 0 | 0 | — | **0%** — not started |
| L3 Vision | 10,507 · 17% | — | 3,850 · 1.3% | coarse Apple labels only |
| L4 Place | 6,738 · 11% | — | 3,581 · 1.2% | 10,468 assets w/ place, 612 named places |
| L5 Story | 0 | 0 | 0 | **0%** — downstream of L3–L4 |

**Images are the great untouched surface:** **290,158 of 294,161 photographs sit at L0 only (98.6%)** — no scene-analysis, no geo-linkage beyond raw EXIF. That is exactly the "photographs — geo-locate, describe the scene, investigate the region" workload, and it is almost entirely ahead of us. (Only ~4,000 photos carry any Vision label or place today, via the iCloud/footage-catalogue carry-over.)

---

## 3. Per-media processing protocol

**Video** (the richest, 23,454 files / ~5.7 TB): extract 16 kHz mono audio locally → **L1** Whisper transcript + **L2** soundscape tag on that same WAV → sample keyframes (scene-change detection, ~1 frame/2s) → **L3** vision-caption each → **L4** pull EXIF/creation geo, reverse-geocode, and cross-check the caption against the expected location ("stupa + monks + Chiang Mai coords = Wat …") → **L5** theme + timeline. One asset → one transcript + one soundscape track + a keyframe caption reel + a place record + story tags.

**Photograph** (294,161 / ~0.4 TB): no audio track, so skip L1/L2. **L3** vision-caption (what is it) → **L4** the heavy lift — EXIF GPS → reverse-geocode → *investigate the region* (what is expected there) → confirm/identify the actual subject (this building = the Ubud palace / that mountain = Agung) → **L5** theme + timeline. Photos are the densest geo-signal we have and will carry the nomad map far beyond the 9,645 iCloud videos.

**Audio** (8,134 / ~0.15 TB): **L1** transcript → **L2** soundscape (is this a voice memo, a dharma talk, ambient capture, a call?) → **L5** theme. No L3/L4 unless paired to media.

**The safety net stays on** (from [[footage-catalogue-pipeline]]): no clip is "story-ready" until face-reviewed and contamination-checked — raw blue OSB crystals read as "water", an artisan's hands must never surface publicly (Yoga firewall). L3 automation is a floor, an eyeball check is still mandatory before any public use.

---

## 4. The nomad-journey map (2.5 years)

The seed already exists: **10,468 geo-located, dated assets across 612 named places, spanning 2013-12 → 2026-06**, resolved to real locations — Bali (Dalem Puri Temple, Lake Batur, Serangan, White Sand Beach), Bangkok (Chatuchak, Vadhana, Don Mueang), and China (Shenyang, Beijing, Liaoning). The "2.5 years as a nomad" is the recent dense subset. Once the **290k untouched photographs** are geo-extracted (L4), the timeline becomes a day-by-day movement map: *place → date → what was shot there → which story it belongs to*. Output = an interactive timeline + map, each pin linking to the L3/L5 catalogue of what happened there.

---

## 5. The story-extraction catalogue (L5)

The point of the whole ladder: **"give me 10 clips about X"** returns real, safe, in-context footage. The catalogue indexes every L3/L4/L5-tagged asset by theme, place, date, people-present, soundscape, and speech-content, so a story brief resolves to a shot-list. This is what feeds the content engine in [[personal-ai-workhouse-roadmap]] step 2. It is **downstream of L3–L5** — it cannot be built until the perception/place layers are run, which is the grind ahead.

---

## 6. Honest state & the path

**Done / solid:** unified L0 catalogue exists (1,241,290 copies across 8 sources in one DB); L1 at 11.5% of A/V; a real geo+scene seed for 10,468 assets across 612 places; the Librarian dedup/transcribe/verify architecture is fully designed.

**The gaps (in priority order):** (1) close the L0 holes — re-mount + re-verify the offline Seagate, catalogue the iCloud stills, **ingest the now-counted M2 volumes (ADRIANS DRI 4.0 TB/181,591 files incl. FCP-bundle internals + recycle-bin; M2-Storage 780 GB/57,463 — ~239k files/4.8 TB online, walked but not yet merged; note its name near-matches the offline Seagate — possible backup, hashing will confirm)**, and content-hash for dedup (currently 0 hashed); (2) L2/L3/L4 are ~0 for the bulk — this is the multi-week, multi-node grind (~66k unprocessed A/V through speech+soundscape, 294k photos through vision+geo); (3) L5 story layer and the journey map are downstream of that.

**This is a grind, stated plainly:** transcribing ~66k unprocessed A/V + vision-captioning 294k photos + geo-investigating them is weeks of fleet compute (M2 GPU Whisper + local vision models + CLI enrichment), not a one-session job. What is delivered now is the **map, the unified SSOT DB, and the ladder** — the foundation that makes the grind measurable and resumable. The compute plan is the Librarian architecture extended with the L2–L5 workers.

---

*Regenerate the unified DB + numbers any time: `python3 tools/content-archive-ssot.py`. Companion: [[2026-06-28-digital-librarian-architecture]] (L0–L1 pipeline), [[personal-ai-workhouse-roadmap]] (the venture this feeds).*
