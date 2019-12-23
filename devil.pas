unit devil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs,ParseMath;

type
  Ddevil = class
    ErrorAllowed,
    x0,
    xf: Real;
    Parsa : TParseMath;
    fun,derv: String;
    Met: Integer;
    solu:Boolean;
    private
      Error:Real;
      function Biseccion():String;
      function FalsaPos():String;
      function NewRaph():String;
      function Secante():String;
      public
      constructor create;
      destructor Destroy; override;
      function Ejecuta():String;
      function funcion(xx:Real):Real;
      function derivada(xx:Real):Real;
      function Defaul():String;
  end;

const
  IsBisecc = 0;
  IsFalsaP = 1;
  IsNewRaph = 2;
  IsSecante = 3;
implementation
const
  Top = 100000;
constructor Ddevil.create;
begin
  Parsa := TParseMath.create();
  Parsa.AddVariable('x',0.0);
  Error:= Top;
end;

function Ddevil.funcion( xx:Real):Real;
begin
  Parsa.Expression:=fun;
  Parsa.NewValue('x',xx);
  Result:= Parsa.Evaluate();
end;                        
function Ddevil.derivada( xx:Real):Real;
begin
  Parsa.Expression:=derv;
  Parsa.NewValue('x',xx);
  Result:= Parsa.Evaluate();
end;
destructor Ddevil.Destroy;
begin
  Parsa.destroy;
end;
function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;
end;
var
  fa,fb:Real;
function Ddevil.Ejecuta():String;
  begin
     if Met < 2 then
     begin
       fa:= funcion(x0);
       fb:= funcion(xf);
       if (fa * fb )<= 0 then
       begin
         case Met of
           0: Result:= Biseccion();
           1: Result:= FalsaPos();
         end;
       end
       else begin
         solu:=False;
       end;
     end
     else begin
       case Met of
           2: Result:= NewRaph();
           3: Result:= Secante();
       end;
     end;
end;
function Ddevil.Defaul():String;
var fxn,h,xn,aux,eerroo,fxh,fhx: Real;
    n: Integer;
begin
   xn:=0;
   solu:=true;
   if(funcion(x0)*funcion(xf)) >= 0 then
   begin
     n:=0;
     repeat
       aux:= xn;
       xn := (x0+xf)/2;
       eerroo:= Error;
       fa:= funcion(x0);
       fxn:= funcion(xn);
       if (fa * fxn) < 0.0 then
         xf:=xn;
       if (fa * fxn) >= 0.0 then
         x0:=xn;
       if n > 0 then
       begin
          Error := abs(xn - aux);
          if (n > 1) then
          begin
            if Error = eerroo then
                Break;
            if Error > eerroo then
                Break;
          end;
       end;
       n:=n+1;
     until (Error < 0.001) or (n>=Top) or (fxn=0);
   end;
   n :=1;
   repeat
     aux:= xn;
     fxn:= funcion(xn);
     h:= ErrorAllowed/10;
     fxh:=funcion(xn+h);
     fhx:=funcion(xn-h);
     xn := xn - (((2*h)*fxn )/(fxh-fhx));
     eerroo:=Error;
     Error := abs(xn - aux);
     if n > 1 then
     begin
       if Error = eerroo then
       begin
         solu:=false;
         Break;
       end;
       if Error > eerroo then
       begin
         solu:=false;
         Break;
       end;
     end;
     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   if solu then
      Result:=FloatToStr(xn);
end;

function Ddevil.Biseccion(): String;
var fxn,xn,aux,eerroo: Real;
    n: Integer;
begin
   xn:=0;
   n:=0;
   solu:=True;
   repeat
     aux:= xn;
     xn := (x0+xf)/2;
     eerroo:= Error;
     fa:= funcion(x0);
     fxn:= funcion(xn);
     if (fa * fxn) < 0.0 then
       xf:=xn;
     if (fa * fxn) >= 0.0 then
       x0:=xn;
     if n > 0 then
     begin
        Error := abs(xn - aux);
        if (n > 1) then
        begin
          if Error = eerroo then
            begin
              solu:= False;
              Break;
            end;
          if Error > eerroo then
            begin
              solu:= False;
              Break;
            end;
        end;
     end;
     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   if solu then
      Result:=FloatToStr(xn);
end;

function Ddevil.NewRaph(): String;
var fxn,xn,dfxn,aux,eerroo: Real;
    n: Integer;
begin
   xn :=x0;
   n :=1;
   repeat
     aux:=xn;
     fxn:= funcion(xn);
     dfxn:= derivada(xn);
     xn := xn - (fxn / dfxn);
     eerroo:= Error;
     Error := abs(xn - aux);
     if n > 1 then
     begin
       if Error = eerroo then
       begin
         solu:=False;
         Break;
       end;
       if Error > eerroo then
       begin
         solu:=False;
         Break;
       end;
     end;
     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   if solu then
     Result:=FloatToStr(xn);
end;

function Ddevil.Secante(): String;
var fxn,fxh,fhx,xn,h,aux,eerroo: Real;
    n: Integer;
begin
   xn :=x0;
   n :=1;
   repeat
     aux:= xn;
     fxn:= funcion(xn);
     h:= ErrorAllowed/10;
     fxh:=funcion(xn+h);
     fhx:=funcion(xn-h);
     xn := xn - (((2*h)*fxn )/(fxh-fhx));
     eerroo:=Error;
     Error := abs(xn - aux);
     if n > 1 then
     begin
       if Error = eerroo then
       begin
         solu:=False;
         Break;
       end;
       if Error > eerroo then
       begin
         solu:=False;
         Break;
       end;
     end;

     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   if solu then
     Result:=FloatToStr(xn);
end;
function Ddevil.FalsaPos(): String;
var fxn,xn,aux,eerroo: Real;
    n: Integer;
begin
   xn :=0;
   n :=0;
   repeat
     aux:= xn;
     fa:= funcion(x0);
     fb:= funcion(xf);
     xn := x0-(fa*(xf-x0)/(fb-fa));
     fxn:= funcion(xn);
     eerroo:=Error;
     if (fa * fxn) < 0.0 then
       xf:=xn;
     if (fa * fxn) >= 0.0 then
       x0:=xn;

     if n > 0 then
     begin
        Error := abs(xn - aux);
        if (n > 1) then
        begin
          if Error = eerroo then
            begin
              solu:=False;
              Break;
            end;
          if Error > eerroo then
            begin
              solu:=False;
              Break;
            end;
        end;
     end;
     eerroo := Error;
     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   if solu then
     Result:=FloatToStr(xn);
end;
end.

