# Reel Production Architecture — The Operating Doctrine

## MANDATORY CREATIVE GATE — 60/40 coverage and speech-led visual rhythm

**Adrian-direct correction, 2026-09-07. Read before selecting, storyboarding, delegating or rendering any reel. This is a pivotal acceptance requirement, not optional inspiration. It applies before presenting an approval draft as well as before publication.**

- **60% B-roll / 40% Adrian on camera.** Plan and measure screen time, not shot counts. For implementation, measure the spoken editorial body separately from the opening-only hook card and closing-only brand hold; report those separately so cards cannot inflate B-roll coverage. Target 60/40 at frame precision. Do not invent a looser tolerance or silently substitute a talking-head-heavy cut.
- **Audio-only exception, Adrian-direct 2026-09-07:** recorded-voice material such as Mastermind has 100% supporting visual coverage and no invented 40% camera presence. Build a complete visual narrative with the same speech-led rhythm. Supporting visuals may use appropriate original footage, illustration, animation, product capture or animated diagrams; 100% visual coverage does not mean every second must be newly AI-generated. Do not substitute a static waveform or repetitive loop for the story.
- **Speech-led rhythm, never clock-led cuts.** Adrian clarified that 2–3 seconds is a guide to frequent visual interest, NOT a compulsory interval, maximum shot length or automatic failure threshold. Land changes on his actual phrasing, punctuation, pauses, emphasis, emotional beats and shifts of meaning. Allow a shot to breathe when the delivery or animated action earns it; cut sooner when the phrase calls for it. Never interrupt a thought, gesture, reveal or connection moment just to meet a timer. Scene, illustration, angle and meaningful crop changes are available tools, not a repeating factory pattern. Caption changes or decorative movement alone do not establish engaging pacing. Review longer holds for purpose and attention, not automatic rejection.
- **Use Adrian for intentional trust and connection moments.** Identify the exact phrases where his face, expression and delivery build rapport, credibility or emotional connection. Record why each talking-head beat earns its place. Keep him large enough to connect with, with subtitles on the measured upper chest near his face.
- **Make the B-roll entertaining and specific to his words.** Use expressive, high-quality animation that illustrates the current idea or action. Different imagery, crops and motivated scene changes sustain the rhythm. Do not stretch three short clips across a long monologue, loop them to fill a quota, substitute generic decorative stock, or count typography as illustrative B-roll. Choose visual styles to suit the subject, including graphite, expressive comic and detailed pastel illustration.
- **Before production:** supply a timestamped beat sheet covering the whole body: start/end, visible scene/crop, A-roll or B-roll, exact spoken phrase, intended action, and reason for each Adrian appearance. Calculate planned A/B seconds and record visual-change intervals alongside their spoken or emotional cues. Intervals are diagnostic evidence, not a metronome. Insufficient assets means generate the missing scenes before final assembly.
- **Before approval delivery:** measure the actual exported timeline against that beat sheet; report total body seconds, B-roll seconds/percentage, Adrian seconds/percentage, longer holds with their editorial reasons, and any coverage or speech-alignment failures. Include timestamped decoded proof and a complete normal-speed audiovisual plus muted-feed review. Missing measurement/review is INCOMPLETE; breached coverage or pacing is FAIL. A caption/layout/audio pass does not override a creative FAIL.
- **Fail closed:** do not call a failed or incomplete export approval-ready, finished, quality-approved or publishable. Label a deliberately shared diagnostic cut clearly as noncompliant. Do not invent exceptions; a user-requested departure must be explicit and recorded. This amendment supersedes conflicting older slower-cadence, hero-only-B-roll or static-filler guidance for this commission. Adrian’s clarification takes precedence over the earlier strict timing wording: his cadence and punctuation govern the edit. Do not impose a fixed 2–3-second rhythm or treat a longer motivated hold as a failure. Equally, do not use this flexibility to excuse extended unconsidered talking-head footage.

**Duplicate gate:** if Adrian recognises an excerpt as already edited/posted, reopen the hold. A comparison with one known export only proves difference from that export; it does not clear all previous edits or posts. Recover and compare the relevant existing edit before release.


**Status:** Canonical operating doctrine for the Subconscious Surgery (SS) short-form video production operation.
**Operator:** Adrian Taffinder / "Subconscious Surgery" — spiritual / mindset / manifestation niche. Wordmark logo, handle `@adrian_taffinder`.
**Last updated:** 2026-09-08 (source-screen, feed composition, speaker tracking and subtractive-cut gates; earlier architecture retained)
**Source:** Synthesised from 6 verified research dimensions (shot_analysis + audio_to_video), each adversarially verified. Confidence HIGH on architecture; numeric thresholds flagged as TUNABLES to calibrate on Adrian's real corpus before being trusted as hard gates.
**Existing code spine:** `working/reels-build/2026-06-21-ss-batch/yt_reel.py` (452 lines: `portrait_crop`, `transcribe`, `make_hook_card`, `make_caption_pngs`, `cut_portrait_video` filler-cut, `composite`).

---

## 0. THE PRIME DIRECTIVE (why this doctrine exists)

This build was triggered by two production failures, both structurally preventable:

1. **A logo was cropped in half** — because `portrait_crop` used a hardcoded `x_off=246` instead of reading the actual frame.
2. **An already-finished reel was double-captioned** — because the pipeline re-processed a video that already carried burned-in captions.

**The fix is one architectural rule, and it is constitutional: A SHOT-ANALYSIS PASS MUST RUN BEFORE ANY CROP OR CAPTION DECISION, AND IT MUST EMIT A GLOBAL `already_produced` VERDICT THAT CAN HARD-GATE THE WHOLE PIPELINE TO PASS-THROUGH.** Read the frames first. Never assume. Never act on a guessed offset. Always look at the actual pixels before claiming a stage is done.

Everything below operationalises that rule.

---

## 0.1 Caption visibility and chest placement — CM-079 (Adrian, 2026-09-07)

**Mandatory for future SS reels, every renderer and every model.** Adrian's live Facebook screenshot showed the bottom captions hidden before opening the reel and a thought card clipped at the top. Muted, unexpanded viewing is an acceptance case. On talking-head shots, Adrian requires subtitles **on his upper chest, as close to his face as possible**, so viewers can read his expression and words together with less eye movement.

The machine-readable companion is [reel-layout-standard.json](reel-layout-standard.json). It is a house production baseline, not a guarantee of every Facebook/Instagram interface. At 1080×1920:

