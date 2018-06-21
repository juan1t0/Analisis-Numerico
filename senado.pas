unit senado;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, Grids, ExtCtrls, StdCtrls, ComCtrls,devil,math,ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Biseccion: TButton;
    edit_derivada: TEdit;
    showDx: TButton;
    FalsaPos: TButton;
    NewRaph: TButton;
    Secante: TButton;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    DrewFuncSeries1: TFuncSeries;
    Drew: TChart;
    edit_x1: TEdit;
    edit_x2: TEdit;
    edit_error: TEdit;
    edit_funcion: TEdit;
    Funcion: TLabel;
    Error: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OutL: TLabel;
    Punto1: TLabel;
    Label_respuesta: TLabel;
    Memo: TMemo;
    Punto2: TLabel;
    Data: TStringGrid;
    Positivo: TTrackBar;
    Negativo: TTrackBar;
    procedure BiseccionClick(Sender: TObject);
    procedure DrewFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure FalsaPosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NegativoChange(Sender: TObject);
    procedure NewRaphClick(Sender: TObject);
    procedure PositivoChange(Sender: TObject);
    procedure SecanteClick(Sender: TObject);
    procedure showDxClick(Sender: TObject);
  private
    Red: Ddevil;
  public
  end;

var
  Form1: TForm1;

