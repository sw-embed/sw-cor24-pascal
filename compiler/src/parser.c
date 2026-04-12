#include "lexer.c"
#include "parser.h"

/* Forward declarations for recursive descent */
int parse_expression(void);
void parse_stmt(void);
void parse_proc_call(char *name);

/* --- String helpers --- */

void str_copy(char *dst, char *src) {
    int i;
    i = 0;
    while (src[i] != 0) {
        dst[i] = src[i];
        i = i + 1;
    }
    dst[i] = 0;
}

/* --- Type compatibility --- */

int is_ordinal(int t) {
    return (t == TYPE_INTEGER || t == TYPE_CHAR || t == TYPE_BOOLEAN);
}

int types_compatible(int t1, int t2) {
    if (t1 == t2) return 1;
    /* char and integer are freely interchangeable */
    if ((t1 == TYPE_CHAR || t1 == TYPE_INTEGER) &&
        (t2 == TYPE_CHAR || t2 == TYPE_INTEGER)) return 1;
    /* nil is compatible with any pointer */
    if (t1 == TYPE_POINTER && t2 == TYPE_NIL) return 1;
    if (t1 == TYPE_NIL && t2 == TYPE_POINTER) return 1;
    /* all pointers are compatible with each other */
    if (t1 == TYPE_POINTER && t2 == TYPE_POINTER) return 1;
    return 0;
}

/* --- Error handling --- */

void error(char *msg) {
    printf("error line %d: %s (got %s)\n", tok_line, msg, token_name(tok_type));
    parse_error = 1;
}

void expect(int tok) {
    if (tok_type != tok) {
        printf("error line %d: expected %s, got %s\n",
               tok_line, token_name(tok), token_name(tok_type));
        parse_error = 1;
        return;
    }
    next_token();
}

int accept(int tok) {
    if (tok_type == tok) {
        next_token();
        return 1;
    }
    return 0;
}

/* --- .spc emission --- */

void emit_rt_call(char *name) {
    if (unit_mode) {
        printf("    xcall %s\n", name);
    } else {
        printf("    call %s\n", name);
    }
}

int new_label(void) {
    int l;
    l = label_count;
    label_count = label_count + 1;
    return l;
}

/* --- Symbol table --- */

char *sym_name_at(int i) {
    int off;
    off = i * MAX_NAME;
    return &sym_name[off];
}

char *str_data_at(int i) {
    return &str_data[str_off[i]];
}

/* --- Procedure table --- */

char *proc_pascal_at(int i) {
    int off;
    off = i * MAX_NAME;
    return &proc_pascal[off];
}

char *proc_extern_at(int i) {
    int off;
    off = i * MAX_NAME;
    return &proc_extern[off];
}

int proc_lookup(char *name) {
    int i;
    i = 0;
    while (i < proc_count) {
        if (strcmp(proc_pascal_at(i), name) == 0) return i;
        i = i + 1;
    }
    return -1;
}

int proc_add(char *pascal_name, char *extern_name, int argc, int has_ret, int ret_type) {
    int idx;
    if (proc_count >= MAX_PROCS) {
        error("too many procedures");
        return -1;
    }
    idx = proc_count;
    str_copy(proc_pascal_at(idx), pascal_name);
    str_copy(proc_extern_at(idx), extern_name);
    proc_argc[idx] = argc;
    proc_has_ret[idx] = has_ret;
    proc_ret_type[idx] = ret_type;
    proc_is_user[idx] = 0;
    proc_nlocals[idx] = 0;
    proc_depth[idx] = 0;
    proc_count = proc_count + 1;
    return idx;
}

/* --- User type table --- */

char *utype_name_at(int i) {
    int off;
    off = i * MAX_NAME;
    return &utype_name[off];
}

char *field_name_at(int i) {
    int off;
    off = i * MAX_NAME;
    return &field_name[off];
}

int utype_lookup(char *name) {
    int i;
    i = 0;
    while (i < utype_count) {
        if (strcmp(utype_name_at(i), name) == 0) return i;
        i = i + 1;
    }
    return -1;
}

int utype_add(char *name, int kind) {
    int idx;
    if (utype_count >= MAX_TYPES) {
        error("too many types");
        return -1;
    }
    idx = utype_count;
    str_copy(utype_name_at(idx), name);
    utype_kind[idx] = kind;
    utype_size[idx] = 0;
    utype_base[idx] = -1;
    utype_nfields[idx] = 0;
    utype_count = utype_count + 1;
    return idx;
}

int field_lookup(int type_idx, char *name) {
    int base;
    int n;
    int i;
    base = utype_base[type_idx];
    n = utype_nfields[type_idx];
    i = 0;
    while (i < n) {
        if (strcmp(field_name_at(base + i), name) == 0) return base + i;
        i = i + 1;
    }
    return -1;
}

/* Resolve a type name to a type kind.
   Returns: TYPE_INTEGER, TYPE_BOOLEAN, TYPE_CHAR, TYPE_POINTER, TYPE_RECORD.
   For user types, sets *utype_idx to the utype table index (-1 for builtins). */
int resolve_type_name(int *utype_idx) {
    int tidx;
    *utype_idx = -1;
    if (tok_type == TOK_INTEGER_KW) { next_token(); return TYPE_INTEGER; }
    if (tok_type == TOK_BOOLEAN_KW) { next_token(); return TYPE_BOOLEAN; }
    if (tok_type == TOK_CHAR_KW)    { next_token(); return TYPE_CHAR; }
    if (tok_type == TOK_IDENT) {
        tidx = utype_lookup(tok_lexeme);
        if (tidx >= 0) {
            *utype_idx = tidx;
            next_token();
            return utype_kind[tidx];
        }
    }
    error("expected type name");
    return TYPE_INTEGER;
}

/* --- Symbol load/store helpers --- */

void emit_load_sym(int idx) {
    int depth;
    if (sym_kind[idx] == SYM_CONST) {
        printf("    push %d\n", sym_value[idx]);
    } else if (sym_kind[idx] == SYM_PARAM || sym_kind[idx] == SYM_LOCAL) {
        depth = scope_depth - sym_depth[idx];
        if (depth > 0) {
            /* Nonlocal access via static link chain */
            printf("    loadn %d %d\n", depth, sym_value[idx]);
        } else if (sym_kind[idx] == SYM_PARAM) {
            printf("    loada %d\n", sym_value[idx]);
        } else {
            printf("    loadl %d\n", sym_value[idx]);
        }
    } else {
        printf("    loadg %s\n", sym_name_at(idx));
    }
}

void emit_store_sym(int idx) {
    int depth;
    if (sym_kind[idx] == SYM_PARAM || sym_kind[idx] == SYM_LOCAL) {
        depth = scope_depth - sym_depth[idx];
        if (depth > 0) {
            printf("    storen %d %d\n", depth, sym_value[idx]);
        } else if (sym_kind[idx] == SYM_PARAM) {
            printf("    storea %d\n", sym_value[idx]);
        } else {
            printf("    storel %d\n", sym_value[idx]);
        }
    } else {
        printf("    storeg %s\n", sym_name_at(idx));
    }
}

/* Emit code to push the address of array element arr[index_on_stack] */
/* Expects: index expression already on eval stack */
/* Leaves: effective byte address on eval stack */
void emit_array_addr(int idx) {
    int low;
    int elem_size;

    low = sym_arr_low[idx];
    elem_size = (sym_arr_elem[idx] == TYPE_CHAR) ? 1 : 3;

    if (low != 0) {
        printf("    push %d\n", low);
        printf("    sub\n");
    }
    if (elem_size > 1) {
        printf("    push %d\n", elem_size);
        printf("    mul\n");
    }
    if (sym_kind[idx] == SYM_VAR) {
        printf("    addrg %s\n", sym_name_at(idx));
    } else if (sym_kind[idx] == SYM_LOCAL) {
        printf("    addrl %d\n", sym_value[idx]);
    } else if (sym_kind[idx] == SYM_PARAM) {
        printf("    loada %d\n", sym_value[idx]);
    }
    printf("    add\n");
}

