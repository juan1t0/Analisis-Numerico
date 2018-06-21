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
    Sequence_Xn ,
    Sequence_A ,
    Sequence_B ,
    Sequence_sg ,
    Sequence_err : TstringList;
    Message : String;
    fun,derv: String;
    Met: Integer;
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
  Sequence_A:= TStringList.Create;
  Sequence_B:= TStringList.Create;
  Sequence_Xn:= TStringList.Create;
  Sequence_sg:= TStringList.Create;
  Sequence_err:= TStringList.Create;
  Message := 'Resueltisimo';
  Parsa := TParseMath.create();
  Parsa.AddVariable('x',0.0);
  Error:= Top;
  x0:=0;
  xf:=0;
  Met:=-1;
//  fun:='x';
//  derv:='x';
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
  Sequence_Xn.Destroy;
  Sequence_A.Destroy;
  Sequence_B.Destroy;
  Sequence_err.Destroy;
  Sequence_sg.Destroy;
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
       if (fa * fb )<=0 then
       begin
         case Met of
           0: Result:= Biseccion();
           1: Result:= FalsaPos();
         end;
       end
       else begin
         Message:='No se puede -';
       end;
     end
     else begin
       case Met of
           2: Result:= NewRaph();
           3: Result:= Secante();
       end;
     end;
end;

function Ddevil.Biseccion(): String;
var fxn,xn,aux,eerroo: Real;
    n: Integer;
begin
   xn:=0;
   n:=0;
   Sequence_err.Add(' - ');
   repeat
     aux:= xn;
     xn := (x0+xf)/2;
     eerroo:= Error;
     Sequence_A.Add(FloatToStr(x0));
     Sequence_B.Add(FloatToStr(xf));
     Sequence_Xn.Add(FloatToStr(xn));
     fa:= funcion(x0);
     fxn:= funcion(xn);
     if (fa * fxn) < 0.0 then
     begin
       xf:=xn;
       Sequence_sg.Add(FloatToStr(fxn));//' - ');
     end;
     if (fa * fxn) >= 0.0 then
     begin
       x0:=xn;
       Sequence_sg.Add(FloatToStr(fxn));//' + ');
     end;
     if n > 0 then
     begin
        Error := abs(xn - aux);
        Sequence_err.Add(FloatToStr(Error));
        if (n > 1) then
        begin
          if Error = eerroo then
            begin
              Message := 'Error: Puntos oscilando';
              Break;
            end;
          if Error > eerroo then
            begin
              Message := 'Error: La derivada se acerca a 0';
              Break;
            end;
        end;
     end;

     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   Result:=FloatToStr(xn);
end;

function Ddevil.NewRaph(): String;
var fxn,xn,dfxn,aux,eerroo: Real;
    n: Integer;
begin
   xn :=x0;
   n :=1;
   Sequence_err.Add(' - ');
   Sequence_Xn.Add(FloatToStr(xn));
   repeat
     aux:=xn;
     fxn:= funcion(xn);
     dfxn:= derivada(xn);
     xn := xn - (fxn / dfxn);
     Sequence_Xn.Add(FloatToStr(xn));
     eerroo:= Error;
     Error := abs(xn - aux);
     Sequence_err.Add(FloatToStr(Error));
     if n > 1 then
     begin
       if Error = eerroo then
       begin
         Message := 'Error: Puntos oscilando';
         Break;
       end;
       if Error > eerroo then
       begin
         Message := 'Error: La derivada se acerca a 0';
         Break;
       end;
     end;
     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   Result:=FloatToStr(xn);
end;

function Ddevil.Secante(): String;
var fxn,fxh,fhx,xn,h,aux,eerroo: Real;
    n: Integer;
begin
   xn :=x0;
   n :=1;
   Sequence_err.Add(' - ');
   Sequence_Xn.Add(FloatToStr(xn));
   repeat
     aux:= xn;
     fxn:= funcion(xn);
     h:= ErrorAllowed/10;
     fxh:=funcion(xn+h);
     fhx:=funcion(xn-h);
     xn := xn - (((2*h)*fxn )/(fxh-fhx));
     Sequence_Xn.Add(FloatToStr(xn));
     eerroo:=Error;
     Error := abs(xn - aux);
     Sequence_err.Add(FloatToStr(Error));
     if n > 1 then
     begin
       if Error = eerroo then
       begin
         Message := 'Error: Puntos oscilando';
         Break;
       end;
       if Error > eerroo then
       begin
         Message := 'Error: La derivada se acerca a 0';
         Break;
       end;
     end;

     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   Result:=FloatToStr(xn);//IntToStr(Met);//
  // Message := 'Resuelto';
end;
function Ddevil.FalsaPos(): String;
var fxn,xn,aux,eerroo: Real;
    n: Integer;
begin
   xn :=0;
   n :=0;
   Sequence_err.Add(' - ');
   repeat
     aux:= xn;
     Sequence_A.Add(FloatToStr(x0));
     Sequence_B.Add(FloatToStr(xf));

     fa:= funcion(x0);
     fb:= funcion(xf);
     xn := x0-(fa*(xf-x0)/(fb-fa));
     Sequence_Xn.Add(FloatToStr(xn));
     fxn:= funcion(xn);
     eerroo:=Error;
     if (fa * fxn) < 0.0 then
     begin
       xf:=xn;
       Sequence_sg.Add(FloatToStr(fxn));//'   -');
     end;

     if (fa * fxn) >= 0.0 then
     begin
       x0:=xn;
       Sequence_sg.Add(FloatToStr(fxn));//'   +');
     end;
     if n > 0 then
     begin
        Error := abs(xn - aux);
        Sequence_err.Add(FloatToStr(Error));
        if (n > 1) then
        begin
          if Error = eerroo then
            begin
              Message := 'Error: Puntos oscilando';
              Break;
            end;
          if Error > eerroo then
            begin
              Message := 'Error: La derivada se acerca a 0';
              Break;
            end;
        end;
     end;
     eerroo := Error;
     n:=n+1;
   until (Error < ErrorAllowed) or (n>=Top) or (fxn=0);
   Result:=FloatToStr(xn);//IntToStr(Met);//
end;
end.


