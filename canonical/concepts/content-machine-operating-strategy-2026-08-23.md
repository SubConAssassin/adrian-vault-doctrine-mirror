---
title: The Content Machine — Macro Operating Strategy
type: concept
status: canonical
created: 2026-08-23
firewall_class: working-internal
supersedes_nothing: true
relates_to:
  - .claude/skills/mkt-reel-craft/SKILL.md            # the production line (craft law)
  - .claude/skills/mkt-social-deploy/SKILL.md         # the deploy surface
  - companies/subconscious-surgery/mastermind-launch/ # 844KB of launch strategy, written Jun-Jul 2026
  - canonical/concepts/cli-prompting-art-per-engine-delivery.md  # the six-lane team
grounding_attestation: "Every number in §1 and §2 was computed against the live databases on
  2026-08-23 and the query is recorded alongside it. Platform claims in §4 carry source URLs from
  a live-web research pass the same day. Nothing here is estimated unless labelled ASSUMPTION."
---

# The Content Machine — Macro Operating Strategy

## §0 THE ONE-LINE DIAGNOSIS

> **Nothing is missing. Everything is disconnected.**
> The strategy exists (844 KB, written June–July, orphaned). The craft law exists (1,739 lines,
> machine-gated). The corpus is mined (19,229 hooks from 861 of 1,037 hours). ~400 finished reels
> exist. What does not exist is a **spine** connecting them, and a **closed loop** that records
> what shipped and what it did.

The funnel was not starved of content. It was dammed at four specific valves, all of which were
mechanical and three of which were free to open.

---

## §1 THE MEASURED STARTING POINT (2026-08-23, morning)

| Layer | State | Query basis |
|---|---|---|
| Recordings | 20,419 — **but 7,756 (38%) are husks under 20 words**; real mineable ≈ 12,600 | `recording` ⋈ `transcript` |
| Transcription | **100% complete.** Zero recordings lack a transcript | `LEFT JOIN transcript ... IS NULL` → 0 |
| Audio corpus | 1,037.1 h. **Unmined: 175.8 h (17%)** — the small number | wpm proxy 129.1, calibrated on 10,669 dual-field rows |
| **Mined but stranded** | **411.6 h across 2,369 recordings** — hooks exist, not one anchored | the real loss |
| Hooks | 19,229. **70.3% unreachable** by `ORDER BY score DESC` (3 incompatible scales + 5,913 unscored) | `hook.score_scale` |
| Anchored | 4,281 (22%) — the anchoring pass **ran once, 2026-08-06, never scheduled again** | `hook_anchor.anchored_utc` all identical |
| Shippable end-to-end | **25** | ready ⋈ clear ⋈ anchored ⋈ local media |
| Published, recorded | **0 rows** in `publication`; no code anywhere writes to it | — |
| Published, actual | 33 FB + ~16 IG posts in 2026 via ≥3 disconnected paths; one reel went out 4× | Graph API |
| Revenue | Kajabi **£0 for 24 consecutive months**, 1 community member (Adrian) | Kajabi |

### The four valves
1. **Anchoring** — a script that was never scheduled. *Free to fix.*
2. **Self-containment** — the anchor matches the hook SENTENCE; nothing extends it to a complete
   thought. 26% of anchors are <5 s, 54% are 5–15 s. **This is the mechanical cause of "half a
   story."** *Fixable on the free local lane.*
3. **Ranking** — three incompatible score scales made 70% of the library invisible. *Free to fix.*
4. **Distribution** — no poster, no publication record, no measurement loop. *The only one that
   needs a build.*

---

## §2 WHAT CHANGED TODAY, AND WHAT IT COST

| Action | Before | After | Cost |
|---|---|---|---|
| Re-ran the existing anchor script | 4,281 anchors | **8,887** (+4,606) | $0, minutes |
| Repaired clip in/out points on the free M2 lane | anchors avg 11.4 s | **avg 28.7 s, 86% self-contained** | $0, ~4 h local |
| Normalised the three score scales into one view | 5,715 rankable | **13,316** | $0 |
| Re-asserted the firewall (`firewall_hold`) | 167 hooks unguarded at the consent layer | 0 reachable downstream | $0 |
| Applied the mastermind-consent standing decision (strict 2-signal test) | — | **+1,048 hooks authorised**, 76 recordings | $0 |
| **Shippable clips, every gate measured** | **25** | **1,351** (1,220 in the 15–60 s band, **595 distinct sources**) | — |

