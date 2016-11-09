unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    Image1: TImage;
    PageControl1: TPageControl;
    tbDisplay: TTabSheet;
    tbKbl: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    panBackground1: TPanel;
    panBackground2: TPanel;
    panFont: TPanel;
    rbAlphaBlend: TRadioGroup;
    lbKbl: TListBox;
    txtKblInfo: TMemo;
    TabSheet1: TTabSheet;
    cbRepeat: TCheckBox;
    txtDelay: TEdit;
    udDelay: TUpDown;
    udRepeat: TUpDown;
    txtRepeat: TEdit;
    lblDelay: TLabel;
    lblRepeat: TLabel;
    lblCPS: TLabel;
    cbShow: TComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure panFontClick(Sender: TObject);
    procedure panBackground1Click(Sender: TObject);
    procedure panBackground2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure panBackground1Enter(Sender: TObject);
    procedure panBackground1Exit(Sender: TObject);
    procedure panBackground2Enter(Sender: TObject);
    procedure panBackground2Exit(Sender: TObject);
    procedure panFontEnter(Sender: TObject);
    procedure panFontExit(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbKblClick(Sender: TObject);
    procedure DelayRateChange(Sender: TObject);
  private
    Fkbl:string;
    FkblI:integer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ShowSettings(ColorBG1, ColorBG2: TColor; Font: TFont;
      AlphaBlend: integer; kbl:string; dorepeat: boolean;
      delayMS, repeatMS, ShowOnMouseOver: integer);
  end;

var
  frmSettings: TfrmSettings;

implementation

uses Main, Registry, MMSystem, Clipbrd;

{$R *.dfm}

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSettings.btnOkClick(Sender: TObject);
var
  r:TRegistry;
  s:string;
  i,l:integer;
begin
  if lbKbl.ItemIndex<0 then
    raise Exception.Create('Please select a keyboard layout');
  if lbKbl.ItemIndex<>FkblI then
   begin
    s:=lbKbl.Items[lbKbl.ItemIndex];
    l:=Length(s);
    i:=1;
    while (i<l) and (s[i]<>':') do inc(i);
    Fkbl:=Copy(s,1,i-1)+'.kbl';
   end;
  r:=TRegistry.Create;
  r.OpenKey('\Software\Double Sigma Programming\MetaKeys',true);
  try
    r.WriteInteger('ColorFG',panFont.Font.Color);
    r.WriteInteger('ColorBG1',panBackground1.Color);
    r.WriteInteger('ColorBG2',panBackground2.Color);
    r.WriteString('FontName',panFont.Font.Name);
    r.WriteInteger('FontSize',panFont.Font.Size);
    r.WriteBool('FontBold',fsBold in panFont.Font.Style);
    r.WriteBool('FontUnderline',fsUnderline in panFont.Font.Style);
    r.WriteBool('FontItalic',fsItalic in panFont.Font.Style);
    r.WriteInteger('AlphaLevel',4-((AlphaBlendValue+1) div 64));
    r.WriteString('KeyboardLayout',Fkbl);
    r.WriteBool('Repeat',cbRepeat.Checked);
    r.WriteInteger('DelayMS',udDelay.Position);
    r.WriteInteger('RepeatMS',udRepeat.Position);
    r.WriteInteger('ShowOnMouseOver',cbShow.ItemIndex);
  except
    //silently, use defaults
  end;
  r.CloseKey;
  r.Free;
  frmMetaKeys.UpdateSettings(
    panBackground1.Color,
    panBackground2.Color,
    panFont.Font,
    rbAlphaBlend.ItemIndex,
    cbShow.ItemIndex,
    cbRepeat.Checked,
    udDelay.Position,
    udRepeat.Position);
  if lbKbl.ItemIndex<>FkblI then
    frmMetaKeys.LoadKeys(Fkbl);
  Close;
end;

procedure TfrmSettings.ShowSettings(ColorBG1, ColorBG2: TColor; Font: TFont;
  AlphaBlend: integer; kbl:string; dorepeat: boolean;
  delayMS, repeatMS, ShowOnMouseOver: integer);
var
  i,l:integer;
  x:string;
begin
  panBackground1.Color:=ColorBG1;
  panBackground2.Color:=ColorBG2;
  panFont.Font:=Font;
  rbAlphaBlend.ItemIndex:=AlphaBlend;
  Fkbl:=kbl;
  x:=ChangeFileExt(kbl,':');
  i:=0;
  l:=Length(x);
  while (i<lbKbl.Items.Count) and (CompareText(Copy(lbKbl.Items[i],1,l),x)<>0) do inc(i);
  if i<lbKbl.Items.Count then FkblI:=i else FkblI:=-1;
  lbKbl.ItemIndex:=FkblI;
  lbKblClick(nil);
  cbRepeat.Checked:=dorepeat;
  udDelay.Position:=delayMS;
  udRepeat.Position:=repeatMS;
  cbShow.ItemIndex:=ShowOnMouseOver;
  Show;
  SetForegroundWindow(Handle);
end;

procedure TfrmSettings.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
end;

procedure TfrmSettings.panFontClick(Sender: TObject);
begin
  FontDialog1.Font:=(Sender as TPanel).Font;
  if FontDialog1.Execute then
    (Sender as TPanel).Font:=FontDialog1.Font;
end;

procedure TfrmSettings.panBackground1Click(Sender: TObject);
begin
  ColorDialog1.Color:=panBackground1.Color;
  if ColorDialog1.Execute then
    panBackground1.Color:=ColorDialog1.Color;
end;

procedure TfrmSettings.panBackground2Click(Sender: TObject);
begin
  ColorDialog1.Color:=panBackground2.Color;
  if ColorDialog1.Execute then
    panBackground2.Color:=ColorDialog1.Color;
end;

procedure TfrmSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmSettings:=nil;
  Action:=caFree;
end;

procedure TfrmSettings.panBackground1Enter(Sender: TObject);
begin
  panBackground1.BevelOuter:=bvLowered;
end;

procedure TfrmSettings.panBackground1Exit(Sender: TObject);
begin
  panBackground1.BevelOuter:=bvRaised;
end;

procedure TfrmSettings.panBackground2Enter(Sender: TObject);
begin
  panBackground2.BevelOuter:=bvLowered;
end;

procedure TfrmSettings.panBackground2Exit(Sender: TObject);
begin
  panBackground2.BevelOuter:=bvRaised;
end;

procedure TfrmSettings.panFontEnter(Sender: TObject);
begin
  panFont.BevelOuter:=bvLowered;
end;

procedure TfrmSettings.panFontExit(Sender: TObject);
begin
  panFont.BevelOuter:=bvRaised;
end;

procedure TfrmSettings.Image1Click(Sender: TObject);
begin
  Clipboard.AsText:='17E8FTNMbWyVuuT3Z5UGfogtmcLG7WjYmd';
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
var
  fd:TWin32FindData;
  fh:THandle;
  fn:string;
  sl:TStringList;
  i:integer;
begin
  fh:=FindFirstFile('*.kbl',fd);
  if fh<>INVALID_HANDLE_VALUE then
   begin
    sl:=TStringList.Create;
    lbKbl.Items.BeginUpdate;
    try
      repeat
        fn:=fd.cFileName;
        sl.LoadFromFile(fn);
        i:=0;
        while (i<sl.Count) and not(Copy(sl[i],1,1)='i') do inc(i);
        if i<sl.Count then
          lbKbl.Items.Add(Copy(fn,1,Length(fn)-4)+': '+Trim(Copy(sl[i],2,Length(sl[i])-1)));
      until not FindNextFile(fh,fd);
    finally
      lbKbl.Items.EndUpdate;
      Windows.FindClose(fh);
      sl.Free;
    end;
   end;
end;

procedure TfrmSettings.lbKblClick(Sender: TObject);
var
  sl:TStringList;
  s:string;
  i,l:integer;
begin
  if lbKbl.ItemIndex<0 then
    txtKblInfo.Clear
  else
   begin
    s:=lbKbl.Items[lbKbl.ItemIndex];
    l:=Length(s);
    i:=1;
    while (i<l) and (s[i]<>':') do inc(i);
    sl:=TStringList.Create;
    txtKblInfo.Lines.BeginUpdate;
    try
      txtKblInfo.Lines.Clear;
      sl.LoadFromFile(Copy(s,1,i-1)+'.kbl');
      for i:=0 to sl.Count-1 do
       begin
        s:=sl[i];
        if (s<>'') and (s[1]='i') then
          txtKblInfo.Lines.Add(Trim(Copy(s,2,Length(s)-1)));
       end;
    finally
      sl.Free;
      txtKblInfo.Lines.EndUpdate;
    end;
   end;
end;

procedure TfrmSettings.DelayRateChange(Sender: TObject);
begin
  lblCPS.Caption:=Format('~%.2f %.2f per sec',
    [1000/udDelay.Position,1000/udRepeat.Position]);
end;

initialization
  frmSettings:=nil;

end.
