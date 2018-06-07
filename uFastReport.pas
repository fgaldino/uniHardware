unit uFastReport;

interface

Uses Winapi.Windows,Classes,System.TypInfo,System.SysUtils,System.JSON,CodeSiteLogging,
  System.StrUtils,frxClass, frxDMPExport, frxEngine, idsync,
  frxChBox, frxCross, frxChart, frxGradient, frxOLE, frxRich, frxBarcode,
  frxDesgn,vcl.forms;

Type
TFastReport = class(TPersistent)
 private
    frxDesigner1: TfrxDesigner;
    frxReport1: TfrxReport;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxRichObject1: TfrxRichObject;
    frxOLEObject1: TfrxOLEObject;
    frxGradientObject1: TfrxGradientObject;
    frxChartObject1: TfrxChartObject;
    frxCrossObject1: TfrxCrossObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    fAFileLoad: string;
    fCopias: integer;
    fEscolherImpressora: boolean;
    fImpressora: string;

    procedure ImprimirExec;
 public
 procedure AfterConstruction; override;
 destructor Destroy; Override;
 published
   property AFileLoad:string read fAFileLoad write fAFileLoad;
   property Impressora:string read fImpressora write fImpressora;
   property Copias:integer read fCopias write fCopias;
   property EscolherImpressora:boolean read fEscolherImpressora write fEscolherImpressora;

   function Imprimir:string;

end;

implementation

uses
  ufrmPrincipal;

{ TFastReport }

procedure TFastReport.AfterConstruction;
begin
  inherited;
  frxDesigner1:= TfrxDesigner.Create(frmPrincipal);
  frxReport1:= TfrxReport.Create(frmPrincipal);
  frxBarCodeObject1:= TfrxBarCodeObject.Create(frmPrincipal);
  frxRichObject1:= TfrxRichObject.Create(frmPrincipal);
  frxOLEObject1:=TfrxOLEObject.Create(frmPrincipal);
  frxGradientObject1:= TfrxGradientObject.Create(frmPrincipal);
  frxChartObject1:= TfrxChartObject.Create(frmPrincipal);
  frxCrossObject1:= TfrxCrossObject.Create(frmPrincipal);
  frxCheckBoxObject1:= TfrxCheckBoxObject.Create(frmPrincipal);
  frxDotMatrixExport1:= TfrxDotMatrixExport.Create(frmPrincipal);

  frxReport1.EngineOptions.ConvertNulls := True;
  frxReport1.EngineOptions.IgnoreDevByZero := true;
  frxReport1.PrintOptions.ShowDialog := true;
  frxReport1.ShowProgress := true;
end;

destructor TFastReport.Destroy;
begin
    frxDesigner1.free;
    frxReport1.free;
    frxBarCodeObject1.free;
    frxRichObject1.free;
    frxOLEObject1.free;
    frxGradientObject1.free;
    frxChartObject1.free;
    frxCrossObject1.free;
    frxCheckBoxObject1.free;
    frxDotMatrixExport1.free;
  inherited;
end;

function TFastReport.Imprimir: string;
begin
  Tidsync.SynchronizeMethod(ImprimirExec);
end;

procedure TFastReport.ImprimirExec;
begin
  try
    frmPrincipal.Show;
    frmPrincipal.Left := -1000;

    try
      frxReport1.PreviewPages.LoadFromFile(AFileLoad);
      frxReport1.PrintOptions.Copies := Copias;


      if (Trim(Impressora) <> '') or EscolherImpressora then
      begin
        if EscolherImpressora then
        begin
          frxReport1.PrintOptions.ShowDialog := True;
          //SetWindowPos(Application.MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
          //Application.MainForm.BringToFront;
          frxReport1.PreviewPages.Print;
        end
        else
        begin
          frxReport1.PrintOptions.Printer := Impressora;
          frxReport1.PrintOptions.ShowDialog := false;
          frxReport1.PreviewPages.Print;
        end;
      end
      else
      begin
        frxReport1.ShowPreparedReport;
        //Tidsync.SynchronizeMethod(TesteX);
      end;
    except
      on E: Exception do
      Begin
      CodeSite.SendException(E);
      End;
    end;
  finally
    frmPrincipal.Hide;
  end;
end;



Initialization
 RegisterClass(TFastReport);

end.
