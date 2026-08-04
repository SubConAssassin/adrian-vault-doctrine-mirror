# Short-Form Editing Doctrine — evidence-graded, per-venture
**Status:** CANONICAL as of 2026-08-04. Promoted verbatim from `working/_research/2026-07-29-venture-content-strategy/EDITING-DOCTRINE-DRAFT.md` (Adrian-direct, live in-conversation: "Make sure everything is fully handled and saved into the prompt architecture to make it reliable moving forward"). The original working file remains in place, superseded, as the permanent evidence trail (raw 3-engine council outputs + citation-audit log in that folder's `council/` subdirectory, plus `run.log`).
**Date:** 2026-07-29 (research) · promoted 2026-08-04.

---

## 0. Read this first: the evidence standard

This doctrine exists because the obvious way to build it — ask the AI team what the rules
are and write them down — was tried today and **failed a citation audit almost completely**.

- A three-engine council produced ~60 precise, confidently-graded numeric rules.
- Independent primary-source verification of 24 citations: **13 of 13 codex/GPT citations
  survived. 0 of 11 agy/Gemini citations survived.**
- agy invented named publications that do not exist ("Descript 2024 Short-Form Editing
  Performance Index", "Wistia B2B Video Report", "AES Social Mix Benchmarks") and — the
  worst case — attached a **fabricated −14 LUFS figure to the real EBU R128 standard,
  which actually specifies −23 LUFS**. It graded its own fabrications [HIGH].

**Therefore this doctrine states its evidence tier on every rule, and carries far fewer
rules than the research produced.** A short doctrine you can trust beats a long one you
cannot. See [[agy-fabricates-citations-in-research]].

**Tier definitions**
- **A — VERIFIED.** Traced to a real primary source that was fetched and read.
- **B — PRIOR.** A defensible engineering default. Not measured. Explicitly untested.
- **C — TO MEASURE.** An open question our own instrument will answer.

Nothing in Tier B may be cited to Adrian, a client, or a partner as a fact.

---

## 1. The answer to the six-second question

**There is no six-second rule for short-form video. It is misapplied classical film folklore.**

Traced and independently re-verified:
- **Magliano et al.** recut one narrative into "Hollywood style" (**5.9s average shot
  length**) and "MTV style" (**2.4s ASL**), showed it to 40 people, and measured
  **spontaneous blink rate** — not retention, not completion, not comprehension. This is
  the closest thing in the literature to a "6 seconds" number, and it is about blinking.
- **Cutting et al.**, 210 films 1915–2015: ASL fell 7.5s (silent) → 10.5s (early sound) →
  7.0s (1960s–80s) → **4.3s (1990–2015)**. A history of cinema pacing. Zero mention of
  audience retention or any digital metric.
- The "human breath cycle is six seconds" folk-explanation traces to a physiology teaching
  handout, not an editing study.

**No study anywhere measures average shot length against short-form retention.** [Tier A]

The nearest real evidence is the JAMS attentional-synchrony work (42 PSAs, 2,520 viewing
experiences): **shorter scenes measurably raise moment-to-moment gaze synchrony, and the
effect is larger when the frame is visually simple.** Direction, not magnitude. It names
no optimal ASL. [Tier A]

**What ships:** *cut faster than classical film, and cut more when the frame is simple —
direction proven, magnitude not.* Any specific cuts-per-minute target in this document is
Tier B and must be validated against our own published performance before it hardens.

---

## 2. The universal floor — applies to every venture

Five rules survived primary-source verification. They are the whole verified foundation.

| # | Rule | Evidence | Tier |
|---|---|---|---|
| 1 | **Intelligible human speech begins within the first 3 seconds.** | Emplifi, 10,110 Reels: **+11.7% retention at 3s, +24.7% at 10s, +5.6% engagement** vs music/silence-led opens | A |
| 2 | **A person is on screen within the first 3 seconds** — then get out of the way. | Same study: **+3.6% at 3s, +10.1% at 10s, but −2.4% at 30s** if sustained without payoff | A |
| 3 | **Burn in captions.** | Meta's own measured **+12% watch time**. Keep the platform's native caption track too — removing it is an accessibility regression, not an optimisation | A |
| 4 | **Simplify the frame before you speed up the cutting.** Busy frame + fast cuts is the worst combination. | JAMS attentional synchrony | A |
| 5 | **TikTok pays nothing under 60 seconds.** Creator Rewards requires **>60s** to qualify at all. | TikTok's own Newsroom | A |

Rule 2 has a sharp edge worth naming: the talking head is worth **+10.1% at ten seconds
and −2.4% at thirty**. A face is an opener, not a format. Anything past ~10s must earn
its place with something other than Adrian's face.

### Platform facts that change where effort goes [Tier A]
- **TikTok views fell 31% year-on-year** (Metricool 2026, verified against their own
  release) amid content saturation. Treat TikTok as a declining-yield surface.
- **Reels' top three ranking signals are watch time, likes-per-reach, and
  sends-per-reach** (Mosseri). **Sends drive *unconnected* reach.** For a business with a
  small following, engineering DM-shareability beats engineering likes.
- **Shorts optimises "viewed vs swiped away"** plus a broader satisfaction measure.
- Shorts added 2× playback and removed the dislike button (June 2026).

### What is NOT established — do not gate anything on these
The entire numeric hook-window drop-off curve (% lost at 1s / 3s / 5s), the "cutting your
intro lifts retention 32%" claim, per-device pattern-interrupt lift, beat-sync retention
lift, trending-audio ranking weight, and rewatch weighting. **All [NOT FOUND] on
independent search.** The most actionable-sounding statistic in the whole research corpus
is also the least supported. Never let an automated decision depend on one.

---

## 3. Per-venture divergence

The ventures conflict on craft. The infrastructure is shared; the creative approach is not.

| Axis | How they conflict |
|---|---|
| **Pace** | XMAXED rewards speed. OSB, AGA, Tri Hita and Ashta are actively *harmed* by the same edit language. |
| **What "proof" is** | Object (OSB) · human change (SS) · place (AGA) · engineering credibility (Tri Hita) · methodological restraint (Ashta) · performance (XMAXED). |
| **Tone risk** | Mystical register helps some OSB buyers and **kills Ashta**. Coach intensity works for SS and looks absurd on waste-to-energy. |
| **Attention↔revenue gap** | Widest for Tri Hita and AGA (views ≠ contracts). Tightest for XMAXED. |
| **Volume economics** | XMAXED and SS can feed volume. Tri Hita and Ashta should deliberately **under-post** at higher quality. |
| **Legal exposure** | SS (outcome claims), Tri Hita (financial/impact claims), XMAXED (road legality) carry real risk. AGA place-films carry almost none. |
| **Non-platform distribution** | Real distribution sometimes isn't a public platform metric at all: forwarded WhatsApp clips and presentation-deck embeds for Tri Hita, a silent Etsy listing-video cut for OSB, Facebook owner-groups for XMAXED. Track these separately — they won't show up in view counts. |

**Safely shared: infrastructure only** — capture discipline, consent/rights workflow,
per-venture asset folders (never one mixed dump), the firewall checklist, caption accuracy
review, and performance logging. **Never shared:** hook templates, posting frequency,
music, CTA style, or one content calendar.

**Full per-venture detail — formats, hooks, edit signature, proof device, anti-patterns,
cadence, and where the two source engines disagreed — is Section 3A, below.**

---

## 3A. Per-venture content strategy

Two independently-produced strategies — Grok, then GPT-5.6 Sol ("codex") — went deep on
each of the six ventures. What follows is the merged, firewall-checked result: craft
reasoning imported from both engines freely; every number that was a research citation,
platform-adoption statistic, or named study is **deleted** unless it also survives as Tier A
in `2026-07-29-editing-science/VERIFIED-RULESET.md` §5. Cadence and format-mix percentages
are kept as **explicit operational hypotheses** (the same Tier B convention as the rest of
this doctrine) — proposals to test, not measured facts. Where the two engines actively
disagreed, it is called out inline rather than averaged away — disagreement is information,
not noise to smooth over.

### 3A.1 Original Siberian Blue — the object is the proof; the operator's job is to get out of its way

**Audience & scroll context.** Affluent spiritual/jewellery buyers and gift-buyers, 28–55,
already mid-scroll through beauty/luxury/wellness or gifting content — not searching for
"crystal information." What stops the thumb is the object looking materially different
before any words start: true cobalt-in-quartz colour, visible depth/inclusions, an
unexpected provenance claim that reads as verifiable rather than sales copy.

**Platform priority — attention vs. revenue diverge here.** Instagram (visual luxury +
shoppable) and TikTok (discovery/curiosity) drive views; **revenue closes on the own site
and Etsy**, where a buyer already has purchase intent. **Both engines agree Instagram leads
and TikTok is second** — but they disagree on the #3 slot: Grok proposes Pinterest
(planning/gifting intent, slow-burn); Codex proposes producing a **silent Etsy listing
video** for every piece instead of treating platform #3 as a social channel at all.
**Verdict: Codex's call is the sharper one.** Etsy is a *confirmed* live sales channel for
OSB (Pinterest is not) — a listing-video cut of the same macro-rotation footage is nearly
free once the social version is shot, and it sits closer to the transaction than any third
social platform. Keep Pinterest as an unconfirmed, low-cost experiment; do not plan around
it.

**Content formats.**
1. **Macro crystal turn** — one serial-numbered piece, rotating under hard side-light:
   inclusion, colour depth, metal-setting detail.
2. **Provenance in 20 seconds** — one fact chain, on-screen text or calm voiceover, no
   jargon pile-up: discovered in Siberia → grown in a laboratory outside Moscow → ~2 months
   to grow → unique serial.
3. **Bench / setting process** — workshop hands only, **never a named individual**: raw
   stone → fitting → polish → finished piece. Craft proof, not a full tutorial.
4. **Worn in real light** — the same piece in window light, warm indoor light, and on skin;
   honest exposure, no heavy filter — "one object, four appearances."
5. **Silent Etsy listing cut** — the macro rotation + serial number, re-exported with no
   music/voice, for the listing itself.

**Hook archetypes.**
- *Rarity / object shock* — "This blue isn't dyed. It's cobalt in the crystal lattice." /
  "Watch what happens when this piece moves out of direct light."
- *Provenance correction* — "Discovered in Siberia. Grown outside Moscow. Not the same
  place." / "This started in a Soviet-era state laboratory — not a mine."
- *Scarcity by specificity* — "This is serial [number]. When it sells, this exact crystal is
  gone." / "Every piece has a number. This is the only one like it that will ever exist."

**Edit signature — and where it must deviate.** Slow to medium pacing; hold the hero
rotation several seconds, not the sub-second jump-cuts generic short-form convention
rewards. Low cut rate throughout. Brief silence or ambient before any music swells. Sparse
music or quiet voiceover — loud trending audio undermines luxury positioning. Captions
minimal and elegant (1–2 facts per screen, never karaoke word-pop). Cool true blues, metal
specular highlights, honest colour — resist heavy teal-orange or neon LUT grading that would
make the buyer distrust the actual blue. **This is a hard deviation from fast-cut
convention**: frantic editing reads as dropshipping in this category; luxury needs dwell
time for scrutiny, not speed.

**Strongest proof device.** The physical, serial-numbered crystal under honest light, with
the serial visible on camera — followed by that *exact* piece worn on a body. It proves
beauty, existence, scale and listing-fidelity in one shot. Never substitute stock footage of
a similar-but-different SKU.

**Anti-patterns.** Any mystical word-salad or fabricated lore ("Cosmic Vein" or equivalent
inventions); stating the crystal is grown *in* Siberia; any diamond-wire-saw framing; the
2500°C claim (correct is 300–400°C under pressure); a teardrop pendant (does not exist);
artificial countdown/"only 3 left" language on pieces that are already genuinely one-of-one;
**naming the artisan**; showing a different hero crystal from the one actually linked for
sale.

**Cadence.** 3–5 posts/week from batched shoot days (roughly half object/macro, remainder
split across provenance, process and wear) — an operational hypothesis, not a measured
category benchmark. Depth of asset library from one excellent shoot day matters more than
daily posting.

---

### 3A.2 Subconscious Surgery — the pattern-recognition is the hook; regulated presence is the proof

**Audience & scroll context.** Financially capable adults roughly 30–55, evening/insomnia/
post-conflict scroll, silently checking whether the speaker understands a pattern they've
been unable to shift despite intelligence and prior effort. They are testing for diagnostic
precision, not looking to be hyped.

**Platform priority — attention vs. revenue diverge sharply here.** **The two engines
disagree on where Facebook sits.** Grok ranks it #4 ("older segment, groups/retargeting");
Codex ranks it #2, reasoning that the buyer's age band skews toward Facebook/YouTube over
TikTok generally. **Verdict: Codex's instinct is right, the specific citation behind it is
not usable** (a demographic-adoption statistic that doesn't survive this doctrine's evidence
bar) — but the underlying, low-risk general knowledge that Facebook's user base skews older
than TikTok's is sound enough to justify ranking it above TikTok. Revised order: **YouTube
(long-form + Shorts as top-of-funnel) → Facebook → Instagram → LinkedIn (founder-identity
angle only) → TikTok** (attention only, brand-voice risk if it drifts toward "manifestation"
energy). **Revenue never comes from view count** — it comes from the discovery call, the
owned funnel, and the Mastermind; a platform that produces vanity views with no call/
application path is underperforming regardless of its numbers.

**Content formats.**
1. **One-pattern diagnosis** — name a precise behaviour, its protective logic, one
   self-observation, then stop (30–60s).
2. **Case anatomy** — with informed consent: before-state, the pivotal shift, present state,
   in the client's own chronology — never implied as a typical/guaranteed outcome.
3. **Mechanism explainer** — why insight alone doesn't resolve the pattern; distinguishes
   intellectual understanding from the deeper process that does.
4. **Fit / objection filter** — who this is and isn't for; filters tire-kickers rather than
   chasing broad reach.
5. **Mastermind atmosphere** — room energy, one insight from a group session, with consent.
   This is the one format that can name faces — see the publishing seam below.

**Hook archetypes.**
- *Pattern recognition* — "If you're successful on paper and still feel like you're
  repeating the same scene, this is the scene." / "You don't have a motivation problem. You
  have a loyalty-to-an-old-identity problem."
- *Mechanism, not motivation* — "Insight without interruption is just a more educated
  stuck." / "The reaction happens before your conscious explanation arrives."
- *Fit / gate* — "This work is expensive because the alternative already cost you more." /
  "If you understand your pattern perfectly and still repeat it, understanding was never the
  missing step."

**Edit signature — and where it must deviate.** Medium pacing with room to breathe;
talking-head holds can run several seconds and should cut only when meaning, emotion or
evidence changes — not on a metronome. Silence after a hard line is doing work, not dead
air; preserve it. Music low or absent under speech. Full captions (accessibility + silent
autoplay) but calm, phrase-based — never karaoke-chaos. Warm, natural skin tones; no
cyberpunk grading. **Hard deviation from "hype coach" fast-cut convention**: constant
punch-ins and stock cutaways make real transformation look like a lead-gen template; trust
rises when the viewer can watch Adrian actually think.

**Strongest proof device.** A consented, specific account showing the exact pre-existing
problem, what was tried before, what changed, and what persisted — in the person's own
words. This beats a montage of generic praise; any exceptional result needs its context
shown, not just a "results vary" disclaimer.

**Anti-patterns.** The word **"therapy"** anywhere in copy or captions (banned outright);
naming any client; publishing 1:1 client material in any form (never publishable, regardless
of anonymisation); promising permanent transformation in one session; crying-client footage
used as spectacle; luxury-signalling designed to manufacture authority; hustle/manifestation
aesthetics; hard-CTA-every-5-seconds or, at the other extreme, endless free value with no
offer path.

**The publishing seam, stated plainly (binding, not a style note):** 1:1 client material is
never publishable, in any anonymised form. **Mastermind (group) material is nameable**, with
consent — that distinction is the entire seam between what can and cannot go out.

**Cadence.** 4–7 short pieces/week plus one long-form piece if capacity allows — operational
hypothesis, weighted toward diagnosis (~40%) and case/proof (~20–25%) over pure
method-fragment or offer content. One strong diagnostic series beats daily low-effort
posting.

---

### 3A.3 AGA Bali — place-as-character; the proof is that it's real and inhabited, not that it's beautiful

**Audience & scroll context.** Conscious-travel and community seekers — remote workers,
wellness travellers, people wanting "a place that feels like a chapter" — dream-mode
scrolling, evenings, comparing Bali options. High aspiration, lower immediate purchase
urgency than a $30 product; this is the opposite tempo to OSB despite both being visual
categories.

**Platform priority — attention vs. revenue diverge widely.** Instagram leads for
place-desire and inquiry; the two engines swap YouTube and TikTok for #2/#3 (YouTube for
qualification depth vs. TikTok for candid discovery) — a minor disagreement, not worth
forcing a single order since both roles matter. **Revenue = inquiry → WhatsApp/email →
booking, not views.** Views ≠ occupied beds; track inquiry rate, not reach.

**Content formats.**
1. **Land-scale walks** — wide shots across the 13 hectares, not only a bedroom.
2. **Morning sensory piece** — birds, rain, footsteps; minimal or no talk.
3. **Guest/resident portrait** — with permission: who came, why, what they found difficult
   as well as what shifted (avoid overclaiming a spiritual outcome).
4. **East vs South Bali contrast** — concrete: quieter, different rhythm, named
   trade-offs.
5. **Place-making in progress** — planting, building, cooking, water management — community
   as labour and reciprocity, not people sitting in a circle.

**Hook archetypes.**
- *Place identity* — "Not Canggu. East Bali. Thirteen hectares. Listen." / "This is what six
  a.m. sounds like when you're not in a hotel corridor."
- *Sensory invitation* — "Walk with me from your room to breakfast — no montage." / "The
  first thing people notice isn't the view. It's how quiet their shoulders get."
- *Stay-type clarity* — "Retreat for a week. Residency for a season. Different contracts
  with the land." / "We're not selling a villa night. We're selling a place you recognise
  yourself in."

**Edit signature — and where it must deviate.** Slow pacing; landscape needs dwell time —
short shots for most material, occasional long unbroken walks or ambient holds. Heavy use of
real natural sound; music subtle or absent, never generic tropical-EDM stock. Sparse
captions (place, time, activity, stay type). True green/soil/sky colour — resist the
teal-orange travel-cliché grade that would erase what East Bali actually looks like. **Hard
deviation from nightclub-Reels travel convention**: rapid montage produces undifferentiated
"Bali retreat" fantasy and stops a serious booker from assessing the actual place; slow
observation is a credibility device here, not an aesthetic choice.

**Strongest proof device.** An immersive, real-scale walkthrough with real people present —
proving the place is functioning and inhabited, not empty architecture porn. Secondary: a
clear map/orientation and the stay-type options on screen.

**Anti-patterns.** Stock Bali tropes (swing, flower bath, "find yourself") without anything
AGA-specific; over-spiritual soft-focus that hides logistics or access; influencer-party
energy against a "conscious community" position; treating Balinese people or culture as
scenic decoration; hiding construction/weather/unfinished areas; fake scarcity on something
that's actually about belonging.

**Cadence.** 3–5/week in peak booking season, 2–3/week off-peak — operational hypothesis.
Batch-shoot on-site days; don't force a daily talking-head when there's no fresh place
footage.

---

### 3A.4 Tri Hita WtE — engineering credibility is the proof; forwardability beats virality

**Audience & scroll context.** Investors, government officials, industrial partners — a
work-mode audience with low tolerance for entertainment fluff, screening for competence
signals and deal relevance. This is the one venture where the viewer is actively hostile to
being "sold" in a short-form register at all.

**Platform priority — attention and revenue diverge more here than anywhere else in the
portfolio.** LinkedIn leads for both attention and relationship-seeding; YouTube is the
technical-explainer/diligence library. Both engines separately flag a real non-platform
distribution channel worth taking seriously: **forwarded clips via WhatsApp/private share**
(Grok) and **embedding in industry/government presentation decks** (Codex) — these aren't
competing, they're complementary; both matter more than growth on Instagram/TikTok, which
rank lowest for this venture and should not be prioritised. **Views here almost never equal
LOIs** — revenue is relationships, RFPs, site visits, term sheets; a short-form clip is a
credibility brochure that moves, not a sales channel by itself.

**Content formats.**
1. **Modular-system diagram in motion** — one module, then the scale-up logic.
2. **Problem framing for Indonesia** — waste/energy/social layer handled factually, never as
   poverty-porn or CSR-poster sentiment.
3. **Site / hardware reality** — real metal, real process, when filmable — the
   anti-vapourware format.
4. **Investor-risk answer** — one hard objection per video (feedstock security, offtake,
   permitting, FX exposure) answered directly, not deflected.
5. **Operator/team credibility** — who builds, who partners, what stage (pilot vs. deploy) —
   stated plainly, no overclaiming of stage.

**Hook archetypes.**
- *Industrial problem* — "Organic waste is not a CSR poster. It's feedstock." / "If your
  waste-to-energy plan can't explain feedstock logistics, you don't have a plan."
- *Modular clarity* — "One module. Then n modules. That's the point." / "We're not pitching
  a cathedral plant first. We're pitching repeatable units."
- *Risk-first credibility* — "The hardest part of biomethane is not the digester." / "Before
  discussing returns, ask who controls the feedstock for the next fifteen years."

**Edit signature — and where it must deviate.** Calm, deliberate pacing; diagrams stay on
screen long enough to actually trace, cuts land at logical transitions rather than a
retention-driven interval. Minimal or no music — voice and real site sound dominate.
Captions read like an analyst's briefing: complete sentences, correct units and terms, never
kinetic-ad styling. Clean industrial colour — steel, concrete, feedstock, gas infrastructure
— never green-leaf/globe stock animation. **Maximal deviation from Gen-Z rapid-cut
convention**: fast edits here read as consumer-app, not bankable infrastructure, and
actively impair the comprehension this format exists to build.

**Strongest proof device.** A real site shot with the accountable technical/executive lead
present, paired with one verifiable, connected artefact — a signed offtake or feedstock
agreement, a permit, gas-quality output, commissioning evidence, a named institutional
partner. A logo wall with no connected claim is not proof.

**Anti-patterns.** "Save the planet" slogans without engineering; unqualified revenue/IRR/
emissions/tonnage claims; describing an MoU as a closed deal; crypto/moonshot-hype
aesthetics; consumer-influencer format; treating pemulung or informal waste workers as
passive scenery rather than a factually-handled part of the system; posting daily filler
that makes the firm look unserious.

**Cadence.** 1–3 substantial pieces/week, or as few as 2–4/month if production is heavy —
operational hypothesis, and deliberately the lowest-volume venture in the portfolio
alongside Ashta. Post only when a real milestone exists; silence is preferable to
manufacturing an update.

---

### 3A.5 Ashta — epistemic restraint IS the brand; strip every register that suits OSB

**Audience & scroll context.** Scientifically-minded, consciousness-curious, allergic to
"woo" — often already following neuroscience, philosophy-of-mind or research-methodology
content. They stop for a claim framed as testable, a visible methods hint, or a sharp line
between experience and evidence — and they leave the instant they smell mystical language
dressed as science.

**Platform priority — attention vs. revenue/legitimacy diverge.** YouTube (Shorts +
long-form) leads as both discovery engine and research archive; LinkedIn reaches
researchers, collaborators and institutionally-credible participants. **The engines differ
slightly on X/Twitter's role** — Grok ranks it #2 as idea-circulation among researchers;
Codex treats it as a distribution layer for discussion, not a primary video home, ranked
below Instagram. **Verdict: Codex's framing is the safer default** — X is worth
cross-posting threads/clips to, but building a primary content cadence around it risks the
platform's own discourse tone bleeding into Ashta's voice. If Ashta's "revenue" is research
participation, grants, licensing or membership, reputation is built on YouTube/X and
conversion happens through application/waitlist trust — not impulse anything.

**Content formats.**
1. **Claim audit** — one popular assertion on screen, labelled supported / unsupported /
   genuinely unresolved.
2. **One concept, one definition** — operationalise a single term (e.g. attention,
   reportability) cleanly.
3. **Methods glimpse** — a study-design sketch or data-pipeline metaphor, no fake results
   implied.
4. **Competing explanations** — two or three models for the same observation, naming what
   evidence would separate them.
5. **Founder/researcher desk talk** — dry, direct, no guru staging.

**Hook archetypes.**
- *Anti-woo boundary* — "If your consciousness content can't survive a methods section, it's
  entertainment." / "We're not here to sell you a vibration. We're here to ask what can be
  observed."
- *Operational definition* — "Before we argue about consciousness, define the measurement."
  / "A subjective report is data. It is not automatically a theory."
- *Falsifiable tension* — "What result would make us abandon this hypothesis?" / "If this
  effect is real, an independent lab should be able to make it fail the same way."

**Edit signature — and where it must deviate.** Thoughtful, moderate pacing — allow a full
second or two to actually read a definition on screen. Low-to-medium cut rate. Sparse,
non-mystical music (no singing bowls, ever, even ironically — too easy to misread). Clean
diagrams and stable, labelled captions (a workable device: mark segments **OBSERVATION /
INTERPRETATION / LIMITATION / SOURCE** on screen so the audience can see where a claim's
certainty actually sits). Cool, lab-adjacent, high-contrast colour — never purple-galaxy
stock. **This is the one venture where the OSB voice is actively destructive**: strip
mystical register entirely, no crystal/third-eye/sacred-geometry visual language, no
"science has proved" openings, no quantum terminology used as metaphor without labelling it
as metaphor.

**Strongest proof device.** Methodological seriousness shown on screen — a real study
structure, a clear definition, an explicit statement of what is *not* claimed. Never
fabricate peer review or results; named collaborators and open questions are secondary
evidence, not the headline.

**Anti-patterns.** Any mystical/woo visual register (this is the firewall's binding line,
not a style preference); overclaiming unpublished findings; "scientists don't want you to
know" framing; false balance between a real result and an unsupported claim; ridiculing
spiritual experiencers (alienates potential participants and reads as cruelty, not rigour);
presenting a hypothesis as a settled finding; the Adrian-is-an-Arcturian-soul identity claim
— this stays strictly private, full stop, regardless of how the philosophy (oneness,
synchronicity) may be woven subtly elsewhere.

**Cadence.** 2–4 shorts/week plus longer pieces only when there's real substance —
operational hypothesis, deliberately low-volume alongside Tri Hita. Epistemic trust
compounds slowly and breaks fast; do not post empty volume to look active.

---

### 3A.6 XMAXED — sound and motion are the proof; this is the one venture allowed to move fast

**Audience & scroll context.** Scooter/motorcycle enthusiasts, younger-skewing but not
exclusively, community-driven and visual — garage energy, comparing builds, music on,
high-dopamine feed. This is the mirror image of OSB: object-led like OSB, but rewarded by
speed where OSB is punished by it.

**Platform priority — attention vs. revenue.** TikTok and Instagram Reels roughly tie for
attention (visual + sound culture); YouTube carries build series and install guides for
viewers closer to a parts decision; Facebook/community groups carry real reputation and
local-job revenue that platform metrics won't show. **Attention lives on TikTok/Reels;
revenue is closed via DM, WhatsApp, workshop visit or marketplace** — track those, not view
count.

**Content formats.**
1. **Pull/roll test** — phone-mounted, honest conditions, no speed-overlay fakery.
2. **Build timelapse** — box → installed part → first start.
3. **Sound check** — cold start, rev, drive-by, real audio only.
4. **Before/after stance and fitment** — wheels, exhaust, lights, with the clearance check
   left in, not cut away from.
5. **Meet/community clips** — other owners, reactions, with consent.

**Hook archetypes.**
- *Sensory shock* — "Stock XMAX vs. this exhaust. Volume up." / "Watch the front — first
  pull after the remap."
- *Build specificity* — "Part list on screen. No mystery boxes." / "This started as a
  standard XMAX. Here are the four changes that altered it."
- *Scene belonging* — "XMAX owners — rate this build one to ten." / "Would you keep the
  comfort, or take this stance?"

**Edit signature — and where it's allowed to differ from every other venture.** Fast where
motion is the actual point — short action shots are fine — but hold long enough on the
engine note or the clearance check that it can be inspected; never cut *over* the best sound
moment or away from the moment enthusiasts scrutinise most. Real engine/exhaust/tool sound
carries proof-weight; music can drive a montage but must drop out for any sound comparison.
Bold, few-word captions naming the part. High-contrast, night-neon-if-authentic colour —
explicitly **not** luxury-jewellery grade; crossing OSB's aesthetic into this venture (or
vice versa) confuses both brands. **This is the one venture that may use fast-cut
convention** — but even here, cutting away before the clearance check or the exhaust note
turns the video into hype instead of proof.

