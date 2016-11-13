unit ddHandle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus;

type
  TfrmDiffHandle = class(TForm)
    Image1: TImage;
    Image2: TImage;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    N1: TMenuItem;
    Addfile1: TMenuItem;
    Addfolder1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AllMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AllMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AllMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AllDblClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Addfile1Click(Sender: TObject);
    procedure Addfolder1Click(Sender: TObject);
  private
    IsDragging:boolean;
    StartM,StartP:TPoint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormDropFiles(var Msg:TWMDropFiles); message WM_DROPFILES;
  public
    Subject:TForm;
  end;

var
  frmDiffHandle: TfrmDiffHandle;

implementation

uses ShellApi, ddMain;

{$R *.dfm}

{ TForm1 }

procedure TfrmDiffHandle.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=Params.ExStyle or WS_EX_TOOLWINDOW;
end;

procedure TfrmDiffHandle.FormDropFiles(var Msg: TWMDropFiles);
var
  i,FileCount,FileNameSize:integer;
  FileName:string;
begin
  FileCount:=DragQueryFile(Msg.Drop,$FFFFFFFF,nil,0);
  for i:=0 to FileCount-1 do
   begin
    FileNameSize:=DragQueryFile(Msg.Drop,i,nil,0)+1;
    SetLength(FileName,FileNameSize);
    DragQueryFile(Msg.Drop,i,@FileName[1],FileNameSize);
    //skip closing #0 char
    SetLength(FileName,FileNameSize-1);
    (Subject as TfrmDirDiffMain).AddSource(FileName);
   end;
  DragFinish(Msg.Drop);
end;

procedure TfrmDiffHandle.FormShow(Sender: TObject);
begin
  DragAcceptFiles(Handle,true);
end;

procedure TfrmDiffHandle.FormCreate(Sender: TObject);
begin
  BoundsRect:=Rect(
    Mouse.CursorPos.X-16,
    Mouse.CursorPos.Y-16,
    Mouse.CursorPos.X+32,
    Mouse.CursorPos.Y+32);
  IsDragging:=false;
end;

procedure TfrmDiffHandle.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfrmDiffHandle.AllMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsDragging:=true;
  StartM:=Mouse.CursorPos;
  StartP:=BoundsRect.TopLeft;
end;

procedure TfrmDiffHandle.AllMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsDragging:=false;
end;

procedure TfrmDiffHandle.AllMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if IsDragging then
    BoundsRect:=Rect(
      StartP.X+Mouse.CursorPos.X-StartM.X,
      StartP.Y+Mouse.CursorPos.Y-StartM.Y,
      StartP.X+Mouse.CursorPos.X-StartM.X+48,
      StartP.Y+Mouse.CursorPos.Y-StartM.Y+48);
end;

procedure TfrmDiffHandle.AllDblClick(Sender: TObject);
begin
  //Application.Restore;
  ShowWindow(Application.Handle,SW_SHOWNORMAL);
end;

procedure TfrmDiffHandle.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDiffHandle.Addfile1Click(Sender: TObject);
begin
  (Subject as TfrmDirDiffMain).miAddFile.Click;
end;

procedure TfrmDiffHandle.Addfolder1Click(Sender: TObject);
begin
  (Subject as TfrmDirDiffMain).miAddFolder.Click;
end;

end.
