unit SideSwitch1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TfrmSideSwitchMain = class(TForm)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure btnSwitchClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnClearClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FMutex:THandle;
    FHideTC:cardinal;
    FTargetMon:TMonitor;
    FAppList:array of record
      h:THandle;
      y:integer;
    end;
    FAppListCount,FListY,FStartX,FStartY,FCCounter:integer;
    FActivateTop,FActivateLeft,FActivateBottom,FActivateRight,FActivateHoldCtrl,
    FIsListing,FListUpsideDown,FSwitchMirrored,
    FTaskBarNixTopMost,FShowTestButton,
    FShowAll,FShowFullInfo,FDrawNext,FAppMini,FDragging:boolean;
    FListSkip,FTaskBarHIcon,FAppHandle1,FAppHandle2:THandle;
    FKeepShowingMS,FIconTimeoutMS:cardinal;
    FBorderMargin,FIconHeight,FShowVisible,FShowMinimized:integer;
    FColorMain,FColorVisible,FColorMinimized:TColor;
    FDesktopRect,FMonitorRect:TRect;
    function WindowOnMonitor(h:THandle):boolean;
    function ListWindow(h: HWND): boolean;
    function ClearWindow(h: HWND): boolean;
    function TestWindow(h: HWND): boolean;
    procedure SwitchWindow(h: THandle);
    procedure TestListWindows;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoCreate; override;
    procedure DoDestroy; override;
    procedure DoShow; override;
    procedure WMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;
  end;

var
  frmSideSwitchMain: TfrmSideSwitchMain;

function InternalGetWindowText(hWnd: HWND; lpString: PWideChar; nMaxCount: Integer): Integer; stdcall;
function GetShellWindow: HWND; stdcall;

implementation

uses Types, SideSwitch2, Registry;

{$R *.dfm}

{$WARN SYMBOL_PLATFORM OFF}

{ TfrmSideSwitchMain }

procedure TfrmSideSwitchMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;
  Params.WndParent:=GetDesktopWindow;
end;

procedure TfrmSideSwitchMain.DoDestroy;
begin
  inherited;
  if FMutex<>0 then CloseHandle(FMutex);
end;

const
  ShowItsMonitor=0;
  ShowAllMonitors=1;
  ShowAllMonitorsSwitch=2;

  Glyph_Minimize=' _ ';
  Glyph_Restore=' + ';
  Glyph_Close=' x ';

  Default_KeepShowingMS=1000;
  Default_IconTimeoutMS=150;
  Default_BorderMargin=32;
  Default_IconHeight=16;
  Default_ColorMain=clRed;
  Default_ColorVisible=clSkyBlue;
  Default_ColorMinimized=clSilver;
  Default_ShowVisible=ShowItsMonitor;
  Default_ShowMinimized=ShowAllMonitorsSwitch;
  Default_SwitchMirrored=false;
  Default_TaskBarNixTopMost=false;
  ICON_SMALL2=2;//since winXP

function InternalGetWindowText; external user32 name 'InternalGetWindowText';
function GetShellWindow; external user32 name 'GetShellWindow';

function DoListWindow(h:HWND; l:LongInt):Boolean; stdcall;
begin
  Result:=frmSideSwitchMain.ListWindow(h);
end;

function DoClearWindow(h:HWND; l:LongInt):Boolean; stdcall;
begin
  Result:=frmSideSwitchMain.ClearWindow(h);
end;

function DoTestWindow(h:HWND; l:LongInt):Boolean; stdcall;
begin
  Result:=frmSideSwitchMain.TestWindow(h);
end;

procedure TfrmSideSwitchMain.Timer1Timer(Sender: TObject);
var
  i,h,mw4,mh4:integer;
  m:TMonitor;
  r:TRect;
  p:TPoint;
  a:boolean;
