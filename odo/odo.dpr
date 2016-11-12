program odo;

uses
  Forms,
  Windows,
  oMain in 'oMain.pas' {winMain},
  oHint in 'oHint.pas' {winHint},
  oSets in 'oSets.pas' {winSettings},
  SQLite in 'SQLite.pas',
  SQLiteData in 'SQLiteData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TwinMain, winMain);
  Application.CreateForm(TwinHint, winHint);
  Application.Run;
end.
