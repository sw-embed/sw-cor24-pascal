program GCD;
var a, b, t: integer;
begin
  a := 48;
  b := 18;
  writeln('Computing GCD of 48 and 18');
  while b <> 0 do
  begin
    t := b;
    b := a mod b;
    a := t
  end;
  writeln(a)
end.
