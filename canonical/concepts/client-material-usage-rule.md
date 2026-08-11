---
title: "Client Material Usage Rule (Chatham House gate)"
type: doctrine-decision-record
status: ACTIVE
authority: Adrian-direct, 2026-08-02
recorded_by: M2-Claude
firewall_class: working-internal
supersedes: none
related:
  - "AGENTS.md §7 (firewall)"
  - "canonical/people/tristan-hamm-unified.md"
  - "working/deep-extraction/ (sensitive third-party sub-archive)"
---

# Client Material Usage Rule

**Authority:** Adrian-direct, 2026-08-02, verbatim:

> *"Yes, Tristan's stuff is firewalled. You can ingest it and enrich Tristan's folder, but obviously client things are always behind the firewall unless Chattenhaus rules are implied and enforced. or the audio recording or the quote can be used if it stands on its own and doesn't identify the client unless permission is granted"*

("Chattenhaus" is voice-to-text for **Chatham House**. Interpretation stated back to Adrian at the time of recording and executed on that basis.)

---

## The rule

**Default: client material stays behind the firewall.** Not public, not published, not clipped.

Three, and only three, routes out:

1. **Chatham House terms.** The *substance* may be used; the *identity and affiliation* of the client may not. The information travels, the person does not. This must be **implied and enforced** — i.e. actually applied to the output, not merely intended.
2. **A self-standing quote or audio clip.** A quote or a piece of audio may be used **if it stands on its own** and **does not identify the client**. "Stands on its own" means it carries meaning without the surrounding case context; if it only makes sense once you know whose session it was, it does not qualify.
3. **Explicit permission.** Anything that identifies the client requires permission granted by that client.

**If none of the three applies, the material stays in.**

---

## Clarification 2026-08-11 (Adrian-direct) — Route 2 applies to Adrian's own facilitator statements, not only client statements

**§8 classification: clarification/extension, no existing rule weakened, removed, or reinterpreted.**

Raised on a live case: `ss-language-signature.md` (classified `strictly-private-mastermind`) was the source for public-facing copy in a CLI review. The file's own classification was being read as making every phrase extracted from it presumptively secret, which over-restricts — a file-level classification protects the aggregated corpus document itself, not necessarily every individual sentence within it, especially Adrian's own recorded words.

Adrian, verbatim: *"anything that I say can be used in isolation as long as it doesn't identify the client."*

This is the same Route 2 test already in this document (**"stands on its own," "does not identify the client"**), stated explicitly to cover statements Adrian himself makes during a session, not only things a client says. The underlying concern is identical either way: does the specific extracted content, standing alone, reveal or identify who the client was. A generic facilitation line Adrian used with a client (a diagnostic question, a sovereignty-framing statement, a technique name) does not identify that client merely by having been said in their session — the same self-standing test applies.

**Worked example from the live case:** "Did that decision take your peace of mind, or did you hand it over?" and "You're the one who makes the call" — both adapted from `ss-language-signature.md`, both Adrian's own words, neither containing a name or any client-identifying detail. Cleared under Route 2 as extended here. Contrast: if the same file had recorded Adrian saying "so when you told me about your custody situation with your ex..." — that utterance, even though it's Adrian speaking, would fail the test, because it only makes sense once you know whose session it was and carries an identifying detail. **The test is about the content of the specific extracted line, not about which party in the room said it.**

## What this does NOT authorise

- It does **not** make client material publishable by default once ingested. Ingestion into the vault and eligibility for output are separate questions; this rule governs the second.
- It does **not** override the **§7 Chelsea firewall**, which is absolute and unaffected by any of the three routes above.
- It does **not** override the **SS speaker-attribution gate**: no quote from a multi-speaker source ships until the speaker is verified. An **undiarized** recording therefore cannot supply an attributable quote regardless of this rule, because there is no verified speaker to attribute it to.
- It does **not** convert AI-generated characterisations of a named person into usable material. Prior autonomous output in `working/deep-extraction/` (abuse characterisations, psych-evaluation drafts, witness-brief drafts) was generated without a human professional in the loop and remains non-authoritative.

---

## Why this needed writing down

The vault's automated privacy classifier tests **one** pattern — the Chelsea regex in `segment_staging.stage_speech_segments()` and `write_speech_note()`. Anything it does not match is written `firewall_class: working-internal`, and may additionally be scored `reel_signal: yes`.

**That classifier cannot see client material at all.** It is silent on it by design, not by judgement. So a private client session can land in the corpus marked internal-and-reel-eligible, and a downstream clip pass has nothing to stop it.

Live example, 2026-08-02: `episodic/transcripts/speech/tristan 19th dec.md` — a 1.38-hour call concerning a named client's interpersonal situation — was classified `working-internal` with `reel_signal: yes` by the canonical extractor. Correct per the code; wrong per this rule. It is flagged in §5 of `canonical/people/tristan-hamm-unified.md`.

**Practical consequence:** `reel_signal: yes` on client material means *unassessed*, never *cleared*. The gate is this rule, applied by a human or by an agent explicitly reasoning against these three routes — not the classifier.

---

## Proposed follow-through (not yet actioned)

1. **AGENTS.md §7 amendment** so this binds at doctrine level rather than sitting only here — filed to M1 as `m2-to-m1-2026-08-02-client-material-usage-rule.md`. Per §8, a doctrine change is Adrian-authorised (it is) but M1 is the canonical writer of `AGENTS.md`.
2. **A client-material signal in the classifier** — the current single-pattern test cannot express "this is a client session". Until it can, the gate is human.
