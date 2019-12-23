unit Parse2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, fpexprpars, Dialogs,trapezoide,Simpson,graph,devil,EDO1;

type
  TParse = Class

  Private
      FParser: TFPExpressionParser;
      identifier: array of TFPExprIdentifierDef;
      Procedure AddFunctions();

  Public
      Expression: string;
      function NewValue( Variable:string; Value: Double ): Double;
      procedure AddVariable( Variable: string; Value: Double );
      procedure AddString( Variable: string; Value: string );
      function Evaluate(  ): Double;
      procedure ChangeH(hh:Real);
      constructor create();
      destructor destroy;

  end;

implementation
var
  h:Real;

constructor TParse.create;
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [ bcMath ];
   AddFunctions();

end;

destructor TParse.destroy;
begin
    FParser.Destroy;
end;

function TParse.NewValue( Variable: string; Value: Double ): Double;
begin
    FParser.IdentifierByName(Variable).AsFloat:= Value;
end;

procedure TParse.ChangeH(hh:Real);
begin
    h := hh;
end;

function TParse.Evaluate(): Double;
begin
     FParser.Expression:= Expression;
     Result:= ArgToFloat( FParser.Evaluate );

end;

function IsNumber(AValue: TExprFloat): Boolean;
begin
  result := not (IsNaN(AValue) or IsInfinite(AValue) or IsInfinite(-AValue));
end;