**Source diversity, the original complaint:** 595 distinct source recordings, maximum 7 clips from
any single one. The batch that caused *"they all look the same"* was 16–18 clips from one podcast.

### Reversibility
Every change is additive and reversible. Nothing was overwritten, moved or deleted.
```
DELETE FROM hook_anchor      WHERE audit_ref LIKE '%reanchor-run2';
DELETE FROM consent_override WHERE audit_ref='2026-08-23-mastermind-consent-doctrine';
DROP TABLE firewall_hold; DROP TABLE clip_repair;
DROP VIEW v_shippable; DROP VIEW v_authorised_hook; DROP VIEW v_hook_rank;
-- v_cuttable original definition: evidence/v_cuttable.ORIGINAL.sql
```

---

## §3 THE SPINE — one authorisation test, one shippable list, one ledger

The defect underneath the firewall incident was not a bad rule. It was **every tool inventing its
own consent test**. My own repair job filtered on `consent_gate='clear'` alone and ingested 37 held
hooks before I caught it in a self-audit.

**Law: nothing selects content by writing its own consent SQL. Everything reads `v_authorised_hook`.**

```
v_authorised_hook  = publishable=1
                     AND NOT IN firewall_hold
                     AND (consent_gate='clear' OR consent_override='clear')
        │
        ▼
v_shippable        = authorised
                     ⋈ clip_repair(verdict=complete, opens_clean, reaches_payoff)
                     AND 12s ≤ duration ≤ 90s
                     AND filler_rate < 6%
        │
        ▼
   posting queue  ──▶  publish  ──▶  publication (CURRENTLY THE MISSING ROW)
```

The `publication` table is the open end of the loop. Until a publish path writes to it, the
accountant is blind, a reel can go out four times, and no rotation rule can be enforced.
**Closing that loop is the highest-value remaining build.**

---

## §4 PLATFORM ALLOCATION (live research, 2026-08-23, sources on every claim)

### The single most important correction
**A YouTube channel already exists: 154 videos, 292 subscribers, dormant ~1 year.**
This is not a cold start. Every plan written on "no YouTube presence" is mis-framed.

#### What dormancy actually costs (verified against YouTube's own docs, 2026-08-23)
- **There is no recommendation penalty for inactivity.** YouTube evaluates each video individually;
  an underperforming video does not penalise the channel. There is no "gap tax" and no "comeback
  multiplier" — the first upload is scored like any other. (support.google.com/youtube/answer/16559651)
- **What dormancy DOES cost:** monetisation may be switched off after 6 months of no uploads or
  Posts (a Partner Program activity rule, not a discovery penalty — irrelevant at 292 subs); and
  since April 2026 **push notifications are cut for subscribers who have not watched in ~a month.**
  After a year dark, assume almost none of the 292 get a phone ping.
- **The subscriber count is not the audience.** It counts historical subscribe events. Unique
  Viewers in the Audience tab is the real number. Read that before planning anything.
- 🔴 **REAL RISK, not folklore:** a 17-year, 58k-sub channel dormant five years was **terminated in
  early 2026** for "spam, scams, commercially deceptive content" after a burst of ~10 uploads —
  an apparent automated false-positive for account takeover. **Do not dump a batch on day one.
  Space uploads, keep the Google account / 2FA / country consistent.** One weekly upload, never a burst.
- Folklore explicitly NOT in any YouTube doc: the "90-day algorithm memory", "the channel is
  shadowbanned for being quiet", "one great video reignites everything". All [NOT FOUND].

#### Publish-first, not audit-first — the decision rule
Re-optimisation pays only on videos that **still get impressions**. A dormant 292-sub library does
not. The famous re-opt case studies (+32% views, +140% subs) were run on live million-sub channels
whose back catalogue was still being served. Copying that onto this channel wastes weeks.

**Cap the channel-surface prune at 72 hours, then ship.** Per video, last 365 days in Studio:
- **KEEP AND RE-PACK** only if on-brand AND in the top quintile of impressions AND CTR is weak.
- **KEEP AND IGNORE** if on-brand and true, even at tiny views — the library is depth for a new viewer.
- **UNLIST** if off-brand, low quality, or it is the first thing a $25k buyer would see. Links still
  work, stats survive, it leaves search/related/Videos tab.
