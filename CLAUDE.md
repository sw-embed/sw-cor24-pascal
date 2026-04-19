# sw-cor24-pascal -- Claude Instructions

## Project Overview

Pascal compiler (`p24p`) and runtime library (`pr24p`) targeting the
COR24 p-code VM. The compiler is written in C and cross-compiled to
COR24 assembly by `tc24r`; the resulting `compiler/p24p.s` runs on
the COR24 emulator and reads Pascal source over UART, emitting `.spc`
p-code assembler text. The runtime library is a mix of hand-written
`.spc` (the canonical artifacts, `runtime/runtime.spc` and
`runtime/runtime-unit.spc`) and `.pas` files documenting the
intended self-hosted implementation.

```
compiler/    Pascal compiler (C source in src/, generated p24p.s)
runtime/     Runtime library (.spc + .pas + tests)
scripts/     Repo-wide helpers (build.sh, relocate_p24.py)
docs/        Repo-wide design notes (each subproject also has docs/)
CHANGES.md   Changelog (update when closing an issue or landing a fix)
```

Key design docs (read before working on the corresponding area):

- `compiler/docs/research.txt` -- p-code VM design, Pascal compiler
  architecture, bootstrapping strategy.
- `compiler/docs/c-and-pascal-implementation.md` -- what's in C vs
  Pascal, phase breakdown, runtime dogfooding plan.
- `compiler/docs/tc24r-bug-report-feature-request.md` -- known
  tc24r issues and workarounds.
- `compiler/docs/pasm-limitations.md`, `pascal-subset.md`,
  `phase1-spec.md`.
- `runtime/docs/runtime.md` -- runtime library specification:
  phases, routines, stack effects, syscall interface, linking model.
- `runtime/docs/research.txt` -- memory model, bootstrap strategy.

## Toolchain Pipeline

```
.pas
  |
  v
p24p (compiler/p24p.s on cor24-run, reads via UART)
  |
  v
.spc  +  runtime/runtime.spc
  |
  v
pl24r (linker)
  |
  v
pa24r (assembler)  ->  .p24
  |
  v
pvm.s on cor24-run
```

Unit mode adds a second path using `pa24r` plus `p24-load` (module
loader) with a pre-assembled `runtime/p24p_rt.p24`. See
`compiler/scripts/run-pascal-unit.sh` and
`compiler/scripts/run-multi-unit.sh`.

## External Dependencies

Sibling repos (under `$ORGROOT`, i.e. `sw-embed/`):

- `sw-cor24-pcode` -- `pa24r` (assembler), `pl24r` (linker),
  `p24-load` (module loader), `vm/pvm.s` (the p-code VM). Build
  first with `./scripts/build.sh` (runs `cargo build --release`
  there).
- `sw-cor24-emulator` (a.k.a. `cor24-rs`) -- `cor24-run`, the
  emulator used to execute `p24p.s`, `pvm.s`, and `pvmasm.s`.
- `tc24r` (in `sw-vibe-coding/tc24r`) -- the C-to-COR24 compiler
  used to rebuild `compiler/p24p.s` from `compiler/src/*.c`.

## Build / Test

From the repo root:

```bash
./scripts/build.sh                                    # build pa24r/pl24r/p24-load in sibling repo
./compiler/scripts/run-pascal.sh <file.pas>           # single-unit: compile + link + assemble + run
./compiler/scripts/run-pascal-unit.sh <file.pas>      # unit-mode single-file pipeline
./compiler/scripts/run-multi-unit.sh <main.pas> <u.pas> [u2.pas ...]
./compiler/scripts/test-all.sh                        # full regression suite
./compiler/scripts/demo.sh <file.pas>                 # one program with full pipeline visibility
```

From `compiler/` (justfile):

```bash
just build                   # regenerate p24p.s from src/main.c via tc24r
just run <file.pas>          # feed file to p24p.s over UART, print .spc to stdout
just test                    # unit tests: lexer + parser + codegen + phase1 lexer
just test-e2e                # delegates to scripts/test-all.sh
just build-runtime-unit      # pre-assemble runtime-unit.spc -> runtime/p24p_rt.p24
```

