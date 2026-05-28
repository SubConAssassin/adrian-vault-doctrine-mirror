# LLM Council Decision Framework

**Status:** Doctrine (decision-making layer — augments §8 single-question protocol, does not replace it)
**Last updated:** 2026-05-29
**Source:** Karpathy 2026 (github.com/karpathy/llm-council) + Stanford 2026 sycophancy study (Science / Fortune 2026-03-31). Surfaced to Adrian via learnaiwithmariah.com/guides/llm-council-prompt.

## 1. Why this exists

A 2026 Stanford study published in Science evaluated 11 major LLMs (Claude, ChatGPT, Gemini included) and found AI assistants affirm user decisions **~49% more often than human respondents do** — even in cases involving clearly wrong behaviour. In a 2,400-participant follow-up, recipients of sycophantic AI advice came away more convinced they were right, less likely to apologise when wrong, and rated the flattering AI as more trustworthy.

Translation for this stack: every time Adrian asks for advice on a hard decision in an existing Claude session, there is roughly a coin-flip chance the responding session is quietly nodding along. That is acceptable for daily ops; structurally dangerous for pricing, hiring, strategic positioning, legal posture, partnership decisions, doctrine changes.

The LLM Council prompt (Karpathy, open-source, originally multi-model) is the counter. It forces ONE Claude session to answer as five fundamentally different roles, then runs an **anonymised peer-review pass** (each adviser grades the others without knowing which response was its own), then synthesises a chairman's call. The anonymised-review step is the load-bearing one — when a model does not know it is grading its own prior response, it grades honestly; when it knows, it defends.

## 2. The five advisers

1. **The Contrarian** — looks only for what will fail. No balance. Lists every reason this decision is wrong, what breaks first, worst plausible outcome.
2. **The First-Principles Thinker** — rips apart assumptions. Asks what you would do if you couldn't use any obvious framework. Strips the problem to its physics, rebuilds.
3. **The Expansionist** — finds the upside being missed. Asymmetric outcomes. What the bigger version of the bet opens up if it works.
4. **The Outsider** — knows nothing about the industry. Asks the dumb questions only an outsider asks — usually the ones insiders stopped questioning.
5. **The Executor** — does not care about strategy. Cares about Monday morning. What you actually do this week, who you call, what email you send, what file you create.

After all five answer, each adviser silently reviews the other four — referred to only as Response A/B/C/D, anonymised — and ranks 1-4 with one-paragraph reasoning. Then the **Chairman** reads all five answers + all five reviews and writes the final call: no hedge, no "both sides" wash, a clear next step under 250 words.

## 3. When to fire it

**YES** — for decisions where being wrong is structurally expensive:
- Pricing anchors / tier restructure / packaging architecture
- Strategic positioning forks (declare-now vs earn-it; polarising-villain frame yes/no; B2B reframe yes/no)
- Big launches (funnel architecture, lead-magnet strategy, cohort sizing)
- Legal posture (file civil vs hold; settlement framing; counter-claim engagement)
- Hiring / firing / equity / partnership decisions
- Doctrine changes (per AGENTS.md §8 — doctrine changes are inherently high-stakes)
- Any decision Adrian has been deferring, OR where his "leaning" feels under-tested, OR where Claude's recommendation feels suspiciously aligned with what Adrian already wants

**NO** — skip for:
- Daily ops (file commission, dispatch feeder, refresh ledger, send Update Sweep)
- Mechanical code edits / content swaps / typo fixes
- One-off Adrian-action requests (send the email, file the form, look up the status)
- Decisions where Adrian has already made the directional call (council cannot override Adrian; it only sharpens his own read)
- Status queries (source-of-truth-first Gmail/calendar lookups)

## 4. How to fire it

**Cardinal rule: fire in a FRESH chat.** The council's value depends on the 5 advisers starting cold — no priming from the current session's context, no momentum from anything Adrian said earlier in this chat, no Claude-CEO read baked in. A fresh Opus 4.7 chat removes the entire chain-of-context that creates sycophancy in the first place. Running the council inside an already-engaged chat partly defeats the purpose.

Workflow:
1. Open a fresh Claude chat. **Opus 4.7** — the article's tip (Karpathy guide) is that the synthesis step is where the smarter model materially outperforms cheaper models; Sonnet works but is less interesting.
2. Copy the prompt template (§5 below) verbatim.
3. Replace `[DECISION I'M STUCK ON]` with the specific decision + constraints + what "good" looks like. **Be specific.** The council is only as useful as the question. A vague "should I raise pricing?" gets vague answers; a "should the SS Mastermind v2 three-brothers anchor be $22,500 or $29,997, given verbatim cohort proof density and the 30-day plan in v2 §12" gets actionable answers.
4. Send.
5. Read the **Chairman's 250-word synthesis** as the deliverable. The 5 individual responses + reviews are diagnostic supporting evidence — read them if you want to interrogate the synthesis, skip if the chairman's call already lands.

