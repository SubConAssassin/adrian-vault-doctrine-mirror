---
title: Edit-Lease Protocol — Concurrency Control for Multi-Agent Canonical Edits
type: canonical-doctrine
status: proposed-pending-adrian
version: 0.1
created: 2026-04-30
last_updated: 2026-04-30
authored_by: claude (Claude Code, autonomous loop iteration — T14 of hive-mind implementation plan)
purpose: Codify a lightweight file-lock protocol so Claude + Antigravity + future agents do not race-condition on canonical/concepts/ edits. Builds on dispatcher-protocol.md's lease concept; extends to per-file edit-time locking with mandatory postflight validation.
status_note: Adopt-when-conflicts-observed. As of 2026-04-30 the dual-agent setup (Claude + AG) has not produced an observed race-condition incident, but the cross-ref recommendation from ChatGPT (top-of-field §6.1 portfolio-level lesson) flagged this as the highest-probability silent corruption class. Promote from `proposed` to `active` on first observed incident OR after 90-day burn-in, whichever first.
sources:
  - canonical/concepts/dispatcher-protocol.md (lease-based concurrency control for parallel Claude sessions)
  - canonical/concepts/top-of-field-cross-ref-2026-04-24.md §6.1 (codified-protocol-system pattern)
  - working/handoffs/2026-04-29-1645-UTC-chatgpt-claude-api.md (ChatGPT cross-ref originating recommendation)
related:
  - canonical/concepts/dispatcher-protocol.md
  - canonical/concepts/frictionless-operator-doctrine.md
  - canonical/concepts/api-integration-doctrine.md
  - canonical/concepts/sleep-time-protocol.md
tags: [concurrency, lease, lock, validation, canonical-edit-discipline, postflight]
---

## 1. Why this exists

Adrian's stack now has at least three agents that can write to `canonical/concepts/`: Claude (claude.ai chat sessions OR Claude Code OR Cowork), Antigravity (file-IO sandbox), and Adrian himself (manual edits). Future agents (Codex, Jules, future GPT) will join.

Concurrent writers on the same canonical file produce the **silent-corruption failure class**: both agents write valid Markdown; the result is invalid knowledge state — a doc with conflicting frontmatter, half a supersedes-chain, or an author attribution mismatch.

