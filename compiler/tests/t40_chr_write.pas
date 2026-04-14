program TestChrWrite;
var c: char;
begin
  c := chr(65);
  write(c);
  write(chr(13));
  write(chr(10));
  c := chr(66);
  writeln(c)
end.
