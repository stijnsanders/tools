object frmDirDiffGoToLine: TfrmDirDiffGoToLine
  Left = 191
  Top = 141
  BorderStyle = bsDialog
  Caption = 'Go to line'
  ClientHeight = 90
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 85
    Height = 16
    Caption = 'Line number:'
    FocusControl = txtLineNumber
  end
  object Label2: TLabel
    Left = 112
    Top = 8
    Width = 48
    Height = 16
    Caption = 'Where:'
    FocusControl = cbWhere
  end
  object txtLineNumber: TEdit
    Left = 8
    Top = 24
    Width = 97
    Height = 24
    TabOrder = 0
    OnKeyPress = txtLineNumberKeyPress
  end
  object cbWhere: TComboBox
    Left = 112
    Top = 24
    Width = 97
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 1
    Text = 'Any'
    Items.Strings = (
      'Any')
  end
  object btnOK: TButton
    Left = 8
    Top = 56
    Width = 97
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 112
    Top = 56
    Width = 97
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
