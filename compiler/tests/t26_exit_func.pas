program ExitFunc;
{ Test: exit from a function preserves return value }
function GetVal: integer;
begin
  GetVal := 42;
  exit;
  GetVal := 99
end;
begin
  writeln(GetVal)
end.
