unit MainModule;

interface

uses
  uniGUIMainModule,uniGUIClasses,uniGUITypes, SysUtils, Classes, frxClass;

type
  TUniMainModule = class(TUniGUIMainModule)
    procedure UniGUIMainModuleNewComponent(AComponent: TComponent);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

procedure TUniMainModule.UniGUIMainModuleNewComponent(AComponent: TComponent);
begin
  if AComponent is TfrxReport then
  begin
    (AComponent as TfrxReport).EngineOptions.UseGlobalDataSetList := False;
    (AComponent as TfrxReport).EngineOptions.SilentMode := True;
    (AComponent as TfrxReport).EngineOptions.EnableThreadSafe := True;
    (AComponent as TfrxReport).EngineOptions.DestroyForms := False;
    (AComponent as TfrxReport).PreviewOptions.AllowEdit := False;
  end;
end;

initialization
  UniAddJSLibrary('files/funcoes.js', False, [upoPlatformDesktop]);
  RegisterMainModuleClass(TUniMainModule);
end.
