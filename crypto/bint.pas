{

  "bint": Bytes-Integer
  by Stijn Sanders
  http://yoy.be/md5
  2018
  v1.0.0

  License: no license, free for any use

}
unit bint;

{$DEFINE BINT_PLAINT_ARRAY_BYTE}

interface

{$IFDEF BINT_PLAINT_ARRAY_BYTE}

type
  TBInt=array of byte;
const
  BIntBase=0;

function BIntToRaw(const x:TBInt):AnsiString;
function RawToBInt(const x:AnsiString):TBInt;

{$ELSE}

type
  TBInt=AnsiString;
const
  BIntBase=1;

{$ENDIF}

function IntToBInt(a:cardinal):TBInt; overload;
function IntToBInt(a:int64):TBInt; overload;

function BIntToStr(const a:TBInt):string;
function StrToBInt(const a:string):TBInt;

function Clone(a:TBInt):TBInt;
function IsZero(const a:TBInt):boolean;
function IsEqual(const a,b:TBInt):boolean;
function IsLessThan(const a,b:TBInt):boolean;
function IsLessThanOrEqual(const a,b:TBInt):boolean;
function IsGreaterThan(const a,b:TBInt):boolean;
function IsGreaterThanOrEqual(const a,b:TBInt):boolean;

function Add(const a:TBint;b:byte):TBInt; overload;
function Add(const a,b:TBInt):TBInt; overload;
function Subtract(const a:TBInt;b:byte):TBInt; overload;
function Subtract(const a,b:TBInt):TBInt; overload;
function Multiply(const a:TBInt;b:byte):TBInt; overload;
function Multiply(const a,b:TBInt):TBInt; overload;
procedure DivMod(const a:TBInt;b:byte;var q:TBInt;var m:byte); overload;
procedure DivMod(const a,b:TBint;var q,m:TBint); overload;
function Power(const a,b:TBInt):TBInt;
function PowMod(const a,b,n:TBint):TBInt;

implementation

uses SysUtils, Math;

{$IFDEF BINT_PLAINT_ARRAY_BYTE}
function BIntToRaw(const x:TBInt):AnsiString;
var
  i,l:cardinal;
begin
  l:=Length(x);
  SetLength(Result,l);
  if l<>0 then
    for i:=0 to l-1 do
      byte(Result[i+1]):=x[i];//TODO:CopyMemory
end;

function RawToBInt(const x:AnsiString):TBInt;
var
  i,l:cardinal;
begin
  l:=Length(x);
  SetLength(Result,l);
  if l<>0 then
    for i:=0 to l-1 do
      Result[i]:=byte(x[i+1]);//TODO:CopyMemory
end;
{$ENDIF}

function IntToBInt(a:cardinal):TBInt;
var
  i:cardinal;
begin
  SetLength(Result,4);
  i:=0;
  while a<>0 do
   begin
    byte(Result[i+BIntBase]):=byte(a);
    a:=a shr 8;
    inc(i);
   end;
  SetLength(Result,i);
end;

function IntToBInt(a:int64):TBInt;
var
  i:cardinal;
begin
  SetLength(Result,8);
  i:=0;
  while a<>0 do
   begin
    byte(Result[i+BIntBase]):=byte(a);
    a:=a shr 8;
    inc(i);
   end;
  SetLength(Result,i);
end;

function BIntToStr(const a:TBInt):string;
var
  i,l:cardinal;
  x:TBInt;
  y:byte;
begin
  //TODO Result:=BIntToBase(a,10);
  l:=Length(a);
  SetLength(Result,l*4);
  x:=Clone(a);
  i:=0;
  while not(IsZero(x)) do
   begin
    DivMod(x,10,x,y);
    inc(i);
    Result[i]:=char($30 or y);
   end;
  if i=0 then Result:='0' else
   begin
    SetLength(Result,i);
    l:=0;
    while l+1<i do
     begin
      inc(l);
      y:=byte(Result[l]);
      Result[l]:=Result[i];
      Result[i]:=char(y);
      dec(i);
     end;
   end;
end;

function StrToBInt(const a:string):TBInt;
var
  i,l:cardinal;
  x:TBInt;
begin
  //TODO Result:=BaseToBInt(a,10);
  l:=Length(a);
  Result:=IntToBInt(0);
  i:=l;
  x:=IntToBInt(1);
  while i<>0 do
   begin
    Result:=Add(Result,Multiply(x,byte(a[i]) and $F));
    dec(i);
    if i<>0 then x:=Multiply(x,10);
   end;
end;

