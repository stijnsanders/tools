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
    Timer1: TTimer;
    odSoundFile: TOpenDialog;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tsIgn: TTabSheet;
    cbLeftSingle: TCheckBox;
    cbLeftDouble: TCheckBox;
    cbLeftDrag: TCheckBox;
    cbRightSingle: TCheckBox;
    cbRightDouble: TCheckBox;
    cbRightDrag: TCheckBox;
    cbWheel: TCheckBox;
    cbCountDown: TCheckBox;
    cbSuspend: TCheckBox;
    cbSettings: TCheckBox;
    cbClose: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    txtInterval: TEdit;
    udInterval: TUpDown;
    panDemo1: TPanel;
    panDemo2: TPanel;
    cbPlaySound: TCheckBox;
    btnSoundPlay: TButton;
    btnSoundSelect: TButton;
    Label2: TLabel;
    panBackground1: TPanel;
    panBackground2: TPanel;
    Label3: TLabel;
    panFont: TPanel;
    Timer2: TTimer;
    lbIgnores: TListBox;
    btnIgnAdd: TButton;
    btnIgnDel: TButton;
    tsIgnNew: TTabSheet;
    rbIgnClass: TRadioButton;
    rbIgnText: TRadioButton;
    rbIgnPath: TRadioButton;
    rbIgnFile: TRadioButton;
    btnIgnApply: TButton;
    btnTryAgain: TButton;
    txtIgnClass: TEdit;
    txtIgnText: TEdit;
    txtIgnPath: TEdit;
    txtIgnFile: TEdit;
    lblIgnTD: TLabel;
    cbOrbitL1: TCheckBox;
    cbOrbitL2: TCheckBox;
    cbOrbitLd: TCheckBox;
    cbOrbitR1: TCheckBox;
    cbOrbitR2: TCheckBox;
    cbOrbitRd: TCheckBox;
    cbOrbitW: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    rbReturnTo: TRadioGroup;
    tsCursorTag: TTabSheet;
    cbCursorTag: TCheckBox;
    Label14: TLabel;
    txtHideAfter: TEdit;
    udHideAfter: TUpDown;
    Label15: TLabel;
    Label13: TLabel;
    txtOrbitSize: TEdit;
    udOrbitSize: TUpDown;
    Label12: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    txtDragHoldY: TEdit;
    txtDragHoldX: TEdit;
    udDragHoldX: TUpDown;
    udDragHoldY: TUpDown;
    Label8: TLabel;
    Label7: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    txtCursorTagPosY: TEdit;
    txtCursorTagPosX: TEdit;
    udCursorTagPosX: TUpDown;
    udCursorTagPosY: TUpDown;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    txtCursorTagHeight: TEdit;
    txtCursorTagWidth: TEdit;
    udCursorTagWidth: TUpDown;
    udCursorTagHeight: TUpDown;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    cbCursorTagKeepOnScreen: TCheckBox;
    txtOrbitMarginX: TEdit;
    udOrbitMarginX: TUpDown;
    Label26: TLabel;
    txtOrbitMarginY: TEdit;
    udOrbitMarginY: TUpDown;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    rbOrbitShape: TRadioGroup;
    Label31: TLabel;
    txtOrbitCrossSize: TEdit;
    udOrbitCrossSize: TUpDown;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    cbAlpha: TComboBox;
    Label35: TLabel;
    cbAlphaCT: TComboBox;
    cbSkipOrbit: TCheckBox;
    cbShow: TComboBox;
    cbStartSuspended: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure panFontClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure udIntervalChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure panBackground1Click(Sender: TObject);
    procedure panBackground2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure panBackground1Enter(Sender: TObject);
    procedure panBackground1Exit(Sender: TObject);
    procedure panBackground2Enter(Sender: TObject);
    procedure panBackground2Exit(Sender: TObject);
    procedure panFontEnter(Sender: TObject);
    procedure panFontExit(Sender: TObject);
    procedure btnSoundPlayClick(Sender: TObject);
    procedure btnSoundSelectClick(Sender: TObject);
    procedure cbPlaySoundClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure btnIgnAddClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIgnDelClick(Sender: TObject);
    procedure btnTryAgainClick(Sender: TObject);
    procedure btnIgnApplyClick(Sender: TObject);
  private
    FDemoY,FIgnTD:integer;
    FSoundFilePath:string;
    procedure StartCatchWindow;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ShowSettings(SetClickMS, HideAfterMS, AlphaBlendLvl,
      AlphaBlendLvlCT:integer;
      ShowL1, ShowL2, ShowLd, ShowR1, ShowR2, ShowRd,
      ShowW, ShowCountDown, ShowZ, ShowS, ShowX: boolean;
      ShowOnMouseOver, ReturnTo: integer; ShowCursorTag,
      CursorTagKeepOnScreen, StartSuspended :boolean;
      Orbit, OrbitSize, OrbitCrossSize,
      OrbitMarginX, OrbitMarginY, OrbitShape,
      CursorTagPosX,CursorTagPosY,CursorTagWidth,CursorTagHeight: integer;
      ColorBG1, ColorBG2: TColor; Font: TFont;
      SetDragHold: TPoint; SoundFilePath: string; Ignores: TStrings);
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
  p:TPoint;
  b1,b2,bs,bc,i:integer;
