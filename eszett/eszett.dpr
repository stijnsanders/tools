program eszett;

uses
  Vcl.Forms,
  eszett1 in 'eszett1.pas' {frmEszettMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:=true;
  Application.ShowMainForm:=false;
  Application.CreateForm(TfrmEszettMain, frmEszettMain);
  Application.Run;
end.
