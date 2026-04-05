program TestFunc;
var result: integer;

function Factorial(n: integer): integer;
var i, acc: integer;
begin
  acc := 1;
  i := 2;
  while i <= n do
  begin
    acc := acc * i;
    i := i + 1
  end;
  Factorial := acc
end;

function Max(a, b: integer): integer;
begin
  if a > b then
    Max := a
  else
    Max := b
end;

procedure PrintTwo(a, b: integer);
begin
  writeln(a);
  writeln(b)
end;

begin
  result := Factorial(6);
  writeln(result);
  writeln(Max(10, 25));
  writeln(Max(Factorial(4), 20));
  PrintTwo(Factorial(3), Factorial(5));
  writeln(Factorial(0))
end.
