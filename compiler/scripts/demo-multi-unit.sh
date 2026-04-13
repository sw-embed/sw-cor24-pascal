#!/bin/bash
# demo-multi-unit.sh — Demonstrate multi-unit Pascal compilation
# Shows each step of compiling units, importing them, and linking.
set -euo pipefail

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
DEMO_DIR="$P24P_DIR/tests/demo_multi_unit"

echo "═══════════════════════════════════════════════"
echo "  Multi-Unit Pascal Compilation Demo"
echo "═══════════════════════════════════════════════"
echo ""

# Step 1: Show the source files
echo "── Unit: MathLib ──────────────────────────────"
cat "$DEMO_DIR/mathlib.pas"
echo ""

echo "── Unit: StrUtils ─────────────────────────────"
cat "$DEMO_DIR/strutils.pas"
echo ""

echo "── Main Program ───────────────────────────────"
cat "$DEMO_DIR/main.pas"
echo ""

# Step 2: Compile each unit
echo "═══════════════════════════════════════════════"
echo "  Step 1: Compile units"
echo "═══════════════════════════════════════════════"

TMP="/tmp/p24p_demo_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

for UNIT_PAS in "$DEMO_DIR/mathlib.pas" "$DEMO_DIR/strutils.pas"; do
  UNIT_NAME=$(basename "$UNIT_PAS" .pas)
  echo ""
  echo ">>> Compiling unit: $UNIT_NAME"

  SPC_OUTPUT=$(cor24-run --run "$P24P_S" -u "$(cat "$UNIT_PAS")"$'\x04' --speed 0 -n 50000000 2>&1 | \
    grep -v '^\[UART' | sed 's/^UART output: //')

  if echo "$SPC_OUTPUT" | grep -q "; OK"; then
    echo "    OK"
    # Extract .spc and .spi
    echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit$/p' | sed '/^\.endunit$/q' > "$TMP/$UNIT_NAME.spc"
    echo "$SPC_OUTPUT" | sed -n '/^;--- SPI ---$/,/^;--- END SPI ---$/p' | grep -v '^;---' > "$TMP/$UNIT_NAME.spi"
    echo "    Generated: $UNIT_NAME.spc ($( wc -l < "$TMP/$UNIT_NAME.spc" | tr -d ' ') lines)"
    echo "    Generated: $UNIT_NAME.spi"
    echo "    Exports:"
    grep '\.export' "$TMP/$UNIT_NAME.spi" | sed 's/^/      /'
  else
    echo "    COMPILE ERROR"
    echo "$SPC_OUTPUT" | grep "error"
    exit 1
  fi
done

# Step 3: Compile main program with SPI data
echo ""
echo "═══════════════════════════════════════════════"
echo "  Step 2: Compile main program (with SPI data)"
echo "═══════════════════════════════════════════════"

SPI_DATA=""
for SPI_FILE in "$TMP"/*.spi; do
  [ -f "$SPI_FILE" ] || continue
  SPI_UNIT_NAME=$(grep '^\.unit ' "$SPI_FILE" | head -1 | awk '{print $2}')
  SPI_DATA="${SPI_DATA};--- SPI ${SPI_UNIT_NAME} ---
$(cat "$SPI_FILE")
;--- END SPI ---
"
done

MAIN_INPUT="${SPI_DATA}$(cat "$DEMO_DIR/main.pas")"
echo ""
echo ">>> Compiling: main.pas (imports: mathlib, strutils)"
SPC_OUTPUT=$(cor24-run --run "$P24P_S" -u "${MAIN_INPUT}"$'\x04' --speed 0 -n 50000000 2>&1 | \
  grep -v '^\[UART' | sed 's/^UART output: //')

if echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "    OK"
  echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit$/p' > "$TMP/main.spc"
  echo ""
  echo "── Generated main.spc ───────────────────────"
  cat "$TMP/main.spc"
else
  echo "    COMPILE ERROR"
  echo "$SPC_OUTPUT" | grep "error"
  exit 1
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "  Step 3: Assembly & Linking (blocked)"
echo "═══════════════════════════════════════════════"
echo ""
echo "  Assembly and linking of multi-unit programs is"
echo "  blocked on pcode toolchain issues:"
echo "    - sw-embed/sw-cor24-pcode#7: pa24r requires main in units"
echo "    - sw-embed/sw-cor24-pcode#8: p24-load import resolution"
echo ""
echo "  Once those are fixed, the pipeline completes:"
echo "    pa24r mathlib.spc -o mathlib.p24"
echo "    pa24r strutils.spc -o strutils.p24"
echo "    pa24r main.spc -o main.p24"
echo "    p24-load main.p24 mathlib.p24 strutils.p24 p24p_rt.p24 -o demo.p24m"
echo "    pvm demo.p24m"
echo ""
echo "═══════════════════════════════════════════════"
