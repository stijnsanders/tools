unit ddPrefs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmDirDiffPrefs = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    btnFont: TButton;
    FontDialog1: TFontDialog;
    cbXmlIndentTags: TCheckBox;
    cbXmlAttrLines: TCheckBox;
    cbXmlAttrIgnSeq: TCheckBox;
    cbXmlElemIgnSeq: TCheckBox;
    cbXmlPreserveWhitespace: TCheckBox;
    cbCollapseEmpty: TCheckBox;
    cbXmlCdataAsText: TCheckBox;
    cbDetectNS: TCheckBox;
    Label1: TLabel;
    txtXmlDefAttrs: TMemo;
    Label2: TLabel;
    txtSkipFiles: TEdit;
    cbIgnoreDates: TCheckBox;
    cbIgnoreWhitespace: TCheckBox;
    cbIgnoreCase: TCheckBox;
    cbWideTabs: TCheckBox;
    cbEOLMarkers: TCheckBox;
    Label3: TLabel;
    cbSearchCaseSensitive: TCheckBox;
    cbSearchOnlyDiffLines: TCheckBox;
    procedure btnFontClick(Sender: TObject);
  end;

var
  frmDirDiffPrefs: TfrmDirDiffPrefs;

implementation

{$R *.dfm}

procedure TfrmDirDiffPrefs.btnFontClick(Sender: TObject);
begin
  FontDialog1.Execute;
end;

end.
