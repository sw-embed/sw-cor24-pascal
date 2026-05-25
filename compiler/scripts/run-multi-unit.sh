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
RT_P24="$REPO_DIR/runtime/p24p_rt.p24"

# Resolve PVM (env override or derive from toolchain location)
if [ ! -f "${PVM:-}" ]; then
  PVM="$(dirname "$(command -v cor24-emu)")/../lib/pcode/pvm.s"
fi
[ -f "$PVM" ] || { echo "Error: pvm.s not found — set PVM env var" >&2; exit 1; }

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

# Pre-assemble compiler and PVM
cor24-asm "$P24P_S" --bin "$TMP/p24p.bin"
export P24P_BIN="$TMP/p24p.bin"
cor24-asm "$PVM" --bin "$TMP/pvm.bin" --listing "$TMP/pvm.lst"

CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
[ -n "$CODE_PTR" ] || { echo "Error: could not resolve code_ptr from PVM" >&2; exit 1; }

# Step 1: Compile each unit
SPI_DATA=""
P24_FILES=""
for UNIT_PAS in "${UNIT_FILES[@]}"; do
  UNIT_NAME=$(basename "$UNIT_PAS" .pas)
  bash "$P24P_DIR/scripts/compile-unit.sh" "$UNIT_PAS" "$TMP" 2>/dev/null

  # Collect SPI data for prepending to main
  if [ -f "$TMP/$UNIT_NAME.spi" ]; then
    SPI_UNIT_NAME=$(grep '^\.unit ' "$TMP/$UNIT_NAME.spi" | head -1 | awk '{print $2}')
    SPI_DATA="${SPI_DATA};--- SPI ${SPI_UNIT_NAME} ---
$(cat "$TMP/$UNIT_NAME.spi")
;--- END SPI ---
"
  fi

  # Assemble unit to .p24
  pa24r "$TMP/$UNIT_NAME.spc" -o "$TMP/$UNIT_NAME.p24" >/dev/null 2>/dev/null
  P24_FILES="$P24_FILES $TMP/$UNIT_NAME.p24"
done

# Step 2: Compile main program with SPI data prepended (write to temp file for --uart-file)
echo "${SPI_DATA}$(cat "$MAIN_PAS")" > "$TMP/main_input.pas"
SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
  --uart-file "$TMP/main_input.pas" --speed 0 -n 50000000 -q 2>/dev/null)

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "Compilation failed for $MAIN_PAS:" >&2
  echo "$SPC_OUTPUT" | grep "error" >&2
  exit 1
fi

echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit/p' > "$TMP/$MAIN_NAME.spc"

# Step 3: Assemble main to .p24
pa24r "$TMP/$MAIN_NAME.spc" -o "$TMP/$MAIN_NAME.p24" >/dev/null 2>/dev/null

# Step 4: Link with p24-load (main first, then units, then runtime)
p24-load --load-addr 0x010000 "$TMP/$MAIN_NAME.p24" $P24_FILES "$RT_P24" -o "$TMP/$MAIN_NAME.p24m" 2>/dev/null

# Step 5: Run on PVM
cor24-emu --load-binary "$TMP/pvm.bin@0" \
  --load-binary "$TMP/$MAIN_NAME.p24m@0x010000" \
  --patch "0x${CODE_PTR}=0x010000" \
  --entry 0 --speed 0 -n "$MAX_INSTRS" --terminal -q 2>/dev/null | \
  sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d'
