unit MathUtils;

interface

function add(a, b: integer): integer;
function multiply(a, b: integer): integer;

implementation

function add(a, b: integer): integer;
begin
  add := a + b
end;

function multiply(a, b: integer): integer;
begin
  multiply := a * b
end;

end.
