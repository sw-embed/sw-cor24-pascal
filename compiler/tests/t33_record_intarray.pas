program RecordIntArray;
{ Test: integer array fields inside record types }
type
  PVec = ^Vec;
  Vec = record
    len: integer;
    data: array[1..5] of integer;
    tag: integer
  end;
var
  v: PVec;
  i: integer;
  sum: integer;
begin
  new(v);
  v^.len := 5;
  v^.tag := 99;
  v^.data[1] := 10;
  v^.data[2] := 20;
  v^.data[3] := 30;
  v^.data[4] := 40;
  v^.data[5] := 50;

  sum := 0;
  i := 1;
  while i <= v^.len do begin
    sum := sum + v^.data[i];
    i := i + 1
  end;

  writeln(v^.len);
  writeln(sum);
  writeln(v^.tag);
  dispose(v)
end.
