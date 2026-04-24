---
title: Agent Team Strategy — Capability Map and Work Division
type: canon
status: superseded
superseded_by: canonical/concepts/hive-mind-resource-map.md
superseded_on: 2026-04-24
created: 2026-04-18
last_updated: 2026-04-18
authored_by: claude (claude.ai session, confirmed against real web research and tool probes)
tags: [strategy, agents, claude, cowork, antigravity, gemini, governance, workflow]
supersedes: working/handoffs/2026-04-18-resource-strategy-draft (if it exists)
---

## Why this document exists
Adrian has multiple AI agents on different subscription tiers. Token costs differ dramatically. Capabilities differ dramatically. Without a deliberate division of labour, the team produces duplication, stale data, and agents working on divergent copies of the same files. With a deliberate division of labour, Adrian gets a real "senior reviewer + junior builders" workflow — specialists routed to the right problems, grunt work routed to whatever's cheapest and capable.

This canon is the current-best routing map. Review quarterly.

---

## The four agents on the team (April 2026)

### Agent 1 — Claude on claude.ai (this session)
**Subscription:** Max 20x, $200/month. ~900 messages per 5-hour window, ~220k tokens per window. Weekly cap on top.
**Model:** Opus 4.7 (top tier). Opus tokens burn ~5× faster than Haiku tokens against the usage pool. Sonnet ~3× faster.
**Filesystem access:** Yes — `~/Documents`, `~/Desktop`, `~/iCloud Drive`. Read and write arbitrary files. Confirmed via tool probe 2026-04-18.
**Code execution:** Via Control-your-Mac osascript. Can run shell commands on Adrian's Mac within macOS permissions.
**Network:** web_search, web_fetch, Gmail, Google Calendar, Google Drive, Wix, PubMed, Kiwi, Apify — all as MCP connectors.
**Persistence:** Vault filesystem survives. Memory summary survives (`userMemories`). Raw chat transcripts don't unless explicitly searched via `conversation_search`.
**Autonomy loop:** NONE. One response per user message. No scheduler, no overnight work. Platform-level constraint.

