program test_array;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  uNeuroNet in 'uNeuroNet.pas',
  uArrays in 'uArrays.pas';

var
 a,b,c,d : tFloatArray;
 N   : tNeuroNet;
begin
 a := tFloatArray.Create(2,3);
 a.random_norm_val(3,0.5);
 b := tFloatArray.Create(3,2);
 b.random_norm_val(3,0.5);
 c := a.dot_array(b);
 a.printf_array;
 b.printf_array;
 c.printf_array;
 //a.T.printf_array;

 { a[0,0] := 1.2;   a[0,1] := -1.4;  a[0,2] := 0.8;
 a[1,0] := -0.7;  a[1,1] := 0.1;   a[1,2] := -0.35;}
// a.printf_array();

{
 N := tNeuroNet.Create(3,3,3,0.3);
 N.Init();
 }


 readln;
end.
