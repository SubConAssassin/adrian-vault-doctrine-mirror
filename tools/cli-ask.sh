#!/usr/bin/env bash
# cli-ask.sh — reliable $0 access to the CLI advisor team (codex / grok / agy=Gemini).
# HARDENED + acid-tested (run tools/cli-ask-selftest.sh). Survives the failure modes that made the
# team flaky — all now STRUCTURAL, not luck:
#   - codex/grok block on stdin             -> always </dev/null
#   - grok returns EMPTY on long -p args    -> deliver the prompt via --prompt-file
#   - agy prints a summary (full answer in its brain dir) -> agy-ask.py retrieves the artifact
#   - a CLI "succeeds" (exit 0) but returns 0-1 bytes -> DETECTED here: warn + retry + exit 3
#       (a caller can NEVER mistake an empty flake for a real answer)
#   - transient flake -> one bounded retry before giving up
#   - shell metacharacters in the prompt -> passed as DATA, never evaluated
#   - missing binary / bad model -> clean non-zero error, never a silent pass
#   - hang -> hard --timeout (default 360s) -> exit 124
#
# Usage:
#   cli-ask.sh <codex|claude|grok|agy> [--timeout N] [--retries R] [--min-bytes B] "prompt"
#   cli-ask.sh <codex|claude|grok|agy> [--timeout N] --stdin < prompt.txt
# Exit: 0 ok | 2 usage | 3 empty/thin after retries | 124 timeout | else = the CLI's own code.
# Binaries overridable via env: CLI_ASK_CODEX / CLI_ASK_GROK / AGY_BIN (the self-test injects mocks).
#
# 2026-07-10 model-upgrade lanes (additive; bare codex/grok/agy behaviour unchanged):
#   codex-sol | codex-terra | codex-luna | codex-spark  -> codex exec -m gpt-5.6-{sol|terra|luna}|gpt-5.3-codex-spark
#   composer                              -> grok-composer-2.5-fast when listed; otherwise a loud live-Grok fallback
#   grok-web                              -> grok-4.5 RESEARCH mode: live web search ON, citations required,
#                                            --max-turns 8 (still no plan/subagents/file-writes)
#   --model M   pin any model id on the underlying CLI (codex -m / grok -m)
#   --effort E  codex reasoning effort: low|medium|high|xhigh|max|ultra (5.6 adds max/ultra)
set -uo pipefail

MODEL="${1:-}"; shift 2>/dev/null || true
[ -n "$MODEL" ] || { echo "usage: cli-ask.sh <codex|claude|codex-sol|codex-terra|codex-luna|codex-spark|grok|grok-web|composer|agy|qwen|deepseek|local|local-vision> [--timeout N] [--retries R] [--min-bytes B] [--model M] [--effort E] [--image FILE] \"prompt\"|--stdin" >&2; exit 2; }
# ---- COMPOSER PIN RESOLUTION (added 2026-08-27) ----
# `grok-composer-2.5-fast` disappeared from this account's xAI catalogue without a published
# retirement notice or named Composer successor. The account now lists only grok-4.6 / grok-4.5, so the
# hard pin made the entire `composer` lane exit 1 with a bare "unknown model id" — a documented,
# advertised lane that could not run at all. A pin is a commitment, not a guarantee
# (memory: pin-drift-cuts-both-ways), so resolve it against what the account ACTUALLY offers:
# keep the original the moment it ever comes back, otherwise fall back to the fastest live grok
# and SAY SO on stderr. Never silently substitute a model the caller did not ask for.
_resolve_composer() {
  local want="grok-composer-2.5-fast"
  local cache="${TMPDIR:-/tmp}/.cli-ask-grok-models.$(id -u)"
  local list=""
  if [ -f "$cache" ] && [ -n "$(find "$cache" -mmin -720 2>/dev/null)" ]; then
    list="$(cat "$cache" 2>/dev/null)"
  else
    list="$("${CLI_ASK_GROK:-grok}" models </dev/null 2>/dev/null)"
    [ -n "$list" ] && printf '%s' "$list" > "$cache" 2>/dev/null
  fi
  # No listing at all (offline / CLI broken): keep the historical pin, let the normal error path speak.
  if [ -z "$list" ]; then printf '%s' "$want"; return 0; fi
  if printf '%s' "$list" | grep -q -- "$want"; then printf '%s' "$want"; return 0; fi
  local alt
  for alt in grok-4.5 grok-4.6; do
    if printf '%s' "$list" | grep -q -- "$alt"; then
      echo "cli-ask: NOTE composer model '$want' is unavailable on this account; using '$alt' instead." >&2
      printf '%s' "$alt"; return 0
    fi
  done
  # Nothing recognisable: no pin at all, so grok uses its own default rather than hard-failing.
  echo "cli-ask: NOTE composer model '$want' is unavailable and no known grok model was listed; using account default." >&2
  printf ''
}

# ── TOP-MODEL DEFAULTS (Adrian-direct 2026-09-07) ──────────────────────────────
# Default `codex` uses terra with low effort for routine work.
# Alias routing remains explicit:
#  - codex-terra  -> gpt-5.6-terra (routine)
#  - codex-spark  -> gpt-5.3-codex-spark (low-cost execution)
#  - codex-sol    -> gpt-5.6-sol (complex implementation)
#  - codex-luna   -> gpt-5.6-luna (strategy / judgment)
# No hidden extra-node pool is implied; each lane tracks its own reported quota bucket.
#   qwen  : qwen3.8-max (2.4T MoE, 1M ctx) rather than bl's own default.
#   grok  : deliberately NOT pinned. Unpinned serves xAI's server-side newest, which IS the
#           top model; a hard-coded slug here goes stale silently (see the grok block below).
#   agy   : pinned in tools/agy-ask.py (gemini-3.8-flash-high), not here.
CLI_ASK_CODEX_MODEL="${CLI_ASK_CODEX_MODEL:-gpt-5.6-terra}"
CLI_ASK_CLAUDE_MODEL="${CLI_ASK_CLAUDE_MODEL:-sonnet}"
CLI_ASK_QWEN_MODEL="${CLI_ASK_QWEN_MODEL:-qwen3.8-max}"
CLI_ASK_DEFAULT_EFFORT="${CLI_ASK_DEFAULT_EFFORT:-low}"

