{

  sha512
  by Stijn Sanders
  http://yoy.be/md5
  2015-2018
  v1.0.1

  based on https://github.com/bitcoin/bitcoin/blob/master/src/crypto/sha512.cpp

  License: no license, free for any use

}
unit sha512;

interface

function SHA512Hash(x:UTF8String):UTF8String;

implementation

{$D-}
{$L-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

function SwapEndian64(Value: UInt64): UInt64;
var
  xx:array[0..7] of byte;
  yy:array[0..7] of byte;
begin
  Move(Value,xx,8);
  yy[7]:=xx[0];
  yy[6]:=xx[1];
  yy[5]:=xx[2];
  yy[4]:=xx[3];
  yy[3]:=xx[4];
  yy[2]:=xx[5];
  yy[1]:=xx[6];
  yy[0]:=xx[7];
  Move(yy,Result,8);
end;

function SHA512Hash(x:UTF8String):UTF8String;
const
  base:array[0..79] of UInt64=(
    UInt64($428a2f98d728ae22),UInt64($7137449123ef65cd),
    UInt64($b5c0fbcfec4d3b2f),UInt64($e9b5dba58189dbbc),
    UInt64($3956c25bf348b538),UInt64($59f111f1b605d019),
    UInt64($923f82a4af194f9b),UInt64($ab1c5ed5da6d8118),
    UInt64($d807aa98a3030242),UInt64($12835b0145706fbe),
    UInt64($243185be4ee4b28c),UInt64($550c7dc3d5ffb4e2),
    UInt64($72be5d74f27b896f),UInt64($80deb1fe3b1696b1),
    UInt64($9bdc06a725c71235),UInt64($c19bf174cf692694),

    UInt64($e49b69c19ef14ad2),UInt64($efbe4786384f25e3),
    UInt64($0fc19dc68b8cd5b5),UInt64($240ca1cc77ac9c65),
    UInt64($2de92c6f592b0275),UInt64($4a7484aa6ea6e483),
    UInt64($5cb0a9dcbd41fbd4),UInt64($76f988da831153b5),
    UInt64($983e5152ee66dfab),UInt64($a831c66d2db43210),
    UInt64($b00327c898fb213f),UInt64($bf597fc7beef0ee4),
    UInt64($c6e00bf33da88fc2),UInt64($d5a79147930aa725),
    UInt64($06ca6351e003826f),UInt64($142929670a0e6e70),

    UInt64($27b70a8546d22ffc),UInt64($2e1b21385c26c926),
    UInt64($4d2c6dfc5ac42aed),UInt64($53380d139d95b3df),
    UInt64($650a73548baf63de),UInt64($766a0abb3c77b2a8),
    UInt64($81c2c92e47edaee6),UInt64($92722c851482353b),
    UInt64($a2bfe8a14cf10364),UInt64($a81a664bbc423001),
    UInt64($c24b8b70d0f89791),UInt64($c76c51a30654be30),
    UInt64($d192e819d6ef5218),UInt64($d69906245565a910),
    UInt64($f40e35855771202a),UInt64($106aa07032bbd1b8),

    UInt64($19a4c116b8d2d0c8),UInt64($1e376c085141ab53),
    UInt64($2748774cdf8eeb99),UInt64($34b0bcb5e19b48a8),
    UInt64($391c0cb3c5c95a63),UInt64($4ed8aa4ae3418acb),
    UInt64($5b9cca4f7763e373),UInt64($682e6ff3d6b2b8a3),
    UInt64($748f82ee5defb2fc),UInt64($78a5636f43172f60),
    UInt64($84c87814a1f0ab72),UInt64($8cc702081a6439ec),
    UInt64($90befffa23631e28),UInt64($a4506cebde82bde9),
    UInt64($bef9a3f7b2c67915),UInt64($c67178f2e372532b),

    UInt64($ca273eceea26619c),UInt64($d186b8c721c0c207),
    UInt64($eada7dd6cde0eb1e),UInt64($f57d4f7fee6ed178),
    UInt64($06f067aa72176fba),UInt64($0a637dc5a2c898a6),
    UInt64($113f9804bef90dae),UInt64($1b710b35131c471b),
    UInt64($28db77f523047d84),UInt64($32caab7b40c72493),
    UInt64($3c9ebe0a15c9bebc),UInt64($431d67c49c100d4c),
    UInt64($4cc5d4becb3e42b6),UInt64($597f299cfc657e2a),
    UInt64($5fcb6fab3ad6faec),UInt64($6c44198c4a475817)
  );
var
  a,b:UInt64;
  dl,i,j:integer;
  d:array of UInt64;
  e:array[0..79] of UInt64;
  g,h:array[0..7] of UInt64;
begin
  a:=Length(x);
  dl:=a+9;
  if (dl mod 128)<>0 then dl:=((dl div 128)+1)*128;
  i:=dl;
  dl:=dl div 8;
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
  d[dl-1]:=SwapEndian64(a shl 3);
  h[0]:=UInt64($6a09e667f3bcc908);
  h[1]:=UInt64($bb67ae8584caa73b);
  h[2]:=UInt64($3c6ef372fe94f82b);
  h[3]:=UInt64($a54ff53a5f1d36f1);
  h[4]:=UInt64($510e527fade682d1);
  h[5]:=UInt64($9b05688c2b3e6c1f);
  h[6]:=UInt64($1f83d9abfb41bd6b);
  h[7]:=UInt64($5be0cd19137e2179);
  i:=0;
  while i<dl do
   begin
    j:=0;
    while j<16 do
     begin
      e[j]:=SwapEndian64(d[i]);
      inc(i);
      inc(j);
     end;
    while j<80 do
     begin
      a:=e[j-15];
      b:=e[j-2];
      e[j]:=e[j-16]+
        (((a shr  1) or (a shl 63)) xor
         ((a shr  8) or (a shl 56)) xor
          (a shr  7))+
        e[j-7]+
        (((b shr 19) or (b shl 45)) xor
         ((b shr 61) or (b shl  3)) xor
          (b shr  6));
      inc(j);
     end;
    g:=h;
    j:=0;
    while j<80 do
     begin
      a:=g[4];
      b:=g[0];
      a:=g[7]+
        (((a shr 14) or (a shl 50)) xor
         ((a shr 18) or (a shl 46)) xor
         ((a shr 41) or (a shl 23)))+
        ((g[4] and g[5]) or (not(g[4]) and g[6]))+
        base[j]+e[j];
      g[3]:=g[3]+a;
      a:=a+
        (((b shr 28) or (b shl 36)) xor
         ((b shr 34) or (b shl 30)) xor
         ((b shr 39) or (b shl 25)))+
        ((g[0] and g[1]) or (g[1] and g[2]) or (g[2] and g[0]));
      g[7]:=g[6];
      g[6]:=g[5];
      g[5]:=g[4];
      g[4]:=g[3];
      g[3]:=g[2];
      g[2]:=g[1];
      g[1]:=g[0];
      g[0]:=a;
      inc(j);
     end;
    for j:=0 to 7 do h[j]:=h[j]+g[j];
   end;
  SetLength(Result,64);
  for j:=0 to 63 do
    byte(Result[j+1]):=h[j shr 3] shr ((j xor 7) shl 3);
end;

end.
