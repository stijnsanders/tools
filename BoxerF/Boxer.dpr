program Boxer;

uses
  Forms,
  Boxer1 in 'Boxer1.pas' {frmBoxer},
  Shell32_TLB in 'Shell32_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBoxer, frmBoxer);
  Application.Run;
end.
