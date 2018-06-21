unit matriz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Grids,matris,ParseMath,NR_generalizado;

type

  { TForm1 }

  TForm1 = class(TForm)
    Calcular: TButton;
    edit_Error: TEdit;
    Error: TLabel;
    Label1: TLabel;
    Status: TLabel;
    Label5: TLabel;
    Xn: TLabel;
    N: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Funciones_cant: TSpinEdit;
    Variables_cant: TSpinEdit;
    Funciones_Sgrid: TStringGrid;
    Memo: TMemo;
    TableSG: TStringGrid;
    Puntos_Sgrid: TStringGrid;
    procedure CalcularClick(Sender: TObject);
    procedure Funciones_cantChange(Sender: TObject);
    procedure Variables_cantChange(Sender: TObject);
  private
    {Xval,
    Yval,
    Zval:Real;}
    Pogba : NewRap;
  public

  end;

var
  Form1: TForm1;

implementation

const
Col_xn = 1;
Col_Err = 2;
Col_n =0;
{$R *.lfm}

{ TForm1 }

(* procesos*)
(*acabo*)

procedure TForm1.Variables_cantChange(Sender: TObject);
begin
  Puntos_Sgrid.RowCount:=Variables_cant.value;
end;

procedure TForm1.Funciones_cantChange(Sender: TObject);
begin
  Funciones_Sgrid.RowCount:=Funciones_cant.value;
end;

procedure TForm1.CalcularClick(Sender: TObject);
var
  resu : String;
  funciones : TStringList;
  cant_fun,
  cant_var,
  i,
  j: Integer;
  vals : Array of Real;
  procedure FillStringGrid;
    var i: Integer;
    begin
      with TableSG do
        for i:= 0 to RowCount - 1 do
            Cells[ Col_n, i ]:= IntToStr( i );
    end;
begin
  funciones := TstringList.create;
  cant_fun := Funciones_cant.value;
  cant_var := Variables_cant.value;

  with Funciones_Sgrid do
    for i:=0 to RowCount-1 do
      funciones.Add(Cells[0,i]);

  //Isaac:=TStringList.create;
  SetLength(vals,cant_var);
  with Puntos_Sgrid do
    for j:=0 to RowCount-1 do begin
      vals[j]:=StrToFloat(Cells[0,j]);
     // Memo.Lines.Add(FloatToStr(vals[j]));
    end;

  Pogba := NewRap.create;
  Pogba.Functiones := funciones;
//  Pogba.Jacob:=Isaac;
{  Memo.Lines.Add( ' 000' + Pogba.Jacob[0]+'a') ;
  Memo.Lines.Add( ' 000' + Pogba.Jacob[1]+'b') ;
  Memo.Lines.Add( ' 000' + Pogba.Jacob[2]+'c') ;
  Memo.Lines.Add( ' 000' + Pogba.Jacob[3]+'d') ;
 } Pogba.ErrorA:= StrToFloat(edit_Error.Text);
  Pogba.func:= cant_fun;
  Pogba.vari:= cant_var;
                         {
  Pogba.xx := StrToFloat(XX.Text);
  Pogba.yy := StrToFloat(YY.Text);
  Pogba.zz := StrToFloat(ZZ.Text);
  Pogba.ww := StrToFloat(WW.Text);
                          }
  Pogba.Variables:= vals;

  resu := Pogba.Ejecutar();
  Memo.Lines.Add( ' = ' + resu) ;
  Status.Caption:=Pogba.mensaje;
  TableSG.RowCount:= Pogba.XnsList.Count;
  TableSG.Cols[Col_xn].Assign( Pogba.XnsList );
  TableSG.Cols[Col_Err].Assign( Pogba.ErrorList);
  FillStringGrid;

  Pogba.Destroy;
end;
end.