- **DELETE only for policy or legal.** Deleting removes the video from viewers' watch history, which
  severs a recommendation connection to people who already watched you.

#### The revival sequence
Week 1: analytics export (Unique Viewers, not subs) · banner/avatar/About/links · unlist the
pollutants · playlists + Home sections · a <60 s trailer cut from existing footage · one Posts-tab
post · **then** long-form 1 on day 4, and two Shorts on days 5 and 7 with Related Video pointing at it.
Weeks 2–3: same pillar, cluster don't scatter. Weeks 4+: step up to the 47-minute class **only if**
average-percentage-viewed on the 13-minute files is not a cliff.
**Start with `ss-solo-mid` (avg 13 min), not the 76-minute multi-person files.** A 13-minute video
that holds is a better first signal than a 76-minute file that dies at minute 8.
Re-packing happens in the gaps between uploads, never instead of them, and one variable at a time
(title OR thumbnail, then watch 3–7 days) so you can tell which lever moved.

**Do not optimise for the Partner Program.** At 292 subs you are ~708 subscribers and 4,000 watch
hours short, and YouTube is an acquisition channel for a $997–$50,000 ladder, not an ads play.

### Order of operations: long-form FIRST, clips the same week
Not shorts-first. The evidence:
- Shorts are **61.5% of organic YouTube views** (Metricool, 32.3 B-view sample) — discovery.
- Long-form carries conversion: one creator P&L measured Shorts RPM $0.04 vs long-form $4.47, and
  dropped 41% of total views while raising revenue 136% by shifting weight to long-form.
- Shorts-acquired subscribers watch long-form at ~5–15% vs 30–60% for long-form-acquired.
  **A shorts-only channel trains an audience that will not buy a $2,499–$9,999 offer.**
- Hybrid lift is real but non-linear: ~5 Shorts/month correlated with +47% long-form views;
  **35+/month showed no lift at all.** Volume is not the lever; topic-matching is.
- Every documented archive-mining case (Jay Shetty, ESPN, KFC Radio) published the pillar first,
  then clipped around it. KFC Radio's themed archive recut: +43% views, +65% watch time, +58% revenue.

### The allocation

| Platform | Object | Cadence | Role | Why this number |
|---|---|---|---|---|
| **YouTube long-form** | 12–25 min talk cut, chapters, custom thumb | **1–2 / week** | The conversion asset | vidIQ: 4–7/month band is where subscriber growth turns positive (0.39% → 0.63%) |
| **YouTube Shorts** | 15–45 s, **Related-Video linked to its parent talk** | 3–5 / week | Discovery | Metricool starter band; the Related Video link is the bridge, and without it conversion is not claimed by YouTube |
| **IG Trial Reels** | 15–45 s | 4–5 / week | Cold test, **non-followers only** | Official: Trials don't touch your 1,354 followers. Do not burn the warm list as a test set |
| **IG Reels (graduated)** | the Trials that performed | 2–3 / week | Follower growth | Reels ≈ 4.7× median reach of other formats |
| **IG Carousel** | offer mechanics, teaching | 1–2 / week | Saves & nurture, not reach | Carousels 2.3× save rate; Reels 8× follower acquisition. Different jobs |
| **Facebook Reels** | same clean master | 3–4 / week | 8 pages already exist, no cold start | All FB video is Reels since Jun 2025, any length/orientation |
| **LinkedIn native** | 1–5 min | 2 / week | Where a high-ticket buyer lives | 100 k-video dataset: like-peak at 2–5 min; native beats links |

**One clean master, no platform chrome.** 1080×1920, H.264 High, AAC 48 kHz, burned-in captions.
Cross-posting the same clean file is **not** penalised — the penalty is a competitor **wordmark**
(Mosseri, Aug 2026). Never use TikTok's "share to Instagram"; it burns the watermark in.

**Duration decision rule:** hook tests 12–18 s · teaching clips that must earn a save 45–60 s ·
never over 3 min for discovery (IG will not recommend >3 min to new audiences). Our shippable pool
is already shaped for this: 682 clips at 15–30 s, 426 at 30–45 s, 112 at 45–60 s.

