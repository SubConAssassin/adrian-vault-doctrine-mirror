---
title: Lessons Learned — Rolling Index
type: canon
status: canonical
created: 2026-05-04
updated: 2026-05-04
tags: [adrian-os, learning, mitigations, infrastructure]
related:
  - canonical/concepts/shutdown-protocol.md
  - canonical/concepts/session-archive-protocol.md
---

## Purpose

Append-only index of lessons extracted from session shutdowns. Read **forwards** — scanned before starting work in a domain to avoid known traps.

This is distinct from:
- **Session archives** (`raw/sessions/`) — read backwards when chasing a remembered problem.
- **Decisions canonical** (`canonical/businesses/...`, `canonical/projects/...`) — state changes about the world.
- **Process canonical** (`canonical/concepts/`, `canonical/frameworks/`) — how we work; lessons cite these when a `process-change` is promoted into one.

## How entries get here

Step 8 of the shutdown protocol (`canonical/concepts/shutdown-protocol.md`). Material lessons from each session are appended below. Trivial lessons stay in the session archive only.

## Entry schema

```markdown
### LL-YYYY-MM-DD-NNN [tag1, tag2] — One-line title

**Session:** <session_id> · **Archive:** [path]
**Date:** YYYY-MM-DD

**Context:** <2-3 sentences — what was being attempted>

**What happened:** <observation — the mistake / discovery / gotcha>

**Root cause:** <only for `mistake` / `tool-gotcha` — why it happened>

**Mitigation / pattern:** <the reusable takeaway>

**Promoted to:** <canonical file path if a new process/safeguard was created or extended, else "—">

**Tags:** `mistake` | `discovery` | `tool-gotcha` | `process-change` (one or more)
```

## Tag taxonomy

| Tag | Definition | Example |
|---|---|---|
| `mistake` | Error made → root cause → mitigation | Skipped a tool_search and assumed parameter names; tool failed silently |
| `discovery` | New technique/pattern worth reusing | `read_multiple_files` halves latency vs sequential reads on small files |
| `tool-gotcha` | MCP/tool/library quirk + workaround | Wix variant API silently drops variants if `option` field omitted |
| `process-change` | New safeguard added to canonical | Added Step 8 Lessons to shutdown protocol after gap noticed |

Multiple tags allowed (e.g. a `tool-gotcha` may also be a `process-change` if a canonical guard is added).

## Domain index

Search this file with `grep -i <domain>` to filter relevant lessons before starting work. Common domain keywords to grep for:

- `wix`, `etsy`, `meta-ads` — channel-specific
- `osb`, `subconscious-surgery`, `aga`, `wte` — business-specific
- `mcp`, `filesystem`, `apple-mail`, `osascript` — tooling
- `secretary`, `shutdown`, `dispatcher`, `u-protocol` — protocol-level

## Promotion threshold

A lesson is worth appending here if a future Claude session scanning this file before similar work would change its approach. If the answer is "no, this is one-off," the lesson stays in the session archive only.

When unclear, err toward including. Cost of one extra entry is low; cost of repeating a mistake is high.

---

## Lessons

### LL-2026-05-04-001 [process-change, mistake] — Shutdown protocol existed in two duplicate canonical files

**Session:** 2026-05-04 shutdown-protocol consolidation · **Archive:** (this session)
**Date:** 2026-05-04

**Context:** Adrian asked Claude to lay out the shutdown protocol "as you have it." Claude found two canonical files (`shutdown-protocol.md` and `session-shutdown-protocol.md`) covering the same procedure with different step numbering and partially overlapping content.

**What happened:** Both files were marked `status: canonical`. Neither pointed to the other. A shutdown trigger would force Claude to reconcile two docs in real time — fragile, slow, prone to dropped steps.

**Root cause:** When the second file was written 2026-04-24 (3 days after the first), the author did not search for an existing canonical of the same name/purpose. No pre-write canonical search was enforced.

**Mitigation / pattern:**
1. Merged into single canonical (`shutdown-protocol.md` v2), marked the second superseded.
2. Before writing any new `canonical/concepts/*.md` file, grep for similar titles AND scan the related-frontmatter graph of nearest neighbours.
3. Add to dispatcher protocol's silent pre-write sweep: also check for canonical-name collisions.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` (v2 merge), this entry.

**Tags:** `process-change`, `mistake`

---

### LL-2026-05-04-002 [discovery, process-change] — Lessons need their own forward-readable file, separate from archives

**Session:** 2026-05-04 shutdown-protocol consolidation · **Archive:** (this session)
**Date:** 2026-05-04

**Context:** Adrian asked whether the shutdown protocol captured mistakes and learnings so processes could be improved over time. Initial v2 protocol relied on session archives to hold lessons implicitly.

**What happened:** Audit revealed that actions (Secretary), decisions (Step 7 promote), and outputs (Step 6 handoff) were each given dedicated steps and dedicated files — but lessons were buried in the archive's free-form body. No forward-readable index. No way for a future session to grep "what gotchas have we hit on Wix" without reading every archive that mentioned Wix.

**Root cause:** Conflated two access patterns. Archives are read *backwards* (chasing a remembered problem). Lessons should be read *forwards* (scanned before starting domain work). Same content, different file, different index.

