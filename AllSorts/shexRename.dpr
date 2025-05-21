program shexRename;

uses
  Forms,
  shexrename1 in 'shexrename1.pas' {frmShexRename};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar:=true;
  Application.CreateForm(TfrmShexRename, frmShexRename);
  Application.Run;
end.

