#!/bin/bash
# run-pascal-unit.sh — Compile and run a Pascal program using multi-unit pipeline
# Usage: ./scripts/run-pascal-unit.sh <file.pas> [max_instructions]
#
# Pipeline: .pas → p24p (unit mode) → .spc → pa24r → user.p24
#           p24-load user.p24 p24p_rt.p24 → image.p24m
#           pvm.s loads image.p24m
set -euo pipefail

PAS="${1:?Usage: $0 <file.pas> [max_instructions]}"
MAX_INSTRS="${2:-50000000}"

# Tool paths
P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
PA24R="$REPO_DIR/../sw-cor24-pcode/target/release/pa24r"
P24LOAD="$REPO_DIR/../sw-cor24-pcode/target/release/p24-load"
RT_P24="$REPO_DIR/runtime/p24p_rt.p24"
PVM="$REPO_DIR/../sw-cor24-pcode/vm/pvm.s"

NAME=$(basename "$PAS" .pas)
TMP="/tmp/p24p_unit_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Step 1: Compile Pascal to .spc (unit mode — source must have 'uses units')
SPC_OUTPUT=$(cor24-run --run "$P24P_S" -u "$(cat "$PAS")"$'\x04' --speed 0 -n 50000000 2>&1 | \
  grep -v '^\[UART' | sed 's/^UART output: //')

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "Compilation failed:" >&2
  echo "$SPC_OUTPUT" | grep "error" >&2
  exit 1
fi

echo "$SPC_OUTPUT" | sed -n '/^\.unit/,/^\.endunit/p' > "$TMP/$NAME.spc"

# Step 2: Assemble user unit to .p24 (v2)
"$PA24R" "$TMP/$NAME.spc" -o "$TMP/$NAME.p24" 2>/dev/null

# Step 3: Link units with p24-load (user first = entry, runtime second)
"$P24LOAD" "$TMP/$NAME.p24" "$RT_P24" -o "$TMP/$NAME.p24m" 2>/dev/null

# Step 4: Pre-assemble PVM and find code_ptr (must run from vm/ dir for includes)
PVM_DIR="$(dirname "$PVM")"
(cd "$PVM_DIR" && cor24-run --assemble "$(basename "$PVM")" "$TMP/pvm.bin" "$TMP/pvm.lst" >/dev/null 2>&1)
CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
if [ -z "$CODE_PTR" ]; then
  echo "Error: could not resolve code_ptr from PVM listing" >&2
  exit 1
fi

# Step 5: Run on PVM
cor24-run --load-binary "$TMP/pvm.bin@0" \
  --load-binary "$TMP/$NAME.p24m@0x010000" \
  --patch "0x${CODE_PTR}=0x010000" \
  --entry 0 --speed 0 -n "$MAX_INSTRS" --terminal 2>&1 | \
  awk '/^PVM OK$/ { found=1; next } /^HALT$/ { found=0; next } /^TRAP / { print; next } found { print }' | \
  grep -v '^\[' | grep -v '^Assembled' | grep -v '^Running' | \
  grep -v '^Executed' | grep -v '^Loaded' | grep -v '^$'
