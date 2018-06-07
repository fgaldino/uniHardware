unit udmRelatorios;

interface

uses
  SysUtils, Classes, frxDesgn, frxDCtrl, frxDMPExport, frxGradient, frxOLE,
  frxRich, frxChart, frxExportCSV, frxExportText, frxExportImage, CodeSiteLogging,
  frxExportHTMLDiv, frxExportDOCX, frxExportXML, frxExportXLS, frxClass,
  frxExportPDF, uniGUIApplication;

type
  TdmRelatorios = class(TDataModule)
    frxReport1: TfrxReport;
    frxPDFExport1: TfrxPDFExport;
    frxXLSExport1: TfrxXLSExport;
    frxXMLExport1: TfrxXMLExport;
    frxDOCXExport1: TfrxDOCXExport;
    frxHTML5DivExport1: TfrxHTML5DivExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxCSVExport1: TfrxCSVExport;
    frxChartObject1: TfrxChartObject;
    frxRichObject1: TfrxRichObject;
    frxOLEObject1: TfrxOLEObject;
    frxGradientObject1: TfrxGradientObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxDialogControls1: TfrxDialogControls;
    frxDesigner1: TfrxDesigner;
  private
    { Private declarations }
  public
    { Public declarations }
    function ExportaFP3(ArquivoFR3 : string; Var RelatorioURL : string) : Boolean;
  end;

function dmRelatorios: TdmRelatorios;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, ServerModule;

function dmRelatorios: TdmRelatorios;
begin
  Result := TdmRelatorios(UniMainModule.GetModuleInstance(TdmRelatorios));
end;

{ TdmRelatorios }

function TdmRelatorios.ExportaFP3(ArquivoFR3: string;
  var RelatorioURL: string): Boolean;
Var
  ArquivoFP3Destino, ArquivoNome : string;
begin
  try
    try
      {$REGION 'Verificando e Carregando Arquivo FR3'}
      if Not FileExists(ArquivoFR3) then
        raise Exception.Create('Não foi possível encontrar o modelo de relatório desejado!' + #13#10 + 'Favor contacte o suporte técnico.');

      frxReport1.LoadFromFile(ArquivoFR3);
      {$ENDREGION}

      {$REGION 'Calculando Diretorio e Nome do Arquivo PDF'}
      ArquivoNome := FormatDateTime('yyyy-mm-dd_HH-MM-SS-ZZZ', Now) + '.fp3';
      ArquivoFP3Destino := UniServerModule.LocalCachePath + 'fp3\' + ArquivoNome;
      ForceDirectories(ExtractFilePath(ArquivoFP3Destino));
      {$ENDREGION}

      frxReport1.PrepareReport(True);
      frxReport1.PreviewPages.SaveToFile(ArquivoFP3Destino);


      RelatorioURL := 'http://' + UniSession.Host + UniServerModule.LocalCacheURL + 'fp3/' + ArquivoNome;

      {$REGION 'CodeSite - Debug'}
      {$IFDEF DEBUG}
      {try
        CodeSite.EnterMethod('TdmRelatorios.ExportaFP3');
        CodeSite.Send('ArquivoDiretorio: ' + UniServerModule.LocalCachePath + 'fp3\');
        CodeSite.Send('ArquivoNome: ' + ArquivoNome);
        CodeSite.Send('ArquivoFP3Destino: ' + ArquivoFP3Destino);

        CodeSite.Send('RelatorioURL: ' + RelatorioURL);
      finally
        CodeSite.ExitMethod('TdmRelatorios.ExportaFP3');
      end;}
      {$ENDIF}
      {$ENDREGION}

      Result := True;
    except
      on E: Exception do
      Begin
        Result := False;
        raise Exception.Create(E.Message);
      End;
    end;
  finally
  end;
end;

initialization
  RegisterModuleClass(TdmRelatorios);

end.
