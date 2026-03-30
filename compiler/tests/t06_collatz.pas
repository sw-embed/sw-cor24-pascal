program Collatz;
var n, steps: integer;
begin
  n := 27;
  steps := 0;
  writeln(n);
  while n <> 1 do
  begin
    if n mod 2 = 0 then
      n := n div 2
    else
      n := 3 * n + 1;
    steps := steps + 1;
    writeln(n)
  end;
  writeln(steps)
end.
