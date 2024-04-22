unit Boxer1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Shell32_TLB, Menus;

const
  WM_DetectSwitch = WM_USER+1;

type
  TfrmBoxer = class(TForm)
    lblDisplay: TLabel;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Removegroup1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Removewindowfromgroup1: TMenuItem;
    Useshellpaths1: TMenuItem;
    procedure lblDisplayClick(Sender: TObject);
    procedure lblListClick(Sender: TObject);
    procedure lblDisplayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Removegroup1Click(Sender: TObject);
    procedure Removewindowfromgroup1Click(Sender: TObject);
    procedure Useshellpaths1Click(Sender: TObject);
  private
    FGroups:array of record
      wp:TWindowPlacement;
    end;
    FGroupsSize,FGroupsIndex:integer;
    FHandles:array of record
      h:THandle;
      g:integer;
      p:string;
      t:integer;
    end;
    FHandlesSize,FHandlesIndex,FHandlesTouched:integer;
    FLabels:array of record
      val:integer;
      lbl:TLabel;
    end;
    FLabelsSize,FLabelsIndex:integer;
    FShell:Shell;
    FHotHandle:THandle;
    FHotGroup,FHotWidth,FDropTimeout,FDropGroup:integer;
    FHotDropped,FDropAuto,FShellPaths:boolean;
    procedure DetectSwitch(hwnd:THandle);
    function GroupName(gi:integer;h1:THandle):string;
    procedure SetLabel(li,Value:integer;const Display:string);
    function LookupHandle(h:THandle):integer;
    procedure UpdateLastKnownPaths;
    procedure DropDown;
    procedure ResetDropDown(AllowAutoDrop:boolean);
  protected
    procedure DoCreate; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoShow; override;
    procedure WMDetectSwitch(var Msg: TMessage); message WM_DetectSwitch;
  end;

var
  frmBoxer: TfrmBoxer;

const
  DisplaySlotY=20;
  DisplayHeight=18;
  DisplayMarginY=2;
  DisplayWidthMaximized=400;
  AutoRollUpTimerCount=6;//see also Timer1.Interval

function InternalGetWindowText(hWnd: HWND; lpString: PWideChar; nMaxCount: Integer): Integer; stdcall;

implementation

uses ActiveX, ComObj;

{$R *.dfm}

{ TfrmBoxer }

procedure TfrmBoxer.DoCreate;
begin
  inherited;
  FShell:=nil;
  FGroupsSize:=0;
  FGroupsIndex:=0;
  FHandlesSize:=0;
  FHandlesIndex:=0;
  FHandlesTouched:=0;//GetTickCount?
  FHotHandle:=0;
  FHotGroup:=-1;
  FHotDropped:=false;
  FDropAuto:=true;
  FShellPaths:=false;//TODO: from config
end;

procedure TfrmBoxer.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;
end;

procedure wDetectSwitch(hWinEventHook:THandle;event:DWORD;hwnd:HWND;
  idObject:integer;idChild:integer;idEventThread:DWORD;dwmsEventTime:DWORD); stdcall;
begin
  frmBoxer.DetectSwitch(hwnd);
end;

procedure wDetectMoveSize(hWinEventHook:THandle;event:DWORD;hwnd:HWND;
  idObject:integer;idChild:integer;idEventThread:DWORD;dwmsEventTime:DWORD); stdcall;
begin
  frmBoxer.FHotHandle:=0;//force updaet
  frmBoxer.DetectSwitch(hwnd);
end;

procedure TfrmBoxer.DoShow;
begin
  inherited;
  OleInitialize(nil);
  ShowWindow(Application.Handle,SW_HIDE);

  SetWinEventHook(EVENT_SYSTEM_FOREGROUND,EVENT_SYSTEM_FOREGROUND,0,
    wDetectSwitch,0,0,WINEVENT_OUTOFCONTEXT);

  SetWinEventHook(EVENT_SYSTEM_MOVESIZEEND,EVENT_SYSTEM_MOVESIZEEND,0,
    wDetectMoveSize,0,0,WINEVENT_OUTOFCONTEXT);

  //TODO: auto-detect windows with same placement?

end;

