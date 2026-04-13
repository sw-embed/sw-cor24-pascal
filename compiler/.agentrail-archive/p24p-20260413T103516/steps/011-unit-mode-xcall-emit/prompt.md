Add multi-unit support to p24p code generation (depends on sw-cor24-pcode unit system landing). Changes to parser.c:

1. parse_program(): emit '.unit <name>' instead of '.module <name>' when compiling for unit mode.
2. emit_externs(): add '.import p24p_rt' directive before extern declarations for runtime procedures.
3. parse_proc_call() line ~862: emit 'xcall' instead of 'call' for non-user procedures (proc_is_user[pidx] == 0).
4. parse_write_stmt/parse_writeln_stmt/parse_read_args: change all hardcoded 'call _p24p_*' to 'xcall _p24p_*' for runtime builtins.
5. emit_externs(): emit '.endunit' instead of '.endmodule'.

Gate this behind a flag or 'uses units' directive so existing static-link mode still works. The runtime (runtime.spc) needs '.unit p24p_rt' and '.export' directives for every public procedure — that's a separate change to runtime/runtime.spc.

Test: compile a Pascal program in unit mode, verify .spc output contains .unit/.import/.extern/xcall directives. Cannot test end-to-end until pcode toolchain phases 1-4 are done.