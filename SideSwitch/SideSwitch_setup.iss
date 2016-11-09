[Setup]
AppId={{657712DF-3C12-4EB2-BC42-74E22CA14277}
AppName=SideSwitch
AppVerName=SideSwitch 1.0.8.460
AppPublisher=Double Sigma Programming
AppPublisherURL=http://yoy.be/sideswitch
AppSupportURL=http://yoy.be/sideswitch
AppUpdatesURL=http://yoy.be/sideswitch
DefaultDirName={pf}\SideSwitch
DisableDirPage=yes
DefaultGroupName=SideSwitch
InfoAfterFile=PostInstall.txt
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=SideSwitch_setup
SetupIconFile=img\SideSwitch.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "SideSwitch.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "SideSwitch_WhatsNew.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\SideSwitch"; Filename: "{app}\SideSwitch.exe"
Name: "{group}\{cm:UninstallProgram,SideSwitch}"; Filename: "{uninstallexe}"
Name: "{userstartup}\SideSwitch"; Filename: "{app}\SideSwitch.exe"

[Run]
Filename: "{app}\SideSwitch.exe"; Description: "{cm:LaunchProgram,SideSwitch}"; Flags: nowait postinstall skipifsilent
Filename: "{app}\README.txt"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent
