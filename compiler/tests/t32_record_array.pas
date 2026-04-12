program RecordArrayField;
{ Test: array fields inside record types }
type
  PToken = ^Token;
  Token = record
    kind: integer;
    text: array[0..3] of char;
    len: integer
  end;
var
  t: PToken;
begin
  new(t);
  t^.kind := 42;
  t^.text[0] := 'A';
  t^.text[1] := 'B';
  t^.text[2] := 'C';
  t^.text[3] := 'D';
  t^.len := 4;

  writeln(t^.kind);
  writechar(t^.text[0]);
  writechar(t^.text[1]);
  writechar(t^.text[2]);
  writechar(t^.text[3]);
  writeln(0);
  writeln(t^.len);
  dispose(t)
end.
