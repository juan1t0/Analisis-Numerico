unit graph;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls,ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Area: TAreaSeries;
    chrGrafica: TChart;
    LineSeries1: TLineSeries;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    Funcion: TFuncSeries;
    Plotear: TLineSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    //procedure FuncionCalculate(const AX: Double; out AY: Double);
    procedure GraficarFuncionPts();
    procedure GraficarFuncionConPloteo();
  private
    Parse : TParseMath;
    function f(x:Double): Double;
    //Procedure DetectarIntervalo();
  public
    AreaA , AreaB : Real;
    fun : String;
    Xs,Ys : TStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0.0);
  Xs:=TStringList.create;
  Ys:=TStringList.create;
end;
procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;
function TForm1.f(x:Double):Double;
begin
  Parse.Expression:= fun;
  Parse.NewValue('x',x);
  Result:= Parse.Evaluate();
end;

procedure TForm1.GraficarFuncionPts();
var
  i:integer;
  xa,ya:Real;
begin
  LineSeries1.Clear;
  LineSeries1.ShowLines:=False;
  LineSeries1.ShowPoints:=True;
  Funcion.Extent.Xmax:= AreaB *1.5;
  Funcion.Extent.Xmin:= AreaA * 1.5;
  Funcion.Extent.UseXMax:= true;
  Funcion.Extent.UseXMin:= true;

  for i:=0 to Xs.Count-1 do begin
    xa:= StrToFloat(Xs[i]);
    ya:= StrToFloat(Ys[i]);
    LineSeries1.AddXY(xa,ya);
  end;
end;

Procedure TForm1.GraficarFuncionConPloteo();
var Max,Min,h,NewX,NewY:Real;
  intervalo : Boolean;
begin
  Plotear.Clear;
  Area.Clear;
  Funcion.Active:=False;
  Area.Active:= False;

  Max := AreaB * 2;
  Min := AreaA * 2;
  NewX:= AreaA;
  h:=0.0001;
  Plotear.LinePen.Color := clNavy;

  Funcion.Extent.Xmax:= Max;
  Funcion.Extent.Xmin:= Min;
  Funcion.Extent.UseXMax:= true;
  Funcion.Extent.UseXMin:= true;
  Funcion.Pen.Color := clOlive;

  while NewX <= AreaB do begin
    NewY:= f( NewX );
    Plotear.AddXY(NewX, NewY);
    intervalo:= (NewX >= AreaA) and (NewX <= AreaB);
    if intervalo then
       Area.AddXY(NewX,NewY);
    NewX:= NewX + h;
  end;
  Plotear.Active:= true;
  Funcion.Active:= true;
  Area.Active:= true;
end;

end.

