unit uReportPDF;
{
 Gnostice PDFtoolkit (www.gnostice.com)
}
interface

Uses Winapi.Windows,Classes,System.SysUtils,CodeSiteLogging,
System.StrUtils,vcl.forms,gtPDFPrinter, gtPDFClasses, gtCstPDFDoc,
  gtExPDFDoc, gtExProPDFDoc, gtPDFDoc;

Type
TPrinterPDF = class(TPersistent)
 private
    gtPDFPrinter1: TgtPDFPrinter;
    gtPDFDocument1: TgtPDFDocument;
    fAFileLoad: string;
    fCopias: integer;
    fEscolherImpressora: boolean;
    fImpressora: string;
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

{ TPrinterPDF }

procedure TPrinterPDF.AfterConstruction;
begin
  inherited;
  gtPDFDocument1:= TgtPDFDocument.Create(nil);
  gtPDFDocument1.ShowSetupDialog := false;
  gtPDFDocument1.OpenAfterSave := false;

  gtPDFPrinter1:= TgtPDFPrinter.Create(nil);
  gtPDFPrinter1.PDFDocument := gtPDFDocument1;
  gtPDFPrinter1.IgnoreHardMargin := true;
  gtPDFPrinter1.ShowSetupDialog := false;
end;

destructor TPrinterPDF.Destroy;
begin
    gtPDFPrinter1.Free;
    gtPDFDocument1.Free;
  inherited;
end;

function TPrinterPDF.Imprimir: string;
begin
     try
        result := '';
        gtPDFDocument1.LoadFromFile(AFileLoad);
        if gtPDFDocument1.IsLoaded then
        begin
             gtPDFPrinter1.Copies := Copias;
             if (Trim(Impressora)<>'') or EscolherImpressora then
             begin
                  if EscolherImpressora then
                  begin
                       gtPDFPrinter1.ShowSetupDialog := true;

                       SetWindowPos(Application.MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
                       //Application.MainForm.BringToFront;

                       gtPDFPrinter1.PrintDoc;
                  end else
                  begin
                       gtPDFPrinter1.ShowSetupDialog := false;
                       gtPDFPrinter1.SelectPrinterByName(Impressora);
                       gtPDFPrinter1.PrintDoc;
                  end;
             end else
             begin
                  gtPDFPrinter1.ShowSetupDialog := true;
                  gtPDFDocument1.OpenAfterSave := true;
                  gtPDFPrinter1.PrintDoc;

                  SetWindowPos(Application.MainForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
                  //Application.MainForm.BringToFront;
             end;
        end;
     except
      on E: Exception do
      Begin
        CodeSite.SendException(E);
      End;
     end;
end;

Initialization
 RegisterClass(TPrinterPDF);

end.
