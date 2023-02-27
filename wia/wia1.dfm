object Form1: TForm1
  Left = 192
  Top = 130
  Width = 674
  Height = 608
  Caption = 'WIA Scan'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    658
    569)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 120
    Height = 14
    Caption = 'Destination Folder:'
  end
  object Label2: TLabel
    Left = 8
    Top = 80
    Width = 12
    Height = 14
    Caption = '...'
  end
  object Button1: TButton
    Left = 8
    Top = 104
    Width = 137
    Height = 25
    Caption = 'Scan'
    TabOrder = 0
    OnClick = Button1Click
  end
  object txtFolder: TEdit
    Left = 8
    Top = 24
    Width = 633
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 48
    Width = 137
    Height = 25
    Caption = 'Select Folder...'
    TabOrder = 2
    OnClick = Button2Click
  end
end
