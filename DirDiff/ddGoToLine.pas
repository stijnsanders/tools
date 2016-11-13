unit ddGoToLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmDirDiffGoToLine = class(TForm)
    Label1: TLabel;
    txtLineNumber: TEdit;
    Label2: TLabel;
    cbWhere: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure txtLineNumberKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDirDiffGoToLine: TfrmDirDiffGoToLine;

implementation

{$R *.dfm}

procedure TfrmDirDiffGoToLine.txtLineNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0'..'9']) then Key:=#0;
end;

end.
