unit udmPrincipal;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, CodeSiteLogging,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext, IdHeaderList,
  System.SyncObjs, Winapi.ShellAPI, Winapi.Windows, Vcl.Forms, IdSync,
  Vcl.ExtCtrls, Vcl.Dialogs,uClasseAuxiliar, Vcl.AppEvnts, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TServerStatus = (svDisponivel, svOcupado, svOffline);

type
  TdmPrincipal = class(TDataModule)
    HTTPServer: TIdHTTPServer;
    procedure HTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FServidorStatus : TServerStatus;

    procedure SetServidorStatus(const Value: TServerStatus);
  public
    { Public declarations }
    FLock: TCriticalSection;
    HardwareMD5 : string;

    function ServerStart(var Erro:string):boolean;
    procedure ServerStop;
    function ServerOnLine:Boolean;

    property ServidorStatus : TServerStatus read FServidorStatus write SetServidorStatus;
    //property AFileLoad:string read fAFileLoad write fAFileLoad;
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

uses
  uProcedimentos, ufrmPrincipal;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmPrincipal.DataModuleCreate(Sender: TObject);
begin
  FLock := TCriticalSection.Create;

  HardwareMD5 := aux.MD5_Arquivo(Application.ExeName);
end;

procedure TdmPrincipal.HTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  Procedimento : TProcedimento;
begin
  try
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.CacheControl := 'no-cache';
    AResponseInfo.CustomHeaders.Add('Access-Control-Allow-Origin: *');


    Procedimento := TProcedimento.Create;
    Procedimento.ARequestInfo := ARequestInfo;
    Procedimento.AResponseInfo := AResponseInfo;

    AResponseInfo.ContentText := Procedimento.Resposta;
  finally
    Procedimento.Free;
  end;
end;


function TdmPrincipal.ServerOnLine: Boolean;
begin
     result := HTTPServer.Active;
end;

function TdmPrincipal.ServerStart(var Erro:string):boolean;
begin
     try
        if not HTTPServer.Active then
           HTTPServer.Active := True;
        result :=  HTTPServer.Active;
     except
     on e:exception do
        begin
             erro := e.Message;
             result := false;
        end;
     end;
end;

procedure TdmPrincipal.ServerStop;
begin
     if HTTPServer.Active then
        HTTPServer.Active := False;
end;

procedure TdmPrincipal.SetServidorStatus(const Value: TServerStatus);
begin
  try
    //dmPrincipal.FLock.Enter;

    FServidorStatus := Value;

    if Value = svDisponivel then
    Begin
      frmPrincipal.TrayIcon1.IconIndex := 1;
    End
    else if Value = svOcupado then
    Begin
      frmPrincipal.TrayIcon1.IconIndex := 0;
    End
    else if Value = svOffline then
    Begin
      frmPrincipal.TrayIcon1.IconIndex := 2;
    End;
  finally
    //dmPrincipal.FLock.Leave;
  end;
end;

end.

{  Timer1.Enabled := False;

  //SetActiveWindow(Application.MainForm.Handle);
  SetWindowPos(Application.MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);

  //Visible := False;
  btnIniciar.Click;

  SetWindowPos(Application.MainForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
  Application.MainForm.WindowState := wsMinimized;}
