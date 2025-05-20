[Setup]
AppId={{F793E76D-8575-4410-9903-A947DF842C5B}
AppName=AllSorts
AppVerName=AllSorts 1.2.0.700
AppPublisher=Double Sigma Programming
AppPublisherURL=http://yoy.be/allsorts
AppSupportURL=http://yoy.be/allsorts
AppUpdatesURL=http://yoy.be/allsorts
DefaultDirName={commonpf}\AllSorts
DisableDirPage=yes
DefaultGroupName=AllSorts
DisableProgramGroupPage=yes
InfoAfterFile=PostInstall.txt
OutputDir=.
OutputBaseFilename=AllSorts_32
Compression=lzma
SolidCompression=yes
SetupIconFile=AllSorts.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\bin32\shexAllSorts.dll"; DestDir: "{app}"; Flags: ignoreversion regserver restartreplace uninsrestartdelete
Source: "shexAllSorts.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\bin32\shexRename.exe"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
Root: HKCU; Subkey: "Software\Double Sigma Programming\AllSorts\External"; ValueType: string; ValueName: "R&ename..."; ValueData: "shexRename.exe"; Flags: uninsdeletekeyifempty