**Strongest proof device.** A controlled before/after — same scooter, same camera position,
same conditions — for whatever the claim actually is: sound A/B, measured clearance, weight,
or a genuine braking/acceleration comparison. A cinematic reveal proves appearance; it does
not prove performance, and claiming otherwise is the fastest way to lose this audience's
trust.

**Anti-patterns.** Claiming a performance gain without measurement; fake exhaust audio or
music covering the real sound; cutting so fast the fitment quality can't actually be
inspected; unsafe road behaviour presented as brand aspiration or road-legality glossed
over; luxury-spiritual crossover aesthetics (confuses the brand); stolen clips of someone
else's build presented as this venture's work.

**Cadence.** 5–10+ posts/week is genuinely sustainable here if content is captured as a
byproduct of real workshop activity — film every install, cut many shorts from one job.
This is the one venture where volume is close to free; it is also the one venture with
essentially no estate yet (§4), so the volume has to be built from here forward rather than
cut from an archive.

---

### 3A.7 Where the two engines disagreed — consolidated

| Venture | Disagreement | Verdict |
|---|---|---|
| Sequencing (all six) | Grok: XMAXED→OSB→SS→AGA→Ashta→Tri Hita (production-effort ROI). Codex: OSB→SS→XMAXED→AGA→Tri Hita→Ashta. | See extended §4 below — Codex's framing is closer to right, and neither engine weighs the corpus already on disk. |
| OSB, platform #3 | Grok: Pinterest. Codex: a produced Etsy listing-video cut. | Codex — Etsy is a confirmed live channel; Pinterest is unconfirmed. The Etsy cut wins the #3 slot; Pinterest stays an optional, low-cost experiment. |
| SS, platform rank | Grok: Facebook #4. Codex: Facebook #2 (age-demographic reasoning). | Codex's instinct — Facebook above TikTok for this buyer age band — survives on general knowledge even after the specific supporting statistic is stripped. |
| AGA, platform #2/#3 | Grok: TikTok #2, YouTube #3. Codex: YouTube #2, TikTok #3. | Not forced to a single order — YouTube for qualification depth, TikTok for discovery; both matter, sequence is secondary. |
| Ashta, X/Twitter's role | Grok: X #2, a primary idea-circulation surface. Codex: X/Reddit as discussion distribution only, not a primary video home. | Codex — the safer default; building cadence around X risks its discourse tone bleeding into Ashta's epistemic register. |
| Tri Hita, distribution channel | Grok: forwarded WhatsApp/private clips. Codex: embedding in industry/government presentation decks. | Both kept — complementary, not competing; neither is "platform growth" in the conventional sense and both outrank Instagram/TikTok for this venture. |