void register_system_unit(void) {
    /* Standard functions (return values, used in expressions) */
    /* NOTE: names are lowercase because lexer lowercases identifiers */
    proc_add("abs", "_p24p_abs", 1, 1, TYPE_INTEGER);
    proc_add("odd", "_p24p_odd", 1, 1, TYPE_BOOLEAN);
    proc_add("ord", "_p24p_ord", 1, 1, TYPE_INTEGER);
    proc_add("chr", "_p24p_chr", 1, 1, TYPE_INTEGER);
    proc_add("succ", "_p24p_succ", 1, 1, TYPE_INTEGER);
    proc_add("pred", "_p24p_pred", 1, 1, TYPE_INTEGER);
    proc_add("sqr", "_p24p_sqr", 1, 1, TYPE_INTEGER);
    proc_add("eof", "_p24p_eof", 0, 1, TYPE_BOOLEAN);
    proc_add("eoln", "_p24p_eoln", 0, 1, TYPE_BOOLEAN);
    /* Standard procedures (no return, used as statements) */
    /* readln/read handled as keywords, not proc calls */
    proc_add("writechar", "_p24p_write_char", 1, 0, 0);
    /* Memory access */
    proc_add("peek", "_p24p_peek", 1, 1, TYPE_INTEGER);
    proc_add("poke", "_p24p_poke", 2, 0, 0);
    proc_add("memcpy", "_p24p_memcpy", 3, 0, 0);
    proc_add("memset", "_p24p_memset", 3, 0, 0);
}

void register_hardware_unit(void) {
    proc_add("ledon", "_p24p_led_on", 0, 0, 0);
    proc_add("ledoff", "_p24p_led_off", 0, 0, 0);
    proc_add("readswitch", "_p24p_read_switch", 0, 1, TYPE_INTEGER);
}

/* --- Symbol table --- */

int sym_lookup(char *name) {
    int i;
    i = 0;
    while (i < sym_count) {
        if (strcmp(sym_name_at(i), name) == 0) return i;
        i = i + 1;
    }
    return -1;
}

int sym_add(char *name, int kind, int type, int value) {
    int idx;
    if (sym_lookup(name) >= 0) {
        printf("error line %d: duplicate symbol '%s'\n", tok_line, name);
        parse_error = 1;
        return -1;
    }
    if (sym_count >= MAX_SYMBOLS) {
        error("too many symbols");
        return -1;
    }
    idx = sym_count;
    str_copy(sym_name_at(idx), name);
    sym_kind[idx] = kind;
    sym_type_id[idx] = type;
    sym_value[idx] = value;
    sym_depth[idx] = scope_depth;
    sym_count = sym_count + 1;
    return idx;
}

/* --- Expression parsing (returns type) --- */

int parse_factor(void) {
    int idx;
    int type;
    char name[MAX_NAME];
    char *s;

    if (tok_type == TOK_INT_LIT) {
        printf("    push %d\n", tok_int_val);
        next_token();
        return TYPE_INTEGER;
    }

    if (tok_type == TOK_CHAR_LIT) {
        /* Char literal — push ordinal value */
        printf("    push %d\n", tok_int_val);
        next_token();
        return TYPE_CHAR;
    }

    if (tok_type == TOK_TRUE) {
        printf("    push 1\n");
        next_token();
        return TYPE_BOOLEAN;
    }

    if (tok_type == TOK_FALSE) {
        printf("    push 0\n");
        next_token();
        return TYPE_BOOLEAN;
    }

    if (tok_type == TOK_NIL) {
        printf("    push 0\n");
        next_token();
        return TYPE_NIL;
    }

    if (tok_type == TOK_NOT) {
        next_token();
        type = parse_factor();
        if (type != TYPE_BOOLEAN) error("not requires boolean");
        printf("    push 0\n");
        printf("    eq\n");
        return TYPE_BOOLEAN;
    }

    if (tok_type == TOK_LPAREN) {
        next_token();
        type = parse_expression();
        expect(TOK_RPAREN);
        return type;
    }

    if (tok_type == TOK_STR_LIT) {
        idx = str_count;
        if (idx >= MAX_STRINGS) {
            error("too many string literals");
            return TYPE_STRING;
        }
        if (str_data_used + tok_str_len + 1 > STR_DATA_SIZE) {
            error("string data pool full");
            return TYPE_STRING;
        }
        str_off[idx] = str_data_used;
        str_copy(&str_data[str_data_used], tok_str_val);
        str_len[idx] = tok_str_len;
        str_data_used = str_data_used + tok_str_len + 1;
        str_count = str_count + 1;
        printf("    push S%d\n", idx);
        next_token();
        return TYPE_STRING;
    }

    if (tok_type == TOK_IDENT) {
        str_copy(name, tok_lexeme);
        next_token();

        /* Check if it's a function call */
        idx = proc_lookup(name);
        if (idx >= 0 && proc_has_ret[idx]) {
            parse_proc_call(name);
            return proc_ret_type[idx];
        }

        /* Variable or constant */
        idx = sym_lookup(name);
        if (idx < 0) {
            printf("error line %d: undeclared '%s'\n", tok_line, name);
            parse_error = 1;
            return TYPE_INTEGER;
        }

        /* Array element access: name[expr] */
        if (sym_type_id[idx] == TYPE_ARRAY && tok_type == TOK_LBRACKET) {
            next_token();
            parse_expression();
            expect(TOK_RBRACKET);
            emit_array_addr(idx);
            if (sym_arr_elem[idx] == TYPE_CHAR) {
                printf("    loadb\n");
            } else {
                printf("    load\n");
            }
            return sym_arr_elem[idx];
        }

        /* Pointer dereference: p^  or p^.field */
        if (sym_type_id[idx] == TYPE_POINTER && tok_type == TOK_CARET) {
            int ptr_utidx;
            int base_utidx;
            int fld_idx;

            emit_load_sym(idx);  /* load pointer value (address) */
            next_token();  /* consume ^ */

            ptr_utidx = sym_ptr_base[idx];
            if (ptr_utidx < 0) {
                /* Raw pointer dereference */
                printf("    load\n");
                return TYPE_INTEGER;
            }
            base_utidx = utype_base[ptr_utidx];

            if (tok_type == TOK_DOT && base_utidx >= 0 && utype_kind[base_utidx] == TYPE_RECORD) {
                /* p^.field */
                next_token();  /* consume . */
                if (tok_type != TOK_IDENT) {
                    error("expected field name after '.'");
                    return TYPE_INTEGER;
                }
                fld_idx = field_lookup(base_utidx, tok_lexeme);
                if (fld_idx < 0) {
                    printf("error line %d: unknown field '%s'\n", tok_line, tok_lexeme);
                    parse_error = 1;
                    return TYPE_INTEGER;
                }
                next_token();

                if (field_type[fld_idx] == TYPE_ARRAY) {
                    /* p^.arrfield[i] — array field access */
                    int fa_low;
                    int fa_elem_size;

                    /* compute base address of array field */
                    if (field_offset[fld_idx] > 0) {
                        printf("    push %d\n", field_offset[fld_idx] * 3);
                        printf("    add\n");
                    }
                    /* now array base address is on stack */

                    expect(TOK_LBRACKET);
                    if (parse_error) return TYPE_INTEGER;

                    /* Ensure scratch global exists */
                    if (!has_arrays) {
                        has_arrays = 1;
                        printf(".global _p24p_tmp 1\n");
                    }
                    /* save base addr */
                    printf("    storeg _p24p_tmp\n");

                    parse_expression(); /* index */

                    fa_low = field_arr_low[fld_idx];
                    fa_elem_size = (field_arr_elem[fld_idx] == TYPE_CHAR) ? 1 : 3;

                    if (fa_low != 0) {
                        printf("    push %d\n", fa_low);
                        printf("    sub\n");
                    }
                    if (fa_elem_size > 1) {
                        printf("    push %d\n", fa_elem_size);
                        printf("    mul\n");
                    }
                    printf("    loadg _p24p_tmp\n");
                    printf("    add\n");

                    expect(TOK_RBRACKET);
                    if (parse_error) return TYPE_INTEGER;

                    if (field_arr_elem[fld_idx] == TYPE_CHAR) {
                        printf("    loadb\n");
                    } else {
                        printf("    load\n");
                    }
                    return field_arr_elem[fld_idx];
                }

                /* scalar field: address + offset, then load */
                if (field_offset[fld_idx] > 0) {
                    printf("    push %d\n", field_offset[fld_idx] * 3);
                    printf("    add\n");
                }
                printf("    load\n");
                return field_type[fld_idx];
            }

            /* p^ without field — dereference whole record or scalar */
            printf("    load\n");
            if (base_utidx >= 0) {
                return utype_kind[base_utidx];
            }
            return TYPE_INTEGER;
        }

        emit_load_sym(idx);
        return sym_type_id[idx];
    }

    error("expected expression");
    return TYPE_INTEGER;
}

