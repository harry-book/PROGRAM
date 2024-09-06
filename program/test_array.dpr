program test_array;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  uNeuroNet in 'uNeuroNet.pas',
  uArrays in 'uArrays.pas';

const
  data_path   = '.\data\';
  file_train  = 'mnist_train_100.csv';
  file_test   = 'mnist_test_10.csv';
  rec_size    = 785;
  chr_size    = 28;

var
 A,B,C     : tFloatArray;
 N         : tNeuroNet;
 inp       : tByteArray;
begin
  inp := _load_csv(data_path + file_test).GetArray(0,0,-1,0);
//  A   := inp.GetFloatArray(0,1,-1,-1);
//  C   := inp.GetFloatArray(0,0,-1,0);
  //B   := _scale_farray(A);
  // B.printf_row(0);
  inp.printf();
//  A.printf;
  readln;
end.
