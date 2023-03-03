unit DirFindWorker;

interface

uses Classes;

type
  TDirFinderCountMatches=(ncFiles,ncMatches,ncSubMatches);

  TDirFinderNotifyMessage=(nmError,nmDone,nmFolderFound,nmProgress,nmFolderDone,nmMatchFound);

  TDirFinderNotifyEvent=procedure(nm:TDirFinderNotifyMessage;
    const msg:string;const vals:array of integer) of object;

  TDirFinder=class(TThread)
  private
    FFolder,FFiles,FNotFiles,FPattern:string;
    FIgnoreCase,FMultiLine:boolean;
    FCountMatches:TDirFinderCountMatches;
    FOnNotify:TDirFinderNotifyEvent;
    FOnNotify_nm:TDirFinderNotifyMessage;
    FOnNotify_msg:string;
    FOnNotify_vals:array of integer;
    procedure Notify(nm:TDirFinderNotifyMessage;const msg:string;
      const vals:array of integer);
    procedure DoNotify;
  protected
    procedure Execute; override;
  public
    PrioFolder:string;
    constructor Create(const Folder,Files,NotFiles,Pattern:string;
      IgnoreCase,MultiLine:boolean;CountMatches:TDirFinderCountMatches;
      OnNotify:TDirFinderNotifyEvent);
    destructor Destroy; override;
  end;

  TFileEncoding=(feUtf16,feUtf8,feUnknown);

function FileAsWideString(const fn:string;var enc:TFileEncoding):WideString;

{$IF not(Defined(RawByteString))}
type
  RawByteString=AnsiString;
{$IFEND}

implementation

uses Windows, SysUtils, ActiveX, VBScript_RegExp_55_TLB;

(*
{$IF not(Defined(UTF8ToWideString))}
function UTF8ToWideString(const x:AnsiString):WideString;
begin
  Result:=UTF8Decode(x);
end;
{$IFEND}
*)

function FileAsWideString(const fn:string;var enc:TFileEncoding):WideString;
var
  i:integer;
  fh:THandle;
  f:THandleStream;
  wx:word;
  s:RawByteString;
begin
  fh:=CreateFile(PChar(fn),GENERIC_READ,FILE_SHARE_READ,nil,
    OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN,0);
  if fh=INVALID_HANDLE_VALUE then Result:='' else
   begin
    f:=THandleStream.Create(fh);
    try
      f.Read(wx,2);
      if wx=$FEFF then
       begin
        //UTF16
        enc:=feUtf16;
        i:=(f.Size div 2)-1;
        SetLength(Result,i);
        f.Read(Result[1],i*2);
       end
      else
       begin
        i:=0;
        if wx=$BBEF then f.Read(i,1);
        if (wx=$BBEF) and (i=$BF) then
         begin
          //UTF-8
          enc:=feUtf8;
          i:=f.Size-3;
          SetLength(s,i);
          f.Read(s[1],i);
          Result:=UTF8ToWideString(s);
         end
        else
         begin
          //assume current encoding
          enc:=feUnknown;
          f.Position:=0;
          i:=f.Size;
          SetLength(s,i);
          f.Read(s[1],i);
          Result:=string(s);
         end;
       end;
    finally
      f.Free;
      CloseHandle(fh);
    end;
   end;
end;


{ TDirFinder }

constructor TDirFinder.Create(const Folder, Files, NotFiles, Pattern: string;
  IgnoreCase, MultiLine: boolean; CountMatches: TDirFinderCountMatches; OnNotify: TDirFinderNotifyEvent);
begin
  inherited Create(false);
  FFolder:=Folder;
  FFiles:=Files;
  FNotFiles:=NotFiles;
  FPattern:=Pattern;
  FIgnoreCase:=IgnoreCase;
  FMultiLine:=MultiLine;
  FCountMatches:=CountMatches;
  FOnNotify:=OnNotify;
  PrioFolder:='';
  FreeOnTerminate:=true;
  Priority:=tpLower;//setting?
end;

destructor TDirFinder.Destroy;
begin
  //...
  inherited;
end;

procedure TDirFinder.Execute;
var
  re,reFiles1,reFiles2:RegExp;
  allfiles1,allfiles2:boolean;
  folders:TStringList;
  i,j,k,l:integer;
  d,fn:string;
  fh:THandle;
  fd:TWin32FindData;
  enc:TFileEncoding;
  mc:MatchCollection;
  m:Match;
  sm:SubMatches;
  vals:array of integer;