PIN_MODEL=""; CODEX_EFFORT=""; GROK_WEB=0
REQUESTED_LANE="$MODEL"
case "$MODEL" in
  codex|claude|grok|agy|gemini|qwen|deepseek|local|localvision) ;;
  codex-sol)   MODEL=codex; PIN_MODEL="gpt-5.6-sol" ;;
  codex-terra) MODEL=codex; PIN_MODEL="gpt-5.6-terra" ;;
  codex-spark) MODEL=codex; PIN_MODEL="gpt-5.3-codex-spark" ;;
  codex-luna)  MODEL=codex; PIN_MODEL="gpt-5.6-luna" ;;
  composer)    MODEL=grok;  PIN_MODEL="__RESOLVE_COMPOSER__" ;;
  grok-web)    MODEL=grok;  GROK_WEB=1 ;;
  # ---- lanes 4-6, added 2026-08-23 (Adrian-direct: "they should all be in the CLI-ask ...
  #      part of the team ... same ruling"). Same gates, same empty-detect, same retry. ----
  qwen-plus)   MODEL=qwen;  PIN_MODEL="qwen3.7-plus" ;;
  local-fast)  MODEL=local; PIN_MODEL="qwen3.5:9b" ;;
  local-vision) MODEL=localvision; PIN_MODEL="${CLI_ASK_VISION_MODEL:-qwen2.5-vl-7b}" ;;
  *) echo "cli-ask: unknown model '$MODEL' (codex|claude|codex-sol|codex-terra|codex-luna|codex-spark|grok|grok-web|composer|agy|qwen|deepseek|local|local-vision)" >&2; exit 2;;
esac
[ "$PIN_MODEL" = "__RESOLVE_COMPOSER__" ] && PIN_MODEL="$(_resolve_composer)"

# Apply the top-model defaults to the BARE lanes only. $MODEL holds the ENGINE here (the
# alias case above rewrote it), and any explicit alias already set PIN_MODEL, so the
# -z guard is what protects codex-terra / codex-luna / qwen-plus. A later --model wins
# because the arg loop below assigns PIN_MODEL after this point.
case "$MODEL" in
  codex) [ -z "$PIN_MODEL" ] && PIN_MODEL="$CLI_ASK_CODEX_MODEL" ;;
  claude) [ -z "$PIN_MODEL" ] && PIN_MODEL="$CLI_ASK_CLAUDE_MODEL" ;;
  qwen)  [ -z "$PIN_MODEL" ] && PIN_MODEL="$CLI_ASK_QWEN_MODEL" ;;
esac
# Top-effort default for codex. Set AFTER the alias case but BEFORE the arg loop would be
# wrong (--effort must win), so it is applied lazily at call time in the codex block instead.
LOCAL_HOST="${LOCAL_HOST:-${CLI_ASK_LOCAL_HOST:-http://192.168.1.2:11434}}"   # M2 Studio grunt lane

# ---- AGY CONCURRENCY GATE (added 2026-06-12 after the 5-wide overnight wedge) ----
# agy hangs ALL lanes when >2 concurrent clients run (documented 2026-06-07, re-proven
# 2026-06-12: 105/105 calls timed out at 3-5 wide). Throughput lever = payload size,
# NEVER client width. This gate makes the mistake impossible: an agy call WAITS for a
# free slot (up to 20 min) instead of stacking, then gives up loudly (exit 75).
# Override (tests only): CLI_ASK_NOGATE=1. Width: CLI_ASK_AGY_MAX (default 2).
if [ "$MODEL" = "agy" ] || [ "$MODEL" = "gemini" ]; then
  if [ "${CLI_ASK_NOGATE:-0}" != "1" ]; then
    AGY_MAX="${CLI_ASK_AGY_MAX:-2}"
    _gate_waited=0
    while :; do
      _n=$(( $(pgrep -f "agy-ask.py" 2>/dev/null | wc -l | tr -d " ") ))
      [ "$_n" -lt "$AGY_MAX" ] && break
      if [ "$_gate_waited" -ge 1200 ]; then
        echo "cli-ask: AGY GATE — $_n agy clients running >= cap $AGY_MAX for 20min; refusing to stack (exit 75)" >&2
        exit 75
      fi
      sleep 15; _gate_waited=$(( _gate_waited + 15 ))
    done
  fi
fi
# ---- GROK CONCURRENCY GATE (added 2026-06-12) ----
# grok contention: when a standing grok lane (e.g. card-verify-grok) is running AND a session fires
# more grok calls, 3-4 concurrent grok jobs return 0 bytes (proven 2026-06-12: 3 chunks + the lane =
# 4-wide -> 2/3 chunks empty). Same fix as agy: WAIT for a slot, never stack. Counts grokprompt temp
# files (every cli-ask grok call writes one). Override: CLI_ASK_NOGATE=1. Width: CLI_ASK_GROK_MAX (default 2).
if [ "$MODEL" = "grok" ]; then
  if [ "${CLI_ASK_NOGATE:-0}" != "1" ]; then
    GROK_MAX="${CLI_ASK_GROK_MAX:-2}"
    _gate_waited=0
    while :; do
      # Count unique grokprompt temp files (1 per actual concurrent grok call).
      # Raw pgrep counts both run-bounded.py and the grok binary (both show the
      # tempfile path) -> 1 real call looked like 2 -> gate triggered at cap=2.
      _pids=$(pgrep -f "grokprompt" 2>/dev/null | tr '\n' ' ')
      if [ -n "$_pids" ]; then
        _n=$(echo "$_pids" | xargs -I{} ps -p {} -o args= 2>/dev/null \
              | grep -oE 'grokprompt\.[^[:space:]]+' | sort -u | wc -l | tr -d ' ')
      else
        _n=0
      fi
      [ "$_n" -lt "$GROK_MAX" ] && break
      if [ "$_gate_waited" -ge 1200 ]; then
        echo "cli-ask: GROK GATE — $_n grok clients running >= cap $GROK_MAX for 20min; refusing to stack (exit 75)" >&2
        exit 75
      fi
      sleep 15; _gate_waited=$(( _gate_waited + 15 ))
    done
  fi
