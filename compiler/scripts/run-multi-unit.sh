#!/bin/bash
# run-multi-unit.sh — Compile and run a multi-unit Pascal program
# Usage: ./scripts/run-multi-unit.sh <main.pas> <unit1.pas> [unit2.pas ...] [-- max_instructions]
#
# Pipeline:
#   1. Compile each unit.pas → .spc + .spi
#   2. Compile main.pas with SPI data prepended → main.spc
#   3. Assemble each .spc → .p24
#   4. Link all .p24 files with p24-load → .p24m
#   5. Run on PVM
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <main.pas> <unit1.pas> [unit2.pas ...] [-- max_instructions]" >&2
  exit 1
fi

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
PA24R="$REPO_DIR/../sw-cor24-pcode/target/release/pa24r"
P24LOAD="$REPO_DIR/../sw-cor24-pcode/target/release/p24-load"
RT_P24="$REPO_DIR/runtime/p24p_rt.p24"
PVM="$REPO_DIR/../sw-cor24-pcode/vm/pvm.s"

MAIN_PAS="$1"
shift

MAX_INSTRS=50000000
UNIT_FILES=()
while [ $# -gt 0 ]; do
  if [ "$1" = "--" ]; then
    shift
    MAX_INSTRS="${1:-50000000}"
    break
  fi
  UNIT_FILES+=("$1")
  shift
done

MAIN_NAME=$(basename "$MAIN_PAS" .pas)
TMP="/tmp/p24p_multi_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Step 1: Compile each unit
SPI_DATA=""
P24_FILES=""
for UNIT_PAS in "${UNIT_FILES[@]}"; do
  UNIT_NAME=$(basename "$UNIT_PAS" .pas)
  bash "$P24P_DIR/scripts/compile-unit.sh" "$UNIT_PAS" "$TMP" 2>/dev/null

  # Collect SPI data for prepending to main
  if [ -f "$TMP/$UNIT_NAME.spi" ]; then
    # Extract the actual unit name from .spi file (.unit <name>)
    SPI_UNIT_NAME=$(grep '^\.unit ' "$TMP/$UNIT_NAME.spi" | head -1 | awk '{print $2}')
    SPI_DATA="${SPI_DATA};--- SPI ${SPI_UNIT_NAME} ---
$(cat "$TMP/$UNIT_NAME.spi")
;--- END SPI ---
"
  fi

  # Assemble unit to .p24
  "$PA24R" "$TMP/$UNIT_NAME.spc" -o "$TMP/$UNIT_NAME.p24" 2>/dev/null
  P24_FILES="$P24_FILES $TMP/$UNIT_NAME.p24"
done

# Step 2: Compile main program with SPI data prepended
MAIN_INPUT="${SPI_DATA}$(cat "$MAIN_PAS")"
SPC_OUTPUT=$(cor24-run --run "$P24P_S" -u "${MAIN_INPUT}"$'\x04' --speed 0 -n 50000000 2>&1 | \
  grep -v '^\[UART' | sed 's/^UART output: //')

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "Compilation failed for $MAIN_PAS:" >&2
  echo "$SPC_OUTPUT" | grep "error" >&2
  exit 1
fi

echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit/p' > "$TMP/$MAIN_NAME.spc"

# Step 3: Assemble main to .p24
"$PA24R" "$TMP/$MAIN_NAME.spc" -o "$TMP/$MAIN_NAME.p24" 2>/dev/null

# Step 4: Link with p24-load (main first, then units, then runtime)
"$P24LOAD" "$TMP/$MAIN_NAME.p24" $P24_FILES "$RT_P24" -o "$TMP/$MAIN_NAME.p24m" 2>/dev/null

# Step 5: Pre-assemble PVM and find code_ptr
PVM_DIR="$(dirname "$PVM")"
(cd "$PVM_DIR" && cor24-run --assemble "$(basename "$PVM")" "$TMP/pvm.bin" "$TMP/pvm.lst" >/dev/null 2>&1)
CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
if [ -z "$CODE_PTR" ]; then
  echo "Error: could not resolve code_ptr from PVM listing" >&2
  exit 1
fi

# Step 6: Run on PVM
cor24-run --load-binary "$TMP/pvm.bin@0" \
  --load-binary "$TMP/$MAIN_NAME.p24m@0x010000" \
  --patch "0x${CODE_PTR}=0x010000" \
  --entry 0 --speed 0 -n "$MAX_INSTRS" --terminal 2>&1 | \
  awk '/^PVM OK$/ { found=1; next } /^HALT$/ { found=0; next } /^TRAP / { print; next } found { print }' | \
  grep -v '^\[' | grep -v '^Assembled' | grep -v '^Running' | \
  grep -v '^Executed' | grep -v '^Loaded' | grep -v '^$'