Isolating a single regression test: run
`./compiler/scripts/run-pascal.sh compiler/tests/tNN_name.pas` and
diff against `compiler/tests/expected/tNN_name.txt`. Optional UART
input lives at `compiler/tests/expected/tNN_name.input`. A test
with no `expected/*.txt` is reported as SKIP, not FAIL.

Runtime tests are standalone `.spc` files exercised directly by
`pvmasm`:

```bash
content=$(cat runtime/tests/test_write_int.spc)
cor24-run --run ~/github/sw-vibe-coding/pv24a/pvmasm.s \
  -u "${content}"$'\x04' --speed 0 -n 50000000
```

## Non-Obvious Conventions

- **`compiler/p24p.s` is a generated, checked-in artifact.** Edit
  `compiler/src/*.c` and regenerate with `just build`. Hand-edits
  will be clobbered on the next rebuild and break the bootstrap
  snapshot downstream tools depend on.
- **Test naming drives `test-all.sh` dispatch:** `t*.pas` starting
  with `unit ` -> unit-declaration compile-only test; `*_multi_*.pas`
  -> multi-unit pipeline (unit deps auto-discovered by matching
  `t<num>_*.pas`); `*_unit*.pas` -> unit-mode pipeline; anything
  else -> single-unit pipeline.
- **UART has a ~4KB terminal buffer limit,** so run scripts feed
  source into `p24p.s` with `-u <preloaded>"\x04"` (EOT-terminated)
  instead of `--terminal`.
- **`code_ptr` address must be resolved dynamically** from the PVM
  image (`cor24-run --run pvm.s -e code_ptr`) and patched at load
  time; it is not a fixed address.
- **Programs are relocated to load address `0x010000`** via
  `scripts/relocate_p24.py`, and `p24-load` is invoked with
  `--load-addr 0x010000` so `push <data_ref>` operands resolve to
  absolute VM addresses.
- **All runtime identifiers use the `_p24p_` prefix** to avoid
  colliding with user Pascal identifiers.
- **File extensions:** `.pas` = Pascal source; `.spc` = p-code
  assembler source (hand-written or compiler output); `.p24` =
  assembled p-code bytecode.
- **When hand-writing `.spc` for pvmasm** (e.g. in `runtime/tests/`):
  `.proc` auto-emits `enter` and `.end` auto-emits `leave` -- do
  NOT add them explicitly; `main` must be the first `.proc` (VM
  starts at address 0); pvmasm's `input_buf` is 512 bytes so test
  `.spc` files must be compact (strip comments, short names); EOT
  (`\x04`) terminates UART input; `.module`/`.export`/`.endmodule`
  directives are silently ignored.
- **VM syscall interface** (for runtime code):
  `0=HALT (--)`, `1=PUTC (c--)`, `2=GETC (--c)`, `3=LED (n--)`,
  `4=ALLOC (size--addr)`, `5=FREE (addr--)`.

## COR24 C Constraints (for work on `compiler/src/*.c` via tc24r)

- Single translation unit (no linker).
- No function pointers; use switch/case for dispatch.
- No floating point (COR24 has no FPU).
- `malloc` is a bump allocator; `free` is a no-op.
- All integers are 24-bit (3 bytes).
- Standard headers come from `~/github/sw-vibe-coding/tc24r/include/`
  (use `-I`).

## CRITICAL: Git Branching Workflow (devgroup policy)

This clone is downstream of a coordinator-gated integration model:

- `main` and `dev` are coordinator-only. **Never commit to them
  directly, and never `git push`.** The coordinator (mike) relays
  ready branches into `dev` and pushes.
- Do all work on `feat/<slug>` or `fix/<slug>` branches, based on
  local `dev` (which tracks the integration branch).
- When work is ready for integration, rename the branch to
  `pr/<slug>` so the coordinator's scan picks it up.
- The ref name is the contract -- no PR API, no JSON, no tickets,
  no `gh pr create`.

### Helpers (on `$PATH` via `$SCRIPTROOT`)

```bash
onboarding               # session briefing: paths, policy, repo state
dg-env                   # environment dump
dg-policy                # reprint the branch policy
dg-new-feature <slug>    # switch dev, fetch, create feat/<slug>
dg-new-fix <slug>        # same flavor, fix/<slug>
dg-mark-pr               # rename current feat/*|fix/* -> pr/*
dg-list-pr               # list local pr/* branches (ready signals)
dg-reap                  # fetch; FF dev; delete pr/* merged into origin/dev
```