begin
  m:=nil;//counter warning
  if Visible and (GetTickCount>FHideTC) and not(FDragging) then
   begin
    Visible:=false;
    FShowAll:=false;
   end;

  if ((GetKeyState(VK_SHIFT) and $80)=0) and
    ((GetKeyState(VK_CONTROL) and $80)<>0) then
    inc(FCCounter)
  else
    FCCounter:=0;

  if not(FIsListing) then
   begin
    FIsListing:=true;
    try
      p:=Mouse.CursorPos;
      i:=0;
      a:=true;
      FListUpsideDown:=false;
      while (i<Screen.MonitorCount) and a do
       begin
        m:=Screen.Monitors[i];
        mw4:=m.Width div 4;
        mh4:=m.Height div 4;
        a:=false;
        if FActivateTop and (p.Y=m.Top) and
          (p.X>=m.Left+mw4) and (p.X<=m.Left+mw4*3) then //top
          r:=Rect(
            m.Left+mw4,m.Top+FBorderMargin,
            m.Left+mw4*3,m.Top+m.Height-FBorderMargin)
        else
        if FActivateBottom and (p.Y=m.Top+m.Height-1) and
          (p.X>=m.Left+mw4) and (p.X<=m.Left+mw4*3) then //bottom
         begin
          r:=Rect(
            m.Left+mw4,m.Top+FBorderMargin,
            m.Left+mw4*3,m.Top+m.Height-FBorderMargin);
          FListUpsideDown:=true;
         end
        else
        if FActivateLeft and (p.X=m.Left) and
          (p.Y>=m.Top+mh4) and (p.Y<=m.Top+mh4*3) then //left
          r:=Rect(
            m.Left+FBorderMargin,m.Top+mh4,
            m.Left+mw4*3,m.Top+m.Height)
        else
        if FActivateRight and (p.X=m.Left+m.Width-1) and
          (p.Y>=m.Top+(m.Height div 4)) and (p.Y<=m.Top+(m.Height div 4)*3) then //right
          r:=Rect(
            m.Left+mw4*2,m.Top+mh4,
            m.Left+m.Width-FBorderMargin,m.Top+m.Height)
        else
        if FActivateHoldCtrl and (FCCounter=3) and
          (p.X>=m.Left) and (p.X<=m.Left+m.Width) and
          (p.Y>=m.Top) and (p.Y<=m.Top+m.Height) then
         begin
          if p.Y<m.Top+m.Height-mh4 then
            r:=Rect(p.X+8,p.Y+8,p.X+m.Width,p.Y+m.Height)
          else
           begin
            r:=Rect(p.X+8,p.Y-m.Height+8,p.X+m.Width,p.Y-8);
            FListUpsideDown:=true;
           end;
         end
        else
          a:=not(FDrawNext);
        inc(i);
       end;

      if not(a) then
       begin
        Canvas.Brush.Style:=bsSolid;
        Canvas.Brush.Color:=Color;
        Canvas.FillRect(Rect(0,0,ClientWidth,ClientHeight));
        if FDrawNext then FDrawNext:=false else
         begin
          BoundsRect:=r;
          FTargetMon:=m;
          FMonitorRect:=m.BoundsRect;
          FDesktopRect:=Screen.DesktopRect;
          FListSkip:=GetShellWindow;//'Program Manager'
         end;
        Visible:=true;
        if FListUpsideDown then FListY:=ClientHeight-FIconHeight-2 else FListY:=0;
        ShowWindow(Application.Handle,SW_HIDE);

        FAppListCount:=1;
        SetLength(FAppList,FAppListCount);
        FAppList[0].h:=0;
        FAppList[0].y:=FListY;
        Canvas.Brush.Color:=FColorMain;

        i:=0;
        h:=FIconHeight*5;
        Canvas.TextRect(Rect(i,FListY,i+h,FListY+FIconHeight),
          i+FIconHeight+(FIconHeight div 2),FListY,'Hide');
        inc(i,h+FIconHeight);
        Canvas.TextRect(Rect(i,FListY,i+h,FListY+FIconHeight),
          i+FIconHeight+(FIconHeight div 2),FListY,'Clear');
        inc(i,h+FIconHeight);
        if Screen.MonitorFromWindow(GetForegroundWindow,mdNull)<>FTargetmon then
          Canvas.TextRect(Rect(i,FListY,i+h,FListY+FIconHeight),
            i+FIconHeight+(FIconHeight div 2),FListY,'Switch');

        inc(i,h+FIconHeight);
        Canvas.TextRect(Rect(i,FListY,i+h,FListY+FIconHeight),
          i+FIconHeight+(FIconHeight div 2),FListY,'More');

        if FShowTestButton then
         begin
          inc(i,h+FIconHeight);
          Canvas.TextRect(Rect(i,FListY,i+h,FListY+FIconHeight),
            i+FIconHeight+(FIconHeight div 2),FListY,'Test');

          inc(i,h+FIconHeight);
          Canvas.TextRect(Rect(i,FListY,i+h,FListY+FIconHeight),
            i+FIconHeight+(FIconHeight div 2),FListY,'xxx');
         end;

        if FListUpsideDown then dec(FListY,FIconHeight+2) else inc(FListY,FIconHeight+2);

        FAppHandle1:=0;
        FAppHandle2:=0;
        FAppMini:=false;
        //FShowAll:=(GetKeyState(VK_CONTROL) and $80)<>0;
        FShowFullInfo:=(GetKeyState(VK_SHIFT) and $80)<>0;
        EnumWindows(@DoListWindow,0);

        FHideTC:=GetTickCount+FKeepShowingMS;
       end;
    except
      //silent (e.g. when workstation is locked)
    end;
    FIsListing:=false;
   end;
