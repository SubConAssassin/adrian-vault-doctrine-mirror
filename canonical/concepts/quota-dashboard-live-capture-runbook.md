# Quota dashboard: what's live, what's stale, and how each pool actually refreshes

**Built 2026-09-19/20.** This is the operating reference for the "Subscription token pools" section
of the fleet dashboard (`tools/fleet-dashboard.py`, served at `http://localhost:7778/` — start with
`python3 tools/fleet-dashboard.py &`). Read this before assuming a number on that dashboard is
current.

## The mechanism, end to end

1. **Observations** land as JSON files in `~/.local/state/adrian-token-accountant/observations/`,
   one per account. Each carries `provider`, `account_key`, `observed_at`, and `rate_limits`.
2. **`tools/quota-accountant.py`** (LaunchAgent `com.adrianvault.quota-accountant`, hourly,
   zero-inference) reads those files plus the Codex CLI's own rate-limit endpoint, normalizes them,
   and writes `working/state/subscription-capacity.json` — the single snapshot every other tool reads.
3. **`tools/resource-router.py`** and **`tools/fleet-dashboard.py`** both read that snapshot and
   apply a **60-minute freshness TTL** (`DEFAULT_TTL_MIN` in `quota-accountant.py`). An observation
   older than that shows as `UNKNOWN (last observed N%)`, not as live capacity. This is correct
   behaviour, not a bug — token usage moves constantly, and a stale number presented as live is worse
   than an honest UNKNOWN.

## Per-vendor: how a fresh observation actually gets written

| Pool | Refresh mechanism | Durable / one-shot |
|---|---|---|
| Claude (any account) | **Native, automatic.** `tools/claude-quota-observer.py` is wired as that machine's Claude Code `statusLine` command (`~/.claude/settings.json`). It fires on every native statusline event **while a Claude Code session is actively running under that account**, and writes straight to the observations directory. No browser needed. | Durable, but only while a session is live on that account/node. OSB's own observer is wired on Studio but has never fired because no session was running there when checked. |
| Codex (OpenAI) | Direct read of the Codex CLI's own rate-limit endpoint inside `quota-accountant.py`. Always live as long as the `codex` binary and its login are present. | Fully durable, no manual step. |
| SuperGrok / Grok (`grok.com`) | **No API, no CLI endpoint.** Only source is the account's own Settings → Usage panel in a real logged-in browser (`claude-in-chrome`, never the sandboxed `Claude_Browser` pane — that has no cookies and will only show a sign-in wall). | One-shot manual screen-read. Decays to UNKNOWN after 60 minutes. |
| ChatGPT (OpenAI subscription, distinct from the Codex CLI meter) | Same story: no API. Settings → Usage inside `chatgpt.com`, logged in as the real account. | One-shot manual screen-read. Decays after 60 minutes. |
| Gemini / Qwen | No capture mechanism built at all yet. | N/A — always UNKNOWN today. |

## How to do a manual capture (Grok / ChatGPT) when asked to refresh the dashboard

1. Load `claude-in-chrome` tools if deferred (`ToolSearch` for `tabs_context_mcp`, `navigate`,
   `computer`, `get_page_text`, `tabs_create_mcp`).
2. `list_connected_browsers` to confirm the real Chrome is attached.
3. Navigate to the account's own usage settings screen (`grok.com` → profile menu → Settings →
   Usage; `chatgpt.com` → `#settings/Usage` via the profile menu, not a bare URL — direct hash
   navigation alone can 404). Screenshot rather than `get_page_text` for these — both apps render
   usage numbers inside a modal that `get_page_text`'s `<main>`-scoped extraction misses.
4. Write a JSON file into the observations directory. **The window key must be `primary`** for any
   non-Anthropic provider — `quota-accountant.py`'s generic path only looks for `primary`/`secondary`
   window keys (Anthropic is the only provider that gets `five_hour`/`seven_day`). A file using any
   other window key (`weekly`, `session`, etc.) is silently skipped — this cost a real debugging pass
   on 2026-09-19, caught by inspecting `normalize_snapshot()` in `quota-accountant.py` directly.
   Minimal shape:
   ```json
   {
     "provider": "xai",
     "account_key": "xai-<short-label>",
     "account_name": "SuperGrok (@handle)",
     "observed_at": "<ISO8601 UTC>",
     "rate_limits": {"primary": {"used_percentage": 0}}
   }
   ```
