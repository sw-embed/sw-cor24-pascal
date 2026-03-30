; p24p Phase 0 Runtime Library
; Provides writeln support: _p24p_write_int, _p24p_write_bool, _p24p_write_ln
; These routines use sys 1 (PUTC) to output characters to UART.

; _p24p_write_int - print signed integer to UART
; Stack: ( n -- )
; Handles negative numbers, converts to decimal digits via recursion.
.proc _p24p_write_int 0
    enter 0
    ; Check if negative
    loada 0
    push 0
    lt
    jz wi_pos
    ; Print '-'
    push 45
    sys 1
    ; Negate
    loada 0
    neg
    storea 0
wi_pos:
    ; If n < 10, single digit
    loada 0
    push 10
    lt
    jnz wi_single
    ; n >= 10: recursively print n/10
    loada 0
    push 10
    div
    call _p24p_write_int
    ; Then print n mod 10 as digit
    loada 0
    push 10
    mod
    push 48
    add
    sys 1
    ret 1
wi_single:
    ; Single digit: print n + '0'
    loada 0
    push 48
    add
    sys 1
    ret 1
.end

; _p24p_write_bool - print "TRUE" or "FALSE" to UART
; Stack: ( b -- )
.proc _p24p_write_bool 0
    enter 0
    loada 0
    jz wb_false
    ; Print "TRUE"
    push 84
    sys 1
    push 82
    sys 1
    push 85
    sys 1
    push 69
    sys 1
    ret 1
wb_false:
    ; Print "FALSE"
    push 70
    sys 1
    push 65
    sys 1
    push 76
    sys 1
    push 83
    sys 1
    push 69
    sys 1
    ret 1
.end

; _p24p_write_ln - print newline to UART
; Stack: ( -- )
.proc _p24p_write_ln 0
    enter 0
    push 10
    sys 1
    ret 0
.end
