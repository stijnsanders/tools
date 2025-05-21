unit shexAllSorts1;

interface

uses
  Windows, Classes, ActiveX, ComObj, ShlObj;

type
  TAllSortsHandler=procedure(Sender:TObject;Index:integer) of object;

  { TContextMenu }

  TContextMenu = class(TComObject, IShellExtInit, IContextMenu)
  private
    DisplayIcon:integer;
    DisplayTitle,Target:string;
    Files:TStringList;
    Commands:array of record
      Caption,Param:string;
      Exec:TAllSortsHandler;
    end;

    procedure CopyUNC(Sender:TObject;Index:integer);
    procedure CopyContent(Sender:TObject;Index:integer);
    procedure PasteText(Sender:TObject;Index:integer);
    procedure ReadOnly(Sender:TObject;Index:integer);
    procedure Touch(Sender:TObject;Index:integer);
    procedure OpenURL(Sender:TObject;Index:integer);
    procedure RunExternal(Sender:TObject;Index:integer);
  protected
    { IShellExtInit }
    function SEIInitialize(pidlFolder: PItemIDList; lpdobj: IDataObject;
      hKeyProgID: HKEY): HResult; stdcall;
    function IShellExtInit.Initialize=SEIInitialize;
    { IContextMenu }
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast,
      uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd: UINT_Ptr; uType: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

const
  Class_ContextMenu: TGUID = '{BE0F44C8-DBE3-4B20-A17C-3A49E61B1363}';

implementation

uses ComServ, SysUtils, Registry, ShellAPI;

var
  LastFolder:string;

procedure TContextMenu.Initialize;
var
  sl:TStringList;
  r:TRegistry;
  i,j,l:integer;
begin
  inherited;
  DisplayIcon:=2;//default
  DisplayTitle:='All&Sorts';//default
  Target:='';//default
  Files:=TStringList.Create;
  sl:=TStringList.Create;
  r:=TRegistry.Create;
  try
    r.RootKey:=HKEY_CURRENT_USER;
    if r.OpenKeyReadOnly('SOFTWARE\Double Sigma Programming\AllSorts') then
     begin
      if r.ValueExists('DisplayIcon') then
        DisplayIcon:=r.ReadInteger('DisplayIcon');
      if r.ValueExists('DisplayTitle') then
        DisplayTitle:=r.ReadString('DisplayTitle');
      r.CloseKey;
     end;

    if r.OpenKeyReadOnly('SOFTWARE\Double Sigma Programming\AllSorts\External') then
      r.GetValueNames(sl);

    l:=6+sl.Count;
    SetLength(Commands,l);
    i:=0;
    Commands[i].Caption:='&Copy UNC';
    Commands[i].Param:='';
    Commands[i].Exec:=CopyUNC;
    inc(i);
    Commands[i].Caption:='Co&py content';
    Commands[i].Param:='';
    Commands[i].Exec:=CopyContent;
    inc(i);
    Commands[i].Caption:='Paste te&xt';
    Commands[i].Param:='';
    Commands[i].Exec:=PasteText;
    inc(i);
    Commands[i].Caption:='Set &read-only';
    Commands[i].Param:='';
    Commands[i].Exec:=ReadOnly;
    inc(i);
    Commands[i].Caption:='&Touch (set date)';
    Commands[i].Param:='';
    Commands[i].Exec:=Touch;
    inc(i);
    Commands[i].Caption:='&Open URL...';
    Commands[i].Param:='';
    Commands[i].Exec:=OpenURL;
    inc(i);
    j:=0;
    while i<>l do
     begin
      Commands[i].Caption:=sl[j];
      Commands[i].Param:=r.ReadString(sl[j]);
      Commands[i].Exec:=RunExternal;
      inc(i);
      inc(j);
     end;

  finally
    sl.Free;
    r.Free;
  end;
end;

destructor TContextMenu.Destroy;
begin
  Files.Free;
  inherited;
end;

function TContextMenu.SEIInitialize(pidlFolder: PItemIDList;
  lpdobj: IDataObject; hKeyProgID: HKEY): HResult; stdcall;
var
  StgMedium: TStgMedium;
  FormatEtc: TFormatEtc;
  i,c:integer;
  s:string;
