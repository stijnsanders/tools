object frmEszettMain: TfrmEszettMain
  Left = 0
  Top = 0
  Caption = 'Eszett'
  ClientHeight = 81
  ClientWidth = 184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMinimized
  PixelsPerInch = 96
  TextHeight = 13
  object TrayIcon1: TTrayIcon
    Hint = 'eszett'
    PopupMenu = PopupMenu1
    Visible = True
    Left = 16
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 16
    object Settings1: TMenuItem
      Caption = '&Settings...'
      OnClick = Settings1Click
    end
    object Settings2: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      OnClick = Exit1Click
    end
  end
end
