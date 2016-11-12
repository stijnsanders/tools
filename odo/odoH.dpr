library odoH;

uses
  Windows,
  Registry,
  Messages;

const
  WM_ODOHIT = WM_USER + 3;

var
  hookinfo:record
    wnd,hook1,hook2:cardinal;
  end;

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
