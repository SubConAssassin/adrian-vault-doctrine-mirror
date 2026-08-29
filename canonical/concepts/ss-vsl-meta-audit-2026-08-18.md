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
- **CORRECTION — the three-year claim does not survive.** My first pass called it corroborated
  because `methodology-canon.md` IP-1 records "Average client relationship: 3+ years". A deeper
  corpus pass shows that is the *only* occurrence in the vault: unsourced, sitting in a
  delivery-model aside inside an **IP-governance memo**, with no dataset behind it anywhere. The
  vault cannot even compute its own cohort completion rate, and the entire documented retention
  evidence base is **one person at 11 of 12 payments** — about a year, not three. It is the one
  line in the script that could be publicly falsified, and it sits in the position of maximum
  trust-load in front of an audience that is explicitly testing for precision. **Strike it.**
  The true replacement is nearly as strong and is citable: *people who have worked with him
  across multiple cohorts since 2018*, with three documented arcs running five-plus years.
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

Ben's beat structure and runtime kept. Every line now traces to the corpus.

**Two corrections this rebuild forced on my own first draft, recorded because they were real
mistakes and both would have shipped:**

1. **I repeated the three-year claim as corroborated.** It is not — see the correction in Part 1.
2. **My first draft leaked a firewalled mechanism.** I wrote *"You score where you actually
   stand, one to ten."* The 1–10 quantifiable inquiry is the **protected diagnostic**
   (`muscle-testing-protocol.md` §3; `ss-methodology-stack.md` §3.1), banned from every public
   surface by Adrian-direct ruling. Ben's step three did the same thing. **Neither of us
   invented it — we both leaked it.** It is out of the script below.

**One unresolved contradiction, flagged rather than silently decided:** the deep pass describes
the 0–10 self-score as the only non-mystical, firewall-clean progress measure available, while
the firewall ruling bans it from public surfaces. **The ban wins until Adrian says otherwise** —
so the script below does not mention it, and the question is on his list.

## The script

**Subconscious Surgery — VSL v1.0**
*Runtime 4:43. Timings measured at ~150 words/minute of speech plus the marked holds. If Adrian runs slower than that, cut the two lines marked [TRIM FIRST] and it lands at 4:28.*

---

**[0:00–0:24 HOOK]**

*Adrian seated, mid-shot, already looking down the lens when the frame opens. No music. No title card. No name super yet.*

Right. Before anything else — think of the thing you're stuck on.

Don't say it out loud. Say it in your head, the way you'd say it to somebody you trust.

*[HOLD — three full seconds. He waits. He does not fill it. Do not cut away.]*

Because the way you just said it — that's the whole thing. That's what I'd be listening to.

*[Hold two seconds on his face before the first cut.]*

---

**[0:24–1:09 PROBLEM]**

You know exactly what to do.

You just… don't do it.

