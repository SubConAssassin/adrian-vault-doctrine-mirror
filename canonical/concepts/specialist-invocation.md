---
title: Specialist Invocation Protocol
type: doctrine
status: canonical
created: 2026-04-21
applies_to: [claude, antigravity, all-agents]
related:
  - canonical/concepts/agent-team-strategy.md
  - canonical/concepts/trust-classes.md
  - procedural/prompts/specialists/
---

## Why specialists exist

A generalist Claude responding to "draft the customs rebuttal" produces uneven output. Sometimes it nails the legal voice, sometimes it over-explains, sometimes it forgets a citation, sometimes it imports a marketing tone where it shouldn't. The variance comes from the same model trying to fit every domain into one default style.

Specialists fix this by pre-loading domain context, voice rules, citation patterns, and forbidden phrases as a system-prompt overlay. Same model, narrower mode. Tighter outputs, less drift, fewer corrections.

This is the lift from the friend's Antigravity stack (17+ specialist agents). Adapted to Adrian's scale: 5 specialists for the highest-leverage domains.

---

## The five specialists (v1)

| Specialist | File | Domain | Primary use |
|---|---|---|---|
| OSB Legal | `procedural/prompts/specialists/osb-legal-specialist.md` | Erica Johnson dispute, postal disputes, conversion claims | Drafting demand letters, citation verification, legal correspondence |
| Wix Catalog | `procedural/prompts/specialists/wix-catalog-specialist.md` | Wix product creation, variant management, MCP workarounds | Building products, fixing variants, navigating Wix API asymmetry |
| Subconscious Surgery Brand | `procedural/prompts/specialists/ss-brand-specialist.md` | Enemy-first positioning, social calendar, ad copy | Drafting posts, ads, sales pages in brand voice |
| Ashta Architect | `procedural/prompts/specialists/ashta-architect-specialist.md` | Voice analytics, accelerometer testing, tier structure | Technical scoping, MVP decisions, white paper updates |
| Customs Disputes | `procedural/prompts/specialists/customs-disputes-specialist.md` | TARIC codes, PMK 4/2025, UPU Convention, bilingual filings | Drafting customs correspondence in EN + target language |

This list grows as new high-frequency domains emerge. Quarterly review.

---

## When to invoke a specialist

**Invoke when ALL of the following are true:**
- Task falls within one specialist's clearly defined domain
- Output will be either user-facing, legally consequential, or canonical
- Task is non-trivial (more than a single-sentence answer)

**Skip the specialist when:**
- Task crosses multiple domains (use generalist Claude with cross-references)
- Task is purely informational ("what's the status of...")
- Task is a quick edit Adrian could verify in 30 seconds
- Adrian explicitly says "don't bother with the specialist"

---

## Invocation methods

### Method A — Adrian invokes by shorthand
Adrian says: `specialist: <name>` or `as <name>` at the start of his message.

Examples:
- "specialist: osb-legal — draft the response to Erica's last email"
- "as wix-catalog, fix the Tranquility variant pricing"
- "ss-brand: write post 7 and 8 for the social calendar"

Claude responds: reads the specialist prompt, adopts the persona, executes the task. No preamble, no "switching to specialist mode" filler.

### Method B — Claude self-invokes
When Claude detects a task clearly falls within a specialist domain, Claude self-invokes by reading the relevant specialist prompt before drafting. Claude does NOT announce this. The output simply reflects the specialist mode.

When Claude self-invokes, the response begins with the work, not with "I'm now operating as the OSB legal specialist." That kind of meta-narration is friction.

### Method C — Handoff to specialist
A handoff to Antigravity (or back to Claude in a future session) can specify a specialist in the frontmatter:

```yaml
specialist: osb-legal
```

The receiving agent reads the named specialist prompt before executing.

---

## What a specialist prompt contains

Every specialist file follows the same structure:

```markdown
---
title: {Domain} Specialist
type: specialist-prompt
domain: {domain}
status: canonical
applies_to: [claude, antigravity]
---

## Activation
{One paragraph: when this specialist mode is invoked.}

## Domain context
{Compressed: the canonical files this specialist must hold in mind, the key facts, the named people, the current state.}

## Voice and style
{Specific: tone, formality, vocabulary, forbidden phrases, required structures.}

## Mandatory checks
{Pre-output checklist: things the specialist must verify before producing.}

## Trust class defaults
{Which actions in this domain are external_write or destructive; which approval gates apply.}

## Common pitfalls
{Failure modes specific to this domain that the specialist watches for.}

## Reference canonical
{Pinned vault paths the specialist re-reads on each invocation.}
```

---

## Combining with trust classes

Specialists operate within the trust class system, not around it. A specialist drafting a customs letter is doing `external_write` (drafting) → must request approval before `destructive` (sending). The specialist mode does not bypass approval gates; it improves the quality of what the gate is approving.

Specifically:
- **OSB Legal specialist** triggers `legal-send` gate before any send
- **Customs Disputes specialist** triggers `customs-submit` gate before any filing
- **Wix Catalog specialist** triggers `external_write` approval before any Wix mutation, and `public-publish` if the change goes to a live product visible to buyers
- **SS Brand specialist** triggers `public-publish` gate before any post
- **Ashta Architect specialist** mostly produces `local_write` (canonical updates, scoping docs) — lower gate burden

---

## Cross-specialist conflicts

When a task touches multiple specialist domains (e.g., "draft the SS social post explaining the new OSB pendant launch"), Claude does NOT chain specialists. Instead:
1. Identify the primary domain — usually the output channel (here: SS social post)
2. Invoke that specialist
3. Pull factual content from the secondary domain's canonical files
4. The primary specialist owns voice; the secondary domain provides facts

This prevents specialist whiplash mid-document.

---

## Versioning

Specialist prompts are versioned by the `last_updated` field in their frontmatter. When Adrian provides feedback that changes how a specialist should behave (new forbidden phrase, new mandatory check, new pitfall), Claude updates the relevant specialist file and bumps the date.

Specialist prompts are NOT throwaway. They accumulate Adrian's hard-won corrections. Treat them as compounding IP.

---

## Future specialists (parking lot)

Domains that may earn specialists if frequency justifies:
- Tri Hita WtE Investor Comms
- AGA Bali Land/Permit
- Crystal Sourcing & Allocation (Stephan coordination)
- Etsy Listings (currently rolled into Wix Catalog)
- US Trip Logistics (Seattle / Mexico / Sedona)
- Dyslexia-Aware Plain English (rewrite/simplify mode for any output)

These get created when Adrian invokes them three times in two weeks with consistent corrections — i.e. when it's clear the variance is real and worth pinning down.
