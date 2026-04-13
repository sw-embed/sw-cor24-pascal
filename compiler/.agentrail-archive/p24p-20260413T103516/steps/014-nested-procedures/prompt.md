Add nested procedure/function support to p24p (GitHub issue #8). Standard Pascal allows procedures declared inside other procedures with access to enclosing scope variables via the static link chain.

Changes needed in parser.c:
1. Track scope nesting depth (current_depth counter, incremented on proc entry, decremented on exit).
2. In parse_proc_or_func_decl: allow recursive calls to parse_proc_or_func_decl for nested procs. Currently procs are only parsed at top level in parse_block.
3. Symbol lookup: when a variable is found at a different scope depth, emit loadn/storen (nonlocal access) instead of loadl/storel. Calculate the static link chain depth = current_depth - symbol_depth.
4. Call frame: emit correct static link when calling nested procs. For a call from depth D to a proc at depth D2, the static link points D-D2+1 levels up the chain.
5. The p-code VM already supports loadn/storen opcodes for nonlocal variable access via the static link chain — no VM changes needed.

Test cases:
- Inner proc accessing outer's local variable
- Two levels of nesting (proc inside proc inside proc)
- Inner proc calling another inner proc at same level
- Outer proc calling inner proc

Reference: GitHub issue #8 (sw-cor24-pascal). The BASIC interpreter may use nested procs for grouping helper functions inside main dispatch procedures.