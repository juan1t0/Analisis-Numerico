unit trapezoide;

{$mode objfpc}

interface

uses
  Classes, SysUtils, Dialogs , ParseMath , math;

type
  ITrapecio = class
    pt_a,
    pt_b,
    h: Real;
    Parsa : TParseMath;
    fun: String;
    n: Integer;
    Integral:Real;
    private
      public
      constructor create;
      destructor Destroy; override;
      function Ejecuta():String;
      function funcion(xx:Real):Real;
      function Area():Real;
  end;

implementation

constructor ITrapecio.create;
begin
  pt_a := 0.0;
  pt_b := 0.0;
  Parsa := TParseMath.create();
  Parsa.AddVariable('x',0.0);
  n:=0;
end;

function ITrapecio.funcion( xx:Real):Real;
begin
  Parsa.Expression:=fun;
  Parsa.NewValue('x',xx);
  Result:= Parsa.Evaluate();
end;
destructor ITrapecio.Destroy;
begin
  Parsa.destroy;
end;

function ITrapecio.Ejecuta():String;
var
  F_a,F_b,xi,sum:Real;
begin
  F_a := funcion(pt_a);
  F_b := funcion(pt_b);
  xi:= pt_a+h;
  sum:=0;
  while ( xi < pt_b ) do begin
    sum:=sum + funcion(xi);
    xi := xi + h;
   end;
  sum:=sum + funcion(xi);

  sum:=sum * 2;
  h:=h/2;
  Integral := h*(F_a + F_b + sum);
  Ejecuta := FloatToStr(Integral);
end;
function ITrapecio.Area():Real;
var
  F_a,F_b,xi,sum:Real;
begin
  F_a := funcion(pt_a);
  F_b := funcion(pt_b);
  xi:= pt_a+h;
  sum:=0;
  while ( xi < pt_b ) do begin
    sum:=sum + abs(funcion(xi));
    xi := xi + h;
   end;
  sum:=sum + abs(funcion(xi));

  sum:=sum * 2;
  h:=h/2;
  Integral := h*(F_a + F_b + sum);
  Area := Integral;
end;

end.

