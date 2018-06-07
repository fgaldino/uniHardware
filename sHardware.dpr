program sHardware;

uses
  Vcl.Forms,Registry,Winapi.Windows,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  udmPrincipal in 'udmPrincipal.pas' {dmPrincipal: TDataModule},
  uProcedimentos in 'uProcedimentos.pas',
  uBalanca in 'uBalanca.pas',
  uFastReport in 'uFastReport.pas',
  uClasseAuxiliar in 'uClasseAuxiliar.pas',
  uReportBuilder in 'uReportBuilder.pas',
  uPrintReport in 'uPrintReport.pas',
  uReportPDF in 'uReportPDF.pas',
  uConst in 'uConst.pas';

{$R *.res}
procedure AutoRun;
var
   Reg: TRegistry;
   S: string;
begin
     Try
        Reg := TRegistry.Create;
        S:= ParamStr(0);
        Try
           Reg.rootkey:= HKEY_LOCAL_MACHINE;
           if Reg.Openkey('SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN',false) then
           begin
                Reg.WriteString('HadwareServer',S);
                Reg.closekey;
           end;
        except

        End;
     Finally
        Reg.Free;
     End;
end;
begin
     //coloca o servidor para ser iniciado pelo windows
     {if DebugHook = 0 then
        AutoRun;}

     Application.Initialize;
     Application.MainFormOnTaskbar := true;
     Application.CreateForm(TfrmPrincipal, frmPrincipal);
     Application.CreateForm(TdmPrincipal, dmPrincipal);
     Application.Showmainform := false;
     Application.Title := cons.TituloSistema;
     Application.Run;
end.
