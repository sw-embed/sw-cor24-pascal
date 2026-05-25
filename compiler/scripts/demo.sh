#!/bin/bash
# demo.sh — Demonstrate the full p24p compilation pipeline for one Pascal program
# Shows: source → compile → .spc → link → assemble → run → output
#
# Usage: ./scripts/demo.sh <file.pas>
set -euo pipefail

PAS="${1:?Usage: $0 <file.pas>}"
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
TMP="/tmp/p24p_demo_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Pre-assemble compiler and PVM
cor24-asm "$P24P_S" --bin "$TMP/p24p.bin"
cor24-asm "$PVM" --bin "$TMP/pvm.bin" --listing "$TMP/pvm.lst"

CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
[ -n "$CODE_PTR" ] || { echo "Error: could not resolve code_ptr from PVM" >&2; exit 1; }

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
SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
  --uart-file "$PAS" --speed 0 -n 50000000 -q 2>"$TMP/compile.log")

if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
  echo "  FAILED:"
  echo "$SPC_OUTPUT" | grep "error" | sed 's/^/  /'
  exit 1
fi

SPC=$(echo "$SPC_OUTPUT" | sed -n '/^\.module/,/^\.endmodule/p')
echo "$SPC" > "$TMP/$NAME.spc"
INSTRS=$(grep -oE 'Executed [0-9]+' "$TMP/compile.log" | grep -oE '[0-9]+' || echo "?")
echo "  OK ($INSTRS COR24 instructions)"
echo ""
echo "$SPC"
echo ""

# --- Step 2: Link ---
echo "--- Step 2: Link with runtime (pl24r) ---"
pl24r "$RUNTIME" "$TMP/$NAME.spc" -o "$TMP/${NAME}_linked.spc" >/dev/null 2>"$TMP/link.log" || true
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
pa24r "$TMP/${NAME}_linked.spc" -o "$TMP/$NAME.p24" >/dev/null 2>&1 || true
P24_SIZE=$(wc -c < "$TMP/$NAME.p24" 2>/dev/null || echo 0)
echo "  OK ($P24_SIZE bytes .p24 binary)"
echo ""

# --- Step 4: Relocate ---
echo "--- Step 4: Relocate for load address 0x010000 ---"
RELOC_OUT=$(python3 "$REPO_DIR/scripts/relocate_p24.py" "$TMP/$NAME.p24" 0x010000 2>&1)
echo "  $RELOC_OUT"
echo ""

# --- Step 5: Execute ---
echo "--- Step 5: Execute on PVM (pvm.s + cor24-emu) ---"
UART=$(cor24-emu --load-binary "$TMP/pvm.bin@0" \
  --load-binary "$TMP/$NAME.bin@0x010000" \
  --patch "0x${CODE_PTR}=0x010000" \
  --entry 0 --terminal --speed 0 -n "$MAX_INSTRS" -q 2>"$TMP/exec.log" | \
  sed '/^PVM OK$/d;/^Entry point:/d;/^HALT$/d;/^$/d')

EXEC_INSTRS=$(grep -oE 'Executed [0-9]+' "$TMP/exec.log" | grep -oE '[0-9]+' || echo "?")
HALTED=$(grep -c 'CPU halted' "$TMP/exec.log" || true)

echo ""
echo "--- Output ---"
echo "$UART"
echo ""
echo "--- Stats ---"
echo "  VM instructions: $EXEC_INSTRS"
if [ "$HALTED" -ge 1 ]; then
  echo "  Status: HALT (clean exit)"
else
  echo "  Status: DID NOT HALT"
fi
echo ""
echo "  Pipeline: .pas -> p24p -> .spc -> pl24r -> pa24r -> .p24 -> pvm"
echo "════════════════════════════════════════════════════════"
