object frmSideSwitchMain: TfrmSideSwitchMain
  Left = 268
  Top = 15
  BorderStyle = bsNone
  Caption = 'SideSwitch'
  ClientHeight = 100
  ClientWidth = 200
  Color = clFuchsia
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 16
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 40
    Top = 8
    object Settings1: TMenuItem
      Caption = '&Settings...'
      OnClick = Settings1Click
    end
    object NewBlack1: TMenuItem
      Caption = 'New "Black"'
      OnClick = NewBlack1Click
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
