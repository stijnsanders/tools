{

  sha1Stream
  by Stijn Sanders
  http://yoy.be/sha1
  2012-2013
  v1.0.1

  based on http://www.ietf.org/rfc/rfc3174.txt

  License: no license, free for any use

}
unit sha1Stream;

interface

uses Classes;

function SHA1HashFromStream(Stream:TStream;ReadBytes:int64=-1):AnsiString;

implementation

{$D-}
{$L-}

function SwapEndian32(Value: integer): integer; register;
asm
  bswap eax
end;

{
function SwapEndian32(Value: integer): integer; overload;
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

function SHA1HashFromStream(Stream:TStream;ReadBytes:int64=-1):AnsiString;
const
  hex:array[0..15] of AnsiChar='0123456789abcdef';
var
  dl:int64;
  a,b:cardinal;
  x,j:integer;
  d:array[0..15] of cardinal;
  e:array[0..79] of cardinal;
  g,h:array[0..4] of cardinal;
begin
  //based on http://www.ietf.org/rfc/rfc3174.txt
  h[0]:=$67452301;
  h[1]:=$efcdab89;
  h[2]:=$98badcfe;
  h[3]:=$10325476;
  h[4]:=$c3d2e1f0;
  dl:=0;
  x:=0;//0: running, 1:tail started but size wouldn't fit, 2:done
  while x<>2 do
   begin
    if x=0 then
     begin
      //normal read
      a:=64;
      if (ReadBytes<>-1) and (dl+a>ReadBytes) then a:=ReadBytes-dl;
      b:=0;
      while b<>a do
       begin
        j:=Stream.Read(d[b],a-b);
        if j=0 then //EOF
          a:=b
        else
          inc(b,j);
       end;
      inc(dl,a);
      //did we get a full block?
      if a<64 then
       begin
        //tail
        j:=(a and 3) shl 3;
        b:=a shr 2;
        d[b]:=(d[b] and ((1 shl j)-1)) or ($80 shl j);
        while b<16 do
         begin
          inc(b);
          d[b]:=0;
         end;
        if a<56 then
         begin
          dl:=dl shl 3;//bit count
          d[14]:=SwapEndian32(dl shr 32);
          d[15]:=SwapEndian32(dl and $FFFFFFFF);
          x:=2;//this is the last block
         end
        else
          x:=1;//one more block for total size
       end;
     end
    else
     begin
      //one more block just for total size
      for a:=0 to 13 do d[a]:=0;
      dl:=dl shl 3;//bit count
      d[14]:=SwapEndian32(dl shr 32);
      d[15]:=SwapEndian32(dl and $FFFFFFFF);
      x:=2;//done
     end;
    j:=0;
    while j<16 do
     begin
      e[j]:=SwapEndian32(d[j]);
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
