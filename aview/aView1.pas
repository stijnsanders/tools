unit aView1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrmAView = class(TForm)
    Image1: TImage;
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image1DblClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FList:TStringList;
    FIndex:integer;
    procedure LoadImage;
    procedure LoadClipboard;
  protected
    procedure FormDropFiles(var Msg:TWMDropFiles); message WM_DROPFILES;
    procedure DoShow; override;
    procedure DoDestroy; override;
  end;

  TBitmapForceHalftone=class(TBitmap)
  protected
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
  end;


var
  frmAView: TfrmAView;

implementation

uses ShellApi, JPEG, Clipbrd;

{$R *.dfm}

{ TBitmapForceHalftone }

procedure TBitmapForceHalftone.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  p:TPoint;
  dc:HDC;
begin
  //not calling inherited; here!
  dc:=ACanvas.Handle;
  GetBrushOrgEx(dc,p);
  SetStretchBltMode(dc,HALFTONE);
  SetBrushOrgEx(dc,p.x,p.y,@p);
  StretchBlt(dc,
    Rect.Left,Rect.Top,
    Rect.Right-Rect.Left,Rect.Bottom-Rect.Top,
    Canvas.Handle,0,0,Width,Height,ACanvas.CopyMode);
end;

{ TfrmAView }

procedure TfrmAView.DoShow;
var
  i:integer;
begin
  inherited;
  FList:=TStringList.Create;
  DragAcceptFiles(Handle,true);
  FIndex:=0;
  for i:=1 to ParamCount do FList.Add(ParamStr(i));
  if FList.Count<>0 then
    LoadImage
  else
    LoadClipboard;
end;

procedure TfrmAView.DoDestroy;
begin
  inherited;
  FList.Free;
end;

procedure TfrmAView.FormDropFiles(var Msg: TWMDropFiles);
var
  i,FileCount,FileNameSize:integer;
  FileName:string;
begin
  FileCount:=DragQueryFile(Msg.Drop,$FFFFFFFF,nil,0);
  FList.Clear;
  for i:=0 to FileCount-1 do
   begin
    FileNameSize:=DragQueryFile(Msg.Drop,i,nil,0)+1;
    SetLength(FileName,FileNameSize);
    DragQueryFile(Msg.Drop,i,@FileName[1],FileNameSize);
    //skip closing #0 char
    SetLength(FileName,FileNameSize-1);
    FList.Add(FileName);
   end;
  DragFinish(Msg.Drop);

  FIndex:=0;
  LoadImage;
end;

procedure TfrmAView.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if (WheelDelta<0) then
   begin
    if FIndex<>0 then dec(FIndex);
   end
  else
   begin
    inc(FIndex);
   end;
  LoadImage;
  Handled:=true;
end;

procedure TfrmAView.LoadImage;
var
  b:TBitmapForceHalftone;
  p:TPicture;
begin
  if FList.Count<>0 then
    while FIndex>FList.Count do dec(FIndex,FList.Count);
  if FIndex<FList.Count then
   begin
    b:=TBitmapForceHalftone.Create;
    try
      p:=TPicture.Create;
      try
        p.LoadFromFile(FList[FIndex]);
        b.Width:=p.Width;
        b.Height:=p.Height;
        b.Canvas.Draw(0,0,p.Graphic);
      finally
        p.Free;
      end;
    except
      b.Free;
      raise;
    end;
    Image1.Picture.Bitmap:=b;
    Caption:=FList[FIndex];
    Application.Title:=FList[FIndex];
   end;
end;

procedure TfrmAView.LoadClipboard;
var
  b:TBitmapForceHalftone;
begin
  b:=TBitmapForceHalftone.Create;
  try
    b.Assign(Clipboard);
    Image1.Picture.Bitmap:=b;
    Caption:='aView';
    Application.Title:='aView';
  except
    b.Free;
    //ignore invalid clipboard format
  end;
end;

procedure TfrmAView.Image1DblClick(Sender: TObject);
begin
  LoadClipboard;
end;

procedure TfrmAView.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:inc(FIndex);
    mbRight:if FIndex<>0 then dec(FIndex);
  end;
  LoadImage;
end;

end.