---

## §5 THE SELECTION ALGORITHM

Adrian's standing rule: **never rank on transcript cleanliness — it reliably selects the rehearsal
take.** His approved hook measured +63% RMS and +55% pitch range against the rehearsal, and was
slower. Text finds candidates; delivery chooses between them.

**Delivery ranking does not exist yet** — zero prosody columns across all four databases. It is
cheap to build: measured 0.14 s/hook locally, ~8 minutes for the whole addressable pool at 8-wide.
Until it exists, rank on this and label it interim:

```
rank = 0.40 · rank_norm_0_1        (percentile within score regime — fixes the 3-scale problem)
     + 0.25 · self_containment      (verdict=complete AND opens_clean AND reaches_payoff)
     + 0.15 · duration_fit          (peak at 15-45s, taper outside)
     + 0.10 · (1 - filler_rate/0.06)
     + 0.10 · source_freshness      (penalise a source already used this fortnight)
── then ──
   HARD ROTATION: no two adjacent posts share a source_video, a theme lane, or an opening device.
```

The rotation constraint is not a preference. The 2026-07 batch broke it and produced the
"all look the same" complaint; the accountant added `source_video` as a 7th axis but has no
publication rows to check against, so **it currently validates a queue, not reality**.

---

## §6 THE RULE RECONCILIATION

A full sweep found **17 live contradictions** between the craft skill, the gate, the engines and
the venture strategy docs. Adjudications (later + more specific wins; the live craft skill
outranks its own engine):

| Rule | Conflict | Governs |
|---|---|---|
| Caption words/card | skill max 3 · gate 2–4 · archive 3–5 · research 3–7 | **max 3** |
| Caption pause break | skill 0.45 s · engine 0.60 s | **0.45 s** |
| Caption type size | skill ~100 px · engine 76 px | **skill** |
| Caption emphasis | skill amber · engine + IG strategy coral | **amber** for reels; coral is stale venture guidance |
| Caption band Y | 68% · older 66% | **68%** |
| B-roll entry | architecture "on the word" · skill 0.10–0.33 s pre-roll | **pre-roll** |
| B-roll share | playbook mandatory 55–65% · gate advisory since 2026-08-04 | **advisory** |
| CTA tail | older ends −1.5 s · current holds final frame | **final frame** |
| Max shot length | craft/gate 6 s · old QA engine 7–12 s | **6 s** |
| Reel duration | craft 30–60 · repurposing 15–60/30–90 · deploy 3–90 · venture 45–90 | **3–90 is the platform envelope; 30–60 is the craft target** |
| Music | old strategy "trending audio" · craft: no cleared library | **no track without licence evidence** |
| 1:1 material | skill "never content" · corrected canon "usable, identity anonymous" | **corrected canon** |
| Testimonials | IG strategy per-client clearance table · later rule | **a testimonial given IS consent** |

**Orphan rules** found in memory/canon but in no skill — all belong in the craft skill's SOURCE
HUNT and CONSENT sections: search Adrian's own dictation before building any explainer; identify
the underlying source recording before building a candidate; enumerate the whole library before
applying recency; build only from vetted candidate lists; watch the cut and confirm no
non-consented identifiable person appears.

---

## §7 THE GATE PROBLEM

An audit of all 64 checks in the reel gate found **10 critical and 19 high-severity checks that
compare a manifest field to another manifest field.** A bad edit with a copied-good manifest passes
all of them. Named examples: the single-AV-unit check reads builder-supplied command strings; the
speaker gate reads a self-asserted boolean; the watch-before-publish check reads three booleans
that can be written without watching; b-roll share, scene-change cadence and every pacing rule are
manifest-derived.

**Law: a check that never opens the artifact is lint, not a gate.** The five gates that do not
exist at all and must be built — self-containment, filler/dead-air, camera selection by measured
face-detection across the whole window, audio provenance and integrity, and b-roll share proven
from rendered pixels — have runnable specifications and known-bad + permit fixtures ready.

Self-containment is **already measured** as of today (`clip_repair`); the other four are specified
and unbuilt.

---

## §8 THE PRODUCTION CEILING NOBODY HAD MEASURED

