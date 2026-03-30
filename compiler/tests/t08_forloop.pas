program ForLoop;
var i, sum: integer;
begin
  sum := 0;
  for i := 1 to 10 do
    sum := sum + i;
  writeln(sum);
  for i := 5 downto 1 do
    writeln(i)
end.
