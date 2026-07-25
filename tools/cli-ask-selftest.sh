#!/usr/bin/env bash
# cli-ask-selftest.sh — the ACID TEST for the CLI-team harness (tools/cli-ask.sh).
# It tries to BREAK the wrapper and reports PASS/FAIL per failure mode. Mostly uses MOCK binaries
# (free, deterministic, instant) so it can run anytime; pass --live to ALSO fire one real bounded
# call per CLI. THIS IS THE LEARNING LOOP: run it after any harness change, and every new failure
# mode found in the wild becomes a new case here -> the harness only ever gets more robust.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; ASK="$HERE/cli-ask.sh"
PASS=0; FAIL=0
ok(){ printf '  \033[32m✅ %s\033[0m\n' "$1"; PASS=$((PASS+1)); }
no(){ printf '  \033[31m❌ %s\033[0m\n' "$1"; FAIL=$((FAIL+1)); }

MOCKDIR="$(mktemp -d -t cliaskmock.XXXXXX)"; trap 'rm -rf "$MOCKDIR" /tmp/cliask_flaky_state /tmp/PWNED_*' EXIT
# echo-mock: emulates grok/codex/agy — pulls the prompt from -p / --prompt-file / positional, echoes a marker.
cat >"$MOCKDIR/echo-mock" <<'EOF'
#!/usr/bin/env bash
p=""
while [ $# -gt 0 ]; do case "$1" in
  -p) p="$2"; shift 2;;
  --prompt-file) p="$(cat "$2")"; shift 2;;
  --permission-mode|--max-turns|-m|--model) shift 2;;
  exec|--skip-git-repo-check|--dangerously-skip-permissions|--no-plan|--no-subagents|--disable-web-search) shift;;
  *) p="$1"; shift;;
