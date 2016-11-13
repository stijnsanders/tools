unit ddData;

interface

uses Windows, SysUtils, Classes, VBScript_RegExp_55_TLB, Graphics, MSXML2_TLB;

const
  WM_LISTCOUNT = $0402;
  WM_PREVIEW = $0403;
  WM_QUEUEINFO = $0404;
  WM_COMPARENEXT = $0405;

type
  TDiffSet=class;//forward
  TDiffRunner=class;//forward

  TDiffData=class(TObject)
  private
    FOwner:TDiffSet;
    FPath1,FPath2:string;
    FIsDir1,FIsDir2,FIsXML:boolean;
    FContentData:Utf8String;
    FContent:array of record
      Index,Length,Weight:integer;
      Hash:cardinal;
    end;
    FContentCount,FContentSize,FContentLength,FContentLast:integer;
    procedure SetPath(const Value: string);
    function LoadFile(const FilePath: string): Utf8String;
  protected
    function LineData(Idx:integer):Utf8String;
  public
    Display1,Display2:TObject;
    ReadOnly:boolean;
    CompareFile,LastFilePath:string;
    LastFileSize:cardinal;
    LastFileTimeStamp:TDateTime;
    XmlDoc:IXMLDOMDocument2;
    constructor Create;
    destructor Destroy; override;
    procedure ListFiles(const Suffix: string;
      Idx:integer; Folders,Files:TStrings);
    procedure LoadFiles;
    procedure LoadContent;
    //TODO LoadContentXML(
    property Path:string read FPath1 write SetPath;
    property IsDir:boolean read FIsDir1;
  end;

  TDiffFileInfo=class(TObject)
  public
    IsDir:boolean;
    Info:array of record
      Name:string;
      FileSize:cardinal;
      LastMod:TDateTime;
    end;
    constructor Create(SetSize:integer);
    function GetIconIndex(IgnoreDates:boolean):integer;
  end;

  TDiffJob=(
    dj_None,
    djLoadData,
    djFindHeadTail,
    djHashing,
    djLCS,
    djOverview,
    djSubDiffs,
    djFileCompare
  );

  TDiffSet=class(TObject)
  private
    FParent:THandle;
    FData:array of TDiffData;
    FDataSize,FDataCount:integer;
    FreSkipFiles:IRegExp2;
    FContentMap,FSubDiffs:array of integer;
    FContentMapCount,FContentMapSize,FSubDiffsSize,
    FContentMapStride,FContentMapLast,
    FLineNrWidth,FLoadIndex,EqLinesHead,EqLinesTail:integer;
    FQueueLock:TRTLCriticalSection;
    FQueue:array of record
      Job:TDiffJob;
      Index:integer;
    end;
    FQueueIn,FQueueOut,FQueueSize:integer;
    FRunners:array of TDiffRunner;
    FQueueInfo:boolean;
    FDataLoaded,FDataHashed:integer;
    //FDictionary:TStringDictionary;
    function GetData(Idx: integer): TDiffData;
    procedure SyncQueue(var Counter:integer;Job:TDiffJob);
    function IndexToContentMapIndex(Idx:integer):integer;
    function ExpandTabs(const Source: Utf8String): Utf8String;
  protected
    function PerformJob(Runner:TDiffRunner):boolean;//called from TDiffRunner thread(s)
    procedure FindHeadTail;
    procedure PerformHashing(di:integer);
    procedure PerformDiff;
    procedure PerformSubDiffs;
    procedure GenerateOverview(OverviewHeight:integer);
    function StripData(const X:Utf8String):Utf8String;
    function CheckOnlyOne(Job:TDiffJob):boolean;
    procedure PerformFileCompare(var n:integer);
    function DetectXML(const FilePath:string):boolean;
    function ReworkXML(const SourceData:UTF8String):UTF8String;
  public
    SkipFiles:string;
    IgnoreDates,IgnoreWhitespace,IgnoreCase,WideTabs,EOLMarkers,
    XmlAutoDetect,XmlDomTree,XmlAttrOnLine,XmlDetectNS,XmlIndent,
    XmlAttrIgnSeq,XmlElemIgnSeq,XmlPreserveWhiteSpace,
    XmlCollapseEmpty,XmlIgnoreCData:boolean;
    XmlDefiningArributes:TStringList;
    constructor Create(Parent: THandle);
    destructor Destroy; override;
    procedure Queue(Job:TDiffJob;Index:integer);
    procedure AbortAll;
    procedure AddData(Data:TDiffData);
    procedure DropData(Index:integer);
    function AnyDir:boolean;
    function AnyXML:boolean;
    procedure LoadContent(const FilePaths: array of string;
      IsDir: boolean; OverviewHeight: integer);
    function DrawLine(Canvas:TCanvas;const Rect:TRect;
      State: TOwnerDrawState;Idx:integer):integer;
    function FindNext(Index,Direction:integer):integer;
    function FindNextText(Index,Direction:integer;const Match:string):integer;
    function FindLine(Index,Where:integer):integer;
    function LineText(Index:integer):string;
    function QueueInfo:string;
    function XmlMatch(x: IXMLDOMNode): string;
    function XmlDisplay(x: IXMLDOMNode): string;
    property DataCount:integer read FDataCount;
    property Data[Idx:integer]:TDiffData read GetData; default;
  end;

  TDiffRunner=class(TThread)
  private
    FOwner:TDiffSet;
    FEvent:THandle;
  protected
    procedure Execute; override;
  public
    Job:TDiffJob;
    Index:integer;
    constructor Create(Owner:TDiffSet);
    destructor Destroy; override;
    procedure Fire;
  end;

const
  DiffColorsCount=6;
  DiffColors:array[0..DiffColorsCount-1] of cardinal=(
    $0000FF,
    $00FF00,
    $FF3333,
    $00FFFF,
    $FFFF00,
    $FF00FF
  );

  //icon indexes
  iiDirNone=0;
  iiDirOnlyLeft=1;
  iiDirOnlyRight=2;
  iiDirEqual=3;
  iiDirLeftNewer=4;
  iiDirRightNewer=5;
  iiDirUnequal=6;
  iiFileNone=7;
  iiFileOnlyLeft=8;
  iiFileOnlyRight=9;
  iiFileEqual=10;
  iiFileLeftNewer=11;
  iiFileRightNewer=12;
  iiFileLeftLarger=13;
  iiFileRightLarger=14;
  iiFileLeftNewerLarger=15;
  iiFileLeftNewerSmaller=16;
  iiFileRightNewerSmaller=17;
  iiFileRightNewerLarger=18;
  iiFileUnequal=19;
  iiFileComparing=20;
  iiXmlNone=21;
  iiXmlOnlyLeft=22;
  iiXmlOnlyRight=23;
  iiXmlEqual=24;
  iiXmlUnequal=25;
  iiAttNone=26;
  iiAttOnlyLeft=27;
  iiAttOnlyRight=28;
  iiAttEqual=29;
  iiAttUnequal=30;
  iiItemNone=31;
  iiItemOnlyLeft=32;
  iiItemOnlyRight=33;
  iiItemEqual=34;
  iiItemUnequal=35;

function CLevel(x:TColor):TColor; //inline;
function DLevel(x:TColor):TColor; //inline;

implementation

uses xxHash, ActiveX, Registry;

const
  growSize=$400;

  //FContentMap indexes
  //cmStart=0;
  cmBitMask=1;
  cmSubDiffs=2;
  cmDelta=3;//first of source-delta's against cmStart

function CLevel(x:TColor):TColor; //inline;
var
  xx:array [0..3] of byte absolute x;
  yy:array [0..3] of byte absolute Result;
begin
  yy[0]:=(xx[0]+$EE) div 2;
  yy[1]:=(xx[1]+$EE) div 2;
  yy[2]:=(xx[2]+$EE) div 2;
end;

function DLevel(x:TColor):TColor; //inline;
var
  xx:array [0..3] of byte absolute x;
  yy:array [0..3] of byte absolute Result;
begin
  yy[0]:=(xx[0]+$1FE) div 3;
  yy[1]:=(xx[1]+$1FE) div 3;
  yy[2]:=(xx[2]+$1FE) div 3;
end;

{ TDiffData }

constructor TDiffData.Create;
begin
  inherited Create;
  FPath1:='';
  FIsDir1:=false;
  FPath2:='';
  FIsDir2:=false;
  FIsXML:=false;
  FOwner:=nil;//see TDiffSet.AddData
  FContentSize:=0;
  FContentCount:=0;
  Display1:=nil;
  Display2:=nil;
  ReadOnly:=true;
  CompareFile:='';
  LastFilePath:='';
  LastFileTimeStamp:=0.0;
  XmlDoc:=nil;
end;

procedure TDiffData.ListFiles(const Suffix:string;
  Idx: integer; Folders, Files: TStrings);
var
  d,x:string;
  y:integer;
  fh:THandle;
  fd:TWin32FindData;
  fi:TDiffFileInfo;
  st:TSystemTime;