end;

function TfrmSideSwitchMain.WindowOnMonitor(h:THandle):boolean;
var
  p:TWindowPlacement;
  r:TRect;
  i,j:integer;
begin
  //Result:=Screen.MonitorFromWindow(h,mdNull)=m;
  Result:=GetWindowPlacement(h,@p);
  if Result then
   begin
    r:=p.rcNormalPosition;
    //Delphi apps use Application.Handle window of 0x0 pixels
    if r.Top=r.Bottom then
     begin
      Result:=GetWindowPlacement(GetLastActivePopup(h),@p);
      if Result then r:=p.rcNormalPosition;
     end;
   end;
  if Result then
   begin
    if FDesktopRect.Left>r.Left then r.Left:=FDesktopRect.Left;
    if FDesktopRect.Right<r.Right then r.Right:=FDesktopRect.Right;
    if r.Top=r.Bottom then
     begin
      if FDesktopRect.Top>r.Top then r.Top:=FDesktopRect.Top;
      if FDesktopRect.Bottom<r.Top then r.Bottom:=FDesktopRect.Top;
      r.Bottom:=r.Top;
     end
    else
     begin
      if FDesktopRect.Top>r.Top then r.Top:=FDesktopRect.Top;
      if FDesktopRect.Bottom<r.Bottom then r.Bottom:=FDesktopRect.Bottom;
     end;
    if (r.Left<=r.Right) and (r.Top<=r.Bottom) then
     begin
      if r.Top=r.Bottom then inc(r.Bottom); 
      i:=(r.Right-r.Left)*(r.Bottom-r.Top);
      if FMonitorRect.Left>r.Left then r.Left:=FMonitorRect.Left;
      if FMonitorRect.Right<r.Right then r.Right:=FMonitorRect.Right;
      if r.Top=r.Bottom then
       begin
        if FMonitorRect.Top>r.Top then r.Top:=FMonitorRect.Top;
        if FMonitorRect.Bottom<r.Top then r.Top:=FMonitorRect.Bottom;
        r.Bottom:=r.Top;
       end
      else
       begin
        if FMonitorRect.Top>r.Top then r.Top:=FMonitorRect.Top;
        if FMonitorRect.Bottom<r.Bottom then r.Bottom:=FMonitorRect.Bottom;
       end;
      if (r.Left<=r.Right) and (r.Top<=r.Bottom) then j:=(r.Right-r.Left)*(r.Bottom-r.Top) else j:=-1;
      Result:=j*4>=i;
     end
    else
      Result:=false;
   end;
end;

function TfrmSideSwitchMain.ListWindow(h:HWND):boolean;
var
  hp,hx:THandle;
  s:WideString;
  b,l:boolean;
  x,i:integer;
  wp:TWindowPlacement;
