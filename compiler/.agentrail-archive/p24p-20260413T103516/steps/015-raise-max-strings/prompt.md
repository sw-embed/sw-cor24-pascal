Raise MAX_STRINGS limit from 16 to 128 (GitHub issue #5). The current limit is too restrictive for real programs — even a simple token-name printer hits it at 17 strings.

Changes:
1. In `compiler/src/parser.h`, change `#define MAX_STRINGS 16` to `#define MAX_STRINGS 128`.
2. Consider whether MAX_STRING_BYTES (currently 256) also needs adjustment. 128 * 256 = 32KB which is fine for COR24.
3. Rebuild the compiler with `just build`.

Test:
- Write `tests/strings_many.pas` — a program that uses at least 20 distinct string literals (e.g., printing token type names, day-of-week names, error messages). Verify it compiles and runs correctly.
- Verify the existing test suite still passes.

Demo: Run the test program and show the output.

Close GitHub issue #5 after verifying.