implementation
const
   col_N = 0;
   col_p1 = 1;
   col_p2 = 2;
   col_Xn = 3;
   col_sig = 4;
   col_error = 5;
{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  Drew.Extent.UseXMax:= true;
  Drew.Extent.UseXMin:= true;
  DrewFuncSeries1.Pen.Color:= clBlue;
end;
procedure TForm1.FormDestroy(Sender: TObject);
begin

end;

procedure TForm1.DrewFuncSeries1Calculate(const AX: Double; out AY: Double);
var Parse : TParseMath;
begin
  Parse := TParseMath.create();
  Parse.Expression:=edit_funcion.Text;
  Parse.AddVariable('x',AX);
  AY:= AX;//Parse.Evaluate();
end;

procedure TForm1.FalsaPosClick(Sender: TObject);
var r:String;
    procedure FillStringGrid;
    var i: Integer;
    begin
      with Data do
        for i:= 0 to RowCount - 1 do
            Cells[ col_N, i ]:= IntToStr( i );
    end;
begin
  DrewFuncSeries1.Active:=false;
  Red:= Ddevil.create;
  Red.x0:= StrToFloat( edit_x1.Text );
  Red.xf:= StrToFloat( edit_x2.Text );
  Red.ErrorAllowed:=StrToFloat(edit_error.Text);
  Red.fun:= edit_funcion.Text;
  Data.Clean;
//  Memo.Clear;
  Red.Met := 1;
  r:= Red.Ejecuta();

  Memo.Lines.Add( ' = ' + r) ;
    with Data do begin
      RowCount:= Red.Sequence_Xn.Count;
      Cols[ col_Xn ].Assign( Red.Sequence_Xn );
      Cols[ col_p1 ].Assign( Red.Sequence_A );
      Cols[ col_p2 ].Assign( Red.Sequence_B );
      Cols[ col_sig ].Assign( Red.Sequence_sg );
      Cols[ col_error ].Assign( Red.Sequence_err );
    end;
  FillStringGrid;
  OutL.Caption := Red.Message;
//  Memo.Lines.Add(Red.Message);
  DrewFuncSeries1.Active:=true;
  if (Red.Message = 'Error: Puntos oscilando') or (Red.Message = 'Error: La derivada se acerca a 0') then
  begin
    Data.Clean;
    Memo.Clear;
  end;
  Red.Destroy;
end;
procedure TForm1.BiseccionClick(Sender: TObject);
var r:String;
    procedure FillStringGrid;
    var i: Integer;
    begin
      with Data do
        for i:= 0 to RowCount - 1 do
            Cells[ col_N, i ]:= IntToStr( i );
    end;
begin
  DrewFuncSeries1.Active:=false;
  Red:= Ddevil.create;
  Red.x0:= StrToFloat( edit_x1.Text );
  Red.xf:= StrToFloat( edit_x2.Text );
  Red.fun:= edit_funcion.Text;
  Red.ErrorAllowed:=StrToFloat(edit_error.Text);
  Data.Clean;
//  Memo.Clear;
  Red.Met := 0;
  r:= Red.Ejecuta();

  Memo.Lines.Add( Red.fun+'  = ' + r) ;
    with Data do begin
      RowCount:= Red.Sequence_Xn.Count;
      Cols[ col_Xn ].Assign( Red.Sequence_Xn );
      Cols[ col_p1 ].Assign( Red.Sequence_A );
      Cols[ col_p2 ].Assign( Red.Sequence_B );
      Cols[ col_sig ].Assign( Red.Sequence_sg );
      Cols[ col_error ].Assign( Red.Sequence_err );
    end;
  FillStringGrid;
  OutL.Caption := Red.Message;
//  Memo.Lines.Add(Red.Message);
  DrewFuncSeries1.Active:=true;
  if (Red.Message = 'Error: Puntos oscilando') or (Red.Message = 'Error: La derivada se acerca a 0') then
  begin
    Data.Clean;
    Memo.Clear;
  end;
  Red.Destroy;
end;
procedure TForm1.NewRaphClick(Sender: TObject);
var r:String;
    procedure FillStringGrid;
    var i: Integer;
    begin
      with Data do
        for i:= 0 to RowCount - 1 do
            Cells[ col_N, i ]:= IntToStr( i );
    end;
begin
  DrewFuncSeries1.Active:=false;
  Red:= Ddevil.create;
  Red.x0:= StrToFloat( edit_x1.Text );
  Red.xf:= StrToFloat( edit_x2.Text );
  Red.fun:= edit_funcion.Text;
  Red.derv:= edit_derivada.Text;
  Red.ErrorAllowed:=StrToFloat(edit_error.Text);
  Data.Clean;
//  Memo.Clear;
  Red.Met := 2;
  r:= Red.Ejecuta();
  Memo.Lines.Add( ' = ' + r) ;
    with Data do begin
      RowCount:= Red.Sequence_Xn.Count;
      Cols[ col_Xn ].Assign( Red.Sequence_Xn );
      Cols[ col_p1 ].Assign( Red.Sequence_A );
      Cols[ col_p2 ].Assign( Red.Sequence_B );
      Cols[ col_sig ].Assign( Red.Sequence_sg );
      Cols[ col_error ].Assign( Red.Sequence_err );
    end;
  FillStringGrid;
  OutL.Caption := Red.Message;
//  Memo.Lines.Add(Red.Message);
  if (Red.Message = 'Error: Puntos oscilando') or (Red.Message = 'Error: La derivada se acerca a 0') then
  begin
    Data.Clean;
    Memo.Clear;
  end;
  DrewFuncSeries1.Active:=true;
  Red.Destroy;
end;
procedure TForm1.SecanteClick(Sender: TObject);
var r:String;
    procedure FillStringGrid;
    var i: Integer;
    begin
      with Data do
        for i:= 0 to RowCount - 1 do
            Cells[ col_N, i ]:= IntToStr( i );
    end;
begin
  DrewFuncSeries1.Active:=false;
  Red:= Ddevil.create;
  Red.x0:= StrToFloat( edit_x1.Text );
  Red.xf:= StrToFloat( edit_x2.Text );
  Red.fun:= edit_funcion.Text;
  Red.ErrorAllowed:=StrToFloat(edit_error.Text);
  Data.Clean;
//  Memo.Clear;
  Red.Met := 3;
  r:= Red.Ejecuta();

  Memo.Lines.Add( ' = ' + r) ;
    with Data do begin
      RowCount:= Red.Sequence_Xn.Count;
      Cols[ col_Xn ].Assign( Red.Sequence_Xn );
      Cols[ col_p1 ].Assign( Red.Sequence_A );
      Cols[ col_p2 ].Assign( Red.Sequence_B );
      Cols[ col_sig ].Assign( Red.Sequence_sg );
      Cols[ col_error ].Assign( Red.Sequence_err );
    end;
  FillStringGrid;
  OutL.Caption := Red.Message;
//  Memo.Lines.Add(Red.Message);
  DrewFuncSeries1.Active:=true;
  if (Red.Message = 'Error: Puntos oscilando') or (Red.Message = 'Error: La derivada se acerca a 0') then
  begin
    Data.Clean;
    Memo.Clear;
  end;
  Red.Destroy;
end;

procedure TForm1.PositivoChange(Sender: TObject);
begin
  Drew.Extent.XMax:=Positivo.Position;
end;

procedure TForm1.NegativoChange(Sender: TObject);
begin
  Drew.Extent.XMin:=Negativo.Position;
end;


procedure TForm1.showDxClick(Sender: TObject);
begin
  edit_derivada.Visible:=True;
  showDx.Visible:=False;
end;

end.

