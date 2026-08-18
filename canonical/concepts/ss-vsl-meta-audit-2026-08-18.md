---
title: "Subconscious Surgery VSL — Meta policy audit + authentic-voice rebuild"
type: working-analysis
status: DELIVERABLE — Adrian review pending
firewall_class: working-internal
firewall_note: "Public-facing SS framing in this document stays inside the standing rule: 'Language is my scalpel / I listen to how you frame what's blocking you / the proof is the outcome.' No mechanism is described. See ss-processing-statement-algorithm.md frontmatter."
created: 2026-08-18
authored_by: claude
source_script: "Ben's edited shooting script, supplied by Adrian 2026-08-18"
related:
  - canonical/concepts/ss-processing-statement-algorithm.md
  - canonical/concepts/cross-project-methodology-map.md
  - canonical/concepts/methodology-canon.md
  - canonical/concepts/ss-language-signature.md
  - canonical/concepts/eight-laws-of-change-operating-principles.md
---

# SS VSL — Meta audit + voice rebuild

Three things were asked, in this order:
1. Audit Ben's script for Meta's sensitive wording.
2. Rebuild it in Adrian's authentic voice — what he would actually do in a pre-work discussion.
3. (implied by the intake questionnaire he sent third) answer Ben's Sections 1–6 from the corpus rather than from a copywriter's assumptions.

This file carries all three.

---

# PART 1 — THE META AUDIT

## Method and its one real limitation

Five independent policy lenses ran over the script (Personal Attributes · health/clinical
implication · claims and substantiation · video creative and funnel · a miss-sweep), each
then adversarially refuted by a second reviewer briefed to knock findings down rather than
pile them up. 58 raw findings reduced to 14 after refutation.

**Stated limitation, because it changes how much weight this carries:** the agent tasked with
retrieving Meta's *current published policy text* was blocked — this session has no outbound
web egress, every host denied by the proxy. So the audit is grounded in model knowledge of
Meta's Advertising Standards, **not** in verbatim policy text retrieved today. The findings
below are reliable on the well-established constructions (Personal Attributes is stable and
long-standing); treat any borderline call as needing a check against the live policy page
before launch.

## Verdict

**The script passes.** Across five lenses and an adversarial pass, **not one finding survived
at high severity.** There is no condition noun, no treatment verb, no guarantee word, no
number-plus-timeframe outcome claim, and no protected attribute asserted anywhere in the
voiceover.

The real exposure is not in the script at all — it is the **landing page and the caption
layer**, neither of which has been audited. Meta reads the destination page as part of the ad,
and reads the video through automatic speech recognition.

## The two lines worth changing before filming

| Line | Why | Fix |
|---|---|---|
| "It is costing **you** months and **money you** have never written down." | The only clause in the asset binding a negative money statement to a second-person referent, plus a claim about the viewer's own record-keeping. Financial status is an enumerated Personal Attributes item. Flagged by all four lenses that cover it, and the one finding the adversarial pass *confirmed* rather than knocked down. | "It runs in months, and in money that never gets written down." Zero rhetorical loss. |
| "Something **in you** keeps **you** from making it." | Low on the text, medium on **placement**. Three lenses correctly downgraded it on merits — "something" names nothing. Raised anyway because it is the densest second-person mind-reading in the first twenty seconds, the most-sampled window in the asset and the first thing both frame sampling and ASR touch. | "And something keeps stopping it." Keeps the beat and the direct address; removes the bit locating a mechanism inside the viewer. |

## What is fine as written — do not sanitise these

Every one was flagged by at least one lens and refuted on review. Changing them costs
conversion for no compliance gain.

- **"I am not a therapist, not a guru, not a hype coach."** No standard prohibits the *word*
  therapist; the prohibition is on offering therapy. This is an unprompted licensure
  disclaimer — the strongest thing available at human appeal, and free FTC/ASA cover.
  Deleting it to dodge a token match would leave an unlicensed man nicknamed "the Subconscious
  Surgeon" with nothing on record saying he is not a clinician. **Keep it.**
- **"You have done the analysis. You have asked smart people. You have bought the books…"**
  Diligence and purchase history are on no enumerated list, and nothing negative is asserted —
  these sentences flatter the viewer. Converting to third person would kill the strongest
  identification beat in the script.
