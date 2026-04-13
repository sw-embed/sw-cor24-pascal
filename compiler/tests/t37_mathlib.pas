unit MathLib;

interface

function add(a, b: integer): integer;
function multiply(a, b: integer): integer;
function square(n: integer): integer;

implementation

function add(a, b: integer): integer;
begin
  add := a + b
end;

function multiply(a, b: integer): integer;
begin
  multiply := a * b
end;

function square(n: integer): integer;
begin
  square := n * n
end;

end.
