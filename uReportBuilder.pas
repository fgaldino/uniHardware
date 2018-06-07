unit uReportBuilder;

interface

Uses Winapi.Windows,Classes,System.SysUtils,CodeSiteLogging,
System.StrUtils,vcl.forms,ppComm, ppRelatv, ppProd, ppArchiv;

Type
TReportBuilder = class(TPersistent)
 private
    ppArchiveReader1: TppArchiveReader;
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

{ TReportBuilder }

procedure TReportBuilder.AfterConstruction;
begin
  inherited;
  ppArchiveReader1:= TppArchiveReader.Create(nil);
  ppArchiveReader1.ShowPrintDialog := false;
  ppArchiveReader1.ShowCancelDialog := false;
  ppArchiveReader1.ModalPreview := false;
  ppArchiveReader1.ModalCancelDialog := false;
  ppArchiveReader1.AllowPrintToFile := false;
  ppArchiveReader1.DeviceType := 'Printer';
end;

destructor TReportBuilder.Destroy;
begin
    ppArchiveReader1.Free;
  inherited;
end;

function TReportBuilder.Imprimir: string;
begin
     try
        result := '';
        ppArchiveReader1.ArchiveFileName:= AFileLoad;
        ppArchiveReader1.PrinterSetup.Copies := Copias;

        if (Trim(Impressora)<>'') or EscolherImpressora then
        begin
             ppArchiveReader1.DeviceType := 'Printer';

             if EscolherImpressora then
             begin
                  ppArchiveReader1.ShowPrintDialog := True;
                  ppArchiveReader1.ShowCancelDialog := true;
                  SetWindowPos(Application.MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
                  //Application.MainForm.BringToFront;
                  ppArchiveReader1.Print;
             end else
             begin
                  ppArchiveReader1.PrinterSetup.PrinterName := Impressora;
                  ppArchiveReader1.ShowPrintDialog := false;
                  ppArchiveReader1.ShowCancelDialog := false;
                  ppArchiveReader1.Print;
             end;
        end else
        begin
             ppArchiveReader1.ModalPreview := True;
             ppArchiveReader1.DeviceType := 'Screen';
             ppArchiveReader1.Print;

             SetWindowPos(Application.MainForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
             //Application.MainForm.BringToFront;
        end;
     except
      on E: Exception do
      Begin
        CodeSite.SendException(E);
      End;
     end;
end;

Initialization
 RegisterClass(TReportBuilder);

end.
