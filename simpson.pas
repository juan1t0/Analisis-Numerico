unit Simpson;
{$mode objfpc}

interface

uses
  Classes, SysUtils, Dialogs , ParseMath , math;

type
  ISimpson = class
    pt_a,
    pt_b,
    h: Real;
    Parsa : TParseMath;
    fun: String;
    Integral:Real;
    private
      public
      constructor create;
      destructor Destroy; override;
      function Ejecuta13():String;
      function Ejecuta38():String;
      function funcion(xx:Real):Real;
      function Area13():Real;
      function Area38():Real;
  end;

implementation

constructor ISimpson.create;
begin
  pt_a := 0.0;
  pt_b := 0.0;
  Parsa := TParseMath.create();
  Parsa.AddVariable('x',0.0);
end;

function ISimpson.funcion( xx:Real):Real;
begin
  Parsa.Expression:=fun;
  Parsa.NewValue('x',xx);
  Result:= Parsa.Evaluate();
end;
destructor ISimpson.Destroy;
begin
  Parsa.destroy;
end;

function ISimpson.Ejecuta13():String;
var
  F_a,F_b,xi,sum1,sum2,hh:Real;
begin
  F_a := funcion(pt_a);
  F_b := funcion(pt_b);
  xi:= pt_a;
  sum1:=0;
  sum2:=0;
  while ( xi < (pt_b-2*h) ) do begin
    xi := xi + 2*h;
    sum1:=sum1 + funcion(xi);
    xi := xi - h;
    sum2:=sum2 + funcion(xi);
    xi := xi+h;
  end;
  hh:=pt_b-xi;
  xi := xi + 2*hh;
  sum1:=sum1 + funcion(xi);
  xi := xi - hh;
  sum2:=sum2 + funcion(xi);
  xi := xi+hh;

  sum2:= sum2 + funcion(xi+hh);
  sum2:=sum2 * 4;
  sum1 := sum1 * 2;

  h:=h/3;
  Integral := h*(F_a + F_b + sum1+sum2);
  Ejecuta13 := FloatToStr(Integral);
end;
function ISimpson.Area13():Real;
var
  F_a,F_b,xi,sum1,sum2,hh:Real;
begin
  F_a := abs(funcion(pt_a));
  F_b := abs(funcion(pt_b));
  xi:= pt_a;
  sum1:=0;
  sum2:=0;
  while ( xi < (pt_b-2*h) ) do begin
    xi := xi + 2*h;
    sum1:=sum1 + abs(funcion(xi));
    xi := xi - h;
    sum2:=sum2 + abs(funcion(xi));
    xi := xi+h;
  end;
  hh:=pt_b-xi;
  xi := xi + 2*hh;
  sum1:=sum1 + abs(funcion(xi));
  xi := xi - hh;
  sum2:=sum2 + abs(funcion(xi));
  xi := xi+hh;

  sum2:= sum2 + abs(funcion(xi+hh));
  sum2:=sum2 * 4;
  sum1 := sum1 * 2;

  h:=h/3;
  Integral := h*(F_a + F_b + sum1+sum2);
  Area13 := abs(Integral);
end;

function ISimpson.Ejecuta38():String;
var
  d , F_a , F_b , xi , sum1 , sum2 , sum3 :Real;
  i ,n:Integer;
begin
  d:= pt_b - pt_a;
  n := 3*10000;
  h:= d/n;
  F_a := funcion(pt_a);
  F_b := funcion(pt_b);
  xi:= pt_a;
  sum1:=0;
  sum2:=0;
  sum3:=0;
  i:=1;
  while ( i < n-2 ) do begin
    xi := xi + 3*h;
    sum1:=sum1 + funcion(xi);
    i:=i+3;
  end;
  xi:= pt_a;
  i:=2;
  while ( i < n-1 ) do begin
    xi := xi + 3*h;
    sum2 := sum2 + funcion(xi);
    i:=i+3;
  end;
  xi:= pt_a;
  i:=3;
  while ( i < n-3 ) do begin
    xi := xi + 3*h;
    sum3 := sum3 + funcion(xi);
    i:=i+3;
  end;
  sum1:=sum1 * 3;
  sum2:=sum2 * 3;
  sum3:=sum3 *2;
  h:=(3*h)/8;
  Integral := h*(F_a + F_b + sum1+sum2+sum3);
  Ejecuta38 := FloatToStr(Integral);
end;
function ISimpson.Area38():Real;
var
  d , F_a , F_b , xi , sum1 , sum2 , sum3 :Real;
  i ,n:Integer;
begin
  d:= pt_b - pt_a;
  n := 3*10000;
  h:= d/n;
  F_a := abs(funcion(pt_a));
  F_b := abs(funcion(pt_b));
  xi:= pt_a;
  sum1:=0;
  sum2:=0;
  sum3:=0;
  i:=1;
  while ( i < n-2 ) do begin
    xi := xi + 3*h;
    sum1:=sum1 + abs(funcion(xi));
    i:=i+3;
  end;
  xi:= pt_a;
  i:=2;
  while ( i < n-1 ) do begin
    xi := xi + 3*h;
    sum2 := sum2 + abs(funcion(xi));
    i:=i+3;
  end;
  xi:= pt_a;
  i:=3;
  while ( i < n-3 ) do begin
    xi := xi + 3*h;
    sum3 := sum3 + abs(funcion(xi));
    i:=i+3;
  end;
  sum1:=sum1 * 3;
  sum2:=sum2 * 3;
  sum3:=sum3 *2;
  h:=(3*h)/8;
  Integral := h*(F_a + F_b + sum1+sum2+sum3);
  Area38 := abs(Integral);
end;

end.

