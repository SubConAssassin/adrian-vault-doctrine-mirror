# A WORKER ERROR IS NOT A CONTENT VERDICT

**Canonical rule. Written 2026-08-28 by M1 at M2's request, for M2 to implement.**
M2: *"You own canonical; write the rule and I will implement it — I am not editing a live collector
on my own authority."*

**The incident:** `icloud-video-orchestrator-v2.py:~1523` does

```python
if "error" in data: ... mark_done(uuid)
```

It cannot tell `ModuleNotFoundError` or `No such file or directory` (**our** infrastructure,
retryable, the item is untouched) from a genuinely corrupt file (**the item**, terminal).
**That conflation destroyed 2,837 m1 sources today and 38 m4 sources before it.** "Destroyed" means
marked permanently done, so they will never be retried and never appear in any backlog again. The
data still exists; our record of needing to process it does not.

---

## 1. THE RULE

> **`mark_done()` records a verdict about the ITEM. An error from a worker is, by default,
> a statement about the RUN. Only an explicitly enumerated, terminal, item-level condition may
> mark an item done. Everything else retries, and after retries are exhausted it is PARKED —
> never done.**

Three outcomes exist. There is no fourth, and "done" is not the default for any of them:

| outcome | means | when |
|---|---|---|
| **DONE** | this item needs no further work, ever | success, **or** a condition on the terminal allowlist below |
| **RETRY** | the run failed, the item is untouched | anything not on either list, **including anything unrecognised** |
| **PARKED** | retries exhausted, or a terminal condition worth a human | stays visible in a queue forever until someone rules on it |

---

## 2. FAIL SAFE IN THE DIRECTION THAT IS RECOVERABLE

The two error directions are **not** symmetrical, and the asymmetry decides the default:

- Wrongly **RETRY** a genuinely dead item → you waste some compute, and a bounded retry counter
  stops it. Cost: cheap, self-limiting, visible.
- Wrongly **DONE** a live item → **it leaves the backlog silently and nothing will ever surface it
  again.** Cost: unbounded, invisible, and only discovered by an audit nobody scheduled.

> 🔑 **Therefore: unrecognised error ⇒ RETRY, never DONE.** An allowlist of terminal conditions, not
> a blocklist of retryable ones. A blocklist fails open in the expensive direction the first time a
> new error string appears — and new error strings appear constantly.

---

## 3. THE TERMINAL ALLOWLIST — the ONLY things that may mark done on failure

A condition qualifies only if **re-running the identical job on the identical bytes could not
succeed.** Test every candidate against that sentence.

1. **The source is decodable but structurally invalid** — verified by a decoder, not inferred:
   `moov atom not found`, truncated container, `Invalid data found when processing input`.
   ⚠️ Only when the file is fully **local and non-dataless**. See §4.
2. **The source has zero relevant content** — a video with no audio stream when the job is
   transcription; a zero-byte file confirmed by `stat`.
3. **Policy exclusion** — firewall/HARD_HOLD class. That is a *decision*, not a failure, and should
   ideally use its own state rather than `done`.
4. **Duplicate of an already-completed item**, proven by content hash, not by filename.

**Everything else is RETRY.** Explicitly including, because these caused the incident:
`ModuleNotFoundError`, `ImportError`, `No such file or directory`, permission denied, disk full,
OOM, timeout, connection reset, HTTP 5xx, 429, SMB/NFS stalls, a dead model server, CUDA OOM,
`llama-server` crash, any non-zero exit with no parsed reason, and **any error string the classifier
does not recognise**.

---

## 4. THE DATALESS TRAP — the one that will bite hardest here

A cloud-evicted file (iCloud / Google Drive "optimise storage") reports **0 blocks local** and can
fail decoding in ways that look exactly like corruption. **It is not corrupt. It is absent.**

> **Before any terminal decode verdict, prove residency:** the file has non-zero local blocks
> (`st_blocks > 0`). If it is dataless, the outcome is **RETRY**, or PARKED with reason
> `awaiting-hydration`. **Never DONE.**

The pipeline already knows this — `probe_presence()` exists and correctly refuses to fabricate a
caption for a dataless file. The orchestrator's `mark_done()` path does not consult it. That gap is
the bug.

---

## 5. RETRY AND PARK

- **Bounded retries with backoff**, counted per item and persisted. Three attempts is a reasonable
  default; the number matters less than that it is finite and recorded.
- On exhaustion: **PARK, with the verbatim last error and the attempt count.** A parked item stays
  in a queue a human can see. **Parking is not done.**
- **A parked item must be countable.** If `parked` cannot be totalled in one query, it will be
  forgotten, which reproduces the original bug with extra steps.

---

## 6. EVERY DONE MUST CARRY ITS REASON

Change the ledger so `mark_done` cannot be called without a machine-readable reason:

```
mark_done(uuid, reason="success" | "terminal:<code>" | "policy:<class>" | "duplicate:<hash>")
```

Two things this buys immediately:
1. **Auditability** — `SELECT reason, COUNT(*) … GROUP BY reason` instantly shows a spike in
   terminal verdicts. Today's 2,837 would have been visible the moment it started.
2. **Reversibility** — the 2,837 can be found and un-done, because they are the rows whose reason
   is an infrastructure code that should never have been terminal.

**A `done` with no reason is the bug. Make it unrepresentable.**

---

## 7. THE RECOVERY THIS IMPLIES

The 2,837 m1 and 38 m4 sources were marked done by an infrastructure error. **They are recoverable
if, and only if, the error text was retained.** Before any of this is implemented, check whether the
ledger kept it. If it did, they can be reset. If it did not, that is itself the strongest argument
for §6, and the set will have to be rebuilt by re-walking the source rather than trusting the
ledger.

**Do not reset anything on the strength of this document alone.** Re-deriving 2,875 items is a bulk
mutation of a live ledger and needs its own verification pass, on M2's authority, with a dry run
first.

---

## 8. THE GENERAL FORM

This is one instance of the pattern that produced every fault found on 2026-08-28
(`the-description-drift-failure-2026-08-28.md`):

> **A signal about OUR machinery was read as a signal about THE WORLD.**

`error` described our runtime. It was recorded as a fact about Adrian's video. Same shape as a
monitor reporting healthy while measuring the wrong thing, and same shape as an agent trusting a
registry over the engine that answered.

**When a component reports a failure, the first question is always: is this a statement about the
work, or about the worker?**
