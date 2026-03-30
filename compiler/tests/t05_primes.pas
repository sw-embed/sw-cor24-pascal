program PrimeCheck;
var n, i: integer;
    isPrime: boolean;
begin
  n := 2;
  while n <= 20 do
  begin
    isPrime := true;
    i := 2;
    while i < n do
    begin
      if n mod i = 0 then
        isPrime := false;
      i := i + 1
    end;
    if isPrime then
      writeln(n);
    n := n + 1
  end
end.
