unit PdeLagrange;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs, ParseMath;

type
  Lagrange = class
    Fution,mensaje : String;
    xn,
    yn : Real;
    Parsa : TParseMath;
    Xs ,
    Ys : Array of Real;
    lagrangeanos : TStringList;

    constructor create;
    destructor destroy;override;

    procedure CreatePolinomio();
    procedure CrearLagrangeanos();
  end;

implementation

constructor Lagrange.create;
begin
  Parsa := TParseMath.create;
  lagrangeanos := TStringList.Create;
end;
destructor Lagrange.destroy;
begin
  Parsa.destroy;
  lagrangeanos.destroy;
end;
procedure Lagrange.CrearLagrangeanos();
var
  temp,aux : string;
  L,x : Real;
  cant,i,j : Integer;
begin
  L:=1;
  cant := length(Xs);
  for i:=0 to cant -1 do begin
    for j:=0 to cant -1 do begin
      if (j<>i) then begin
        temp := temp + '(x - '+FloatToStr(Xs[j])+')*';
        L:=L*(Xs[i]-Xs[j]);
      end;
    end;
    aux:= '('+temp+'1)/'+ FloatToStr(L);
    lagrangeanos.Add(aux);
    L:=1;
    temp:='';
  end;
end;
procedure Lagrange.CreatePolinomio();
var
  poli:string;
  i,n:integer;
begin
  CrearLagrangeanos();
  n:= length(Xs);
  for i:= 0 to n-1 do begin
    poli:= poli + '('+floatToStr(Ys[i])+'*('+lagrangeanos[i]+'))+';
  end;
    poli:=poli+'0';
    mensaje:=poli;
    Fution:=poli;
end;
end.