function TfrmBoxer.GroupName(gi:integer;h1:THandle): string;
var
  hi,c,n:integer;
begin
  c:=0;
  n:=0;
  Result:='';
  for hi:=0 to FHandlesIndex-1 do
    if FHandles[hi].g=gi then
     begin
      Result:=Result+'  '+FHandles[hi].p;
      inc(c);
      if (h1<>0) and (h1=FHandles[hi].h) then n:=c;
     end;
  if h1=0 then
    Result:='#'+IntToStr(c)+Result
  else
    Result:='['+IntToStr(n)+'/'+IntToStr(c)+']'+Result;
end;

function TfrmBoxer.LookupHandle(h: THandle): integer;
begin
  //TODO: AB-lookup... store sorted...
  Result:=0;
  while (Result<FHandlesIndex) and (FHandles[Result].h<>h) do inc(Result);
end;

procedure TfrmBoxer.DetectSwitch(hwnd:THandle);
var
  h:THandle;
  hi,x,y:integer;
  wp:TWindowPlacement;
  s:array[0..MAX_PATH] of WideChar;
  wn:PWideChar;
begin
  h:=GetForegroundWindow; //assert = hwnd

  //TODO: GetWindowPlacement and detect/update groups

  if h<>FHotHandle then
   begin
    wn:=@s[0];
    GetClassNameW(h,wn,MAX_PATH);
    if (wn='CabinetWClass') and GetWindowPlacement(h,@wp) then
     begin

      //known handle?
      hi:=LookupHandle(h);
      FHotHandle:=h;
      FDropAuto:=true;
      if hi=FHandlesIndex then
       begin
        FHotGroup:=-1;
        lblDisplay.Caption:='(click here to add to a group)';
       end
      else
       begin
        FHotGroup:=FHandles[hi].g;
        //TODO: update FGroups[FHotGroup].wp?
        UpdateLastKnownPaths;//TODO: only once every X seconds?
        lblDisplay.Caption:=GroupName(FHotGroup,h);
       end;

      //update display
      if wp.showCmd=SW_SHOWMAXIMIZED then
       begin
        GetWindowRect(h,wp.rcNormalPosition);
        FHotWidth:=DisplayWidthMaximized;
        SetBounds(
          wp.rcNormalPosition.Right-DisplayWidthMaximized-32,
          wp.rcNormalPosition.Top+32,
          FHotWidth,DisplaySlotY);
       end
      else
       begin
        FHotWidth:=wp.rcNormalPosition.Right-wp.rcNormalPosition.Left-152;
        if FHotWidth<120 then FHotWidth:=120;
        x:=wp.rcNormalPosition.Left+8;
        y:=wp.rcNormalPosition.Top-DisplaySlotY-DisplayMarginY;
        if y<-3 then
         begin
          y:=-3;
          FHotWidth:=FHotWidth div 2;
          inc(x,FHotWidth);
         end;
        SetBounds(x,y,FHotWidth,DisplaySlotY);
       end;
      lblDisplay.SetBounds(2,2,FHotWidth-4,DisplayHeight);
      if not Visible then
       begin
        Show;
        ShowWindow(Application.Handle,SW_HIDE);
       end;
      FHotDropped:=false;

     end
    else
     begin
      Hide;
      FHotHandle:=0;
      FHotGroup:=-1;
     end;
   end;
end;

procedure TfrmBoxer.Timer1Timer(Sender: TObject);
var
  p:TPoint;
begin
  if FHotDropped then
   begin
    p:=ScreenToClient(Mouse.CursorPos);
    if (p.X<0) or (p.Y<0) or (p.X>ClientWidth) or (p.Y>ClientHeight) then
     begin
      inc(FDropTimeout);
      if FDropTimeout>=AutoRollUpTimerCount then
        ResetDropDown(true);
     end
    else
      FDropTimeout:=0;
   end;
end;

procedure TfrmBoxer.UpdateLastKnownPaths;
const
  sSize=1024;
var
  wl,w:OleVariant;
  i,hi:integer;
  s:array[0..sSize] of WideChar;
  DoCleanup:boolean;