int parse_term(void) {
    int type;
    int op;
    int rtype;

    type = parse_factor();

    while (tok_type == TOK_STAR || tok_type == TOK_DIV ||
           tok_type == TOK_MOD || tok_type == TOK_AND) {
        op = tok_type;
        next_token();
        rtype = parse_factor();

        if (op == TOK_STAR) {
            if (!is_ordinal(type) || !is_ordinal(rtype))
                error("* requires integers");
            printf("    mul\n");
            type = TYPE_INTEGER;
        } else if (op == TOK_DIV) {
            if (!is_ordinal(type) || !is_ordinal(rtype))
                error("div requires integers");
            printf("    div\n");
            type = TYPE_INTEGER;
        } else if (op == TOK_MOD) {
            if (!is_ordinal(type) || !is_ordinal(rtype))
                error("mod requires integers");
            printf("    mod\n");
            type = TYPE_INTEGER;
        } else {
            if (type != TYPE_BOOLEAN || rtype != TYPE_BOOLEAN)
                error("and requires booleans");
            printf("    and\n");
            type = TYPE_BOOLEAN;
        }
    }

    return type;
}

int parse_simple_expr(void) {
    int negate;
    int type;
    int op;
    int rtype;

    negate = 0;
    if (tok_type == TOK_PLUS) {
        next_token();
    } else if (tok_type == TOK_MINUS) {
        next_token();
        negate = 1;
    }

    type = parse_term();

    if (negate) {
        if (!is_ordinal(type)) error("unary minus requires integer");
        printf("    neg\n");
        type = TYPE_INTEGER;
    }

    while (tok_type == TOK_PLUS || tok_type == TOK_MINUS || tok_type == TOK_OR) {
        op = tok_type;
        next_token();
        rtype = parse_term();

        if (op == TOK_PLUS) {
            if (!is_ordinal(type) || !is_ordinal(rtype))
                error("+ requires integers");
            printf("    add\n");
            type = TYPE_INTEGER;
        } else if (op == TOK_MINUS) {
            if (!is_ordinal(type) || !is_ordinal(rtype))
                error("- requires integers");
            printf("    sub\n");
            type = TYPE_INTEGER;
        } else {
            if (type != TYPE_BOOLEAN || rtype != TYPE_BOOLEAN)
                error("or requires booleans");
            printf("    or\n");
            type = TYPE_BOOLEAN;
        }
    }

    return type;
}

int parse_expression(void) {
    int type;
    int op;
    int rtype;

    type = parse_simple_expr();

    if (tok_type == TOK_EQ || tok_type == TOK_NEQ ||
        tok_type == TOK_LT || tok_type == TOK_LE ||
        tok_type == TOK_GT || tok_type == TOK_GE) {
        op = tok_type;
        next_token();
        rtype = parse_simple_expr();

        if (!types_compatible(type, rtype)) error("type mismatch in comparison");

        if (op == TOK_EQ) printf("    eq\n");
        else if (op == TOK_NEQ) printf("    ne\n");
        else if (op == TOK_LT) printf("    lt\n");
        else if (op == TOK_LE) printf("    le\n");
        else if (op == TOK_GT) printf("    gt\n");
        else if (op == TOK_GE) printf("    ge\n");

        return TYPE_BOOLEAN;
    }

    return type;
}

/* --- Statement parsing --- */

void parse_compound_stmt(void) {
    expect(TOK_BEGIN);
    parse_stmt();
    while (tok_type == TOK_SEMI) {
        next_token();
        parse_stmt();
    }
    expect(TOK_END);
}

void parse_if_stmt(void) {
    int type;
    int l_else;
    int l_end;

    next_token(); /* consume IF */
    type = parse_expression();
    if (type != TYPE_BOOLEAN) error("if condition must be boolean");

    l_else = new_label();
    l_end = new_label();

    printf("    jz L%d\n", l_else);

    expect(TOK_THEN);
    parse_stmt();

    if (tok_type == TOK_ELSE) {
        printf("    jmp L%d\n", l_end);
        printf("L%d:\n", l_else);
        next_token();
        parse_stmt();
        printf("L%d:\n", l_end);
    } else {
        printf("L%d:\n", l_else);
    }
}

void parse_while_stmt(void) {
    int type;
    int l_start;
    int l_end;

    next_token(); /* consume WHILE */
    l_start = new_label();
    l_end = new_label();

    printf("L%d:\n", l_start);

    type = parse_expression();
    if (type != TYPE_BOOLEAN) error("while condition must be boolean");

    printf("    jz L%d\n", l_end);

    expect(TOK_DO);
    parse_stmt();

    printf("    jmp L%d\n", l_start);
    printf("L%d:\n", l_end);
}

void parse_for_stmt(void) {
    char name[MAX_NAME];
    int idx;
    int l_start;
    int l_end;
    int downto;

    next_token(); /* consume FOR */

    if (tok_type != TOK_IDENT) {
        error("expected variable after for");
        return;
    }
    str_copy(name, tok_lexeme);
    next_token();

    idx = sym_lookup(name);
    if (idx < 0) {
        printf("error line %d: undeclared '%s'\n", tok_line, name);
        parse_error = 1;
        return;
    }
    if (sym_kind[idx] == SYM_CONST) {
        error("for variable must be a var");
        return;
    }

    expect(TOK_ASSIGN);
    if (parse_error) return;

    parse_expression();
    emit_store_sym(idx);

    downto = 0;
    if (tok_type == TOK_DOWNTO) {
        downto = 1;
        next_token();
    } else {
        expect(TOK_TO);
        if (parse_error) return;
    }

    /* limit expression — evaluated each iteration */
    l_start = new_label();
    l_end = new_label();

    printf("L%d:\n", l_start);
    emit_load_sym(idx);
    parse_expression();
    if (downto) {
        printf("    ge\n");
    } else {
        printf("    le\n");
    }
    printf("    jz L%d\n", l_end);

    expect(TOK_DO);
    if (parse_error) return;
    parse_stmt();

    /* increment/decrement */
    emit_load_sym(idx);
    if (downto) {
        printf("    push 1\n");
        printf("    sub\n");
    } else {
        printf("    push 1\n");
        printf("    add\n");
    }
    emit_store_sym(idx);
    printf("    jmp L%d\n", l_start);
    printf("L%d:\n", l_end);
}

void parse_repeat_stmt(void) {
    int type;
    int l_top;

    next_token(); /* consume REPEAT */
    l_top = new_label();

    printf("L%d:\n", l_top);

    parse_stmt();
    while (tok_type == TOK_SEMI) {
        next_token();
        parse_stmt();
    }

    expect(TOK_UNTIL);
    if (parse_error) return;

    type = parse_expression();
    if (type != TYPE_BOOLEAN) error("until condition must be boolean");

    printf("    jz L%d\n", l_top);
}

void parse_case_stmt(void) {
    int type;
    int l_end;
    int l_next;
    int val;

    next_token(); /* consume CASE */

    type = parse_expression();
    if (type != TYPE_INTEGER && type != TYPE_BOOLEAN) {
        error("case selector must be integer or boolean");
    }

    expect(TOK_OF);
    if (parse_error) return;

    l_end = new_label();

    /* Parse case branches: <const>: <stmt>; ... */
    while (tok_type != TOK_END && tok_type != TOK_EOF && !parse_error) {
        l_next = new_label();

        /* Parse constant value (integer literal or char literal) */
        printf("    dup\n");
        if (tok_type == TOK_INT_LIT) {
            val = tok_int_val;
            printf("    push %d\n", val);
            next_token();
        } else if (tok_type == TOK_CHAR_LIT) {
            val = tok_int_val;
            printf("    push %d\n", val);
            next_token();
        } else if (tok_type == TOK_MINUS) {
            next_token();
            if (tok_type != TOK_INT_LIT) {
                error("expected integer after minus in case label");
                return;
            }
            val = 0 - tok_int_val;
            printf("    push %d\n", val);
            next_token();
        } else if (tok_type == TOK_IDENT) {
            /* Named constant */
            val = sym_lookup(tok_lexeme);
            if (val < 0 || sym_kind[val] != SYM_CONST) {
                error("expected constant in case label");
                return;
            }
            printf("    push %d\n", sym_value[val]);
            next_token();
        } else {
            error("expected constant in case label");
            return;
        }

        printf("    eq\n");
        printf("    jz L%d\n", l_next);

        expect(TOK_COLON);
        if (parse_error) return;

        /* Drop the selector copy before executing the statement */
        printf("    drop\n");
        parse_stmt();

        printf("    jmp L%d\n", l_end);
        printf("L%d:\n", l_next);

        /* Optional semicolon between branches */
        if (tok_type == TOK_SEMI) {
            next_token();
        }
    }

    /* Drop selector value (no branch matched) */
    printf("    drop\n");
    printf("L%d:\n", l_end);

    expect(TOK_END);
}