| Check | Bounds (left, top, right, bottom) |
|---|---|
| Essential hook, subtitle, thought/label and endcard copy | 96, 480, 936, 1440 |
| Default B-roll caption panel | 96, 1160, 936, 1440 |
| Full portrait proof | 0, 0, 1080, 1920 |
| Centred 4:5 feed proof | 0, 285, 1080, 1635 |
| Conservative centred square proof | 0, 420, 1080, 1500 |

The screenshot is consistent with a centred 4:5 viewport. The square test is an additional conservative house check. Actual platform previews, when available, remain the final check for that surface.

- **Talking head:** inspect the actual shot and annotate the anatomical chin and upper-chest region. Use a stable chest anchor for the shot; captions must not cover the mouth or chin. A face detector's rectangle bottom is not the chin. Start on the nearest readable upper chest; reframe a source copy or reflow the text if the panel cannot fit the feed-safe rectangle. The 24–400 px chin gap is only a broad geometry guard: chest placement must also be evidenced and visually reviewed.
- **B-roll:** use a clear lower-central caption panel inside the safe rectangle. Keep thought bubbles, labels and essential illustrated actions separate; do not overlap competing text. Caption readability has priority.
- Use high-contrast type, normally 56–60 px on the full-size canvas, no more than two lines, with phrase-based timing. Preserve the words and qualifying clauses. Judge readability at phone size, not just on a desktop.
- Measure the whole text-and-panel bounds and animation extrema, not just an anchor point. Hook cards, thought bubbles, persistent primary branding and the final brand/CTA must survive all three previews. Primary branding stays fully visible and readable throughout; the endcard does not substitute for it. Do not shrink a corner mark into an incidental bug to dodge collisions.
- Build proofs from the actual decoded export, review talking-head and B-roll moments plus hook/outro in all three layouts, and watch muted. Geometry checks and still proofs do not establish full audiovisual review.
- Save an export-hash-bound layout manifest with every caption group, intervals, measured bounds, speaker chest evidence and proof paths. Run `~/reel-tools/verify_feed_layout.py MANIFEST --standard /Users/adriantaffinder/Documents/Adrian-Vault/canonical/concepts/reel-layout-standard.json --report REPORT`. Exit 0 is geometry pass; 1 is fail; 2 is incomplete. Do not release with fail/incomplete. Re-encode requires a fresh matching manifest/check.

The canonical Facebook/Instagram `reel` CLI commands now require `--layout-report REPORT` for the SS accounts. The guard reruns the current standard on the linked manifest and matches the actual local upload file before creating a publication attempt. A stale file, stale manifest, missing evidence or geometry failure blocks the write. This is installed in the M1 canonical publishing tools; another node must have the current helper/config before using those commands. URL-only uploads cannot satisfy this local-file binding. Existing publication/duplicate/approval controls still apply, and no live post was replaced by this amendment.

This amendment supersedes CM-065's old fixed vertical bands **only for feed-safe placement**; its ban on overlapping competing text remains. Do not assume the historical 1267–1728 caption band is release-safe. This applies to both the active reel-craft skill and its GPT-6 review fork. Adrian's requested pilot correction is an explicit, copy-based revision of a produced reel; preserve all originals and published versions. It does not authorise automatic replacement or reposting.

Evidence: [original Facebook screenshot](../../working/session-images/01a07a11-0db6-7f31-9fca-3327a478e52a/2026-09-07-facebook-feed-caption-clipping.png). Authority: Adrian's direct feedback in Codex task `01a07a11-0db6-7f31-9fca-3327a478e52a`. Classification: current user-approved production correction; other doctrine is unchanged.

---

## 0.2 Mandatory viewer next step — Adrian, 2026-09-08

**Every Subconscious Surgery reel must tell the viewer what to do next.** Adrian corrected ABEL-19 because the ending posed a question but gave no call to action. This requirement applies to the storyboard, final on-screen ending and accompanying post. A logo, reflective question or closing payoff alone does not satisfy it.

- Choose one clear primary action that fits the reel's purpose. For teaching and audience growth, the default is **“Follow Subconscious Surgery for more.”** “Save this for later” or a specific, relevant sharing/comment invitation may suit a different piece. Do not stack a list of competing requests by default.
- Preserve the established teaching/conversion cadence. A teaching reel still gets a light engagement action; “no sales CTA” does not mean “no action.” Use a commercial next step only for an intended conversion piece and an existing approved offer/destination. This amendment adds no new sales ratio or offer.
- Keep authored CTA text distinct from Adrian's verbatim speech subtitles. Add a clearly designed closing card or overlay; never fabricate spoken words or label the CTA as something he said. Preserve the full mind-chatter branding and any source credit.
- Specify `cta.action`, `cta.on_screen_copy`, `cta.post_copy`, `cta.start_sec` and `cta.end_sec` in the edit handoff. Keep the action visible through the final frame, with enough reading time for the complete ending. Fit the actual text, backing and animation extrema within CM-079, separate from captions and branding.
- Before sharing a revision, inspect the actual exported ending at phone size and in portrait, 4:5 and square crops. Verify the action is present and legible, the final frame still carries it, and the post gives the same next step. An absent CTA is a production defect; fix it before calling the reel complete. Existing full-playback and per-piece approval requirements remain.

Authority: Adrian's direct correction in Codex task `01a07a11-0db6-7f31-9fca-3327a478e52a`, 2026-09-08. Classification: user-directed clarification and enforcement of the reel CTA requirement, not an amendment to AGENTS.md or authority to publish.

---

## 0.3 Source-screen classification and chroma treatment — Adrian, 2026-09-08

Every video source is classified from actual source frames as `green`, `blue`, `none`, or
`uncertain` before framing. The classification describes the screen or backdrop behind the
subject. It must not be inferred from a green object, plant, garment, wall detail or natural
background. Record the human basis, reviewer, time, source hash and hash-bound frame evidence in
`source-screen-review.json`; run `~/reel-tools/verify_source_screen.py classify RECEIPT` before
crop or framing. `uncertain`, `pending`, `hold`, stale hashes and incomplete receipts block work.

A `green` or `blue` source requires an intentional treatment plan and background description.
Choose the key and background treatment for that actual source, lighting, subject and clothing;
there is no universal key threshold in this doctrine. After composite, a human reviews decoded
frames at full export resolution for edge detail, spill, skin tone, shirt integrity, hand
integrity and matte holes. The same receipt carries hash-bound evidence for those checks and for
portrait 9:16, feed 4:5 and square 1:1 views, then
`~/reel-tools/verify_source_screen.py final RECEIPT` must pass on the current export. Re-encoding
requires renewed final evidence and hash binding.

