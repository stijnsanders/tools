unit shexRename1;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TfrmShexRename }

  TfrmShexRename = class(TForm)
    btnReset: TButton;
    btnClose: TButton;
    btnGo: TButton;
    btnAddFiles: TButton;
    cbFolders: TCheckBox;
    cbRenameMask: TComboBox;
    OpenDialog1: TOpenDialog;
    txtNewFileNames: TMemo;
    panLeft: TPanel;
    panRight: TPanel;
    panBottom: TPanel;
    panLeftTop: TPanel;
    panRightTop: TPanel;
    Splitter1: TSplitter;
    txtOriginalFileNames: TMemo;
    procedure btnAddFilesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure cbFoldersChange(Sender: TObject);
    procedure cbRenameMaskChange(Sender: TObject);
  private
    FFiles:TStringList;
    procedure ListFiles;
    procedure RenderNames;
  protected
    procedure DoCreate; override;
    procedure DoClose(var CloseAction: TCloseAction); override;
  end;

var
  frmShexRename: TfrmShexRename;

implementation

uses Registry, Windows, ShellAPI;

{$R *.dfm}

{ TfrmShexRename }

procedure TfrmShexRename.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmShexRename.btnAddFilesClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
   begin
    FFiles.AddStrings(OpenDialog1.Files);
    ListFiles;
    RenderNames;
   end;
end;

procedure TfrmShexRename.btnGoClick(Sender: TObject);
var
  rm,s1,s2,fn:string;
  so:TSHFILEOPSTRUCT;
  i,j,l:integer;
