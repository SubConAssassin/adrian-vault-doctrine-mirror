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
#   cli-ask.sh <codex|grok|agy> [--timeout N] [--retries R] [--min-bytes B] "prompt"
#   cli-ask.sh <codex|grok|agy> [--timeout N] --stdin < prompt.txt
# Exit: 0 ok | 2 usage | 3 empty/thin after retries | 124 timeout | else = the CLI's own code.
# Binaries overridable via env: CLI_ASK_CODEX / CLI_ASK_GROK / AGY_BIN (the self-test injects mocks).
#
# 2026-07-10 model-upgrade lanes (additive; bare codex/grok/agy behaviour unchanged):
#   codex-sol | codex-terra | codex-luna  -> codex exec -m gpt-5.6-{sol|terra|luna}
#   composer                              -> grok -m grok-composer-2.5-fast (Cursor coding model, fast/cheap)
#   grok-web                              -> grok-4.5 RESEARCH mode: live web search ON, citations required,
#                                            --max-turns 8 (still no plan/subagents/file-writes)
#   --model M   pin any model id on the underlying CLI (codex -m / grok -m)
#   --effort E  codex reasoning effort: low|medium|high|xhigh|max|ultra (5.6 adds max/ultra)
set -uo pipefail

MODEL="${1:-}"; shift 2>/dev/null || true
[ -n "$MODEL" ] || { echo "usage: cli-ask.sh <codex|codex-sol|codex-terra|codex-luna|grok|grok-web|composer|agy> [--timeout N] [--retries R] [--min-bytes B] [--model M] [--effort E] \"prompt\"|--stdin" >&2; exit 2; }
PIN_MODEL=""; CODEX_EFFORT=""; GROK_WEB=0
case "$MODEL" in
  codex|grok|agy|gemini) ;;
  codex-sol)   MODEL=codex; PIN_MODEL="gpt-5.6-sol" ;;
  codex-terra) MODEL=codex; PIN_MODEL="gpt-5.6-terra" ;;
  codex-luna)  MODEL=codex; PIN_MODEL="gpt-5.6-luna" ;;
  composer)    MODEL=grok;  PIN_MODEL="grok-composer-2.5-fast" ;;
  grok-web)    MODEL=grok;  GROK_WEB=1 ;;
  *) echo "cli-ask: unknown model '$MODEL' (codex|codex-sol|codex-terra|codex-luna|grok|grok-web|composer|agy)" >&2; exit 2;;
esac

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
# ---- end gate ----

TIMEOUT=360; RETRIES="${CLI_ASK_RETRIES:-1}"; MIN_BYTES="${CLI_ASK_MIN_BYTES:-20}"; USE_STDIN=0
PROMPT_ARG=""; PROMPT_CAPTURED=0
while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) TIMEOUT="${2:?--timeout needs a value}"; shift 2;;
    --retries) RETRIES="${2:?--retries needs a value}"; shift 2;;
    --min-bytes) MIN_BYTES="${2:?--min-bytes needs a value}"; shift 2;;
    --model) PIN_MODEL="${2:?--model needs a value}"; shift 2;;
    --effort) CODEX_EFFORT="${2:?--effort needs a value}"; shift 2;;
    --web) GROK_WEB=1; shift;;
    --stdin) USE_STDIN=1; shift;;
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

