unit ddMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, ImgList, ddParams, ddData,
  System.ImageList;

type
  TfrmDirDiffMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    miRefresh: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    tvFolders: TTreeView;
    spFolders: TSplitter;
    tvXML: TTreeView;
    spXML: TSplitter;
    panMain: TPanel;
    imgOverview: TImage;
    lbView: TListBox;
    panTop: TPanel;
    txtFind: TEdit;
    btnFind: TButton;
    Edit1: TMenuItem;
    miCopy: TMenuItem;
    ImageList1: TImageList;
    Diff1: TMenuItem;
    miPrev: TMenuItem;
    miNext: TMenuItem;
    miPreviousFile: TMenuItem;
    miNextFile: TMenuItem;
    miSearch: TMenuItem;
    miFindNext: TMenuItem;
    miFindPrevious: TMenuItem;
    miGotoLine: TMenuItem;
    XML1: TMenuItem;
    N3: TMenuItem;
    miPreferences: TMenuItem;
    miXmlOff: TMenuItem;
    miXmlAuto: TMenuItem;
    miXmlOn: TMenuItem;
    N4: TMenuItem;
    miXmlExpandAll: TMenuItem;
    miXmlCollapseAll: TMenuItem;
    N5: TMenuItem;
    miXmlPreferences: TMenuItem;
    N6: TMenuItem;
    miShowDragHandle: TMenuItem;
    miAddFile: TMenuItem;
    miDiffBase: TMenuItem;
    miCopyUNC: TMenuItem;
    miOpen: TMenuItem;
    miUpdate: TMenuItem;
    miDelete: TMenuItem;
    btnAddFile: TButton;
    miAddFolder: TMenuItem;
    btnAddFolder: TButton;
    miNx: TMenuItem;
    miReadOnly: TMenuItem;
    OpenDialog1: TOpenDialog;
    N7: TMenuItem;
    miSelectFile: TMenuItem;
    miSelectFolder: TMenuItem;
    StatusBar1: TStatusBar;
    shViewPort: TShape;
    tiUpdate: TTimer;
    Selectall1: TMenuItem;
    N8: TMenuItem;
    miDiffExpandAll: TMenuItem;
    miDiffCollapseAll: TMenuItem;
    miRemove: TMenuItem;
    miSource: TMenuItem;
    N9: TMenuItem;
    miUpdateSelected: TMenuItem;
    miDeleteSelected: TMenuItem;
    ImageList2: TImageList;
    miCopyUNCs: TMenuItem;
    N10: TMenuItem;
    miClearSelFiles: TMenuItem;
    procedure miExitClick(Sender: TObject);
    procedure miAddFileClick(Sender: TObject);
    procedure miAddFolderClick(Sender: TObject);
    procedure miPreferencesClick(Sender: TObject);
    procedure miXmlPreferencesClick(Sender: TObject);
    procedure miSelectFileClick(Sender: TObject);
    procedure miSelectFolderClick(Sender: TObject);
    procedure miCopyUNCClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure tvFoldersExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvFoldersChange(Sender: TObject; Node: TTreeNode);
    procedure lbViewDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure imgOverviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgOverviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure shViewPortMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shViewPortMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure miPrevClick(Sender: TObject);
    procedure miNextClick(Sender: TObject);
    procedure tiUpdateTimer(Sender: TObject);
    procedure miSearchClick(Sender: TObject);
    procedure txtFindKeyPress(Sender: TObject; var Key: Char);
    procedure miFindNextClick(Sender: TObject);
    procedure txtPathExit(Sender: TObject);
    procedure miFindPreviousClick(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure miPreviousFileClick(Sender: TObject);
    procedure miNextFileClick(Sender: TObject);
    procedure miGotoLineClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miShowDragHandleClick(Sender: TObject);
    procedure miXmlOffClick(Sender: TObject);
    procedure miXmlAutoClick(Sender: TObject);
    procedure miXmlOnClick(Sender: TObject);
    procedure tvFoldersDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvXMLDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvXMLChange(Sender: TObject; Node: TTreeNode);
    procedure tvXMLExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure miDiffExpandAllClick(Sender: TObject);
    procedure miDiffCollapseAllClick(Sender: TObject);
    procedure miXmlExpandAllClick(Sender: TObject);
    procedure miXmlCollapseAllClick(Sender: TObject);
    procedure XML1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure miRemoveClick(Sender: TObject);
    procedure miSourceClick(Sender: TObject);
    procedure miReadOnlyClick(Sender: TObject);
    procedure tvFoldersChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure tvFoldersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miDeleteClick(Sender: TObject);
    procedure miUpdateClick(Sender: TObject);
    procedure miClearSelFilesClick(Sender: TObject);
    procedure miCopyUNCsClick(Sender: TObject);
    procedure miDeleteSelectedClick(Sender: TObject);
    procedure miUpdateSelectedClick(Sender: TObject);
    procedure AppActivate(Sender: TObject);
    procedure tvFoldersDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvFoldersDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvFoldersKeyPress(Sender: TObject; var Key: Char);
  private
    FDataSet:TDiffSet;
    FDataCount,FFilesSource:integer;
    vp1,vp2,FQueueFlash,FResetToTop,FResetToLine:integer;
    FCompareFile:TTreeNode;
    FClosing,FSkipXML,FSkipNodeCheck,FSkipAppActivate,FAskingUpdate,
    FSomeChecked:boolean;
    procedure CreateSetUI(d: TDiffData);
    procedure ShowPrefs(bXml: boolean);
    procedure UpdateUI;
    procedure LoadFiles(np: TTreeNode);
    procedure ListToPx(Y: integer);
    procedure ListToLine(Idx: integer);
    procedure LoadFromPaths;
    procedure UpdateViewPort(Reset:boolean);
    procedure ExpandXmlNodes(n: TTreeNode);
    function tvFoldersCheck(NN: TTreeNode; X, Y: integer):boolean;
    procedure ListSelectedFiles(Index:integer;sl:TStringList);
  protected
    procedure DoCreate; override;
    procedure DoShow; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoDestroy; override;
    procedure WMListCount(var Msg: TMessage); message WM_LISTCOUNT;
    procedure WMPreview(var Msg: TMessage); message WM_PREVIEW;
    procedure WMQueueInfo(var Msg: TMessage); message WM_QUEUEINFO;
    procedure WMCompareNext(var Msg: TMessage); message WM_COMPARENEXT;
  public
    procedure AddSource(const FilePath:string);
  end;

var
  frmDirDiffMain: TfrmDirDiffMain;

implementation

{$WARN UNIT_PLATFORM OFF}

uses
  FileCtrl, ddPrefs, ClipBrd, ActiveX, ddGoToLine, ddHandle, MSXML2_TLB,
  ddDiff, ddXmlTools, ShellAPI, ShlObj, UITypes;

{$R *.dfm}

procedure TfrmDirDiffMain.DoCreate;
var
  si:TSystemInfo;
  sl:TStringList;
  s:string;
begin
  inherited;
  Application.OnActivate:=AppActivate;
  GetSystemInfo(si);
  //si.dwNumberOfProcessors
  GetStoredDims(Self);
  FClosing:=false;
  FDataSet:=TDiffSet.Create(Handle);
  FDataCount:=0;
  FResetToTop:=-1;
  FResetToLine:=-1;
  FCompareFile:=nil;
  FSkipXML:=false;
  FFilesSource:=-1;
  FSkipNodeCheck:=false;
  FSkipAppActivate:=false;
  FAskingUpdate:=false;
  FSomeChecked:=false;

  sl:=TStringList.Create;
  try
    sl.LoadFromFile(ChangeFileExt(Application.ExeName,'.ini'));
    s:=sl.Values['FontName'];
    if s<>'' then
     begin
      lbView.Font.Name:=s;
      lbView.Font.Size:=StrToIntDef(sl.Values['FontSize'],9);
      lbView.Font.Color:=StrToIntDef(sl.Values['FontColor'],0);
      if sl.Values['FontBold']='1' then
        lbView.Font.Style:=lbView.Font.Style+[fsBold];
      if sl.Values['FontItalic']='1' then
        lbView.Font.Style:=lbView.Font.Style+[fsItalic];
      lbView.ItemHeight:=2-lbView.Font.Height;
     end;
    FDataSet.IgnoreDates:=sl.Values['IgnoreDates']='1';
    FDataSet.SkipFiles:=sl.Values['Skip'];
    FDataSet.IgnoreWhitespace:=sl.Values['IgnoreWhitespace']='1';
    FDataSet.IgnoreCase:=sl.Values['IgnoreCase']='1';
    FDataSet.WideTabs:=sl.Values['WideTabs']='1';
    FDataSet.EOLMarkers:=sl.Values['EOLMarkers']='1';
    FDataSet.XmlAttrOnLine:=sl.Values['XMLAttributesOnLines']='1';
    FDataSet.XmlDetectNS:=sl.Values['XMLDetectNamespaces']='1';
    FDataSet.XmlIndent:=sl.Values['XMLIndentation']='1';
    FDataSet.XmlAutoDetect:=sl.Values['XmlAutoDetect']='1';
    FDataSet.XmlDomTree:=sl.Values['XMLDOMTree']='1';
    FDataSet.XmlAttrIgnSeq:=sl.Values['XMLAttributesIgnoreSeq']='1';
    FDataSet.XmlPreserveWhiteSpace:=sl.Values['XMLPreserveWhitespace']='1';
    FDataSet.XmlCollapseEmpty:=sl.Values['XMLCollapseEmptyTags']='1';
    FDataSet.XmlDefiningArributes.Text:=StringReplace(
      sl.Values['XMLDefiningAttributes'],' ',#13#10,[rfReplaceAll]);
    FDataSet.XmlElemIgnSeq:=sl.Values['XMLElementsIgnoreSeq']='1';
    FDataSet.XmlIgnoreCData:=sl.Values['XMLIgnoreCDATA']='1';

    if FDataSet.XmlDomTree then
      miXmlOn.Checked:=true
    else if FDataSet.XmlAutoDetect then
      miXmlAuto.Checked:=true
    else
      miXmlOff.Checked:=true;

  except
    //use defaults
  end;
  sl.Free;
  vp1:=0;
  vp2:=0;
end;

procedure TfrmDirDiffMain.DoClose(var Action: TCloseAction);
begin
  inherited;
  //Action:=caFree;
  Application.OnActivate:=nil;
  FDataSet.AbortAll;
  FClosing:=true;
  SetStoredDims(Self);
  //TODO: save settings
end;

procedure TfrmDirDiffMain.DoShow;
var
  d:TDiffData;
  i:integer;
  s:string;
begin
  inherited;
  //ShowWindow(Application.Handle,SW_HIDE);
  OleInitialize(nil);

  //TODO: move to dpr? /handle? single op?

  if ParamCount<>0 then
   begin
    i:=1;
    while (i<=ParamCount) do
     begin
      s:=ParamStr(i);
      inc(i);

      //if s[1]='/' then case s[2]?
      if LowerCase(s)='/h' then
       begin
        miShowDragHandle.Click;
        PostMessage(Handle,WM_PREVIEW,0,0);//?
       end
      else
       begin
        d:=TDiffData.Create;
        d.Path:=s;
        FDataSet.AddData(d);
        CreateSetUI(d);
       end;

     end;
    UpdateUI;
    FSkipAppActivate:=true;
   end;

end;

procedure TfrmDirDiffMain.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDirDiffMain.miAddFileClick(Sender: TObject);
var
  d:TDiffData;
begin
  if OpenDialog1.Execute then
   begin
    d:=TDiffData.Create;
    d.Path:=OpenDialog1.FileName;
    FDataSet.AddData(d);
    CreateSetUI(d);
    UpdateUI;
   end;
end;

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg=BFFM_INITIALIZED) and (lpData<>0) then
    SendMessage(Wnd,BFFM_SETSELECTION,Integer(True),lpdata);
  Result:=0;
end;

function SelectDirectory2(const Caption: string;
  var Directory: string): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  OldErrorMode: Cardinal;
  ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
begin
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc)<>S_OK) or (ShellMalloc=nil) then
    RaiseLastOSError;
  Buffer:=ShellMalloc.Alloc(MAX_PATH);
  try
    with BrowseInfo do
    begin
      hwndOwner:=Application.Handle;
      //pidlRoot:=RootItemIDList;
      //pszDisplayName:=Buffer;
      lpszTitle:=PChar(Caption);
      ulFlags:=BIF_RETURNONLYFSDIRS or BIF_EDITBOX;
      if Directory <> '' then
      begin
        lpfn := SelectDirCB;
        lParam := Integer(PChar(Directory));
      end;
    end;
    WindowList:=DisableTaskWindows(0);
    OldErrorMode:=SetErrorMode(SEM_FAILCRITICALERRORS);
    try
      ItemIDList:=ShBrowseForFolder(BrowseInfo);
    finally
      SetErrorMode(OldErrorMode);
      EnableTaskWindows(WindowList);
    end;
    Result:=ItemIDList<>nil;
    if Result then
    begin
      ShGetPathFromIDList(ItemIDList,Buffer);
      ShellMalloc.Free(ItemIDList);
      Directory:=Buffer;
    end;
  finally
    ShellMalloc.Free(Buffer);
  end;
