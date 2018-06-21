unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries,
  TATransformations, TATools, Forms,Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Grids, Spin, PdeLagrange,ParseMath,devil;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGraph: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsFuncSeries2: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    chartGraphicsLineSeries2: TLineSeries;
    chartGraphicsLineSeries3: TLineSeries;
    Funcion2: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Funcion1: TLabel;
    Label3: TLabel;
    imagen: TLabel;
    Memo: TMemo;
    Points1: TStringGrid;
    preimagen: TLabel;
    pnlRight: TPanel;
    SpinEdit1: TSpinEdit;
    Points: TStringGrid;
    SpinEdit2: TSpinEdit;
    trbMax: TTrackBar;
    trbMin: TTrackBar;
    procedure btnGraphClick(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure chartGraphicsFuncSeries2Calculate(const AX: Double; out AY: Double
      );
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private

  public
    fucion: String;
    Pepe : TParseMath;
    Polinomio,Polinomia : Lagrange;
    Red : Ddevil;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnGraphClick(Sender: TObject);
var x,y,r,w:Real;
  i,n:integer;
  xx,yy,nn: Array of Real;
begin
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= False;
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  setlength(xx,Points.RowCount);
  setlength(yy,Points.RowCount);
  for i:=0 to Points.RowCount -1 do begin
    x:= StrToFloat( Points.Cells[0,i] );
    y:= StrToFloat( Points.Cells[1,i] );
    chartGraphicsLineSeries1.AddXY( x, y );
    xx[i]:=x;
    yy[i]:=y;
  end;
  Polinomio:= Lagrange.create;
  Polinomio.Xs := xx;
  Polinomio.Ys := yy;
  Polinomio.CreatePolinomio();
  Funcion1.Caption := Polinomio.Fution;
  Memo.Lines.Add(Polinomio.Fution);
  Polinomio.destroy;
{--------------------------------------------------------------    }
  chartGraphicsFuncSeries2.Pen.Color:= clRed;
  chartGraphicsFuncSeries2.Active:= False;

  chartGraphicsLineSeries2.ShowLines:= False;
  chartGraphicsLineSeries2.ShowPoints:= true;

  setlength(xx,Points1.RowCount);
  setlength(yy,Points1.RowCount);
  for i:=0 to Points1.RowCount -1 do begin
    x:= StrToFloat( Points1.Cells[0,i] );
    y:= StrToFloat( Points1.Cells[1,i] );
    chartGraphicsLineSeries2.AddXY( x, y );
    xx[i]:=x;
    yy[i]:=y;
  end;
  Polinomia:= Lagrange.create;
  Polinomia.Xs := xx;
  Polinomia.Ys := yy;
  Polinomia.CreatePolinomio();
  Funcion2.Caption := Polinomia.Fution;

  Polinomia.destroy;
  chartGraphicsFuncSeries2.Active:= True;
  chartGraphicsFuncSeries1.Active:= True;
  {--------------------------------------------------------------}
  Red:= Ddevil.create;
  chartGraphicsLineSeries3.ShowLines:= false;
  chartGraphicsLineSeries3.ShowPoints:= true;
  n:= SpinEdit1.Value + SpinEdit2.Value;
  Red.ErrorAllowed:=0.00001;
  Red.fun:= '('+Funcion1.Caption + ')-(' + Funcion2.Caption+')';
  Pepe.Expression:=Funcion1.Caption;
  for i:=n downto -5 do begin
    Red.x0:= i;
    Red.Met := 3;
    r:= StrToFloat(Red.Ejecuta());
    Pepe.NewValue('x',r);
    w:= Pepe.Evaluate();
    chartGraphicsLineSeries3.AddXY(r,w)
  end;




end;

procedure TfrmMain.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);

begin
  Pepe.Expression:=Funcion1.Caption;
  Pepe.NewValue('x',AX);
  AY:=Pepe.Evaluate();
  //AY:=AX;
end;

procedure TfrmMain.chartGraphicsFuncSeries2Calculate(const AX: Double; out
  AY: Double);
begin
  Pepe.Expression:=Funcion2.Caption;
  Pepe.NewValue('x',AX);
  AY:=Pepe.Evaluate();
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  Pepe := TParseMath.create();
  Pepe.AddVariable('x',0.0);
end;

procedure TfrmMain.SpinEdit1Change(Sender: TObject);
begin
  Points.RowCount:=SpinEdit1.Value;
end;

procedure TfrmMain.SpinEdit2Change(Sender: TObject);
begin
  Points1.RowCount:=SpinEdit2.Value;
end;

procedure TfrmMain.trbMaxChange(Sender: TObject);
begin
  chartGraphics.Extent.XMax:= trbMax.Position;
end;

procedure TfrmMain.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
end;

end.

