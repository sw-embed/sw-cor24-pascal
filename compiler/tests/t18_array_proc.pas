program TestArrayProc;
var
  data: array[1..10] of integer;
  i: integer;

procedure FillArray(n: integer);
var k: integer;
begin
  k := 1;
  while k <= n do
  begin
    data[k] := k * k;
    k := k + 1
  end
end;

function SumArray(n: integer): integer;
var k, s: integer;
begin
  s := 0;
  k := 1;
  while k <= n do
  begin
    s := s + data[k];
    k := k + 1
  end;
  SumArray := s
end;

begin
  FillArray(5);
  writeln(data[1]);
  writeln(data[3]);
  writeln(data[5]);
  writeln(SumArray(5))
end.
