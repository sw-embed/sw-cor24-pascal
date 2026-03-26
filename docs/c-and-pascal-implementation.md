# p24p Implementation Strategy: C Compiler + Pascal Runtime

## Architecture

**C (via tc24r, runs natively on COR24):** The compiler itself — lexer, parser, symbol table, type checker, codegen. Text-to-text translator: reads Pascal source, emits .spc p-code assembler output. Stays in C indefinitely.

**Pascal (dogfooded, runs on pv24a VM):** The runtime library — everything a Pascal program needs at execution time. Written in Pascal, compiled by the C compiler → .spc → pasm → .p24, linked with user programs.

**Why this split:**
- The compiler doesn't need Pascal features to work
- The runtime IS Pascal code — perfect dogfooding
- Each runtime feature tests the compiler feature that enables it
- The runtime ships alongside user programs on the VM

## Pipeline

```
Pascal source (.pas)
  → p24p compiler (C, native COR24)
  → .spc file (p-code assembler text)
  → pasm (COR24 assembly)
  → .p24 file (bytecode)
  → pv24a VM (COR24 assembly)
  → execution on emulator/FPGA
```

## Memory Coexistence

One COR24 emulator, one address space. The C compiler code and pvm.s coexist:

```
COR24 Memory:
+---------------------------+
| C compiler code (native)  |  tc24r output
| pvm.s (VM interpreter)    |  linked together
+---------------------------+
| C globals, buffers        |
| source_buf[]              |  Pascal source (input)
| spc_buf[]                 |  .spc output
+---------------------------+
| p-code bytecode (.p24)    |  runtime + user program
+---------------------------+
| VM eval stack             |
| VM call stack             |
| VM globals/heap           |
+---------------------------+
```

The C compiler calls the VM as a subroutine. Shared memory buffers are the API between native C code and Pascal code running on the VM.

## Compiler Phases

### Phase 0 — Expressions (MUST HAVE, start here)

**Compiler (C):**
- `program`/`begin`/`end` — parser, codegen
- `integer`, `boolean` — type system
- `const` declarations — symbol table
- `var` declarations (scalars) — symbol table, frame layout
- `:=` assignment — codegen
- `+`, `-`, `*`, `div`, `mod` — codegen (maps to .spc opcodes)
- `=`, `<>`, `<`, `<=`, `>`, `>=` — codegen
- `and`, `or`, `not` — codegen
- `if`/`then`/`else` — codegen (jz/jmp)
- `while`/`do` — codegen (jz/jmp)
- `writeln` (integers) — codegen emits sys PUTC calls

**Runtime:** `writeln`/`readln` and low-level I/O primitives (`putc`, `getc`, integer-to-decimal) — hand-written .spc permanently. These are stable I/O glue around `sys PUTC`/`sys GETC` and don't benefit from rewriting in Pascal.

### Phase 1 — Block Structure (MUST HAVE)

**Compiler (C):**
- `procedure`/`function` — call/ret, frame layout
- Parameters (by value) — push args, enter/leave
- `var` parameters (by reference) — push address
- Nested procedures + static links — calln, static chain
- Fixed arrays `array[lo..hi]` — index calc, bounds info
- Records — field offsets
- `char` type — byte load/store
- String literals — data segment, packed chars
- `for`/`do`, `repeat`/`until` — codegen
- `case` statement — jump table or chain
- `read`/`readln`, `write`/`writeln` (full) — codegen

**Runtime (hand-written .spc, permanent):**
- `writeln`/`readln` formatting and I/O primitives (`putc`, `getc`, integer-to-decimal, UART polling) — stable low-level glue, no value in rewriting

**Runtime (now writable in Pascal — dogfooding begins):**
- Standard functions: `abs`, `odd`, `ord`, `chr`, `succ`, `pred`, `sqr`
- Bounds check failure handler (print diagnostic, trap)
- Nil check handler

**Phase 1 is the transition point.** Pascal is expressive enough to write real runtime code.

### Phase 2 — Dynamic Features (NICE TO HAVE)

**Compiler (C):**
- Pointers (`^type`) — codegen for deref, address-of
- `new`/`dispose` — codegen calls runtime
- Multi-dimensional arrays — nested index calc
- `with` statement — implicit field access
- `type` section — type alias resolution
- Enumerated types — ordinal mapping
- Subrange types — bounds checking
- Sets (small) — bit-vector ops
- String helpers

**Runtime (Pascal — major dogfooding):**
- Heap allocator (`new`/`dispose`) — exercises pointers, records, arrays, VM memory model
- Leak detector — track allocations, report at program exit
- Set operations: union, intersection, difference, membership
- Subrange check handler
- String compare, copy, concat

**No GC.** Pascal uses explicit `new`/`dispose`. GC is maybe-someday for a future Lisp front-end targeting the same VM.

### Phase 3 — Full Language (MAYBE SOMEDAY)

- File types — major I/O subsystem, needs VM support
- Variant records — complex type layout, tag checking
- Conformant array parameters — complex calling convention
- Procedural parameters — needs function pointers in p-code
- `goto`/labels — non-local jumps, complicates frame cleanup
- Packed types — bit-packing, complex load/store
- Real numbers — N/A (integer-only ISA)
- ISO 7185 full compliance — enormous surface area

## Saga Scope

Phase 0 + Phase 1 compiler in C. Phase 1 runtime in Pascal.

The "enough C to dogfood the rest" threshold: **Phase 1 compiler complete**. That unlocks writing all runtime code in Pascal. Phase 2 compiler features added incrementally, each enabling more Pascal runtime to be dogfooded.
