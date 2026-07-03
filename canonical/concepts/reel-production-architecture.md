# Reel Production Architecture — The Operating Doctrine

**Status:** Canonical operating doctrine for the Subconscious Surgery (SS) short-form video production operation.
**Operator:** Adrian Taffinder / "Subconscious Surgery" — spiritual / mindset / manifestation niche. Wordmark logo, handle `@adrian_taffinder`.
**Last updated:** 2026-06-27
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

## 1. THE TEAM MODEL

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

Every source enters here. The classifier runs in Team 2 (Shot-Analysis), BEFORE any crop or caption. There are three input classes and three different paths.

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
   - *Verify:* extract sample frames across the timeline. Confirm NO bisected logo, NO double caption, captions synced to the (silent-to-most-viewers) VO, hook centered. This is the frame-level check that prevents both original failures.

8. **CAPTION** — render the kinetic phrase-chunk caption track (skipped entirely for Class C; forbidden in the detected caption region for any class).
   - *Verify:* a sampled caption frame is legible sound-off (stroke + drop shadow), chunk is 2–4 words, held ≥600 ms.

9. **VIRALITY-QA** — Team 5 scores with `virality_predictor`; if low, ONE bounded revision (hook/pacing) back to step 7, then re-score. `upscale_video` for polish.
   - *Verify:* QA report attached; final frame-sweep confirms no regressions from the revision.

10. **DELIVER** — Team 6 deploys 9:16 via `mkt-social-deploy` / `postiz`.
    - *Verify:* confirm the published asset is the QA-passed file, correct aspect, correct handle `@adrian_taffinder`.

---

## 6. THE TOP RULES — CHECKLIST

1. **Read the frames before you touch them.** Shot-analysis runs BEFORE any crop or caption. No exceptions. (Constitutional — this is the fix.)
2. **`already_produced` is a hard gate.** ≥2 of {burned captions, logo, true-9:16} with temporal hysteresis → PASS-THROUGH. Never double-caption, never re-crop a finished reel.
3. **Never crop on a fixed offset.** Kill `x_off=246`. Crop box = face/subject center, bounds-clamped, EMA-smoothed with deadband + max-velocity clamp.
4. **Never bisect a logo.** Once `logo_bbox` is known, the crop includes it whole or excludes it whole.
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
