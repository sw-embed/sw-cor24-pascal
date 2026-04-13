#pragma once

/* p24p Phase 0 Parser — recursive descent, emits .spc directly */

/* Type kinds */
#define TYPE_INTEGER 0
#define TYPE_BOOLEAN 1
#define TYPE_STRING  2
#define TYPE_ARRAY   3
#define TYPE_CHAR    4
#define TYPE_POINTER 5
#define TYPE_RECORD  6
#define TYPE_NIL     7

/* Symbol kinds */
#define SYM_CONST 0
#define SYM_VAR   1
#define SYM_PARAM 2
#define SYM_LOCAL 3

/* Symbol table limits */
#define MAX_SYMBOLS 256
#define MAX_NAME 32
#define SYM_NAME_SIZE 8192

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

/* Exit label for current procedure/function/main (-1 if none) */
int exit_label;

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
#define MAX_PROCS 128
#define PROC_NAME_SIZE 4096
char proc_pascal[PROC_NAME_SIZE];
char proc_extern[PROC_NAME_SIZE];
int proc_argc[MAX_PROCS];
int proc_has_ret[MAX_PROCS];
int proc_ret_type[MAX_PROCS];
int proc_count;

/* User procedure extensions to proc table */
int proc_is_user[MAX_PROCS];
int proc_is_exported[MAX_PROCS]; /* 1 = declared in unit interface section */
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

/* User-defined type table (records and pointer types) */
#define MAX_TYPES 32
#define TYPE_NAME_SIZE 1024
char utype_name[TYPE_NAME_SIZE];  /* packed names */
int utype_kind[MAX_TYPES];        /* TYPE_RECORD or TYPE_POINTER */
int utype_size[MAX_TYPES];        /* size in words (records) */
int utype_base[MAX_TYPES];        /* pointer: base type id; record: first field index */
int utype_nfields[MAX_TYPES];     /* record: number of fields */
int utype_count;

/* Record field table */
#define MAX_FIELDS 128
#define FIELD_NAME_SIZE 2048
char field_name[FIELD_NAME_SIZE]; /* packed names */
int field_type[MAX_FIELDS];       /* field type id */
int field_offset[MAX_FIELDS];     /* offset in words from record base */
int field_size[MAX_FIELDS];       /* size in words (1 for scalars, N for arrays) */
int field_count;

/* Array metadata for record fields (valid when field_type == TYPE_ARRAY) */
int field_arr_low[MAX_FIELDS];
int field_arr_high[MAX_FIELDS];
int field_arr_elem[MAX_FIELDS];   /* element type: TYPE_INTEGER, TYPE_BOOLEAN, TYPE_CHAR */
int field_arr_size[MAX_FIELDS];   /* element count (high - low + 1) */

/* Pointer metadata for symbols */
int sym_ptr_base[MAX_SYMBOLS];    /* for pointer vars: user type index of pointed-to type */

/* Array scratch global flag */
int has_arrays;

/* Unit flags */
int unit_hardware;
int unit_mode;       /* 1 = emit .unit/.xcall for multi-unit loading */
int is_unit_compilation; /* 1 = compiling a 'unit', 0 = compiling a 'program' */
int in_interface;        /* 1 = parsing interface section (proc headers are implicit forward) */
char unit_name[MAX_NAME]; /* name of the unit being compiled */

/* Error flag */
int parse_error;

/* Initialize parser with source buffer */
void parser_init(char *src, int len);

/* Parse a complete Pascal program, emitting .spc to stdout */
void parse_program(void);

/* Parse a Pascal unit, emitting .spc to stdout */
void parse_unit(void);
