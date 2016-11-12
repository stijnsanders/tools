unit oHint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TwinHint = class(TForm)
    Panel1: TPanel;
    lblHint: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  public
    procedure SetHint(const s:string);
  end;

var
  winHint: TwinHint;

implementation

uses oMain;

{$R *.dfm}

{ TwinHint }

procedure TwinHint.SetHint(const s: string);
var
  x,y:integer;
  r:TRect;
begin
  lblHint.Caption:=s;
  r.Left:=Mouse.CursorPos.X+8;
  r.Top:=Mouse.CursorPos.Y+4;
  x:=lblHint.Width+lblHint.Left*2;
  y:=lblHint.Height+lblHint.Top*2;

  if r.Left+x>Screen.Width then r.Left:=Mouse.CursorPos.X-8-x;
  if r.Top+y>Screen.Height then r.Top:=Mouse.CursorPos.Y-4-y;

  r.Right:=r.Left+x;
  r.Bottom:=r.Top+y;
  BoundsRect:=r;
  Show;
end;

procedure TwinHint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WinMain.Close;
end;

procedure TwinHint.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (x>1) or (y>1) then Hide;
end;

end.