---

## 4. Sequencing — and where I depart from the council's answer

The two independently-produced strategies don't even agree with each other on the
effort-ranking, before the corpus is weighed at all:

| rank | Grok (return per production effort) | Codex-Sol (return per production effort) |
|---|---|---|
| 1 | XMAXED | Original Siberian Blue |
| 2 | Original Siberian Blue | Subconscious Surgery |
| 3 | Subconscious Surgery | XMAXED |
| 4 | AGA Bali | AGA Bali |
| 5 | Ashta | Tri Hita WtE |
| 6 | Tri Hita WtE | Ashta |

**Grok put XMAXED first** — correct for an operator starting from nothing and assuming
workshop activity supplies footage at near-zero marginal cost. **Codex-Sol put OSB first
and SS second**, reasoning from existing $200–650 purchasable inventory and the density of
assets a single shoot day yields — much closer to the corpus argument below than to a pure
per-post production-cost model.

**My verdict on the engines' own disagreement:** Codex is closer to right, for the same
reason the corpus table below makes XMAXED wrong to lead with — it reasons from what
already *exists* (serialised, purchasable inventory; a shoot day that yields a library)
rather than treating workshop footage as free. Grok's XMAXED-first case only holds once
build/workshop activity is actually producing footage at volume — plausible eventually,
unproven on an estate of one recording. **On the tail end, Codex's call is also the better
one**: it ranks Ashta last, Grok ranks Tri Hita last. Tri Hita posts rarely but each post is
a straightforward milestone explainer; Ashta's proof device — every scientific claim needing
a source trail — carries a verification burden *per post* that Tri Hita's milestone-gated
cadence doesn't. Ashta is the slower one to produce at any volume, not just the
lowest-revenue-per-view one — so Ashta last, not Tri Hita, is the sharper read.