begin
  if (h<>Handle) and (h<>FListSkip) and IsWindowVisible(h) then
   begin
    hp:=GetWindowLong(h,GWL_HWNDPARENT);
    if (hp=0) or (GetWindow(h,GW_OWNER)=0) or (FShowAll and (
      ((GetWindowLong(h,GWL_EXSTYLE) and WS_EX_APPWINDOW)<>0) or
      ((GetWindowLong(hp,GWL_EXSTYLE) and WS_EX_APPWINDOW)<>0))) then
     begin
      b:=IsIconic(h);
      if FShowFullInfo then l:=true else
        if b then
          l:=(FShowMinimized<>ShowItsMonitor) or WindowOnMonitor(h)
        else
          l:=(FShowVisible<>ShowItsMonitor) or WindowOnMonitor(h);
      if l and not(FShowAll)
        and (GetWindow(h,GW_CHILD)=0) and GetWindowPlacement(h,@wp) then
        if h=FAppHandle1 then
         begin
          h:=FAppHandle2;
          b:=FAppMini;
          FAppHandle1:=0;
          FAppHandle2:=0;
          FAppMini:=false;
         end
        else
          l:=not((wp.flags=0)
            and (wp.rcNormalPosition.Top=wp.rcNormalPosition.Bottom)
            and (wp.rcNormalPosition.Left=wp.rcNormalPosition.Right));
      if l then
       begin
        x:=Font.Size*7 div 3;
        Canvas.Brush.Color:=FColorMain;
        if b then
          Canvas.TextOut(0,FListY,Glyph_Restore)
        else
          Canvas.TextOut(0,FListY,Glyph_Minimize);
        Canvas.TextOut(x,FListY,Glyph_Close);
        inc(x,x);
        SetLength(s,1024);
        if FShowAll and FShowFullInfo then
         begin
          SetLength(s,GetClassNameW(h,PWideChar(s),1023));
          if GetWindowPlacement(h,@wp) then
            s:=s+Format(' %.8x %d,%d %d,%d',[
              wp.flags,
              wp.rcNormalPosition.Left,
              wp.rcNormalPosition.Top,
              wp.rcNormalPosition.Right-wp.rcNormalPosition.Left,
              wp.rcNormalPosition.Bottom-wp.rcNormalPosition.Top
            ]);
         end
        else
          SetLength(s,InternalGetWindowText(h,PWideChar(s),1023));
        if b then
          Canvas.Brush.Color:=FColorMinimized
        else
          Canvas.Brush.Color:=FColorVisible;
        Canvas.TextRect(Rect(
          FIconHeight+x-2,FListY,
          FIconHeight+x+10+Canvas.TextWidth(s),FListY+FIconHeight),
          FIconHeight+x+4,FListY,s);
        Canvas.Brush.Color:=clRed;
        Canvas.FillRect(Rect(x+2,FListY-1,x+4,FListY+FIconHeight+1));
        hx:=0;//default
        if FIconHeight<=24 then
         begin
          if hx=0 then if SendMessageTimeout(h,WM_GETICON,ICON_SMALL2,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,hx)=0 then hx:=0;
          if hx=0 then if SendMessageTimeout(h,WM_GETICON,ICON_SMALL,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,hx)=0 then hx:=0;
          if hx=0 then hx:=GetClassLong(h,GCL_HICONSM);
         end;
        if hx=0 then if SendMessageTimeout(h,WM_GETICON,ICON_BIG,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,hx)=0 then hx:=0;
        if hx=0 then hx:=GetClassLong(h,GCL_HICON);
        if (hx=0) and (hp<>0) then
         begin
          if FIconHeight<=24 then
           begin
            if hx=0 then if SendMessageTimeout(hp,WM_GETICON,ICON_SMALL2,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,hx)=0 then hx:=0;
            if hx=0 then if SendMessageTimeout(hp,WM_GETICON,ICON_SMALL,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,hx)=0 then hx:=0;
            if hx=0 then hx:=GetClassLong(hp,GCL_HICONSM);
           end;
          if hx=0 then if SendMessageTimeout(hp,WM_GETICON,ICON_BIG,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,hx)=0 then hx:=0;
          if hx=0 then hx:=GetClassLong(hp,GCL_HICON);
         end;
        if hx=0 then
         begin
          SetLength(s,1024);
          SetLength(s,GetClassNameW(h,PWideChar(s),1023));
          if s='Shell_TrayWnd' then
           begin
            hx:=FTaskBarHIcon;
            if FTaskBarNixTopMost then
             begin
              hp:=GetForegroundWindow;
              i:=GetWindowLong(h,GWL_EXSTYLE);
              if ((i and WS_EX_TOPMOST)<>0) and (h<>hp) then
               begin
                dec(i,WS_EX_TOPMOST);
                SetWindowLong(h,GWL_EXSTYLE,i);
                //SetWindowPos(h,hp,?
                SetWindowPos(h,HWND_BOTTOM,0,0,0,0,
                  SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_ASYNCWINDOWPOS);
                SetWindowPos(hp,HWND_NOTOPMOST,0,0,0,0,
                  SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_ASYNCWINDOWPOS);
               end;
             end;
           end;
         end;
        //if hx=0 then default?
        DrawIconEx(Canvas.Handle,x,FListY,hx,FIconHeight,FIconHeight,0,0,DI_NORMAL);
        SetLength(FAppList,FAppListCount+1);
        FAppList[FAppListCount].h:=h;
        FAppList[FAppListCount].y:=FListY;
        inc(FAppListCount);
        if FListUpsideDown then dec(FListY,FIconHeight+2) else inc(FListY,FIconHeight+2);
       end;
     end
    else
      if hp<>0 then
       begin
        FAppHandle1:=hp;
        FAppHandle2:=h;
        FAppMini:=IsIconic(h);
       end
      else
       begin
        FAppHandle1:=0;
        FAppHandle2:=0;
        FAppMini:=false;
       end;
   end;
  Result:=FListY<ClientHeight;
