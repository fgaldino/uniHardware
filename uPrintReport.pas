unit uPrintReport;

interface

Uses Winapi.Windows,Classes,System.TypInfo,System.SysUtils,System.JSON,CodeSiteLogging,IdCustomHTTPServer,
System.StrUtils,Printers,vcl.forms,uClasseAuxiliar;

Type
TPrinterReport = class(TPersistent)
 private
    Impressora:string;
    Copias:integer;
    EscolherImpressora:boolean;
    fAFileLoad: string;
    fARequestInfo: TIdHTTPRequestInfo;
    fRemoverAfterPrint: boolean;
    function PrinterDefault:String;
    function PrinterReport(AClasse:string):string;
 public
 procedure AfterConstruction; override;
 destructor Destroy; Override;
 published
   property RemoverAfterPrint:boolean read fRemoverAfterPrint write fRemoverAfterPrint;
   property ARequestInfo : TIdHTTPRequestInfo read fARequestInfo write fARequestInfo;
   property AFileLoad:string read fAFileLoad write fAFileLoad;
   function Imprimir:string;
end;

Type printerreport = class(TPrinterReport);

implementation

{ TPrinterReport }

procedure TPrinterReport.AfterConstruction;
begin
  inherited;
  Copias := 1;
  Impressora := '';
  EscolherImpressora := false;
  RemoverAfterPrint := True;
end;

destructor TPrinterReport.Destroy;
begin
  inherited;
end;

function TPrinterReport.Imprimir: string;
begin
     result := '';
     if FileExists(AFileLoad) then
     try
        try
           if ARequestInfo <> nil then
           Try
              CodeSite.Send('ARequestInfo.Params.Values[''escolher''] : ' + ARequestInfo.Params.Values['escolher']);

              Impressora := AnsiLowerCase(ARequestInfo.Params.Values['impressora']);
              EscolherImpressora := sametext(ARequestInfo.Params.Values['escolher'], 'true');
              Copias := ARequestInfo.Params.Values['copias'].ToInteger;
           except
              Copias := 1;
           End;

           CodeSite.Send('Impressora : ' + Impressora);
           CodeSite.Send('Copias : ' + Copias.ToString);
           CodeSite.Send('EscolherImpressora : ' + IfThen(EscolherImpressora, 'True', 'False'));

           //if Not EscolherImpressora and (Impressora = '') then
           if Not EscolherImpressora and (Impressora = 'default') then
              Impressora := PrinterDefault;

           if sametext(ExtractFileExt(AFileLoad),'.fp3') then
              result := PrinterReport('TFastReport') else
           if sametext(ExtractFileExt(AFileLoad),'.raf') then
              result := PrinterReport('TReportBuilder') else
           if sametext(ExtractFileExt(AFileLoad),'.pdf') then
              result := PrinterReport('TPrinterPDF');
        except
         on E: Exception do
         Begin
           CodeSite.SendException(E);
         End;
        end;
     finally
        if RemoverAfterPrint then
           DeleteFile(AFileLoad);
     end;
end;

function TPrinterReport.PrinterDefault: String;
begin
     result := '';
     if Printer.Printers.Count > 0 then
         Result := Printer.Printers[Printer.PrinterIndex];
end;

function TPrinterReport.PrinterReport(AClasse:string): string;
var AObj:TObject;
begin
     Try
        AObj := aux.CreateObj(AClasse);
        if AObj <> nil then
        begin
             Aux.SetValue(AObj,'Impressora',Impressora);
             Aux.SetValue(AObj,'Copias',Copias);
             Aux.SetValue(AObj,'EscolherImpressora',EscolherImpressora);
             Aux.SetValue(AObj,'AFileLoad',AFileLoad);
             result := aux.MethodString(AObj,'imprimir');
        end;
     Finally
        if AObj <> nil then
           AObj.Free;
     End;

end;

Initialization
 RegisterClass(TPrinterReport);

end.
