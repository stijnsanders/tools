{

  HashUtils
  by Stijn Sanders
  http://yoy.be/md5
  2015-2021
  v1.0.4

  based on
  https://en.wikipedia.org/wiki/Hmac
  https://tools.ietf.org/html/rfc2898
  https://tools.ietf.org/html/rfc4648

  License: no license, free for any use

}
unit HashUtils;

interface

type
  THashFunction=function(x:UTF8String):UTF8String;

  TPseudoRandomFunction=function(const Key, Msg:UTF8String):UTF8String;

function HMAC(HashFn: THashFunction; BlockSize: integer;
  const Key, Msg: UTF8String): UTF8String;

function PBKDF2(PRF:TPseudoRandomFunction;HashLength:cardinal;
  const Password,Salt:UTF8String;Iterations,KeyLength:cardinal):UTF8String;

function HexEncode(const x:UTF8String):UTF8String;
function HexEncodeUpperCase(const x:UTF8String):UTF8String;
function HexDecode(const x:UTF8String):UTF8String;

function Base32Encode(const x:UTF8String):UTF8String;
function Base32Decode(const x:UTF8String):UTF8String;

function Base64Encode(const x:UTF8String):UTF8String;
function Base64Decode(const x:UTF8String):UTF8String;

implementation

{$D-}
{$L-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

function HexEncode(const x:UTF8String):UTF8String;
var
  i,l:integer;
const
  hex:array[0..15] of AnsiChar='0123456789abcdef';
begin
  l:=Length(x);
  SetLength(Result,l*2);
  for i:=1 to l do
   begin
    Result[i*2-1]:=hex[byte(x[i]) shr $4];
    Result[i*2  ]:=hex[byte(x[i]) and $F];
   end;
end;

function HexEncodeUpperCase(const x:UTF8String):UTF8String;
var
  i,l:integer;
const
  hex:array[0..15] of AnsiChar='0123456789ABCDEF';
begin
  l:=Length(x);
  SetLength(Result,l*2);
  for i:=1 to l do
   begin
    Result[i*2-1]:=hex[byte(x[i]) shr $4];
    Result[i*2  ]:=hex[byte(x[i]) and $F];
   end;
end;

function HexDecode(const x:UTF8String):UTF8String;
var
  i,l:integer;
begin
  l:=Length(x) div 2;
  SetLength(Result,l);
  for i:=1 to l do
   begin
    byte(Result[i]):=0;
    if (byte(x[i*2-1]) and $F0)=$30 then
      inc(byte(Result[i]),(byte(x[i*2-1]) and $0F) shl 4)
    else
      inc(byte(Result[i]),((byte(x[i*2-1]) and $1F)+9) shl 4);
    if (byte(x[i*2]) and $F0)=$30 then
      inc(byte(Result[i]),byte(x[i*2]) and $0F)
    else
      inc(byte(Result[i]),(byte(x[i*2]) and $1F)+9);
   end;
end;

function HMAC(HashFn: THashFunction; BlockSize: integer;
  const Key, Msg: UTF8String): UTF8String;
var
  k,h1,h2:UTF8String;
  i:integer;
begin
  //assert BlockSize=Length(HashFn('')) div 2
  if Length(Key)>BlockSize then k:=HashFn(Key) else
   begin
    k:=Key;
    i:=Length(k);
    SetLength(k,BlockSize);
    while (i<BlockSize) do
     begin
      inc(i);
      k[i]:=#0;
     end;
   end;
  SetLength(h1,BlockSize);
  SetLength(h2,BlockSize);
  //TODO: speed-up by doing 32 bits at a time
  for i:=1 to BlockSize do byte(h1[i]):=byte(k[i]) xor $5C;
  for i:=1 to BlockSize do byte(h2[i]):=byte(k[i]) xor $36;
  Result:=HashFn(h1+HashFn(h2+Msg));
end;

{
//example PRF's:

function HMAC_SHA256(const Key,Msg:UTF8String):UTF8String;
begin
  Result:=HMAC(SHA256Hash,64,Key,Msg);
end;

function HMAC_SHA1(const Key,Msg:UTF8String):UTF8String;
begin
  Result:=HMAC(SHA1Hash,64,Key,Msg);
end;
}

function PBKDF2(PRF:TPseudoRandomFunction;HashLength:cardinal;
  const Password,Salt:UTF8String;Iterations,KeyLength:cardinal):UTF8String;
var
  i,j,k,c,l:cardinal;
  x,y:UTF8String;
begin
  //assert HashLength:=Length(PRF('','')) div 2
  l:=KeyLength div HashLength;
  if (KeyLength mod HashLength)<>0 then inc(l);
  SetLength(Result,l*HashLength);
  i:=0;
  j:=0;
  while (i<KeyLength) do
   begin
    inc(j);
    x:=PRF(Password,Salt+UTF8String(
      AnsiChar(j shr 24)+AnsiChar((j shr 16) and $FF)+
      AnsiChar((j shr 8) and $FF)+AnsiChar(j and $FF)));
    y:=x;
    c:=Iterations-1;
    while c<>0 do
     begin
      x:=PRF(Password,x);
      for k:=1 to Length(x) do
        byte(y[k]):=byte(y[k]) xor byte(x[k]);
      dec(c);
     end;
    for k:=1 to HashLength do
     begin
      inc(i);
      Result[i]:=y[k];
     end;
   end;
  SetLength(Result,KeyLength);
end;

const
  Base32Codes:array[0..31] of AnsiChar=
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

function Base32Encode(const x:UTF8String):UTF8String;
var
  i,j,l:cardinal;
begin
  l:=Length(x);
  i:=(l div 5);
  if (l mod 5)<>0 then inc(i);
  SetLength(Result,i*8);
  i:=1;
  j:=0;
  while (i+4<=l) do
   begin
    inc(j);Result[j]:=Base32Codes[  byte(x[i  ]) shr 3];
    inc(j);Result[j]:=Base32Codes[((byte(x[i  ]) and $07) shl 2)
                                or (byte(x[i+1]) shr 6)];
    inc(j);Result[j]:=Base32Codes[ (byte(x[i+1]) and $3E) shr 1];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+1]) and $01) shl 4)
                                or (byte(x[i+2]) shr 4)];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+2]) and $0F) shl 1)
                                or (byte(x[i+3]) shr 7)];
    inc(j);Result[j]:=Base32Codes[ (byte(x[i+3]) and $7C) shr 2];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+3]) and $03) shl 3)
                                or (byte(x[i+4]) shr 5)];
    inc(j);Result[j]:=Base32Codes[  byte(x[i+4]) and $1F];
    inc(i,5);
   end;
  case l-i of
  0:
   begin
    inc(j);Result[j]:=Base32Codes[  byte(x[i  ]) shr 3];
    inc(j);Result[j]:=Base32Codes[((byte(x[i  ]) and $07) shl 2)];
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
   end;
  1:
   begin
    inc(j);Result[j]:=Base32Codes[  byte(x[i  ]) shr 3];
    inc(j);Result[j]:=Base32Codes[((byte(x[i  ]) and $07) shl 2)
                                or (byte(x[i+1]) shr 6)];
    inc(j);Result[j]:=Base32Codes[ (byte(x[i+1]) and $3E) shr 1];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+1]) and $01) shl 4)];
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
   end;
  2:
   begin
    inc(j);Result[j]:=Base32Codes[  byte(x[i  ]) shr 3];
    inc(j);Result[j]:=Base32Codes[((byte(x[i  ]) and $07) shl 2)
                                or (byte(x[i+1]) shr 6)];
    inc(j);Result[j]:=Base32Codes[ (byte(x[i+1]) and $3E) shr 1];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+1]) and $01) shl 4)
                                or (byte(x[i+2]) shr 4)];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+2]) and $0F) shl 1)];
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
   end;
  3:
   begin
    inc(j);Result[j]:=Base32Codes[  byte(x[i  ]) shr 3];
    inc(j);Result[j]:=Base32Codes[((byte(x[i  ]) and $07) shl 2)
                                or (byte(x[i+1]) shr 6)];
    inc(j);Result[j]:=Base32Codes[ (byte(x[i+1]) and $3E) shr 1];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+1]) and $01) shl 4)
                                or (byte(x[i+2]) shr 4)];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+2]) and $0F) shl 1)
                                or (byte(x[i+3]) shr 7)];
    inc(j);Result[j]:=Base32Codes[ (byte(x[i+3]) and $7C) shr 2];
    inc(j);Result[j]:=Base32Codes[((byte(x[i+3]) and $03) shl 3)];
    inc(j);Result[j]:='=';
   end;
  end;
