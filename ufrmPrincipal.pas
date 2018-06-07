unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, PsAPI,
  TlHelp32,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.SyncObjs, CodeSiteLogging,
  uClasseAuxiliar, System.ImageList, Vcl.ImgList,uConst, Vcl.Menus, Vcl.AppEvnts;

type
  TfrmPrincipal = class(TForm)
    Timer1: TTimer;
    ImageList1: TImageList;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    IniciarPlugin1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    PararPlugin1: TMenuItem;
    tmrForms: TTimer;
    procedure IniciarPlugin1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure PararPlugin1Click(Sender: TObject);
    procedure tmrFormsTimer(Sender: TObject);
  private
    { Private declarations }
    procedure BalloonInfo(Flags:TBalloonFlags;Title,Texto:string);
  public
    { Public declarations }
    function IniciarServidor:boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  udmPrincipal;

{$R *.dfm}

procedure TfrmPrincipal.ApplicationEvents1Minimize(Sender: TObject);
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  //TrayIcon1.Animate := True;
end;

procedure TfrmPrincipal.BalloonInfo(Flags: TBalloonFlags; Title, Texto: string);
begin
  TrayIcon1.BalloonTitle := '';//Title;
  TrayIcon1.BalloonFlags := Flags;
  TrayIcon1.BalloonHint := Texto;
  TrayIcon1.ShowBalloonHint;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  //Necessario para ocultar o formulario na hora da impressão
  frmPrincipal.Left := -1000;
  Application.ProcessMessages;

  {$REGION 'Bloco Necessario para que a Primeira Impressão receba Foco.'}
  frmPrincipal.Show;
  Application.ProcessMessages;
  frmPrincipal.Hide;
  {$ENDREGION}


  TrayIcon1.Hint := cons.TituloSistema;
end;

procedure TfrmPrincipal.IniciarPlugin1Click(Sender: TObject);
begin
  IniciarServidor;
end;

function TfrmPrincipal.IniciarServidor:boolean;
var erro:string;
begin
    result := dmPrincipal.ServerStart(erro);
    if not result then
        BalloonInfo(bfError,cons.TituloSistema,cons.FalhaStartServer) else
    begin
         TrayIcon1.IconIndex := 1;

         IniciarPlugin1.Enabled := false;
         PararPlugin1.Enabled := true;
         BalloonInfo(bfNone,cons.TituloSistema,cons.SucessStartSever);
    end;
end;

procedure TfrmPrincipal.PararPlugin1Click(Sender: TObject);
begin
  try
    try
      dmPrincipal.ServerStop;
      TrayIcon1.IconIndex := 2;
    except
    end;
  finally
    if not dmPrincipal.ServerOnLine then
    begin
      IniciarPlugin1.Enabled := true;
      PararPlugin1.Enabled := false;
      BalloonInfo(bfNone,cons.TituloSistema,cons.StopServer);
    end;
  end;
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  try
    Timer1.Enabled := False;

    IniciarServidor;
  finally
    if Not dmPrincipal.ServerOnLine then
    begin
      Timer1.Interval := 10000;
      Timer1.Enabled := true;
    end;
  end;
end;




procedure TfrmPrincipal.tmrFormsTimer(Sender: TObject);
Var
  i : Integer;
begin


//  for i := 0 to Screen.FormCount - 1 do
//  begin
//    CodeSite.Send('');
//    CodeSite.Send('Screen.Forms[i].Name : ' + Screen.Forms[i].Name);
//
//    if Screen.Forms[i].Name = 'frxPrintDialog' then
//    Begin
//      CodeSite.Send('Focus frxPrintDialog');
//      //SetForegroundWindow(frmPrincipal.Handle);
//      SetForegroundWindow(Screen.Forms[i].Handle);
//    End
//    else
//    Begin
//      if Screen.Forms[i].Name = 'frxPreviewForm' then
//      Begin
//        CodeSite.Send('Focus frxPreviewForm');
//        //SetForegroundWindow(frmPrincipal.Handle);
//        SetForegroundWindow(Screen.Forms[i].Handle);
//      End;
//    End;
//  end;
//
//  CodeSite.Send('');
end;

procedure TfrmPrincipal.TrayIcon1Click(Sender: TObject);
begin
     TrayIcon1.BalloonTitle := '';
     if not dmPrincipal.ServerOnLine then
        TrayIcon1.BalloonHint := cons.TituloSistema+' OffLine' else
     TrayIcon1.BalloonHint := cons.TituloSistema+' OnLine';
     TrayIcon1.BalloonFlags := bfNone;
     TrayIcon1.ShowBalloonHint;
end;

{function GetTitleOfActiveWindow: string;
var
  AHandle: THandle;
  ATitle: string;
  ALen: Integer;
begin
  Result := '';
  AHandle := GetForegroundWindow;

  if AHandle <> 0 then begin
    ALen := GetWindowTextLength(AHandle) + 1;
    SetLength(ATitle, ALen);
    GetWindowText(AHandle, PChar(ATitle), ALen);
    result := Trim(ATitle);
  end;
end;}

end.
