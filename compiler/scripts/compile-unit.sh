#!/bin/bash
# compile-unit.sh — Compile a Pascal unit to .spc and .spi
# Usage: ./scripts/compile-unit.sh <unit.pas> <output_dir>
#
# Outputs: <output_dir>/<name>.spc and <output_dir>/<name>.spi
set -euo pipefail

PAS="${1:?Usage: $0 <unit.pas> <output_dir>}"
OUTDIR="${2:?Usage: $0 <unit.pas> <output_dir>}"

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
NAME=$(basename "$PAS" .pas)

mkdir -p "$OUTDIR"

# Use pre-assembled compiler if available, otherwise assemble now
if [ -n "${P24P_BIN:-}" ] && [ -f "$P24P_BIN" ]; then
  _p24p_bin="$P24P_BIN"
else
  cor24-asm "$P24P_S" --bin "$OUTDIR/p24p.bin"
  _p24p_bin="$OUTDIR/p24p.bin"
fi

# Compile unit
SPC_OUTPUT=$(cor24-emu --load-binary "$_p24p_bin@0" --entry 0 \
  --uart-file "$PAS" --speed 0 -n 50000000 -q 2>/dev/null)

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "Compilation failed for $PAS:" >&2
  echo "$SPC_OUTPUT" | grep "error" >&2
  exit 1
fi

# Extract .spc (between first .unit and .endunit, stop at .endunit)
echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit$/p' | sed '/^\.endunit$/q' > "$OUTDIR/$NAME.spc"

# Extract .spi (between SPI markers)
if echo "$SPC_OUTPUT" | grep -q '^;--- SPI ---'; then
  echo "$SPC_OUTPUT" | sed -n '/^;--- SPI ---$/,/^;--- END SPI ---$/p' | \
    grep -v '^;---' > "$OUTDIR/$NAME.spi"
fi

echo "Compiled: $OUTDIR/$NAME.spc + $OUTDIR/$NAME.spi" >&2
