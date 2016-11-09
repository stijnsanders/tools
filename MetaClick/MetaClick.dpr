program MetaClick;

uses
  Forms,
  Main in 'Main.pas' {frmMetaClick},
  CursorTag in 'CursorTag.pas' {frmCursorTag},
  Settings in 'Settings.pas' {frmSettings},
  Orbit in 'Orbit.pas' {frmOrbit},
  mcCommon in 'mcCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMetaClick, frmMetaClick);
  Application.CreateForm(TfrmCursorTag, frmCursorTag);
  Application.CreateForm(TfrmOrbit, frmOrbit);
  Application.Run;
end.
