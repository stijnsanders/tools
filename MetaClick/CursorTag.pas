unit CursorTag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

var
  CursorTagConfig:record
    MSCount,MSTotal:integer;
    Second:boolean;
    ColorFG1,ColorFG2:TColor;
  end;

type
  TfrmCursorTag = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmCursorTag: TfrmCursorTag;

const
  CursorTagPadX_Default=24;
  CursorTagPadY_Default=8;
  CursorTagWidth_Default=14;
  CursorTagHeight_Default=28;
  CursorTagBorderTop=1;
  CursorTagBorderBottom=1;
  CursorTagBorderLeft=2;
  CursorTagBorderRight=2;

implementation

{$R *.dfm}

procedure TfrmCursorTag.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;
end;

procedure TfrmCursorTag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //don't exit other than application terminate
  Action:=caNone;
end;

procedure TfrmCursorTag.FormCreate(Sender: TObject);
begin
  SetBounds(
    Mouse.CursorPos.X+CursorTagPadX_Default,
    Mouse.CursorPos.Y+CursorTagPadY_Default,
    CursorTagWidth_Default,CursorTagHeight_Default);
end;

procedure TfrmCursorTag.FormPaint(Sender: TObject);
var
  i:integer;
  x,y:integer;
begin
  //x:=CursorTagWidth;
  //y:=CursorTagHeight;
  x:=Width;
  y:=Height;
  i:=y-CursorTagBorderTop-CursorTagBorderBottom;
  if CursorTagConfig.MSCount>CursorTagConfig.MSTotal then
   begin
    Canvas.Brush.Color:=CursorTagConfig.ColorFG2;
    i:=CursorTagBorderTop;
   end
  else
   begin
    i:=CursorTagBorderTop+i-(CursorTagConfig.MSCount*i
      div CursorTagConfig.MSTotal);
    if CursorTagConfig.Second then
     begin
      Canvas.Brush.Color:=CursorTagConfig.ColorFG2;
      Canvas.Rectangle(
        CursorTagBorderLeft,
        CursorTagBorderTop,
        x-CursorTagBorderRight+1,
        i-1);
     end;
    Canvas.Brush.Color:=CursorTagConfig.ColorFG1;
   end;
  Canvas.Brush.Style:=bsSolid;
  Canvas.Pen.Style:=psClear;
  Canvas.Rectangle(
    CursorTagBorderLeft,
    i,
    x-CursorTagBorderRight+1,
    y-CursorTagBorderBottom+1);
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

initialization
  //defaults
  CursorTagConfig.ColorFG1:=$000000;//black
  CursorTagConfig.ColorFG2:=$0000CC;//red
end.
