#pragma once

/* p24p Phase 0 Parser — recursive descent, emits .spc directly */

/* Type kinds */
#define TYPE_INTEGER 0
#define TYPE_BOOLEAN 1
#define TYPE_STRING  2
#define TYPE_ARRAY   3
#define TYPE_CHAR    4

/* Symbol kinds */
#define SYM_CONST 0
#define SYM_VAR   1
#define SYM_PARAM 2
#define SYM_LOCAL 3

/* Symbol table limits */
#define MAX_SYMBOLS 64
#define MAX_NAME 32
#define SYM_NAME_SIZE 2048

/* Symbol table — parallel arrays (avoids tc24r struct array bugs) */
char sym_name[SYM_NAME_SIZE];
int sym_kind[MAX_SYMBOLS];
int sym_type_id[MAX_SYMBOLS];
int sym_value[MAX_SYMBOLS];
int sym_count;

/* Array metadata (valid when sym_type_id == TYPE_ARRAY) */
int sym_arr_low[MAX_SYMBOLS];
int sym_arr_high[MAX_SYMBOLS];
int sym_arr_elem[MAX_SYMBOLS];   /* element type: TYPE_INTEGER or TYPE_BOOLEAN */
int sym_arr_size[MAX_SYMBOLS];   /* total words allocated */

/* Label counter */
int label_count;

/* String literal table (packed pool) */
#define MAX_STRINGS 128
#define MAX_STRING_BYTES 256
#define STR_DATA_SIZE 8192
char str_data[STR_DATA_SIZE];
int str_off[MAX_STRINGS];
int str_len[MAX_STRINGS];
int str_data_used;
int str_count;

/* External procedure table */
#define MAX_PROCS 32
#define PROC_NAME_SIZE 1024
char proc_pascal[PROC_NAME_SIZE];
char proc_extern[PROC_NAME_SIZE];
int proc_argc[MAX_PROCS];
int proc_has_ret[MAX_PROCS];
int proc_ret_type[MAX_PROCS];
int proc_count;

/* User procedure extensions to proc table */
int proc_is_user[MAX_PROCS];
int proc_nlocals[MAX_PROCS];
int proc_depth[MAX_PROCS];       /* nesting depth where proc was declared */

/* Symbol nesting depth (for nonlocal access) */
int sym_depth[MAX_SYMBOLS];      /* nesting depth when symbol was declared */

/* Scope management for procedure/function bodies */
int scope_base;
int scope_depth;                 /* current nesting depth (0=global, 1=first proc, ...) */
int in_proc;
int cur_proc_argc;
int cur_func_local;              /* -1 = procedure, 0 = function (return val at local 0) */
char cur_func_name[MAX_NAME];    /* function name for return-value assignment detection */

/* Array scratch global flag */
int has_arrays;

/* Unit flags */
int unit_hardware;
int unit_mode;       /* 1 = emit .unit/.xcall for multi-unit loading */

/* Error flag */
int parse_error;

/* Initialize parser with source buffer */
void parser_init(char *src, int len);

/* Parse a complete Pascal program, emitting .spc to stdout */
void parse_program(void);
