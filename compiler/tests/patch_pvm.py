#!/usr/bin/env python3
"""Patch pvm.s to use flat memory model for pasm bytecode.

pasm generates bytecodes with flat addressing: globals are at
code_size+data_size byte offsets in the image. pvm's loadg/storeg
multiply operand by 3 (word indexing), which breaks with pasm's
byte offsets. This script patches pvm to:
  1. Set gp = code_seg (flat model)
  2. Remove the *3 in loadg/storeg (use byte offsets directly)
  3. Embed bytecode + global padding in code_seg
"""

import re
import sys
import os

workdir = sys.argv[1]
pvm_path = sys.argv[2]

with open(f'{workdir}/bytecode.txt', 'r') as f:
    bytecode = f.read().strip().split()

# Pad with 24 zero bytes for globals (8 words * 3 bytes)
for i in range(24):
    bytecode.append('0')

# Generate .byte directives
byte_lines = []
for i in range(0, len(bytecode), 16):
    chunk = bytecode[i:i+16]
    byte_lines.append('    .byte ' + ', '.join(chunk))

with open(pvm_path, 'r') as f:
    pvm = f.read()

# 1. Replace code_seg bytecode
pattern = r'(code_seg:\n).*?(globals_seg:)'
replacement = r'\g<1>' + '\n'.join(byte_lines) + '\n\n' + r'\g<2>'
pvm_new = re.sub(pattern, replacement, pvm, flags=re.DOTALL)

# 2. Fix gp: point to code_seg instead of globals_seg
pvm_new = pvm_new.replace(
    '    la r0, globals_seg\n    sw r0, 12(fp)',
    '    la r0, code_seg\n    sw r0, 12(fp)'
)

# 3. Fix loadg/storeg: remove *3 multiplication
# The pattern "mov r0, r2 / add r0, r0 / add r0, r2" computes r2*3
# We need it to be just "mov r0, r2" (byte offset, no multiplication)
# Only fix the ones in op_loadg and op_storeg (identified by surrounding context)

# Fix loadg
pvm_new = pvm_new.replace(
    '    ; Compute gp + offset * 3\n'
    '    mov r0, r2\n'
    '    add r0, r0\n'
    '    add r0, r2\n'
    '    ; r0 = offset * 3\n'
    '    lw r2, 12(fp)\n'
    '    add r0, r2\n'
    '    ; r0 = gp + offset * 3\n'
    '    lw r2, 0(r0)',
    '    ; Compute gp + byte offset (flat model)\n'
    '    mov r0, r2\n'
    '    lw r2, 12(fp)\n'
    '    add r0, r2\n'
    '    ; r0 = gp + byte offset\n'
    '    lw r2, 0(r0)'
)

# Fix storeg
pvm_new = pvm_new.replace(
    '    ; Compute target: gp + offset * 3\n'
    '    mov r0, r2\n'
    '    add r0, r0\n'
    '    add r0, r2\n'
    '    ; r0 = offset * 3\n'
    '    lw r2, 12(fp)\n'
    '    add r0, r2\n'
    '    ; r0 = target address',
    '    ; Compute target: gp + byte offset (flat model)\n'
    '    mov r0, r2\n'
    '    lw r2, 12(fp)\n'
    '    add r0, r2\n'
    '    ; r0 = target address'
)

with open(f'{workdir}/pvm_test.s', 'w') as f:
    f.write(pvm_new)

# Verify patches applied
checks = [
    ('gp fix', 'la r0, code_seg\n    sw r0, 12(fp)'),
    ('loadg flat', 'gp + byte offset (flat model)'),
    ('storeg flat', 'gp + byte offset (flat model)'),
]
for name, text in checks:
    if text in pvm_new:
        print(f'  {name}: OK')
    else:
        print(f'  {name}: FAILED')

print(f'Wrote pvm_test.s with {len(bytecode)} bytes')
