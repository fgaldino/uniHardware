unit uClasseAuxiliar;

interface

Uses Classes,System.JSON,system.TypInfo,Variants,System.SysUtils,
CodeSiteLogging,IdCustomHTTPServer,IdHTTP,IdHashMessageDigest,forms;

Type TAuxilio = class
private
public
class function JsonStatus(AStatus:boolean;AMessage:string):string;
class procedure SetObject(const AInstance:TObject;AProp:string;AObject:TObject);
class procedure SetValue(const AInstance:TObject;AProp:string;AValue:variant);
class function GetObject(const AInstance:TObject;AProp:string):TObject;
class function GetValue(const AInstance:TObject;AProp:string;ADefault:variant):Variant;
class function MethodBoolean(const AInstance:TObject; AMethodName: string):Boolean;
class function MethodString(const AInstance:TObject; AMethodName: string):string;
class function CreateObj(AClass:string):TObject;
class function DownloadHTTP(Url, Destino : string): Boolean;
class procedure IdHttpDefineHeaders(_HTTP : TIdHTTP);
class function GeraSenha(aQuant : Integer) : String;
class function MD5_String(const texto:string):string;
class function MD5_Arquivo(const fileName : string) : string;
class function Iff(Condicao: Boolean; ResultTrue, ResultFalse: Variant): Variant;
class function ExecuteNaoPrevisto(ARequestInfo:TIdHTTPRequestInfo) : string;
end;

Type Aux = class(TAuxilio);

implementation

{ TAuxilio }

class function TAuxilio.CreateObj(AClass: string): TObject;
var PercClasse:TPersistentClass;
begin
     Try
        result := nil;
        PercClasse := GetClass(AClass);
        if PercClasse = nil then
           exit;
        result:= PercClasse.Create;
     except
     on e:exception do
        CodeSite.SendException(e);
     End;
end;

class function TAuxilio.DownloadHTTP(Url, Destino: string): Boolean;
var
  fileDownload : TFileStream;
  _http : TIdHTTP;
begin
  try
    try
       result := false;
      _http := TIdHTTP.Create(Application);
      fileDownload := TFileStream.Create(Destino, fmCreate);


      IdHttpDefineHeaders(_http);

      _http.Get(URL, fileDownload);

      Result := True;
    except
      on E:Exception do
      begin
        Result := False;

        if E.Message <> 'Floating point division by zero' then
          CodeSite.SendException(E);
      end;
    end;
  finally
    FreeAndNil(_http);
    FreeAndNil(fileDownload);
  end;

end;

class function TAuxilio.ExecuteNaoPrevisto(ARequestInfo:TIdHTTPRequestInfo): string;
begin
  Result := '<html><head><title>Response</title></head>' +
  '<body>Command: ' + ARequestInfo.Command +
  '<br />Host: ' + ARequestInfo.Host +
  '<br />URI: ' + ARequestInfo.URI +
  '<br />UserAgent: ' + ARequestInfo.UserAgent +
  '</body></html>';
end;

class function TAuxilio.GeraSenha(aQuant: Integer): String;
var
  str: string;
begin
  Randomize;
  str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = aQuant)
end;

class function TAuxilio.GetObject(const AInstance: TObject;
  AProp: string): TObject;
begin
     result := nil;
     if AInstance <> nil then
     begin
          if IsPublishedProp(AInstance,AProp) then
             result := GetObjectProp(AInstance,AProp);
     end;
end;

class function TAuxilio.GetValue(const AInstance: TObject; AProp: string;
  ADefault: variant): Variant;
begin
     result := ADefault;
     if AInstance <> nil then
     begin
          if IsPublishedProp(AInstance,AProp) then
             result := GetPropValue(AInstance,AProp);
     end;
end;

class procedure TAuxilio.IdHttpDefineHeaders(_HTTP: TIdHTTP);
begin
  _HTTP.Request.Accept := 'Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*';
  _HTTP.Request.AcceptLanguage := 'pt-br';
  _HTTP.Request.ProxyConnection := 'Keep-Alive';
  _HTTP.Request.UserAgent:='Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)';
end;

class function TAuxilio.Iff(Condicao: Boolean; ResultTrue,
  ResultFalse: Variant): Variant;
begin
     if Condicao then
        Result := ResultTrue else Result := ResultFalse;
end;

class function TAuxilio.JsonStatus(AStatus: boolean; AMessage: string): string;
var LJsonObject: TJSONObject;
begin
  try
    try
      LJsonObject := TJSONObject.Create;
      LJsonObject.AddPair(TJSONPair.Create('status', VarToStr(AStatus)));
      LJsonObject.AddPair(TJSONPair.Create('msg', AMessage));
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

class function TAuxilio.MD5_Arquivo(const fileName: string): string;
var
  fs : TFileStream;
  idmd5 : TIdHashMessageDigest5;
begin
  if (Trim(fileName) = '') or (Not FileExists(fileName)) then
  Begin
    Result := '';
    Exit;
  End;

  try
    try
      idmd5 := TIdHashMessageDigest5.Create;
      fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite);
      Result := LowerCase(idmd5.HashStreamAsHex(fs));
    Except
      on E: Exception do
      Begin
        Result := '';
        raise Exception.Create(E.Message);
      End;
    end;
  finally
    FreeAndNil(fs);
    FreeAndNil(idmd5);
  end;
end;

class function TAuxilio.MD5_String(const texto: string): string;
var
  idmd5 : TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := AnsiLowerCase(idmd5.HashStringAsHex(texto));
  finally
    idmd5.Free;
  end;
end;

class function TAuxilio.MethodBoolean(const AInstance: TObject;
  AMethodName: string): Boolean;
type TExecMethod = function :Boolean of object;
var Routine: TMethod;
    Executar :TExecMethod;
begin
     Try
        Result := false;
        if (AInstance <> nil) and (AMethodName <> '') then
        begin
             Routine.Data := Pointer(AInstance);
             Routine.Code := AInstance.MethodAddress(AMethodName);
             if Routine.Code <> nil then
             begin
                  Executar := TExecMethod(Routine);
                  Result := Executar;
             end;
        end;
     except
     on e:exception do
        CodeSite.SendException(e);
     end;
end;

class function TAuxilio.MethodString(const AInstance: TObject;
  AMethodName: string): string;
type TExecMethod = function :string of object;
var Routine: TMethod;
    Executar :TExecMethod;
begin
     Try
        Result := '';
        if (AInstance <> nil) and (AMethodName <> '') then
        begin
             Routine.Data := Pointer(AInstance);
             Routine.Code := AInstance.MethodAddress(AMethodName);
             if Routine.Code <> nil then
             begin
                  Executar := TExecMethod(Routine);
                  Result := Executar;
             end;
        end;
     except
     on e:exception do
        CodeSite.SendException(e);
     end;
end;

class procedure TAuxilio.SetObject(const AInstance: TObject; AProp: string;
  AObject: TObject);
begin
     if AInstance <> nil then
     begin
          if IsPublishedProp(AInstance,AProp) then
             SetObjectProp(AInstance,AProp,AObject);
     end;
end;

class procedure TAuxilio.SetValue(const AInstance: TObject; AProp: string;
  AValue: variant);
begin
     if AInstance <> nil then
     begin
          if IsPublishedProp(AInstance,AProp) then
             SetPropValue(AInstance,AProp,AValue);
     end;
end;

end.
