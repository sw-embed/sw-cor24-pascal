# sw-cor24-pascal — Pascal for COR24

Pascal compiler(s) and runtime library targeting the COR24 p-code VM.

## Repository Structure

```
compiler/    Pascal compiler (C, compiled by tc24r, runs on COR24)
runtime/     Runtime library (written in Pascal)
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

## Language Features

- Integer, boolean, char types
- Arrays, records (including array fields), pointer types (`^T`)
- `new` / `dispose` for heap allocation
- Procedures and functions (nested, forward-declared, pointer return types)
- Control flow: if/else, while, for, repeat/until, case, exit
- Standard I/O: read, readln, write, writeln
- 128 string literals (packed pool)
- Up to 256 symbols, 128 procedures, 32 KB source input

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

## Projects Using This Compiler

- [sw-cor24-basic](https://github.com/sw-embed/sw-cor24-basic) — 1970s-terminal-inspired "Time Sharing" BASIC interpreter for COR24 ISA hardware and emulator.
- `runtime/` — the Pascal runtime library in this repo is itself written in Pascal.

## License

See [LICENSE](LICENSE).