void parse_read_args(void) {
    char name[MAX_NAME];
    int idx;

    /* parse ( var1, var2, ... ) — each var gets read_int + storeg */
    if (tok_type != TOK_LPAREN) return;
    next_token();

    if (tok_type == TOK_RPAREN) {
        next_token();
        return;
    }

    while (1) {
        if (tok_type != TOK_IDENT) {
            error("expected variable in read");
            return;
        }
        str_copy(name, tok_lexeme);
        next_token();

        idx = sym_lookup(name);
        if (idx < 0) {
            printf("error line %d: undeclared '%s'\n", tok_line, name);
            parse_error = 1;
            return;
        }
        if (sym_kind[idx] == SYM_CONST) {
            error("cannot read into constant");
            return;
        }

        if (sym_type_id[idx] == TYPE_CHAR) {
            emit_rt_call("_p24p_read_char");
        } else {
            emit_rt_call("_p24p_read_int");
        }
        emit_store_sym(idx);

        if (tok_type != TOK_COMMA) break;
        next_token();
    }

    expect(TOK_RPAREN);
}

void parse_read_stmt(void) {
    next_token(); /* consume READ */
    parse_read_args();
}

void parse_readln_stmt(void) {
    next_token(); /* consume READLN */
    parse_read_args();
    emit_rt_call("_p24p_read_ln");
}

void parse_write_stmt(void) {
    int type;

    next_token(); /* consume WRITE */

    if (tok_type == TOK_LPAREN) {
        next_token();

        type = parse_expression();
        if (type == TYPE_STRING) {
            emit_rt_call("_p24p_write_str");
        } else if (type == TYPE_BOOLEAN) {
            emit_rt_call("_p24p_write_bool");
        } else if (type == TYPE_CHAR) {
            emit_rt_call("_p24p_write_char");
        } else {
            emit_rt_call("_p24p_write_int");
        }

        while (tok_type == TOK_COMMA) {
            next_token();
            type = parse_expression();
            if (type == TYPE_STRING) {
                emit_rt_call("_p24p_write_str");
            } else if (type == TYPE_BOOLEAN) {
                emit_rt_call("_p24p_write_bool");
            } else if (type == TYPE_CHAR) {
                emit_rt_call("_p24p_write_char");
            } else {
                emit_rt_call("_p24p_write_int");
            }
        }

        expect(TOK_RPAREN);
    }
    /* no call to _p24p_write_ln */
}

void parse_writeln_stmt(void) {
    int type;

    next_token(); /* consume WRITELN */

    if (tok_type == TOK_LPAREN) {
        next_token();

        type = parse_expression();
        if (type == TYPE_STRING) {
            emit_rt_call("_p24p_write_str");
        } else if (type == TYPE_BOOLEAN) {
            emit_rt_call("_p24p_write_bool");
        } else if (type == TYPE_CHAR) {
            emit_rt_call("_p24p_write_char");
        } else {
            emit_rt_call("_p24p_write_int");
        }

        while (tok_type == TOK_COMMA) {
            next_token();
            type = parse_expression();
            if (type == TYPE_STRING) {
                emit_rt_call("_p24p_write_str");
            } else if (type == TYPE_BOOLEAN) {
                emit_rt_call("_p24p_write_bool");
            } else if (type == TYPE_CHAR) {
                emit_rt_call("_p24p_write_char");
            } else {
                emit_rt_call("_p24p_write_int");
            }
        }

        expect(TOK_RPAREN);
    }

    emit_rt_call("_p24p_write_ln");
}

void parse_proc_call(char *name) {
    int pidx;
    int argc;

    /* Built-in: new(p) — allocate heap memory for pointer's base type */
    if (strcmp(name, "new") == 0) {
        int vidx;
        int ptr_utidx;
        int base_utidx;
        int size;
        expect(TOK_LPAREN);
        if (parse_error) return;
        if (tok_type != TOK_IDENT) { error("expected pointer variable"); return; }
        vidx = sym_lookup(tok_lexeme);
        if (vidx < 0) { error("undeclared variable"); return; }
        if (sym_type_id[vidx] != TYPE_POINTER) { error("new requires pointer variable"); return; }
        next_token();
        expect(TOK_RPAREN);
        if (parse_error) return;

        ptr_utidx = sym_ptr_base[vidx];
        base_utidx = (ptr_utidx >= 0) ? utype_base[ptr_utidx] : -1;
        size = (base_utidx >= 0) ? utype_size[base_utidx] : 1;

        printf("    push %d\n", size * 3);  /* size in bytes (3 bytes/word) */
        emit_rt_call("_p24p_new");
        emit_store_sym(vidx);
        return;
    }

    /* Built-in: dispose(p) — free heap memory */
    if (strcmp(name, "dispose") == 0) {
        int vidx;
        expect(TOK_LPAREN);
        if (parse_error) return;
        if (tok_type != TOK_IDENT) { error("expected pointer variable"); return; }
        vidx = sym_lookup(tok_lexeme);
        if (vidx < 0) { error("undeclared variable"); return; }
        next_token();
        expect(TOK_RPAREN);
        if (parse_error) return;

        emit_load_sym(vidx);
        emit_rt_call("_p24p_dispose");
        return;
    }

    pidx = proc_lookup(name);
    if (pidx < 0) {
        printf("error line %d: unknown procedure '%s'\n", tok_line, name);
        parse_error = 1;
        return;
    }

    argc = 0;
    if (tok_type == TOK_LPAREN) {
        next_token();
        if (tok_type != TOK_RPAREN) {
            parse_expression();
            argc = argc + 1;
            while (tok_type == TOK_COMMA) {
                next_token();
                parse_expression();
                argc = argc + 1;
            }
        }
        expect(TOK_RPAREN);
        if (parse_error) return;
    }

    if (argc != proc_argc[pidx]) {
        printf("error line %d: wrong arg count for %s\n", tok_line, name);
        parse_error = 1;
        return;
    }

    if (unit_mode && !proc_is_user[pidx]) {
        printf("    xcall %s\n", proc_extern_at(pidx));
    } else if (proc_is_user[pidx] && proc_depth[pidx] > 1) {
        /* Nested proc: emit calln with static link depth */
        /* depth = caller_scope_depth - (proc_depth - 1) */
        /* proc_depth is the scope where the proc lives; its parent is proc_depth-1 */
        printf("    calln %d %s\n", scope_depth - proc_depth[pidx] + 1, proc_extern_at(pidx));
    } else {
        printf("    call %s\n", proc_extern_at(pidx));
    }
}

