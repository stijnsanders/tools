object frmSettings: TfrmSettings
  Left = 346
  Top = 111
  BorderStyle = bsDialog
  Caption = 'SideSwitch settings'
  ClientHeight = 353
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
  object Button1: TButton
    Left = 80
    Top = 312
    Width = 89
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 15
  end
  object Button2: TButton
    Left = 176
    Top = 312
    Width = 89
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 16
  end
  object cbSessionBoot: TCheckBox
    Left = 8
    Top = 272
    Width = 257
    Height = 17
    Caption = 'Start when Windows starts'
    TabOrder = 13
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
    Top = 104
    Width = 209
    Height = 57
    Caption = 'List visible windows'
    ItemIndex = 0
    Items.Strings = (
      'on its monitor'
      'on all monitors')
    TabOrder = 10
  end
  object rgMinimized: TRadioGroup
    Left = 56
    Top = 168
    Width = 209
    Height = 81
    Caption = 'List minimized windows'
    ItemIndex = 2
    Items.Strings = (
      'on its monitor'
      'on all monitors'
      'on all + switch on restore')
    TabOrder = 11
  end
  object panClrMain: TPanel
    Left = 8
    Top = 112
    Width = 41
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 7
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
    Top = 160
    Width = 41
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 8
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
    Top = 208
    Width = 41
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 9
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
    Top = 256
    Width = 257
    Height = 17
    Caption = 'Switch mirrored'
    TabOrder = 12
  end
  object cbTaskBarNixTopMost: TCheckBox
    Left = 8
    Top = 288
    Width = 257
    Height = 17
    Caption = 'Disable taskbar stay on top (Win7)'
    TabOrder = 14
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 240
    Top = 88
  end
  object ColorDialog1: TColorDialog
    Left = 240
    Top = 120
  end
end
