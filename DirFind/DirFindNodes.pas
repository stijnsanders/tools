unit DirFindNodes;

interface

uses ComCtrls, DirFindWorker;

type
  TDirFindTreeNode=class(TTreeNode)//abstract
  public
    function ProgressText:string; virtual;
    procedure DoDblClick; virtual;
  end;

  TDirFinderNodeProgress=procedure(Sender:TObject;
    const PrgTxt:string) of object;

  TDirFinderNode=class(TDirFindTreeNode)
  private
    FDirFinder:TDirFinder;
    FRootPath,FFiles,FNotFiles,FPattern,FProgressText:string;
    FIgnoreCase,FMultiLine:boolean;
    FCountMatches:TDirFinderCountMatches;
    FTotalFilesFound:integer;
    FTotalFinds:array of integer;
    FOnProgress:TDirFinderNodeProgress;
  public
    procedure Start(const Folder,Files,NotFiles,Pattern:string;
      IgnoreCase,MultiLine:boolean;CountMatches:TDirFinderCountMatches);
    procedure FinderNotify(nm:TDirFinderNotifyMessage;
      const msg:string;const vals:array of integer);
    destructor Destroy; override;
    procedure Abort;
    procedure Refresh;
    function ReplaceAll(const ReplaceWith:WideString):integer;
    property OnProgress:TDirFinderNodeProgress
      read FOnProgress write FOnProgress;
    property Pattern:string read FPattern;
    property RootPath:string read FRootPath;
    function ProgressText:string; override;
    function IsFinding:boolean;
    function AllFilePaths:string;
  end;

  TDirFindFolderNode=class(TDirFindTreeNode)
  private
    FMatchingFiles,FFolders:integer;
    FMatches:array of integer;
    procedure IncMatches(const vals:array of integer);
  public
    FolderName:string;
    procedure AfterConstruction; override;
    procedure SetPrioFolder;
    function FolderPath:string;
    function ProgressText:string; override;
  end;

  TDirFindMatchNode=class(TDirFindTreeNode)
  private
    FFilePath:string;
    FLines:integer;
    FMatchingLinesLoaded:boolean;
  public
    procedure AfterConstruction; override;
    function ProgressText:string; override;
    procedure DoDblClick; override;
    property FilePath:string read FFilePath;
    property Lines:integer read FLines;
  end;

  TDirFindLineNode=class(TDirFindTreeNode)
  private
    FLineNumber,FIndentLevel:integer;
    procedure UpdateIcons;
  public
    procedure DoDblClick; override;
    property LineNumber:integer read FLineNumber;
  end;

var
  DirFindNextNodeClass:TTreeNodeClass;
  IndentLevelTabSize:integer;

implementation

uses SysUtils, Classes, VBScript_RegExp_55_TLB;

const
  NodeTextSeparator=#$95;//'  ';
  NodeTextProgress='...';
  NodeTextMatchCount=#$B7;//':';
  NodeTextSubMatchCount=' \';

  iiFolder=0;
  iiFolderWorking=1;
  iiFile=2;
  iiFolderGray=3;
  iiError=4;
  iiLineMatch=5;
  iiFileMulti=6;//..6+7
  iiLineMatchMulti=14;//..14+7
  iiLine=22;
  iiLineNeighboursLoaded=23;

function IndentLevel(var w:WideString):integer;
var
  i,j,k,l:integer;
  x:WideString;
  y:boolean;
begin
  i:=1;
  j:=1;
  Result:=0;
  x:=w;
  y:=true;
  l:=Length(x);
  k:=l;
  while i<=l do
   begin
    if x[i]=#9 then
     begin
      if j+IndentLevelTabSize>=k then
       begin
        inc(k,$100);
        SetLength(w,k);
       end;
      w[j]:=#32;
      inc(j);
      while ((j-1) mod IndentLevelTabSize)<>0 do
       begin
        w[j]:=#32;
        inc(j);
       end;
      if y then Result:=j-1;
     end
    else
     begin
      if y then if x[i]=#32 then inc(Result) else y:=false;
      if j=k then
       begin
        inc(k,$100);
        SetLength(w,k);
       end;
      w[j]:=x[i];
      inc(j);
     end;
    inc(i);
   end;
  SetLength(w,j-1);
end;

