{

  sha3
  by Stijn Sanders
  http://yoy.be/md5
  2016
  v1.0.0

  based on http://keccak.noekeon.org/

  License: no license, free for any use

}
unit sha3;

interface

function Keccak(rateBytes,outputBytes:integer;suffix:byte;const data:UTF8String):UTF8String;
function SHAKE128(const x:UTF8String;outputSize:integer):UTF8String;
function SHAKE256(const x:UTF8String;outputSize:integer):UTF8String;
function SHA3_224(const x:UTF8String):UTF8String;
function SHA3_256(const x:UTF8String):UTF8String;
function SHA3_384(const x:UTF8String):UTF8String;
function SHA3_512(const x:UTF8String):UTF8String;

type
  KeccakLane=int64;
  KeccakState=array[0..24] of KeccakLane;

procedure KeccakF1600_StatePermute(var state:KeccakState);

implementation

{$D-}
{$L-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

procedure KeccakF1600_StatePermute(var state:KeccakState);
var
  round,i,j,r,t:integer;
  l:byte;
  c:array[0..4] of KeccakLane;
  d:KeccakLane;
begin
  l:=1;
  for round:=0 to 23 do
   begin
    //theta
    for i:=0 to 4 do c[i]:=0;
    for i:=0 to 4 do for j:=0 to 4 do c[i]:=c[i] xor state[i+5*j];
    for i:=0 to 4 do
     begin
      d:=c[(i+1) mod 5];
      d:=c[(i+4) mod 5] xor ((d shl 1) or (d shr 63));
      for j:=0 to 4 do state[i+5*j]:=state[i+5*j] xor d;
     end;
    //ro pi
    i:=1;
    j:=0;
    d:=state[1];
    for t:=0 to 23 do
     begin
      r:=(2*i+3*j) mod 5;
      i:=j;
      j:=r;
      c[0]:=state[i+5*j];
      r:=((t+1)*(t+2) div 2) and $3F;
      state[i+5*j]:=(d shl r) or (d shr (64-r));
      d:=c[0];
     end;
    //chi
    for j:=0 to 4 do
     begin
      for i:=0 to 4 do
        c[i]:=state[i+5*j];
      for i:=0 to 4 do
        state[i+5*j]:=c[i] xor (not(c[(i+1) mod 5]) and c[(i+2) mod 5]);
     end;
    //iota
    for j:=0 to 6 do
     begin
      state[0]:=state[0] xor (int64(l and 1) shl ((1 shl j)-1));
      l:=(l shl 1) xor ($71*(l shr 7));
     end;
   end;
end;

function Keccak(rateBytes,outputBytes:integer;suffix:byte;const data:UTF8String):UTF8String;
type
  TArr8=array[0..7] of byte;
  PArr8=^TArr8;
  PByte1=^byte;
var
  state:KeccakState;
  i,j,l:integer;
  p:PByte1;
begin
  for i:=0 to 24 do state[i]:=0;
  i:=1;
  j:=0;
  l:=Length(data);
  //absorb
  while i<=l do
   begin
    p:=@PArr8(@state[j shr 3])[j and 7];
    p^:=p^ xor byte(data[i]);
    inc(i);
    inc(j);
    if j=rateBytes then
     begin
      j:=0;
      KeccakF1600_StatePermute(state);
     end;
   end;
  //padding
  p:=@PArr8(@state[j shr 3])[j and 7];
  p^:=p^ xor byte(suffix);
  if ((suffix and $80)<>0) and (j=rateBytes-1) then
    KeccakF1600_StatePermute(state);
  j:=rateBytes-1;
  p:=@PArr8(@state[j shr 3])[j and 7];
  p^:=p^ xor $80;
  //squeeze
  KeccakF1600_StatePermute(state);
  SetLength(Result,outputBytes);
  i:=1;
  j:=0;
  while (i<=outputBytes) do
   begin
    byte(Result[i]):=PArr8(@state[j shr 3])[j and 7];
    inc(i);
    inc(j);
    if j=rateBytes then
     begin
      j:=0;
      KeccakF1600_StatePermute(state);
     end;
   end;
end;

function SHAKE128(const x:UTF8String;outputSize:integer):UTF8String;
begin
  Result:=Keccak(168,outputSize,$1F,x);
end;

function SHAKE256(const x:UTF8String;outputSize:integer):UTF8String;
begin
  Result:=Keccak(136,outputSize,$1F,x);
end;

function SHA3_224(const x:UTF8String):UTF8String;
begin
  Result:=Keccak(144,28,$06,x);
end;

function SHA3_256(const x:UTF8String):UTF8String;
begin
  Result:=Keccak(136,32,$06,x);
end;

function SHA3_384(const x:UTF8String):UTF8String;
begin
  Result:=Keccak(104,48,$06,x);
end;

function SHA3_512(const x:UTF8String):UTF8String;
begin
  Result:=Keccak(72,64,$06,x);
end;

end.