**B-roll is the binding constraint, not content.**
45 consent-clean clips are reachable today — **9 min 25 s** — against **4,471 s of demand** for the
top 500 reels. That is **12.6% of need**. 97.2% of the 11,134-clip footage catalogue has never been
face-reviewed. The 2.3 GB semantic index that could make a larger bank searchable has a broken
primary key: only 41% of its rows still point at the file they describe.

Three consequences:
1. The 55–65% b-roll target is **arithmetically unreachable** at current supply. Its downgrade to
   advisory was correct.
2. Depict-don't-label reels are supply-limited; **speaker-led clips are not.** Lead with A-roll.
3. Face-review of the footage catalogue on the free PC vision lane (measured 2,196 img/hr) is the
   cheapest way to lift the ceiling. It has never been run.

**Source quality is strong where it matters:** 20 physical events, 683 GB, 15 with 2+ camera files,
**11 with a dedicated mono lav on Adrian — 19.9 hours.** And every byte is readable today over
`rclone serve http` (1,310 files probed, zero downloaded, zero failures) — so `media.is_local` and
the reachability table are **stale mount-predicates** that were under-reporting the cuttable pool
to near zero. That is why "shippable" read 25 this morning.

---

## §9 THE FIRST 90 DAYS

**Weeks 1–2 — close the loop.** Write the publication path (publish → row in `publication`). Point
the accountant at real publication rows, not the queue. Materialise and register the ~400 rescued
reels. Re-open the YouTube channel: banner, trailer, 8–12 long-form pillars from the 112 scored
candidates. Ship the first 20 clips from `v_shippable` as IG Trial Reels — non-followers only.
*Decision gate: is anything reaching a non-follower at all?*

**Weeks 3–6 — establish cadence.** 1 long-form + 4 Shorts + 4 Trial Reels + 1 carousel per week.
Every Short carries a Related Video link to its parent talk. Build delivery-based ranking
(8 minutes of compute) and re-rank. Run face-review on the footage catalogue to lift the b-roll
ceiling. Build the four missing artifact gates.
*Decision gate: long-form average view duration, Related-Video clicks, profile visits, DMs.
Kill hooks that move none of the four.*

**Weeks 7–12 — compound.** Promote graduated Trial Reels to the follower feed. Add LinkedIn native.
Extend the machine to OSB using the same spine (72 clips already attributed, plus 552 unattributed
awaiting classification on the free local lane).
*Decision gate: first qualified inbound. Expect it from a long-form talk with a real CTA, not a
viral 16-second hook — typically inside 30–45 days of weekly long-form.*

**Timing:** post to US evenings 7–9 pm EST, which is Adrian's Bali morning 8–10 am.

---

## §10 THE HARD DEADLINE

**2026-10-08 — 46 days from today — `META_USER_TOKEN` and every derived page token lose data
access.** That darkens all Facebook and Instagram publishing. Re-consent is also the only moment to
add the two missing scopes: `instagram_manage_insights` (we can publish to 2,708 IG followers and
**cannot measure a single impression**) and ads scopes. **One action, not three.** Do it before
building anything that depends on IG measurement.

---

## §11 WHAT IS STILL BROKEN AND OWNED

1. `publication` has zero rows and nothing writes to it. **The loop is open.** — the top build.
2. Four of the five artifact gates are specified and unbuilt.
3. Delivery-based ranking specified, ~8 minutes of compute, not yet run.
4. B-roll at 12.6% of need; face-review never run.
5. The semantic index primary key is broken — 59% of rows orphaned.
6. `qwen` lane blocked on an Alibaba Model Studio entitlement (Adrian action).
7. Erica Johnson material: an agent reported 12 cleared hooks; my stem-based test found none.
   **Unresolved, not cleared.** Needs a positive identification method before anyone trusts either.
8. 552 shippable clips are venture-unattributed. Free to classify on the local lane; not yet run.
9. 844 KB of launch strategy remains orphaned from the operating layer — this document is the
   pointer that was missing, but the launch corpus itself has not been reconciled line by line.

## Revision history
- 2026-08-23 — created. Grounded in a same-day forensic sweep (7 dimensions), a live-web platform
  research pass, a full rule-contradiction audit, and direct measurement against the content SSOT.
  Classification: ADDITION — no existing rule weakened, removed or reinterpreted; §6 adjudicates
  pre-existing conflicts without inventing new law.