end;

procedure TfrmDirDiffMain.miAddFolderClick(Sender: TObject);
var
  s:string;
  d:TDiffData;
begin
  s:='';
  if SelectDirectory2('Select Folder',s) then
   begin
    d:=TDiffData.Create;
    d.Path:=s;
    FDataSet.AddData(d);
    CreateSetUI(d);
    UpdateUI;
   end;
end;

procedure TfrmDirDiffMain.CreateSetUI(d:TDiffData);
var
  i,y,z:integer;
  s:string;
  e:TEdit;
  m,m1,m2:TMenuItem;
begin
  //create UI
  z:=FDataSet.DataCount;
  y:=btnAddFile.Height;
  //s:=IntToStr(z);
  inc(FDataCount);
  s:=IntToStr(FDataCount);
  e:=TEdit.Create(Self);
  e.Name:='txtDiffPath'+s;
  e.Color:=CLevel(DiffColors[(z-1) mod DiffColorsCount]);
  e.Text:=d.Path;
  e.Tag:=z-1;
  e.SetBounds(8,8+(8+y)*(z-1),panTop.ClientWidth-16,e.Height);//assert j=e.Height?
  e.Anchors:=[akTop,akLeft,akRight];
  e.Parent:=panTop;
  e.OnExit:=txtPathExit;
  d.Display1:=e;

  //update UI
  txtFind.Visible:=false;
  btnFind.Visible:=false;
  if z=1 then
   begin
    inc(y,16);
    if FDataSet[0].IsDir then
     begin
      btnAddFile.Visible:=false;
      btnAddFolder.Top:=y;
     end
    else
     begin
      btnAddFile.Top:=y;
      btnAddFolder.Visible:=false;
     end;
    panTop.Height:=y*2-8;
   end
  else
   begin
    btnAddFile.Visible:=false;
    btnAddFolder.Visible:=false;
    panTop.Height:=(y+8)*z+8;
   end;

  //menu item
  m:=TMenuItem.Create(Self);
  m.Caption:='-'+IntToStr(z)+'-';
  m.Name:='miDiff'+s;
  m.Tag:=z;
  //m.OnClick:=
  MainMenu1.Items.Add(m);
  d.Display2:=m;
  for i:=0 to miDiffBase.Count-1 do
   begin
    m1:=TMenuItem.Create(Self);
    m2:=miDiffBase.Items[i];
    //m1.Assign(m2);
    m1.Name:=m2.Name+s;
    m1.Caption:=m2.Caption;
    m1.OnClick:=m2.OnClick;
    m1.ImageIndex:=m2.ImageIndex;
    m1.Checked:=m2.Checked;
    m1.Enabled:=m2.Enabled;
    m1.Tag:=z;
    m.Add(m1);
   end;
end;

procedure TfrmDirDiffMain.DoDestroy;
begin
  inherited;
  FreeAndNil(FDataSet);
end;

procedure TfrmDirDiffMain.miPreferencesClick(Sender: TObject);
begin
  ShowPrefs(false);
end;

procedure TfrmDirDiffMain.miXmlPreferencesClick(Sender: TObject);
begin
  ShowPrefs(true);
end;

procedure TfrmDirDiffMain.ShowPrefs(bXml:boolean);
var
  f:TfrmDirDiffPrefs;
  sl:TStringList;
const
  B:array[boolean] of string=('0','1');
