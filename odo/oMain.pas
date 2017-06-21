unit oMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets, AppEvnts, Menus, SQLiteData;

const
  WM_ODOHIT = WM_USER + 3;
  MinutesADay=1440;//24*60
  pidGrowSize=32;

type
  TCArr=array[0..0] of cardinal;
  PCARR=^TCARR;

  TCountData=record
    KeyCount,SwitchCount,AppCount,ClickCount,MouseXCount,MouseYCount:integer;
  end;

  TwinMain = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    Settings1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Stayontop1: TMenuItem;
    tiIdle: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Stayontop1Click(Sender: TObject);
    procedure tiIdleTimer(Sender: TObject);
  protected
    procedure FormQueryEndSession(var Msg : TWMQueryEndSession);
      message WM_QUERYENDSESSION;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMOdoHit(var Msg: TMessage); message WM_ODOHIT;
  private
    hookinfo:record
      wnd,hook1,hook2:cardinal;
    end;

    CurrentData:TCountData;
    LastWND,LastMinute:cardinal;
    LastMouse:TPoint;
    CountCtrls,CountArrows:boolean;
    CountDeletes:integer;
    pidl:integer;
    pids:array of integer;

    Data:array of TCountData;
    DataBitmap:TBitmap;
    LastOffMap:TDateTime;
    DoInsert,FirstShow:boolean;

    DataLink: TSQLiteConnection;

    {DataLink settings}
    dlTable,dlDBPath:string;
    dlUser,dlComp,dlDomain,dlGetDBData:boolean;
    dlExtraVals:TStringList;
    dtNiceDateFormat:string;

    IsDragMove,IsDragSize,IsHolding:boolean;
    DragMX,DragMY,DragSX,DragSY:integer;

    procedure DrawDisplay(const DC:HDC);
    procedure NextMinute;
    function WasActive(const Index:integer):boolean;
    function NiceDateTime(d:TDateTime):string;
    procedure CheckMinute;
  public
    function OpenDataLink:boolean;
    procedure CloseDataLink;
  end;

var
  winMain: TwinMain;

implementation

uses oHint, Math, oSets, IniFiles, Registry, DateUtils;

{$R *.dfm}
{$R odoCursor.res}

procedure TwinMain.FormCreate(Sender: TObject);
var
  b:TRect;
  s:string;
  ini:TIniFile;
  h:THandle;
  r:TRegistry;
  st:TSystemTime;
  p:TProcedure;
