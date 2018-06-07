unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, System.StrUtils,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, CodeSiteLogging, System.JSON,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniButton,
  uniMultiItem, uniListBox, uniTimer, uniLabel, uniGroupBox, uniComboBox,
  uniPanel, uniPageControl;

type
  TMainForm = class(TUniForm)
    UniListBox1: TUniListBox;
    tmrVerificaHardwareServer: TUniTimer;
    lblStatus: TUniLabel;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniTabSheet3: TUniTabSheet;
    UniGroupBox1: TUniGroupBox;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    UniLabel4: TUniLabel;
    UniLabel5: TUniLabel;
    cbModelo: TUniComboBox;
    cbBaudrate: TUniComboBox;
    cbdatabits: TUniComboBox;
    cbparity: TUniComboBox;
    cbstopbits: TUniComboBox;
    UniLabel6: TUniLabel;
    cbPorta: TUniComboBox;
    UniLabel7: TUniLabel;
    cbhandsharing: TUniComboBox;
    UniButton4: TUniButton;
    btnFRImprimirDireto: TUniButton;
    UniButton6: TUniButton;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    btnFRVisualizar: TUniButton;
    procedure UniButton1Click(Sender: TObject);
    procedure UniButton2Click(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure btnFRImprimirDiretoClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    function uniHardwareVerificaStatus(StrJson : string) : Boolean;

    function RespostaBalanca(StrJson:string):boolean;

    procedure tmrVerificaHardwareServerTimer(Sender: TObject);
    procedure UniButton4Click(Sender: TObject);
    procedure UniButton6Click(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure btnFRVisualizarClick(Sender: TObject);
  private
    { Private declarations }
    HardwareServerOnline : Boolean;

  public
    { Public declarations }

  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, udmRelatorios, ServerModule;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

function TMainForm.RespostaBalanca(StrJson: string): boolean;
var
  jsObject : TJSONObject;
  Status : String;
Begin
  try
    try
      CodeSite.Send('RespostaBalança');
      CodeSite.Send('JsonString : ' + StrJson);

      jsObject := TJSONObject.ParseJSONValue(StrJson) as TJSONObject;

      Status := jsObject.GetValue('status').Value;

      CodeSite.Send('status : ' + jsObject.GetValue('status').Value);
      CodeSite.Send('msg : ' + jsObject.GetValue('msg').Value);
      CodeSite.Send('');

      if sametext(Status,'true') then
         UniListBox1.Items.Add('Peso Lido: '+jsObject.GetValue('msg').Value) else
         UniListBox1.Items.Add('Falha Leitura:'+jsObject.GetValue('msg').Value);
    except
      on E: Exception do
      Begin
          result := false;
          CodeSite.SendException(E);
      End;
    end;
  finally
    jsObject.Free;
  end;
end;

procedure TMainForm.tmrVerificaHardwareServerTimer(Sender: TObject);
begin
  tmrVerificaHardwareServer.Enabled := False;
  UniSession.AddJS('uniHardwareStatus();');
end;

procedure TMainForm.UniButton1Click(Sender: TObject);
begin
  UniSession.AddJS('SolicitaGet();');
end;

procedure TMainForm.UniButton2Click(Sender: TObject);
begin
  UniSession.AddJS('SolicitaPost();');
end;

procedure TMainForm.btnFRImprimirDiretoClick(Sender: TObject);
Var
  dm : TdmRelatorios;
  ArquivoFR3, RelatorioURL : string;
begin
  dm := nil;

  try
    try
      dm := TdmRelatorios.Create(UniMainModule);
      dm.frxReport1.DataSets.Clear;

      ArquivoFR3 := UniServerModule.StartPath + 'files\relatorio.fr3';

      {CodeSite.Send('ArquivoFR3: ' + ArquivoFR3);
      CodeSite.Send('ArquivoFR3: ' + IfThen(FileExists(ArquivoFR3), 'Existe', 'Não Existe'));
      CodeSite.Send('');}



      if dm.ExportaFP3(ArquivoFR3, RelatorioURL) then
      Begin
        UniSession.AddJS('RelatorioShowFP3(' + QuotedStr(RelatorioURL)+','+QuotedStr('default')+',1,'+QuotedStr('true')+ ')');
      End else
        ShowMessage('Erro');
    except
      on E: Exception do
      Begin
        MessageDlg(E.Message, mtWarning, [mbOK]);
      End;
    end;
  finally
    dm.Free;
  end;
end;

procedure TMainForm.UniButton4Click(Sender: TObject);
begin
     UniSession.AddJS('LeituraBalanca(' +
     QuotedStr(cbModelo.Text)+','+
     QuotedStr(cbPorta.Text)+','+
     QuotedStr(cbBaudrate.Text)+','+
     QuotedStr(cbdatabits.Text)+','+
     QuotedStr(cbparity.Text)+','+
     QuotedStr(cbstopbits.Text)+','+
     QuotedStr(cbhandsharing.Text)+')');
end;

procedure TMainForm.btnFRVisualizarClick(Sender: TObject);
Var
  dm : TdmRelatorios;
  ArquivoFR3, RelatorioURL : string;
begin
  dm := nil;

  try
    try
      dm := TdmRelatorios.Create(UniMainModule);
      dm.frxReport1.DataSets.Clear;

      ArquivoFR3 := UniServerModule.StartPath + 'files\relatorio.fr3';

      {CodeSite.Send('ArquivoFR3: ' + ArquivoFR3);
      CodeSite.Send('ArquivoFR3: ' + IfThen(FileExists(ArquivoFR3), 'Existe', 'Não Existe'));
      CodeSite.Send('');}



      if dm.ExportaFP3(ArquivoFR3, RelatorioURL) then
      Begin
        CodeSite.Clear;
        //CodeSite.Send('RelatorioShowFP3(' + QuotedStr(RelatorioURL)+', '''', 0, ' + QuotedStr('false') + ')');

        UniSession.AddJS('RelatorioShowFP3(' + QuotedStr(RelatorioURL)+', '''', 0, ' + QuotedStr('false') + ')');
      End else
        ShowMessage('Erro');
    except
      on E: Exception do
      Begin
        MessageDlg(E.Message, mtWarning, [mbOK]);
      End;
    end;
  finally
    dm.Free;
  end;
end;

procedure TMainForm.UniButton6Click(Sender: TObject);
Var
  dm : TdmRelatorios;
  ArquivoFR3, RelatorioURL : string;
begin
  dm := nil;

  try
    try
      dm := TdmRelatorios.Create(UniMainModule);
      dm.frxReport1.DataSets.Clear;

      ArquivoFR3 := UniServerModule.StartPath + 'files\relatorio.fr3';

      CodeSite.Send('ArquivoFR3: ' + ArquivoFR3);
      CodeSite.Send('ArquivoFR3: ' + IfThen(FileExists(ArquivoFR3), 'Existe', 'Não Existe'));
      CodeSite.Send('');



      if dm.ExportaFP3(ArquivoFR3, RelatorioURL) then
      Begin
        UniSession.AddJS('SalvarFile('+QuotedStr(RelatorioURL)+','+QuotedStr('teste.fr3')+','+QuotedStr('c:/temp')+','+QuotedStr('false')+')');
      End else
      ShowMessage('Erro');
    except
      on E: Exception do
      Begin
        MessageDlg(E.Message, mtWarning, [mbOK]);
      End;
    end;
  finally
    dm.Free;
  end;

end;

procedure TMainForm.UniFormAjaxEvent(Sender: TComponent; EventName: string;Params: TUniStrings);
var i:integer;
begin
//  CodeSite.Send('');
//  CodeSite.Send(EventName);

  {$REGION 'uniHardwareStatus'}
  if sametext(EventName,'uniHardwareStatus') then
  Begin
    uniHardwareVerificaStatus(Params.Values['data']);
  End;
  {$ENDREGION}


  if sametext(EventName,'RetornoGET') then
  Begin
    CodeSite.Send('RetornoGET');
    CodeSite.Send('data : ' + Params.Values['data']);
  End
  else if sametext(EventName,'RetornoPOST') then
  Begin
    CodeSite.Send('RetornoPOST');
    CodeSite.Send('data : ' + Params.Values['data']);
    UniListBox1.Items.Add(Params.Values['data']);
  End
  else if sametext(EventName,'RetornoBalanca') then
  begin
       CodeSite.Send('RetornoBalanca');
       CodeSite.Send('data : ' + Params.Values['data']);
       RespostaBalanca(Params.Values['data']);
  end;
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
  HardwareServerOnline := false;
end;


procedure TMainForm.UniFormShow(Sender: TObject);
begin
     UniSession.AddJS('uniHardwareStatus();');
end;

function TMainForm.uniHardwareVerificaStatus(StrJson : string) : Boolean;
var
  jsObject : TJSONObject;
  Status : String;
Begin
  try
    try
//      CodeSite.Send('uniHardwareVerificaStatus');
//      CodeSite.Send('JsonString : ' + StrJson);

      jsObject := TJSONObject.ParseJSONValue(StrJson) as TJSONObject;

      Status := jsObject.GetValue('status').Value;

      //CodeSite.Send('md5 : ' + jsObject.GetValue('md5').Value);
      //CodeSite.Send('status : ' + jsObject.GetValue('status').Value);
      //CodeSite.Send('ocupado : ' + jsObject.GetValue('ocupado').Value);
      //CodeSite.Send('');

      if sametext(Status,'true') then
      Begin
        if Not HardwareServerOnline then
        Begin
          HardwareServerOnline := True;

          //Notifica que ficou online
          //UniListBox1.Items.Add('HardwareServer Online');
          lblStatus.Caption := 'HardwareServer Online';
          lblStatus.Font.Color := clGreen;
        End;
      End
      else
      Begin
        if HardwareServerOnline then
        Begin
          HardwareServerOnline := False;

          //Notifica que ficou offline
          //UniListBox1.Items.Add('HardwareServer Offline');
          lblStatus.Caption := 'HardwareServer OffLine';
          lblStatus.Font.Color := clRed;
        End;
      End;
    except
      on E: Exception do
      Begin
        CodeSite.SendException(E);
      End;
    end;
  finally
    jsObject.Free;

    tmrVerificaHardwareServer.Enabled := True;
  end;
End;

initialization
  RegisterAppFormClass(TMainForm);

end.