begin
  if FShellPaths then
   begin

    if FShell=nil then FShell:=CoShell.Create;
    DoCleanup:=true;
    try
      inc(FHandlesTouched);//FHandlesTouched:=GetTickCount?
      wl:=FShell.Windows;//TODO: find out which interface!
      for i:=0 to wl.Count-1 do
       begin
        w:=wl.Item(i);
        hi:=LookupHandle(w.HWND);
        if hi<FHandlesIndex then
         begin
          FHandles[hi].p:=w.Document.Folder.Self.Path;//TODO: replace with explicit interface calls!
          FHandles[hi].t:=FHandlesTouched;
         end;
       end;
    except
      //ignore pointer errors
      //FShell:=nil//?
      DoCleanup:=false;
    end;

   end
  else
   begin

    DoCleanup:=false;
    for hi:=0 to FHandlesIndex-1 do
      if FHandles[hi].h<>0 then
        if InternalGetWindowText(FHandles[hi].h,@s[0],sSize-1)<>0 then
         begin
          FHandles[hi].p:=s;
          FHandles[hi].t:=FHandlesTouched;
          DoCleanup:=true;
         end;

   end;
  if DoCleanup then
    for hi:=0 to FHandlesIndex-1 do
      if FHandles[hi].t<>FHandlesTouched then
       begin
        FHandles[hi].h:=0;
        FHandles[hi].g:=-1;
        FHandles[hi].p:='';
       end;
end;

function InternalGetWindowText; external user32 name 'InternalGetWindowText';

procedure TfrmBoxer.lblDisplayClick(Sender: TObject);
begin
  if FHotDropped then
   begin
    ResetDropDown(false);
    PostMessage(Handle,WM_DetectSwitch,0,0);
   end
  else
    DropDown;
end;

procedure TfrmBoxer.DropDown;
var
  gi,hi,i:integer;
begin
  if FHotGroup=-1 then
   begin
    //add to a group
    lblDisplay.Caption:='(add to a group:)';
    //UpdateLastKnownPaths;?

    for gi:=0 to FGroupsIndex-1 do
      SetLabel(gi,0,GroupName(gi,0));
    SetLabel(FGroupsIndex,0,'(new group)');
    Height:=DisplaySlotY*(FGroupsIndex+2);

   end
  else
   begin
    //list group

    i:=0;
    for hi:=0 to FHandlesIndex-1 do
      if FHandles[hi].g=FHotGroup then
       begin
        SetLabel(i,hi,FHandles[hi].p);
        inc(i);
       end;
    Height:=DisplaySlotY*(i+1);

    //TODO: '(drop from group)'? '(move to group)'?

   end;
  FHotDropped:=true;
  Timer1.Enabled:=true;
  FDropTimeout:=0;
end;

procedure TfrmBoxer.ResetDropDown(AllowAutoDrop:boolean);
begin
  Height:=DisplaySlotY;
  FHotDropped:=false;
  Timer1.Enabled:=false;
  FDropAuto:=AllowAutoDrop;
end;

procedure TfrmBoxer.SetLabel(li, Value: integer; const Display: string);
var
  lbl:TLabel;
begin
  //assert li<=FLabelsIndex
  if li=FLabelsIndex then
   begin
    if FLabelsIndex=FLabelsSize then
     begin
      inc(FLabelsSize,32);//grow step
      SetLength(FLabels,FLabelsSize);
     end;
    lbl:=TLabel.Create(Self);
    lbl.AutoSize:=false;
    lbl.ShowAccelChar:=false;
    lbl.PopupMenu:=PopupMenu1;
    lbl.Tag:=FLabelsIndex;
    lbl.OnClick:=lblListClick;
    lbl.Parent:=Self;
    FLabels[FLabelsIndex].lbl:=lbl;
    inc(FLabelsIndex);
   end;
  FLabels[li].val:=Value;
  FLabels[li].lbl.Caption:=Display;
  FLabels[li].lbl.SetBounds(2,li*20+22,FHotWidth-4,18);
end;

procedure TfrmBoxer.lblListClick(Sender: TObject);
var
  gi,hi:integer;
  h:THandle;
