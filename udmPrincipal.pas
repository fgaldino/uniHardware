unit udmPrincipal;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, CodeSiteLogging,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext, IdHeaderList,
  System.SyncObjs, Winapi.ShellAPI, Winapi.Windows, Vcl.Forms, IdSync,
  Vcl.ExtCtrls, Vcl.Dialogs,uClasseAuxiliar, Vcl.AppEvnts, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TdmPrincipal = class(TDataModule)
    HTTPServer: TIdHTTPServer;
    procedure HTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FLock: TCriticalSection;
    HardwareMD5 : string;

    function ServerStart(var Erro:string):boolean;
    procedure ServerStop;
    function ServerOnLine:Boolean;
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

uses
  uProcedimentos;

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

end.

{  Timer1.Enabled := False;

  //SetActiveWindow(Application.MainForm.Handle);
  SetWindowPos(Application.MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);

  //Visible := False;
  btnIniciar.Click;

  SetWindowPos(Application.MainForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
  Application.MainForm.WindowState := wsMinimized;}
