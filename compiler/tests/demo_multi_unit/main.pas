program MultiUnitDemo;
uses mathlib, strutils;
begin
  print_banner;
  print_separator;
  writeln(add(10, 20));
  writeln(multiply(6, 7));
  writeln(square(5));
  writeln(cube(3));
  print_separator
end.