end;

procedure TfrmSideSwitchMain.btnSwitchClick(Sender: TObject);
var
  h:THandle;
begin
  h:=GetForegroundWindow;
  if h=Handle then h:=GetWindow(h,GW_HWNDNEXT);
  SwitchWindow(h);
  FHideTC:=GetTickCount+(FKeepShowingMS div 2);
end;

procedure TfrmSideSwitchMain.SwitchWindow(h:THandle);
var
  m:TMonitor;
  p:TWindowPlacement;
  r:TRect;
  r1,r2:integer;
begin
  m:=Screen.MonitorFromWindow(h);
  if m<>FTargetMon then
   begin
    p.length:=SizeOf(TWindowPlacement);
    Win32Check(GetWindowPlacement(h,@p));
    r:=p.rcNormalPosition;
    if FSwitchMirrored and ((m.MonitorNum and 1)<>(FTargetMon.MonitorNum and 1)) then
     begin
      r1:=m.Left+m.Width-r.Right;
      r2:=m.Left+m.Width-r.Left;
     end
    else
     begin
      r1:=r.Left-m.Left;
      r2:=r.Right-m.Left;
     end;
    p.rcNormalPosition.Left  :=FTargetMon.Left+r1*FTargetMon.Width  div m.Width;
    p.rcNormalPosition.Top   :=FTargetMon.Top +(r.Top -m.Top )*FTargetMon.Height div m.Height;
    p.rcNormalPosition.Right :=FTargetMon.Left+r2*FTargetMon.Width  div m.Width;
    p.rcNormalPosition.Bottom:=FTargetMon.Top +(r.Bottom-m.Top )*FTargetMon.Height div m.Height;
    Win32Check(SetWindowPlacement(h,@p));
    if IsZoomed(h) then
     begin
      Win32Check(GetWindowRect(h,r));
      Win32Check(MoveWindow(h,
        FTargetMon.Left+(r.Left-m.Left)*FTargetMon.Width  div m.Width,
        FTargetMon.Top +(r.Top -m.Top )*FTargetMon.Height div m.Height,
        (r.Right -r.Left)*FTargetMon.Width  div m.Width,
        (r.Bottom-r.Top )*FTargetMon.Height div m.Height,
        true));
     end;
   end;
end;

procedure TfrmSideSwitchMain.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FHideTC:=GetTickCount+FKeepShowingMS;
  if FDragging then
   begin
    Canvas.TextRect(Rect(FIconHeight*24,FListY,FIconHeight*30,
      FListY+FIconHeight),
      FIconHeight*24+(FIconHeight div 2),FListY,Format('  %d,%d  ',[
        X-FStartX,
        Y-FStartY
      ]));

   end;
end;

procedure TfrmSideSwitchMain.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i:integer;
begin
  if Button=mbLeft then
   begin
    i:=0;
    while (i<Length(FAppList)) and not((Y>=FAppList[i].y) and (Y<FAppList[i].y+FIconHeight+2)) do inc(i);
    if (i<Length(FAppList)) then
      if FAppList[i].h=0 then
        case X div (FIconHeight*6) of
          0:btnHideClick(Sender);
          1:btnClearClick(Sender);
          2:btnSwitchClick(Sender);
          3:
           begin
            FShowAll:=true;
            FDrawNext:=true;
           end;
          4:TestListWindows;
          5:
           begin
            FDragging:=true;
            FStartX:=X;
            FStartY:=Y;
           end;
          //...
        end
      else
        case X div (Font.Size*7 div 3) of
          0://min/restore
            if IsIconic(FAppList[i].h) then
             begin
              ShowWindow(FAppList[i].h,SW_RESTORE);
              if FShowMinimized=ShowAllMonitorsSwitch then SwitchWindow(FAppList[i].h);
              Canvas.Brush.Color:=FColorVisible;
              Canvas.TextOut(0,FAppList[i].y,Glyph_Minimize);
             end
            else
             begin
              ShowWindow(FAppList[i].h,SW_MINIMIZE);
              Canvas.Brush.Color:=FColorMinimized;
              Canvas.TextOut(0,FAppList[i].y,Glyph_Restore);
             end;
          1://close
           begin
            if (GetKeyState(VK_CONTROL) and $80)<>0 then
              PostMessage(FAppList[i].h,WM_QUIT,0,0)
            else
              PostMessage(FAppList[i].h,WM_CLOSE,0,0);
            Canvas.Brush.Color:=Color;
            Canvas.FillRect(Rect(0,FAppList[i].y,Width,FAppList[i].y+FIconHeight+1));
           end;
          else
           begin
            if IsIconic(FAppList[i].h) then
             begin
              ShowWindow(FAppList[i].h,SW_RESTORE);
              if (FShowMinimized=ShowAllMonitorsSwitch) or (FShowFullInfo) then
                SwitchWindow(FAppList[i].h);
             end;
            SetForegroundWindow(FAppList[i].h);
           end;
        end;
   end;