begin
  if FHotGroup=-1 then
   begin
    gi:=(Sender as TLabel).Tag;
{
    hi:=LookupHandle(FHotHandle);
    if hi=FHandlesIndex then //assert hi=FHandlesIndex
}
     begin
      if FHandlesIndex=FHandlesSize then
       begin
        inc(FHandlesSize,32);//grow step
        SetLength(FHandles,FHandlesSize);
       end;
      FHandles[FHandlesIndex].h:=FHotHandle;
      FHandles[FHandlesIndex].g:=gi;
      FHandles[FHandlesIndex].p:='...';//see UpdateLastKnownPaths
      FHandles[FHandlesIndex].t:=FHandlesTouched-1;
      inc(FHandlesIndex);
     end;

    //add to group
    if gi=FGroupsIndex then
     begin
      //new group
      if FGroupsIndex=FGroupsSize then
       begin
        inc(FGroupsSize,4);//grow step
        SetLength(FGroups,FGroupsSize);
       end;
      //FGroups[gi].?
      GetWindowPlacement(FHotHandle,@FGroups[gi].wp);
      inc(FGroupsIndex);
     end
    else
     begin
      //existing group

      SetWindowPlacement(FHotHandle,@FGroups[gi].wp);

     end;
    //FHandles[hi].g:=gi;//see above!

    //force update display
    FHotHandle:=0;
    PostMessage(Handle,WM_DetectSwitch,0,0);
   end
  else
   begin
    gi:=FHotGroup;
    hi:=FLabels[(Sender as TLabel).Tag].val;
    ResetDropdown(true);

    //switch to window
    h:=FHandles[hi].h;
    SetForegroundWindow(h);
    SetWindowPlacement(h,@FGroups[gi].wp);//?

   end;
end;

procedure TfrmBoxer.lblDisplayMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FDropAuto and not(FHotDropped) then DropDown;
end;

procedure TfrmBoxer.WMDetectSwitch(var Msg: TMessage);
begin
  DetectSwitch(0);
end;

procedure TfrmBoxer.Exit1Click(Sender: TObject);
begin
  if MessageBox(GetDesktopWindow,'Are you sure to close Boxer "F"?','Boxer "F"',
    MB_OKCANCEL or MB_ICONQUESTION)=idOk then Application.Terminate;
end;

procedure TfrmBoxer.PopupMenu1Popup(Sender: TObject);
begin
  FDropGroup:=FHotGroup;
  Removewindowfromgroup1.Enabled:=(FHotGroup<>-1) and (FHotHandle<>0);
  Removegroup1.Enabled:=FHotGroup<>-1;
end;

procedure TfrmBoxer.Removegroup1Click(Sender: TObject);
var
  hi:integer;
begin
  //assert FDropGroup<>-1
  if MessageBox(GetDesktopWindow,'Are you sure to remove the group and release the windows?','Boxer "F"',
    MB_OKCANCEL or MB_ICONQUESTION)=idOk then
   begin
    for hi:=0 to FHandlesIndex-1 do
      if FHandles[hi].g=FDropGroup then
       begin
        FHandles[hi].h:=0;
        FHandles[hi].g:=-1;
        FHandles[hi].p:='';
       end;
    //FGroups[FHotGroup].?

    if FDropGroup=FGroupsIndex-1 then dec(FGroupsIndex);
    //TODO: else move the others up (or mark group-slot as 'free')

   end;
  FHotHandle:=0;//force update
  PostMessage(Handle,WM_DetectSwitch,0,0);
end;

procedure TfrmBoxer.Removewindowfromgroup1Click(Sender: TObject);
var
  hi:integer;
begin
  //assert FHotHandle<>0
  hi:=LookupHandle(FHotHandle);
  FHandles[hi].h:=0;
  FHandles[hi].g:=-1;
  FHandles[hi].p:='';
  FHotHandle:=0;//force update
  PostMessage(Handle,WM_DetectSwitch,0,0);
end;

procedure TfrmBoxer.Useshellpaths1Click(Sender: TObject);
begin
  FShellPaths:=not(FShellPaths);
  Useshellpaths1.Checked:=FShellPaths;
  UpdateLastKnownPaths;
end;

end.
