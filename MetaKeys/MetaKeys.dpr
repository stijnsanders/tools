program MetaKeys;

uses
  Forms,
  Main in 'Main.pas' {frmMetaKeys},
  Settings in 'Settings.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMetaKeys, frmMetaKeys);
  Application.Run;
end.               
