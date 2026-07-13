---
title: Content Scope Verification Before Processing — Exclude by Default
type: protocol
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-07-13
updated: 2026-07-13
last_updated: 2026-07-13
tags: [adrian-os, pipeline, ingestion, attribution, scope, safeguard]
related:
  - canonical/concepts/lessons-learned.md
  - canonical/concepts/shutdown-protocol.md
---

## Thesis

Born from the 2026-07-12/13 SS priority night-run incident (full account: `raw/sessions/2026-07-13-1435-pipeline-forensic-audit-and-attribution-incident.md`, `lessons-learned.md` LL-2026-07-13-005 through 009). Any time a processing/transcription/analysis list is built automatically from a large corpus (keyword match, folder pattern, glob), the list-builder must treat **candidacy** and **inclusion** as separate steps. A path matching a keyword is a candidate. It is not yet eligible for actual processing (download, transcription, publishing, compute spend of any kind) until it clears the checks below.

**Default posture: EXCLUDE. A file earns its way onto a live processing queue; it does not start there by default.**

## The checks, in order (cheapest first)

1. **Technical processability** — for audio/video, does the file actually contain a decodable audio stream? A single `ffprobe`/`ffmpeg -i` call is enough to know before any download+decode cycle is spent. Silent camera-roll clips, screen recordings, and corrupted files fail this immediately and should never enter a queue built for transcription.
2. **Named-third-party folder scan** — before trusting ANY keyword-built list, walk every unique folder path segment in it and flag capitalized, non-generic words (a person's first name, a full name like "Croner-Mark Russell"). Do this systematically across the WHOLE list in one pass — not by spot-checking the files that happen to look odd. A folder sitting as a structural SIBLING to a folder named after the content owner (e.g. `.../Alan` next to `.../Adrian` in the same event) is a strong, near-certain signal of a different speaker, not a coincidence to wave away.
3. **Existing attribution data** — if a diarization/speaker-verdict dataset already exists for any part of the corpus, cross-reference the candidate list against it BEFORE building the queue, and check the actual coverage percentage rather than assuming it applies. Do not silently proceed past a genuinely low-coverage cross-reference as if it had cleared the list.
4. **When still unverifiable** — if a folder or file cannot be confirmed as on-topic/on-speaker by any of the above, exclude it and surface it as an open question. Do not process now and revert if wrong; the download/compute/transcription cost is not free, and a third party's voice ending up in a business content pipeline is not a reversible mistake in the way a wrong SQL query is.

## What NOT to do (the failure mode this exists to prevent)

- Do not treat "the folder path contains my keyword" as sufficient grounds for inclusion.
- Do not assume a broad top-level folder (e.g. a personal brand/account name folder) contains only on-topic content just because SOME files in it clearly are on-topic.
- Do not wait for the file to fail in the pipeline (ffmpeg error, wasted download) to discover it was never processable — check first.
- Do not re-guess the same class of mistake a second time in the same session after being corrected once; if the first correction reveals a *pattern* (not an isolated file), re-scan the WHOLE remaining list against that pattern immediately, not just the specific item that was flagged.

## Applies to

Any pipeline or one-off task that builds a media/document processing list from folder names, filename patterns, or corpus-wide search — not limited to the SS transcription pipeline. Applies equally to future content-machine phases (image captioning, document extraction) described in `working/_m2-staging/2026-07-12-content-machine-master-plan/`.

## Change log

- **2026-07-13 (v1)** — Created directly from the SS priority night-run attribution incident. Standing M2 exception to sole-canonical-writer applied (same precedent as `lessons-learned.md` direct-append) since this is a process/safeguard file tightly coupled to a lessons-learned promotion, not a business/decision canonical fact.
