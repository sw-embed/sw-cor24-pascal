program ReadChar;
{ Test: read(ch) reads a single character, not an integer }
var ch: char;
begin
  read(ch);
  writeln(ord(ch));
  read(ch);
  writeln(ord(ch));
  read(ch);
  writeln(ord(ch))
end.
