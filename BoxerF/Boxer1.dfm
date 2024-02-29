object frmBoxer: TfrmBoxer
  Left = 293
  Top = 82
  BorderStyle = bsNone
  Caption = 'Boxer'
  ClientHeight = 20
  ClientWidth = 400
  Color = 52479
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object lblDisplay: TLabel
    Left = 2
    Top = 2
    Width = 95
    Height = 14
    AutoSize = False
    Caption = '...'
    ShowAccelChar = False
    OnClick = lblDisplayClick
    OnMouseMove = lblDisplayMouseMove
  end
  object Timer1: TTimer
    Interval = 250
    OnTimer = Timer1Timer
    Left = 16
    Top = 8
  end
end