begin
  f:=TfrmDirDiffPrefs.Create(nil);
  try
    if bXml then f.PageControl1.ActivePageIndex:=1;
    f.FontDialog1.Font.Assign(lbView.Font);
    f.cbXmlIndentTags.Checked:=FDataSet.XmlIndent;
    f.cbXmlAttrLines.Checked:=FDataSet.XmlAttrOnLine;
    f.cbXmlAttrIgnSeq.Checked:=FDataSet.XmlAttrIgnSeq;
    f.cbXmlElemIgnSeq.Checked:=FDataSet.XmlElemIgnSeq;
    f.cbXmlPreserveWhitespace.Checked:=FDataSet.XmlPreserveWhiteSpace;
    f.cbCollapseEmpty.Checked:=FDataSet.XmlCollapseEmpty;
    f.cbXmlCdataAsText.Checked:=FDataSet.XmlIgnoreCData;
    f.cbDetectNS.Checked:=FDataSet.XmlDetectNS;
    f.txtXmlDefAttrs.Lines.Assign(FDataSet.XmlDefiningArributes);
    f.txtSkipFiles.Text:=FDataSet.SkipFiles;
    f.cbIgnoreDates.Checked:=FDataSet.IgnoreDates;
    f.cbIgnoreWhitespace.Checked:=FDataSet.IgnoreWhitespace;
    f.cbIgnoreCase.Checked:=FDataSet.IgnoreCase;
    f.cbWideTabs.Checked:=FDataSet.WideTabs;
    f.cbEOLMarkers.Checked:=FDataSet.EOLMarkers;
    if f.ShowModal=mrOk then
     begin
      //apply
      lbView.Font.Assign(f.FontDialog1.Font);
      lbView.ItemHeight:=2-lbView.Font.Height;
      FDataSet.LineNrWidth:=0;//force recalculate
      FDataSet.SkipFiles:=f.txtSkipFiles.Text;
      FDataSet.IgnoreDates:=f.cbIgnoreDates.Checked;
      FDataSet.IgnoreWhitespace:=f.cbIgnoreWhitespace.Checked;
      FDataSet.IgnoreCase:=f.cbIgnoreCase.Checked;
      FDataSet.WideTabs:=f.cbWideTabs.Checked;
      FDataSet.EOLMarkers:=f.cbEOLMarkers.Checked;
      //FDataSet.XmlAutoDetect:=
      //FDataSet.XmlDomTree:=
      FDataSet.XmlAttrOnLine:=f.cbXmlAttrLines.Checked;
      FDataSet.XmlDetectNS:=f.cbDetectNS.Checked;
      FDataSet.XmlIndent:=f.cbXmlIndentTags.Checked;
      FDataSet.XmlAttrIgnSeq:=f.cbXmlAttrIgnSeq.Checked;
      FDataSet.XmlElemIgnSeq:=f.cbXmlElemIgnSeq.Checked;
      FDataSet.XmlPreserveWhiteSpace:=f.cbXmlPreserveWhitespace.Checked;
      FDataSet.XmlCollapseEmpty:=f.cbXmlPreserveWhitespace.Checked;
      FDataSet.XmlIgnoreCData:=f.cbXmlCdataAsText.Checked;
      FDataSet.XmlDefiningArributes.Assign(f.txtXmlDefAttrs.Lines);
      //TODO: refresh?
      
      //save
      sl:=TStringList.Create;
      try
        try
          sl.LoadFromFile(ChangeFileExt(Application.ExeName,'.ini'));
        except
          //silent
        end;
        sl.Values['FontName']:=f.FontDialog1.Font.Name;
        sl.Values['FontSize']:=IntToStr(f.FontDialog1.Font.Size);
        sl.Values['FontColor']:=Format('$%.6x',[f.FontDialog1.Font.Color]);
        sl.Values['FontBold']:=B[fsBold in f.FontDialog1.Font.Style];
        sl.Values['FontItalic']:=B[fsItalic in f.FontDialog1.Font.Style];
        sl.Values['IgnoreDates']:=B[f.cbIgnoreDates.Checked];
        sl.Values['Skip']:=f.txtSkipFiles.Text;
        sl.Values['IgnoreWhitespace']:=B[f.cbIgnoreWhitespace.Checked];
        sl.Values['IgnoreCase']:=B[f.cbIgnoreCase.Checked];
        sl.Values['WideTabs']:=B[f.cbWideTabs.Checked];
        sl.Values['EOLMarkers']:=B[f.cbEOLMarkers.Checked];
        sl.Values['XMLAttributesOnLines']:=B[f.cbXmlAttrLines.Checked];
        sl.Values['XMLDetectNamespaces']:=B[f.cbDetectNS.Checked];
        sl.Values['XMLIndentation']:=B[f.cbXmlIndentTags.Checked];
        sl.Values['XmlAutoDetect']:=B[FDataSet.XmlAutoDetect];
        sl.Values['XMLDOMTree']:=B[FDataSet.XmlDomTree];
        sl.Values['XMLAttributesIgnoreSeq']:=B[f.cbXmlAttrIgnSeq.Checked];
        sl.Values['XMLPreserveWhitespace']:=B[f.cbXmlPreserveWhitespace.Checked];
        sl.Values['XMLCollapseEmptyTags']:=B[f.cbCollapseEmpty.Checked];
        sl.Values['XMLDefiningAttributes']:=StringReplace(
          f.txtXmlDefAttrs.Text,#13#10,' ',[rfReplaceAll]);
        sl.Values['XMLElementsIgnoreSeq']:=B[f.cbXmlElemIgnSeq.Checked];
        sl.Values['XMLIgnoreCDATA']:=B[f.cbXmlCdataAsText.Checked];
        sl.SaveToFile(ChangeFileExt(Application.ExeName,'.ini'));
      finally
        sl.Free;
      end;
     end;
  finally
    f.Free;
  end;
end;

procedure TfrmDirDiffMain.miSelectFileClick(Sender: TObject);
var
  d:TDiffData;
begin
  d:=FDataSet[(Sender as TComponent).Tag-1];
  OpenDialog1.FileName:=d.Path;
  if OpenDialog1.Execute then
   begin
    d.Path:=OpenDialog1.FileName;
    (d.Display1 as TEdit).Text:=d.Path;
    UpdateUI;
   end;
end;

procedure TfrmDirDiffMain.miSelectFolderClick(Sender: TObject);
var
  d:TDiffData;
  s:string;
begin
  d:=FDataSet[(Sender as TComponent).Tag-1];
  s:=d.Path;
  if SelectDirectory2('Select Folder',s) then
   begin
    d.Path:=s;
    (d.Display1 as TEdit).Text:=d.Path;
    UpdateUI;
   end;
end;

procedure TfrmDirDiffMain.miCopyUNCClick(Sender: TObject);
var
  i:integer;
  n:TTreeNode;
  s:string;
begin
  i:=(Sender as TComponent).Tag-1;
  if tvFolders.Visible then
   begin
    n:=tvFolders.Selected;
    s:='';
    while n<>nil do
     begin
      s:=PathDelim+TDiffFileInfo(n.Data).Info[i].Name+s;
      n:=n.Parent;
     end;
    Clipboard.AsText:=FDataSet[i].Path+s;
   end
  else
    Clipboard.AsText:=FDataSet[i].Path;
end;

procedure TfrmDirDiffMain.miRefreshClick(Sender: TObject);
var
  sl:TStringList;
  n:TTreeNode;
  s:string;
begin
  FResetToTop:=lbView.TopIndex;
  FResetToLine:=lbView.ItemIndex;
  if tvFolders.Visible then
   begin
    sl:=TStringList.Create;
    try
      n:=tvFolders.Selected;
      while n<>nil do
       begin
        sl.Add(n.Text);//?
        n:=n.Parent;
       end;

      UpdateUI;

      n:=nil;
      while sl.Count<>0 do
       begin
        s:=sl[sl.Count-1];
        sl.Delete(sl.Count-1);
        if n=nil then
          n:=tvFolders.Items.GetFirstNode
        else
         begin
          n.Expand(false);
          n:=n.getFirstChild;
         end;
        while (n<>nil) and (n.Text<>s) do n:=n.getNextSibling;
        if n=nil then sl.Clear;
       end;
      if n=nil then
       begin
        FResetToTop:=-1;
        FResetToLine:=-1;
       end
      else
        tvFolders.Selected:=n;

    finally
      sl.Free;
    end;
   end
  else
    UpdateUI;
end;

procedure TfrmDirDiffMain.UpdateUI;
var
  s:string;
  i:integer;
  r:TResourceStream;
begin
  if FDataSet.AnyDir then
   begin
    tvFolders.Visible:=true;
    spFolders.Visible:=true;
    tvFolders.Left:=0;
    spFolders.Left:=tvFolders.Width;

    r:=TResourceStream.Create(HInstance,'ICODIR',MakeIntResource(23));
    try
      Icon.LoadFromStream(r);
      Application.Icon.Assign(Icon);
    finally
      r.Free;
    end;

    Screen.Cursor:=crHourGlass;
    try
      FCompareFile:=nil;
      FSomeChecked:=false;
      tvFolders.Items.Clear;
      LoadFiles(nil);
    finally
      Screen.Cursor:=crDefault;
    end;

   end
  else
   begin
    tvFolders.Visible:=false;
    spFolders.Visible:=false;
    FCompareFile:=nil;
    FSomeChecked:=false;
    tvFolders.Items.Clear;

    r:=TResourceStream.Create(HInstance,'ICODOC',MakeIntResource(23));
    try
      Icon.LoadFromStream(r);
      Application.Icon.Assign(Icon);
    finally
      r.Free;
    end;

    LoadFromPaths;

   end;

  s:='DirDiff';
  for i:=0 to FDataSet.DataCount-1 do
    s:=s+' - '+FDataSet[i].Path;
  Caption:=s;
  Application.Title:=s;

  lbView.Invalidate;
end;

procedure TfrmDirDiffMain.LoadFiles(np:TTreeNode);
var
  p,s:string;
  n,n1:TTreeNode;
  slFiles,slFolders:TStringList;
  i,j,k:integer;
  d:TDiffFileInfo;
begin
  slFiles:=TStringList.Create;
  slFolders:=TStringList.Create;
  try
    slFiles.Sorted:=true;
    slFolders.Sorted:=true;
    //TODO: threaded
    for i:=0 to FDataSet.DataCount-1 do
     begin
      p:='';
      if (np=nil) or (TDiffFileInfo(np.Data).Info[i].Name<>'') then
       begin
        n:=np;
        while (n<>nil) do
         begin
          //p:=n.Text+PathDelim+p;
          p:=TDiffFileInfo(n.Data).Info[i].Name+PathDelim+p;
          n:=n.Parent;
         end;
        FDataSet[i].ListFiles(p,i,slFolders,slFiles);
       end;
     end;
    for i:=0 to slFolders.Count-1 do
     begin
      d:=slFolders.Objects[i] as TDiffFileInfo;
      slFolders.Objects[i]:=nil;
      //assert d.IsDir
      k:=0;
      while (k<FDataSet.DataCount) and (d.Info[k].Name='') do inc(k);
      if k=FDataSet.DataCount then s:=slFolders[i] else s:=d.Info[k].Name;
      n:=tvFolders.Items.AddChild(np,s);
      n.HasChildren:=true;
      n.Data:=d;
      j:=d.GetIconIndex(FDataSet.IgnoreDates);
      n.ImageIndex:=j;
      n.SelectedIndex:=j;
      n.StateIndex:=1;
     end;
    n1:=nil;
    for i:=0 to slFiles.Count-1 do
     begin
      d:=slFiles.Objects[i] as TDiffFileInfo;
      slFiles.Objects[i]:=nil;
      k:=0;
      while (k<FDataSet.DataCount) and (d.Info[k].Name='') do inc(k);
      if k=FDataSet.DataCount then s:=slFolders[i] else s:=d.Info[k].Name;
      n:=tvFolders.Items.AddChild(np,s);
      n.Data:=d;
      j:=d.GetIconIndex(FDataSet.IgnoreDates);
      n.ImageIndex:=j;
      n.SelectedIndex:=j;
      n.StateIndex:=1;
      if (n1=nil) and (j=iiFileComparing) then n1:=n;
     end;
    if n1<>nil then
     begin
      if (FCompareFile=nil) or
        (FCompareFile.AbsoluteIndex>n1.AbsoluteIndex) then
       begin
        FCompareFile:=n1;
        FDataSet.Queue(djFileCompare,n1.AbsoluteIndex);
       end;
     end;
  finally
    slFiles.Free;
    slFolders.Free;
  end;
end;

procedure TfrmDirDiffMain.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  c:TCanvas;
  np:TTreeNode;
  x,x1,i:integer;
  s:string;
  d:TDiffFileInfo;
const
  QueueFlashColors:array[0..3] of TColor=($DDDDDD,$00CCFF,$00BBDD,$00DDFF);
begin
  c:=StatusBar1.Canvas;
  c.Font.Assign(Font);
  c.Brush.Style:=bsSolid;
  c.Pen.Style:=psClear;
  x:=Rect.Left+2;
  np:=tvFolders.Selected;
  if tvFolders.Visible and (np<>nil) then
   begin
    for i:=0 to FDataSet.DataCount-1 do
     begin
      c.Brush.Color:=CLevel(DiffColors[i mod DiffColorsCount]);
      d:=np.Data;
      if d.Info[i].Name='' then s:=' - ' else
        s:=' '+d.Info[i].Name+' '+IntToStr(d.Info[i].FileSize)+' '+
          FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',d.Info[i].LastMod)+' ';
      x1:=c.TextWidth(s);
      c.TextOut(x,Rect.Top,s);
      inc(x,x1+4);
     end;
   end;
  s:=FDataSet.QueueInfo;
  if s='' then
   begin
    tiUpdate.Enabled:=false;
    FQueueFlash:=0;
    c.Brush.Color:=clBtnFace;
    c.Rectangle(x,Rect.Top,Rect.Right,Rect.Bottom);
   end
  else
   begin
    c.Brush.Color:=QueueFlashColors[FQueueFlash and 3];
    inc(FQueueFlash);
    c.TextOut(x,Rect.Top,s+' ');
    tiUpdate.Enabled:=true;
   end;
end;

procedure TfrmDirDiffMain.tvFoldersExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if tvFolders.Selected=nil then tvFolders.Selected:=Node;
  AllowExpansion:=true;
  if Node.HasChildren and (Node.Count=0) then
   begin
    Node.HasChildren:=false;
    Screen.Cursor:=crHourGlass;
    try
      LoadFiles(Node);
    finally
      Screen.Cursor:=crDefault;
    end;
   end;
end;

procedure TfrmDirDiffMain.tvFoldersChange(Sender: TObject; Node: TTreeNode);
var
  i:integer;
  p:string;
  n:TTreeNode;
  r:array of string;
begin
  if Screen.Cursor=crHourGlass then Exit;
  StatusBar1.Invalidate;
  Screen.Cursor:=crHourGlass;
  try
    SetLength(r,FDataSet.DataCount);
    i:=0;
    while i<FDataSet.DataCount do
     begin
      p:='';
      if TDiffFileInfo(Node.Data).Info[i].Name<>'' then
       begin
        n:=Node;
        while (n<>nil) do
         begin
          p:=PathDelim+TDiffFileInfo(n.Data).Info[i].Name+p;
          n:=n.Parent;
         end;
        end;
      r[i]:=p;
      inc(i);
     end;
    lbView.Count:=0;
    lbView.Invalidate;
    imgOverview.Picture.Bitmap:=nil;
    FSkipXML:=false;
    FDataSet.LoadContent(r,TDiffFileInfo(Node.Data).IsDir,imgOverview.Height);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmDirDiffMain.lbViewDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  c:TCanvas;
  i:integer;
begin
  c:=lbView.Canvas;
  i:=FDataSet.DrawLine(c,Rect,State,Index);//,lbView.TopIndex);
  //TODO: return value max width!
  if lbView.ScrollWidth<i then lbView.ScrollWidth:=i;
  UpdateViewPort(false);
end;

procedure TfrmDirDiffMain.UpdateViewPort(Reset:boolean);
var
  i:integer;
begin
  if lbView.Count<>0 then
   begin
    i:=imgOverview.Height*lbView.TopIndex div lbView.Count;
    if Reset then
      FDataSet.Queue(djOverview,imgOverview.Height);
    if Reset or (vp1<>i) then
     begin
      vp1:=i;
      vp2:=(lbView.ClientHeight*imgOverview.Height) div
        (lbView.ItemHeight*lbView.Count);
      shViewPort.Top:=vp1;
      shViewPort.Height:=vp2;
     end;
   end;
end;

procedure TfrmDirDiffMain.imgOverviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
   begin
    ListToPx(Y);
    if not lbView.Focused then lbView.SetFocus;
   end;
end;

procedure TfrmDirDiffMain.imgOverviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
   begin
    ListToPx(Y);
    if not lbView.Focused then lbView.SetFocus;
   end;
end;

procedure TfrmDirDiffMain.ListToPx(Y:integer);
var
  i,j:integer;
begin
  i:=lbView.Count*Y div imgOverview.Height;
  j:=i-((lbView.ClientHeight div lbView.ItemHeight) div 2);
  if j<0 then j:=0;
  lbView.TopIndex:=j;
  lbView.ItemIndex:=i;
  //if not lbView.Focused then lbView.SetFocus;
end;

procedure TfrmDirDiffMain.ListToLine(Idx:integer);
var
  i:integer;
begin
  if (Idx<>-1) and (lbView.Count<>0) and (Idx<lbView.Count) then
   begin
    i:=Idx-((lbView.ClientHeight div lbView.ItemHeight) div 2);
    if i<0 then i:=0;
    lbView.Items.BeginUpdate;
    try
      lbView.TopIndex:=i;
      lbView.ItemIndex:=Idx;
      lbView.ClearSelection;
      lbView.Selected[Idx]:=true;
    finally
      lbView.Items.EndUpdate;
    end;
    //UpdateViewPort(false);//?
    //if not lbView.Focused then lbView.SetFocus;
   end;
end;

procedure TfrmDirDiffMain.WMListCount(var Msg: TMessage);
  procedure AddXmlNode(i:integer;x:IXMLDOMNode);
  var
    n:TTreeNode;
    d:TDiffXmlInfo;
    j:integer;
  begin
    if x<>nil then
     begin
      n:=tvXML.Items.GetFirstNode;
      while (n<>nil) and (TDiffXmlInfo(n.Data).NodeType<>x.nodeType) do
        n:=n.GetNextSibling;
      if n=nil then
       begin
        n:=tvXML.Items.AddChild(nil,FDataSet.XmlDisplay(x));
        d:=TDiffXmlInfo.Create(FDataSet.DataCount);
        n.Data:=d;
       end
      else
        d:=n.Data;
      d.Info[i].Node:=x;
      j:=d.GetIconIndex;
      n.ImageIndex:=j;
      n.SelectedIndex:=j;
      n.HasChildren:=n.HasChildren or ((x.childNodes.length<>0)
        or ((x.attributes<>nil) and (x.attributes.length<>0)));
     end;
  end;
var
  i:integer;
  d:TDiffFileInfo;
begin
  //TODO: if Msg.LParam=jobindex?
  lbView.ScrollWidth:=0;
  lbView.Count:=Msg.WParam;
  if FResetToLine=-1 then
    ListToLine(Msg.LParam)
  else
   begin
    lbView.TopIndex:=FResetToTop;
    lbView.ItemIndex:=FResetToLine;
    FResetToTop:=-1;
    FResetToLine:=-1;
   end;
  UpdateViewPort(true);

  if tvFolders.Selected<>nil then
   begin
    d:=TDiffFileInfo(tvFolders.Selected.Data);
    for i:=0 to FDataSet.DataCount-1 do
      if FDataSet[i].LastFilePath<>'' then
       begin
        d.Info[i].FileSize:=FDataSet[i].LastFileSize;
        d.Info[i].LastMod:=FDataSet[i].LastFileTimeStamp;
       end;
   end;

  if FSkipXML then FSkipXML:=false else
    if FDataSet.AnyXML then
     begin
      tvXML.Visible:=true;
      spXML.Visible:=true;
      if tvFolders.Visible then
        i:=tvFolders.Width+spFolders.Width
      else
        i:=0;
      tvXML.Left:=i;
      spXML.Left:=i+tvXML.Width;

      Screen.Cursor:=crHourGlass;
      tvXML.Items.BeginUpdate;
      try
        tvXML.Items.Clear;
        for i:=0 to FDataSet.DataCount-1 do
          if FDataSet[i].XmlDoc<>nil then
           begin
            AddXmlNode(i,FDataSet[i].XmlDoc.doctype);
            AddXmlNode(i,FDataSet[i].XmlDoc.definition);
            //AddXmlNode(i,FDataSet[i].XmlDoc.namespaces);
           end;
        ExpandXmlNodes(nil);
      finally
        tvXML.Items.EndUpdate;
        Screen.Cursor:=crDefault;
      end;

     end
    else
     begin
      tvXML.Visible:=false;
      spXML.Visible:=false;
     end;
end;

procedure TfrmDirDiffMain.WMPreview(var Msg: TMessage);
begin
  if Msg.WParam=0 then
    Application.Minimize //see FormShow
  else
    imgOverview.Picture.Bitmap:=TBitmap(Msg.WParam);
end;

procedure TfrmDirDiffMain.FormResize(Sender: TObject);
begin
  if Visible and (FDataSet<>nil) and not(FClosing) then
    FDataSet.Queue(djOverview,imgOverview.Height);
end;

procedure TfrmDirDiffMain.LoadFromPaths;
var
  i:integer;
  r:array of string;
begin
  StatusBar1.Invalidate;
  Screen.Cursor:=crHourGlass;
  try
    SetLength(r,FDataSet.DataCount);
    for i:=0 to FDataSet.DataCount-1 do r[i]:=FDataSet[i].Path;
    FSkipXML:=false;
    FDataSet.LoadContent(r,false,imgOverview.Height);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmDirDiffMain.shViewPortMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imgOverviewMouseDown(Sender,Button,Shift,X+shViewPort.Left,Y+shViewPort.Top);
end;

procedure TfrmDirDiffMain.shViewPortMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  imgOverviewMouseMove(Sender,Shift,X+shViewPort.Left,Y+shViewPort.Top);
end;

procedure TfrmDirDiffMain.miPrevClick(Sender: TObject);
begin
  ListToLine(FDataSet.FindNext(lbView.ItemIndex,-1));
end;

procedure TfrmDirDiffMain.miNextClick(Sender: TObject);
begin
  ListToLine(FDataSet.FindNext(lbView.ItemIndex,+1));
end;

procedure TfrmDirDiffMain.WMQueueInfo(var Msg: TMessage);
begin
  case Msg.WParam of
    0:StatusBar1.Invalidate;
    1:lbView.Invalidate;
  end;
end;

procedure TfrmDirDiffMain.tiUpdateTimer(Sender: TObject);
begin
  StatusBar1.Invalidate;
end;

procedure TfrmDirDiffMain.WMCompareNext(var Msg: TMessage);
var
  i:integer;
  p:string;
  n:TTreeNode;
begin
  if Msg.WParam=0 then
   begin
    //fetch paths
    if FCompareFile=nil then
      Msg.Result:=-1
    else
     begin
      if TDiffFileInfo(FCompareFile.Data).IsDir then
        Msg.Result:=-1//TODO: find next?
      else
       begin
        i:=0;
        while i<FDataSet.DataCount do
         begin
          p:='';
          if TDiffFileInfo(FCompareFile.Data).Info[i].Name<>'' then
           begin
            n:=FCompareFile;
            while (n<>nil) do
             begin
              p:=PathDelim+TDiffFileInfo(n.Data).Info[i].Name+p;
              n:=n.Parent;
             end;
            end;
          FDataSet.Data[i].CompareFile:=p;
          inc(i);
         end;
        Msg.Result:=FCompareFile.AbsoluteIndex;
       end;
     end;
   end
  else
   begin
    if FCompareFile<>nil then
      case Msg.WParam of
        1://is equal
         begin
          FCompareFile.ImageIndex:=iiFileEqual;
          FCompareFile.SelectedIndex:=iiFileEqual;
         end;
        2://is unequal
         begin
          FCompareFile.ImageIndex:=iiFileUnequal;
          FCompareFile.SelectedIndex:=iiFileUnequal;
         end;
       end;
    //find next
    while (FCompareFile<>nil) and (FCompareFile.ImageIndex<>iiFileComparing) do
      FCompareFile:=FCompareFile.GetNext;
    if FCompareFile=nil then
      Msg.Result:=-1
    else
     begin
      Msg.Result:=FCompareFile.AbsoluteIndex;
      FCompareFile.ImageIndex:=iiFileNone;
      //FCompareFile.SelectedIndex:=iiFileNone;
     end;
  end;
end;

procedure TfrmDirDiffMain.txtPathExit(Sender: TObject);
var
  e:TEdit;
begin
  e:=Sender as TEdit;
  if FDataSet[e.Tag].Path<>e.Text then
   begin
    FDataSet[e.Tag].Path:=e.Text;
    miRefreshClick(Sender);
   end;
end;

procedure TfrmDirDiffMain.miSearchClick(Sender: TObject);
var
  y1,y2,x1,x2:integer;
begin
  if (FDataSet<>nil) and (FDataSet.DataCount<>0) then
   begin
    y1:=btnAddFile.Height;
    y2:=(y1+8)*FDataSet.DataCount+8;
    x1:=btnFind.Width;
    x2:=panTop.Width-24-x1;
    txtFind.SetBounds(btnAddFile.Left,y2,x2,y1);
    btnFind.SetBounds(x2+16,y2,x1,y1);
    panTop.Height:=y1+y2+8;
    txtFind.Visible:=true;
    btnFind.Visible:=true;
    txtFind.SelectAll;
    txtFind.SetFocus;
    FDataSet.Queue(djOverview,imgOverview.Height);
   end;
end;

procedure TfrmDirDiffMain.txtFindKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
   begin
    Key:=#0;
    btnFind.Click;
   end;
end;

procedure TfrmDirDiffMain.miFindNextClick(Sender: TObject);
begin
  if txtFind.Visible then
   begin
    ListToLine(FDataSet.FindNextText(lbView.ItemIndex,+1,txtFind.Text));
    if not lbView.Focused then lbView.SetFocus;
   end
  else
    miSearchClick(Sender);
end;

procedure TfrmDirDiffMain.miFindPreviousClick(Sender: TObject);
begin
  if txtFind.Visible then
   begin
    ListToLine(FDataSet.FindNextText(lbView.ItemIndex,-1,txtFind.Text));
    if not lbView.Focused then lbView.SetFocus;
   end
  else
    miSearchClick(Sender);
end;

procedure TfrmDirDiffMain.Selectall1Click(Sender: TObject);
var
  i,j:integer;
begin
  if lbView.Focused then
   begin
    lbView.Items.BeginUpdate;
    try
      i:=lbView.TopIndex;
      j:=lbView.ItemIndex;
      lbView.SelectAll;
      lbView.TopIndex:=i;
      lbView.ItemIndex:=j;
    finally
      lbView.Items.EndUpdate;
    end;
   end
  else
    if ActiveControl is TEdit then
      (ActiveControl as TEdit).SelectAll;
end;

procedure TfrmDirDiffMain.miPreviousFileClick(Sender: TObject);
var
  n,n1:TTreeNode;
  i:integer;
begin
  Screen.Cursor:=crHourGlass;
  try
    n:=tvFolders.Selected;
    while n<>nil do
     begin
      //previous
      n1:=n.getPrevSibling;
      while (n<>nil) and (n1=nil) do
       begin
        n:=n.Parent;
        if n=nil then n1:=nil else n1:=n.getPrevSibling;
       end;
      if n1<>nil then
       begin
        n:=n1;
        while n.HasChildren or (n.Count<>0) do
         begin
          if n.HasChildren and (n.Count=0) then
           begin
            n.HasChildren:=false;
            LoadFiles(n);
           end;
          n1:=n.GetLastChild;
          if n1<>nil then n:=n1;
         end;
        //still comparing?
        i:=0;
        while n.ImageIndex in [iiFileNone,iiFileComparing] do
         begin
          //TODO: check djFileCompare running?
          Application.ProcessMessages;
          Sleep(25);
          inc(i);
          if i=200 then
            raise Exception.Create('Timed out waiting for pending file compare');
         end;
        //is it non-equal?
        if (n.ImageIndex>=iiFileNone) and (n.ImageIndex<>iiFileEqual) then
         begin
          Screen.Cursor:=crDefault;//see tvFoldersChange
          tvFolders.Selected:=n;
          n:=nil;//end loop
         end;
       end;
     end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmDirDiffMain.miNextFileClick(Sender: TObject);
var
  n,n1:TTreeNode;
  i:integer;
  fromtop:boolean;
begin
  Screen.Cursor:=crHourGlass;
  try
    n:=tvFolders.Selected;
    fromtop:=n=nil;
    while (n<>nil) or fromtop do
     begin
      //next
      if (n=nil) and fromtop then
       begin
        n1:=tvFolders.Items.GetFirstNode;
        n:=n1;
        fromtop:=false;
       end
      else
        n1:=n.getNextSibling;
      while (n<>nil) and (n1=nil) do
       begin
        n:=n.Parent;
        if n=nil then n1:=nil else n1:=n.getNextSibling;
       end;
      if n1<>nil then
       begin
        n:=n1;
        while n.HasChildren or (n.Count<>0) do
         begin
          if n.HasChildren and (n.Count=0) then
           begin
            n.HasChildren:=false;
            LoadFiles(n);
           end;
          n1:=n.GetFirstChild;
          if n1<>nil then n:=n1;
         end;
        //still comparing?
        i:=0;
        while n.ImageIndex in [iiFileNone,iiFileComparing] do
         begin
          //TODO: check djFileCompare running?
          Application.ProcessMessages;
          Sleep(25);
          inc(i);
          if i=200 then
            raise Exception.Create('Timed out waiting for pending file compare');
         end;
        //is it non-equal?
        if (n.ImageIndex>=iiFileNone) and (n.ImageIndex<>iiFileEqual) then
         begin
          Screen.Cursor:=crDefault;//see tvFoldersChange
          tvFolders.Selected:=n;
          n:=nil;//end loop
         end;
       end;
     end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmDirDiffMain.miGotoLineClick(Sender: TObject);
var
  f:TfrmDirDiffGoToLine;
  i:integer;
begin
  f:=TfrmDirDiffGoToLine.Create(nil);
  try
    for i:=0 to FDataSet.DataCount-1 do
      f.cbWhere.Items.Add(IntToStr(i+1)+': '+FDataSet.Data[0].Path);
    if f.ShowModal=mrOk then
     begin
      ListToLine(FDataSet.FindLine(StrToInt(f.txtLineNumber.Text),
        f.cbWhere.ItemIndex));
      if not lbView.Focused then lbView.SetFocus;
     end;
  finally
    f.Free;
  end;
end;

procedure TfrmDirDiffMain.miCopyClick(Sender: TObject);
var
  i:integer;
  s:string;
begin
  if lbView.Focused then
   begin
    //TODO: include line numbers? (only when shift down?)
    s:='';
    for i:=0 to lbView.Count-1 do
      if lbView.Selected[i] then
        s:=s+FDataSet.LineText(i)+#13#10;
    Clipboard.AsText:=s;
   end
  else
    if ActiveControl is TEdit then
      (ActiveControl as TEdit).CopyToClipboard;
end;

procedure TfrmDirDiffMain.miShowDragHandleClick(Sender: TObject);
var
  f:TfrmDiffHandle;
begin
  f:=TfrmDiffHandle.Create(Application);
  f.Subject:=Self;
  f.Show;
end;

procedure TfrmDirDiffMain.AddSource(const FilePath: string);
var
  d:TDiffData;
begin
  d:=TDiffData.Create;
  d.Path:=FilePath;
  FDataSet.AddData(d);
  CreateSetUI(d);
  UpdateUI;
end;

procedure TfrmDirDiffMain.miXmlOffClick(Sender: TObject);
begin
  miXmlOff.Checked:=true;
  FDataSet.XmlAutoDetect:=false;
  FDataSet.XmlDomTree:=false;
  miRefresh.Click;
end;

procedure TfrmDirDiffMain.miXmlAutoClick(Sender: TObject);
begin
  miXmlAuto.Checked:=true;
  FDataSet.XmlAutoDetect:=true;
  FDataSet.XmlDomTree:=false;
  miRefresh.Click;
end;

procedure TfrmDirDiffMain.miXmlOnClick(Sender: TObject);
begin
  miXmlOn.Checked:=true;
  FDataSet.XmlAutoDetect:=false;
  FDataSet.XmlDomTree:=true;
  miRefresh.Click;
end;

procedure TfrmDirDiffMain.tvFoldersDeletion(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Data<>nil then TDiffFileInfo(Node.Data).Free;
end;

procedure TfrmDirDiffMain.tvXMLDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Node.Data<>nil then TDiffXmlInfo(Node.Data).Free;
end;

procedure TfrmDirDiffMain.tvXMLChange(Sender: TObject; Node: TTreeNode);
var
  i:integer;
  r:array of string;
  x:IXMLDOMNode;
begin
  if Screen.Cursor=crHourGlass then Exit;
  StatusBar1.Invalidate;
  Screen.Cursor:=crHourGlass;
  try
    SetLength(r,FDataSet.DataCount);
    for i:=0 to FDataSet.DataCount-1 do
     begin
      x:=TDiffXmlInfo(Node.Data).Info[i].Node;
      if x=nil then r[i]:='' else r[i]:='xml:'+x.xml;
     end;
    lbView.Count:=0;
    lbView.Invalidate;
    imgOverview.Picture.Bitmap:=nil;
    FSkipXML:=true;
    FDataSet.LoadContent(r,false,imgOverview.Height);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmDirDiffMain.tvXMLExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if tvXML.Selected=nil then tvXML.Selected:=Node;
  AllowExpansion:=true;
  if Node.HasChildren and (Node.Count=0) then
   begin
    Node.HasChildren:=false;
    Screen.Cursor:=crHourGlass;
    tvXML.Items.BeginUpdate;
    try
      ExpandXmlNodes(Node);
    finally
      tvXML.Items.EndUpdate;
      Screen.Cursor:=crDefault;
    end;
   end;
end;

procedure TfrmDirDiffMain.ExpandXmlNodes(n: TTreeNode);

  procedure PerformMatching1(di:integer;m:IXMLDOMNamedNodeMap);
  var
    x:IXMLDOMNode;
    p:TTreeNode;
    d:TDiffXmlInfo;
    i,j:integer;
    s:string;
  begin
    if m=nil then Exit;
    for i:=0 to m.length-1 do
     begin
      x:=m.item[i];
      if n=nil then
        p:=tvXML.Items.GetFirstNode
      else
        p:=n.getFirstChild;
      s:=FDataSet.XmlDisplay(x);
      while (p<>nil) and not((TDiffXmlInfo(p.Data).NodeType=x.nodeType)
        and (p.Text=s)) do p:=p.GetNextSibling;
      if p=nil then
       begin
        p:=tvXML.Items.AddChild(n,s);
        d:=TDiffXmlInfo.Create(FDataSet.DataCount);
        p.Data:=d;
       end
      else
        d:=p.Data;
      d.Info[di].Node:=x;
      j:=d.GetIconIndex;
      p.ImageIndex:=j;
      p.SelectedIndex:=j;
      //p.HasChildren:=p.HasChildren or ((x.childNodes.length<>0)
      //  or ((x.attributes<>nil) and (x.attributes.length<>0)));
     end;
  end;

  procedure PerformMatching2(di:integer;l:IXMLDOMNodeList);
  var
    x:IXMLDOMNode;
    p:TTreeNode;
    d:TDiffXmlInfo;
    i,j:integer;
    s:string;
  begin
    if l=nil then Exit;
    for i:=0 to l.length-1 do
     begin
      x:=l.item[i];
      if n=nil then
        p:=tvXML.Items.GetFirstNode
      else
        p:=n.getFirstChild;
      s:=FDataSet.XmlMatch(x);
      while (p<>nil) and not((TDiffXmlInfo(p.Data).NodeType=x.nodeType)
        and (TDiffXmlInfo(p.Data).Match=s)) do p:=p.GetNextSibling;
      if p=nil then
       begin
        p:=tvXML.Items.AddChild(n,FDataSet.XmlDisplay(x));
        d:=TDiffXmlInfo.Create(FDataSet.DataCount);
        d.Match:=s;
        p.Data:=d;
       end
      else
        d:=p.Data;
      d.Info[di].Node:=x;
      j:=d.GetIconIndex;
      p.ImageIndex:=j;
      p.SelectedIndex:=j;
      p.HasChildren:=p.HasChildren or ((x.childNodes.length<>0)
        or ((x.attributes<>nil) and (x.attributes.length<>0)));
     end;
  end;

var
  x:array of IXMLDOMNode;
  i:integer;
  d:array of IDiffSource;
begin
  //expect called does BeginUpdate/EndUpdate

  SetLength(x,FDataSet.DataCount);
  if n=nil then
   begin
    for i:=0 to FDataSet.DataCount-1 do
      if FDataSet[i].XmlDoc=nil then
        x[i]:=nil
      else
        x[i]:=FDataSet[i].XmlDoc;
   end
  else
   begin
    for i:=0 to FDataSet.DataCount-1 do
      x[i]:=TDiffXmlInfo(n.Data).Info[i].Node;
   end;

  if FDataSet.XmlAttrIgnSeq then
   begin
    for i:=0 to FDataSet.DataCount-1 do
      if x[i]<>nil then
        PerformMatching1(i,x[i].attributes);
   end
  else
   begin
    SetLength(d,FDataSet.DataCount);
    for i:=0 to FDataSet.DataCount-1 do
      d[i]:=TDiffNodeSource1.Create(FDataSet,x[i]);
    PerformDiff(d,TDiffNodeLister.Create(tvXML.Items,n));
    for i:=0 to FDataSet.DataCount-1 do d[i]:=nil;
   end;

  if FDataSet.XmlElemIgnSeq then
   begin
    for i:=0 to FDataSet.DataCount-1 do
      if x[i]<>nil then
        PerformMatching2(i,x[i].childNodes);
   end
  else
   begin
    SetLength(d,FDataSet.DataCount);
    for i:=0 to FDataSet.DataCount-1 do
      if x[i]=nil then
        d[i]:=TDiffNodeSource2.Create(FDataSet,nil)
      else
        d[i]:=TDiffNodeSource2.Create(FDataSet,x[i]);
    PerformDiff(d,TDiffNodeLister.Create(tvXML.Items,n));
    for i:=0 to FDataSet.DataCount-1 do d[i]:=nil;
   end;

end;

procedure TfrmDirDiffMain.miDiffExpandAllClick(Sender: TObject);
var
  n:TTreeNode;
begin
  n:=tvFolders.Items.GetFirstNode;
  while n<>nil do
   begin
    n.Expand(true);
    n:=n.getNextSibling;
   end;
end;

procedure TfrmDirDiffMain.miDiffCollapseAllClick(Sender: TObject);
var
  n:TTreeNode;
begin
  n:=tvFolders.Items.GetFirstNode;
  while n<>nil do
   begin
    n.Collapse(true);
    n:=n.getNextSibling;
   end;
end;

procedure TfrmDirDiffMain.miXmlExpandAllClick(Sender: TObject);
var
  n:TTreeNode;
begin
  n:=tvXML.Items.GetFirstNode;
  while n<>nil do
   begin
    n.Expand(true);
    n:=n.getNextSibling;
   end;
end;

procedure TfrmDirDiffMain.miXmlCollapseAllClick(Sender: TObject);
var
  n:TTreeNode;
begin
  n:=tvXML.Items.GetFirstNode;
  while n<>nil do
   begin
     n.Collapse(true);
     n:=n.getNextSibling;
   end;
end;

procedure TfrmDirDiffMain.XML1Click(Sender: TObject);
begin
  miXmlExpandAll.Enabled:=tvXML.Visible;
  miXmlCollapseAll.Enabled:=tvXML.Visible;
end;

procedure TfrmDirDiffMain.File1Click(Sender: TObject);
begin
  miDiffExpandAll.Enabled:=tvFolders.Visible;
  miDiffCollapseAll.Enabled:=tvFolders.Visible;
end;

procedure TfrmDirDiffMain.miRemoveClick(Sender: TObject);
var
  i,j,y,z:integer;
  e:TEdit;
  m:TMenuItem;
begin
  y:=btnAddFile.Height;
  z:=(Sender as TComponent).Tag-1;
  if FFilesSource>z then FFilesSource:=-1;
  FDataSet.DropData(z);
  txtFind.Visible:=false;
  btnFind.Visible:=false;
  if FDataSet.DataCount=0 then
   begin
    btnAddFile.Top:=8;
    btnAddFile.Visible:=true;
    btnAddFolder.Top:=8;
    btnAddFolder.Visible:=true;
    panTop.Height:=y+16;
    lbView.Count:=0;
   end
  else
   begin
    for i:=z to FDataSet.DataCount-1 do
     begin
      e:=FDataSet[i].Display1 as TEdit;
      e.Color:=CLevel(DiffColors[i mod DiffColorsCount]);
      e.Tag:=i;
      e.SetBounds(8,8+(8+y)*i,panTop.ClientWidth-16,e.Height);//assert j=e.Height?
      m:=FDataSet[i].Display2 as TMenuItem;
      m.Caption:='-'+IntToStr(i+1)+'-';
      m.Tag:=i+1;
      for j:=0 to m.Count-1 do m.Items[j].Tag:=i+1;
     end;
    panTop.Height:=(y+8)*FDataSet.DataCount+8;
   end;
  UpdateUI;
end;

procedure TfrmDirDiffMain.miSourceClick(Sender: TObject);
var
  m1,m2:TMenuItem;
  i:integer;
  s:string;
begin
  m1:=Sender as TMenuItem;
  i:=m1.Parent.IndexOf(m1);
  if FFilesSource<>-1 then
   begin
    m2:=FDataSet[FFilesSource].Display2 as TMenuItem;
    if FDataSet[FFilesSource].ReadOnly then s:='-' else s:='>>>';
    m2.Caption:=s+IntToStr(FFilesSource+1)+'-';
    m2.Items[i].Checked:=false;
    FFilesSource:=-1;
    tvFolders.StateImages:=nil;
   end
  else
    m2:=nil;
  if m1.Parent<>m2 then
   begin
    FFilesSource:=m1.Tag-1;
    tvFolders.StateImages:=ImageList2;
    miClearSelFiles.Enabled:=true;
    if m1.Parent.Items[i+1].Checked then s:='-' else s:='>>>';//read-only?
    m1.Parent.Caption:=//(FDataSet[FFilesSource].Display2 as TMenuItem).Caption:=
      s+IntToStr(FFilesSource+1)+'>>>';
    m1.Checked:=true;
   end;
end;

procedure TfrmDirDiffMain.miReadOnlyClick(Sender: TObject);
var
  m1:TMenuItem;
  s:string;
  i:integer;
begin
  m1:=Sender as TMenuItem;
  m1.Checked:=not(m1.Checked);
  FDataSet[m1.Tag-1].ReadOnly:=m1.Checked;
  if m1.Checked then s:='-' else s:='>>>';
  s:=s+IntToStr(m1.Tag);
  if FFilesSource=m1.Tag-1 then s:=s+'>>>' else s:=s+'-';
  m1.Parent.Caption:=s;
  i:=m1.Parent.IndexOf(m1);
  m1.Parent.Items[i+1].Enabled:=not(m1.Checked);//Update
  m1.Parent.Items[i+2].Enabled:=not(m1.Checked);//Delete
  m1.Parent.Items[i+5].Enabled:=not(m1.Checked);//Update selected
  m1.Parent.Items[i+6].Enabled:=not(m1.Checked);//Delete selected
end;

function TfrmDirDiffMain.tvFoldersCheck(NN:TTreeNode;X,Y:integer):boolean;
var
  n,n0,n1:TTreeNode;
  r:TRect;
  i,j:integer;
begin
  Result:=true;//default
  if tvFolders.StateImages<>nil then
   begin
    if NN=nil then
     begin
      n:=tvFolders.GetNodeAt(X,Y);
      if n<>nil then
       begin
        r:=n.DisplayRect(true);
        if not(r.Left-x in [21..34]) then n:=nil;
       end;
     end
    else
      n:=NN;
    if n<>nil then
     begin
      case n.StateIndex of
        1://was clear
         begin
          n.StateIndex:=2;
          FSomeChecked:=true;
         end;
        2://was selected
          n.StateIndex:=1;
        3://was partial
         begin
          n.StateIndex:=1;
          n0:=n.getNextSibling;
          n1:=n.GetNext;
          while n1<>n0 do
           begin
            n1.StateIndex:=1;
            n1:=n1.GetNext;
           end;
         end;
      end;
      n:=n.Parent;
      while n<>nil do
       begin
        n1:=n.getFirstChild;
        i:=0;
        j:=0;
        while (n1<>nil) and (i=0) do
         begin
          case n1.StateIndex of
            1://clear
              if j<>1 then
                if j=0 then j:=1 else i:=3;
            2://selected
              if j<>2 then
                if j=0 then j:=2 else i:=3;
            3://partial
              i:=3;
          end;
          n1:=n1.getNextSibling;
         end;
        if i=0 then
          if j=0 then i:=1 else i:=j;
        n.StateIndex:=i;
        n:=n.Parent;
       end;
      Result:=false;
     end;
   end;
end;

procedure TfrmDirDiffMain.tvFoldersChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
var
  p:TPoint;
begin
  //odd! OnChanging occurs before OnMouseDown! reverted to CursorPos here...
  p:=tvFolders.ParentToClient(ScreenToClient(Mouse.CursorPos));
  AllowChange:=tvFoldersCheck(nil,p.X,p.Y);
  FSkipNodeCheck:=not(AllowChange);
end;

procedure TfrmDirDiffMain.tvFoldersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FSkipNodeCheck then FSkipNodeCheck:=false else
    tvFoldersCheck(nil,X,Y);
end;

procedure TfrmDirDiffMain.miDeleteClick(Sender: TObject);
var
  i:integer;
  n:TTreeNode;
  s:string;
  fo:TSHFileOpStruct;
  d:TDiffFileInfo;
begin
  if MessageBox(Handle,'Some items have been checkemarked, are you sure you want to delete only the focused item?',
    PChar(Caption),MB_YESNO or MB_ICONQUESTION)<>idYes then
    Exit;

  i:=(Sender as TComponent).Tag-1;
  if tvFolders.Visible then
   begin
    n:=tvFolders.Selected;
    s:='';
    while n<>nil do
     begin
      d:=TDiffFileInfo(n.Data);
      if d.Info[i].Name='' then
        raise Exception.Create('File is not present in this location');
      s:=PathDelim+d.Info[i].Name+s;
      n:=n.Parent;
     end;
    s:=FDataSet[i].Path+s;
   end
  else
    s:=FDataSet[i].Path;

  fo.Wnd:=Handle;
  fo.wFunc:=FO_DELETE;
  fo.pFrom:=PChar(s+#0#0);
  fo.pTo:=nil;
  fo.fFlags:=FOF_ALLOWUNDO;
  if SHFileOperation(fo)=0 then
   begin
    n:=tvFolders.Selected;
    if n<>nil then
     begin
      d:=TDiffFileInfo(n.Data);
      d.Info[i].Name:='';
      d.Info[i].FileSize:=0;
      d.Info[i].LastMod:=0.0;
      i:=0;
      while (i<>FDataSet.DataCount) and (d.Info[i].Name='') do inc(i);
      if i=FDataSet.DataCount then
        n.Delete
      else
       begin
        i:=d.GetIconIndex(FDataSet.IgnoreDates);
        n.ImageIndex:=i;
        n.SelectedIndex:=i;
        tvFoldersChange(tvFolders,n);
       end;
     end;
   end
  else
    if not(fo.fAnyOperationsAborted) then
      RaiseLastOSError;
end;

procedure TfrmDirDiffMain.miUpdateClick(Sender: TObject);
var
  i,j:integer;
  n:TTreeNode;
  s1,s2:string;
  fo:TSHFileOpStruct;
  d:TDiffFileInfo;
  cd:boolean;
begin
  if FFilesSource=-1 then
    raise Exception.Create('No location selected as source');
  if FSomeChecked then
    if MessageBox(Handle,'Some items have been checkemarked, are you sure you want to update only the focused item?',
      PChar(Caption),MB_YESNO or MB_ICONQUESTION)<>idYes then
      Exit;

  i:=FFilesSource;
  j:=(Sender as TComponent).Tag-1;
  cd:=false;
  if tvFolders.Visible then
   begin
    n:=tvFolders.Selected;
    s1:='';
    s2:='';
    while n<>nil do
     begin
      d:=TDiffFileInfo(n.Data);
      if d.Info[i].Name='' then
        raise Exception.Create('File is not present in this location');
      s1:=PathDelim+d.Info[i].Name+s1;
      if d.Info[j].Name='' then
       begin
        s2:=PathDelim+d.Info[i].Name+s2;
        cd:=cd or d.IsDir;
       end
      else
        if (s2='') and d.IsDir then
          s2:=PathDelim //copy dir into destination parent dir
        else
          s2:=PathDelim+d.Info[j].Name+s2;
      n:=n.Parent;
     end;
    s1:=FDataSet[i].Path+s1;
    s2:=FDataSet[j].Path+s2;
    if cd then SysUtils.ForceDirectories(ExtractFilePath(s2));
   end
  else
   begin
    s1:=FDataSet[i].Path;
    s2:=FDataSet[j].Path;
   end;

  fo.Wnd:=Handle;
  fo.wFunc:=FO_COPY;
  fo.pFrom:=PChar(s1+#0#0);
  fo.pTo:=PChar(s2+#0#0);
  fo.fFlags:=0;//FOF_ALLOWUNDO;
  if SHFileOperation(fo)=0 then
   begin
    n:=tvFolders.Selected;
    if n<>nil then
     begin
      while n<>nil do
        if TDiffFileInfo(n.Data).Info[j].Name='' then
         begin
          d:=TDiffFileInfo(n.Data);
          d.Info[j]:=d.Info[i];
          j:=d.GetIconIndex(FDataSet.IgnoreDates);
          n.ImageIndex:=j;
          n.SelectedIndex:=j;
          n:=n.Parent;
         end
        else
          n:=nil;
      tvFoldersChange(tvFolders,tvFolders.Selected);
     end;
   end
  else
    if not(fo.fAnyOperationsAborted) then
      RaiseLastOSError;
end;

procedure TfrmDirDiffMain.miClearSelFilesClick(Sender: TObject);
var
  n:TTreeNode;
begin
  n:=tvFolders.Items.GetFirstNode;
  while n<>nil do
   begin
    n.StateIndex:=1;
    n:=n.GetNext;
   end;
end;

procedure TfrmDirDiffMain.ListSelectedFiles(Index: integer; sl: TStringList);
var
  p:TStringList;
  n,n1:TTreeNode;
  any,nonext:boolean;
  s:string;
  i:integer;
  d:TDiffFileInfo;
begin
  p:=TStringList.Create;
  try
    any:=false;
    nonext:=false;
    p.Add(FDataSet[Index].Path+PathDelim);
    n:=tvFolders.Items.GetFirstNode;
    while n<>nil do
     begin
      n1:=nil;
      d:=TDiffFileInfo(n.Data);
      s:=d.Info[Index].Name;
      if s<>'' then
        if n.StateIndex in [2,3] then
         begin
          if n.HasChildren and (n.Count=0) then
           begin
            n.HasChildren:=false;
            LoadFiles(n);
           end;
          n1:=n.getFirstChild;
          if n1=nil then
           begin
            if n.StateIndex=2 then
             begin
              i:=p.Count;
              while i<>0 do
               begin
                dec(i);
                s:=p[i]+s;
               end;
              sl.Add(s);
              any:=true;
             end;
           end
          else
           begin
            p.Add(s+PathDelim);
            nonext:=true;
           end;
         end;

      //next
      if nonext then
       begin
        any:=false;
        nonext:=false;
       end
      else
       begin
        n1:=nil;
        while (n1=nil) and (n<>nil) do
         begin
          n1:=n.getNextSibling;
          if n1=nil then
           begin
            n:=n.Parent;

            //was only dir selected?
            if not(any) and (n<>nil) and (n.StateIndex=2) then
             begin
              s:='';
              i:=p.Count;
              while i<>0 do
               begin
                dec(i);
                s:=p[i]+s;
               end;
              sl.Add(s);
              any:=true;
             end;

            p.Delete(p.Count-1);
           end;
         end;
       end;
      n:=n1;
     end;
  finally
    p.Free;
  end;
end;

procedure TfrmDirDiffMain.miCopyUNCsClick(Sender: TObject);
var
  sl:TStringList;
begin
  sl:=TStringList.Create;
  try
    //TODO: warn/raise when selected with Info[z].Name=''? (also higher up path)
    ListSelectedFiles((Sender as TMenuItem).Tag-1,sl);
    if sl.Count=0 then
      raise Exception.Create('No files selected')
    else
      Clipboard.AsText:=sl.Text;
  finally
    sl.Free;
  end;
end;

procedure TfrmDirDiffMain.miDeleteSelectedClick(Sender: TObject);
var
  sl:TStringList;
  i:integer;
  s:string;
  fo:TSHFileOpStruct;
begin
  sl:=TStringList.Create;
  try
    //TODO: detect+delete empty left-over directories
    ListSelectedFiles((Sender as TMenuItem).Tag-1,sl);
    if sl.Count=0 then
      raise Exception.Create('No files selected')
    else
     begin
      s:='';
      for i:=0 to sl.Count-1 do s:=s+sl[i]+#0;
      fo.Wnd:=Handle;
      fo.wFunc:=FO_DELETE;
      fo.pFrom:=PChar(s+#0);
      fo.pTo:=nil;
      fo.fFlags:=FOF_ALLOWUNDO;
      if SHFileOperation(fo)=0 then
       begin
        //?
        miRefresh.Click;
       end
      else
        if not(fo.fAnyOperationsAborted) then
          RaiseLastOSError;
     end;
  finally
    sl.Free;
  end;
end;

procedure TfrmDirDiffMain.miUpdateSelectedClick(Sender: TObject);
var
  sl:TStringList;
  i:integer;
  s1,s2,d1,d2:string;
  fo:TSHFileOpStruct;
begin
  if FFilesSource=-1 then
    raise Exception.Create('No location selected as source');

  sl:=TStringList.Create;
  try
    d1:=FDataSet[FFilesSource].Path;
    d2:=FDataSet[(Sender as TMenuItem).Tag-1].Path;
    ListSelectedFiles(FFilesSource,sl);
    if sl.Count=0 then
      raise Exception.Create('No files selected')
    else
     begin
      s1:='';
      s2:='';
      for i:=0 to sl.Count-1 do
       begin
        s1:=s1+sl[i]+#0;
        s2:=s2+d2+Copy(sl[i],Length(d1)+1,Length(sl[i])-Length(d1))+#0;
       end;
      fo.Wnd:=Handle;
      fo.wFunc:=FO_COPY;
      fo.pFrom:=PChar(s1+#0);
      fo.pTo:=PChar(s2+#0);
      fo.fFlags:=FOF_MULTIDESTFILES;
      if SHFileOperation(fo)=0 then
       begin
        //?
        miRefresh.Click;
       end
      else
        if not(fo.fAnyOperationsAborted) then
          RaiseLastOSError;
     end;
  finally
    sl.Free;
  end;

end;

procedure TfrmDirDiffMain.AppActivate(Sender: TObject);
var
  i:integer;
  b:boolean;
  fh:THandle;
  fd:TWin32FindData;
  st:TSystemTime;
begin
  if not(FAskingUpdate) then
   begin
    if FSkipAppActivate then
     begin
      FSkipAppActivate:=false;
      Exit;
     end;
    i:=0;
    b:=false;
    while (i<>FDataSet.DataCount) and not(b) do
     begin
      if FDataSet[i].LastFilePath<>'' then
       begin
        fh:=FindFirstFile(PChar(FDataSet[i].LastFilePath),fd);
        if fh=INVALID_HANDLE_VALUE then b:=true else
         begin

          if FileTimeToSystemTime(fd.ftLastWriteTime,st) then
            if Abs(SystemTimeToDateTime(st)-
              FDataSet[i].LastFileTimeStamp)>1/86400 then b:=true;
              
          Windows.FindClose(fh);
         end;
       end;
      inc(i);
     end;

    if b then
     begin
      FAskingUpdate:=true;
      if MessageBox(Handle,'File update detected. Reload files now?',
        PChar(Caption),MB_OKCANCEL or MB_ICONQUESTION)=idOK then
        if tvFolders.Selected=nil then
          miRefresh.Click
        else
          tvFoldersChange(tvFolders,tvFolders.Selected);
      FAskingUpdate:=false;
     end;
   end;
end;

procedure TfrmDirDiffMain.tvFoldersDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  n1,n2:TTreeNode;
  d1,d2:TDiffFileInfo;
  i:integer;
begin
  n1:=tvFolders.Selected;
  n2:=tvFolders.DropTarget;
  if (n1=nil) or (n2=nil) then
    Accept:=false
  else
   begin
    d1:=TDiffFileInfo(n1.Data);
    d2:=TDiffFileInfo(n2.Data);
    i:=0;
    while (i<>FDataSet.DataCount) and
      (((d1.Info[i].Name='') and (d2.Info[i].Name<>'')) or
      ((d1.Info[i].Name<>'') and (d2.Info[i].Name=''))) do inc(i);
    Accept:=i=FDataSet.DataCount;
   end;
end;

procedure TfrmDirDiffMain.tvFoldersDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  n1,n2:TTreeNode;
  d1,d2:TDiffFileInfo;
  i:integer;
  s:string;
begin
  n1:=tvFolders.Selected;
  n2:=tvFolders.DropTarget;
  if (n1<>nil) and (n2<>nil) then
   begin
    d1:=TDiffFileInfo(n1.Data);
    d2:=TDiffFileInfo(n2.Data);

    s:='';
    for i:=0 to FDataSet.DataCount-1 do
     begin
      if d2.Info[i].Name='' then d2.Info[i].Name:=d1.Info[i].Name;
      s:=s+' :: '+d2.Info[i].Name;
     end;
    n1.Delete;
    i:=d2.GetIconIndex(FDataSet.IgnoreDates);
    n2.ImageIndex:=i;
    n2.SelectedIndex:=i;
    n2.Text:=Copy(s,5,Length(s)-4);
    tvFolders.Selected:=n2;
   end;
end;

procedure TfrmDirDiffMain.tvFoldersKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key=' ') and (tvFolders.StateImages<>nil)
    and (tvFolders.Selected<>nil) then
    tvFoldersCheck(tvFolders.Selected,0,0);
end;

end.
