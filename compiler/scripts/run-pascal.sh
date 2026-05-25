#!/bin/bash
# run-pascal.sh — Compile and run a Pascal program through the full p24p toolchain
# Usage: ./scripts/run-pascal.sh <file.pas> [max_instructions]
#
# Pipeline: .pas → p24p → .spc → pl24r → pa24r → .p24 → pvm
set -euo pipefail

PAS="${1:?Usage: $0 <file.pas> [max_instructions]}"
MAX_INSTRS="${2:-50000000}"

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
RUNTIME="$REPO_DIR/runtime/runtime.spc"

# Resolve PVM (env override or derive from toolchain location)
if [ ! -f "${PVM:-}" ]; then
  PVM="$(dirname "$(command -v cor24-emu)")/../lib/pcode/pvm.s"
fi
[ -f "$PVM" ] || { echo "Error: pvm.s not found — set PVM env var" >&2; exit 1; }

NAME=$(basename "$PAS" .pas)
TMP="/tmp/p24p_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Pre-assemble compiler and PVM
cor24-asm "$P24P_S" --bin "$TMP/p24p.bin"
cor24-asm "$PVM" --bin "$TMP/pvm.bin" --listing "$TMP/pvm.lst"

CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
[ -n "$CODE_PTR" ] || { echo "Error: could not resolve code_ptr from PVM" >&2; exit 1; }

# Step 1: Compile Pascal to .spc
SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
  --uart-file "$PAS" --speed 0 -n "$MAX_INSTRS" -q 2>/dev/null)

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "Compilation failed:" >&2
  echo "$SPC_OUTPUT" | grep "error" >&2
  exit 1
fi

echo "$SPC_OUTPUT" | sed -n '/^\.module/,/^\.endmodule/p' > "$TMP/$NAME.spc"

# Step 2: Link with runtime
pl24r "$RUNTIME" "$TMP/$NAME.spc" -o "$TMP/${NAME}_linked.spc" >/dev/null 2>/dev/null

# Step 3: Assemble to .p24
pa24r "$TMP/${NAME}_linked.spc" -o "$TMP/$NAME.p24" >/dev/null 2>/dev/null

# Step 4: Relocate for load address 0x010000
python3 "$REPO_DIR/scripts/relocate_p24.py" "$TMP/$NAME.p24" 0x010000 >/dev/null

# Step 5: Run on PVM
cor24-emu --load-binary "$TMP/pvm.bin@0" \
  --load-binary "$TMP/$NAME.bin@0x010000" \
  --patch "0x${CODE_PTR}=0x010000" \
  --entry 0 --terminal --speed 0 -n "$MAX_INSTRS" -q 2>/dev/null | \
  sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d'
