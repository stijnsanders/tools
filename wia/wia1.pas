unit wia1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    txtFolder: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  protected
    procedure DoShow; override;
  end;

var
  Form1: TForm1;

implementation

uses ActiveX, WIA_TLB, JPEG, FileCtrl, Math;

{$R *.dfm}

procedure TForm1.DoShow;
begin
  inherited;
  OleInitialize(nil);
end;

const
  wiaFormatBMP='{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}';
  wiaFormatPNG='{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}';
  wiaFormatGIF='{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}';
  wiaFormatJPEG='{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}';
  wiaFormatTIFF='{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}';

procedure TForm1.Button1Click(Sender: TObject);
var
  f:WideString;
  x:IImageFile;
  p:IImageProcess;
  u,v,w:OleVariant;
  n:integer;
  d,fn:string;
begin
  f:='';//wiaFormatJPEG;
  x:=CoCommonDialog.Create.ShowAcquireImage(
    ScannerDeviceType,
    ColorIntent,//UnspecifiedIntent,
    0,//MaximizeQuality
    f,
    false,//AlwaysSelectDevice
    false,//UseCommonUI
    true);//CancelError

  p:=CoImageProcess.Create;
  v:='Convert';
  p.Filters.Add(p.FilterInfos[v].FilterID,0);
  u:=wiaFormatJPEG;
  v:=1;
  w:='FormatID';
  p.Filters[v].Properties[w].Set_Value(u);

  x:=p.Apply(x);

  d:=IncludeTrailingPathDelimiter(txtFolder.Text);
  n:=1;
  while FileExists(d+Format('%.3d',[n])+'.jpg') do inc(n);

  fn:=d+Format('%.3d',[n])+'.jpg';
  x.SaveFile(fn);
  Label2.Caption:=fn;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  s:string;
begin
  s:=txtFolder.Text;
  if SelectDirectory('Destination Folder','',s) then
    txtFolder.Text:=s;
end;

end.
