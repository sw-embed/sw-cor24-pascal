// p24p compiler feasibility test for tc24r
// Tests features needed by a Pascal compiler:
//   - enums for token/node types
//   - structs for tokens, AST nodes, symbol table entries
//   - switch/case for lexer and parser dispatch
//   - malloc for AST node allocation
//   - arrays via helper functions (workaround for ptr[i].member bug)
//   - nested function calls
//   - pointer-heavy tree walking
//   - recursive evaluation

#include <stdio.h>
#include <stdlib.h>

// --- Token types (enum) ---
enum token_type {
    TOK_INT = 1,
    TOK_PLUS = 2,
    TOK_MINUS = 3,
    TOK_STAR = 4,
    TOK_LPAREN = 5,
    TOK_RPAREN = 6,
    TOK_EOF = 7,
    TOK_IDENT = 8,
    TOK_SEMI = 9
};

// --- AST node types ---
enum node_type {
    NODE_NUM = 1,
    NODE_ADD = 2,
    NODE_SUB = 3,
    NODE_MUL = 4
};

// --- AST node (binary tree) ---
struct node {
    int type;
    int value;
    struct node *left;
    struct node *right;
};

// --- Symbol table entry ---
struct symbol {
    int name_char;
    int value;
    int defined;
};

// --- Symbol table (heap-allocated) ---
struct symbol *symtab;
int sym_count;
int sym_cap;

// Workaround: helper for struct array indexing
struct symbol *sym_at(int i) {
    char *base = (char *)symtab;
    int offset = i * sizeof(struct symbol);
    return (struct symbol *)(base + offset);
}

// --- Allocate an AST node ---
struct node *make_node(int type, int val, struct node *l, struct node *r) {
    struct node *n;
    n = (struct node *)malloc(sizeof(struct node));
    n->type = type;
    n->value = val;
    n->left = l;
    n->right = r;
    return n;
}

struct node *make_num(int val) {
    return make_node(NODE_NUM, val, (struct node *)0, (struct node *)0);
}

struct node *make_binop(int type, struct node *l, struct node *r) {
    return make_node(type, 0, l, r);
}

// --- Evaluate AST ---
int eval(struct node *n) {
    int l;
    int r;
    if (n->type == NODE_NUM) {
        return n->value;
    }
    l = eval(n->left);
    r = eval(n->right);
    if (n->type == NODE_ADD) return l + r;
    if (n->type == NODE_SUB) return l - r;
    if (n->type == NODE_MUL) return l * r;
    return 0;
}

// --- Token type to string (switch/case test) ---
int tok_name(int t) {
    switch (t) {
        case TOK_INT: return 73;
        case TOK_PLUS: return 43;
        case TOK_MINUS: return 45;
        case TOK_STAR: return 42;
        case TOK_IDENT: return 65;
        default: return 63;
    }
}

// --- Symbol table operations ---
int sym_init(int cap) {
    symtab = (struct symbol *)malloc(cap * sizeof(struct symbol));
    sym_count = 0;
    sym_cap = cap;
    return 1;
}

int sym_define(int name_ch, int val) {
    struct symbol *s;
    if (sym_count >= sym_cap) return 0;
    s = sym_at(sym_count);
    s->name_char = name_ch;
    s->value = val;
    s->defined = 1;
    sym_count = sym_count + 1;
    return 1;
}

int sym_lookup(int name_ch) {
    int i;
    struct symbol *s;
    i = 0;
    while (i < sym_count) {
        s = sym_at(i);
        if (s->name_char == name_ch) {
            return s->value;
        }
        i = i + 1;
    }
    return -1;
}

int main() {
    int ok;
    int result;
    struct node *tree;
    struct node *left;
    struct node *right;

    ok = 1;

    // Test 1: AST construction and evaluation
    // Build tree for (3 + 4) * 5 = 35
    left = make_binop(NODE_ADD, make_num(3), make_num(4));
    right = make_num(5);
    tree = make_binop(NODE_MUL, left, right);
    result = eval(tree);
    if (result != 35) ok = 0;

    // Test 2: switch/case
    if (tok_name(TOK_PLUS) != 43) ok = 0;
    if (tok_name(TOK_INT) != 73) ok = 0;
    if (tok_name(99) != 63) ok = 0;

    // Test 3: symbol table (heap array of structs + lookup)
    sym_init(16);
    sym_define(120, 10);
    sym_define(121, 20);
    sym_define(122, 30);
    if (sym_lookup(121) != 20) ok = 0;
    if (sym_lookup(122) != 30) ok = 0;
    if (sym_lookup(119) != -1) ok = 0;

    // Test 4: nested struct access via pointers
    if (tree->left->type != NODE_ADD) ok = 0;
    if (tree->left->left->value != 3) ok = 0;

    if (ok) {
        printf("P24P-OK\n");
        return 35;
    }
    printf("P24P-FAIL\n");
    return 0;
}
