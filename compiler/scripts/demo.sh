#!/bin/bash
# demo.sh — Demonstrate the full p24p compilation pipeline for one Pascal program
# Shows: source → compile → .spc → link → assemble → run → output
#
# Usage: ./scripts/demo.sh <file.pas>
set -euo pipefail

PAS="${1:?Usage: $0 <file.pas>}"
MAX_INSTRS="${2:-50000000}"

# Tool paths
P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
PL24R="$REPO_DIR/../sw-cor24-pcode/target/release/pl24r"
PA24R="$REPO_DIR/../sw-cor24-pcode/target/release/pa24r"
RUNTIME="$REPO_DIR/runtime/runtime.spc"
PVM="$REPO_DIR/../sw-cor24-pcode/vm/pvm.s"

NAME=$(basename "$PAS" .pas)
TMP="/tmp/p24p_demo_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Resolve code_ptr address dynamically from PVM
CODE_PTR_ADDR=$(cor24-run --run "$PVM" -e code_ptr --speed 0 -n 0 2>&1 | \
  grep "Entry point:" | sed 's/.*@ //')
if [ -z "$CODE_PTR_ADDR" ]; then
  echo "Error: could not resolve code_ptr address from PVM" >&2
  exit 1
fi

echo "════════════════════════════════════════════════════════"
echo "  p24p Pascal Compiler Demo: $NAME"
echo "════════════════════════════════════════════════════════"
echo ""

# --- Show source ---
echo "--- Source: $PAS ---"
cat "$PAS"
echo ""

# --- Step 1: Compile ---
echo "--- Step 1: Compile (.pas -> .spc) ---"
echo "  p24p running on COR24 emulator..."
# Use -u (preloaded UART) instead of --terminal to avoid ~4KB terminal buffer limit
SPC_OUTPUT=$(cor24-run --run "$P24P_S" -u "$(cat "$PAS")"$'\x04' --speed 0 -n 50000000 2>&1 | \
  grep -v '^\[UART' | sed 's/^UART output: //')

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "  FAILED:"
  echo "$SPC_OUTPUT" | grep "error" | sed 's/^/  /'
  exit 1
fi

SPC=$(echo "$SPC_OUTPUT" | sed -n '/^\.module/,/^\.endmodule/p')
echo "$SPC" > "$TMP/$NAME.spc"
INSTRS=$(echo "$SPC_OUTPUT" | grep -oE 'Executed [0-9]+' | grep -oE '[0-9]+')
echo "  OK ($INSTRS COR24 instructions)"
echo ""
echo "$SPC"
echo ""

# --- Step 2: Link ---
echo "--- Step 2: Link with runtime (pl24r) ---"
"$PL24R" "$RUNTIME" "$TMP/$NAME.spc" -o "$TMP/${NAME}_linked.spc" 2>"$TMP/link.log" || true
LINKED_SIZE=$(wc -c < "$TMP/${NAME}_linked.spc" 2>/dev/null || echo 0)
if [ "$LINKED_SIZE" -eq 0 ]; then
  echo "  FAILED:"
  cat "$TMP/link.log" | sed 's/^/  /'
  exit 1
fi
echo "  OK ($LINKED_SIZE bytes linked .spc)"
echo ""

# --- Step 3: Assemble ---
echo "--- Step 3: Assemble (.spc -> .p24 binary, pa24r) ---"
PA24R_OUT=$("$PA24R" "$TMP/${NAME}_linked.spc" -o "$TMP/$NAME.p24" 2>&1) || true
P24_SIZE=$(wc -c < "$TMP/$NAME.p24" 2>/dev/null || echo 0)
echo "  OK ($P24_SIZE bytes .p24 binary)"
echo ""

# --- Step 4: Relocate ---
echo "--- Step 4: Relocate for load address 0x010000 ---"
RELOC_OUT=$(python3 "$REPO_DIR/scripts/relocate_p24.py" "$TMP/$NAME.p24" 0x010000 2>&1)
echo "  $RELOC_OUT"
echo ""

# --- Step 5: Execute ---
echo "--- Step 5: Execute on PVM (pvm.s + cor24-run) ---"
printf '\x00\x00\x01' > "$TMP/code_ptr.bin"
EXEC_OUTPUT=$(cor24-run --run "$PVM" \
  --load-binary "$TMP/$NAME.bin@0x010000" \
  --load-binary "$TMP/code_ptr.bin@${CODE_PTR_ADDR}" \
  --terminal --speed 0 -n "$MAX_INSTRS" 2>&1)

EXEC_INSTRS=$(echo "$EXEC_OUTPUT" | grep -oE 'Executed [0-9]+' | grep -oE '[0-9]+')
HALTED=$(echo "$EXEC_OUTPUT" | grep -c 'CPU halted' || true)
UART=$(echo "$EXEC_OUTPUT" | grep -v '^\[' | grep -v '^Assembled' | grep -v '^Running' | \
  grep -v '^Executed' | grep -v '^Loaded' | grep -v '^PVM OK' | grep -v '^$' | grep -v '^HALT$')

echo ""
echo "--- Output ---"
echo "$UART"
echo ""
echo "--- Stats ---"
echo "  VM instructions: $EXEC_INSTRS"
if [ "$HALTED" -eq 1 ]; then
  echo "  Status: HALT (clean exit)"
else
  echo "  Status: DID NOT HALT"
fi
echo ""
echo "  Pipeline: .pas -> p24p -> .spc -> pl24r -> pa24r -> .p24 -> pvm.s"
echo "════════════════════════════════════════════════════════"
