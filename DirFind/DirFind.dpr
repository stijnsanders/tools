program DirFind;

uses
  Forms,
  DirFindMain in 'DirFindMain.pas' {fDirFindMain},
  VBScript_RegExp_55_TLB in 'VBScript_RegExp_55_TLB.pas',
  DirFindWorker in 'DirFindWorker.pas',
  DirFindNodes in 'DirFindNodes.pas',
  DirFindReplace in 'DirFindReplace.pas' {fDirFindReplace};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DirFind';
  Application.CreateForm(TfDirFindMain, fDirFindMain);
  Application.CreateForm(TfDirFindReplace, fDirFindReplace);
  Application.Run;
end.
