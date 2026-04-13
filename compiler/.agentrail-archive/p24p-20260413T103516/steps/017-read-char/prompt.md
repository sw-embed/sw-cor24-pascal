Fix `read(ch)` for char variables — currently calls `_p24p_read_int` instead of reading a raw character byte (GitHub issue #4).

Compiler changes:
1. In the code generation for `read()` / `readln()`, check the type of the target variable.
2. If the variable is of type `char`, emit a call to `_p24p_read_char` instead of `_p24p_read_int`.
3. `_p24p_read_char` should read exactly one byte from UART input and push its ordinal value onto the stack.

Runtime changes:
1. Add `_p24p_read_char` to the runtime library (`runtime/runtime.spc` or equivalent).
2. The implementation reads a single character from the UART input buffer and returns its ASCII value.
3. Whitespace characters (space, newline, tab) should be returned as-is, NOT skipped (unlike read_int which skips leading whitespace).

Test cases:
1. `tests/read_char.pas` — Read a single character, print its ordinal value. With input "A", expect output "65".
2. `tests/read_char_space.pas` — Read characters including spaces. With input "A B", read three chars and print their ordinal values. Expect "65 32 66" (A, space, B).
3. `tests/read_char_loop.pas` — Read characters in a loop until newline. With input "Hello\n", print each character's ordinal value.

Demo: Run test programs with UART input and show correct output.

Close GitHub issue #4 after verifying.
