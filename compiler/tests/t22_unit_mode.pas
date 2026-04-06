program TestUnitMode;
uses units;
var x: integer;

function double(n: integer): integer;
begin
  double := n * 2
end;

begin
  x := 21;
  writeln(double(x));
  if double(5) = 10 then
    writeln(1)
  else
    writeln(0)
end.
