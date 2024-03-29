unit SideSwitch3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmBlack = class(TForm)
    ColorDialog1: TColorDialog;
    procedure FormDblClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoClose(var Action: TCloseAction); override;
  end;

implementation

{$R *.dfm}

procedure TfrmBlack.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=0;
  Params.ExStyle:=Params.ExStyle or WS_EX_TOOLWINDOW;
end;

procedure TfrmBlack.DoClose(var Action: TCloseAction);
begin
  inherited;
  //see also TfrmSideSwitchMain.BlackClose
  Action:=caFree
end;

procedure TfrmBlack.FormDblClick(Sender: TObject);
begin
  ColorDialog1.Color:=Color;
  if ColorDialog1.Execute then Color:=ColorDialog1.Color;
end;

end.