begin
  s:=NiceDateTime(Now);
  //Application.Title:=s;
  Caption:=s;
  FirstShow:=true;
  DoInsert:=false;
  DataLink:=nil;
  dlExtraVals:=TStringList.Create;

  DataBitmap:=TBitmap.Create;
  DataBitmap.PixelFormat:=pf32bit;
  DataBitmap.Width:=ClientWidth;
  DataBitmap.Height:=ClientHeight;

  IsDragMove:=false;
  IsDragSize:=false;

  SetLength(Data,0);
  {
  SetLength(Data,ClientWidth);
  //for i:=0 to ClientWidth-1 do
  for i:=0 to Length(Data)-1 do
  begin
   Data[i].KeyCount:=0;
   Data[i].SwitchCount:=0;
   Data[i].AppCount:=0;
   Data[i].ClickCount:=0;
   Data[i].MouseXCount:=0;
   Data[i].MouseYCount:=0;
  end;
  }
  LastOffMap:=0;

  ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    dlTable:=ini.ReadString('DB','Table','');
    dlDBPath:=ini.ReadString('DB','Path','');

    dlUser:=ini.ReadBool('Data','UserName',false);
    dlComp:=ini.ReadBool('Data','ComputerName',false);
    dlDomain:=ini.ReadBool('Data','DomainName',false);
    dlExtraVals.Text:=StringReplace(ini.ReadString('Data','Extra',''),'\\\\',#13#10,[rfReplaceAll]);

    dlGetDBData:=ini.ReadBool('DB','GetData',true);

    dtNiceDateFormat:=ini.ReadString('Display','DateTimeFormat','ddd '+ShortDateFormat+' hh:nn');
    CountCtrls:=ini.ReadBool('Count','Ctrls',true);
    CountArrows:=ini.ReadBool('Count','Arrows',true);
    CountDeletes:=ini.ReadInteger('Count','Deletes',2);

    b.Left:=ini.ReadInteger('Position','Left',Left);
    b.Top:=ini.ReadInteger('Position','Top',Top);
    b.Right:=ini.ReadInteger('Position','Width',Width)+b.Left;
    b.Bottom:=ini.ReadInteger('Position','Height',Height)+b.Top;
    BoundsRect:=b;
    //calls the resize event!! (event should be called)

    if ini.ReadBool('Position','TopMost',false) then FormStyle:=fsStayOnTop;
    Stayontop1.Checked:=FormStyle=fsStayOnTop;

    //if the default settings were used, the resize event isn't called, so call it ourselves
    if Length(Data)=0 then FormResize(Self);
  finally
    ini.Free;
  end;

  //start data
  CurrentData.KeyCount:=0;
  CurrentData.SwitchCount:=0;
  CurrentData.AppCount:=0;
  CurrentData.ClickCount:=0;
  CurrentData.MouseXCount:=0;
  CurrentData.MouseYCount:=0;
  GetCursorPos(LastMouse);
  LastWND:=GetForegroundWindow;
  GetLocalTime(st);
  LastMinute:=st.wMinute;
  pidl:=pidGrowSize;
  SetLength(pids,pidl);

  //create hooks
  p:=nil;//counter warning
  r:=TRegistry.Create;
  try
    r.OpenKey('\Software\Double Sigma Programming\odo',true);
    hookinfo.wnd:=0;
    hookinfo.hook1:=0;
    hookinfo.hook2:=0;
    r.WriteBinaryData('HookInfo',hookinfo,4*3);

    h:=LoadLibrary(PChar(ExtractFilePath(Application.ExeName)+'odoH.dll'));
    if h=0 then
     begin
      MessageBox(GetDesktopWindow,'Failed to load odoH.dll','odo',MB_OK or MB_ICONERROR);
      PostQuitMessage(1);
      raise Exception.Create('Failed to load odoH.dll');
     end
    else
     begin
      @p:=GetProcAddress(h,'odoLoadSettings');
      hookinfo.wnd:=Handle;
      hookinfo.hook1:=SetWindowsHookEx(WH_KEYBOARD,GetProcAddress(h,'odoKeybCallback'),h,0);
      hookinfo.hook2:=SetWindowsHookEx(WH_MOUSE,GetProcAddress(h,'odoMouseCallback'),h,0);

      r.WriteBinaryData('HookInfo',hookinfo,4*3);
     end;
  finally
    r.Free;
  end;

  p;
end;

procedure TwinMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  b:TRect;
  ini:TIniFile;
begin
  UnhookWindowsHookEx(hookinfo.hook1);
  UnhookWindowsHookEx(hookinfo.hook2);

  ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    b:=BoundsRect;
    ini.WriteInteger('Position','Left',b.Left);
    ini.WriteInteger('Position','Top',b.Top);
    ini.WriteInteger('Position','Width',b.Right-b.Left);
    ini.WriteInteger('Position','Height',b.Bottom-b.Top);
    ini.WriteBool('Position','TopMost',FormStyle=fsStayOnTop);
  finally
    ini.Free;
  end;

  CloseDataLink;
  dlExtraVals.Free;

  SetLength(Data,0);
  DataBitmap.Free;
end;

procedure TwinMain.FormResize(Sender: TObject);
var
  i:integer;
  qr:TSQLiteStatement;
  ts:Double;
begin
  i:=Length(Data);
  SetLength(Data,ClientWidth);
  // try to connect
  if dlGetDBData and OpenDataLink and (i<Length(Data)) then
   begin
    //read data from DB
    try
      qr:=TSQLiteStatement.Create(DataLink,
        'SELECT * FROM ['+dlTable+'] ORDER BY [TimeStamp] DESC');
        //where?
      try
        LastOffMap:=0.0;
        qr.Read;
        while (i<Length(Data)) do
         begin
          Data[i].KeyCount:=0;
          Data[i].SwitchCount:=0;
          Data[i].AppCount:=0;
          Data[i].ClickCount:=0;
          Data[i].MouseXCount:=0;
          Data[i].MouseYCount:=0;
          if not qr.EOF then
           begin
            ts:=(DateTimeToUnix(Now) div 60)-i;
            while not(qr.EOF) and ((qr.GetInt64('TimeStamp') div 60)>ts) do
              qr.Read;
            if not(qr.EOF) and ((qr.GetInt64('TimeStamp') div 60)=ts) then
             begin
              Data[i].MouseXCount:=qr.GetInt('MouseX');
              Data[i].MouseYCount:=qr.GetInt('MouseY');
              Data[i].ClickCount:=qr.GetInt('Clicks');
              Data[i].SwitchCount:=qr.GetInt('Switches');
              Data[i].AppCount:=qr.GetInt('Apps');
              Data[i].KeyCount:=qr.GetInt('Keystrokes');
              qr.Read;
             end;
           end;
          inc(i);
         end;
        if not(qr.EOF) then
          LastOffMap:=UnixToDateTime(qr.GetInt64('TimeStamp'));
      finally
        qr.Free;
      end;
    except
      //...
    end;
   end
  else
   begin
    while i<ClientWidth do
     begin
      Data[i].KeyCount:=0;
      Data[i].SwitchCount:=0;
      Data[i].AppCount:=0;
      Data[i].ClickCount:=0;
      Data[i].MouseXCount:=0;
      Data[i].MouseYCount:=0;
      inc(i);
     end;
   end;
  DataBitmap.Width:=ClientWidth;
  DataBitmap.Height:=ClientHeight;
  DrawDisplay(Canvas.Handle);
end;

procedure SetMax(const v:integer;var m:integer);
begin
  if v>m then m:=v;
end;

procedure TwinMain.DrawDisplay(const DC:HDC);
type
  TCArr=array[0..0] of integer;
  PCarr=^TCarr;
const
  BackGround=        $000000;
  BackGroundHour=    $808080;
  BackGroundQuarter= $404040;
  BackGroundSplit=   $606060;
var
  x,y,y1,y2,xm,ym,i,bc,c:integer;
  Max,Current:TCountData;
  bdata:PCarr;
begin
  Max.KeyCount:=1;
  Max.SwitchCount:=1;
  Max.AppCount:=1;
  Max.ClickCount:=1;
  Max.MouseXCount:=1;
  Max.MouseYCount:=1;

  xm:=ClientWidth;
  ym:=ClientHeight;
  y1:=(ym div 3);
  y2:=ym-y1-1;

  //assert Length(Data)=ClientWidth
  //assert DataBitmap.Width=ClientWidth
  //assert DataBitmap.Height=ClientHeight

  //bitmap data begint onderaan
  bdata:=DataBitmap.ScanLine[ClientHeight-1];

  //maximums ophalen
  for i:=0 to ClientWidth-1 do
   begin
    SetMax(Data[i].KeyCount,Max.KeyCount);
    SetMax(Data[i].SwitchCount,Max.SwitchCount);
    SetMax(Data[i].AppCount,Max.AppCount);
    SetMax(Data[i].ClickCount,Max.ClickCount);
    SetMax(Data[i].MouseXCount,Max.MouseXCount);
    SetMax(Data[i].MouseYCount,Max.MouseYCount);
   end;

  //MouseX/MouseY maar 1 gebruiken!
  SetMax(Max.MouseXCount,Max.MouseYCount);

  for x:=0 to xm-1 do
   begin
    i:=ClientWidth-1-x-integer(LastMinute);
    if (i mod 60)=0 then bc:=BackGroundHour else
      if (i mod 15)=0 then bc:=BackGroundQuarter else bc:=BackGround;

    i:=ClientWidth-1-x;

    Current.KeyCount:=Data[i].KeyCount*y1 div Max.KeyCount;
    Current.ClickCount:=Data[i].ClickCount*y1 div Max.ClickCount;
    Current.SwitchCount:=Data[i].SwitchCount*y1 div Max.SwitchCount;
    //Current.AppCount:=Data[i].AppCount*y1 div Max.AppCount;

    //MouseX/MouseY maar 1 gebruiken! MouseX
    Current.MouseXCount:=Data[i].MouseXCount*y2 div Max.MouseXCount;
    Current.MouseYCount:=Data[i].MouseYCount*y2 div Max.MouseXCount;

    //bdata[x+(ym-1)*xm]:=BackGroundSplit;
    //bdata[x+(y1+1)*xm]:=BackGroundSplit;
    //bdata[x]:=BackGroundSplit;
    //bovenste
    for y:=1 to y2 do
     begin
      if y=y2 then c:=BackGroundSplit else c:=bc;
      if (y<=Current.MouseXCount) then c:=c or ((((y*$7F) div Current.MouseXCount) or $80) shl 16);
      if (y<=Current.MouseYCount) then c:=c or ((((y*$7F) div Current.MouseYCount) or $80) shl 8);
      bdata[x+((y1+y)*xm)]:=c;
     end;
    //middellijn
    bdata[x+y1*xm]:=BackGroundHour;
    //onderste
    for y:=1 to y1 do
     begin
      if y=y1 then c:=BackGroundSplit else c:=bc;
      if (y<=Current.KeyCount) then c:=c or ((((y*$7F) div Current.KeyCount) or $80) shl 8);
      if (y<=Current.ClickCount) then c:=c or ((((y*$7F) div Current.ClickCount) or $80) shl 16);
      if (y<=Current.SwitchCount) then c:=c or ((((y*$7F) div Current.SwitchCount) or $80));//shl 0);
      //if (y<=Current.AppCount) then c:=c or ?
      bdata[x+((y1-y)*xm)]:=c;
     end;
   end;

  BitBlt(DC,0,0,xm,ym,DataBitmap.Canvas.Handle,0,0,SRCCOPY);
  //GdiFlush;
end;

const
  ResizeDragCornerX=40;
  ResizeDragCornerY=40;

procedure TwinMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DragMX:=Mouse.CursorPos.X;
  DragMY:=Mouse.CursorPos.Y;
  IsHolding:=true;
  winHint.Hide;
  if (X>Width-ResizeDragCornerX) and (Y>Height-ResizeDragCornerY) then
   begin
    IsDragSize:=true;
    DragSX:=Width;
    DragSY:=Height;
   end
  else
   begin
    IsDragMove:=true;
    DragSX:=Left;
    DragSY:=Top;
   end;
end;

procedure TwinMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsDragSize:=false;
  IsDragMove:=false;
end;

procedure TwinMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
const
  DragTreshold=16;
var
  sx,sy,i,j:integer;
  s:string;
  d1,d2:TDateTime;
  d:double;
begin
  if (X>Width-ResizeDragCornerX) and (Y>Height-ResizeDragCornerY) then
    Cursor:=crSizeNWSE
  else
    Cursor:=5;//crDefault;

  if IsHolding then
   begin
    //GetSystemMetrics();
    sx:=DragMX-Mouse.CursorPos.X;
    sy:=DragMY-Mouse.CursorPos.Y;
    if (sx<-DragTreshold) or (sx>DragTreshold) or
       (sy<-DragTreshold) or (sy>DragTreshold) then
     IsHolding:=false;
   end;

  if not(IsHolding) then
   begin
    if IsDragMove then
     begin
      sx:=DragSX-DragMX+Mouse.CursorPos.X;
      sy:=DragSY-DragMY+Mouse.CursorPos.Y;
      BoundsRect:=Rect(sx,sy,sx+Width,sy+Height);
     end
    else
    if IsDragSize then
     begin
      sx:=DragSX-DragMX+Mouse.CursorPos.X;
      sy:=DragSY-DragMY+Mouse.CursorPos.Y;
      if sx<60 then sx:=60;
      if sy<20 then sy:=20;
      BoundsRect:=Rect(Left,Top,Left+sx,Top+sy);
     end;
   end;

  if not(IsDragMove) and not(IsDragSize) then
   begin
    if Application.Active then
     begin
      i:=ClientWidth-1-x;
      if WasActive(i) then
       begin
        winHint.SetHint(
         NiceDateTime(Now-i/MinutesADay)+
         #13#10'Mouse ('+IntToStr(Data[i].MouseXCount)+','+IntToStr(Data[i].MouseYCount)+
         ')'#13#10'Clicks: '+IntToStr(Data[i].ClickCount)+
         ', Keys: '+IntToStr(Data[i].KeyCount)+
         #13#10'Switches: '+IntToStr(Data[i].SwitchCount)+
         ' ('+IntToStr(Data[i].AppCount)+' apps)');
       end
      else
       begin
        j:=i;
        while (j<length(Data)) and not(WasActive(j)) do inc(j);
        if j=length(Data) then
          if LastOffMap=0.0 then d1:=0.0 else d1:=LastOffMap
        else
          d1:=Now-j/MinutesADay;
        if d1=0.0 then s:='<< ???'#13#10 else s:='<< '+NiceDateTime(d1)+#13#10;
        j:=i;
        while (j>-1) and not(WasActive(j)) do dec(j);
        if j=-1 then d2:={0.0}Now else d2:=Now-j/MinutesADay;
        if d2=0.0 then s:=s+'??? >>' else s:=s+NiceDateTime(d2)+' >>';
        if (d1<>0.0) and (d2<>0.0) then
         begin
          s:=s+#13#10;
          d:=d2-d1;
          j:=Trunc(d);
          if j<>0 then s:=s+IntToStr(j)+'d ';
          d:=Frac(d)*24;
          j:=Trunc(d);
          if j<>0 then s:=s+IntToStr(j)+'h ';
          d:=Frac(d)*60;
          j:=Trunc(d);
          s:=s+IntToStr(j)+'''';
         end;
        winHint.SetHint(s);
       end;
     end;
   end;
end;

procedure TwinMain.NextMinute;
var
  i:integer;
  s:string;
begin
  s:=NiceDateTime(Now);
  //Application.Title:=s;
  Caption:=s;
  if WasActive(Length(Data)-1) then LastOffMap:=Now-((Length(Data)-1)/MinutesADay);
  for i:=Length(Data)-1 downto 1 do Data[i]:=Data[i-1];
  Data[0]:=CurrentData;
  DrawDisplay(Canvas.Handle);
  //insert later want syncd hier
  DoInsert:=true;
end;

procedure TwinMain.ApplicationEvents1Deactivate(Sender: TObject);
begin
  winHint.Hide;
  ShowWindow(Application.Handle,SW_HIDE);
end;

procedure TwinMain.FormQueryEndSession(var Msg: TWMQueryEndSession);
begin
  Msg.Result:=1;
  //PostMessage(Application.Handle,WM_CLOSE,0,0);
  PostQuitMessage(0);
end;

procedure TwinMain.WMPaint(var Message: TWMPaint);
var
  dc:HDC;
  ps:TPaintStruct;
begin
  dc:=BeginPaint(Handle,ps);
  DrawDisplay(dc);
  EndPaint(Handle,ps);
end;


procedure TwinMain.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  //naah, skip this
  Message.Result:=1;
end;

procedure TwinMain.Close1Click(Sender: TObject);
begin
  Close;
end;

function TwinMain.WasActive(const Index: integer): boolean;
begin
  Result:=
      Data[Index].MouseXCount+
      Data[Index].MouseYCount+
      Data[Index].ClickCount*50+
      Data[Index].KeyCount*10
      //+Data[Index].SwitchCount*20
      //+Data[Index].AppCount*?
  >500;
end;

procedure TwinMain.CloseDataLink;
begin
  try
    FreeAndNil(DataLink);
  except
  end;
end;

function TwinMain.OpenDataLink: boolean;
var
  s,t:string;
  f:TFileStream;
begin
  s:=Application.ExeName;
  s:=copy(s,1,length(s)-4);
  try
    Result:=true;//default
    if DataLink=nil then
     begin
      if FileExists(s+'.db') then
        DataLink:=TSQLiteConnection.Create(s+'.db')
      else if dlDBPath<>'' then
        DataLink:=TSQLiteConnection.Create(dlDBPath)
      else
        //raise Exception.Create('No DataLink specifications found.');
        Result:=false;
     end;
  except
    on e:Exception do
     begin
      //write error to log
      try
        f:=TFileStream.Create(s+'.log',fmCreate);
        try
          t:=DateTimeToStr(Now)+' '+e.Message+#13#10;
          f.Write(t[1],length(t));
        finally
          f.Free;
        end;
      except
        //silent
      end;
      Result:=false;
     end;
  end;
end;

procedure TwinMain.Settings1Click(Sender: TObject);
var
  ini:TIniFile;
  b:TRect;
begin
  winSettings:=TwinSettings.Create(Application);
  try
    winSettings.txtTable.Text:=dlTable;
    winSettings.cbUser.Checked:=dlUser;
    winSettings.cbComp.Checked:=dlComp;
    winSettings.cbDomain.Checked:=dlDomain;
    winSettings.ValueListEditor1.Strings.Text:=dlExtraVals.Text;
    winSettings.txtNiceDateTime.Text:=dtNiceDateFormat;
    winSettings.cbCountControl.Checked:=CountCtrls;
    winSettings.cbCountArrows.Checked:=CountArrows;
    WinSettings.cbCountDeletes.ItemIndex:=CountDeletes;
    if winSettings.ShowModal=mrOk then
     begin
      dlTable:=winSettings.txtTable.Text;
      dlUser:=winSettings.cbUser.Checked;
      dlComp:=winSettings.cbComp.Checked;
      dlDomain:=winSettings.cbDomain.Checked;
      dlExtraVals.Text:=winSettings.ValueListEditor1.Strings.Text;
      dtNiceDateFormat:=winSettings.txtNiceDateTime.Text;
      CountCtrls:=winSettings.cbCountControl.Checked;
      CountArrows:=winSettings.cbCountArrows.Checked;
      CountDeletes:=WinSettings.cbCountDeletes.ItemIndex;

      ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
      try
        ini.WriteString('DB','Table',dlTable);
        //ini.WriteString('DB','Path',dlDBPath);

        ini.WriteBool('Data','UserName',dlUser);
        ini.WriteBool('Data','ComputerName',dlComp);
        ini.WriteBool('Data','DomainName',dlDomain);

        ini.WriteString('Data','Extra',StringReplace(dlExtraVals.Text,#13#10,'\\\\',[rfReplaceAll]));
        ini.WriteString('Display','DateTimeFormat',dtNiceDateFormat);
        ini.WriteBool('Count','Ctrls',CountCtrls);
        ini.WriteBool('Count','Arrows',CountArrows);
        ini.WriteInteger('Count','Deletes',CountDeletes);

        //deze hier ook?
        b:=BoundsRect;
        ini.WriteInteger('Position','Left',b.Left);
        ini.WriteInteger('Position','Top',b.Top);
        ini.WriteInteger('Position','Width',b.Right-b.Left);
        ini.WriteInteger('Position','Height',b.Bottom-b.Top);
        ini.WriteBool('Position','TopMost',FormStyle=fsStayOnTop);
      finally
        ini.Free;
      end;
     end;
  finally
    winSettings.Free;
  end;
end;

procedure TwinMain.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var
  s1,s2:string;
  x:array of OleVariant;
  i:integer;
  procedure AddField(const xx:string;const yy:OleVariant);
  begin
    if i<$40 then
     begin
      s1:=s1+'['+xx+'],';
      s2:=s2+'?,';
      x[i]:=yy;
      inc(i);
     end;
  end;
begin
  if DoInsert then
   begin
    DoInsert:=false;
    if OpenDataLink then
     begin
      try
        SetLength(x,$40);
        i:=0;
        s1:='INSERT INTO ['+dlTable+'] (';
        s2:=' VALUES (';
        AddField('TimeStamp',DateTimeToUnix(Now));
        AddField('MouseX',Data[0].MouseXCount);
        AddField('MouseY',Data[0].MouseYCount);
        AddField('Clicks',Data[0].ClickCount);
        AddField('Switches',Data[0].SwitchCount);
        AddField('Apps',Data[0].AppCount);
        AddField('Keystrokes',Data[0].KeyCount);
        if dlUser then AddField('UserName',GetEnvironmentVariable('USERNAME'));
        if dlComp then AddField('ComputerName',GetEnvironmentVariable('COMPUTERNAME'));
        if dlDomain then AddField('DomainName',GetEnvironmentVariable('USERDOMAIN'));
        for i:=0 to dlExtraVals.Count-1 do
          if dlExtraVals.Names[i]<>'' then AddField(dlExtraVals.Names[i],
            dlExtraVals.Values[dlExtraVals.Names[i]]);

        s1[Length(s1)]:=')';
        s2[Length(s2)]:=')';
        SetLength(x,i);
        DataLink.Execute(s1+s2,x);
      except
        //on e:Exception do //log?
      end;
     end;
   end;
end;

procedure TwinMain.FormShow(Sender: TObject);
begin
  if FirstShow then
   begin
    FirstShow:=false;
    Screen.Cursors[5]:=LoadCursor(HInstance,'1');
    Cursor:=5;
    winHint.Cursor:=5;
   end;
end;

procedure TwinMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=(Params.ExStyle or WS_EX_TOOLWINDOW) and not(WS_EX_APPWINDOW);
end;

procedure TwinMain.Stayontop1Click(Sender: TObject);
begin
  if FormStyle=fsStayOnTop then FormStyle:=fsNormal else FormStyle:=fsStayOnTop;
  Stayontop1.Checked:=FormStyle=fsStayOnTop;
end;

function TwinMain.NiceDateTime(d: TDateTime): string;
begin
  Result:=FormatDateTime(dtNiceDateFormat,d);
end;

procedure TwinMain.WMOdoHit(var Msg: TMessage);
var
  i:integer;
  h:THandle;
  pid:cardinal;
begin
  case Msg.WParam of
    1://keypress
      case Msg.LParam of
        VK_LSHIFT,VK_RSHIFT,VK_LCONTROL,VK_RCONTROL:
          if CountCtrls then inc(CurrentData.KeyCount);
        VK_BACK,VK_CLEAR:
          case CountDeletes of
            1:inc(CurrentData.KeyCount);
            2:if CurrentData.KeyCount>0 then dec(CurrentData.KeyCount);
          end;
        VK_PRIOR..VK_DOWN:
          if CountArrows then inc(CurrentData.KeyCount);
        VK_TAB,VK_RETURN,VK_KANA..VK_SPACE,VK_SELECT..143:
          inc(CurrentData.KeyCount);
      end;
    2,3://mousemove,mousedown
     begin
      if Msg.WParam=2 then inc(CurrentData.ClickCount);
      i:=Msg.LParamLo-LastMouse.X;
      if i<0 then dec(CurrentData.MouseXCount,i) else inc(CurrentData.MouseXCount,i);
      i:=Msg.LParamHi-LastMouse.Y;
      if i<0 then dec(CurrentData.MouseYCount,i) else inc(CurrentData.MouseYCount,i);
      LastMouse.X:=Msg.LParamLo;
      LastMouse.Y:=Msg.LParamHi;
     end;
  end;

  h:=GetForegroundWindow;
  if h<>LastWND then
   begin
    inc(CurrentData.SwitchCount);
    GetWindowThreadProcessId(h,pid);
    i:=0;
    while (i<CurrentData.AppCount) and (pids[i]<>integer(pid)) do inc(i);
    if i=CurrentData.AppCount then
     begin
      inc(CurrentData.AppCount);
      if CurrentData.AppCount=pidl then
       begin
        inc(pidl,pidGrowSize);
        SetLength(pids,pidl);
       end;
      pids[i]:=pid;
      //Data.AppCount: see DoMinute call
     end;
   end;
  LastWND:=h;

  CheckMinute;
end;

procedure TwinMain.CheckMinute;
var
  st:TSystemTime;
begin
  GetLocalTime(st);
  if LastMinute<>st.wMinute then
   begin
    LastMinute:=st.wMinute;
    NextMinute;
    CurrentData.KeyCount:=0;
    CurrentData.SwitchCount:=0;
    CurrentData.AppCount:=0;
    CurrentData.ClickCount:=0;
    CurrentData.MouseXCount:=0;
    CurrentData.MouseYCount:=0;
    CurrentData.AppCount:=0;
   end;
end;

procedure TwinMain.tiIdleTimer(Sender: TObject);
begin
  //check minute by timer for when no inputs are coming in
  CheckMinute;
end;

end.
