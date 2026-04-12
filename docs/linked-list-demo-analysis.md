# Linked-List Demo Analysis (t30_pointer)

Analysis of the `compiler/tests/t30_pointer.pas` test program running through
the full p24p compilation pipeline on the COR24 emulator.

## Test Program

`t30_pointer.pas` builds a singly-linked list by inserting integers 1..5 at the
head, walks the list printing values (5 4 3 2 1), disposes all nodes, and prints 0.

```pascal
type
  PNode = ^Node;
  Node = record
    value: integer;
    next: PNode
  end;
```

Each `Node` is 2 words (6 bytes): `value` at offset 0, `next` at offset +3.

## Pipeline Steps

```
t30_pointer.pas                  (488 bytes source)
    |  p24p compiler (runs on COR24 emulator, 7M COR24 instructions)
    v
t30.spc                          (1,628 bytes p-code assembler)
    |  pl24r linker (resolves runtime symbols, inlines runtime procs)
    v
t30_linked.spc                   (23,110 bytes linked .spc)
    |  pa24r assembler (two-pass, emits binary p-code)
    v
t30.p24                          (1,961 bytes, 18-byte header + 1,943 code)
    |  relocate_p24.py (patches absolute addresses for load at 0x010000)
    v
t30.bin                          (1,943 bytes, raw p-code)
    |  loaded into COR24 emulator memory
    v
PVM executes p-code              (58,143 p-code instructions, clean HALT)
```

## COR24 Emulator Memory Map

COR24 has a 24-bit address space. SRAM occupies 0x000000..0x0FFFFF (1 MB).
MMIO is at 0xFF0000+ (UART, LED, switch).

### Binaries loaded into memory

| Binary | Load Address | Size | Contents |
|--------|-------------|------|----------|
| `pvm.s` (assembled) | 0x000000 | 7,335 bytes | COR24 native code: PVM interpreter, dispatch tables, data segments |
| `code_ptr.bin` | 0x001033 | 3 bytes | Patches `code_ptr` to 0x010000 (redirects PVM to external p-code) |
| `t30.bin` | 0x010000 | 1,943 bytes | Relocated p-code bytecode (runtime + user program) |

### PVM internal segments (inside the 7,335-byte pvm.s image)

```
0x000000 +-----------------------+
         | PVM native code       |  COR24 assembly: dispatch loop, opcode
         | (interpreter)         |  handlers, syscall implementations
         | ~4,105 bytes          |
0x001009 +-----------------------+
         | vm_state (30 bytes)   |  pc, esp, csp, fp, gp, hp, code, status,
         |                       |  trap_code, irt_base
0x001027 +-----------------------+
         | dispatch tables, etc. |  opcode jump tables, nonlocal_temps scratch
0x001033 +-----------------------+
         | code_ptr (3 bytes)    |  Patched to 0x010000 at load time
0x001036 +-----------------------+
         | vm_flags (1 byte)     |  Boot flags (default: 0)
0x001037 +-----------------------+
         | code_seg (16 bytes)   |  Built-in "PVM OK" test program (unused)
0x001047 +-----------------------+
         | globals_seg           |  512 words = 1,536 bytes
         | (1,536 bytes)         |  Holds all .global variables
0x001647 +-----------------------+
         | call_stack            |  256 words = 768 bytes
         | (768 bytes)           |  Call frames grow upward
0x001947 +-----------------------+
         | eval_stack            |  256 words = 768 bytes
         | (768 bytes)           |  Expression evaluation, grows upward
0x001C47 +-----------------------+
         | heap_seg              |  32 words = 96 bytes statically reserved
         | (96 bytes+)           |  Bump allocator grows into free SRAM
0x001CA7 +-----------------------+
         |                       |
         | (free SRAM)           |  ~57 KB gap before p-code binary
         |                       |
0x010000 +-----------------------+
         | t30.bin (p-code)      |  1,943 bytes of p-code bytecode
         | (1,943 bytes)         |
0x010797 +-----------------------+
         |                       |
         | (free SRAM to 1MB)    |
         |                       |
0x0FFFFF +-----------------------+
```

### Distance between segments

- PVM end to p-code binary: 0x010000 - 0x001CA7 = ~58 KB gap
- Heap can grow ~58 KB before colliding with p-code (this test uses 30 bytes)
- P-code binary to end of SRAM: 0x0FFFFF - 0x010797 = ~957 KB unused

## Globals Layout (25 words at 0x001047)

The pa24r assembler assigns global offsets in order of `.global` directives
in the linked .spc file. Runtime globals come first (from runtime.spc),
then user globals (from the compiled program).

| Offset | Name | Size | Source |
|--------|------|------|--------|
| 0 | `_h_ac` | 1 word | Runtime: heap allocation count |
| 3 | `_h_fc` | 1 word | Runtime: heap free count |
| 6 | `_h_pt` | 16 words | Runtime: pointer tracking table (16 slots) |
| 54 | `_io_la` | 1 word | Runtime: I/O lookahead buffer (-1 = empty) |
| 57 | `_io_ef` | 1 word | Runtime: EOF flag |
| 60 | `head` | 1 word | User: linked list head pointer |
| 63 | `p` | 1 word | User: working pointer |
| 66 | `tmp` | 1 word | User: temp pointer for dispose loop |
| 69 | `i` | 1 word | User: loop counter |
| 72 | `_p24p_tmp` | 1 word | Compiler: scratch for address save/restore |

Total: 25 words = 75 bytes (of 1,536 available, 5% used).

## Heap Usage

The PVM heap is a bump allocator (`sys 4 ALLOC`). `sys 5 FREE` is a no-op --
memory is never reclaimed. The runtime's `_p24p_new` / `_p24p_dispose` add
tracking on top (allocation count, free count, 16-slot pointer table).

