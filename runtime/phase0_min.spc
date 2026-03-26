; Minimal runtime for pasm pipeline testing
; Uses short label names to fit pasm symbol table

.proc _p24p_write_int 0
    enter 0
    loada 0
    push 0
    lt
    jz P
    push 45
    sys 1
    loada 0
    neg
    storea 0
P:
    loada 0
    push 10
    lt
    jnz S
    loada 0
    push 10
    div
    call _p24p_write_int
    loada 0
    push 10
    mod
    push 48
    add
    sys 1
    ret 1
S:
    loada 0
    push 48
    add
    sys 1
    ret 1
.end

.proc _p24p_write_ln 0
    enter 0
    push 10
    sys 1
    ret 0
.end