function Clone(a:TBInt):TBInt;
var
  i,l:cardinal;
begin
  l:=Length(a);
  SetLength(Result,l);
  if l<>0 then
    for i:=0 to l-1 do
      byte(Result[i+BIntBase]):=byte(a[i+BIntBase]);
end;

function IsZero(const a:TBInt):boolean;
var
  l:cardinal;
begin
  l:=Length(a);
  while (l<>0) and (byte(a[l-1+BIntBase])=0) do dec(l);
  Result:=l=0;
end;

function IsEqual(const a,b:TBInt):boolean;
var
  la,lb:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if la=lb then
   begin
    while (la<>0) and (a[la-1+BIntBase]=b[la-1+BIntBase]) do dec(la);
    Result:=la=0;
   end
  else
    Result:=false;
end;

function IsLessThan(const a,b:TBInt):boolean;
var
  la,lb,i:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if la=lb then
   begin
    i:=la;
    while (i<>0) and (a[i-1+BIntBase]=b[i-1+BIntBase]) do dec(i);
    Result:=(i<>0) and (a[i-1+BIntBase]<b[i-1+BIntBase]);
   end
  else
    Result:=la<lb;
end;

function IsLessThanOrEqual(const a,b:TBInt):boolean;
var
  la,lb,i:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if la=lb then
   begin
    i:=la;
    while (i<>0) and (a[i-1+BIntBase]=b[i-1+BIntBase]) do dec(i);
    Result:=(i=0) or (a[i-1+BIntBase]<b[i-1+BIntBase]);
   end
  else
    Result:=la<lb;
end;

function IsGreaterThan(const a,b:TBInt):boolean;
var
  la,lb,i:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if la=lb then
   begin
    i:=la;
    while (i<>0) and (a[i-1+BIntBase]=b[i-1+BIntBase]) do dec(i);
    Result:=(i<>0) and (a[i-1+BIntBase]>b[i-1+BIntBase]);
   end
  else
    Result:=la<lb;
end;

function IsGreaterThanOrEqual(const a,b:TBInt):boolean;
var
  la,lb,i:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if la=lb then
   begin
    i:=la;
    while (i<>0) and (a[i-1+BIntBase]=b[i-1+BIntBase]) do dec(i);
    Result:=(i=0) or (a[i-1+BIntBase]>b[i-1+BIntBase]);
   end
  else
    Result:=la<lb;
end;

function Add(const a:TBint;b:byte):TBInt;
var
  la,lr,i,c:cardinal;
begin
  la:=Length(a);
  lr:=la;
  if (la=1) and (cardinal(a[BIntBase])+b>$FF) then
    inc(lr);
  SetLength(Result,lr);
  i:=0;
  c:=b;
  while i<lr do
   begin
    if i<la then inc(c,byte(a[i+BIntBase]));
    byte(Result[i+BIntBase]):=byte(c);
    c:=c shr 8;
    inc(i);
   end;
end;

function Add(const a,b:TBInt):TBInt;
var
  la,lb,lr,i,c:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if (la<>0) and (la=lb) then
   begin
    lr:=la;
    if cardinal(a[la-1+BIntBase])+cardinal(b[lb-1+BIntBase])>$FF then
      inc(lr);
   end
  else
    if la>lb then lr:=la else lr:=lb;
  SetLength(Result,lr);
  i:=0;
  c:=0;
  while i<lr do
   begin
    if i<la then inc(c,byte(a[i+BIntBase]));
    if i<lb then inc(c,byte(b[i+BIntBase]));
    byte(Result[i+BIntBase]):=byte(c);
    c:=c shr 8;
    inc(i);
   end;
end;

function Subtract(const a:TBint;b:byte):TBInt;
var
  la,i,c,xa:cardinal;
begin
  la:=Length(a);
  if (la=0) or ((la=1) and (byte(a[BIntBase])<b)) then
    raise Exception.Create('BInt: Subtract: b greater than a in "a-b"');
  SetLength(Result,la);
  i:=0;
  c:=b;
  while i<la do
   begin
    xa:=byte(a[i+BIntBase]);
    if xa<c then
     begin
      inc(xa,$100-c);
      c:=1;
     end
    else
     begin
      if c<>0 then dec(xa);
      c:=0;
     end;
    byte(Result[i+BIntBase]):=xa;
   end;
  while (la<>0) and (byte(Result[la-1+BIntBase])=0) do dec(la);
  SetLength(Result,la);
end;

function Subtract(const a,b:TBInt):TBInt;
var
  la,lb,xa,xb,i,c:cardinal;