begin
  if MessageBox(Handle,'Are you sure to rename these files?','shexRename',MB_OKCANCEL or MB_ICONQUESTION)=idOk then
   begin
    rm:=cbRenameMask.Text;
    if cbRenameMask.Items.IndexOf(rm)=-1 then cbRenameMask.Items.Insert(0,rm);

    s1:='';
    s2:='';
    for i:=0 to FFiles.Count-1 do
     begin
      fn:=FFiles[i];
      s1:=s1+fn+#0;
      if cbFolders.Checked then
        s2:=s2+txtNewFileNames.Lines[i]+#0
      else
       begin
        l:=Length(fn);
        j:=l;
        while (j<>0) and (fn[j]<>'\') do dec(j);
        s2:=s2+Copy(fn,1,j)+txtNewFileNames.Lines[i]+#0;
       end;
     end;
    s1:=s1+#0;
    s2:=s2+#0;

    so.wnd:=Handle;
    so.wFunc:=FO_MOVE;
    so.pFrom:=PChar(s1);
    so.pTo:=PChar(s2);
    so.fFlags:=FOF_MULTIDESTFILES or FOF_ALLOWUNDO;
    so.fAnyOperationsAborted:=false;
    so.hNameMappings:=nil;
    so.lpszProgressTitle:=nil;

    if SHFileOperation(so)<>0 then RaiseLastOSError else Close;

   end;
end;

procedure TfrmShexRename.btnResetClick(Sender: TObject);
begin
  RenderNames;
end;

procedure TfrmShexRename.cbFoldersChange(Sender: TObject);
begin
  ListFiles;
  RenderNames;
end;

procedure TfrmShexRename.cbRenameMaskChange(Sender: TObject);
begin
  if FFiles.Count<200 then RenderNames;
end;

procedure TfrmShexRename.DoCreate;
var
  r:TRegistry;
  i,l:integer;
begin
  inherited DoCreate;
  r:=TRegistry.Create;
  try
    r.RootKey:=HKEY_CURRENT_USER;
    if r.OpenKeyReadOnly('SOFTWARE\Double Sigma Programming\AllSorts\RenameMasks') then
     begin
      try
        l:=r.ReadInteger('Count');
        for i:=0 to l-1 do
          cbRenameMask.Items.Add(r.ReadString(IntToStr(i)));
        cbRenameMask.ItemIndex:=r.ReadInteger('Index');
        cbFolders.Checked:=r.ReadBool('ShowFullPath');
      except
        //silent
      end;
     end;
  finally
    r.Free;
  end;

  FFiles:=TStringList.Create;
  //FFiles.Sorted:=true;?
  if Paramcount=0 then
   begin
    btnAddFiles.Visible:=true;
    if OpenDialog1.Execute then FFiles.AddStrings(OpenDialog1.Files);
   end
  else
    FFiles.LoadFromFile(ParamStr(1));

  ListFiles;
  RenderNames;
end;

procedure TfrmShexRename.DoClose(var CloseAction: TCloseAction);
var
  r:TRegistry;
  i,l:integer;
begin
  inherited DoClose(CloseAction);
  FFiles.Free;
  r:=TRegistry.Create;
  try
    r.RootKey:=HKEY_CURRENT_USER;
    if r.OpenKey('SOFTWARE\Double Sigma Programming\AllSorts\RenameMasks',true) then
     begin
      l:=cbRenameMask.Items.Count;
      r.WriteInteger('Count',l);
      r.WriteInteger('Index',cbRenameMask.ItemIndex);
      for i:=0 to l-1 do
        r.WriteString(IntToStr(i),cbRenameMask.Items[i]);
      r.WriteBool('ShowFullPath',cbFolders.Checked);
     end;
  finally
    r.Free;
  end;
end;

procedure TfrmShexRename.ListFiles;
var
  i:integer;
begin
  txtOriginalFileNames.Lines.BeginUpdate;
  try
    txtOriginalFileNames.Lines.Clear;
    if cbFolders.Checked then
      txtOriginalFileNames.Lines.AddStrings(FFiles)
    else
      for i:=0 to FFiles.Count-1 do
        txtOriginalFileNames.Lines.Add(ExtractFileName(FFiles[i]));
  finally
    txtOriginalFileNames.Lines.EndUpdate;
  end;
end;

procedure TfrmShexRename.RenderNames;
var
  rm,fn,s,t:string;
  i,j,k,l,m,lr,lf,e0,e1:integer;
  fd:TWIN32FINDDATA;
  fh:THANDLE;
  d:TDateTime;
  st:TSYSTEMTIME;
begin
  rm:=cbRenameMask.Text;
  lr:=Length(rm);

  txtNewFileNames.Lines.BeginUpdate;
  try
    txtNewFileNames.Lines.Clear;
    for i:=0 to FFiles.Count-1 do
     begin
      fh:=FindFirstFile(PChar(FFiles[i]),fd);
      if fh=INVALID_HANDLE_VALUE then ZeroMemory(@fd,SizeOf(TWIN32FINDDATA));
      FindClose(fh);

      //TODO: if cbFolders.Checked
      //fn:=ExtractFileName(FFiles[i]);
      fn:=txtOriginalFileNames.Lines[i];
      lf:=Length(fn);
      e0:=lf;
      while (e0<>0) and (fn[e0]<>'\') do dec(e0);
      e1:=lf;
      while (e1<>e0) and (fn[e1]<>'.') do dec(e1);
      if e1=e0 then e1:=lf+1;

      //default last write
      if FileTimeToSystemTime(fd.ftLastWriteTime,st) then
        d:=SystemTimeToDateTime(st)
      else
        d:=0.0;//?

      s:='';
      j:=1;
      while (j<=lr) do
       begin
        case rm[j] of
          '$':
            if j<>lr then
             begin
              inc(j);
              case rm[j] of
                '$':s:=s+'$';
                'f':s:=s+fn;
                'F':s:=s+UpperCase(fn);
                'e':s:=s+Copy(fn,e1+1,lf-e1);
                'E':s:=s+UpperCase(Copy(fn,e1+1,lf-e1));
                'n':s:=s+Copy(fn,e0+1,e1-e0-1);
                'N':s:=s+UpperCase(Copy(fn,e0+1,e1-e0-1));
                'd'://date
                  if j<>lr then
                   begin
                    inc(j);
                    case rm[j] of
                      'c'://created
                        if FileTimeToSystemTime(fd.ftCreationTime,st) then
                          d:=SystemTimeToDateTime(st)
                        else
                          d:=0.0;//?
                      'm'://last modified
                        if FileTimeToSystemTime(fd.ftLastWriteTime,st) then
                          d:=SystemTimeToDateTime(st)
                        else
                          d:=0.0;//?
                      'a'://last accessed
                        if FileTimeToSystemTime(fd.ftLastAccessTime,st) then
                          d:=SystemTimeToDateTime(st)
                        else
                          d:=0.0;//?
                      'n':d:=Now;
                      else s:=s+'???';//raise?
                    end;
                   end;
                'p'://path
                  if j<>lr then
                   begin
                    inc(j);
                    case rm[j] of
                      'd':s:=s+Copy(fn,1,1);
                      'D':s:=s+UpperCase(Copy(fn,1,1));
                      'f':s:=s+Copy(fn,1,e0);
                      'F':s:=s+UpperCase(Copy(fn,1,e0));
                      'n':;//TODO
                      '0'..'9':
                       begin
                        k:=(byte(rm[j]) and $F)+1;
                        l:=e0;
                        m:=e0;
                        while k<>0 do
                         begin
                          l:=m-1;
                          while (l<>0) and (fn[l]<>'\') do dec(l);
                          dec(k);
                         end;
                        s:=s+Copy(fn,l+1,m-l-1);
                       end
                      else s:=s+'???';//raise?
                    end;
                   end;
                's':s:=s+IntToStr(fd.nFileSizeLow);//assert fd.nFileSizeHigh=0
                //'c'://hashes
                //TODO: 'c' CRC32
                //TODO: 'm' MD5
                //TODO: 'e' RIP-EMD160
                //TODO: 's' SHA1
                //TODO: '2' SHA256
                //'x'://xml XPath Query //TODO
                else s:=s+'$'+rm[j];
              end;
             end;
          '"':
            if j<>lr then
             begin
              inc(j);
              k:=j;
              while (k<=lr) and (rm[k]<>'"') do
               begin
                while (k<=lr) and (rm[k]<>'"') do inc(k);
                s:=s+Copy(rm,j,k-j);
                if (k+1<=lr) and (rm[k+1]='"') then
                 begin
                  s:=s+'"';
                  inc(k,2);
                  j:=k;
                 end;
               end;
             end;
          ' ','c','d','e','g','m','h','y','n','s','z','t','a','p','/':
           begin
            k:=j;
            while (k<=lr) and (AnsiChar(rm[k]) in [
              ' ','c','d','e','g','m','h','y','n','s','z','t','a','p','/'
            ]) do inc(k);
            t:=FormatDateTime(Copy(rm,j,k-j),d);
            j:=k-1;
            for k:=1 to Length(t) do
              if AnsiChar(t[k]) in ['\','/',':','*','?','<','>','|'] then t[k]:='_';
            s:=s+t;
           end;
          //'\','/':s:=s+PathDelim;
          ':','*','?','<','>','|':s:=s+'_';//not allowed in file names
          else s:=s+rm[j];
        end;
        inc(j);
       end;
      txtNewFileNames.Lines.Add(s);
     end;
  finally
    txtNewFileNames.Lines.EndUpdate;
  end;
end;

end.

