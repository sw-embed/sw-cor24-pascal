program StringsMany;
{ Test: more than 16 string literals (issue #5) }
var i: integer;
begin
  writeln('Token types:');
  writeln('  0 = EOF');
  writeln('  1 = INT');
  writeln('  2 = IDENT');
  writeln('  3 = STRING');
  writeln('  4 = PLUS');
  writeln('  5 = MINUS');
  writeln('  6 = STAR');
  writeln('  7 = SLASH');
  writeln('  8 = LPAREN');
  writeln('  9 = RPAREN');
  writeln(' 10 = ASSIGN');
  writeln(' 11 = SEMI');
  writeln(' 12 = DOT');
  writeln(' 13 = COMMA');
  writeln(' 14 = COLON');
  writeln(' 15 = EQ');
  writeln(' 16 = NEQ');
  writeln(' 17 = LT');
  writeln(' 18 = GT');
  writeln(' 19 = LTE');
  writeln(' 20 = GTE');
  writeln('Done: 21 token types listed')
end.
