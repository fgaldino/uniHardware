unit uProcedimentos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,CodeSiteLogging,
  IdCustomHTTPServer, IdHTTP, System.JSON,system.TypInfo,uClasseAuxiliar;

  type
    TProcedimento = class(TObject)
  private
    RequestInfo: TIdHTTPRequestInfo;
    ResponseInfo : TIdHTTPResponseInfo;
    procedure DoProc;

    function ExecuteStatus : string;
    procedure ExecFastReport;
    function SalvarFile:string;
    function EscutarBalanca:string;
  protected
  public
    constructor Create();
    destructor Destroy; override;

    property ARequestInfo : TIdHTTPRequestInfo read RequestInfo write RequestInfo;
    property AResponseInfo : TIdHTTPResponseInfo read ResponseInfo write ResponseInfo;

    function Resposta : String;
  end;

implementation

uses
  udmPrincipal;

{ TProcedimento }

constructor TProcedimento.Create;
begin
  inherited;
end;

destructor TProcedimento.Destroy;
begin
  inherited;
end;

procedure TProcedimento.DoProc;
begin
  //ShowMessage('ok');
end;

function TProcedimento.Resposta: String;
var
  Acao, ArquivoLocalFP3 : string;
begin
     Acao := AnsiLowerCase(ARequestInfo.Params.Values['acao']);

     if ARequestInfo.Command = 'GET' then
     Begin
         Result := aux.JsonStatus(aux.iff(sametext(acao,'status'),true,false),
         aux.iff(sametext(acao,'status'),'online','offline'));
     End
     else if ARequestInfo.Command = 'POST' then
     Begin
          if Acao = 'fp3' then
             ExecFastReport else
          if Acao = 'lerbalanca' then
             result := EscutarBalanca else
          if acao='salvarfile' then
             result := SalvarFile
          else
             Result :=  aux.ExecuteNaoPrevisto(ARequestInfo);
     End
     else
       Result := 'Acesso Negado!';
end;

function TProcedimento.SalvarFile:string;
Var
  AFileLocal, AUrl,ADir : string;
  AFalhar:boolean;
begin
  try
     dmPrincipal.FLock.Enter;
     Try
        result := aux.JsonStatus(false,'');
        AUrl := ARequestInfo.Params.Values['url'];
        AFileLocal := ARequestInfo.Params.Values['filename'];
        ADir := StringReplace(ARequestInfo.Params.Values['dir'],'/','\',[rfReplaceAll]);
        AFalhar := sametext(ARequestInfo.Params.Values['dir'],'falharexistir');
        if ADir <> '' then
           ForceDirectories(ADir);

        CodeSite.Send('FIle : ' + AUrl);
        CodeSite.Send('FileLocal:' + IncludeTrailingPathDelimiter(ADir)+AFileLocal);

        if AFalhar then
        begin
             if FileExists(IncludeTrailingPathDelimiter(ADir)+AFileLocal) then
             begin
                  result := aux.JsonStatus(false,'Arquivo já existente no diretório');
                  exit;
             end;
        end;
        if aux.DownloadHTTP(AUrl,IncludeTrailingPathDelimiter(ADir)+AFileLocal) then
           result := aux.JsonStatus(true,'Arquivo salvo com sucesso');
     except
     on e:exception do
        begin
             result := aux.JsonStatus(false,e.Message);
        end;
     End;
  finally
    dmPrincipal.FLock.Leave;
  end;

end;

function TProcedimento.EscutarBalanca:string;
var AObj:TObject;
begin
     Try
        dmPrincipal.FLock.Enter;
        Try
           result := aux.JsonStatus(false,'Sem comunicação');
           AObj := aux.CreateObj('TBalanca');
           if AObj <> nil then
           begin
                aux.SetObject(AObj,'ARequestInfo',ARequestInfo);
                result := aux.MethodString(AObj,'LerPesoBalanca');
           end;
        except
         on e:exception do
            begin
                 CodeSite.SendException(e);
                 aux.JsonStatus(false,e.Message);
            end;
        End;
     Finally
        if AObj <> nil then
           AObj.Free;
        dmPrincipal.FLock.Leave;
     End;
end;

procedure TProcedimento.ExecFastReport;
Var
  ArquivoLocal, Url : string;
  Aobj :Tobject;
  ExtArq:string;
begin
  try
    dmPrincipal.FLock.Enter;

    Url := ARequestInfo.Params.Values['url'];
    ExtArq := ExtractFileExt(Url);

    ArquivoLocal := ExtractFilePath(Application.ExeName) + 'tmp\' + aux.GeraSenha(20) + ExtArq;
    ForceDirectories(ExtractFilePath(ArquivoLocal));

    CodeSite.Send('Url : ' + Url);
    CodeSite.Send('ArquivoLocal : ' + ArquivoLocal);

    if aux.DownloadHTTP(Url, ArquivoLocal) then
    begin
         Try
            Try
               CodeSite.Send('Download Concluido');
               AObj := aux.CreateObj('TPrinterReport');
               if AObj <> nil then
               begin
                    aux.SetObject(AObj,'ARequestInfo',ARequestInfo);
                    aux.SetValue(Aobj,'AFileLoad',ArquivoLocal);
                    aux.MethodString(AObj,'Imprimir');
               end;
            except
             on e:exception do
                CodeSite.SendException(e);
            End;
         Finally
            if AObj <> nil then
               AObj.Free;
         End;
    end;
  finally
    dmPrincipal.FLock.Leave;
  end;
end;

function TProcedimento.ExecuteStatus : string;
var LJsonObject: TJSONObject;
begin
  try
    try
      LJsonObject := TJSONObject.Create;

      LJsonObject.AddPair(TJSONPair.Create('md5', dmPrincipal.HardwareMD5));
      LJsonObject.AddPair(TJSONPair.Create('status', 'online'));
      LJsonObject.AddPair(TJSONPair.Create('ocupado', 'false'));

      Result := LJsonObject.ToString;
    except
      on E: Exception do
      Begin
        CodeSite.SendException(E);
      End;
    end;
  finally
    LJsonObject.Free;
  end;
end;


end.