end;

function Base32Decode(const x:UTF8String):UTF8String;
var
  i,j,k,l,n:cardinal;
  a:array[0..7] of byte;
begin
  l:=Length(x);
  if l<8 then Result:='' else
   begin
    k:=(Length(x) div 8)*5;
    SetLength(Result,k);
    if x[l  ]='=' then dec(k);
    if x[l-2]='=' then dec(k);
    if x[l-3]='=' then dec(k);
    if x[l-5]='=' then dec(k);
    i:=0;
    j:=0;
    while i<l do
     begin
      for n:=0 to 7 do
       begin
        inc(i);a[n]:=0;while (a[n]<32) and (x[i]<>Base32Codes[a[n]]) do inc(a[n]);
       end;
      if i=l then
        for n:=1 to 7 do
          if a[n]=32 then a[n]:=0;
      inc(j);Result[j]:=AnsiChar((a[0] shl 3) or (a[1] shr 2));
      inc(j);Result[j]:=AnsiChar((a[1] shl 6) or (a[2] shl 1) or (a[3] shr 4));
      inc(j);Result[j]:=AnsiChar((a[3] shl 4) or (a[4] shr 1));
      inc(j);Result[j]:=AnsiChar((a[4] shl 7) or (a[5] shl 2) or (a[6] shr 3));
      inc(j);Result[j]:=AnsiChar((a[6] shl 5) or (a[7]      ));
     end;
    SetLength(Result,k);
   end;