esac; done
# 2026-07-18: grok's LARGE-prompt path (>CLI_ASK_GROK_INLINE_MAX) delivers content via an on-disk grokdata
# file that grok reads with its Read tool (not inline). Faithfully simulate that Read so the mock sees the
# full payload the real grok would — otherwise the mock only sees the short "read this file" instruction.
df=$(printf '%s' "$p" | grep -oE '/[^ ]*grokdata[^ ]*' | head -1)
if [ -n "$df" ] && [ -f "$df" ]; then p="$(cat "$df")"; fi
printf 'MOCK_OK len=%s firstword=%s\n' "${#p}" "${p%% *}"
EOF
printf '#!/usr/bin/env bash\nexit 0\n'                 >"$MOCKDIR/empty-mock"   # exit 0, prints nothing
printf '#!/usr/bin/env bash\nprintf .\n'               >"$MOCKDIR/onebyte-mock" # 1 byte
printf '#!/usr/bin/env bash\nsleep 30\necho late\n'    >"$MOCKDIR/slow-mock"    # hangs past any short timeout
cat >"$MOCKDIR/flaky-mock" <<'EOF'
#!/usr/bin/env bash
f=/tmp/cliask_flaky_state
if [ -f "$f" ]; then printf 'RECOVERED real content long enough to pass\n'; else : >"$f"; fi
EOF
chmod +x "$MOCKDIR"/*

echo "=== cli-ask acid test (mock battery) ==="
# P1 empty prompt
"$ASK" codex "" >/dev/null 2>&1; [ $? -eq 2 ] && ok "P1 empty prompt -> exit 2" || no "P1 empty prompt"
# P2 whitespace-only prompt
"$ASK" codex "   " >/dev/null 2>&1; [ $? -eq 2 ] && ok "P2 whitespace-only prompt -> exit 2" || no "P2 whitespace prompt"
# P3 unknown model
"$ASK" banana "hi" >/dev/null 2>&1; [ $? -eq 2 ] && ok "P3 unknown model -> exit 2" || no "P3 unknown model"
# P4 shell-metacharacter safety (must be passed as DATA, never executed)
rm -f /tmp/PWNED_$$
out=$(CLI_ASK_GROK="$MOCKDIR/echo-mock" "$ASK" grok '$(touch /tmp/PWNED_'"$$"'); `id`' 2>/dev/null)
{ [ ! -e "/tmp/PWNED_$$" ] && printf '%s' "$out" | grep -q MOCK_OK; } && ok "P4 metacharacters passed as data, not executed" || no "P4 metacharacter safety"
# P5 long (200KB) prompt arrives intact. Since 2026-07-18, a prompt >CLI_ASK_GROK_INLINE_MAX (40KB) is NOT
# inlined — grok's harness truncates big inline --prompt-file payloads (PROVEN: 116KB -> 3/18 files seen).
# Instead the full payload is written to an on-disk grokdata file that grok READS with its own tool
# (PROVEN: 116KB -> all 18/18 files, RC=0). The mock simulates that Read, so a faithful delivery still
# reports the full length. This guards the large-payload path end-to-end.
big=$(head -c 200000 </dev/zero | tr '\0' 'x')
out=$(CLI_ASK_GROK="$MOCKDIR/echo-mock" "$ASK" grok "$big" 2>/dev/null)
len=$(printf '%s' "$out" | sed -n 's/.*len=\([0-9][0-9]*\).*/\1/p')
{ [ -n "$len" ] && [ "$len" -ge 200000 ]; } && ok "P5 200KB prompt intact via grok file-read path (len=$len)" || no "P5 long prompt (len=${len:-none})"
# P5b a SMALL prompt (<40KB) must still deliver INLINE (unchanged single-turn path), not via a data file.
small=$(head -c 5000 </dev/zero | tr '\0' 'y')
out=$(CLI_ASK_GROK="$MOCKDIR/echo-mock" "$ASK" grok "$small" 2>/dev/null)
len=$(printf '%s' "$out" | sed -n 's/.*len=\([0-9][0-9]*\).*/\1/p')
{ [ -n "$len" ] && [ "$len" -ge 5000 ]; } && ok "P5b 5KB prompt intact via inline path (len=$len)" || no "P5b small inline (len=${len:-none})"
# P6 timeout fires, no hang
t0=$SECONDS; CLI_ASK_GROK="$MOCKDIR/slow-mock" "$ASK" grok --timeout 2 --retries 0 "hi" >/dev/null 2>&1; rc=$?; dt=$((SECONDS-t0))
{ [ "$rc" -eq 124 ] && [ "$dt" -lt 12 ]; } && ok "P6 timeout -> exit 124 in ${dt}s (no hang)" || no "P6 timeout (rc=$rc dt=${dt}s)"
# P7 missing binary -> non-zero (not a silent 0)
CLI_ASK_CODEX="/nonexistent/codex" "$ASK" codex --retries 0 "hi" >/dev/null 2>&1; [ $? -ne 0 ] && ok "P7 missing binary -> non-zero" || no "P7 missing binary (silent pass!)"
# P8 empty output (exit 0, 0 bytes) is DETECTED
CLI_ASK_CODEX="$MOCKDIR/empty-mock" "$ASK" codex --retries 0 "hi" >/dev/null 2>&1; [ $? -eq 3 ] && ok "P8 empty output -> exit 3 (not silent pass)" || no "P8 empty detection"
# P9 1-byte output is DETECTED as thin
CLI_ASK_CODEX="$MOCKDIR/onebyte-mock" "$ASK" codex --retries 0 --min-bytes 20 "hi" >/dev/null 2>&1; [ $? -eq 3 ] && ok "P9 1-byte output -> exit 3 (thin)" || no "P9 thin detection"
# P10 real content passes through, exit 0
out=$(CLI_ASK_CODEX="$MOCKDIR/echo-mock" "$ASK" codex --retries 0 "hello world" 2>/dev/null)
printf '%s' "$out" | grep -q MOCK_OK && ok "P10 real content -> exit 0 + passthrough" || no "P10 real content"
# P11 thin-then-retry recovers
rm -f /tmp/cliask_flaky_state
out=$(CLI_ASK_CODEX="$MOCKDIR/flaky-mock" "$ASK" codex --retries 1 "hi" 2>/dev/null)
printf '%s' "$out" | grep -q RECOVERED && ok "P11 thin first try -> retry recovers" || no "P11 retry recovery"
# P12 concurrent calls, no temp-file collision (gate bypassed — testing collision, not throttling)
pids=(); for i in 1 2 3; do (CLI_ASK_GROK="$MOCKDIR/echo-mock" CLI_ASK_NOGATE=1 "$ASK" grok "concurrent-$i" >"$MOCKDIR/c$i.out" 2>/dev/null) & pids+=($!); done
wait "${pids[@]}" 2>/dev/null; n=$(grep -l MOCK_OK "$MOCKDIR"/c*.out 2>/dev/null | wc -l | tr -d ' ')
[ "$n" = 3 ] && ok "P12 3 concurrent calls, no collision" || no "P12 concurrent ($n/3)"
# P13 agy path wiring honours AGY_BIN (mock under agy-ask.py's PTY)
out=$(AGY_BIN="$MOCKDIR/echo-mock" "$ASK" agy --timeout 20 --retries 0 "ping" 2>/dev/null)
printf '%s' "$out" | grep -q MOCK_OK && ok "P13 agy path honours AGY_BIN (PTY mock)" || no "P13 agy wiring"

