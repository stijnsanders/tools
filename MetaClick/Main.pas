unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, ExtCtrls, StdCtrls, Menus, mcCommon;

type
  TfrmMetaClick = class(TForm)
    panMain: TPanel;
    PopupMenu1: TPopupMenu;
    panLeftSingle: TPanel;
    panLeftDouble: TPanel;
    panRightSingle: TPanel;
    panClose: TPanel;
    Exit1: TMenuItem;
    N2: TMenuItem;
    Settings1: TMenuItem;
    panRightDouble: TPanel;
    panRightDrag: TPanel;
    panLeftDrag: TPanel;
    panOptions: TPanel;
    panWheel: TPanel;
    Timer1: TTimer;
    Suspend1: TMenuItem;
    imgResize: TImage;
    N1: TMenuItem;
    LeftSingle1: TMenuItem;
    LeftDouble1: TMenuItem;
    LeftDrag1: TMenuItem;
    RightSingle1: TMenuItem;
    RightDouble1: TMenuItem;
    RightDrag1: TMenuItem;
    Wheel1: TMenuItem;
    panSuspend: TPanel;
    panCountDown: TPanel;
    panCountDown1: TPanel;
    panCountDown2: TPanel;
    tiMouseOver: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure panCloseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panWheelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panOptionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panRightDragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panRightDoubleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panLeftDragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AllMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure AllMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AllMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure panLeftSingleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panLeftDoubleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panRightSingleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Suspend1Click(Sender: TObject);
    procedure imgResizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure panSuspendMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LeftSingle1Click(Sender: TObject);
    procedure LeftDouble1Click(Sender: TObject);
    procedure LeftDrag1Click(Sender: TObject);
    procedure RightSingle1Click(Sender: TObject);
    procedure RightDouble1Click(Sender: TObject);
    procedure RightDrag1Click(Sender: TObject);
    procedure Wheel1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tiMouseOverTimer(Sender: TObject);
  private
    IsMoving,IsMovingStarted,IsResizing,IsPopUp,IsMOver:boolean;
    StartDrag,StartPos,DragHold,LastPos:TPoint;
    LastTC:cardinal;
    ClickMS,HideMS,FOrbit,FOrbitSize,FOrbitCrossSize,FReturnTo,
    FCursorTagPosX,FCursorTagPosY,FCursorTagWidth,FCursorTagHeight,
    bx,by,FCursorTagABL,FShowOnMouseOver,FAlphaLevel:integer;
    Clicked: TClickState;
    FClickMode: TClickMode;
    BoolColor:array[boolean] of TColor;
    FVerifClose: boolean;
    WheelKeepY,IgnoreAgainCounter: integer;
    FSoundPlayFile:string;
    FShowCursorTag,FCursorTagKeepOnScreen,FStartSus:boolean;
    FIgnores:TStringList;
    Corners:HRGN;
    procedure SetVerifClose(const Value: boolean);
    function IsClicked: boolean;
    procedure SetClickMode(const Value: TClickMode);
    procedure ArrangeButtons;
    procedure DrawCountDown(cd:integer);
    function CheckIgnores(SkipOrbit:boolean): boolean;
    procedure StoreBounds;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    property ClickMode:TClickMode read FClickMode write SetClickMode;
    property VerifClose:boolean read FVerifClose write SetVerifClose;
  public
    procedure UpdateSettings(SetClickMS, HideAfterMS, Buttons,
      Orbit, OrbitSize, OrbitCrossSize, OrbitMarginX, OrbitMarginY, OrbitShape,
      ReturnTo, CursorTagPosX,CursorTagPosY,CursorTagWidth,CursorTagHeight,
      AlphaBlendLevel1, AlphaBlendLevelCT,ShowOnMouseOver: integer;
      ShowCursorTag, CursorTagKeepOnScreen:boolean;
      ColorBG1, ColorBG2: TColor; Font1: TFont; SetDragHold: TPoint;
      SoundFilePath: string; Ignores: TStrings);
  end;

  PGetModuleFileNameEx=function(hProcess,hModule:THandle;lpFileName:PAnsiChar;cchFileNameMax:UINT):UINT; stdcall;

var
  frmMetaClick: TfrmMetaClick;
  GetModuleFileNameEx: PGetModuleFileNameEx;

implementation

uses CursorTag, Settings, Math, MMSystem, Orbit;

const
  SysDragHoldX=4;//GetSystemMetrics(SM_CXDRAG)
  SysDragHoldY=4;//GetSystemMetrics(SM_CYDRAG)
  WHEEL_DELTA=120;

{$R *.dfm}

procedure TfrmMetaClick.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StoreBounds;
end;

procedure TfrmMetaClick.StoreBounds;
var
  sl:TStringList;
  fn:string;
begin
  sl:=TStringList.Create;
  try
    fn:=ChangeFileExt(ParamStr(0),'.ini');
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
end;

procedure CheckMin(var a:integer;b:integer);
begin
  if a<b then a:=b;
end;

procedure CheckMax(var a:integer;b:integer);
begin
  if a>b then a:=b;
end;

function i2ABV(i:integer):integer;
begin
  Result:=(4-i)*64-1;
end;

function ABV2i(a:integer):integer;
begin
  Result:=4-((a+1) div 64);
end;

