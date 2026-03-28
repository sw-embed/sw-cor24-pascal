program Fibonacci;
var f1, f2, f3, i: integer;
begin
  f1 := 0;
  f2 := 1;
  writeln(f1);
  writeln(f2);
  i := 3;
  while i <= 10 do
  begin
    f3 := f1 + f2;
    writeln(f3);
    f1 := f2;
    f2 := f3;
    i := i + 1
  end
end.
