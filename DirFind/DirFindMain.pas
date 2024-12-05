unit DirFindMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ActnList, Menus, ImgList, DirFindNodes, ShlObj,
  System.Actions, System.ImageList;

type
  TfDirFindMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbIgnoreCase: TCheckBox;
    cbMultiLine: TCheckBox;
    cbFolder: TComboBox;
    btnSelectFolder: TButton;
    cbFiles: TComboBox;
    cbPattern: TComboBox;
    btnStart: TButton;
    txtProgress: TEdit;
    tvMatches: TTreeView;
    Label4: TLabel;
    cbNotFiles: TComboBox;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    ActionList1: TActionList;
    aCopy: TAction;
    aRefresh: TAction;
    aTerminate: TAction;
    aDelete: TAction;
    aReplace: TAction;
    aTerminateAll: TAction;
    aDeleteAll: TAction;
    CopyLocation1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    Abort1: TMenuItem;
    Remove1: TMenuItem;
    N2: TMenuItem;
    Replace1: TMenuItem;
    N3: TMenuItem;
    Abortall1: TMenuItem;
    Removeall1: TMenuItem;
    Expand1: TMenuItem;
    cbRegExp: TCheckBox;
    btnSearchSection: TButton;
    Label5: TLabel;
    rbCountFiles: TRadioButton;
    rbCountMatches: TRadioButton;
    rbCountSubMatches: TRadioButton;
    procedure btnSelectFolderClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure tvMatchesCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvMatchesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure aRefreshExecute(Sender: TObject);
    procedure aTerminateExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure tvMatchesDblClick(Sender: TObject);
    procedure aCopyExecute(Sender: TObject);
    procedure tvMatchesKeyPress(Sender: TObject; var Key: Char);
    procedure tvMatchesEnter(Sender: TObject);
    procedure tvMatchesExit(Sender: TObject);
    procedure tvMatchesChange(Sender: TObject; Node: TTreeNode);
    procedure aTerminateAllExecute(Sender: TObject);
    procedure aDeleteAllExecute(Sender: TObject);
    procedure aReplaceExecute(Sender: TObject);
    procedure Expand1Click(Sender: TObject);
  private
    FPopupNode:TTreeNode;
    FFinderProgress:TDirFinderNode;
    cm2:IContextMenu2;
    function PopupFinder: TDirFinderNode;
    procedure DoFinderProgress(Sender: TObject; const PrgTxt: string);
    procedure DoStoreValues(Sender: TObject);
  protected
    procedure DoCreate; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure WndProc(var Message: TMessage); override;
    procedure DoShow; override;
  end;

var
  fDirFindMain: TfDirFindMain;

implementation

{$WARN UNIT_PLATFORM OFF}

uses ActiveX, ComObj, FileCtrl, ClipBrd, DirFindReplace, DirFindWorker;

{$R *.dfm}

const
  AppName='DirFind';

function IniStr(Key,Default,Ini:string):string;
begin
  SetLength(Result,1024);
  SetLength(Result,GetPrivateProfileString(AppName,PChar(Key),PChar(Default),PChar(Result),1024,PChar(Ini)));
end;

procedure SetIniStr(Key,Value,Ini:string);
begin
  WritePrivateProfileString(AppName,PChar(Key),PChar(Value),PChar(Ini));
end;

procedure TfDirFindMain.DoCreate;
var
  d:string;
  i:integer;