fi
# ---- QWEN / DEEPSEEK / LOCAL GATES (added 2026-08-23) ----
# Same principle as agy/grok: WAIT for a slot, never stack. Widths chosen per lane economics —
# qwen is a cloud sub (2), deepseek is METERED so it is deliberately serialised (1), and the
# M2 Studio local lane is free but Ollama serialises internally, so 3 keeps it saturated
# without thrashing. Override: CLI_ASK_QWEN_MAX / CLI_ASK_DEEPSEEK_MAX / CLI_ASK_LOCAL_MAX.
_gate_on() {   # $1 = pgrep pattern, $2 = cap, $3 = lane label
  [ "${CLI_ASK_NOGATE:-0}" = "1" ] && return 0
  _w=0
  while :; do
    _n=$(( $(pgrep -f "$1" 2>/dev/null | wc -l | tr -d " ") ))
    [ "$_n" -lt "$2" ] && break
    if [ "$_w" -ge 1200 ]; then
      echo "cli-ask: $3 GATE — $_n clients >= cap $2 for 20min; refusing to stack (exit 75)" >&2; exit 75
    fi
    sleep 15; _w=$(( _w + 15 ))
  done
}
case "$MODEL" in
  qwen)     _gate_on "cliask-qwen"     "${CLI_ASK_QWEN_MAX:-2}"     QWEN ;;
  deepseek) _gate_on "ask-deepseek.py" "${CLI_ASK_DEEPSEEK_MAX:-1}" DEEPSEEK ;;
  local)    _gate_on "cliask-local"    "${CLI_ASK_LOCAL_MAX:-3}"    LOCAL ;;
  localvision) _gate_on "cliask-localvision" 1 LOCALVISION ;;   # server crashes on concurrent image decode
esac
# ---- end gate ----

IMAGE=""
TIMEOUT=360; RETRIES="${CLI_ASK_RETRIES:-1}"; MIN_BYTES="${CLI_ASK_MIN_BYTES:-20}"; USE_STDIN=0
PROMPT_ARG=""; PROMPT_CAPTURED=0
# --no-tools (2026-09-13, opt-in, claude lane ONLY): every built-in tool and every MCP server is
# removed on the CLI itself (--tools "" --strict-mcp-config), for untrusted-data prompts such as
# member feedback. Absent the flag, nothing below changes. Callers detect support via this line:
CLI_ASK_CLAUDE_NO_TOOLS_SUPPORTED=1; CLAUDE_NO_TOOLS=0
# Remote bounding (2026-09-13): a --no-tools inference runs on the Mini under cli-ask-nt-watchdog.py
# (wall deadline TIMEOUT-8s, process-group kill, one-at-a-time flock). Killing M1's ssh parent does
# not stop the Mini process, so the far side must bound and serialise itself. Callers detect it here:
CLI_ASK_CLAUDE_NO_TOOLS_BOUNDED=1
while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) TIMEOUT="${2:?--timeout needs a value}"; shift 2;;
    --retries) RETRIES="${2:?--retries needs a value}"; shift 2;;
    --min-bytes) MIN_BYTES="${2:?--min-bytes needs a value}"; shift 2;;
    --model) PIN_MODEL="${2:?--model needs a value}"; shift 2;;
    --effort) CODEX_EFFORT="${2:?--effort needs a value}"; shift 2;;
    --web) GROK_WEB=1; shift;;
    --image) IMAGE="${2:?--image needs a path}"; shift 2;;
    --stdin) USE_STDIN=1; shift;;
    --no-tools) CLAUDE_NO_TOOLS=1; shift;;
    --) shift; break;;
    *)
      # 2026-08-03 FIX: flags placed AFTER the prompt used to be silently dropped —
      # this loop broke on the first non-flag token (the prompt) and never looked at
      # anything past it. `cli-ask.sh codex "$P" --timeout 840` therefore silently
      # reverted to the 360s default with NO warning: a codex build that legitimately
      # needed 840s hard-timed-out at 360s instead. Root-caused after the same call
      # failed twice in one session. Fix: capture the first non-flag token as the
      # prompt but KEEP SCANNING remaining tokens for recognised flags, so flag order
      # relative to the prompt no longer matters. `--` above is unchanged: it still
      # means "stop parsing entirely, everything after is literal."
      if [ "$USE_STDIN" != 1 ] && [ "$PROMPT_CAPTURED" = 0 ]; then
        PROMPT_ARG="$1"; PROMPT_CAPTURED=1; shift
      else
        break
      fi
      ;;
  esac
done
if [ "$USE_STDIN" = 1 ]; then PROMPT="$(cat)"; else PROMPT="$PROMPT_ARG"; fi
# Non-empty check MUST be pipe-free: `printf "$PROMPT" | grep -q` breaks on large
# prompts — grep -q closes the pipe on first match, printf dies SIGPIPE(141), and
# `set -o pipefail` turns that into a false "empty prompt" (only for big --stdin
# payloads; small ones finished before the pipe closed). Pure-builtin glob, no pipe.
case "$PROMPT" in *[![:space:]]*) ;; *) echo "cli-ask: empty prompt" >&2; exit 2;; esac
if [ "$CLAUDE_NO_TOOLS" = 1 ] && [ "$MODEL" != claude ]; then echo "cli-ask: --no-tools is supported for the claude lane only" >&2; exit 2; fi
# The >BIG_MAX file-read idiom needs the Read tool, so a no-tools call refuses rather than re-enabling it.
if [ "$CLAUDE_NO_TOOLS" = 1 ] && [ "${#PROMPT}" -gt "${CLI_ASK_BIG_MAX:-100000}" ]; then echo "cli-ask: --no-tools prompt exceeds ${CLI_ASK_BIG_MAX:-100000} chars; refusing" >&2; exit 2; fi
# A busy or timed-out Mini lane is never retried: exactly one inference attempt, and the far-side
# deadline needs room to kill and confirm its process group before node-exec's own TIMEOUT alarm.
if [ "$CLAUDE_NO_TOOLS" = 1 ]; then
  RETRIES=0
  case "$TIMEOUT" in ''|*[!0-9]*) echo "cli-ask: --no-tools needs an integer --timeout" >&2; exit 2;; esac
  [ "$TIMEOUT" -ge 20 ] || { echo "cli-ask: --no-tools needs --timeout >= 20" >&2; exit 2; }