GROK="${CLI_ASK_GROK:-$HOME/.local/bin/grok}"
CODEX="${CLI_ASK_CODEX:-/opt/homebrew/bin/codex}"
HERE="$(cd "$(dirname "$0")" && pwd)"

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
if [ "${#PROMPT}" -gt "$BIG_MAX" ] && [ "$MODEL" != grok ]; then
  if [ "${CLI_ASK_LEGACY_GROK_REROUTE:-0}" = "1" ]; then
    echo "cli-ask: prompt ${#PROMPT} chars > $BIG_MAX — LEGACY reroute to grok (CLI_ASK_LEGACY_GROK_REROUTE=1)." >&2
    MODEL=grok
  else
    BIGFILE="$(mktemp -t cliaskdata.XXXXXX)"; printf '%s' "$PROMPT" >"$BIGFILE"
    echo "cli-ask: prompt ${#PROMPT} chars > $BIG_MAX — staying on ${MODEL}, delivering via file-read idiom ($BIGFILE)." >&2
    PROMPT="OUTPUT MODE — READ FIRST: The file at ${BIGFILE} contains your COMPLETE task and all source material. It may be large. FIRST use your file-reading tool to read ${BIGFILE} IN FULL (the entire file, not a preview). THEN carry out the instructions it contains and write your COMPLETE answer as plain text to standard output as your final message. Do NOT enter plan mode. Do NOT spawn subagents. Do NOT create, write, or edit ANY files — your only tool use is reading that one file."
  fi
fi

# bound: hard wall-clock cap that SIGKILLs the WHOLE process group (run-bounded.py) — so a PTY/agent
# grandchild (agy/codex/grok/llama-server) can NEVER be orphaned and outlive the timeout.
# This is the 2026-06-04 fix for the 9-hour zero-output hang (old perl-alarm+exec only signalled the
# single exec'd process, leaving the agy PTY child running for 9h).
bound() { python3 "$HERE/run-bounded.py" "$TIMEOUT" "$@"; }

run_once() {  # $1 = output file; returns the CLI's exit code (anything >128 i.e. killed/timeout -> 124)
  local out="$1" rc g
  case "$MODEL" in
    codex)
      # shellcheck disable=SC2086
      bound "$CODEX" exec --skip-git-repo-check \
        ${PIN_MODEL:+-m "$PIN_MODEL"} \
        ${CODEX_EFFORT:+-c model_reasoning_effort="$CODEX_EFFORT"} \
        "$PROMPT" </dev/null >"$out" 2>/dev/null; rc=$? ;;
    grok)
      g="$(mktemp -t grokprompt.XXXXXX)"
      # grok-build is a coding AGENT: on long "produce a document" prompts it goes agentic (plan / write-a-file)
      # and emits NOTHING to stdout. Fix (verified 2026-06-03): writing-task framing + strip plan/subagents/web
      # tools so it returns prose to stdout. For live-web grok, call the binary directly with web enabled.
      # 2026-06-12 ROOT-CAUSE FIX: on prompts >~40KB the framing alone was NOT enough — grok still entered a
      # MULTI-TURN agentic loop and emitted 0 bytes (the 62KB chunks that "flaked" twice). --max-turns 1 forces
      # a SINGLE direct answer to stdout (no loop, no file-write path). PROVEN: same 62KB chunk 0B -> 10KB.
      # 2026-07-10 grok-web RESEARCH mode: grok-4.5 has server-side live web search. Web ON needs multiple
      # turns (search->read->answer), so --max-turns 8; plan/subagents/file-writes stay OFF to prevent the
      # agentic-drift 0-byte failure mode. Final answer must land on stdout.
      if [ "$GROK_WEB" = 1 ]; then
        { printf '%s\n\n' 'OUTPUT MODE — READ FIRST: This is a live-web RESEARCH task. Use your web search tools to ground the answer, then write your COMPLETE answer as plain text to standard output as your final message. Cite a source URL for every factual claim; write [NOT FOUND] for anything you cannot verify. Do NOT create/write/edit any files. Do NOT enter plan mode. Do NOT spawn subagents.'; printf '%s' "$PROMPT"; } >"$g"
        bound "$GROK" --no-plan --no-subagents --max-turns 8 ${PIN_MODEL:+-m "$PIN_MODEL"} --prompt-file "$g" </dev/null >"$out" 2>/dev/null; rc=$?
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
          bound "$GROK" --no-plan --no-subagents --disable-web-search --max-turns 1 ${PIN_MODEL:+-m "$PIN_MODEL"} --prompt-file "$g" </dev/null >"$out" 2>/dev/null; rc=$?
        else
          d="$(mktemp -t grokdata.XXXXXX)"; printf '%s' "$PROMPT" >"$d"
          { printf 'OUTPUT MODE — READ FIRST: The file at %s contains your COMPLETE task and all source material. It may be large. FIRST use your Read tool to read %s IN FULL (read the entire file, not a preview). THEN carry out the instructions it contains and write your COMPLETE answer as plain text to standard output as your final message. Do NOT enter plan mode. Do NOT spawn subagents. Do NOT create, write, or edit ANY files — your only tool use is reading that one file.\n' "$d" "$d"; } >"$g"
          bound "$GROK" --no-plan --no-subagents --disable-web-search --permission-mode bypassPermissions --max-turns 12 ${PIN_MODEL:+-m "$PIN_MODEL"} --prompt-file "$g" </dev/null >"$out" 2>/dev/null; rc=$?
          rm -f "$d"
        fi
      fi
      rm -f "$g" ;;
    agy|gemini)
      # Outer wall is TIMEOUT+30 so agy-ask.py's inner SIGALRM (at TIMEOUT) always fires first,
      # writes whatever output it has, and the parent exits cleanly before the SIGKILL lands.
      # Same TIMEOUT+30 is safe — if inner alarm fires at Ts, parent is done within Ts+1s.
      python3 "$HERE/run-bounded.py" "$((TIMEOUT + 30))" \
        python3 "$HERE/agy-ask.py" --timeout "$TIMEOUT" "$PROMPT" \
        </dev/null >"$out" 2>/dev/null; rc=$? ;;
  esac
  [ "$rc" -gt 128 ] && rc=124
  return $rc
}