begin
  if (FOwner.SkipFiles<>'') and (FOwner.FreSkipFiles=nil) then
   begin
    //TODO: critsec!
    FOwner.FreSkipFiles:=CoRegExp.Create;
    FOwner.FreSkipFiles.Pattern:=FOwner.SkipFiles;
    FOwner.FreSkipFiles.IgnoreCase:=true;
   end;
  if FIsDir1 then
    d:=IncludeTrailingPathDelimiter(FPath1)
  else
    d:=ExtractFilePath(FPath1);
  fh:=FindFirstFile(PChar(d+Suffix+'*.*'),fd);
  if fh<>INVALID_HANDLE_VALUE then
   begin
    repeat
      fi:=nil;
      if (fd.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN)=0 then
        if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)=0 then
         begin
          x:=LowerCase(fd.cFileName);
          if (FOwner.SkipFiles='') or not(FOwner.FreSkipFiles.Test(x)) then
           begin
            y:=Files.IndexOf(x);
            if y=-1 then
             begin
              fi:=TDiffFileInfo.Create(FOwner.DataCount);
              Files.AddObject(x,fi);
             end
            else
              fi:=Files.Objects[y] as TDiffFileInfo;
            fi.IsDir:=false;
           end;
         end
        else
          if (string(fd.cFileName)<>'.') and (string(fd.cFileName)<>'..') then
           begin
            x:=LowerCase(fd.cFileName);
            y:=Folders.IndexOf(x);
            if y=-1 then
             begin
              fi:=TDiffFileInfo.Create(FOwner.DataCount);
              Folders.AddObject(x,fi);
             end
            else
              fi:=Folders.Objects[y] as TDiffFileInfo;
            fi.IsDir:=true;
           end;
      if fi<>nil then
       begin
        fi.Info[Idx].Name:=fd.cFileName;
        fi.Info[Idx].FileSize:=fd.nFileSizeLow;
        if FileTimeToSystemTime(fd.ftLastWriteTime,st) then
          fi.Info[Idx].LastMod:=SystemTimeToDateTime(st)
        else
          fi.Info[Idx].LastMod:=0.0;
       end;
    until not FindNextFile(fh,fd);
    Windows.FindClose(fh);
   end;
end;

function TDiffData.LoadFile(const FilePath: string): Utf8String;
var
  f:TFileStream;
  w:WideString;
  s:AnsiString;
  wx:word;
  i,j:integer;
  fd:TByHandleFileInformation;
  st:TSystemTime;
begin
  f:=TFileStream.Create(FilePath,fmOpenRead or fmShareDenyNone);//fmShareDenyWrite?
  try
    f.Read(wx,2);
    if wx=$FEFF then
     begin
      //UTF16
      i:=(f.Size div 2)-1;
      SetLength(w,i);
      f.Read(w[1],i*2);
      //detect NULL's
      for j:=1 to i do if w[j]=#0 then w[j]:=' ';//?
      Result:=UTF8Encode(w);
     end
    else
     begin
      i:=0;
      if wx=$BBEF then f.Read(i,1);
      if (wx=$BBEF) and (i=$BF) then
       begin
        //UTF-8
        i:=f.Size-3;
        SetLength(Result,i);
        f.Read(Result[1],i);
        //detect NULL's
        for j:=1 to i do if Result[j]=#0 then Result[j]:=' ';//?
       end
      else
       begin                        
        //assume current encoding
        f.Position:=0;
        i:=f.Size;
        SetLength(s,i);
        f.Read(s[1],i);
        //detect NULL's
        for j:=1 to i do if s[j]=#0 then s[j]:=' ';//?
        Result:=s;
       end;
     end;

    LastFilePath:=FilePath;
    LastFileSize:=0;
    LastFileTimeStamp:=0.0;
    if GetFileInformationByHandle(f.Handle,fd) then
     begin
      if FileTimeToSystemTime(fd.ftLastWriteTime,st) then
        LastFileTimeStamp:=SystemTimeToDateTime(st);
      //assert fd.nFileSizeHigh=0
      LastFileSize:=fd.nFileSizeLow;
     end;

  finally
    f.Free;
  end;
end;

procedure TDiffData.LoadFiles;
var
  x:string;
  b:boolean;
  i,j,l:integer;
  fh:THandle;
  fd:TWin32FindData;
  st:TSystemTime;
  sl:TStringList;
begin
  if (FOwner.SkipFiles<>'') and (FOwner.FreSkipFiles=nil) then
   begin
    //TODO: critsec!
    FOwner.FreSkipFiles:=CoRegExp.Create;
    FOwner.FreSkipFiles.Pattern:=FOwner.SkipFiles;
    FOwner.FreSkipFiles.IgnoreCase:=true;
   end;
  FIsXML:=false;
  if FPath2='' then
   begin
    FContentData:='';
    FContentLength:=0;
    FContentCount:=0;
   end
  else
   begin
    //assert FIsDir
    sl:=TStringList.Create;
    try
      //list files
      sl.Sorted:=true;
      fh:=FindFirstFile(PChar(FPath1+FPath2+PathDelim+'*.*'),fd);
      if fh<>INVALID_HANDLE_VALUE then
       begin
        repeat
          b:=false;
          if (fd.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN)=0 then
            if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)=0 then
             begin
              x:=LowerCase(fd.cFileName);
              if (FOwner.SkipFiles='') or not(FOwner.FreSkipFiles.Test(x)) then
               begin
                x:=x+'  '+IntToStr(fd.nFileSizeLow);
                b:=true;
               end;
             end
            else
              if (string(fd.cFileName)<>'.') and (string(fd.cFileName)<>'..') then
               begin
                x:=PathDelim+LowerCase(fd.cFileName);
                b:=true;
               end;
          if b then
           begin
            if FileTimeToSystemTime(fd.ftCreationTime,st) then
              x:=x+'  '+FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',
                SystemTimeToDateTime(st))
            else
              x:=x+'  ?';
            if FileTimeToSystemTime(fd.ftLastWriteTime,st) then
              x:=x+'  '+FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',
                SystemTimeToDateTime(st))
            else
              x:=x+'  ?';
            //TODO: attributes! SHRA
            sl.Add(x);
           end;
        until not FindNextFile(fh,fd);
        Windows.FindClose(fh);
       end;
      //load into content
      FContentData:=sl.Text;
      FContentLength:=Length(FContentData);
      FContentCount:=0;
      l:=1;
      for i:=0 to sl.Count-1 do
       begin
        x:=sl[i];
        j:=Length(x);
        if FContentCount=FContentSize then
         begin
          inc(FContentSize,growSize);
          SetLength(FContent,FContentSize);
         end;
        FContent[FContentCount].Index:=l;
        FContent[FContentCount].Length:=j;
        FContent[FContentCount].Weight:=0;
        FContent[FContentCount].Hash:=0;
        inc(FContentCount);
        inc(l,j);
        inc(l,2);
       end;
    finally
      sl.Free;
    end;
   end;
end;

procedure TDiffData.LoadContent;
var
  i,j:integer;