- **"…what actually comes out is rarely 'I'm not sure they're right.' It's closer to 'if I pick
  wrong again, it proves I can't trust my own judgement.'"** The quoted belief is *first*
  person, inside a third-party pattern frame. No second-person binding to a protected
  predicate anywhere in it. It is the passage that earns the call. (One caveat below.)
- **"Third, we score a baseline. That belief, one to ten, logged."** Baseline, score, logged
  and measurement are analytics, fitness and OKR words. This is the rigour signal the sceptical
  audience is buying.
- **"The session is not a trailer for a pitch."** The best objection-handler in the asset.
- **"You already know the move."** Knowing your own business is not an attribute. Keep both
  occurrences — it is the bookend.
- **"Forty minutes. One real decision on the table. Four steps."** Session length and step
  count are not outcomes.

## Beyond the script — where the actual risk is

**The landing page.** Personal-attributes rejections in coaching originate above the fold far
more often than in the VSL.
- **The form field labels are the single highest-risk string on the page.** "What are you
  struggling with?" is the classic rejection. Use decision-framed labels instead: *"Which
  decision is stalled?"* · *"How long has it been sitting?"* Never a field asking about
  feelings, mental state, health, or money problems.
- The page must state the price (free), the duration (40 minutes), what the session produces,
  and that a paid next step may be recommended — that is both the ad-to-page consistency check
  and basic FTC hygiene.
- The page must not describe the service as therapy, treatment, or healing. That is where an
  unlicensed-practice frame would actually cohere — not in a nickname.

**The caption layer — five minutes of work that removes a whole class of inexplicable rejection.**
- **Upload an accurate SRT. Do not rely on auto-captions.** A Yorkshire delivery plus the brand
  name "Subconscious Surgeon" is a realistic source of a mis-transcription that trips a
  classifier on words Adrian never said. Proofread the ASR output specifically around
  "Subconscious Surgeon", "not a therapist" and "capacity".
- Bracketed cues and the delivery note must never reach the SRT, the primary text, the ad
  description, the page, or any burned-in card.

**Visual treatment.**
- Never put "Subconscious Surgeon" over scrubs, operating theatres, scalpels, or anatomical or
  brain imagery. That is the one thing that turns a defensible nickname into a coherent
  clinical frame.
- **Do not burn the "if I pick wrong again…" line into a quote card.** It ships fine in the
  voiceover because it is first-person inside a third-party frame — but OCR on a static card
  reads it without the frame, and it is the most quotable line in the script, so it is the
  likeliest candidate for exactly that treatment. Use "That's the belief. Not the hire." instead.

**Substantiation to hold on file before the ad airs** (CAP requires evidence in hand at
publication, not on request):
- The client-tenure data behind the three-years claim, plus a written definition of what counts
  as a client and how the figure was computed. **Corroborated in the corpus** —
  `methodology-canon.md` IP-1 records "Average client relationship: 3+ years" — but that is a
  secondary internal document, not primary client records. If it is an impression rather than a
  computation, use "Most client relationships here run past three years."
- The operational commitment: **the sheet ships every time, automatically.** "Everything is
  stated, scored, and written down" is an unconditional deliverable promise. Defensible if the
  sheet always exists; it is the one line that generates misleading-ad reports if it quietly
  does not, and those feed account quality independently of ad review.

---

# PART 2 — WHAT THE CORPUS SAYS (read first-hand, not delegated)

This is the part that changes the brief. Four findings, in order of how much they matter.

## Finding 1 — the vault already contains the answer to "how should SS be marketed"

`ss-processing-statement-algorithm.md` carries this in its frontmatter, as a hard rule, and
`cross-project-methodology-map.md` §0 repeats it verbatim:

> **"This IS the private mechanism. NEVER public, never client-facing, never in
> marketing/ads/sales/social. Public framing remains EXACTLY: 'Language is my scalpel / I
> listen to how you frame what's blocking you / the proof is the outcome.'"**

That is a three-clause public positioning statement, already ratified, already firewalled,
and it is a **better VSL spine than anything in Ben's draft.** Ben did not have it.

