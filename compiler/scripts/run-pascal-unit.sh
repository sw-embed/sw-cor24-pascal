#!/bin/bash
# run-pascal-unit.sh — Compile and run a Pascal program using multi-unit pipeline
# Usage: ./scripts/run-pascal-unit.sh <file.pas> [max_instructions] [input_file]
#
# Pipeline: .pas → p24p (unit mode) → .spc → pa24r → user.p24
#           p24-load user.p24 p24p_rt.p24 → image.p24m
#           pvm loads image.p24m
set -euo pipefail

PAS="${1:?Usage: $0 <file.pas> [max_instructions] [input_file]}"
MAX_INSTRS="${2:-50000000}"
INPUT_FILE="${3:-}"

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
RT_P24="$REPO_DIR/runtime/p24p_rt.p24"

# Resolve PVM (env override or derive from toolchain location)
if [ ! -f "${PVM:-}" ]; then
  PVM="$(dirname "$(command -v cor24-emu)")/../lib/pcode/pvm.s"
fi
[ -f "$PVM" ] || { echo "Error: pvm.s not found — set PVM env var" >&2; exit 1; }

NAME=$(basename "$PAS" .pas)
TMP="/tmp/p24p_unit_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Pre-assemble compiler and PVM
if [ -n "${P24P_BIN:-}" ] && [ -f "$P24P_BIN" ]; then
  cp "$P24P_BIN" "$TMP/p24p.bin"
else
  cor24-asm "$P24P_S" --bin "$TMP/p24p.bin"
fi
cor24-asm "$PVM" --bin "$TMP/pvm.bin" --listing "$TMP/pvm.lst"

CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
[ -n "$CODE_PTR" ] || { echo "Error: could not resolve code_ptr from PVM" >&2; exit 1; }

# Step 1: Compile Pascal to .spc (unit mode — source must have 'uses units')
SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
  --uart-file "$PAS" --speed 0 -n 50000000 -q 2>/dev/null)

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "Compilation failed:" >&2
  echo "$SPC_OUTPUT" | grep "error" >&2
  exit 1
fi

echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit/p' > "$TMP/$NAME.spc"

# Extract .spi interface file if present (for unit compilations)
if echo "$SPC_OUTPUT" | grep -q '^;--- SPI ---'; then
  echo "$SPC_OUTPUT" | sed -n '/^;--- SPI ---$/,/^;--- END SPI ---$/p' | \
    grep -v '^;---' > "$TMP/$NAME.spi"
fi

# Step 2: Assemble user unit to .p24
pa24r "$TMP/$NAME.spc" -o "$TMP/$NAME.p24" >/dev/null 2>/dev/null

# Step 3: Link units with p24-load (user first = entry, runtime second)
p24-load --load-addr 0x010000 "$TMP/$NAME.p24" "$RT_P24" -o "$TMP/$NAME.p24m" 2>/dev/null

# Step 4: Run on PVM
if [ -n "$INPUT_FILE" ] && [ -f "$INPUT_FILE" ]; then
  cor24-emu --load-binary "$TMP/pvm.bin@0" \
    --load-binary "$TMP/$NAME.p24m@0x010000" \
    --patch "0x${CODE_PTR}=0x010000" \
    --entry 0 --speed 0 -n "$MAX_INSTRS" -u "$(cat "$INPUT_FILE")"$'\x04' -q 2>/dev/null | \
    sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d'
else
  cor24-emu --load-binary "$TMP/pvm.bin@0" \
    --load-binary "$TMP/$NAME.p24m@0x010000" \
    --patch "0x${CODE_PTR}=0x010000" \
    --entry 0 --speed 0 -n "$MAX_INSTRS" --terminal -q 2>/dev/null | \
    sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d'
fi
