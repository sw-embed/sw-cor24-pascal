Convert runtime/runtime.spc into a standalone p-code unit with exports. Changes:

1. Add '.unit p24p_rt' at the top of runtime.spc (replacing .module if present).
2. Add '.export' directives for every public procedure: _p24p_write_int, _p24p_write_bool, _p24p_write_str, _p24p_write_char, _p24p_write_ln, _p24p_read_int, _p24p_read_ln, _p24p_abs, _p24p_odd, _p24p_ord, _p24p_chr, _p24p_succ, _p24p_pred, _p24p_sqr, _p24p_eof, _p24p_eoln, _p24p_peek, _p24p_poke, _p24p_memcpy, _p24p_memset, _p24p_writechar, _p24p_led_on, _p24p_led_off, _p24p_read_switch (with correct arg counts).
3. Add '.endunit' at the end.
4. Create runtime/runtime.spi interface file listing exports with arg counts for compiler consumption.
5. Pre-assemble runtime unit: pa24r runtime.spc -o p24p_rt.p24 (add to build scripts/justfile).

Test: verify pa24r produces a valid v2 .p24 with export table. Depends on pa24r supporting v2 format (sw-cor24-pcode phase 1).