It also means the correct answer to "should the VSL describe the mechanism?" was settled before
the question was asked: **no mechanism is ever described to users.** Not a judgement call.

## Finding 2 — Ben's script breaks three of Adrian's own standing rules

Not Meta's rules. Adrian's.

| Rule | Source | What Ben's script does |
|---|---|---|
| **No fear-selling, no false scarcity, no manipulation in copy** | 8 Laws of Change, Law 6, applied to SS explicitly: *"no fear/pressure selling in the funnel"* | "Meanwhile the maybe is not free. It is costing you months and money you have never written down" is a loss-aversion squeeze. The delivery note — *"That's the belief-install moment"* — describes covertly installing a belief in a prospect. |
| **Radical congruence: the public claim must match the private truth** | 8 Laws, Law 7, applied to SS as *"brand congruence… no over-promise"* | The "Decision Audit" as described is not what happens in a first conversation (Finding 3). |
| **Never use regulated clinical terminology** — `therapy` is on the banned list | `ss-language-signature.md` §8 | "I am not a therapist." |

The third one is a genuine conflict, and **the Meta audit and Adrian's own doctrine disagree
about it.** The audit says keep "I am not a therapist" — it is licensure cover and the single
best asset at human appeal. The language signature bans the word outright. **My read: keep the
line.** §8's ban is written to stop an operator *recasting Adrian's method* in clinical terms;
an explicit denial of clinical status is the opposite of that, and the regulatory upside is
real. But it is a doctrine question and it is Adrian's call, not mine.

## Finding 3 — the "Decision Audit" is not what actually happens

`ss-protocol-cards/intake-session-structure.md` records a seven-stage first-session arc, ~80
minutes, grounded in 28 captured client sessions from the 2019 practice corpus. Ben's version
is 40 minutes and four steps.

Two of Ben's four steps are **distorted echoes of real ones** — the 1–10 scoring is real, and
naming the exact wording of the belief is real and is the heart of the method. Two are
invented. The overall shape, timing and framing are not what the corpus describes.

This matters commercially, not just doctrinally: **Law 7 congruence.** If the ad promises a
four-step forty-minute Decision Audit, that is now the thing that has to happen on the call.

**The constraint that cuts the other way:** the same protocol card is
`firewall_class: strictly-private-mastermind`, and states *"Public materials must treat these
structures strictly as conceptual coaching indicators, keeping specific session timing and
mechanics confidential."* So the honest answer is **not** to put the real seven stages in the
ad either.

**Where that leaves it:** the VSL can be authentic about the *stance, the register and what the
client leaves with*, and must stay silent about the *mechanism*. That is a narrower target than
"be more like the real thing", and it is the actual brief.

## Finding 4 — the voice bible has a citation problem, and the better source is elsewhere

`ss-language-signature.md` presents 25 "verbatim" quotes. Its frontmatter declares **five**
sources. The body cites **seventeen** distinct filenames — twelve of which are not in the
declared list, including several that look auto-generated (`mastermind-38-`, `-42-`, `-48-`).
One quote contains a stray Russian word mid-sentence (*"my стратегический perspective"*), which
is a corruption marker, not a transcription.

Per the vault's own verify-before-trust gate: **do not put a quote from that file into a paid
ad on the strength of it being labelled verbatim.** Quotes citing the five declared sources are
sound; the rest are unverified.

**The well-grounded alternative is `cross-project-methodology-map.md` §1** — ten SS principles,
each with a real transcript citation, described as *"forensically verified grounded — quotes are
real substrings of real sources."* That is the material to build on. The strongest for a VSL:

- **P4 — "I can't do the push-ups for you."** *"I tell you exactly what to do… you don't do
  it… and then you don't get the results."* An anti-pitch line that is entirely his.
- **P3 — Language-as-scalpel.** Reframing the same facts from pain-frame to validation-frame.
- **P8 — Clinical reality-check over false hope.** Decide from permanent reality, not moments
  of levity.
- **P5 — Explicit energy exchange.** His time and value named and protected.
- **P6 — "It's just noise."** Nobody changes how you feel without your permission.

And from `methodology-canon.md` IP-1, the line that outranks everything in Ben's draft:

> **"Language is my scalpel."**