begin
  if lpdobj=nil then
   begin
    SetLength(Target,MAX_PATH+1);
    if SHGetPathFromIDList(pidlFolder,@Target[1]) then
     begin
      i:=1;
      while (i<MAX_PATH) and (Target[i]<>#0) do inc(i);
      SetLength(Target,i-1);
      if LastFolder=Target then
       begin
        LastFolder:='';//already loaded
        Result:=E_INVALIDARG;
       end
      else
        Result:=NOERROR;
     end
    else
      Result:=E_INVALIDARG;
   end
  else
   begin
    Target:='';
    FormatEtc.cfFormat:=CF_HDROP;
    FormatEtc.ptd:=nil;
    FormatEtc.dwAspect:=DVASPECT_CONTENT;
    FormatEtc.lindex:=-1;
    FormatEtc.tymed:=TYMED_HGLOBAL;
    Result:=lpdobj.GetData(FormatEtc,StgMedium);
    if not(Failed(Result)) then
     begin
      //TODO: DragQueryFileW
      c:=DragQueryFile(StgMedium.hGlobal,$FFFFFFFF,nil,0);
      for i:=0 to c-1 do
       begin
        SetLength(s,1024);
        SetLength(s,DragQueryFile(StgMedium.hGlobal,i,PChar(s),1024));
        Files.Add(s);
       end;
      ReleaseStgMedium(StgMedium);
      if Files.Count=1 then LastFolder:=Files[0];
      Result:=NOERROR;
     end;
   end;
end;

function TContextMenu.QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst,
  idCmdLast, uFlags: UINT): HResult; stdcall;
var
  h:HMENU;
  b:HBITMAP;
  i,f:UINT;
begin
  h:=CreatePopupMenu;
  for i:=0 to Length(Commands)-1 do
   begin
    f:=MF_STRING;
    if (i=1) and (Files.Count=0) then f:=f or MF_DISABLED;//copy content only on file(s)
    if (i=2) and not(IsClipboardFormatAvailable(CF_UNICODETEXT) and
      ((Target<>'') or (Files.Count=1))) then f:=f or MF_DISABLED;//paste only on folder
    AppendMenu(h,f,idCmdFirst+i+1,PChar(Commands[i].Caption));
   end;
  InsertMenu(Menu,indexMenu,
    MF_BYPOSITION or MF_POPUP or MF_STRING,h,PChar(DisplayTitle));
  if DisplayIcon<>0 then
   begin
    b:=LoadImage(HInstance,MakeIntResource(DisplayIcon),
      IMAGE_BITMAP,0,0,LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS);
    SetMenuItemBitmaps(Menu,indexMenu,MF_BYPOSITION,b,b);
   end;
  Result:=Length(Commands)+1;//MakeResult(SEVERITY_SUCCESS,FACILITY_NULL,)?
end;

function TContextMenu.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
  stdcall;
var
  i:integer;
begin
  Result:=E_FAIL;

  //not called by application
  if HiWord(Integer(lpici.lpVerb))=0 then
   begin

    try
      Result:=NOERROR;
      i:=LoWord(Integer(lpici.lpVerb));
      if (i=0) or (i>Length(Commands)) then Result:=E_INVALIDARG else
       begin
        Result:=NOERROR;
        dec(i);
        Commands[i].Exec(Self,i);
       end;
    except
      on e:Exception do
       begin
        MessageBox(GetDesktopWindow,PChar(
          '{'+e.ClassName+'}'+e.Message
        ),'AllSorts',MB_OK or MB_ICONERROR);
       end;
    end;

   end;
end;

