        .text

        .globl  _start
_start:
        la      r0,_main
        jal     r1,(r0)
_halt:
        bra     _halt

        .globl  __putc_uart
__putc_uart:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L1:
        la      r0,16711937
        lbu     r0,0(r0)
        la      r1,128
        and     r0,r1
        ceq     r0,z
        brt     L2
        bra     L1
L2:
        la      r0,16711936
        mov     r1,r0
        lw      r0,9(fp)
        sb      r0,0(r1)
L0:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _getchar
_getchar:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L4:
        la      r0,16711937
        lbu     r0,0(r0)
        lc      r1,1
        and     r0,r1
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L5
        bra     L4
L5:
        la      r0,16711936
        lbu     r0,0(r0)
L3:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __print_int
__print_int:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-11
        lw      r0,9(fp)
        cls     r0,z
        brf     L8
        lc      r0,45
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        lw      r1,9(fp)
        sub     r0,r1
        sw      r0,9(fp)
L8:
        lw      r0,9(fp)
        ceq     r0,z
        brf     L10
        lc      r0,48
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L6
        jmp     (r2)
L10:
        lc      r0,0
        sw      r0,-11(fp)
L11:
        lw      r0,9(fp)
        lc      r1,0
        cls     r1,r0
        brt     L15
        la      r2,L12
        jmp     (r2)