**Mitigation / pattern:**
1. Added Step 8 to shutdown protocol — mandatory lessons extraction, even if `0 extracted`.
2. Created this file as the rolling canonical. Append-only, indexed by date + tag + domain keywords.
3. Restart Recovery Checklist (in shutdown-protocol.md) updated: next session greps this file by domain before starting work.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` (Step 8 added), this file (created).

**Tags:** `discovery`, `process-change`

---

### LL-2026-05-04-003 [discovery, process-change] — One-doctrine-two-surfaces pattern for cross-surface protocols

**Session:** 5db0 shutdown-protocol-v2-2-build · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-04

**Context:** Adrian asked to extend shutdown protocol to Antigravity. Naive read = write a parallel AG-shutdown-protocol.md. That would have created the exact duplication problem just resolved by LL-2026-05-04-001.

**What happened:** Recognised the u-protocol already solved this — single canonical doc with `applies_to: [claude, antigravity]` frontmatter and a deltas section. Adopted the same shape for shutdown-protocol.md v2.2.

**Mitigation / pattern:** When a doctrine touches both Claude and AG, write ONE canonical with:
1. `applies_to: [claude, antigravity]` in frontmatter
2. Universal body (the protocol body works for both surfaces)
3. `## <SecondSurface> adaptations` section near the end documenting deltas (triggers, step behaviours, final-line format, edge cases)
4. Cross-surface coordination subsection (what happens when both surfaces run the protocol concurrently)

Reusable for any future cross-surface doctrine. Don't duplicate.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` v2.2 (uses pattern), this entry.

**Tags:** `discovery`, `process-change`

---

### LL-2026-05-04-004 [discovery, process-change] — Handoff acknowledgment loop = telemetry for doctrine integration

**Session:** 5db0 shutdown-protocol-v2-2-build · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-04

**Context:** Per u-protocol authoring rules, handoffs must be self-executing with a defined "done" state. But "doctrine integration" handoffs have no tangible output — the work is internalisation, not file production.

**What happened:** Resolved by requiring the receiving surface to write an acknowledgment file as the only telemetry. File path pattern: `working/handoffs/YYYY-MM-DD-HHMM-<receiver>-to-<sender>-<doctrine-slug>-integrated.md`. File existence IS the proof of integration. Acknowledgment file content includes: confirmation of read, list of internalised triggers/behaviours, optional dry-run results, and — critically — proposed deltas if the receiver sees gaps based on its operational reality.

**Mitigation / pattern:** Canonical pattern for ANY cross-surface doctrine push:
1. Authoring side writes self-executing handoff to working/handoffs/
2. Receiving side reads the handoff (via `u` or explicit instruction)
3. Receiving side writes acknowledgment file back to working/handoffs/ with confirmation + proposed deltas
4. Authoring side reads ack on next session, marks Secretary action complete, applies any proposed deltas to canonical

The proposed-deltas slot is critical — prevents the receiver from silently working around gaps in the doctrine. Surfaces operational mismatches for canonical update.

**Promoted to:** `canonical/concepts/shutdown-protocol.md` (handoff to AG used this pattern), this entry. Worth lifting into a standalone `canonical/concepts/cross-surface-doctrine-integration.md` if used two more times.

**Tags:** `discovery`, `process-change`

---

### LL-2026-05-04-005 [tool-gotcha] — /working/ is gitignored; save-vault output silent about it

**Session:** 5db0 shutdown-protocol-v2-2-build · **Archive:** raw/sessions/2026-05-05-0014-shutdown-protocol-v2-2-build-with-ag-integration.md
**Date:** 2026-05-04

**Context:** Wrote a handoff to `working/handoffs/` then ran save-vault. Output only listed the modified canonical file in the commit summary; new handoff file was not mentioned. Initially looked like a write failure.

**What happened:** Verified file existed on disk (6059 bytes, correct path, correct content). `git status` showed "nothing to commit, working tree clean." `git ls-files | grep <handoff>` returned empty. Investigation: `.gitignore` rule `/working/` excludes the entire working directory per `bridge-protocols.md` rule that only canonical/ syncs to the public-facing GitHub mirror.

**Root cause:** save-vault is a thin wrapper around `git add -A && git commit && git push`. It honours .gitignore. Handoffs in /working/ are deliberately local-only. AG reads them via filesystem MCP, not git. So the gitignore is correct behaviour. But save-vault's output gives no signal that working/ files were skipped — it's silent.

**Mitigation / pattern:**
1. Don't read save-vault silence about working/ files as failure. Verify with `ls` or `git check-ignore -v <path>` before assuming a write failed.
2. For any handoff-write workflow, add a post-write `ls -la <handoff-path>` to confirm the file exists, since save-vault won't tell you.
3. If you ever need a working/ file in git for any reason, you'd need to override the gitignore explicitly (`git add -f`) — but think hard about whether it should be in canonical/ instead.

**Promoted to:** This entry. Worth adding to `canonical/concepts/bridge-protocols.md` as a known operational consequence of the gitignore rule.

**Tags:** `tool-gotcha`

---
