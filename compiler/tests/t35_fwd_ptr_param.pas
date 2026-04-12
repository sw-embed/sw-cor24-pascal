program TestFwdPtrParam;
{ Test: forward-declared functions with pointer-type parameters
  can access fields via ^.field (issue #13) }
type
  PNode = ^Node;
  Node = record value: integer; next: PNode end;
var
  n: PNode;
  result: integer;

function getval(p: PNode): integer; forward;

function getval(p: PNode): integer;
begin
  getval := p^.value
end;

begin
  new(n);
  n^.value := 42;
  n^.next := nil;
  result := getval(n);
  writeln(result)
end.