begin
  if cbPlaySound.Checked and (FSoundFilePath='') then
    raise Exception.Create('Play sound selected, but no sound file is selected.');
  p.X:=udDragHoldX.Position;
  p.Y:=udDragHoldY.Position;
  b1:=0;
  if cbLeftSingle.Checked then b1:=b1 or $001;
  if cbLeftDouble.Checked then b1:=b1 or $002;
  if cbLeftDrag.Checked then b1:=b1 or $004;
  if cbRightSingle.Checked then b1:=b1 or $008;
  if cbRightDouble.Checked then b1:=b1 or $010;
  if cbRightDrag.Checked then b1:=b1 or $020;
  if cbWheel.Checked then b1:=b1 or $040;
  if cbSuspend.Checked then b1:=b1 or $080;
  if cbSettings.Checked then b1:=b1 or $100;
  if cbClose.Checked then b1:=b1 or $200;
  if cbCountDown.Checked then b1:=b1 or $400;
  b2:=0;
  if cbOrbitL1.Checked then b2:=b2 or $001;
  if cbOrbitL2.Checked then b2:=b2 or $002;
  if cbOrbitLd.Checked then b2:=b2 or $004;
  if cbOrbitR1.Checked then b2:=b2 or $008;
  if cbOrbitR2.Checked then b2:=b2 or $010;
  if cbOrbitRd.Checked then b2:=b2 or $020;
  if cbOrbitW.Checked then b2:=b2 or $040;
  if not(cbPlaySound.Checked) then FSoundFilePath:='';
  bs:=udOrbitSize.Position;
  bc:=udOrbitCrossSize.Position;
  r:=TRegistry.Create;
  try
    r.OpenKey('\Software\Double Sigma Programming\MetaClick',true);
    try
      r.WriteInteger('Interval',udInterval.Position);
      r.WriteInteger('HideAfter',udHideAfter.Position);
      r.WriteInteger('ReturnTo',rbReturnTo.ItemIndex);
      r.WriteInteger('ColorFG',panFont.Font.Color);
      r.WriteInteger('ColorBG1',panBackground1.Color);
      r.WriteInteger('ColorBG2',panBackground2.Color);
      r.WriteString('FontName',panFont.Font.Name);
      r.WriteInteger('FontSize',panFont.Font.Size);
      r.WriteBool('FontBold',fsBold in panFont.Font.Style);
      r.WriteBool('FontUnderline',fsUnderline in panFont.Font.Style);
      r.WriteBool('FontItalic',fsItalic in panFont.Font.Style);
      r.WriteInteger('AlphaLevel',cbAlpha.ItemIndex);
      r.WriteInteger('DragHoldX',p.X);
      r.WriteInteger('DragHoldY',p.Y);
      r.WriteInteger('Buttons',b1);
      r.WriteInteger('Orbit',b2);
      r.WriteInteger('OrbitSize',bs);
      r.WriteInteger('OrbitCrossSize',bc);
      r.WriteInteger('OrbitMarginX',udOrbitMarginX.Position);
      r.WriteInteger('OrbitMarginY',udOrbitMarginY.Position);
      r.WriteInteger('OrbitShape',rbOrbitShape.ItemIndex);
      r.WriteString('PlaySound',FSoundFilePath);
      r.WriteBool('CursorTag',cbCursorTag.Checked);
      r.WriteInteger('CursorTagPosX',udCursorTagPosX.Position);
      r.WriteInteger('CursorTagPosY',udCursorTagPosY.Position);
      r.WriteInteger('CursorTagWidth',udCursorTagWidth.Position);
      r.WriteInteger('CursorTagHeight',udCursorTagHeight.Position);
      r.WriteBool('CursorTagKeepOnScreen',cbCursorTagKeepOnScreen.Checked);
      r.WriteInteger('CursorTagAlphaLevel',cbAlphaCT.ItemIndex);
      r.WriteInteger('IgnoreRules',lbIgnores.Items.Count);
      for i:=0 to lbIgnores.Items.Count-1 do
        r.WriteString('IgnoreRule'+IntToStr(i+1),lbIgnores.Items[i]);
      r.WriteString('CustomColors',ColorDialog1.CustomColors.CommaText);
      r.WriteInteger('ShowOnMouseOver',cbShow.ItemIndex);
      r.WriteBool('StartSuspended',cbStartSuspended.Checked);
    except
      //silently, use defaults
    end;
    r.CloseKey;
  finally
    r.Free;
  end;
  frmMetaClick.UpdateSettings(
    udInterval.Position,udHideAfter.Position,b1,b2,bs,bc,
    udOrbitMarginX.Position,udOrbitMarginY.Position,rbOrbitShape.ItemIndex,
    rbReturnTo.ItemIndex,
    udCursorTagPosX.Position,udCursorTagPosY.Position,
    udCursorTagWidth.Position,udCursorTagHeight.Position,
    cbAlpha.ItemIndex,cbAlphaCT.ItemIndex,cbShow.ItemIndex,
    cbCursorTag.Checked,cbCursorTagKeepOnScreen.Checked,
    panBackground1.Color,panBackground2.Color,panFont.Font,
    p,FSoundFilePath,lbIgnores.Items);
  Close;