void parse_stmt(void) {
    char name[MAX_NAME];
    int idx;
    int etype;
    int pidx;

    if (tok_type == TOK_IDENT) {
        str_copy(name, tok_lexeme);
        next_token();

        if (tok_type == TOK_LBRACKET) {
            /* Array element assignment: name[expr] := expr */
            idx = sym_lookup(name);
            if (idx < 0) {
                printf("error line %d: undeclared '%s'\n", tok_line, name);
                parse_error = 1;
                return;
            }
            if (sym_type_id[idx] != TYPE_ARRAY) {
                error("not an array");
                return;
            }
            next_token();
            parse_expression();  /* index on stack */
            expect(TOK_RBRACKET);
            if (parse_error) return;
            emit_array_addr(idx);  /* addr on stack */
            /* Save addr to scratch, parse value, restore addr */
            printf("    storeg _p24p_tmp\n");
            expect(TOK_ASSIGN);
            if (parse_error) return;
            parse_expression();  /* value on stack */
            printf("    loadg _p24p_tmp\n");  /* value, addr on stack */
            if (sym_arr_elem[idx] == TYPE_CHAR) {
                printf("    storeb\n");
            } else {
                printf("    store\n");
            }

        } else if (tok_type == TOK_CARET) {
            /* Pointer dereference assignment: p^ := expr or p^.field := expr */
            int ptr_utidx;
            int base_utidx;
            int fld_idx;

            idx = sym_lookup(name);
            if (idx < 0) {
                printf("error line %d: undeclared '%s'\n", tok_line, name);
                parse_error = 1;
                return;
            }
            if (sym_type_id[idx] != TYPE_POINTER) {
                error("not a pointer");
                return;
            }
            next_token();  /* consume ^ */

            ptr_utidx = sym_ptr_base[idx];
            base_utidx = (ptr_utidx >= 0) ? utype_base[ptr_utidx] : -1;

            if (tok_type == TOK_DOT && base_utidx >= 0 && utype_kind[base_utidx] == TYPE_RECORD) {
                /* p^.field := expr */
                next_token();  /* consume . */
                if (tok_type != TOK_IDENT) {
                    error("expected field name");
                    return;
                }
                fld_idx = field_lookup(base_utidx, tok_lexeme);
                if (fld_idx < 0) {
                    printf("error line %d: unknown field '%s'\n", tok_line, tok_lexeme);
                    parse_error = 1;
                    return;
                }
                next_token();

                if (!has_arrays) {
                    has_arrays = 1;
                    printf(".global _p24p_tmp 1\n");
                }

                if (field_type[fld_idx] == TYPE_ARRAY) {
                    /* p^.arrfield[i] := expr */
                    int fa_low;
                    int fa_elem_size;

                    expect(TOK_LBRACKET);
                    if (parse_error) return;

                    /* Compute array base address */
                    emit_load_sym(idx);
                    if (field_offset[fld_idx] > 0) {
                        printf("    push %d\n", field_offset[fld_idx] * 3);
                        printf("    add\n");
                    }
                    printf("    storeg _p24p_tmp\n");

                    parse_expression(); /* index */

                    fa_low = field_arr_low[fld_idx];
                    fa_elem_size = (field_arr_elem[fld_idx] == TYPE_CHAR) ? 1 : 3;

                    if (fa_low != 0) {
                        printf("    push %d\n", fa_low);
                        printf("    sub\n");
                    }
                    if (fa_elem_size > 1) {
                        printf("    push %d\n", fa_elem_size);
                        printf("    mul\n");
                    }
                    printf("    loadg _p24p_tmp\n");
                    printf("    add\n");

                    expect(TOK_RBRACKET);
                    if (parse_error) return;

                    /* Now element address is on stack, save it */
                    printf("    storeg _p24p_tmp\n");

                    expect(TOK_ASSIGN);
                    if (parse_error) return;

                    etype = parse_expression();

                    printf("    loadg _p24p_tmp\n");
                    if (field_arr_elem[fld_idx] == TYPE_CHAR) {
                        printf("    storeb\n");
                    } else {
                        printf("    store\n");
                    }
                } else {
                    /* p^.scalarfield := expr */
                    expect(TOK_ASSIGN);
                    if (parse_error) return;

                    emit_load_sym(idx);
                    if (field_offset[fld_idx] > 0) {
                        printf("    push %d\n", field_offset[fld_idx] * 3);
                        printf("    add\n");
                    }
                    printf("    storeg _p24p_tmp\n");

                    etype = parse_expression();

                    printf("    loadg _p24p_tmp\n");
                    printf("    store\n");
                }

            } else if (tok_type == TOK_ASSIGN) {
                /* p^ := expr */
                next_token();

                emit_load_sym(idx);  /* address */
                if (!has_arrays) {
                    has_arrays = 1;
                    printf(".global _p24p_tmp 1\n");
                }
                printf("    storeg _p24p_tmp\n");

                etype = parse_expression();

                printf("    loadg _p24p_tmp\n");
                printf("    store\n");
            } else {
                error("expected := or .field after ^");
            }

        } else if (tok_type == TOK_ASSIGN) {
            /* Assignment — could be variable or function return value */
            next_token();

            /* Check for function return assignment: FuncName := expr */
            if (in_proc && cur_func_local >= 0 && strcmp(name, cur_func_name) == 0) {
                etype = parse_expression();
                printf("    storel %d\n", cur_func_local);
                return;
            }

            idx = sym_lookup(name);
            if (idx < 0) {
                printf("error line %d: undeclared '%s'\n", tok_line, name);
                parse_error = 1;
                return;
            }
            if (sym_kind[idx] == SYM_CONST) {
                error("cannot assign to constant");
                return;
            }

            etype = parse_expression();

            if (!types_compatible(sym_type_id[idx], etype)) {
                error("type mismatch in assignment");
            }
            emit_store_sym(idx);

        } else {
            /* Procedure call */
            parse_proc_call(name);
        }

    } else if (tok_type == TOK_IF) {
        parse_if_stmt();
    } else if (tok_type == TOK_WHILE) {
        parse_while_stmt();
    } else if (tok_type == TOK_FOR) {
        parse_for_stmt();
    } else if (tok_type == TOK_REPEAT) {
        parse_repeat_stmt();
    } else if (tok_type == TOK_CASE) {
        parse_case_stmt();
    } else if (tok_type == TOK_READ) {
        parse_read_stmt();
    } else if (tok_type == TOK_READLN) {
        parse_readln_stmt();
    } else if (tok_type == TOK_WRITE) {
        parse_write_stmt();
    } else if (tok_type == TOK_WRITELN) {
        parse_writeln_stmt();
    } else if (tok_type == TOK_BEGIN) {
        parse_compound_stmt();
    } else if (tok_type == TOK_EXIT) {
        next_token();
        if (exit_label < 0) {
            error("exit outside procedure/function");
        } else {
            printf("    jmp L%d\n", exit_label);
        }
    }
    /* else: empty statement — valid per grammar */
}

/* --- Declaration parsing --- */

void parse_const_def(void) {
    char name[MAX_NAME];
    int value;
    int type;
    int negate;
    int idx;

    if (tok_type != TOK_IDENT) {
        error("expected identifier in const");
        return;
    }
    str_copy(name, tok_lexeme);
    next_token();

    expect(TOK_EQ);
    if (parse_error) return;

    negate = 0;
    if (tok_type == TOK_MINUS) {
        negate = 1;
        next_token();
    } else if (tok_type == TOK_PLUS) {
        next_token();
    }

    if (tok_type == TOK_INT_LIT) {
        value = tok_int_val;
        if (negate) value = 0 - value;
        type = TYPE_INTEGER;
        next_token();
    } else if (tok_type == TOK_TRUE) {
        value = 1;
        type = TYPE_BOOLEAN;
        next_token();
    } else if (tok_type == TOK_FALSE) {
        value = 0;
        type = TYPE_BOOLEAN;
        next_token();
    } else if (tok_type == TOK_IDENT) {
        idx = sym_lookup(tok_lexeme);
        if (idx < 0 || sym_kind[idx] != SYM_CONST) {
            error("expected constant value");
            next_token();
            expect(TOK_SEMI);
            return;
        }
        value = sym_value[idx];
        if (negate) value = 0 - value;
        type = sym_type_id[idx];
        next_token();
    } else {
        error("expected constant value");
        return;
    }

    sym_add(name, SYM_CONST, type, value);
    expect(TOK_SEMI);
}

void parse_const_section(void) {
    next_token(); /* consume CONST */
    parse_const_def();
    while (tok_type == TOK_IDENT && !parse_error) {
        parse_const_def();
    }
}

/* --- Type section parsing --- */

