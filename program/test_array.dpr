program test_array;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  uNeuroNet in 'uNeuroNet.pas',
  uArrays in 'uArrays.pas';

const
  data_path  = 'c:\APP_DELPHI\NEURO\bin_data\';
  file_name  = 'mnist_train_100.bin';
  SIZE_LINE  = 785;
  chr_width  = 28;
  chr_height = 28;
  chr_size   = 784;

var
 a,b,c,d   : tFloatArray;
 N         : tNeuroNet;
 inp,test  : tByteArray;
begin
{ a := tFloatArray.Create(2,3);
 a.random_norm_val(3,0.5);
 b := tFloatArray.Create(3,2);
 b.random_norm_val(3,0.5);}
{ c := a.dot_array(b);
 a.printf_array;
 b.printf_array;
 c.printf_array;
 }
 //a.T.printf_array;

 { a[0,0] := 1.2;   a[0,1] := -1.4;  a[0,2] := 0.8;
 a[1,0] := -0.7;  a[1,1] := 0.1;   a[1,2] := -0.35;}
// a.printf_array();


{ N := tNeuroNet.Create(3,3,3,0.3);
 N.Init();
 N.Train(a,b);}

  inp     := tByteArray.CreateFromBinFile(100,785,'.\\data\\mnist_train_100.bin');
  //writeln(inp.RowCount);
  test    := inp.GetArray(0,0,4,0);
  test.printf();

  readln;
end.