begin
  LastFilePath:='';
  LastFileSize:=0;
  LastFileTimeStamp:=0.0;
  try
    if FPath2='' then
     begin
      FContentData:='';
      FIsXML:=false;
     end
    else
    if Copy(FPath2,1,4)='xml:' then
     begin
      FContentData:=FOwner.ReworkXML(Copy(FPath2,5,Length(FPath2)-4));
      FIsXML:=true;
     end
    else
     begin
      if FIsDir1 then
        FContentData:=LoadFile(FPath1+FPath2)
      else
        FContentData:=LoadFile(FPath2);
      FIsXML:=FOwner.DetectXML(FPath2);
      if FIsXML then
       begin

        XmlDoc:=CoDOMDocument.Create;
        XmlDoc.async:=false;
        XmlDoc.preserveWhiteSpace:=FOwner.XmlPreserveWhiteSpace;
        XmlDoc.loadXML(UTF8Decode(FContentData));//if not?

        FContentData:=FOwner.ReworkXML(FContentData);
       end;
     end;

    FContentLength:=Length(FContentData);
    FContentCount:=0;
    i:=1;
    while (i<=FContentLength) do
     begin
      j:=i;
      while (j<=FContentLength)
        and (FContentData[j]<>#13) and (FContentData[j]<>#10) do
       begin
        //TODO: whitespace? ignorecase?
        inc(j);
       end;
      //line found
      if FContentCount=FContentSize then
       begin
        inc(FContentSize,growSize);
        SetLength(FContent,FContentSize);
       end;
      FContent[FContentCount].Index:=i;
      FContent[FContentCount].Length:=j-i;
      FContent[FContentCount].Weight:=0;
      FContent[FContentCount].Hash:=0;
      inc(FContentCount);

      //skip CRLF
      if (j<FContentLength) and (FContentData[j]=#13)
        and (FContentData[j+1]=#10) then inc(j);
      i:=j+1;

{
      //final EOL?
      if i>FContentLength then
       begin
        if FContentCount=FContentSize then
         begin
          inc(FContentSize,growSize);
          SetLength(FContent,FContentSize);
         end;
        FContent[FContentCount].Index:=FContentLength+1;
        FContent[FContentCount].Length:=0;
        FContent[FContentCount].Weight:=0;
        FContent[FContentCount].Hash:=0;
        inc(FContentCount);
       end;
}
     end;
  except
    on EFOpenError do
     begin
      //check file not exists?
      FContentCount:=0;
     end;
  end;
  //TODO: check XML?
end;

procedure TDiffData.SetPath(const Value: string);
var
  i:integer;
begin
  FPath1:=Value;
  i:=GetFileAttributes(PChar(FPath1));
  FIsDir1:=((i<>-1) and ((i and FILE_ATTRIBUTE_DIRECTORY)<>0))
    or ((FPath1<>'') and (FPath1[Length(FPath1)]=PathDelim));
  FPath2:='';
  FIsDir2:=false;
end;

function TDiffData.LineData(Idx: integer): Utf8String;
begin
  Result:=FOwner.StripData(Copy(
    FContentData,FContent[Idx].Index,FContent[Idx].Length));
end;

destructor TDiffData.Destroy;
begin
  Display1.Free;
  Display2.Free;
  inherited;
end;

{ TDiffSet }

constructor TDiffSet.Create(Parent: THandle);
var
  i,l:integer;
begin
  inherited Create;
  FParent:=Parent;
  FDataSize:=0;
  FDataCount:=0;
  FreSkipFiles:=nil;
  FContentMapCount:=0;
  FContentMapSize:=0;
  FContentMapStride:=2;//default
  FContentMapLast:=-1;
  FSubDiffsSize:=0;
  FQueueIn:=0;
  FQueueOut:=0;
  FQueueSize:=0;
  FQueueInfo:=true;
  FLoadIndex:=0;
  FDataLoaded:=0;
  FDataHashed:=0;
  //FDictionary:=TStringDictionary.Create;
  InitializeCriticalSection(FQueueLock);
  //defaults
  SkipFiles:='';
  IgnoreDates:=true;
  IgnoreWhitespace:=true;
  IgnoreCase:=true;
  WideTabs:=false;
  EOLMarkers:=false;
  XmlAutoDetect:=true;
  XmlDomTree:=false;
  XmlAttrOnLine:=false;
  XmlDetectNS:=true;
  XmlIndent:=true;
  XmlAttrIgnSeq:=true;
  XmlPreserveWhiteSpace:=false;
  XmlCollapseEmpty:=true;
  XmlElemIgnSeq:=false;
  XmlIgnoreCData:=false;
  XmlDefiningArributes:=TStringList.Create;
  XmlDefiningArributes.Add('ID');
  XmlDefiningArributes.Add('Name');
  //start threads
  l:=StrToIntDef(GetEnvironmentVariable('NUMBER_OF_PROCESSORS'),1);
  //multiplier?
  SetLength(FRunners,l);
  for i:=0 to l-1 do FRunners[i]:=TDiffRunner.Create(Self);
end;

destructor TDiffSet.Destroy;
var
  i:integer;
begin
  for i:=0 to Length(FRunners)-1 do
   begin
    FRunners[i].Terminate;
    FRunners[i].FreeOnTerminate:=true;
    FRunners[i].Fire;
   end;
  DeleteCriticalSection(FQueueLock);
  XmlDefiningArributes.Free;
  while FDataCount<>0 do
   begin
    dec(FDataCount);
    FData[FDataCount].Free;
   end;
  //FDictionary.Free;
  inherited;
end;

procedure TDiffSet.AddData(Data: TDiffData);
begin
  if FDataCount=FDataSize then
   begin
    inc(FDataSize,growSize);
    SetLength(FData,FDataSize);
   end;
  FData[FDataCount]:=Data;
  Data.FOwner:=Self;
  inc(FDataCount);
  FContentMapCount:=0;
  FContentMapLast:=-1;
  FContentMapStride:=FDataCount+cmDelta;
end;

function TDiffSet.GetData(Idx: integer): TDiffData;
begin
  if (Idx<0) or (Idx>=FDataCount) then
    raise Exception.Create('TDiffSet.GetData out of range');
  Result:=FData[Idx];
end;

function TDiffSet.AnyDir: boolean;
var
  i:integer;
begin
  i:=0;
  Result:=false;
  while (i<>FDataCount) and not(Result) do
    if FData[i].FIsDir1 then Result:=true else inc(i);
end;

function TDiffSet.AnyXML: boolean;
var
  i:integer;
begin
  i:=0;
  Result:=false;
  while (i<>FDataCount) and not(Result) do
    if FData[i].FIsXML then Result:=true else inc(i);
end;

procedure TDiffSet.LoadContent(const FilePaths: array of string;
  IsDir: boolean; OverviewHeight: integer);
var
  i,j,l:integer;
begin
  if FDataCount<>Length(FilePaths) then
    raise Exception.Create('LoadContent FilePaths mismatch');
  //hard reset
  AbortAll;//does inc(FLoadIndex
  i:=0;
  l:=Length(FRunners);
  while i<l do
   begin
    j:=100;
    while (FRunners[i].Job<>dj_None) and (j<>0) do
     begin
      Sleep(25);
      dec(j);
     end;
    inc(i);
   end;
  //reset
  FContentMapCount:=0;
  FContentMapLast:=-1;
  //assert FContentMapStride set by AddData
  FLineNrWidth:=0;
  //queue jobs
  for i:=0 to FDataCount-1 do
   begin
    FData[i].LastFilePath:='';
    FData[i].LastFileTimeStamp:=0.0;
    FData[i].FPath2:=FilePaths[i];
    FData[i].FIsDir2:=IsDir;
    Queue(djLoadData,i);
   end;
end;

function TDiffSet.DrawLine(Canvas: TCanvas; const Rect: TRect;
  State: TOwnerDrawState; Idx: integer): integer;
var
  i,j,ix,jx,ca,cb,cc,cn,sl,si,s1,s2,x1,x2,x3:integer;
  r,r1:TRect;
  s,t1,t2,t3:string;
  bc,dc,tc,ec:TColor;
  cx:array[0..2] of integer;
  dx:array[0..3] of byte absolute dc;
  all:boolean;
begin
  Result:=0;//default
  if (FContentMapLast<>-1) and
    (Idx>=FContentMap[FContentMapLast*FContentMapStride]) and
    (Idx<FContentMap[(FContentMapLast+1)*FContentMapStride]) then
    cc:=FContentMapLast
  else
   begin
    ca:=0;
    cb:=FContentMapCount div FContentMapStride;
    cc:=-1;
    while ca<cb do
     begin
      cc:=(ca+cb) div 2;
      if Idx<FContentMap[cc*FContentMapStride] then //Start
        cb:=cc
      else
        if Idx>=FContentMap[(cc+1)*FContentMapStride] then //Stop
          ca:=cc+1
        else
          ca:=cb;
     end;
    FContentMapLast:=cc;
   end;
  if cc<>-1 then
   begin
    if FLineNrWidth=0 then
     begin
      ix:=0;
      for i:=0 to FDataCount-1 do
        if FData[i].FContentCount>ix then ix:=FData[i].FContentCount;
      FLineNrWidth:=Canvas.TextWidth(IntToStr(ix+1))+10;
     end;
    if odSelected in State then bc:=clSilver else bc:=clWhite;
    cc:=cc*FContentMapStride;
    dc:=bc;
    cx[0]:=0;
    cx[1]:=0;
    cx[2]:=0;
    cn:=0;
    all:=FContentMap[cc+cmBitMask]=((1 shl FDataCount)-1);
    si:=FContentMap[cc+cmSubDiffs];
    r.Left:=Rect.Left;
    r.Top:=Rect.Top;
    r.Right:=r.Left+4;
    r.Bottom:=Rect.Bottom;
    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=bc;
    Canvas.Font.Color:=$666666;
    Canvas.FillRect(r);
    j:=-1;
    jx:=0;
    for i:=0 to FDataCount-1 do
     begin
      r.Left:=Rect.Left+FLineNrWidth*i+4;
      r.Right:=r.Left+FLineNrWidth-4;
      if (FContentMap[cc+cmBitMask] and (1 shl i))=0 then
       begin
        Canvas.Brush.Color:=DLevel(DiffColors[i mod DiffColorsCount]);
        if r.Right>=0 then
          Canvas.FillRect(r);
       end
      else
       begin
        ix:=Idx-FContentMap[cc+cmDelta+i];
        if all then
          dc:=$CCCCCC//CLevel(DiffColors[i mod DiffColorsCount])
        else
          dc:=CLevel(DiffColors[i mod DiffColorsCount]);
        inc(cx[0],dx[0]);
        inc(cx[1],dx[1]);
        inc(cx[2],dx[2]);
        inc(cn);
        Canvas.Brush.Color:=dc;
        s:=IntToStr(ix+1);
        if j=-1 then
         begin
          j:=i;
          jx:=ix;
         end;
        if r.Right>=0 then
          Canvas.TextRect(r,r.Left+FLineNrWidth-6-Canvas.TextWidth(s),r.Top,s);
       end;
      r.Left:=r.Right;
      r.Right:=r.Left+4;
      Canvas.Brush.Color:=bc;
      Canvas.FillRect(r);
     end;
    r.Left:=FDataCount*FLineNrWidth+4;
    r.Right:=Rect.Right;
    if j=-1 then
     begin
      s:='';
      sl:=0;
     end
    else
     begin
      s:=ExpandTabs(Copy(Data[j].FContentData
        ,Data[j].FContent[jx].Index
        ,Data[j].FContent[jx].Length
        ));
      sl:=Length(s);
     end;
    if all then
     begin
      tc:=bc;
      ec:=bc;
     end
    else
     begin
      if cn=0 then
        dc:=$FFFFFF //?
      else
       begin
        dx[0]:=cx[0] div cn;
        dx[1]:=cx[1] div cn;
        dx[2]:=cx[2] div cn;
       end;
      tc:=dc;
      inc(cx[0],$FF*cn);
      inc(cx[1],$FF*cn);
      inc(cx[2],$FF*cn);
      dx[0]:=cx[0] div (cn*2);
      dx[1]:=cx[1] div (cn*2);
      dx[2]:=cx[2] div (cn*2);
      ec:=dc;
     end;
    Canvas.Font.Color:=$000000;
    if (si=0) or (sl=0) then
     begin
      i:=Canvas.TextWidth(s);
      Canvas.Brush.Color:=tc;
      Canvas.TextRect(r,r.Left,r.Top,s);
      r.Left:=r.Left+i;
     end
    else
     begin
      inc(si,(Idx-FContentMap[cc])*2);
      s1:=FSubDiffs[si];
      s2:=FSubDiffs[si+1];
      t1:=Copy(s,1,s1);
      t2:=Copy(s,s1+1,sl-s1-s2);
      t3:=Copy(s,sl-s2+1,s2);
      if t1='' then x1:=0 else x1:=Canvas.TextWidth(t1);
      if t2='' then x2:=0 else x2:=Canvas.TextWidth(t2);
      if t3='' then x3:=0 else x3:=Canvas.TextWidth(t3);
      r1:=r;
      if x1<>0 then
       begin
        Canvas.Brush.Color:=ec;
        r1.Left:=r.Left;
        r1.Right:=r1.Left+x1;
        Canvas.FillRect(r1);
       end;
      if x2<>0 then
       begin
        Canvas.Brush.Color:=tc;
        r1.Left:=r.Left+x1;
        r1.Right:=r1.Left+x2;
        Canvas.FillRect(r1);
       end;
      if s2<>0 then
       begin
        Canvas.Brush.Color:=ec;
        r1.Left:=r.Left+x1+x2;
        r1.Right:=r1.Left+x3;
        Canvas.FillRect(r1);
       end;
      Canvas.Brush.Color:=tc;
      r1.Left:=r.Left+x1+x2+x3;
      r1.Right:=r.Right;
      Canvas.FillRect(r1);
      Canvas.Brush.Style:=bsClear;
      Canvas.TextOut(r.Left,r.Top,s);
      r.Left:=r1.Left;
     end;
    Result:=r.Left+8;
    if EOLMarkers then
     begin
      if all then
        Canvas.Brush.Color:=$CCCCCC
      else
        Canvas.Brush.Color:=bc;
      inc(r.Top);
      dec(r.Bottom);
      r.Left:=r.Left+3;
      r.Right:=r.Left+1;
      Canvas.FillRect(r);
     end;
   end;
end;

function TDiffSet.ExpandTabs(const Source:Utf8String):Utf8String;
var
  i,j,l,tw:integer;
const
  sGrowStep=$400;  
begin
  //TODO: unicode?
  //TODO: separate job, deduplicate between DrawLine and PerformSubDiffs
  l:=((Length(Source) div sGrowStep)+1)*sGrowStep;
  SetLength(Result,l);
  if WideTabs then tw:=8 else tw:=4;
  j:=0;
  for i:=1 to Length(Source) do
    if Source[i]=#9 then
      repeat
        if j=l then
         begin
          inc(l,sGrowStep);
          SetLength(Result,l);
         end;
        inc(j);
        Result[j]:=' ';
      until (j and tw)=0
    else
     begin
      if j=l then
       begin
        inc(l,sGrowStep);
        SetLength(Result,l);
       end;
      inc(j);
      Result[j]:=Source[i];
     end;
  l:=j;
  SetLength(Result,l);
end;

procedure TDiffSet.Queue(Job: TDiffJob; Index: integer);
begin
  EnterCriticalSection(FQueueLock);
  try
    if FQueueIn=FQueueSize then
     begin
      inc(FQueueSize,growSize);
      SetLength(FQueue,FQueueSize);
     end;
    FQueue[FQueueIn].Job:=Job;
    FQueue[FQueueIn].Index:=Index;
    FRunners[FQueueIn mod Length(FRunners)].Fire;
    inc(FQueueIn);
    if not(FQueueInfo) then
     begin
      FQueueInfo:=true;
      PostMessage(FParent,WM_QUEUEINFO,0,0);
     end;
  finally
    LeaveCriticalSection(FQueueLock);
  end;
end;

procedure TDiffSet.AbortAll;
begin
  EnterCriticalSection(FQueueLock);
  try
    while FQueueOut<>FQueueIn do
     begin
      FQueue[FQueueOut].Job:=dj_None;
      inc(FQueueOut);
     end;
    FQueueIn:=0;
    FQueueOut:=0;
    FDataLoaded:=0;
    FDataHashed:=0;
    inc(FLoadIndex);
    //PostMessage(FParent,WM_QUEUEINFO,0,0);//?FQueueInfo:=?
  finally
    LeaveCriticalSection(FQueueLock);
  end;
end;

function TDiffSet.PerformJob(Runner:TDiffRunner):boolean;
begin
  //ATTENTION: called from TDiffRunner thread(s) !!!

  Result:=true;//default
  EnterCriticalSection(FQueueLock);
  try
    if FQueueIn=FQueueOut then
     begin
      Result:=false;//go to sleep until next Fire
      if not(FQueueInfo) then//and all threads now sleeping?
       begin
        FQueueInfo:=true;
        PostMessage(FParent,WM_QUEUEINFO,0,0);
       end;
     end
    else
     begin
      Runner.Job:=FQueue[FQueueOut].Job;
      Runner.Index:=FQueue[FQueueOut].Index;
      FQueue[FQueueOut].Job:=dj_None;
      inc(FQueueOut);
      if FQueueOut=FQueueIn then
       begin
        FQueueIn:=0;
        FQueueOut:=0;
       end;
      if not(FQueueInfo) then
       begin
        FQueueInfo:=true;
        PostMessage(FParent,WM_QUEUEINFO,0,0);
       end;
     end;
  finally
    LeaveCriticalSection(FQueueLock);
  end;

  try
    case Runner.Job of

      djLoadData:
       begin
        if FData[Runner.Index].FIsDir2 then
          FData[Runner.Index].LoadFiles
        else
          FData[Runner.Index].LoadContent;
        SyncQueue(FDataLoaded,djFindHeadTail);
       end;

      djFindHeadTail:
        FindHeadTail;

      djHashing:
       begin
        PerformHashing(Runner.Index);
        SyncQueue(FDataHashed,djLCS);
       end;

      djLCS:
        PerformDiff;

      djOverview:
        GenerateOverview(Runner.Index);

      djSubDiffs:
        PerformSubDiffs;

      djFileCompare:
        if CheckOnlyOne(djFileCompare) then
          PerformFileCompare(Runner.Index);

    end;
  finally
    Runner.Job:=dj_None;
    Runner.Index:=0;
  end;
end;

const
  ContentMapGrowStep=$100;

procedure TDiffSet.FindHeadTail;
var
  ok:boolean;
  i,j,k,l,lx:integer;
  s:Utf8String;
begin
  lx:=FLoadIndex;

  //check equal lines from start
  EqLinesHead:=0;
  ok:=true;
  while ok do
   begin
    for i:=0 to FDataCount-1 do
      if EqLinesHead=FData[i].FContentCount then
        ok:=false;
    if ok then
     begin
      s:=FData[0].LineData(EqLinesHead);
      i:=1;
      while (i<>FDataCount) and (s=FData[i].LineData(EqLinesHead)) do
        inc(i);
      if i=FDataCount then
        inc(EqLinesHead)
      else
        ok:=false;
     end;
    if ((EqLinesHead and $F)=0) and (FLoadIndex<>lx) then Exit;
   end;

  //check equal lines from end
  EqLinesTail:=0;
  for i:=0 to FDataCount-1 do
    FData[i].FContentLast:=FData[i].FContentCount;
  ok:=true;
  while ok do
   begin
    for i:=0 to FDataCount-1 do
      if FData[i].FContentLast=EqLinesHead then
        ok:=false;
    if ok then
     begin
      s:=FData[0].LineData(FData[0].FContentLast-1);
      i:=1;
      while (i<>FDataCount) and
        (s=FData[i].LineData(FData[i].FContentLast-1)) do
        inc(i);
      if i=FDataCount then
       begin
        inc(EqLinesTail);
        for i:=0 to FDataCount-1 do
          dec(FData[i].FContentLast);
       end
      else
        ok:=false;
     end;
    if ((EqLinesTail and $F)=0) and (FLoadIndex<>lx) then Exit;
   end;

  //start the content map with the remaining sections
  //TODO: lock/unlock
  FContentMapCount:=(2+FDataCount)*FContentMapStride;
  if FContentMapSize<=FContentMapCount then
   begin
    FContentMapSize:=((FContentMapCount div ContentMapGrowStep)+1)*ContentMapGrowStep;
    SetLength(FContentMap,FContentMapSize);
   end;
  k:=0;
  if EqLinesHead<>0 then
   begin
    FContentMap[0]:=0;//master index
    FContentMap[cmBitMask]:=(1 shl FDataCount)-1;//bitmask
    FContentMap[cmSubDiffs]:=0;//sub-diffs, see PerformSubDiffs
    for i:=0 to FDataCount-1 do
      FContentMap[cmDelta+i]:=0;//delta
    inc(k,FContentMapStride);
   end;
  l:=0;
  for i:=0 to FDataCount-1 do
   begin
    FContentMap[k]:=EqLinesHead+l;//master index
    FContentMap[k+cmBitMask]:=1 shl i;//bitmask
    FContentMap[k+cmSubDiffs]:=0;//sub-diffs, see PerformSubDiffs
    for j:=0 to FDataCount-1 do
      if i=j then
        FContentMap[k+cmDelta+j]:=l//delta
      else
        FContentMap[k+cmDelta+j]:=-1;
    inc(l,FData[i].FContentLast-EqLinesHead);
    inc(k,FContentMapStride);
   end;
  if EqLinesTail<>0 then
   begin
    FContentMap[k]:=EqLinesHead+l;//master index
    FContentMap[k+cmBitMask]:=(1 shl FDataCount)-1;//bitmask
    FContentMap[k+cmSubDiffs]:=0;//sub-diffs, see PerformSubDiffs
    for j:=0 to FDataCount-1 do
      FContentMap[k+cmDelta+j]:=EqLinesHead+l-FData[j].FContentLast;//delta
    inc(k,FContentMapStride);
   end;
  FContentMap[k]:=EqLinesHead+l+EqLinesTail;
  FContentMapCount:=k;

  //lines between head and tail?
  if l=0 then
   begin
    //none, show now
    PostMessage(FParent,WM_LISTCOUNT,EqLinesHead+l+EqLinesTail,0);
   end
  else
   begin
    //TODO: time? check enough to display? send/sync overview update now?
    for i:=0 to FDataCount-1 do Queue(djHashing,i);
   end;
end;

procedure TDiffSet.PerformHashing(di:integer);
var
  i,lx:integer;
begin
  lx:=FLoadIndex;
  for i:=EqLinesHead to FData[di].FContentLast-1 do
   begin
    FData[di].FContent[i].Hash:=
      //FDictionary.StrIdx(FData[di].LineData(i));
      xxHash32(FData[di].LineData(i),$EDCB7654);
    if ((i and $F)=0) and (lx<>FLoadIndex) then Exit;
   end;
end;

procedure TDiffSet.PerformDiff;
const
  qGrowStep=$10;
type
  tkk=record
    f,fx,fy,b,bx,by:integer;
  end;
  pkk=^tkk;
var
  i,j,k,l,lx,dc:integer;
  ok:boolean;
  s:Utf8String;
  q:array of integer;
  qi,qx,ql,qStart,qStride,qNext,di,dj,dodd,
  aa,ax,ay,bb,bx,by,cx,cy,dx,dy:integer;
  kkk:array of tkk;
  kk:pkk;
  ff:array of integer;
  function kx(ii:integer):pkk; //inline
  begin
    if ii<0 then
      Result:=@kkk[(-ii)*2-1]
    else
      Result:=@kkk[ii*2]
  end;
begin
  lx:=FLoadIndex;
  dc:=FDataCount;

  //TODO: deduplicate with ddDiff's PerformDiff

  qNext:=dc*2;
  qStride:=qNext+1;
  ql:=qGrowStep*qStride;
  SetLength(q,ql);
  qStart:=qStride;
  qi:=qStride;
  qx:=qStride*2;
  aa:=0;
  for i:=0 to dc-1 do
   begin
    j:=FData[i].FContentLast;
    l:=j-EqLinesHead;
    if l>aa then aa:=l;
    q[i*2  ]:=j;//closing entry past last line
    q[i*2+1]:=j+EqLinesTail;
    q[qi+i*2  ]:=EqLinesHead;//start
    q[qi+i*2+1]:=j;
   end;
  q[qNext]:=-1;//closing entry
  q[qi+qNext]:=0;//start entry
  SetLength(kkk,aa*2+5);
  SetLength(ff,dc*2);

  while qi<>qx do
   begin
    //split
    ff[0]:=q[qi];
    ff[1]:=q[qi+1];
    di:=0;
    dj:=1;
    while dj<>dc do
     begin
      cx:=ff[di*2];
      cy:=ff[di*2+1];
      if cx=-1 then
       begin
        cx:=q[qi+di*2];
        cy:=q[qi+di*2+1];
       end;
      dx:=q[qi+dj*2];
      dy:=q[qi+dj*2+1];
      ax:=cy-cx;
      bx:=dy-dx;
      if ax>bx then l:=ax else l:=bx; //assert l<Length(kkk)
      dodd:=(ax xor bx) and 1;
      ay:=0;//counter warning
      by:=0;//counter warning
      i:=((dy-dx)-(cy-cx)+1) div 2;
      if i<cy-cx then i:=0;
      for k:=-i to i do
       begin
        kk:=kx(k);
        j:=cx-1; kk.f:=j; kk.fx:=j; kk.fy:=j;
        j:=cy  ; kk.b:=j; kk.bx:=j; kk.by:=j;
       end;
      k:=i+2;
      while i<>l do
       begin
        kk:=kx(-i-1);
        j:=cx-1; kk.f:=j; kk.fx:=j; kk.fy:=j;
        j:=cy  ; kk.b:=j; kk.bx:=j; kk.by:=j;
        kk:=kx(i+1);
        j:=cx-1; kk.f:=j; kk.fx:=j; kk.fy:=j;
        j:=cy  ; kk.b:=j; kk.bx:=j; kk.by:=j;
        k:=-i;
        while (i<>l) and (k<=i) do
         begin
          kk:=kx(k);
          //forward
          if true then
           begin
            aa:=kx(k+1).f;
            ax:=kx(k-1).f+1;
            if aa<ax then aa:=ax else ax:=aa;
            bb:=q[qi+di*2]-dx+k;//bb:=cx-dx+k;
            bx:=ax-bb;
            if (ax>=cx) and (bx>=dx) then
             begin
              ay:=cy;
              by:=dy;
              while (ax<ay) and (bx<by) and
                (FData[di].FContent[ax].Hash=FData[dj].FContent[bx].Hash) do
               begin
                inc(ax);
                inc(bx);
               end;
             end;
            kk.f:=ax;
            if aa<>ax then
             begin
              kk.fx:=aa;
              kk.fy:=ax;
             end;
            if (dodd=1) and (ax>=kk.b) then
              if (kk.fx<>kk.fy) and
                (kk.fy-kk.fx>=kk.by-kk.bx) then
               begin
                i:=l;
                ax:=kk.fx;
                ay:=kk.fy;
                bx:=ax-bb;
                by:=ay-bb;
               end
              else
              if kk.bx<>kk.by then
               begin
                i:=l;
                bb:=q[qi+di*2+1]-dy+k;
                ax:=kk.bx+1;
                ay:=kk.by+1;
                bx:=ax-bb;
                by:=ay-bb;
               end;
           end;
          //backward
          if i<>l then
           begin
            aa:=kx(k-1).b;
            ax:=kx(k+1).b-1;
            if aa>ax then aa:=ax else ax:=aa;
            bb:=q[qi+di*2+1]-dy+k;//bb:=cy-dy+k;
            bx:=ax-bb;
            if (ax<cy) and (bx<dy) then
             begin
              ay:=cx;
              by:=dx;
              while (ax>=ay) and (bx>=by) and
                (FData[di].FContent[ax].Hash=FData[dj].FContent[bx].Hash) do
               begin
                dec(ax);
                dec(bx);
               end;
             end;
            kk.b:=ax;
            if aa<>ax then
             begin
              kk.bx:=ax;
              kk.by:=aa;
             end;
            if (dodd=0) and (kk.f>=ax) then
              if (kk.bx<>kk.by) and
                (kk.by-kk.bx>=kk.fy-kk.fx) then
               begin
                i:=l;
                ax:=kk.bx+1;
                ay:=kk.by+1;
                bx:=ax-bb;
                by:=ay-bb;
               end
              else
              if kk.fx<>kk.fy then
               begin
                i:=l;
                bb:=q[qi+di*2]-dx+k;
                ax:=kk.fx;
                ay:=kk.fy;
                bx:=ax-bb;
                by:=ay-bb;
               end;
           end;
          //next
          if i<>l then inc(k,2);
          if lx<>FLoadIndex then Exit;
         end;
        if i<>l then inc(i);
       end;
      //next source
      if k>i then
       begin
{
        if ff[di*2]-q[qi+di*2]<q[qi+di*2+1]-ff[di*2+1] then
          j:=q[qi+dj*2]
        else
          j:=q[qi+dj*2+1];

        ff[dj*2  ]:=j;
        ff[dj*2+1]:=j;
}
        ff[dj*2  ]:=-1;
        ff[dj*2+1]:=-1;

        inc(di);
        if di=dj then
         begin
          di:=0;
          inc(dj);
         end;
       end
      else
       begin
        //assert ay-ax=by-bx
        if (ax<>cx) or (ay<>cy) then
          for j:=0 to dj-1 do
            if ff[j*2]<>ff[j*2+1] then
             begin
              inc(ff[j*2  ],ax-cx);
              dec(ff[j*2+1],cy-ay);
             end;
        ff[dj*2  ]:=bx;
        ff[dj*2+1]:=by;
        inc(dj);
       end;
     end;

    //update fragment stack
    //if (k>i) or (ff[0]=ff[1]) then
    k:=0;
    for i:=0 to dc-1 do if ff[i*2]<ff[i*2+1] then inc(k);
    if k<2 then
     begin
      //nothing found, skip (and invalidate for below)
      for i:=0 to dc-1 do q[qi+i*2+1]:=q[qi+i*2];
      inc(qi,qStride);
     end
    else
     begin
      //top fragment
      //if (ax>q[qi]) and (bx>q[qj]) then
      i:=0;
      while (i<>dc) and ((ff[i*2]=ff[i*2+1]) or (ff[i*2]=q[qi+i*2])) do inc(i);
      if i<>dc then
       begin
        if qx=ql then
         begin
          inc(ql,qGrowStep*qStride);
          SetLength(q,ql);
         end;
        for i:=0 to dc-1 do
         begin
          q[qx+i*2  ]:=q[qi+i*2];
          if ff[i*2]=-1 then
            q[qx+i*2+1]:=q[qi+i*2+1]
          else
            q[qx+i*2+1]:=ff[i*2];
         end;
        if qStart=qi then
          qStart:=qx
        else
         begin
           i:=qStride;
           while (i<>qx) and (q[i+qNext]<>qi) do inc(i,qStride);
           q[i+qNext]:=qx;
         end;
        q[qx+qNext]:=qi;
        inc(qx,qStride);
       end;
      //bottom fragment
      //if (ay<q[qi+1]) and (by<q[qj+1]) then
      i:=0;
      while (i<>dc) and ((ff[i*2]=ff[i*2+1]) or (ff[i*2+1]=q[qi+i*2+1])) do inc(i);
      if i<>dc then
       begin
        if qx=ql then
         begin
          inc(ql,qGrowStep*qStride);
          SetLength(q,ql);
         end;
        for i:=0 to dc-1 do
         begin
          if ff[i*2+1]=-1 then
            q[qx+i*2]:=q[qi+i*2]
          else
            q[qx+i*2]:=ff[i*2+1];
          q[qx+i*2+1]:=q[qi+i*2+1];
         end;
        q[qx+qNext]:=q[qi+qNext];
        q[qi+qNext]:=qx;
        inc(qx,qStride);
       end;
      //equal part
      for i:=0 to dc-1 do
       begin
        q[qi+i*2  ]:=ff[i*2  ];
        q[qi+i*2+1]:=ff[i*2+1];
       end;
      //q[qi+qNext]:=//see above
      inc(qi,qStride);
     end;
   end;

  SetLength(kkk,0);
  //SetLength(ff,dc);

  //draw common subsequences
  FContentMapCount:=(3+qx*2*dc)*FContentMapStride;
  if FContentMapSize<=FContentMapCount then
   begin
    FContentMapSize:=((FContentMapCount div ContentMapGrowStep)+1)*ContentMapGrowStep;
    SetLength(FContentMap,FContentMapSize);
   end;
  k:=0;
  //FContentMap[0]:=;//done by FindHeadTail
  if EqLinesHead<>0 then inc(k,FContentMapStride);
  l:=EqLinesHead;
  for i:=0 to dc-1 do ff[i]:=EqLinesHead;
  qi:=qStart;
  while qi<>-1 do
   begin
{
    //check vector
    for i:=0 to dc-1 do
      if (ff[i]>q[qi+i*2]) and (q[qi+i*2]<>q[qi+i*2+1]) then
       begin
        aa:=ff[i]-q[qi+i*2];
        for j:=0 to dc-1 do inc(q[qi+j*2],aa);
       end;
}
    //unequal part
    for i:=0 to dc-1 do
     begin
      aa:=q[qi+i*2];
      if {(aa<>q[qi+i*2+1]) and }(ff[i]<aa) then
       begin
        FContentMap[k]:=l;
        FContentMap[k+cmBitMask]:=(1 shl i);
        FContentMap[k+cmSubDiffs]:=0;
        for j:=0 to dc-1 do
          if i=j then
            FContentMap[k+cmDelta+j]:=l-ff[i]
          else
            FContentMap[k+cmDelta+j]:=-1;
        inc(k,FContentMapStride);
        inc(l,aa-ff[i]);
        ff[i]:=aa;
       end;
     end;
    //equal part
    aa:=0;
    bb:=0;
    for i:=0 to dc-1 do
     begin
      j:=q[qi+i*2+1]-q[qi+i*2];
      if j<>0 then
       begin
        aa:=aa or (1 shl i);
        bb:=j;
       end;
     end;
    if aa<>0 then
     begin
      FContentMap[k]:=l;
      FContentMap[k+cmBitMask]:=aa;
      FContentMap[k+cmSubDiffs]:=0;
      for i:=0 to dc-1 do
        if (aa and (1 shl i))=0 then
          FContentMap[k+cmDelta+i]:=-1
        else
         begin
          FContentMap[k+cmDelta+i]:=l-ff[i];
          inc(ff[i],bb);
         end;
      inc(k,FContentMapStride);
      inc(l,bb);
     end;
    //next
    qi:=q[qi+qNext];
    if lx<>FLoadIndex then Exit;
   end;
{
  //tail //(replaced by q[0] above)
  if EqLinesTail<>0 then
   begin
    FContentMap[k]:=l;
    FContentMap[k+cmBitMask]:=(1 shl dc)-1;
    FContentMap[k+cmSubDiffs]:=0;
    for j:=0 to FDataCount-1 do
      FContentMap[k+cmDelta+j]:=l-FData[j].FContentLast;//delta
    inc(k,FContentMapStride);
    inc(l,EqLinesTail);
   end;
}
  FContentMap[k]:=l;
  FContentMapCount:=k;

  //done
  PostMessage(FParent,WM_LISTCOUNT,l,EqLinesHead);
  //Sleep(100);//stall a bit to let display update (let djOverview queue first)
  Queue(djSubDiffs,0);
end;

function TDiffSet.StripData(const X: Utf8String): Utf8String;
var
  i,j,l:integer;
  w:WideString;
begin
  if IgnoreWhitespace then
   begin
    w:=UTF8Decode(X);
    i:=1;
    j:=1;

    l:=Length(w);

    while (i<=l) and (w[i]<=' ') do inc(i);

    while (i<=l) do
     begin
      while (i<=l) and (w[i]>' ') do
       begin
        w[j]:=w[i];
        inc(i);
        inc(j);
       end;
      if (i<=l) and (w[i]<=' ') then
       begin
        w[j]:=' ';
        inc(j);
        while (i<=l) and (w[i]<=' ') do inc(i);
        if i>l then
         begin
          dec(j);
         end;
       end;
     end;
    SetLength(w,j-1);

    if IgnoreCase then
      Result:=UTF8Encode(WideUpperCase(UTF8Decode(w)))
    else
      Result:=UTF8Encode(w);
   end
  else
    if IgnoreCase then
      Result:=UTF8Encode(WideUpperCase(X))
    else
      Result:=X;
end;

function TDiffSet.IndexToContentMapIndex(Idx:integer):integer;
var
  ca,cb:integer;
begin
  ca:=0;
  cb:=FContentMapCount div FContentMapStride;
  Result:=-1;
  if Idx=-1 then Idx:=0;
  while ca<cb do
   begin
    Result:=(ca+cb) div 2;
    if Idx<FContentMap[Result*FContentMapStride] then
      cb:=Result
    else
      if Idx>=FContentMap[(Result+1)*FContentMapStride] then
        ca:=Result+1
      else
        ca:=cb;
   end;
  if Result<>-1 then
    Result:=Result*FContentMapStride;
end;

function TDiffSet.FindNext(Index, Direction: integer): integer;
var
  l,c:integer;
begin
  //assert Direction=1 or Direction=-1
  Result:=-1;//default
  c:=IndexToContentMapIndex(Index);
  if c<>-1 then
   begin
    l:=(1 shl FDataCount)-1;
    //exit current block
    while (c<>0) and (c<FContentMapCount) and (FContentMap[c+cmBitMask]<>l) do
      inc(c,FContentMapStride*Direction);
    //skip block of equals
    while (c<>0) and (c<FContentMapCount) and (FContentMap[c+cmBitMask]=l) do
      inc(c,FContentMapStride*Direction);
    //done
    if (c<>0) and (c<FContentMapCount) then Result:=FContentMap[c];
   end;
end;

//never call with Value=0!
procedure FillLongword(var X; Count: Integer; Value: Longword);
asm
  push  edi
  mov   edi,eax
  mov   eax,ecx
  mov   ecx,edx
  rep   stosd
  pop   edi
end;

procedure TDiffSet.GenerateOverview(OverviewHeight:integer);
var
  bb:TBitmap;
  i,j,k,l,a,b,c,d,p,lx:integer;
  cx:array[0..3] of byte absolute c;
  px:array[0..2] of integer;
begin
  inherited;
  lx:=FLoadIndex;
  bb:=TBitmap.Create;
  bb.PixelFormat:=pf32bit;//?
  bb.Width:=32;
  bb.Height:=OverviewHeight;
  if FContentMapCount<>0 then
   begin
    a:=FContentMap[FContentMapCount]+1;
    b:=OverviewHeight;
    k:=0;
    for i:=0 to b-1 do
     begin
      d:=(i+1)*a div b;
      p:=0;
      px[0]:=0;
      px[1]:=0;
      px[2]:=0;
      while (k<>FContentMapCount) and (FContentMap[k+FContentMapStride]<d) do
        inc(k,FContentMapStride);
      l:=k;
      while (l<>FContentMapCount) and ((l=k) or (FContentMap[l]<d)) do
       begin
        for j:=0 to FDataCount-1 do
         if ((1 shl j) and FContentMap[l+cmBitMask])<>0 then
           begin
            inc(p);
            c:=DiffColors[j];
            inc(px[0],cx[0]);
            inc(px[1],cx[1]);
            inc(px[2],cx[2]);
           end;
        inc(l,FContentMapStride);
       end;
      if (p=FDataCount) or (p=0) then
        c:=$FFFFFF
      else
       begin
        cx[0]:=px[2] div p;
        cx[1]:=px[1] div p;
        cx[2]:=px[0] div p;
        cx[3]:=0;
       end;
      FillLongword(bb.ScanLine[i]^,32,c);
      if ((i and $F)=0) and (FLoadIndex<>lx) then Exit;
     end;
   end;
   
  SendMessage(FParent,WM_PREVIEW,integer(bb),0);
end;

function TDiffSet.QueueInfo: string;
var
  i:integer;
const
  djName:array[TDiffJob] of string=(
    '-',
    'load',
    'body',
    'hash',
    'diff',
    'view',
    'subd',
    'fcmp'
  );
begin
  EnterCriticalSection(FQueueLock);
  try
    Result:='';
    for i:=0 to Length(FRunners)-1 do
      if FRunners[i].Job<>dj_None then
        Result:=Format('%s %d#%s:%d',[Result,i,
          djName[FRunners[i].Job],FRunners[i].Index]);
    i:=FQueueOut;
    while i<>FQueueIn do
     begin
      Result:=Format('%s %s:%d',[Result,
        djName[FQueue[i].Job],FQueue[i].Index]);
      inc(i);
     end;
    FQueueInfo:=false;
  finally
    LeaveCriticalSection(FQueueLock);
  end;
end;

procedure TDiffSet.SyncQueue(var Counter: integer; Job: TDiffJob);
begin
  EnterCriticalSection(FQueueLock);
  try
    inc(Counter);
    if Counter=FDataCount then
     begin
      Counter:=0;
      Queue(Job,0);
     end;
  finally
    LeaveCriticalSection(FQueueLock);
  end;
end;

procedure TDiffSet.PerformFileCompare(var n:integer);
const
  dSize=$10000;
var
  i,j,l1,l2:integer;
  d1,d2:array[0..dSize-1] of byte;
  f:array of TFileStream;
  eq:boolean;
begin
  Sleep(100);//stall a bit to let display update
  SetLength(f,FDataCount);
  while n<>-1 do
   begin
    //get node info (into FData[i].CompareFile)
    n:=SendMessage(FParent,WM_COMPARENEXT,0,n);
    if n=-1 then Exit;
    for i:=0 to FDataCount-1 do
      f[i]:=nil;
    try
      eq:=true;//default
      i:=0;
      while eq and (i<FDataCount) do
       begin
        try
          if FData[i].CompareFile='' then
            eq:=false
          else
            f[i]:=TFileStream.Create(FData[i].FPath1+FData[i].CompareFile,
              fmOpenRead or fmShareDenyNone);//fmShareDenyWrite?
        except
          on EFOpenError do
            eq:=false;
        end;
        inc(i);
       end;
      l1:=1;
      while eq and (l1<>0) do
       begin
        l1:=f[0].Read(d1[0],dSize);
        i:=1;
        while (i<>FDataCount) and eq do
         begin
          l2:=f[i].Read(d2[0],dSize);
          if l1=l2 then
           begin
            j:=0;
            while (j<l1) and (d1[j]=d2[j]) do inc(j);
            eq:=j=l1;
           end
          else
            eq:=false;
          inc(i);
         end;
       end;
    finally
      for i:=0 to FDataCount-1 do
        f[i].Free;
    end;

    //report result and get next node index (if any)
    if eq then i:=1 else i:=2;
    n:=SendMessage(FParent,WM_COMPARENEXT,i,n);

    //re-queue to take other jobs first?
    if FQueueIn<>FQueueOut then
     begin
      Queue(djFileCompare,n);
      n:=-1;
     end;
   end;
end;

function TDiffSet.FindNextText(Index, Direction: integer;
  const Match: string): integer;
var
  c,x,i:integer;
  m1,m2:UTF8String;
begin
  Result:=-1;//default
  if Index=-1 then x:=0 else x:=Index+Direction;
  c:=IndexToContentMapIndex(x);
  m1:=UpperCase(Match);
  while (Result=-1) and (c>=0) and (c<FContentMapCount) do
   begin
    i:=0;
    while (i<>FDataCount) and
      ((FContentMap[c+cmBitMask] and (1 shl i))=0) do inc(i);
    if i=FDataCount then
      m2:=''
    else
      m2:=UpperCase(FData[i].LineData(x-FContentMap[c+cmDelta+i]));
    if Pos(m1,m2)<>0 then
      Result:=x
    else
     begin
      inc(x,Direction);
      if (x<FContentMap[c]) or (x>=FContentMap[c+FContentMapStride]) then
        inc(c,FContentMapStride*Direction);
     end;
   end;
end;

function TDiffSet.CheckOnlyOne(Job: TDiffJob): boolean;
var
  i,j:integer;
begin
  j:=0;
  for i:=0 to Length(FRunners)-1 do
    if FRunners[i].Job=Job then
      inc(j);
  Result:=j=1;
end;

function TDiffSet.FindLine(Index, Where: integer): integer;
var
  i,j:integer;
  f:array of integer;
begin
  //assert Direction=1 or Direction=-1
  Result:=-1;//default
  SetLength(f,FDataCount);
  for i:=0 to FDataCount-1 do f[i]:=-1;
  i:=0;
  while (i<>FContentMapCount) and (Result=-1) do
   begin
    if Where=0 then j:=0 else j:=Where-1;
    while j<>FDataCount do
     begin
      if (FContentMap[i+cmBitMask] and (1 shl j))<>0 then
        if (f[j]<>-1) and
          (FContentMap[i]-FContentMap[i+cmDelta+j]>Index-1) then
          Result:=FContentMap[f[j]+cmDelta+j]+Index-1
        else
          f[j]:=i;
      if Where=0 then inc(j) else j:=FDataCount;
     end;
    if i<>FContentMapCount then inc(i,FContentMapStride);
   end;
  if Result=-1 then
   begin
    if Where=0 then j:=0 else j:=Where-1;
    while (j<>FDataCount) and (Result=-1) do
     begin
      if f[j]<>-1 then
        Result:=FContentMap[f[j]+cmDelta+j]+Index-1;
      if Where=0 then inc(j) else j:=FDataCount;
     end;
   end;
end;

function TDiffSet.LineText(Index: integer): string;
var
  c,i,ix:integer;
begin
  c:=IndexToContentMapIndex(Index);
  if c=-1 then Result:='' else
   begin
    i:=0;
    while (i<>FDataCount) and ((FContentMap[c+cmBitMask] and (1 shl i))=0) do inc(i);
    if i=FDataCount then Result:='' else
     begin
      ix:=Index-FContentMap[c+cmDelta+i];
      Result:=Copy(Data[i].FContentData
        ,Data[i].FContent[ix].Index
        ,Data[i].FContent[ix].Length);
     end;
   end;  
end;

function TDiffSet.DetectXML(const FilePath: string): boolean;
var
  r:TRegistry;
  i:integer;
  s:string;
begin
  if XmlDomTree then
    Result:=true
  else
    if XmlAutoDetect then
     begin
      //Result:=LowerCase(copy(fn,Length(fn)-3,4))='.xml';
      Result:=false;//default
      i:=Length(FilePath);
      while not(i=0) and not(FilePath[i]='.') do dec(i);
      s:=LowerCase(Copy(FilePath,i,Length(FilePath)-i+1));
      r:=TRegistry.Create;
      try
        r.RootKey:=HKEY_CLASSES_ROOT;
        if r.OpenKey(s,false) then
          if r.ValueExists('Content Type') then
            Result:=r.ReadString('Content Type')='text/xml';
      finally
        r.Free;
      end
     end
    else
      Result:=false;
end;

function TDiffSet.ReworkXML(const SourceData: UTF8String): UTF8String;
var
  re,reEOL,reAttrs:RegExp;
  ml,mlEOL:MatchCollection;
  m,m2,mEOL:Match;
  i,j,p,l:integer;
  w:WideString;
  px:string;
  procedure sAdd(xx:Utf8String);
  begin
    Result:=Result+xx+#13#10;
  end;
  function Prefix:string;
  var
    prefix_i:integer;
  begin
    prefix_i:=0;
    if XmlIndent then
      if WideTabs then prefix_i:=l*8 else prefix_i:=l*4;
    SetLength(Result,prefix_i);
    FillChar(Result[1],prefix_i,' ');
  end;
  procedure DoOpeningTag(x,y:WideString);
  var
    ml:MatchCollection;
    m:Match;
    px:string;
    i:integer;
  begin
    px:=Prefix;
    if XmlAttrOnLine and not((Length(x)>1) and (char(x[2]) in ['!','?'])) then
     begin
      ml:=reAttrs.Execute(x) as MatchCollection;
      if ml.Count=0 then
        sAdd(px+x+y)
      else
       begin
        //j:=1;
        //if XmlIgnoreAttSeq1 then sort? when right match using left?
        for i:=0 to ml.Count-1 do
         begin
          m:=ml.Item[i] as Match;
          if i=0 then sAdd(px+Copy(x,1,m.FirstIndex-1));
          sAdd(px+'  '+m.Value);
          //j:=m.FirstIndex+m.Length+1;
         end;
        if y='' then //empty tag
         begin
          //sAdd(px+'  '+Copy(x,j,Length(x)-j-1));
          sAdd(px+Copy(x,Length(x)-1,2)+y);
         end
        else
         begin
          //sAdd(px+'  '+Copy(x,j,Length(x)-j));
          sAdd(px+x[Length(x)]+y);
         end;
       end;
     end
    else
      sAdd(px+x+y);
  end;
var
  src:WideString;
begin
  //TODO: rewrite using msxml
  re:=CoRegExp.Create;
  re.IgnoreCase:=true;
  re.Global:=true;
  re.Multiline:=false;
  re.Pattern:='<[^>]+?>';

  reEOL:=CoRegExp.Create;
  reEOL.Global:=true;
  reEOL.Multiline:=false;//??
  reEOL.Pattern:='\r\n';

  reAttrs:=CoRegExp.Create;
  reAttrs.Global:=true;
  reAttrs.Multiline:=false;
  reAttrs.Pattern:='\S+?=("[^"]+?"|''[^'']+?''|\S+)';

  try
    Result:='';
    src:=UTF8Decode(SourceData);
    ml:=re.Execute(src) as MatchCollection;

    p:=1;
    l:=0;
    i:=0;
    while i<ml.Count do
     begin
      m:=ml.Item[i] as Match;
      w:=Trim(copy(src,p,m.FirstIndex+1-p));
      if w<>'' then sAdd(Prefix+w);
      p:=m.FirstIndex+m.Length+1;
      if (m.Value[2]='?') or (m.Value[2]='!') or (m.Value[m.Length-1]='/') then
        DoOpeningTag(m.Value,'')
      else
       begin
        if m.Value[2]='/' then
         begin
          //closing tag
          dec(l);
          sAdd(Prefix+m.Value);
         end
        else
         begin
          //opening tag, check next
          if (i+1<ml.Count) and ((ml.Item[i+1] as Match).Value[2]='/') then
           begin
            //next one is closing, so single line
            m2:=ml.Item[i+1] as Match;
            w:=copy(src,p,m2.FirstIndex+1-p);
            if XmlCollapseEmpty and (w='') then
              DoOpeningTag(Copy(m.Value,1,m.Length-1)+'/>','')
            else
              if reEOL.Test(w) then
               begin
                mlEOL:=reEOL.Execute(w) as MatchCollection;
                DoOpeningTag(m.Value,'');
                inc(l);
                px:=Prefix;
                p:=1;
                for j:=0 to mlEOL.Count-1 do
                 begin
                  mEOL:=mlEOL.Item[j] as Match;
                  sAdd(px+copy(w,p,mEOL.FirstIndex+1-p));
                  p:=mEOL.FirstIndex+mEOL.Length+1;
                 end;
                dec(l);
                sAdd(Prefix+m2.Value);
               end
              else
                DoOpeningTag(m.Value,w+m2.Value);
            p:=m2.FirstIndex+m2.Length+1;
            inc(i);
           end
          else
           begin
            DoOpeningTag(m.Value,'');
            inc(l);
           end;
         end;
       end;
      inc(i);
     end;
    w:=Trim(copy(src,p,Length(src)-p+1));
    if w<>'' then sAdd(Prefix+w);
  finally
    ml:=nil;
    m:=nil;
    m2:=nil;
    re:=nil;
    reEOL:=nil;
    reAttrs:=nil;
  end;
end;

function TDiffSet.XmlDisplay(x: IXMLDOMNode): string;
var
  i:integer;
begin
  case x.nodeType of
    NODE_TEXT:Result:='#text';
    NODE_CDATA_SECTION:Result:='#data';
    NODE_COMMENT:Result:='#comment';
    //NODE_PROCESSING_INSTRUCTION:=Result:='<??>';//?
    else
     begin
      if XmlDetectNS then
        Result:=x.baseName
      else
        Result:=x.nodeName;
      if (x.attributes<>nil) and (x.attributes.length<>0) then
        for i:=0 to x.attributes.length-1 do
          if XmlDefiningArributes.IndexOf(x.attributes[i].nodeName)<>-1 then
            Result:=Result+' '+x.attributes[i].xml;
     end;
  end;
end;

function TDiffSet.XmlMatch(x: IXMLDOMNode): string;
begin
  if x=nil then Result:='' else
    if XmlIgnoreCData and (x.nodeType in [NODE_TEXT,NODE_CDATA_SECTION]) then
      Result:='#'
    else
      if XmlDetectNS then
        Result:=IntToHex(x.nodeType,8)+':'+x.namespaceURI+':'+XmlDisplay(x)
      else
        Result:=IntToHex(x.nodeType,8)+':'+XmlDisplay(x);
end;

procedure TDiffSet.DropData(Index: integer);
var
  i:integer;
begin
  i:=Index;
  dec(FDataCount);
  FData[i].Free;
  while i<FDataCount do
   begin
    FData[i]:=FData[i+1];
    inc(i);
   end;
  FData[i]:=nil;
end;

procedure TDiffSet.PerformSubDiffs;
var
  lx,cx,dx,bm,mi,ni,sx,si,sl,i,j,la,lb,
  ai,ax,ay,e1,e2,f1,f2:integer;
  ss:array of record
    bm:integer;
    t:string;
  end;
  sa,sb:string;
const
  sGrowStep=$100;
begin
  lx:=FLoadIndex;
  //TODO: expand into full diff on sequence of bytes (see ddDiff.pas)
  if FSubDiffsSize=0 then
   begin
    inc(FSubDiffsSize,$1000);
    SetLength(FSubDiffs,FSubDiffsSize);
   end;
  sl:=0;
  sx:=2;//skip '0'
  cx:=0;
  while cx<>FContentMapCount do
   begin
    while (cx<>FContentMapCount) and
      (FContentMap[cx+cmBitMask]=(1 shl FDataCount)-1) do
      inc(cx,FContentMapStride);
    dx:=cx;
    si:=0;
    while (cx<>FContentMapCount) and
      (FContentMap[cx+cmBitMask]<>(1 shl FDataCount)-1) do
     begin
      bm:=FContentMap[cx+cmBitMask];
      ai:=0;
      while (ai<>FDataCount) and ((bm and (1 shl ai))=0) do inc(ai);
      ax:=FContentMap[cx]-FContentMap[cx+cmDelta+ai];
      ay:=FContentMap[cx+FContentMapStride]-FContentMap[cx+cmDelta+ai];
      for i:=ax to ay-1 do
       begin
        if si=sl then
         begin
          inc(sl,sGrowStep);
          SetLength(ss,sl);
         end;
        ss[si].bm:=bm;
        ss[si].t:=ExpandTabs(Copy(Data[ai].FContentData
            ,Data[ai].FContent[i].Index
            ,Data[ai].FContent[i].Length));
        inc(si);
       end;
      inc(cx,FContentMapStride);
     end;
    if IgnoreCase then
      for i:=0 to si-1 do ss[i].t:=UpperCase(ss[i].t);
    mi:=FContentMap[dx];
    ni:=mi;
    i:=0;
    while (i<>si) do
     begin
      e1:=0;
      e2:=0;
      sa:=ss[i].t;
      la:=Length(sa);
      for j:=0 to si-1 do
        if (ss[i].bm and ss[j].bm)=0 then
         begin
          sb:=ss[j].t;
          lb:=Length(sb);
          f1:=0;
          while (f1<la) and (f1<lb) and
            (sa[1+f1]=sb[1+f1]) do inc(f1);
          f2:=0;
          while (f2<la-f1) and (f2<lb-f1) and
            (sa[la-f2]=sb[lb-f2]) do inc(f2);
          if f1+f2>e1+e2 then
           begin
            e1:=f1;
            e2:=f2;
           end;
         end;
      if lx<>FLoadIndex then Exit;
      if mi=ni then
       begin
        FContentMap[dx+cmSubDiffs]:=sx;
        inc(dx,FContentMapStride);
        mi:=FContentMap[dx];
       end;
      inc(ni);
      if sx=FSubDiffsSize then
       begin
        inc(FSubDiffsSize,$1000);
        SetLength(FSubDiffs,FSubDiffsSize);
       end;
      FSubDiffs[sx]:=e1;
      FSubDiffs[sx+1]:=e2;
      inc(sx,2);
      inc(i);
     end;
    //TODO: invalidate view when first visible lines reached?
   end;

  if sx<>2 then PostMessage(FParent,WM_QUEUEINFO,1,0);//invalidate view
end;

{ TDiffFileInfo }

constructor TDiffFileInfo.Create(SetSize: integer);
var
  i:integer;
begin
  inherited Create;
  SetLength(Info,SetSize);
  for i:=0 to SetSize-1 do Info[i].Name:='';
end;

function TDiffFileInfo.GetIconIndex(IgnoreDates:boolean): integer;
var
  l:integer;
begin
  l:=Length(Info);
  if IsDir then
    if l=1 then
      Result:=iiDirEqual
    else
      if Info[0].Name<>'' then
        if Info[1].Name<>'' then
          if IgnoreDates then
            Result:=iiDirEqual//iiDirUnequal?
          else if Info[0].LastMod<Info[1].LastMod then
            Result:=iiDirRightNewer
          else if Info[0].LastMod=Info[1].LastMod then
            Result:=iiDirEqual
          else //if Info[0].LastMod>Info[1].LastMod then
            Result:=iiDirLeftNewer
        else
          Result:=iiDirOnlyLeft
      else
        if Info[1].Name<>'' then
          Result:=iiDirOnlyRight
        else
          Result:=iiDirNone
  else
    if l=1 then
      Result:=iiFileEqual
    else
      if Info[0].Name<>'' then
        if Info[1].Name<>'' then
          if IgnoreDates then
            if Info[0].FileSize<Info[1].FileSize then
              Result:=iiFileRightLarger
            else if Info[0].FileSize=Info[1].FileSize then
              Result:=iiFileComparing//...
            else //if Info[0].FileSize>Info[1].FileSize then
              Result:=iiFileLeftLarger
          else
            if Info[0].FileSize<Info[1].FileSize then
              if Info[0].LastMod<Info[1].LastMod then
                Result:=iiFileRightNewerLarger
              else if Info[0].LastMod=Info[1].LastMod then
                Result:=iiFileRightLarger
              else //if Info[0].LastMod>Info[1].LastMod then
                Result:=iiFileLeftNewerSmaller
            else if Info[0].FileSize=Info[1].FileSize then
              if Info[0].LastMod<Info[1].LastMod then
                Result:=iiFileRightNewer
              else if Info[0].LastMod=Info[1].LastMod then
                Result:=iiFileComparing//...
              else //if Info[0].LastMod>Info[1].LastMod then
                Result:=iiFileLeftNewer
            else //if Info[0].FileSize>Info[1].FileSize then
              if Info[0].LastMod<Info[1].LastMod then
                Result:=iiFileRightNewerSmaller
              else if Info[0].LastMod=Info[1].LastMod then
                Result:=iiFileLeftLarger
              else //if Info[0].LastMod>Info[1].LastMod then
                Result:=iiFileLeftNewerLarger
        else
          Result:=iiFileOnlyLeft
      else
        if Info[1].Name<>'' then
          Result:=iiFileOnlyRight
        else
          Result:=iiFileNone
  ;
  //TODO: l>2?
end;

{ TDiffRunner }

constructor TDiffRunner.Create(Owner: TDiffSet);
begin
  inherited Create(false);
  FOwner:=Owner;
  FEvent:=CreateEvent(nil,false,false,nil);
  Job:=dj_None;
  Index:=0;
end;

destructor TDiffRunner.Destroy;
begin
  CloseHandle(FEvent);
  inherited;
end;

procedure TDiffRunner.Execute;
begin
  CoInitialize(nil);
  while not Terminated do
    try
      if not FOwner.PerformJob(Self) then
       begin
        //Suspend;
        ResetEvent(FEvent);
        WaitForSingleObject(FEvent,INFINITE);
       end;
    except
      //TODO: on e:Exception do...
    end;
end;

procedure TDiffRunner.Fire;
begin
  SetEvent(FEvent);
end;

end.