# P14 (2026-07-25 regression guard): an oversized NON-grok prompt must STAY on the requested engine
# and be delivered via the file-read idiom — it must NOT be silently rerouted to grok. The old
# behaviour swapped the engine behind the caller's back and sent the biggest jobs to grok, which
# since Grok 4.5 has the SMALLEST context (500K) and a 54% hallucination rate. If this test fails,
# someone has reintroduced the cross-engine reroute.
big=$(python3 -c "print('x'*120000)")
err=$(AGY_BIN="$MOCKDIR/echo-mock" "$ASK" agy --timeout 20 --retries 0 "$big" 2>&1 >/dev/null)
if printf '%s' "$err" | grep -q "staying on agy" && ! printf '%s' "$err" | grep -qi "AUTO-ROUTING to grok"; then
  ok "P14 oversized non-grok prompt stays on its engine (no silent grok reroute)"
else
  no "P14 oversized prompt reroute guard (stderr: $(printf '%s' "$err" | tr -d '\n' | head -c 90))"
fi
# P14b the legacy escape hatch still works if anyone needs to fall back
err=$(CLI_ASK_LEGACY_GROK_REROUTE=1 CLI_ASK_GROK="$MOCKDIR/echo-mock" "$ASK" agy --timeout 20 --retries 0 "$big" 2>&1 >/dev/null)
printf '%s' "$err" | grep -q "LEGACY reroute to grok" \
  && ok "P14b CLI_ASK_LEGACY_GROK_REROUTE=1 restores the old behaviour" \
  || no "P14b legacy escape hatch (stderr: $(printf '%s' "$err" | tr -d '\n' | head -c 90))"

if [ "${1:-}" = "--live" ]; then
  echo; echo "=== LIVE smoke (3 real bounded calls, \$0) ==="
  for m in agy codex grok; do
    r=$("$ASK" "$m" --timeout 120 --retries 0 "Reply with exactly this token and nothing else: ${m}_LIVE_OK" 2>/dev/null)
    printf '%s' "$r" | grep -q "${m}_LIVE_OK" && ok "LIVE $m responded with the token" || no "LIVE $m (got: $(printf '%s' "$r" | tr -d '\n' | head -c 70))"
  done
fi

echo; echo "RESULT: $PASS passed, $FAIL failed"; [ "$FAIL" -eq 0 ]
