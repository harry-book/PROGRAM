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

 AByte    = array[0..0]of byte;
 pAByte   = ^AByte;

 tFloatArray = class
  protected
   data : pAFloat;
   rows, cols   : int32;
   function  get_value(aRow,aCol : int32):float;
   procedure set_value(aRow,aCol : int32;value : float);
  public
   constructor Create(aRows, aCols : int32);
   function    T : tFloatArray;
   function    dot_array(A : tFloatArray):tFloatArray;
   function    sub_array(A : tFloatArray):tFloatArray;
   function    sigm():tFloatArray;
   procedure   random_val(sub_val : float);
   procedure   random_norm_val(c_val : uint32;sub_val : float);
   procedure   printf_row(aRow : int32);
   procedure   printf();
   property    value[aRow, aCol : int32]:float read get_value write set_value;default;
 end;

 tByteArray = class
  protected
   data : pAByte;
   rows, cols   : int32;
   function    get_value(aRow,aCol : int32):byte;
   procedure   set_value(aRow,aCol : int32;value : byte);
  public
   constructor Create(aRows, aCols : int32);
   constructor CreateFromBinFile(aRows,aCols : int32; fName : string);
   function    GetArray(start_row,start_col, end_row,end_col :int32):tByteArray;
   procedure   printf();
   property    value[aRow, aCol : int32]:byte read get_value write set_value;default;
   property    RowCount : int32 read rows;
   property    ColCount : int32 read cols;
 end;

 function  _dot_farrays(A,B : tFloatArray):tFloatArray;
 function  _sub_farrays(A,B : tFloatArray):tFloatArray;
 function  _transpose_farray(A : tFloatArray):tFloatArray;
 function  _sigm(x : float):float;

implementation

  uses math;

  // tByteArray --------------------------------------
  constructor tByteArray.Create(aRows, aCols : int32);
  begin
   inherited Create;
   Rows        := aRows;
   Cols        := aCols;
   GetMem(data,Rows*Cols*sizeof(byte));
  end;

  function   tByteArray.GetArray(start_row,start_col, end_row,end_col :int32):tByteArray;
  var
   i,j,iRow,iCol : int32;
   R   : tByteArray;
  begin
   if end_row = -1 then end_row := Rows-1;
   if end_col = -1 then end_col := Cols-1;
   R := tByteArray.Create(end_row - start_row + 1, end_col - start_col + 1);
   iRow := 0;
   for i := start_row to end_row do
    begin
    iCol := 0;
    for j := start_col to end_col do
     begin
      R[iRow,iCol] := value[i,j];
      inc(iCol);
     end;
     inc(iRow);
    end;
   Result := R;
  end;

  procedure tByteArray.printf();
  var
   i,j : int32;
  begin
   for i:= 0 to Rows-1 do
    begin
     for j:= 0 to Cols-1 do
      write(value[i,j],', ');
     writeln;
    end; 
  end;


  constructor tByteArray.CreateFromBinFile(aRows,aCols : int32; fName : string);
  var
   f    : tFileStream;
  begin
   inherited Create;
   f := tFileStream.Create(fName,fmOpenRead);
   if (f.Size <> aRows*aCols) then exit;
   Rows        := aRows;
   Cols        := aCols;
   GetMem(data,Rows*Cols);
   f.Read(data[0],Rows*Cols);
   f.Destroy();
  end;

  function  tByteArray.get_value(aRow,aCol : int32):byte;
  begin
   Result := data[aRow * Cols + aCol];
  end;

  procedure tByteArray.set_value(aRow,aCol : int32;value : byte);
  begin
   data[aRow*Cols + aCol] := value;
  end;
  // tFloatArray -------------------------------------
  constructor tFloatArray.Create(aRows, aCols : int32);
  begin
   inherited Create;
   Rows        := aRows;
   Cols        := aCols;
   GetMem(data,Rows*Cols*sizeof(float));
  end;

  function  tFLoatArray.dot_array(A : tFloatArray):tFloatArray;
  begin
   Result := _dot_farrays(self,A);
  end;

  function  tFLoatArray.sub_array(A : tFloatArray):tFloatArray;
  begin
   Result := _sub_farrays(self,A);
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

  procedure tFloatArray.printf();
  var
   i : int32;
  begin
   for i:= 0 to Rows-1 do
    printf_row(i);
   writeln;
  end;

// FUNCTIONS  ****************************************************
 function  _dot_farrays(A,B : tFloatArray):tFloatArray;
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

 function  _sub_farrays(A,B : tFloatArray):tFloatArray;
 var
  i  : uint32;
  R  : tFloatARray;
 begin
  Result := nil;
  if(a.cols <> b.rows)or(a.rows <> b.rows) then  exit;
  R := tFloatArray.Create(a.cols,a.rows);
  for i :=0 to a.cols * a.rows -1 do
   R.data[i] := A.data[i] - B.data[i];
  Result := R;
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
