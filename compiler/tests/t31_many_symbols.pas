program ManySymbols;
{ Test: program with >64 symbols to verify raised MAX_SYMBOLS }
const
  C01 = 1;  C02 = 2;  C03 = 3;  C04 = 4;  C05 = 5;
  C06 = 6;  C07 = 7;  C08 = 8;  C09 = 9;  C10 = 10;
  C11 = 11; C12 = 12; C13 = 13; C14 = 14; C15 = 15;
  C16 = 16; C17 = 17; C18 = 18; C19 = 19; C20 = 20;
  C21 = 21; C22 = 22; C23 = 23; C24 = 24; C25 = 25;
  C26 = 26; C27 = 27; C28 = 28; C29 = 29; C30 = 30;
  C31 = 31; C32 = 32; C33 = 33; C34 = 34; C35 = 35;
var
  V01, V02, V03, V04, V05: integer;
  V06, V07, V08, V09, V10: integer;
  V11, V12, V13, V14, V15: integer;
  V16, V17, V18, V19, V20: integer;
  V21, V22, V23, V24, V25: integer;
  V26, V27, V28, V29, V30: integer;
  V31, V32, V33, V34, V35: integer;
begin
  { 35 constants + 35 variables = 70 symbols, exceeds old limit of 64 }
  V01 := C01 + C35;
  writeln(V01)
end.
