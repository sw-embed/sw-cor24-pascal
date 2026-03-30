# tc24r Bug Report & Feature Requests for p24p

Context: Building a Pascal compiler (p24p) in COR24 C targeting tc24r.
The compiler needs: lexer, parser, symbol table, AST, code generator.
These patterns require struct-heavy code with arrays, trees, and dispatch tables.

## Bug 1: `ptr[index].member` panics (CRITICAL)

**What:** Indexing a struct pointer and accessing a member causes a panic.
`arr[i].key` where `arr` is `struct pair *` crashes the compiler.

**Error:**
```
thread 'main' panicked at components/codegen-expr/crates/tc24r-expr-struct/src/member.rs:89:9:
unknown struct member 'key' in type Int
```

**Root cause:** Array subscript on a struct pointer (`arr[i]`) resolves to type `Int` instead of the struct type. The subsequent `.member` access then fails because `Int` has no members.

**Minimal repro:**
```c
struct pair { int key; int val; };

int main() {
    struct pair *arr;
    arr = (struct pair *)malloc(2 * sizeof(struct pair));
    arr[0].key = 10;   // PANIC: 'key' in type Int
    arr[0].val = 20;   // same
    return arr[0].key;
}
```

**Expected:** `arr[i]` should resolve to `struct pair`, allowing `.key` access.

**Also fails:** `arr[i].member = value` (store) and `x = arr[i].member` (load).

**Workaround:** Helper function returning `struct pair *` via manual pointer arithmetic:
```c
struct pair *pair_at(struct pair *arr, int i) {
    char *base = (char *)arr;
    return (struct pair *)(base + i * sizeof(struct pair));
}
// Then: pair_at(arr, 0)->key = 10;
```

**Impact:** A compiler needs arrays of structs for symbol tables, token buffers, AST node pools, string tables, etc. This pattern appears dozens of times in typical compiler code.

---

## Bug 2: Global array of structs fails to parse (CRITICAL)

**What:** Declaring a struct array at global scope fails with a parse error.

**Error:**
```
tc24r: error at offset 3730: expected Semicolon, got LBracket
```

**Minimal repro:**
```c
struct symbol { int name_char; int value; };
struct symbol symtab[8];   // ERROR: expected Semicolon, got LBracket
```

**Expected:** Global `struct symbol symtab[8];` should allocate 8 structs in the data segment.

**Note:** Global `int table[16];` works fine. The issue is specific to struct type arrays at global scope.

**Impact:** Global struct arrays are a fundamental C pattern for fixed-size tables (keyword tables, opcode tables, etc.).

---

## Bug 3: `(ptr + offset)->member` fails to parse (MODERATE)

**What:** Pointer arithmetic in parentheses followed by arrow access fails.

**Error:**
```
tc24r: error at offset 5357: expected Semicolon, got Arrow
```

**Minimal repro:**
```c
struct pair { int key; int val; };
struct pair *arr = (struct pair *)malloc(6);
(arr + 1)->key = 30;   // ERROR: expected Semicolon, got Arrow
```

**Expected:** `(arr + 1)` should be a `struct pair *`, and `->key` should access the member.

**Impact:** This is the natural C idiom for pointer arithmetic on struct arrays. Without this AND without `ptr[i].member`, there's no direct way to index struct arrays — only the helper-function workaround works.

---

## Feature Request 1: Function Pointers (HIGH PRIORITY)

**What:** Support for declaring and calling through function pointers.

**Why needed:** A compiler's parser uses dispatch tables to select parsing functions based on token type. Without function pointers, every dispatch point becomes a large switch/case chain.

**Syntax needed:**
```c
typedef int (*parse_fn)(void);    // function pointer typedef
int (*handler)(int);              // function pointer variable
handler = &some_function;         // assignment
int result = handler(42);         // indirect call
```

**Minimum viable subset:**
- Function pointer variables (local and global)
- Assignment from function address
- Indirect calls through function pointers
- Typedef for function pointer types (nice-to-have)

**Workaround:** Large switch/case blocks. Functional but verbose and hard to maintain.

---

## Feature Request 2: `static` Local Variables (LOW PRIORITY)

**What:** `static` locals currently behave as regular locals (not persisted across calls).

**Why relevant:** Useful for lexer state (current position in source buffer), but can be worked around with globals.

**Workaround:** Use globals instead.

---

## Priority Order for p24p

1. **Bug 1** (ptr[i].member) — blocks all struct array code
2. **Bug 2** (global struct array) — blocks global tables
3. **Bug 3** ((ptr+n)->member) — blocks pointer arithmetic on structs
4. **Feature 1** (function pointers) — needed for clean dispatch, but switch/case works

Fixing bugs 1-3 unblocks p24p completely. Function pointers would make the code much cleaner but aren't strictly required.

## What Works Well

These features all compile and run correctly — sufficient for a compiler:

- Structs with pointer members (AST nodes, linked lists)
- Nested struct pointer access (`tree->left->right->value`)
- `sizeof(struct T)` — correct for allocation
- `malloc` / heap allocation
- Enums
- Switch/case with enum constants and default
- Recursive functions (AST evaluation)
- Global int arrays (`int table[16]`)
- Global struct pointers
- String literals and UART output via printf