end;

procedure TfrmSettings.ShowSettings(SetClickMS, HideAfterMS,
  AlphaBlendLvl, AlphaBlendLvlCT: integer;
  ShowL1, ShowL2, ShowLd, ShowR1, ShowR2, ShowRd, ShowW, ShowCountDown,
  ShowZ, ShowS, ShowX: boolean; ShowOnMouseOver, ReturnTo: integer;
  ShowCursorTag, CursorTagKeepOnScreen, StartSuspended: boolean;
  Orbit, OrbitSize, OrbitCrossSize, OrbitMarginX, OrbitMarginY, OrbitShape,
  CursorTagPosX,CursorTagPosY,CursorTagWidth,CursorTagHeight: integer;
  ColorBG1, ColorBG2: TColor; Font: TFont;
  SetDragHold: TPoint; SoundFilePath: string; Ignores: TStrings);
begin
  udInterval.Position:=SetClickMS;
  udHideAfter.Position:=HideAfterMS;
  cbLeftSingle.Checked:=ShowL1;
  cbLeftDouble.Checked:=ShowL2;
  cbLeftDrag.Checked:=ShowLd;
  cbRightSingle.Checked:=ShowR1;
  cbRightDouble.Checked:=ShowR2;
  cbRightDrag.Checked:=ShowRd;
  cbWheel.Checked:=ShowW;
  cbCountDown.Checked:=ShowCountDown;
  cbSuspend.Checked:=ShowZ;
  cbSettings.Checked:=ShowS;
  cbClose.Checked:=ShowX;
  cbOrbitL1.Checked:=(Orbit and $001)<>0;
  cbOrbitL2.Checked:=(Orbit and $002)<>0;
  cbOrbitLd.Checked:=(Orbit and $004)<>0;
  cbOrbitR1.Checked:=(Orbit and $008)<>0;
  cbOrbitR2.Checked:=(Orbit and $010)<>0;
  cbOrbitRd.Checked:=(Orbit and $020)<>0;
  cbOrbitW.Checked:=(Orbit and $040)<>0;
  udOrbitSize.Position:=OrbitSize;
  udOrbitCrossSize.Position:=OrbitCrossSize;
  udOrbitMarginX.Position:=OrbitMarginX;
  udOrbitMarginY.Position:=OrbitMarginY;
  rbOrbitShape.ItemIndex:=OrbitShape;
  rbReturnTo.ItemIndex:=ReturnTo;
  panBackground1.Color:=ColorBG1;
  panBackground2.Color:=ColorBG2;
  panDemo1.Color:=ColorBG1;
  panDemo2.Color:=ColorBG2;
  panFont.Font:=Font;
  cbAlpha.ItemIndex:=AlphaBlendLvl;
  cbShow.ItemIndex:=ShowOnMouseOver;
  cbStartSuspended.Checked:=StartSuspended;
  udDragHoldX.Position:=SetDragHold.X;
  udDragHoldY.Position:=SetDragHold.Y;
  cbPlaySound.Checked:=not(SoundFilePath='');
  cbCursorTag.Checked:=ShowCursorTag;
  udCursorTagPosX.Position:=CursorTagPosX;
  udCursorTagPosY.Position:=CursorTagPosY;
  udCursorTagWidth.Position:=CursorTagWidth;
  udCursorTagHeight.Position:=CursorTagHeight;
  cbCursorTagKeepOnScreen.Checked:=CursorTagKeepOnScreen;
  cbAlphaCT.ItemIndex:=AlphaBlendLvlCT;
  FSoundFilePath:=SoundFilePath;
  lbIgnores.Items.Assign(Ignores);
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

