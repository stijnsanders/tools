library odoHfix102;

uses
  Windows,
  Registry,SysUtils,
  Messages;

const
  WM_ODOHIT = WM_USER + 3;

var
  hookinfo:record
    wnd,hook1,hook2:cardinal;
  end;
  //fix102 vars
  fixLS:boolean;

procedure odoLoadSettings;
var
  r:TRegistry;
begin
  r:=TRegistry.Create;
  try
    if r.OpenKeyReadOnly('\Software\Double Sigma Programming\odo') then
      r.ReadBinaryData('HookInfo',hookinfo,4*3);
  finally
    r.Free;
  end;
  fixLS:=false;
end;

procedure SendKeyStroke(const A: char);
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

function odoKeybCallback(code,wparam,lparam:integer):HRESULT; stdcall;
begin
  if code>=0 then
   begin
    if (lparam and $C0000000)=0 then PostMessage(hookinfo.wnd,WM_ODOHIT,0,wparam);

    //fix for missing 102nd key on qwerty used as azerty
    if GetAsyncKeyState(VK_LSHIFT)<>0 then
     begin
      if ((lparam and $C0000000)=$00000000) then fixLS:=true;
      if ((lparam and $C0000000)=$C0000000) and fixLS then
        if GetAsyncKeyState(VK_RSHIFT)<>0 then
          SendKeyStroke('>')
        else if GetAsyncKeyState(VK_RCONTROL)<>0 then
          SendKeyStroke('\')
        else
          SendKeyStroke('<');
     end
    else
      fixLS:=false;

   end;
  Result:=CallNextHookEx(hookinfo.hook1,code,wparam,lparam);
end;

function odoMouseCallback(code,wparam,lparam:integer):HRESULT; stdcall;
begin
  if code=0 then
    if (
      (wparam=WM_NCLBUTTONDOWN) or
      (wparam=WM_NCRBUTTONDOWN) or
      (wparam=WM_NCMBUTTONDOWN) or
      (wparam=WM_LBUTTONDOWN) or
      (wparam=WM_RBUTTONDOWN) or
      (wparam=WM_MBUTTONDOWN)) then
     begin
      PostMessage(hookinfo.wnd,WM_ODOHIT,1,
        (PMouseHookStruct(lparam).pt.X and $FFFF) or
        ((PMouseHookStruct(lparam).pt.Y and $FFFF) shl 16)
      );
     end
    else if (
      (wparam=WM_NCMOUSEMOVE) or
      (wparam=WM_MOUSEMOVE)) then
      PostMessage(hookinfo.wnd,WM_ODOHIT,2,
        (PMouseHookStruct(lparam).pt.X and $FFFF) or
        ((PMouseHookStruct(lparam).pt.Y and $FFFF) shl 16)
      );
  Result:=CallNextHookEx(hookinfo.hook2,code,wparam,lparam);
end;

exports
  odoLoadSettings,
  odoKeybCallback,
  odoMouseCallback;

begin
  odoLoadSettings;
end.
