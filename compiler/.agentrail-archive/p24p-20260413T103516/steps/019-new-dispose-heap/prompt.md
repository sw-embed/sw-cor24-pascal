Add `new()` and `dispose()` built-in procedures for heap allocation (GitHub issue #7, part 2 of 3).

Builds on step 018 (pointer type system). This step adds dynamic memory allocation.

Compiler changes:
1. Recognize `new(p)` as a built-in procedure call where `p` is a pointer variable.
2. Compute the size (in words) of the pointed-to type at compile time.
3. Emit: push the size, call `_p24p_new`, store the returned address into the pointer variable.
4. Recognize `dispose(p)` as a built-in procedure call.
5. Emit: push the pointer value, call `_p24p_dispose`.

Runtime changes:
1. Add `_p24p_new(size)` — allocates `size` words from the heap, returns the base address. Use a simple bump allocator or the existing heap.pas infrastructure if available.
2. Add `_p24p_dispose(addr)` — frees the block. Can be a no-op initially (bump allocator), but the entry point must exist.
3. Heap grows upward from a designated region. Ensure it doesn't collide with the stack.

Test cases:
1. `tests/new_record.pas` — Allocate a record via new, assign fields through the pointer, read them back. Verify correct values.
2. `tests/new_multiple.pas` — Allocate multiple records, verify they get different addresses and fields are independent.
3. `tests/ptr_record_access.pas` — Create a record with pointer fields, build a two-node chain (A -> B -> nil), walk the chain printing values.
4. `tests/dispose_basic.pas` — Allocate and dispose. Verify no crash (dispose can be a no-op).

Demo: Run all test programs and show correct output.