end;

const
  Base64Codes:array[0..63] of AnsiChar=
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function Base64Encode(const x:UTF8String):UTF8String;
var
  i,j,l:cardinal;
begin
  l:=Length(x);
  i:=(l div 3);
  if (l mod 3)<>0 then inc(i);
  SetLength(Result,i*4);
  i:=1;
  j:=0;
  while (i+2<=l) do
   begin
    inc(j);Result[j]:=Base64Codes[  byte(x[i  ]) shr 2];
    inc(j);Result[j]:=Base64Codes[((byte(x[i  ]) and $03) shl 4)
                                or (byte(x[i+1]) shr 4)];
    inc(j);Result[j]:=Base64Codes[((byte(x[i+1]) and $0F) shl 2)
                                or (byte(x[i+2]) shr 6)];
    inc(j);Result[j]:=Base64Codes[  byte(x[i+2]) and $3F];
    inc(i,3);
   end;
  if i=l then
   begin
    inc(j);Result[j]:=Base64Codes[  byte(x[i  ]) shr 2];
    inc(j);Result[j]:=Base64Codes[((byte(x[i  ]) and $03) shl 4)];
    inc(j);Result[j]:='=';
    inc(j);Result[j]:='=';
   end
  else if i+1=l then
   begin
    inc(j);Result[j]:=Base64Codes[  byte(x[i  ]) shr 2];
    inc(j);Result[j]:=Base64Codes[((byte(x[i  ]) and $03) shl 4)
                                or (byte(x[i+1]) shr 4)];
    inc(j);Result[j]:=Base64Codes[((byte(x[i+1]) and $0F) shl 2)];
    inc(j);Result[j]:='=';
   end;
end;

function Base64Decode(const x:UTF8String):UTF8String;
var
  i,j,k,l:cardinal;
  a,b,c,d:byte;
begin
  l:=Length(x);
  if l<4 then Result:='' else
   begin
    k:=(Length(x) div 4)*3;
    SetLength(Result,k);
    if x[l  ]='=' then dec(k);
    if x[l-1]='=' then dec(k);
    i:=0;
    j:=0;
    while i<l do
     begin
      inc(i);a:=0;while (a<64) and (x[i]<>Base64Codes[a]) do inc(a);
      inc(i);b:=0;while (b<64) and (x[i]<>Base64Codes[b]) do inc(b);
      inc(i);c:=0;while (c<64) and (x[i]<>Base64Codes[c]) do inc(c);
      inc(i);d:=0;while (d<64) and (x[i]<>Base64Codes[d]) do inc(d);
      if i=l then
       begin
        if c=64 then c:=0;
        if d=64 then d:=0;
       end;
      inc(j);Result[j]:=AnsiChar((a shl 2) or (b shr 4));
      inc(j);Result[j]:=AnsiChar((b shl 4) or (c shr 2));
      inc(j);Result[j]:=AnsiChar((c shl 6) or (d      ));
     end;
    SetLength(Result,k);
   end;
end;

end.