`dispatcher-protocol.md` already defines a lease pattern at the *intent* layer (declare what you're about to touch, sibling sessions read the table). This protocol extends that to the *edit-time* layer with **per-file write locks** + **mandatory postflight validation**.

## 2. Core mechanics

### 2.1 Lock file location

Every canonical file edit takes a lock at:

```
~/Documents/Adrian-Vault/.leases/<relative-path>.lock
```

Examples:

- Edit to `canonical/concepts/bridge-protocols.md` → lock at `.leases/canonical/concepts/bridge-protocols.md.lock`
- Edit to `canonical/projects/osb/business-intelligence-2026-04-24.md` → lock at `.leases/canonical/projects/osb/business-intelligence-2026-04-24.md.lock`

The `.leases/` directory mirrors the vault structure exactly. This makes lock collisions impossible (one file, one lock path).

### 2.2 Lock file contents (YAML frontmatter)

```yaml
---
agent: claude  # or antigravity / codex / adrian / etc.
surface: claude-code  # or claude-ai / cowork / cowork-vm / antigravity / terminal
session_id: <uuid-or-process-id>
canary: <link-to-handoff-canary-or-self-uuid>
acquired_at: 2026-04-30T07:55:00+08:00
ttl_seconds: 600  # 10 minutes default; bumped for long edits
intent: <one-line description of what this edit will do>
target_path: <absolute-path-of-the-file-being-edited>
---
```

### 2.3 Pre-write protocol

Before any agent writes to a `canonical/*.md` file:

1. **Check** if `.leases/<path>.lock` exists.
2. **If yes**, read it:
   - If `acquired_at + ttl_seconds < now`: lock is stale → the original agent died or forgot to release; **acquire it** (overwrite with own lock + log acquisition reason in the lock file body as `# stale-acquired by claude at 2026-04-30T08:00 — original agent: antigravity-session-xyz`).
   - If lock is fresh and held by another agent: **DEFER**. Either (a) wait + retry every 30s up to 3× then give up, OR (b) write a deferral note to `working/handoffs/<HHMM>-<agent>-deferred-on-lease.md` and proceed to other work.
   - If lock is held by the SAME agent (this session has it already): proceed; renew TTL.
3. **If no lock**: create the lock, then write. Always create-then-write, never write-then-create.

### 2.4 Post-write protocol — mandatory validation

After write, but BEFORE releasing the lock:

1. **Run `validate-note.sh <path>`** (already exists at `.claude/scripts/stability/validate-note.sh`):
   - YAML frontmatter parses
   - Required keys present (title + ≥1 date key)
   - `supersedes:` / `superseded_by:` targets exist
   - `[[wikilinks]]` resolve
   - File is not 0 bytes / not iCloud stub
2. If validation fails: revert the edit (or flag for Adrian if revert isn't safe), keep the lock open until resolved. Write incident note to `wiki/audits/incident-<HHMM>.md`.
3. If validation passes: **release the lock** (delete the `.lock` file).

### 2.5 Lock release on session end

Every agent's session-shutdown protocol (per `shutdown-protocol.md`) MUST include:

```
for lock in .leases/**/*.lock; do
  if [ "$(yq -r .session_id $lock)" = "$MY_SESSION_ID" ]; then
    rm $lock
  fi
done
```

If the agent crashes (no graceful shutdown), `ttl_seconds` from §2.2 lets the next agent acquire-stale per §2.3.

## 3. Operational integration

### 3.1 Claude Code

Claude Code's `.claude/scripts/stability/check-leases.sh` (already exists) runs every loop iteration as part of preflight to surface stale locks. Extend that script to also surface FRESH locks held by other agents — that's the new "do not write here, defer" signal.

### 3.2 Antigravity

AG's session-start preflight (per `claude-antigravity-work-partition.md`) extends to: also read `.leases/` and respect locks. If AG is commissioned to edit a file currently locked by another agent, AG defers and writes a deferral handoff.

### 3.3 Adrian (manual edits)

Adrian generally does NOT need to take locks for trivial edits — he's the human and his window of edit is short. But for substantive edits (adding a new canonical doc, restructuring an existing one), he can take a lock the same way:

```bash
# convenience alias for Adrian's terminal
alias canlock='echo "agent: adrian\nsurface: terminal\nacquired_at: $(date -Iseconds)\nttl_seconds: 1800" > .leases/$1.lock'
```

If Adrian forgets the lock and writes anyway, his edit wins (as the founder); validators surface any frontmatter/wikilink breakage on next loop preflight.

### 3.4 Cross-pollination with bridge-protocols.md

`bridge-protocols.md` v1.5 governs courier channels and now-API-primary cross-model comms. Edit-lease protocol governs *the local filesystem write layer* — orthogonal but complementary. An agent receiving a courier handoff (e.g. ChatGPT response landing in Drive) still acquires an edit-lease before writing the response into canonical.

## 4. Severity classes (when to enforce vs. when to advise)

| Class | Path pattern | Lock requirement |
|---|---|---|
| **L1 — Strict** | `canonical/concepts/*.md` (doctrine) | Mandatory lock + mandatory postflight validation |
| **L1 — Strict** | `canonical/roadmaps/*.md` | Mandatory lock + mandatory postflight validation |
| **L2 — Recommended** | `canonical/projects/<project>/*.md` | Lock recommended; postflight validation mandatory |
| **L2 — Recommended** | `canonical/people/*.md` | Lock recommended for substantive rewrites; trivial frontmatter edits skip |
| **L3 — Light** | `wiki/*.md` (LLM working space) | Locks not enforced; concurrent edits unlikely |
| **L3 — Light** | `working/handoffs/*.md` | Locks not enforced; handoff naming convention prevents collision (filename = canary = unique) |
| **L4 — Skip** | `episodic/*` (append-only history) | No lock needed |
| **L4 — Skip** | `raw/*` (immutable) | Per Karpathy schema: never write |

## 5. Failure modes + mitigations

| Failure | Mitigation |
|---|---|
| **Agent crashes mid-edit, lock never released** | TTL expiry (§2.3); next agent acquires-stale and logs |
| **Agent acquires-stale but original agent comes back** | Original agent reads lock and sees its own session_id no longer there; logs an interrupted-edit incident; resumes by re-acquiring fresh |
| **Two agents acquire simultaneously due to filesystem race** | Use atomic `ln -s` or `mkdir` for lock acquisition (both fail on existing file/dir); never `touch` or `cat >` |
| **Validator fails post-write but agent already released lock** | `validate-note.sh` runs BEFORE release per §2.4; release is the success signal |
| **Lock paths conflict with `.gitignore`** | `.leases/` is in vault root; pre-existing or to-be-added to whitelist `.gitignore`; per public mirror, `.leases/` is NOT mirrored (operational ephemera) |

## 6. Promotion threshold (proposed → active)

This protocol is currently `status: proposed-pending-adrian` because:

- Dual-agent (Claude + AG) edit collisions have not been observed in the corpus to date.
- The cost of mandatory locks is non-zero (every write becomes 3 ops: check + lock + write + validate + release).
- Under-load risk is low (vault edit volume is modest compared to a software repo).

**Promote to `status: active` when ANY of:**

1. **First observed silent-corruption incident** in `canonical/` — frontmatter mismatch, supersedes-chain inconsistency, author attribution conflict that was clearly multi-author race-condition.
2. **A third concurrent writer joins** the stack (Codex, Jules, future GPT direct-write) — adding a third agent passes the threshold where collisions become statistically likely.
3. **90-day burn-in of the protocol as advisory** — if no incidents but operators consistently follow it voluntarily, formalise.
4. **Adrian decides** the discipline is worth the cost regardless of incident frequency (CEO call).

Until promoted: **advisory only**. Agents that adopt it preemptively gain insurance; agents that skip it bet on the absence of contention. Both currently acceptable.

## 7. Implementation checklist (for the day Adrian promotes this)

- [ ] Add `.leases/` to `~/Documents/Adrian-Vault/.gitignore` if not present (operational ephemera, not mirror content).
- [ ] Mirror `.leases/` directory structure on first lock acquisition (auto-create paths).
- [ ] Update `.claude/scripts/stability/check-leases.sh` to surface FRESH locks held by other agents (not just stale ones).
- [ ] Update Claude Code session-start (per `session-start-protocol.md`) to scan for own stale locks and clear them.
- [ ] Update Antigravity commissions to include "acquire lease before writing" in trust_class for canonical_write commissions.
- [ ] Update `shutdown-protocol.md` to require lock-release scan.
- [ ] Add a one-line `canlock` shell alias for Adrian's manual edits.
- [ ] Write a 3-min Slack/Drive note for Adrian explaining the protocol if he ever wants to take a manual lock.

## 8. What this protocol does NOT solve

- **Logical conflicts that pass validation** — e.g. two agents both write valid frontmatter but disagree on a fact. This is a doctrine-disagreement issue, not a concurrency issue. Resolved by the bridge-protocols cross-model round-trip (Claude ↔ ChatGPT ratification) or by Adrian's CEO judgement.
- **Adrian writing without a lock** — see §3.3; founder-overrides are accepted; validators clean up.
- **External-API-side state** — ChatGPT/Grok don't touch local filesystem directly; their responses come via the bridge tools (`tools/ask-chatgpt.py`) which acquire local locks the same way.
- **Renderer-runaway-class issues** — orthogonal; partition-v2 + sleep-time-protocol address those.

End of edit-lease protocol v0.1. Promote to v1.0 active when threshold §6 met.
