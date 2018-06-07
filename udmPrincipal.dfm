object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 338
  Width = 683
  object HTTPServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 10287
    OnCommandGet = HTTPServerCommandGet
    Left = 100
    Top = 24
  end
end
