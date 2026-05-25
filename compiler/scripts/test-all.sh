#!/bin/bash
# test-all.sh — Run all Pascal test programs and check against expected output
# Regression test suite for the p24p compiler pipeline
#
# Usage: ./scripts/test-all.sh
set -euo pipefail

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
RUNTIME="$REPO_DIR/runtime/runtime.spc"
EXPECTED="$P24P_DIR/tests/expected"

# Resolve PVM (env override or derive from toolchain location)
if [ ! -f "${PVM:-}" ]; then
  PVM="$(dirname "$(command -v cor24-emu)")/../lib/pcode/pvm.s"
fi
[ -f "$PVM" ] || { echo "Error: pvm.s not found — set PVM env var" >&2; exit 1; }

TMP="/tmp/p24p_test_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Pre-assemble compiler and PVM (once for entire test run)
cor24-asm "$P24P_S" --bin "$TMP/p24p.bin"
cor24-asm "$PVM" --bin "$TMP/pvm.bin" --listing "$TMP/pvm.lst"
export P24P_BIN="$TMP/p24p.bin"

CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
if [ -z "$CODE_PTR" ]; then
  echo "Error: could not resolve code_ptr from PVM" >&2
  exit 1
fi

PASS=0
FAIL=0
SKIP=0

for f in "$P24P_DIR"/tests/t*.pas "$P24P_DIR"/tests/hello*.pas "$P24P_DIR"/tests/countdown.pas; do
  [ -f "$f" ] || continue
  # Skip unit-mode tests, unit-declaration files, and multi-unit tests (handled separately below)
  case "$f" in *_unit*|*_multi_*) continue ;; esac
  if head -1 "$f" | grep -qi '^unit '; then continue; fi
  NAME=$(basename "$f" .pas)
  EXPECT="$EXPECTED/${NAME}.txt"

  # Skip if no expected output file
  if [ ! -f "$EXPECT" ]; then
    printf "SKIP %-20s (no expected output)\n" "$NAME"
    SKIP=$((SKIP + 1))
    continue
  fi

  # Step 1: Compile
  SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
    --uart-file "$f" --speed 0 -n 50000000 -q 2>/dev/null)

  if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
    printf "FAIL %-20s (compile error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  echo "$SPC_OUTPUT" | sed -n '/^\.module/,/^\.endmodule/p' > "$TMP/$NAME.spc"

  # Step 2: Link
  if ! pl24r "$RUNTIME" "$TMP/$NAME.spc" -o "$TMP/${NAME}_linked.spc" >/dev/null 2>"$TMP/link.log"; then
    printf "FAIL %-20s (link error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  # Step 3: Assemble
  if ! pa24r "$TMP/${NAME}_linked.spc" -o "$TMP/$NAME.p24" >/dev/null 2>/dev/null; then
    printf "FAIL %-20s (assemble error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  # Step 4: Relocate
  if ! python3 "$REPO_DIR/scripts/relocate_p24.py" "$TMP/$NAME.p24" 0x010000 >/dev/null 2>/dev/null; then
    printf "FAIL %-20s (relocate error)\n" "$NAME"
    FAIL=$((FAIL + 1))
    continue
  fi

  # Step 5: Execute (with optional UART input from .input file)
  INPUT_FILE="$P24P_DIR/tests/expected/${NAME}.input"
  if [ -f "$INPUT_FILE" ]; then
    ACTUAL=$(cor24-emu --load-binary "$TMP/pvm.bin@0" \
      --load-binary "$TMP/$NAME.bin@0x010000" \
      --patch "0x${CODE_PTR}=0x010000" \
      --entry 0 --speed 0 -n 50000000 -u "$(cat "$INPUT_FILE")"$'\x04' -q 2>"$TMP/exec.log" | \
      sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d')
  else
    ACTUAL=$(cor24-emu --load-binary "$TMP/pvm.bin@0" \
      --load-binary "$TMP/$NAME.bin@0x010000" \
      --patch "0x${CODE_PTR}=0x010000" \
      --entry 0 --speed 0 -n 50000000 --terminal -q 2>"$TMP/exec.log" | \
      sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d')
  fi

  HALTED=$(grep -c 'CPU halted' "$TMP/exec.log" || true)

  # Compare
  echo "$ACTUAL" > "$TMP/${NAME}_actual.txt"
  if diff -q "$EXPECT" "$TMP/${NAME}_actual.txt" > /dev/null 2>&1; then
    if [ "$HALTED" -ge 1 ]; then
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

# Unit-declaration compile-only tests (files that start with 'unit' keyword)
for f in "$P24P_DIR"/tests/t*.pas; do
  [ -f "$f" ] || continue
  if ! head -1 "$f" | grep -qi '^unit '; then
    continue
  fi
  NAME=$(basename "$f" .pas)

  SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
    --uart-file "$f" --speed 0 -n 50000000 -q 2>/dev/null)

  if echo "$SPC_OUTPUT" | grep -q "; OK"; then
    printf "PASS %-20s (unit decl)\n" "$NAME"
    PASS=$((PASS + 1))
  else
    printf "FAIL %-20s (unit decl compile error)\n" "$NAME"
    echo "$SPC_OUTPUT" | grep "error" | head -5 | sed 's/^/     /'
    FAIL=$((FAIL + 1))
  fi
done

# Multi-unit tests (files matching *_multi_*.pas)
MULTI_SCRIPT="$P24P_DIR/scripts/run-multi-unit.sh"
for f in "$P24P_DIR"/tests/*_multi_*.pas; do
  [ -f "$f" ] || continue
  NAME=$(basename "$f" .pas)
  EXPECT="$EXPECTED/${NAME}.txt"

  if [ ! -f "$EXPECT" ]; then
    printf "SKIP %-20s (multi-unit, no expected output)\n" "$NAME"
    SKIP=$((SKIP + 1))
    continue
  fi

  # Find unit dependencies: look for matching t<num>_<unitname>.pas files
  PREFIX=$(echo "$NAME" | sed 's/_multi_.*//')
  UNIT_FILES=()
  for uf in "$P24P_DIR"/tests/${PREFIX}_*.pas; do
    [ -f "$uf" ] || continue
    if head -1 "$uf" | grep -qi '^unit '; then
      UNIT_FILES+=("$uf")
    fi
  done

  if [ ${#UNIT_FILES[@]} -eq 0 ]; then
    printf "SKIP %-20s (multi-unit, no unit files found)\n" "$NAME"
    SKIP=$((SKIP + 1))
    continue
  fi

  ACTUAL=$(bash "$MULTI_SCRIPT" "$f" "${UNIT_FILES[@]}" 2>&1) || true

  echo "$ACTUAL" > "$TMP/${NAME}_actual.txt"
  if diff -q "$EXPECT" "$TMP/${NAME}_actual.txt" > /dev/null 2>&1; then
    printf "PASS %-20s (multi-unit)\n" "$NAME"
    PASS=$((PASS + 1))
  else
    printf "FAIL %-20s (multi-unit, output mismatch)\n" "$NAME"
    diff "$EXPECT" "$TMP/${NAME}_actual.txt" | head -10 | sed 's/^/     /'
    FAIL=$((FAIL + 1))
  fi
done

# Unit-mode tests (files matching *_unit*.pas, compiled via unit pipeline)
UNIT_SCRIPT="$P24P_DIR/scripts/run-pascal-unit.sh"
for f in "$P24P_DIR"/tests/*_unit*.pas; do
  [ -f "$f" ] || continue
  if head -1 "$f" | grep -qi '^unit '; then continue; fi
  NAME=$(basename "$f" .pas)
  EXPECT="$EXPECTED/${NAME}.txt"

  if [ ! -f "$EXPECT" ]; then
    printf "SKIP %-20s (no expected output)\n" "$NAME"
    SKIP=$((SKIP + 1))
    continue
  fi

  INPUT_FILE="$EXPECTED/${NAME}.input"
  if [ -f "$INPUT_FILE" ]; then
    ACTUAL=$(bash "$UNIT_SCRIPT" "$f" 50000000 "$INPUT_FILE" 2>&1)
  else
    ACTUAL=$(bash "$UNIT_SCRIPT" "$f" 50000000 2>&1)
  fi

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
