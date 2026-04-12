program ExitProc;
{ Test: exit from a procedure (should not print "after") }
procedure DoWork;
begin
  writeln(1);
  exit;
  writeln(2)
end;
begin
  DoWork;
  writeln(3)
end.