It *earns* the surgical frame instead of asserting it, and it is literally true — the method
fills every slot with the client's own words. The canon says so in terms:
*"The practitioner re-sequences; he does not invent. (This is why the public claim 'language is
my scalpel' is literal and true.)"*

That is the unique mechanism, sayable in public, firewall-clean, and Meta-clean:

> **I don't give you my words. I give you yours, back, in the right order.**

## The tension to be aware of, stated plainly

The three constraints pull in different directions:

- **Authenticity** wants the real register — sovereign, non-advisory, somatic, radically direct.
- **The firewall** forbids describing the mechanism publicly at all.
- **Meta** would treat the actual modality vocabulary as health-claim territory.

They converge on one point, and it is a lucky one: **Adrian's real register is more
Meta-compliant than the copywriter's.** His documented voice is hedged and sovereignty-framed
— *"I am only here to give my perspective"*, *"it is up to you whether you engage with it or
not"*, *"you can play devil's advocate with my testing, go and do the opposite, prove it to
yourself"* — which is *structurally* Personal-Attributes-safe, because it never asserts
anything about the viewer. Ben's script is riskier precisely where it is least like Adrian:
the relentless second-person assertion.

**Being more himself makes the ad safer, not more dangerous.** That is the finding to act on.

## One live gap

This repository is the doctrine mirror — `companies/` is git-ignored, so the SS ledger,
pricing, the Kajabi mastermind tiers and the actual product ladder are **not readable from
here.** Sections 4 and 6 of Ben's questionnaire (what's included, offer structure, CTA,
scarcity) cannot be answered from this repo and need either the full vault or Adrian.

---

# PART 3 — THE REBUILD

Ben's structure kept exactly: same beats, same timecodes, same runtime. What changes is that
the words are sourced from the corpus instead of from assumption.

**Three rules held throughout:** (1) the public framing rule — *language is my scalpel / I
listen to how you frame what's blocking you / the proof is the outcome*; (2) no mechanism
described; (3) third-person and first-person framing wherever Ben used second-person assertion,
which is simultaneously more like Adrian and safer with Meta.

## The script

**[0:00-0:20 HOOK]** Nearly every founder I work with arrives with a decision they have already
made three times, and reversed twice. [PAUSE] The hire. The price. The partner conversation.
The offer that is built and still not sent. They know the move. And something keeps stopping it.

**[0:20-1:00 PROBLEM]** By the time someone gets to me, they have done the analysis. Asked the
smart people. Bought the books, the coaching, the workshops. And the stall is still there.
[lean in] It is not a strategy problem. It is not a discipline problem. When you were born, you
had an operating system. Everything since has been software, installed by experience. Most of
it runs fine. Some of it runs against you — and it does not announce itself. While it stays
invisible, the delay feels rational.

**[1:00-1:30 CREDIBILITY]** I am Adrian Taffinder. The work is called Subconscious Surgery. I am
not a therapist, not a guru, not a hype coach. What I do is quite unusual, but it works. I work
with founders and high performers who have already done a lot of the work and can still feel
the gap that will not shift. Most of the people I work with have been with me for years, not
months. I do not think that is loyalty. I think it is that the work holds.

**[1:30-2:45 UNIQUE MECHANISM]** So here is what is different. I do not work from my words. I
work from yours.

Language is my scalpel. I listen to how you frame what is blocking you. Not the story — the
framing. The exact words you reach for when you describe the thing you will not do.

[PAUSE] Because you will tell me. Everybody does. Take the hire you keep re-interviewing in your
head. Say it out loud enough times and what comes out is rarely "I'm not sure they're right."
It is closer to "if I pick wrong again, it proves I can't trust my own judgement."

That is the belief. Not the hire.

Once it is in your own words, in front of you, it stops being weather and becomes something you
can work on. And we do not put a flower on top of the weed. If the root stays, it grows back.

So: one real decision. You talk, I take notes, I do not interrupt. Then I give you your own
words back, in the right order. You score where you actually stand, one to ten. And you leave
with one concrete move, and the date you will make it.