begin
  inherited;
  OleInitialize(nil);//CoInitialize(nil);
  FPopupNode:=nil;
  FFinderProgress:=nil;
  cm2:=nil;
  try
    d:=GetEnvironmentVariable('APPDATA');
    if d='' then d:=ExtractFilePath(Application.ExeName) else d:=d+'\DirFind\';
    cbFolder.Items.LoadFromFile(d+'DirFind_Folders.txt');
    cbFiles.Items.LoadFromFile(d+'DirFind_Files.txt');
    cbNotFiles.Items.LoadFromFile(d+'DirFind_FilesNot.txt');
    cbPattern.Items.LoadFromFile(d+'DirFind_Patterns.txt');
  except
    //silent
  end;

  cbFolder.Sorted:=true;
  cbFiles.Sorted:=true;
  cbNotFiles.Sorted:=true;
  cbPattern.Sorted:=true;

  d:=d+'DirFind.ini';
  cbFolder.Text:=IniStr('Folder','',d);
  cbFiles.Text:=IniStr('Files','',d);
  cbNotFiles.Text:=IniStr('FilesNot','',d);
  cbPattern.Text:=IniStr('Pattern','',d);
  cbRegExp.Checked:=IniStr('RegExp','0',d)='1';
  cbIgnoreCase.Checked:=IniStr('IgnoreCase','1',d)='1';
  cbMultiLine.Checked:=IniStr('MultiLine','0',d)='1';
  i:=StrToIntDef(IniStr('CountMatches','0',d),0);
  case i of
    0:rbCountFiles.Checked:=true;
    1:rbCountMatches.Checked:=true;
    2:rbCountSubMatches.Checked:=true;
  end;
  IndentLevelTabSize:=StrToInt(IniStr('TabSize','4',d));
end;

procedure TfDirFindMain.DoClose(var Action: TCloseAction);
var
  d:string;
  i:integer;
const
  BoolStr:array[boolean] of string=('0','1');
begin
  inherited;
  d:=GetEnvironmentVariable('APPDATA');
  if d='' then d:=ExtractFilePath(Application.ExeName) else
   begin
    d:=d+'\DirFind\';
    CreateDir(d);
   end;
  cbFolder.Items.SaveToFile(d+'DirFind_Folders.txt');
  cbFiles.Items.SaveToFile(d+'DirFind_Files.txt');
  cbNotFiles.Items.SaveToFile(d+'DirFind_FilesNot.txt');
  cbPattern.Items.SaveToFile(d+'DirFind_Patterns.txt');

  d:=d+'DirFind.ini';
  SetIniStr('Folder',cbFolder.Text,d);
  SetIniStr('Files',cbFiles.Text,d);
  SetIniStr('FilesNot',cbNotFiles.Text,d);
  SetIniStr('Pattern',cbPattern.Text,d);
  SetIniStr('RegExp',BoolStr[cbRegExp.Checked],d);
  SetIniStr('IgnoreCase',BoolStr[cbIgnoreCase.Checked],d);
  SetIniStr('MultiLine',BoolStr[cbMultiLine.Checked],d);
  if rbCountFiles.Checked then i:=0 else
  if rbCountMatches.Checked then i:=1 else
  if rbCountSubMatches.Checked then i:=2 else
    i:=0;//default
  SetIniStr('CountMatches',IntToStr(i),d);
end;

procedure TfDirFindMain.btnSelectFolderClick(Sender: TObject);
var
  d:string;
begin
  d:=cbFolder.Text;
  if SelectDirectory('Select directory to search in','',d,
    [sdShowEdit,sdShowShares,sdNewUI],Self) then cbFolder.Text:=d;
end;

function RegExSafe(const x:string):string;
var
  i,j,l:integer;
