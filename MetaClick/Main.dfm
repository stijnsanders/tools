object frmMetaClick: TfrmMetaClick
  Left = 280
  Top = 115
  AlphaBlend = True
  AlphaBlendValue = 192
  BorderStyle = bsNone
  Caption = 'MetaClick'
  ClientHeight = 106
  ClientWidth = 260
  Color = 14535867
  Constraints.MinHeight = 24
  Constraints.MinWidth = 24
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clInfoText
  Font.Height = -19
  Font.Name = 'Verdana'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = AllMouseDown
  OnMouseMove = AllMouseMove
  OnMouseUp = AllMouseUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object panMain: TPanel
    Left = 0
    Top = 0
    Width = 260
    Height = 106
    Cursor = crSizeAll
    Align = alClient
    BevelWidth = 2
    ParentColor = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnMouseDown = AllMouseDown
    OnMouseMove = AllMouseMove
    OnMouseUp = AllMouseUp
    DesignSize = (
      260
      106)
    object imgResize: TImage
      Left = 241
      Top = 87
      Width = 20
      Height = 20
      Cursor = crSizeNWSE
      Anchors = [akRight, akBottom]
      Picture.Data = {
        07544269746D6170F6000000424DF60000000000000076000000280000001000
        000010000000010004000000000080000000C40E0000C40E0000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00DDDDDDDDDDDDDDDDD00DD00DD00DDDDDDDD0DDD0DDD0DDDDDDDD0DDD0DDD
        0DDDDDDDD0DDD0DDD0DDDDDDDD0DDD0DDD0DDDDDDDD0DDD0DD0DDDDDDDDD0DDD
        0DDDDDDDDDDDD0DDD0DDDDDDDDDDDD0DDD0DDDDDDDDDDDD0DD0DDDDDDDDDDDDD
        0DDDDDDDDDDDDDDDD0DDDDDDDDDDDDDDDD0DDDDDDDDDDDDDDD0DDDDDDDDDDDDD
        DDDD}
      PopupMenu = PopupMenu1
      Transparent = True
      OnMouseDown = imgResizeMouseDown
      OnMouseMove = imgResizeMouseMove
      OnMouseUp = imgResizeMouseUp
    end
    object panLeftSingle: TPanel
      Left = 16
      Top = 8
      Width = 41
      Height = 42
      BevelWidth = 2
      Caption = 'L1'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panLeftSingleMouseUp
    end
    object panLeftDouble: TPanel
      Left = 63
      Top = 8
      Width = 41
      Height = 42
      BevelWidth = 2
      Caption = 'L2'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 1
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panLeftDoubleMouseUp
    end
    object panRightSingle: TPanel
      Left = 16
      Top = 56
      Width = 41
      Height = 42
      BevelWidth = 2
      Caption = 'R1'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 3
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panRightSingleMouseUp
    end
    object panClose: TPanel
      Left = 157
      Top = 80
      Width = 28
      Height = 25
      BevelWidth = 2
      Caption = 'x'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 9
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panCloseMouseUp
    end
    object panRightDouble: TPanel
      Left = 63
      Top = 56
      Width = 41
      Height = 42
      BevelWidth = 2
      Caption = 'R2'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 4
      Visible = False
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panRightDoubleMouseUp
    end
    object panRightDrag: TPanel
      Left = 110
      Top = 56
      Width = 41
      Height = 42
      BevelWidth = 2
      Caption = 'Rd'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 5
      Visible = False
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panRightDragMouseUp
    end
    object panLeftDrag: TPanel
      Left = 110
      Top = 8
      Width = 41
      Height = 42
      BevelWidth = 2
      Caption = 'Ld'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 2
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panLeftDragMouseUp
    end
    object panOptions: TPanel
      Left = 157
      Top = 56
      Width = 28
      Height = 25
      BevelWidth = 2
      Caption = 's'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 8
      Visible = False
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panOptionsMouseUp
    end
    object panWheel: TPanel
      Left = 157
      Top = 8
      Width = 28
      Height = 25
      BevelWidth = 2
      Caption = 'W'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 6
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panWheelMouseUp
    end
    object panSuspend: TPanel
      Left = 157
      Top = 32
      Width = 28
      Height = 25
      BevelWidth = 2
      Caption = 'z'
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 7
      Visible = False
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = panSuspendMouseUp
    end
    object panCountDown: TPanel
      Left = 192
      Top = 8
      Width = 41
      Height = 42
      ParentColor = True
      PopupMenu = PopupMenu1
      TabOrder = 10
      Visible = False
      OnMouseDown = AllMouseDown
      OnMouseMove = AllMouseMove
      OnMouseUp = AllMouseUp
      object panCountDown1: TPanel
        Left = 8
        Top = 0
        Width = 25
        Height = 17
        BevelOuter = bvNone
        Color = clRed
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnMouseDown = AllMouseDown
        OnMouseMove = AllMouseMove
        OnMouseUp = AllMouseUp
      end
      object panCountDown2: TPanel
        Left = 8
        Top = 16
        Width = 25
        Height = 17
        BevelOuter = bvNone
        Color = clBlue
        PopupMenu = PopupMenu1
        TabOrder = 1
        Visible = False
        OnMouseDown = AllMouseDown
        OnMouseMove = AllMouseMove
        OnMouseUp = AllMouseUp
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 32
    object LeftSingle1: TMenuItem
      Caption = 'L1: left single'
      GroupIndex = 1
      RadioItem = True
      OnClick = LeftSingle1Click
    end
    object LeftDouble1: TMenuItem
      Caption = 'L2: left double'
      GroupIndex = 1
      RadioItem = True
      OnClick = LeftDouble1Click
    end
    object LeftDrag1: TMenuItem
      Caption = 'Ld: left drag'
      GroupIndex = 1
      RadioItem = True
      OnClick = LeftDrag1Click
    end
    object RightSingle1: TMenuItem
      Caption = 'R1: right single'
      GroupIndex = 1
      RadioItem = True
      OnClick = RightSingle1Click
    end
    object RightDouble1: TMenuItem
      Caption = 'R2: right double'
      GroupIndex = 1
      RadioItem = True
      OnClick = RightDouble1Click
    end
    object RightDrag1: TMenuItem
      Caption = 'Rd: Right drag'
      GroupIndex = 1
      RadioItem = True
      OnClick = RightDrag1Click
    end
    object Wheel1: TMenuItem
      Caption = 'W: wheel'
      GroupIndex = 1
      RadioItem = True
      OnClick = Wheel1Click
    end
    object N1: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object Suspend1: TMenuItem
      Caption = 'z: suspend'
      GroupIndex = 1
      OnClick = Suspend1Click
    end
    object Settings1: TMenuItem
      Caption = 's: settings...'
      GroupIndex = 1
      OnClick = Settings1Click
    end
    object N2: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object Exit1: TMenuItem
      Caption = 'x: Exit'
      GroupIndex = 1
      OnClick = Exit1Click
    end
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
  end
  object tiMouseOver: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tiMouseOverTimer
    Left = 64
  end
end