{ TDirFindTreeNode }

procedure TDirFindTreeNode.DoDblClick;
begin
  //
end;

function TDirFindTreeNode.ProgressText: string;
begin
  Result:=Text;//inheritants don't need to call inherited
end;

{ TDirFinderNode }

destructor TDirFinderNode.Destroy;
begin
  if FDirFinder<>nil then FDirFinder.Terminate;
  inherited;
end;

procedure TDirFinderNode.FinderNotify(nm: TDirFinderNotifyMessage;
  const msg: string; const vals: array of integer);
var
  tn:TTreeNode;
  procedure FindNode(IsFile:boolean);
  var
    tn1:TTreeNode;
    i,j,k:integer;
    s:string;
  begin
    tn:=Self;
    i:=Length(FRootPath)+2;
    while (i<=Length(msg)) do
     begin
      j:=i;
      while (j<=Length(msg)) and (msg[j]<>'\') do inc(j);
      if IsFile and (j>Length(msg)) then
       begin
        s:=Copy(msg,i,j-i);
        tn1:=tn.getFirstChild;
        while (tn1<>nil) and (tn1 is TDirFindFolderNode) do
          tn1:=tn1.getNextSibling;
        while (tn1<>nil) and (CompareText(tn1.Text,s)<0) do
          tn1:=tn1.getNextSibling;
        //assert doesn't exist already, only one FindNode(true) call
        case FCountMatches of
          ncMatches:
            s:=s+NodeTextSeparator+IntToStr(vals[0]);//assert(Length(vals)=1)
          ncSubMatches:
            if Length(vals)>0 then
              if Length(vals)>3 then
               begin
                s:=s+NodeTextSeparator+IntToStr(vals[0]);
                for k:=1 to Length(vals)-1 do
                  s:=s+NodeTextSubMatchCount+IntToStr(k)+'='+IntToStr(vals[k]);
               end
              else
               begin
                s:=s+NodeTextSeparator+IntToStr(vals[0]);
                for k:=1 to Length(vals)-1 do
                  s:=s+NodeTextMatchCount+IntToStr(vals[k]);
               end;
        end;
        DirFindNextNodeClass:=TDirFindMatchNode;
        if tn1=nil then
          tn1:=Owner.AddChild(tn,s)
        else
          tn1:=Owner.Insert(tn1,s);
        (tn1 as TDirFindMatchNode).FFilePath:=msg;
       end
      else
       begin
        s:='\'+Copy(msg,i,j-i);
        tn1:=tn.getFirstChild;
        while (tn1<>nil) and (tn1 is TDirFindFolderNode) and
          (CompareText((tn1 as TDirFindFolderNode).FolderName,s)<0) do tn1:=tn1.getNextSibling;
        if (tn1=nil) or not(tn1 is TDirFindFolderNode) or
          ((tn1 as TDirFindFolderNode).FolderName<>s) then
         begin
          DirFindNextNodeClass:=TDirFindFolderNode;
          if tn1=nil then
            tn1:=Owner.AddChild(tn,s+NodeTextProgress)
          else
            tn1:=Owner.Insert(tn1,s+NodeTextProgress);
          (tn1 as TDirFindFolderNode).FolderName:=s;
          if tn<>Self then inc((tn as TDirFindFolderNode).FFolders);
         end;
       end;
      i:=j+1;
      tn:=tn1;
     end;
  end;
var
  tn1:TTreeNode;
  s1:string;
  k,l:integer;
begin
  case nm of
    nmDone:
     begin
      FDirFinder:=nil;
      if ImageIndex<>iiFolderGray then //see nmError below
       begin
        ImageIndex:=iiFolder;
        SelectedIndex:=iiFolder;
       end;
      case FCountMatches of
        ncFiles:
          s1:=IntToStr(FTotalFinds[0]);
        ncMatches://assert(Length(FTotalFinds)=1)
          s1:=IntToStr(FTotalFilesFound)+NodeTextMatchCount+IntToStr(FTotalFinds[0]);
        ncSubMatches:
         begin
          s1:=IntToStr(FTotalFilesFound);
          if Length(FTotalFinds)>3 then
           begin
            s1:=s1+NodeTextMatchCount+IntToStr(FTotalFinds[0]);
            for k:=1 to Length(FTotalFinds)-1 do
              s1:=s1+NodeTextSubMatchCount+IntToStr(k)+'='+IntToStr(FTotalFinds[k]);
           end
          else
            for k:=0 to Length(FTotalFinds)-1 do
              s1:=s1+NodeTextMatchCount+IntToStr(FTotalFinds[k]);
         end;
      end;
      FProgressText:=FRootPath+NodeTextSeparator+s1+NodeTextSeparator+
        FPattern+NodeTextSeparator+FFiles+NodeTextSeparator+FNotFiles;
      Text:=FProgressText;
      if @FOnProgress<>nil then FOnProgress(Self,FProgressText);
     end;
    nmError:
     begin
      DirFindNextNodeClass:=TTreeNode;//TDirFindErrorNode?
      ImageIndex:=iiFolderGray;
      SelectedIndex:=iiFolderGray;
      tn:=Owner.AddChild(Self,msg);
      tn.ImageIndex:=iiError;
      tn.SelectedIndex:=iiError;
     end;
    nmFolderFound:
     begin
      FindNode(false);
      tn.ImageIndex:=iiFolderWorking;
      tn.SelectedIndex:=iiFolderWorking;
     end;
    nmProgress:
     begin
      FProgressText:=NodeTextProgress+msg;
      if @FOnProgress<>nil then FOnProgress(Self,FProgressText);
     end;
    nmFolderDone:
     begin
      FindNode(false);
      while tn<>Self do
       begin
        if tn.Count=0 then
         begin
          tn1:=tn.Parent;
          tn.Delete;
          tn:=tn1;
         end
        else
          if (tn as TDirFindFolderNode).FFolders=0 then
           begin
            tn.ImageIndex:=iiFolder;
            tn.SelectedIndex:=iiFolder;
            tn:=tn.Parent;
           end
          else
            tn:=Self;
        if tn<>Self then dec((tn as TDirFindFolderNode).FFolders);
       end;
     end;
    nmMatchFound:
     begin
      FindNode(true);
      tn.ImageIndex:=iiFile;
      tn.SelectedIndex:=iiFile;
      inc(FTotalFilesFound);
      k:=Length(FTotalFinds);
      l:=Length(vals);
      if k<l then
       begin
        SetLength(FTotalFinds,l);
        while k<l do
         begin
          FTotalFinds[k]:=0;
          inc(k);
         end;
       end;
      for k:=0 to l-1 do
        inc(FTotalFinds[k],vals[k]);
      tn:=tn.Parent;
      while (tn<>nil) and (tn<>Self) do
       begin
        (tn as TDirFindFolderNode).IncMatches(vals);
        tn:=tn.Parent;
       end;
     end;
  end;
end;

procedure TDirFinderNode.Start(const Folder, Files, NotFiles, Pattern: string;
  IgnoreCase, MultiLine: boolean; CountMatches: TDirFinderCountMatches);
var
  i:integer;
begin
  //assert called once, short after add/create
  FRootPath:=Folder;
  FFiles:=Files;
  FNotFiles:=NotFiles;
  FPattern:=Pattern;
  FIgnoreCase:=IgnoreCase;
  FMultiLine:=MultiLine;
  FCountMatches:=CountMatches;
  FProgressText:=NodeTextProgress+Folder;
  i:=Length(FRootPath);
  if (i<>0) and (FRootPath[i]='\') then SetLength(FRootPath,i-1);
  FDirFinder:=nil;
  Refresh;
end;

procedure TDirFinderNode.Refresh;
begin
  if FDirFinder<>nil then FDirFinder.Terminate;
  DeleteChildren;
  ImageIndex:=iiFolderWorking;
  SelectedIndex:=iiFolderWorking;
  FTotalFilesFound:=0;
  SetLength(FTotalFinds,1);
  FTotalFinds[0]:=0;
  Text:=FRootPath+NodeTextSeparator+NodeTextProgress+NodeTextSeparator+
    FPattern+NodeTextSeparator+FFiles+NodeTextSeparator+FNotFiles;
  FDirFinder:=TDirFinder.Create(FRootPath,FFiles,FNotFiles,FPattern,
    FIgnoreCase,FMultiLine,FCountMatches,FinderNotify);
  //assert notifies nmDone when done
end;

procedure TDirFinderNode.Abort;
begin
  if FDirFinder<>nil then
   begin
    FDirFinder.Terminate;
    FinderNotify(nmError,'Aborted by user',[]);
    FinderNotify(nmDone,'',[-1]);
   end;
end;

function TDirFinderNode.ProgressText: string;
begin
  Result:=FProgressText;
end;

function TDirFinderNode.IsFinding: boolean;
begin
  Result:=FDirFinder<>nil;
end;

function TDirFinderNode.ReplaceAll(const ReplaceWith: WideString): integer;
var
  re:RegExp;
  tn,tnLast:TTreeNode;
  enc:TFileEncoding;
  fn:string;
  s:RawByteString;
  w:WideString;
  f:TFileStream;
const
  BOMUtf16=#$FF#$FE;
  BOMUtf8=#$EF#$BB#$BF;
begin
  //assert FDirFinder=nil, checked so by caller
  re:=CoRegExp.Create;
  re.Pattern:=FPattern;
  re.IgnoreCase:=FIgnoreCase;
  re.Multiline:=FMultiLine;
  re.Global:=true;

  Result:=0;
  Owner.BeginUpdate;
  try
    tn:=Self.getFirstChild;
    tnLast:=Self.getNextSibling;
    while (tn<>tnLast) do
     begin
      if (tn is TDirFindMatchNode) then
       begin
        if tn.Count<>0 then tn.DeleteChildren;//reset any matching lines shown

        fn:=(tn as TDirFindMatchNode).FilePath;
        w:=re.Replace(FileAsWideString(fn,enc),ReplaceWith);
        f:=TFileStream.Create(fn,fmCreate);
        try
          case enc of
            feUtf16:
             begin
              f.Write(BOMUtf16[1],2);
              f.Write(w[1],Length(w)*2);
             end;
            feUtf8:
             begin
              s:=UTF8Encode(w);
              f.Write(BOMUtf8[1],3);
              f.Write(s[1],Length(s));
             end;
            else//feUnknown
             begin
              s:=AnsiString(w);
              f.Write(s[1],Length(s));
             end;
          end;
        finally
          f.Free;
        end;
        inc(Result);

       end;
      tn:=tn.GetNext;
     end;
  finally
    Owner.EndUpdate;
  end;
end;

function TDirFinderNode.AllFilePaths: string;
var
  n,n1:TTreeNode;
begin
  Result:='';
  n1:=getNextSibling;
  n:=Self;
  while n<>n1 do
   begin
    if n is TDirFindMatchNode then
      Result:=Result+(n as TDirFindMatchNode).FilePath+#13#10;
    n:=n.GetNext;
   end;
end;

{ TDirFindFolderNode }

procedure TDirFindFolderNode.AfterConstruction;
begin
  inherited;
  FMatches:=nil;//SetLength(FMatches,0);
  FFolders:=0;
end;

procedure TDirFindFolderNode.IncMatches(const vals:array of integer);
var
  k,l:integer;
  s:string;
begin
  inc(FMatchingFiles);
  k:=Length(FMatches);
  l:=Length(vals);
  if k<l then
   begin
    SetLength(FMatches,l);
    while k<l do
     begin
      FMatches[k]:=0;
      inc(k);
     end;
   end;
  for k:=0 to l-1 do inc(FMatches[k],vals[k]);
  //case FCountMatches of
  if (Length(FMatches)=0) or ((Length(FMatches)=1) and (FMatches[0]=FMatchingFiles)) then
    s:=FolderName+NodeTextSeparator+IntToStr(FMatchingFiles)
  else
   begin
    s:=FolderName+NodeTextSeparator+IntToStr(FMatchingFiles);
    if Length(FMatches)>3 then
     begin
      s:=s+NodeTextMatchCount+IntToStr(FMatches[0]);
      for k:=1 to l-1 do
        s:=s+NodeTextSubMatchCount+IntToStr(k)+'='+IntToStr(FMatches[k]);
     end
    else
      for k:=0 to l-1 do
        s:=s+NodeTextMatchCount+IntToStr(FMatches[k]);
   end;
  Text:=s;
end;

function TDirFindFolderNode.ProgressText: string;
begin
  Result:=FolderPath;
end;

function TDirFindFolderNode.FolderPath: string;
var
  tn:TTreeNode;
begin
  tn:=Self;
  Result:='';
  while tn is TDirFindFolderNode do
   begin
    Result:=(tn as TDirFindFolderNode).FolderName+Result;
    tn:=tn.Parent;
   end;
  Result:=(tn as TDirFinderNode).RootPath+Result;//+NodeTextSeparator+IntToStr?
end;

procedure TDirFindFolderNode.SetPrioFolder;
var
  tn:TTreeNode;
  s:string;
begin
  tn:=Self;
  s:='';
  while (tn<>nil) and (tn is TDirFindFolderNode) do
   begin
    s:=(tn as TDirFindFolderNode).FolderName+s;
    tn:=tn.Parent;
   end;
  if (tn as TDirFinderNode).FDirFinder<>nil then
    (tn as TDirFinderNode).FDirFinder.PrioFolder:=s;
end;

{ TDirFindMatchNode }

procedure TDirFindMatchNode.AfterConstruction;
begin
  inherited;
  //FFilePath:=//? see where created
  FMatchingLinesLoaded:=false;
  FLines:=-1;//see DoDblClick
end;

function TDirFindMatchNode.ProgressText: string;
begin
  Result:=FFilePath;//TODO: file size? last modified date?
end;

procedure TDirFindMatchNode.DoDblClick;
var
  re:RegExp;
  mc:MatchCollection;
  m1:Match;
  i,j,l,k,m,n:integer;
  w,w1:WideString;
  tn:TTreeNode;
  enc:TFileEncoding;
begin
  if not(FMatchingLinesLoaded) then
   begin
    w:=FileAsWideString(FilePath,enc);

    tn:=Self;
    while not(tn is TDirFinderNode) do tn:=tn.Parent;
    re:=CoRegExp.Create;
    re.Pattern:=(tn as TDirFinderNode).FPattern;
    re.IgnoreCase:=(tn as TDirFinderNode).FIgnoreCase;
    re.Multiline:=(tn as TDirFinderNode).FMultiLine;
    re.Global:=true;

    mc:=re.Execute(w) as MatchCollection;
    //first match
    n:=0;
    if mc.Count=0 then m1:=nil else m1:=mc.Item[0] as Match;

    DirFindNextNodeClass:=TDirFindLineNode;
    Owner.BeginUpdate;
    try
      i:=1;
      k:=1;
      l:=Length(w);
      while i<=l do
       begin
        j:=i;
        while (j<=l) and (w[j]<>#13) and (w[j]<>#10) do inc(j);

        if (m1<>nil) and (m1.FirstIndex>=i-1) and (m1.FirstIndex<j-1) then
         begin
          //show line
          w1:=Copy(w,i,j-i);//TODO: expand tabs
          m:=IndentLevel(w1);
          tn:=Owner.AddChild(Self,Format('%.6d',[k])+NodeTextSeparator+w1);
          tn.ImageIndex:=iiLineMatch;
          tn.SelectedIndex:=iiLineMatch;
          (tn as TDirFindLineNode).FLineNumber:=k;
          (tn as TDirFindLineNode).FIndentLevel:=m;
          //next match
          while (m1<>nil) and (m1.FirstIndex<j-1) do
           begin
            inc(n);
            if mc.Count=n then m1:=nil else m1:=mc.Item[n] as Match;
           end;
         end;

        if (j<l) and (w[j]=#13) and (w[j+1]=#10) then inc(j);
        i:=j+1;
        inc(k);
       end;
      FLines:=k-1;//for TDirFindLineNode.DoDblClick iiLineNeighboursLoaded

      Expand(false);
    finally
      Owner.EndUpdate;
    end;

    FMatchingLinesLoaded:=true;
   end;
end;

{ TDirFindLineNode }

procedure TDirFindLineNode.DoDblClick;
const
  IndentSeekMax=128;
var
  i,j,k,l,m:integer;
  w,w1:WideString;
  tn:TTreeNode;
  s:string;
  MaxLineIndentLevel:array[0..IndentSeekMax-1] of record
    LineNumber,IndentLevel:integer;
    LineText:WideString;
  end;
  procedure AddLine;
  begin
    tn:=Self;
    if (k<FLineNumber) then
      while (tn<>nil) and ((tn as TDirFindLineNode).FLineNumber>k) do
        tn:=tn.getPrevSibling
    else
      while (tn<>nil) and ((tn as TDirFindLineNode).FLineNumber<k) do
        tn:=tn.getNextSibling;
    if (tn=nil) or ((tn as TDirFindLineNode).FLineNumber<>k) then
     begin
      s:=Format('%.6d',[k])+NodeTextSeparator+w1;
      if k<FLineNumber then
        if tn=nil then
          tn:=Owner.AddChildFirst(Self.parent,s)
        else
          tn:=Owner.Insert(tn.getNextSibling,s)
      else
        if tn=nil then
          tn:=Owner.AddChild(Parent,s)
        else
          tn:=Owner.Insert(tn,s);
      tn.ImageIndex:=iiLine;
      tn.SelectedIndex:=iiLine;
      (tn as TDirFindLineNode).FLineNumber:=k;
      (tn as TDirFindLineNode).FIndentLevel:=m;
     end;
  end;
var
  enc:TFileEncoding;
begin
  for i:=0 to IndentSeekMax-1 do MaxLineIndentLevel[i].LineNumber:=-1;
  w:=FileAsWideString((Parent as TDirFindMatchNode).FilePath,enc);

  tn:=Self;
  while not(tn is TDirFinderNode) do tn:=tn.Parent;

  DirFindNextNodeClass:=TDirFindLineNode;
  Owner.BeginUpdate;
  try
    //find lines
    i:=1;
    k:=1;
    l:=Length(w);
    while i<=l do
     begin
      j:=i;
      while (j<=l) and (w[j]<>#13) and (w[j]<>#10) do inc(j);

      w1:=Copy(w,i,j-i);//TODO: expand tabs
      m:=IndentLevel(w1);
      if (k<FLineNumber) and (i<>j) then
       begin
        if (m<FIndentLevel) and (m<IndentSeekMax) then
         begin
          MaxLineIndentLevel[m].LineNumber:=k;
          MaxLineIndentLevel[m].IndentLevel:=m;
          MaxLineIndentLevel[m].LineText:=w1;
         end;
       end;
      if ((k>=FLineNumber-5) and (k<FLineNumber)) or
         ((k>FLineNumber) and (k<=FLineNumber+5)) then
        AddLine;

      if (j<l) and (w[j]=#13) and (w[j+1]=#10) then inc(j);
      i:=j+1;
      inc(k);
      if k>FLineNumber+5 then i:=l+1;//skip remainder
     end;

    //lines of lower indent
    i:=0;
    j:=-1;
    while (i<FIndentLevel) and (i<IndentSeekMax) do
     begin
      if MaxLineIndentLevel[i].LineNumber>j then
       begin
        j:=MaxLineIndentLevel[i].LineNumber;
        m:=MaxLineIndentLevel[i].IndentLevel;
        w1:=MaxLineIndentLevel[i].LineText;
        k:=j;
        AddLine;
       end;
      inc(i);
     end;

    UpdateIcons;
    Expand(false);
  finally
    Owner.EndUpdate;
  end;
end;

procedure TDirFindLineNode.UpdateIcons;
var
  tn0,tn1,tn2:TDirFindLineNode;
  ml:integer;
begin
  ml:=(Parent as TDirFindMatchNode).Lines;
  tn0:=nil;
  tn1:=Self.Parent.getFirstChild as TDirFindLineNode;
  tn2:=(tn1.getNextSibling) as TDirFindLineNode;
  while tn1<>nil do
   begin
    if (tn1.ImageIndex=iiLine) and
      (((tn0=nil) and (tn1.LineNumber=1)) or
        ((tn0<>nil) and (tn0.LineNumber=tn1.LineNumber-1))) and
      (((tn2=nil) and (tn1.LineNumber>=ml)) or
        (((tn2<>nil) and (tn2.LineNumber=tn1.LineNumber+1)))) then
     begin
      tn1.ImageIndex:=iiLineNeighboursLoaded;
      tn1.SelectedIndex:=iiLineNeighboursLoaded;
     end;
    tn0:=tn1;
    tn1:=tn2;
    if tn2<>nil then tn2:=(tn2.getNextSibling) as TDirFindLineNode;
   end;
end;

initialization
  IndentLevelTabSize:=4;//default
end.