The executable verifies that the declared review is complete and applies to the files on disk.
It does not detect a screen, inspect pixels, choose thresholds or establish a visual pass. Human
review remains the visual gate. This section adds to the factual, method, caption, creative and
normal-speed audiovisual gates; it does not replace them.

## 0.4 Persistent branding and essential-subject feed composition — CM-079 (Adrian, 2026-09-08)

Every reel carries intentionally prominent, readable primary branding throughout the decoded
export. A closing brand card supports this requirement but does not replace it. Placement may
adapt by shot to protect the composition; a fixed tiny corner bug is not an acceptable way to
avoid captions, faces or actions. Measure the tight visible glyph/mark, excluding transparent
padding and its backing panel. The current internal floor in `reel-layout-standard.json` was
chosen from a human-reviewed 460×92 panel whose tight mark measured 400×68 on the 1080-wide
canvas (133.3×22.7 in a 360-pixel-wide phone design preview). The executable uses a 133×22 preview
floor to tolerate measurement rounding. This is an SS design acceptance floor, not a claim about
every Facebook or Instagram interface. Human review must still find the mark readable, prominent
and deliberately aligned with the subtitles and shot.

For each shot, identify every meaning-bearing face and action before framing. A face box includes
the complete head and hair, not just a detector's eye/nose rectangle. An action box includes the
gesture and objects needed to understand it. Inspect the source first: absent or already cropped
subject matter cannot be recovered by reframing. Mark it complete only when the source proves it;
an intentional partial subject needs a named human editorial acceptance and reason.

The layout receipt maps each source box through the actual per-sample source crop and output
placement. The resulting output box must remain protected in portrait, centred 4:5 and centred
square checks and must not collide with active subtitles, labels, hooks or primary branding.
Moving subjects need decoded start, middle, end and motion-extremum samples; shot boundaries also
need decoded transition-in and transition-out samples. Bind every proof and the human review to
the current export hash. A re-encode invalidates them.

`verify_feed_layout.py` checks receipt completeness, file hashes, persistent-brand timeline
coverage, declared glyph size, crop-transform arithmetic, safe bounds and declared collisions.
It does not see pixels or establish logo legibility, subject completeness, composition or
platform behavior. A named human must review the decoded full, 4:5 and square samples at phone
size and explicitly pass logo legibility/prominence, subtitles, source completeness, essential
faces/actions, motion extrema and transitions. Missing review is INCOMPLETE; a human hold/fail is
FAIL even when the geometry passes.

## 0.5 Whole-shot Adrian tracking and full-head feed safety — CM-080 (Adrian, 2026-09-08)

The final mixed export declares every end-exclusive Adrian A-roll interval. The release check
decodes every frame inside those intervals with scored YuNet eye landmarks. B-roll faces are not
speaker evidence. Missing rows and missing detections remain in the denominator and fail; the
checker may not delete positional outliers, accept a partial coverage percentage or fall back to
Haar/collar boxes. More than one face candidate is identity-ambiguous and needs a repaired shot or
explicitly safer source/crop before it can pass the automated lane.

All declared A-roll frames share one reel-wide eye anchor. Apply the internal eye band, maximum
reel-wide deviation and adjacent-frame movement values from `reel-layout-standard.json`; do not
use a median or p90 summary to hide a short edge exit. These values are SS production acceptance
thresholds, not platform guarantees. Tracking must be smooth and feasible within the actual
source edges; interpolation may not manufacture head room that is absent in the source.

For each A-roll interval, save current-export decoded proofs at start, middle, end, leftmost,
rightmost, topmost and bottommost eye positions, maximum adjacent movement, and relevant shot
transitions. In portrait, centred 4:5 and centred square, a named human confirms Adrian's identity,
complete head and hair, visible eyes, source-edge feasibility, smooth movement and deliberate
composition, then completes the normal-speed audiovisual and muted watches. Assistant still review
does not count as this named human pass. Bind every proof, transform and review to the current
export hash. A re-encode invalidates the receipt. The report separates `technical_status` from
`human_status`; technical PASS with human INCOMPLETE is still not releasable. Run:

`~/reel-tools/verify_speaker_tracking.py SPEAKER-TRACKING.json --standard /Users/adriantaffinder/Documents/Adrian-Vault/canonical/concepts/reel-layout-standard.json --report SPEAKER-TRACKING-REPORT.json`

The legacy `verify_eyeline.py` is diagnostic only for mixed reels: it uniformly samples B-roll,
allows missing detections, rejects positional outliers and reports median/p90 movement. Those
behaviours allowed Adrian's real edge wander to disappear from the release evidence. The new
checker validates measurements and receipt completeness; it cannot identify Adrian, see missing
hair, judge motion quality or replace a normal-speed audiovisual and muted watch.

## 0.6 Documented subtractive filler edits — R-006 (Adrian, 2026-09-08)

Choose one continuous source passage. Retained speech remains exact and in source order, but an
editor may remove an individually reviewed redundant discourse filler such as an “erm” or “yeah”.
This is not a blanket word list: acknowledgements, qualifiers, negation, emphasis, emotion,
repetition and pauses that carry meaning or musical cadence stay. Cover the visual jump with
B-roll, preserve natural audio cadence and never reorder, rewrite or regenerate Adrian's speech.

The cut receipt binds the source, original word timing and edited speech artifact hashes. It maps
each retained word and removed source range, proves monotonic source and cut order, and records a
named human decision for every removal plus the complete cadence/meaning review. Even an uncut
passage records one retained span and an empty removal list; a legacy or missing receipt does not
silently pass. `verify_subtractive_cut.py` checks this evidence and arithmetic. It does not decide
whether a word is semantically expendable or whether the edit sounds natural; the named human
review remains mandatory.

Candidate selection also records why the exact story is useful to serial or spiritually minded
entrepreneurs in business, identity, relationships or inner work. Job and interview material may
qualify when that link is real. A topic label alone neither qualifies nor excludes it.

## 1. THE TEAM MODEL

### Batch source variety — Adrian, 2026-09-07

Adrian requires a visible mix of original recordings and periods of his life, including newer podcast footage alongside older archive material. Do not fill a batch with many extracts from the same source video. Deduplicate source identity using recording IDs and available full-file hashes, not filenames or alternate encodes alone. Track recording date/era and its evidence, set/outfit and format; file modification time is not proof of recording age. Unknown dates remain unknown. Adrian estimates the pilot footage is about eleven years old; that is an estimate until source evidence confirms it.

