{

  murmur3
  by Stijn Sanders
  http://yoy.be/md5
  2017
  v1.0.0

  based on https://github.com/aappleby/smhasher/blob/master/src/MurmurHash3.cpp
  (92cf370 on Jan 9 2016)

  License: no license, free for any use

}
unit murmur3;

interface

function MurMurHash3_x86_32(const x:UTF8String; seed:cardinal):UTF8String;
function MurMurHash3_x86_128(const x:UTF8String; seed:cardinal):UTF8String;
function MurMurHash3_x64_128(const x:UTF8String; seed:cardinal):UTF8String;

implementation

uses SysUtils;

{$D-}
{$L-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

function fmix32(h:cardinal):cardinal;
begin
  Result:=h xor (h shr 16);
  Result:=Result*$85ebca6b;
  Result:=Result xor (Result shr 13);
  Result:=Result*$c2b2ae35;
  Result:=Result xor (Result shr 16);
end;

function fmix64(k:UInt64):UInt64;
begin
  Result:=k xor (k shr 33);
  Result:=Result*$ff51afd7ed558ccd;
  Result:=Result xor (Result shr 33);
  Result:=Result*$c4ceb9fe1a85ec53;
  Result:=Result xor (Result shr 33);
end;

function MurMurHash3_x86_32(const x:UTF8String; seed:cardinal):UTF8String;
var
  i,l,n,h1,k1:cardinal;
const
  c1=$cc9e2d51;
  c2=$1b873593;
begin
  l:=Length(x);
  n:=l xor (l and $3);
  h1:=seed;
  i:=0;
  while i<>n do
   begin
    k1:=PCardinal(@x[i+1])^;
    inc(i,4);
    k1:=k1*c1;
    k1:=((k1 shl 15) or (k1 shr 17))*c2;
    h1:=h1 xor k1;
    h1:=((h1 shl 13) or (h1 shr 19))*5+$e6546b64;
   end;
  n:=l and $3;
  k1:=0;
  if n>2 then k1:=k1 xor byte(x[i+3]) shl 16;
  if n>1 then k1:=k1 xor byte(x[i+2]) shl 8;
  if n>0 then k1:=k1 xor byte(x[i+1]);
  k1:=k1*c1;
  k1:=((k1 shl 15) or (k1 shr 17))*c2;
  h1:=h1 xor k1;
  Result:=Format('%.8x',[fmix32(h1 xor l)]);
end;

function MurMurHash3_x86_128(const x:UTF8String; seed:cardinal):UTF8String;
var
  i,l,n,h1,h2,h3,h4,k1,k2,k3,k4:cardinal;
const
  c1=$239b961b;
  c2=$ab0e9789;
  c3=$38b34ae5;
  c4=$a1e38b93;
begin
  l:=Length(x);
  n:=l xor (l and $F);
  h1:=seed;
  h2:=seed;
  h3:=seed;
  h4:=seed;
  i:=0;
  while i<>n do
   begin
    k1:=PCardinal(@x[i+1])^*c1;
    k1:=((k1 shl 15) or (k1 shr 17))*c2;
    h1:=h1 xor k1;
    h1:=(((h1 shl 19) or (h1 shr 13))+h2)*5+$561ccd1b;
    inc(i,4);

    k2:=PCardinal(@x[i+1])^*c2;
    k2:=((k2 shl 16) or (k2 shr 16))*c3;
    h2:=h2 xor k2;
    h2:=(((h2 shl 17) or (h2 shr 15))+h3)*5+$0bcaa747;
    inc(i,4);

    k3:=PCardinal(@x[i+1])^*c3;
    k3:=((k3 shl 17) or (k3 shr 15))*c4;
    h3:=h3 xor k3;
    h3:=(((h3 shl 15) or (h3 shr 17))+h4)*5+$96cd1c35;
    inc(i,4);

    k4:=PCardinal(@x[i+1])^*c4;
    k4:=((k4 shl 18) or (k4 shr 14))*c1;
    h4:=h4 xor k4;
    h4:=(((h4 shl 13) or (h4 shr 19))+h4)*5+$32ac3b17;
    inc(i,4);
   end;

  n:=l and $F;

  k4:=0;
  if n>14 then k4:=k4 xor (byte(x[i+15]) shl 16);
  if n>13 then k4:=k4 xor (byte(x[i+14]) shl 8);
  if n>12 then k4:=k4 xor (byte(x[i+13]));
  k4:=k4*c4;
  k4:=((k4 shl 18) or (k4 shl 14))*c1;
  h4:=h4 xor k4;

  k3:=0;
  if n>11 then k3:=k3 xor (byte(x[i+12]) shl 24);
  if n>10 then k3:=k3 xor (byte(x[i+11]) shl 16);
  if n>09 then k3:=k3 xor (byte(x[i+10]) shl 8);
  if n>08 then k3:=k3 xor (byte(x[i+9]));
  k3:=k3*c3;
  k3:=((k3 shl 17) or (k3 shr 17))*c4;
  h3:=h3 xor k3;

  k2:=0;
  if n>7 then k2:=k2 xor (byte(x[i+8]) shl 24);
  if n>6 then k2:=k2 xor (byte(x[i+7]) shl 16);
  if n>5 then k2:=k2 xor (byte(x[i+6]) shl 8);
  if n>4 then k2:=k2 xor (byte(x[i+5]));
  k2:=k2*c2;
  k2:=((k2 shl 16) or (k2 shr 16))*c3;
  h2:=h2 xor k2;

  k1:=0;
  if n>3 then k1:=k1 xor (byte(x[i+4]) shl 24);
  if n>2 then k1:=k1 xor (byte(x[i+3]) shl 16);
  if n>1 then k1:=k1 xor (byte(x[i+2]) shl 8);
  if n>0 then k1:=k1 xor (byte(x[i+1]));
  k1:=k1*c1;
  k1:=((k1 shl 15) or (k1 shr 17))*c2;
  h1:=h1 xor k1;

  h1:=h1 xor l;
  h2:=h2 xor l;
  h3:=h3 xor l;
  h4:=h4 xor l;

  h1:=h1+h2+h3+h4;
  h2:=h2+h1;
  h3:=h3+h1;
  h4:=h4+h1;

  h1:=fmix32(h1);
  h2:=fmix32(h2);
  h3:=fmix32(h3);
  h4:=fmix32(h4);

  h1:=h1+h2+h3+h4;
  h2:=h2+h1;
  h3:=h3+h1;
  h4:=h4+h1;

  Result:=Format('%.8x%.8x%.8x%.8x',[h1,h2,h3,h4]);
end;

function MurMurHash3_x64_128(const x:UTF8String; seed:cardinal):UTF8String;
var
  i,l,n:cardinal;
  h1,h2,k1,k2:UInt64;
const
  c1:UInt64=UInt64($87c37b91114253d5);
  c2:UInt64=UInt64($4cf5ad432745937f);
begin
  l:=Length(x);
  n:=l xor (l and $F);
  h1:=seed;
  h2:=seed;
  i:=0;
  while i<>n do
   begin
    k1:=PInt64(@x[i+1])^*c1;
    k1:=((k1 shl 31) or (k1 shr 33))*c2;
    h1:=h1 xor k1;
    h1:=(((h1 shl 27) or (h1 shr 37))+h2)*5+$52dce729;
    inc(i,8);

    k2:=PInt64(@x[i+1])^*c2;
    k2:=((k2 shl 33) or (k2 shr 31))*c1;
    h2:=h2 xor k2;
    h2:=(((h2 shl 31) or (h2 shr 33))+h1)*5+$38495ab5;
    inc(i,8);
   end;

  n:=l and $F;

  k2:=0;
  if n>15 then k2:=k2 xor ((UInt64(byte(x[i+15]))) shl 48);
  if n>14 then k2:=k2 xor ((UInt64(byte(x[i+14]))) shl 40);
  if n>13 then k2:=k2 xor ((UInt64(byte(x[i+13]))) shl 32);
  if n>12 then k2:=k2 xor ((UInt64(byte(x[i+12]))) shl 24);
  if n>11 then k2:=k2 xor ((UInt64(byte(x[i+11]))) shl 16);
  if n>10 then k2:=k2 xor ((UInt64(byte(x[i+10]))) shl 8);
  if n>09 then k2:=k2 xor ((UInt64(byte(x[i+9]))));
  k2:=k2*c2;
  k2:=((k2 shl 33) or (k2 shr 31))*c1;
  h2:=h2 xor k2;

  k1:=0;
  if n>8 then k1:=k1 xor ((UInt64(byte(x[i+8]))) shl 56);
  if n>7 then k1:=k1 xor ((UInt64(byte(x[i+7]))) shl 48);
  if n>6 then k1:=k1 xor ((UInt64(byte(x[i+6]))) shl 40);
  if n>5 then k1:=k1 xor ((UInt64(byte(x[i+5]))) shl 32);
  if n>4 then k1:=k1 xor ((UInt64(byte(x[i+4]))) shl 24);
  if n>3 then k1:=k1 xor ((UInt64(byte(x[i+3]))) shl 16);
  if n>2 then k1:=k1 xor ((UInt64(byte(x[i+2]))) shl 8);
  if n>0 then k1:=k1 xor ((UInt64(byte(x[i+1]))));
  k1:=k1*c1;
  k1:=((k1 shl 31) or (k1 shr 33))*c2;
  h1:=h1 xor k1;

  h1:=h1 xor l;
  h2:=h2 xor l;
  h1:=h1+h2;
  h2:=h2+h1;
  h1:=fmix64(h1);
  h2:=fmix32(h2);
  h1:=h1+h2;
  h2:=h2+h1;
  Result:=Format('%.16x%.16x',[h1,h2]);
end;

end.
