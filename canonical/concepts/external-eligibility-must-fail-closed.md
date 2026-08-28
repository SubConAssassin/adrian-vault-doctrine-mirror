# AN EXTERNAL-ELIGIBILITY GATE MUST FAIL CLOSED

**Canonical rule. 2026-08-29, written after two firewall events on the same night that are the same
principle from opposite ends.**

- **~20:40** — M1 was assigned bulk classification of ~11,660 "ungated" records on an external API
  and **refused the transport**, because the pattern list's own history shows "ungated" has
  repeatedly meant "undiscovered confidential".
- **~23:50–00:45** — M2 corpus-mining captioned 9,551 images on an external API. An audit of the
  **output** found **1,628 sensitive images (16.7%) had left the estate**: 258 chat threads,
  banking screens and ID documents, plus 1,370 lock screens carrying notification previews and
  sender names. Contained at 00:45. **Unsendable.**

---

## 1. THE RULE

> **Anything leaving the estate must be POSITIVELY classified as safe. "Not known to be private"
> is never "known to be safe".**

Three states, and only the first may egress:

| state | meaning | may leave? |
|---|---|---|
| **KNOWN-SAFE** | a validated rule positively identified it as impersonal | **yes** |
| **KNOWN-SENSITIVE** | a rule matched a confidential class | no |
| **UNDECIDED** | no rule could adjudicate it | **no — and this is the default** |

The failure was not a wrong verdict. **The gate was structurally incapable of reaching a verdict**
on 87.7% of what it saw, and the architecture treated "no verdict" as permission.

---

## 2. WHY THE DEFAULT MUST BE ASYMMETRIC

The two error directions are not comparable and the asymmetry decides the default:

- Wrongly withhold something safe → **a delay.** Recoverable, visible, cheap.
- Wrongly release something private → **irreversible.** It is on a third party's servers, under
  retention terms you cannot verify, and no subsequent action retrieves it.

> 🔑 **When one error is recoverable and the other is not, the default belongs on the recoverable
> side, and no efficiency argument outranks that.**

This is the same shape as `a-worker-error-is-not-a-content-verdict.md`: a wrong RETRY costs bounded
compute, a wrong DONE removes an item from the backlog forever. **Both rules are one rule: default
toward the reversible outcome.**

---

## 3. A TIER THAT CAN BE PROMOTED IS NOT A SAFE DEFAULT

M2 built the correct default — unclassified → AMBER, never GREEN — and it still failed, because
**AMBER could be promoted to external by a second-stage detector.** So the real default was
whatever that detector said, and it said GREEN to almost everything.

> **A safe default that something else can override is not a default. It is a suggestion.**
> If a tier can be promoted, the promoter's failure mode IS the system's default. Audit the
> promoter, not the tier.

---

## 4. NEVER SHIP A DETECTOR THAT WAS NOT VALIDATED ON THE DOMINANT FILE TYPE

Stage-2 identified screenshots by matching **original device pixel dimensions**. The corpus is
**87.7% Photos-library derivatives**, which are resized and therefore never match. Its own research
note said so before it ran: *"Stage 2 has never been validated on real files; 0 of my 3,000 test
images matched a device resolution."*

**And the authoritative flag does not rescue it either.** Apple's `ZKINDSUBTYPE==10` marks only
images captured with the screenshot gesture *on that device*. A Messenger thread someone sent you
and you saved is an ordinary photo. On the leaked example: `known screenshot: False`.

> **Validate a classifier on the file type that DOMINATES the corpus, not on a clean test set.
> A detector that cannot decide must return UNDECIDED, never a default verdict.**

---

## 5. AUDIT THE OUTPUT, NOT THE TABLE

M2's three self-criticisms, verbatim, because they generalise far beyond images:

1. *"I built a fail-safe default and then let AMBER be promoted by a detector I had never validated
   on the file type that dominates the corpus."*
2. *"I audited the routing TABLE before starting and it looked right. I did not audit the OUTPUT.
   A gate's verdict distribution tells you nothing about whether the verdicts are correct."*
3. *"I treated 0 errors + 0.40 s/image as evidence the lane was healthy. It was evidence it was fast."*

**It was found by reading eight random captions.** Not by a counter, an error rate, or a throughput
number — all of which said healthy throughout.

> **Before any bulk external run, read a random sample of the ACTUAL OUTPUT. Ten items is enough to
> find a 2.7% base rate. Do it again periodically during the run, not only at the start.**

---

## 6. THE OPERATING CHECKLIST

Before any bulk job that egresses:

1. **Name the positive rule** that makes each item safe. If the rule is "nothing flagged it", stop.
2. **Validate the classifier on the dominant file type**, with counts.
3. **Confirm nothing can promote the undecided tier.**
4. **Read ten random OUTPUTS**, not ten inputs and not the verdict distribution.
5. **Keep the affected list.** If it goes wrong, "which items" must be answerable — M2 could answer
   it, which is the difference between an incident and a catastrophe.
6. **Prefer the local lane.** $0, and the question does not arise. The PC vision lane and M2 Ollama
   both caption images without anything leaving the estate.

---

## 7. THE UNDERLYING SENTENCE

Both events, and every fault found on 2026-08-28
(`the-description-drift-failure-2026-08-28.md`), reduce to:

> **A signal about our machinery was read as a signal about the world.**

"No rule matched" described **our rule set**. It was acted on as a fact about **Adrian's data**.

---

*Related: `a-worker-error-is-not-a-content-verdict.md` · `the-description-drift-failure-2026-08-28.md` ·
`firewall-tests-must-be-content-based` · AGENTS.md §7 and §7.0 · `tools/firewall-gap-finder.py`.*
