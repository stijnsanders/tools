program Boxer;

uses
  Forms,
  Boxer1 in 'Boxer1.pas' {frmBoxerMain},
  Boxer2 in 'Boxer2.pas' {frmSwitchHandle};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBoxerMain, frmBoxerMain);
  Application.CreateForm(TfrmSwitchHandle, frmSwitchHandle);
  Application.Run;
end.
