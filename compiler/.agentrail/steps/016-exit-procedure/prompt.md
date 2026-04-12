Add `exit` procedure support for early return from procedures and functions (GitHub issue #6).

Standard Pascal `exit` jumps to the procedure's epilogue, effectively an early return.

Compiler changes:
1. Recognize `exit` as a built-in procedure in the parser (similar to how `writeln`, `read`, etc. are handled).
2. Each procedure/function needs an epilogue label. When compiling a procedure body, generate a unique label (e.g., `_exit_N`) that marks the return point.
3. When `exit` is encountered, emit a `jmp` to that epilogue label.
4. At the end of the procedure body, emit the epilogue label before the `ret` instruction.
5. `exit` in the main program body should jump to program end (halt).
6. `exit` takes no arguments in this implementation (Turbo Pascal style).

Test cases (write as test .pas files and run them):
1. `tests/exit_proc.pas` — Procedure with early exit: call a procedure that prints "before", exits, and should NOT print "after". Verify only "before" appears.
2. `tests/exit_func.pas` — Function with early exit: function that sets result and exits before a second assignment. Verify correct return value.
3. `tests/exit_nested.pas` — Exit from a nested if/begin block inside a procedure. Verify it exits the whole procedure, not just the block.
4. `tests/exit_main.pas` — Exit in main program body. Verify it halts without executing subsequent statements.

Demo: Run all test programs and show output matches expectations.

Close GitHub issue #6 after verifying.
