program TestChar;
var
  ch: char;
  i: integer;
  buf: array[0..4] of char;
begin
  ch := 'A';
  i := ord(ch);
  writeln(i);
  ch := chr(66);
  write(ch);
  writeln;
  if ch >= 'A' then
    writeln(1)
  else
    writeln(0);
  buf[0] := 'H';
  buf[1] := 'i';
  buf[2] := '!';
  i := 0;
  while i < 3 do
  begin
    write(buf[i]);
    i := i + 1
  end;
  writeln
end.