**[2:45-3:30 PROOF]** If you are sceptical — good. That is the right starting position, and I
would rather have it than enthusiasm. Play devil's advocate. Go and do the opposite if you want.
Prove it to yourself. [PAUSE] And I will tell you the one thing I cannot do. I cannot do the
push-ups for you. I can be exactly right about what is in the way, and if you do not move,
nothing moves. That is not a threat, it is the arrangement. You are the one who decides. I am
only ever giving you my read.

**[3:30-4:00 OFFER]** So we start with one conversation. Forty minutes. Free. One decision —
the one you have been carrying. You leave with what we found: the belief in your own words,
where you scored it, and the next move with a date on it. You keep that whether you ever work
with me or not. Some people go on to work with me properly. Most do not, and I will say so. I
would rather send you away with the sheet than sell you something you do not need.

**[4:00-4:45 CTA]** If you want a straight read on the decision that has been sitting there,
book the conversation on this page. It is free, and it runs forty minutes. Fill in the short
form. Tell me the decision. I will tell you honestly whether this is the right tool for where
you are — and if it is not, I will tell you that too. [look at camera] You already know the
move. Let's find out what has been stopping it.

## Where every line came from

| Line | Source |
|---|---|
| "Language is my scalpel. I listen to how you frame what is blocking you." | The mandated public framing, verbatim — `ss-processing-statement-algorithm.md` frontmatter; `cross-project-methodology-map.md` §0 |
| "When you were born, you had an operating system… software installed by experience" | 2019 practice corpus, quoted in `intake-session-structure.md` §1 |
| "We do not put a flower on top of the weed. If the root stays, it grows back." | 2019 practice corpus, `intake-session-structure.md` §6 Citation 2 |
| "What I do is quite unusual, but it works." | Same source, §1 |
| "I cannot do the push-ups for you." | P4, `cross-project-methodology-map.md` §1 — forensically verified transcript `00000647` |
| "Play devil's advocate. Go and do the opposite if you want. Prove it to yourself." | `ss-language-signature.md` §1 #17, citing a *declared* source (mastermind-32-testing) |
| "You are the one who decides. I am only ever giving you my read." | The non-advisory sovereignty register, §1 passim |
| "I do not work from my words. I work from yours." | `methodology-canon.md` IP-1: *"The practitioner re-sequences; he does not invent"* |
| "Most of the people I work with have been with me for years, not months." | `methodology-canon.md` IP-1 — deliberately worded as the non-numeric form pending substantiation |
| The hire / re-interviewing / "if I pick wrong again" passage | **Ben's.** Kept intact — it is the best thing in his draft and it cleared the audit twice. |

## What Adrian has to decide or supply

1. **The three-year claim.** Is it a computed average from records, or an impression? The script
   currently uses the safe non-numeric form. If it is computed and documented, the number is
   stronger — say so and it goes back in.
2. **"I am not a therapist" — keep or cut?** The Meta audit says keep (licensure cover).
   `ss-language-signature.md` §8 bans the word. My read is keep. Your call.
3. **The one line closest to the firewall:** *"Then I give you your own words back, in the right
   order."* It describes the principle, not the mechanism — no statement grammar, nothing
   somatic, nothing procedural. I judge it inside the line, but it is the closest the script
   goes, so you should see it flagged rather than find it later.
4. **Does the call actually run this way?** The script now promises: 40 minutes, free, you talk
   first, you score one to ten, you leave with a move and a date, you keep the sheet. Under
   Law 7 that is now a commitment. If the real first conversation is longer or shaped
   differently, change the script — not the session.
5. **Not answerable from this repo:** price ladder, what the Kajabi mastermind includes, whether
   there is a paid tier immediately behind the free call. `companies/` is git-ignored in this
   mirror.

## Delivery notes

- The sceptic line lands **dry**, not defensive. It is the moment trust is earned.
- "I cannot do the push-ups for you" is the only place to allow a half-smile. It is the most
  human line in the script and it does the disqualifying work without any hard edge.
- The operating-system passage is the one place to slow right down. It is the idea most people
  have never heard framed that way.
- Do not over-perform "that is the belief, not the hire." Flat, and let the pause carry it.
- **Production hygiene:** these notes and every bracketed cue stay out of the SRT, the primary
  text, the description, the page and any burned-in card. Keep the voiceover script in a
  separate file from this one.