**Strengths:**
- Synthesis across context: can hold the whole ecosystem in one response
- Writing with voice fidelity (Adrian's tone, dyslexia-aware structure)
- Canonical-writing authority — vault single-source-of-truth flows through Claude
- Catching contradictions between documents
- Long-form documents under time pressure

**Weaknesses:**
- Expensive per token — wasted on grunt work
- No autonomy — cannot run while Adrian sleeps
- No IDE surface — clunky for iterative code review with build/test loops

### Agent 2 — Cowork (claude.ai Desktop agentic mode)
**Subscription:** Same Max 20x pool as claude.ai — shared usage bucket.
**Model:** Opus 4.6 by default, Sonnet 4.6 available. Opus drains fastest.
**Filesystem access:** Sandbox by default at `~/Library/Application Support/Claude/local-agent-mode-sessions/...`. User-attached folders via native macOS folder picker also accessible. Must be attached through UI, not text path.
**Code execution:** Full sandboxed VM. Runs scripts, installs packages, executes tests.
**Network:** Connectors (Wix, Gmail, Google Drive, etc.). Claude-in-Chrome integration.
**Persistence:** Session-scoped sandbox survives between Cowork sessions but isn't in the vault. Files written to attached folders persist in those folders (i.e., if saved to `Adrian-Vault`, they persist there).
**Autonomy loop:** Scheduled recurring tasks supported. Multi-step execution within a single session is agentic. Not truly "unattended for days" — session-bound.

**Strengths:**
- Agentic file operations at scale within a codebase
- Iterative code work with real build/test loops
- Integrated browser via Claude-in-Chrome
- Non-technical user-friendly surface

**Weaknesses:**
- Shares the same token pool as claude.ai Opus — expensive
- Sandbox-by-default creates data-fragmentation risk
- Cannot see outside attached folders

### Agent 3 — Antigravity (Google)
**Subscription:** Free public preview as of April 2026. "Generous rate limits" on Gemini 3 Pro. Claude Sonnet 4.6 and Claude Opus 4.6 also available inside Antigravity as model choices. Future paid tier expected but not yet priced.
**Model:** Gemini 3 Pro is the default and the cheapest-for-Adrian option (free). Also Claude Sonnet 4.6, Claude Opus 4.6, GPT-OSS-120B selectable.
**Filesystem access:** Full IDE-level access to the open workspace folder. Reads and writes freely inside the workspace.
**Code execution:** Full terminal access, browser access, multi-step execution across editor + terminal + browser. Most capable code-execution surface of the four.
**Network:** Full, via terminal (curl, wget, etc.) and integrated browser.
**Persistence:** Workspace is a filesystem folder — fully persistent. Agent knowledge base persists across tasks and learns from prior work.
**Autonomy loop:** YES. Multiple parallel agents working asynchronously in Manager View. True long-running scoped autonomous work. **This is Adrian's real "overnight work" agent.**

**Strengths:**
- Free Gemini 3 Pro tokens — cheapest grunt-work option available
- True autonomy: commission a task, sleep, wake to completion
- Parallel agents for independent tasks
- Workspace folder = persistent shared filesystem (can BE the vault)
- Multi-step execution across full dev stack

**Weaknesses:**
- Newer product — more stability issues than Claude surfaces
- Gemini 3 Pro is excellent but stylistically different from Claude (may produce voice mismatch on user-facing copy)
- Agent autonomy means supervision matters more, not less — bad scoping compounds faster
- Early-preview privacy concerns (codebase processed through Google)

### Agent 4 — ChatGPT (separate, not Anthropic)
**Subscription:** Adrian has Plus or Pro (to be confirmed).
**Role:** Independent review only. Different training data, different blind spots, catches things Claude misses.
**Filesystem access:** None directly. Communicates via Google Drive bridge (proven working 2026-04-18).
**Use case:** Second-opinion reviews, critique of Claude recommendations, documentation collaboration.

---

## The token economy (why this matters)

| Agent | Cost to Adrian per heavy session | Best used for |
|---|---|---|
| Antigravity (Gemini 3 Pro) | Free | Grunt work — code implementation, repeated file ops, long autonomous runs |
| Antigravity (Claude Opus inside) | Burns Antigravity's Claude allocation (free preview) | Code review when Gemini's style isn't a fit |
| Cowork (Opus 4.6) | Shared Max pool — burns Adrian's Claude usage fast | Interactive iterative code fixes, sandbox experimentation |
| Cowork (Sonnet 4.6) | Shared Max pool — 3× cheaper burn than Opus | Most Cowork work should default here |
| claude.ai Opus 4.7 | Shared Max pool — expensive | Strategy, synthesis, canonical writing, review |
| ChatGPT | Separate subscription | Independent review checkpoint |

**The economic insight:** Adrian's cheapest professional-grade token is Antigravity/Gemini 3 Pro (free). The most expensive is Claude Opus (anywhere — claude.ai, Cowork, or inside Antigravity). The ratio is effectively infinity-to-one right now while Antigravity is in free preview.

**Therefore:** route grunt work (build, implement, refactor, test) to Antigravity. Route specialist work (strategy, canonical writing, review of user-facing copy) to Claude. Keep Cowork for situations where the native macOS file-picker integration is the only way to solve a specific problem (it rarely is now that the vault is set up).

---

## The team operating pattern

### Pattern 1 — The "build-then-review" workflow (the pattern Adrian described)
1. **Claude (claude.ai) scopes the work.** Writes a commission brief to `working/handoffs/`. Defines deliverables, constraints, stop conditions.
2. **Antigravity executes the build.** Opens the vault as its workspace. Reads the brief. Implements code, runs tests, produces artifacts (diffs, screenshots, logs). Writes completion summary back to `working/handoffs/`.
3. **Claude reviews.** Reads the completion summary and the actual code from the vault. Catches gaps, contradictions, voice issues. Writes review to `working/handoffs/`.
4. **Antigravity iterates.** Reads the review. Applies the feedback. Writes updated completion summary.
5. **Claude verifies.** If clean, promotes to canonical or marks as ready to ship. If not, another iteration.

Adrian's role: scope the initial problem, approve or veto at each checkpoint, handle irreversible actions (sending, publishing, contracts).

### Pattern 2 — The "parallel exploration" workflow
For genuinely exploratory problems (e.g., "what should the Testing Engine architecture be?"):
1. Claude produces synthesis-level recommendation based on canonical context.
2. Antigravity produces engineering-first recommendation based on technical feasibility.
3. ChatGPT produces independent-critique recommendation.
4. Claude synthesises the three into a single decision document. Adrian approves.

Parallelism uses three different agents' strengths without any one agent needing to be right alone.

### Pattern 3 — The "overnight commission" workflow
1. Before Adrian sleeps, Claude (this session) writes a detailed commission file for Antigravity.
2. Adrian opens Antigravity, points it at the commission file, grants autonomy-level "Agent-driven" or "Review-driven" (see Antigravity settings).
3. Antigravity runs overnight on Gemini 3 Pro's free tokens.
4. Adrian wakes, Claude reads the Antigravity output from the vault, synthesises what was accomplished and what needs attention.

**This is the pattern Adrian wanted last night and couldn't get from claude.ai directly.** It is real, it works, and it runs on free tokens rather than paid ones.

### Pattern 4 — The "direct edit" workflow (vault as filesystem)
For simple edits Adrian wants right now:
1. Claude edits the file directly in the vault.
2. Next agent to open the vault sees the change.

No commission, no handoff — appropriate for small fast changes where the intent is clear.

---

## The canonical rule: the vault IS the shared memory

**Every agent must treat `/Users/adriantaffinder/Documents/Adrian-Vault/` as the source of truth.** Sandboxes are scratch. Chat transcripts are local. Whatever persists, persists in the vault.

This means:
- **Cowork** must be told at session start: "save project work to `~/Documents/Adrian-Vault/projects/compatibility-test/`, sandbox is scratch only."
- **Antigravity** must be opened with the vault as its workspace folder, not a fresh folder.
- **Claude** (me, here) already writes directly to the vault — this is the pattern.
- **ChatGPT** bridges via Google Drive (already proven working).

Agents who don't follow this rule produce divergent data. The June 2026 audit (hypothetical future review) should be able to read any fact from the vault and know it's current.

---

## Current work routing for the compatibility test

| Work item | Agent | Why |
|---|---|---|
| Quick fixes 1, 2, 3 (pretest copy, timing, auto-save) | Cowork (in progress) | Cowork has the context; sandbox work already underway |
| Sensie vs Sensei web research | Any (cheapest = Antigravity) | Simple web task; no context needed |
| 32-framework restructure (content rewrite for 8 new + 4 modified frameworks) | Claude (claude.ai) | Voice fidelity matters more than anything else here |
| Frameworks.js refactor to JSON pack | Antigravity | Mechanical refactor, no voice concerns, free tokens |
| Post-capture email funnel (Wix Automations) | Adrian-led, Claude drafts copy | Operational setup + voice-heavy copy |
| Testing Engine architecture doc | Antigravity (scope already drafted) | Engineering synthesis, long-horizon autonomous work |
| Final Wix HTML regeneration after fixes | Cowork or Antigravity | Mechanical; either works |
| Review of all of the above | Claude (claude.ai) | Specialist review role |

---

## The capability probe (paste into any new agent)

Use this to stress-test any new agent Adrian adds to the team. Same 5 questions ensure comparable answers.

```
I'm building a multi-agent workflow. Please answer these five questions precisely
— yes/no/partial, not prose:

1. FILESYSTEM: Can you read and write arbitrary local files on my Mac?
   If yes, what's the path constraint?

2. CODE EXECUTION: Can you run shell commands / execute scripts?
   If yes, what runtimes are available by default?

3. PERSISTENCE: Does anything you do in this session survive into the next?
   If yes, where?

4. NETWORK: Can you make web requests?
   Any restrictions?

5. AUTONOMOUS LOOP: Can you run continuously without me messaging you?
   For how long, and what stops it?

Then one extra: what are you best at that my other agents aren't?
```

---

## Governance rules

1. **Only Claude (claude.ai) writes to `canonical/`.** Every other agent writes to `working/`, `episodic/`, or `raw/`. Canonical is the vetted single source of truth.
2. **Every agent commits to file before ending a session.** No work lives only in chat transcripts.
3. **Commission files are explicit.** When handing work to Antigravity or Cowork, the commission file must contain: scope, deliverables, stop conditions, hard constraints, reference materials.
4. **Receipt canaries on async handoffs.** When one agent instructs another asynchronously via the vault, include a unique phrase the receiving agent must quote verbatim to prove the instruction was actually read. (Proven working with ChatGPT via Drive bridge 2026-04-18.)
5. **The 72-hour rule for long-running Antigravity work.** Claude Code loops cap at 72 hours; Antigravity agents can technically run longer but should checkpoint at 72-hour boundaries for review.
6. **Model selection defaults.** Antigravity = Gemini 3 Pro (free). Cowork = Sonnet 4.6 unless Opus specifically required. claude.ai = Opus 4.7 (Adrian's direct session is where the specialist work happens).

---

## Open questions for Adrian

1. **ChatGPT plan?** (Plus vs Pro vs Team.) Affects how often to route independent-review work there.
2. **Antigravity autonomy-level preference?** (Secure / Review-driven / Agent-driven / Custom.) Recommend "Review-driven development" as the default — balances autonomy with checkpoints.
3. **Cowork sandbox — keep or abandon?** Once Adrian-Vault is properly attached to Cowork, the sandbox serves no purpose. Recommend: abandon.
4. **What's the first real Antigravity commission?** Recommend: the Testing Engine architecture doc (scope already written).

---

## Related
- `procedural/workflows/agent-task-routing.md` — tactical routing rules
- `procedural/workflows/overnight-autonomous-work.md` — commission pattern for async work
- `canonical/ecosystem/shared-infrastructure.md` § Vault-as-shared-brain
- `working/handoffs/2026-04-18-antigravity-testing-engine-scope.md` — first real Antigravity commission

---

## Change Log

- **2026-04-24**: Core capability mapping and economics subsumed by `canonical/concepts/hive-mind-resource-map.md`. This document is now marked superseded, though its operational patterns, capability probe, and 72-hour rule remain valid historical context pending extraction to a dedicated workflow document.
