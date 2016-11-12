object fDirFindReplace: TfDirFindReplace
  Left = 238
  Top = 110
  Width = 521
  Height = 407
  Caption = 'Replace'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    505
    369)
  PixelsPerInch = 96
  TextHeight = 14
  object lblPattern: TLabel
    Left = 8
    Top = 8
    Width = 491
    Height = 14
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lblPattern'
  end
  object txtReplaceWith: TMemo
    Left = 8
    Top = 32
    Width = 489
    Height = 297
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
    WordWrap = False
  end
  object btnOk: TButton
    Left = 312
    Top = 336
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 408
    Top = 336
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
