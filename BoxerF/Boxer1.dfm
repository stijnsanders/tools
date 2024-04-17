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
  PopupMenu = PopupMenu1
  PixelsPerInch = 96
  TextHeight = 14
  object lblDisplay: TLabel
    Left = 2
    Top = 2
    Width = 95
    Height = 14
    AutoSize = False
    Caption = '...'
    PopupMenu = PopupMenu1
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
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 48
    Top = 8
    object Removewindowfromgroup1: TMenuItem
      Caption = 'Remove &window from group'
      OnClick = Removewindowfromgroup1Click
    end
    object Removegroup1: TMenuItem
      Caption = '&Remove group'
      OnClick = Removegroup1Click
    end
    object Useshellpaths1: TMenuItem
      Caption = 'Use shell paths'
      OnClick = Useshellpaths1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      OnClick = Exit1Click
    end
  end
end
