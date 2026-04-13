unit StrUtils;

interface

procedure print_banner;
procedure print_separator;

implementation

procedure print_banner;
begin
  writeln(66); writeln(65); writeln(78); writeln(78); writeln(69); writeln(82)
end;

procedure print_separator;
begin
  writeln(45); writeln(45); writeln(45)
end;

end.