*[Beat. He's finding the next bit, not reciting it.]*

And then you build a reason on top of it, and the reason's intelligent because you're intelligent — which means the not-doing stops looking like avoidance and starts looking like judgement.

That's the bit that costs. Not the not-doing. The not-doing that looks like wisdom from the inside.

And you already know all this. You could describe the pattern better than I could.

And you still do it.

*[PAUSE — three seconds. Silence is doing work here. Do not cut on it.]*

So it isn't a strategy problem. It isn't a discipline problem. It's a loyalty to an old identity — and if understanding fixed it, you'd be free by now.

---

**[1:09–2:20 CREDIBILITY]**

*Name super on first mention only, lower third, no credentials line beneath it.*

I'm Adrian.

I had a business before this one. Two hundred grand a week, twelve people on the payroll. Then the government changed the rules and the phone stopped. Ninety-eight per cent, overnight.

I kept everybody on through Christmas because I thought we'd win the legal challenge.

We won it. Three months later.

The bank pulled my overdraft the week after I'd cleared it. Hundred and twenty grand of my own money, gone. A year on benefits.

*[PAUSE — four seconds. This is the longest hold in the film. He is not performing recovery.]*

January, two thousand and fifteen. Thirty pounds in my bank account. And I was completely calm.

Not pretending. Calm.

That's when I knew the thing I'd been learning actually worked. Because the number hadn't changed. I had.

Thirty-seven weekly sessions with one man, over fifteen months. Eleven thousand dollars. I've been doing this since two thousand and fourteen, and there are people I've worked with across cohorts since two thousand and eighteen.

And I'm not a licensed therapist. This isn't medical. I'd rather say it than let you assume otherwise.

*[Deliberately no year given for the collapse — see Adrian's list, item 6.]*

---

**[2:20–3:13 UNIQUE MECHANISM]**

What I do is quite unusual, but it works.

Language is my scalpel. I listen to how you frame what's blocking you. The proof is the outcome.

The construction of the sentence — not the story, the construction. That's where the pattern's kept.

Somebody tells me a decision took their peace of mind. And I'll ask them: did that decision take your peace of mind, or did you hand it over?

*[PAUSE — three seconds. He is watching an imagined person answer.]*

And when they say — I handed it over — right. That's the truth. Now there's something we can actually work with.

And we don't put a flower on top of the weed. You take the resistance out, or the root just grows back.

Nothing of mine goes in. I re-sequence what you already said.

---

**[3:13–3:41 PROOF]**

What actually changes is smaller than people expect.

The sentence changes. That's the one I watch for. You come in saying it happened to you, and at some point, no fanfare, you say it differently. That's the turn.

And the thing you've been carrying gets decided. Not gloriously. Just decided.

I'm not going to tell you your revenue doubles. I don't know that. And neither does anybody who tells you it.

*[ADRIAN TO CONFIRM: if the 0–10 self-score at the start of the work, re-checked as you go, is still run today, one sentence goes here — it is the only non-mystical, firewall-clean progress measure the corpus contains, and this beat is the thinnest in the film without it. Documented for 2017 only, so it cannot be stated in the present tense unaided.]*

---

**[3:41–4:12 OFFER]**

You leave with a set of lines built out of your own words, and you say them every day.

I can't do the push-ups for you. I'll tell you exactly what I see. You don't do anything with it, you don't get the results. I'd rather say that now than after you've paid me. **[TRIM FIRST: "I'd rather say that now than after you've paid me." — the same move recurs in the CTA.]**

And the whole thing is built to end. The point is you stop needing me.

This is surgery. You don't operate on yourself.

*[ADRIAN TO CONFIRM: which rung this points at — Mastermind, the twelve-week, or the 1:1. The beat is written to be true of all three. If it is the Mastermind, one line naming the group goes after "every day." Also confirm whether "it's been remote since twenty-fifteen — that isn't a pandemic thing" can be said; it is a strong line resting on weak sourcing.]*

---

**[4:12–4:43 CTA]**

Right. Here's where I'll leave it.

There's a call. On it I'll tell you what I think is actually running underneath. In your words, not mine.

I can't advise you; it'll only ever be my thoughts and feelings on it. And if I don't think it's right for you, I'll say so on the call, not after.

The link's there. It's completely up to you whether you use it.

*[Beat.]*

You're the one who makes the call.

*[Hold three seconds. He does not smile at the end. Cut on black, no outro card, no music sting.]*

*[ADRIAN TO CONFIRM: length of the call and whether it is free. The corpus documents a complimentary 30-minute discovery call in 2017; current status unrecorded. Do not record the bracket — if confirmed, the line becomes "There's a call. Thirty minutes, no charge."]*

---

## WHY THIS VERSION

Six things in Ben's draft the corpus contradicts, and what replaced them.

**"Average client relationship: more than three years."** It exists once in the whole vault, unsourced, in an IP-governance memo, with no dataset behind it — the entire retention evidence base is one person at 11 of 12 payments. It sat in the credibility slot of a paid ad aimed at people the corpus describes as "testing for diagnostic precision." Struck. Replaced with the true, cited version: *people I've worked with across cohorts since two thousand and eighteen.*

**The "Decision Audit," its four steps and its forty minutes.** The product doesn't exist. Worse, its third step — score the belief one to ten, logged — is the actual protected diagnostic, banned from every public surface by an Adrian-direct ruling. The script manufactured an offer that isn't real and leaked one that is. Both gone. The mechanism beat now says only what is cleared to be said, and says it in full, all three clauses.

**No origin story.** Ben asked question 5.2 and shipped 4:45 without answering it. The £200k week, the 98% overnight, Christmas on the payroll, the High Court win three months late, £120k, and thirty pounds in the bank while completely calm — all Adrian's own biography, all clean once the family chapter comes out, and the strongest asset in the corpus. It now carries the middle third of the film.

**"Every capable founder I meet."** That's the aspirational buyer. The documented paying base is a different demographic entirely, and no file reconciles them. The fix costs nothing: the corpus's audience definition is a psychographic — unable to shift a pattern despite intelligence and prior effort — which fits both. No demographic noun appears anywhere in this script.

**Four imperatives in the CTA.** From a man whose documented register treats *what should I do* as the symptom being treated. The close is now a door with his own hedge grammar in front of it.

**"I am not a therapist" used as a brag.** The word is banned outright in copy. The boundary still has to be stated, so it is stated once, plainly, as the compliance line it is — and the volunteering of it does the trust work the brag was reaching for.

The spine is the conversational draft's, because its hook performs the one sanctioned public claim instead of asserting it. Grafted in: the £30 block and the peace-of-mind exchange with its four-beat rhythm, the flower-and-weed line, *nothing of mine goes in*, and *the not-doing that looks like wisdom from the inside.* Three lines the judges flagged in that spine are cut: *that's the only difference that matters* (unhedged absolutism), *that's the whole public version* (points at the firewall inside the ad), and the unsayable three-clause disqualifier.

---

## LINES CARRIED OVER FROM BEN

**"That is not a strategy problem. It is not a discipline problem. It is a belief running underneath the logic."**
The closest thing in his draft to the corpus's actual separating insight, and structurally right — anaphoric doubling is his documented shape. It survives at 1:05, contracted to spoken rhythm and landing on a pre-cleared hook: *It isn't a strategy problem. It isn't a discipline problem. It's a loyalty to an old identity.*

**"You already know the move."**
The right sentiment, and nearly the shape of the cleared public line *you're the one who makes the call.* It survives twice — as *and you already know all this* at 0:55, and as the final line of the film.

**"The right starting position is scepticism. Good."**
Correct instinct for this audience, and it is why the proof beat here refuses to overclaim rather than reaching for the $65M book deal. Not quoted directly, because the corpus's own answer to doubt is stronger and is already Adrian's: he invites you to disprove him. Held in reserve as the first line of a companion cut.

**"Name the belief — the exact wording underneath how you talk about the decision."**
The only part of his four-step invention that hits the real mechanism. It *is* "language is my scalpel," restated as an action. It survives as the mechanism beat's spine: *the construction of the sentence — not the story, the construction.*

---

## WHAT ADRIAN STILL HAS TO SUPPLY

1. **Which offer does this point at — the Mastermind, the twelve-week, or the 1:1 retainer?** The corpus contradicts itself on whether the Mastermind teaches the method or only the concepts, and a VSL that converts against a one-operator retainer builds a queue you can't serve.
2. **Is the call still thirty minutes, and is it still free?** One line in the CTA cannot be recorded until this is answered.
3. **Is the first session with a new person still the full intervention, rather than a sales consultation — and is it paid?** If it is, it's a rare offer structure and it belongs in the film.
4. **Is the 0–10 self-score at the start, re-checked as the work goes on, still run today?** If yes, it is the single best proof device available to this ad and needs no mechanism disclosure. If no, it cannot be described in the present tense.
5. **Can I say the practice has been remote since 2015 — not a pandemic adaptation?**
6. **What year did the solar business collapse?** The vault dates it twice, three years apart, and the two datings can't both be true. The script currently gives no year.
7. **Is there a guarantee?** Nothing in the corpus records one. My read is no, and that we don't manufacture one — *I can't do the push-ups for you* is stronger for this buyer than a refund promise.
8. **Do you want "I'm not a licensed therapist, this isn't medical" spoken on camera, or carried as an on-screen line?** Spoken, it becomes a trust signal. On-screen, it's compliance furniture. My read is spoken.

No price is named anywhere in the film. Nine mutually inconsistent figures exist in the vault and the live one is unrecorded — and the doctrine on numbers is to state them on the call, then stop talking.

---

## DELIVERY NOTES

**The voice track is the brand.** Everything else is subordinate and interruptible. Cut to B-roll rather than show him partially framed, and never break the audio to do it. Cut only when meaning, emotion or evidence changes — not on a metronome.

**The three held pauses are load-bearing, not breathing room.** Silence after a hard line is doing work. The hook pause has to be genuinely held: he asks the viewer to think of something, and then he waits, on camera, doing nothing. If that hold gets trimmed in the edit, the hook stops working, because the whole move is that the viewer's own sentence is the diagnosis.

**"Right." is a gear change, not a greeting.** Four of them, four different jobs — opener, turn, confirmation, close. None of them cheerful.

**The collapse is told flat.** No rue, no war story, no relish in the numbers. The line that matters is not the hundred and twenty grand, it's *thirty pounds in my bank account, and I was completely calm.* That must be said as a plain fact about a Tuesday. *Not pretending. Calm.* is two beats, dropped in weight, not lifted. If it gets any performance at all it becomes a boast and stops being believable. Then *the number hadn't changed. I had.* — and immediately move on. Do not let it land as a moment.

**The peace-of-mind exchange is recalled speech, not drama.** He's reporting a thing that happens in a room, quoting two people including himself. The question gets asked lightly. The *right — that's the truth* is fast and unceremonious. He books the insight and moves; he does not celebrate it.

**Do not sell "wisdom from the inside."** It is the cleverest line in the film and will collapse if it is pointed at. Say it as an aside and carry on.

**Let him think.** There is one marked hesitation — *You just… don't do it* — and it should be real. He drops into thought mid-sentence; that tic is documented and it is what makes the register readable as diagnosis rather than pitch. A fluent take is a worse take.

**Register throughout: full empathy, zero rescue, in the same breath.** Warm, unhurried, completely unwilling to help you feel better about it. Nothing in here should sound encouraging.

**End downward.** Voice drops on *you're the one who makes the call*, three seconds of held frame, no smile, no music sting, no outro card. He has offered a door and he isn't going to walk you through it.

**Craft caveat, so nobody mis-sells this internally:** the vault's own measured finding is that every editing rule is already obeyed on essentially every SS video and reach still collapsed thirtyfold. Craft is not the lever; distribution is. This script is a paid-traffic asset and should be judged on calls booked, not on plays.
---

# PART 4 — META RE-CHECK ON THE NEW SCRIPT

The audit in Part 1 was run against **Ben's** script. The rebuild is a different asset with a
different risk profile, so here is the delta. This is my own read, not a second five-lens run.

**What it removes.** The one finding that survived adversarial review — *"It is costing **you**
months and **money you** have never written down"* — is gone, along with the entire
second-person-assertion spine. The hook and problem beats are now first- and third-person. On
Personal Attributes, which is the policy that actually rejects coaching ads, **the new script is
materially safer than Ben's.** That is the convergence noted in Part 2: being more himself makes
the ad safer.

**What it adds, and you should see it before filming.**

| New exposure | Read |
|---|---|
| **Money figures — £200k/week, 98%, £120k, £30 in the bank** | Autobiographical, past tense, about his own former business. That is the *safe* form of a money claim: it asserts nothing about the viewer and promises nothing. But it raises the money density of a coaching ad substantially. **Do not put any of these figures on a burned-in card, in primary text, or in a thumbnail** — stripped of the narrative frame, OCR reads "£200,000 a week" as an income claim, which is the get-rich-quick pattern. Same logic as the quote-card warning in Part 1. |
| **"This is surgery. You don't operate on yourself."** | Stronger line than the nickname, and slightly higher clinical-coherence risk, because the metaphor is now a full sentence rather than a name. It is well mitigated — *"I'm not a licensed therapist. This isn't medical"* sits two beats earlier. **Keep those two in the same cut.** If the film is ever trimmed, they travel together or both come out. |
| **"A year on benefits"** | First-person, past tense, his own status. Safe. Would not be safe in any second-person form. |
| **Substantiation duty moves** | Off the (struck) three-year retention claim and onto the Photon Utilities figures and the 2014 start date. Those are documented in `mea-business-arc-2014-2017.md` and `ss-methodology-stack.md` — but the **collapse year is given inconsistently in the vault, three years apart.** The script gives no year, which is the right call until that is resolved. |

**Unchanged and still binding:** the landing page and form-field guidance, the SRT requirement,
and the no-scrubs/no-scalpels visual rule from Part 1 all apply to this script exactly as they
applied to Ben's.

**One line the compliance and doctrine layers disagreed on, now resolved.** The audit said keep
*"I am not a therapist"* (licensure cover, the strongest asset at human appeal).
`editing-doctrine-2026-07-29.md:257` bans the word "therapy" in copy. The rebuild threads it:
**"I'm not a licensed therapist. This isn't medical."** — the boundary is stated, the licensure
cover is kept, and "therapy" never appears as the category word for the work. That satisfies
both, and it is the version I would ship.
