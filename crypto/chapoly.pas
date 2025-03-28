{

  chapoly
  by Stijn Sanders
  http://yoy.be/md5
  2020
  v1.0.0

  based on https://tools.ietf.org/html/rfc8439

  License: no license, free for any use

}
unit chapoly;

interface

type
  TChaChaNonce=array[0..2] of cardinal;
  TChaChaKey=array[0..7] of cardinal;
  TChaChaMatrix_U32=array[0..15] of cardinal;
  TChaChaMatrix_U8 =array[0..63] of byte;

function ChaCha20_Block(key:TChaChaKey;nonce:TChaChaNonce;counter:cardinal):
  TChaChaMatrix_U32;
function ChaCha20_Encrypt(key:TChaChaKey;nonce:TChaChaNonce;counter:cardinal;
  const plaintext:UTF8String):UTF8String;

implementation

{$D-}
{$L-}
{$Q-}
{$R-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

function ChaCha20_Block(key:TChaChaKey;nonce:TChaChaNonce;counter:cardinal):
  TChaChaMatrix_U32;
var
  r:cardinal;
  procedure ChaChaQuarterRound(a,b,c,d:byte);
  var
    e:cardinal;
  begin
    inc(Result[a],Result[b]);
    e:=Result[d] xor Result[a];
    Result[d]:=(e shl 16) or (e shr 16);

    inc(Result[c],Result[d]);
    e:=Result[b] xor Result[c];
    Result[b]:=(e shl 12) or (e shr 20);

    inc(Result[a],Result[b]);
    e:=Result[d] xor Result[a];
    Result[d]:=(e shl 8) or (e shr 24);

    inc(Result[c],Result[d]);
    e:=Result[b] xor Result[c];
    Result[b]:=(e shl 7) or (e shr 25);
  end;
begin
  Result[ 0]:=$61707865;
  Result[ 1]:=$3320646e;
  Result[ 2]:=$79622d32;
  Result[ 3]:=$6b206574;
  Result[ 4]:=key[0];
  Result[ 5]:=key[1];
  Result[ 6]:=key[2];
  Result[ 7]:=key[3];
  Result[ 8]:=key[4];
  Result[ 9]:=key[5];
  Result[10]:=key[6];
  Result[11]:=key[7];
  Result[12]:=counter;
  Result[13]:=nonce[0];
  Result[14]:=nonce[1];
  Result[15]:=nonce[2];

  for r:=1 to 10 do
   begin
    ChaChaQuarterRound(0,4, 8,12);
    ChaChaQuarterRound(1,5, 9,13);
    ChaChaQuarterRound(2,6,10,14);
    ChaChaQuarterRound(3,7,11,15);
    ChaChaQuarterRound(0,5,10,15);
    ChaChaQuarterRound(1,6,11,12);
    ChaChaQuarterRound(2,7, 8,13);
    ChaChaQuarterRound(3,4, 9,14);
   end;

  inc(Result[ 0],$61707865);
  inc(Result[ 1],$3320646e);
  inc(Result[ 2],$79622d32);
  inc(Result[ 3],$6b206574);
  inc(Result[ 4],key[0]);
  inc(Result[ 5],key[1]);
  inc(Result[ 6],key[2]);
  inc(Result[ 7],key[3]);
  inc(Result[ 8],key[4]);
  inc(Result[ 9],key[5]);
  inc(Result[10],key[6]);
  inc(Result[11],key[7]);
  inc(Result[12],counter);
  inc(Result[13],nonce[0]);
  inc(Result[14],nonce[1]);
  inc(Result[15],nonce[2]);
end;

function ChaCha20_Encrypt(key:TChaChaKey;nonce:TChaChaNonce;counter:cardinal;
  const plaintext:UTF8String):UTF8String;
var
  i,j,k,l,n:integer;
  s:TChaChaMatrix_U32;
begin
  l:=Length(plaintext);
  SetLength(Result,l);
  n:=l shr 6;//n:=l div 64;
  if (l and $3F)<>0 then inc(n);//if (l mod 64)=0 then inc(n);
  j:=0;
  for i:=0 to n-1 do
   begin
    s:=ChaCha20_Block(key,nonce,counter);
    k:=0;
    while (k<64) and (j<l) do
     begin
      inc(j);
      byte(Result[j]):=byte(plaintext[j]) xor TChaChaMatrix_U8(s)[k];
      inc(k);
     end;
    inc(counter);
   end;
end;

end.