### Rules

- **Never `git push`** -- the coordinator handles all pushes.
- **Never commit to `main` or `dev`** -- always work on `feat/*`
  or `fix/*`.
- Base new branches on `origin/dev`; fall back to `origin/main`
  only when `origin/dev` does not exist yet.
- No history rewrites on `dev` or `main`. Rebase is fine on your
  own `feat/*` / `fix/*` before marking `pr/*`.
- After the coordinator merges `pr/<slug>` into `origin/dev`, run
  `dg-reap` to fast-forward local `dev` and delete the merged
  branch.

Full policy:
`/disk1/github/softwarewrighter/devgroup/docs/branching-pr-strategy.md`

## CRITICAL: AgentRail Session Protocol (MUST follow exactly)

Each AgentRail step maps to one `feat/<slug>` (or `fix/<slug>`)
branch. Create the branch BEFORE doing the work, and rename it to
`pr/<slug>` AFTER `agentrail complete`.

### 1. START (do this FIRST, before anything else)
```bash
onboarding     # paths, branch policy, helpers, current repo state
agentrail next # current step prompt + plan context
```

### 2. BRANCH (create a work branch for the step)
```bash
dg-new-feature <slug>    # or dg-new-fix <slug> for a bug fix
```
Use the step's slug as the topic. This switches to `dev`, fetches,
and creates `feat/<slug>`.

### 3. BEGIN (tell AgentRail the step is started)
```bash
agentrail begin
```

### 4. WORK (do what the step prompt says)
Do NOT ask "want me to proceed?". The step prompt IS your
instruction. Execute it directly.

### 5. COMMIT (after the work is done)
Commit your code changes with git on the `feat/<slug>` branch. Do
NOT push -- the coordinator handles pushes.

### 6. COMPLETE (after committing)
```bash
agentrail complete --summary "what you accomplished" \
  --reward 1 \
  --actions "tools and approach used"
```
- If the step failed: `--reward -1 --failure-mode "what went wrong"`
- If the saga is finished: add `--done`

### 7. MARK PR (signal ready-to-merge)
```bash
dg-mark-pr               # renames feat/<slug> -> pr/<slug>
```

### 8. STOP (after mark-pr, DO NOT continue working)
Do NOT make further code changes after `dg-mark-pr`. Any changes
after complete/mark-pr are outside the step's recorded scope.
Future work belongs in the NEXT step on a NEW branch.

Before starting the next step, fast-forward local `dev`:
```bash
dg-reap     # or: git switch dev && git fetch --all --prune && git merge --ff-only
```

## Key Rules

- **Never push** -- coordinator-only.
- **Never commit to `main` or `dev`** -- always work on `feat/*`
  or `fix/*`.
- **Do NOT skip AgentRail steps** -- the next session depends on
  accurate tracking.
- **Do NOT ask for permission** -- the step prompt is the instruction.
- **Do NOT continue working** after `dg-mark-pr`.
- **Commit before complete** -- always commit first, then record
  completion, then mark-pr.
- **Never hand-edit `compiler/p24p.s`** -- regenerate from C source.

## Available AgentRail Task Types

`cor24-c` (C source in `compiler/src/`), `cor24-asm` (hand-written
`.spc` in `runtime/`), `pre-commit`.

## Useful Commands

```bash
agentrail status          # current saga state
agentrail history         # all completed steps
agentrail plan            # view the plan
agentrail next            # current step + context
```

## Cross-Repo Context

All COR24 repos live under `$ORGROOT` (`.../sw-embed/`) as siblings.
Most relevant to this project:

- `sw-cor24-pcode` -- p-code VM, assembler (`pa24r`), linker
  (`pl24r`), module loader (`p24-load`).
- `sw-cor24-emulator` -- `cor24-run` emulator + native assembler.
- `sw-cor24-plsw` -- alternate Pascal-to-p-code compiler.
- `sw-cor24-basic` -- BASIC interpreter, another front-end for the
  p-code VM.
- `sw-cor24-project` -- ecosystem umbrella / migration tracking.

`tc24r` lives in `~/github/sw-vibe-coding/tc24r` (not under
`sw-embed/`).
