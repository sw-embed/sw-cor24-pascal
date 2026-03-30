/* p24p parser test — parses the Countdown program and prints .spc output */

#include <stdio.h>
#include <string.h>
#include "parser.c"

int main() {
    char *src = "program Countdown;\nconst\n  start = 10;\nvar\n  n: integer;\n  done: boolean;\nbegin\n  n := start;\n  done := false;\n  while not done do\n  begin\n    writeln(n);\n    n := n - 1;\n    if n = 0 then\n      done := true\n  end;\n  writeln(n)\nend.\n";

    int len;
    len = strlen(src);

    printf("=== p24p parser test ===\n");
    parser_init(src, len);
    parse_program();

    if (parse_error) {
        printf("=== FAILED ===\n");
    } else {
        printf("=== PASSED ===\n");
    }

    return 0;
}
