program FuncPointerReturn;
{ Test: functions returning pointer types }
type
  PNode = ^Node;
  Node = record
    val: integer;
    next: PNode
  end;
var
  a, b, tmp: PNode;

function make_node(v: integer): PNode;
var n: PNode;
begin
  new(n);
  n^.val := v;
  n^.next := nil;
  make_node := n
end;

begin
  a := make_node(10);
  b := make_node(20);
  b^.next := a;

  writeln(a^.val);
  writeln(b^.val);
  tmp := b^.next;
  writeln(tmp^.val);

  dispose(a);
  dispose(b)
end.
