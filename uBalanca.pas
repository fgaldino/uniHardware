unit uBalanca;

interface

Uses Classes,System.TypInfo,System.SysUtils,System.JSON,CodeSiteLogging,IdCustomHTTPServer,
System.StrUtils,ACBrBAL,ACBrDevice,ACBrBase,uClasseAuxiliar;

Type
TBalanca = class(TPersistent)
 private
    fARequestInfo: TIdHTTPRequestInfo;
    Abal:TACBrBAL;
 public
 procedure AfterConstruction; override;
 destructor Destroy; Override;

 published
    property ARequestInfo : TIdHTTPRequestInfo read fARequestInfo write fARequestInfo;
    function LerPesoBalanca:string;
end;

implementation

{ TBalanca }

procedure TBalanca.AfterConstruction;
begin
  inherited;
  Abal := TACBrBAL.Create(nil);
end;

destructor TBalanca.Destroy;
begin
  Abal.Free;
  inherited;
end;

function TBalanca.LerPesoBalanca:string;
var
    Apeso:Double;
    valid : integer;
    ABalancaStatus:integer;

    AModelo,
    AHandsharing,
    AParity,
    AStopBits,
    ADataBits,
    ABaudRate,
    APorta:string;
begin
     try
        ABalancaStatus := 0;
        APeso := 0;
        if ARequestInfo <> nil then
        begin
           AModelo := ARequestInfo.Params.Values['modelo'];
           APorta := ARequestInfo.Params.Values['porta'];
           AHandsharing := ARequestInfo.Params.Values['handshaking'];
           AParity := ARequestInfo.Params.Values['parity'];
           AStopBits := ARequestInfo.Params.Values['stopbits'];
           ADataBits := ARequestInfo.Params.Values['databits'];
           ABaudRate := ARequestInfo.Params.Values['baudrate'];

           CodeSite.Send('Modelo:'+AModelo);
           CodeSite.Send('Porta:'+APorta);
           CodeSite.Send('Handsharing:'+AHandsharing);
           CodeSite.Send('Parity:'+AParity);
           CodeSite.Send('StopBits:'+AStopBits);
           CodeSite.Send('DataBits:'+ADataBits);
           CodeSite.Send('BaudRate:'+ABaudRate);

           if (AModelo<>'') and (AHandsharing<>'') and (AParity<>'') and
              (AStopBits<>'') and (ADataBits<>'') and (ABaudRate<>'') and
              (APorta<>'') then
           begin
              ABal.ArqLOG := '';
              ABal.Modelo           := TACBrBALModelo(GetEnumValue(TypeInfo(TACBrBALModelo),'bal'+AModelo));
              ABal.Device.HandShake := TACBrHandShake(GetEnumValue(TypeInfo(TACBrHandShake),AHandsharing));
              ABal.Device.Parity    := TACBrSerialParity(GetEnumValue(TypeInfo(TACBrSerialParity),AParity));
              ABal.Device.Stop      := TACBrSerialStop(GetEnumValue(TypeInfo(TACBrSerialStop),AStopBits));
              ABal.Device.Data      := StrToInt(ADataBits);
              ABal.Device.Baud      := StrToInt(ABaudRate);
              ABal.Device.Porta     := APorta;
           end;
           ABal.Ativar;
           if ABal.Ativo then
           begin
                APeso := ABal.LePeso();
                if APeso <= 0 then
                begin
                     valid := Trunc(ABal.UltimoPesoLido);
                     case valid of
                        0 : result := 'TimeOut!,coloque o produto sobre a Balança!';
                       -1 : result := 'Peso Instavel, Tente Nova Leitura';
                       -2 : result := 'Peso Negativo !' ;
                       -9 : result := 'Falha comunicação';
                      -10 : result := 'Sobrepeso !' ;
                     end;
                end else
                begin
                     ABalancaStatus := 1;
                     result := Apeso.ToString;
                end;
           end else
           result := 'Falha ao comunicar com a balança';

           result := aux.JsonStatus(ABalancaStatus=1,result);
        end;
     except
     on e:exception do
        begin
             CodeSite.SendException(E);
        end;
     end;
end;

Initialization
 RegisterClass(TBalanca);

end.