procedure TfrmSettings.Timer1Timer(Sender: TObject);
var
  y,sy,ty:integer;
begin
  ty:=udInterval.Position div 10;//Timer1.Interval;
  if ty=0 then ty:=1;
  sy:=panDemo1.ClientHeight-4;
  inc(FDemoY);
  y:=FDemoY*sy div ty;
  panDemo2.SetBounds(2,sy-y+2,panDemo1.ClientWidth-4,y);
  if FDemoY>=ty then Timer1.Enabled:=false;
end;

procedure TfrmSettings.udIntervalChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  FDemoY:=0;
  Timer1.Enabled:=true;
end;

procedure TfrmSettings.panBackground1Click(Sender: TObject);
begin
  ColorDialog1.Color:=panBackground1.Color;
  if ColorDialog1.Execute then
   begin
    panBackground1.Color:=ColorDialog1.Color;
    panDemo1.Color:=ColorDialog1.Color;
   end;
end;

procedure TfrmSettings.panBackground2Click(Sender: TObject);
begin
  ColorDialog1.Color:=panBackground2.Color;
  if ColorDialog1.Execute then
   begin
    panBackground2.Color:=ColorDialog1.Color;
    panDemo2.Color:=ColorDialog1.Color;
   end;
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

procedure TfrmSettings.btnSoundPlayClick(Sender: TObject);
begin
  if not(sndPlaySound(PAnsiChar(FSoundFilePath),SND_ASYNC)) then RaiseLastOSError;
end;

procedure TfrmSettings.btnSoundSelectClick(Sender: TObject);
begin
  odSoundFile.FileName:=FSoundFilePath;
  if odSoundFile.Execute then FSoundFilePath:=odSoundFile.FileName;
end;

procedure TfrmSettings.cbPlaySoundClick(Sender: TObject);
begin
  if Visible and cbPlaySound.Checked and (FSoundFilePath='') then btnSoundSelect.Click;
end;

procedure TfrmSettings.Image1Click(Sender: TObject);
begin
  Clipboard.AsText:='17E8FTNMbWyVuuT3Z5UGfogtmcLG7WjYmd';
end;

procedure TfrmSettings.btnIgnAddClick(Sender: TObject);
begin
  StartCatchWindow;
