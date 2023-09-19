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
    procedure DoClose(var Action: TCloseAction); override;
  end;

implementation

{$R *.dfm}

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