5. Run `python3 tools/quota-accountant.py` to rebuild the snapshot, then `python3
   tools/resource-router.py --refresh` and reload the dashboard.
6. If you want the dashboard to show a friendly name instead of `<provider> · default`, add the
   `account_key` to the `safe_names` dict in `token_rows()` in `tools/fleet-dashboard.py`, then
   restart the dashboard process (`pkill -f tools/fleet-dashboard.py`, relaunch).

## What this runbook deliberately does NOT do

It does not stand up an unattended headless-browser job that stores Grok/ChatGPT session cookies
and re-captures on a timer. That is a real, separate security-shape decision (persisting live
account session state for automated reads) and needs an explicit go from Adrian, not a default
assumed under a general "keep the dashboard current" instruction. Until that's decided, these two
pools are refreshed by an explicit request routed through the manual procedure above.

## Quota-aware routing policy (Adrian-direct, 2026-09-20)

The dashboard is not merely a capacity display. It is the evidence source for an explicit routing
decision. The goal is to use subscriptions before their own reset deadlines without exhausting a
model that may be needed for a model-specific, time-sensitive task.

### Decision order

For every substantial dispatch, choose a lane in this order:

1. **Model fit first.** A task must meet the lane's capability and authority requirements; a
   near-reset pool is never a reason to use an unfit model.
2. **Fresh vendor evidence second.** Use an authenticated observation from the current routing
   cycle. `UNKNOWN` is unavailable for autonomous allocation; never infer that a reset occurred
   because a calendar time passed.
3. **Cycle pressure third.** Prefer an equally-fit pool that resets sooner or would otherwise be
   stranded. Claude is evaluated separately on its 5-hour and weekly windows; the constraining
   window wins.
4. **Reserve gate fourth.** Hold a minimum 5% of each individual pool for contingency. Do not
   cross it outside the pool's final two wall-clock hours before its own reset, unless Adrian
   explicitly authorises it.
5. **Intentional final drain.** In the final two hours, a pool may be drained below 5% only when
   there is no queued or predictable task requiring that specific model before reset. Record the
   reason and the expected reset time in the routing plan.

The 5% rule is per account and per reset window, never a fleet-wide average. It protects against
the misleading case where aggregate capacity looks healthy while the one required model is spent.

### Account roles

- **Main ChatGPT account:** orchestration, decisions, acceptance, and concise user-facing work.
  It is budgeted to last the entire weekly cycle and must not quietly absorb bulk generation.
- **Claude 20x accounts:** use the more expiring viable Claude pool for implementation/review work,
  while preserving the 5% reserve. Treat each Claude account's 5-hour and weekly windows as
  distinct constraints. A weekly reset on one account can make it the preferred near-term work
  lane even if another has more raw remaining capacity.
- **Grok, Gemini, and other subscription CLIs:** use for tasks they fit when their authenticated
  quota is fresh and they reduce avoidable consumption of the primary orchestration account.
- **DeepSeek prepaid API pool:** route only behind its metered-spend gate and ledger-backed balance;
  it is not a subscription quota and must never be used as an unbounded fallback.

### Scheduling and visibility

One routing authority writes a compact, human-readable plan before dispatching material work:
`task → selected lane → fit rationale → remaining/reset evidence → reserve state → fallback`.
The plan must name any account fallback; no account or host fallback is silent. Simultaneous
dispatches read the same fresh snapshot and are serialised through that authority so two machines
cannot allocate against the same apparent headroom.

Flag, rather than execute, any auto-purchase, usage-credit activation, usage reset, account upgrade,
or cross-account login. Adrian alone authorises those actions. A routing pass fails closed when the
account identity or its live quota cannot be verified.

### Acceptance checks

1. A pool below 5% and outside its final two-hour window refuses non-contingency work.
2. A stale or missing observation is `UNKNOWN`, not a plausible capacity estimate.
3. A fallback between accounts is visible in the routing plan.
4. The main ChatGPT weekly burn is compared with time remaining in its week and flags early if its
   projected path would exhaust before reset.
5. A completed week's log can reconstruct why each substantial task went to its selected lane from
   stored vendor observations and recorded fit/routing rationale.