void parse_type_section(void) {
    char tname[MAX_NAME];
    char base_name[MAX_NAME];
    int tidx;
    int base_tidx;
    int fld_base;
    int fld_count;
    int fld_offset;
    int fld_type;
    int fld_utype;

    next_token(); /* consume TYPE */

    while (tok_type == TOK_IDENT && !parse_error) {
        str_copy(tname, tok_lexeme);
        next_token();

        expect(TOK_EQ);
        if (parse_error) return;

        if (tok_type == TOK_CARET) {
            /* Pointer type: ^BaseType */
            next_token();
            if (tok_type != TOK_IDENT) {
                error("expected type name after ^");
                return;
            }
            str_copy(base_name, tok_lexeme);
            next_token();

            tidx = utype_lookup(tname);
            if (tidx < 0) {
                tidx = utype_add(tname, TYPE_POINTER);
            } else {
                utype_kind[tidx] = TYPE_POINTER;
            }
            if (tidx < 0) return;
            utype_size[tidx] = 1;  /* pointer is 1 word */

            /* Resolve base type (may be forward reference) */
            base_tidx = utype_lookup(base_name);
            if (base_tidx < 0) {
                /* Forward reference — create placeholder */
                base_tidx = utype_add(base_name, TYPE_RECORD);
            }
            utype_base[tidx] = base_tidx;

        } else if (tok_type == TOK_RECORD) {
            /* Record type: record field1: type1; field2: type2; ... end */
            next_token();

            tidx = utype_lookup(tname);
            if (tidx < 0) {
                tidx = utype_add(tname, TYPE_RECORD);
            } else {
                utype_kind[tidx] = TYPE_RECORD;
            }
            if (tidx < 0) return;

            fld_base = field_count;
            fld_count = 0;
            fld_offset = 0;

            while (tok_type == TOK_IDENT && !parse_error) {
                /* Parse field names */
                int fld_first;
                int fi;
                fld_first = field_count;

                if (field_count >= MAX_FIELDS) {
                    error("too many record fields");
                    return;
                }
                str_copy(field_name_at(field_count), tok_lexeme);
                field_count = field_count + 1;
                fld_count = fld_count + 1;
                next_token();

                while (tok_type == TOK_COMMA) {
                    next_token();
                    if (tok_type != TOK_IDENT) {
                        error("expected field name");
                        return;
                    }
                    if (field_count >= MAX_FIELDS) {
                        error("too many record fields");
                        return;
                    }
                    str_copy(field_name_at(field_count), tok_lexeme);
                    field_count = field_count + 1;
                    fld_count = fld_count + 1;
                    next_token();
                }

                expect(TOK_COLON);
                if (parse_error) return;

                /* Field type — scalar or array */
                if (tok_type == TOK_ARRAY) {
                    /* array[low..high] of ElementType */
                    int fa_low;
                    int fa_high;
                    int fa_elem;
                    int fa_size;
                    int fa_words;

                    next_token();
                    expect(TOK_LBRACKET);
                    if (parse_error) return;

                    fa_low = 0;
                    if (tok_type == TOK_MINUS) {
                        next_token();
                        if (tok_type != TOK_INT_LIT) { error("expected integer"); return; }
                        fa_low = 0 - tok_int_val;
                        next_token();
                    } else if (tok_type == TOK_INT_LIT) {
                        fa_low = tok_int_val;
                        next_token();
                    } else {
                        error("expected lower bound");
                        return;
                    }

                    expect(TOK_DOTDOT);
                    if (parse_error) return;

                    fa_high = 0;
                    if (tok_type == TOK_MINUS) {
                        next_token();
                        if (tok_type != TOK_INT_LIT) { error("expected integer"); return; }
                        fa_high = 0 - tok_int_val;
                        next_token();
                    } else if (tok_type == TOK_INT_LIT) {
                        fa_high = tok_int_val;
                        next_token();
                    } else {
                        error("expected upper bound");
                        return;
                    }

                    expect(TOK_RBRACKET);
                    if (parse_error) return;
                    expect(TOK_OF);
                    if (parse_error) return;

                    if (tok_type == TOK_INTEGER_KW) {
                        fa_elem = TYPE_INTEGER;
                        next_token();
                    } else if (tok_type == TOK_BOOLEAN_KW) {
                        fa_elem = TYPE_BOOLEAN;
                        next_token();
                    } else if (tok_type == TOK_CHAR_KW) {
                        fa_elem = TYPE_CHAR;
                        next_token();
                    } else {
                        error("expected element type");
                        return;
                    }

                    fa_size = fa_high - fa_low + 1;
                    if (fa_size <= 0) {
                        error("array size must be positive");
                        return;
                    }

                    if (fa_elem == TYPE_CHAR) {
                        fa_words = (fa_size + 2) / 3;
                    } else {
                        fa_words = fa_size;
                    }

                    fi = fld_first;
                    while (fi < field_count) {
                        field_type[fi] = TYPE_ARRAY;
                        field_offset[fi] = fld_offset;
                        field_size[fi] = fa_words;
                        field_arr_low[fi] = fa_low;
                        field_arr_high[fi] = fa_high;
                        field_arr_elem[fi] = fa_elem;
                        field_arr_size[fi] = fa_size;
                        fld_offset = fld_offset + fa_words;
                        fi = fi + 1;
                    }
                } else {
                    fld_type = resolve_type_name(&fld_utype);
                    if (parse_error) return;

                    /* Fix up field types and offsets */
                    fi = fld_first;
                    while (fi < field_count) {
                        field_type[fi] = fld_type;
                        field_offset[fi] = fld_offset;
                        field_size[fi] = 1;
                        fld_offset = fld_offset + 1;
                        fi = fi + 1;
                    }
                }

                /* Semicolon between fields, optional before end */
                if (tok_type == TOK_SEMI) {
                    next_token();
                }
                if (tok_type == TOK_END) break;
            }

            if (tok_type != TOK_END) {
                error("expected 'end' after record fields");
                return;
            }
            next_token(); /* consume END */

            utype_base[tidx] = fld_base;
            utype_nfields[tidx] = fld_count;
            utype_size[tidx] = fld_offset;  /* total words */

        } else {
            error("expected ^ or record in type definition");
            return;
        }

        expect(TOK_SEMI);
        if (parse_error) return;
    }
}

void parse_var_decl(void) {
    int first;
    int type;
    int i;

    first = sym_count;

    /* First identifier */
    if (tok_type != TOK_IDENT) {
        error("expected identifier in var");
        return;
    }
    sym_add(tok_lexeme, SYM_VAR, TYPE_INTEGER, 0);
    next_token();

    /* More identifiers separated by commas */
    while (tok_type == TOK_COMMA) {
        next_token();
        if (tok_type != TOK_IDENT) {
            error("expected identifier after comma");
            return;
        }
        sym_add(tok_lexeme, SYM_VAR, TYPE_INTEGER, 0);
        next_token();
    }

    expect(TOK_COLON);
    if (parse_error) return;

    /* Type name — scalar or array */
    if (tok_type == TOK_ARRAY) {
        /* array[low..high] of BaseType */
        int arr_low;
        int arr_high;
        int elem_type;
        int arr_size;

        next_token();
        expect(TOK_LBRACKET);
        if (parse_error) return;

        /* Lower bound */
        arr_low = 0;
        if (tok_type == TOK_MINUS) {
            next_token();
            if (tok_type != TOK_INT_LIT) { error("expected integer"); return; }
            arr_low = 0 - tok_int_val;
            next_token();
        } else if (tok_type == TOK_INT_LIT) {
            arr_low = tok_int_val;
            next_token();
        } else {
            error("expected lower bound");
            return;
        }

        expect(TOK_DOTDOT);
        if (parse_error) return;

        /* Upper bound */
        arr_high = 0;
        if (tok_type == TOK_MINUS) {
            next_token();
            if (tok_type != TOK_INT_LIT) { error("expected integer"); return; }
            arr_high = 0 - tok_int_val;
            next_token();
        } else if (tok_type == TOK_INT_LIT) {
            arr_high = tok_int_val;
            next_token();
        } else {
            error("expected upper bound");
            return;
        }

        expect(TOK_RBRACKET);
        if (parse_error) return;
        expect(TOK_OF);
        if (parse_error) return;

        if (tok_type == TOK_INTEGER_KW) {
            elem_type = TYPE_INTEGER;
            next_token();
        } else if (tok_type == TOK_BOOLEAN_KW) {
            elem_type = TYPE_BOOLEAN;
            next_token();
        } else if (tok_type == TOK_CHAR_KW) {
            elem_type = TYPE_CHAR;
            next_token();
        } else {
            error("expected element type");
            return;
        }

        arr_size = arr_high - arr_low + 1;
        if (arr_size <= 0) {
            error("array size must be positive");
            return;
        }

        expect(TOK_SEMI);

        /* Emit scratch global for array store if first array */
        if (!has_arrays) {
            has_arrays = 1;
            printf(".global _p24p_tmp 1\n");
        }

        /* Fix up as array type */
        i = first;
        while (i < sym_count) {
            int alloc_words;
            sym_type_id[i] = TYPE_ARRAY;
            sym_arr_low[i] = arr_low;
            sym_arr_high[i] = arr_high;
            sym_arr_elem[i] = elem_type;
            sym_arr_size[i] = arr_size;
            /* Char arrays: 1 byte/elem, alloc ceil(size/3) words */
            if (elem_type == TYPE_CHAR) {
                alloc_words = (arr_size + 2) / 3;
            } else {
                alloc_words = arr_size;
            }
            printf(".global %s %d\n", sym_name_at(i), alloc_words);
            i = i + 1;
        }
    } else {
        /* Scalar or user-defined type */
        int utidx;
        utidx = -1;

        if (tok_type == TOK_INTEGER_KW) {
            type = TYPE_INTEGER;
            next_token();
        } else if (tok_type == TOK_BOOLEAN_KW) {
            type = TYPE_BOOLEAN;
            next_token();
        } else if (tok_type == TOK_CHAR_KW) {
            type = TYPE_CHAR;
            next_token();
        } else if (tok_type == TOK_IDENT) {
            utidx = utype_lookup(tok_lexeme);
            if (utidx >= 0) {
                type = utype_kind[utidx];
                next_token();
            } else {
                error("expected type name");
                return;
            }
        } else {
            error("expected type name");
            return;
        }

        expect(TOK_SEMI);

        /* Fix up types and emit .global directives */
        i = first;
        while (i < sym_count) {
            sym_type_id[i] = type;
            sym_ptr_base[i] = utidx;
            printf(".global %s 1\n", sym_name_at(i));
            i = i + 1;
        }
    }
}