fi

GROK="${CLI_ASK_GROK:-$HOME/.local/bin/grok}"
CODEX="${CLI_ASK_CODEX:-/opt/homebrew/bin/codex}"
HERE="$(cd "$(dirname "$0")" && pwd)"

# ── NODE ROUTING: run the lane OFF M1 (added 2026-09-10, Adrian-direct) ───────────────────────
# "any CLIs are run on the Mini and/or Studio when Mini reaches capacity."
# M1 was measured at load 110-226 with 1628 processes while a sibling lane's renders were being
# SIGTERMed by the memory guardian three nights running. A CLI client is ~200-400MB resident plus
# a scheduler slot; hosting the whole team on the operator's laptop is the pressure itself.
#
# node-exec.sh picks mini -> studio -> local from a LIVE probe (memory, load, swap, binary present,
# credential present). It NEVER silently swaps engines - only the machine the engine runs on. If no
# node can serve the lane it says so loudly on stderr and returns local, so behaviour degrades to
# exactly what it was before this block existed.
#
# Lanes deliberately NOT routed here:
#   local/local-fast/local-vision - already remote: they speak HTTP to Studio/PC, never a local binary
#   deepseek                      - METERED. Its spend gate (metered-guard.py) lives on M1 and must
#                                   stay in the call path. cli-ask must never become a way around it.
#   qwen                          - the `bl` CLI is installed on M1 only
#   agy                           - needs tools/agy-ask.py, which lives in this vault (M1 only)
CLI_NODE=local
# An explicit binary override is a LOCAL-PATH instruction and must pin execution to M1. The
# self-test injects mock binaries this way; routing them to a remote node would resolve the real
# CLI on PATH instead and turn a hermetic test into a live billed call. Same for --image, whose
# file only exists here.
if [ -n "${CLI_ASK_CODEX:-}" ] || [ -n "${CLI_ASK_GROK:-}" ]; then CLI_ASK_FORCE_LOCAL=1; fi
if [ -n "$IMAGE" ]; then CLI_ASK_FORCE_LOCAL=1; fi
if [ "${CLI_ASK_FORCE_LOCAL:-0}" != "1" ] && [ -f "$HERE/node-exec.sh" ]; then
  case "$MODEL" in
    codex|claude|grok) CLI_NODE="$(bash "$HERE/node-exec.sh" pick "$REQUESTED_LANE" 2>/dev/null || echo local)" ;;
  esac
fi
# Adrian-direct 2026-09-13: M2 Original Siberian Blue only. UK Photon is
# reserved for Adrian; never spill this lane to the Mini or primary Mac.
if [ "$MODEL" = "claude" ] && [ "$CLI_NODE" != "studio" ]; then
  echo "cli-ask: Claude M2 OSB lane unavailable, unauthenticated or at capacity; refusing account fallback." >&2
  exit 75
fi
# Binary resolution differs per node: M1 pins absolute paths, remote nodes resolve on PATH
# (codex is ~/.local/bin/codex on the Mini but /opt/homebrew/bin/codex on the Studio - an absolute
# path taken from M1 would be wrong on one of them, and silently wrong on both after any reinstall).
if [ "$CLI_NODE" = local ]; then CODEX_BIN="$CODEX"; GROK_BIN="$GROK"; CLAUDE_BIN=claude; else CODEX_BIN=codex; GROK_BIN=grok; CLAUDE_BIN=claude; fi
[ "$CLI_NODE" != local ] && echo "cli-ask: lane '$REQUESTED_LANE' -> executing on $CLI_NODE (M1 stays free)" >&2

# _stage: copy a local file to the exec node and print the path that is valid THERE.
# Without this, every file-based idiom below hands a remote CLI an M1 path it cannot see - the
# prompt-file, the >100K data file, and grok's large-payload read file.
_stage() {
  if [ "$CLI_NODE" = local ]; then printf '%s\n' "$1"
  else bash "$HERE/node-exec.sh" stage "$CLI_NODE" "$1" || printf '%s\n' "$1"; fi
}
# _E: run argv on the exec node under the same timeout contract as bound().
# Remote calls carry their own far-side watchdog, so a hang cannot outlive its timeout on the very
# node we moved the work to.
_E() {
  if [ "$CLI_NODE" = local ]; then bound "$@"
  else NODE_EXEC_PINNED_NODE="$CLI_NODE" bash "$HERE/node-exec.sh" run "$REQUESTED_LANE" --timeout "$TIMEOUT" -- "$@"; fi
}

# OVERSIZED-PROMPT HANDLING (rewritten 2026-07-25 — see the defect note below).
# agy/codex take the prompt as a single argv arg and degrade/stall on very large inputs.
#
# THE OLD BEHAVIOUR (2026-06-04 -> 2026-07-25) AND WHY IT WAS WRONG:
#   Any >100K-char prompt for agy/codex was AUTO-ROUTED TO GROK, because grok had --prompt-file and,
#   at the time, a 1M context window. Since Grok 4.5 (2026-07-08) grok has the SMALLEST window of the
#   three (500K vs agy/codex ~1M) and a measured 54% hallucination rate. So the rule silently sent the
#   BIGGEST jobs to the LEAST suitable engine, and silently changed which model answered — the caller
#   asked for agy and got grok. That inverts delegation-doctrine §13.3.6.
#
# THE FIX: never switch engines behind the caller's back. Instead give agy/codex the same FILE-READ
# idiom already proven for grok (§2026-07-18): write the payload to a data file and hand the engine a
# SHORT argv instruction telling it to Read that file in full. Both are agentic CLIs with file tools
# (agy runs --dangerously-skip-permissions; codex exec has read access), so the argv limit stops being
# the constraint — the argv is now ~400 chars regardless of payload size.
# Override the threshold with CLI_ASK_BIG_MAX. Set CLI_ASK_LEGACY_GROK_REROUTE=1 to restore the old
# behaviour if a regression ever shows up.
BIG_MAX="${CLI_ASK_BIG_MAX:-100000}"
BIGFILE=""
# local/deepseek deliver over HTTP (no argv limit), so the file-read idiom is unnecessary
# and actively harmful there — it would ask a non-agentic endpoint to "read a file" it cannot see.
if [ "${#PROMPT}" -gt "$BIG_MAX" ] && [ "$MODEL" != grok ] && [ "$MODEL" != local ] && [ "$MODEL" != deepseek ]; then
  if [ "${CLI_ASK_LEGACY_GROK_REROUTE:-0}" = "1" ]; then
    # On a remote node the engine cannot see an M1 path, so stage it and reference the far-side copy.
    BIGREF="$(_stage "$BIGFILE")"
    echo "cli-ask: prompt ${#PROMPT} chars > $BIG_MAX — LEGACY reroute to grok (CLI_ASK_LEGACY_GROK_REROUTE=1)." >&2
    MODEL=grok
  else
    BIGFILE="$(mktemp -t cliaskdata.XXXXXX)"; printf '%s' "$PROMPT" >"$BIGFILE"
    echo "cli-ask: prompt ${#PROMPT} chars > $BIG_MAX — staying on ${MODEL}, delivering via file-read idiom ($BIGFILE)." >&2
    PROMPT="OUTPUT MODE — READ FIRST: The file at ${BIGREF} contains your COMPLETE task and all source material. It may be large. FIRST use your file-reading tool to read ${BIGREF} IN FULL (the entire file, not a preview). THEN carry out the instructions it contains and write your COMPLETE answer as plain text to standard output as your final message. Do NOT enter plan mode. Do NOT spawn subagents. Do NOT create, write, or edit ANY files — your only tool use is reading that one file."
  fi
fi

# bound: hard wall-clock cap that SIGKILLs the WHOLE process group (run-bounded.py) — so a PTY/agent
# grandchild (agy/codex/grok/llama-server) can NEVER be orphaned and outlive the timeout.
# This is the 2026-06-04 fix for the 9-hour zero-output hang (old perl-alarm+exec only signalled the
# single exec'd process, leaving the agy PTY child running for 9h).
bound() { python3 "$HERE/run-bounded.py" "$TIMEOUT" "$@"; }

# ---- ENGINE STDERR CAPTURE (added 2026-08-26) ----
# Every engine invocation used to send stderr to /dev/null, so a lane that was merely OUT OF QUOTA
# presented identically to a lane that had crashed: "thin/failed (rc=1 bytes=0)" and nothing else.
# PROVEN 2026-08-26: grok/grok-web returned rc=1 bytes=0 on a one-line probe. The discarded stderr
# said `API error (status 402 Payment Required): Grok Build usage balance exhausted`. That single
# line was the whole diagnosis, and it was being thrown away on every call.
# Engine stderr now lands in $ERRF and its last meaningful line is appended to the failure message.
# stdout handling is unchanged, so this is diagnostic-only.
ERRF="$(mktemp -t cliaskerr.XXXXXX)"
START_UTC=""
START_EPOCH=""
attempts=0

_cleanup_files() {
  rm -f "$OUT" "$ERRF" ${BIGFILE:+"$BIGFILE"}
}

trap _cleanup_files EXIT

_quota_exhausted() {
  [ -s "$ERRF" ] || return 1
  grep -iqE 'usage limit reached|weekly limit|individual quota reached|balance exhausted' "$ERRF"
}

_append_telemetry() {
  local rc="$1" nonws="$2" attempts_made="$3" end_epoch="$4" end_utc="$5"
  local elapsed=$(( end_epoch - START_EPOCH ))
  python3 "$HERE/lane_telemetry.py" --append \
    --run-id "${CLI_ASK_TELEMETRY_RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)}" \
    --task-id "${CLI_ASK_TASK_ID:-${FLEET_SESSION_ID:-UNKNOWN}}" \
    --account-pool "${CLI_ASK_ACCOUNT_POOL:-UNKNOWN}" \
    --requested-lane "$REQUESTED_LANE" \
    --actual-engine "$MODEL" \
    --model "$PIN_MODEL" \
    --effort "${CODEX_EFFORT:-$CLI_ASK_DEFAULT_EFFORT}" \
    --start-utc "$START_UTC" \
    --end-utc "$end_utc" \
    --elapsed-seconds "$elapsed" \
    --exit-code "$rc" \
    --attempts "$attempts_made" \
    --prompt-chars "${#PROMPT}" \
    --output-bytes "$nonws" \
    --acceptance "unreviewed" >/dev/null 2>&1
  [ $? -ne 0 ] && echo "cli-ask: WARNING failed to append telemetry" >&2
}

errtail() {  # last non-empty, non-noise stderr line, trimmed for one-line display
  [ -s "$ERRF" ] || return 0
  local line
  line="$(grep -v '^[[:space:]]*$' "$ERRF" | grep -iE 'error|denied|quota|exhaust|unauthor|forbidden|payment|limit|expired|invalid' | tail -1)"
  [ -n "$line" ] || line="$(grep -v '^[[:space:]]*$' "$ERRF" | tail -1)"
  [ -n "$line" ] || return 0
  printf ' | stderr: %s' "$(printf '%s' "$line" | tr -d '\r' | cut -c1-300)"
}

