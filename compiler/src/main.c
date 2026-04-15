/* p24p — Pascal compiler for COR24 P-Code VM
   UART-input mode: reads Pascal source from stdin until EOT (0x04),
   then compiles and emits .spc to stdout. */

#include <stdio.h>
#include <string.h>
#include "parser.c"

#define INPUT_BUF_SIZE 131072

char input_buf[INPUT_BUF_SIZE];

int main() {
    int ch;
    int len;
    int src_offset;
    int truncated;

    len = 0;
    truncated = 0;
    while (1) {
        ch = getchar();
        if (ch == 4 || ch == -1) {
            break;
        }
        if (len >= INPUT_BUF_SIZE - 1) {
            truncated = 1;
            continue;
        }
        input_buf[len] = ch;
        len = len + 1;
    }
    input_buf[len] = 0;

    if (len == 0) {
        printf("; ERROR: no input\n");
        return 1;
    }

    if (truncated) {
        printf("; ERROR: source exceeds compiler input buffer (%d bytes)\n", INPUT_BUF_SIZE);
        return 1;
    }

    /* Find where SPI sections end and Pascal source begins */
    src_offset = load_spi_sections(input_buf, len);

    /* Initialize parser with the Pascal source (after SPI sections).
       Note: parser_init resets proc_count, so SPI procs are loaded after. */
    parser_init(&input_buf[src_offset], len - src_offset);

    /* Re-load SPI sections to register imported procs (after system unit) */
    if (src_offset > 0) {
        load_spi_sections(input_buf, src_offset);
    }

    if (tok_type == TOK_UNIT) {
        parse_unit();
    } else {
        parse_program();
    }

    if (parse_error) {
        printf("; COMPILE ERROR\n");
        return 1;
    }

    printf("; OK\n");
    return 0;
}
