[Setup]
AppId={{F793E76D-8575-4410-9903-A947DF842C5B}
AppName=AllSorts
AppVerName=AllSorts 1.1.5.345
AppPublisher=Double Sigma Programming
AppPublisherURL=http://yoy.be/allsorts
AppSupportURL=http://yoy.be/allsorts
AppUpdatesURL=http://yoy.be/allsorts
DefaultDirName={pf}\AllSorts
DisableDirPage=yes
DefaultGroupName=AllSorts
DisableProgramGroupPage=yes
InfoAfterFile=PostInstall.txt
OutputDir=.
OutputBaseFilename=AllSorts
Compression=lzma
SolidCompression=yes
SetupIconFile=AllSorts.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "shexAllSorts1.pas"; DestDir: "{app}"; Flags: ignoreversion
Source: "shexAllSorts.dll"; DestDir: "{app}"; Flags: ignoreversion regserver restartreplace uninsrestartdelete
Source: "shexAllSorts.lpr"; DestDir: "{app}"; Flags: ignoreversion
Source: "shexAllSorts.txt"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
Root: HKCU; Subkey: "Software\Double Sigma Programming\AllSorts\External"; ValueType: string; ValueName: "R&ename..."; ValueData: "shexRename.exe"; Flags: uninsdeletekeyifempty