run_once() {  # $1 = output file; returns the CLI's exit code (anything >128 i.e. killed/timeout -> 124)
  local out="$1" rc g
  : >"$ERRF"
  case "$MODEL" in
    codex)
      # shellcheck disable=SC2086
      _E "$CODEX_BIN" exec --skip-git-repo-check \
        ${PIN_MODEL:+-m "$PIN_MODEL"} \
        -c model_reasoning_effort="${CODEX_EFFORT:-$CLI_ASK_DEFAULT_EFFORT}" \
        "$PROMPT" </dev/null >"$out" 2>>"$ERRF"; rc=$? ;;
    claude)
      # Verify the pool immediately before inference. A valid Claude login on the wrong
      # subscription is a hard failure, not permission to consume it.
      cstatus="$(NODE_EXEC_PINNED_NODE=studio bash "$HERE/node-exec.sh" run claude --timeout 15 -- "$CLAUDE_BIN" auth status 2>>"$ERRF")"
      if ! printf '%s' "$cstatus" | grep -q '"loggedIn": true' || \
         ! printf '%s' "$cstatus" | grep -q '"email": "originalsiberianblue@gmail.com"'; then
        echo "cli-ask: M2 Claude identity check failed; expected Original Siberian Blue account." >>"$ERRF"
        rc=77
      elif [ "$CLAUDE_NO_TOOLS" = 1 ]; then
        # No-inference argv probe over the SAME exec route: the empty --tools value must arrive
        # intact on the node (a dropped "" would let the next token become the tool list).
        probe="$(_E /usr/bin/printf '[%s]' --tools "" --strict-mcp-config </dev/null 2>>"$ERRF")"
        if [ "$probe" != "[--tools][][--strict-mcp-config]" ]; then
          echo "cli-ask: --no-tools argv probe failed on $CLI_NODE; refusing inference." >>"$ERRF"
          rc=78
        elif ! nt_wd="$(cat "$HERE/cli-ask-nt-watchdog.py" 2>/dev/null)" || [ -z "$nt_wd" ]; then
          echo "cli-ask: --no-tools watchdog $HERE/cli-ask-nt-watchdog.py missing; refusing inference." >>"$ERRF"
          rc=78
        else
          # The watchdog source crosses as argv data (never a remote shell string) and holds the
          # Mini lock for the life of the call; 75 = another no-tools inference is still running.
          _E /usr/bin/python3 -c "$nt_wd" --deadline "$(( TIMEOUT - 8 ))" -- \
            "$CLAUDE_BIN" --print --model "$PIN_MODEL" --permission-mode auto \
            --tools "" --strict-mcp-config \
            --no-session-persistence "$PROMPT" </dev/null >"$out" 2>>"$ERRF"; rc=$?
          [ "$rc" = 75 ] && echo "cli-ask: Mini no-tools lane busy (previous inference still running); refusing, no retry." >>"$ERRF"
        fi
      else
        _E "$CLAUDE_BIN" --print --model "$PIN_MODEL" --permission-mode auto \
          --no-session-persistence "$PROMPT" </dev/null >"$out" 2>>"$ERRF"; rc=$?
      fi ;;
    grok)
      g="$(mktemp -t grokprompt.XXXXXX)"
      # grok-build is a coding AGENT: on long "produce a document" prompts it goes agentic (plan / write-a-file)
      # and emits NOTHING to stdout. Fix (verified 2026-06-03): writing-task framing + strip plan/subagents/web
      # tools so it returns prose to stdout. For live-web grok, call the binary directly with web enabled.
      # 2026-06-12 ROOT-CAUSE FIX: on prompts >~40KB the framing alone was NOT enough — grok still entered a
      # MULTI-TURN agentic loop and emitted 0 bytes (the 62KB chunks that "flaked" twice). --max-turns 1 forces
      # a SINGLE direct answer to stdout (no loop, no file-write path). PROVEN: same 62KB chunk 0B -> 10KB.
      # 2026-07-10 grok-web RESEARCH mode: the grok lane has server-side live web search. Web ON needs multiple
      # (2026-08-14: was written as "grok-4.5". This lane passes NO -m flag, so it serves whatever xAI's
      #  server-side default is — verified 2026-08-13 to be grok-4.6 via ~/.grok/sessions/*/signals.json.
      #  Do not name a specific model here; it goes stale silently. Check the session log, not this comment.)
      # turns (search->read->answer), so --max-turns 8; plan/subagents/file-writes stay OFF to prevent the
      # agentic-drift 0-byte failure mode. Final answer must land on stdout.
      if [ "$GROK_WEB" = 1 ]; then
        { printf '%s\n\n' 'OUTPUT MODE — READ FIRST: This is a live-web RESEARCH task. Use your web search tools to ground the answer, then write your COMPLETE answer as plain text to standard output as your final message. Cite a source URL for every factual claim; write [NOT FOUND] for anything you cannot verify. Do NOT create/write/edit any files. Do NOT enter plan mode. Do NOT spawn subagents.'; printf '%s' "$PROMPT"; } >"$g"
        gr="$(_stage "$g")"
        _E "$GROK_BIN" --no-plan --no-subagents --max-turns 8 ${PIN_MODEL:+-m "$PIN_MODEL"} --prompt-file "$gr" </dev/null >"$out" 2>>"$ERRF"; rc=$?
      else
        # Non-web grok. Delivery mode is SIZE-GATED (2026-07-18 root-cause fix):
        #   SMALL (<= GROK_INLINE_MAX): inline single-turn (--max-turns 1). Proven reliable; no agentic drift.
        #   LARGE (>  GROK_INLINE_MAX): grok's harness OFFLOADS + TRUNCATES a big inline --prompt-file, and a
        #     headless SINGLE turn cannot retrieve the offloaded remainder — PROVEN 2026-07-18: a 116KB inline
        #     prompt made grok see only 3 of 18 files ("message body was mid-truncated after join route ... per
        #     offload note"). Every large grok call this way silently audits a fraction of the input.
        #     FIX (proven, RC=0, all 18/18 files): write the payload to a DATA file and have grok READ it with
        #     its own Read tool (the agentic idiom a coding-agent CLI is built for), with tool permission granted
        #     (--permission-mode bypassPermissions) + enough turns (--max-turns 12). Big context is NOT the limit
        #     (116KB ~= 29K tokens vs grok-4.5's 500K window) — inline-offload truncation is. Override the gate
        #     with CLI_ASK_GROK_INLINE_MAX (bytes; default 40000 — safely above the 22KB that works inline and
        #     below the 116KB that truncates).
        GROK_INLINE_MAX="${CLI_ASK_GROK_INLINE_MAX:-40000}"
        if [ "${#PROMPT}" -le "$GROK_INLINE_MAX" ]; then
          { printf '%s\n\n' 'OUTPUT MODE — READ FIRST: This is a pure WRITING/ANALYSIS task. Write your COMPLETE answer as plain text to standard output now. Do NOT use any tools. Do NOT create/write/edit any files. Do NOT enter plan mode. Do NOT spawn subagents. Just write the full answer as text.'; printf '%s' "$PROMPT"; } >"$g"
          gr="$(_stage "$g")"
          _E "$GROK_BIN" --no-plan --no-subagents --disable-web-search --max-turns 1 ${PIN_MODEL:+-m "$PIN_MODEL"} --prompt-file "$gr" </dev/null >"$out" 2>>"$ERRF"; rc=$?
        else
          d="$(mktemp -t grokdata.XXXXXX)"; printf '%s' "$PROMPT" >"$d"
          dr="$(_stage "$d")"   # stage BEFORE writing $g: the remote path goes inside the instruction text
          { printf 'OUTPUT MODE — READ FIRST: The file at %s contains your COMPLETE task and all source material. It may be large. FIRST use your Read tool to read %s IN FULL (read the entire file, not a preview). THEN carry out the instructions it contains and write your COMPLETE answer as plain text to standard output as your final message. Do NOT enter plan mode. Do NOT spawn subagents. Do NOT create, write, or edit ANY files — your only tool use is reading that one file.\n' "$dr" "$dr"; } >"$g"
          gr="$(_stage "$g")"
          _E "$GROK_BIN" --no-plan --no-subagents --disable-web-search --permission-mode bypassPermissions --max-turns 12 ${PIN_MODEL:+-m "$PIN_MODEL"} --prompt-file "$gr" </dev/null >"$out" 2>>"$ERRF"; rc=$?
          rm -f "$d"
        fi
      fi
      rm -f "$g" ;;
    qwen)
      # ⚠️ REWIRED 2026-08-27 (Adrian-direct). This lane used to shell the `qwen` Code CLI and
      # FORCE-INJECT the vault's DASHSCOPE_API_KEY over the top of it. That key belongs to a
      # different, unentitled Alibaba account, so it clobbered the working credential and the lane
      # failed 100% of the time from 2026-08-07 to 2026-08-27. Every session then reported
      # "qwen BLOCKED, Adrian must activate Model Studio", which was false, and a paid
      # subscription sat at ZERO usage for twenty days.
      #
      # THE WORKING LANE IS `bl` (Bailian CLI) on Adrian's Model Studio TOKEN PLAN. This was
      # already documented correctly in tools/lanes.py on 2026-08-07 and simply never read.
      # FLAT-RATE and already paid for, so per the SATURATION LAW it should be pushed hard.
      # Check auth with `bl auth status`; config lives in ~/.bailian/config.json.
      # NEVER export DASHSCOPE_API_KEY into this lane — that is precisely what broke it.
      q="$(mktemp -t qwenmsg.XXXXXX)"
      printf '%s' "$PROMPT" | python3 -c 'import json,sys; json.dump([{"role":"user","content":sys.stdin.read()}], open(sys.argv[1],"w"))' "$q"
      QBIN="${CLI_ASK_BL:-bl}"
      # bl has its OWN http timeout, separate from cli-ask's wrapper timeout. Without passing it
      # a long brief dies with "Error: Request timed out" (exit 5) while the wrapper still has
      # minutes left. Give bl slightly less than the wrapper so the wrapper's 124 stays meaningful.
      QTMO=$(( TIMEOUT > 60 ? TIMEOUT - 30 : TIMEOUT ))
      bound env CLIASK_LANE=cliask-qwen "$QBIN" text chat \
        --messages-file "$q" \
        --max-tokens "${CLI_ASK_QWEN_MAXTOK:-32768}" \
        --timeout "$QTMO" \
        --stream \
        --quiet ${PIN_MODEL:+--model "$PIN_MODEL"} \
        </dev/null >"$out" 2>>"$ERRF"; rc=$?
      rm -f "$q" ;;
    deepseek)
      # METERED. Deliberately routed through ask-deepseek.py so tools/metered-guard.py and the
      # $20/mo trial cap still apply — cli-ask must never become a way around the spend gate.
      d="$(mktemp -t dsprompt.XXXXXX)"; printf '%s' "$PROMPT" >"$d"
      bound python3 "$HERE/ask-deepseek.py" --file "$d" </dev/null >"$out" 2>>"$ERRF"; rc=$?
      rm -f "$d" ;;
    local)
      # M2 Studio Ollama (free, unlimited) — the doctrine's big-corpus grunt lane. HTTP, so the
      # prompt goes inline at any size. Non-agentic: no tools, no files, answer is the response body.
      LM="${PIN_MODEL:-${CLI_ASK_LOCAL_MODEL:-qwen2.5:14b}}"
      d="$(mktemp -t cliask-local.XXXXXX)"
      printf '%s' "$PROMPT" >"$d"
      bound /usr/bin/python3 -c '
