#!/bin/bash
# test-all.sh — Run all Pascal test programs and check against expected output
# Regression test suite for the p24p compiler pipeline
#
# Usage: ./scripts/test-all.sh
set -euo pipefail

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
PL24R="$REPO_DIR/../sw-cor24-pcode/target/release/pl24r"
PA24R="$REPO_DIR/../sw-cor24-pcode/target/release/pa24r"
RUNTIME="$REPO_DIR/runtime/runtime.spc"
PVM="$REPO_DIR/../sw-cor24-pcode/vm/pvm.s"
EXPECTED="$P24P_DIR/tests/expected"

TMP="/tmp/p24p_test_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Resolve code_ptr address dynamically from PVM
CODE_PTR_ADDR=$(cor24-run --run "$PVM" -e code_ptr --speed 0 -n 0 2>&1 | \
  grep "Entry point:" | sed 's/.*@ //')
if [ -z "$CODE_PTR_ADDR" ]; then
  echo "Error: could not resolve code_ptr address from PVM" >&2
  exit 1
fi

PASS=0
FAIL=0
SKIP=0

printf '\x00\x00\x01' > "$TMP/code_ptr.bin"

for f in "$P24P_DIR"/tests/t*.pas "$P24P_DIR"/tests/hello*.pas "$P24P_DIR"/tests/countdown.pas; do
  [ -f "$f" ] || continue
  # Skip unit-mode tests (handled separately below)
  case "$f" in *_unit*) continue ;; esac
  NAME=$(basename "$f" .pas)
  EXPECT="$EXPECTED/${NAME}.txt"

  # Skip if no expected output file
  if [ ! -f "$EXPECT" ]; then
    printf "SKIP %-20s (no expected output)\n" "$NAME"
    SKIP=$((SKIP + 1))
    continue
  fi

  # Step 1: Compile
  # Use -u (preloaded UART) instead of --terminal to avoid ~4KB terminal buffer limit
  SPC_OUTPUT=$(cor24-run --run "$P24P_S" -u "$(cat "$f")"$'\x04' --speed 0 -n 50000000 2>&1 | \
    grep -v '^\[UART' | sed 's/^UART output: //')

  if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
    printf "FAIL %-20s (compile error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  echo "$SPC_OUTPUT" | sed -n '/^\.module/,/^\.endmodule/p' > "$TMP/$NAME.spc"

  # Step 2: Link
  if ! "$PL24R" "$RUNTIME" "$TMP/$NAME.spc" -o "$TMP/${NAME}_linked.spc" 2>"$TMP/link.log"; then
    printf "FAIL %-20s (link error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  # Step 3: Assemble
  if ! "$PA24R" "$TMP/${NAME}_linked.spc" -o "$TMP/$NAME.p24" 2>/dev/null; then
    printf "FAIL %-20s (assemble error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  # Step 4: Relocate
  if ! python3 "$REPO_DIR/scripts/relocate_p24.py" "$TMP/$NAME.p24" 0x010000 2>/dev/null; then
    printf "FAIL %-20s (relocate error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  # Step 5: Execute (with optional UART input from .input file)
  INPUT_FILE="$P24P_DIR/tests/expected/${NAME}.input"
  if [ -f "$INPUT_FILE" ]; then
    EXEC_OUTPUT=$(cor24-run --run "$PVM" \
      --load-binary "$TMP/$NAME.bin@0x010000" \
      --load-binary "$TMP/code_ptr.bin@${CODE_PTR_ADDR}" \
      -u "$(cat "$INPUT_FILE")" --speed 0 -n 50000000 2>&1)
  else
    EXEC_OUTPUT=$(cor24-run --run "$PVM" \
      --load-binary "$TMP/$NAME.bin@0x010000" \
      --load-binary "$TMP/code_ptr.bin@${CODE_PTR_ADDR}" \
      --terminal --speed 0 -n 50000000 2>&1)
  fi

  ACTUAL=$(echo "$EXEC_OUTPUT" | grep -v '^\[' | grep -v '^Assembled' | grep -v '^Running' | \
    grep -v '^Executed' | grep -v '^Loaded' | grep -v 'PVM OK' | grep -v '^$' | \
    grep -v '^HALT$' | grep -v '^CPU halted')

  HALTED=$(echo "$EXEC_OUTPUT" | grep -c 'CPU halted' || true)

  # Compare
  echo "$ACTUAL" > "$TMP/${NAME}_actual.txt"
  if diff -q "$EXPECT" "$TMP/${NAME}_actual.txt" > /dev/null 2>&1; then
    if [ "$HALTED" -eq 1 ]; then
      printf "PASS %-20s\n" "$NAME"
      PASS=$((PASS + 1))
    else
      printf "FAIL %-20s (correct output but did not halt)\n" "$NAME"
      FAIL=$((FAIL + 1))
    fi
  else
    printf "FAIL %-20s (output mismatch)\n" "$NAME"
    diff "$EXPECT" "$TMP/${NAME}_actual.txt" | head -10 | sed 's/^/     /'
    FAIL=$((FAIL + 1))
  fi
done

# Unit-mode tests (files matching *_unit*.pas, compiled via unit pipeline)
UNIT_SCRIPT="$P24P_DIR/scripts/run-pascal-unit.sh"
for f in "$P24P_DIR"/tests/*_unit*.pas; do
  [ -f "$f" ] || continue
  NAME=$(basename "$f" .pas)
  EXPECT="$EXPECTED/${NAME}.txt"

  if [ ! -f "$EXPECT" ]; then
    printf "SKIP %-20s (no expected output)\n" "$NAME"
    SKIP=$((SKIP + 1))
    continue
  fi

  ACTUAL=$(bash "$UNIT_SCRIPT" "$f" 50000000 2>&1)

  echo "$ACTUAL" > "$TMP/${NAME}_actual.txt"
  if diff -q "$EXPECT" "$TMP/${NAME}_actual.txt" > /dev/null 2>&1; then
    printf "PASS %-20s (unit)\n" "$NAME"
    PASS=$((PASS + 1))
  else
    printf "FAIL %-20s (unit, output mismatch)\n" "$NAME"
    diff "$EXPECT" "$TMP/${NAME}_actual.txt" | head -10 | sed 's/^/     /'
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "═══════════════════════════════════"
TOTAL=$((PASS + FAIL + SKIP))
echo "  $PASS passed, $FAIL failed, $SKIP skipped ($TOTAL total)"
if [ "$FAIL" -eq 0 ]; then
  echo "  ALL PASS"
else
  echo "  FAILURES DETECTED"
  exit 1
fi
echo "═══════════════════════════════════"
