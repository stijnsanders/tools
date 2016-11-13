unit ddParams;

interface

uses Forms;

procedure GetStoredDims(f:TForm);
procedure SetStoredDims(f:TForm);
function IsXML(FilePath1,FilePath2:string):boolean;

implementation

uses Windows, SysUtils, Registry;

const
  AppRegKey='\Software\Double Sigma Programming\DirDiff\';

procedure GetStoredDims(f:TForm);
var
  reg:TRegistry;
  r:TRect;
begin
  reg:=TRegistry.Create;
  try
    reg.OpenKey(AppRegKey+f.ClassName,true);
    r.Top:=reg.ReadInteger('Top');
    r.Left:=reg.ReadInteger('Left');
    r.Right:=reg.ReadInteger('Right');
    r.Bottom:=reg.ReadInteger('Bottom');
    f.BoundsRect:=r;
    if reg.ReadBool('Maximized') then
      //f.WindowState:=wsMaximized;
      ShowWindow(f.Handle,SW_MAXIMIZE);
  except
    //silent
  end;
  reg.Free;
end;

procedure SetStoredDims(f:TForm);
var
  reg:TRegistry;
  r:TRect;
begin
  reg:=TRegistry.Create;
  reg.OpenKey(AppRegKey+f.ClassName,true);
  reg.WriteBool('Maximized',f.WindowState=wsMaximized);
  if not(f.WindowState=wsMaximized) then
   begin
    r:=f.BoundsRect;
    reg.WriteInteger('Top',r.Top);
    reg.WriteInteger('Left',r.Left);
    reg.WriteInteger('Right',r.Right);
    reg.WriteInteger('Bottom',r.Bottom);
   end;
  reg.Free;
end;

function IsXML(FilePath1,FilePath2:string):boolean;
var
  r:TRegistry;
  i:integer;
  s,t:string;
begin
  //Result:=LowerCase(copy(fn,Length(fn)-3,4))='.xml';
  Result:=false;//default
  i:=Length(FilePath1);
  while not(i=0) and not(FilePath1[i]='.') do dec(i);
  s:=LowerCase(Copy(FilePath1,i,Length(FilePath1)-i+1));
  r:=TRegistry.Create;
  try
    r.RootKey:=HKEY_CLASSES_ROOT;
    if r.OpenKey(s,false) then
      if r.ValueExists('Content Type') then
        Result:=r.ReadString('Content Type')='text/xml';
    if Result and not(FilePath2='') then
     begin
      i:=Length(s);
      t:=LowerCase(Copy(FilePath2,Length(FilePath2)-i+1,i));
      if not(s=t) then
       begin
        Result:=false;
        r.CloseKey;
        if r.OpenKey(t,false) then
          if r.ValueExists('Content Type') then
            Result:=r.ReadString('Content Type')='text/xml';
       end;
     end;
  finally
    r.Free;
  end;
end;

end.

