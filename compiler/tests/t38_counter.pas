unit Counter;

interface

var count: integer;

procedure reset_count;
procedure increment;

implementation

procedure reset_count;
begin
  count := 0
end;

procedure increment;
begin
  count := count + 1
end;

end.
