Update build pipeline scripts for multi-unit compilation. The new pipeline:

  .pas → p24p (unit mode) → user.spc → pa24r → user.p24 (v2, with imports)
  runtime.spc → pa24r → p24p_rt.p24 (v2, with exports, pre-built)
  p24-load user.p24 p24p_rt.p24 → image.p24m
  pvm.s loads image.p24m

Changes:
1. run-pascal.sh: add --unit flag; when set, skip pl24r static link step, assemble user.spc directly with pa24r, then use p24-load to combine with pre-built p24p_rt.p24 into .p24m image. Load .p24m into PVM.
2. test-all.sh: support both static-link and unit-mode test cases.
3. justfile: add 'build-runtime-unit' recipe, 'run-unit' recipe.
4. Keep backward compatibility: default mode is still static link. Unit mode is opt-in via flag.

Test: end-to-end — compile a Pascal program in unit mode, load with p24-load, run on PVM, verify correct output. Depends on p24-load existing (sw-cor24-pcode phase 3) and PVM supporting .p24m (phase 4).