begin
  la:=Length(a);
  lb:=Length(b);
  if (lb>la) or ((lb=la) and (a[la-1+BIntBase]<b[lb-1+BIntBase])) then
    raise Exception.Create('BInt: Subtract: b greater than a in "a-b"');
  SetLength(Result,la);
  i:=0;
  c:=0;
  while i<lb do
   begin
    xa:=byte(a[i+BIntBase]);
    xb:=byte(b[i+BIntBase]);
    if (xa<c) or (xa<xb) then
     begin
      inc(xa,$100-c);
      c:=1;
     end
    else
     begin
      if c<>0 then dec(xa);
      c:=0;
     end;
    byte(Result[i+BintBase]):=byte(xa-xb);
    inc(i);
   end;
  while (la<>0) and (byte(Result[la-1+BIntBase])=0) do dec(la);
  SetLength(Result,la);
end;

function Multiply(const a:TBInt;b:byte):TBInt;
var
  la,i,xc:cardinal;
  x:TBInt;
begin
  if b=0 then
    SetLength(Result,0)
  else
   begin
    la:=Length(a);
    while (la<>0) and (byte(a[la-1+BIntBase])=0) do dec(la);
    SetLength(x,la+1);
    for i:=0 to la do byte(x[i+BIntBase]):=0;
    i:=0;
    xc:=0;
    while (i<la) do
     begin
      inc(xc,byte(a[i+BIntBase])*b);
      byte(x[i+BIntBase]):=byte(xc);
      xc:=xc shr 8;
      inc(i);
     end;
    //assert xc<$100;
    byte(x[la+BIntBase]):=byte(xc);
    inc(la);
    while (la<>0) and (byte(x[la-1+BIntBase])=0) do dec(la);
    SetLength(Result,la);
    if la<>0 then
      for i:=0 to la-1 do
        byte(Result[i+BIntBase]):=byte(x[i+BIntBase]);
   end;
end;

function Multiply(const a,b:TBInt):TBInt;
var
  la,lb,i,ia,ib,xa,xb,xc:cardinal;
  x:TBInt;
begin
  la:=Length(a);
  lb:=Length(b);
  while (la<>0) and (byte(a[la-1+BIntBase])=0) do dec(la);
  while (lb<>0) and (byte(b[lb-1+BIntBase])=0) do dec(lb);
  xa:=la+lb;
  SetLength(x,xa);
  if xa<>0 then
    for i:=0 to xa-1 do
      byte(x[i+BIntBase]):=0;
  ia:=0;
  while ia<la do
   begin
    ib:=0;
    while ib<lb do
     begin
      xa:=byte(a[ia+BIntBase]);
      xb:=byte(b[ib+BIntBase]);
      xc:=xa*xb;
      i:=ia+ib;
      while xc<>0 do
       begin
        inc(xc,byte(x[i+BIntBase]));
        byte(x[i+BIntBase]):=byte(xc);
        xc:=xc shr 8;
        inc(i);
       end;
      inc(ib);
     end;
    inc(ia);
   end;
  i:=la+lb;
  while (i<>0) and (byte(x[i-1+BIntBase])=0) do dec(i);
  SetLength(Result,i);
  while (i<>0) do
   begin
    dec(i);
    Result[i+BIntBase]:=x[i+BIntBase];
   end;
end;

procedure DivMod(const a:TBInt;b:byte;var q:TBInt;var m:byte);
var
  la,ia,xd:cardinal;
begin
  if b=0 then raise EDivByZero.Create('BInt: Division by zero');
  la:=Length(a);
  if (la=1) and (byte(a[BIntBase])<b) then
   begin
    m:=byte(a[BIntBase]);
    q:=IntToBInt(0);
   end
  else
   begin
    SetLength(q,la);
    ia:=la;
    xd:=0;
    while ia<>0 do
     begin
      dec(ia);
      xd:=(xd shl 8) or byte(a[ia+BIntBase]);
      byte(q[ia+BIntBase]):=xd div b;
      xd                  :=xd mod b;
     end;
    m:=xd;
    while (la<>0) and (byte(q[la-1+BIntBase])=0) do dec(la);
    SetLength(q,la);
   end;
end;

procedure DivMod(const a,b:TBint;var q,m:TBint);
var
  la,lb,lq,ia,ib,na,xa,xb,xc,xq:cardinal;
  ra,rb,rc:TBInt;//ra,rb just in case (q=a) or (q=b) or (m=a) or (m=b)
  c:boolean;