procedure TfrmMetaClick.FormCreate(Sender: TObject);
var
  sl,sl1:TStringList;
  f:TFont;
  x,y,sx,sy,b1,ms1,ms2,omx,omy,oms,ablCT,smo,r1,c1,c2:integer;
  dr:TRect;
  p:TPoint;
  spf,fn:string;
  ct:boolean;
const
  MinimalShowMargin=4;
begin
  IsMoving:=false;
  IsResizing:=false;
  IsPopUp:=false;
  IsMOver:=false;
  try
    LastPos:=Mouse.CursorPos;
  except
    LastPos:=Point(0,0);//access denied?
  end;
  FIgnores:=TStringList.Create;
  //default values
  ClickMS:=1000;
  HideMS:=ClickMS*3;
  FReturnTo:=1;//return to L1
  FShowCursorTag:=true;
  BoolColor[false]:=$DDCCBB;//$00CCFF;//yellow
  BoolColor[true]:=$CC6666;//$0000CC;//red
  p.X:=16;//GetSystemMetrics(SM_CXDRAG);
  p.Y:=16;//GetSystemMetrics(SM_CYDRAG);
  DragHold:=p;
  b1:=$24F;
  FAlphaLevel:=1;
  FOrbit:=$00B;
  FOrbitSize:=100;
  FOrbitCrossSize:=5;
  FCursorTagPosX:=CursorTagPadX_Default;
  FCursorTagPosY:=CursorTagPadY_Default;
  FCursorTagWidth:=CursorTagWidth_Default;
  FCursorTagHeight:=CursorTagHeight_Default;
  FCursorTagKeepOnScreen:=true;
  dr:=Screen.DesktopRect;
  x:=dr.Left+(dr.Right-dr.Left)*3 div 4;//Left;
  y:=dr.Top+(dr.Bottom-dr.Top)*3 div 4;//Top;
  sx:=170;//Width;
  sy:=Height;
  spf:='';
  ct:=true;
  ms1:=ClickMS;
  ms2:=HideMS;
  omx:=5;
  omy:=3;
  oms:=0;
  bx:=0;
  by:=0;
  Corners:=0;
  smo:=0;
  ablCT:=1;
  r1:=0;
  c1:=BoolColor[false];
  c2:=BoolColor[true];

  ClickMode:=cmLeftSingle;//uses BoolColor!

  //load settings (excessive silent try/except's here are for easy upgradability)
  fn:=ChangeFileExt(ParamStr(0),'.ini');
  sl:=TStringList.Create;
  sl1:=TStringList.Create;
  f:=TFont.Create;
  f.Assign(Font);
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
  except
    //silent use defaults
  end;
  SetBounds(x,y,sx,sy);
  try
    f.Color:=StrToInt('$'+sl.Values['ColorFG']);
    f.Name:=sl.Values['FontName'];
    f.Size:=StrToInt(sl.Values['FontSize']);
    if sl.Values['FontBold']='1' then f.Style:=f.Style+[fsBold];
    if sl.Values['FontUnderline']='1' then f.Style:=f.Style+[fsUnderline];
    if sl.Values['FontItalic']='1' then f.Style:=f.Style+[fsItalic];
    p.X:=StrToInt(sl.Values['DragHoldX']);
    p.Y:=StrToInt(sl.Values['DragHoldY']);
    spf:=sl.Values['PlaySound'];
    ct:=sl.Values['CursorTag']='1';
    y:=StrToInt(sl.Values['IgnoreRules']);
    for x:=1 to y do sl1.Add(sl.Values['IgnoreRule'+IntToStr(x)]);
    b1:=StrToInt(sl.Values['Buttons']);
    FOrbit:=StrToInt(sl.Values['Orbit']);
    FOrbitSize:=StrToInt(sl.Values['OrbitSize']);
    ms1:=StrToInt(sl.Values['Interval']);
    ms2:=StrToInt(sl.Values['HideAfter']);
    FCursorTagPosX:=StrToInt(sl.Values['CursorTagPosX']);
    FCursorTagPosY:=StrToInt(sl.Values['CursorTagPosY']);
    FCursorTagWidth:=StrToInt(sl.Values['CursorTagWidth']);
    FCursorTagHeight:=StrToInt(sl.Values['CursorTagHeight']);
    FCursorTagKeepOnScreen:=sl.Values['CursorTagKeepOnScreen']='1';
    omx:=StrToInt(sl.Values['OrbitMarginX']);
    omy:=StrToInt(sl.Values['OrbitMarginY']);
    oms:=StrToInt(sl.Values['OrbitShape']);
    FOrbitCrossSize:=StrToInt(sl.Values['OrbitCrossSize']);
    smo:=StrToInt(sl.Values['ShowOnMouseOver']);
    FAlphaLevel:=StrToInt(sl.Values['AlphaLevel']);
    ablCT:=StrToInt(sl.Values['CursorTagAlphaLevel']);
    FStartSus:=sl.Values['StartSuspended']='1';
    r1:=StrToInt(sl.Values['ReturnTo']);
    c1:=StrToInt('$'+sl.Values['ColorBG1']);
    c2:=StrToInt('$'+sl.Values['ColorBG2']);
  except
    //silent use defaults
    y:=0;
  end;
  sl.Free;
  //Don't use r past this line!!!
  try
    UpdateSettings(
      ms1,ms2,b1,FOrbit,FOrbitSize,FOrbitCrossSize,omx,omy,oms,r1,
      FCursorTagPosX,FCursorTagPosY,FCursorTagWidth,FCursorTagHeight,
      FAlphaLevel,ablCT,smo,ct,FCursorTagKeepOnScreen,
      c1,c2,f,p,spf,sl1);
  except
    //silently, use defaults, force first arrange
    ArrangeButtons;
  end;
  f.Free;
  sl1.Free;

  LastTC:=GetTickCount-cardinal(ClickMS);
  Clicked:=csAllDone;
