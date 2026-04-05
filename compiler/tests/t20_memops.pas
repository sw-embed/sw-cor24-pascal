program TestMemops;
var
  buf: array[0..7] of char;
  i: integer;
begin
  buf[0] := 'H';
  buf[1] := 'i';
  buf[2] := '!';
  i := 0;
  while i < 3 do
  begin
    write(buf[i]);
    i := i + 1
  end;
  writeln;
  writeln(ord(buf[0]));
  writeln(ord(buf[1]));
  writeln(ord(buf[2]))
end.
