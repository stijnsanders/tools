object winMain: TwinMain
  Left = 330
  Top = 192
  BorderStyle = bsNone
  Caption = 'odo'
  ClientHeight = 43
  ClientWidth = 368
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ApplicationEvents1: TApplicationEvents
    OnDeactivate = ApplicationEvents1Deactivate
    OnIdle = ApplicationEvents1Idle
    Left = 8
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 8
    object Settings1: TMenuItem
      Caption = 'Settings...'
      OnClick = Settings1Click
    end
    object Stayontop1: TMenuItem
      Caption = 'Stay on top'
      OnClick = Stayontop1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
  end
  object tiIdle: TTimer
    Interval = 100
    OnTimer = tiIdleTimer
    Left = 72
    Top = 8
  end
end
