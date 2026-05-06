---
title: Content Librarian Agent — Spec
type: framework
status: pending-review
tier: 2
firewall_class: working-internal
version: 0.1.0
created: 2026-05-05
last_updated: 2026-05-05
authored_by: claude (Chief of Staff)
related:
  - canonical/concepts/corporate-agent-architecture.md
  - canonical/concepts/executive-secretary-agent.md
  - canonical/concepts/precedence-hierarchy.md
  - canonical/state/content-index.md
  - canonical/adrian-corpus/persona-catalog.md
purpose: |
  The Content Librarian is the cross-cutting agent that indexes, tags,
  and retrieves all content across the vault — text drafts, episodic
  narratives, persona corpus, voice transcripts, image assets, video
  assets, and external media references. It exists so Adrian can ask
  "give me X" in plain language and get the answer, instead of having
  to remember where things live.
tags: [agent, librarian, content-index, retrieval, mind-pillar]
---

# 1. Charter

When Adrian asks for content — *"pick me 7 of the best images of Merkaba on a female model in gold"* / *"find the voice note where I describe the muscle-testing prediction"* / *"pull every draft that uses the Compassionate Consultant persona"* — the Librarian answers from the index, not by re-discovering the vault each time.

Surface the right content. Don't make Adrian remember where it lives.

The agent owns:
- Content discovery across all vault directories + connected external storage (AdriansDrive, BackupDrive, Photos library, Wix CDN, Google Drive)
- Tagging schema design + maintenance
- Index construction + refresh cadence
- Query resolution at retrieval time
- Asset-pack assembly (e.g. carousel-ready 7-image bundles with subtitle text)
- Gap analysis when a query has no answer (so the gap becomes a fill-it commission)

