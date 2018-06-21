unit matris;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs,math;

type
  matriz = Array of array of Real;
  CMatriz = class
   // Mr : matriz;
    Message : String;
    Operacion: Integer;
//    i,j:Integer;
      function Suma(A , B : matriz):matriz;
      function Resta(A , B : matriz):matriz;
      function Multiplicacion(A , B : matriz):matriz;
      function Determinante(A : matriz):Real;
      function Transponer(A : matriz):matriz;
      function Adjunta(A : matriz):matriz;
      function Inversa(A : matriz):matriz;
//      function Inversa(A : matriz):string;
      function Triangular(A : matriz):matriz;
      function Traza(A : matriz):matriz;
    public
      constructor create;
      destructor Destroy; override;
//      function Ejecuta(A ,B: matris):String;
      function funcion():Real;
  end;


implementation
constructor CMatriz.create;
begin
  Operacion:= 0;
end;
destructor CMatriz.Destroy;
begin
end;
function CMatriz.funcion():Real;
begin
  funcion:= 2;
end;

function CMatriz.Suma(A , B : matriz):matriz;
var aa,bb:Integer;
  Mr : matriz;
begin
  SetLength(Mr,Length(A),Length(A[0]));
  for aa:=0 to Length(Mr)-1 do begin
    for bb:=0 to Length(Mr[0])-1 do begin
      Mr[aa,bb]:=A[aa,bb]+B[aa,bb];
    end;
  end;
  Suma:=Mr;
end;
function CMatriz.Resta(A , B : matriz):matriz;
var aa,bb:Integer ;
  Mr : matriz;
begin
  setLength(Mr,Length(A),Length(A[0]));
  for aa:=0 to Length(Mr)-1 do begin
    for bb:=0 to Length(Mr[0])-1 do begin
      Mr[aa,bb]:=A[aa,bb]-B[aa,bb];
    end;
  end;
  Resta:=Mr;
end;
function CMatriz.Multiplicacion(A , B : matriz):matriz;
var
  k,aa,bb:Integer;
  aux:Real;
  Mr : matriz;
begin
  SetLength(Mr,Length(A),Length(B[0]));
  for aa:=0 to Length(Mr)-1 do begin
    for bb:=0 to Length(Mr[0])-1 do begin
      aux:=0;
      for k:=0 to Length(B)-1 do begin
        aux:= aux +(A[aa,k] * B[k,bb]);
      end;
      Mr[aa,bb]:=aux;
    end;
  end;
  Multiplicacion:=Mr;
end;
{function CMatriz.Determinante(A : matriz):Real;
var
  R,aux,temp:Real;
  k,aa,bb,i,j:Integer;
begin
  aa:= Length(A)-1;
  bb:= Length(A[0])-1;
  aux:=0;
  temp:=0;
  if aa<>bb then
  begin
    Determinante:=0;
  end
  else begin
    for k:=0 to aa do begin
      R:=1;
      for i:=0 to aa do begin
        j:=i+k;
        if j > aa then
          j:=0;
        R := R * A[i,j];
      end;
      temp:=temp + R;
    end;

    for k:=0 to aa do begin
      R:=1;
      for i:=0 to aa do begin
        j:= bb- k;
        if j < 0 then
          j:=aa;
        R := R * A[i,j];
        bb:=bb-1;
      end;
      bb:=aa;
      aux:=aux +R ;
    end;
    Determinante:= temp-aux;
  end;
end;}
function CMatriz.Transponer(A : matriz):matriz;
var
  i,j:Integer;
  Mr : matriz;
begin
  SetLength(Mr,Length(A[0]),Length(A));
  for i:=0 to Length(A)-1 do begin
    for j:=0 to Length(A[0])-1 do begin
      Mr[j,i]:=A[i,j];
    end;
  end;
  Transponer:= Mr;
end;
function Sub(A : matriz;n,m:Integer):matriz;
var
  i,j,x,y:Integer;
  mm : matriz;
begin
  SetLength(mm,Length(A)-1,Length(A[0])-1);
  x:=0;
  for i:=0 to (Length(A)-1) do begin
    y:=0;
    if i = n then
      Continue;
    for j:=0 to (Length(A[0])-1) do begin
      if j=m then
        Continue;
      mm[x,y]:=A[i,j];
      y:=y+1
    end;
    x:= x+1;
  end;
  Sub:=mm;
end;
function CMatriz.Determinante (A : matriz):Real;
var
  i:Integer;
  Re,rrr:Real;
  m:matriz;
begin
  if(Length(A) = 1) then begin
    Determinante := A[0,0];
  end
  else begin
    Re:= 1;
    rrr:=0;
    setlength(m,Length(A)-1,Length(A)-1);
    for i:= 0 to (Length(A)-1) do begin
      m:=Sub(A,0,i);
      Re:=A[0,i]*Determinante(m);
      if(i mod 2 <> 0)then
        Re:= Re * (-1);
      rrr := rrr + Re;
    end;
    Message:=IntToStr(i);
    Determinante:=rrr;
  end;
end;
function PorEscalar(A : matriz; x:Real):matriz;
var
  i,j:Integer;
  m : matriz;
begin
  SetLength(m,Length(A),Length(A[0]));
  for i:=0 to Length(A)-1 do begin
    for j:=0 to Length(A[0])-1 do begin
      m[i,j]:= x*A[i,j];
    end;
  end;
  PorEscalar:= m;
end;

function CMatriz.Adjunta(A : matriz):matriz;
var
  i,j:Integer;
  m : matriz;
  d:Real;
begin
  SetLength(m,Length(A),Length(A[0]));
  for i:=0 to Length(A)-1 do begin
    for j:=0 to Length(A[0])-1 do begin
      d:=Determinante(Sub(A,i,j));
      if abs(i-j)mod 2 = 1 then
        d:=d*(-1);
      m[i,j]:= d;
    end;
  end;
  Result:= m;
end;
function CMatriz.Inversa(A : matriz):matriz;
var
  Mr : matriz;
  d : Real;
begin
  d:= Determinante(A);
 // Message:= FloatToStr(d);
  //Inversa:= FloatToStr(d);
  SetLength(Mr,Length(A),Length(A));
  if d = 0 then begin
    Inversa:=Mr;
  end;
  if(Length(A) = 2) then begin
    Mr[0,0]:= A[1,1]*1/d;
    Mr[0,1]:= A[0,1]*-1/d;
    Mr[1,0]:= A[1,0]*-1/d;
    Mr[1,1]:= A[0,0]*1/d;
  end;
  if(length(A)<>length(A[0])) then begin
    Inversa:=Mr;
  end
//  SetLength(Mr,Length(A),Length(A));
  else begin
    Mr:=Transponer(A);
    Mr:=Adjunta(Mr);
    d:= 1/d;
    Mr:=PorEscalar(Mr,d);
    Result:=Mr;
  end;
end;
function CMatriz.Triangular(A : matriz):matriz;
begin

end;
function CMatriz.Traza(A : matriz):matriz;
begin

end;

end.