begin
  la:=Length(a);
  lb:=Length(b);
  while (la<>0) and (byte(a[la-1+BIntBase])=0) do dec(la);
  if la=0 then raise EDivByZero.Create('BInt: Division by zero');
  while (lb<>0) and (byte(b[lb-1+BIntBase])=0) do dec(lb);
  if (lb>la) or ((la<>0) and (lb=la) and (byte(a[la-1+BIntBase])<byte(b[lb-1+BIntBase]))) then
   begin
    //divider larger than divident
    SetLength(q,0);
    if @m<>@a then
     begin
      SetLength(m,la);
      if la<>0 then
        for ia:=0 to la-1 do
          m[ia+BIntBase]:=a[ia+BIntBase];
     end;
   end
  else
   begin
    //ra:=Clone(a);
    SetLength(ra,la);
    if la<>0 then
      for ia:=0 to la-1 do
        ra[ia+BIntBase]:=a[ia+BIntBase];
    //rb:=Clone(b);
    SetLength(rb,lb);
    if lb<>0 then
      for ib:=0 to lb-1 do
        rb[ib+BIntBase]:=b[ib+BIntBase];
    //rc will hold rb*xq below
    SetLength(rc,la);
    lq:=la-lb;
    SetLength(q,lq);
    xa:=0;
    na:=la;
    while lq<>0 do
     begin
      xa:=(xa shl 8) or byte(ra[na-1+BIntBase]);
      xq:=xa div byte(rb[lb-1+BIntBase]);
      if xq=0 then
        dec(na)
      else
       begin
        c:=true;
        while c do
         begin
          ia:=na-lb;
          ib:=0;
          xc:=0;
          while ia<la do
           begin
            if ib<lb then inc(xc,byte(rb[ib+BIntBase])*xq);
            byte(rc[ia+BIntBase]):=byte(xc);
            xc:=xc shr 8;
            inc(ia);
            inc(ib);
           end;
          ia:=la;
          while (ia<>0) and (rc[ia-1+BIntBase]=ra[ia-1+BIntBase]) do dec(ia);
          c:=(ia=0) or (rc[ia-1+BIntBase]>ra[ia-1+BIntBase]);
          if c then dec(xq);
         end;
        dec(lq);
        byte(q[lq+BIntBase]):=xq;
        ia:=lq;
        xc:=0;
        while ia<la do
         begin
          xa:=byte(ra[ia+BIntBase]);
          xb:=byte(rc[ia+BIntBase]);
          if (xa<xc) or (xa<xb) then
           begin
            inc(xa,$100-xc);
            xc:=1;
           end
          else
           begin
            if xc<>0 then dec(xa);
            xc:=0;
           end;
          byte(ra[ia+BintBase]):=byte(xa-xb);
          inc(ia);
         end;
        if (la<>0) and (ra[la+BIntBase]=0) then dec(la);
        na:=la;
        xa:=0;
       end;
     end;
    while (la<>0) and (byte(ra[la-1+BIntBase])=0) do dec(la);
    SetLength(m,la);
    if la<>0 then
      for ia:=0 to la-1 do
        byte(m[ia+BIntBase]):=byte(ra[ia+BIntBase]);
   end;
end;

function Power(const a,b:TBInt):TBInt;
var
  n,r:TBInt;
  xb:byte;
  lb,ib,nb:cardinal;
begin
  n:=Clone(a);
  r:=IntToBInt(1);
  ib:=0;
  lb:=Length(b);
  while ib<lb do
   begin
    xb:=byte(b[ib+BIntBase]);
    inc(ib);
    nb:=8;
    while (nb<>0) and (xb<>0) do
     begin
      dec(nb);
      if (xb and 1)<>0 then
        r:=Multiply(r,n);
      xb:=xb shr 1;
      if not((xb=0) and (ib=lb)) then n:=Multiply(n,n);
     end;
   end;
  Result:=Clone(r);
end;

function PowMod(const a,b,n:TBint):TBInt;
var
  m,q,r:TBInt;
  xb:byte;
  lb,ib,nb:cardinal;
begin
  DivMod(a,n,q,m);
  r:=IntToBInt(1);
  ib:=0;
  lb:=Length(b);
  while ib<lb do
   begin
    xb:=byte(b[ib+BIntBase]);
    inc(ib);
    nb:=8;
    while (nb<>0) and (xb<>0) do
     begin
      dec(nb);
      if (xb and 1)<>0 then
        r:=Multiply(r,m);
      xb:=xb shr 1;
      if not((xb=0) and (ib=lb)) then DivMod(Multiply(m,m),n,q,m);
     end;
   end;
  Result:=Clone(r);
end;

end.
