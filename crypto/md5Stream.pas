{

  md5Stream
  by Stijn Sanders
  http://yoy.be/md5
  2012
  v1.0.1

  based on http://www.ietf.org/rfc/rfc1321.txt

  License: no license, free for any use

}
unit md5Stream;

interface

uses Classes;

function MD5HashFromStream(Stream:TStream;ReadBytes:int64=-1):AnsiString;

implementation

function MD5HashFromStream(Stream:TStream;ReadBytes:int64=-1):AnsiString;
const
  roll1:array[0..3] of cardinal=(7,12,17,22);
  roll2:array[0..3] of cardinal=(5,9,14,20);
  roll3:array[0..3] of cardinal=(4,11,16,23);
  roll4:array[0..3] of cardinal=(6,10,15,21);
  base1:array[0..15] of cardinal=(
    $d76aa478,$e8c7b756,$242070db,$c1bdceee,
    $f57c0faf,$4787c62a,$a8304613,$fd469501,
    $698098d8,$8b44f7af,$ffff5bb1,$895cd7be,
    $6b901122,$fd987193,$a679438e,$49b40821);
  base2:array[0..15] of cardinal=(
    $f61e2562,$c040b340,$265e5a51,$e9b6c7aa,
    $d62f105d,$02441453,$d8a1e681,$e7d3fbc8,
    $21e1cde6,$c33707d6,$f4d50d87,$455a14ed,
    $a9e3e905,$fcefa3f8,$676f02d9,$8d2a4c8a);
  base3:array[0..15] of cardinal=(
    $fffa3942,$8771f681,$6d9d6122,$fde5380c,
    $a4beea44,$4bdecfa9,$f6bb4b60,$bebfbc70,
    $289b7ec6,$eaa127fa,$d4ef3085,$04881d05,
    $d9d4d039,$e6db99e5,$1fa27cf8,$c4ac5665);
  base4:array[0..15] of cardinal=(
    $f4292244,$432aff97,$ab9423a7,$fc93a039,
    $655b59c3,$8f0ccc92,$ffeff47d,$85845dd1,
    $6fa87e4f,$fe2ce6e0,$a3014314,$4e0811a1,
    $f7537e82,$bd3af235,$2ad7d2bb,$eb86d391);
  hex:array[0..15] of AnsiChar='0123456789abcdef';
var
  dl:int64;
  a,b:cardinal;
  x,j,k,l:integer;
  d:array[0..15] of cardinal;
  g,h:array[0..3] of cardinal;
begin
  //based on http://www.ietf.org/rfc/rfc1321.txt
  h[0]:=$67452301;
  h[1]:=$efcdab89;
  h[2]:=$98badcfe;
  h[3]:=$10325476;
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
          d[14]:=dl and $FFFFFFFF;
          d[15]:=dl shr 32;
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
      d[14]:=dl and $FFFFFFFF;
      d[15]:=dl shr 32;
      x:=2;//done
     end;
    g:=h;
    j:=0;
    for k:=0 to 15 do
     begin
      l:=k*3;
      a:=h[l and 3]+
        ((h[(l+1) and 3] and h[(l+2) and 3]) or
        (not(h[(l+1) and 3]) and h[(l+3) and 3]))+
        d[j]+
        base1[k];
      h[l and 3]:=h[(l+1) and 3]+
        ((a shl roll1[k and 3]) or (a shr (32-roll1[k and 3])));
      inc(j);
     end;
    j:=1;
    for k:=0 to 15 do
     begin
      l:=k*3;
      a:=h[l and 3]+
        ((h[(l+3) and 3] and h[(l+1) and 3]) or
        (not(h[(l+3) and 3]) and h[(l+2) and 3]))+
        d[j and $F]+
        base2[k];
      h[l and 3]:=h[(l+1) and 3]+
        ((a shl roll2[k and 3]) or (a shr (32-roll2[k and 3])));
      inc(j,5);
     end;
    j:=5;
    for k:=0 to 15 do
     begin
      l:=k*3;
      a:=h[l and 3]+
        (h[(l+1) and 3] xor h[(l+2) and 3] xor h[(l+3) and 3])+
        d[j and $F]+
        base3[k];
      h[l and 3]:=h[(l+1) and 3]+
        ((a shl roll3[k and 3]) or (a shr (32-roll3[k and 3])));
      inc(j,3);
     end;
    j:=0;
    for k:=0 to 15 do
     begin
      l:=k*3;
      a:=h[l and 3]+
        (h[(l+2) and 3] xor (h[(l+1) and 3] or not h[(l+3) and 3]))+
        d[j and $F]+
        base4[k];
      h[l and 3]:=h[(l+1) and 3]+
        ((a shl roll4[k and 3]) or (a shr (32-roll4[k and 3])));
      inc(j,7);
     end;
    for k:=0 to 3 do inc(h[k],g[k]);
   end;
  SetLength(Result,32);
  for k:=0 to 31 do
    Result[k+1]:=hex[h[k shr 3] shr ((k xor 1) shl 2) and $F];
end;

end.

