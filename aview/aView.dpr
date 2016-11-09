program aView;

uses
  Forms,
  aView1 in 'aView1.pas' {frmAView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAView, frmAView);
  Application.Run;
end.
