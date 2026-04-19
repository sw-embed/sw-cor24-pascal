# sw-cor24-pascal — Pascal for COR24

Pascal compiler(s) and runtime library targeting the COR24 p-code VM.

## Repository Structure

```
compiler/    Pascal compiler (C, compiled by tc24r, runs on COR24)
runtime/     Runtime library (written in Pascal)
scripts/     Build and utility scripts
```

## Pipeline

### Single-unit (default)
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

### Multi-unit
```
unit.pas  ->  p24p  ->  unit.spc + unit.spi
main.pas  ->  p24p (with SPI)  ->  main.spc

pa24r unit.spc  ->  unit.p24
pa24r main.spc  ->  main.p24

p24-load main.p24 unit.p24 p24p_rt.p24  ->  image.p24m
pvm.s image.p24m
```

## Language Features

- Integer, boolean, char types
- Arrays, records (including array fields), pointer types (`^T`)
- `new` / `dispose` for heap allocation
- Procedures and functions (nested, forward-declared, pointer return types)
- User-defined units (`unit`/`interface`/`implementation`) with cross-unit procedure calls
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

# Run a multi-unit program
./compiler/scripts/run-multi-unit.sh compiler/tests/t37_multi_mathlib.pas compiler/tests/t37_mathlib.pas

# Run all regression tests
./compiler/scripts/test-all.sh
```

## Projects Using This Compiler

- [sw-cor24-basic](https://github.com/sw-embed/sw-cor24-basic) — 1970s-terminal-inspired "Time Sharing" BASIC interpreter for COR24 ISA hardware and emulator.
- `runtime/` — the Pascal runtime library in this repo is itself written in Pascal.

## Links

- Blog: [Software Wrighter Lab](https://software-wrighter-lab.github.io/)
- Discord: [Join the community](https://discord.com/invite/Ctzk5uHggZ)
- YouTube: [Software Wrighter](https://www.youtube.com/@SoftwareWrighter)

## License

Copyright (c) 2026 Michael A Wright. MIT-licensed; see [LICENSE](LICENSE).