begin
  l:=Length(x);
  SetLength(Result,l*2);
  i:=0;
  j:=0;
  while i<l do
   begin
    inc(i);
    inc(j);
    if AnsiChar(x[i]) in ['\','.','*','+','?','$','^','[',']','(',')','{','}'] then
     begin
      Result[j]:='\';
      inc(j);
     end;
    Result[j]:=x[i];
   end;
  SetLength(Result,j);
end;

procedure TfDirFindMain.btnStartClick(Sender: TObject);
var
  n:TDirFinderNode;
  p:string;
  i:integer;
begin
  if (txtProgress.Focused or (Sender=btnSearchSection)) and (txtProgress.SelLength<>0) then
    if cbRegExp.Checked then
      cbPattern.Text:=RegExSafe(txtProgress.SelText)
    else
      cbPattern.Text:=txtProgress.SelText;
  cbPattern.SelectAll;
  if cbRegExp.Checked then
    p:=cbPattern.Text
  else
    p:=RegExSafe(cbPattern.Text);
  if rbCountFiles.Checked then i:=0 else
  if rbCountMatches.Checked then i:=1 else
  if rbCountSubMatches.Checked then i:=2 else
    i:=0;//default
  DirFindNextNodeClass:=TDirFinderNode;
  n:=tvMatches.Items.Add(nil,'') as TDirFinderNode;
  n.Start(
    cbFolder.Text,
    cbFiles.Text,
    cbNotFiles.Text,
    p,
    cbIgnoreCase.Checked,
    cbMultiLine.Checked,
    TDirFinderCountMatches(i),
    DoStoreValues);
  tvMatches.Selected:=n;
end;

procedure TfDirFindMain.tvMatchesCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass:=DirFindNextNodeClass;
end;

procedure TfDirFindMain.tvMatchesContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
const
  startCmd=20;//keep somewhere above total count of items in popupmenu
var
  fn:string;
  Malloc:IMalloc;
  DesktopFolder,SourceFolder:IShellFolder;
  eaten,flags:cardinal;
  id:PItemIDList;
  cm:IContextMenu;
  w:WideString;
  i:integer;
  ici:TCMInvokeCommandInfo;
  p:TPoint;
  mi,mi1:TMenuItem;
begin
  FPopupNode:=tvMatches.GetNodeAt(MousePos.X,MousePos.Y);
  if (FPopupNode<>nil) and
    ((FPopupNode is TDirFindFolderNode) or
    (FPopupNode is TDirFindMatchNode)) then
   begin
    try
      fn:='';//counter warning
      if FPopupNode is TDirFindFolderNode then
        fn:=(FPopupNode as TDirFindFolderNode).FolderPath;
      if FPopupNode is TDirFindMatchNode then
        fn:=(FPopupNode as TDirFindMatchNode).FilePath;
      p:=tvMatches.ClientToScreen(MousePos);
      mi:=TMenuItem.Create(nil);
      mi1:=TMenuItem.Create(nil);//forces sub-menu
      mi1.Visible:=false;
      mi.Caption:='Context menu';
      mi.Add(mi1);
      try
        OleCheck(SHGetMalloc(Malloc));
        OleCheck(SHGetDesktopFolder(DesktopFolder));
        flags:=0;
        w:=ExtractFilePath(fn);
        OleCheck(DesktopFolder.ParseDisplayName(0,nil,PWideChar(w),eaten,id,flags));
        try
          OleCheck(DesktopFolder.BindToObject(id,nil,IShellFolder,SourceFolder));
        finally
          Malloc.Free(id);
        end;
        w:=ExtractFileName(fn);
        OleCheck(SourceFolder.ParseDisplayName(0,nil,PWideChar(w),eaten,id,flags));
        try
          OleCheck(SourceFolder.GetUIObjectOf(0,1,id,IContextMenu,nil,cm));
        finally
          Malloc.Free(id);
        end;
        cm.QueryContextMenu(mi.Handle,0,startCmd,$7FFF,
          CMF_EXPLORE or CMF_NODEFAULT);
        PopupMenu1.Items.Insert(2,mi);
        cm2:=cm as IContextMenu2;
        i:=integer(TrackPopupMenu(
          PopupMenu1.Handle,
          TPM_RETURNCMD or TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_RIGHTBUTTON,
          p.X,p.Y,0,Handle,nil));
        if i<>0 then
          if not PopupMenu1.DispatchCommand(i) then
           begin
            dec(i,startCmd);
            ici.cbSize:=SizeOf(TCMInvokeCommandInfo);
            ici.fMask:=0;
            ici.hwnd:=Handle;
            ici.lpVerb:=pointer(i);
            ici.lpParameters:=nil;
            ici.lpDirectory:=nil;
            ici.nShow:=SW_SHOWNORMAL;
            ici.dwHotKey:=0;
            ici.hIcon:=0;
            cm.InvokeCommand(ici);
           end;
      finally
        cm2:=nil;
        cm:=nil;
        mi.Free;
        DesktopFolder:=nil;
        Malloc:=nil;
      end;
      Handled:=true;
    except
      //silent
    end;
   end;
end;

procedure TfDirFindMain.WndProc(var Message: TMessage);
begin
  if cm2<>nil then
    case Message.Msg of
      WM_INITMENUPOPUP,
      WM_DRAWITEM,
      WM_MENUCHAR,
      WM_MEASUREITEM:
       begin
        cm2.HandleMenuMsg(Message.Msg,Message.WParam,Message.LParam);
        Message.Result:=0;
       end;
    end;
  inherited;
end;

function TfDirFindMain.PopupFinder: TDirFinderNode;
begin
  while (FPopupNode<>nil) and (FPopupNode.Parent<>nil) do FPopupNode:=FPopupNode.Parent;
  if FPopupNode<>nil then Result:=FPopupNode as TDirFinderNode else
    raise EAbort.Create('Nothing selected');//Result:=nil?
end;

procedure TfDirFindMain.aRefreshExecute(Sender: TObject);
begin
  PopupFinder.Refresh;
end;

procedure TfDirFindMain.aTerminateExecute(Sender: TObject);
begin
  PopupFinder.Abort;
end;

procedure TfDirFindMain.aDeleteExecute(Sender: TObject);
var
  n:TDirFinderNode;
begin
  n:=PopupFinder;
  if FFinderProgress<>nil then FFinderProgress.OnProgress:=nil;
  FFinderProgress:=nil;
  txtProgress.Text:='';
  Caption:=AppName;
  Application.Title:=AppName;
  n.Delete;
  FPopupNode:=tvMatches.Selected;//for next press of [delete]
  if tvMatches.Focused and (tvMatches.Selected=nil) then cbPattern.SetFocus;
end;

procedure TfDirFindMain.tvMatchesDblClick(Sender: TObject);
var
  tn:TTreeNode;
begin
  tn:=tvMatches.Selected;
  if (tn<>nil) and (tn is TDirFindTreeNode) then
    (tn as TDirFindTreeNode).DoDblClick;
end;

procedure TfDirFindMain.aCopyExecute(Sender: TObject);
begin
  if FPopupNode<>nil then
    if FPopupNode is TDirFinderNode then
      Clipboard.AsText:=(FPopupNode as TDirFinderNode).AllFilePaths
    else
    if FPopupNode is TDirFindTreeNode then
      Clipboard.AsText:=(FPopupNode as TDirFindTreeNode).ProgressText//?
    else
      Clipboard.AsText:=FPopupNode.Text;
end;

procedure TfDirFindMain.tvMatchesKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:tvMatchesDblClick(Sender);
    '/'://if not tvMatches.IsEditing then
      if tvMatches.Selected=nil then
        tvMatches.FullCollapse
      else
        tvMatches.Selected.Collapse(true);
   end;
end;

procedure TfDirFindMain.tvMatchesEnter(Sender: TObject);
begin
  aDelete.Enabled:=true;
  aDeleteAll.Enabled:=true;
  aCopy.Enabled:=true;
end;

procedure TfDirFindMain.tvMatchesExit(Sender: TObject);
begin
  aDelete.Enabled:=false;
  aDeleteAll.Enabled:=false;
  aCopy.Enabled:=false;
end;

procedure TfDirFindMain.tvMatchesChange(Sender: TObject; Node: TTreeNode);
var
  tn:TTreeNode;
begin
  FPopupNode:=Node;
  tn:=Node;
  if tn=nil then txtProgress.Text:='' else
    if tn is TDirFindTreeNode then
      txtProgress.Text:=(tn as TDirFindTreeNode).ProgressText
    else
      txtProgress.Text:=tn.Text;
  if FFinderProgress<>nil then
   begin
    FFinderProgress.OnProgress:=nil;
    FFinderProgress:=nil;
   end;
  if tn<>nil then
    if tn is TDirFindFolderNode then (tn as TDirFindFolderNode).SetPrioFolder else
      if tn is TDirFinderNode then
       begin
        FFinderProgress:=(tn as TDirFinderNode);
        FFinderProgress.OnProgress:=DoFinderProgress;
       end;
  while (tn<>nil) and not(tn is TDirFinderNode) do tn:=tn.Parent;
  if tn<>nil then
   begin
    Caption:=AppName+' - '+(tn as TDirFinderNode).RootPath+' - '+(tn as TDirFinderNode).Pattern;
    Application.Title:=Caption;
   end;
end;

procedure TfDirFindMain.DoFinderProgress(Sender:TObject;const PrgTxt:string);
begin
  txtProgress.Text:=PrgTxt;
end;

procedure TfDirFindMain.aTerminateAllExecute(Sender: TObject);
var
  tn:TTreeNode;
begin
  tn:=tvMatches.Items.GetFirstNode;
  while (tn<>nil) do
   begin
    if tn is TDirFinderNode then (tn as TDirFinderNode).Abort;
    tn:=tn.getNextSibling;
   end;
end;

procedure TfDirFindMain.aDeleteAllExecute(Sender: TObject);
begin
  if FFinderProgress<>nil then FFinderProgress.OnProgress:=nil;
  FFinderProgress:=nil;
  txtProgress.Text:='';
  Caption:=AppName;
  Application.Title:=AppName;
  tvMatches.Items.BeginUpdate;
  try
    tvMatches.Items.Clear;
  finally
    tvMatches.Items.EndUpdate;
  end;
  if tvMatches.Focused then cbPattern.SetFocus;
end;

procedure TfDirFindMain.aReplaceExecute(Sender: TObject);
var
  tn:TDirFinderNode;
begin
  tn:=PopupFinder;
  if tn.IsFinding then raise Exception.Create('Matching job is still running. Wait for it to complete first.');
  fDirFindReplace.lblPattern.Caption:=tn.Pattern;
  if fDirFindReplace.ShowModal=mrOk then
    MessageBox(Handle,PChar('Performed replace, '+
      IntToStr(tn.ReplaceAll(fDirFindReplace.txtReplaceWith.Text))+' file(s) changed.'),
      AppName,MB_OK or MB_ICONINFORMATION);
end;

procedure TfDirFindMain.Expand1Click(Sender: TObject);
begin
  if FPopupNode<>nil then
    if FPopupNode.HasChildren then
      FPopupNode.Expand(false)
    else
      if FPopupNode is TDirFindTreeNode then
        (FPopupNode as TDirFindTreeNode).DoDblClick;
end;

procedure TfDirFindMain.DoShow;
var
  i,j,l:integer;
  s:string;
  b:boolean;
begin
  inherited;
  j:=0;
  i:=ParamCount;
  if i>0 then
   begin
    s:=ParamStr(1);
    if Copy(s,1,1)='/' then
     begin
      b:=true;
      j:=2;
      l:=Length(s);
      while j<=l do
       begin
        case s[j] of
          '-':b:=false;
          '+':b:=true;
          'r','R':cbRegExp.Checked:=b;
          'c','C':cbIgnoreCase.Checked:=b;
          'm','M':cbMultiLine.Checked:=b;
          'f','F':rbCountFiles.Checked:=true;
          'a','A':rbCountMatches.Checked:=true;
          's','S':rbCountSubMatches.Checked:=true;
          else raise Exception.Create('Unknown command line option at position '+
            IntToStr(j)+':"'+s+'"');
        end;
        inc(j);
       end;
      j:=1;
      dec(i);
     end;
   end;
  case i of
    1:
     begin
      cbFolder.Text:=ParamStr(j+1);
      cbPattern.SetFocus;
     end;
    2:
     begin
      cbFolder.Text:=ParamStr(j+1);
      cbFiles.Text:='';//?
      cbPattern.Text:=ParamStr(j+2);
      btnStart.Click;
     end;
    3:
     begin
      cbFolder.Text:=ParamStr(j+1);
      cbFiles.Text:=ParamStr(j+2);
      cbPattern.Text:=ParamStr(j+3);
      btnStart.Click;
     end;
    4:
     begin
      cbFolder.Text:=ParamStr(j+1);
      cbFiles.Text:=ParamStr(j+2);
      cbNotFiles.Text:=ParamStr(j+3);
      cbPattern.Text:=ParamStr(j+4);
      btnStart.Click;
     end;
  end;
end;

procedure TfDirFindMain.DoStoreValues(Sender: TObject);
var
  n:TDirFinderNode;

  procedure DoStore(cb:TComboBox;const Value:string);
  begin
    //assert cb.Items.Sorted
    if (Value<>'') and (cb.Items.IndexOf(Value)=-1) then
      cb.Items.Add(Value);
  end;

begin
  n:=(Sender as TDirFinderNode);
  DoStore(cbFolder,n.RootPath);
  DoStore(cbFiles,n.FindFiles);
  DoStore(cbNotFiles,n.FindNotFiles);
  DoStore(cbPattern,n.Pattern);
end;

end.
