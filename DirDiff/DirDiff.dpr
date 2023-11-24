program DirDiff;

{$R 'DirDiff_ico.res' 'DirDiff_ico.rc'}

uses
  Forms,
  ddMain in 'ddMain.pas' {frmDirDiffMain},
  ddPrefs in 'ddPrefs.pas' {frmDirDiffPrefs},
  ddData in 'ddData.pas',
  ddParams in 'ddParams.pas',
  VBScript_RegExp_55_TLB in 'VBScript_RegExp_55_TLB.pas',
  MSXML2_TLB in 'MSXML2_TLB.pas',
  xxHash in 'xxHash.pas',
  ddGoToLine in 'ddGoToLine.pas' {frmDirDiffGoToLine},
  ddHandle in 'ddHandle.pas' {frmDiffHandle},
  ddDiff in 'ddDiff.pas',
  ddXmlTools in 'ddXmlTools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title:='DirDiff';
  Application.MainFormOnTaskBar:=true;
  Application.CreateForm(TfrmDirDiffMain, frmDirDiffMain);
  Application.Run;
end.
