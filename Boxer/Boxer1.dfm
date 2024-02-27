object frmBoxerMain: TfrmBoxerMain
  Left = 117
  Top = 176
  Caption = 'Boxer'
  ClientHeight = 467
  ClientWidth = 1210
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  Position = poDefault
  OnActivate = DoUpdateTabs
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1210
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    PopupMenu = PopupMenu2
    TabOrder = 0
    OnClick = Panel1Click
    OnEnter = DoUpdateTabs
    OnResize = Panel1Resize
    object Label2: TLabel
      Left = 8
      Top = 4
      Width = 442
      Height = 14
      Caption = 
        'Use the boxing handle on the window title bar to box windows her' +
        'e...'
      Enabled = False
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 25
    Width = 824
    Height = 442
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    Color = clAppWorkSpace
    ParentColor = False
    TabOrder = 1
    OnEnter = DoUpdateTabs
    OnMouseDown = ScrollBox1MouseDown
    OnMouseMove = ScrollBox1MouseMove
    OnMouseUp = ScrollBox1MouseUp
    OnResize = ScrollBox1Resize
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = '.:'
    end
  end
  object ListBox1: TListBox
    Left = 824
    Top = 25
    Width = 386
    Height = 442
    Align = alRight
    ItemHeight = 14
    TabOrder = 2
    Visible = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 56
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 56
    object Activate1: TMenuItem
      Caption = 'Activate'
      Default = True
      OnClick = TabClick
    end
    object Unbox1: TMenuItem
      Caption = '&Unbox'
      OnClick = Unbox1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = '&Close'
      OnClick = Close1Click
    end
  end
  object PopupMenu2: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 72
    Top = 56
    object BoxHandle1: TMenuItem
      Caption = '&Box handle'
      Checked = True
      OnClick = BoxHandle1Click
    end
    object BoxHandleOnce1: TMenuItem
      Caption = 'Box handle &once'
      Enabled = False
      OnClick = BoxHandleOnce1Click
    end
    object DebugMessages1: TMenuItem
      Caption = 'Debug Messages'
      Visible = False
      OnClick = DebugMessages1Click
    end
  end
end
