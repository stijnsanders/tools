{

  ripemd160Stream
  by Stijn Sanders
  http://yoy.be/ripemd160
  2013
  v1.0.1

  based on http://homes.esat.kuleuven.be/~bosselae/ripemd160.html

  License: no license, free for any use

}
unit ripemd160Stream;

interface

uses Classes;

function RIPEMD160HashFromStream(Stream:TStream;ReadBytes:int64=-1):AnsiString;

implementation

{$D-}
{$L-}

function RIPEMD160HashFromStream(Stream:TStream;ReadBytes:int64=-1):AnsiString;
const
  sel1:array[0..9] of cardinal=(
    $01234567,$89abcdef,
    $74d1a6f3,$c0952eb8,
    $3ae49f81,$2706db5c,
    $19ba08c4,$d37fe562,
    $40597c2a,$e138b6fd);
  sel2:array[0..9] of cardinal=(
    $5e7092b4,$d6f81a3c,
    $6b370d5a,$ef8c4912,
    $f5137e69,$b8c2a04d,
    $86413bf0,$5c2d97ae,
    $cfa41587,$62de039b);
  rol1:array[0..9] of cardinal=(
    $befc5879,$bdef6798,
    $768db97f,$7cf9b7dc,
    $bd67e9df,$e8d65c75,
    $bcefef98,$9e56865c,
    $9f5b68dc,$5cdeb856);
  rol2:array[0..9] of cardinal=(
    $899bdff5,$778beec6,
    $9df7c89b,$77c76fdb,
    $97fb866e,$cd5edd75,
    $f58bee6e,$69c9c5f8,
    $85c9c5e6,$8d65fdbb);
  add1:array[0..4] of cardinal=(
    $00000000,$5a827999,$6ed9eba1,$8f1bbcdc,$a953fd4e);
  add2:array[0..4] of cardinal=(
    $50a28be6,$5c4dd124,$6d703ef3,$7a6d76e9,$00000000);
  hex:array[0..15] of AnsiChar='0123456789abcdef';
var
  dl:int64;
  a,r,s,k:cardinal;
  x:integer;
  d:array[0..15] of cardinal;
  f:array[0..4] of cardinal;
  ga,gb,gc,gd,ge,ha,hb,hc,hd,he:cardinal;
begin
  f[0]:=$67452301;
  f[1]:=$efcdab89;
  f[2]:=$98badcfe;
  f[3]:=$10325476;
  f[4]:=$c3d2e1f0;
  dl:=0;
  x:=0;//0: running, 1:tail started but size wouldn't fit, 2:done
  while x<>2 do
   begin
    if x=0 then
     begin
      //normal read
      a:=64;
      if (ReadBytes<>-1) and (dl+a>ReadBytes) then a:=ReadBytes-dl;
      r:=0;
      while r<>a do
       begin
        s:=Stream.Read(d[r],a-r);
        if s=0 then //EOF
          a:=r
        else
          inc(r,s);
       end;
      inc(dl,a);
      //did we get a full block?
      if a<64 then
       begin
        //tail
        r:=(a and 3) shl 3;
        s:=a shr 2;
        d[s]:=(d[s] and ((1 shl r)-1)) or ($80 shl r);
        while s<16 do
         begin
          inc(s);
          d[s]:=0;
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
      for r:=0 to 13 do d[r]:=0;
      dl:=dl shl 3;//bit count
      d[14]:=dl and $FFFFFFFF;
      d[15]:=dl shr 32;
      x:=2;//done
     end;
    ga:=f[0];
    gb:=f[1];
    gc:=f[2];
    gd:=f[3];
    ge:=f[4];
    ha:=ga;
    hb:=gb;
    hc:=gc;
    hd:=gd;
    he:=ge;
    for k:=0 to 79 do
     begin
      r:=(7-(k and 7))*4;
      s:=(rol1[k shr 3] shr r) and $f;
      case k shr 4 of
        0:a:=gb xor gc xor gd;
        1:a:=(gb and gc) or (not(gb) and gd);
        2:a:=(gb or not(gc)) xor gd;
        3:a:=(gb and gd) or (gc and not(gd));
        4:a:=gb xor (gc or not(gd));
        else a:=0;
      end;
      a:=a+ga+d[((sel1[k shr 3] shr r) and $f)]+add1[k shr 4];
      a:=((a shl s) or (a shr (32-s)))+ge;
      ga:=ge;
      ge:=gd;
      gd:=((gc shl 10) or (gc shr 22));
      gc:=gb;
      gb:=a;
      s:=(rol2[k shr 3] shr r) and $f;
      case k shr 4 of
        0:a:=hb xor (hc or not(hd));
        1:a:=(hb and hd) or (hc and not(hd));
        2:a:=(hb or not(hc)) xor hd;
        3:a:=(hb and hc) or (not(hb) and hd);
        4:a:=hb xor hc xor hd;
        else a:=0;
      end;
      a:=a+ha+d[((sel2[k shr 3] shr r) and $f)]+add2[k shr 4];
      a:=((a shl s) or (a shr (32-s)))+he;
      ha:=he;
      he:=hd;
      hd:=((hc shl 10) or (hc shr 22));
      hc:=hb;
      hb:=a;
     end;
    a:=f[1]+gc+hd;
    f[1]:=f[2]+gd+he;
    f[2]:=f[3]+ge+ha;
    f[3]:=f[4]+ga+hb;
    f[4]:=f[0]+gb+hc;
    f[0]:=a;
   end;
  SetLength(Result,40);
  for k:=0 to 39 do
    Result[k+1]:=hex[f[k shr 3] shr ((k xor 1) shl 2) and $F];
end;

end.