L15:
        lc      r0,48
        push    r0
        lw      r0,9(fp)
        lc      r1,10
        push    r1
        push    r0
        la      r0,__tc24r_mod
        jal     r1,(r0)
        add     sp,6
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        lc      r0,-8
        add     r0,fp
        lw      r1,-11(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,9(fp)
        lc      r1,10
        push    r1
        push    r0
        la      r0,__tc24r_div
        jal     r1,(r0)
        add     sp,6
        sw      r0,9(fp)
        lw      r0,-11(fp)
        push    r0
        add     r0,1
        sw      r0,-11(fp)
        pop     r0
        la      r2,L11
        jmp     (r2)
L12:
L13:
        lw      r0,-11(fp)
        lc      r1,0
        cls     r1,r0
        brf     L14
        lw      r0,-11(fp)
        push    r0
        add     r0,-1
        sw      r0,-11(fp)
        pop     r0
        lc      r0,-8
        add     r0,fp
        lw      r1,-11(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        bra     L13
L14:
L6:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __print_hex
__print_hex:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-12
        lw      r0,9(fp)
        ceq     r0,z
        brf     L18
        lc      r0,48
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L16
        jmp     (r2)
L18:
        lc      r0,0
        sw      r0,-9(fp)
L19:
        lw      r0,9(fp)
        lc      r1,0
        cls     r1,r0
        brt     L25
        la      r2,L20
        jmp     (r2)
L25:
        lw      r0,9(fp)
        lc      r1,15
        and     r0,r1
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        lc      r1,10
        cls     r0,r1
        brf     L21
        lc      r0,48
        lw      r1,-12(fp)
        add     r0,r1
        push    r0
        lc      r0,-6
        add     r0,fp
        lw      r1,-9(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        bra     L22
L21:
        lc      r0,87
        lw      r1,-12(fp)
        add     r0,r1
        push    r0
        lc      r0,-6
        add     r0,fp
        lw      r1,-9(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
L22:
        lw      r0,9(fp)
        lc      r1,4
        sra     r0,r1
        sw      r0,9(fp)
        lw      r0,-9(fp)
        push    r0
        add     r0,1
        sw      r0,-9(fp)
        pop     r0
        la      r2,L19
        jmp     (r2)
L20:
L23:
        lw      r0,-9(fp)
        lc      r1,0
        cls     r1,r0
        brf     L24
        lw      r0,-9(fp)
        push    r0
        add     r0,-1
        sw      r0,-9(fp)
        pop     r0
        lc      r0,-6
        add     r0,fp
        lw      r1,-9(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        bra     L23
L24:
L16:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __print_str
__print_str:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L27:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brt     L28
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        bra     L27
L28:
L26:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __fmt_one
__fmt_one:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lc      r1,100
        ceq     r0,r1
        brf     L30
        lw      r0,12(fp)
        push    r0
        la      r0,__print_int
        jal     r1,(r0)
        add     sp,3
        la      r2,L31
        jmp     (r2)
L30:
        lw      r0,9(fp)
        lc      r1,120
        ceq     r0,r1
        brf     L32
        lw      r0,12(fp)
        push    r0
        la      r0,__print_hex
        jal     r1,(r0)
        add     sp,3
        la      r2,L33
        jmp     (r2)
L32:
        lw      r0,9(fp)
        lc      r1,99
        ceq     r0,r1
        brf     L34
        lw      r0,12(fp)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        bra     L35
L34:
        lw      r0,9(fp)
        lc      r1,115
        ceq     r0,r1
        brf     L36
        lw      r0,12(fp)
        push    r0
        la      r0,__print_str
        jal     r1,(r0)
        add     sp,3
        bra     L37
L36:
        lw      r0,9(fp)
        lc      r1,37
        ceq     r0,r1
        brf     L38
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        bra     L39
L38:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L39:
L37:
L35:
L33:
L31:
L29:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf0
___tc24r_printf0:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L41:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L47
        la      r2,L42
        jmp     (r2)
L47:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brf     L43
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brf     L45
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        bra     L46
L45:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L46:
        bra     L44
L43:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L44:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L41
        jmp     (r2)
L42:
        lc      r0,0
L40:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf1
___tc24r_printf1:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L49:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L58
        la      r2,L50
        jmp     (r2)
L58:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brt     L57
        la      r2,L51
        jmp     (r2)
L57:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brf     L53
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        bra     L54
L53:
        lw      r0,-3(fp)
        ceq     r0,z
        brf     L55
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        bra     L56
L55:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L56:
L54:
        bra     L52
L51:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L52:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L49
        jmp     (r2)
L50:
        lc      r0,0
L48:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf2
___tc24r_printf2:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L60:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L71
        la      r2,L61
        jmp     (r2)
L71:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brt     L70
        la      r2,L62
        jmp     (r2)
L70:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brf     L64
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L65
        jmp     (r2)
L64:
        lw      r0,-3(fp)
        ceq     r0,z
        brf     L66
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        bra     L67
L66:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L68
        lw      r0,15(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        bra     L69
L68:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L69:
L67:
L65:
        bra     L63
L62:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L63:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L60
        jmp     (r2)
L61:
        lc      r0,0
L59:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf3
___tc24r_printf3:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L73:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L86
        la      r2,L74
        jmp     (r2)
L86:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brt     L85
        la      r2,L75
        jmp     (r2)
L85:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        lc      r1,37
        ceq     r0,r1
        brf     L77
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L78
        jmp     (r2)
L77:
        lw      r0,-3(fp)
        ceq     r0,z
        brf     L79
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L80
        jmp     (r2)
L79:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L81
        lw      r0,15(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        bra     L82
L81:
        lw      r0,-3(fp)
        lc      r1,2
        ceq     r0,r1
        brf     L83
        lw      r0,18(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        bra     L84
L83:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L84:
L82:
L80:
L78:
        bra     L76
L75:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L76:
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L73
        jmp     (r2)
L74:
        lc      r0,0
L72:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _strcmp
_strcmp:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L88:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brt     L92
        lw      r0,12(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brt     L92
        lc      r0,1
        bra     L93
L92:
        lc      r0,0
L93:
        ceq     r0,z
        brt     L90
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,12(fp)
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L90
        lc      r0,1
        bra     L91
L90:
        lc      r0,0
L91:
        ceq     r0,z
        brt     L89
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,12(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,12(fp)
        la      r2,L88
        jmp     (r2)
L89:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,12(fp)
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
L87:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lex_is_alpha
_lex_is_alpha:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lc      r1,97
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L99
        lw      r0,9(fp)
        lc      r1,122
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L99
        lc      r0,1
        bra     L100
L99:
        lc      r0,0
L100:
        ceq     r0,z
        brf     L97
        lw      r0,9(fp)
        lc      r1,65
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L101
        lw      r0,9(fp)
        lc      r1,90
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L101
        lc      r0,1
        bra     L102
L101:
        lc      r0,0
L102:
        ceq     r0,z
        brf     L97
        lc      r0,0
        bra     L98
L97:
        lc      r0,1
L98:
        ceq     r0,z
        brf     L95
        lw      r0,9(fp)
        lc      r1,95
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L95
        lc      r0,0
        bra     L96
L95:
        lc      r0,1
L96:
L94:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lex_is_digit
_lex_is_digit:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lc      r1,48
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L104
        lw      r0,9(fp)
        lc      r1,57
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L104
        lc      r0,1
        bra     L105
L104:
        lc      r0,0
L105:
L103:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lex_to_lower
_lex_to_lower:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lc      r1,65
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L109
        lw      r0,9(fp)
        lc      r1,90
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L109
        lc      r0,1
        bra     L110
L109:
        lc      r0,0
L110:
        ceq     r0,z
        brt     L108
        lw      r0,9(fp)
        lc      r1,32
        add     r0,r1
        bra     L106
L108:
        lw      r0,9(fp)
L106:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lex_advance
_lex_advance:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        brt     L113
        lc      r0,0
        bra     L111
L113:
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        sw      r0,-3(fp)
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_pos
        sw      r0,0(r1)
        lw      r0,-3(fp)
        lc      r1,10
        ceq     r0,r1
        brf     L115
        la      r1,_lex_line
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_line
        sw      r0,0(r1)
L115:
        lw      r0,-3(fp)
L111:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lex_skip_ws
_lex_skip_ws:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
L117:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        brt     L150
        la      r2,L118
        jmp     (r2)
L150:
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L125
        lw      r0,-3(fp)
        lc      r1,9
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L125
        lc      r0,0
        bra     L126
L125:
        lc      r0,1
L126:
        ceq     r0,z
        brf     L123
        lw      r0,-3(fp)
        lc      r1,13
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L123
        lc      r0,0
        bra     L124
L123:
        lc      r0,1
L124:
        ceq     r0,z
        brf     L121
        lw      r0,-3(fp)
        lc      r1,10
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L121
        lc      r0,0
        bra     L122
L121:
        lc      r0,1
L122:
        ceq     r0,z
        brt     L119
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r2,L120
        jmp     (r2)
L119:
        lw      r0,-3(fp)
        lc      r1,123
        ceq     r0,r1
        brt     L149
        la      r2,L127
        jmp     (r2)
L149:
        la      r0,_lex_advance
        jal     r1,(r0)
L129:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L131
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,125
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L131
        lc      r0,1
        bra     L132
L131:
        lc      r0,0
L132:
        ceq     r0,z
        brt     L130
        la      r0,_lex_advance
        jal     r1,(r0)
        bra     L129
L130:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        brf     L134
        la      r0,_lex_advance
        jal     r1,(r0)
L134:
        la      r2,L128
        jmp     (r2)
L127:
        lw      r0,-3(fp)
        lc      r1,40
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L139
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L139
        lc      r0,1
        bra     L140
L139:
        lc      r0,0
L140:
        ceq     r0,z
        brt     L137
        la      r1,_lex_src
        lw      r0,0(r1)
        push    r0
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,42
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L137
        lc      r0,1
        bra     L138
L137:
        lc      r0,0
L138:
        ceq     r0,z
        brf     L148
        la      r2,L135
        jmp     (r2)
L148:
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_lex_advance
        jal     r1,(r0)
L141:
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        brt     L147
        la      r2,L142
        jmp     (r2)
L147:
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,42
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L145
        la      r1,_lex_src
        lw      r0,0(r1)
        push    r0
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,41
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L145
        lc      r0,1
        bra     L146
L145:
        lc      r0,0
L146:
        ceq     r0,z
        brt     L144
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_lex_advance
        jal     r1,(r0)
        bra     L142
L144:
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r2,L141
        jmp     (r2)
L142:
        bra     L136
L135:
        bra     L118
L136:
L128:
L120:
        la      r2,L117
        jmp     (r2)
L118:
L116:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lex_keyword
_lex_keyword:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_S0
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L153
        lc      r0,0
        la      r2,L151
        jmp     (r2)
L153:
        la      r0,_S1
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L155
        lc      r0,1
        la      r2,L151
        jmp     (r2)
L155:
        la      r0,_S2
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L157
        lc      r0,2
        la      r2,L151
        jmp     (r2)
L157:
        la      r0,_S3
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L159
        lc      r0,3
        la      r2,L151
        jmp     (r2)
L159:
        la      r0,_S4
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L161
        lc      r0,4
        la      r2,L151
        jmp     (r2)
L161:
        la      r0,_S5
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L163
        lc      r0,5
        la      r2,L151
        jmp     (r2)
L163:
        la      r0,_S6
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L165
        lc      r0,6
        la      r2,L151
        jmp     (r2)
L165:
        la      r0,_S7
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L167
        lc      r0,7
        la      r2,L151
        jmp     (r2)
L167:
        la      r0,_S8
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L169
        lc      r0,8
        la      r2,L151
        jmp     (r2)
L169:
        la      r0,_S9
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L171
        lc      r0,9
        la      r2,L151
        jmp     (r2)
L171:
        la      r0,_S10
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L173
        lc      r0,10
        la      r2,L151
        jmp     (r2)
L173:
        la      r0,_S11
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L175
        lc      r0,11
        la      r2,L151
        jmp     (r2)
L175:
        la      r0,_S12
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L177
        lc      r0,12
        la      r2,L151
        jmp     (r2)
L177:
        la      r0,_S13
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L179
        lc      r0,13
        la      r2,L151
        jmp     (r2)
L179:
        la      r0,_S14
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L181
        lc      r0,14
        la      r2,L151
        jmp     (r2)
L181:
        la      r0,_S15
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L183
        lc      r0,15
        la      r2,L151
        jmp     (r2)
L183:
        la      r0,_S16
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L185
        lc      r0,16
        la      r2,L151
        jmp     (r2)
L185:
        la      r0,_S17
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L187
        lc      r0,17
        la      r2,L151
        jmp     (r2)
L187:
        la      r0,_S18
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L189
        lc      r0,18
        la      r2,L151
        jmp     (r2)
L189:
        la      r0,_S19
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L191
        lc      r0,19
        la      r2,L151
        jmp     (r2)
L191:
        la      r0,_S20
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L193
        lc      r0,40
        la      r2,L151
        jmp     (r2)
L193:
        la      r0,_S21
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L195
        lc      r0,41
        la      r2,L151
        jmp     (r2)
L195:
        la      r0,_S22
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L197
        lc      r0,42
        la      r2,L151
        jmp     (r2)
L197:
        la      r0,_S23
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L199
        lc      r0,43
        la      r2,L151
        jmp     (r2)
L199:
        la      r0,_S24
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L201
        lc      r0,44
        la      r2,L151
        jmp     (r2)
L201:
        la      r0,_S25
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L203
        lc      r0,45
        la      r2,L151
        jmp     (r2)
L203:
        la      r0,_S26
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L205
        lc      r0,46
        la      r2,L151
        jmp     (r2)
L205:
        la      r0,_S27
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L207
        lc      r0,47
        la      r2,L151
        jmp     (r2)
L207:
        la      r0,_S28
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L209
        lc      r0,48
        la      r2,L151
        jmp     (r2)
L209:
        la      r0,_S29
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L211
        lc      r0,49
        la      r2,L151
        jmp     (r2)
L211:
        la      r0,_S30
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L213
        lc      r0,50
        la      r2,L151
        jmp     (r2)
L213:
        la      r0,_S31
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L215
        lc      r0,51
        la      r2,L151
        jmp     (r2)
L215:
        la      r0,_S32
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L217
        lc      r0,52
        la      r2,L151
        jmp     (r2)
L217:
        la      r0,_S33
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L219
        lc      r0,53
        la      r2,L151
        jmp     (r2)
L219:
        la      r0,_S34
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L221
        lc      r0,54
        la      r2,L151
        jmp     (r2)
L221:
        la      r0,_S35
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L223
        lc      r0,55
        la      r2,L151
        jmp     (r2)
L223:
        la      r0,_S36
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L225
        lc      r0,56
        la      r2,L151
        jmp     (r2)
L225:
        la      r0,_S37
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L227
        lc      r0,62
        la      r2,L151
        jmp     (r2)
L227:
        la      r0,_S38
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L229
        lc      r0,63
        la      r2,L151
        jmp     (r2)
L229:
        la      r0,_S39
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L231
        lc      r0,64
        la      r2,L151
        jmp     (r2)
L231:
        la      r0,_S40
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L233
        lc      r0,66
        bra     L151
L233:
        la      r0,_S41
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L235
        lc      r0,67
        bra     L151
L235:
        la      r0,_S42
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L237
        lc      r0,68
        bra     L151
L237:
        lc      r0,36
L151:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _lexer_init
_lexer_init:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        la      r1,_lex_src
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_lex_pos
        sw      r0,0(r1)
        lw      r0,12(fp)
        la      r1,_lex_len
        sw      r0,0(r1)
        lc      r0,1
        la      r1,_lex_line
        sw      r0,0(r1)
        lc      r0,38
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,1
        la      r1,_tok_line
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_tok_int_val
        sw      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        la      r0,_tok_str_val
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,0
        la      r1,_tok_str_len
        sw      r0,0(r1)
L238:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _next_token
_next_token:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        la      r0,_lex_skip_ws
        jal     r1,(r0)
        la      r1,_lex_line
        lw      r0,0(r1)
        la      r1,_tok_line
        sw      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        brt     L241
        lc      r0,38
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,38
        la      r2,L239
        jmp     (r2)
L241:
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        push    r0
        la      r0,_lex_is_alpha
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        brf     L336
        la      r2,L243
        jmp     (r2)
L336:
        lc      r0,0
        sw      r0,-6(fp)
L244:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L335
        la      r2,L246
        jmp     (r2)
L335:
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_lex_is_alpha
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        brf     L248
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_lex_is_digit
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        brf     L248
        lc      r0,0
        bra     L249
L248:
        lc      r0,1
L249:
        ceq     r0,z
        brt     L246
        lc      r0,1
        bra     L247
L246:
        lc      r0,0
L247:
        ceq     r0,z
        brf     L334
        la      r2,L245
        jmp     (r2)
L334:
        lw      r0,-6(fp)
        push    r0
        lc      r0,64
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        brf     L251
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_lex_to_lower
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_tok_lexeme
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
L251:
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_pos
        sw      r0,0(r1)
        la      r2,L244
        jmp     (r2)
L245:
        la      r0,_tok_lexeme
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        push    r0
        la      r0,_lex_keyword
        jal     r1,(r0)
        add     sp,3
        la      r1,_tok_type
        sw      r0,0(r1)
        la      r1,_tok_type
        lw      r0,0(r1)
        la      r2,L239
        jmp     (r2)
L243:
        lw      r0,-3(fp)
        push    r0
        la      r0,_lex_is_digit
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        brf     L333
        la      r2,L253
        jmp     (r2)
L333:
        lc      r0,0
        sw      r0,-6(fp)
        lc      r0,0
        la      r1,_tok_int_val
        sw      r0,0(r1)
L254:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L256
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_lex_is_digit
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        brt     L256
        lc      r0,1
        bra     L257
L256:
        lc      r0,0
L257:
        ceq     r0,z
        brf     L332
        la      r2,L255
        jmp     (r2)
L332:
        lw      r0,-6(fp)
        push    r0
        lc      r0,64
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        brf     L259
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_tok_lexeme
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
L259:
        la      r1,_tok_int_val
        lw      r0,0(r1)
        lc      r1,10
        mul     r0,r1
        push    r0
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,_tok_int_val
        sw      r0,0(r1)
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_pos
        sw      r0,0(r1)
        la      r2,L254
        jmp     (r2)
L255:
        la      r0,_tok_lexeme
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,37
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,37
        la      r2,L239
        jmp     (r2)
L253:
        lw      r0,-3(fp)
        lc      r1,39
        ceq     r0,r1
        brt     L331
        la      r2,L261
        jmp     (r2)
L331:
        la      r0,_lex_advance
        jal     r1,(r0)
        lc      r0,0
        sw      r0,-9(fp)
L262:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L264
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,39
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L264
        lc      r0,1
        bra     L265
L264:
        lc      r0,0
L265:
        ceq     r0,z
        brf     L330
        la      r2,L263
        jmp     (r2)
L330:
        lw      r0,-9(fp)
        push    r0
        la      r0,256
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        brf     L267
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_tok_str_val
        lw      r1,-9(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
L267:
        la      r1,_lex_pos
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_lex_pos
        sw      r0,0(r1)
        la      r2,L262
        jmp     (r2)
L263:
        la      r0,_tok_str_val
        lw      r1,-9(fp)
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lw      r0,-9(fp)
        la      r1,_tok_str_len
        sw      r0,0(r1)
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        brf     L269
        la      r0,_lex_advance
        jal     r1,(r0)
L269:
        lw      r0,-9(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L271
        la      r0,_tok_str_val
        lc      r1,0
        add     r0,r1
        lbu     r0,0(r0)
        la      r1,_tok_int_val
        sw      r0,0(r1)
        la      r0,_tok_str_val
        lc      r1,0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,60
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,60
        la      r2,L239
        jmp     (r2)
L271:
        lc      r0,0
        sw      r0,-6(fp)
L272:
        lw      r0,-6(fp)
        lw      r1,-9(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L274
        lw      r0,-6(fp)
        push    r0
        lc      r0,64
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L274
        lc      r0,1
        bra     L275
L274:
        lc      r0,0
L275:
        ceq     r0,z
        brt     L273
        la      r0,_tok_str_val
        lw      r1,-6(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_tok_lexeme
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
        la      r2,L272
        jmp     (r2)
L273:
        la      r0,_tok_lexeme
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,61
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,61
        la      r2,L239
        jmp     (r2)
L261:
        la      r0,_lex_advance
        jal     r1,(r0)
        lw      r0,-3(fp)
        lc      r1,58
        ceq     r0,r1
        brt     L329
        la      r2,L277
        jmp     (r2)
L329:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L280
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,61
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L280
        lc      r0,1
        bra     L281
L280:
        lc      r0,0
L281:
        ceq     r0,z
        brt     L279
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,58
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,61
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,20
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,20
        la      r2,L239
        jmp     (r2)
L279:
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,58
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,35
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,35
        la      r2,L239
        jmp     (r2)
L277:
        lw      r0,-3(fp)
        lc      r1,60
        ceq     r0,r1
        brt     L328
        la      r2,L283
        jmp     (r2)
L328:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L286
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,62
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L286
        lc      r0,1
        bra     L287
L286:
        lc      r0,0
L287:
        ceq     r0,z
        brt     L285
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,60
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,62
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,30
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,30
        la      r2,L239
        jmp     (r2)
L285:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L290
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,61
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L290
        lc      r0,1
        bra     L291
L290:
        lc      r0,0
L291:
        ceq     r0,z
        brt     L289
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,60
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,61
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,32
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,32
        la      r2,L239
        jmp     (r2)
L289:
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,60
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,31
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,31
        la      r2,L239
        jmp     (r2)
L283:
        lw      r0,-3(fp)
        lc      r1,62
        ceq     r0,r1
        brt     L327
        la      r2,L293
        jmp     (r2)
L327:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L296
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,61
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L296
        lc      r0,1
        bra     L297
L296:
        lc      r0,0
L297:
        ceq     r0,z
        brt     L295
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,62
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,61
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,34
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,34
        la      r2,L239
        jmp     (r2)
L295:
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,62
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,33
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,33
        la      r2,L239
        jmp     (r2)
L293:
        lw      r0,-3(fp)
        lc      r1,59
        ceq     r0,r1
        brf     L299
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,59
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,21
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,21
        la      r2,L239
        jmp     (r2)
L299:
        lw      r0,-3(fp)
        lc      r1,46
        ceq     r0,r1
        brt     L326
        la      r2,L301
        jmp     (r2)
L326:
        la      r1,_lex_pos
        lw      r0,0(r1)
        la      r1,_lex_len
        lw      r1,0(r1)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L304
        la      r1,_lex_src
        lw      r0,0(r1)
        la      r1,_lex_pos
        lw      r1,0(r1)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,46
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L304
        lc      r0,1
        bra     L305
L304:
        lc      r0,0
L305:
        ceq     r0,z
        brt     L303
        la      r0,_lex_advance
        jal     r1,(r0)
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,46
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,46
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,59
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,59
        la      r2,L239
        jmp     (r2)
L303:
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,46
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,22
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,22
        la      r2,L239
        jmp     (r2)
L301:
        lw      r0,-3(fp)
        lc      r1,44
        ceq     r0,r1
        brf     L307
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,44
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,23
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,23
        la      r2,L239
        jmp     (r2)
L307:
        lw      r0,-3(fp)
        lc      r1,40
        ceq     r0,r1
        brf     L309
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,40
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,24
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,24
        la      r2,L239
        jmp     (r2)
L309:
        lw      r0,-3(fp)
        lc      r1,41
        ceq     r0,r1
        brf     L311
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,41
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,25
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,25
        la      r2,L239
        jmp     (r2)
L311:
        lw      r0,-3(fp)
        lc      r1,43
        ceq     r0,r1
        brf     L313
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,43
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,26
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,26
        la      r2,L239
        jmp     (r2)
L313:
        lw      r0,-3(fp)
        lc      r1,45
        ceq     r0,r1
        brf     L315
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,45
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,27
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,27
        la      r2,L239
        jmp     (r2)
L315:
        lw      r0,-3(fp)
        lc      r1,42
        ceq     r0,r1
        brf     L317
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,42
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,28
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,28
        la      r2,L239
        jmp     (r2)
L317:
        lw      r0,-3(fp)
        lc      r1,61
        ceq     r0,r1
        brf     L319
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,61
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,29
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,29
        la      r2,L239
        jmp     (r2)
L319:
        lw      r0,-3(fp)
        lc      r1,91
        ceq     r0,r1
        brf     L321
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,91
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,57
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,57
        la      r2,L239
        jmp     (r2)
L321:
        lw      r0,-3(fp)
        lc      r1,93
        ceq     r0,r1
        brf     L323
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,93
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,58
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,58
        la      r2,L239
        jmp     (r2)
L323:
        lw      r0,-3(fp)
        lc      r1,94
        ceq     r0,r1
        brf     L325
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,94
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,65
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,65
        bra     L239
L325:
        la      r0,_tok_lexeme
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lw      r0,-3(fp)
        sb      r0,0(r1)
        la      r0,_tok_lexeme
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,39
        la      r1,_tok_type
        sw      r0,0(r1)
        lc      r0,39
L239:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _token_name
_token_name:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        ceq     r0,z
        brf     L339
        la      r0,_S43
        la      r2,L337
        jmp     (r2)
L339:
        lw      r0,9(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L341
        la      r0,_S44
        la      r2,L337
        jmp     (r2)
L341:
        lw      r0,9(fp)
        lc      r1,2
        ceq     r0,r1
        brf     L343
        la      r0,_S45
        la      r2,L337
        jmp     (r2)
L343:
        lw      r0,9(fp)
        lc      r1,3
        ceq     r0,r1
        brf     L345
        la      r0,_S46
        la      r2,L337
        jmp     (r2)
L345:
        lw      r0,9(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L347
        la      r0,_S47
        la      r2,L337
        jmp     (r2)
L347:
        lw      r0,9(fp)
        lc      r1,5
        ceq     r0,r1
        brf     L349
        la      r0,_S48
        la      r2,L337
        jmp     (r2)
L349:
        lw      r0,9(fp)
        lc      r1,6
        ceq     r0,r1
        brf     L351
        la      r0,_S49
        la      r2,L337
        jmp     (r2)
L351:
        lw      r0,9(fp)
        lc      r1,7
        ceq     r0,r1
        brf     L353
        la      r0,_S50
        la      r2,L337
        jmp     (r2)
L353:
        lw      r0,9(fp)
        lc      r1,8
        ceq     r0,r1
        brf     L355
        la      r0,_S51
        la      r2,L337
        jmp     (r2)
L355:
        lw      r0,9(fp)
        lc      r1,9
        ceq     r0,r1
        brf     L357
        la      r0,_S52
        la      r2,L337
        jmp     (r2)
L357:
        lw      r0,9(fp)
        lc      r1,10
        ceq     r0,r1
        brf     L359
        la      r0,_S53
        la      r2,L337
        jmp     (r2)
L359:
        lw      r0,9(fp)
        lc      r1,11
        ceq     r0,r1
        brf     L361
        la      r0,_S54
        la      r2,L337
        jmp     (r2)
L361:
        lw      r0,9(fp)
        lc      r1,12
        ceq     r0,r1
        brf     L363
        la      r0,_S55
        la      r2,L337
        jmp     (r2)
L363:
        lw      r0,9(fp)
        lc      r1,13
        ceq     r0,r1
        brf     L365
        la      r0,_S56
        la      r2,L337
        jmp     (r2)
L365:
        lw      r0,9(fp)
        lc      r1,14
        ceq     r0,r1
        brf     L367
        la      r0,_S57
        la      r2,L337
        jmp     (r2)
L367:
        lw      r0,9(fp)
        lc      r1,15
        ceq     r0,r1
        brf     L369
        la      r0,_S58
        la      r2,L337
        jmp     (r2)
L369:
        lw      r0,9(fp)
        lc      r1,16
        ceq     r0,r1
        brf     L371
        la      r0,_S59
        la      r2,L337
        jmp     (r2)
L371:
        lw      r0,9(fp)
        lc      r1,17
        ceq     r0,r1
        brf     L373
        la      r0,_S60
        la      r2,L337
        jmp     (r2)
L373:
        lw      r0,9(fp)
        lc      r1,18
        ceq     r0,r1
        brf     L375
        la      r0,_S61
        la      r2,L337
        jmp     (r2)
L375:
        lw      r0,9(fp)
        lc      r1,19
        ceq     r0,r1
        brf     L377
        la      r0,_S62
        la      r2,L337
        jmp     (r2)
L377:
        lw      r0,9(fp)
        lc      r1,20
        ceq     r0,r1
        brf     L379
        la      r0,_S63
        la      r2,L337
        jmp     (r2)
L379:
        lw      r0,9(fp)
        lc      r1,21
        ceq     r0,r1
        brf     L381
        la      r0,_S64
        la      r2,L337
        jmp     (r2)
L381:
        lw      r0,9(fp)
        lc      r1,22
        ceq     r0,r1
        brf     L383
        la      r0,_S65
        la      r2,L337
        jmp     (r2)
L383:
        lw      r0,9(fp)
        lc      r1,23
        ceq     r0,r1
        brf     L385
        la      r0,_S66
        la      r2,L337
        jmp     (r2)
L385:
        lw      r0,9(fp)
        lc      r1,24
        ceq     r0,r1
        brf     L387
        la      r0,_S67
        la      r2,L337
        jmp     (r2)
L387:
        lw      r0,9(fp)
        lc      r1,25
        ceq     r0,r1
        brf     L389
        la      r0,_S68
        la      r2,L337
        jmp     (r2)
L389:
        lw      r0,9(fp)
        lc      r1,26
        ceq     r0,r1
        brf     L391
        la      r0,_S69
        la      r2,L337
        jmp     (r2)
L391:
        lw      r0,9(fp)
        lc      r1,27
        ceq     r0,r1
        brf     L393
        la      r0,_S70
        la      r2,L337
        jmp     (r2)
L393:
        lw      r0,9(fp)
        lc      r1,28
        ceq     r0,r1
        brf     L395
        la      r0,_S71
        la      r2,L337
        jmp     (r2)
L395:
        lw      r0,9(fp)
        lc      r1,29
        ceq     r0,r1
        brf     L397
        la      r0,_S72
        la      r2,L337
        jmp     (r2)
L397:
        lw      r0,9(fp)
        lc      r1,30
        ceq     r0,r1
        brf     L399
        la      r0,_S73
        la      r2,L337
        jmp     (r2)
L399:
        lw      r0,9(fp)
        lc      r1,31
        ceq     r0,r1
        brf     L401
        la      r0,_S74
        la      r2,L337
        jmp     (r2)
L401:
        lw      r0,9(fp)
        lc      r1,32
        ceq     r0,r1
        brf     L403
        la      r0,_S75
        la      r2,L337
        jmp     (r2)
L403:
        lw      r0,9(fp)
        lc      r1,33
        ceq     r0,r1
        brf     L405
        la      r0,_S76
        la      r2,L337
        jmp     (r2)
L405:
        lw      r0,9(fp)
        lc      r1,34
        ceq     r0,r1
        brf     L407
        la      r0,_S77
        la      r2,L337
        jmp     (r2)
L407:
        lw      r0,9(fp)
        lc      r1,35
        ceq     r0,r1
        brf     L409
        la      r0,_S78
        la      r2,L337
        jmp     (r2)
L409:
        lw      r0,9(fp)
        lc      r1,36
        ceq     r0,r1
        brf     L411
        la      r0,_S79
        la      r2,L337
        jmp     (r2)
L411:
        lw      r0,9(fp)
        lc      r1,37
        ceq     r0,r1
        brf     L413
        la      r0,_S80
        la      r2,L337
        jmp     (r2)
L413:
        lw      r0,9(fp)
        lc      r1,40
        ceq     r0,r1
        brf     L415
        la      r0,_S81
        la      r2,L337
        jmp     (r2)
L415:
        lw      r0,9(fp)
        lc      r1,41
        ceq     r0,r1
        brf     L417
        la      r0,_S82
        la      r2,L337
        jmp     (r2)
L417:
        lw      r0,9(fp)
        lc      r1,42
        ceq     r0,r1
        brf     L419
        la      r0,_S83
        la      r2,L337
        jmp     (r2)
L419:
        lw      r0,9(fp)
        lc      r1,43
        ceq     r0,r1
        brf     L421
        la      r0,_S84
        la      r2,L337
        jmp     (r2)
L421:
        lw      r0,9(fp)
        lc      r1,44
        ceq     r0,r1
        brf     L423
        la      r0,_S85
        la      r2,L337
        jmp     (r2)
L423:
        lw      r0,9(fp)
        lc      r1,45
        ceq     r0,r1
        brf     L425
        la      r0,_S86
        la      r2,L337
        jmp     (r2)
L425:
        lw      r0,9(fp)
        lc      r1,46
        ceq     r0,r1
        brf     L427
        la      r0,_S87
        la      r2,L337
        jmp     (r2)
L427:
        lw      r0,9(fp)
        lc      r1,47
        ceq     r0,r1
        brf     L429
        la      r0,_S88
        la      r2,L337
        jmp     (r2)
L429:
        lw      r0,9(fp)
        lc      r1,48
        ceq     r0,r1
        brf     L431
        la      r0,_S89
        la      r2,L337
        jmp     (r2)
L431:
        lw      r0,9(fp)
        lc      r1,49
        ceq     r0,r1
        brf     L433
        la      r0,_S90
        la      r2,L337
        jmp     (r2)
L433:
        lw      r0,9(fp)
        lc      r1,50
        ceq     r0,r1
        brf     L435
        la      r0,_S91
        la      r2,L337
        jmp     (r2)
L435:
        lw      r0,9(fp)
        lc      r1,51
        ceq     r0,r1
        brf     L437
        la      r0,_S92
        la      r2,L337
        jmp     (r2)
L437:
        lw      r0,9(fp)
        lc      r1,52
        ceq     r0,r1
        brf     L439
        la      r0,_S93
        la      r2,L337
        jmp     (r2)
L439:
        lw      r0,9(fp)
        lc      r1,53
        ceq     r0,r1
        brf     L441
        la      r0,_S94
        la      r2,L337
        jmp     (r2)
L441:
        lw      r0,9(fp)
        lc      r1,54
        ceq     r0,r1
        brf     L443
        la      r0,_S95
        la      r2,L337
        jmp     (r2)
L443:
        lw      r0,9(fp)
        lc      r1,55
        ceq     r0,r1
        brf     L445
        la      r0,_S96
        la      r2,L337
        jmp     (r2)
L445:
        lw      r0,9(fp)
        lc      r1,56
        ceq     r0,r1
        brf     L447
        la      r0,_S97
        la      r2,L337
        jmp     (r2)
L447:
        lw      r0,9(fp)
        lc      r1,57
        ceq     r0,r1
        brf     L449
        la      r0,_S98
        la      r2,L337
        jmp     (r2)
L449:
        lw      r0,9(fp)
        lc      r1,58
        ceq     r0,r1
        brf     L451
        la      r0,_S99
        la      r2,L337
        jmp     (r2)
L451:
        lw      r0,9(fp)
        lc      r1,59
        ceq     r0,r1
        brf     L453
        la      r0,_S100
        la      r2,L337
        jmp     (r2)
L453:
        lw      r0,9(fp)
        lc      r1,60
        ceq     r0,r1
        brf     L455
        la      r0,_S101
        la      r2,L337
        jmp     (r2)
L455:
        lw      r0,9(fp)
        lc      r1,61
        ceq     r0,r1
        brf     L457
        la      r0,_S102
        la      r2,L337
        jmp     (r2)
L457:
        lw      r0,9(fp)
        lc      r1,62
        ceq     r0,r1
        brf     L459
        la      r0,_S103
        la      r2,L337
        jmp     (r2)
L459:
        lw      r0,9(fp)
        lc      r1,63
        ceq     r0,r1
        brf     L461
        la      r0,_S104
        la      r2,L337
        jmp     (r2)
L461:
        lw      r0,9(fp)
        lc      r1,64
        ceq     r0,r1
        brf     L463
        la      r0,_S105
        la      r2,L337
        jmp     (r2)
L463:
        lw      r0,9(fp)
        lc      r1,65
        ceq     r0,r1
        brf     L465
        la      r0,_S106
        bra     L337
L465:
        lw      r0,9(fp)
        lc      r1,66
        ceq     r0,r1
        brf     L467
        la      r0,_S107
        bra     L337
L467:
        lw      r0,9(fp)
        lc      r1,67
        ceq     r0,r1
        brf     L469
        la      r0,_S108
        bra     L337
L469:
        lw      r0,9(fp)
        lc      r1,68
        ceq     r0,r1
        brf     L471
        la      r0,_S109
        bra     L337
L471:
        lw      r0,9(fp)
        lc      r1,38
        ceq     r0,r1
        brf     L473
        la      r0,_S110
        bra     L337
L473:
        la      r0,_S111
L337:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _str_copy
_str_copy:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L475:
        lw      r0,12(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        ceq     r0,z
        brt     L476
        lw      r0,12(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        bra     L475
L476:
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
L474:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _is_ordinal
_is_ordinal:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L480
        lw      r0,9(fp)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L480
        lc      r0,0
        bra     L481
L480:
        lc      r0,1
L481:
        ceq     r0,z
        brf     L478
        lw      r0,9(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L478
        lc      r0,0
        bra     L479
L478:
        lc      r0,1
L479:
L477:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _types_compatible
_types_compatible:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        ceq     r0,r1
        brf     L484
        lc      r0,1
        la      r2,L482
        jmp     (r2)
L484:
        lw      r0,9(fp)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L489
        lw      r0,9(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L489
        lc      r0,0
        bra     L490
L489:
        lc      r0,1
L490:
        ceq     r0,z
        brt     L487
        lw      r0,12(fp)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L491
        lw      r0,12(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L491
        lc      r0,0
        bra     L492
L491:
        lc      r0,1
L492:
        ceq     r0,z
        brt     L487
        lc      r0,1
        bra     L488
L487:
        lc      r0,0
L488:
        ceq     r0,z
        brt     L486
        lc      r0,1
        la      r2,L482
        jmp     (r2)
L486:
        lw      r0,9(fp)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L495
        lw      r0,12(fp)
        lc      r1,7
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L495
        lc      r0,1
        bra     L496
L495:
        lc      r0,0
L496:
        ceq     r0,z
        brt     L494
        lc      r0,1
        la      r2,L482
        jmp     (r2)
L494:
        lw      r0,9(fp)
        lc      r1,7
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L499
        lw      r0,12(fp)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L499
        lc      r0,1
        bra     L500
L499:
        lc      r0,0
L500:
        ceq     r0,z
        brt     L498
        lc      r0,1
        bra     L482
L498:
        lw      r0,9(fp)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L503
        lw      r0,12(fp)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L503
        lc      r0,1
        bra     L504
L503:
        lc      r0,0
L504:
        ceq     r0,z
        brt     L502
        lc      r0,1
        bra     L482
L502:
        lc      r0,0
L482:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _error
_error:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r1,_tok_type
        lw      r0,0(r1)
        push    r0
        la      r0,_token_name
        jal     r1,(r0)
        add     sp,3
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S112
        push    r0
        la      r0,___tc24r_printf3
        jal     r1,(r0)
        add     sp,12
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
L505:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _expect
_expect:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r1,_tok_type
        lw      r0,0(r1)
        lw      r1,9(fp)
        ceq     r0,r1
        brt     L508
        la      r1,_tok_type
        lw      r0,0(r1)
        push    r0
        la      r0,_token_name
        jal     r1,(r0)
        add     sp,3
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_token_name
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S113
        push    r0
        la      r0,___tc24r_printf3
        jal     r1,(r0)
        add     sp,12
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        bra     L506
L508:
        la      r0,_next_token
        jal     r1,(r0)
L506:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _emit_rt_call
_emit_rt_call:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        brt     L510
        lw      r0,9(fp)
        push    r0
        la      r0,_S114
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        bra     L511
L510:
        lw      r0,9(fp)
        push    r0
        la      r0,_S115
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L511:
L509:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _new_label
_new_label:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r1,_label_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        la      r1,_label_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_label_count
        sw      r0,0(r1)
        lw      r0,-3(fp)
L512:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _sym_name_at
_sym_name_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lc      r1,32
        mul     r0,r1
        sw      r0,-3(fp)
        la      r0,_sym_name
        lw      r1,-3(fp)
        add     r0,r1
L513:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _str_data_at
_str_data_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_str_data
        push    r0
        la      r0,_str_off
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        add     r0,r1
L514:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _proc_pascal_at
_proc_pascal_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lc      r1,32
        mul     r0,r1
        sw      r0,-3(fp)
        la      r0,_proc_pascal
        lw      r1,-3(fp)
        add     r0,r1
L515:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _proc_extern_at
_proc_extern_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lc      r1,32
        mul     r0,r1
        sw      r0,-3(fp)
        la      r0,_proc_extern
        lw      r1,-3(fp)
        add     r0,r1
L516:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _proc_lookup
_proc_lookup:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L518:
        lw      r0,-3(fp)
        la      r1,_proc_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L519
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_pascal_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L521
        lw      r0,-3(fp)
        bra     L517
L521:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        bra     L518
L519:
        lc      r0,-1
L517:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _proc_add
_proc_add:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r1,_proc_count
        lw      r0,0(r1)
        la      r1,128
        cls     r0,r1
        brt     L524
        la      r0,_S116
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,-1
        la      r2,L522
        jmp     (r2)
L524:
        la      r1,_proc_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_pascal_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        lw      r0,12(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_proc_argc
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,15(fp)
        sw      r0,0(r1)
        la      r0,_proc_has_ret
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,18(fp)
        sw      r0,0(r1)
        la      r0,_proc_ret_type
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,21(fp)
        sw      r0,0(r1)
        la      r0,_proc_is_user
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_proc_is_exported
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_proc_nlocals
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_proc_depth
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r1,_proc_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_proc_count
        sw      r0,0(r1)
        lw      r0,-3(fp)
L522:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _import_name_at
_import_name_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lc      r1,32
        mul     r0,r1
        sw      r0,-3(fp)
        la      r0,_import_name
        lw      r1,-3(fp)
        add     r0,r1
L525:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _import_lookup
_import_lookup:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L527:
        lw      r0,-3(fp)
        la      r1,_import_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L528
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_import_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L530
        lw      r0,-3(fp)
        bra     L526
L530:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        bra     L527
L528:
        lc      r0,-1
L526:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _load_spi_sections
_load_spi_sections:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        sub     sp,385
        lc      r0,0
        sw      r0,-3(fp)
L532:
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        brt     L689
        la      r2,L533
        jmp     (r2)
L689:
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,59
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L536
        lw      r0,-3(fp)
        lc      r1,9
        add     r0,r1
        lw      r1,12(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L536
        lc      r0,0
        bra     L537
L536:
        lc      r0,1
L537:
        ceq     r0,z
        brt     L535
        la      r2,L533
        jmp     (r2)
L535:
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,45
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L542
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,45
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L542
        lc      r0,0
        bra     L543
L542:
        lc      r0,1
L543:
        ceq     r0,z
        brf     L540
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,45
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L540
        lc      r0,0
        bra     L541
L540:
        lc      r0,1
L541:
        ceq     r0,z
        brt     L539
        la      r2,L533
        jmp     (r2)
L539:
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,4
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L550
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,5
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,83
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L550
        lc      r0,0
        bra     L551
L550:
        lc      r0,1
L551:
        ceq     r0,z
        brf     L548
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,6
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,80
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L548
        lc      r0,0
        bra     L549
L548:
        lc      r0,1
L549:
        ceq     r0,z
        brf     L546
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,7
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,73
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L546
        lc      r0,0
        bra     L547
L546:
        lc      r0,1
L547:
        ceq     r0,z
        brt     L545
        la      r2,L533
        jmp     (r2)
L545:
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,8
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        brt     L553
        la      r2,L533
        jmp     (r2)
L553:
        lw      r0,-3(fp)
        lc      r1,9
        add     r0,r1
        sw      r0,-3(fp)
        lc      r0,0
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
L554:
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L560
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L560
        lc      r0,1
        bra     L561
L560:
        lc      r0,0
L561:
        ceq     r0,z
        brt     L558
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,10
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L558
        lc      r0,1
        bra     L559
L558:
        lc      r0,0
L559:
        ceq     r0,z
        brt     L556
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        lc      r0,32
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L556
        lc      r0,1
        bra     L557
L556:
        lc      r0,0
L557:
        ceq     r0,z
        brf     L688
        la      r2,L555
        jmp     (r2)
L688:
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,-294
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        la      r2,L554
        jmp     (r2)
L555:
        la      r0,-294
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
L562:
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L564
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,10
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L564
        lc      r0,1
        bra     L565
L564:
        lc      r0,0
L565:
        ceq     r0,z
        brt     L563
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        bra     L562
L563:
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        brf     L567
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
L567:
        la      r1,_import_count
        lw      r0,0(r1)
        lc      r1,16
        cls     r0,r1
        brf     L569
        la      r0,-294
        add     r0,fp
        push    r0
        la      r1,_import_count
        lw      r0,0(r1)
        push    r0
        la      r0,_import_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r1,_import_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_import_count
        sw      r0,0(r1)
L569:
L570:
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        brt     L687
        la      r2,L571
        jmp     (r2)
L687:
        lc      r0,0
        la      r1,-262
        add     r1,fp
        sw      r0,0(r1)
L572:
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L576
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,10
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L576
        lc      r0,1
        bra     L577
L576:
        lc      r0,0
L577:
        ceq     r0,z
        brt     L574
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        la      r1,255
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L574
        lc      r0,1
        bra     L575
L574:
        lc      r0,0
L575:
        ceq     r0,z
        brf     L686
        la      r2,L573
        jmp     (r2)
L686:
        lw      r0,9(fp)
        lw      r1,-3(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-262
        add     r1,fp
        sw      r0,0(r1)
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        la      r2,L572
        jmp     (r2)
L573:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lw      r0,-3(fp)
        lw      r1,12(fp)
        cls     r0,r1
        brf     L579
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
L579:
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,15
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L588
        la      r0,-259
        add     r0,fp
        lc      r1,0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,59
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L588
        lc      r0,1
        bra     L589
L588:
        lc      r0,0
L589:
        ceq     r0,z
        brt     L586
        la      r0,-259
        add     r0,fp
        lc      r1,1
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,45
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L586
        lc      r0,1
        bra     L587
L586:
        lc      r0,0
L587:
        ceq     r0,z
        brt     L584
        la      r0,-259
        add     r0,fp
        lc      r1,2
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,45
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L584
        lc      r0,1
        bra     L585
L584:
        lc      r0,0
L585:
        ceq     r0,z
        brt     L582
        la      r0,-259
        add     r0,fp
        lc      r1,3
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,45
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L582
        lc      r0,1
        bra     L583
L582:
        lc      r0,0
L583:
        ceq     r0,z
        brt     L581
        la      r2,L571
        jmp     (r2)
L581:
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,8
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brt     L604
        la      r0,-259
        add     r0,fp
        lc      r1,0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,46
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L604
        lc      r0,1
        bra     L605
L604:
        lc      r0,0
L605:
        ceq     r0,z
        brt     L602
        la      r0,-259
        add     r0,fp
        lc      r1,1
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,101
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L602
        lc      r0,1
        bra     L603
L602:
        lc      r0,0
L603:
        ceq     r0,z
        brt     L600
        la      r0,-259
        add     r0,fp
        lc      r1,2
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,120
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L600
        lc      r0,1
        bra     L601
L600:
        lc      r0,0
L601:
        ceq     r0,z
        brt     L598
        la      r0,-259
        add     r0,fp
        lc      r1,3
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,112
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L598
        lc      r0,1
        bra     L599
L598:
        lc      r0,0
L599:
        ceq     r0,z
        brt     L596
        la      r0,-259
        add     r0,fp
        lc      r1,4
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,111
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L596
        lc      r0,1
        bra     L597
L596:
        lc      r0,0
L597:
        ceq     r0,z
        brt     L594
        la      r0,-259
        add     r0,fp
        lc      r1,5
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,114
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L594
        lc      r0,1
        bra     L595
L594:
        lc      r0,0
L595:
        ceq     r0,z
        brt     L592
        la      r0,-259
        add     r0,fp
        lc      r1,6
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,116
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L592
        lc      r0,1
        bra     L593
L592:
        lc      r0,0
L593:
        ceq     r0,z
        brf     L685
        la      r2,L591
        jmp     (r2)
L685:
        lc      r0,8
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        lc      r0,0
        la      r1,-262
        add     r1,fp
        sw      r0,0(r1)
L606:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L610
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L610
        lc      r0,1
        bra     L611
L610:
        lc      r0,0
L611:
        ceq     r0,z
        brt     L608
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        lc      r0,32
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L608
        lc      r0,1
        bra     L609
L608:
        lc      r0,0
L609:
        ceq     r0,z
        brf     L684
        la      r2,L607
        jmp     (r2)
L684:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,-326
        add     r0,fp
        push    r0
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-262
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r2,L606
        jmp     (r2)
L607:
        la      r0,-326
        add     r0,fp
        push    r0
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,0
        la      r1,-361
        add     r1,fp
        sw      r0,0(r1)
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        brt     L683
        la      r2,L613
        jmp     (r2)
L683:
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
L614:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L616
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,57
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L616
        lc      r0,1
        bra     L617
L616:
        lc      r0,0
L617:
        ceq     r0,z
        brf     L682
        la      r2,L615
        jmp     (r2)
L682:
        la      r1,-361
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,10
        mul     r0,r1
        push    r0
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,-361
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r2,L614
        jmp     (r2)
L615:
L613:
        lc      r0,0
        la      r1,-373
        add     r1,fp
        sw      r0,0(r1)
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        brt     L681
        la      r2,L619
        jmp     (r2)
L681:
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        sub     r0,r1
        la      r1,-373
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
L619:
        lc      r0,0
        la      r1,-376
        add     r1,fp
        sw      r0,0(r1)
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        brt     L680
        la      r2,L621
        jmp     (r2)
L680:
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        lc      r0,0
        la      r1,-376
        add     r1,fp
        sw      r0,0(r1)
L622:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L624
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,57
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L624
        lc      r0,1
        bra     L625
L624:
        lc      r0,0
L625:
        ceq     r0,z
        brf     L679
        la      r2,L623
        jmp     (r2)
L679:
        la      r1,-376
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,10
        mul     r0,r1
        push    r0
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,-376
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r2,L622
        jmp     (r2)
L623:
L621:
        la      r0,-326
        add     r0,fp
        lc      r1,0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,95
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L636
        la      r0,-326
        add     r0,fp
        lc      r1,1
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,117
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L636
        lc      r0,1
        bra     L637
L636:
        lc      r0,0
L637:
        ceq     r0,z
        brt     L634
        la      r0,-326
        add     r0,fp
        lc      r1,2
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,115
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L634
        lc      r0,1
        bra     L635
L634:
        lc      r0,0
L635:
        ceq     r0,z
        brt     L632
        la      r0,-326
        add     r0,fp
        lc      r1,3
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,101
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L632
        lc      r0,1
        bra     L633
L632:
        lc      r0,0
L633:
        ceq     r0,z
        brt     L630
        la      r0,-326
        add     r0,fp
        lc      r1,4
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,114
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L630
        lc      r0,1
        bra     L631
L630:
        lc      r0,0
L631:
        ceq     r0,z
        brt     L628
        la      r0,-326
        add     r0,fp
        lc      r1,5
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,95
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L628
        lc      r0,1
        bra     L629
L628:
        lc      r0,0
L629:
        ceq     r0,z
        brt     L626
        la      r0,-326
        add     r0,fp
        lc      r1,6
        add     r0,r1
        push    r0
        la      r0,-358
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        bra     L627
L626:
        la      r0,-326
        add     r0,fp
        push    r0
        la      r0,-358
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
L627:
        la      r1,-376
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r1,-373
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r1,-361
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r0,-326
        add     r0,fp
        push    r0
        la      r0,-358
        add     r0,fp
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        la      r1,-364
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-364
        add     r1,fp
        lw      r0,0(r1)
        cls     r0,z
        brt     L639
        la      r0,_proc_is_user
        push    r0
        la      r1,-364
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
L639:
L591:
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,5
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brt     L650
        la      r0,-259
        add     r0,fp
        lc      r1,0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,46
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L650
        lc      r0,1
        bra     L651
L650:
        lc      r0,0
L651:
        ceq     r0,z
        brt     L648
        la      r0,-259
        add     r0,fp
        lc      r1,1
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,118
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L648
        lc      r0,1
        bra     L649
L648:
        lc      r0,0
L649:
        ceq     r0,z
        brt     L646
        la      r0,-259
        add     r0,fp
        lc      r1,2
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,97
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L646
        lc      r0,1
        bra     L647
L646:
        lc      r0,0
L647:
        ceq     r0,z
        brt     L644
        la      r0,-259
        add     r0,fp
        lc      r1,3
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,114
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L644
        lc      r0,1
        bra     L645
L644:
        lc      r0,0
L645:
        ceq     r0,z
        brt     L642
        la      r0,-259
        add     r0,fp
        lc      r1,4
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L642
        lc      r0,1
        bra     L643
L642:
        lc      r0,0
L643:
        ceq     r0,z
        brf     L678
        la      r2,L641
        jmp     (r2)
L678:
        lc      r0,5
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        lc      r0,0
        la      r1,-262
        add     r1,fp
        sw      r0,0(r1)
L652:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L656
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L656
        lc      r0,1
        bra     L657
L656:
        lc      r0,0
L657:
        ceq     r0,z
        brt     L654
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        lc      r0,32
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L654
        lc      r0,1
        bra     L655
L654:
        lc      r0,0
L655:
        ceq     r0,z
        brf     L677
        la      r2,L653
        jmp     (r2)
L677:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,-358
        add     r0,fp
        push    r0
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-262
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r2,L652
        jmp     (r2)
L653:
        la      r0,-358
        add     r0,fp
        push    r0
        la      r1,-262
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,0
        la      r1,-379
        add     r1,fp
        sw      r0,0(r1)
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        brt     L676
        la      r2,L659
        jmp     (r2)
L676:
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
L660:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L662
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,57
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L662
        lc      r0,1
        bra     L663
L662:
        lc      r0,0
L663:
        ceq     r0,z
        brf     L675
        la      r2,L661
        jmp     (r2)
L675:
        la      r1,-379
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,10
        mul     r0,r1
        push    r0
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,-379
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r2,L660
        jmp     (r2)
L661:
L659:
        lc      r0,0
        la      r1,-382
        add     r1,fp
        sw      r0,0(r1)
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,32
        ceq     r0,r1
        brt     L674
        la      r2,L665
        jmp     (r2)
L674:
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        lc      r0,0
        la      r1,-382
        add     r1,fp
        sw      r0,0(r1)
L666:
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L668
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,57
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L668
        lc      r0,1
        bra     L669
L668:
        lc      r0,0
L669:
        ceq     r0,z
        brf     L673
        la      r2,L667
        jmp     (r2)
L673:
        la      r1,-382
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,10
        mul     r0,r1
        push    r0
        la      r0,-259
        add     r0,fp
        push    r0
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        lc      r1,48
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,-382
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-370
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,-370
        add     r1,fp
        sw      r0,0(r1)
        la      r2,L666
        jmp     (r2)
L667:
L665:
        lc      r0,0
        push    r0
        la      r1,-382
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        lc      r0,1
        push    r0
        la      r0,-358
        add     r0,fp
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        la      r1,-385
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-385
        add     r1,fp
        lw      r0,0(r1)
        cls     r0,z
        brf     L672
        la      r2,L671
        jmp     (r2)
L672:
        la      r0,_sym_is_imported
        push    r0
        la      r1,-385
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
        la      r1,_import_count
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_import_idx
        push    r0
        la      r1,-385
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r1,-379
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_import_off
        push    r0
        la      r1,-385
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r1,-379
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_global_off
        push    r0
        la      r1,-385
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
L671:
L641:
        la      r2,L570
        jmp     (r2)
L571:
        la      r2,L532
        jmp     (r2)
L533:
        lw      r0,-3(fp)
L531:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _utype_name_at
_utype_name_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lc      r1,32
        mul     r0,r1
        sw      r0,-3(fp)
        la      r0,_utype_name
        lw      r1,-3(fp)
        add     r0,r1
L690:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _field_name_at
_field_name_at:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lc      r1,32
        mul     r0,r1
        sw      r0,-3(fp)
        la      r0,_field_name
        lw      r1,-3(fp)
        add     r0,r1
L691:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _utype_lookup
_utype_lookup:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L693:
        lw      r0,-3(fp)
        la      r1,_utype_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L694
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_utype_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L696
        lw      r0,-3(fp)
        bra     L692
L696:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        bra     L693
L694:
        lc      r0,-1
L692:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _utype_add
_utype_add:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r1,_utype_count
        lw      r0,0(r1)
        lc      r1,32
        cls     r0,r1
        brt     L699
        la      r0,_S117
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,-1
        la      r2,L697
        jmp     (r2)
L699:
        la      r1,_utype_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_utype_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_utype_kind
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,12(fp)
        sw      r0,0(r1)
        la      r0,_utype_size
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_utype_base
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,-1
        sw      r0,0(r1)
        la      r0,_utype_nfields
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r1,_utype_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_utype_count
        sw      r0,0(r1)
        lw      r0,-3(fp)
L697:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _field_lookup
_field_lookup:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        la      r0,_utype_base
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-3(fp)
        la      r0,_utype_nfields
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-6(fp)
        lc      r0,0
        sw      r0,-9(fp)
L701:
        lw      r0,-9(fp)
        lw      r1,-6(fp)
        cls     r0,r1
        brf     L702
        lw      r0,12(fp)
        push    r0
        lw      r0,-3(fp)
        lw      r1,-9(fp)
        add     r0,r1
        push    r0
        la      r0,_field_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L704
        lw      r0,-3(fp)
        lw      r1,-9(fp)
        add     r0,r1
        bra     L700
L704:
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        bra     L701
L702:
        lc      r0,-1
L700:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _resolve_type_name
_resolve_type_name:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        mov     r1,r0
        lc      r0,-1
        sw      r0,0(r1)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,11
        ceq     r0,r1
        brf     L707
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,0
        la      r2,L705
        jmp     (r2)
L707:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,12
        ceq     r0,r1
        brf     L709
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,1
        la      r2,L705
        jmp     (r2)
L709:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,47
        ceq     r0,r1
        brf     L711
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,4
        la      r2,L705
        jmp     (r2)
L711:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brf     L713
        la      r0,_tok_lexeme
        push    r0
        la      r0,_utype_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        cls     r0,z
        brt     L715
        lw      r0,9(fp)
        mov     r1,r0
        lw      r0,-3(fp)
        sw      r0,0(r1)
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_utype_kind
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        bra     L705
L715:
L713:
        la      r0,_S118
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
L705:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _emit_load_sym
_emit_load_sym:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brf     L717
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S119
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r2,L718
        jmp     (r2)
L717:
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L721
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L721
        lc      r0,0
        bra     L722
L721:
        lc      r0,1
L722:
        ceq     r0,z
        brf     L729
        la      r2,L719
        jmp     (r2)
L729:
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_depth
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,0
        cls     r1,r0
        brf     L723
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_S120
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        la      r2,L724
        jmp     (r2)
L723:
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,2
        ceq     r0,r1
        brf     L725
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S121
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        bra     L726
L725:
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S122
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L726:
L724:
        la      r2,L720
        jmp     (r2)
L719:
        la      r0,_sym_is_imported
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L727
        la      r0,_sym_import_off
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_sym_import_idx
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S123
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        bra     L728
L727:
        lw      r0,9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S124
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L728:
L720:
L718:
L716:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _emit_store_sym
_emit_store_sym:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L733
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L733
        lc      r0,0
        bra     L734
L733:
        lc      r0,1
L734:
        ceq     r0,z
        brf     L741
        la      r2,L731
        jmp     (r2)
L741:
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_depth
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,0
        cls     r1,r0
        brf     L735
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_S125
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        la      r2,L736
        jmp     (r2)
L735:
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,2
        ceq     r0,r1
        brf     L737
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S126
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        bra     L738
L737:
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S127
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L738:
L736:
        la      r2,L732
        jmp     (r2)
L731:
        la      r0,_sym_is_imported
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L739
        la      r0,_sym_import_off
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_sym_import_idx
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S128
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        bra     L740
L739:
        lw      r0,9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S129
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L740:
L732:
L730:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _emit_array_addr
_emit_array_addr:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        la      r0,_sym_arr_low
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-3(fp)
        la      r0,_sym_arr_elem
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L743
        lc      r0,1
        bra     L744
L743:
        lc      r0,3
L744:
        sw      r0,-6(fp)
        lw      r0,-3(fp)
        ceq     r0,z
        brt     L746
        lw      r0,-3(fp)
        push    r0
        la      r0,_S130
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S131
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L746:
        lw      r0,-6(fp)
        lc      r1,1
        cls     r1,r0
        brf     L748
        lw      r0,-6(fp)
        push    r0
        la      r0,_S132
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S133
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L748:
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,1
        ceq     r0,r1
        brf     L749
        lw      r0,9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S134
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r2,L750
        jmp     (r2)
L749:
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        brf     L751
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S135
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        bra     L752
L751:
        la      r0,_sym_kind
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,2
        ceq     r0,r1
        brf     L754
        la      r0,_sym_value
        push    r0
        lw      r0,9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S136
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L754:
L752:
L750:
        la      r0,_S137
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L742:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _register_system_unit
_register_system_unit:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S138
        push    r0
        la      r0,_S139
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S140
        push    r0
        la      r0,_S141
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S142
        push    r0
        la      r0,_S143
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,4
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S144
        push    r0
        la      r0,_S145
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S146
        push    r0
        la      r0,_S147
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S148
        push    r0
        la      r0,_S149
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S150
        push    r0
        la      r0,_S151
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        lc      r0,0
        push    r0
        la      r0,_S152
        push    r0
        la      r0,_S153
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        lc      r0,0
        push    r0
        la      r0,_S154
        push    r0
        la      r0,_S155
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S156
        push    r0
        la      r0,_S157
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,1
        push    r0
        la      r0,_S158
        push    r0
        la      r0,_S159
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,2
        push    r0
        la      r0,_S160
        push    r0
        la      r0,_S161
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,3
        push    r0
        la      r0,_S162
        push    r0
        la      r0,_S163
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,3
        push    r0
        la      r0,_S164
        push    r0
        la      r0,_S165
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
L755:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _register_hardware_unit
_register_hardware_unit:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        la      r0,_S166
        push    r0
        la      r0,_S167
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        la      r0,_S168
        push    r0
        la      r0,_S169
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        lc      r0,0
        push    r0
        la      r0,_S170
        push    r0
        la      r0,_S171
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
L756:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _sym_lookup
_sym_lookup:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L758:
        lw      r0,-3(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L759
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L761
        lw      r0,-3(fp)
        bra     L757
L761:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        bra     L758
L759:
        lc      r0,-1
L757:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _sym_add
_sym_add:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        cls     r0,z
        brt     L764
        lw      r0,9(fp)
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S172
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,-1
        la      r2,L762
        jmp     (r2)
L764:
        la      r1,_sym_count
        lw      r0,0(r1)
        la      r1,512
        cls     r0,r1
        brt     L766
        la      r0,_S173
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,-1
        la      r2,L762
        jmp     (r2)
L766:
        la      r1,_sym_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_sym_kind
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,12(fp)
        sw      r0,0(r1)
        la      r0,_sym_type_id
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,15(fp)
        sw      r0,0(r1)
        la      r0,_sym_value
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,18(fp)
        sw      r0,0(r1)
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_depth
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r0,_sym_is_imported
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_sym_import_idx
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_sym_import_off
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_sym_global_off
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r0,_sym_is_exported_g
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sw      r0,0(r1)
        la      r1,_sym_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_sym_count
        sw      r0,0(r1)
        lw      r0,-3(fp)
L762:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_factor
_parse_factor:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-56
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L769
        la      r1,_tok_int_val
        lw      r0,0(r1)
        push    r0
        la      r0,_S174
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L769:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,60
        ceq     r0,r1
        brf     L771
        la      r1,_tok_int_val
        lw      r0,0(r1)
        push    r0
        la      r0,_S175
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,4
        la      r2,L767
        jmp     (r2)
L771:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,13
        ceq     r0,r1
        brf     L773
        la      r0,_S176
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,1
        la      r2,L767
        jmp     (r2)
L773:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,14
        ceq     r0,r1
        brf     L775
        la      r0,_S177
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,1
        la      r2,L767
        jmp     (r2)
L775:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,64
        ceq     r0,r1
        brf     L777
        la      r0,_S178
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,7
        la      r2,L767
        jmp     (r2)
L777:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,19
        ceq     r0,r1
        brf     L779
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_factor
        jal     r1,(r0)
        sw      r0,-6(fp)
        lw      r0,-6(fp)
        lc      r1,1
        ceq     r0,r1
        brt     L781
        la      r0,_S179
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L781:
        la      r0,_S180
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S181
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,1
        la      r2,L767
        jmp     (r2)
L779:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,24
        ceq     r0,r1
        brf     L783
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-6(fp)
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        lw      r0,-6(fp)
        la      r2,L767
        jmp     (r2)
L783:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,61
        ceq     r0,r1
        brt     L847
        la      r2,L785
        jmp     (r2)
L847:
        la      r1,_str_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        la      r1,128
        cls     r0,r1
        brt     L787
        la      r0,_S182
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,2
        la      r2,L767
        jmp     (r2)
L787:
        la      r1,_str_data_used
        lw      r0,0(r1)
        la      r1,_tok_str_len
        lw      r1,0(r1)
        add     r0,r1
        lc      r1,1
        add     r0,r1
        la      r1,8192
        cls     r1,r0
        brf     L789
        la      r0,_S183
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,2
        la      r2,L767
        jmp     (r2)
L789:
        la      r1,_str_data_used
        lw      r0,0(r1)
        push    r0
        la      r0,_str_off
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r0,_tok_str_val
        push    r0
        la      r0,_str_data
        la      r1,_str_data_used
        lw      r1,0(r1)
        add     r0,r1
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r1,_tok_str_len
        lw      r0,0(r1)
        push    r0
        la      r0,_str_len
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r1,_str_data_used
        lw      r0,0(r1)
        la      r1,_tok_str_len
        lw      r1,0(r1)
        add     r0,r1
        lc      r1,1
        add     r0,r1
        la      r1,_str_data_used
        sw      r0,0(r1)
        la      r1,_str_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_str_count
        sw      r0,0(r1)
        lw      r0,-3(fp)
        push    r0
        la      r0,_S184
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,2
        la      r2,L767
        jmp     (r2)
L785:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L846
        la      r2,L791
        jmp     (r2)
L846:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-38
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,-38
        add     r0,fp
        push    r0
        la      r0,_proc_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L794
        la      r0,_proc_has_ret
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L794
        lc      r0,1
        bra     L795
L794:
        lc      r0,0
L795:
        ceq     r0,z
        brt     L793
        lc      r0,-38
        add     r0,fp
        push    r0
        la      r0,_parse_proc_call
        jal     r1,(r0)
        add     sp,3
        la      r0,_proc_ret_type
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L767
        jmp     (r2)
L793:
        lc      r0,-38
        add     r0,fp
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        cls     r0,z
        brf     L797
        lc      r0,-38
        add     r0,fp
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S185
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L797:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L800
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,57
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L800
        lc      r0,1
        bra     L801
L800:
        lc      r0,0
L801:
        ceq     r0,z
        brf     L845
        la      r2,L799
        jmp     (r2)
L845:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        lc      r0,58
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        push    r0
        la      r0,_emit_array_addr
        jal     r1,(r0)
        add     sp,3
        la      r0,_sym_arr_elem
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        brf     L802
        la      r0,_S186
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L803
L802:
        la      r0,_S187
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L803:
        la      r0,_sym_arr_elem
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L767
        jmp     (r2)
L799:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L806
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,65
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L806
        lc      r0,1
        bra     L807
L806:
        lc      r0,0
L807:
        ceq     r0,z
        brf     L844
        la      r2,L805
        jmp     (r2)
L844:
        lw      r0,-3(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_sym_ptr_base
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-44(fp)
        lw      r0,-44(fp)
        cls     r0,z
        brf     L809
        la      r0,_S188
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L809:
        la      r0,_utype_base
        push    r0
        lw      r0,-44(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-47(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,22
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L814
        lw      r0,-47(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L814
        lc      r0,1
        bra     L815
L814:
        lc      r0,0
L815:
        ceq     r0,z
        brt     L812
        la      r0,_utype_kind
        push    r0
        lw      r0,-47(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,6
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L812
        lc      r0,1
        bra     L813
L812:
        lc      r0,0
L813:
        ceq     r0,z
        brf     L843
        la      r2,L811
        jmp     (r2)
L843:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L817
        la      r0,_S189
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L817:
        la      r0,_tok_lexeme
        push    r0
        lw      r0,-47(fp)
        push    r0
        la      r0,_field_lookup
        jal     r1,(r0)
        add     sp,6
        sw      r0,-50(fp)
        lw      r0,-50(fp)
        cls     r0,z
        brf     L819
        la      r0,_tok_lexeme
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S190
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L819:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_field_type
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        brt     L842
        la      r2,L821
        jmp     (r2)
L842:
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,0
        cls     r1,r0
        brf     L823
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        mul     r0,r1
        push    r0
        la      r0,_S191
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S192
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L823:
        lc      r0,57
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L825
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L825:
        la      r1,_has_arrays
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L827
        lc      r0,1
        la      r1,_has_arrays
        sw      r0,0(r1)
        la      r0,_S193
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L827:
        la      r0,_S194
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_expression
        jal     r1,(r0)
        la      r0,_field_arr_low
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-53(fp)
        la      r0,_field_arr_elem
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L828
        lc      r0,1
        bra     L829
L828:
        lc      r0,3
L829:
        sw      r0,-56(fp)
        lw      r0,-53(fp)
        ceq     r0,z
        brt     L831
        lw      r0,-53(fp)
        push    r0
        la      r0,_S195
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S196
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L831:
        lw      r0,-56(fp)
        lc      r1,1
        cls     r1,r0
        brf     L833
        lw      r0,-56(fp)
        push    r0
        la      r0,_S197
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S198
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L833:
        la      r0,_S199
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S200
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,58
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L835
        lc      r0,0
        la      r2,L767
        jmp     (r2)
L835:
        la      r0,_field_arr_elem
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        brf     L836
        la      r0,_S201
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L837
L836:
        la      r0,_S202
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L837:
        la      r0,_field_arr_elem
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L767
        jmp     (r2)
L821:
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,0
        cls     r1,r0
        brf     L839
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        mul     r0,r1
        push    r0
        la      r0,_S203
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S204
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L839:
        la      r0,_S205
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_field_type
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L767
        jmp     (r2)
L811:
        la      r0,_S206
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-47(fp)
        cls     r0,z
        brt     L841
        la      r0,_utype_kind
        push    r0
        lw      r0,-47(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        bra     L767
L841:
        lc      r0,0
        bra     L767
L805:
        lw      r0,-3(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r0,_sym_type_id
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        bra     L767
L791:
        la      r0,_S207
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
L767:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_term
_parse_term:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        la      r0,_parse_factor
        jal     r1,(r0)
        sw      r0,-3(fp)
L849:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,28
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L855
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,15
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L855
        lc      r0,0
        bra     L856
L855:
        lc      r0,1
L856:
        ceq     r0,z
        brf     L853
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,16
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L853
        lc      r0,0
        bra     L854
L853:
        lc      r0,1
L854:
        ceq     r0,z
        brf     L851
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,17
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L851
        lc      r0,0
        bra     L852
L851:
        lc      r0,1
L852:
        ceq     r0,z
        brf     L882
        la      r2,L850
        jmp     (r2)
L882:
        la      r1,_tok_type
        lw      r0,0(r1)
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_factor
        jal     r1,(r0)
        sw      r0,-9(fp)
        lw      r0,-6(fp)
        lc      r1,28
        ceq     r0,r1
        brt     L881
        la      r2,L857
        jmp     (r2)
L881:
        lw      r0,-3(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L861
        lw      r0,-9(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L861
        lc      r0,0
        bra     L862
L861:
        lc      r0,1
L862:
        ceq     r0,z
        brt     L860
        la      r0,_S208
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L860:
        la      r0,_S209
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-3(fp)
        la      r2,L858
        jmp     (r2)
L857:
        lw      r0,-6(fp)
        lc      r1,15
        ceq     r0,r1
        brt     L880
        la      r2,L863
        jmp     (r2)
L880:
        lw      r0,-3(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L867
        lw      r0,-9(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L867
        lc      r0,0
        bra     L868
L867:
        lc      r0,1
L868:
        ceq     r0,z
        brt     L866
        la      r0,_S210
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L866:
        la      r0,_S211
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-3(fp)
        la      r2,L864
        jmp     (r2)
L863:
        lw      r0,-6(fp)
        lc      r1,16
        ceq     r0,r1
        brt     L879
        la      r2,L869
        jmp     (r2)
L879:
        lw      r0,-3(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L873
        lw      r0,-9(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L873
        lc      r0,0
        bra     L874
L873:
        lc      r0,1
L874:
        ceq     r0,z
        brt     L872
        la      r0,_S212
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L872:
        la      r0,_S213
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-3(fp)
        la      r2,L870
        jmp     (r2)
L869:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L877
        lw      r0,-9(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L877
        lc      r0,0
        bra     L878
L877:
        lc      r0,1
L878:
        ceq     r0,z
        brt     L876
        la      r0,_S214
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L876:
        la      r0,_S215
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,1
        sw      r0,-3(fp)
L870:
L864:
L858:
        la      r2,L849
        jmp     (r2)
L850:
        lw      r0,-3(fp)
L848:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_simple_expr
_parse_simple_expr:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-12
        lc      r0,0
        sw      r0,-3(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,26
        ceq     r0,r1
        brf     L884
        la      r0,_next_token
        jal     r1,(r0)
        bra     L885
L884:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L887
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,1
        sw      r0,-3(fp)
L887:
L885:
        la      r0,_parse_term
        jal     r1,(r0)
        sw      r0,-6(fp)
        lw      r0,-3(fp)
        ceq     r0,z
        brt     L889
        lw      r0,-6(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L891
        la      r0,_S216
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L891:
        la      r0,_S217
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-6(fp)
L889:
L892:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,26
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L896
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L896
        lc      r0,0
        bra     L897
L896:
        lc      r0,1
L897:
        ceq     r0,z
        brf     L894
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,18
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L894
        lc      r0,0
        bra     L895
L894:
        lc      r0,1
L895:
        ceq     r0,z
        brf     L916
        la      r2,L893
        jmp     (r2)
L916:
        la      r1,_tok_type
        lw      r0,0(r1)
        sw      r0,-9(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_term
        jal     r1,(r0)
        sw      r0,-12(fp)
        lw      r0,-9(fp)
        lc      r1,26
        ceq     r0,r1
        brt     L915
        la      r2,L898
        jmp     (r2)
L915:
        lw      r0,-6(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L902
        lw      r0,-12(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L902
        lc      r0,0
        bra     L903
L902:
        lc      r0,1
L903:
        ceq     r0,z
        brt     L901
        la      r0,_S218
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L901:
        la      r0,_S219
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-6(fp)
        la      r2,L899
        jmp     (r2)
L898:
        lw      r0,-9(fp)
        lc      r1,27
        ceq     r0,r1
        brt     L914
        la      r2,L904
        jmp     (r2)
L914:
        lw      r0,-6(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L908
        lw      r0,-12(fp)
        push    r0
        la      r0,_is_ordinal
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L908
        lc      r0,0
        bra     L909
L908:
        lc      r0,1
L909:
        ceq     r0,z
        brt     L907
        la      r0,_S220
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L907:
        la      r0,_S221
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-6(fp)
        la      r2,L905
        jmp     (r2)
L904:
        lw      r0,-6(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L912
        lw      r0,-12(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L912
        lc      r0,0
        bra     L913
L912:
        lc      r0,1
L913:
        ceq     r0,z
        brt     L911
        la      r0,_S222
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L911:
        la      r0,_S223
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,1
        sw      r0,-6(fp)
L905:
L899:
        la      r2,L892
        jmp     (r2)
L893:
        lw      r0,-6(fp)
L883:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_expression
_parse_expression:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        la      r0,_parse_simple_expr
        jal     r1,(r0)
        sw      r0,-3(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,29
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L928
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,30
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L928
        lc      r0,0
        bra     L929
L928:
        lc      r0,1
L929:
        ceq     r0,z
        brf     L926
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,31
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L926
        lc      r0,0
        bra     L927
L926:
        lc      r0,1
L927:
        ceq     r0,z
        brf     L924
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L924
        lc      r0,0
        bra     L925
L924:
        lc      r0,1
L925:
        ceq     r0,z
        brf     L922
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,33
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L922
        lc      r0,0
        bra     L923
L922:
        lc      r0,1
L923:
        ceq     r0,z
        brf     L920
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,34
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L920
        lc      r0,0
        bra     L921
L920:
        lc      r0,1
L921:
        ceq     r0,z
        brf     L944
        la      r2,L919
        jmp     (r2)
L944:
        la      r1,_tok_type
        lw      r0,0(r1)
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_simple_expr
        jal     r1,(r0)
        sw      r0,-9(fp)
        lw      r0,-9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_types_compatible
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L931
        la      r0,_S224
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L931:
        lw      r0,-6(fp)
        lc      r1,29
        ceq     r0,r1
        brf     L932
        la      r0,_S225
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r2,L933
        jmp     (r2)
L932:
        lw      r0,-6(fp)
        lc      r1,30
        ceq     r0,r1
        brf     L934
        la      r0,_S226
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r2,L935
        jmp     (r2)
L934:
        lw      r0,-6(fp)
        lc      r1,31
        ceq     r0,r1
        brf     L936
        la      r0,_S227
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L937
L936:
        lw      r0,-6(fp)
        lc      r1,32
        ceq     r0,r1
        brf     L938
        la      r0,_S228
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L939
L938:
        lw      r0,-6(fp)
        lc      r1,33
        ceq     r0,r1
        brf     L940
        la      r0,_S229
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L941
L940:
        lw      r0,-6(fp)
        lc      r1,34
        ceq     r0,r1
        brf     L943
        la      r0,_S230
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L943:
L941:
L939:
L937:
L935:
L933:
        lc      r0,1
        bra     L917
L919:
        lw      r0,-3(fp)
L917:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_compound_stmt
_parse_compound_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lc      r0,3
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_stmt
        jal     r1,(r0)
L946:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,21
        ceq     r0,r1
        brf     L947
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_stmt
        jal     r1,(r0)
        bra     L946
L947:
        lc      r0,4
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L945:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_if_stmt
_parse_if_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brt     L950
        la      r0,_S231
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L950:
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-6(fp)
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-9(fp)
        lw      r0,-6(fp)
        push    r0
        la      r0,_S232
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,6
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_stmt
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,7
        ceq     r0,r1
        brf     L951
        lw      r0,-9(fp)
        push    r0
        la      r0,_S233
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-6(fp)
        push    r0
        la      r0,_S234
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_stmt
        jal     r1,(r0)
        lw      r0,-9(fp)
        push    r0
        la      r0,_S235
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        bra     L952
L951:
        lw      r0,-6(fp)
        push    r0
        la      r0,_S236
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L952:
L948:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_while_stmt
_parse_while_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-6(fp)
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-9(fp)
        lw      r0,-6(fp)
        push    r0
        la      r0,_S237
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brt     L955
        la      r0,_S238
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L955:
        lw      r0,-9(fp)
        push    r0
        la      r0,_S239
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,9
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_stmt
        jal     r1,(r0)
        lw      r0,-6(fp)
        push    r0
        la      r0,_S240
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-9(fp)
        push    r0
        la      r0,_S241
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L953:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_for_stmt
_parse_for_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-44
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L958
        la      r0,_S242
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L956
        jmp     (r2)
L958:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-35(fp)
        lw      r0,-35(fp)
        cls     r0,z
        brf     L960
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S243
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L956
        jmp     (r2)
L960:
        la      r0,_sym_kind
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brf     L962
        la      r0,_S244
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L956
        jmp     (r2)
L962:
        lc      r0,20
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L964
        lc      r0,0
        la      r2,L956
        jmp     (r2)
L964:
        la      r0,_parse_expression
        jal     r1,(r0)
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_store_sym
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-44(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,50
        ceq     r0,r1
        brf     L965
        lc      r0,1
        sw      r0,-44(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L966
L965:
        lc      r0,49
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L968
        lc      r0,0
        la      r2,L956
        jmp     (r2)
L968:
L966:
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-38(fp)
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-41(fp)
        lw      r0,-38(fp)
        push    r0
        la      r0,_S245
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_expression
        jal     r1,(r0)
        lw      r0,-44(fp)
        ceq     r0,z
        brt     L969
        la      r0,_S246
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L970
L969:
        la      r0,_S247
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L970:
        lw      r0,-41(fp)
        push    r0
        la      r0,_S248
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,9
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L972
        lc      r0,0
        la      r2,L956
        jmp     (r2)
L972:
        la      r0,_parse_stmt
        jal     r1,(r0)
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        lw      r0,-44(fp)
        ceq     r0,z
        brt     L973
        la      r0,_S249
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S250
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L974
L973:
        la      r0,_S251
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S252
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L974:
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_store_sym
        jal     r1,(r0)
        add     sp,3
        lw      r0,-38(fp)
        push    r0
        la      r0,_S253
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-41(fp)
        push    r0
        la      r0,_S254
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L956:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_repeat_stmt
_parse_repeat_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-6(fp)
        lw      r0,-6(fp)
        push    r0
        la      r0,_S255
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_parse_stmt
        jal     r1,(r0)
L976:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,21
        ceq     r0,r1
        brf     L977
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_stmt
        jal     r1,(r0)
        bra     L976
L977:
        lc      r0,52
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L979
        lc      r0,0
        bra     L975
L979:
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brt     L981
        la      r0,_S256
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L981:
        lw      r0,-6(fp)
        push    r0
        la      r0,_S257
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L975:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_case_stmt
_parse_case_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-12
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L985
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L985
        lc      r0,1
        bra     L986
L985:
        lc      r0,0
L986:
        ceq     r0,z
        brt     L984
        la      r0,_S258
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L984:
        lc      r0,45
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L988
        lc      r0,0
        la      r2,L982
        jmp     (r2)
L988:
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-6(fp)
L989:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L993
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,38
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L993
        lc      r0,1
        bra     L994
L993:
        lc      r0,0
L994:
        ceq     r0,z
        brt     L991
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L991
        lc      r0,1
        bra     L992
L991:
        lc      r0,0
L992:
        ceq     r0,z
        brf     L1014
        la      r2,L990
        jmp     (r2)
L1014:
        la      r0,_new_label
        jal     r1,(r0)
        sw      r0,-9(fp)
        la      r0,_S259
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L995
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        push    r0
        la      r0,_S260
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L996
        jmp     (r2)
L995:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,60
        ceq     r0,r1
        brf     L997
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        push    r0
        la      r0,_S261
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L998
        jmp     (r2)
L997:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L999
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brt     L1002
        la      r0,_S262
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L982
        jmp     (r2)
L1002:
        lc      r0,0
        la      r1,_tok_int_val
        lw      r1,0(r1)
        sub     r0,r1
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        push    r0
        la      r0,_S263
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1000
        jmp     (r2)
L999:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1013
        la      r2,L1003
        jmp     (r2)
L1013:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1007
        la      r0,_sym_kind
        push    r0
        lw      r0,-12(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L1007
        lc      r0,0
        bra     L1008
L1007:
        lc      r0,1
L1008:
        ceq     r0,z
        brt     L1006
        la      r0,_S264
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L982
        jmp     (r2)
L1006:
        la      r0,_sym_value
        push    r0
        lw      r0,-12(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S265
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1004
L1003:
        la      r0,_S266
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L982
        jmp     (r2)
L1004:
L1000:
L998:
L996:
        la      r0,_S267
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-9(fp)
        push    r0
        la      r0,_S268
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,35
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1010
        lc      r0,0
        la      r2,L982
        jmp     (r2)
L1010:
        la      r0,_S269
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_stmt
        jal     r1,(r0)
        lw      r0,-6(fp)
        push    r0
        la      r0,_S270
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-9(fp)
        push    r0
        la      r0,_S271
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,21
        ceq     r0,r1
        brf     L1012
        la      r0,_next_token
        jal     r1,(r0)
L1012:
        la      r2,L989
        jmp     (r2)
L990:
        la      r0,_S272
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-6(fp)
        push    r0
        la      r0,_S273
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,4
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L982:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_read_args
_parse_read_args:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-35
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,24
        ceq     r0,r1
        brt     L1017
        lc      r0,0
        la      r2,L1015
        jmp     (r2)
L1017:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,25
        ceq     r0,r1
        brf     L1019
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,0
        la      r2,L1015
        jmp     (r2)
L1019:
L1020:
        lc      r0,1
        ceq     r0,z
        brf     L1032
        la      r2,L1021
        jmp     (r2)
L1032:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1023
        la      r0,_S274
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1015
        jmp     (r2)
L1023:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-35(fp)
        lw      r0,-35(fp)
        cls     r0,z
        brf     L1025
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S275
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1015
        jmp     (r2)
L1025:
        la      r0,_sym_kind
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brf     L1027
        la      r0,_S276
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1015
        jmp     (r2)
L1027:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        brf     L1028
        la      r0,_S277
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1029
L1028:
        la      r0,_S278
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1029:
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_store_sym
        jal     r1,(r0)
        add     sp,3
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1031
        bra     L1021
L1031:
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1020
        jmp     (r2)
L1021:
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L1015:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_read_stmt
_parse_read_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_read_args
        jal     r1,(r0)
L1033:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_readln_stmt
_parse_readln_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_read_args
        jal     r1,(r0)
        la      r0,_S279
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1034:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_write_stmt
_parse_write_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,24
        ceq     r0,r1
        brt     L1053
        la      r2,L1037
        jmp     (r2)
L1053:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,2
        ceq     r0,r1
        brf     L1038
        la      r0,_S280
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1039
L1038:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L1040
        la      r0,_S281
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1041
L1040:
        lw      r0,-3(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L1042
        la      r0,_S282
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1043
L1042:
        la      r0,_S283
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1043:
L1041:
L1039:
L1044:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1052
        la      r2,L1045
        jmp     (r2)
L1052:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,2
        ceq     r0,r1
        brf     L1046
        la      r0,_S284
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1047
L1046:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L1048
        la      r0,_S285
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1049
L1048:
        lw      r0,-3(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L1050
        la      r0,_S286
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1051
L1050:
        la      r0,_S287
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1051:
L1049:
L1047:
        la      r2,L1044
        jmp     (r2)
L1045:
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L1037:
L1035:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_writeln_stmt
_parse_writeln_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,24
        ceq     r0,r1
        brt     L1072
        la      r2,L1056
        jmp     (r2)
L1072:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,2
        ceq     r0,r1
        brf     L1057
        la      r0,_S288
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1058
L1057:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L1059
        la      r0,_S289
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1060
L1059:
        lw      r0,-3(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L1061
        la      r0,_S290
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1062
L1061:
        la      r0,_S291
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1062:
L1060:
L1058:
L1063:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1071
        la      r2,L1064
        jmp     (r2)
L1071:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,2
        ceq     r0,r1
        brf     L1065
        la      r0,_S292
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1066
L1065:
        lw      r0,-3(fp)
        lc      r1,1
        ceq     r0,r1
        brf     L1067
        la      r0,_S293
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1068
L1067:
        lw      r0,-3(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L1069
        la      r0,_S294
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        bra     L1070
L1069:
        la      r0,_S295
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1070:
L1068:
L1066:
        la      r2,L1063
        jmp     (r2)
L1064:
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L1056:
        la      r0,_S296
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
L1054:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_proc_call
_parse_proc_call:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-21
        la      r0,_S297
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brt     L1122
        la      r2,L1075
        jmp     (r2)
L1122:
        lc      r0,24
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1077
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1077:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1079
        la      r0,_S298
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1079:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-21(fp)
        lw      r0,-21(fp)
        cls     r0,z
        brf     L1081
        la      r0,_S299
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1081:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-21(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,5
        ceq     r0,r1
        brt     L1083
        la      r0,_S300
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1083:
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1085
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1085:
        la      r0,_sym_ptr_base
        push    r0
        lw      r0,-21(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1086
        la      r0,_utype_base
        push    r0
        lw      r0,-12(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        bra     L1087
L1086:
        lc      r0,-1
L1087:
        sw      r0,-15(fp)
        lw      r0,-15(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1088
        la      r0,_utype_size
        push    r0
        lw      r0,-15(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        bra     L1089
L1088:
        lc      r0,1
L1089:
        sw      r0,-18(fp)
        lw      r0,-18(fp)
        lc      r1,3
        mul     r0,r1
        push    r0
        la      r0,_S301
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S302
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        lw      r0,-21(fp)
        push    r0
        la      r0,_emit_store_sym
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1075:
        la      r0,_S303
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brt     L1121
        la      r2,L1091
        jmp     (r2)
L1121:
        lc      r0,24
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1093
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1093:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1095
        la      r0,_S304
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1095:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-21(fp)
        lw      r0,-21(fp)
        cls     r0,z
        brf     L1097
        la      r0,_S305
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1097:
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1099
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1099:
        lw      r0,-21(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r0,_S306
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1091:
        lw      r0,9(fp)
        push    r0
        la      r0,_proc_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        cls     r0,z
        brf     L1101
        lw      r0,9(fp)
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S307
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1101:
        lc      r0,0
        sw      r0,-6(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,24
        ceq     r0,r1
        brt     L1120
        la      r2,L1103
        jmp     (r2)
L1120:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,25
        ceq     r0,r1
        brt     L1105
        la      r0,_parse_expression
        jal     r1,(r0)
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
L1106:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brf     L1107
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
        bra     L1106
L1107:
L1105:
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1109
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1109:
L1103:
        lw      r0,-6(fp)
        push    r0
        la      r0,_proc_argc
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        brt     L1111
        lw      r0,9(fp)
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S308
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1073
        jmp     (r2)
L1111:
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1114
        la      r0,_proc_is_user
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1114
        lc      r0,1
        bra     L1115
L1114:
        lc      r0,0
L1115:
        ceq     r0,z
        brt     L1112
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S309
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r2,L1113
        jmp     (r2)
L1112:
        la      r0,_proc_is_user
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L1118
        la      r0,_proc_depth
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,1
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brt     L1118
        lc      r0,1
        bra     L1119
L1118:
        lc      r0,0
L1119:
        ceq     r0,z
        brt     L1116
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_proc_depth
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        lc      r1,1
        add     r0,r1
        push    r0
        la      r0,_S310
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        bra     L1117
L1116:
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S311
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1117:
L1113:
L1073:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_stmt
_parse_stmt:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-56
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1228
        la      r2,L1124
        jmp     (r2)
L1228:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,57
        ceq     r0,r1
        brt     L1227
        la      r2,L1126
        jmp     (r2)
L1227:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-35(fp)
        lw      r0,-35(fp)
        cls     r0,z
        brf     L1129
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S312
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1129:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        brt     L1131
        la      r0,_S313
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1131:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_expression
        jal     r1,(r0)
        lc      r0,58
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1133
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1133:
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_array_addr
        jal     r1,(r0)
        add     sp,3
        la      r0,_S314
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,20
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1135
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1135:
        la      r0,_parse_expression
        jal     r1,(r0)
        la      r0,_S315
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_sym_arr_elem
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        brf     L1136
        la      r0,_S316
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L1137
L1136:
        la      r0,_S317
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1137:
        la      r2,L1127
        jmp     (r2)
L1126:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,65
        ceq     r0,r1
        brt     L1226
        la      r2,L1138
        jmp     (r2)
L1226:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-35(fp)
        lw      r0,-35(fp)
        cls     r0,z
        brf     L1141
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S318
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1141:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,5
        ceq     r0,r1
        brt     L1143
        la      r0,_S319
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1143:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_sym_ptr_base
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-44(fp)
        lw      r0,-44(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1144
        la      r0,_utype_base
        push    r0
        lw      r0,-44(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        bra     L1145
L1144:
        lc      r0,-1
L1145:
        sw      r0,-47(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,22
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1150
        lw      r0,-47(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1150
        lc      r0,1
        bra     L1151
L1150:
        lc      r0,0
L1151:
        ceq     r0,z
        brt     L1148
        la      r0,_utype_kind
        push    r0
        lw      r0,-47(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,6
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1148
        lc      r0,1
        bra     L1149
L1148:
        lc      r0,0
L1149:
        ceq     r0,z
        brf     L1225
        la      r2,L1146
        jmp     (r2)
L1225:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1153
        la      r0,_S320
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1153:
        la      r0,_tok_lexeme
        push    r0
        lw      r0,-47(fp)
        push    r0
        la      r0,_field_lookup
        jal     r1,(r0)
        add     sp,6
        sw      r0,-50(fp)
        lw      r0,-50(fp)
        cls     r0,z
        brf     L1155
        la      r0,_tok_lexeme
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S321
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1155:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_has_arrays
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1157
        lc      r0,1
        la      r1,_has_arrays
        sw      r0,0(r1)
        la      r0,_S322
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1157:
        la      r0,_field_type
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        ceq     r0,r1
        brt     L1224
        la      r2,L1158
        jmp     (r2)
L1224:
        lc      r0,57
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1161
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1161:
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,0
        cls     r1,r0
        brf     L1163
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        mul     r0,r1
        push    r0
        la      r0,_S323
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S324
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1163:
        la      r0,_S325
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_expression
        jal     r1,(r0)
        la      r0,_field_arr_low
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-53(fp)
        la      r0,_field_arr_elem
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1164
        lc      r0,1
        bra     L1165
L1164:
        lc      r0,3
L1165:
        sw      r0,-56(fp)
        lw      r0,-53(fp)
        ceq     r0,z
        brt     L1167
        lw      r0,-53(fp)
        push    r0
        la      r0,_S326
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S327
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1167:
        lw      r0,-56(fp)
        lc      r1,1
        cls     r1,r0
        brf     L1169
        lw      r0,-56(fp)
        push    r0
        la      r0,_S328
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S329
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1169:
        la      r0,_S330
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S331
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,58
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1171
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1171:
        la      r0,_S332
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,20
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1173
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1173:
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-38(fp)
        la      r0,_S333
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_field_arr_elem
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,4
        ceq     r0,r1
        brf     L1174
        la      r0,_S334
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L1175
L1174:
        la      r0,_S335
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1175:
        la      r2,L1159
        jmp     (r2)
L1158:
        lc      r0,20
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1177
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1177:
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,0
        cls     r1,r0
        brf     L1179
        la      r0,_field_offset
        push    r0
        lw      r0,-50(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,3
        mul     r0,r1
        push    r0
        la      r0,_S336
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S337
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1179:
        la      r0,_S338
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-38(fp)
        la      r0,_S339
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S340
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1159:
        la      r2,L1147
        jmp     (r2)
L1146:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,20
        ceq     r0,r1
        brt     L1223
        la      r2,L1180
        jmp     (r2)
L1223:
        la      r0,_next_token
        jal     r1,(r0)
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_load_sym
        jal     r1,(r0)
        add     sp,3
        la      r1,_has_arrays
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1183
        lc      r0,1
        la      r1,_has_arrays
        sw      r0,0(r1)
        la      r0,_S341
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1183:
        la      r0,_S342
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-38(fp)
        la      r0,_S343
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S344
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L1181
L1180:
        la      r0,_S345
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L1181:
L1147:
        la      r2,L1139
        jmp     (r2)
L1138:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,20
        ceq     r0,r1
        brt     L1222
        la      r2,L1184
        jmp     (r2)
L1222:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_in_proc
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1190
        la      r1,_cur_func_local
        lw      r0,0(r1)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1190
        lc      r0,1
        bra     L1191
L1190:
        lc      r0,0
L1191:
        ceq     r0,z
        brt     L1188
        la      r0,_cur_func_name
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1188
        lc      r0,1
        bra     L1189
L1188:
        lc      r0,0
L1189:
        ceq     r0,z
        brt     L1187
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-38(fp)
        la      r1,_cur_func_local
        lw      r0,0(r1)
        push    r0
        la      r0,_S346
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1187:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-35(fp)
        lw      r0,-35(fp)
        cls     r0,z
        brf     L1193
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S347
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1193:
        la      r0,_sym_kind
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brf     L1195
        la      r0,_S348
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1123
        jmp     (r2)
L1195:
        la      r0,_parse_expression
        jal     r1,(r0)
        sw      r0,-38(fp)
        lw      r0,-38(fp)
        push    r0
        la      r0,_sym_type_id
        push    r0
        lw      r0,-35(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_types_compatible
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1197
        la      r0,_S349
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
L1197:
        lw      r0,-35(fp)
        push    r0
        la      r0,_emit_store_sym
        jal     r1,(r0)
        add     sp,3
        bra     L1185
L1184:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_parse_proc_call
        jal     r1,(r0)
        add     sp,3
L1185:
L1139:
L1127:
        la      r2,L1125
        jmp     (r2)
L1124:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,5
        ceq     r0,r1
        brf     L1198
        la      r0,_parse_if_stmt
        jal     r1,(r0)
        la      r2,L1199
        jmp     (r2)
L1198:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,8
        ceq     r0,r1
        brf     L1200
        la      r0,_parse_while_stmt
        jal     r1,(r0)
        la      r2,L1201
        jmp     (r2)
L1200:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,48
        ceq     r0,r1
        brf     L1202
        la      r0,_parse_for_stmt
        jal     r1,(r0)
        la      r2,L1203
        jmp     (r2)
L1202:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,51
        ceq     r0,r1
        brf     L1204
        la      r0,_parse_repeat_stmt
        jal     r1,(r0)
        la      r2,L1205
        jmp     (r2)
L1204:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,53
        ceq     r0,r1
        brf     L1206
        la      r0,_parse_case_stmt
        jal     r1,(r0)
        la      r2,L1207
        jmp     (r2)
L1206:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,55
        ceq     r0,r1
        brf     L1208
        la      r0,_parse_read_stmt
        jal     r1,(r0)
        la      r2,L1209
        jmp     (r2)
L1208:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,56
        ceq     r0,r1
        brf     L1210
        la      r0,_parse_readln_stmt
        jal     r1,(r0)
        la      r2,L1211
        jmp     (r2)
L1210:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,54
        ceq     r0,r1
        brf     L1212
        la      r0,_parse_write_stmt
        jal     r1,(r0)
        la      r2,L1213
        jmp     (r2)
L1212:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,10
        ceq     r0,r1
        brf     L1214
        la      r0,_parse_writeln_stmt
        jal     r1,(r0)
        la      r2,L1215
        jmp     (r2)
L1214:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,3
        ceq     r0,r1
        brf     L1216
        la      r0,_parse_compound_stmt
        jal     r1,(r0)
        bra     L1217
L1216:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,63
        ceq     r0,r1
        brf     L1219
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_exit_label
        lw      r0,0(r1)
        cls     r0,z
        brf     L1220
        la      r0,_S350
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        bra     L1221
L1220:
        la      r1,_exit_label
        lw      r0,0(r1)
        push    r0
        la      r0,_S351
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1221:
L1219:
L1217:
L1215:
L1213:
L1211:
L1209:
L1207:
L1205:
L1203:
L1201:
L1199:
L1125:
L1123:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_const_def
_parse_const_def:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-44
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1231
        la      r0,_S352
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1229
        jmp     (r2)
L1231:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,29
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1233
        lc      r0,0
        la      r2,L1229
        jmp     (r2)
L1233:
        lc      r0,0
        sw      r0,-41(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L1234
        lc      r0,1
        sw      r0,-41(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1235
L1234:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,26
        ceq     r0,r1
        brf     L1237
        la      r0,_next_token
        jal     r1,(r0)
L1237:
L1235:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L1238
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-35(fp)
        lw      r0,-41(fp)
        ceq     r0,z
        brt     L1241
        lc      r0,0
        lw      r1,-35(fp)
        sub     r0,r1
        sw      r0,-35(fp)
L1241:
        lc      r0,0
        sw      r0,-38(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1239
        jmp     (r2)
L1238:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,13
        ceq     r0,r1
        brf     L1242
        lc      r0,1
        sw      r0,-35(fp)
        lc      r0,1
        sw      r0,-38(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1243
        jmp     (r2)
L1242:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,14
        ceq     r0,r1
        brf     L1244
        lc      r0,0
        sw      r0,-35(fp)
        lc      r0,1
        sw      r0,-38(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1245
        jmp     (r2)
L1244:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1254
        la      r2,L1246
        jmp     (r2)
L1254:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-44(fp)
        lw      r0,-44(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1250
        la      r0,_sym_kind
        push    r0
        lw      r0,-44(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L1250
        lc      r0,0
        bra     L1251
L1250:
        lc      r0,1
L1251:
        ceq     r0,z
        brt     L1249
        la      r0,_S353
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1229
        jmp     (r2)
L1249:
        la      r0,_sym_value
        push    r0
        lw      r0,-44(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-35(fp)
        lw      r0,-41(fp)
        ceq     r0,z
        brt     L1253
        lc      r0,0
        lw      r1,-35(fp)
        sub     r0,r1
        sw      r0,-35(fp)
L1253:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-44(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-38(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1247
L1246:
        la      r0,_S354
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        bra     L1229
L1247:
L1245:
L1243:
L1239:
        lw      r0,-35(fp)
        push    r0
        lw      r0,-38(fp)
        push    r0
        lc      r0,0
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L1229:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_const_section
_parse_const_section:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_const_def
        jal     r1,(r0)
L1256:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1258
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1258
        lc      r0,1
        bra     L1259
L1258:
        lc      r0,0
L1259:
        ceq     r0,z
        brt     L1257
        la      r0,_parse_const_def
        jal     r1,(r0)
        bra     L1256
L1257:
L1255:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_type_section
_parse_type_section:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-106
        la      r0,_next_token
        jal     r1,(r0)
L1261:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1263
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1263
        lc      r0,1
        bra     L1264
L1263:
        lc      r0,0
L1264:
        ceq     r0,z
        brf     L1350
        la      r2,L1262
        jmp     (r2)
L1350:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,29
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1266
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1266:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,65
        ceq     r0,r1
        brt     L1349
        la      r2,L1267
        jmp     (r2)
L1349:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1270
        la      r0,_S355
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1270:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-64
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_utype_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-67(fp)
        lw      r0,-67(fp)
        cls     r0,z
        brf     L1271
        lc      r0,5
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_utype_add
        jal     r1,(r0)
        add     sp,6
        sw      r0,-67(fp)
        bra     L1272
L1271:
        la      r0,_utype_kind
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,5
        sw      r0,0(r1)
L1272:
        lw      r0,-67(fp)
        cls     r0,z
        brf     L1274
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1274:
        la      r0,_utype_size
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
        lc      r0,-64
        add     r0,fp
        push    r0
        la      r0,_utype_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-70(fp)
        lw      r0,-70(fp)
        cls     r0,z
        brf     L1276
        lc      r0,6
        push    r0
        lc      r0,-64
        add     r0,fp
        push    r0
        la      r0,_utype_add
        jal     r1,(r0)
        add     sp,6
        sw      r0,-70(fp)
L1276:
        la      r0,_utype_base
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-70(fp)
        sw      r0,0(r1)
        la      r2,L1268
        jmp     (r2)
L1267:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,46
        ceq     r0,r1
        brt     L1348
        la      r2,L1277
        jmp     (r2)
L1348:
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_utype_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-67(fp)
        lw      r0,-67(fp)
        cls     r0,z
        brf     L1279
        lc      r0,6
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_utype_add
        jal     r1,(r0)
        add     sp,6
        sw      r0,-67(fp)
        bra     L1280
L1279:
        la      r0,_utype_kind
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,6
        sw      r0,0(r1)
L1280:
        lw      r0,-67(fp)
        cls     r0,z
        brf     L1282
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1282:
        la      r1,_field_count
        lw      r0,0(r1)
        sw      r0,-73(fp)
        lc      r0,0
        sw      r0,-76(fp)
        lc      r0,0
        sw      r0,-79(fp)
L1283:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1285
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1285
        lc      r0,1
        bra     L1286
L1285:
        lc      r0,0
L1286:
        ceq     r0,z
        brf     L1347
        la      r2,L1284
        jmp     (r2)
L1347:
        la      r1,_field_count
        lw      r0,0(r1)
        sw      r0,-88(fp)
        la      r1,_field_count
        lw      r0,0(r1)
        la      r1,128
        cls     r0,r1
        brt     L1288
        la      r0,_S356
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1288:
        la      r0,_tok_lexeme
        push    r0
        la      r1,_field_count
        lw      r0,0(r1)
        push    r0
        la      r0,_field_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r1,_field_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_field_count
        sw      r0,0(r1)
        lw      r0,-76(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-76(fp)
        la      r0,_next_token
        jal     r1,(r0)
L1289:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1346
        la      r2,L1290
        jmp     (r2)
L1346:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1292
        la      r0,_S357
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1292:
        la      r1,_field_count
        lw      r0,0(r1)
        la      r1,128
        cls     r0,r1
        brt     L1294
        la      r0,_S358
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1294:
        la      r0,_tok_lexeme
        push    r0
        la      r1,_field_count
        lw      r0,0(r1)
        push    r0
        la      r0,_field_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r1,_field_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_field_count
        sw      r0,0(r1)
        lw      r0,-76(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-76(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1289
        jmp     (r2)
L1290:
        lc      r0,35
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1296
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1296:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,44
        ceq     r0,r1
        brt     L1345
        la      r2,L1297
        jmp     (r2)
L1345:
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,57
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1300
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1300:
        lc      r0,0
        sw      r0,-94(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L1301
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brt     L1304
        la      r0,_S359
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1304:
        lc      r0,0
        la      r1,_tok_int_val
        lw      r1,0(r1)
        sub     r0,r1
        sw      r0,-94(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1302
L1301:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L1305
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-94(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1306
L1305:
        la      r0,_S360
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1306:
L1302:
        lc      r0,59
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1308
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1308:
        lc      r0,0
        sw      r0,-97(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L1309
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brt     L1312
        la      r0,_S361
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1312:
        lc      r0,0
        la      r1,_tok_int_val
        lw      r1,0(r1)
        sub     r0,r1
        sw      r0,-97(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1310
L1309:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L1313
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-97(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1314
L1313:
        la      r0,_S362
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1314:
L1310:
        lc      r0,58
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1316
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1316:
        lc      r0,45
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1318
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1318:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,11
        ceq     r0,r1
        brf     L1319
        lc      r0,0
        sw      r0,-100(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1320
L1319:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,12
        ceq     r0,r1
        brf     L1321
        lc      r0,1
        sw      r0,-100(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1322
L1321:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,47
        ceq     r0,r1
        brf     L1323
        lc      r0,4
        sw      r0,-100(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1324
L1323:
        la      r0,_S363
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1324:
L1322:
L1320:
        lw      r0,-97(fp)
        lw      r1,-94(fp)
        sub     r0,r1
        lc      r1,1
        add     r0,r1
        sw      r0,-103(fp)
        lw      r0,-103(fp)
        lc      r1,0
        cls     r1,r0
        brt     L1326
        la      r0,_S364
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1326:
        lw      r0,-100(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L1327
        lw      r0,-103(fp)
        lc      r1,2
        add     r0,r1
        lc      r1,3
        push    r1
        push    r0
        la      r0,__tc24r_div
        jal     r1,(r0)
        add     sp,6
        sw      r0,-106(fp)
        bra     L1328
L1327:
        lw      r0,-103(fp)
        sw      r0,-106(fp)
L1328:
        lw      r0,-88(fp)
        sw      r0,-91(fp)
L1329:
        lw      r0,-91(fp)
        la      r1,_field_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1344
        la      r2,L1330
        jmp     (r2)
L1344:
        la      r0,_field_type
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,3
        sw      r0,0(r1)
        la      r0,_field_offset
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-79(fp)
        sw      r0,0(r1)
        la      r0,_field_size
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-106(fp)
        sw      r0,0(r1)
        la      r0,_field_arr_low
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-94(fp)
        sw      r0,0(r1)
        la      r0,_field_arr_high
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-97(fp)
        sw      r0,0(r1)
        la      r0,_field_arr_elem
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-100(fp)
        sw      r0,0(r1)
        la      r0,_field_arr_size
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-103(fp)
        sw      r0,0(r1)
        lw      r0,-79(fp)
        lw      r1,-106(fp)
        add     r0,r1
        sw      r0,-79(fp)
        lw      r0,-91(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-91(fp)
        la      r2,L1329
        jmp     (r2)
L1330:
        la      r2,L1298
        jmp     (r2)
L1297:
        lc      r0,-85
        add     r0,fp
        push    r0
        la      r0,_resolve_type_name
        jal     r1,(r0)
        add     sp,3
        sw      r0,-82(fp)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1332
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1332:
        lw      r0,-88(fp)
        sw      r0,-91(fp)
L1333:
        lw      r0,-91(fp)
        la      r1,_field_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1343
        la      r2,L1334
        jmp     (r2)
L1343:
        la      r0,_field_type
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-82(fp)
        sw      r0,0(r1)
        la      r0,_field_offset
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-79(fp)
        sw      r0,0(r1)
        la      r0,_field_size
        push    r0
        lw      r0,-91(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
        lw      r0,-79(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-79(fp)
        lw      r0,-91(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-91(fp)
        la      r2,L1333
        jmp     (r2)
L1334:
L1298:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,21
        ceq     r0,r1
        brf     L1336
        la      r0,_next_token
        jal     r1,(r0)
L1336:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,4
        ceq     r0,r1
        brf     L1338
        bra     L1284
L1338:
        la      r2,L1283
        jmp     (r2)
L1284:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,4
        ceq     r0,r1
        brt     L1340
        la      r0,_S365
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1260
        jmp     (r2)
L1340:
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_utype_base
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-73(fp)
        sw      r0,0(r1)
        la      r0,_utype_nfields
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-76(fp)
        sw      r0,0(r1)
        la      r0,_utype_size
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-79(fp)
        sw      r0,0(r1)
        bra     L1278
L1277:
        la      r0,_S366
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        bra     L1260
L1278:
L1268:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1342
        lc      r0,0
        bra     L1260
L1342:
        la      r2,L1261
        jmp     (r2)
L1262:
L1260:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_var_decl
_parse_var_decl:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-27
        la      r1,_sym_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1353
        la      r0,_S367
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1353:
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        la      r0,_next_token
        jal     r1,(r0)
L1354:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brf     L1355
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1357
        la      r0,_S368
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1357:
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,1
        push    r0
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1354
        jmp     (r2)
L1355:
        lc      r0,35
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1359
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1359:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,44
        ceq     r0,r1
        brt     L1414
        la      r2,L1360
        jmp     (r2)
L1414:
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,57
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1363
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1363:
        lc      r0,0
        sw      r0,-12(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L1364
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brt     L1367
        la      r0,_S369
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1367:
        lc      r0,0
        la      r1,_tok_int_val
        lw      r1,0(r1)
        sub     r0,r1
        sw      r0,-12(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1365
L1364:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L1368
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-12(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1369
L1368:
        la      r0,_S370
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1369:
L1365:
        lc      r0,59
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1371
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1371:
        lc      r0,0
        sw      r0,-15(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,27
        ceq     r0,r1
        brf     L1372
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brt     L1375
        la      r0,_S371
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1375:
        lc      r0,0
        la      r1,_tok_int_val
        lw      r1,0(r1)
        sub     r0,r1
        sw      r0,-15(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1373
L1372:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,37
        ceq     r0,r1
        brf     L1376
        la      r1,_tok_int_val
        lw      r0,0(r1)
        sw      r0,-15(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1377
L1376:
        la      r0,_S372
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1377:
L1373:
        lc      r0,58
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1379
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1379:
        lc      r0,45
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1381
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1381:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,11
        ceq     r0,r1
        brf     L1382
        lc      r0,0
        sw      r0,-18(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1383
L1382:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,12
        ceq     r0,r1
        brf     L1384
        lc      r0,1
        sw      r0,-18(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1385
L1384:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,47
        ceq     r0,r1
        brf     L1386
        lc      r0,4
        sw      r0,-18(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1387
L1386:
        la      r0,_S373
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1387:
L1385:
L1383:
        lw      r0,-15(fp)
        lw      r1,-12(fp)
        sub     r0,r1
        lc      r1,1
        add     r0,r1
        sw      r0,-21(fp)
        lw      r0,-21(fp)
        lc      r1,0
        cls     r1,r0
        brt     L1389
        la      r0,_S374
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1389:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_has_arrays
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1391
        lc      r0,1
        la      r1,_has_arrays
        sw      r0,0(r1)
        la      r1,_global_offset
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_global_offset
        sw      r0,0(r1)
        la      r0,_S375
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1391:
        lw      r0,-3(fp)
        sw      r0,-9(fp)
L1392:
        lw      r0,-9(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1413
        la      r2,L1393
        jmp     (r2)
L1413:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,3
        sw      r0,0(r1)
        la      r0,_sym_arr_low
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-12(fp)
        sw      r0,0(r1)
        la      r0,_sym_arr_high
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-15(fp)
        sw      r0,0(r1)
        la      r0,_sym_arr_elem
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-18(fp)
        sw      r0,0(r1)
        la      r0,_sym_arr_size
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-21(fp)
        sw      r0,0(r1)
        lw      r0,-18(fp)
        lc      r1,4
        ceq     r0,r1
        brf     L1394
        lw      r0,-21(fp)
        lc      r1,2
        add     r0,r1
        lc      r1,3
        push    r1
        push    r0
        la      r0,__tc24r_div
        jal     r1,(r0)
        add     sp,6
        sw      r0,-24(fp)
        bra     L1395
L1394:
        lw      r0,-21(fp)
        sw      r0,-24(fp)
L1395:
        la      r1,_global_offset
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_global_off
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r1,_in_interface
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1397
        la      r0,_sym_is_exported_g
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
L1397:
        la      r1,_global_offset
        lw      r0,0(r1)
        lw      r1,-24(fp)
        add     r0,r1
        la      r1,_global_offset
        sw      r0,0(r1)
        lw      r0,-24(fp)
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S376
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1392
        jmp     (r2)
L1393:
        la      r2,L1361
        jmp     (r2)
L1360:
        lc      r0,-1
        sw      r0,-27(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,11
        ceq     r0,r1
        brf     L1398
        lc      r0,0
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1399
        jmp     (r2)
L1398:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,12
        ceq     r0,r1
        brf     L1400
        lc      r0,1
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1401
        jmp     (r2)
L1400:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,47
        ceq     r0,r1
        brf     L1402
        lc      r0,4
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1403
        jmp     (r2)
L1402:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brf     L1404
        la      r0,_tok_lexeme
        push    r0
        la      r0,_utype_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-27(fp)
        lw      r0,-27(fp)
        cls     r0,z
        brt     L1406
        la      r0,_utype_kind
        push    r0
        lw      r0,-27(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1407
L1406:
        la      r0,_S377
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1407:
        bra     L1405
L1404:
        la      r0,_S378
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1351
        jmp     (r2)
L1405:
L1403:
L1401:
L1399:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        sw      r0,-9(fp)
L1408:
        lw      r0,-9(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1412
        la      r2,L1409
        jmp     (r2)
L1412:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-6(fp)
        sw      r0,0(r1)
        la      r0,_sym_ptr_base
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-27(fp)
        sw      r0,0(r1)
        la      r1,_global_offset
        lw      r0,0(r1)
        push    r0
        la      r0,_sym_global_off
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r1,_in_interface
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1411
        la      r0,_sym_is_exported_g
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
L1411:
        la      r1,_global_offset
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_global_offset
        sw      r0,0(r1)
        lw      r0,-9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S379
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1408
        jmp     (r2)
L1409:
L1361:
L1351:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_var_section
_parse_var_section:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_parse_var_decl
        jal     r1,(r0)
L1416:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1418
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1418
        lc      r0,1
        bra     L1419
L1418:
        lc      r0,0
L1419:
        ceq     r0,z
        brt     L1417
        la      r0,_parse_var_decl
        jal     r1,(r0)
        bra     L1416
L1417:
L1415:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_param_list
_parse_param_list:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-18
        la      r1,_sym_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        lc      r0,0
        sw      r0,-6(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,24
        ceq     r0,r1
        brt     L1422
        lc      r0,0
        la      r2,L1420
        jmp     (r2)
L1422:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,25
        ceq     r0,r1
        brf     L1424
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,0
        la      r2,L1420
        jmp     (r2)
L1424:
L1425:
        lc      r0,1
        ceq     r0,z
        brf     L1444
        la      r2,L1426
        jmp     (r2)
L1444:
        la      r1,_sym_count
        lw      r0,0(r1)
        sw      r0,-9(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1428
        la      r0,_S380
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lw      r0,-6(fp)
        la      r2,L1420
        jmp     (r2)
L1428:
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,2
        push    r0
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
L1429:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1443
        la      r2,L1430
        jmp     (r2)
L1443:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1432
        la      r0,_S381
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lw      r0,-6(fp)
        la      r2,L1420
        jmp     (r2)
L1432:
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,2
        push    r0
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1429
        jmp     (r2)
L1430:
        lc      r0,35
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1434
        lw      r0,-6(fp)
        la      r2,L1420
        jmp     (r2)
L1434:
        lc      r0,-18
        add     r0,fp
        push    r0
        la      r0,_resolve_type_name
        jal     r1,(r0)
        add     sp,3
        sw      r0,-12(fp)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1436
        lw      r0,-6(fp)
        la      r2,L1420
        jmp     (r2)
L1436:
        lw      r0,-9(fp)
        sw      r0,-15(fp)
L1437:
        lw      r0,-15(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L1438
        la      r0,_sym_type_id
        push    r0
        lw      r0,-15(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-12(fp)
        sw      r0,0(r1)
        la      r0,_sym_ptr_base
        push    r0
        lw      r0,-15(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-18(fp)
        sw      r0,0(r1)
        lw      r0,-15(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-15(fp)
        bra     L1437
L1438:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,21
        ceq     r0,r1
        brt     L1440
        bra     L1426
L1440:
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1425
        jmp     (r2)
L1426:
        lc      r0,25
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        sw      r0,-15(fp)
L1441:
        lw      r0,-15(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L1442
        lw      r0,-6(fp)
        lc      r1,1
        sub     r0,r1
        push    r0
        lw      r0,-15(fp)
        lw      r1,-3(fp)
        sub     r0,r1
        mov     r1,r0
        pop     r0
        sub     r0,r1
        push    r0
        la      r0,_sym_value
        push    r0
        lw      r0,-15(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,-15(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-15(fp)
        bra     L1441
L1442:
        lw      r0,-6(fp)
L1420:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_local_vars
_parse_local_vars:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-15
        lc      r0,0
        sw      r0,-12(fp)
        la      r0,_next_token
        jal     r1,(r0)
L1446:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1448
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1448
        lc      r0,1
        bra     L1449
L1448:
        lc      r0,0
L1449:
        ceq     r0,z
        brf     L1464
        la      r2,L1447
        jmp     (r2)
L1464:
        la      r1,_sym_count
        lw      r0,0(r1)
        sw      r0,-3(fp)
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,3
        push    r0
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        lw      r0,-12(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-12(fp)
        la      r0,_next_token
        jal     r1,(r0)
L1450:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1463
        la      r2,L1451
        jmp     (r2)
L1463:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1453
        la      r0,_S382
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lw      r0,-12(fp)
        la      r2,L1445
        jmp     (r2)
L1453:
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,3
        push    r0
        la      r0,_tok_lexeme
        push    r0
        la      r0,_sym_add
        jal     r1,(r0)
        add     sp,12
        lw      r0,-12(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-12(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1450
        jmp     (r2)
L1451:
        lc      r0,35
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1455
        lw      r0,-12(fp)
        la      r2,L1445
        jmp     (r2)
L1455:
        lc      r0,-15
        add     r0,fp
        push    r0
        la      r0,_resolve_type_name
        jal     r1,(r0)
        add     sp,3
        sw      r0,-6(fp)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1457
        lw      r0,-12(fp)
        la      r2,L1445
        jmp     (r2)
L1457:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1459
        lw      r0,-12(fp)
        la      r2,L1445
        jmp     (r2)
L1459:
        lw      r0,-3(fp)
        sw      r0,-9(fp)
L1460:
        lw      r0,-9(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1462
        la      r2,L1461
        jmp     (r2)
L1462:
        la      r0,_sym_type_id
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-6(fp)
        sw      r0,0(r1)
        la      r0,_sym_value
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,9(fp)
        sw      r0,0(r1)
        la      r0,_sym_ptr_base
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-15(fp)
        sw      r0,0(r1)
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1460
        jmp     (r2)
L1461:
        la      r2,L1446
        jmp     (r2)
L1447:
        lw      r0,-12(fp)
L1445:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_proc_or_func_decl
_parse_proc_or_func_decl:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        sub     sp,138
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1467
        la      r0,_S383
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1465
        jmp     (r2)
L1467:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_S384
        push    r0
        lc      r0,-64
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        lc      r0,-32
        add     r0,fp
        push    r0
        lc      r0,-64
        add     r0,fp
        lc      r1,6
        add     r0,r1
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r1,_scope_base
        lw      r0,0(r1)
        sw      r0,-82(fp)
        la      r1,_scope_depth
        lw      r0,0(r1)
        sw      r0,-85(fp)
        la      r1,_in_proc
        lw      r0,0(r1)
        sw      r0,-88(fp)
        la      r1,_cur_proc_argc
        lw      r0,0(r1)
        sw      r0,-91(fp)
        la      r1,_cur_func_local
        lw      r0,0(r1)
        sw      r0,-94(fp)
        la      r0,_cur_func_name
        push    r0
        lc      r0,-126
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r1,_sym_count
        lw      r0,0(r1)
        la      r1,_scope_base
        sw      r0,0(r1)
        la      r1,_scope_depth
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_scope_depth
        sw      r0,0(r1)
        lc      r0,0
        push    r0
        la      r0,_parse_param_list
        jal     r1,(r0)
        add     sp,3
        sw      r0,-70(fp)
        lc      r0,0
        sw      r0,-79(fp)
        lw      r0,9(fp)
        ceq     r0,z
        brf     L1523
        la      r2,L1469
        jmp     (r2)
L1523:
        lc      r0,35
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1471
        lc      r0,0
        la      r2,L1465
        jmp     (r2)
L1471:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,11
        ceq     r0,r1
        brf     L1472
        lc      r0,0
        sw      r0,-79(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1473
        jmp     (r2)
L1472:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,12
        ceq     r0,r1
        brf     L1474
        lc      r0,1
        sw      r0,-79(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1475
        jmp     (r2)
L1474:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,47
        ceq     r0,r1
        brf     L1476
        lc      r0,4
        sw      r0,-79(fp)
        la      r0,_next_token
        jal     r1,(r0)
        la      r2,L1477
        jmp     (r2)
L1476:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1522
        la      r2,L1478
        jmp     (r2)
L1522:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_utype_lookup
        jal     r1,(r0)
        add     sp,3
        la      r1,-132
        add     r1,fp
        sw      r0,0(r1)
        la      r1,-132
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1482
        la      r0,_utype_kind
        push    r0
        la      r1,-132
        add     r1,fp
        lw      r0,0(r1)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1482
        lc      r0,1
        bra     L1483
L1482:
        lc      r0,0
L1483:
        ceq     r0,z
        brt     L1480
        lc      r0,5
        sw      r0,-79(fp)
        la      r0,_next_token
        jal     r1,(r0)
        bra     L1481
L1480:
        la      r0,_S385
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1465
        jmp     (r2)
L1481:
        bra     L1479
L1478:
        la      r0,_S386
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1465
        jmp     (r2)
L1479:
L1477:
L1475:
L1473:
L1469:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1485
        lc      r0,0
        la      r2,L1465
        jmp     (r2)
L1485:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,42
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1488
        la      r1,_in_interface
        lw      r0,0(r1)
        ceq     r0,z
        brf     L1488
        lc      r0,0
        bra     L1489
L1488:
        lc      r0,1
L1489:
        ceq     r0,z
        brf     L1521
        la      r2,L1487
        jmp     (r2)
L1521:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,42
        ceq     r0,r1
        brf     L1491
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L1491:
        lw      r0,-79(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        lw      r0,-70(fp)
        push    r0
        lc      r0,-64
        add     r0,fp
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        sw      r0,-67(fp)
        lw      r0,-67(fp)
        cls     r0,z
        brf     L1520
        la      r2,L1493
        jmp     (r2)
L1520:
        la      r0,_proc_is_user
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_proc_depth
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r1,_in_interface
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1495
        la      r0,_proc_is_exported
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
L1495:
L1493:
        la      r1,_scope_base
        lw      r0,0(r1)
        la      r1,_sym_count
        sw      r0,0(r1)
        lw      r0,-82(fp)
        la      r1,_scope_base
        sw      r0,0(r1)
        lw      r0,-85(fp)
        la      r1,_scope_depth
        sw      r0,0(r1)
        lc      r0,0
        la      r2,L1465
        jmp     (r2)
L1487:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_proc_lookup
        jal     r1,(r0)
        add     sp,3
        sw      r0,-67(fp)
        lw      r0,-67(fp)
        cls     r0,z
        brt     L1496
        la      r0,_proc_argc
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lw      r0,-70(fp)
        sw      r0,0(r1)
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_proc_depth
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        la      r2,L1497
        jmp     (r2)
L1496:
        lw      r0,-79(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        lw      r0,-70(fp)
        push    r0
        lc      r0,-64
        add     r0,fp
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_proc_add
        jal     r1,(r0)
        add     sp,15
        sw      r0,-67(fp)
        lw      r0,-67(fp)
        cls     r0,z
        brt     L1499
        la      r0,_proc_is_user
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        lc      r0,1
        sw      r0,0(r1)
        la      r1,_scope_depth
        lw      r0,0(r1)
        push    r0
        la      r0,_proc_depth
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
L1499:
L1497:
        lc      r0,1
        la      r1,_in_proc
        sw      r0,0(r1)
        lw      r0,-70(fp)
        la      r1,_cur_proc_argc
        sw      r0,0(r1)
        lw      r0,9(fp)
        ceq     r0,z
        brt     L1500
        lc      r0,0
        la      r1,_cur_func_local
        sw      r0,0(r1)
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_cur_func_name
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        lc      r0,1
        sw      r0,-76(fp)
        bra     L1501
L1500:
        lc      r0,-1
        la      r1,_cur_func_local
        sw      r0,0(r1)
        la      r0,_cur_func_name
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,0
        sw      r0,-76(fp)
L1501:
        lc      r0,0
        sw      r0,-73(fp)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,2
        ceq     r0,r1
        brf     L1503
        lw      r0,-76(fp)
        push    r0
        la      r0,_parse_local_vars
        jal     r1,(r0)
        add     sp,3
        sw      r0,-73(fp)
L1503:
        lw      r0,-73(fp)
        push    r0
        lw      r0,9(fp)
        ceq     r0,z
        brt     L1504
        lc      r0,1
        bra     L1505
L1504:
        lc      r0,0
L1505:
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,-129
        add     r1,fp
        sw      r0,0(r1)
        lw      r0,-67(fp)
        cls     r0,z
        brt     L1507
        la      r1,-129
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r0,_proc_nlocals
        push    r0
        lw      r0,-67(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
L1507:
L1508:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1512
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,41
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1512
        lc      r0,0
        bra     L1513
L1512:
        lc      r0,1
L1513:
        ceq     r0,z
        brt     L1510
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1510
        lc      r0,1
        bra     L1511
L1510:
        lc      r0,0
L1511:
        ceq     r0,z
        brt     L1509
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        brf     L1514
        lc      r0,0
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
        bra     L1515
L1514:
        lc      r0,1
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
L1515:
        la      r2,L1508
        jmp     (r2)
L1509:
        la      r1,-129
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        lc      r0,-64
        add     r0,fp
        push    r0
        la      r0,_S387
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        la      r1,_exit_label
        lw      r0,0(r1)
        la      r1,-135
        add     r1,fp
        sw      r0,0(r1)
        la      r1,_label_count
        lw      r0,0(r1)
        la      r1,-138
        add     r1,fp
        sw      r0,0(r1)
        la      r1,_label_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_label_count
        sw      r0,0(r1)
        la      r1,-138
        add     r1,fp
        lw      r0,0(r1)
        la      r1,_exit_label
        sw      r0,0(r1)
        la      r0,_parse_compound_stmt
        jal     r1,(r0)
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,-138
        add     r1,fp
        lw      r0,0(r1)
        push    r0
        la      r0,_S388
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,9(fp)
        ceq     r0,z
        brt     L1517
        la      r1,_cur_func_local
        lw      r0,0(r1)
        push    r0
        la      r0,_S389
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1517:
        lw      r0,-70(fp)
        push    r0
        la      r0,_S390
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S391
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r1,-135
        add     r1,fp
        lw      r0,0(r1)
        la      r1,_exit_label
        sw      r0,0(r1)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1519
        lc      r0,0
        bra     L1465
L1519:
        la      r1,_scope_base
        lw      r0,0(r1)
        la      r1,_sym_count
        sw      r0,0(r1)
        lw      r0,-82(fp)
        la      r1,_scope_base
        sw      r0,0(r1)
        lw      r0,-85(fp)
        la      r1,_scope_depth
        sw      r0,0(r1)
        lw      r0,-88(fp)
        la      r1,_in_proc
        sw      r0,0(r1)
        lw      r0,-91(fp)
        la      r1,_cur_proc_argc
        sw      r0,0(r1)
        lw      r0,-94(fp)
        la      r1,_cur_func_local
        sw      r0,0(r1)
        lc      r0,-126
        add     r0,fp
        push    r0
        la      r0,_cur_func_name
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
L1465:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_block
_parse_block:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,1
        ceq     r0,r1
        brf     L1526
        la      r0,_parse_const_section
        jal     r1,(r0)
L1526:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,43
        ceq     r0,r1
        brf     L1528
        la      r0,_parse_type_section
        jal     r1,(r0)
L1528:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,2
        ceq     r0,r1
        brf     L1530
        la      r0,_parse_var_section
        jal     r1,(r0)
L1530:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1531
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,41
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1531
        lc      r0,0
        bra     L1532
L1531:
        lc      r0,1
L1532:
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        ceq     r0,z
        brt     L1535
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1535
        lc      r0,1
        bra     L1536
L1535:
        lc      r0,0
L1536:
        ceq     r0,z
        brt     L1534
        la      r0,_S392
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S393
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S394
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S395
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1534:
L1537:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1541
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,41
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1541
        lc      r0,0
        bra     L1542
L1541:
        lc      r0,1
L1542:
        ceq     r0,z
        brt     L1539
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1539
        lc      r0,1
        bra     L1540
L1539:
        lc      r0,0
L1540:
        ceq     r0,z
        brt     L1538
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        brf     L1543
        lc      r0,0
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
        bra     L1544
L1543:
        lc      r0,1
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
L1544:
        la      r2,L1537
        jmp     (r2)
L1538:
        lw      r0,-3(fp)
        ceq     r0,z
        brt     L1547
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1547
        lc      r0,1
        bra     L1548
L1547:
        lc      r0,0
L1548:
        ceq     r0,z
        brt     L1545
        la      r0,_S396
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L1546
L1545:
        la      r0,_S397
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1546:
        la      r0,_S398
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S399
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        la      r0,_S400
        push    r0
        la      r0,_emit_rt_call
        jal     r1,(r0)
        add     sp,3
        la      r1,_label_count
        lw      r0,0(r1)
        sw      r0,-6(fp)
        la      r1,_label_count
        lw      r0,0(r1)
        lc      r1,1
        add     r0,r1
        la      r1,_label_count
        sw      r0,0(r1)
        lw      r0,-6(fp)
        la      r1,_exit_label
        sw      r0,0(r1)
        la      r0,_parse_compound_stmt
        jal     r1,(r0)
        lw      r0,-6(fp)
        push    r0
        la      r0,_S401
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        ceq     r0,z
        brt     L1551
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1551
        lc      r0,1
        bra     L1552
L1551:
        lc      r0,0
L1552:
        ceq     r0,z
        brt     L1549
        la      r0,_S402
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L1550
L1549:
        la      r0,_S403
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1550:
        la      r0,_S404
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,-1
        la      r1,_exit_label
        sw      r0,0(r1)
L1524:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _emit_string_data
_emit_string_data:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        lc      r0,0
        sw      r0,-3(fp)
L1554:
        lw      r0,-3(fp)
        la      r1,_str_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1560
        la      r2,L1555
        jmp     (r2)
L1560:
        lw      r0,-3(fp)
        push    r0
        la      r0,_str_data_at
        jal     r1,(r0)
        add     sp,3
        sw      r0,-9(fp)
        lw      r0,-3(fp)
        push    r0
        la      r0,_S405
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,0
        sw      r0,-6(fp)
L1556:
        lw      r0,-6(fp)
        push    r0
        la      r0,_str_len
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        brf     L1557
        lw      r0,-6(fp)
        lc      r1,0
        cls     r1,r0
        brf     L1559
        la      r0,_S406
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1559:
        lw      r0,-9(fp)
        lw      r1,-6(fp)
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,_S407
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
        la      r2,L1556
        jmp     (r2)
L1557:
        la      r0,_S408
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        la      r2,L1554
        jmp     (r2)
L1555:
L1553:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parser_init
_parser_init:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lc      r0,0
        la      r1,_sym_count
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_label_count
        sw      r0,0(r1)
        lc      r0,-1
        la      r1,_exit_label
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_str_count
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_str_data_used
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_proc_count
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_utype_count
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_field_count
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_unit_hardware
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_unit_mode
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_is_unit_compilation
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_in_interface
        sw      r0,0(r1)
        la      r0,_unit_name
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lc      r0,0
        la      r1,_import_count
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_has_arrays
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_global_offset
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_scope_base
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_scope_depth
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_in_proc
        sw      r0,0(r1)
        lc      r0,0
        la      r1,_cur_proc_argc
        sw      r0,0(r1)
        lc      r0,-1
        la      r1,_cur_func_local
        sw      r0,0(r1)
        la      r0,_cur_func_name
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        la      r0,_register_system_unit
        jal     r1,(r0)
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_lexer_init
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
L1561:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_uses_clause
_parse_uses_clause:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-32
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1564
        la      r0,_S409
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1562
        jmp     (r2)
L1564:
L1565:
        lc      r0,1
        ceq     r0,z
        brf     L1577
        la      r2,L1566
        jmp     (r2)
L1577:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_unit_name
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        la      r0,_next_token
        jal     r1,(r0)
        la      r0,_S410
        push    r0
        la      r0,_unit_name
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L1567
        lc      r0,1
        la      r1,_unit_hardware
        sw      r0,0(r1)
        la      r0,_register_hardware_unit
        jal     r1,(r0)
        la      r2,L1568
        jmp     (r2)
L1567:
        la      r0,_S411
        push    r0
        la      r0,_unit_name
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        ceq     r0,z
        brf     L1569
        lc      r0,1
        la      r1,_unit_mode
        sw      r0,0(r1)
        bra     L1570
L1569:
        la      r0,_unit_name
        push    r0
        la      r0,_import_lookup
        jal     r1,(r0)
        add     sp,3
        cls     r0,z
        brt     L1571
        lc      r0,1
        la      r1,_unit_mode
        sw      r0,0(r1)
        bra     L1572
L1571:
        la      r0,_unit_name
        push    r0
        la      r1,_tok_line
        lw      r0,0(r1)
        push    r0
        la      r0,_S412
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        lc      r0,1
        la      r1,_parse_error
        sw      r0,0(r1)
        lc      r0,0
        bra     L1562
L1572:
L1570:
L1568:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,23
        ceq     r0,r1
        brt     L1574
        bra     L1566
L1574:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,36
        ceq     r0,r1
        brt     L1576
        la      r0,_S413
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        bra     L1562
L1576:
        la      r2,L1565
        jmp     (r2)
L1566:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
L1562:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _emit_externs
_emit_externs:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        brf     L1589
        la      r2,L1579
        jmp     (r2)
L1589:
        la      r0,_S414
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S415
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S416
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S417
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S418
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S419
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S420
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S421
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S422
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S423
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S424
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r2,L1580
        jmp     (r2)
L1579:
        la      r0,_S425
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S426
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S427
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S428
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S429
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S430
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S431
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S432
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S433
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S434
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S435
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1580:
        lc      r0,0
        sw      r0,-3(fp)
L1581:
        lw      r0,-3(fp)
        la      r1,_proc_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1588
        la      r2,L1582
        jmp     (r2)
L1588:
        la      r0,_proc_is_user
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L1587
        la      r2,L1584
        jmp     (r2)
L1587:
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1585
        la      r0,_proc_argc
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S436
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        bra     L1586
L1585:
        lw      r0,-3(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S437
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1586:
L1584:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        la      r2,L1581
        jmp     (r2)
L1582:
L1578:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_program
_parse_program:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-35
        lc      r0,0
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1592
        lc      r0,0
        la      r2,L1590
        jmp     (r2)
L1592:
        la      r0,_tok_lexeme
        push    r0
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        lc      r0,36
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1594
        lc      r0,0
        la      r2,L1590
        jmp     (r2)
L1594:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1596
        lc      r0,0
        la      r2,L1590
        jmp     (r2)
L1596:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,62
        ceq     r0,r1
        brf     L1598
        la      r0,_parse_uses_clause
        jal     r1,(r0)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1600
        lc      r0,0
        la      r2,L1590
        jmp     (r2)
L1600:
L1598:
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        brf     L1611
        la      r2,L1601
        jmp     (r2)
L1611:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_S438
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S439
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        sw      r0,-35(fp)
L1603:
        lw      r0,-35(fp)
        la      r1,_import_count
        lw      r1,0(r1)
        cls     r0,r1
        brf     L1604
        lw      r0,-35(fp)
        push    r0
        la      r0,_import_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S440
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lw      r0,-35(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-35(fp)
        bra     L1603
L1604:
        bra     L1602
L1601:
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_S441
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1602:
        la      r0,_emit_externs
        jal     r1,(r0)
        la      r0,_S442
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,-32
        add     r0,fp
        push    r0
        la      r0,_S443
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_parse_block
        jal     r1,(r0)
        la      r1,_str_count
        lw      r0,0(r1)
        lc      r1,0
        cls     r1,r0
        brf     L1606
        la      r0,_emit_string_data
        jal     r1,(r0)
L1606:
        lc      r0,22
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_unit_mode
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1607
        la      r0,_S444
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        bra     L1608
L1607:
        la      r0,_S445
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1608:
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1610
        la      r0,_S446
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1610:
L1590:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _parse_unit
_parse_unit:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        lc      r0,66
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1614
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1614:
        la      r0,_tok_lexeme
        push    r0
        la      r0,_unit_name
        push    r0
        la      r0,_str_copy
        jal     r1,(r0)
        add     sp,6
        lc      r0,36
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1616
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1616:
        lc      r0,21
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1618
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1618:
        lc      r0,1
        la      r1,_is_unit_compilation
        sw      r0,0(r1)
        lc      r0,1
        la      r1,_unit_mode
        sw      r0,0(r1)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,62
        ceq     r0,r1
        brf     L1620
        la      r0,_parse_uses_clause
        jal     r1,(r0)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1622
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1622:
L1620:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,67
        ceq     r0,r1
        brt     L1624
        la      r0,_S447
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1624:
        la      r0,_next_token
        jal     r1,(r0)
        lc      r0,1
        la      r1,_in_interface
        sw      r0,0(r1)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,1
        ceq     r0,r1
        brf     L1626
        la      r0,_parse_const_section
        jal     r1,(r0)
L1626:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,43
        ceq     r0,r1
        brf     L1628
        la      r0,_parse_type_section
        jal     r1,(r0)
L1628:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,2
        ceq     r0,r1
        brf     L1630
        la      r0,_parse_var_section
        jal     r1,(r0)
L1630:
L1631:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1635
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,41
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1635
        lc      r0,0
        bra     L1636
L1635:
        lc      r0,1
L1636:
        ceq     r0,z
        brt     L1633
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1633
        lc      r0,1
        bra     L1634
L1633:
        lc      r0,0
L1634:
        ceq     r0,z
        brt     L1632
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        brf     L1637
        lc      r0,0
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
        bra     L1638
L1637:
        lc      r0,1
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
L1638:
        la      r2,L1631
        jmp     (r2)
L1632:
        lc      r0,0
        la      r1,_in_interface
        sw      r0,0(r1)
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1640
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1640:
        la      r0,_unit_name
        push    r0
        la      r0,_S448
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r0,_S449
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_emit_externs
        jal     r1,(r0)
        lc      r0,0
        sw      r0,-9(fp)
L1641:
        lw      r0,-9(fp)
        la      r1,_proc_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1688
        la      r2,L1642
        jmp     (r2)
L1688:
        la      r0,_proc_is_exported
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L1644
        la      r0,_proc_argc
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S450
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
L1644:
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1641
        jmp     (r2)
L1642:
        lc      r0,0
        sw      r0,-9(fp)
L1645:
        lw      r0,-9(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1687
        la      r2,L1646
        jmp     (r2)
L1687:
        la      r0,_sym_kind
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1649
        la      r0,_sym_is_exported_g
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L1649
        lc      r0,1
        bra     L1650
L1649:
        lc      r0,0
L1650:
        ceq     r0,z
        brt     L1648
        lw      r0,-9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S451
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1648:
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1645
        jmp     (r2)
L1646:
        la      r0,_unit_name
        push    r0
        la      r0,_S452
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,68
        ceq     r0,r1
        brt     L1652
        la      r0,_S453
        push    r0
        la      r0,_error
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1652:
        la      r0,_next_token
        jal     r1,(r0)
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,1
        ceq     r0,r1
        brf     L1654
        la      r0,_parse_const_section
        jal     r1,(r0)
L1654:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,43
        ceq     r0,r1
        brf     L1656
        la      r0,_parse_type_section
        jal     r1,(r0)
L1656:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,2
        ceq     r0,r1
        brf     L1658
        la      r0,_parse_var_section
        jal     r1,(r0)
L1658:
L1659:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1663
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,41
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1663
        lc      r0,0
        bra     L1664
L1663:
        lc      r0,1
L1664:
        ceq     r0,z
        brt     L1661
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L1661
        lc      r0,1
        bra     L1662
L1661:
        lc      r0,0
L1662:
        ceq     r0,z
        brt     L1660
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,40
        ceq     r0,r1
        brf     L1665
        lc      r0,0
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
        bra     L1666
L1665:
        lc      r0,1
        push    r0
        la      r0,_parse_proc_or_func_decl
        jal     r1,(r0)
        add     sp,3
L1666:
        la      r2,L1659
        jmp     (r2)
L1660:
        la      r1,_str_count
        lw      r0,0(r1)
        lc      r1,0
        cls     r1,r0
        brf     L1668
        la      r0,_emit_string_data
        jal     r1,(r0)
L1668:
        lc      r0,4
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1670
        lc      r0,0
        la      r2,L1612
        jmp     (r2)
L1670:
        lc      r0,22
        push    r0
        la      r0,_expect
        jal     r1,(r0)
        add     sp,3
        la      r0,_S454
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1671
        la      r0,_S455
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r2,L1672
        jmp     (r2)
L1671:
        la      r0,_S456
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_unit_name
        push    r0
        la      r0,_S457
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,0
        sw      r0,-9(fp)
L1673:
        lw      r0,-9(fp)
        la      r1,_proc_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1686
        la      r2,L1674
        jmp     (r2)
L1686:
        la      r0,_proc_is_exported
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brf     L1685
        la      r2,L1676
        jmp     (r2)
L1685:
        la      r0,_proc_argc
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r0,_proc_extern_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S458
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        la      r0,_proc_ret_type
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_proc_has_ret
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S459
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
L1676:
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1673
        jmp     (r2)
L1674:
        lc      r0,0
        sw      r0,-9(fp)
L1677:
        lw      r0,-9(fp)
        la      r1,_sym_count
        lw      r1,0(r1)
        cls     r0,r1
        brt     L1684
        la      r2,L1678
        jmp     (r2)
L1684:
        la      r0,_sym_kind
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L1681
        la      r0,_sym_is_exported_g
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        ceq     r0,z
        brt     L1681
        lc      r0,1
        bra     L1682
L1681:
        lc      r0,0
L1682:
        ceq     r0,z
        brf     L1683
        la      r2,L1680
        jmp     (r2)
L1683:
        la      r0,_sym_global_off
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r0,_sym_name_at
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_S460
        push    r0
        la      r0,___tc24r_printf2
        jal     r1,(r0)
        add     sp,9
        la      r0,_sym_type_id
        push    r0
        lw      r0,-9(fp)
        lc      r1,3
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S461
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
L1680:
        lw      r0,-9(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L1677
        jmp     (r2)
L1678:
        la      r0,_S462
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L1672:
L1612:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _main
_main:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-12
        lc      r0,0
        sw      r0,-6(fp)
        lc      r0,0
        sw      r0,-12(fp)
L1690:
        lc      r0,1
        ceq     r0,z
        brf     L1708
        la      r2,L1691
        jmp     (r2)
L1708:
        la      r0,_getchar
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1694
        lw      r0,-3(fp)
        lc      r1,-1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1694
        lc      r0,0
        bra     L1695
L1694:
        lc      r0,1
L1695:
        ceq     r0,z
        brt     L1693
        bra     L1691
L1693:
        lw      r0,-6(fp)
        push    r0
        la      r0,131072
        lc      r1,1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        brt     L1697
        lc      r0,1
        sw      r0,-12(fp)
        la      r2,L1690
        jmp     (r2)
L1697:
        la      r0,_input_buf
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        lw      r0,-3(fp)
        sb      r0,0(r1)
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
        la      r2,L1690
        jmp     (r2)
L1691:
        la      r0,_input_buf
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        lc      r0,0
        sb      r0,0(r1)
        lw      r0,-6(fp)
        ceq     r0,z
        brf     L1699
        la      r0,_S463
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,1
        la      r2,L1689
        jmp     (r2)
L1699:
        lw      r0,-12(fp)
        ceq     r0,z
        brt     L1701
        la      r0,131072
        push    r0
        la      r0,_S464
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        lc      r0,1
        la      r2,L1689
        jmp     (r2)
L1701:
        lw      r0,-6(fp)
        push    r0
        la      r0,_input_buf
        push    r0
        la      r0,_load_spi_sections
        jal     r1,(r0)
        add     sp,6
        sw      r0,-9(fp)
        lw      r0,-6(fp)
        lw      r1,-9(fp)
        sub     r0,r1
        push    r0
        la      r0,_input_buf
        lw      r1,-9(fp)
        add     r0,r1
        push    r0
        la      r0,_parser_init
        jal     r1,(r0)
        add     sp,6
        lw      r0,-9(fp)
        lc      r1,0
        cls     r1,r0
        brf     L1703
        lw      r0,-9(fp)
        push    r0
        la      r0,_input_buf
        push    r0
        la      r0,_load_spi_sections
        jal     r1,(r0)
        add     sp,6
L1703:
        la      r1,_tok_type
        lw      r0,0(r1)
        lc      r1,66
        ceq     r0,r1
        brf     L1704
        la      r0,_parse_unit
        jal     r1,(r0)
        bra     L1705
L1704:
        la      r0,_parse_program
        jal     r1,(r0)
L1705:
        la      r1,_parse_error
        lw      r0,0(r1)
        ceq     r0,z
        brt     L1707
        la      r0,_S465
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,1
        bra     L1689
L1707:
        la      r0,_S466
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
L1689:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

__tc24r_div:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        lc      r2,0
        cls     r0,z
        brf     __td_dp
        push    r1
        push    r0
        lc      r0,0
        pop     r1
        sub     r0,r1
        pop     r1
        add     r2,1
__td_dp:
        cls     r1,z
        brf     __td_rp
        push    r0
        lc      r0,0
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r2,1
__td_rp:
        push    r2
        lc      r2,0
__td_lp:
        cls     r0,r1
        brt     __td_dn
        sub     r0,r1
        add     r2,1
        bra     __td_lp
__td_dn:
        mov     r0,r2
        pop     r2
        lc      r1,1
        and     r2,r1
        ceq     r2,z
        brt     __td_ret
        push    r0
        lc      r0,0
        pop     r1
        sub     r0,r1
__td_ret:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
__tc24r_mod:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        lc      r2,0
        cls     r0,z
        brf     __tm_dp
        push    r1
        push    r0
        lc      r0,0
        pop     r1
        sub     r0,r1
        pop     r1
        lc      r2,1
__tm_dp:
        cls     r1,z
        brf     __tm_rp
        push    r0
        lc      r0,0
        sub     r0,r1
        mov     r1,r0
        pop     r0
__tm_rp:
        push    r2
__tm_lp:
        cls     r0,r1
        brt     __tm_dn
        sub     r0,r1
        bra     __tm_lp
__tm_dn:
        pop     r2
        ceq     r2,z
        brt     __tm_ret
        push    r0
        lc      r0,0
        pop     r1
        sub     r0,r1
__tm_ret:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .data
_tok_type:
        .zero   3
_tok_line:
        .zero   3
_tok_int_val:
        .zero   3
_tok_lexeme:
        .zero   64
_tok_str_val:
        .zero   256
_tok_str_len:
        .zero   3
_lex_src:
        .zero   3
_lex_pos:
        .zero   3
_lex_len:
        .zero   3
_lex_line:
        .zero   3
_sym_name:
        .zero   8192
_sym_kind:
        .zero   1536
_sym_type_id:
        .zero   1536
_sym_value:
        .zero   1536
_sym_count:
        .zero   3
_sym_arr_low:
        .zero   1536
_sym_arr_high:
        .zero   1536
_sym_arr_elem:
        .zero   1536
_sym_arr_size:
        .zero   1536
_label_count:
        .zero   3
_exit_label:
        .zero   3
_str_data:
        .zero   8192
_str_off:
        .zero   384
_str_len:
        .zero   384
_str_data_used:
        .zero   3
_str_count:
        .zero   3
_proc_pascal:
        .zero   4096
_proc_extern:
        .zero   4096
_proc_argc:
        .zero   384
_proc_has_ret:
        .zero   384
_proc_ret_type:
        .zero   384
_proc_count:
        .zero   3
_proc_is_user:
        .zero   384
_proc_is_exported:
        .zero   384
_proc_nlocals:
        .zero   384
_proc_depth:
        .zero   384
_sym_depth:
        .zero   1536
_scope_base:
        .zero   3
_scope_depth:
        .zero   3
_in_proc:
        .zero   3
_cur_proc_argc:
        .zero   3
_cur_func_local:
        .zero   3
_cur_func_name:
        .zero   32
_utype_name:
        .zero   1024
_utype_kind:
        .zero   96
_utype_size:
        .zero   96
_utype_base:
        .zero   96
_utype_nfields:
        .zero   96
_utype_count:
        .zero   3
_field_name:
        .zero   2048
_field_type:
        .zero   384
_field_offset:
        .zero   384
_field_size:
        .zero   384
_field_count:
        .zero   3
_field_arr_low:
        .zero   384
_field_arr_high:
        .zero   384
_field_arr_elem:
        .zero   384
_field_arr_size:
        .zero   384
_sym_ptr_base:
        .zero   1536
_sym_is_imported:
        .zero   1536
_sym_import_idx:
        .zero   1536
_sym_import_off:
        .zero   1536
_sym_global_off:
        .zero   1536
_sym_is_exported_g:
        .zero   1536
_has_arrays:
        .zero   3
_global_offset:
        .zero   3
_unit_hardware:
        .zero   3
_unit_mode:
        .zero   3
_is_unit_compilation:
        .zero   3
_in_interface:
        .zero   3
_unit_name:
        .zero   32
_import_name:
        .zero   512
_import_count:
        .zero   3
_parse_error:
        .zero   3
_input_buf:
        .zero   131072
_S0:
        .byte   112,114,111,103,114,97,109,0
_S1:
        .byte   99,111,110,115,116,0
_S2:
        .byte   118,97,114,0
_S3:
        .byte   98,101,103,105,110,0
_S4:
        .byte   101,110,100,0
_S5:
        .byte   105,102,0
_S6:
        .byte   116,104,101,110,0
_S7:
        .byte   101,108,115,101,0
_S8:
        .byte   119,104,105,108,101,0
_S9:
        .byte   100,111,0
_S10:
        .byte   119,114,105,116,101,108,110,0
_S11:
        .byte   105,110,116,101,103,101,114,0
_S12:
        .byte   98,111,111,108,101,97,110,0
_S13:
        .byte   116,114,117,101,0
_S14:
        .byte   102,97,108,115,101,0
_S15:
        .byte   100,105,118,0
_S16:
        .byte   109,111,100,0
_S17:
        .byte   97,110,100,0
_S18:
        .byte   111,114,0
_S19:
        .byte   110,111,116,0
_S20:
        .byte   112,114,111,99,101,100,117,114,101,0
_S21:
        .byte   102,117,110,99,116,105,111,110,0
_S22:
        .byte   102,111,114,119,97,114,100,0
_S23:
        .byte   116,121,112,101,0
_S24:
        .byte   97,114,114,97,121,0
_S25:
        .byte   111,102,0
_S26:
        .byte   114,101,99,111,114,100,0
_S27:
        .byte   99,104,97,114,0
_S28:
        .byte   102,111,114,0
_S29:
        .byte   116,111,0
_S30:
        .byte   100,111,119,110,116,111,0
_S31:
        .byte   114,101,112,101,97,116,0
_S32:
        .byte   117,110,116,105,108,0
_S33:
        .byte   99,97,115,101,0
_S34:
        .byte   119,114,105,116,101,0
_S35:
        .byte   114,101,97,100,0
_S36:
        .byte   114,101,97,100,108,110,0
_S37:
        .byte   117,115,101,115,0
_S38:
        .byte   101,120,105,116,0
_S39:
        .byte   110,105,108,0
_S40:
        .byte   117,110,105,116,0
_S41:
        .byte   105,110,116,101,114,102,97,99,101,0
_S42:
        .byte   105,109,112,108,101,109,101,110,116,97,116,105,111,110,0
_S43:
        .byte   80,82,79,71,82,65,77,0
_S44:
        .byte   67,79,78,83,84,0
_S45:
        .byte   86,65,82,0
_S46:
        .byte   66,69,71,73,78,0
_S47:
        .byte   69,78,68,0
_S48:
        .byte   73,70,0
_S49:
        .byte   84,72,69,78,0
_S50:
        .byte   69,76,83,69,0
_S51:
        .byte   87,72,73,76,69,0
_S52:
        .byte   68,79,0
_S53:
        .byte   87,82,73,84,69,76,78,0
_S54:
        .byte   73,78,84,69,71,69,82,0
_S55:
        .byte   66,79,79,76,69,65,78,0
_S56:
        .byte   84,82,85,69,0
_S57:
        .byte   70,65,76,83,69,0
_S58:
        .byte   68,73,86,0
_S59:
        .byte   77,79,68,0
_S60:
        .byte   65,78,68,0
_S61:
        .byte   79,82,0
_S62:
        .byte   78,79,84,0
_S63:
        .byte   65,83,83,73,71,78,0
_S64:
        .byte   83,69,77,73,0
_S65:
        .byte   68,79,84,0
_S66:
        .byte   67,79,77,77,65,0
_S67:
        .byte   76,80,65,82,69,78,0
_S68:
        .byte   82,80,65,82,69,78,0
_S69:
        .byte   80,76,85,83,0
_S70:
        .byte   77,73,78,85,83,0
_S71:
        .byte   83,84,65,82,0
_S72:
        .byte   69,81,0
_S73:
        .byte   78,69,81,0
_S74:
        .byte   76,84,0
_S75:
        .byte   76,69,0
_S76:
        .byte   71,84,0
_S77:
        .byte   71,69,0
_S78:
        .byte   67,79,76,79,78,0
_S79:
        .byte   73,68,69,78,84,0
_S80:
        .byte   73,78,84,0
_S81:
        .byte   80,82,79,67,69,68,85,82,69,0
_S82:
        .byte   70,85,78,67,84,73,79,78,0
_S83:
        .byte   70,79,82,87,65,82,68,0
_S84:
        .byte   84,89,80,69,0
_S85:
        .byte   65,82,82,65,89,0
_S86:
        .byte   79,70,0
_S87:
        .byte   82,69,67,79,82,68,0
_S88:
        .byte   67,72,65,82,0
_S89:
        .byte   70,79,82,0
_S90:
        .byte   84,79,0
_S91:
        .byte   68,79,87,78,84,79,0
_S92:
        .byte   82,69,80,69,65,84,0
_S93:
        .byte   85,78,84,73,76,0
_S94:
        .byte   67,65,83,69,0
_S95:
        .byte   87,82,73,84,69,0
_S96:
        .byte   82,69,65,68,0
_S97:
        .byte   82,69,65,68,76,78,0
_S98:
        .byte   76,66,82,65,67,75,69,84,0
_S99:
        .byte   82,66,82,65,67,75,69,84,0
_S100:
        .byte   68,79,84,68,79,84,0
_S101:
        .byte   67,72,65,82,95,76,73,84,0
_S102:
        .byte   83,84,82,95,76,73,84,0
_S103:
        .byte   85,83,69,83,0
_S104:
        .byte   69,88,73,84,0
_S105:
        .byte   78,73,76,0
_S106:
        .byte   67,65,82,69,84,0
_S107:
        .byte   85,78,73,84,0
_S108:
        .byte   73,78,84,69,82,70,65,67,69,0
_S109:
        .byte   73,77,80,76,69,77,69,78,84,65,84,73,79,78,0
_S110:
        .byte   69,79,70,0
_S111:
        .byte   69,82,82,79,82,0
_S112:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,37,115,32,40,103,111,116,32,37,115,41,10,0
_S113:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,101,120,112,101,99,116,101,100,32,37,115,44,32,103,111,116,32,37,115,10,0
_S114:
        .byte   32,32,32,32,120,99,97,108,108,32,37,115,10,0
_S115:
        .byte   32,32,32,32,99,97,108,108,32,37,115,10,0
_S116:
        .byte   116,111,111,32,109,97,110,121,32,112,114,111,99,101,100,117,114,101,115,0
_S117:
        .byte   116,111,111,32,109,97,110,121,32,116,121,112,101,115,0
_S118:
        .byte   101,120,112,101,99,116,101,100,32,116,121,112,101,32,110,97,109,101,0
_S119:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S120:
        .byte   32,32,32,32,108,111,97,100,110,32,37,100,32,37,100,10,0
_S121:
        .byte   32,32,32,32,108,111,97,100,97,32,37,100,10,0
_S122:
        .byte   32,32,32,32,108,111,97,100,108,32,37,100,10,0
_S123:
        .byte   32,32,32,32,120,108,111,97,100,103,32,37,100,32,37,100,10,0
_S124:
        .byte   32,32,32,32,108,111,97,100,103,32,37,115,10,0
_S125:
        .byte   32,32,32,32,115,116,111,114,101,110,32,37,100,32,37,100,10,0
_S126:
        .byte   32,32,32,32,115,116,111,114,101,97,32,37,100,10,0
_S127:
        .byte   32,32,32,32,115,116,111,114,101,108,32,37,100,10,0
_S128:
        .byte   32,32,32,32,120,115,116,111,114,101,103,32,37,100,32,37,100,10,0
_S129:
        .byte   32,32,32,32,115,116,111,114,101,103,32,37,115,10,0
_S130:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S131:
        .byte   32,32,32,32,115,117,98,10,0
_S132:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S133:
        .byte   32,32,32,32,109,117,108,10,0
_S134:
        .byte   32,32,32,32,97,100,100,114,103,32,37,115,10,0
_S135:
        .byte   32,32,32,32,97,100,100,114,108,32,37,100,10,0
_S136:
        .byte   32,32,32,32,108,111,97,100,97,32,37,100,10,0
_S137:
        .byte   32,32,32,32,97,100,100,10,0
_S138:
        .byte   95,112,50,52,112,95,97,98,115,0
_S139:
        .byte   97,98,115,0
_S140:
        .byte   95,112,50,52,112,95,111,100,100,0
_S141:
        .byte   111,100,100,0
_S142:
        .byte   95,112,50,52,112,95,111,114,100,0
_S143:
        .byte   111,114,100,0
_S144:
        .byte   95,112,50,52,112,95,99,104,114,0
_S145:
        .byte   99,104,114,0
_S146:
        .byte   95,112,50,52,112,95,115,117,99,99,0
_S147:
        .byte   115,117,99,99,0
_S148:
        .byte   95,112,50,52,112,95,112,114,101,100,0
_S149:
        .byte   112,114,101,100,0
_S150:
        .byte   95,112,50,52,112,95,115,113,114,0
_S151:
        .byte   115,113,114,0
_S152:
        .byte   95,112,50,52,112,95,101,111,102,0
_S153:
        .byte   101,111,102,0
_S154:
        .byte   95,112,50,52,112,95,101,111,108,110,0
_S155:
        .byte   101,111,108,110,0
_S156:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,99,104,97,114,0
_S157:
        .byte   119,114,105,116,101,99,104,97,114,0
_S158:
        .byte   95,112,50,52,112,95,112,101,101,107,0
_S159:
        .byte   112,101,101,107,0
_S160:
        .byte   95,112,50,52,112,95,112,111,107,101,0
_S161:
        .byte   112,111,107,101,0
_S162:
        .byte   95,112,50,52,112,95,109,101,109,99,112,121,0
_S163:
        .byte   109,101,109,99,112,121,0
_S164:
        .byte   95,112,50,52,112,95,109,101,109,115,101,116,0
_S165:
        .byte   109,101,109,115,101,116,0
_S166:
        .byte   95,112,50,52,112,95,108,101,100,95,111,110,0
_S167:
        .byte   108,101,100,111,110,0
_S168:
        .byte   95,112,50,52,112,95,108,101,100,95,111,102,102,0
_S169:
        .byte   108,101,100,111,102,102,0
_S170:
        .byte   95,112,50,52,112,95,114,101,97,100,95,115,119,105,116,99,104,0
_S171:
        .byte   114,101,97,100,115,119,105,116,99,104,0
_S172:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,100,117,112,108,105,99,97,116,101,32,115,121,109,98,111,108,32,39,37,115,39,10,0
_S173:
        .byte   116,111,111,32,109,97,110,121,32,115,121,109,98,111,108,115,0
_S174:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S175:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S176:
        .byte   32,32,32,32,112,117,115,104,32,49,10,0
_S177:
        .byte   32,32,32,32,112,117,115,104,32,48,10,0
_S178:
        .byte   32,32,32,32,112,117,115,104,32,48,10,0
_S179:
        .byte   110,111,116,32,114,101,113,117,105,114,101,115,32,98,111,111,108,101,97,110,0
_S180:
        .byte   32,32,32,32,112,117,115,104,32,48,10,0
_S181:
        .byte   32,32,32,32,101,113,10,0
_S182:
        .byte   116,111,111,32,109,97,110,121,32,115,116,114,105,110,103,32,108,105,116,101,114,97,108,115,0
_S183:
        .byte   115,116,114,105,110,103,32,100,97,116,97,32,112,111,111,108,32,102,117,108,108,0
_S184:
        .byte   32,32,32,32,112,117,115,104,32,83,37,100,10,0
_S185:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,100,101,99,108,97,114,101,100,32,39,37,115,39,10,0
_S186:
        .byte   32,32,32,32,108,111,97,100,98,10,0
_S187:
        .byte   32,32,32,32,108,111,97,100,10,0
_S188:
        .byte   32,32,32,32,108,111,97,100,10,0
_S189:
        .byte   101,120,112,101,99,116,101,100,32,102,105,101,108,100,32,110,97,109,101,32,97,102,116,101,114,32,39,46,39,0
_S190:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,107,110,111,119,110,32,102,105,101,108,100,32,39,37,115,39,10,0
_S191:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S192:
        .byte   32,32,32,32,97,100,100,10,0
_S193:
        .byte   46,103,108,111,98,97,108,32,95,112,50,52,112,95,116,109,112,32,49,10,0
_S194:
        .byte   32,32,32,32,115,116,111,114,101,103,32,95,112,50,52,112,95,116,109,112,10,0
_S195:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S196:
        .byte   32,32,32,32,115,117,98,10,0
_S197:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S198:
        .byte   32,32,32,32,109,117,108,10,0
_S199:
        .byte   32,32,32,32,108,111,97,100,103,32,95,112,50,52,112,95,116,109,112,10,0
_S200:
        .byte   32,32,32,32,97,100,100,10,0
_S201:
        .byte   32,32,32,32,108,111,97,100,98,10,0
_S202:
        .byte   32,32,32,32,108,111,97,100,10,0
_S203:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S204:
        .byte   32,32,32,32,97,100,100,10,0
_S205:
        .byte   32,32,32,32,108,111,97,100,10,0
_S206:
        .byte   32,32,32,32,108,111,97,100,10,0
_S207:
        .byte   101,120,112,101,99,116,101,100,32,101,120,112,114,101,115,115,105,111,110,0
_S208:
        .byte   42,32,114,101,113,117,105,114,101,115,32,105,110,116,101,103,101,114,115,0
_S209:
        .byte   32,32,32,32,109,117,108,10,0
_S210:
        .byte   100,105,118,32,114,101,113,117,105,114,101,115,32,105,110,116,101,103,101,114,115,0
_S211:
        .byte   32,32,32,32,100,105,118,10,0
_S212:
        .byte   109,111,100,32,114,101,113,117,105,114,101,115,32,105,110,116,101,103,101,114,115,0
_S213:
        .byte   32,32,32,32,109,111,100,10,0
_S214:
        .byte   97,110,100,32,114,101,113,117,105,114,101,115,32,98,111,111,108,101,97,110,115,0
_S215:
        .byte   32,32,32,32,97,110,100,10,0
_S216:
        .byte   117,110,97,114,121,32,109,105,110,117,115,32,114,101,113,117,105,114,101,115,32,105,110,116,101,103,101,114,0
_S217:
        .byte   32,32,32,32,110,101,103,10,0
_S218:
        .byte   43,32,114,101,113,117,105,114,101,115,32,105,110,116,101,103,101,114,115,0
_S219:
        .byte   32,32,32,32,97,100,100,10,0
_S220:
        .byte   45,32,114,101,113,117,105,114,101,115,32,105,110,116,101,103,101,114,115,0
_S221:
        .byte   32,32,32,32,115,117,98,10,0
_S222:
        .byte   111,114,32,114,101,113,117,105,114,101,115,32,98,111,111,108,101,97,110,115,0
_S223:
        .byte   32,32,32,32,111,114,10,0
_S224:
        .byte   116,121,112,101,32,109,105,115,109,97,116,99,104,32,105,110,32,99,111,109,112,97,114,105,115,111,110,0
_S225:
        .byte   32,32,32,32,101,113,10,0
_S226:
        .byte   32,32,32,32,110,101,10,0
_S227:
        .byte   32,32,32,32,108,116,10,0
_S228:
        .byte   32,32,32,32,108,101,10,0
_S229:
        .byte   32,32,32,32,103,116,10,0
_S230:
        .byte   32,32,32,32,103,101,10,0
_S231:
        .byte   105,102,32,99,111,110,100,105,116,105,111,110,32,109,117,115,116,32,98,101,32,98,111,111,108,101,97,110,0
_S232:
        .byte   32,32,32,32,106,122,32,76,37,100,10,0
_S233:
        .byte   32,32,32,32,106,109,112,32,76,37,100,10,0
_S234:
        .byte   76,37,100,58,10,0
_S235:
        .byte   76,37,100,58,10,0
_S236:
        .byte   76,37,100,58,10,0
_S237:
        .byte   76,37,100,58,10,0
_S238:
        .byte   119,104,105,108,101,32,99,111,110,100,105,116,105,111,110,32,109,117,115,116,32,98,101,32,98,111,111,108,101,97,110,0
_S239:
        .byte   32,32,32,32,106,122,32,76,37,100,10,0
_S240:
        .byte   32,32,32,32,106,109,112,32,76,37,100,10,0
_S241:
        .byte   76,37,100,58,10,0
_S242:
        .byte   101,120,112,101,99,116,101,100,32,118,97,114,105,97,98,108,101,32,97,102,116,101,114,32,102,111,114,0
_S243:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,100,101,99,108,97,114,101,100,32,39,37,115,39,10,0
_S244:
        .byte   102,111,114,32,118,97,114,105,97,98,108,101,32,109,117,115,116,32,98,101,32,97,32,118,97,114,0
_S245:
        .byte   76,37,100,58,10,0
_S246:
        .byte   32,32,32,32,103,101,10,0
_S247:
        .byte   32,32,32,32,108,101,10,0
_S248:
        .byte   32,32,32,32,106,122,32,76,37,100,10,0
_S249:
        .byte   32,32,32,32,112,117,115,104,32,49,10,0
_S250:
        .byte   32,32,32,32,115,117,98,10,0
_S251:
        .byte   32,32,32,32,112,117,115,104,32,49,10,0
_S252:
        .byte   32,32,32,32,97,100,100,10,0
_S253:
        .byte   32,32,32,32,106,109,112,32,76,37,100,10,0
_S254:
        .byte   76,37,100,58,10,0
_S255:
        .byte   76,37,100,58,10,0
_S256:
        .byte   117,110,116,105,108,32,99,111,110,100,105,116,105,111,110,32,109,117,115,116,32,98,101,32,98,111,111,108,101,97,110,0
_S257:
        .byte   32,32,32,32,106,122,32,76,37,100,10,0
_S258:
        .byte   99,97,115,101,32,115,101,108,101,99,116,111,114,32,109,117,115,116,32,98,101,32,105,110,116,101,103,101,114,32,111,114,32,98,111,111,108,101,97,110,0
_S259:
        .byte   32,32,32,32,100,117,112,10,0
_S260:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S261:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S262:
        .byte   101,120,112,101,99,116,101,100,32,105,110,116,101,103,101,114,32,97,102,116,101,114,32,109,105,110,117,115,32,105,110,32,99,97,115,101,32,108,97,98,101,108,0
_S263:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S264:
        .byte   101,120,112,101,99,116,101,100,32,99,111,110,115,116,97,110,116,32,105,110,32,99,97,115,101,32,108,97,98,101,108,0
_S265:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S266:
        .byte   101,120,112,101,99,116,101,100,32,99,111,110,115,116,97,110,116,32,105,110,32,99,97,115,101,32,108,97,98,101,108,0
_S267:
        .byte   32,32,32,32,101,113,10,0
_S268:
        .byte   32,32,32,32,106,122,32,76,37,100,10,0
_S269:
        .byte   32,32,32,32,100,114,111,112,10,0
_S270:
        .byte   32,32,32,32,106,109,112,32,76,37,100,10,0
_S271:
        .byte   76,37,100,58,10,0
_S272:
        .byte   32,32,32,32,100,114,111,112,10,0
_S273:
        .byte   76,37,100,58,10,0
_S274:
        .byte   101,120,112,101,99,116,101,100,32,118,97,114,105,97,98,108,101,32,105,110,32,114,101,97,100,0
_S275:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,100,101,99,108,97,114,101,100,32,39,37,115,39,10,0
_S276:
        .byte   99,97,110,110,111,116,32,114,101,97,100,32,105,110,116,111,32,99,111,110,115,116,97,110,116,0
_S277:
        .byte   95,112,50,52,112,95,114,101,97,100,95,99,104,97,114,0
_S278:
        .byte   95,112,50,52,112,95,114,101,97,100,95,105,110,116,0
_S279:
        .byte   95,112,50,52,112,95,114,101,97,100,95,108,110,0
_S280:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,115,116,114,0
_S281:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,98,111,111,108,0
_S282:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,99,104,97,114,0
_S283:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,105,110,116,0
_S284:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,115,116,114,0
_S285:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,98,111,111,108,0
_S286:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,99,104,97,114,0
_S287:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,105,110,116,0
_S288:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,115,116,114,0
_S289:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,98,111,111,108,0
_S290:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,99,104,97,114,0
_S291:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,105,110,116,0
_S292:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,115,116,114,0
_S293:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,98,111,111,108,0
_S294:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,99,104,97,114,0
_S295:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,105,110,116,0
_S296:
        .byte   95,112,50,52,112,95,119,114,105,116,101,95,108,110,0
_S297:
        .byte   110,101,119,0
_S298:
        .byte   101,120,112,101,99,116,101,100,32,112,111,105,110,116,101,114,32,118,97,114,105,97,98,108,101,0
_S299:
        .byte   117,110,100,101,99,108,97,114,101,100,32,118,97,114,105,97,98,108,101,0
_S300:
        .byte   110,101,119,32,114,101,113,117,105,114,101,115,32,112,111,105,110,116,101,114,32,118,97,114,105,97,98,108,101,0
_S301:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S302:
        .byte   95,112,50,52,112,95,110,101,119,0
_S303:
        .byte   100,105,115,112,111,115,101,0
_S304:
        .byte   101,120,112,101,99,116,101,100,32,112,111,105,110,116,101,114,32,118,97,114,105,97,98,108,101,0
_S305:
        .byte   117,110,100,101,99,108,97,114,101,100,32,118,97,114,105,97,98,108,101,0
_S306:
        .byte   95,112,50,52,112,95,100,105,115,112,111,115,101,0
_S307:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,107,110,111,119,110,32,112,114,111,99,101,100,117,114,101,32,39,37,115,39,10,0
_S308:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,119,114,111,110,103,32,97,114,103,32,99,111,117,110,116,32,102,111,114,32,37,115,10,0
_S309:
        .byte   32,32,32,32,120,99,97,108,108,32,37,115,10,0
_S310:
        .byte   32,32,32,32,99,97,108,108,110,32,37,100,32,37,115,10,0
_S311:
        .byte   32,32,32,32,99,97,108,108,32,37,115,10,0
_S312:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,100,101,99,108,97,114,101,100,32,39,37,115,39,10,0
_S313:
        .byte   110,111,116,32,97,110,32,97,114,114,97,121,0
_S314:
        .byte   32,32,32,32,115,116,111,114,101,103,32,95,112,50,52,112,95,116,109,112,10,0
_S315:
        .byte   32,32,32,32,108,111,97,100,103,32,95,112,50,52,112,95,116,109,112,10,0
_S316:
        .byte   32,32,32,32,115,116,111,114,101,98,10,0
_S317:
        .byte   32,32,32,32,115,116,111,114,101,10,0
_S318:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,100,101,99,108,97,114,101,100,32,39,37,115,39,10,0
_S319:
        .byte   110,111,116,32,97,32,112,111,105,110,116,101,114,0
_S320:
        .byte   101,120,112,101,99,116,101,100,32,102,105,101,108,100,32,110,97,109,101,0
_S321:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,107,110,111,119,110,32,102,105,101,108,100,32,39,37,115,39,10,0
_S322:
        .byte   46,103,108,111,98,97,108,32,95,112,50,52,112,95,116,109,112,32,49,10,0
_S323:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S324:
        .byte   32,32,32,32,97,100,100,10,0
_S325:
        .byte   32,32,32,32,115,116,111,114,101,103,32,95,112,50,52,112,95,116,109,112,10,0
_S326:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S327:
        .byte   32,32,32,32,115,117,98,10,0
_S328:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S329:
        .byte   32,32,32,32,109,117,108,10,0
_S330:
        .byte   32,32,32,32,108,111,97,100,103,32,95,112,50,52,112,95,116,109,112,10,0
_S331:
        .byte   32,32,32,32,97,100,100,10,0
_S332:
        .byte   32,32,32,32,115,116,111,114,101,103,32,95,112,50,52,112,95,116,109,112,10,0
_S333:
        .byte   32,32,32,32,108,111,97,100,103,32,95,112,50,52,112,95,116,109,112,10,0
_S334:
        .byte   32,32,32,32,115,116,111,114,101,98,10,0
_S335:
        .byte   32,32,32,32,115,116,111,114,101,10,0
_S336:
        .byte   32,32,32,32,112,117,115,104,32,37,100,10,0
_S337:
        .byte   32,32,32,32,97,100,100,10,0
_S338:
        .byte   32,32,32,32,115,116,111,114,101,103,32,95,112,50,52,112,95,116,109,112,10,0
_S339:
        .byte   32,32,32,32,108,111,97,100,103,32,95,112,50,52,112,95,116,109,112,10,0
_S340:
        .byte   32,32,32,32,115,116,111,114,101,10,0
_S341:
        .byte   46,103,108,111,98,97,108,32,95,112,50,52,112,95,116,109,112,32,49,10,0
_S342:
        .byte   32,32,32,32,115,116,111,114,101,103,32,95,112,50,52,112,95,116,109,112,10,0
_S343:
        .byte   32,32,32,32,108,111,97,100,103,32,95,112,50,52,112,95,116,109,112,10,0
_S344:
        .byte   32,32,32,32,115,116,111,114,101,10,0
_S345:
        .byte   101,120,112,101,99,116,101,100,32,58,61,32,111,114,32,46,102,105,101,108,100,32,97,102,116,101,114,32,94,0
_S346:
        .byte   32,32,32,32,115,116,111,114,101,108,32,37,100,10,0
_S347:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,100,101,99,108,97,114,101,100,32,39,37,115,39,10,0
_S348:
        .byte   99,97,110,110,111,116,32,97,115,115,105,103,110,32,116,111,32,99,111,110,115,116,97,110,116,0
_S349:
        .byte   116,121,112,101,32,109,105,115,109,97,116,99,104,32,105,110,32,97,115,115,105,103,110,109,101,110,116,0
_S350:
        .byte   101,120,105,116,32,111,117,116,115,105,100,101,32,112,114,111,99,101,100,117,114,101,47,102,117,110,99,116,105,111,110,0
_S351:
        .byte   32,32,32,32,106,109,112,32,76,37,100,10,0
_S352:
        .byte   101,120,112,101,99,116,101,100,32,105,100,101,110,116,105,102,105,101,114,32,105,110,32,99,111,110,115,116,0
_S353:
        .byte   101,120,112,101,99,116,101,100,32,99,111,110,115,116,97,110,116,32,118,97,108,117,101,0
_S354:
        .byte   101,120,112,101,99,116,101,100,32,99,111,110,115,116,97,110,116,32,118,97,108,117,101,0
_S355:
        .byte   101,120,112,101,99,116,101,100,32,116,121,112,101,32,110,97,109,101,32,97,102,116,101,114,32,94,0
_S356:
        .byte   116,111,111,32,109,97,110,121,32,114,101,99,111,114,100,32,102,105,101,108,100,115,0
_S357:
        .byte   101,120,112,101,99,116,101,100,32,102,105,101,108,100,32,110,97,109,101,0
_S358:
        .byte   116,111,111,32,109,97,110,121,32,114,101,99,111,114,100,32,102,105,101,108,100,115,0
_S359:
        .byte   101,120,112,101,99,116,101,100,32,105,110,116,101,103,101,114,0
_S360:
        .byte   101,120,112,101,99,116,101,100,32,108,111,119,101,114,32,98,111,117,110,100,0
_S361:
        .byte   101,120,112,101,99,116,101,100,32,105,110,116,101,103,101,114,0
_S362:
        .byte   101,120,112,101,99,116,101,100,32,117,112,112,101,114,32,98,111,117,110,100,0
_S363:
        .byte   101,120,112,101,99,116,101,100,32,101,108,101,109,101,110,116,32,116,121,112,101,0
_S364:
        .byte   97,114,114,97,121,32,115,105,122,101,32,109,117,115,116,32,98,101,32,112,111,115,105,116,105,118,101,0
_S365:
        .byte   101,120,112,101,99,116,101,100,32,39,101,110,100,39,32,97,102,116,101,114,32,114,101,99,111,114,100,32,102,105,101,108,100,115,0
_S366:
        .byte   101,120,112,101,99,116,101,100,32,94,32,111,114,32,114,101,99,111,114,100,32,105,110,32,116,121,112,101,32,100,101,102,105,110,105,116,105,111,110,0
_S367:
        .byte   101,120,112,101,99,116,101,100,32,105,100,101,110,116,105,102,105,101,114,32,105,110,32,118,97,114,0
_S368:
        .byte   101,120,112,101,99,116,101,100,32,105,100,101,110,116,105,102,105,101,114,32,97,102,116,101,114,32,99,111,109,109,97,0
_S369:
        .byte   101,120,112,101,99,116,101,100,32,105,110,116,101,103,101,114,0
_S370:
        .byte   101,120,112,101,99,116,101,100,32,108,111,119,101,114,32,98,111,117,110,100,0
_S371:
        .byte   101,120,112,101,99,116,101,100,32,105,110,116,101,103,101,114,0
_S372:
        .byte   101,120,112,101,99,116,101,100,32,117,112,112,101,114,32,98,111,117,110,100,0
_S373:
        .byte   101,120,112,101,99,116,101,100,32,101,108,101,109,101,110,116,32,116,121,112,101,0
_S374:
        .byte   97,114,114,97,121,32,115,105,122,101,32,109,117,115,116,32,98,101,32,112,111,115,105,116,105,118,101,0
_S375:
        .byte   46,103,108,111,98,97,108,32,95,112,50,52,112,95,116,109,112,32,49,10,0
_S376:
        .byte   46,103,108,111,98,97,108,32,37,115,32,37,100,10,0
_S377:
        .byte   101,120,112,101,99,116,101,100,32,116,121,112,101,32,110,97,109,101,0
_S378:
        .byte   101,120,112,101,99,116,101,100,32,116,121,112,101,32,110,97,109,101,0
_S379:
        .byte   46,103,108,111,98,97,108,32,37,115,32,49,10,0
_S380:
        .byte   101,120,112,101,99,116,101,100,32,112,97,114,97,109,101,116,101,114,32,110,97,109,101,0
_S381:
        .byte   101,120,112,101,99,116,101,100,32,112,97,114,97,109,101,116,101,114,32,110,97,109,101,32,97,102,116,101,114,32,99,111,109,109,97,0
_S382:
        .byte   101,120,112,101,99,116,101,100,32,105,100,101,110,116,105,102,105,101,114,32,97,102,116,101,114,32,99,111,109,109,97,0
_S383:
        .byte   101,120,112,101,99,116,101,100,32,112,114,111,99,101,100,117,114,101,47,102,117,110,99,116,105,111,110,32,110,97,109,101,0
_S384:
        .byte   95,117,115,101,114,95,0
_S385:
        .byte   101,120,112,101,99,116,101,100,32,114,101,116,117,114,110,32,116,121,112,101,0
_S386:
        .byte   101,120,112,101,99,116,101,100,32,114,101,116,117,114,110,32,116,121,112,101,0
_S387:
        .byte   10,46,112,114,111,99,32,37,115,32,37,100,10,0
_S388:
        .byte   76,37,100,58,10,0
_S389:
        .byte   32,32,32,32,108,111,97,100,108,32,37,100,10,0
_S390:
        .byte   32,32,32,32,114,101,116,32,37,100,10,0
_S391:
        .byte   46,101,110,100,10,0
_S392:
        .byte   10,46,112,114,111,99,32,109,97,105,110,32,48,10,0
_S393:
        .byte   32,32,32,32,99,97,108,108,32,95,112,50,52,112,95,109,97,105,110,10,0
_S394:
        .byte   32,32,32,32,104,97,108,116,10,0
_S395:
        .byte   46,101,110,100,10,0
_S396:
        .byte   10,46,112,114,111,99,32,95,112,50,52,112,95,109,97,105,110,32,48,10,0
_S397:
        .byte   10,46,112,114,111,99,32,109,97,105,110,32,48,10,0
_S398:
        .byte   32,32,32,32,101,110,116,101,114,32,48,10,0
_S399:
        .byte   95,112,50,52,112,95,105,111,95,105,110,105,116,0
_S400:
        .byte   95,112,50,52,112,95,104,101,97,112,95,105,110,105,116,0
_S401:
        .byte   76,37,100,58,10,0
_S402:
        .byte   32,32,32,32,114,101,116,32,48,10,0
_S403:
        .byte   32,32,32,32,104,97,108,116,10,0
_S404:
        .byte   46,101,110,100,10,0
_S405:
        .byte   46,100,97,116,97,32,83,37,100,32,0
_S406:
        .byte   44,0
_S407:
        .byte   37,100,0
_S408:
        .byte   44,48,10,0
_S409:
        .byte   101,120,112,101,99,116,101,100,32,117,110,105,116,32,110,97,109,101,32,97,102,116,101,114,32,117,115,101,115,0
_S410:
        .byte   104,97,114,100,119,97,114,101,0
_S411:
        .byte   117,110,105,116,115,0
_S412:
        .byte   101,114,114,111,114,32,108,105,110,101,32,37,100,58,32,117,110,107,110,111,119,110,32,117,110,105,116,32,39,37,115,39,10,0
_S413:
        .byte   101,120,112,101,99,116,101,100,32,117,110,105,116,32,110,97,109,101,32,97,102,116,101,114,32,99,111,109,109,97,0
_S414:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,105,110,116,32,49,10,0
_S415:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,98,111,111,108,32,49,10,0
_S416:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,115,116,114,32,49,10,0
_S417:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,108,110,32,48,10,0
_S418:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,105,111,95,105,110,105,116,32,48,10,0
_S419:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,114,101,97,100,95,105,110,116,32,48,10,0
_S420:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,114,101,97,100,95,99,104,97,114,32,48,10,0
_S421:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,114,101,97,100,95,108,110,32,48,10,0
_S422:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,104,101,97,112,95,105,110,105,116,32,48,10,0
_S423:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,110,101,119,32,49,10,0
_S424:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,100,105,115,112,111,115,101,32,49,10,0
_S425:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,105,110,116,10,0
_S426:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,98,111,111,108,10,0
_S427:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,115,116,114,10,0
_S428:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,119,114,105,116,101,95,108,110,10,0
_S429:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,105,111,95,105,110,105,116,10,0
_S430:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,114,101,97,100,95,105,110,116,10,0
_S431:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,114,101,97,100,95,99,104,97,114,10,0
_S432:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,114,101,97,100,95,108,110,10,0
_S433:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,104,101,97,112,95,105,110,105,116,10,0
_S434:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,110,101,119,10,0
_S435:
        .byte   46,101,120,116,101,114,110,32,95,112,50,52,112,95,100,105,115,112,111,115,101,10,0
_S436:
        .byte   46,101,120,116,101,114,110,32,37,115,32,37,100,10,0
_S437:
        .byte   46,101,120,116,101,114,110,32,37,115,10,0
_S438:
        .byte   46,117,110,105,116,32,37,115,10,0
_S439:
        .byte   46,105,109,112,111,114,116,32,112,50,52,112,95,114,116,10,0
_S440:
        .byte   46,105,109,112,111,114,116,32,37,115,10,0
_S441:
        .byte   46,109,111,100,117,108,101,32,37,115,10,0
_S442:
        .byte   46,101,120,112,111,114,116,32,109,97,105,110,10,0
_S443:
        .byte   59,32,112,50,52,112,32,111,117,116,112,117,116,58,32,37,115,10,0
_S444:
        .byte   46,101,110,100,117,110,105,116,10,0
_S445:
        .byte   46,101,110,100,109,111,100,117,108,101,10,0
_S446:
        .byte   59,32,99,111,109,112,105,108,97,116,105,111,110,32,102,97,105,108,101,100,10,0
_S447:
        .byte   101,120,112,101,99,116,101,100,32,39,105,110,116,101,114,102,97,99,101,39,32,105,110,32,117,110,105,116,0
_S448:
        .byte   46,117,110,105,116,32,37,115,10,0
_S449:
        .byte   46,105,109,112,111,114,116,32,112,50,52,112,95,114,116,10,0
_S450:
        .byte   46,101,120,112,111,114,116,32,37,115,32,37,100,10,0
_S451:
        .byte   46,103,108,111,98,97,108,32,37,115,32,49,10,0
_S452:
        .byte   59,32,112,50,52,112,32,117,110,105,116,58,32,37,115,10,0
_S453:
        .byte   101,120,112,101,99,116,101,100,32,39,105,109,112,108,101,109,101,110,116,97,116,105,111,110,39,32,105,110,32,117,110,105,116,0
_S454:
        .byte   46,101,110,100,117,110,105,116,10,0
_S455:
        .byte   59,32,99,111,109,112,105,108,97,116,105,111,110,32,102,97,105,108,101,100,10,0
_S456:
        .byte   59,45,45,45,32,83,80,73,32,45,45,45,10,0
_S457:
        .byte   46,117,110,105,116,32,37,115,10,0
_S458:
        .byte   46,101,120,112,111,114,116,32,37,115,32,37,100,0
_S459:
        .byte   32,37,100,32,37,100,10,0
_S460:
        .byte   46,118,97,114,32,37,115,32,37,100,0
_S461:
        .byte   32,37,100,10,0
_S462:
        .byte   59,45,45,45,32,69,78,68,32,83,80,73,32,45,45,45,10,0
_S463:
        .byte   59,32,69,82,82,79,82,58,32,110,111,32,105,110,112,117,116,10,0
_S464:
        .byte   59,32,69,82,82,79,82,58,32,115,111,117,114,99,101,32,101,120,99,101,101,100,115,32,99,111,109,112,105,108,101,114,32,105,110,112,117,116,32,98,117,102,102,101,114,32,40,37,100,32,98,121,116,101,115,41,10,0
_S465:
        .byte   59,32,67,79,77,80,73,76,69,32,69,82,82,79,82,10,0
_S466:
        .byte   59,32,79,75,10,0
