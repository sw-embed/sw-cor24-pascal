program TestArray;
var
  a: array[0..4] of integer;
  i, sum: integer;
begin
  i := 0;
  while i < 5 do
  begin
    a[i] := i * 10;
    i := i + 1
  end;
  sum := 0;
  i := 0;
  while i < 5 do
  begin
    sum := sum + a[i];
    i := i + 1
  end;
  writeln(sum)
end.