end;

procedure TfrmMetaClick.AllMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsMovingStarted:=false;
  IsMoving:=Button=mbLeft;
  StartPos:=BoundsRect.TopLeft;
  StartDrag:=Mouse.CursorPos;
  IsPopUp:=false;
end;

procedure TfrmMetaClick.AllMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsClicked;
end;

function TfrmMetaClick.IsClicked:boolean;
begin
  IsMoving:=false;
  IsResizing:=false;
  VerifClose:=false;
  Result:=not(IsPopUp) and not(IsMovingStarted);
  IsPopUp:=false;
end;

procedure TfrmMetaClick.AllMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx,dy:integer;
  p:TPoint;
begin
  if IsMoving then
   begin
    p:=Mouse.CursorPos;
    if IsMovingStarted then
     begin
      SetBounds(
        StartPos.X-StartDrag.X+p.X,
        StartPos.Y-StartDrag.Y+p.Y,
        Width,Height);
     end
    else
     begin
      dx:=p.X-StartDrag.X;
      if dx<0 then dx:=-dx;
      dy:=p.Y-StartDrag.Y;
      if dy<0 then dy:=-dy;
      if (dx>SysDragHoldX) or (dy>SysDragHoldY) then IsMovingStarted:=true;
     end;
   end
  else
  if Suspend1.Checked and not(Timer1.Enabled) then
    Timer1.Enabled:=true;
end;

const
  ButtonMarginLarge=16;
  ButtonMarginSmall=8;
  ButtonSpacing=2;


procedure TfrmMetaClick.FormShow(Sender: TObject);
begin
  frmCursorTag.Color:=Color;
  frmCursorTag.AlphaBlendValue:=i2ABV(FCursorTagABL);
  frmCursorTag.AlphaBlend:=FCursorTagABL>0;
  if FShowCursorTag then frmCursorTag.Show;
  ShowWindow(Application.Handle,SW_HIDE);
  if FStartSus then Suspend1Click(nil);
end;

procedure TfrmMetaClick.Timer1Timer(Sender: TObject);
var
  cp:TPoint;
  ct,cd,dx,dy,ax,ay,i:integer;
  inputs:array[0..3] of TInput;
  inputcount:integer;
  b:boolean;
  r:TRect;
  procedure SetM(idx:integer;dwFlags:DWORD);
  begin
    inputs[idx].Itype:=INPUT_MOUSE;
    inputs[idx].mi.dx:=cp.X;
    inputs[idx].mi.dy:=cp.Y;
    inputs[idx].mi.mouseData:=0;
    inputs[idx].mi.dwFlags:=dwFlags;
    inputs[idx].mi.time:=0;
    inputs[idx].mi.dwExtraInfo:=0;
    inputcount:=idx+1;//assert largest one last!
  end;
