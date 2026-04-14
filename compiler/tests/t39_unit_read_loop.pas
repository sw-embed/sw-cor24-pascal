program TestReadLoopUnit;
uses units;
var ch: char;
    count: integer;
begin
  count := 0;
  while not eof do
  begin
    read(ch);
    count := count + 1
  end;
  writeln(count)
end.