void parse_var_section(void) {
    next_token(); /* consume VAR */
    parse_var_decl();
    while (tok_type == TOK_IDENT && !parse_error) {
        parse_var_decl();
    }
}

/* --- Procedure and function declarations --- */

int parse_param_list(int pidx) {
    /* Parse (name1: type1; name2, name3: type2; ...) */
    /* Returns number of parameters parsed */
    /* Adds params as SYM_PARAM to symbol table */
    /* loada indices are set after all params are known */
    int param_start;
    int param_count;
    int first;
    int type;
    int i;

    param_start = sym_count;
    param_count = 0;

    if (tok_type != TOK_LPAREN) return 0;
    next_token();

    if (tok_type == TOK_RPAREN) {
        next_token();
        return 0;
    }

    while (1) {
        first = sym_count;

        /* Parse one or more names */
        if (tok_type != TOK_IDENT) {
            error("expected parameter name");
            return param_count;
        }
        sym_add(tok_lexeme, SYM_PARAM, TYPE_INTEGER, 0);
        param_count = param_count + 1;
        next_token();

        while (tok_type == TOK_COMMA) {
            next_token();
            if (tok_type != TOK_IDENT) {
                error("expected parameter name after comma");
                return param_count;
            }
            sym_add(tok_lexeme, SYM_PARAM, TYPE_INTEGER, 0);
            param_count = param_count + 1;
            next_token();
        }

        expect(TOK_COLON);
        if (parse_error) return param_count;

        /* Type */
        {
            int utidx;
            type = resolve_type_name(&utidx);
            if (parse_error) return param_count;
        }

        /* Fix up types for this group */
        i = first;
        while (i < sym_count) {
            sym_type_id[i] = type;
            i = i + 1;
        }

        if (tok_type != TOK_SEMI) break;
        next_token();
    }

    expect(TOK_RPAREN);

    /* Set loada indices: loada 0 = last param, loada N-1 = first param */
    i = param_start;
    while (i < sym_count) {
        sym_value[i] = param_count - 1 - (i - param_start);
        i = i + 1;
    }

    return param_count;
}

int parse_local_vars(int local_offset) {
    /* Parse var section inside procedure/function body */
    /* Returns number of locals declared */
    /* Adds as SYM_LOCAL with value = local index starting at local_offset */
    int first;
    int type;
    int i;
    int count;

    count = 0;
    next_token(); /* consume VAR */

    while (tok_type == TOK_IDENT && !parse_error) {
        first = sym_count;

        /* Parse identifiers */
        sym_add(tok_lexeme, SYM_LOCAL, TYPE_INTEGER, 0);
        count = count + 1;
        next_token();

        while (tok_type == TOK_COMMA) {
            next_token();
            if (tok_type != TOK_IDENT) {
                error("expected identifier after comma");
                return count;
            }
            sym_add(tok_lexeme, SYM_LOCAL, TYPE_INTEGER, 0);
            count = count + 1;
            next_token();
        }

        expect(TOK_COLON);
        if (parse_error) return count;

        /* Type */
        {
            int utidx;
            type = resolve_type_name(&utidx);
            if (parse_error) return count;

            expect(TOK_SEMI);
            if (parse_error) return count;

            /* Fix up types, local indices, and pointer metadata */
            i = first;
            while (i < sym_count) {
                sym_type_id[i] = type;
                sym_value[i] = local_offset;
                sym_ptr_base[i] = utidx;
                local_offset = local_offset + 1;
                i = i + 1;
            }
        }
    }

    return count;
}

void parse_proc_or_func_decl(int is_func) {
    char name[MAX_NAME];
    char extern_name[MAX_NAME];
    int pidx;
    int param_count;
    int local_count;
    int local_offset;
    int ret_type;
    int saved_scope_base;
    int saved_scope_depth;
    int saved_in_proc;
    int saved_cur_proc_argc;
    int saved_cur_func_local;
    char saved_func_name[MAX_NAME];
    int total_locals;

    next_token(); /* consume PROCEDURE or FUNCTION */

    if (tok_type != TOK_IDENT) {
        error("expected procedure/function name");
        return;
    }
    str_copy(name, tok_lexeme);
    next_token();

    /* Build extern name: _user_<name> */
    str_copy(extern_name, "_user_");
    str_copy(&extern_name[6], name);

    /* Save scope state */
    saved_scope_base = scope_base;
    saved_scope_depth = scope_depth;
    saved_in_proc = in_proc;
    saved_cur_proc_argc = cur_proc_argc;
    saved_cur_func_local = cur_func_local;
    str_copy(saved_func_name, cur_func_name);

    scope_base = sym_count;
    scope_depth = scope_depth + 1;

    /* Parse parameters */
    param_count = parse_param_list(0);

    /* Parse return type for functions */
    ret_type = TYPE_INTEGER;
    if (is_func) {
        expect(TOK_COLON);
        if (parse_error) return;
        if (tok_type == TOK_INTEGER_KW) {
            ret_type = TYPE_INTEGER;
            next_token();
        } else if (tok_type == TOK_BOOLEAN_KW) {
            ret_type = TYPE_BOOLEAN;
            next_token();
        } else if (tok_type == TOK_CHAR_KW) {
            ret_type = TYPE_CHAR;
            next_token();
        } else if (tok_type == TOK_IDENT) {
            int rt_utidx;
            rt_utidx = utype_lookup(tok_lexeme);
            if (rt_utidx >= 0 && utype_kind[rt_utidx] == TYPE_POINTER) {
                ret_type = TYPE_POINTER;
                next_token();
            } else {
                error("expected return type");
                return;
            }
        } else {
            error("expected return type");
            return;
        }
    }

    expect(TOK_SEMI);
    if (parse_error) return;

    /* Check for forward declaration */
    if (tok_type == TOK_FORWARD) {
        next_token();
        expect(TOK_SEMI);
        /* Register in proc table as user proc */
        pidx = proc_add(name, extern_name, param_count, is_func, ret_type);
        if (pidx >= 0) {
            proc_is_user[pidx] = 1;
            proc_depth[pidx] = scope_depth;
        }
        /* Restore scope */
        sym_count = scope_base;
        scope_base = saved_scope_base;
        scope_depth = saved_scope_depth;
        return;
    }

    /* Register in proc table (or update if forward-declared) */
    pidx = proc_lookup(name);
    if (pidx >= 0) {
        /* Already forward-declared — update */
        proc_argc[pidx] = param_count;
        proc_depth[pidx] = scope_depth;
    } else {
        pidx = proc_add(name, extern_name, param_count, is_func, ret_type);
        if (pidx >= 0) {
            proc_is_user[pidx] = 1;
            proc_depth[pidx] = scope_depth;
        }
    }

    /* Set up scope for body */
    in_proc = 1;
    cur_proc_argc = param_count;

    /* Functions get a hidden local at index 0 for return value */
    if (is_func) {
        cur_func_local = 0;
        str_copy(cur_func_name, name);
        local_offset = 1;  /* user locals start at 1 */
    } else {
        cur_func_local = -1;
        cur_func_name[0] = 0;
        local_offset = 0;
    }

    /* Parse optional local var section */
    local_count = 0;
    if (tok_type == TOK_VAR) {
        local_count = parse_local_vars(local_offset);
    }

    total_locals = local_count + (is_func ? 1 : 0);
    if (pidx >= 0) {
        proc_nlocals[pidx] = total_locals;
    }

    /* Parse nested procedure/function declarations */
    while ((tok_type == TOK_PROCEDURE || tok_type == TOK_FUNCTION) && !parse_error) {
        if (tok_type == TOK_PROCEDURE) {
            parse_proc_or_func_decl(0);
        } else {
            parse_proc_or_func_decl(1);
        }
    }

    /* Emit .proc header (pa24r auto-generates enter from .proc N) */
    printf("\n.proc %s %d\n", extern_name, total_locals);

    /* Set up exit label for this procedure */
    {
        int saved_exit_label;
        int my_exit_label;
        saved_exit_label = exit_label;
        my_exit_label = label_count;
        label_count = label_count + 1;
        exit_label = my_exit_label;

        /* Parse body */
        parse_compound_stmt();
        expect(TOK_SEMI);  /* semicolon after procedure/function body */

        /* Emit exit label and return */
        printf("L%d:\n", my_exit_label);
        if (is_func) {
            printf("    loadl %d\n", cur_func_local);  /* push return value */
        }
        printf("    ret %d\n", param_count);
        printf(".end\n");

        exit_label = saved_exit_label;
    }
    if (parse_error) return;

    /* Restore scope */
    sym_count = scope_base;
    scope_base = saved_scope_base;
    scope_depth = saved_scope_depth;
    in_proc = saved_in_proc;
    cur_proc_argc = saved_cur_proc_argc;
    cur_func_local = saved_cur_func_local;
    str_copy(cur_func_name, saved_func_name);
}