begin
  try
    cp:=Mouse.CursorPos;
    ct:=GetTickCount;

    if FShowCursorTag then
     begin
      dx:=cp.X+FCursorTagPosX;
      dy:=cp.Y+FCursorTagPosY;
      ax:=dx+FCursorTagWidth;
      ay:=dy+FCursorTagHeight;
      if FCursorTagKeepOnScreen then
       begin
        r:=Screen.DesktopRect;
        if dx<r.Left then
          dx:=cp.X-FCursorTagPosX-FCursorTagWidth;
        if dy<r.Top  then
          dy:=cp.Y-FCursorTagPosY-FCursorTagHeight;
        if ax>r.Right  then
          dx:=cp.X-FCursorTagPosX-FCursorTagWidth;
        if ay>r.Bottom then
          dy:=cp.Y-FCursorTagPosY-FCursorTagHeight;
       end;
      frmCursorTag.SetBounds(dx,dy,FCursorTagWidth,FCursorTagHeight);
     end;


    //if debug then panLeftSingle.Caption:=
    //  IntToStr(integer(Clicked))+IntToStr(integer(ClickMode));

    dx:=cp.X-LastPos.X;
    if dx<0 then dx:=-dx;
    dy:=cp.Y-LastPos.Y;
    if dy<0 then dy:=-dy;
    case Clicked of
      csFirstDone:
        b:=(dx>DragHold.X) or (dy>DragHold.Y);
      csIgnoredFirstMove:
       begin
        b:=(dx>DragHold.X) or (dy>DragHold.Y);
        inc(IgnoreAgainCounter);
        if IgnoreAgainCounter=100 then //const? setting?
          Clicked:=csAllDone;
       end;
      csAllDone:
       begin
        if (dx>SysDragHoldX) or (dy>SysDragHoldY) then
         begin
          Clicked:=csIgnoredFirstMove;
          LastPos:=cp;
          IgnoreAgainCounter:=0;
         end;
        b:=false;//don't reset timer
       end;
      csOrbit:
       begin
        if (OrbitConfig.Center.X-cp.X)*(OrbitConfig.Center.X-cp.X)+
           (OrbitConfig.Center.Y-cp.Y)*(OrbitConfig.Center.Y-cp.Y) >
           FOrbitSize*FOrbitSize div 8 then
         begin
          frmOrbit.DrawCross;
          Clicked:=csOrbitCross;
         end;
        b:=(dx>SysDragHoldX) or (dy>SysDragHoldY);
       end;
      csOrbitCross:
       begin
        i:=(OrbitConfig.Center.X-cp.X)*(OrbitConfig.Center.X-cp.X)+
           (OrbitConfig.Center.Y-cp.Y)*(OrbitConfig.Center.Y-cp.Y);
        if i>FOrbitSize*FOrbitSize then
         begin
          //leaving orbit: cancel
          frmOrbit.HideOrbit;
          Clicked:=csAllDone;
         end
        else if i<FOrbitSize*FOrbitSize div 8 then
         begin
          //back to center of orbit!
          LastTC:=ct-ClickMS-ClickMS;
         end
        else
          frmOrbit.CheckOrbit;
        b:=(dx>SysDragHoldX) or (dy>SysDragHoldY);//? see below
        //b:=false;
       end;
      else
        if (ClickMode=cmWheel) and (Clicked=csSecond) then
         begin
          b:=dy<>0;// or (dx<>0);
          if b then
           begin
            SetM(0,MOUSEEVENTF_WHEEL);
            inputs[0].mi.mouseData:=cardinal(WHEEL_DELTA
              *((WheelKeepY-cp.Y) div SysDragHoldY)+1);
            if CheckIgnores(false) then
              SendInput(inputcount,inputs[0],sizeof(TInput));
            Mouse.CursorPos:=Point(cp.X,WheelKeepY);
           end;
         end
        else
        if Suspend1.Checked and ((cp.X<Left) or (cp.Y<Top) or
          (cp.X>Left+Width) or (cp.Y>Top+Height)) then
         begin
          frmCursorTag.Hide;
          Clicked:=csAllDone;
          Timer1.Enabled:=false;
          b:=false;
         end
        else
          b:=(dx>SysDragHoldX) or (dy>SysDragHoldY);
            //use DragHold? other setting?
    end;
    if b then
     begin
      //moving, reset timer
      LastTC:=ct;
      case Clicked of
        csFirstDone:Clicked:=csSecond;
        csIgnoredFirstMove:Clicked:=csFirst;
      end;
      LastPos:=cp;
      if FShowCursorTag and not frmCursorTag.Visible then frmCursorTag.Show;
     end;
    cd:=cardinal(ct)-LastTC;
    CursorTagConfig.Second:=Clicked in [csFirstDone,csSecond,csOrbitCross];
    if CursorTagConfig.MSCount<>cd then
     begin
      CursorTagConfig.MSCount:=cd;
      DrawCountDown(cd);
     end;
    if (Clicked<>csAllDone) and (cd>=ClickMS) then
     begin
      if Clicked=csOrbitCross then
       begin
        frmOrbit.HideOrbit;
        FClickMode:=frmOrbit.CheckItem(cp);
        if ClickMode=cmOrbit then Clicked:=csAllDone else
         begin
          cp:=OrbitConfig.Center;
          Mouse.CursorPos:=cp;
         end;
       end;
      inputcount:=0;
      b:=false;
      case Clicked of
        csFirst,csOrbitCross:
         begin
          if ((GetKeyState(VK_LBUTTON) and $80)<>0) or
             ((GetKeyState(VK_RBUTTON) and $80)<>0) then
            Clicked:=csAllDone
          else
          if (cp.X>=Left+ButtonMarginLarge) and (cp.Y>=Top+ButtonMarginLarge) and
            (cp.X<=Left+Width-ButtonMarginLarge) and
            (cp.Y<=Top+Height-ButtonMarginLarge) then
           begin
            //Self.Perform?
            SetM(0,MOUSEEVENTF_LEFTDOWN);
            SetM(1,MOUSEEVENTF_LEFTUP);
            b:=true;
           end
          else
           begin
            case ClickMode of
              cmOrbit:
               begin
                if CheckIgnores(true) then
                 begin
                  OrbitConfig.Orbit:=FOrbit;
                  OrbitConfig.OrbitSize:=FOrbitSize;
                  OrbitConfig.CrossSize:=FOrbitCrossSize;
                  OrbitConfig.Color1:=BoolColor[true];
                  OrbitConfig.Color2:=BoolColor[false];
                  frmOrbit.Font.Assign(Font);
                  frmOrbit.AlphaBlendValue:=i2ABV(FAlphaLevel);
                  frmOrbit.AlphaBlend:=FAlphaLevel>0;
                  OrbitConfig.Center:=cp;
                  frmOrbit.ShowOrbit;
                 end
                else
                 begin
                  SetM(0,MOUSEEVENTF_LEFTDOWN);
                  SetM(1,MOUSEEVENTF_LEFTUP);
                  SendInput(inputcount,inputs[0],sizeof(TInput));
                  inputcount:=0;//skip below
                  FClickMode:=cmLeftSingle;
                 end;
               end;
              cmLeftSingle:
               begin
                SetM(0,MOUSEEVENTF_LEFTDOWN);
                SetM(1,MOUSEEVENTF_LEFTUP);
               end;
              cmLeftDouble:
               begin
                SetM(0,MOUSEEVENTF_LEFTDOWN);
                SetM(1,MOUSEEVENTF_LEFTUP);
                SetM(2,MOUSEEVENTF_LEFTDOWN);
                SetM(3,MOUSEEVENTF_LEFTUP);
               end;
              cmLeftDrag:
                SetM(0,MOUSEEVENTF_LEFTDOWN);
              cmRightSingle:
               begin
                SetM(0,MOUSEEVENTF_RIGHTDOWN);
                SetM(1,MOUSEEVENTF_RIGHTUP);
               end;
              cmRightDouble:
               begin
                SetM(0,MOUSEEVENTF_RIGHTDOWN);
                SetM(1,MOUSEEVENTF_RIGHTUP);
                SetM(2,MOUSEEVENTF_RIGHTDOWN);
                SetM(3,MOUSEEVENTF_RIGHTUP);
               end;
              cmRightDrag:
                SetM(0,MOUSEEVENTF_RIGHTDOWN);
              cmWheel:
               begin
                //start with a click to focus
                SetM(0,MOUSEEVENTF_LEFTDOWN);
                SetM(1,MOUSEEVENTF_LEFTUP);
                WheelKeepY:=LastPos.Y;
               end;
            end;
            if FSoundPlayFile<>'' then
              sndPlaySound(PAnsiChar(FSoundPlayFile),SND_ASYNC);
            if ClickMode in [cmLeftDrag,cmRightDrag,cmWheel] then
              Clicked:=csFirstDone
            else if ClickMode=cmOrbit then
              Clicked:=csOrbit
            else
              b:=true;//done
           end;
         end;
        csSecond:
         begin
          case ClickMode of
            cmLeftDrag:
              SetM(0,MOUSEEVENTF_LEFTUP);
            cmRightDrag:
              SetM(0,MOUSEEVENTF_RIGHTUP);
          end;
          if FSoundPlayFile<>'' then
            sndPlaySound(PAnsiChar(FSoundPlayFile),SND_ASYNC);
          b:=true;//done
         end;
        //csOrbitCross moved above
      end;
      //done?
      if b then
       begin
        Clicked:=csAllDone;
        case FReturnTo of
          1:ClickMode:=cmLeftSingle;
          2:ClickMode:=cmOrbit;
          3:ClickMode:=cmRightSingle;
        end;
        if Suspend1.Checked then Timer1.Enabled:=false;
       end;
      //send input
      if (inputcount<>0) and CheckIgnores(false) then
        SendInput(inputcount,inputs[0],sizeof(TInput));
     end;
    if (Clicked=csOrbit) and (cd>=HideMS) then
     begin
      frmOrbit.HideOrbit;
      Clicked:=csAllDone;
     end;
    if FShowCursorTag and (Clicked=csAllDone) and (cd>=HideMS)
      and frmCursorTag.Visible then frmCursorTag.Hide;
  except
    //silent? log?
  end;
