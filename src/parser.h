#pragma once

/* p24p Phase 0 Parser — recursive descent, emits .spc directly */

/* Type kinds */
#define TYPE_INTEGER 0
#define TYPE_BOOLEAN 1

/* Symbol kinds */
#define SYM_CONST 0
#define SYM_VAR   1

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

/* Label counter */
int label_count;

/* Error flag */
int parse_error;

/* Initialize parser with source buffer */
void parser_init(char *src, int len);

/* Parse a complete Pascal program, emitting .spc to stdout */
void parse_program(void);
