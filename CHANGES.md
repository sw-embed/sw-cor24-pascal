# Changelog

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