end;

procedure TfrmMetaClick.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;
end;

procedure TfrmMetaClick.panLeftSingleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmLeftSingle;
end;

procedure TfrmMetaClick.panOptionsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then Settings1Click(nil);
end;

procedure TfrmMetaClick.Settings1Click(Sender: TObject);
var
  ablCT:integer;
begin
  if frmSettings=nil then frmSettings:=TfrmSettings.Create(nil);
  if frmCursorTag=nil then
    ablCT:=ABV2i(AlphaBlendValue)
  else
    ablCT:=ABV2i(frmCursorTag.AlphaBlendValue);
  frmSettings.ShowSettings(
    ClickMS,
    HideMS,
    FAlphaLevel,
    ablCT,
    panLeftSingle.Visible,
    panLeftDouble.Visible,
    panLeftDrag.Visible,
    panRightSingle.Visible,
    panRightDouble.Visible,
    panRightDrag.Visible,
    panWheel.Visible,
    panCountDown.Visible,
    panSuspend.Visible,
    panOptions.Visible,
    panClose.Visible,
    FShowOnMouseOver,
    FReturnTo,
    FShowCursorTag,
    FCursorTagKeepOnScreen,
    FStartSus,
    FOrbit,FOrbitSize,FOrbitCrossSize,
    OrbitConfig.MarginX,OrbitConfig.MarginY,OrbitConfig.OrbitShape,
    FCursorTagPosX,FCursorTagPosY,FCursorTagWidth,FCursorTagHeight,
    BoolColor[false],
    BoolColor[true],
    Font,
    DragHold,
    FSoundPlayFile,
    FIgnores);
end;

procedure TfrmMetaClick.panCloseMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  b:boolean;
begin
  b:=VerifClose;
  if IsClicked then if b then Close else VerifClose:=true;
end;

procedure TfrmMetaClick.panLeftDoubleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmLeftDouble;
end;

procedure TfrmMetaClick.panLeftDragMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmLeftDrag;
end;

procedure TfrmMetaClick.panRightSingleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmRightSingle;
end;

procedure TfrmMetaClick.panRightDoubleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmRightDouble;
end;

procedure TfrmMetaClick.panRightDragMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmRightDrag;
end;

procedure TfrmMetaClick.panWheelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then ClickMode:=cmWheel;
end;

