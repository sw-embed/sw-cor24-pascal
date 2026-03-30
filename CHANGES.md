# Changelog

## 2026-03-30 — Repository consolidation

- Forked from `softwarewrighter/p24c` to `sw-embed/sw-cor24-pascal`
- Moved compiler contents into `compiler/` subdirectory
- Copied runtime library from `pr24p` into `runtime/`
- Updated all scripts to reference `sw-cor24-pcode` sibling repo
- Fixed code_ptr address (0x0A0F -> 0x0A12) for current PVM
- Added `scripts/relocate_p24.py` (was in /tmp)
- Added top-level `scripts/build.sh`
- Verified: 15 compiler tests pass, runtime tests pass