import json,os,sys,urllib.request
host,model,pf,to=sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4])
p=open(pf,encoding="utf-8").read()
body=json.dumps({"model":model,"prompt":p,"stream":False,
                 "options":{"temperature":float(os.environ.get("CLI_ASK_LOCAL_TEMP","0")),
                            "num_ctx":int(os.environ.get("CLI_ASK_LOCAL_CTX","16384"))}}).encode()
req=urllib.request.Request(host+"/api/generate",data=body,headers={"Content-Type":"application/json"})
sys.stdout.write(json.loads(urllib.request.urlopen(req,timeout=to).read()).get("response",""))
' "$LOCAL_HOST" "$LM" "$d" "$TIMEOUT" </dev/null >"$out" 2>>"$ERRF"; rc=$?
      rm -f "$d" ;;
    localvision)
      # ⚠️ REWRITTEN 2026-08-28. This lane was structurally incapable of working for its whole life:
      # it reused the Ollama-native `local` block, so it POSTed {"model","prompt"} to /api/generate
      # on a server that is OpenAI-compatible llama.cpp, sent NO Authorization header (-> 401 on
      # every call), and carried no image field at all. A vision lane that could not receive an
      # image. /v1/models answers 200 without auth, which is why every health check called it fine.
      # Contract taken from the one proven caller,
      # working/_research/2026-07-29-osb-visual-audit/pc-vision-pass.py (1.3 s/image, ~2,770 img/hr).
      VH="${CLI_ASK_PC_VISION:-http://desktop-g882q54.tail51f5fb.ts.net:8080}"
      if [ -z "${PC_VISION_API_KEY:-}" ] && [ -f "$HOME/.config/com.adrian-vault/.env" ]; then
        PC_VISION_API_KEY="$(grep -m1 '^PC_VISION_API_KEY=' "$HOME/.config/com.adrian-vault/.env" | cut -d= -f2-)"
        export PC_VISION_API_KEY
      fi
      d="$(mktemp -t cliask-lv.XXXXXX)"; printf '%s' "$PROMPT" >"$d"
      bound /usr/bin/python3 -c '