For the current 30-reel selection, the working editorial target is at most two extracts per original recording, separated in the release order, and approximately ten newer podcast selections if enough suitable, cleared footage exists. These numbers are execution choices to implement variety, not a quotation of Adrian's instruction or permission to use weaker material to fill a quota. Screen podcast speakers, guests and consent individually. Preserve every source's clearance and actual opening/payoff context. Report candidate cards, distinct qualified recordings and finished reels separately; duplicates, rejected takes and unresolved sources do not count as a production-ready batch.

The operation is six concrete capability clusters ("teams"). Each is a defined stage with named tools and a defined handoff artifact. Work flows left to right; the artifact each team produces is the input contract for the next.

### Team 1 — RESEARCH (trending hooks + script read)
**What it does:** Finds the viral hook angle and reads the script/transcript the way a human editor reads an A-roll — on two axes: the HORIZONTAL axis (flow/pacing — where to cut) and the VERTICAL axis (emotional alignment — which exact word wants a punch). Identifies the 0–3s hook, the emphasis beats, the tonal shifts.
**Tools/skills/code:**
- `str-trending-research` skill (Reddit/X scan for hook angles + verbatims in the SS topic space).
- `mkt-ugc-scripts` / `mkt-content-repurposing` skills for hook-line variants in Adrian's voice.
- `mlx_whisper` large-v3-turbo (LOCAL) → word-level `(word, t_start, t_end)` transcript = the master clock everything keys off.
- `virality_predictor` (MCP) for a pre-build read on candidate hooks.
**Hands to next team:** the word-level transcript JSON (the spine) + a chosen hook line + a list of marker candidates (emphasis words, tonal-shift words, clause boundaries).

### Team 2 — SHOT-ANALYSIS (read the video shot-by-shot)
**What it does:** The load-bearing team. Reads the source video frame-by-frame and emits the per-shot analysis record + the video-level `already_produced` verdict that gates everything. This is the team whose absence caused both failures.
**Tools/skills/code:**
- `PySceneDetect 0.7` (installable) — `AdaptiveDetector(adaptive_threshold=3.0, min_scene_len=15)` for talking-head; `ContentDetector(threshold=27.0, min_scene_len=15)` default. ffmpeg `select='gt(scene,0.3)'` is the zero-install fallback.
- `easyocr` / tesseract / PaddleOCR (installable) — text-DETECTION (bounding boxes only, not full recognition) over ~1 fps sampled frames, SSIM-skipping near-identical frames, restricted to caption-zone + logo-corner crops.
- `mediapipe` 0.10 face detection (installable), fallback cascade MediaPipe → YuNet → Haar (opencv).
- `librosa.feature.rms` (installable) over the VO wav for acoustic emphasis + silence.
- ffmpeg `cropdetect` / `blackdetect` / `silencedetect` (zero-install) as a degraded-mode fallback tier.
- `video_analysis_create` (MCP) as corroboration of the content read.
- New function in `yt_reel.py`: `detect_existing_production(src) -> {already_produced, is_portrait, has_logo, logo_bbox, has_burned_captions, caption_region}`.
**Hands to next team:** `shot_analysis.json` (per-shot records + video-level header) written beside `vo_words.json` in the cache dir. **If `already_produced == true`, the pipeline branches to PASS-THROUGH and no further team runs.**

### Team 3 — ASSET (generate bespoke B-roll / animation / graphics)
**What it does:** Produces the visual layer — kinetic-type PNGs, generated B-roll, metaphor footage, color-graded backdrops — per the line-type → visual-device decision rule.
**Tools/skills/code:**
- `PIL`/Pillow (LOCAL) — kinetic caption PNGs, hook card, color-pop keyword, list-accumulate renders. Fonts: Anton / Bebas Neue / Montserrat Black.
- `generate_video` (MCP, Veo/Kling-grammar prompts) for hero/motion lines.
- `generate_image` (MCP) + `motion_control` / `animation_actions` / `outpaint_image` (MCP), or ffmpeg `zoompan` Ken-Burns, for cheaper static-to-motion.
- Adobe MCP `image_apply_monochromatic_tint` / `image_apply_gaussian_blur` / `image_apply_color_overlay` / `image_adjust_color_temperature` for emotional-beat backdrops; `remove_background` / `image_remove_background` for compositing.
- `reframe` (MCP) to force any non-vertical asset to clean 9:16.
**Hands to next team:** a timed asset manifest — per-line PNG paths, generated clip paths, backdrop, with the timecodes they bind to.

### Team 4 — EDITING ENGINE
**What it does:** Executes the editorial decisions — reframe/crop, punch-ins, pan-scan, cutaways, filler cuts — and composites the asset layer onto the video track. This is the existing `yt_reel.py` core, upgraded.
**Tools/skills/code:**
- `yt_reel.py` `portrait_crop` (now face-anchored + logo-aware, replaces `x_off=246`), `cut_portrait_video` (filler-cut, now acoustic-aware), `composite`.
- ffmpeg 8.x — crop, zoompan punch-in (1.0→~1.08 over an emphasis word), overlay, concat.
- Adobe MCP `video_create_quick_cut` / `video_render` / `video_resize` as an alternative render path; `mosaic-video-editor` skill to consume the marker list.
**Hands to next team:** the assembled but un-QA'd reel (`.mp4`, 1080×1920).

### Team 5 — VIRALITY-QA GATE
**What it does:** Scores the assembled reel before publish; if weak, sends one structured revision back to the Editing Engine (swap hook card, re-pace captions) and re-scores. Also the verification checkpoint where a human/agent LOOKS AT ACTUAL FRAMES.
**Tools/skills/code:**
- `virality_predictor` (MCP) — pre-publish score.
- `video_render_frame` (Adobe MCP) / ffmpeg frame extraction — pull sample frames and VISUALLY confirm: no bisected logo, no double caption, captions synced, hook centered.
- `upscale_video` (MCP) for final polish.
**Hands to next team:** a passed reel + its QA report, OR a bounded revision request back to Team 4.

### Team 6 — SOCIAL-DEPLOY
**What it does:** Platform-native 9:16 deployment and scheduling.
**Tools/skills/code:**
- `mkt-social-deploy` / `postiz` skills; `mkt-video-postprod`.
- `reframe` (MCP) for any final platform-specific aspect tweak.
**Hands to next team:** published / scheduled post + a record back into the SS reel pipeline state.

---

## 2. THE INPUT DECISION-TREE (load-bearing)

Every source enters here. The classifier runs in Team 2 (Shot-Analysis), BEFORE any crop or caption. There are three input classes and three different paths. For every video source, the orthogonal source-screen review in §0.3 runs before the Class B framing path: `none` continues normally; `green` or `blue` continues only with an intentional treatment plan; `uncertain` blocks.

