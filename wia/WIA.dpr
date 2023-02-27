program WIA;

uses
  Forms,
  wia1 in 'wia1.pas' {Form1},
  WIA_TLB in 'WIA_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