begin
  inherited;
  CoInitialize(nil);
  folders:=TStringList.Create;
  try
    folders.Add(FFolder);

    re:=CoRegExp.Create;
    re.Pattern:=FPattern;
    re.IgnoreCase:=FIgnoreCase;
    re.Multiline:=FMultiLine;
    re.Global:=true;

    reFiles1:=CoRegExp.Create;
    reFiles1.Pattern:=FFiles;
    reFiles1.IgnoreCase:=true;
    reFiles1.Global:=false;
    reFiles1.Multiline:=false;
    allfiles1:=FFiles='';

    reFiles2:=CoRegExp.Create;
    reFiles2.Pattern:=FNotFiles;
    reFiles2.IgnoreCase:=true;
    reFiles2.Global:=false;
    reFiles2.Multiline:=false;
    allfiles2:=FNotFiles='';

    while (folders.Count<>0) and not(Terminated) do
     begin
      if PrioFolder='' then i:=0 else
       begin
        i:=folders.IndexOf(FFolder+PrioFolder);
        if i=-1 then i:=0;
       end;
      d:=folders[i];
      folders.Delete(i);
      Notify(nmProgress,d,[]);//folders.Count);?
      fh:=FindFirstFile(PChar(d+'\*.*'),fd);
      try
        repeat
          fn:=d+'\'+fd.cFileName;
          if (fd.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN)=0 then //setting?
           begin
            if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)=0 then
             begin
              if (allfiles1 or reFiles1.Test(fn)) and (allfiles2 or not(reFiles2.Test(fn))) then
                case FCountMatches of
                  ncFiles:
                    if re.Test(FileAsWideString(fn,enc)) then Notify(nmMatchFound,fn,[1]);
                  ncMatches:
                   begin
                    j:=(re.Execute(FileAsWideString(fn,enc)) as MatchCollection).Count;
                    if j<>0 then Notify(nmMatchFound,fn,[j]);
                   end;
                  ncSubMatches:
                   begin
                    mc:=re.Execute(FileAsWideString(fn,enc)) as MatchCollection;
                    if mc.Count<>0 then
                     begin
                      m:=mc[0] as Match;
                      sm:=m.SubMatches as SubMatches;
                      SetLength(vals,1+sm.Count);//assert all matches same SubMatches.Count
                      vals[0]:=mc.Count;
                      if sm.Count<>0 then
                       begin
                        for k:=0 to sm.Count-1 do
                         begin
                          vals[k+1]:=0;
                          if TVarData(sm[k]).VType<>0 then inc(vals[k+1]);
                         end;
                        for l:=1 to mc.Count-1 do
                         begin
                          m:=mc[l] as Match;
                          sm:=m.SubMatches as SubMatches;
                          for k:=0 to sm.Count-1 do
                            if TVarData(sm[k]).VType<>0 then inc(vals[k+1]);
                         end;
                       end;
                      Notify(nmMatchFound,fn,vals);
                     end;
                   end;
                end;
             end
            else
              if not((fd.cFileName[0]='.') and (
                (fd.cFileName[1]=#0) or ((fd.cFileName[1]='.') and (fd.cFileName[2]=#0)))) then
               begin
                folders.Add(fn);
                Notify(nmFolderFound,fn,[]);
               end;
           end;
        until not(FindNextFile(fh,fd)) or Terminated;
        Notify(nmFolderDone,d,[]);
      finally
        Windows.FindClose(fh);
      end;
     end;

  except
    on e:Exception do Notify(nmError,e.Message,[]);
  end;
  Notify(nmDone,'',[]);
  folders.Free;
end;

procedure TDirFinder.Notify(nm: TDirFinderNotifyMessage;
  const msg: string; const vals:array of integer);
var
  k,l:integer;
begin
  if not(Terminated) then
   begin
    FOnNotify_nm:=nm;
    FOnNotify_msg:=msg;
    //FOnNotify_vals:=vals;
    l:=Length(vals);
    SetLength(FOnNotify_vals,l);
    for k:=0 to l-1 do FOnNotify_vals[k]:=vals[k];
    Synchronize(DoNotify);
   end;
end;

procedure TDirFinder.DoNotify;
var
  vals:array of integer;
  i,l:integer;
begin
  l:=Length(FOnNotify_vals);
  SetLength(vals,l);
  for i:=0 to l-1 do vals[i]:=FOnNotify_vals[i];
  FOnNotify(FOnNotify_nm,FOnNotify_msg,vals);
end;

end.
