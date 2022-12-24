library eszc;

uses
  Windows;

var
  hookinfo:record
    wnd,hook1,hook2:cardinal;
  end;
  xp:integer;
  tc:cardinal;

const
  WM_ESZETT = $0403;

procedure eszcLoad; stdcall;
var
  rr:HKey;
  dt,ds:integer;
begin
  xp:=0;
  tc:=0;

  //default
  hookinfo.wnd:=0;
  hookinfo.hook1:=0;
  hookinfo.hook2:=0;
  rr:=0;
  if RegOpenKeyEx(HKEY_CURRENT_USER,'Software\Double Sigma Programming\eszett',0,KEY_READ,rr)=0 then
   begin
    dt:=REG_NONE;
    ds:=4*3;
    if RegQueryValueEx(rr,'HookInfo',nil,@dt,@hookinfo,@ds)<>0 then
     begin
      hookinfo.wnd:=0;
      hookinfo.hook1:=0;
      hookinfo.hook2:=0;
     end;
   end;
end;

procedure XSendEszett;
var
  x:array[0..1] of tagINPUT;
begin
  xp:=1;

  x[0].Itype:=INPUT_KEYBOARD;
  x[0].ki.wVk:=0;
  x[0].ki.wScan:=$DF;
  x[0].ki.dwFlags:=KEYEVENTF_UNICODE;
  x[0].ki.time:=0;
  x[0].ki.dwExtraInfo:=0;

  x[1].Itype:=INPUT_KEYBOARD;
  x[1].ki.wVk:=0;
  x[1].ki.wScan:=$DF;
  x[1].ki.dwFlags:=KEYEVENTF_UNICODE or KEYEVENTF_KEYUP;
  x[1].ki.time:=0;
  x[1].ki.dwExtraInfo:=0;

  SendInput(2,x[0],sizeof(tagInput));
  tc:=GetTickCount;
  xp:=0;
end;

{
procedure XSendEszett;
var
  x:array[0..13] of tagINPUT;
begin
  xp:=1;

  //release Ctrl
  x[0].Itype:=INPUT_KEYBOARD;
  x[0].ki.wVk:=VK_CONTROL;
  x[0].ki.wScan:=MapVirtualKey(VK_CONTROL,0);
  x[0].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[0].ki.time:=0;
  x[0].ki.dwExtraInfo:=0;

  //release Alt
  x[1].Itype:=INPUT_KEYBOARD;
  x[1].ki.wVk:=VK_MENU;
  x[1].ki.wScan:=MapVirtualKey(VK_MENU,0);
  x[1].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[1].ki.time:=0;
  x[1].ki.dwExtraInfo:=0;

  //
  x[2].Itype:=INPUT_KEYBOARD;
  x[2].ki.wVk:=VK_MENU;
  x[2].ki.wScan:=MapVirtualKey(VK_MENU,0);
  x[2].ki.dwFlags:=0;
  x[2].ki.time:=0;
  x[2].ki.dwExtraInfo:=0;

  x[3].Itype:=INPUT_KEYBOARD;
  x[3].ki.wVk:=$60;
  x[3].ki.wScan:=MapVirtualKey($60,0);
  x[3].ki.dwFlags:=0;
  x[3].ki.time:=0;
  x[3].ki.dwExtraInfo:=0;

  x[4].Itype:=INPUT_KEYBOARD;
  x[4].ki.wVk:=$60;
  x[4].ki.wScan:=MapVirtualKey($60,0);
  x[4].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[4].ki.time:=0;
  x[4].ki.dwExtraInfo:=0;

  x[5].Itype:=INPUT_KEYBOARD;
  x[5].ki.wVk:=$62;
  x[5].ki.wScan:=MapVirtualKey($62,0);
  x[5].ki.dwFlags:=0;
  x[5].ki.time:=0;
  x[5].ki.dwExtraInfo:=0;

  x[6].Itype:=INPUT_KEYBOARD;
  x[6].ki.wVk:=$62;
  x[6].ki.wScan:=MapVirtualKey($62,0);
  x[6].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[6].ki.time:=0;
  x[6].ki.dwExtraInfo:=0;

  x[7].Itype:=INPUT_KEYBOARD;
  x[7].ki.wVk:=$62;
  x[7].ki.wScan:=MapVirtualKey($62,0);
  x[7].ki.dwFlags:=0;
  x[7].ki.time:=0;
  x[7].ki.dwExtraInfo:=0;

  x[8].Itype:=INPUT_KEYBOARD;
  x[8].ki.wVk:=$62;
  x[8].ki.wScan:=MapVirtualKey($62,0);
  x[8].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[8].ki.time:=0;
  x[8].ki.dwExtraInfo:=0;

  x[9].Itype:=INPUT_KEYBOARD;
  x[9].ki.wVk:=$63;
  x[9].ki.wScan:=MapVirtualKey($63,0);
  x[9].ki.dwFlags:=0;
  x[9].ki.time:=0;
  x[9].ki.dwExtraInfo:=0;

  x[10].Itype:=INPUT_KEYBOARD;
  x[10].ki.wVk:=$63;
  x[10].ki.wScan:=MapVirtualKey($63,0);
  x[10].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[10].ki.time:=0;
  x[10].ki.dwExtraInfo:=0;

  x[11].Itype:=INPUT_KEYBOARD;
  x[11].ki.wVk:=VK_MENU;
  x[11].ki.wScan:=MapVirtualKey(VK_MENU,0);
  x[11].ki.dwFlags:=KEYEVENTF_KEYUP;
  x[11].ki.time:=0;
  x[11].ki.dwExtraInfo:=0;

  //restore Ctrl
  x[12].Itype:=INPUT_KEYBOARD;
  x[12].ki.wVk:=VK_CONTROL;
  x[12].ki.wScan:=MapVirtualKey(VK_CONTROL,0);
  x[12].ki.dwFlags:=0;
  x[12].ki.time:=0;
  x[12].ki.dwExtraInfo:=0;

  //restore Alt
  x[13].Itype:=INPUT_KEYBOARD;
  x[13].ki.wVk:=VK_MENU;
  x[13].ki.wScan:=MapVirtualKey(VK_MENU,0);
  x[13].ki.dwFlags:=0;
  x[13].ki.time:=0;
  x[13].ki.dwExtraInfo:=0;

  SendInput(12,x[0],sizeof(tagInput)); //14 locks CTRL!!!

  xp:=0;
end;
}


function eszcKeybCB(code,wparam,lparam:integer):HRESULT; stdcall;
begin
  if (wparam=$53) //'S'
    and (xp=0)
    and (cardinal(GetTickCount-tc)>25)
    and ((lparam and $80000000)=0)
    and ((GetKeyState(VK_CONTROL) and $80000000)<>0) //Ctrl
    and ((GetKeyState(VK_MENU) and $80000000)<>0) //Alt
    then
      XSendEszett;
  Result:=CallNextHookEx(hookinfo.hook1,code,wparam,lparam);
end;

exports
  eszcLoad,
  eszcKeybCB;

begin
  eszcLoad;
end.
