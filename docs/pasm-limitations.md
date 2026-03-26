# pasm Limitations for p24p

Known issues in pv24a's pasm assembler that affect the p24p → pasm → pvm pipeline.

## 1. Input Buffer: 160 bytes (BLOCKING)

pasm's `input_buf` is only 160 bytes. Real compiler output (`.spc` + runtime) is 500+ bytes. Pasm silently truncates input beyond this limit.

**Fix needed:** Increase `input_buf` in pasm.s to at least 2048 bytes.

## 2. Comment Handling: Non-ASCII breaks parser

Comments containing non-ASCII characters (e.g., em-dash `—`, UTF-8 multi-byte) cause pasm to misparse subsequent instructions. ASCII-only comments work fine.

**Workaround:** Strip comments from `.spc` before feeding to pasm.

## 3. Global Variable Addressing: Flat vs Segmented

pasm patches global symbols with absolute byte offsets (`code_size + data_size + word_index`). But pvm's `loadg`/`storeg` treat operands as word indices and multiply by 3.

**Result:** Globals are addressed at 3x their intended offset.

**Fix options:**
- pvm: Remove `*3` in loadg/storeg, use byte offsets directly
- pasm: Store word indices instead of byte offsets for globals
- pvm: Set `gp = code_seg` for flat memory model (code+data+globals contiguous)

## 4. Two-Pass Symbol Duplication

pasm's two-pass assembly adds symbols to the table in BOTH passes. With a 17-entry table (160 bytes / 9 bytes per entry), programs with >8 unique symbols overflow during pass 2.

**Fix needed:** Either reset the table between passes, or skip adding in pass 2.