The agent does **not** own:
- Content creation (that's the Master Scriptwriter / persona-router / brand-voice skills)
- Publish decisions (firewall gating stays with Adrian)
- External cloud storage migration (that's infrastructure)
- Persona doctrine maintenance (that's the Voice & Persona department)

# 2. Where this agent sits in the team

Per `canonical/concepts/corporate-agent-architecture.md`: **cross-cutting under Chief of Staff (Claude)**, peer to the Executive Secretary. The Librarian is to retrieval what the Secretary is to attention — both are spine services for every department.

Reporting line: Content Librarian → Claude (Chief of Staff) → Adrian (CEO).
Lateral peers: Executive Secretary, Production Manager Agent, Master Scriptwriter, Social Strategist.

Substrates the role can run on:
- **v0.1 (now):** in-Claude retrieval against `canonical/state/content-index.md` + filesystem grep — no separate process; the librarian role is something Claude *plays* when a retrieval query lands
- **v0.2 (next):** Python indexer + local SQLite tags database (`tools/content_indexer.py`)
- **v0.3 (later):** local CLIP visual-embedding index for image semantic search (free, runs on M3 Pro)
- **v0.4 (only with presidential go):** managed embedding API for hybrid text+image semantic search (paid)

# 3. The four content domains

| Domain | What lives there | Index status v0.1 |
|---|---|---|
| **Text corpus** | Drafts, episodic, canonical, persona cards, handoffs, voice transcripts | LIVE — file-tree + frontmatter parsing is enough for most queries |
| **Image assets** | OSB product photography, lifestyle, brand assets, Marketing Studio outputs, social-source media | GAP — 118K+ images on `/Volumes/AdriansDrive` with camera-ID filenames, not tagged. Needs a tagging pass (see §6) |
| **Audio corpus** | Voice notes (FB / WhatsApp / dictation), client recordings, mastermind recordings | PARTIAL — 1,073 FB voice notes ingested with `_audio-manifest.md` per thread; whisper transcription queued (AG-1) |
| **Video assets** | Marketing Studio Veo3 outputs, mastermind recordings, client-call recordings, Loom captures | GAP — uncatalogued; reference paths exist in `working/marketing-studio-emulator/` |

# 4. Query patterns the Librarian must answer

| Query class | Example | v0.1 capability |
|---|---|---|
| **Persona-driven retrieval** | *"Give me 5 Compassionate Consultant DM examples from IG"* | LIVE (text corpus + persona-catalog cross-ref) |
| **Topic-driven retrieval** | *"Pull every Heart Talk reference across the corpus"* | LIVE (grep) |
| **Asset-bundle assembly** | *"7 best Merkaba on female model gold images + subtitle copy for IG carousel"* | GAP (no image index) |
| **Voice-corpus quote retrieval** | *"Find me the verbatim line where I close the loop with Gino"* | PARTIAL (text-only; whisper output expands this) |
| **Cross-corpus pattern** | *"Show me every time I've used the £200 test framework anywhere"* | LIVE (grep) |
| **Time-bound** | *"What did I publish to LinkedIn last month?"* | LIVE (filesystem mtime) |
| **Production-readiness check** | *"Which OSB SKUs have product photography ready for the new collection drop?"* | GAP (image index) |

# 5. Inputs (what the agent reads)

| Input | Source | Form | v0.1 status |
|---|---|---|---|
| Vault file tree | `Adrian-Vault/**` | filesystem walk | LIVE |
| Frontmatter metadata | `*.md` files (persona, firewall_class, source) | YAML parse | LIVE |
| Drafts pipeline | `working/drafts-pending/*` | filesystem listing + persona tag | LIVE |
| Persona catalog | `canonical/adrian-corpus/persona-catalog.md` + `personas/*` | markdown | LIVE |
| Voice transcripts | `working/extraction/voice-transcripts/*` + per-thread audio manifests | markdown | PARTIAL (post-whisper) |
| Image directories | `/Volumes/AdriansDrive/{siberian blue,FINAL,SS01,...}` + vault dirs | filesystem listing | LIVE for inventory; GAP for content tagging |
| Wix CDN references | OSB website + Wix Sites MCP | API | DEFERRED v0.2 |
| External media | iCloud Photos library | macOS Photos.app | DEFERRED v0.3 |

# 6. Image-asset indexing — the hardest domain

The vault inventory currently shows ZERO product images named with semantic tags. All 118K+ images on the external drive use camera IDs (IMG_XXXX.HEIC). A query like *"Merkaba on female model in gold"* cannot resolve until images are tagged.

**Three indexing paths, ranked by cost-leverage:**

1. **Local CLIP / open-source visual embedding** — free, runs on M3 Pro, ~50ms per image, ~100 minutes for the full 118K. Output: per-image embedding vector + nearest-neighbour text labels. Quality good for "shows person", "shows jewellery", "shows gold-tone metal", "outdoor scene". Quality weaker for product-line distinction (Merkaba vs Tranquility shapes are similar at coarse resolution).
2. **Adrian-narrated tagging session** — Adrian narrates one folder at a time ("this folder is the Bali shoot with Sina, Sept 2024, Merkaba mediums"). Claude writes the tags to a sidecar `.json` per folder. Time-cost: Adrian ~30 min per major shoot folder. Output quality: highest, because Adrian knows what's what. Best for the 10-20 most important folders.
3. **Paid Vision API** (Vertex AI Vision / Anthropic Vision / OpenAI Vision) — high quality, fast. Egress + per-image cost. Per `feedback-paid-spend-lockdown.md`: requires presidential go before any commission. Not run by default.

**v0.1 path (no Adrian time, no spend):**
- Inventory the directory tree on AdriansDrive (LIVE — see §7 below)
- Tag each *folder* with a best-effort semantic name based on its existing folder name + any `.txt` or `.md` companions found
- Defer per-image tagging until either Adrian narrates the priority folders OR he authorises CLIP/Vision

**v0.2 path (Adrian narrates 5-10 priority folders):**
- 5-hour total Adrian commitment, distributed across sessions
- Result: top 10 OSB shoot folders fully tagged at the per-image level for Merkaba/Tranquility/etc, gold/silver, model/flatlay, gender, scene
- All carousel queries against those folders become resolvable

# 7. The directory inventory (run-once snapshot — refresh cadence: weekly)

External drive `/Volumes/AdriansDrive` has 118,034 image files across these top-level folders:
- `siberian blue/polished crystals/` — likely OSB product photography
- `FINAL/` — possibly final-cut shoots (mixed images + .MOV video)
- `SS01/Exquisite Crystal Carving/` — production photography
- `aryo/` — possibly Aryo (artisan or model) shoots
- `riki/` — possibly Riki (artisan) shoots
- `back up NFT/` — NFT-collection art
- `stephan Schwartz/` — Stephan-related (likely Seattle source material)
- `download/` — generic downloads
- `2023-01-11 admin.wpp/`, `RX back up`, `iosbackup`, `other backup` — iOS / WhatsApp historical backups

Vault internal:
- `working/marketing-studio-emulator/2026-04-30-2326-small-yellow-gold/reference_image.jpg` and similar — Veo3 generation reference shots (small batch)
- `raw/whatsapp-archives/{relationship}/` — WhatsApp photos by counterparty (NOT product, mostly personal — exclude from OSB queries)
- `raw/facebook-import/messages/{thread}/` — Facebook Messenger photos (NOT product, mostly personal — exclude from OSB queries)

# 8. Output formats the Librarian produces

| Output | Use case | Form |
|---|---|---|
| **File list** | "find me X" | markdown table with paths + tags |
| **Verbatim quote pull** | "find the exact line where" | markdown with line refs back to source |
| **Asset bundle** | "give me 7 carousel images + subtitles" | folder under `working/asset-bundles/YYYY-MM-DD-{slug}/` containing the 7 image symlinks/copies + `_carousel-script.md` with per-image subtitle copy |
| **Persona-tagged collection** | "show me all Compassionate Consultant copy" | markdown index pointing to all matches |
| **Gap report** | "I asked for X, the index can't answer because Y is missing" | handoff at `working/handoffs/YYYY-MM-DD-librarian-gap-{slug}.md` with the fill-it path |

# 9. Refresh cadence

| Index domain | Refresh trigger |
|---|---|
| Text corpus | Every session, on demand (filesystem walk is fast) |
| Drafts pipeline | Every "u" sweep (filesystem mtime check) |
| Image directory inventory | Weekly (manual `find` walk; new external-drive content rare) |
| Per-image tags | Per-folder, after Adrian narrates OR after CLIP/Vision pass authorised |
| Voice transcripts | After each whisper batch completes |
| Persona catalog cross-ref | When persona-catalog.md updates |

# 10. v0.1 → v0.2 → v0.3 roadmap

**v0.1 (now, this session):**
- This doctrine ✓
- `canonical/state/content-index.md` v0.1 — text corpus + image directory inventory (no per-image tags)
- Gap analysis on Adrian's first test query (Merkaba carousel) ✓ at `working/handoffs/2026-05-05-claude-self-image-library-gap-analysis.md`

**v0.2 (next 2-3 sessions, Adrian-narrated):**
- 5-10 priority OSB shoot folders fully tagged via Adrian narration
- First fully-resolvable carousel query
- `tools/content_indexer.py` written (file-walk + frontmatter parse + sidecar tag JSON)

**v0.3 (when ready):**
- CLIP visual embedding for the remaining 100K+ images (free, local, ~100 min compute)
- Hybrid text+image semantic search resolved entirely from vault — no external dependency
- Voice transcripts integrated (post-whisper)

**v0.4 (only with presidential go):**
- Wix CDN reference index
- iCloud Photos library integration via macOS Photos.app
- Paid Vision API for the most ambiguous content classes

# 11. Failure modes the Librarian must handle

- **Query has no answer in current index** → produce a Gap Report; do NOT invent matches
- **Index claims a file but file is gone** → mark stale; trigger re-walk
- **Firewall conflict** (query asks for content tagged strictly-private) → return the result but flag with the firewall class clearly; remind Adrian he is the publish decider
- **Multiple candidate matches** (e.g. 50 Merkaba images, query asks for 7 best) → ask Adrian for ranking criteria once, save the answer as a tagging rule, apply going forward

— Claude (Chief of Staff), 2026-05-05 ~21:00 GMT+8
