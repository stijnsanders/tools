object frmMetaKeys: TfrmMetaKeys
  Left = 302
  Top = 113
  AlphaBlend = True
  AlphaBlendValue = 192
  BorderStyle = bsNone
  Caption = 'MetaKeys'
  ClientHeight = 162
  ClientWidth = 384
  Color = 52479
  Constraints.MinHeight = 24
  Constraints.MinWidth = 24
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clInfoText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = AllMouseDown
  OnMouseMove = AllMouseMove
  OnMouseUp = AllMouseUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object panMain: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 162
    Cursor = crSizeAll
    Align = alClient
    BevelWidth = 2
    Color = 14535867
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnMouseDown = AllMouseDown
    OnMouseMove = AllMouseMove
    OnMouseUp = AllMouseUp
    DesignSize = (
      384
      162)
    object imgResize: TImage
      Left = 365
      Top = 143
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
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 8
    Top = 8
    object Settings1: TMenuItem
      Caption = '&Settings...'
      GroupIndex = 1
      OnClick = Settings1Click
    end
    object N2: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      GroupIndex = 1
      OnClick = Exit1Click
    end
  end
  object tiDelay: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tiDelayTimer
    Left = 40
    Top = 8
  end
  object tiRepeat: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tiRepeatTimer
    Left = 72
    Top = 8
  end
  object tiMouseOver: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tiMouseOverTimer
    Left = 104
    Top = 8
  end
  object tiCheckKeyV: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tiCheckKeyVTimer
    Left = 136
    Top = 8
  end
end
