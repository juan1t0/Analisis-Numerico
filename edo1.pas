unit EDO1;

{$mode objfpc}

interface

uses
  Classes, SysUtils, Dialogs , ParseMath , math;

type
  EEuler = class
    x_0,
    y_0 : Real;
    Parsa : TParseMath;
    funD: String;
    solu,
    fin,
    f_xn,
    h :Real;
    xs,ys : TStringList;
    private
      Error:Real;
      public
      constructor create;
      destructor Destroy; override;
      function Euler():String;
      function Heun():String;
      function RungeKutta():String;
      function DormandPrince():String;
      function funcionD(xx,yy:Real):Real;
  end;

implementation

constructor EEuler.create;
begin
  x_0 := 0.0;
  y_0 := 0.0;
  Parsa := TParseMath.create();
  Parsa.AddVariable('x',0.0);
  Parsa.AddVariable('y',0.0);
  xs:= TStringList.create;
  ys:= TStringList.create;
end;

function EEuler.funcionD( xx,yy:Real):Real;
begin
  Parsa.Expression:=funD;
  Parsa.NewValue('x',xx);
  Parsa.NewValue('y',yy);
  Result:= Parsa.Evaluate();
end;
destructor EEuler.Destroy;
begin
  Parsa.destroy;
end;

function EEuler.Euler():String;
var
  xn : Real;
  rr:Boolean;
begin
  xn := x_0;
  f_xn := y_0;
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
  rr:=false;
  repeat
    f_xn := f_xn + h*(funcionD(xn,f_xn));
    xn := xn + h;
    xs.Add(FloatToStr(xn));
    ys.Add(FloatToStr(f_xn));
    if h < 0 then
    begin
      rr := (xn < fin);
    end else
    begin
      rr := (xn > fin);
    end;
  until rr = true{) and (Error ...)};
  solu := f_xn + (fin-xn)*(funcionD(xn,f_xn));
  Euler := FloatToStr(solu);
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
end;

function EEuler.Heun():String;
var
  xn, yn , ft1,ft2 :Real;
  rr : Boolean;
begin
  rr:=false;
  xn := x_0;
  yn := y_0;
  f_xn := y_0;
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
  repeat
    solu:=f_xn;
    ft1 := funcionD(xn,f_xn);
    xn := xn + h;
    yn := f_xn + h*(ft1);
    ft2 := funcionD(xn,yn);
    f_xn := f_xn + (h*0.5)*(ft1+ft2);
    xs.Add(FloatToStr(xn));
    ys.Add(FloatToStr(f_xn));
    if h < 0 then
    begin
      rr := (xn < fin);
    end else
    begin
      rr := (xn > fin);
    end;
  until rr=true;
  solu:= f_xn + ((fin-xn)*0.5)*(ft1+ft2);
  Heun := FloatToStr(solu);
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
end;

function EEuler.RungeKutta():String;
var
  xn,k1,k2,k3,k4,m,hh:Real;
  rr:Boolean;
begin
  rr:=false;
  xn := x_0;
  f_xn := y_0;
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
  repeat
    solu:=f_xn;
    k1:=funcionD(xn,f_xn);
    k2:=funcionD(xn+(h/2),f_xn+(k1*h)/2);
    k3:=funcionD(xn+(h/2),f_xn+(k2*h)/2);
    k4:=funcionD(xn+h,f_xn+(k3*h));
    m:= (k1+2*k2+2*k3+k4)/6;
    f_xn := f_xn+h*m;
    xn:=xn+h;
    xs.Add(FloatToStr(xn));
    ys.Add(FloatToStr(f_xn));
    if h < 0 then
    begin
      rr := (xn < fin);
    end else
    begin
      rr := (xn > fin);
    end;
  until rr = true;
  hh:=fin-xn;
  f_xn:=solu;
  k1:=funcionD(xn,f_xn);
  k2:=funcionD(xn+(hh/2),f_xn+(k1*hh)/2);
  k3:=funcionD(xn+(hh/2),f_xn+(k2*hh)/2);
  k4:=funcionD(xn+hh,f_xn+(k3*hh));
  m:= (k1+2*k2+2*k3+k4)/6;
  solu := f_xn+hh*m;
  RungeKutta:=FloatToStr(solu);
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
end;
function EEuler.DormandPrince():String;
var
  xn,yn,errorAllowed,k1,k2,k3,k4,k5,k6,k7,y1,z1,s :Real;
  rr:Boolean;
begin
  errorAllowed:=0.0001;
  xn:=x_0;
  yn:=y_0;
  rr:=false;
//  s:=0;
  repeat
    k1:= funcionD(xn,yn);
    k2:= funcionD(xn+(1/5) *h, yn + (h*k1)*(1/5));
    k3:= funcionD(xn+(3/10)*h, yn + (h*k1)*(3/40)      +(h*k2)*(9/40));
    k4:= funcionD(xn+(4/5) *h, yn + (h*k1)*(44/45)     -(h*k2)*(56/15)     +(h*k3)*(32/9));
    k5:= funcionD(xn+(8/9) *h, yn + (h*k1)*(19372/6561)-(h*k2)*(25360/2187)+(h*k3)*(64448/6561)- (h*k4)*(212/729));
    k6:= funcionD(xn+h       , yn + (h*k1)*(9017/3168) -(h*k2)*(355/33)    +(h*k3)*(46732/5247)+ (h*k4)*(49/176) -(h*k5)*(5103/18656));
    k7:= funcionD(xn+h , yn+(35/384)*k1+(500/1113)*k3+(125/192)*k4-(2187/6784)*k5+(11/84)*k6);

    yn:= yn+h*((35/384)*k1)+h*((500/1113)*k3)+h*((125/192)*k4)-h*((2187/6784)*k5)+h*((11/84)*k6);
//    z1:= yn+h*((5179/57600)*k1+(7571/16695)*k3+(393/640)*k4-(92097/339200)*k5+(187/2100)*k6+k7/40);

//    error:= abs(z1-yn);
//    s:=Exp((1/5)*Ln(errorAllowed*h/(2*error)));
//    h:=h*s;
    {if h<hmin then h:=hmin
    else if h > hmax then h=hmax}

    xn:= xn+h;
    xs.Add(FloatToStr(xn));
    ys.Add(FloatToStr(yn));
    if h < 0 then
    begin
      rr := (xn <= fin);
    end else
    begin
      rr := (xn >= fin);
    end;
  until rr=true;
  solu := yn;
  DormandPrince:=FloatToStr(solu);
  xs.Add(FloatToStr(xn));
  ys.Add(FloatToStr(f_xn));
end;

end.