end;

procedure TfrmSideSwitchMain.btnClearClick(Sender: TObject);
begin
  SetLength(FAppList,0);
  //FHideTC:=GetTickCount+(FKeepShowingMS div 2);
  Visible:=false;
  EnumWindows(@DoClearWindow,0);
end;

function TfrmSideSwitchMain.ClearWindow(h:HWND):boolean;
var
  hp:THandle;
  p:cardinal;
  wp:TWindowPlacement;
  b:boolean;
begin
  if (h<>Handle) and IsWindowVisible(h) then
   begin
    hp:=GetWindowLong(h,GWL_HWNDPARENT);
    b:=(hp=0) or (GetWindow(h,GW_OWNER)=0);
    if b then b:=not(IsIconic(h)) and WindowOnMonitor(h);
    if b then b:=(GetWindowLong(h,GWL_EXSTYLE)
      and (WS_EX_NOACTIVATE or WS_EX_TOPMOST))=0;
    if b and (GetWindow(h,GW_CHILD)=0) and GetWindowPlacement(h,@wp) then
      b:=not((wp.flags=0)
        and (wp.rcNormalPosition.Right=0)
        and (wp.rcNormalPosition.Left=0)
        and (wp.rcNormalPosition.Bottom=0)
        and (wp.rcNormalPosition.Top=0));
    if b then
     begin
      GetWindowThreadProcessId(h,p);
      SendMessageTimeout(h,WM_SYSCOMMAND,SC_MINIMIZE,0,SMTO_ABORTIFHUNG,FIconTimeoutMS,p);
     end;
   end;
  Result:=true;
end;

procedure TfrmSideSwitchMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSideSwitchMain.DoShow;
begin
  inherited;
  ShowWindow(Application.Handle,SW_HIDE);
  FHideTC:=GetTickCount;
  FTaskbarHIcon:=LoadIcon(LoadLibraryEx('shell32.dll',0,$22),PChar(integer(40)));
end;

procedure TfrmSideSwitchMain.DoCreate;
var
  fs:TFontStyles;
