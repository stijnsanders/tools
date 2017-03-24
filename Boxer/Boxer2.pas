unit Boxer2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSwitchHandle = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    procedure FormClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmSwitchHandle: TfrmSwitchHandle;

implementation

uses Boxer1;

{$R *.dfm}

procedure TfrmSwitchHandle.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  if (Params.ExStyle and WS_EX_APPWINDOW)<>0 then
    Params.ExStyle:=Params.ExStyle xor WS_EX_APPWINDOW;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;// or WS_EX_PALETTEWINDOW;
end;

procedure TfrmSwitchHandle.FormClick(Sender: TObject);
begin
  ShowWindow(Handle,SW_HIDE);
  frmBoxerMain.TakeHWND;
end;

end.
