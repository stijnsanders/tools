[Setup]
AppID={{01FD81F1-45F6-4243-80FA-30C03818ACA8}
AppName=MetaKeys
AppVerName=MetaKeys 1.1.0.540
AppPublisher=Double Sigma Programming
AppPublisherURL=http://yoy.be/metakeys
AppSupportURL=http://yoy.be/metakeys
AppUpdatesURL=http://yoy.be/metakeys
DefaultDirName={pf}\MetaKeys
DisableDirPage=yes
DefaultGroupName=MetaKeys
AllowNoIcons=yes
OutputBaseFilename=MetaKeys_setup32
OutputDir=.
SetupIconFile=MetaKeys_Icon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\bin32\MetaKeys.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "WhatsNew.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "MetaKeysInfo.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "be.kbl"; DestDir: "{app}"; Flags: ignoreversion
Source: "us.kbl"; DestDir: "{app}"; Flags: ignoreversion
Source: "numpad.kbl"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\MetaKeys"; Filename: "{app}\MetaKeys.exe"
Name: "{group}\{cm:UninstallProgram,MetaKeys}"; Filename: "{uninstallexe}"
Name: "{userstartup}\MetaKeys"; Filename: "{app}\MetaKeys.exe"

[Run]
Filename: "{app}\MetaKeys.exe"; Description: "{cm:LaunchProgram,MetaKeys}"; Flags: nowait postinstall skipifsilent