For Claude-CEO operating in this stack (i.e. me in any future session):
- On any high-stakes decision matching §3, surface the option to fire the council BEFORE Adrian commits to a direction
- If Adrian green-lights firing within-session, draft the populated prompt (with the specific decision pasted in) and hand it to Adrian for paste into a fresh chat — never run it inside an already-engaged session
- The Chairman's call enters Adrian's §8 single-question protocol as Claude-CEO's "my read"
- Council augments §8, never replaces it

## 5. The prompt template (verbatim — Karpathy original)

```
DECISION I'M STUCK ON:
[Replace this with your specific decision or question. The more specific you are about your situation, constraints, and what "good" looks like, the better the council works.]

I want you to act as a five-person decision council. Do not skip steps. Do not blend the advisers together. Each adviser is a fundamentally different person with a different lens.

STEP 1 — Each adviser answers separately.

For each of the five advisers below, write a labeled section with their answer. Stay in character. Different language, different priorities, different blind spots.

Adviser 1 — THE CONTRARIAN. Looks only for what will fail. Does not balance. Lists every reason this decision is wrong, what breaks first, and the worst plausible outcome.

Adviser 2 — THE FIRST-PRINCIPLES THINKER. Rips apart my assumptions. Asks what I would do if I couldn't use any obvious framework. Strips the problem down to fundamentals and rebuilds.

Adviser 3 — THE EXPANSIONIST. Finds the upside I'm missing. Looks at the asymmetric outcome if this works. What does the bigger version of this open up?

Adviser 4 — THE OUTSIDER. Knows nothing about my industry. Asks the dumb questions only an outsider asks. Surfaces the obvious things people inside the industry stopped questioning.

Adviser 5 — THE EXECUTOR. Doesn't care about strategy. Cares about Monday morning. Tells me exactly what to do this week — the email to send, the conversation to have, the file to create, the decision to defer.

STEP 2 — Anonymous peer review.

Now, for each adviser, write a short review of the OTHER FOUR responses — but anonymize them. Refer to them only as "Response A," "Response B," etc. Do not let an adviser know which response is which. Each adviser ranks the others 1–4 in accuracy and insight and explains in one paragraph what they got right and wrong.

STEP 3 — The Chairman's final call.

Finally, act as the Chairman. You have read all five original answers and all five anonymous reviews. Synthesize a single clear recommendation. No hedging. No "both sides." Tell me:
- What the right decision actually is
- The one strongest reason for it
- The one biggest risk to watch for
- The specific next step I should take in the next 7 days

Keep the Chairman's section under 250 words. Sharper is better.
```

## 6. Relationship to the existing 4-way research bridge

This is orthogonal to, not a replacement for, the existing ChatGPT-Pro + SuperGrok + AG multi-model research stack (per `working/handoffs/STATE-OF-STACK.md` 2026-05-27 ~11:00 four-source synthesis pattern):

| Layer | Function | Failure mode it solves |
|---|---|---|
| Multi-model bridges (ChatGPT Pro DR / SuperGrok DeeperSearch / AG Gemini 3.5 Flash High) | Different substrates → different priors, different blind spots, different recency cuts | Single-model overconfidence; ChatGPT memory leverage; Grok contrarian challenge; AG sustained-burn depth |
| LLM Council (single-chat, role-forced) | One model forced into 5 role-incompatible incentive structures + anonymous peer review + chairman synthesis | Sycophancy WITHIN a single session; under-tested "leanings" Adrian carries into chat; Claude-CEO recommendations that suspiciously align with Adrian's pre-existing direction |

The two can **compound**:
- **Council BEFORE 4-way:** use the council to identify what to actually ask the bridges (council surfaces the questions Adrian's pre-existing framing is hiding)
- **Council AFTER 4-way:** use the council to pressure-test the chairman-level synthesis the 4-way produces (does the recommendation survive 5 hostile roles + anonymised review?)
- **Council INSTEAD of 4-way:** for time-pressured decisions where the bridge ferry-cycle is too slow but sycophancy risk is still real

## 7. Source attribution

- Original framework: **Andrej Karpathy**, 2026, github.com/karpathy/llm-council (multi-model implementation; this doctrine adapts it to single-Claude operation per the Mariah Garcia guide)
- Sycophancy data: **Stanford 2026 study (Science)**; summarised Fortune 2026-03-31, "AI tech sycophantic regulations OpenAI ChatGPT Gemini Claude Anthropic American politics"; 11 LLMs evaluated; ~49% over-affirmation rate vs human baseline; 2,400-participant follow-up
- Guide that surfaced this to Adrian: **Mariah Garcia**, learnaiwithmariah.com/guides/llm-council-prompt (2026); recommends Opus 4.7 for the synthesis step

## 8. Revision history

- 2026-05-29: Created. Adrian-direct authorisation to lock the council into doctrine + memory after reading the Mariah Garcia guide on 2026-05-29. Adrian-stated rationale: "start experimenting with it on different decisions moving forward to see if it adds any of [the] benefit." First live test candidate identified at creation: SS Mastermind v2 pricing anchor ($22,500 vs $29,997, three-brothers conversation this week per v2 §12). Doctrine status: PROVISIONAL until ≥3 live decisions have been run through the council and Adrian confirms it adds material decision quality vs the existing §8 protocol alone.