OUT="$(mktemp -t cliask.XXXXXX)"; trap 'rm -f "$OUT" ${BIGFILE:+"$BIGFILE"}' EXIT
attempt=0
while :; do
  run_once "$OUT"; rc=$?
  nonws=$(tr -d '[:space:]' <"$OUT" | wc -c | tr -d ' ')
  if [ "$rc" -eq 0 ] && [ "$nonws" -ge "$MIN_BYTES" ]; then cat "$OUT"; exit 0; fi
  # 2026-06-12: a hard TIMEOUT (124) is NOT a transient flake — retrying re-pays the full --timeout wall
  # (the 18-min double-wait that wasted the 185KB run). A genuinely oversized prompt will just time out
  # again, so fail fast and tell the caller to chunk. (Set CLI_ASK_RETRY_TIMEOUT=1 to restore old behaviour.)
  if [ "$rc" -eq 124 ] && [ "${CLI_ASK_RETRY_TIMEOUT:-0}" != "1" ]; then
    echo "cli-ask: $MODEL hard-timed-out at ${TIMEOUT}s — NOT retrying (oversized prompt? chunk it, or raise --timeout)" >&2
    cat "$OUT"; exit 124
  fi
  # 2026-06-18: agy now returns non-zero on tool-use failures (migration from gemini CLI).
  # A tool-use failure with substantive output is NOT a transient flake — retrying burns the
  # 20 req/day free-tier quota for no gain. Fast-fail if agy produced output but exited non-zero.
  if [ "$MODEL" = "agy" ] && [ "$rc" -ne 0 ] && [ "$nonws" -ge "$MIN_BYTES" ]; then
    echo "cli-ask: agy exited $rc (tool-use failure?) with ${nonws} bytes output — NOT retrying" >&2
    cat "$OUT"; exit "$rc"
  fi
  if [ "$attempt" -ge "$RETRIES" ]; then
    if [ "$rc" -ne 0 ]; then echo "cli-ask: $MODEL exited $rc after $((attempt+1)) attempt(s)" >&2; cat "$OUT"; exit "$rc"; fi
    echo "cli-ask: $MODEL returned only ${nonws} non-space bytes (min ${MIN_BYTES}) after $((attempt+1)) attempt(s) — FAILURE, not a silent pass" >&2
    cat "$OUT"; exit 3
  fi
  attempt=$((attempt+1)); echo "cli-ask: $MODEL thin/failed (rc=$rc bytes=${nonws}); retry ${attempt}/${RETRIES}..." >&2; sleep 2
done