function TContextMenu.GetCommandString(idCmd: UINT_Ptr; uType: UINT;
  pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult; stdcall;
const
  AName:AnsiString='Perform one of several functions on files'#0;
begin
  if idCmd=0 then
   begin
    if (uType=GCS_HELPTEXTW) then
      Move(AName[1],pszName^,Length(AName));
    Result:=NOERROR;
   end
  else
    Result:=E_INVALIDARG;
end;

type
  TContextMenuFactory = class(TComObjectFactory)
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

procedure TContextMenuFactory.UpdateRegistry(Register: Boolean);
var
  ClassID:string;
  r:TRegistry;
begin
  if Register then
   begin
    inherited UpdateRegistry(Register);

    ClassID := GUIDToString(Class_ContextMenu);
    CreateRegKey('*\shellex', '', '');
    CreateRegKey('*\shellex\ContextMenuHandlers', '', '');
    CreateRegKey('*\shellex\ContextMenuHandlers\AllSorts', '', ClassID);

    CreateRegKey('Folder\shellex', '', '');
    CreateRegKey('Folder\shellex\ContextMenuHandlers', '', '');
    CreateRegKey('Folder\shellex\ContextMenuHandlers\AllSorts', '', ClassID);

    {
    CreateRegKey('AllFilesystemObjects\shellex', '', '');
    CreateRegKey('AllFilesystemObjects\shellex\ContextMenuHandlers', '', '');
    CreateRegKey('AllFilesystemObjects\shellex\ContextMenuHandlers\AllSorts', '', ClassID);
    }

    CreateRegKey('Directory\Background\shellex', '', '');
    CreateRegKey('Directory\Background\shellex\ContextMenuHandlers', '', '');
    CreateRegKey('Directory\Background\shellex\ContextMenuHandlers\AllSorts', '', ClassID);

    if Win32Platform=VER_PLATFORM_WIN32_NT then
     begin
      r:=TRegistry.Create;
      try
        r.RootKey:=HKEY_LOCAL_MACHINE;
        r.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions',True);
        r.OpenKey('Approved',True);
        r.WriteString(ClassID,'AllSorts Shell Extension');
      finally
        r.Free;
      end;
     end;

    r:=TRegistry.Create;
    try
      r.RootKey:=HKEY_CURRENT_USER;
      r.OpenKey('SOFTWARE\Double Sigma Programming\AllSorts\URLs',True);
      r.WriteString('C:\InetPub\wwwroot','http://localhost');
    finally
      r.Free;
    end;

   end
  else
   begin
    DeleteRegKey('Folder\shellex\ContextMenuHandlers\AllSorts');
    DeleteRegKey('*\shellex\ContextMenuHandlers\AllSorts');

    inherited UpdateRegistry(Register);
   end;
end;

procedure ClipboardAsText(const x:AnsiString);
var
  hg:HGLOBAL;
  p:PChar;
begin
  if not OpenClipboard(0) then RaiseLastOSError;
  try
    EmptyClipboard;
    hg:=GlobalAlloc(GMEM_MOVEABLE,Length(x)+1);
    p:=GlobalLock(hg);
    Move(x[1],p^,Length(x)+1);
    GlobalUnlock(hg);
    SetClipboardData(CF_TEXT,hg);
  finally
    CloseClipboard;
  end;
end;

procedure TContextMenu.CopyUNC(Sender:TObject;Index:integer);
var
  i,j:integer;
  s:string;
  CtrlDown:boolean;
begin
  //clear? open? close?
  CtrlDown:=(GetKeyState(VK_CONTROL) and $8000)<>0;
  if (Files.Count=0) and (Target<>'') then
    Files.Add(Target+PathDelim);
  if CtrlDown then
    for i:=Files.Count-1 downto 0 do
     begin
      s:=Files[i];
      j:=Length(s);
      while (j<>0) and (s[j]<>'\') do dec(j);
      Files[i]:=Copy(s,j+1,Length(s)-j);
     end;
  ClipboardAsText(AnsiString(Trim(Files.Text)));
end;

procedure TContextMenu.CopyContent(Sender:TObject;Index:integer);
var
  i,l,lw:integer;
  a:array[0..3] of byte;
  t:AnsiString;
  w:WideString;
  CtrlDown:boolean;
  hg:HGLOBAL;
  p:PWideChar;
  f:TFileStream;
begin
  w:='';
  CtrlDown:=(GetKeyState(VK_CONTROL) and $8000)<>0;
  if CtrlDown then
   begin
    OpenClipboard(0);
    try
      hg:=GetClipboardData(CF_UNICODETEXT);
      if hg<>0 then
       begin
        i:=GlobalSize(hg)-1;
        lw:=i div 2;
        SetLength(w,lw);
        p:=GlobalLock(hg);
        Move(p^,w[1],i);
        GlobalUnlock(hg);
       end;
    finally
      CloseClipboard;
    end;
   end;
  //assert (Files.Count<>0) and (Target='')
  for i:=Files.Count-1 downto 0 do
   begin
    //TODO: warning large size/binary data?
    f:=TFileStream.Create(Files[i],fmOpenRead or fmShareDenyWrite);
    try
      a[0]:=0;
      a[1]:=0;
      a[2]:=0;
      a[3]:=0;
      l:=f.Size;
      f.Read(a[0],3);
      if (a[0]=$FF) and (a[1]=$FE) then //UTF16
       begin
        f.Position:=2;
        dec(l,2);
        lw:=Length(w);
        SetLength(w,lw+(l div 2));
        f.Read(w[lw+1],l);
       end
      else if (a[0]=$EF) and (a[1]=$BB) and (a[2]=$BF) then //UTF8
       begin
        dec(l,3);
        SetLength(t,l);
        f.Read(t[1],l);
        w:=w+UTF8ToWideString(t);
       end
      else
       begin
        f.Position:=0;
        SetLength(t,l);
        f.Read(t[1],l);
        w:=w+WideString(t);
       end;
    finally
      f.Free;
    end;
   end;
  if not OpenClipboard(0) then RaiseLastOSError;
  try
    EmptyClipboard;
    l:=(Length(w)+1)*2;
    hg:=GlobalAlloc(GMEM_MOVEABLE,l);
    p:=GlobalLock(hg);
    Move(w[1],p^,l);
    GlobalUnlock(hg);
    SetClipboardData(CF_UNICODETEXT,hg);
  finally
    CloseClipboard;
  end;
end;

procedure TContextMenu.PasteText(Sender: TObject; Index: integer);
var
  l,lw:integer;
  t:AnsiString;
  w:WideString;
  CtrlDown:boolean;
  hg:HGLOBAL;
  p:pointer;
  f:TFileStream;
  fn:string;
  fi:PItemIDList;
  ff:DWORD;
  procedure StoreData;
  begin
    f:=TFileStream.Create(fn,fmCreate);
    try
      if CtrlDown then
        f.Write(t[1],l)
      else
       begin
        //TODO: switch UTF16 (#$FEFF)?
        t:=#$EF#$BB#$BF+UTF8Encode(w);
        f.Write(t[1],Length(t));
       end;
    finally
      f.Free;
    end;
  end;
begin
  CtrlDown:=(GetKeyState(VK_CONTROL) and $8000)<>0;
  OpenClipboard(0);
  try
    if CtrlDown then
      hg:=GetClipboardData(CF_TEXT)
    else
      hg:=GetClipboardData(CF_UNICODETEXT);
    if hg=0 then
      raise Exception.Create('Paste: no text content found on clipboard');
    l:=GlobalSize(hg)-1;
    p:=GlobalLock(hg);
    if CtrlDown then
     begin
      lw:=l;
      SetLength(t,l);
      Move(p^,t[1],l);
     end
    else
     begin
      lw:=l div 2;
      SetLength(w,lw);
      Move(p^,w[1],l);
     end;
    GlobalUnlock(hg);
  finally
    CloseClipboard;
  end;
  if (Target='') then
   begin
    if Files.Count=1 then
     begin
      fn:=Files[0];
      if (GetFileAttributes(PChar(fn)) and FILE_ATTRIBUTE_DIRECTORY)<>0 then
       begin
        fn:=fn+PathDelim+FormatDateTime('yyyymmddhhnnss',Now)+'.txt';
        StoreData;
       end
      else
       begin
        if MessageBox(GetDesktopWindow,PChar(
          'Are you sure to overwrite this file? (#'+IntToStr(lw)+')'#13#10+fn),
          'AllSorts: Paste clipboard text',MB_ICONEXCLAMATION or MB_OKCANCEL)=idOk then
          StoreData;
       end;
     end
    else
      raise Exception.Create('Paste: unsupported file list count');
   end
  else
   begin
    //create file
    fn:=Target+PathDelim+FormatDateTime('yyyymmddhhnnss',Now)+'.txt';
    StoreData;
    if Succeeded(SHParseDisplayName(PChar(fn),nil,fi,SFGAO_CANRENAME,ff)) then//SFGAO_FILESYSTEM?
     begin
      SHOpenFolderAndSelectItems(fi,0,nil,OFASI_EDIT);
      CoTaskMemFree(fi);
     end;
   end;
end;

procedure TContextMenu.ReadOnly(Sender:TObject;Index:integer);
var
  i,a:integer;
  CtrlDown:boolean;
begin
  CtrlDown:=(GetKeyState(VK_CONTROL) and $8000)<>0;
  if (Files.Count=0) and (Target<>'') then
    Files.Add(Target);
  for i:=0 to Files.Count-1 do
   begin
    //if directory then cascade?
    a:=GetFileAttributes(PChar(Files[i]));
    if CtrlDown then
      a:=a and not(FILE_ATTRIBUTE_READONLY)
    else
      a:=a or FILE_ATTRIBUTE_READONLY;
    SetFileAttributes(PChar(Files[i]),a);
   end;
end;

procedure TContextMenu.Touch(Sender:TObject;Index:integer);
var
  i:integer;
begin
  if (Files.Count=0) and (Target<>'') then
    Files.Add(Target+PathDelim);
  for i:=0 to Files.Count-1 do
    FileSetDate(Files[i],DateTimeToFileDate(Now));
end;

procedure TContextMenu.OpenURL(Sender:TObject;Index:integer);
var
  r:TRegistry;
  sl:TStringList;
  i,l:integer;
  url:string;
begin
  //opzoeken in lijst
  if (Files.Count=0) and (Target<>'') then
    Files.Add(Target+PathDelim);
  if Files.Count<>0 then
   begin
    sl:=TStringList.Create;
    r:=TRegistry.Create;
    try
      r.RootKey:=HKEY_CURRENT_USER;
      if r.OpenKeyReadOnly('SOFTWARE\Double Sigma Programming\AllSorts\URLs') then
        r.GetValueNames(sl);

      i:=0;
      while (i<sl.Count) and (sl[i]<>'') and
        (UpperCase(sl[i])<>UpperCase(copy(Files[0],1,Length(sl[i])))) do
          inc(i);

      if i<sl.Count then
       begin
        l:=Length(sl[i]);
        url:=r.ReadString(sl[i])+StringReplace(
           copy(Files[0],l+1,Length(Files[0])-l),'\','/',[rfReplaceAll]);
        ShellExecute(0,nil,PChar(url),nil,nil,SW_NORMAL);
       end
      else
       begin
        if MessageBox(GetDesktopWindow,
          'Path not found in URL list, please edit registry key:'#13#10+
          '  SOFTWARE\Double Sigma Programming\AllSorts\URLs'#13#10+
          'Select OK to copy the selected path onto the clipboard.',
          'AllSorts: Open URL',MB_ICONEXCLAMATION or MB_OKCANCEL)=idOk then
         begin
          ClipboardAsText(AnsiString(Files[0]));
         end;
       end;

    finally
      sl.Free;
      r.Free;
    end;
  end;
end;

procedure TContextMenu.RunExternal(Sender:TObject;Index:integer);
var
  s,fn:string;
  i:integer;
begin
  SetLength(s,MAX_PATH);
  i:=GetModuleFileName(HINSTANCE,PChar(s),MAX_PATH);
  while (i<>0) and (s[i]<>PathDelim) do dec(i);
  SetLength(s,i);

  SetLength(fn,MAX_PATH);
  SetLength(fn,GetTempPath(MAX_PATH,PChar(fn)));
  fn:=Format('%sAllSorts%.8x%.8x.txt',[fn,GetTickCount,GetCurrentProcessId]);

  if (Files.Count=0) and (Target<>'') then
    Files.Add(Target+PathDelim);
  Files.SaveToFile(fn);

  ShellExecute(0,nil,PChar(Commands[Index].Param),PChar(fn),PChar(s),SW_NORMAL);
end;

initialization
  LastFolder:='';
  TContextMenuFactory.Create(ComServer, TContextMenu, Class_ContextMenu,
    '', 'AllSorts Shell Extension', ciMultiInstance, tmApartment);
end.
