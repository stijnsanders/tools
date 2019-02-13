library odoH;

uses
  Windows,
  Messages;

const
  WM_ODOHIT = WM_USER + 3;

var
  hookinfo:record
    wnd,hook1,hook2:cardinal;
  end;

procedure odoLoadSettings;
var
  rr:HKey;
  dt,ds:integer;
begin
  //default
  hookinfo.wnd:=0;
  hookinfo.hook1:=0;
  hookinfo.hook2:=0;
  rr:=0;
  if RegOpenKeyEx(HKEY_CURRENT_USER,'Software\Double Sigma Programming\odo',0,KEY_READ,rr)=0 then
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

function odoKeybCallback(code,wparam,lparam:integer):HRESULT; stdcall;
begin
  if (code>=0) and ((lparam and $C0000000)=0) then PostMessage(hookinfo.wnd,WM_ODOHIT,1,wparam);
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
      PostMessage(hookinfo.wnd,WM_ODOHIT,2,
        (PMouseHookStruct(lparam)^.pt.X and $FFFF) or
        ((PMouseHookStruct(lparam)^.pt.Y and $FFFF) shl 16)
      );
     end
    else if (
      (wparam=WM_NCMOUSEMOVE) or
      (wparam=WM_MOUSEMOVE)) then
      PostMessage(hookinfo.wnd,WM_ODOHIT,3,
        (PMouseHookStruct(lparam)^.pt.X and $FFFF) or
        ((PMouseHookStruct(lparam)^.pt.Y and $FFFF) shl 16)
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
