# sw-cor24-pascal — Pascal for COR24

Pascal compiler(s) and runtime library targeting the COR24 p-code VM.

## Repository Structure

```
compiler/    Pascal compiler (C, compiled by tc24r, runs on COR24)
runtime/     Runtime library (32 routines, hand-coded .spc)
scripts/     Build and utility scripts
```

## Pipeline

```
.pas  ->  p24p (compiler/)  ->  .spc
                                  |
runtime/runtime.spc  -------------+
                                  v
                          pl24r (linker)
                                  |
                                  v
                          pa24r (assembler)  ->  .p24 bytecode
                                                      |
                                                      v
                                              pvm.s (COR24 VM)
```

## Dependencies

Sibling repos (cloned under `~/github/sw-embed/`):

- `sw-cor24-pcode` — p-code assembler (pa24r), linker (pl24r), VM (pvm.s)
- `sw-cor24-emulator` — COR24 emulator (cor24-run)

## Quick Start

```bash
# Build p-code tools
./scripts/build.sh

# Run a Pascal program
./compiler/scripts/run-pascal.sh compiler/tests/t01_factorial.pas

# Run all regression tests
./compiler/scripts/test-all.sh
```

## License

See [LICENSE](LICENSE).
