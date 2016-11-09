unit Orbit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mcCommon;

var
  OrbitConfig:record
    Color1,Color2:TColor;
    Orbit,OrbitSize,CrossSize,MarginX,MarginY,OrbitShape:integer;
    Center:TPoint;
    Items:array[TClickMode] of TRect;
  end;

type
  TfrmOrbit = class(TForm)
  private
    MovedOver:TClickMode;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure WMEraseBkgnd(var Msg: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure DoCreate; override;
  public
    procedure ShowOrbit;
    procedure HideOrbit;
    procedure DrawCross;
    function CheckItem(p:TPoint):TClickMode;
    procedure CheckOrbit;
  end;

var
  frmOrbit: TfrmOrbit;

implementation

{$R *.dfm}

{ TfrmOrbit }

procedure TfrmOrbit.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
  Params.ExStyle:=Params.ExStyle or WS_EX_NOACTIVATE;
end;

procedure TfrmOrbit.DrawCross;
begin
  with OrbitConfig do
   begin
    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Color:=Color1;
    Canvas.Pen.Width:=6;
    Canvas.MoveTo(OrbitSize-CrossSize,OrbitSize-CrossSize);
    Canvas.LineTo(OrbitSize+CrossSize,OrbitSize+CrossSize);
    Canvas.MoveTo(OrbitSize-CrossSize,OrbitSize+CrossSize);
    Canvas.LineTo(OrbitSize+CrossSize,OrbitSize-CrossSize);
    Canvas.Pen.Color:=Color2;
    Canvas.Pen.Width:=2;
    Canvas.MoveTo(OrbitSize-CrossSize,OrbitSize-CrossSize);
    Canvas.LineTo(OrbitSize+CrossSize,OrbitSize+CrossSize);
    Canvas.MoveTo(OrbitSize-CrossSize,OrbitSize+CrossSize);
    Canvas.LineTo(OrbitSize+CrossSize,OrbitSize-CrossSize);
   end;
end;

procedure TfrmOrbit.Paint;
var
  i,j,l,p,x,y:integer;
  cm:TClickMode;
  s:TSize;
  t:string;
  a,b,c:Real;
const
  Labels:array[TClickMode] of string=('','L1','L2','Ld','R1','R2','Rd','W');
begin
  inherited;
  with OrbitConfig do
   begin
    if Center.X<Screen.DesktopLeft+OrbitSize then
      if Center.Y<Screen.DesktopTop+OrbitSize then
       begin
        a:=1.0;
        b:=0.5;
       end
      else if Center.Y>Screen.DesktopTop+Screen.DesktopHeight-OrbitSize then
       begin
        a:=0.0;
        b:=0.5;
       end
      else
       begin
        a:=0.0;
        b:=1.0;
       end
    else if Center.X>Screen.DesktopLeft+Screen.DesktopWidth-OrbitSize then
      if Center.Y<Screen.DesktopTop+OrbitSize then
       begin
        a:=1.5;
        b:=1.0;
       end
      else if Center.Y>Screen.DesktopTop+Screen.DesktopHeight-OrbitSize then
       begin
        a:=-0.5;
        b:=0.0;
       end
      else
       begin
        a:=-1.0;
        b:=0.0;
       end
    else
      if Center.Y<Screen.DesktopTop+OrbitSize then
       begin
        a:=1.5;
        b:=0.5;
       end
      else if Center.Y>Screen.DesktopTop+Screen.DesktopHeight-OrbitSize then
       begin
        a:=-0.5;
        b:=0.5;
       end
      else
       begin
        a:=-0.75;
        b:=0.75;
       end;
    i:=1;
    p:=0;
    while i<>$080 do
     begin
      if (Orbit and i)<>0 then inc(p);
      i:=i shl 1;
     end;
    j:=1;
    cm:=cmLeftSingle;
    l:=0;
    i:=0;
    Canvas.Brush.Style:=bsSolid;
    if MovedOver=cmOrbit then
     begin
      Canvas.Brush.Color:=TransparentColorValue;
      Canvas.FillRect(Rect(0,0,OrbitSize*2+1,OrbitSize*2+1));
     end
    else
      DrawCross;
    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Width:=1;
    Canvas.Pen.Color:=Font.Color;
    while i<p do
     begin
      while ((Orbit and j)=0) or (l=1) do
       begin
        j:=j shl 1;
        inc(cm);
        l:=0;
       end;
      if cm=MovedOver then
        Canvas.Brush.Color:=Color1
      else
        Canvas.Brush.Color:=Color2;
      t:=Labels[cm];
      inc(i);
      c:=(a+(b-a)/(p+1)*i)*pi;
      s:=Canvas.TextExtent(t);
      x:=Round(OrbitSize+sin(c)*(OrbitSize-s.cy));
      y:=Round(OrbitSize-cos(c)*(OrbitSize-s.cy));
      Items[cm].Left:=x-MarginX-s.cx div 2;
      Items[cm].Top:=y-MarginY-s.cy div 2;
      Items[cm].Right:=x+MarginX+s.cx div 2;
      Items[cm].Bottom:=y+MarginY+s.cy div 2;
      case OrbitShape of
        0:Canvas.Rectangle(Items[cm]);
        1:Canvas.Ellipse(Items[cm]);
        //more?
      end;
      Canvas.TextOut(x-s.cx div 2,y-s.cy div 2,t);
      l:=1;
     end;
    //SetBounds(
    SetWindowPos(Handle,HWND_TOP,
      Center.X-OrbitSize,Center.Y-OrbitSize,OrbitSize*2+1,OrbitSize*2+1,
      SWP_NOACTIVATE);
   end;
end;

function TfrmOrbit.CheckItem(p: TPoint): TClickMode;
var
  i,j,k,k1,k2:integer;
  c:TClickMode;
begin
  with OrbitConfig do
  if MovedOver=cmOrbit then
   begin
    dec(p.X,Left);
    dec(p.Y,Top);
{
    Result:=High(TClickMode);
    i:=1 shl (integer(Result)-1);
    while (Result<>cmOrbit) and not(
      ((i and Orbit)<>0) and
      (p.X>Items[Result].Left) and
      (p.Y>Items[Result].Top) and
      (p.X<Items[Result].Right) and
      (p.Y<Items[Result].Bottom)
    ) do
     begin
      dec(Result);
      i:=i shr 1;
     end;
}
    c:=High(TClickMode);
    i:=1 shl (integer(c)-1);
    j:=-1;
    Result:=cmLeftSingle;//cmOrbit;//default
    while (c<>cmOrbit) do
     begin
      if ((i and Orbit)<>0) then
       begin
        k1:=p.X-(Items[c].Left+Items[c].Right) div 2;
        k2:=p.Y-(Items[c].Top+Items[c].Bottom) div 2;
        k:=k1*k1+k2*k2;
        if (j=-1) or (k<j) then
         begin
          j:=k;
          Result:=c;
         end;
       end;
      dec(c);
      i:=i shr 1;
     end;
   end
  else
   begin
    Result:=MovedOver;
    MovedOver:=cmOrbit;
   end;
end;

procedure TfrmOrbit.ShowOrbit;
begin
  MovedOver:=cmOrbit;
  //Visible:=true;
  SetWindowPos(Handle,HWND_TOP,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE or
    SWP_NOACTIVATE or SWP_SHOWWINDOW);
  Repaint;
end;

procedure TfrmOrbit.WMEraseBkgnd(var Msg: TWmEraseBkgnd);
begin
  Msg.Result:=-1;
end;

procedure TfrmOrbit.HideOrbit;
begin
  Visible:=false;
  ShowWindow(Handle,SW_HIDE);
end;

procedure TfrmOrbit.DoCreate;
begin
  inherited;
  MovedOver:=cmOrbit;
end;

procedure TfrmOrbit.CheckOrbit;
begin
  MovedOver:=cmOrbit;
  MovedOver:=CheckItem(Mouse.CursorPos);
  Repaint;
end;

initialization
  //defaults
  OrbitConfig.MarginX:=5;
  OrbitConfig.MarginY:=3;
  OrbitConfig.OrbitShape:=0;//rectangles
end.