/* --- Block and program --- */

void parse_block(void) {
    int has_procs;

    if (tok_type == TOK_CONST) parse_const_section();
    if (tok_type == TOK_TYPE) parse_type_section();
    if (tok_type == TOK_VAR) parse_var_section();

    has_procs = (tok_type == TOK_PROCEDURE || tok_type == TOK_FUNCTION);

    if (has_procs && !unit_mode) {
        /* PVM executes from offset 0, so emit main as trampoline first */
        printf("\n.proc main 0\n");
        printf("    call _p24p_main\n");
        printf("    halt\n");
        printf(".end\n");
    }

    /* Parse procedure and function declarations */
    while ((tok_type == TOK_PROCEDURE || tok_type == TOK_FUNCTION) && !parse_error) {
        if (tok_type == TOK_PROCEDURE) {
            parse_proc_or_func_decl(0);
        } else {
            parse_proc_or_func_decl(1);
        }
    }

    if (has_procs && !unit_mode) {
        printf("\n.proc _p24p_main 0\n");
    } else {
        printf("\n.proc main 0\n");
    }
    printf("    enter 0\n");
    emit_rt_call("_p24p_io_init");
    emit_rt_call("_p24p_heap_init");

    {
        int main_exit_label;
        main_exit_label = label_count;
        label_count = label_count + 1;
        exit_label = main_exit_label;

        parse_compound_stmt();

        printf("L%d:\n", main_exit_label);
        if (has_procs && !unit_mode) {
            printf("    ret 0\n");
        } else {
            printf("    halt\n");
        }
        printf(".end\n");
        exit_label = -1;
    }
}

/* --- Public API --- */

void emit_string_data(void) {
    int i;
    int j;
    char *s;

    i = 0;
    while (i < str_count) {
        s = str_data_at(i);
        printf(".data S%d ", i);
        j = 0;
        while (j < str_len[i]) {
            if (j > 0) printf(",");
            printf("%d", s[j]);
            j = j + 1;
        }
        printf(",0\n");
        i = i + 1;
    }
}

void parser_init(char *src, int len) {
    sym_count = 0;
    label_count = 0;
    exit_label = -1;
    parse_error = 0;
    str_count = 0;
    str_data_used = 0;
    proc_count = 0;
    utype_count = 0;
    field_count = 0;
    unit_hardware = 0;
    unit_mode = 0;
    has_arrays = 0;
    scope_base = 0;
    scope_depth = 0;
    in_proc = 0;
    cur_proc_argc = 0;
    cur_func_local = -1;
    cur_func_name[0] = 0;
    register_system_unit();
    lexer_init(src, len);
    next_token(); /* prime the first token */
}

void parse_uses_clause(void) {
    char unit_name[MAX_NAME];

    next_token(); /* consume USES */

    if (tok_type != TOK_IDENT) {
        error("expected unit name after uses");
        return;
    }

    while (1) {
        str_copy(unit_name, tok_lexeme);
        next_token();

        /* Lexer lowercases identifiers */
        if (strcmp(unit_name, "hardware") == 0) {
            unit_hardware = 1;
            register_hardware_unit();
        } else if (strcmp(unit_name, "units") == 0) {
            unit_mode = 1;
        } else {
            printf("error line %d: unknown unit '%s'\n", tok_line, unit_name);
            parse_error = 1;
            return;
        }

        if (tok_type != TOK_COMMA) break;
        next_token();
        if (tok_type != TOK_IDENT) {
            error("expected unit name after comma");
            return;
        }
    }

    expect(TOK_SEMI);
}

void emit_externs(void) {
    int i;
    /* Always emit the write/writeln/read externs (System builtins handled as keywords) */
    if (unit_mode) {
        printf(".extern _p24p_write_int 1\n");
        printf(".extern _p24p_write_bool 1\n");
        printf(".extern _p24p_write_str 1\n");
        printf(".extern _p24p_write_ln 0\n");
        printf(".extern _p24p_io_init 0\n");
        printf(".extern _p24p_read_int 0\n");
        printf(".extern _p24p_read_char 0\n");
        printf(".extern _p24p_read_ln 0\n");
        printf(".extern _p24p_heap_init 0\n");
        printf(".extern _p24p_new 1\n");
        printf(".extern _p24p_dispose 1\n");
    } else {
        printf(".extern _p24p_write_int\n");
        printf(".extern _p24p_write_bool\n");
        printf(".extern _p24p_write_str\n");
        printf(".extern _p24p_write_ln\n");
        printf(".extern _p24p_io_init\n");
        printf(".extern _p24p_read_int\n");
        printf(".extern _p24p_read_char\n");
        printf(".extern _p24p_read_ln\n");
        printf(".extern _p24p_heap_init\n");
        printf(".extern _p24p_new\n");
        printf(".extern _p24p_dispose\n");
    }
    /* Emit externs for non-user registered procedures */
    i = 0;
    while (i < proc_count) {
        if (!proc_is_user[i]) {
            if (unit_mode) {
                printf(".extern %s %d\n", proc_extern_at(i), proc_argc[i]);
            } else {
                printf(".extern %s\n", proc_extern_at(i));
            }
        }
        i = i + 1;
    }
}

void parse_program(void) {
    char prog_name[MAX_NAME];

    expect(TOK_PROGRAM);
    if (parse_error) return;

    str_copy(prog_name, tok_lexeme);
    expect(TOK_IDENT);
    if (parse_error) return;

    expect(TOK_SEMI);
    if (parse_error) return;

    /* Parse optional uses clause */
    if (tok_type == TOK_USES) {
        parse_uses_clause();
        if (parse_error) return;
    }

    if (unit_mode) {
        printf(".unit %s\n", prog_name);
        printf(".import p24p_rt\n");
    } else {
        printf(".module %s\n", prog_name);
    }
    emit_externs();
    printf(".export main\n");
    printf("; p24p output: %s\n", prog_name);

    parse_block();

    if (str_count > 0) {
        emit_string_data();
    }

    expect(TOK_DOT);

    if (unit_mode) {
        printf(".endunit\n");
    } else {
        printf(".endmodule\n");
    }

    if (parse_error) {
        printf("; compilation failed\n");
    }
}