Procedure ExprRaiz(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b:Real;
  f,metodo,res:string;
  Red : Ddevil;
begin
   f:= Args[ 0 ].ResString;
   a:= ArgToFloat( Args[ 1 ] );
   b:= ArgToFloat( Args[ 2 ] );
   metodo:=Args[ 3 ].ResString;

   Red:= Ddevil.create;
   Red.fun:=f;
   Red.ErrorAllowed:= 0.00001;
   Red.x0:=a;
   Red.xf:=b;
//   Red.h:=h;
   if metodo = '' then
   begin
     res:=Red.Defaul();
     if Red.solu then
     begin
       Result.ResFloat := StrToFloat(res);
     end else begin
       Result.ResFloat := NaN;
     end;
     Red.Destroy;
   end else if metodo = 'biseccion' then
   begin
     Red.Met:=0;
     res:=Red.Ejecuta();
     if Red.solu then
     begin
       Result.ResFloat := StrToFloat(res);
     end else begin
       Result.ResFloat := NaN;
     end;
     Red.Destroy;
   end else if metodo = 'falsapos' then
   begin        
     Red.Met:=1;
     res:=Red.Ejecuta();
     if Red.solu then
     begin
       Result.ResFloat := StrToFloat(res);
     end else begin
       Result.ResFloat := NaN;
     end;
     Red.Destroy;
   end else if metodo = 'newton' then
   begin        
     Red.Met:=3;
     res:=Red.Ejecuta();
     if Red.solu then
     begin
       Result.ResFloat := StrToFloat(res);
     end else begin
       Result.ResFloat := NaN;
     end;
     Red.Destroy;
   end else if metodo = 'secante' then
   begin        
     Red.Met:=3;
     res:=Red.Ejecuta();
     if Red.solu then
     begin
       Result.ResFloat := StrToFloat(res);
     end else begin
       Result.ResFloat := NaN;
     end;
     Red.Destroy;
   end;
end;

Procedure ExprIntegral( var Result: TFPExpressionResult; Const Args: TExprParameterArray );
var
  a,b: Real;
  f,metodo: string;
  Homero: ISimpson;
  Trapecio: ITrapecio;
begin
   f:= Args[ 0 ].ResString;
   a:= ArgToFloat( Args[ 1 ] );
   b:= ArgToFloat( Args[ 2 ] );
   metodo:=Args[ 3 ].ResString;

   if metodo = '' then
   begin
     Homero:= ISimpson.create;
     Homero.pt_a:=a;
     Homero.pt_b:=b;
     Homero.fun:=f;
     Homero.h:=h;
     Result.ResFloat := StrToFloat(Homero.Ejecuta13());
     Homero.Destroy;
   end else if metodo = 'trapecio' then
   begin
     Trapecio:= ITrapecio.create;
     Trapecio.pt_a:=a;
     Trapecio.pt_b:=b;
     Trapecio.fun:=f;
     Trapecio.h:=h;
     Result.ResFloat := StrToFloat(Trapecio.Ejecuta());
     Trapecio.Destroy;
   end else if metodo = 'simpson_untercio' then
   begin
     Homero:= ISimpson.create;
     Homero.pt_a:=a;
     Homero.pt_b:=b;
     Homero.fun:=f;
     Homero.h:=h;
     Result.ResFloat := StrToFloat(Homero.Ejecuta13());
     Homero.Destroy;
   end else if metodo = 'simpson_tresoctv' then
   begin
     Homero:= ISimpson.create;
     Homero.pt_a:=a;
     Homero.pt_b:=b;
     Homero.fun:=f;
     Homero.h:=h;
     Result.ResFloat := StrToFloat(Homero.Ejecuta38());
     Homero.Destroy;
   end;
   Form1.AreaA:= a;
   Form1.AreaB:= b;
   Form1.fun:= f;

   Form1.GraficarFuncionConPloteo();
   Form1.Visible:= true;

end;
procedure ExprEdo( var Result: TFPExpressionResult; Const Args: TExprParameterArray );
var
  x0,y0,rn :Real;
  metodo,fd:String;
  eDodo : Eeuler;
begin
  fd:= Args[ 0 ].ResString;
  x0:= ArgToFloat( Args[ 1 ] );
  y0:= ArgToFloat( Args[ 2 ] );
  rn:= ArgToFloat( Args[ 3 ] );
  metodo:= Args[ 4 ].ResString;

  if rn < x0 then
     h:= (-1)*h;
  eDodo:= Eeuler.create;
  eDodo.x_0:= x0;
  eDodo.y_0:= y0;
  eDodo.fin:= rn;
  eDodo.funD:= fd;
  eDodo.h:=h;
  if metodo = '' then
  begin
    Result.ResFloat := StrToFloat(eDodo.DormandPrince());
    Form1.Xs:= eDodo.xs;
    Form1.Ys:= eDodo.ys;
    eDodo.Destroy;
  end else if metodo = 'euler' then
  begin
    Result.ResFloat := StrToFloat(eDodo.Euler());
    Form1.Xs:= eDodo.xs;
    Form1.Ys:= eDodo.ys;
    eDodo.Destroy;
  end else if metodo = 'heun' then
  begin
    Result.ResFloat := StrToFloat(eDodo.Heun());
    Form1.Xs:= eDodo.xs;
    Form1.Ys:= eDodo.ys;
    eDodo.Destroy;
  end else if metodo = 'runge_kutta' then
  begin
    Result.ResFloat := StrToFloat(eDodo.RungeKutta());
    Form1.Xs:= eDodo.xs;
    Form1.Ys:= eDodo.ys;
    eDodo.Destroy;
  end else if metodo = 'dormand_prince' then
  begin
    Result.ResFloat := StrToFloat(eDodo.DormandPrince());
    Form1.Xs:= eDodo.xs;
    Form1.Ys:= eDodo.ys;
    eDodo.Destroy;
  end;
  Form1.AreaA:=x0;
  Form1.AreaB:=rn;
  Form1.GraficarFuncionPts();
  Form1.Visible:= true;
end;

Procedure TParse.AddFunctions();
begin
   with FParser.Identifiers do begin
       AddFunction('raiz', 'F', 'SFFS', @ExprRaiz );
       AddFunction('integral', 'F', 'SFFS',@ExprIntegral);
       AddFunction('edo','F','SFFFS',@ExprEdo);

   end;

end;

procedure TParse.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);

end;

procedure TParse.AddString( Variable: string; Value: string );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;

   identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);
end;

end.