| Allocation | Size | Heap Address | Contents |
|-----------|------|-------------|----------|
| `new(p)` #1 | 6 bytes (2 words) | 0x001C47 | Node: value=1, next=nil |
| `new(p)` #2 | 6 bytes | 0x001C4D | Node: value=2, next=0x001C47 |
| `new(p)` #3 | 6 bytes | 0x001C53 | Node: value=3, next=0x001C4D |
| `new(p)` #4 | 6 bytes | 0x001C59 | Node: value=4, next=0x001C53 |
| `new(p)` #5 | 6 bytes | 0x001C5F | Node: value=5, next=0x001C59 |

After all allocations: `hp` = 0x001C65. Total heap used: 30 bytes.
After all disposes: `hp` unchanged (bump allocator), but tracking table
records 5 allocs and 5 frees.

Heap capacity: 96 bytes statically reserved, but can grow into ~58 KB
of free SRAM before the p-code binary at 0x010000.

## Call Stack Usage

Each call frame has a 12-byte header (return PC, dynamic link, static link,
proc ID) plus N local slots (3 bytes each).

### Call chains during execution

1. **Initialization**: main -> `_p24p_io_init` (0 locals) -> ret
2. **Initialization**: main -> `_p24p_heap_init` (1 local) -> ret
3. **Allocation loop** (5 iterations):
   - main -> `_p24p_new` (2 locals, 1 arg) -> `sys 4` -> ret
4. **Print loop** (5 iterations):
   - main -> `_p24p_write_int` (1 local, 1 arg) -> ret
   - main -> `_p24p_write_ln` (0 locals) -> ret
5. **Dispose loop** (5 iterations):
   - main -> `_p24p_dispose` (1 local, 1 arg) -> ret
6. **Final print**: main -> `_p24p_write_int` -> ret, main -> `_p24p_write_ln` -> ret

Maximum call depth: 2 (main + one runtime procedure). No recursion.

Peak call stack usage: main frame (12 bytes) + `_p24p_new` frame (12 + 6 = 18 bytes)
= **30 bytes**. Call stack capacity: 768 bytes (4% used).

## Eval Stack Usage

The eval stack holds intermediate values during expression evaluation
and arguments before procedure calls.

Deepest eval stack moment: inside `_p24p_write_int` during digit extraction.
The routine pushes a 0 sentinel, then pushes digit characters in reverse
order. For a single-digit number (values 1-5), that's 2 entries. For the
maximum 24-bit integer (~8 digits), up to 9 entries (27 bytes).

Peak eval stack usage: ~**30 bytes**. Eval stack capacity: 768 bytes (4% used).

## Linked Procedures

The linker (pl24r) inlines all runtime procedures into the output. The linked
binary contains 28 procedures, of which only 6 are actually called at runtime:

| Procedure | Locals | Called? | Purpose |
|-----------|--------|---------|---------|
| `main` | 0 | Yes (entry) | User program body |
| `_p24p_io_init` | 0 | Yes | Initialize I/O lookahead buffer |
| `_p24p_heap_init` | 1 | Yes | Zero heap tracking counters and table |
| `_p24p_new` | 2 | Yes (5x) | Allocate via `sys 4`, track pointer |
| `_p24p_dispose` | 1 | Yes (5x) | Free via `sys 5`, untrack pointer |
| `_p24p_write_int` | 1 | Yes (6x) | Print signed integer to UART |
| `_p24p_write_ln` | 0 | Yes (6x) | Print newline to UART |
| (21 others) | -- | No | Linked but unreachable (dead code) |

Dead code accounts for ~1,500 bytes of the 1,943-byte binary (~77%).
The linker does not perform dead-code elimination.

## Recently-Added Features

Analysis of which compiler features from recent issues are exercised:

| Feature | Issue | Used? | How |
|---------|-------|-------|-----|
| Pointer types (^Type) | pre-existing | Yes | `PNode = ^Node`, all dereferences |
| Record types | pre-existing | Yes | `Node = record value; next end` |
| new/dispose | pre-existing | Yes | 5 allocs, 5 frees |
| Array fields in records | #9 | No | Node has only scalar fields |
| MAX_SYMBOLS = 256 | #8 | No | Only ~10 symbols used |
| Function pointer returns | #10 | No | No user functions defined |
| MAX_PROCS = 128 | #11 | No | ~20 runtime + 0 user procs |
| INPUT_BUF_SIZE = 32K | #12 | No | Source is only 488 bytes |

The `_p24p_tmp` global (compiler scratch for address save/restore during
pointer field stores) is allocated because the program uses `p^.field := expr`.
This scratch variable was part of the original pointer/record implementation,
not the recent fixes.

## Execution Statistics

| Metric | Value |
|--------|-------|
| p24p compilation | 7,066,842 COR24 instructions |
| PVM execution | 58,143 p-code instructions |
| Output | `5\n4\n3\n2\n1\n0\n` (12 bytes) |
| Status | Clean HALT |
| Total COR24 time | ~58K p-code ops (each ~10-50 COR24 ops) |

## Summary

The linked-list demo runs a two-layer emulation: COR24 hardware emulated by
`cor24-run` (Rust), running pvm.s (COR24 assembly), which interprets p-code
bytecode compiled from Pascal. The two binaries (PVM at 0x000000 and p-code at
0x010000) are separated by a ~58 KB gap in the 1 MB SRAM address space. All
runtime state (globals, stacks, heap) lives inside the PVM's statically-allocated
segments between 0x001047 and 0x001CA7. This test uses <5% of available stack
and globals capacity, and <1% of available heap-to-code-gap space.
