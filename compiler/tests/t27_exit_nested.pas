program ExitNested;
{ Test: exit from nested if/begin exits the whole procedure }
procedure Check(x: integer);
begin
  if x > 0 then begin
    writeln(x);
    if x > 10 then begin
      exit
    end
  end;
  writeln(0)
end;
begin
  Check(5);
  Check(20);
  Check(3)
end.
