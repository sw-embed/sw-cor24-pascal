#!/bin/bash
# build.sh — Verify Pascal toolchain dependencies are available
# Usage: ./scripts/build.sh
set -euo pipefail

echo "Checking toolchain dependencies..."

MISSING=0
for tool in cor24-asm cor24-emu pa24r pl24r p24-load; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf "  %-12s %s\n" "$tool" "$(command -v "$tool")"
  else
    printf "  %-12s MISSING\n" "$tool"
    MISSING=$((MISSING + 1))
  fi
done

if [ "$MISSING" -gt 0 ]; then
  echo ""
  echo "Error: $MISSING tool(s) missing from PATH." >&2
  echo "Install via the devgroup shared toolchain or build from source repos." >&2
  exit 1
fi

echo ""
echo "Pascal compiler (compiler/p24p.s) runs on COR24 via cor24-emu."
echo "Runtime library is in runtime/runtime.spc."
echo ""
echo "To run a Pascal program:"
echo "  ./compiler/scripts/run-pascal.sh <file.pas>"
echo ""
echo "To run all tests:"
echo "  ./compiler/scripts/test-all.sh"