```
INGEST(src)
  │
  ├─ Is src audio-only (no video stream)?  ───────────────────────►  CLASS A
  │
  └─ src has a video stream → run detect_existing_production(src):
        sample ~1 fps, SSIM-skip, OCR-detect caption-zone + logo-corners,
        check container aspect + cropdetect for baked bars
        │
        ├─ already_produced verdict TRUE  ─────────────────────────►  CLASS C
        │     (>=2 of {has_burned_captions, has_logo, true-9:16} latch,
        │      with temporal hysteresis — must persist N consecutive
        │      sampled seconds, not one frame)
        │
        └─ already_produced verdict FALSE ─────────────────────────►  CLASS B
```

### CLASS A — Plain audio / VO-only → BUILD FULL VISUAL TRACK FROM SCRATCH
The dominant SS path (real Adrian audio from the 325+ MP4 corpus is the brand). No source video; every pixel is generated/composited around the voice.
- **Voiceover source:** PRIMARY = Adrian's real captured audio (real voice = brand identity). FALLBACK = `generate_audio` / `create_voice` / `voice_change` (MCP). Clean noisy source first with `media_enhance_speech` (Adobe MCP).
- **Path:** `mlx_whisper` → line-type classifier → per-line visual device (Team 3) → composite kinetic-type over ambient backdrop (Format C: text-visual hybrid) → caption → QA.
- **Target format:** Format C — kinetic typography carrying the information-dense line over a subtle ambient B-roll layer.

### CLASS B — Raw talking-head footage → EDITORIAL REFRAME OVER RUNNING VO
A real shot of Adrian, unbranded, uncaptioned. The job is editorial: reframe to 9:16, punch in on emphasis, pan-scan to follow the face, cut on silence, cut away to B-roll where the line wants visual support — all over the running voiceover.
- **Source screen:** complete §0.3 classification before framing. Green/blue screen footage takes its recorded key/background path and later full-resolution subject/matte review; `none` takes the ordinary footage path. Do not infer chroma from scene colour.
- **Reframe:** face-anchored crop (MediaPipe center, bounds-clamped, EMA-smoothed) — NEVER a fixed offset. If a logo bbox exists, include-it-whole-or-exclude-it-entirely; never bisect.
- **Punch-in:** zoom 1.0→~1.08 over each acoustic-emphasis word (RMS above local rolling mean).
- **Cut-on-silence:** RMS below threshold for >X ms (acoustic, upgrading the existing lexical `find_filler_spans`).
- **Cutaway:** lines the classifier routes to literal/metaphor footage get a generated B-roll cutaway over the continuing VO.
- **Captions:** add the kinetic-type caption layer (this footage has none).

### CLASS C — Already-produced branded + captioned reel → DO NOT REPROCESS
The failure case. A finished reel already carrying the SS wordmark + burned-in captions, and/or already true 9:16.
- **Detection (how the system classifies it):** `detect_existing_production` fires `already_produced` when **≥2 of three signals latch**, each with temporal hysteresis (persist across N consecutive sampled seconds, not one frame):
  1. `has_burned_captions` — persistent text in the lower-third (y > ~0.62·H), horizontally centered, content CHANGES over time (tracks speech). Strengthened by the **Whisper-OCR consistency check**: if OCR'd lower-third text fuzzy-matches the transcript at the same timestamp → it IS a speech caption → definitively skip re-captioning.
  2. `has_logo` — small, STATIC (same pixels) element in a corner across the whole clip.
  3. `is_portrait` — aspect within ±3% of 9:16 AND no baked-in letterbox/pillarbox bars (check via ffmpeg `cropdetect`; a 9:16 file with pillarboxed 16:9 inside is NOT produced and still needs reframe).
  Shot COUNT corroborates: a single returned shot = raw A-roll; many short shots = already-edited montage.
- **Action:** PASS-THROUGH untouched. **DO NOT re-caption. DO NOT re-crop. DO NOT bisect the logo.** Route to repost/deploy only. The caption region and logo bbox become FORBIDDEN ZONES that no later stage may write into or cut through.

---

## 3. THE SHOT-ANALYSIS SCHEMA

The artifact Team 2 produces and every downstream team reads. Written as `shot_analysis.json` in the cache dir, beside `vo_words.json`. The spine is PySceneDetect's minimal shot schema, extended. **The video-level header carries the `already_produced` verdict that gates whether `composite()` runs at all.**

```json
{
  "video": {
    "asset_id": "ss-2026-06-27-clip-014",
    "analyzer_version": "1.0.0",
    "source_hash": "sha256:…",
    "duration_s": 47.2,
    "source_w": 1080, "source_h": 1920,
    "input_class": "A | B | C",
    "already_produced": false,
    "is_portrait": false,
    "aspect_ratio": "16:9",
    "has_letterbox_bars": false,
    "has_logo": false,
    "logo_bbox": null,
    "has_burned_captions": false,
    "caption_region": null,
    "shot_count": 1,
    "whisper_ocr_caption_match": null
  },
  "shots": [
    {
      "shot_index": 0,
      "start_s": 0.000,
      "end_s": 47.200,
      "metric": 0.0,
      "content_type": "talking_head",        // talking_head | graphics | broll | text_overlay
      "face_bbox": {"x": 412, "y": 280, "w": 300, "h": 360},
      "crop_box": {"x": 236, "y": 0, "w": 607, "h": 1920},  // face-anchored, bounds-clamped, NOT fixed offset
      "has_logo": false,
      "logo_bbox": null,
      "has_burned_captions": false,
      "caption_region": null,
      "emphasis_score": 0.0,                  // peak acoustic emphasis in this shot (0–1)
      "edit_points": [                        // cut/trim candidates (silence, clause boundary)
        {"t": 12.4, "type": "cut_on_silence", "confidence": 0.81},
        {"t": 28.9, "type": "trim_filler", "span_s": 0.9}
      ],
      "emphasis_points": [                    // punch-in candidates (RMS above local mean)
        {"t": 3.2, "word": "surrender", "rms_ratio": 1.6, "suggested_zoom": 1.08}
      ],
      "suggested_edit": "punch-in"            // cut | punch-in | cutaway | hold | passthrough
    }
  ]
}
```

**Field notes:**
- `content_type` derivation: face + speech + static framing → `talking_head`; large persistent text filling frame → `graphics`/`text_overlay`; no face + motion + no speech-align → `broll`; changing lower-third text → `text_overlay` sub-flag.
- `crop_box` is ALWAYS computed from `face_bbox` (or saliency/center fallback), clamped to source bounds, EMA-smoothed across the shot with a deadband + max-velocity clamp. It is NEVER a hardcoded x-offset.
- `analyzer_version` + `source_hash` busts the cache when gate logic or detector thresholds change (generalising the existing `vo_words.json` invalidation discipline).

