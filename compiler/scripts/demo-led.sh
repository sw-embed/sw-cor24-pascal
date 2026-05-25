#!/bin/bash
# demo-led.sh — Demonstrate LED control from Pascal
# Shows: source → compile → link → assemble → run → LED state in dump
#
# Usage: ./scripts/demo-led.sh
set -euo pipefail

P24P_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$P24P_DIR/.." && pwd)"
P24P_S="$P24P_DIR/p24p.s"
RUNTIME="$REPO_DIR/runtime/runtime.spc"

# Resolve PVM (env override or derive from toolchain location)
if [ ! -f "${PVM:-}" ]; then
  PVM="$(dirname "$(command -v cor24-emu)")/../lib/pcode/pvm.s"
fi
[ -f "$PVM" ] || { echo "Error: pvm.s not found — set PVM env var" >&2; exit 1; }

TMP="/tmp/p24p_led_$$"
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

# Pre-assemble compiler and PVM
cor24-asm "$P24P_S" --bin "$TMP/p24p.bin"
cor24-asm "$PVM" --bin "$TMP/pvm.bin" --listing "$TMP/pvm.lst"

CODE_PTR=$(grep -A1 "code_ptr:" "$TMP/pvm.lst" | tail -1 | awk '{print $1}' | tr -d ':')
[ -n "$CODE_PTR" ] || { echo "Error: could not resolve code_ptr from PVM" >&2; exit 1; }

for f in "$P24P_DIR"/tests/led_on.pas "$P24P_DIR"/tests/led_off.pas; do
  [ -f "$f" ] || continue
  NAME=$(basename "$f" .pas)

  echo "════════════════════════════════════════════════════════"
  echo "  LED Demo: $NAME"
  echo "════════════════════════════════════════════════════════"
  echo ""

  echo "--- Source ---"
  cat "$f"
  echo ""

  # Compile
  SPC_OUTPUT=$(cor24-emu --load-binary "$TMP/p24p.bin@0" --entry 0 \
    --uart-file "$f" --speed 0 -n 50000000 -q 2>/dev/null)

  if ! echo "$SPC_OUTPUT" | grep -q "; OK"; then
    echo "  COMPILE FAILED"
    echo "$SPC_OUTPUT" | grep "error" | sed 's/^/  /'
    continue
  fi

  SPC=$(echo "$SPC_OUTPUT" | sed -n '/^\.module/,/^\.endmodule/p')
  echo "$SPC" > "$TMP/$NAME.spc"
  echo "--- Generated .spc ---"
  echo "$SPC" | sed -n '/^\.proc/,/^\.end/p'
  echo ""

  # Link + assemble + relocate
  pl24r "$RUNTIME" "$TMP/$NAME.spc" -o "$TMP/${NAME}_linked.spc" >/dev/null 2>/dev/null
  pa24r "$TMP/${NAME}_linked.spc" -o "$TMP/$NAME.p24" >/dev/null 2>/dev/null
  python3 "$REPO_DIR/scripts/relocate_p24.py" "$TMP/$NAME.p24" 0x010000 >/dev/null 2>&1

  # Run with dump
  EXEC_OUTPUT=$(cor24-emu --load-binary "$TMP/pvm.bin@0" \
    --load-binary "$TMP/$NAME.bin@0x010000" \
    --patch "0x${CODE_PTR}=0x010000" \
    --entry 0 --dump --speed 0 -n 50000000 2>&1)

  INSTRS=$(echo "$EXEC_OUTPUT" | grep -oE 'Executed [0-9]+' | grep -oE '[0-9]+')
  HALTED=$(echo "$EXEC_OUTPUT" | grep -c 'CPU halted' || true)

  echo "--- Hardware State ---"
  echo "$EXEC_OUTPUT" | grep -E '^\s*(LED D2|BTN S2):' | sed 's/^/  /'
  echo ""
  echo "--- Stats ---"
  echo "  VM instructions: $INSTRS"
  if [ "$HALTED" -ge 1 ]; then
    echo "  Status: HALT (clean exit)"
  else
    echo "  Status: DID NOT HALT"
  fi
  echo ""
done

echo "NOTE: LED D2 is active-low (0x00 = on, 0x01 = off)."
echo "NOTE: LedOn and LedOff should show different LED states."
