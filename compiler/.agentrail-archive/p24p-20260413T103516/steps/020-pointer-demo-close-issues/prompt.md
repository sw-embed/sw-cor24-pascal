End-to-end pointer demonstration and comprehensive testing (GitHub issue #7, part 3 of 3).

This step validates the full pointer implementation from steps 018-019 with a real-world demo program and comprehensive tests.

Demo program — `tests/demo_linked_list.pas`:
Build a proper singly-linked list:
1. Define `type PNode = ^Node; Node = record value: integer; next: PNode end;`
2. Insert 5 values (e.g., 10, 20, 30, 40, 50) at the head of the list.
3. Walk the list from head to tail, printing each value.
4. Expected output: "50 40 30 20 10" (reverse insertion order).
5. Dispose all nodes after printing (cleanup).

Demo program — `tests/demo_binary_tree.pas` (if time permits):
Build a simple binary search tree:
1. Insert values: 4, 2, 6, 1, 3, 5, 7
2. In-order traversal prints: 1 2 3 4 5 6 7

Comprehensive test suite:
1. Run ALL pointer tests from steps 018-019 plus the demos.
2. Run ALL existing tests to verify no regressions.
3. Document any limitations (e.g., no pointer arithmetic, no typed file pointers).

Close GitHub issue #7 after all tests pass.

Update the wiki page [[P24P]] with the new features (pointers, exit, read_char, raised string limit).