begin
  inherited;
  FIsListing:=false;
  FMutex:=CreateMutex(nil,false,'SideSwitch_SingleInstance');
  if (FMutex=0) or (GetLastError=ERROR_ALREADY_EXISTS) then
   begin
    MessageBox(GetDesktopWindow,'An instance of SideSwitch is already running.'#13#10'Move the mouse pointer to the edges of the screen to see a list of windows on that monitor.',
      'SideSwitch',MB_ICONINFORMATION or MB_OK or MB_SYSTEMMODAL);
    PostQuitMessage(1);
   end;
  FKeepShowingMS:=Default_KeepShowingMS;
  FIconTimeoutMS:=Default_IconTimeoutMS;
  FBorderMargin:=Default_BorderMargin;
  FIconHeight:=Default_IconHeight;
  FColorMain:=Default_ColorMain;
  FColorVisible:=Default_ColorVisible;
  FColorMinimized:=Default_ColorMinimized;
  FShowVisible:=Default_ShowVisible;
  FShowMinimized:=Default_ShowMinimized;
  FSwitchMirrored:=Default_SwitchMirrored;
  FTaskBarNixTopMost:=Default_TaskBarNixTopMost;
  FShowTestButton:=(ParamCount>0) and (LowerCase(ParamStr(1))='/test');
  FDragging:=false;
  FCCounter:=0;
  FDrawNext:=false;
  FActivateTop:=true;
  FActivateLeft:=true;
  FActivateRight:=true;
  FActivateBottom:=true;
  with TRegistry.Create do
   begin
    try
      if OpenKeyReadOnly('\Software\Double Sigma Programming\SideSwitch') then
       begin
        FKeepShowingMS:=ReadInteger('KeepShowingMS');
        FBorderMargin:=ReadInteger('BorderMargin');
        FIconHeight:=ReadInteger('IconHeight');
        Self.Font.Size:=ReadInteger('FontSize');
        Self.Font.Name:=ReadString('FontName');
        fs:=[];
        if ReadBool('FontItalic') then Include(fs,fsItalic);
        if ReadBool('FontBold') then Include(fs,fsBold);
        Self.Font.Style:=fs;
        Self.Font.Color:=ReadInteger('FontColor');
        FColorMain:=ReadInteger('MainColor');
        FColorVisible:=ReadInteger('VisibleColor');
        FColorMinimized:=ReadInteger('MinimizedColor');
        FShowVisible:=ReadInteger('ShowVisible');
        FShowMinimized:=ReadInteger('ShowMinimized');
        FIconTimeoutMS:=ReadInteger('IconTimeoutMS');
        FSwitchMirrored:=ReadBool('SwitchMirrored');
        FTaskBarNixTopMost:=ReadBool('TaskBarNixTopMost');
        FActivateTop:=ReadBool('ActivateTop');
        FActivateLeft:=ReadBool('ActivateLeft');
        FActivateRight:=ReadBool('ActivateRight');
        FActivateBottom:=ReadBool('ActivateBottom');
        FActivateHoldCtrl:=ReadBool('ActivateHoldCtrl');
        CloseKey;
       end;
    except
      //silent, use defaults
    end;
    Free;
   end;
end;

procedure TfrmSideSwitchMain.Settings1Click(Sender: TObject);
var
  r:TRegistry;
begin
  with TfrmSettings.Create(nil) do
    try
      udIconHeight.Position:=FIconHeight;
      udKeepShowing.Position:=FKeepShowingMS;
      udIconTimeout.Position:=FIconTimeoutMS;
      FontDialog1.Font:=Self.Font;
      panClrMain.Color:=FColorMain;
      panClrVisible.Color:=FColorVisible;
      panClrMinimized.Color:=FColorMinimized;
      rgVisible.ItemIndex:=FShowVisible;
      rgMinimized.ItemIndex:=FShowMinimized;
      cbSwitchMirrored.Checked:=FSwitchMirrored;
      cbTaskBarNixTopMost.Checked:=FTaskBarNixTopMost;
      cbScreenTop.Checked:=FActivateTop;
      cbScreenLeft.Checked:=FActivateLeft;
      cbScreenRight.Checked:=FActivateRight;
      cbScreenBottom.Checked:=FActivateBottom;
      cbActivateHoldCtrl.Checked:=FActivateHoldCtrl;
      r:=TRegistry.Create;
      try
        //r.RootKey:=HKEY_CURRENT_USER;//assert default
        if r.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Run') then
         begin
          if r.ValueExists('SideSwitch') then cbSessionBoot.Checked:=true;
          r.CloseKey;
         end;
      finally
        r.Free;
      end;
      if ShowModal=mrOk then
       begin
        FIconHeight:=udIconHeight.Position;
        Self.Font:=FontDialog1.Font;
        FKeepShowingMS:=udKeepShowing.Position;
        FColorMain:=panClrMain.Color;
        FColorVisible:=panClrVisible.Color;
        FColorMinimized:=panClrMinimized.Color;
        FShowVisible:=rgVisible.ItemIndex;
        FShowMinimized:=rgMinimized.ItemIndex;
        FSwitchMirrored:=cbSwitchMirrored.Checked;
        FTaskBarNixTopMost:=cbTaskBarNixTopMost.Checked;
        FActivateTop:=cbScreenTop.Checked;
        FActivateLeft:=cbScreenLeft.Checked;
        FActivateRight:=cbScreenRight.Checked;
        FActivateBottom:=cbScreenBottom.Checked;
        FActivateHoldCtrl:=cbActivateHoldCtrl.Checked;
        r:=TRegistry.Create;
        try
          //r.RootKey:=HKEY_CURRENT_USER;//assert default
          r.OpenKey('\Software\Double Sigma Programming\SideSwitch',true);
          r.WriteInteger('KeepShowingMS',FKeepShowingMS);
          r.WriteInteger('IconTimeoutMS',FIconTimeoutMS);
          r.WriteInteger('BorderMargin',FBorderMargin);
          r.WriteInteger('IconHeight',FIconHeight);
          r.WriteInteger('FontSize',Self.Font.Size);
          r.WriteString('FontName',Self.Font.Name);
          r.WriteBool('FontItalic',fsItalic in Self.Font.Style);
          r.WriteBool('FontBold',fsBold in Self.Font.Style);
          r.WriteInteger('FontColor',Self.Font.Color);
          r.WriteInteger('MainColor',FColorMain);
          r.WriteInteger('VisibleColor',FColorVisible);
          r.WriteInteger('MinimizedColor',FColorMinimized);
          r.WriteInteger('ShowVisible',FShowVisible);
          r.WriteInteger('ShowMinimized',FShowMinimized);
          r.WriteBool('SwitchMirrored',FSwitchMirrored);
          r.WriteBool('TaskBarNixTopMost',FTaskBarNixTopMost);
          r.WriteBool('ActivateTop',FActivateTop);
          r.WriteBool('ActivateLeft',FActivateLeft);
          r.WriteBool('ActivateRight',FActivateRight);
          r.WriteBool('ActivateBottom',FActivateBottom);
          r.WriteBool('ActivateHoldCtrl',FActivateHoldCtrl);
          r.CloseKey;
          r.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run',true);
          if cbSessionBoot.Checked then
            r.WriteString('SideSwitch','"'+Application.ExeName+'"')
          else
            if r.ValueExists('SideSwitch') then r.DeleteValue('SideSwitch');
          r.CloseKey;
        finally
          r.Free;
        end;
       end;
    finally
      Free;
    end;
