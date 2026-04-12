Add pointer type support to p24p — type declarations, nil, and dereference (GitHub issue #7, part 1 of 3).

This step adds the type system and code generation for pointers WITHOUT heap allocation (new/dispose come in step 019). Pointers can be assigned nil and compared, but not yet allocated.

Compiler changes — type system:
1. Add a `TYPE_POINTER` kind to the type system.
2. Pointer types store a reference to the pointed-to (base) type.
3. Parse `^TypeName` in type declarations: `type PNode = ^Node;`
4. Support forward type references: `^Node` can appear before `Node` is defined in the same type block. After the type block, resolve all forward references and error on any unresolved ones.
5. `nil` is a built-in constant with value 0, compatible with any pointer type.

Compiler changes — code generation:
1. Parse `p^` as a dereference expression (unary postfix `^`).
2. Parse `p^.field` as dereference-then-field-access.
3. Generate indirect load/store for dereferenced pointer access. Check what p-code instructions are available for indirect addressing (loadi/storei or equivalent). If not available, may need to use peek/poke runtime calls.
4. Pointer comparison (`=`, `<>`) with nil and other pointers.
5. Pointer assignment (`:=`).

Test cases:
1. `tests/ptr_nil.pas` — Declare a pointer type, assign nil, test `p = nil`. Expect "true".
2. `tests/ptr_assign.pas` — Assign one pointer to another, verify they compare equal.
3. `tests/ptr_type_fwd.pas` — Forward reference: `type PNode = ^Node; Node = record ... end;` Verify it compiles.

Do NOT implement new/dispose yet — that's step 019. Focus on getting the type system and dereference codegen solid.
