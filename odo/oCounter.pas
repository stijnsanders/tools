unit oCounter;

interface

uses
  Windows, Classes;

const
  MinutesADay=1440;//24*60

type
  TKeyCounter = class(TThread)
  private
    { Private declarations }
    LastWND:HWND;
    LastMouse:TPoint;
    LastMinute:integer;
    procedure SendKeyStroke(const A:char);
  protected
    procedure Execute; override;
    procedure DoMinute;
  public
    Data:TCountData²;
    Fix102:boolean;
    OnMinute:procedure of object;
    property Minute:integer read LastMinute;
    constructor Create(CreateSuspended: Boolean);
  end;

implementation

uses SysUtils;

{ TKeyCounter }

//http://msdn.microsoft.com/library/en-us/winui/WinUI/WindowsUserInterface/UserInput/VirtualKeyCodes.asp

constructor TKeyCounter.Create(CreateSuspended: Boolean);
begin
  inherited;
  Fix102:=false;
  Data.KeyCount:=0;
  Data.SwitchCount:=0;
  Data.AppCount:=0;
  Data.ClickCount:=0;
  Data.MouseXCount:=0;
  Data.MouseYCount:=0;
  GetCursorPos(LastMouse);
  LastWND:=GetForegroundWindow;
  LastMinute:=Trunc(Frac(Now)*MinutesADay);
end;

const
  MouseCodes=[1..6];
  KeyCodes=[VK_BACK,VK_TAB,VK_CLEAR,VK_RETURN,$15..$8F];
  ControlCodes=[VK_LSHIFT,VK_RSHIFT,VK_LCONTROL,VK_RCONTROL];
  pidGrowSize=32;

procedure TKeyCounter.Execute;
var
  i:integer;
  p:TPoint;
  h:HWND;
  pid:cardinal;
  pidx,pidl:integer;
  pids:array of integer;
  //fix102 vars
  downLS,fixLS,sx:boolean;
begin
  downLS:=false;
  fixLS:=false;
  sx:=false;
  pidx:=0;
  pidl:=pidGrowSize;
  SetLength(pids,pidl);

  while not(Terminated) do
   begin
    i:=0;
    //while (i<$90) and not(Terminated) do
    while (i<VK_OEM_CLEAR) and not(Terminated) do
     begin
      if (GetAsyncKeyState(i) and 1)=1 then
       begin
        if i in MouseCodes then inc(Data.ClickCount);
        if i in KeyCodes then inc(Data.KeyCount);
        if not(i in ControlCodes) then sx:=true;
       end;
      inc(i);
     end;

    //fix for missing 102nd key on qwerty used as azerty
    if fix102 then
     begin
      if downLS then
       begin
        //if other key pressed or clicked, don't fix
        if fixLS and sx then fixLS:=false;

        if (GetAsyncKeyState(VK_LSHIFT)=0) then //or repeat?
         begin
          //LShift released
          if fixLS then
           begin
            if not(GetAsyncKeyState(VK_RSHIFT)=0) then
              SendKeyStroke('>')
            else if not(GetAsyncKeyState(VK_RCONTROL)=0) then
              SendKeyStroke('\')
            else
              SendKeyStroke('<');
           end;
          //reset states
          downLS:=false;
          fixLS:=false;
         end;

       end
      else
       begin
        //LS not down, is it down now?
        if not(GetAsyncKeyState(VK_LSHIFT)=0) then
         begin
          downLS:=true;
          fixLS:=sx;
          sx:=false;
         end;
       end;
     end;
    //fix102 done

    GetCursorPos(p);
    i:=p.X-LastMouse.X;
    if i<0 then i:=-i;
    inc(Data.MouseXCount,i);
    i:=p.Y-LastMouse.Y;
    if i<0 then i:=-i;
    inc(Data.MouseYCount,i);
    LastMouse:=p;

    h:=GetForegroundWindow;
    if not(h=LastWND) then
     begin
      inc(Data.SwitchCount);
      GetWindowThreadProcessId(h,pid);
      i:=0;
      while (i<pidx) and (pids[i]<>integer(pid)) do inc(i);
      if i=pidx then
       begin
        inc(pidx);
        if pidx=pidl then
         begin
          inc(pidl,pidGrowSize);
          SetLength(pids,pidl);
         end;
        pids[i]:=pid;
        //Data.AppCount: see DoMinute call
       end;
     end;
    LastWND:=h;

    i:=Trunc(Frac(Now)*MinutesADay);
    if not(LastMinute=i) then
     begin
      LastMinute:=i;
      Data.AppCount:=pidx;
      pidx:=0;
      Synchronize(DoMinute);
     end;

    Sleep(2);
   end;
end;

procedure TKeyCounter.DoMinute;
begin
  if Assigned(OnMinute) then OnMinute;
  Data.KeyCount:=0;
  Data.SwitchCount:=0;
  Data.AppCount:=0;
  Data.ClickCount:=0;
  Data.MouseXCount:=0;
  Data.MouseYCount:=0;
end;

procedure TKeyCounter.SendKeyStroke(const A: char);
var
  x:array[0..1] of tagINPUT;
begin 
  x[0].Itype:=INPUT_KEYBOARD;
  x[0].ki.wVk:=VkKeyScan(a);
  x[0].ki.wScan:=MapVirtualKey(x[0].ki.wVk,0);
  x[0].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[0].ki.time:=0;
  x[0].ki.dwExtraInfo:=0;
  x[1].Itype:=INPUT_KEYBOARD;
  x[1].ki.wVk:=x[0].ki.wVk;
  x[1].ki.wScan:=x[0].ki.wScan;
  x[1].ki.dwFlags:=0;
  x[1].ki.time:=0;
  x[1].ki.dwExtraInfo:=0;

  SendInput(2,x[0],sizeof(tagInput));
  //assert result returned = 2
end;

end.
