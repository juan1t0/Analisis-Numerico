unit NR_generalizado;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs,matris,ParseMath,math;

type
  NewRap = class
    Xn : matriz;
    Variables : Array of Real;
    FdeN,
    jacobiana : matriz;
    XnsList,
    ErrorList,
    Functiones: TStringList;
    ErrorA,
    Error : Real;
    func,
    vari:Integer;
    mensaje:String;
  private
    MyParsa : TParseMath;
    OpMax : CMatriz;
    function GetJaco(vars:Array of Real):matriz;

  public
    function Ejecutar():String;
    constructor create;
    destructor Destroy; override;
  end;

implementation
const
  Top = 100001;
var
  name_var: Array[0..20] of string =
  ('x','y','z','w','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q');
constructor NewRap.create;
var a:Integer;
begin
  ErrorList:=TStringList.Create;
  XnsList := TStringList.Create;
  Functiones := TStringList.Create;
//  SetLength(Variables,vari);
//  Jacob := TStringList.Create;
  //SetLength(FdeN,func,1);
  //SetLength(jacobiana,func,vari);
  //SetLength(Xn,vari,1);
  MyParsa := TParseMath.Create();
  OpMax := CMatriz.create;
  Error := Top;
end;
destructor NewRap.Destroy;
begin
  ErrorList.Destroy;
  XnsList.Destroy;
  Functiones.Destroy;
  //Jacob.Destroy;
  MyParsa.destroy;
  OpMax.Destroy;
end;

function NewRap.GetJaco(vars:Array of Real):matriz;
var m : matriz;
  i,j,x,n : Integer;
  s : String;
  h,tempmas,temples : Real;
begin
//  x:=0;
  n:= Length(vars)-1;
  SetLength(m,func,vari);
  //for i:=0 to vari-1 do
    //MyParsa.NewValue(name_var[i],vars[i]);
  h:=ErrorA/10;
   for i:=0 to n do begin
    s := Functiones[i];
    MyParsa.Expression := s;
    for j:=0 to n do begin
      for x:=0 to n do
         MyParsa.NewValue(name_var[x],vars[x]);
      MyParsa.NewValue(name_var[j],vars[j]+h);
      tempmas:= MyParsa.Evaluate();
      MyParsa.NewValue(name_var[j],vars[j]-h);
      temples:= MyParsa.Evaluate();
      m[i,j]:= (tempmas - temples)/(2*h);
      //x:=x+1;
    end;
  end;
  mensaje:= FloatToStr(m[0,0]);
  GetJaco:= m;
end;

procedure Asignar(M:matriz;V : Array of Real);
var
  i:Integer;
begin
  for i:=0 to Length(V)-1 do
    M[i,0]:= V[i];
end;
procedure AdderToSL(lista:TStringList;vars:Array of Real);
var i : Integer;
  temp : String;
begin
  temp:='( ';
  for i:=0 to Length(vars)-2 do
    temp:= temp + FloatToStr(vars[i])+' , ';
  temp:= temp + FloatToStr(vars[Length(vars)-1]) + ' )';
  lista.Add(temp);
end;
function NewRap.Ejecutar():String;
var
  i,n,j : Integer;
  aux : Array of Real;
  jaco_1,Faux : matriz;
  res : String;
begin
//  for i:=0 to vari do
  n:=0;
//  x_a :=xx;
//  y_a :=yy;
  aux := Variables;
  SetLength(FdeN,func,1);
  SetLength(jacobiana,func,vari);
  SetLength(Xn,vari,1);
  Asignar(Xn,Variables);
  ErrorList.Add(' - ');

  SetLength(jaco_1,func,vari);
  SetLength(Faux,func,1);
  for j:=0 to vari-1 do
    MyParsa.AddVariable(name_var[j],0);
  repeat
    AdderToSL(XnsList,Variables);
    jacobiana := GetJaco(Variables);
    //mensaje:= IntToStr(Length(jacobiana[0])+Length(jacobiana));
    jaco_1 := OpMax.Inversa(jacobiana);
    mensaje:=OpMax.Message;
    for i:=0 to func-1 do begin
      MyParsa.Expression := functiones[i];
      for j:=0 to Length(Variables)-1 do
        MyParsa.NewValue( name_var[j], Variables[j] );
      FdeN[i,0]:= MyParsa.Evaluate();
    end;
    Faux := OpMax.Multiplicacion(jaco_1,FdeN);
    //mensaje:=FloatToStr(Faux[0,0]);
    Xn:= OpMax.Resta(Xn,Faux);
    if n>0 then
    begin
      for i:=0 to Length(Variables)-1 do
        Error := Error + (Power(Variables[i] - Xn[i,0],2));
      Error := sqrt(Error);
      //Error := sqrt(Power(x_a - xx,2) + Power(x_a - yy,2));
      ErrorList.Add(FloatToStr(Error));
      Error:=0;
    end;
    for i:=0 to vari-1 do
      Variables[i] := Xn[i,0];

    n:=n+1
  until (Error < ErrorA) or (n>=Top);
  //mensaje:=FloatToStr(Error);
  res:='( ';
  for i:=0 to vari-2 do
    res:= res + FloatToStr(Variables[i])+' , ';
  res:= res + FloatToStr(Variables[vari-1]) + ' )';

 // mensaje:= IntToStr(XnsList.Count)+ ' '+IntToStr(ErrorList.Count);
  Ejecutar:=mensaje+' '+IntToStr(n)+res;
end;

end.

