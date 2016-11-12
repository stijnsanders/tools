unit DirFindReplace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfDirFindReplace = class(TForm)
    lblPattern: TLabel;
    txtReplaceWith: TMemo;
    btnOk: TButton;
    btnCancel: TButton;
  end;

var
  fDirFindReplace: TfDirFindReplace;

implementation

{$R *.dfm}

end.
