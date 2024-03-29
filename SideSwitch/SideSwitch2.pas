unit SideSwitch2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmSettings = class(TForm)
    Label1: TLabel;
    txtKeepShowing: TEdit;
    udKeepShowing: TUpDown;
    Label2: TLabel;
    txtIconHeight: TEdit;
    udIconHeight: TUpDown;
    btnOK: TButton;
    btnCancel: TButton;
    cbSessionBoot: TCheckBox;
    FontDialog1: TFontDialog;
    btnFont: TButton;
    ColorDialog1: TColorDialog;
    rgVisible: TRadioGroup;
    rgMinimized: TRadioGroup;
    panClrMain: TPanel;
    btnClrMain: TButton;
    panClrVisible: TPanel;
    btnClrVisible: TButton;
    panClrMinimized: TPanel;
    btnClrMinimized: TButton;
    Label3: TLabel;
    txtIconTimeout: TEdit;
    udIconTimeout: TUpDown;
    cbSwitchMirrored: TCheckBox;
    cbTaskBarNixTopMost: TCheckBox;
    gbActivate: TGroupBox;
    cbScreenTop: TCheckBox;
    gbScreen: TGroupBox;
    cbScreenLeft: TCheckBox;
    cbScreenBottom: TCheckBox;
    cbScreenRight: TCheckBox;
    cbActivateHoldCtrl: TCheckBox;
    cbClock: TCheckBox;
    txtClock: TEdit;
    procedure btnFontClick(Sender: TObject);
    procedure btnClrMainClick(Sender: TObject);
    procedure btnClrVisibleClick(Sender: TObject);
    procedure btnClrMinimizedClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TfrmSettings.btnFontClick(Sender: TObject);
begin
  FontDialog1.Execute;
end;

procedure TfrmSettings.btnClrMainClick(Sender: TObject);
begin
  ColorDialog1.Color:=panClrMain.Color;
  if ColorDialog1.Execute then panClrMain.Color:=ColorDialog1.Color;
end;

procedure TfrmSettings.btnClrVisibleClick(Sender: TObject);
begin
  ColorDialog1.Color:=panClrVisible.Color;               
  if ColorDialog1.Execute then panClrVisible.Color:=ColorDialog1.Color;
end;

procedure TfrmSettings.btnClrMinimizedClick(Sender: TObject);
begin
  ColorDialog1.Color:=panClrMinimized.Color;
  if ColorDialog1.Execute then panClrMinimized.Color:=ColorDialog1.Color;
end;

end.