import base64,json,mimetypes,os,sys,urllib.request
host,model,pf,to,img=sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4]),sys.argv[5]
key=os.environ.get("PC_VISION_API_KEY","")
if not key:
    sys.stderr.write("local-vision: PC_VISION_API_KEY unset -> the server will 401. "
                     "It lives in ~/.config/com.adrian-vault/.env\n"); sys.exit(2)
content=[{"type":"text","text":open(pf,encoding="utf-8").read()}]
if img:
    if not os.path.exists(img):
        sys.stderr.write("local-vision: --image not found: %s\n" % img); sys.exit(2)
    mt=mimetypes.guess_type(img)[0] or "image/jpeg"
    b64=base64.b64encode(open(img,"rb").read()).decode()
    content.append({"type":"image_url","image_url":{"url":"data:%s;base64,%s"%(mt,b64)}})
body=json.dumps({"model":model,"temperature":0,
                 "max_tokens":int(os.environ.get("CLI_ASK_VISION_MAXTOK","1024")),
                 "messages":[{"role":"user","content":content}]}).encode()
req=urllib.request.Request(host+"/v1/chat/completions",data=body,
      headers={"Content-Type":"application/json","Authorization":"Bearer "+key})
d=json.loads(urllib.request.urlopen(req,timeout=to).read())
sys.stdout.write(d["choices"][0]["message"]["content"])
' "$VH" "${PIN_MODEL:-qwen2.5-vl-7b}" "$d" "$TIMEOUT" "$IMAGE" </dev/null >"$out" 2>>"$ERRF"; rc=$?
      rm -f "$d" ;;
    agy|gemini)
      # Outer wall is TIMEOUT+30 so agy-ask.py's inner SIGALRM (at TIMEOUT) always fires first,
      # writes whatever output it has, and the parent exits cleanly before the SIGKILL lands.
      # Same TIMEOUT+30 is safe — if inner alarm fires at Ts, parent is done within Ts+1s.
      python3 "$HERE/run-bounded.py" "$((TIMEOUT + 30))" \
        python3 "$HERE/agy-ask.py" --timeout "$TIMEOUT" "$PROMPT" \
        </dev/null >"$out" 2>>"$ERRF"; rc=$? ;;
  esac
  [ "$rc" -gt 128 ] && rc=124
  return $rc
}

OUT="$(mktemp -t cliask.XXXXXX)"
START_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
START_EPOCH="$(date -u +%s)"
attempt=0
while :; do
  run_once "$OUT"; rc=$?
  nonws=$(tr -d '[:space:]' <"$OUT" | wc -c | tr -d ' ')
  attempts=$((attempt + 1))
  now_epoch="$(date -u +%s)"; now_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  if [ "$rc" -eq 0 ] && [ "$nonws" -ge "$MIN_BYTES" ]; then
    _append_telemetry "$rc" "$nonws" "$attempts" "$now_epoch" "$now_utc"
    cat "$OUT"; exit 0
  fi

  if _quota_exhausted; then
    _append_telemetry "$rc" "$nonws" "$attempts" "$now_epoch" "$now_utc"
    echo "cli-ask: $MODEL explicit quota-exhaustion pattern$(errtail)" >&2
    cat "$OUT"; exit "$rc"
  fi
  # 2026-06-12: a hard TIMEOUT (124) is NOT a transient flake — retrying re-pays the full --timeout wall
  # (the 18-min double-wait that wasted the 185KB run). A genuinely oversized prompt will just time out
  # again, so fail fast and tell the caller to chunk. (Set CLI_ASK_RETRY_TIMEOUT=1 to restore old behaviour.)
  if [ "$rc" -eq 124 ] && [ "${CLI_ASK_RETRY_TIMEOUT:-0}" != "1" ]; then
    _append_telemetry "$rc" "$nonws" "$attempts" "$now_epoch" "$now_utc"
    echo "cli-ask: $MODEL hard-timed-out at ${TIMEOUT}s — NOT retrying (oversized prompt? chunk it, or raise --timeout)" >&2
    cat "$OUT"; exit 124
  fi
  # 2026-06-18: agy now returns non-zero on tool-use failures (migration from gemini CLI).
  # A tool-use failure with substantive output is NOT a transient flake — retrying burns the
  # compute-weighted subscription quota for no gain. Fast-fail if agy produced output but exited non-zero.
  if [ "$MODEL" = "agy" ] && [ "$rc" -ne 0 ] && [ "$nonws" -ge "$MIN_BYTES" ]; then
    _append_telemetry "$rc" "$nonws" "$attempts" "$now_epoch" "$now_utc"
    echo "cli-ask: agy exited $rc (tool-use failure?) with ${nonws} bytes output — NOT retrying$(errtail)" >&2
    cat "$OUT"; exit "$rc"
  fi
  if [ "$attempt" -ge "$RETRIES" ]; then
    if [ "$rc" -ne 0 ]; then
      _append_telemetry "$rc" "$nonws" "$attempts" "$now_epoch" "$now_utc"
      echo "cli-ask: $MODEL exited $rc after $attempts attempt(s)$(errtail)" >&2
      cat "$OUT"; exit "$rc"
    fi
    _append_telemetry "3" "$nonws" "$attempts" "$now_epoch" "$now_utc"
    echo "cli-ask: $MODEL returned only ${nonws} non-space bytes (min ${MIN_BYTES}) after $attempts attempt(s) — FAILURE, not a silent pass$(errtail)" >&2
    cat "$OUT"; exit 3
  fi
  attempt=$((attempt+1)); echo "cli-ask: $MODEL thin/failed (rc=$rc bytes=${nonws})$(errtail); retry ${attempt}/${RETRIES}..." >&2; sleep 2
done