Neither engine, however, weighs the corpus already on disk — that is a different question,
answered here:

| venture | indexed corpus on hand |
|---|---|
| subconscious-surgery | 884 substantive recordings + **~58h / 525,669 words of Mastermind** |
| original-siberian-blue | 3,234 described product images; 351 live catalogue pieces |
| xmaxed | **1 recording** |

XMAXED tops Grok's effort ranking (and still sits third even in Codex's more conservative
one) while holding essentially no estate. **Ranked by what can be cut from what already
exists, the order inverts further still: SS → OSB → XMAXED.**

Both rankings are real and they answer different questions. The resolution: **cut SS from
the archive while shooting XMAXED as a byproduct of workshop activity that is happening
anyway.** They do not compete for the same hours — one is edit-time, the other is
capture-time.

**Do not** make Tri Hita or Ashta the primary short-form investment. Wrong medium-to-money
mapping for scarce attention.

---

## 5. The measurement loop — how this stops being opinion

Every Tier B number here is a hypothesis. The instrument to settle them is being built:
it pulls real insight data for already-published videos, extracts objective edit features
from the source files (shot count, ASL, time-to-first-speech, leading silence, integrated
LUFS, caption presence), and joins them.

**IT HAS NOW RUN, AND IT OVERTURNS THE PREMISE OF THIS DOCUMENT. [Tier A — measured on
Adrian's own published videos, n=16]**

| verified rule | compliance on Adrian's own reels |
|---|---|
| speech within 3s | **14/16** (starts <0.5s) |
| burned-in captions | **16/16** |
| loudness in spec | **15/16** |

**Every rule in Section 2 is already being obeyed on essentially every video — and reach
collapsed ~30× anyway.** A 2023 reel on the SS page drew **316 plays**; 2026 reels draw
**2–34**, while the editing became *more* sophisticated.

**A rule already obeyed on every video cannot explain variance between videos.** This does
not falsify Section 2 — those rules remain the correct floor, and they are being met. It
means **craft is not the lever. Distribution is the binding constraint.**

**Do not commission an editing-optimisation build as the answer to poor reach.** The
editing is the one thing already compliant. Fix distribution first: cadence, platform
choice, and sends-per-reach (which drives *unconnected* reach on Reels).

**Statistical honesty — why this is a hypothesis and not a law.** n=16. Minimum detectable
correlation |r| = **0.651**; the strongest edit-feature correlation in the data is
**0.636 — below it**. Nothing reaches significance; that is arithmetic, not hedging. The
only relationship clearing the threshold is a **confound**: days-since-publication vs
plays, rho = **+0.708**. Correlations are stored tagged `"UNDERPOWERED — do not interpret
as a finding"`. n≈30 needed for large effects, n≈85 for moderate.

**Length is the only edit feature with genuine spread** (23.6–94.6s) and is therefore the
first thing to test as n grows.

**Two concrete defects found, worth fixing regardless of any retention theory:**
`01-THU-PM` clips at **+0.77 dBTP** (only file outside −16…−14 LUFS), and
`0-SELF-PRESERVATION-BROLL` opens on **2.6s of dead air** — a direct violation of Rule 1.

**The `publication` table in content-index.db is currently EMPTY (0 rows).** Nothing in the
vault records what has ever been published, which is structurally why the posting
accountant could not see reposts. Until publishes are recorded there, no content→outcome
loop can close. Fixing that is a prerequisite for this section, not an enhancement.

---

## 6. Firewall — binding on every venture

- **SS: never the word "therapy."**
- **⚠️ CORRECTED 2026-07-30 (Adrian-direct). An earlier draft of this line said "no client
  named" and "1:1 material is never publishable." BOTH WERE WRONG and they under-counted
  the usable corpus badly.** The actual rule:
  - **Mastermind (group call) content — participants CAN be named, quoted and used with
    full transparency.** It is a public mastermind that people subscribe to; everyone
    consented to being recorded for a training programme. There is no blanket
    "never name a client" rule for Mastermind, and there never was.
  - **Private 1:1 sessions — Chatham House.** That means the **content and the insight ARE
    usable**; only the identity is not attributed. It does NOT mean the material is
    unpublishable. Treating 1:1 as unusable discards a large, legitimate seam.
  - The **SOURCE of the specific recording** decides which rule applies — not the person.
    One person can be both a Mastermind participant and a private 1:1 client.
  - **An affirmatively-given testimonial is consent, full stop.** If someone handed over a
    video or written testimonial for marketing use, that act IS the permission. Never raise
    a "needs consent" item for it.
  - **An orthogonal restriction always wins** over the general Mastermind rule — an active
    crisis, a live legal dispute, or a standing personal firewall. Check for one before
    reclassifying anything out of `strictly-private`; on 2026-07-30 all six Mastermind
    recordings marked strictly-private turned out to be correctly classified for exactly
    such a reason.
  Canonical: [[feedback-ss-mastermind-vs-1to1-attribution]].
- **OSB:** crystal discovered in Siberia, **grown in a laboratory outside Moscow — not in
  Siberia**, ~2 months per crystal. **300–400°C under pressure, NOT 2500°C.** Never
  "Cosmic Vein." Never mention diamond-wire-saw cutting. No teardrop pendant exists. The
  **KGB origin is real and is the USP — never strip it.** The artisan is never named
  publicly, and a draft of this strategy surfaced that name — it must not reach copy.
- **Ashta:** strip all mystical register. It is the one venture where the OSB voice is
  actively destructive.
- Adrian's Arcturian *identity* claim stays strictly private; the philosophy may be woven
  in subtly.

---

## PROMOTION NOTE (added 2026-08-04, does not alter any finding above)

The "Open" section immediately below is carried forward unchanged from the original draft,
following this file's own §6 correction convention (append, don't delete). It is now **stale
on two of its four points** and should be read as historical:
- "The codex leg and cross-audit of the venture strategy" — **already done.** §3A above IS
  the merged, cross-audited Grok+Codex result, and §3A.7 tabulates every point of
  disagreement between them. This was true at promotion time and had been true since
  shortly after the draft's original 2026-07-29 date — the closing note was never updated
  to match.
- "Per-venture content-estate counts from the housekeeping audit" — **partially done.** §4
  has real counts for three ventures only (subconscious-surgery, original-siberian-blue,
  xmaxed). AGA, Tri Hita and Ashta counts were never folded in. Treat §4's corpus table as
  incomplete, not wrong, and verify against a fresh housekeeping audit before using it for
  any sequencing decision that matters.
- The other two open items (segment-recovery count, empirical baseline's final n) were not
  independently re-checked at promotion time — status unknown, not confirmed resolved.

## Open, folding in when the running jobs land
- Per-venture content-estate counts from the housekeeping audit.
- The codex leg and cross-audit of the venture strategy.
- Segment recovery results — the number of newly cuttable Mastermind segments.
- The empirical baseline's actual n and which metrics the API granted.
