unit uArrays;

interface

uses Classes, SysUtils;

type

 bool     = boolean;
 float    = single;
 int8     = shortint;
 uint8    = byte;
 int16    = smallint;
 uint16   = word;
 int32    = longint;
 uint32   = LongWord;

 AFloat   = array[0..0]of float;
 pAFloat  = ^AFloat;

 tFloatArray = class
  protected
   data : pAFloat;
   rows, cols   : int32;
   function  get_value(aRow,aCol : int32):float;
   procedure set_value(aRow,aCol : int32;value : float);
  public
   constructor Create(aRows, aCols : int32);
   function    T : tFloatArray;
   function    sigm():tFloatArray;
   procedure   random_val(sub_val : float);
   procedure   random_norm_val(c_val : uint32;sub_val : float);
   procedure   printf_row(aRow : int32);
   procedure   printf_array();
   property    value[aRow, aCol : int32]:float read get_value write set_value;default;
 end;

 function  dot_farrays(A,B : tFloatArray):tFloatArray;
 function  _transpose_farray(A : tFloatArray):tFloatArray;
 function  _sigm(x : float):float;

implementation

  uses math;

  constructor tFloatArray.Create(aRows, aCols : int32);
  begin
   inherited Create;
   Rows        := aRows;
   Cols        := aCols;
   GetMem(data,Rows*Cols*sizeof(float));
  end;

  function  tFloatArray.sigm():tFloatArray;
  var
   i : int32;
   R : tFloatArray;
  begin
   R := tFloatArray.Create(rows, cols);
   for i:=0 to rows * cols-1 do
    R.data[i] := _sigm(data[i]);
   Result := R; 
  end;

  function  tFloatArray.T : tFloatArray;
  begin
   Result := _transpose_farray(self);
  end;

  procedure tFloatArray.random_val(sub_val : float);
  var
   i : int32;
  begin
   randomize();
   for i:=0 to cols*rows-1 do
     data[i] := (RandomRange(0,100))/100 - sub_val;
  end;

  procedure tFloatArray.random_norm_val(c_val : uint32;sub_val : float);
  var
   i : int32;
  begin
   randomize();
   for i:=0 to cols*rows-1 do
     data[i] := RandG(0,power(c_val,-0.5));
  end;

  function  tFloatArray.get_value(aRow,aCol : int32):float;
  begin
   Result := data[aRow * Cols + aCol];
  end;

  procedure tFloatArray.set_value(aRow,aCol : int32;value : float);
  begin
   data[aRow*Cols + aCol] := value;
  end;

  procedure tFloatArray.printf_row(aRow : int32);
  var
   i : int32;
  begin
   for i:= 0 to Cols-1 do
    write(value[aRow,i]:6:2,', ');
   writeln;
  end;

  procedure tFloatArray.printf_array();
  var
   i : int32;
  begin
   for i:= 0 to Rows-1 do
    printf_row(i);
   writeln;
  end;

// FUNCTIONS  ****************************************************
 function  dot_farrays(A,B : tFloatArray):tFloatArray;
 var
  n,m,p,k,i,j : uint32;
  sum_v       : float;
 begin
  Result := nil;
  if(a.cols <> b.rows) then exit;
  n := A.rows;
  m := A.cols;
  p := B.cols;
  Result := tFloatArray.Create(n,p);
   for i :=0 to n-1 do
    for j:=0 to p-1 do begin
      sum_v := 0;
      for k:=0 to m-1 do
        sum_v := sum_v + A[i,k] * B[k,j];
      Result[i,j] := sum_v;
    end;
 end;

  function  _sigm(x : float):float;
  begin
   Result := 1 - 1/(1 + exp(-x));
  end;


  function  _transpose_farray(A : tFloatArray):tFloatArray;
  var
   R    : tFloatArray;
   i,j  : int32;
  begin
   R := tFloatArray.Create(A.cols, A.rows);
   for i:=0 to A.rows - 1 do
    for j:=0 to A.cols - 1 do
     R[j,i] := A[i,j];
   Result := R;
  end;
 

end.