end;

procedure TfrmSideSwitchMain.btnHideClick(Sender: TObject);
begin
  Visible:=false;
end;

procedure TfrmSideSwitchMain.PopupMenu1Popup(Sender: TObject);
begin
  //FHideTC:=GetTickCount+FKeepShowingMS;
  FHideTC:=GetTickCount+5000;
end;

procedure TfrmSideSwitchMain.WMDisplayChange(var Msg: TWMDisplayChange);
begin
  Monitor;//forces update of Screen.Monitor!
  //if FSwitchOnDisplayChange then TestListWindows;
end;

var
  gTestList:string;

procedure TfrmSideSwitchMain.TestListWindows;
begin
  gTestList:='';
  EnumWindows(@DoTestWindow,0);
  with TFileStream.Create(FormatDateTime('yyyymmddhhnnss',Now)+'.log',fmCreate) do
    try
      Write(gTestList[1],Length(gTestList));
    finally
      Free;
    end;
end;

function TfrmSideSwitchMain.TestWindow(h: HWND): boolean;
const
  IsMini:array[boolean] of string=('+','-');
var
  t,u:WideString;
  wp:TWindowPlacement;
  r:TRect;
  hp:THandle;
begin
  hp:=GetWindowLong(h,GWL_HWNDPARENT);
  if IsWindowVisible(h) and ((hp=0) or (GetWindow(h,GW_OWNER)=0) or (
    ((GetWindowLong(h,GWL_EXSTYLE) and WS_EX_APPWINDOW)<>0) or
    ((GetWindowLong(hp,GWL_EXSTYLE) and WS_EX_APPWINDOW)<>0))) then
   begin
    SetLength(t,1024);
    SetLength(t,InternalGetWindowText(h,PWideChar(t),1023));
    SetLength(u,1024);
    SetLength(u,GetClassNameW(h,PWideChar(u),1023));
    if GetWindowPlacement(h,@wp) and GetWindowRect(h,r) then
      gTestList:=Format('%s%.8x %.8x %.2x %.2x %.6d (%.6d,%.6d %.6d,%.6d) (%.6d,%.6d %.6d,%.6d) %s [%s] %s'#13#10,[gTestList,
        h,
        hp,
        wp.flags,
        wp.showCmd,
        GetWindowThreadProcessId(h,nil),
        wp.rcNormalPosition.Left,
        wp.rcNormalPosition.Top,
        wp.rcNormalPosition.Right,
        wp.rcNormalPosition.Bottom,
        r.Left,
        r.Top,
        r.Right,
        r.Bottom,
        IsMini[IsIconic(h)],
        u,
        t
      ]);
   end;
  Result:=true;
end;

procedure TfrmSideSwitchMain.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDragging:=false;
end;

end.
