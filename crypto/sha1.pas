{

  sha1
  by Stijn Sanders
  http://yoy.be/md5
  2012 - 2013
  v1.0.1

  based on http://www.ietf.org/rfc/rfc3174.txt

  License: no license, free for any use

}
unit sha1;

interface

function SHA1Hash(x:UTF8String):UTF8String;

implementation

{$D-}
{$L-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

function SwapEndian32(Value: integer): integer; register;
asm
  bswap eax
end;

{
function SwapEndian32(Value: integer): integer;
var
  x:array[0..3] of byte absolute Result;
  y:array[0..3] of byte absolute Value;
begin
  x[0]:=y[3];
  x[1]:=y[2];
  x[2]:=y[1];
  x[3]:=y[0];
end;
}

function SHA1Hash(x:UTF8String):UTF8String;
const
  hex:array[0..15] of AnsiChar='0123456789abcdef';
var
  a:cardinal;
  dl,i,j:integer;
  d:array of cardinal;
  e:array[0..79] of cardinal;
  g,h:array[0..4] of cardinal;
begin
  //based on http://www.ietf.org/rfc/rfc3174.txt
  a:=Length(x);
  dl:=a+9;
  if (dl and $3F)<>0 then dl:=(dl and $FFC0)+$40;
  i:=dl;
  dl:=dl shr 2;
  SetLength(d,dl);
  SetLength(x,i);
  j:=a+1;
  x[j]:=#$80;
  while j<i do
   begin
    inc(j);
    x[j]:=#0;
   end;
  Move(x[1],d[0],i);
  d[dl-1]:=SwapEndian32(a shl 3);
  h[0]:=$67452301;
  h[1]:=$efcdab89;
  h[2]:=$98badcfe;
  h[3]:=$10325476;
  h[4]:=$c3d2e1f0;
  i:=0;
  while i<dl do
   begin
    j:=0;
    while j<16 do
     begin
      e[j]:=SwapEndian32(d[i]);
      inc(i);
      inc(j);
     end;
    while j<80 do
     begin
      a:=e[j-3] xor e[j-8] xor e[j-14] xor e[j-16];
      e[j]:=((a shl 1) or (a shr 31));
      inc(j);
     end;
    g:=h;
    j:=0;
    while j<20 do
     begin
      a:=((g[0] shl 5) or (g[0] shr 27))+
        ((g[1] and g[2]) or (not(g[1]) and g[3]))+
        g[4]+e[j]+$5a827999;
      g[4]:=g[3];
      g[3]:=g[2];
      g[2]:=((g[1] shl 30) or (g[1] shr 2));
      g[1]:=g[0];
      g[0]:=a;
      inc(j);
     end;
    while j<40 do
     begin
      a:=((g[0] shl 5) or (g[0] shr 27))+
        (g[1] xor g[2] xor g[3])+
        g[4]+e[j]+$6ed9eba1;
      g[4]:=g[3];
      g[3]:=g[2];
      g[2]:=((g[1] shl 30) or (g[1] shr 2));
      g[1]:=g[0];
      g[0]:=a;
      inc(j);
     end;
    while j<60 do
     begin
      a:=((g[0] shl 5) or (g[0] shr 27))+
        ((g[1] and g[2]) or (g[1] and g[3]) or (g[2] and g[3]))+
        g[4]+e[j]+$8f1bbcdc;
      g[4]:=g[3];
      g[3]:=g[2];
      g[2]:=((g[1] shl 30) or (g[1] shr 2));
      g[1]:=g[0];
      g[0]:=a;
      inc(j);
     end;
    while j<80 do
     begin
      a:=((g[0] shl 5) or (g[0] shr 27))+
        (g[1] xor g[2] xor g[3])+
        g[4]+e[j]+$ca62c1d6;
      g[4]:=g[3];
      g[3]:=g[2];
      g[2]:=((g[1] shl 30) or (g[1] shr 2));
      g[1]:=g[0];
      g[0]:=a;
      inc(j);
     end;
    for j:=0 to 4 do inc(h[j],g[j]);
   end;
  SetLength(Result,40);
  for j:=0 to 39 do
    Result[j+1]:=hex[h[j shr 3] shr ((47-j) shl 2) and $F];
end;

end.
