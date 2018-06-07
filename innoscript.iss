[Files]
Source: "Win32\Release\sHardware.exe"; DestDir: "{app}"; Flags: ignoreversion

[Setup]
DisableReadyPage=True
DisableReadyMemo=True
AppName=Plugin Hardware Server
AppVersion=1.0
SetupIconFile=D:\projetos\unihardware\uniHardware_Server_Icon3.ico
RestartApplications=False
SolidCompression=True
UninstallDisplayName=Susej Plugin Hardware Server
VersionInfoVersion=1.0
VersionInfoCompany=Susej Solution
VersionInfoDescription=Plugin de comunicação com webbrowser
VersionInfoCopyright=susej@2014
VersionInfoProductName=Hardware Server
VersionInfoProductVersion=1.0
AppCopyright=Susej Solution
CreateAppDir=False
AppPublisher=Susej Solution
AppComments=Plugin Hardware Server
AppContact=suporte@susejsolution.com.br
AppSupportPhone=(65)3058-1770
UninstallDisplayIcon={win}\sHardware.exe

[Dirs]
Name: "{app}\susej"

[Run]
Filename: "{win}\sHardware.exe"; Flags: postinstall runminimized
