unit Boxer1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus;

type
  TfrmBoxerMain = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Activate1: TMenuItem;
    Unbox1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    PopupMenu2: TPopupMenu;
    BoxHandle1: TMenuItem;
    Label2: TLabel;
    BoxHandleOnce1: TMenuItem;
    ListBox1: TListBox;
    DebugMessages1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure TabClick(Sender: TObject);
    procedure Unbox1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure AppActivate(Sender: TObject);
    procedure AppDeactivate(Sender: TObject);
    procedure BoxHandle1Click(Sender: TObject);
    procedure TabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BoxHandleOnce1Click(Sender: TObject);
    procedure DoUpdateTabs(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure DebugMessages1Click(Sender: TObject);
    procedure ListMsg(var Msg: TMsg; var Handled: Boolean);
  private
    FBoxed:array of record
      h:THandle;
      x:integer;
      p1:TPanel;
      i1:TImage;
      l1:TLabel;
    end;
    FBoxedLength,FTabWidth:integer;
    FLastHWND,FLastMaxed:THandle;
    FPrefix:string;
    FTagOffset,FDraggingTab,FDragStartX,FDragStartY,
    FDraggingWorkspace:integer;
    FFirstShow,FTabDragging:boolean;
    FMutex:THandle;
    procedure CleanBox(i:integer);
    procedure ReOrderTabs(SetX: integer);
    procedure UpdateTabs;
    procedure CheckForms;
    function FindTab(c: TControl; var i: integer): boolean;
    procedure UnBox(i: integer);
  protected
    procedure DoCreate; override;
    procedure DoShow; override;
    procedure DoClose(var Action: TCloseAction); override;
  public
    procedure TakeHWND;
  end;

var
  frmBoxerMain: TfrmBoxerMain;

function InternalGetWindowText(hWnd: HWND; lpString: PWideChar; nMaxCount: Integer): Integer; stdcall;
function GetShellWindow: HWND; stdcall;

implementation

uses Boxer2, Types;

{$R *.dfm}

function InternalGetWindowText; external user32 name 'InternalGetWindowText';
function GetShellWindow; external user32 name 'GetShellWindow';

const
  SysBorder=8;//TODO: get from theme? (Width-ClientWidth) div 2?
  SysButtons=160;//?

procedure TfrmBoxerMain.Timer1Timer(Sender: TObject);
var
  h,h1:THandle;
  r:TRect;
  f:cardinal;
  s:WideString;
begin
  h1:=GetForegroundWindow;
  h:=GetAncestor(h1,GA_ROOT);
  if h=Handle then
   begin
    if FLastHWND<>h1 then UpdateTabs;
    FLastHWND:=h1;
   end
  else
   begin
    if BoxHandle1.Checked or BoxHandleOnce1.Checked then
     begin
      f:=SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_HIDEWINDOW;
      if h<>FLastHWND then
       begin
        FLastHWND:=0;
        h1:=GetAncestor(GetShellWindow,GA_ROOT);
        if (h<>0) and (h<>h1) and (GetWindow(h,GW_OWNER)<>Handle) and
          (GetWindowRect(h,r)) then
          if (r.Left<>r.Right) and (r.Top<>r.Bottom) then
           begin
            SetLength(s,1023);
            SetLength(s,GetClassNameW(h,PWideChar(s),1023));
            if s<>'TfrmBoxerMain' then //if s<>ClassName then
             begin
              frmSwitchHandle.SetBounds(r.Right-FTagOffset,r.Top+SysBorder+2,16,16);
              f:=f xor SWP_NOZORDER xor SWP_HIDEWINDOW or SWP_SHOWWINDOW;
              FLastHWND:=h;
             end;
           end;
        SetWindowPos(frmSwitchHandle.Handle,HWND_TOPMOST,0,0,0,0,f);
       end;
     end;
    Mouse.IsDragging
   end;
end;

procedure TfrmBoxerMain.ScrollBox1Resize(Sender: TObject);
begin
  CheckForms;
end;

procedure TfrmBoxerMain.CheckForms;
var
  i,x,y,ax,ay,bx,by:integer;
  p:TWindowPlacement;
begin
  x:=12;
  y:=12;
  bx:=ScrollBox1.ClientWidth;
  by:=ScrollBox1.ClientHeight;

  for i:=0 to FBoxedLength-1 do
    if (FBoxed[i].h<>0) and GetWindowPlacement(FBoxed[i].h,@p) then
      case p.showCmd of
        SW_SHOWNORMAL:
         begin
          ax:=p.rcNormalPosition.Right;
          ay:=p.rcNormalPosition.Bottom;
          if ax>x then x:=ax;
          if ay>y then y:=ay;
         end;
        SW_SHOWMAXIMIZED:
          SetWindowPos(FBoxed[i].h,0,-SysBorder,-SysBorder,bx+SysBorder*2,by+SysBorder*2,
            SWP_ASYNCWINDOWPOS or SWP_NOZORDER);
        //SW_SHOWMINIMIZED://align along bottom?
     end;

  Label1.SetBounds(x-12,y-12,16,16);
end;

procedure TfrmBoxerMain.DoCreate;
begin
  inherited;
  FBoxedLength:=0;
  Application.OnActivate:=AppActivate;
  Application.OnDeactivate:=AppDeactivate;
  FFirstShow:=true;
  FDraggingTab:=-1;
  FDraggingWorkspace:=0;
end;

procedure TfrmBoxerMain.DoShow;
var
  i:integer;
  h:THandle;
begin
  inherited;
  if FFirstShow then
   begin
    FFirstShow:=false;

    h:=CreateMutex(nil,true,'DoubleSigma_Boxer');
    if (h<>0) and (GetLastError=ERROR_ALREADY_EXISTS) then
     begin
      ReleaseMutex(h);
      i:=0;
      FMutex:=0;
      while FMutex=0 do
       begin
        inc(i);

        h:=CreateMutex(nil,true,PChar('DoubleSigma_Boxer_'+IntToStr(i)));
        if (h<>0) and (GetLastError=ERROR_ALREADY_EXISTS) then
          ReleaseMutex(h)
        else
         begin
          FMutex:=h;
          FPrefix:='Boxer:'+AnsiChar($40+i);
          frmSwitchHandle.Label1.Caption:=char($40+i);
          frmSwitchHandle.Label1.Visible:=true;
          FTagOffset:=20*i+SysButtons;
          Caption:=FPrefix;
          Application.Title:=FPrefix;
         end;
       end;
     end
    else
     begin
      FMutex:=h;
      FPrefix:='Boxer';
      FTagOffset:=SysButtons;
     end;

   end;
end;

procedure TfrmBoxerMain.DoClose(var Action: TCloseAction);
var
  i,c:integer;
begin
  inherited;

  c:=0;
  for i:=0 to FBoxedLength-1 do
    if (FBoxed[i].h<>0) and IsWindow(FBoxed[i].h) then inc(c);

  if c<>0 then
    if MessageBox(Handle,PChar(IntToStr(c)+' application(s) are boxed, close now and unbox these applications?'),
      PChar(Caption),MB_OKCANCEL or MB_ICONQUESTION or MB_SYSTEMMODAL)<>idOK then
      Action:=caNone;

  if Action<>caNone then
   begin
    for i:=0 to FBoxedLength-1 do
      if FBoxed[i].h<>0 then Unbox(i);
    ReleaseMutex(FMutex);
   end;
end;

procedure TfrmBoxerMain.TakeHWND;
var
  i,j,x,y:integer;
  r,r1,r2:TRect;
begin
  if FLastHWND<>0 then
   begin
    i:=0;
    while (i<FBoxedLength) and (FBoxed[i].h<>0) do inc(i);
    if i=FBoxedLength then
     begin
      //grow
      inc(FBoxedLength,$100);
      SetLength(FBoxed,FBoxedLength);
      for j:=i to FBoxedLength-1 do FBoxed[j].h:=0;
     end;

    x:=0;//default
    y:=0;//default
    if not GetWindowRect(FLastHWND,r) then r.Bottom:=0;

    if Windows.SetParent(FLastHWND,ScrollBox1.Handle)=0 then RaiseLastOSError;

    FBoxed[i].h:=FLastHWND;
    FBoxed[i].p1:=TPanel.Create(Self);
    FBoxed[i].p1.PopupMenu:=PopupMenu1;
    FBoxed[i].p1.OnClick:=TabClick;
    FBoxed[i].p1.OnMouseDown:=TabMouseDown;
    FBoxed[i].p1.OnMouseMove:=TabMouseMove;
    FBoxed[i].p1.OnMouseUp:=TabMouseUp;
    FBoxed[i].i1:=TImage.Create(Self);
    FBoxed[i].i1.SetBounds(4,4,16,16);
    FBoxed[i].i1.Parent:=FBoxed[i].p1;
    FBoxed[i].i1.Transparent:=true;
    FBoxed[i].i1.Stretch:=true;
    FBoxed[i].i1.PopupMenu:=PopupMenu1;
    FBoxed[i].i1.OnClick:=TabClick;
    FBoxed[i].i1.OnMouseDown:=TabMouseDown;
    FBoxed[i].i1.OnMouseMove:=TabMouseMove;
    FBoxed[i].i1.OnMouseUp:=TabMouseUp;
    FBoxed[i].l1:=TLabel.Create(Self);
    FBoxed[i].l1.AutoSize:=false;
    FBoxed[i].l1.ShowAccelChar:=false;
    FBoxed[i].l1.SetBounds(22,4,100,14);
    FBoxed[i].l1.Parent:=FBoxed[i].p1;
    FBoxed[i].l1.PopupMenu:=PopupMenu1;
    FBoxed[i].l1.OnClick:=TabClick;
    FBoxed[i].l1.OnMouseDown:=TabMouseDown;
    FBoxed[i].l1.OnMouseMove:=TabMouseMove;
    FBoxed[i].l1.OnMouseUp:=TabMouseUp;

    SetWindowLong(FLastHWND,GWL_EXSTYLE,
      GetWindowLong(FLastHWND,GWL_EXSTYLE) or WS_EX_MDICHILD);

    //fits client?
    if r.Bottom<>0 then
     begin
      r1:=ScrollBox1.ClientRect;
      r2.TopLeft:=ScrollBox1.ClientToScreen(r1.TopLeft);
      //r2.BottomRight:=ScrollBox1.ClientToScreen(r1.BottomRight);
      r2.Right:=r2.Left-r1.Left+r1.Right;
      r2.Bottom:=r2.Top-r1.Top+r1.Bottom;
      if (r.Top>=r2.Top) and (r.Left>=r2.Left) and (r.Right<r2.Right) and (r.Bottom<r2.Bottom) then
       begin
        x:=r.Left+r1.Left-r2.Left;
        y:=r.Top+r1.Top-r2.Top;
       end;
     end;

    if not SetWindowPos(FLastHWND,HWND_TOP,x,y,0,0,SWP_ASYNCWINDOWPOS or SWP_NOSIZE) then RaiseLastOSError;

    ReOrderTabs(i);
   end;
  if BoxHandleOnce1.Checked then BoxHandleOnce1.Checked:=false;
  ShowWindow(frmSwitchHandle.Handle,SW_HIDE);
  UpdateTabs;
  CheckForms;
end;

procedure TfrmBoxerMain.Panel1Resize(Sender: TObject);
begin
  ReOrderTabs(-1);
  UpdateTabs;
  CheckForms;
end;

procedure TfrmBoxerMain.ReOrderTabs(SetX:integer);
var
  i,c,bx:integer;
  x:array of integer;
const
  MinTabWidth=240;
begin
  //count first
  c:=0;
  for i:=0 to FBoxedLength-1 do
    if FBoxed[i].h<>0 then inc(c);
  if c<>0 then
   begin
    if SetX<>-1 then FBoxed[SetX].x:=c-1;
    SetLength(x,c);

    for i:=0 to FBoxedLength-1 do
      if FBoxed[i].h<>0 then
       begin
        if FBoxed[i].x>=c then FBoxed[i].x:=0;//just to be sure, shouldn't happen
        x[FBoxed[i].x]:=i;
       end;

    FTabWidth:=Panel1.Width div c;//Panel1.ClientWidth div c;
    if FTabWidth>MinTabWidth then FTabWidth:=MinTabWidth;
    bx:=0;
    i:=0;
    while i<c do
     begin
      FBoxed[x[i]].p1.SetBounds(bx,0,FTabWidth-1,24);
      FBoxed[x[i]].l1.Width:=FTabWidth-24;
      inc(i);
      inc(bx,FTabWidth);
     end;

    if SetX<>-1 then
     begin
      FBoxed[SetX].p1.Alignment:=taLeftJustify;
      FBoxed[SetX].p1.BorderWidth:=4;
      FBoxed[SetX].p1.Parent:=Panel1;
     end;
   end;
end;

procedure TfrmBoxerMain.UnBox(i: integer);
var
  r:TRect;
begin
  GetWindowRect(FBoxed[i].h,r);
  Windows.SetParent(FBoxed[i].h,GetDesktopWindow);
  SetWindowLong(FLastHWND,GWL_EXSTYLE,
    GetWindowLong(FLastHWND,GWL_EXSTYLE) and not(WS_EX_MDICHILD));
  SetWindowPos(FBoxed[i].h,0,r.Left,r.Top,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOACTIVATE);
end;

procedure TfrmBoxerMain.CleanBox(i: integer);
var
  x,j:integer;
begin
  x:=FBoxed[i].x;
  FBoxed[i].h:=0;
  FreeAndNil(FBoxed[i].l1);
  FreeAndNil(FBoxed[i].i1);
  FreeAndNil(FBoxed[i].p1);
  for j:=0 to FBoxedLength-1 do
    if (FBoxed[j].h<>0) and (FBoxed[j].x>x) then dec(FBoxed[j].x);
  ReOrderTabs(-1);
  UpdateTabs;
  CheckForms;
end;

procedure TfrmBoxerMain.UpdateTabs;
var
  i,c:integer;
  h,hx,hf:THandle;
  s,t:WideString;
  ss:string;
  rr:boolean;
  b:TBitmap;
const
  ICON_SMALL2=2;//since winXP
  IconTimeoutMS=150;
begin
  hf:=GetForegroundWindow;
  t:='';
  c:=0;
  rr:=false;
  for i:=0 to FBoxedLength-1 do
    if FBoxed[i].h<>0 then
     begin
      if not IsWindow(FBoxed[i].h) then
       begin
        CleanBox(i);
        rr:=true;
       end
      else
       begin
        inc(c);
        h:=FBoxed[i].h;
        hx:=0;//default
        if hx=0 then if SendMessageTimeout(h,WM_GETICON,ICON_SMALL2,0,SMTO_ABORTIFHUNG,IconTimeoutMS,@hx)=0 then hx:=0;
        if hx=0 then if SendMessageTimeout(h,WM_GETICON,ICON_SMALL,0,SMTO_ABORTIFHUNG,IconTimeoutMS,@hx)=0 then hx:=0;
        if hx=0 then hx:=GetClassLong(h,GCL_HICONSM);
        if hx=0 then if SendMessageTimeout(h,WM_GETICON,ICON_BIG,0,SMTO_ABORTIFHUNG,IconTimeoutMS,@hx)=0 then hx:=0;
        if hx=0 then hx:=GetClassLong(h,GCL_HICON);
        //DrawIconEx(Canvas.Handle,x,FListY,hx,FIconHeight,FIconHeight,0,0,DI_NORMAL);
        //FBoxed[i].i1.Picture.Icon.Handle:=hx;
        b:=TBitmap.Create;
        b.Canvas.Brush.Color:=clBtnFace;
        b.PixelFormat:=pf32bit;
        b.Width:=16;
        b.Height:=16;
        DrawIconEx(b.Canvas.Handle,0,0,hx,16,16,0,0,DI_NORMAL);
        FBoxed[i].i1.Picture.Bitmap:=b;

        SetLength(s,1023);
        SetLength(s,InternalGetWindowText(h,PWideChar(s),1023));
        FBoxed[i].l1.Caption:=s;
        if (h=hf) or IsChild(h,hf) then
         begin
          FBoxed[i].p1.BevelOuter:=bvLowered;
          FBoxed[i].p1.Color:=clActiveCaption;
          FBoxed[i].p1.Font.Color:=clCaptionText;
          t:=s;//display in caption, see below
          if IsZoomed(h) then FLastMaxed:=h else FLastMaxed:=0;
         end
        else
         begin
          FBoxed[i].p1.BevelOuter:=bvRaised;
          FBoxed[i].p1.Color:=clBtnFace;
          FBoxed[i].p1.Font.Color:=clBtnText;
         end;
       end;
     end;
  if c=0 then
   begin
    Label2.Visible:=true;
    ss:=FPrefix;
   end
  else
   begin
    Label2.Visible:=false;
    ss:=FPrefix+' ('+IntToStr(c)+') '+t;
   end;
  Caption:=ss;
  Application.Title:=ss;
  if rr then ReOrderTabs(-1);
end;


procedure TfrmBoxerMain.Panel1Click(Sender: TObject);
begin
  UpdateTabs;
  CheckForms;
end;

function TfrmBoxerMain.FindTab(c:TControl;var i:integer):boolean;
begin
  while (c<>nil) and not(c is TPanel) do c:=c.Parent;
  i:=0;
  while (i<FBoxedLength) and not((FBoxed[i].h<>0) and (FBoxed[i].p1=c)) do inc(i);
  Result:=i<FBoxedLength;
end;

procedure TfrmBoxerMain.TabClick(Sender: TObject);
var
  i:integer;
  c:TControl;
begin
  if Sender is TMenuItem then
    c:=PopupMenu1.PopupComponent as TControl
  else
    c:=Sender as TControl;
  if FindTab(c,i) then
   begin

    if FLastMaxed<>0 then
     begin
      //send to back? tried but didn't work...
      ShowWindow(FLastMaxed,SW_RESTORE);
      FLastMaxed:=0;
     end;

    SetForegroundWindow(FBoxed[i].h);

   end;
  UpdateTabs;
  CheckForms;
end;

procedure TfrmBoxerMain.Unbox1Click(Sender: TObject);
var
  i:integer;
begin
  if FindTab(PopupMenu1.PopupComponent as TControl,i) then
   begin
    Unbox(i);
    CleanBox(i);
   end;
  UpdateTabs;
  CheckForms;
end;

procedure TfrmBoxerMain.Close1Click(Sender: TObject);
var
  i:integer;
begin
  if FindTab(PopupMenu1.PopupComponent as TControl,i) then
   begin
    PostMessage(FBoxed[i].h,WM_CLOSE,0,0);
    //CleanBox(i);//?
   end;
  //UpdateTabs;
  //CheckForms;
end;

procedure TfrmBoxerMain.AppActivate(Sender: TObject);
begin
  ShowWindow(frmSwitchHandle.Handle,SW_HIDE);
  UpdateTabs;
end;

procedure TfrmBoxerMain.AppDeactivate(Sender: TObject);
begin
  //
end;

procedure TfrmBoxerMain.BoxHandle1Click(Sender: TObject);
var
  b:boolean;
begin
  b:=not(BoxHandle1.Checked);
  BoxHandle1.Checked:=b;
  BoxHandleOnce1.Enabled:=not(b);
  BoxHandleOnce1.Checked:=false;
  ShowWindow(frmSwitchHandle.Handle,SW_HIDE);
end;

procedure TfrmBoxerMain.BoxHandleOnce1Click(Sender: TObject);
var
  b:boolean;
begin
  b:=not(BoxHandleOnce1.Checked);
  BoxHandleOnce1.Checked:=b;
  ShowWindow(frmSwitchHandle.Handle,SW_HIDE);
end;

procedure TfrmBoxerMain.TabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FindTab(Sender as TControl,FDraggingTab) then
   begin
    FTabDragging:=false;
    FDragStartX:=FBoxed[FDraggingTab].p1.Left-Mouse.CursorPos.X;
   end
  else
    FDraggingTab:=-1;
end;

procedure TfrmBoxerMain.TabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i,j,c,cc:integer;
begin
  if FDraggingTab<>-1 then
    try
      if not(FTabDragging) then
       begin
        i:=FDragStartX+Mouse.CursorPos.X-FBoxed[FDraggingTab].p1.Left;
        if i<0 then i:=-i;
        if i>GetSystemMetrics(SM_CXDRAG) then
         begin
          FTabDragging:=true;
          FBoxed[FDraggingTab].p1.BringToFront;
         end;
      end;
      if FTabDragging then
       begin
        i:=FDragStartX+Mouse.CursorPos.X;//TODO: use argument X;
        FBoxed[FDraggingTab].p1.Left:=i;
        i:=((2*i) div FTabWidth+1) div 2;
        if i<0 then i:=0;
        if i<>FBoxed[FDraggingTab].x then
         begin
          c:=FBoxed[FDraggingTab].x;
          cc:=0;
          for j:=0 to FBoxedLength-1 do
            if (j<>FDraggingTab) and (FBoxed[j].h<>0) then
             begin
              inc(cc);
              if FBoxed[j].x>c then dec(FBoxed[j].x);
              if FBoxed[j].x>=i then inc(FBoxed[j].x);
              FBoxed[j].p1.Left:=FTabWidth*FBoxed[j].x;
             end;
          if i>cc then i:=cc;
          FBoxed[FDraggingTab].x:=i;
         end;
       end;
    except
      FDraggingTab:=-1;
      raise;
    end;
end;

procedure TfrmBoxerMain.TabMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i:integer;
begin
  if FDraggingTab<>-1 then
    try
      for i:=0 to FBoxedLength-1 do
        if FBoxed[i].h<>0 then
          FBoxed[i].p1.Left:=FTabWidth*FBoxed[i].x;
    finally
      FDraggingTab:=-1;
    end;
end;

procedure TfrmBoxerMain.ScrollBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:TPoint;
begin
  FDraggingWorkspace:=1;
  p:=Mouse.CursorPos;
  FDragStartX:=ScrollBox1.HorzScrollBar.Position+p.X;
  FDragStartY:=ScrollBox1.VertScrollBar.Position+p.Y;
  CheckForms;
end;

procedure TfrmBoxerMain.ScrollBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  p,q:TPoint;
begin
  case FDraggingWorkspace of
    1:
     begin
      p:=Mouse.CursorPos;
      q.X:=GetSystemMetrics(SM_CXDRAG);
      q.Y:=GetSystemMetrics(SM_CYDRAG);
      p.X:=FDragStartX-p.X-ScrollBox1.HorzScrollBar.Position;
      p.Y:=FDragStartY-p.Y-ScrollBox1.VertScrollBar.Position;
      if (p.X<-q.X) or (p.X>q.X) or (p.Y<-q.Y) or (p.Y>q.Y) then
        FDraggingWorkspace:=2;
     end;
    2:
     begin
      p:=Mouse.CursorPos;
      ScrollBox1.HorzScrollBar.Position:=FDragStartX-p.X;
      ScrollBox1.VertScrollBar.Position:=FDragStartY-p.Y;
     end;
  end;
end;

procedure TfrmBoxerMain.ScrollBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDraggingWorkspace:=0;
end;

procedure TfrmBoxerMain.DoUpdateTabs(Sender: TObject);
begin
  UpdateTabs;
end;

procedure TfrmBoxerMain.PopupMenu2Popup(Sender: TObject);
begin
  DebugMessages1.Visible:=(GetKeyState(VK_CONTROL) and $8000000)<>0;
end;

procedure TfrmBoxerMain.DebugMessages1Click(Sender: TObject);
begin
  ListBox1.Visible:=true;
  Application.OnMessage:=ListMsg;
end;

procedure TfrmBoxerMain.ListMsg(var Msg: TMsg; var Handled: Boolean);
var
  i,l:integer;
  s:string;
begin
  l:=ListBox1.Items.Count;
  i:=0;
  while (i<l) and (StrToInt('$'+Copy(ListBox1.Items[i],1,4))<integer(Msg.message)) do
    inc(i);
  s:=Format('%.4x %s %.8x %d %d',[Msg.message,
    FormatDateTime('hh:nn:ss.zzz',Now),
    Msg.hwnd,Msg.lParam,Msg.wParam]);
  if i<l then
    if Copy(ListBox1.Items[i],1,4)=Copy(s,1,4) then
      ListBox1.Items[i]:=s
    else
      ListBox1.Items.Insert(i,s)
  else
    ListBox1.Items.Add(s);
end;

end.
