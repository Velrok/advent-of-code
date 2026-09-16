#!/usr/bin/env bash
# Manual CLI regression checks for the intcode-vm binary.
# Mirrors the scenarios covered by src/intcode.rs unit tests, but driven
# through the CLI (program file + stdin inputs + noun/verb args).
set -euo pipefail

cd "$(dirname "$0")/.."
cargo build --bin intcode-vm --quiet
BIN=./target/debug/intcode-vm
DIR="$(cd "$(dirname "$0")" && pwd)"

failures=0

check() {
  local desc="$1" expected="$2" stdin="$3"
  shift 3
  local actual
  actual=$(printf '%s' "$stdin" | "$BIN" "$@" 2>/dev/null)
  if [ "$actual" = "$expected" ]; then
    printf '%-45s expected=%-6s actual=%-6s OK\n' "$desc" "$expected" "$actual"
  else
    printf '%-45s expected=%-6s actual=%-6s MISMATCH\n' "$desc" "$expected" "$actual"
    failures=$((failures + 1))
  fi
}

check "add pos (noun=5 verb=6)"        5    ""  "$DIR/add_pos.ic" 5 6
check "mult pos (noun=5 verb=6)"       6    ""  "$DIR/mult_pos.ic" 5 6
check "add imm (noun=5 verb=6)"        11   ""  "$DIR/add_imm.ic" 5 6
check "mult imm (noun=5 verb=6)"       30   ""  "$DIR/mult_imm.ic" 5 6
check "jump_true no-jump (noun=0)"     10   ""  "$DIR/jump_true.ic" 0
check "jump_true jump (noun=1)"        1105 ""  "$DIR/jump_true.ic" 1
check "jump_false jump (noun=0)"       1106 ""  "$DIR/jump_false.ic" 0
check "jump_false no-jump (noun=1)"    10   ""  "$DIR/jump_false.ic" 1
check "less_then true (3<4)"           1    ""  "$DIR/less_then.ic" 3 4
check "less_then false (5<4)"          0    ""  "$DIR/less_then.ic" 5 4
check "equals true (3==3)"             1    ""  "$DIR/equals.ic" 3 3
check "equals false (5==4)"            0    ""  "$DIR/equals.ic" 5 4
check "io echo (input=7, stdout mem0)" 3    "7" "$DIR/io.ic"

if [ "$failures" -gt 0 ]; then
  echo "$failures check(s) failed"
  exit 1
fi
echo "All checks passed"
