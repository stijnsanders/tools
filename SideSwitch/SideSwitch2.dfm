object frmSettings: TfrmSettings
  Left = 346
  Top = 111
  BorderStyle = bsDialog
  Caption = 'SideSwitch settings'
  ClientHeight = 449
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 125
    Height = 16
    Caption = 'Keep showing (ms)'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 75
    Height = 16
    Caption = 'Icon height'
  end
  object Label3: TLabel
    Left = 144
    Top = 8
    Width = 119
    Height = 16
    Caption = 'Icon timeout (ms)'
  end
  object txtKeepShowing: TEdit
    Left = 8
    Top = 24
    Width = 57
    Height = 24
    TabOrder = 0
    Text = '1000'
  end
  object udKeepShowing: TUpDown
    Left = 65
    Top = 24
    Width = 16
    Height = 24
    Associate = txtKeepShowing
    Min = 100
    Max = 10000
    Increment = 50
    Position = 1000
    TabOrder = 1
    Thousands = False
  end
  object txtIconHeight: TEdit
    Left = 8
    Top = 72
    Width = 57
    Height = 24
    TabOrder = 4
    Text = '16'
  end
  object udIconHeight: TUpDown
    Left = 65
    Top = 72
    Width = 16
    Height = 24
    Associate = txtIconHeight
    Min = 8
    Max = 250
    Position = 16
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 80
    Top = 408
    Width = 89
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 18
  end
  object btnCancel: TButton
    Left = 176
    Top = 408
    Width = 89
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 19
  end
  object cbSessionBoot: TCheckBox
    Left = 8
    Top = 368
    Width = 257
    Height = 17
    Caption = 'Start when Windows starts'
    TabOrder = 16
  end
  object btnFont: TButton
    Left = 96
    Top = 72
    Width = 73
    Height = 25
    Caption = 'Font...'
    TabOrder = 6
    OnClick = btnFontClick
  end
  object rgVisible: TRadioGroup
    Left = 56
    Top = 200
    Width = 209
    Height = 57
    Caption = 'List visible windows'
    ItemIndex = 0
    Items.Strings = (
      'on its monitor'
      'on all monitors')
    TabOrder = 13
  end
  object rgMinimized: TRadioGroup
    Left = 56
    Top = 264
    Width = 209
    Height = 81
    Caption = 'List minimized windows'
    ItemIndex = 2
    Items.Strings = (
      'on its monitor'
      'on all monitors'
      'on all + switch on restore')
    TabOrder = 14
  end
  object panClrMain: TPanel
    Left = 8
    Top = 208
    Width = 41
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 10
    OnClick = btnClrMainClick
    object btnClrMain: TButton
      Left = 8
      Top = 16
      Width = 25
      Height = 17
      TabOrder = 0
      OnClick = btnClrMainClick
    end
  end
  object panClrVisible: TPanel
    Left = 8
    Top = 256
    Width = 41
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 11
    OnClick = btnClrVisibleClick
    object btnClrVisible: TButton
      Left = 8
      Top = 16
      Width = 25
      Height = 17
      TabOrder = 0
      OnClick = btnClrVisibleClick
    end
  end
  object panClrMinimized: TPanel
    Left = 8
    Top = 304
    Width = 41
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 12
    OnClick = btnClrMinimizedClick
    object btnClrMinimized: TButton
      Left = 8
      Top = 16
      Width = 25
      Height = 17
      TabOrder = 0
      OnClick = btnClrMinimizedClick
    end
  end
  object txtIconTimeout: TEdit
    Left = 144
    Top = 24
    Width = 57
    Height = 24
    TabOrder = 2
    Text = '150'
  end
  object udIconTimeout: TUpDown
    Left = 201
    Top = 24
    Width = 16
    Height = 24
    Associate = txtIconTimeout
    Min = 1
    Max = 30000
    Position = 150
    TabOrder = 3
  end
  object cbSwitchMirrored: TCheckBox
    Left = 8
    Top = 352
    Width = 257
    Height = 17
    Caption = 'Switch mirrored'
    TabOrder = 15
  end
  object cbTaskBarNixTopMost: TCheckBox
    Left = 8
    Top = 384
    Width = 257
    Height = 17
    Caption = 'Disable taskbar stay on top (Win7)'
    TabOrder = 17
  end
  object gbActivate: TGroupBox
    Left = 8
    Top = 104
    Width = 129
    Height = 89
    Caption = 'Activate'
    TabOrder = 7
    object gbScreen: TGroupBox
      Left = 16
      Top = 16
      Width = 33
      Height = 41
      TabOrder = 0
    end
    object cbScreenTop: TCheckBox
      Left = 24
      Top = 16
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cbScreenLeft: TCheckBox
      Left = 8
      Top = 32
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbScreenBottom: TCheckBox
      Left = 24
      Top = 48
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cbScreenRight: TCheckBox
      Left = 40
      Top = 32
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cbActivateHoldCtrl: TCheckBox
      Left = 8
      Top = 64
      Width = 113
      Height = 17
      Caption = 'by holding Ctrl'
      TabOrder = 5
    end
  end
  object cbClock: TCheckBox
    Left = 144
    Top = 104
    Width = 97
    Height = 17
    Caption = 'Show Clock'
    TabOrder = 8
  end
  object txtClock: TEdit
    Left = 144
    Top = 120
    Width = 121
    Height = 24
    TabOrder = 9
    Text = 'ccccc d/m hh:nn'
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 232
    Top = 32
  end
  object ColorDialog1: TColorDialog
    Left = 232
    Top = 64
  end
end