---

## 4. THE VIRAL-HOOK-FIRST PRINCIPLE

**Every reel opens with a researched hook in the first 0–3 seconds.** The hook decides retention; the hold rate is measured in that window.

- **How the hook is chosen:** Team 1 (Research) scans trending angles (`str-trending-research`) and audience verbatims in the SS topic space, then selects the line with the strongest scroll-stop promise. The chosen hook is scored with `virality_predictor` before commitment; weak hooks are swapped before any production spend.
- **How the hook is produced:** a CENTER-framed oversized kinetic-type card (NOT lower-third), 80–120 px heavy sans (Anton / Bebas Neue / Montserrat Black), MIXED CASE (all-caps now reads dated), with the emphasis keyword color-popped in SS brand accent CORAL `#EF548E` and a slight scale-in/bounce on entry. Rendered in PIL via `make_hook_card()` (updated to this 2026 spec), laid over one calm ambient backdrop (`generate_image` still + ffmpeg slow-zoom).
- **Rule:** the hook card is the first line of EVERY reel, always. If `virality_predictor` scores the assembled reel low at the QA gate, the FIRST lever pulled is re-doing the hook card.

---

## 5. THE PRODUCTION SEQUENCE

Step by step, source → deliver. **Every step ends with a verification gate. The standing lesson: ALWAYS LOOK AT THE ACTUAL FRAMES BEFORE CLAIMING A STEP IS DONE.**

1. **INGEST + CLASSIFY** — run the §2 decision-tree. `detect_existing_production` on any video stream.
   - *Verify:* read back the video-level header. If `already_produced`, STOP and route to pass-through/deploy. Pull 3 sample frames and confirm the logo + caption that triggered the verdict are really there before discarding the clip from reprocessing.

1a. **SOURCE-SCREEN CLASSIFICATION** — inspect the actual backdrop and record `green`, `blue`, `none` or `uncertain` in the hash-bound §0.3 receipt before any crop/framing. For chroma, record the intended key/background treatment.
   - *Verify:* `verify_source_screen.py classify` exits 0. A green object or natural background is not a screen verdict. Do not claim pixel inspection from the executable result.

2. **SHOT ANALYSIS** — PySceneDetect shots → per-shot face/OCR/audio passes → write `shot_analysis.json`.
   - *Verify:* confirm `shot_count` is sane (1 for raw talking-head), every shot has a `crop_box` inside source bounds, and no `crop_box` bisects `logo_bbox`. Render one cropped sample frame and EYEBALL it.

3. **TRANSCRIBE** — `mlx_whisper` large-v3-turbo → `(word, t_start, t_end)` spine (reuse cached `vo_words.json`; no new transcription cost for the acoustic pass).
   - *Verify:* word count > 0; timestamps monotonic; spot-check 3 words against the audio.

4. **HOOK** — choose + score + produce the center-framed hook card (§4).
   - *Verify:* `virality_predictor` on the hook concept; render the card PNG and confirm text fits, is mixed-case, keyword is CORAL, nothing clipped.

5. **EDITORIAL DECISIONS** — run the acoustic emphasis/silence pass (librosa RMS aligned to words) + the line-type → visual-device classifier; fill `edit_points` / `emphasis_points` / `suggested_edit` per shot.
   - *Verify:* classifier output reviewed (borderline abstract-vs-concrete lines route to M2 local LLM `qwen2.5:14b` or a hand-tuned SS lexicon, NOT a paid model). Confirm punch-ins land on real emphasis words.

6. **ASSET GENERATION** — Team 3 builds per-line assets: phrase-chunk caption PNGs (2–4 words, held 600–900 ms, mixed case, accent keyword), hero-line `generate_video`, metaphor footage from the fixed lexicon, Ken-Burns stills for non-hero lines, color-graded emotional backdrops.
   - *Verify:* every generated clip is 9:16 (`reframe` if not); open each hero asset and confirm it matches the line. No "coffee scene"-vague prompt failures — prompts are subject+action+style+camera-move specific.

7. **ASSEMBLY** — Team 4 composites: face-anchored crop / punch-ins / pan-scan / filler cuts / asset overlay via ffmpeg + `composite()`.
   - *Verify:* extract decoded start/middle/end, motion-extremum and transition samples for every shot. Map each whole-head/meaning-bearing-action source box through the actual crop transform. Confirm primary branding remains prominent and readable, essential faces/actions remain composed in full/4:5/square views, no text or brand collision, NO double caption, captions synced to the (silent-to-most-viewers) VO, and hook centered. Run the §0.4 receipt gate; its geometry result does not replace human viewing.

8. **CAPTION** — render the kinetic phrase-chunk caption track (skipped entirely for Class C; forbidden in the detected caption region for any class).
   - *Verify:* a sampled caption frame is legible sound-off (stroke + drop shadow), chunk is 2–4 words, held ≥600 ms.

9. **VIRALITY-QA** — Team 5 scores with `virality_predictor`; if low, ONE bounded revision (hook/pacing) back to step 7, then re-score. `upscale_video` for polish.
   - *Verify:* QA report attached; final frame-sweep confirms no regressions from the revision.

10. **DELIVER** — Team 6 deploys 9:16 via `mkt-social-deploy` / `postiz`.
    - *Verify:* confirm the published asset is the QA-passed file, correct aspect, correct handle `@adrian_taffinder`.

---

## 6. THE TOP RULES — CHECKLIST

