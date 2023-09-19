program SideSwitch;

uses
  Forms,
  SideSwitch1 in 'SideSwitch1.pas' {frmSideSwitchMain},
  SideSwitch2 in 'SideSwitch2.pas' {frmSettings},
  SideSwitch3 in 'SideSwitch3.pas' {frmBlack};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSideSwitchMain, frmSideSwitchMain);
  Application.Run;
end.