procedure TfrmMetaClick.SetClickMode(const Value: TClickMode);
const
  BoolBevel:array[boolean] of TBevelCut=(bvRaised,bvLowered);
  procedure DoPanel(p:TPanel;mi:TMenuItem;cm:TClickMode);
  var
    b:boolean;
  begin
    b:=FClickMode=cm;
    if (p.BevelOuter<>BoolBevel[b]) and (Corners<>0) then
     begin
      SetWindowRgn(Handle,0,false);
      DeleteObject(Corners);
      Corners:=0;
     end;
    p.BevelOuter:=BoolBevel[b];
    p.Color:=BoolColor[b];
    mi.Checked:=b;
    p.Repaint;
  end;
begin
  FClickMode:=Value;
  DoPanel(panLeftSingle,LeftSingle1,cmLeftSingle);
  DoPanel(panLeftDouble,LeftDouble1,cmLeftDouble);
  DoPanel(panLeftDrag,LeftDrag1,cmLeftDrag);
  DoPanel(panRightSingle,RightSingle1,cmRightSingle);
  DoPanel(panRightDouble,RightDouble1,cmRightDouble);
  DoPanel(panRightDrag,RightDrag1,cmRightDrag);
  DoPanel(panWheel,Wheel1,cmWheel);
end;

procedure TfrmMetaClick.SetVerifClose(const Value: boolean);
begin
  FVerifClose := Value;
  if FVerifClose then
    panClose.Caption:='x?'
  else
    panClose.Caption:='x';
end;

procedure TfrmMetaClick.UpdateSettings(SetClickMS, HideAfterMS, Buttons, Orbit,
  OrbitSize, OrbitCrossSize, OrbitMarginX, OrbitMarginY, OrbitShape, ReturnTo,
  CursorTagPosX,CursorTagPosY,CursorTagWidth,CursorTagHeight,
  AlphaBlendLevel1, AlphaBlendLevelCT, ShowOnMouseOver: integer;
  ShowCursorTag, CursorTagKeepOnScreen: boolean;
  ColorBG1, ColorBG2: TColor; Font1: TFont;
  SetDragHold: TPoint; SoundFilePath: string; Ignores: TStrings);
var
  cm:TClickMode;
begin
  if Corners<>0 then
   begin
    SetWindowRgn(Handle,0,false);
    DeleteObject(Corners);
    Corners:=0;
   end;
  Color:=ColorBG1;
  BoolColor[false]:=ColorBG1;
  BoolColor[true]:=ColorBG2;
  Font:=Font1;
  DragHold:=SetDragHold;
  ClickMS:=SetClickMS;
  HideMS:=HideAfterMS;
  FReturnTo:=ReturnTo;
  if ReturnTo<>0 then
   begin
    case ReturnTo of
      1:cm:=cmLeftSingle;
      2:cm:=cmOrbit;
      3:cm:=cmRightSingle;
      else cm:=cmLeftSingle;//default;
    end;
    ClickMode:=cm;//update display
   end;
  //LastTC:=GetTickCount;
  Clicked:=csFirst;
  FAlphaLevel:=AlphaBlendLevel1;
  AlphaBlendValue:=i2ABV(FAlphaLevel);
  AlphaBlend:=FAlphaLevel>0;
  FCursorTagABL:=AlphaBlendLevelCT;
  CursorTagConfig.MSTotal:=ClickMS;
  CursorTagConfig.ColorFG1:=Font.Color;
  CursorTagConfig.ColorFG2:=ColorBG2;
  if frmCursorTag<>nil then //see also FormShow
   begin
    frmCursorTag.Color:=ColorBG1;
    if ShowCursorTag and not(Suspend1.Checked) then
      frmCursorTag.Show else frmCursorTag.Hide;
    frmCursorTag.AlphaBlendValue:=i2ABV(FCursorTagABL);
    frmCursorTag.AlphaBlend:=FCursorTagABL>0;
   end;
  FShowOnMouseOver:=ShowOnMouseOver;
  tiMouseOver.Enabled:=ShowOnMouseOver>0;
  IsMOver:=not(IsMOver);
  FCursorTagPosX:=CursorTagPosX;
  FCursorTagPosY:=CursorTagPosY;
  FCursorTagWidth:=CursorTagWidth;
  FCursorTagHeight:=CursorTagHeight;
  FCursorTagKeepOnScreen:=CursorTagKeepOnScreen;
  panLeftSingle.Visible:=(Buttons and $001)<>0;
  panLeftDouble.Visible:=(Buttons and $002)<>0;
  panLeftDrag.Visible:=(Buttons and $004)<>0;
  panRightSingle.Visible:=(Buttons and $008)<>0;
  panRightDouble.Visible:=(Buttons and $010)<>0;
  panRightDrag.Visible:=(Buttons and $020)<>0;
  panWheel.Visible:=(Buttons and $040)<>0;
  panSuspend.Visible:=(Buttons and $080)<>0;
  panOptions.Visible:=(Buttons and $100)<>0;
  panClose.Visible:=(Buttons and $200)<>0;
  panCountDown.Visible:=(Buttons and $400)<>0;
  FOrbit:=Orbit;
  FOrbitSize:=OrbitSize;
  FOrbitCrossSize:=OrbitCrossSize;
  OrbitConfig.MarginX:=OrbitMarginX;
  OrbitConfig.MarginY:=OrbitMarginY;
  OrbitConfig.OrbitShape:=OrbitShape;
  FSoundPlayFile:=SoundFilePath;
  FShowCursorTag:=ShowCursorTag;
  FIgnores.Assign(Ignores);
  ArrangeButtons;
