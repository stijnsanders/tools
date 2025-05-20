object frmShexRename: TfrmShexRename
  Left = 238
  Top = 145
  Caption = 'shexRename'
  ClientHeight = 228
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDefault
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 170
    Top = 0
    Width = 5
    Height = 187
  end
  object panLeft: TPanel
    Left = 0
    Top = 0
    Width = 170
    Height = 187
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 186
    object panLeftTop: TPanel
      Left = 0
      Top = 0
      Width = 170
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object cbFolders: TCheckBox
        Left = 6
        Top = 4
        Width = 96
        Height = 19
        Caption = 'Show full path'
        TabOrder = 0
      end
    end
    object txtOriginalFileNames: TMemo
      Left = 0
      Top = 26
      Width = 170
      Height = 161
      Align = alClient
      ReadOnly = True
      TabOrder = 1
      WordWrap = False
      ExplicitHeight = 160
    end
  end
  object panRight: TPanel
    Left = 175
    Top = 0
    Width = 362
    Height = 187
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 358
    ExplicitHeight = 186
    object panRightTop: TPanel
      Left = 0
      Top = 0
      Width = 362
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 358
      object cbRenameMask: TComboBox
        Left = 0
        Top = 0
        Width = 362
        Height = 23
        Align = alTop
        TabOrder = 0
        Text = 'yyyy-mm-dd hh:nn $n.$e'
        OnChange = cbRenameMaskChange
        ExplicitWidth = 358
      end
    end
    object txtNewFileNames: TMemo
      Left = 0
      Top = 26
      Width = 362
      Height = 161
      Align = alClient
      TabOrder = 1
      WordWrap = False
      ExplicitWidth = 358
      ExplicitHeight = 160
    end
  end
  object panBottom: TPanel
    Left = 0
    Top = 187
    Width = 537
    Height = 41
    Align = alBottom
    Anchors = [akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 186
    ExplicitWidth = 533
    DesignSize = (
      537
      41)
    object btnReset: TButton
      Left = 270
      Top = 8
      Width = 81
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Reset'
      TabOrder = 0
      OnClick = btnResetClick
      ExplicitLeft = 266
    end
    object btnClose: TButton
      Left = 355
      Top = 8
      Width = 81
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
      ExplicitLeft = 351
    end
    object btnGo: TButton
      Left = 444
      Top = 8
      Width = 81
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Go!'
      TabOrder = 2
      OnClick = btnGoClick
      ExplicitLeft = 440
    end
    object btnAddFiles: TButton
      Left = 8
      Top = 8
      Width = 40
      Height = 27
      Caption = '+'
      TabOrder = 3
      Visible = False
      OnClick = btnAddFilesClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Title = 'shexRename: Select file(s)'
    Left = 120
    Top = 8
  end
end