1. **Read the frames before you touch them.** Shot-analysis runs BEFORE any crop or caption. No exceptions. (Constitutional — this is the fix.)
1a. **Classify the source screen before framing.** `green`, `blue`, `none` or `uncertain`; chroma needs an intentional treatment and a full-resolution, hash-bound final human review of edges, spill, skin, shirt, hands, matte holes and feed crops.
2. **`already_produced` is a hard gate.** ≥2 of {burned captions, logo, true-9:16} with temporal hysteresis → PASS-THROUGH. Never double-caption, never re-crop a finished reel.
3. **Never crop on a fixed offset.** Kill `x_off=246`. Crop box = face/subject center, bounds-clamped, EMA-smoothed with deadband + max-velocity clamp.
4. **Keep primary branding intentionally prominent and readable throughout.** The endcard is not a substitute. Measure the tight visible mark, protect it in every crop, adapt its shot placement when needed and obtain the §0.4 phone-preview human pass; do not shrink it into a collision-avoidance bug.
5. **Whisper-OCR match clinches the caption verdict.** Lower-third text that fuzzy-matches the transcript at the same timestamp IS a speech caption → definitively skip re-captioning.
6. **The word-level transcript is the master clock.** Every visual decision keys off `(word, t_start, t_end)`.
7. **Hook-first, always.** First 0–3s = a researched, center-framed, oversized, mixed-case kinetic hook card. Weak hook → swap before spend.
8. **Captions are phrase chunks, not word-by-word.** 2–4 words, held 600–900 ms, mixed case, heavy sans, accent keyword in CORAL `#EF548E`. Word-by-word now reads cheap.
9. **Design for sound-off (70–85% of views).** On-screen text must carry the full message alone. Kinetic captions hold +39% longer than static (directional figure — treat as a lever, not gospel).
10. **Emphasis and silence are acoustic, not just lexical.** librosa RMS over the existing VO → punch-in on emphasis words (1.0→~1.08), cut on sub-threshold silence.
11. **Cut on scene/sentence boundaries, not a metronome.** B-roll changes follow the line, not a fixed beat.
12. **B-roll is curated, not sprayed.** Only HERO lines get bespoke `generate_video`; everything else gets Ken-Burns over a still. Concrete noun → literal footage; abstract concept → fixed metaphor lexicon (subconscious→ocean/iceberg, fear→closing corridor, alignment→sunrise, growth→time-lapse plant, surrender→open hands/water, mind chatter→tangled threads loosening).
13. **Generated-video prompts use real cinematography grammar.** Google 5-part formula (Cinematography + Subject + Action + Context + Style/Ambiance), 2–3 modifiers, ONE dominant camera move, 100–150 words.
14. **All numeric thresholds are TUNABLES until calibrated.** The >40% caption-persistence, >80% logo-persistence, y>0.62·H, ±3% aspect, RMS margins are engineering defaults — dry-run `detect_existing_production` (verdict-only) on ~10 known-raw + ~10 known-finished SS clips and tune before trusting as a hard gate.
15. **Everything local-first and $0.** scenedetect / easyocr / mediapipe / librosa run on-device over ffmpeg + mlx_whisper + PIL. MCP generation only for bespoke B-roll. easyocr on M1 is effectively CPU-bound (MPS unreliable) — SSIM-skip + 1 fps sampling keeps it cheap anyway. Defer the full YOLOv11+ByteTrack cascade — overkill for single-shot talking-head; MediaPipe + saliency covers ~all real cases.
16. **Verify by looking, at every step.** Extract real frames and eyeball them before claiming any stage done. The pipeline failed twice because it claimed done without looking. Never again.

## Addendum 2026-07-02 — Real-footage B-roll capability

A parallel capability was built and proven: sourcing REAL personal footage (not generated) as B-roll, catalogued from iCloud/Dropbox/an external SSD via `tools/footage-catalogue.py` (Apple Vision scene classify + face-detection safety net + filename-contamination filtering). Full detail: memory `footage-catalogue-pipeline`. Headline lessons that extend the rules above:

17. **A raw Vision scene label is a candidate, never a verdict.** Every false positive found (a stranger's face, an artisan's hands, raw gemstones) was invisible from the label alone — only a real frame-pull caught it. This is rule 16 applied to source ingestion, not just output.
18. **Business/product folders systematically poison scenery labels.** Translucent blue OSB crystal product shots get misread as "water" by Vision on sight, repeatedly, across unrelated folders — not a one-off, a standing pattern. Exclude known product-shoot paths by default; don't re-litigate per clip.
19. **Face-detection is a floor, not a ceiling.** It catches faces, not hands/context/workshop activity. A hands-only shot of someone crafting product can have `has_face=0` and still be unsafe to use as anonymous scenery.
20. **B-roll starts ON the word it illustrates, never before it.** Adrian's own craft correction — the visual is reinforcing what's being said at that instant, so the cut lands exactly on the trigger word's timestamp, not a lead-in.
21. **A VO-only (no talking-head) reel uses `build_sequence_bed()`**, not the talking-head reframe path — a crossfaded sequence of B-roll clips IS the entire visual track. Any custom script that renders `caption_engine.render_karaoke_overlay()` outside the standard `reel_build.build()` pipeline MUST pass `lead=LEAD` explicitly or captions silently desync ~2s early once the hook card is prepended — a real bug caught only by adversarial re-verification with real frame pulls, not by the builder's own self-report.

## Addendum 2026-07-15 — Content-aware editing rhythm + real iconographic animation (the reject-and-rebuild cycle)

Context: M1 handed off a complete reel-rebuild mandate 2026-07-14 (`working/claude-coordination/m1-to-m2-2026-07-14-ss-reel-complete-rebuild-handover.md`) after Adrian rejected every reel shipped to date. Building the replacement POC (v1→v4) surfaced two consecutive rounds of detailed, specific creative-editing feedback from Adrian that go beyond anything captured above — they are the actual craft rules, not just engine mechanics, and every future reel build must apply them from the first cut, not discover them again through another rejection cycle. This addendum is the operational answer to Adrian's explicit ask: *"I need you to be growing and learning... so you can do it on a regular basis, reliably, without being babysat."*