end;

procedure TfrmMetaClick.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMetaClick.PopupMenu1Popup(Sender: TObject);
begin
  IsPopUp:=true;
end;

procedure TfrmMetaClick.Suspend1Click(Sender: TObject);
begin
  if Suspend1.Checked then
   begin
    Suspend1.Checked:=false;
    panSuspend.Caption:='z';
    //frmCursorTag.Show;
    Timer1.Enabled:=true;
    LastTC:=GetTickCount;
   end
  else
   begin
    //Timer1.Enabled:=false;
    frmCursorTag.Hide;
    Suspend1.Checked:=true;
    panSuspend.Caption:='z!';
   end;
end;

procedure TfrmMetaClick.imgResizeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsMovingStarted:=false;
  IsResizing:=Button=mbLeft;
  StartPos.X:=Width;
  StartPos.Y:=Height;
  StartDrag:=Mouse.CursorPos;
  IsPopUp:=false;
end;

procedure TfrmMetaClick.imgResizeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsClicked;
end;

procedure TfrmMetaClick.imgResizeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  dx,dy:integer;
  p:TPoint;
begin
  if IsResizing then
   begin
    p:=Mouse.CursorPos;
    if IsMovingStarted then
     begin
      SetBounds(
        Left,Top,
        StartPos.X-StartDrag.X+p.X,
        StartPos.Y-StartDrag.Y+p.Y);
     end
    else
     begin
      dx:=p.X-StartDrag.X;
      if dx<0 then dx:=-dx;
      dy:=p.Y-StartDrag.Y;
      if dy<0 then dy:=-dy;
      if (dx>SysDragHoldX) or (dy>SysDragHoldY) then
        IsMovingStarted:=true;
     end;
   end;
end;

procedure TfrmMetaClick.panSuspendMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsClicked then Suspend1Click(Sender);
end;

procedure TfrmMetaClick.LeftSingle1Click(Sender: TObject);
begin
  ClickMode:=cmLeftSingle;
end;

procedure TfrmMetaClick.LeftDouble1Click(Sender: TObject);
begin
  ClickMode:=cmLeftDouble;
end;

procedure TfrmMetaClick.LeftDrag1Click(Sender: TObject);
begin
  ClickMode:=cmLeftDrag;
end;

procedure TfrmMetaClick.RightSingle1Click(Sender: TObject);
begin
  ClickMode:=cmRightSingle;
end;

procedure TfrmMetaClick.RightDouble1Click(Sender: TObject);
begin
  ClickMode:=cmRightDouble;
end;

procedure TfrmMetaClick.RightDrag1Click(Sender: TObject);
begin
  ClickMode:=cmRightDrag;
end;

procedure TfrmMetaClick.Wheel1Click(Sender: TObject);
begin
  ClickMode:=cmWheel;
end;

procedure TfrmMetaClick.FormResize(Sender: TObject);
begin
  if Visible then ArrangeButtons;
end;

procedure TfrmMetaClick.ArrangeButtons;
var
  panels:array[0..10] of TPanel;
  sx,sy,tx,ty,p,p1,i:integer;
  procedure setp(pp:TPanel);
  begin
    if pp.Visible then
     begin
      panels[p]:=pp;
      inc(p);
     end;
  end;
begin
  p:=0;
  setp(panLeftSingle);
  setp(panRightSingle);
  setp(panLeftDouble);
  setp(panRightDouble);
  setp(panLeftDrag);
  setp(panRightDrag);
  setp(panWheel);
  setp(panCountDown);
  setp(panSuspend);
  setp(panOptions);
  setp(panClose);
  if p<>0 then
   begin
    p1:=(p div 2)+(p mod 2);
    if p1=0 then p1:=1;//?
    sx:=Width;
    sy:=Height;
    if sx>=sy then
     begin
      dec(sx,ButtonMarginLarge);
      dec(sy,ButtonMarginSmall);
      tx:=sx-ButtonMarginLarge;
      ty:=sy-ButtonMarginSmall;
      sx:=tx+ButtonSpacing;
      sy:=ty+ButtonSpacing;
      if tx>=ty*p1 then
       begin
        //single line horizontal
        bx:=(tx-ButtonSpacing*(p-1)) div p;
        by:=ty;
        for i:=0 to p-1 do
          panels[i].SetBounds(
            ButtonMarginLarge+(sx*i div p),
            ButtonMarginSmall,
            bx,by);
       end
      else
       begin
        //two lines horizontal
        bx:=(tx-ButtonSpacing*(p1-1)) div p1;
        by:=(ty-ButtonSpacing) div 2;
        for i:=0 to p-1 do
          panels[i].SetBounds(
            ButtonMarginLarge+(sx*(i div 2) div p1),
            ButtonMarginSmall+(sy*(i mod 2) div 2),
            bx,by);
       end;
     end
    else
     begin
      dec(sx,ButtonMarginSmall);
      dec(sy,ButtonMarginLarge);
      tx:=sx-ButtonMarginSmall;
      ty:=sy-ButtonMarginLarge;
      sx:=tx+ButtonSpacing;
      sy:=ty+ButtonSpacing;
      if tx*p1>=ty then
       begin
        //two columns vertical
        bx:=(tx-ButtonSpacing) div 2;
        by:=(ty-ButtonSpacing*(p1-1)) div p1;
        for i:=0 to p-1 do
          panels[i].SetBounds(
            ButtonMarginSmall+(sx*(i mod 2) div 2),
            ButtonMarginLarge+(sy*(i div 2) div p1),
            bx,by);
       end
      else
       begin
        //single line vertical
        bx:=tx;
        by:=(ty-ButtonSpacing*(p-1)) div p;
        for i:=0 to p-1 do
          panels[i].SetBounds(
            ButtonMarginSmall,
            ButtonMarginLarge+(sy*i div p),
            bx,by);
       end;
     end;
   end;
  DrawCountDown(GetTickCount-LastTC);
