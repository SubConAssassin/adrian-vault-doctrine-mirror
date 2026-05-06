---
title: n8n Quick Reference (extracted from data.popcorn cheat sheet v2025.04)
type: reference
status: canonical
created: 2026-05-02
source: data.popcorn cheat sheet v2025.04 (CC BY 4.0) — https://linktr.ee/datapopcorn — YouTube @data.popcorn
license: CC BY 4.0 — attribution required if redistributed
related:
  - companies/ashta/architecture-decisions.md
  - companies/bodhisvara/architecture-decisions.md
  - canonical/concepts/agent-budget-framework.md
---

# n8n Quick Reference

Extracted as text (not stored as image per Adrian's directive 2026-05-02). Preserves the load-bearing content from the data.popcorn cheat sheet for grep + AG access.

---

## Triggers (every workflow needs one)

| Trigger | Use case |
|---|---|
| **Manual** | User clicks "Test Workflow" — for development |
| **Schedule** | Cron — runs at intervals (good for OSB inventory sync, daily reconciliation) |
| **Form** | n8n-hosted form submits → workflow runs (lead capture, contact forms) |
| **Chat** | Chat input → workflow (AI agent triggers) |
| **Webhook** | External system POSTs HTTP → workflow runs (Stripe webhooks, Wix webhooks, etc.) |
| **Workflow** | Called from another workflow (composition / sub-routines) |

Trigger pattern in canvas: **Trigger Node (Start) → Node (Input → Function → Output)** — each step shows item count and data type on the connection.

---

## Expressions

| Type | Expression | Notes |
|---|---|---|
| Basic | `{{ $json["key"] }}` | Most common — get a field from current item |
| Node nomination | `{{ $node["nodeName"].json["value"] }}` | Pull from a specific upstream node by name |
| Date formatting | `{{ $now.format('yyyy-MM-dd') }}` | Built-in date helpers |
| Condition | `{{ $json["price"] > 100 }}` | Boolean — used in IF nodes |
| Ternary | `{{ $json["price"] > 100 ? "expensive" : "cheap" }}` | Inline if/else |
| Built-in methods | `$jmespath()`, `$fromAI()`, `$max()`, `$min()` | Full reference: `https://docs.n8n.io/code/builtin/data-transformation-functions/` |
| Metadata | `$execution`, `$itemIndex`, `$input`, `$parameter`, `$prevNode`, `$runIndex`, `$today`, `$vars`, `$workflow`, `$nodeVersion`, `$now` | System-level access |

Toggle expression mode on a field with `=` (the "Inside Node" keyboard shortcut).

Field types n8n recognises: String / Number / Boolean / Array / Object.

---

## Built-in Nodes

### Trigger nodes (already covered above)

### Core nodes

| Node | What it does |
|---|---|
| **Edit Fields (Set)** | Set or modify field values on items |
| **Remove Duplicates** | De-duplicates items (by field or hash) |
| **IF** | Branches flow based on a condition |
| **Aggregate** | Groups items, returns summary |
| **Split out** | Splits an array into individual items |
| **Filter** | Filters items by condition (passes some, drops others) |
| **Summarize** | Counts, averages, summary stats |
| **Code** | Run JavaScript / Python on item stream |
| **Merge** | Combines two streams into one |
| **Sort** | Sorts items by criteria |
| **Limit** | Caps item count |
| **Loop** | Repeats nodes |
| **Wait** | Pauses for time period (rate-limit handling) |
| **Convert to File** | Stream → file artefact |
| **Extract from File** | File → structured items |
| **Compression** | Compress / decompress |
| **Stop and Error** | Halts workflow with custom error |
| **HTTP Request** | Calls any REST/GraphQL/external API |

---

## AI Agent Node (the persona slot)

The AI Agent node has four required inputs and a system message. This pattern maps onto Adrian's persona-first architecture:

| n8n slot | Maps to Adrian's architecture |
|---|---|
| **Model** (1:1, required) — OpenAI / Anthropic / Gemini chat model | Pick per persona / per task — likely Claude Sonnet for synthesis, Gemini for cheap-and-fast |
| **Memory** (1:N) — Window Buffer Memory etc. | Per-conversation state (running mastermind cohort, ongoing client thread) |
| **Tool** (1:N) — SerpAPI / Notion / MCP Client / etc. | Capabilities each persona can call (vault search, calendar, email send, etc.) |
| **System Message** | Persona card content — Persona / Task / Context / Format |

System Message structure recommended by the cheat sheet:
- **Persona** — Role (who is the agent)
- **Task** — Todo (what is it for)
- **Context** — Objective (background / constraints)
- **Format** — Output (structured response format)

This is exactly the persona-card-as-runtime-prompt pattern. Each card in `canonical/adrian-corpus/personas/` becomes an AI Agent node template.

---

## HTTP Request — the API node

Killer feature: **Import cURL command — One Click Auto fill.** Paste any curl from API docs, n8n parses it into URL, headers, body, auth.

Example:
```bash
curl -X POST https://api.example.com/data \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -d '{"name": "Alice", "email": "alice@example.com"}'
```

Imports as a fully-configured HTTP Request node with one click. Massively faster than reading API docs and filling each field manually.

---

## Node Common Settings (failure modes)

These are the levers that distinguish a fragile workflow from a robust one.

| Setting | What it does | Trap |
|---|---|---|
| **Always Output Data** | Returns empty item even when no data | **DANGER:** can cause infinite loops with IF nodes — only enable when downstream specifically expects an item every run |
| **Execute Once** | Processes only the first item, ignores rest | Useful when downstream expects a single config call, not per-item |
| **Retry On Fail** | Retries until success | Combine with Wait node + exponential backoff |
| **On Error: Stop Workflow** | Halts the whole workflow on any node error | Default; brittle for production |
| **On Error: Continue** | Skips to next node even if this one errored, using last valid data | Better for production, but masks errors silently |
| **On Error: Continue (using error output)** | Routes the error info to a separate output branch | **Best for production** — handle errors explicitly downstream |
| **Notes** (memo) | Inline note on the node | Use liberally — workflows go stale fast |
| **Display note in flow** | Shows note as subtitle inside the workflow canvas | Good for handoff documentation |
| **Node Version Check** | n8n flags when node uses an older version | Always update — community templates often ship with old versions |

---

## Docker Self-Hosting (env vars reference)

If we self-host (Hetzner / Railway / local Docker) instead of using n8n Cloud Starter, these are the env vars that matter. Reference for AG when authoring deployment configs.

```bash
# Install
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit

# Update / stop / remove
sudo docker pull docker.n8n.io/n8nio/n8n
sudo docker stop n8n
sudo docker rm n8n

# Run
sudo docker run -it \
  --restart unless-stopped \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e WEBHOOK_URL="https://n8n.example.com/" \
  -e N8N_SMTP_HOST="smtp.gmail.com" \
  -e N8N_SMTP_PORT=465 \
  -e N8N_SMTP_USER="YOUR_EMAIL" \
  -e N8N_SMTP_PASS="<app password>" \
  -e N8N_SMTP_SENDER="YOUR_EMAIL" \
  -e N8N_SMTP_SECURE="true" \
  -e N8N_SMTP_SSL="true" \
  -e GENERIC_TIMEZONE="Asia/Makassar" \
  -e N8N_DIAGNOSTICS_ENABLED=false \
  -e N8N_VERSION_NOTIFICATIONS_ENABLED=false \
  -e VUE_APP_URL_BASE_API=https://n8n.example.com/ \
  -e N8N_ENCRYPTION_KEY=<random string, store in 1Password> \
  -e N8N_TEMPLATES_ENABLED=false \
  -e N8N_USER_FOLDER=/home/jim/n8n \
  -e EXECUTIONS_TIMEOUT=3600 \
  -e EXECUTIONS_TIMEOUT_MAX=7200 \
  -e N8N_METRICS=true \
  -e N8N_CUSTOM_EXTENSIONS="/home/jim/n8n/custom-nodes;/data/n8n/nodes" \
  -e NODE_FUNCTION_ALLOW_BUILTIN=* \
  -d docker.n8n.io/n8nio/n8n:latest
```

**Adrian-specific notes:**
- `GENERIC_TIMEZONE` should be `Asia/Makassar` for Bali (UTC+8), not `Asia/Seoul` from the cheat sheet
- `N8N_ENCRYPTION_KEY` — generate once, store in 1Password, never lose (encrypts saved credentials)
- `N8N_DIAGNOSTICS_ENABLED=false` — Adrian-aligned (no telemetry)
- `EXECUTIONS_TIMEOUT_MAX=7200` (2 hours) — fits longer transcription jobs

---

## Keyboard shortcuts (Adrian-only when in canvas)

### Workflow control
| Action | Shortcut |
|---|---|
| New workflow | Ctrl + Alt + N |
| Open workflow | Ctrl + O |
| Save | Ctrl + S |
| Undo / Redo | Ctrl + Z / Ctrl + Shift + Z |
| Run workflow | Ctrl + Enter |

### Canvas
| Action | Shortcut |
|---|---|
| Move node view | Ctrl + Left Mouse + Drag, or Space + Drag, or Middle Mouse + Drag, or Two Fingers on Touchscreen |
| Zoom in / out | `=`/`+` or `-`/`_`, or Ctrl + Mouse Wheel |
| Reset zoom | `0` |
| Fit workflow to view | `1` |
| Select all | Ctrl + A |
| Paste | Ctrl + V |
| Add note | Shift + S |

### Node selection
| Action | Shortcut |
|---|---|
| Select node below / left / right / above | ↓ / ← / → / ↑ |
| Copy / cut | Ctrl + C / Ctrl + X |
| Disable | D |
| Delete | Delete |
| Open | Enter |
| Rename | F2 |
| Pin Data | P |
| Select all left-side / right-side nodes | Shift + ← / Shift + → |

### Node panel
| Action | Shortcut |
|---|---|
| Open / insert node / close panel | Tab / Enter / Escape |
| Insert / expand node | Enter |
| Expand / collapse category | → / ← |

### Inside node
| Action | Shortcut |
|---|---|
| Toggle expression mode | `=` |

---

## Community resources

| Resource | URL |
|---|---|
| Official docs | https://docs.n8n.io |
| Community forum | https://community.n8n.io |
| Discord | https://discord.gg/n8n |
| GitHub | https://github.com/n8n-io/n8n |
| Workflow library | https://n8n.io/workflows/ |

---

## How this reference is used in our stack

1. **AG authoring workflow JSON** — grep this file for syntax (expressions, env vars, node settings)
2. **Persona deployment** — AI Agent node section is the runtime template for each persona card
3. **Self-host decision** — Docker section is the reference if Adrian chooses Hetzner/local over managed
4. **Robustness** — the Node Common Settings section is the rubric for production readiness (retry, error output, version check)
5. **Pattern compliance** — when picking community templates from `n8n.io/workflows/`, check that they use Pattern 1/2/3 not Pattern 4 (per Ashta + Bodhisvara binding rule)

Original cheat sheet image lives on Adrian's desktop temporarily — not stored in vault per directive 2026-05-02. This text extraction is the canonical record.
