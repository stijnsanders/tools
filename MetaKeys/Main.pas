unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, ExtCtrls, StdCtrls, Menus;

const
  KeyDefModMax=5;
  WM_KEYHOT=WM_USER+1;

type
  TfrmMetaKeys = class(TForm)
    panMain: TPanel;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    N2: TMenuItem;
    Settings1: TMenuItem;
    imgResize: TImage;
    tiDelay: TTimer;
    tiRepeat: TTimer;
    tiMouseOver: TTimer;
    tiCheckKeyV: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AllMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure AllMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AllMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure imgResizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure KeyXMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure KeyXMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tiDelayTimer(Sender: TObject);
    procedure tiRepeatTimer(Sender: TObject);
    procedure tiMouseOverTimer(Sender: TObject);
    procedure tiCheckKeyVTimer(Sender: TObject);
  private
    IsMoving,IsMovingStarted,IsResizing,IsPopUp,DoRepeat,IsMOver:boolean;
    Corners:HRGN;
    DoRepeatIdx,FShowOnMouseOver,FAlphaLevel:integer;
    StartDrag,StartPos,LastPos:TPoint;
    Clr1,Clr2:TColor;
    KeyDefFile:string;
    KeyDefHot:TPanel;
    KeyDefHotTC:cardinal;
    KeyDefMod:array[0..KeyDefModMax] of integer;
    KeyDefCount,KeyRows,KeyCols,KeyV:integer;
    KeyDefs:array of record
      s1,s2,s3:string;
      x,y,vk,h,w:integer;
      p:TPanel;
    end;
    function IsClicked: boolean;
    procedure ArrangeButtons;
    procedure SetKeyV(v:integer);
    procedure KeyXClick(i:integer;Mods:integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMKeyHot(var Msg: TMessage); message WM_KEYHOT;
  public
    procedure LoadKeys(kbl:string);
    procedure UpdateSettings(ColorBG1, ColorBG2: TColor; Font1: TFont;
      AlphaBlendLevel, AShowOnMouseOver: integer; ADoRepeat:boolean;
      ADelayInterval, ARepeatInterval: integer);
  end;

var
  frmMetaKeys: TfrmMetaKeys;

implementation

uses Settings, Math, MMSystem, Types, UITypes;

const
  SysDragHoldX=4;//GetSystemMetrics(SM_CXDRAG)
  SysDragHoldY=4;//GetSystemMetrics(SM_CYDRAG)

{$R *.dfm}

procedure TfrmMetaKeys.FormClose(Sender: TObject; var Action: TCloseAction);
var
  sl:TStringList;
  fn:string;
begin
  fn:=ChangeFileExt(ParamStr(0),'.ini');
  sl:=TStringList.Create;
  try
    try
      sl.LoadFromFile(fn);
    except
      on EFOpenError do ; //ignore
    end;
    sl.Values['Top']:=IntToStr(Top);
    sl.Values['Left']:=IntToStr(Left);
    sl.Values['Width']:=IntToStr(Width);
    sl.Values['Height']:=IntToStr(Height);
    sl.SaveToFile(fn);
  finally
    sl.Free;
  end;
  //if Corners<>0 then DeleteObject(Corners);
end;

procedure CheckMin(var a:integer;b:integer);
begin
  if a<b then a:=b;
end;

procedure CheckMax(var a:integer;b:integer);
begin
  if a>b then a:=b;
end;

procedure TfrmMetaKeys.FormCreate(Sender: TObject);
var
  sl:TStringList;
  f:TFont;
  r0:boolean;
  x,y,sx,sy,abl,r1,r2:integer;
  dr:TRect;
  kbl,s,fn:string;
const
  MinimalShowMargin=16;
begin
  IsMoving:=false;
  IsResizing:=false;
  IsPopUp:=false;
  IsMOver:=false;
  Corners:=0;
  LastPos:=Mouse.CursorPos;
  KeyDefFile:='';
  KeyDefHot:=nil;
  KeyV:=0;//see also LoadKeys
  for x:=0 to KeyDefModMax do KeyDefMod[KeyDefModMax]:=0;

  //default values
  Clr1:=$DDCCBB;//$00CCFF;//yellow
  Clr2:=$CC6666;//$0000CC;//red
  dr:=Screen.DesktopRect;
  x:=dr.Right-440;//Left;
  y:=dr.Bottom-220;//Top;
  sx:=400;
  sy:=180;
  abl:=1;
  kbl:='';
  r0:=true;
  r1:=500;
  r2:=50;
  FShowOnMouseOver:=0;

  //load settings (excessive silent try/except's here are for easy upgradability)
  f:=TFont.Create;
  sl:=TStringList.Create;
  fn:=ChangeFileExt(ParamStr(0),'.ini');
  try
    sl.LoadFromFile(fn);
    x:=StrToInt(sl.Values['Left']);
    y:=StrToInt(sl.Values['Top']);
    sx:=StrToInt(sl.Values['Width']);
    sy:=StrToInt(sl.Values['Height']);
    CheckMin(sx,Constraints.MinWidth);
    CheckMax(sx,dr.Right-dr.Left);
    CheckMin(sy,Constraints.MinHeight);
    CheckMax(sy,dr.Bottom-dr.Top);
    CheckMin(x,dr.Left-sx+MinimalShowMargin);
    CheckMax(x,dr.Right-MinimalShowMargin);
    CheckMin(y,dr.Top-sy+MinimalShowMargin);
    CheckMax(y,dr.Bottom-MinimalShowMargin);
    r0:=sl.Values['Repeat']='1';
    r1:=StrToInt(sl.Values['DelayMS']);
    r2:=StrToInt(sl.Values['RepeatMS']);
  except
    //silent use defaults
  end;
  try
    f.Color:=StrToInt('$'+sl.Values['ColorFG']);
    f.Name:=sl.Values['FontName'];
    f.Size:=StrToInt(sl.Values['FontSize']);
    if sl.Values['FontBold']='1' then f.Style:=f.Style+[fsBold];
    if sl.Values['FontUnderline']='1' then f.Style:=f.Style+[fsUnderline];
    if sl.Values['FontItalic']='1' then f.Style:=f.Style+[fsItalic];
    abl:=StrToInt(sl.Values['AlphaLevel']);
    kbl:=sl.Values['KeyboardLayout'];
    FShowOnMouseOver:=StrToInt(sl.Values['ShowOnMouseOver']);
  except
    //silent use defaults
  end;
  try
    UpdateSettings(
      StrToInt('$'+sl.Values['ColorBG1']),
      StrToInt('$'+sl.Values['ColorBG2']),
      f,abl,FShowOnMouseOver,r0,r1,r2);
  except
    //silently, use defaults, force first arrange
    ArrangeButtons;
  end;
  sl.Free;
  f.Free;
  if kbl='' then
    Settings1Click(nil)
  else
   begin
    r1:=1;
    while r1<=ParamCount do
     begin
      s:=ParamStr(r1);
      if (Length(s)>=2) and (s[1]='/') then
        case s[2] of
          'p','P':
           begin
            r2:=3;
            x:=0;
            while (r2<=Length(s)) and (s[r2]<>',') do
             begin
              x:=x*10+(byte(s[r2]) and $F);
              inc(r2);
             end;
            inc(r2);
            y:=0;
            while (r2<=Length(s)) and (s[r2]<>',') do
             begin
              y:=y*10+(byte(s[r2]) and $F);
              inc(r2);
             end;
            inc(r2);
            sx:=0;
            while (r2<=Length(s)) and (s[r2]<>',') do
             begin
              sx:=sx*10+(byte(s[r2]) and $F);
              inc(r2);
             end;
            inc(r2);
            sy:=0;
            while (r2<=Length(s)) and (s[r2]<>',') do
             begin
              sy:=sy*10+(byte(s[r2]) and $F);
              inc(r2);
             end;
           end;
          '?':MessageBox(Handle,'MetaKeys command line options:'#13#10+
            '<keyboard layout file>'#13#10+
            '/p<x>,<y>,<w>,<h>  window position'#13#10,
            'MetaKeys',MB_OK or MB_ICONINFORMATION);
          //more?
          else MessageBox(Handle,PChar('Unknown option '+s),
            'MetaKeys',MB_OK or MB_ICONINFORMATION);
        end
      else
        kbl:=s;
      inc(r1);
     end;
    SetBounds(x,y,sx,sy);
    LoadKeys(kbl);
   end;
end;

procedure TfrmMetaKeys.LoadKeys(kbl:string);
const
  MaxFontDefs=8;
var
  sl:TStringList;
  i,j,k,l,m,x,y:integer;
  s:string;
  t:array[0..3] of string;
  u:array[0..MaxFontDefs-1] of record
    n:char;
    f:string;
  end;
  p:TPanel;
begin
  sl:=TStringList.Create;
  try
    for i:=0 to MaxFontDefs-1 do u[i].n:=#0;
    for i:=0 to Length(KeyDefs)-1 do FreeAndNil(KeyDefs[i].p);
    sl.LoadFromFile(kbl);
    i:=0;
    x:=0;
    y:=0;
    KeyCols:=0;
    KeyDefCount:=sl.Count;
    SetLength(KeyDefs,sl.Count);
    if (GetKeyState(VK_CAPITAL) and 1)=0 then KeyV:=1 else KeyV:=2;
    while i<sl.Count do
     begin
      KeyDefs[i].p:=nil;
      s:=Trim(sl[i]);
      l:=Length(s);
      j:=2;
      if l<>0 then
        try
          case s[1] of
            'i':;//info
            'f'://font def
             begin
              j:=0;
              while (j<MaxFontDefs) and (u[j].n<>#0) do inc(j);
              if j=MaxFontDefs then
                raise Exception.Create('Maximum font definitions exceeded');
              u[j].n:=s[2];
              u[j].f:=Trim(Copy(s,3,l-2));
             end;
            'l'://new line
             begin
              inc(y);
              if x>KeyCols then KeyCols:=x;
              x:=0;
              KeyDefs[i].p:=nil;
              KeyDefs[i].vk:=0;
             end;
            's'://spacer
              inc(x);
            'k','c'://key
             begin
              p:=TPanel.Create(Self);
              p.Parent:=panMain;
              p.ParentColor:=True;
              KeyDefs[i].p:=p;
              KeyDefs[i].x:=x;
              KeyDefs[i].y:=y;
              //width modifier
              if (j<=l) and (AnsiChar(s[j]) in ['0'..'9']) then
               begin
                KeyDefs[i].w:=0;
                while (j<=l) and (AnsiChar(s[j]) in ['0'..'9']) do
                 begin
                  KeyDefs[i].w:=KeyDefs[i].w*10+(byte(s[j]) and $F);
                  inc(j);
                 end;
               end
              else
                KeyDefs[i].w:=1;
              //height modifier
              if (j<=l) and (s[j]=',') then
               begin
                inc(j);
                KeyDefs[i].h:=0;
                while (j<=l) and (AnsiChar(s[j]) in ['0'..'9']) do
                 begin
                  KeyDefs[i].h:=KeyDefs[i].h*10+(byte(s[j]) and $F);
                  inc(j);
                 end;
               end
              else
                KeyDefs[i].h:=1;
              //font modifier
              if (j<=l) and (s[j]<>' ') then
               begin
                k:=0;
                while (k<MaxFontDefs) and (u[k].n<>s[j]) do inc(k);
                if k<MaxFontDefs then
                  p.Font.Name:=u[k].f
                else
                  raise Exception.Create('Unknown modifier');
                inc(j);
               end;
              //fields
              while (j<=l) and (s[j]=' ') do inc(j);
              m:=0;
              while (j<=l) and (m<4) do
               begin
                k:=j;
                while (j<=l) and (s[j]<>' ') do inc(j);
                t[m]:=StringReplace(Copy(s,k,j-k),'&','&&',[rfReplaceAll]);
                inc(m);
                inc(j);
               end;
              //key with code caption?
              if s[1]='c' then
               begin
                k:=0;
                while k<m-1 do
                 begin
                  t[k]:=char(StrToInt(t[k]));
                  inc(k);
                 end;
               end;
              case m of
                1:
                 begin
                  KeyDefs[i].s1:='';
                  KeyDefs[i].s2:='';
                  KeyDefs[i].s3:='';
                  KeyDefs[i].vk:=StrToInt(t[0]);
                 end;
                2:
                 begin
                  KeyDefs[i].s1:=t[0];
                  KeyDefs[i].s2:=t[0];
                  KeyDefs[i].s3:=t[0];
                  KeyDefs[i].vk:=StrToInt(t[1]);
                 end;
                3:
                 begin
                  KeyDefs[i].s1:=t[0];
                  KeyDefs[i].s2:=t[1];
                  KeyDefs[i].s3:='';
                  KeyDefs[i].vk:=StrToInt(t[2]);
                 end;
                4:
                 begin
                  KeyDefs[i].s1:=t[0];
                  KeyDefs[i].s2:=t[1];
                  KeyDefs[i].s3:=t[2];
                  KeyDefs[i].vk:=StrToInt(t[3]);
                 end;
                else
                  raise Exception.Create('Unexpected number of items');
              end;
              if KeyV=1 then
                p.Caption:=KeyDefs[i].s1
              else
                p.Caption:=KeyDefs[i].s2;
              p.Tag:=i;
              p.OnMouseDown:=KeyXMouseDown;
              p.OnMouseMove:=AllMouseMove;
              p.OnMouseUp:=KeyXMouseUp;
              if (KeyV=2) and (KeyDefs[i].vk=VK_CAPITAL) then p.Color:=Clr2;
              inc(x,KeyDefs[i].w);
             end;
            else
              raise Exception.Create('Unknown type');
          end;
        except
          on e:Exception do
           begin
            e.Message:='Error on line '+IntToStr(i+1)+#13#10+e.Message+#13#10+s;
            raise;
           end;
        end;
      inc(i);
     end;
  finally
    sl.Free;
  end;
  if x>KeyCols then KeyCols:=x;
  KeyRows:=y+1;
  KeyDefFile:=kbl;
  KeyDefHot:=nil;
  ArrangeButtons;
end;

procedure TfrmMetaKeys.AllMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsMovingStarted:=false;
  IsMoving:=Button=mbLeft;
  StartPos:=BoundsRect.TopLeft;
  StartDrag:=Mouse.CursorPos;
  IsPopUp:=Button=mbRight;
end;

procedure TfrmMetaKeys.AllMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsClicked;
end;

function TfrmMetaKeys.IsClicked:boolean;
begin
  IsMoving:=false;
  IsResizing:=false;
  Result:=not(IsPopUp) and not(IsMovingStarted);
  IsPopUp:=false;
end;

procedure TfrmMetaKeys.AllMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx,dy:integer;
begin
  if IsMoving then
   begin
    if IsMovingStarted then
     begin
      SetBounds(
        StartPos.X-StartDrag.X+Mouse.CursorPos.X,
        StartPos.Y-StartDrag.Y+Mouse.CursorPos.Y,
        Width,Height);
     end
    else
     begin
      dx:=Mouse.CursorPos.X-StartDrag.X;
      if dx<0 then dx:=-dx;                               
      dy:=Mouse.CursorPos.Y-StartDrag.Y;
      if dy<0 then dy:=-dy;
      if (KeyDefHot=nil) and ((dx>SysDragHoldX) or (dy>SysDragHoldY)) then
        IsMovingStarted:=true;
     end;
   end;
end;

procedure TfrmMetaKeys.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle,SW_HIDE);
end;

procedure TfrmMetaKeys.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;
end;

procedure TfrmMetaKeys.Settings1Click(Sender: TObject);
begin
  if frmSettings=nil then frmSettings:=TfrmSettings.Create(nil);
  if KeyDefFile='' then
    frmSettings.PageControl1.ActivePage:=frmSettings.tbKbl
  else
    frmSettings.PageControl1.ActivePageIndex:=0;
  frmSettings.ShowSettings(
    Clr1,
    Clr2,
    Font,
    4-((AlphaBlendValue+1) div 64),
    KeyDefFile,
    DoRepeat,
    tiDelay.Interval,
    tiRepeat.Interval,
    FShowOnMouseOver);
end;

procedure TfrmMetaKeys.UpdateSettings(ColorBG1, ColorBG2: TColor;
  Font1: TFont; AlphaBlendLevel, AShowOnMouseOver: integer;
  ADoRepeat: boolean; ADelayInterval, ARepeatInterval: integer);
var
  i:integer;
begin
  Color:=ColorBG1;
  Clr1:=ColorBG1;
  Clr2:=ColorBG2;
  Font:=Font1;
  FAlphaLevel:=AlphaBlendLevel;
  AlphaBlendValue:=(4-AlphaBlendLevel)*64-1;
  AlphaBlend:=AlphaBlendLevel>0;
  DoRepeat:=ADoRepeat;
  if Corners<>0 then
   begin
    SetWindowRgn(Handle,0,false);
    DeleteObject(Corners);
    Corners:=0;
   end;
  FShowOnMouseOver:=AShowOnMouseOver;
  tiMouseOver.Enabled:=FShowOnMouseOver>0;
  tiDelay.Interval:=ADelayInterval;
  tiRepeat.Interval:=ARepeatInterval;
  for i:=0 to KeyDefCount-1 do
    if KeyDefs[i].p<>nil then
      if not KeyDefs[i].p.ParentFont then
       begin
        KeyDefs[i].p.Font.Color:=Font1.Color;
        KeyDefs[i].p.Font.Size:=Font1.Size;
        KeyDefs[i].p.Font.Style:=Font1.Style;
       end;
  ArrangeButtons;
end;

procedure TfrmMetaKeys.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMetaKeys.PopupMenu1Popup(Sender: TObject);
begin
  IsPopUp:=true;
  if KeyDefHot<>nil then
   begin
    KeyDefHot.Color:=Clr1;
    KeyDefHot:=nil;
   end;
end;

procedure TfrmMetaKeys.imgResizeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsMovingStarted:=false;
  IsResizing:=Button=mbLeft;
  StartPos.X:=Width;
  StartPos.Y:=Height;
  StartDrag:=Mouse.CursorPos;
  IsPopUp:=false;
end;

procedure TfrmMetaKeys.imgResizeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsClicked;
end;

procedure TfrmMetaKeys.imgResizeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  dx,dy:integer;
begin
  if IsResizing then
   begin
    if IsMovingStarted then
     begin
      SetBounds(
        Left,Top,
        StartPos.X-StartDrag.X+Mouse.CursorPos.X,
        StartPos.Y-StartDrag.Y+Mouse.CursorPos.Y);
     end
    else
     begin
      dx:=Mouse.CursorPos.X-StartDrag.X;
      if dx<0 then dx:=-dx;
      dy:=Mouse.CursorPos.Y-StartDrag.Y;
      if dy<0 then dy:=-dy;
      if (dx>SysDragHoldX) or (dy>SysDragHoldY) then
       begin
        IsMovingStarted:=true;
        if KeyDefHot<>nil then
         begin
          KeyDefHot.Color:=Clr1;
          KeyDefHot:=nil;
         end;
       end;
     end;
   end;
end;

procedure TfrmMetaKeys.FormResize(Sender: TObject);
begin
  if Visible then ArrangeButtons;
end;

procedure TfrmMetaKeys.ArrangeButtons;
const
  OuterMargin=6;
var
  i,sx,sy,ax,ay,bx,by:integer;
begin
  //...
  panMain.Visible:=false;
  try
    sx:=panMain.Width-OuterMargin-OuterMargin;
    sy:=panMain.Height-OuterMargin-OuterMargin;
    for i:=0 to KeyDefCount-1 do if KeyDefs[i].p<>nil then
     begin
      ax:=KeyDefs[i].x*sx div KeyCols;
      ay:=KeyDefs[i].y*sy div KeyRows;
      bx:=(KeyDefs[i].x+KeyDefs[i].w)*sx div KeyCols;
      by:=(KeyDefs[i].y+KeyDefs[i].h)*sy div KeyRows;
      KeyDefs[i].p.SetBounds(
        OuterMargin+ax,
        OuterMargin+ay,
        bx-ax,
        by-ay
      );
     end;
  finally
    panMain.Visible:=true;
  end;
end;

procedure TfrmMetaKeys.KeyXMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:TPanel;
  c:boolean;
begin
  AllMouseDown(Sender,Button,Shift,X,Y);
  p:=Sender as TPanel;
  p.Color:=Clr2;
  DoRepeatIdx:=p.Tag;
  c:=(KeyDefs[DoRepeatIdx].vk>=0);
  if c and (KeyDefs[DoRepeatIdx].vk<>VK_CAPITAL) then
   begin
    KeyDefHot:=p;
    KeyDefHotTC:=GetTickCount;
   end;
  if DoRepeat and IsClicked and c then
   begin
    KeyXClick(DoRepeatIdx,$3);
    tiDelay.Enabled:=true;
   end;
end;

procedure TfrmMetaKeys.KeyXMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i:integer;
begin
  if KeyDefHot<>nil then
   begin
    //assert KeyDefHot=Sender
    if cardinal(GetTickCount-KeyDefHotTC)<25 then
     begin
      Update;
      PostMessage(Handle,WM_KEYHOT,0,0);
     end
    else
     begin
      KeyDefHot.Color:=Clr1;
      KeyDefHot:=nil;
     end;
   end;
  i:=(Sender as TPanel).Tag;//?
  if DoRepeat and (KeyDefs[i].vk>=0) then
   begin
    tiDelay.Enabled:=false;
    tiRepeat.Enabled:=false;
    KeyXClick(DoRepeatIdx,$4);
    IsClicked;//call to reset
   end
  else
    if IsClicked then KeyXClick(i,$7);
end;

procedure TfrmMetaKeys.KeyXClick(i:integer;Mods:integer);
var
  j,k,vk:integer;
  inputs:array[0..(KeyDefModMax+2)*2] of TInput;
  inputcount:integer;
  procedure SetK(idx:integer;code:word;dn:boolean);
  var
    x:DWORD;
  begin
    inputs[idx].Itype:=INPUT_KEYBOARD;
    inputs[idx].ki.wVk:=code;
    inputs[idx].ki.wScan:=0;
    if dn then x:=0 else x:=KEYEVENTF_KEYUP;
    if code in [VK_PRIOR..VK_HELP] then x:=KEYEVENTF_EXTENDEDKEY;
    inputs[idx].ki.dwFlags:=x;
    inputs[idx].ki.time:=0;
    inputs[idx].ki.dwExtraInfo:=0;
    inputcount:=idx+1;//assert largest one last!
  end;
begin
  //assert caller checked IsClicked
  inputcount:=0;
  //assert KeyDefs[i].p=Sender
  if KeyDefs[i].vk<0 then
   begin
    //sticky
    //assert tiDelay.Enabled=false, Mods=3
    vk:=-KeyDefs[i].vk;
    j:=0;
    while (j<KeyDefModMax) and (KeyDefMod[j]<>vk) and (KeyDefMod[j]<>0) do inc(j);
    if (j<KeyDefModMax) then
     begin
      if KeyDefMod[j]=0 then
       begin
        //set
        for k:=0 to KeyDefCount-1 do
          if KeyDefs[k].vk=-vk then
            KeyDefs[k].p.Color:=Clr2;
        KeyDefMod[j]:=vk;
       end
      else
       begin
        //reset
        for k:=0 to KeyDefCount-1 do
          if KeyDefs[k].vk=-vk then
            KeyDefs[k].p.Color:=Clr1;
        while (j<KeyDefModMax) do
         begin
          KeyDefMod[j]:=KeyDefMod[j+1];
          inc(j);
         end;
        KeyDefMod[j]:=0;
        SetK(0,vk,true);
        SetK(1,vk,false);
       end;
     end;
    case KeyDefMod[0] of
      VK_SHIFT:SetKeyV(3-KeyV);//?
      VK_RMENU:SetKeyV(3);//from .kbl? more than s3?
      else SetKeyV(0);
    end;
   end
  else
   begin
    if KeyDefMod[0]<>0 then
     begin
      //modified event
      j:=0;
      while (j<=KeyDefModMax) and (KeyDefMod[j]<>0) do
       begin
        if (Mods and $1)<>0 then SetK(inputcount,KeyDefMod[j],true);
        inc(j);
       end;
      if (Mods and $2)<>0 then
       begin
        SetK(inputcount,KeyDefs[i].vk,true);
        SetK(inputcount,KeyDefs[i].vk,false);
       end;
      if (Mods and $4)<>0 then
       begin
        while (j<>0) do
         begin
          dec(j);
          vk:=KeyDefMod[j];
          SetK(inputcount,vk,false);
          for k:=0 to KeyDefCount-1 do
            if KeyDefs[k].vk=-vk then
              KeyDefs[k].p.Color:=Clr1;
          KeyDefMod[j]:=0;
         end;
       end;
      SetKeyV(0);
     end
    else
      if (Mods and $2)<>0 then
       begin
        vk:=KeyDefs[i].vk;
        case vk of //special codes
          0..255:
           begin
            //plain event
            SetK(0,vk,true);
            SetK(1,vk,false);
           end;
          666:Close;
          777:Settings1.Click;
          1000..1999:LoadKeys(Format('%.3d.kbl',[vk mod 1000]));
          2000..999999:SetBounds(Left,Top,vk div 1000,vk mod 1000);
          else
           begin
            SetBounds(Left,Top,(vk div 1000) mod 1000,vk mod 1000);
            LoadKeys(Format('%.3d.kbl',[(vk div 1000000) mod 1000]));
           end;
        end;
       end;
   end;                            
  if inputcount<>0 then
   begin
    SendInput(inputcount,inputs[0],sizeof(TInput));
    if KeyDefs[i].vk=VK_CAPITAL then tiCheckKeyV.Enabled:=true;//SetKeyV(0);
   end;
end;

procedure TfrmMetaKeys.SetKeyV(v: integer);
var
  i:integer;
  c:boolean;                            
begin
  if v<>KeyV then
   begin
    c:=(GetKeyState(VK_CAPITAL) and 1)=1;
    if v=0 then
      if c then v:=2 else v:=1;
    KeyV:=v;
    for i:=0 to KeyDefCount-1 do if KeyDefs[i].p<>nil then
     begin
      case v of
        1:KeyDefs[i].p.Caption:=KeyDefs[i].s1;
        2:KeyDefs[i].p.Caption:=KeyDefs[i].s2;
        3:KeyDefs[i].p.Caption:=KeyDefs[i].s3;
      end;
      if KeyDefs[i].vk=VK_CAPITAL then
        if c then KeyDefs[i].p.Color:=Clr2 else KeyDefs[i].p.Color:=Clr1;
     end;
   end;
end;

procedure TfrmMetaKeys.tiDelayTimer(Sender: TObject);
begin
  try
    tiDelay.Enabled:=false;
    KeyXClick(DoRepeatIdx,$2);
    tiRepeat.Enabled:=true;
  except
    //show?log?
  end;
end;

procedure TfrmMetaKeys.tiRepeatTimer(Sender: TObject);
begin
  try
    KeyXClick(DoRepeatIdx,$2);
  except
    //show?log?
  end;
end;

procedure TfrmMetaKeys.tiMouseOverTimer(Sender: TObject);
var
  b:boolean;
  c:HDC;
  x,y,sx,sy,sx2,sy2:integer;
  p:array[0..7] of TPoint;
  r:TRect absolute p;
begin
  try
    if not(IsMoving or IsResizing) then
     begin
      r:=BoundsRect;
      p[5]:=Mouse.CursorPos;
      b:=(p[5].X>=r.Left) and (p[5].X<=r.Right) and
        (p[5].Y>=r.Top) and (p[5].Y<=r.Bottom);
      case FShowOnMouseOver of
        1:
          if b<>(Corners=0) then
            if Corners=0 then
             begin
              c:=Canvas.Handle;
              x:=r.Right-r.Left;//x:=Width;
              y:=r.Bottom-r.Top;//y:=Height;
              sx:=x div KeyCols;
              sy:=y div KeyRows;
              sx2:=sx div 2;
              sy2:=sy div 2;
              b:=true;
              b:=b and BeginPath(c);

              p[0]:=Point(0,0);
                p[1]:=Point(0,0);
                p[2]:=Point(sx,0);
              p[3]:=Point(sx,0);
                p[4]:=Point(sx,sy2);
                p[5]:=Point(sx2,sy);
              p[6]:=Point(0,sy);
              b:=b and PolyBezier(c,p[0],7);
              b:=b and CloseFigure(c);

              p[0]:=Point(x,0);
                p[1]:=Point(x,0);
                p[2]:=Point(x,sy);
              p[3]:=Point(x,sy);
                p[4]:=Point(x-sx2,sy);
                p[5]:=Point(x-sx,sy2);
              p[6]:=Point(x-sx,0);
              b:=b and PolyBezier(c,p[0],7);
              b:=b and CloseFigure(c);

              p[0]:=Point(x,y);
                p[1]:=Point(x,y);
                p[2]:=Point(x-sx,y);
              p[3]:=Point(x-sx,y);
                p[4]:=Point(x-sx,y-sy2);
                p[5]:=Point(x-sx2,y-sy);
              p[6]:=Point(x,y-sy);
              b:=b and PolyBezier(c,p[0],7);
              b:=b and CloseFigure(c);

              p[0]:=Point(0,y);
                p[1]:=Point(0,y);
                p[2]:=Point(0,y-sy);
              p[3]:=Point(0,y-sy);
                p[4]:=Point(sx2,y-sy);
                p[5]:=Point(sx,y-sy2);
              p[6]:=Point(sx,y);
              b:=b and PolyBezier(c,p[0],7);
              //b:=b and CloseFigure(c);

              b:=b and EndPath(c);
              if b then
               begin
                Corners:=PathToRegion(c);
                SetWindowRgn(Handle,Corners,false);
               end;
             end
            else
             begin
              SetWindowRgn(Handle,0,false);
              DeleteObject(Corners);
              Corners:=0;
             end;
        2:
         begin
          sx:=(4-FAlphaLevel)*64-1;
          if not b then sx:=(sx+1) div 2;
          AlphaBlendValue:=sx;
          AlphaBlend:=sx<255;
         end;
      end;
      IsMOver:=b;
     end;
  except
    //show?log?
  end;
end;

procedure TfrmMetaKeys.WMKeyHot(var Msg: TMessage);
begin
  if KeyDefHot<>nil then
   begin
    Sleep(100);
    KeyDefHot.Color:=Clr1;
    KeyDefHot:=nil;
   end;
end;

procedure TfrmMetaKeys.tiCheckKeyVTimer(Sender: TObject);
begin
  tiCheckKeyV.Enabled:=false;
  SetKeyV(0);
end;

end.