end;

procedure TfrmMetaClick.DrawCountDown(cd:integer);
var
  x,y1,y2:integer;
  b:boolean;
const
  CountDownMargin=4;
  CountDownMargin2=CountDownMargin+CountDownMargin;
begin
  if frmCursorTag<>nil then
   begin
    if FShowCursorTag then frmCursorTag.Invalidate;
    if panCountDown.Visible then
     begin
      x:=panCountDown.ClientWidth-CountDownMargin2;
      y1:=panCountDown.ClientHeight-CountDownMargin2;
      if cd>=ClickMS then
       begin
        panCountDown1.Color:=BoolColor[true];
        panCountDown1.SetBounds(CountDownMargin,CountDownMargin,x,y1);
       end
      else
       begin
        panCountDown1.Color:=Font.Color;
        y2:=y1-(y1*cd div ClickMS);
        b:=CursorTagConfig.Second;
        panCountDown2.Visible:=b;
        if b then
         begin
          panCountDown2.Color:=BoolColor[true];
          panCountDown2.SetBounds(CountDownMargin,CountDownMargin,x,y2);
          inc(y2,CountDownMargin);
          panCountDown1.SetBounds(CountDownMargin,CountDownMargin+y2,x,y1-y2);
         end
        else
          panCountDown1.SetBounds(CountDownMargin,CountDownMargin+y2,x,y1-y2);
       end;
     end;
   end;
end;

procedure TfrmMetaClick.FormDestroy(Sender: TObject);
begin
  FIgnores.Free;
end;

function TfrmMetaClick.CheckIgnores(SkipOrbit:boolean):boolean;
var
  i,j,l:integer;
  c1,t1,p1:boolean;
  c,t,p,f,s:string;
  h,h1:THandle;
  pid:cardinal;
begin
  Result:=true;//default
  if FIgnores.Count<>0 then
   begin
    //h:=GetForegroundWindow;
    h:=GetAncestor(WindowFromPoint(Mouse.CursorPos),GA_ROOT);
    c1:=true;
    t1:=true;
    p1:=true;
    i:=0;
    while Result and (i<FIgnores.Count) do
     begin
      s:=FIgnores[i];
      l:=Length(s);
      j:=1;
      while (j<=l) and (s[j]<>':') do inc(j);
      inc(j);
      case s[1] of
        'C'://class
         begin
          if c1 then
           begin
            SetLength(c,$400);
            SetLength(c,GetClassName(h,PChar(c),$400));
            c1:=false;
           end;
          if (c<>'') and (Copy(s,j,l-j+1)=c) then Result:=false;
         end;
        'T'://text
         begin
          if t1 then
           begin
            SetLength(t,$400);
            SetLength(t,GetWindowText(h,PChar(t),$400));
            t1:=false;
           end;
          if (t<>'') and (Copy(s,j,l-j+1)=t) then Result:=false;
         end;
        'P','F'://path,file
         begin
          if p1 then
           begin
            SetLength(p,$400);
            if @GetModuleFileNameEx=nil then
              SetLength(p,GetWindowModuleFileName(h,PChar(p),$400))
            else
             begin
              GetWindowThreadProcessId(h,pid);
              h1:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
                false,pid);
              SetLength(p,GetModuleFileNameEx(h1,0,PChar(p),$400));
              CloseHandle(h1);
             end;
            p1:=false;
           end;
          if s[1]='F' then f:=ExtractFileName(p) else f:=p;
          if (f<>'') and (Copy(s,j,l-j+1)=f) then Result:=false;
         end;
      end;
      if SkipOrbit and not(Result) and (s[j-2]<>'°') then Result:=true;
      inc(i);
     end;
   end;
end;

procedure TfrmMetaClick.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  StoreBounds;
  CanClose:=true;
end;

procedure TfrmMetaClick.tiMouseOverTimer(Sender: TObject);
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
            if (bx=0) or (by=0) then
             begin
              sx:=Width div 3;
              sy:=Height div 3;
              if sx>sy then sy:=sx else sx:=sy;
             end
            else
             begin
              sx:=bx div 2;//See ArrangeButtons
              sy:=by div 2;
             end;
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
          if b<>IsMOver then
           begin
            sx:=i2ABV(FAlphaLevel);
            if not b then sx:=(sx+1) div 2;
            AlphaBlendValue:=sx;
            AlphaBlend:=sx<255;
           end;
         end;
       end;
       IsMOver:=b;
     end;
  except
    //show?log?
  end;
end;

initialization
  GetModuleFileNameEx:=GetProcAddress(LoadLibrary('psapi.dll'),
    'GetModuleFileNameExA');

end.
