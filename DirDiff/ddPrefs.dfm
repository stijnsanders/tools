object frmDirDiffPrefs: TfrmDirDiffPrefs
  Left = 191
  Top = 141
  BorderStyle = bsDialog
  Caption = 'DirDiff Preferences'
  ClientHeight = 410
  ClientWidth = 330
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
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 313
    Height = 361
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      BorderWidth = 4
      Caption = '&Configuration'
      object Label2: TLabel
        Left = 0
        Top = 32
        Width = 176
        Height = 16
        Caption = '&Ignore files/folders (regex)'
        FocusControl = txtSkipFiles
      end
      object btnFont: TButton
        Left = 0
        Top = 0
        Width = 97
        Height = 25
        Caption = '&Font...'
        TabOrder = 0
        OnClick = btnFontClick
      end
      object txtSkipFiles: TEdit
        Left = 0
        Top = 48
        Width = 297
        Height = 24
        TabOrder = 1
      end
      object cbIgnoreDates: TCheckBox
        Left = 0
        Top = 72
        Width = 297
        Height = 17
        Caption = 'Ignore file/folder &date'
        TabOrder = 2
      end
      object cbIgnoreWhitespace: TCheckBox
        Left = 0
        Top = 96
        Width = 297
        Height = 17
        Caption = 'Ignore &whitespace'
        TabOrder = 3
      end
      object cbIgnoreCase: TCheckBox
        Left = 0
        Top = 112
        Width = 297
        Height = 17
        Caption = 'Ignore c&ase'
        TabOrder = 4
      end
      object cbWideTabs: TCheckBox
        Left = 0
        Top = 128
        Width = 297
        Height = 17
        Caption = 'Wide &tabs (8 vs 4)'
        TabOrder = 5
      end
      object cbEOLMarkers: TCheckBox
        Left = 0
        Top = 144
        Width = 297
        Height = 17
        Caption = '&End of line marker'
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      BorderWidth = 4
      Caption = '&XML'
      ImageIndex = 1
      object Label1: TLabel
        Left = 0
        Top = 168
        Width = 222
        Height = 16
        Caption = 'D&efining attributes (one per line):'
        FocusControl = txtXmlDefAttrs
      end
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 297
        Height = 33
        AutoSize = False
        Caption = 
          'Warning: line-numbers displayed may not match actual line-number' +
          's in the XML file(s)'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInfoText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        WordWrap = True
      end
      object cbXmlIndentTags: TCheckBox
        Left = 0
        Top = 32
        Width = 297
        Height = 17
        Caption = '&Indent tags'
        TabOrder = 0
      end
      object cbXmlAttrLines: TCheckBox
        Left = 0
        Top = 48
        Width = 297
        Height = 17
        Caption = '&Attributes on separate lines'
        TabOrder = 1
      end
      object cbXmlAttrIgnSeq: TCheckBox
        Left = 0
        Top = 64
        Width = 297
        Height = 17
        Caption = 'Ignore attribute se&quence'
        TabOrder = 2
      end
      object cbXmlElemIgnSeq: TCheckBox
        Left = 0
        Top = 80
        Width = 297
        Height = 17
        Caption = 'I&gnore element sequence'
        TabOrder = 3
      end
      object cbXmlPreserveWhitespace: TCheckBox
        Left = 0
        Top = 96
        Width = 297
        Height = 17
        Caption = '&Preserve whitespace'
        TabOrder = 4
      end
      object cbCollapseEmpty: TCheckBox
        Left = 0
        Top = 112
        Width = 297
        Height = 17
        Caption = '&Collapse empty tags'
        TabOrder = 5
      end
      object cbXmlCdataAsText: TCheckBox
        Left = 0
        Top = 128
        Width = 297
        Height = 17
        Caption = '&Treat CDATA sections as text'
        TabOrder = 6
      end
      object cbDetectNS: TCheckBox
        Left = 0
        Top = 144
        Width = 297
        Height = 17
        Caption = '&Detect namespaces'
        TabOrder = 7
      end
      object txtXmlDefAttrs: TMemo
        Left = 0
        Top = 184
        Width = 297
        Height = 137
        ScrollBars = ssBoth
        TabOrder = 8
        WordWrap = False
      end
    end
  end
  object btnOK: TButton
    Left = 120
    Top = 376
    Width = 97
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 224
    Top = 376
    Width = 97
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 4
    Top = 371
  end
end
