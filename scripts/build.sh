#!/bin/bash
# build.sh — Build the Pascal toolchain dependencies
# Usage: ./scripts/build.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PCODE_DIR="$REPO_DIR/../sw-cor24-pcode"

echo "Building p-code assembler and linker..."
(cd "$PCODE_DIR" && cargo build --release)

echo ""
echo "Pascal compiler (compiler/p24p.s) runs on COR24 via cor24-run."
echo "Runtime library is in runtime/runtime.spc."
echo ""
echo "To run a Pascal program:"
echo "  ./scripts/run-pascal.sh <file.pas>"
echo ""
echo "To run all tests:"
echo "  ./scripts/test-all.sh"
