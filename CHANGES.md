# Changelog

## 2026-04-13 — User-defined unit support

### Compiler
- **Unit declarations** (issue #14): `unit <name>; interface ... implementation ... end.`
  - `TOK_UNIT`, `TOK_INTERFACE`, `TOK_IMPLEMENTATION` keywords
  - Interface-section procedures are implicit forward declarations
  - Auto-detects `unit` vs `program` by first token
- **Export code generation**: interface procedures get `.export` directives in `.spc`
  - `proc_is_exported[]` flag in procedure table
  - `.spc` exports use pa24r-compatible format (`name argc`)
- **SPI interface files**: compiler emits `;--- SPI ---` section after `.endunit`
  - Extended format with `has_ret` and `ret_type` for function signatures
  - Build scripts extract `.spi` files for importing units
- **SPI loader**: programs can import user-defined units via `uses <unitname>`
  - SPI sections prepended to input stream by build scripts
  - `load_spi_sections()` registers imported procedures with full signatures
  - Emits `.import <unitname>` and `.extern` for imported symbols
  - `xcall` for cross-unit procedure calls

### Build Scripts
- `compile-unit.sh` — compile a Pascal unit to `.spc` + `.spi`
- `run-multi-unit.sh` — compile, assemble, link, and run multi-unit programs
- `demo-multi-unit.sh` — CLI demo with two user-defined units
- `test-all.sh` — multi-unit test section with automatic unit dependency discovery

### Tests
- t36_unit_decl — unit declaration (compile-only)
- t37_mathlib — MathLib unit with add/multiply/square (compile-only)
- t37_multi_mathlib — end-to-end: main program imports MathLib unit
- demo_multi_unit/ — two-unit demo (mathlib + strutils)

### Known Limitations
- Cross-unit global variables not yet supported (requires sw-cor24-pcode#9)
- Only procedures and functions can be shared between units

### Issues closed
- #14 Support multiple user-defined compilation units

## 2026-04-12 — Forward-declared pointer parameter fix

### Compiler
- **Forward-declared functions with pointer parameters** (issue #13): `sym_ptr_base`
  metadata was not set for function/procedure parameters in `parse_param_list`,
  so `p^.field` access failed with "unknown field" when the function was
  forward-declared. Fixed by adding `sym_ptr_base[i] = utidx` to the parameter
  fixup loop, matching the pattern already used for local and global variables.

### Tests
- t35_fwd_ptr_param — forward-declared function taking `PNode` parameter,
  accesses `p^.value` in implementation body

### Issues closed
- #13 Forward-declared functions with pointer-type parameters lose field access

## 2026-04-12 — Compiler limits, record arrays, pointer returns

### Compiler
- **MAX_SYMBOLS** raised from 64 to 256 (issue #8); SYM_NAME_SIZE 2048 -> 8192
- **Array fields in records** (issue #9): `text: array[0..3] of char` inside record types
  - Correct multi-word field size and offset calculations
  - `p^.arrfield[i]` in both expressions and assignments
  - Supports char arrays (byte access via loadb/storeb) and integer arrays
- **Pointer return types** (issue #10): functions can return `PNode`, `PExpr`, etc.
  - Fixed `sym_ptr_base` metadata for local pointer variables in `parse_local_vars`
- **MAX_PROCS** raised from 32 to 128 (issue #11); PROC_NAME_SIZE 1024 -> 4096
- **INPUT_BUF_SIZE** raised from 16384 to 32768 (issue #12)

### Tests
- t31_many_symbols — 70 symbols (35 constants + 35 variables), exceeds old limit
- t32_record_array — char array field in record, accessed via pointer
- t33_record_intarray — integer array field in record, sum loop
- t34_func_pointer — function returning pointer type, factory pattern

### Documentation
- `docs/linked-list-demo-analysis.md` — detailed COR24 memory layout analysis

### Issues closed
- #8 Raise MAX_SYMBOLS from 64
- #9 Support array fields inside record types
- #10 Functions cannot return pointer types
- #11 Raise MAX_PROCS from 32
- #12 Raise INPUT_BUF_SIZE from 16384

## 2026-04-12 — Issue sweep: pointers, exit, read_char, strings

### Compiler
- **Pointer types** (issue #7): `type PNode = ^Node; Node = record ... end;`
  - Record types with arbitrary fields
  - Forward type references (`^Node` before `Node` is defined)
  - `nil` constant, pointer comparison (`=`, `<>`)
  - Dereference: `p^.field` (read and assignment)
  - `new(p)` / `dispose(p)` with heap allocation (sys ALLOC)
  - Automatic `_p24p_heap_init` and `_p24p_io_init` at program start
- **Exit procedure** (issue #6): early return from procedures, functions, and main
- **read(ch) fix** (issue #4): `read()` now calls `_p24p_read_char` for char variables
- **String pool** (issue #5): packed string pool replaces fixed-width 256-byte slots; limit raised from 16 to 128

### Runtime
- Added `_p24p_io_init` to initialize I/O lookahead buffer to -1 (empty)
- Added `_p24p_io_init` export to runtime.spc, runtime-unit.spc, runtime.spi

### Tests
- t24_strings_many — 23 string literals
- t25–t28 — exit procedure (proc, func, nested, main)
- t29_read_char — character input via UART
- t30_pointer — linked list (build, traverse, dispose)
- demo_bst — binary search tree with recursive in-order traversal
- demo_exit — linked list search using exit for early return
- Test runner: support `.input` files for UART-input tests

### Issues closed
- #4 read(ch) for char variables
- #5 Raise MAX_STRINGS limit
- #6 Add exit procedure support
- #7 Add pointer types, new, and dispose

## 2026-03-30 — Repository consolidation

- Forked from `softwarewrighter/p24c` to `sw-embed/sw-cor24-pascal`
- Moved compiler contents into `compiler/` subdirectory
- Copied runtime library from `pr24p` into `runtime/`
- Updated all scripts to reference `sw-cor24-pcode` sibling repo
- Fixed code_ptr address (0x0A0F -> 0x0A12) for current PVM
- Added `scripts/relocate_p24.py` (was in /tmp)
- Added top-level `scripts/build.sh`
- Verified: 15 compiler tests pass, runtime tests pass