end;

procedure TfrmSettings.StartCatchWindow;
begin
  if MessageBox(Handle,'After you click [OK] here, move the mouse-pointer '+
    'over the window to ignore, then count 5 seconds '+
    'and see if the correct settings appear here.',
    'MetaClick',MB_OKCANCEL or MB_ICONINFORMATION)=idOK then
   begin
    txtIgnClass.Text:='...';
    txtIgnText.Text:='...';
    txtIgnPath.Text:='...';
    txtIgnFile.Text:='...';
    Timer2.Enabled:=true;
    PageControl1.ActivePage:=tsIgnNew;
    rbIgnClass.Checked:=true;
    FIgnTD:=5;
    lblIgnTD.Caption:=IntToStr(FIgnTD);
    lblIgnTD.Visible:=true;
   end;
end;

procedure TfrmSettings.Timer2Timer(Sender: TObject);
var
  h,h1:THandle;
  pid:cardinal;
  s:string;
begin
  dec(FIgnTD);
  if FIgnTD=0 then
   begin
    lblIgnTD.Visible:=false;
    Timer2.Enabled:=false;
    //h:=GetForegroundWindow;
    h:=GetAncestor(WindowFromPoint(Mouse.CursorPos),GA_ROOT);
    SetLength(s,$400);
    SetLength(s,GetClassName(h,PChar(s),$400));
    txtIgnClass.Text:=s;
    SetLength(s,$400);
    SetLength(s,GetWindowText(h,PChar(s),$400));
    txtIgnText.Text:=s;
    SetLength(s,$400);
    if @GetModuleFileNameEx=nil then
      SetLength(s,GetWindowModuleFileName(h,PChar(s),$400))
    else
     begin
      GetWindowThreadProcessId(h,pid);
      h1:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,pid);
      SetLength(s,GetModuleFileNameEx(h1,0,PChar(s),$400));
      CloseHandle(h1);
     end;
    if s='' then
     begin
      rbIgnPath.Enabled:=false;
      rbIgnFile.Enabled:=false;
      txtIgnPath.Text:='';
      txtIgnFile.Text:='';
     end
    else
     begin
      rbIgnPath.Enabled:=true;
      rbIgnFile.Enabled:=true;
      txtIgnPath.Text:=s;
      txtIgnFile.Text:=ExtractFileName(s);
     end;
   end
  else
    lblIgnTD.Caption:=IntToStr(FIgnTD);
end;

procedure TfrmSettings.FormShow(Sender: TObject);
var
  r:TRegistry;
begin
  Constraints.MinWidth:=Width;
  Constraints.MinHeight:=Height;
  Constraints.MaxWidth:=Width;
  Constraints.MaxHeight:=Height;
  r:=TRegistry.Create;
  try
    if r.OpenKeyReadOnly('\Software\Double Sigma Programming\MetaClick') then
      ColorDialog1.CustomColors.CommaText:=r.ReadString('CustomColors');
  except
    //silently, use defaults
  end;
  r.Free;
end;

procedure TfrmSettings.btnIgnDelClick(Sender: TObject);
begin
  if lbIgnores.ItemIndex<>-1 then
    lbIgnores.Items.Delete(lbIgnores.ItemIndex);
end;

procedure TfrmSettings.btnTryAgainClick(Sender: TObject);
begin
  StartCatchWindow;
end;

procedure TfrmSettings.btnIgnApplyClick(Sender: TObject);
var
  s:string;
begin
  if cbSkipOrbit.Checked then s:='°:' else s:=':';
  if rbIgnClass.Checked then lbIgnores.Items.Add('Class'+s+txtIgnClass.Text);
  if rbIgnText.Checked then lbIgnores.Items.Add('Text'+s+txtIgnText.Text);
  if rbIgnPath.Checked then lbIgnores.Items.Add('Path'+s+txtIgnPath.Text);
  if rbIgnFile.Checked then lbIgnores.Items.Add('File'+s+txtIgnFile.Text);
  PageControl1.ActivePage:=tsIgn;
end;

initialization
  frmSettings:=nil;

end.
