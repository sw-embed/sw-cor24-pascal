program ExitMain;
{ Test: exit in main program halts }
begin
  writeln(1);
  writeln(2);
  exit;
  writeln(3)
end.
