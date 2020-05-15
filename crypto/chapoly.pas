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
  TChaChaMatrix=array[0..15] of cardinal;

function ChaCha20(block:cardinal;nonce:TChaChaNonce;key:TChaChaKey):TChaChaMatrix;


implementation

function ChaCha20(block:cardinal;nonce:TChaChaNonce;key:TChaChaKey):TChaChaMatrix;
var
  s:TChaChaMatrix;
  r:cardinal;
  procedure ChaChaQuarterRound(a,b,c,d:byte);
  var
    e:cardinal;
  begin
    inc(s[a],s[b]);
    e:=s[d] xor s[a];
    s[d]:=(e shl 16) or (e shr 16);

    inc(s[c],s[d]);
    e:=s[b] xor s[c];
    s[b]:=(e shl 12) or (e shr 20);

    inc(s[a],s[b]);
    e:=s[d] xor s[a];
    s[d]:=(e shl 8) or (e shr 24);

    inc(s[c],s[d]);
    e:=s[b] xor s[c];
    s[b]:=(e shl 7) or (e shr 25);
  end;
begin
  s[ 0]:=$61707865;  s[ 1]:=$3320646e;  s[ 2]:=$79622d32;  s[ 3]:=$6b206574;
  s[ 4]:=key[0];     s[ 5]:=key[1];     s[ 6]:=key[2];     s[ 7]:=key[3];
  s[ 8]:=key[4];     s[ 9]:=key[5];     s[10]:=key[6];     s[11]:=key[7];
  s[12]:=block;      s[13]:=nonce[0];   s[14]:=nonce[1];   s[15]:=nonce[2];

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

  inc(s[ 0],$61707865); inc(s[ 1],$3320646e); inc(s[ 2],$79622d32); inc(s[ 3],$6b206574);
  inc(s[ 4],key[0]);    inc(s[ 5],key[1]);    inc(s[ 6],key[2]);    inc(s[ 7],key[3]);
  inc(s[ 8],key[4]);    inc(s[ 9],key[5]);    inc(s[10],key[6]);    inc(s[11],key[7]);
  inc(s[12],block);     inc(s[13],nonce[0]);  inc(s[14],nonce[1]);  inc(s[15],nonce[2]);

  Result:=s;

  //10f1e7e4 d13b5915 500fdd1f a32071c4
  //c7d1f4c7 33c06803 0422aa9a c3d46c4e
  //d2826446 079faa09 14c2d705 d98b02a2
  //b5129cd1 de164eb9 cbd083e8 a2503c4e
end;

end.