22. **Punch-ins are TIMED TO CONTENT, never round-robin/random.** The single biggest, most repeated correction across both feedback rounds. A punch-in lands (reaches peak zoom) exactly as the emphatic word starts, HOLDS through that word plus the reaction after it (a laugh, a pause), then eases back out. It is never "flick in a fraction, flick out a fraction" with no relationship to what's being said — Adrian named that pattern explicitly as amateur and pointless. Engine implementation: `working/reels-build/_engine/punch_arc.py` → `render_punch_arc()` takes `land_time` (when peak is reached) and `hold_end` (when the hold ends) as content-derived timestamps, not fixed offsets — every call site must derive these from the actual word-timestamp data for that beat, never guess or evenly-space them.
23. **Punch magnitude must be REAL, not cosmetic.** Adrian's own number: roughly 40% zoom on a real emphasis beat (peak_punch ≈ 1.35–1.40 in the crop-ratio scale `punch_arc.py` uses), not "a few millimetres" / a couple of percent. A punch that doesn't read as an obvious, confident push on a full-resolution frame comparison has failed, even if the code executed without error.
24. **QC punch-in magnitude on full-resolution frame pulls, never small thumbnail grids.** Twice this session a punch-in was misjudged as "not working" from a small (~150×266px) contact-sheet thumbnail; both times a full-resolution before/after frame comparison proved the mechanism was working correctly. Small thumbnails compress exactly the kind of subtle-but-real crop-tightness difference this mechanic produces — they are not a reliable QC surface for this specific check. Always pull full-res frames at the land/hold timestamps before judging a punch-in pass or fail.
25. **On-screen presence is an audio-continuity rule, not a visual-tracking rule.** Adrian's direct correction: "you don't actually need to track me throughout the whole thing, as long as you put B-roll on if I am off screen. Any videos that are showing me, I should be on screen, fully visible. If there's B-roll, it doesn't matter, you only need to hear me." So: (a) never show a frame where the subject is half-cropped-out or drifting off the edge — if the source framing can't keep him fully in frame for a beat, cut to B-roll/graphic instead of forcing a bad crop; (b) his voiceover continues uninterrupted under the B-roll; (c) this is the justification for graphic/B-roll cutaways, not a tracking-precision problem to solve with better crop math.
26. **A concept mentioned in the VO gets an actual illustrated animation of that concept — not a text card.** When Adrian talks about the brain, the animation is an actual brain shape (with a scan/search motion, since the RAS is described as searching/filtering information — "it's like Google... the brain searching lots of information"). When he talks about the eye's data capacity, the animation is an actual eye shape with a visible data/particle stream. Kinetic typography (stat cards, word-emphasis text) is a legitimate tool for numbers and short phrases, but it is not a substitute for illustrating a concrete visual concept the speaker names — that requires real iconographic motion graphics. Engine implementation: `working/reels-build/_engine/icon_animate.py` (`brain_scan` / `eye_dataflow` modes today; extend with new modes for new concepts rather than falling back to text-only when a script calls for illustrating something else). `stat_card.py` remains the right tool for pure numeric/text beats.
27. **Graphic/icon beats need their own word list, filtered out of the caption overlay.** `icon_animate.py` bakes its own text into the clip. If the standard word-caption overlay isn't filtered to exclude that time range, the same words get captioned twice, stacked — a real bug hit and fixed in v4 (`words_v4_filtered.json`). Any composer that mixes baked-text graphic segments with a global caption pass must exclude the graphic segments' timestamp ranges from the caption word list before rendering.
28. **The CTA outro is a fully branded beat, not a text banner over footage.** Use the real ident assets (e.g. `SubConMaster/images/video idents/DNA SS.mp4`) as the backdrop, not a generic color card. ⚠️ **PATH CORRECTED 2026-08-18: `~/Documents/SubConMaster/` NO LONGER EXISTS ON M1.** The idents are alive in two places — iCloud Drive (`Documents/SubConMaster/images/video idents/`, reachable from the Studio at `~/Library/Mobile Documents/com~apple~CloudDocs/Documents/SubConMaster/`) and, fully materialised with no cloud dependency, at `studio:/Volumes/M2-Storage/from-M1-housekeeping-2026-07-27/SubConMaster/images/video idents/`. Use the Studio path for builds. **Copy, never move** (AGENTS.md §15).
29. **When a user names a specific file/version in feedback, confirm which file before acting on the critique.** Adrian's second feedback round initially referenced issues already fixed in a later version because he'd clicked an older file by mistake. Don't silently re-fix already-fixed problems or silently assume the newest version — state plainly which version the feedback appears to describe and reconcile before making changes, otherwise both the editor and the reviewer waste a cycle.
30. **ffmpeg gotchas specific to this pipeline, collected from repeated hits:** `-ss` placed AFTER `-i` (not before) for frame-accurate seeking near concat boundaries; alpha-channel overlays must round-trip through `qtrle`/`pix_fmt argb`, not `libx264`/`yuv420p` (the latter silently drops alpha and breaks compositing); `-c:v copy` combined with `-shortest` can silently truncate final duration — do a full re-encode when duration correctness matters; `zoompan`'s `z` accumulator is monotonic within one continuous filter chain, so a genuine zoom-OUT within a punch arc is built as several short concatenated static-crop segments (see `punch_arc.py`'s stepped-ramp design), not a single zoompan expression fighting its own accumulator.

See also `canonical/concepts/lessons-learned.md` LL-2026-07-15-008 through 015 (staged 2026-07-15 in `working/_m2-staging/2026-07-15-ss-reel-shutdown/`, promoted 2026-08-01) for the full session trail this addendum was extracted from.


## Creative direction — 2026-09-07: variety and expressive comic illustration

Adrian explicitly requests that reels do not all use the same visual style. Choose the treatment for the spoken subject. Detailed graphite remains one option, not the batch-wide default. An additional approved reference direction is polished expressive comic illustration: confident ink outlines, warm rich colour, detailed environments, exaggerated facial reactions and humorous visual contrasts. Reference: `working/session-images/01a07a11-0db6-7f31-9fca-3327a478e52a/2026-09-07-expressive-comic-style-reference.png`. This is a still-image reference; its original motion/timing has not been inspected.

Use this direction selectively for recognisable everyday habits, overthinking, approval-seeking or disproportionate reactions where humour helps the teaching. Aim humour at the pattern, without ridiculing people or trivialising distress. Create original characters/scenes appropriate to the actual words; do not reproduce the reference's starvation scenario, advertising copy, interface or exact composition by default. Craft quality remains high: expressive intentional drawing, consistent anatomy within caricature, clear staged actions, anticipation and reaction beats rather than random deformation. Maintain all existing hook, chest-subtitle, muted-feed safe-area and actual-motion requirements. Record a visual treatment per reel and review variety across the release order. The current car animation may remain graphite; this preference does not require discarding completed work.


### Additional reference — detailed pastel interiors (2026-09-07)

Adrian supplied a second optional visual direction: a carefully drawn, softly coloured domestic interior, with fine consistent outlines, warm diffuse light, layered furnishings and many small recognisable objects. Reference: `working/session-images/01a07a11-0db6-7f31-9fca-3327a478e52a/2026-09-07-pastel-interior-style-reference.png`. Treat this as a still-image style reference, not evidence of the original animation.

Possible editorial applications include selective attention, familiar routines, noticing overlooked details, and a visually busy environment supporting a line about mental clutter. Choose only when the spoken passage supports it. Create original environments; omit the game inventory tiles, pointer and Play Now advertising button. For vertical reels, simplify the reference's dense wide composition around one meaningful action, preserve caption-safe negative space and avoid a distracting object hunt. Possible motion includes a hand moving one relevant object, curtains moving gently, or a motivated change of focus; background ambience alone does not replace an expressive action when the line calls for one. This expands the available styles alongside graphite and expressive comic illustration; it does not make any one style mandatory or require redoing completed shots.
