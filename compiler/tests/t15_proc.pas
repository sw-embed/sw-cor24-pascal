program TestProc;
var x: integer;

procedure SetX(n: integer);
begin
  x := n
end;

function Double(n: integer): integer;
begin
  Double := n * 2
end;

begin
  SetX(21);
  writeln(Double(x))
end.
