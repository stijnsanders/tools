{

  des
  by Stijn Sanders
  http://yoy.be/md5
  2016
  v1.0.0

  based on http://csrc.nist.gov/publications/fips/archive/fips46-3/fips46-3.pdf

  License: no license, free for any use

}
unit des;

interface

type
  DESBlock=array[0..7] of byte;//64 bit

function DESEncrypt(Input,Key:DESBlock):DESBlock;
function DESDecrypt(Input,Key:DESBlock):DESBlock;
function TripleDESEncrypt(Input,Key1,Key2,Key3:DESBlock):DESBlock;
function TripleDESDecrypt(Input,Key1,Key2,Key3:DESBlock):DESBlock;

implementation

{$D-}
{$L-}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}

function DESCrypt(Input,Key:DESBlock;KeyRev:byte):DESBlock;
const
  B0:DESBlock=(0,0,0,0,0,0,0,0);
  Perm1:array[0..7*8-1] of byte=(
    63,55,47,39,31,23,15,
    07,62,54,46,38,30,22,
    14,06,61,53,45,37,29,
    21,13,05,60,52,44,36,
    57,49,41,33,25,17,09,
    01,58,50,42,34,26,18,
    10,02,59,51,43,35,27,
    19,11,03,28,20,12,04);
  RotX=$8103;
  Perm2:array[0..6*8-1] of byte=(
    08,20,11,28,06,02,
    04,24,22,01,16,12,
    29,18,10,03,26,14,
    21,00,25,17,09,05,
    41,60,36,45,50,57,
    37,42,61,52,34,49,
    53,48,43,56,33,59,
    51,40,62,46,38,35);
  InitPerm:array[0..8*8-1] of byte=(
    62,54,46,38,30,22,14,06,
    60,52,44,36,28,20,12,04,
    58,50,42,34,26,18,10,02,
    56,48,40,32,24,16,08,00,
    63,55,47,39,31,23,15,07,
    61,53,45,37,29,21,13,05,
    59,51,43,35,27,19,11,03,
    57,49,41,33,25,17,09,01);
  EBitX:array[0..6*8-1] of byte=(
    56,39,38,37,36,35,
    36,35,34,33,32,47,
    32,47,46,45,44,43,
    44,43,42,41,40,55,
    40,55,54,53,52,51,
    52,51,50,49,48,63,
    48,63,62,61,60,59,
    60,59,58,57,56,39);
  Perm3:array[0..4*8-1] of byte=(
    12,05,16,23,
    31,08,24,19,
    03,13,21,26,
    07,18,29,10,
    02,04,20,14,
    28,25,01,11,
    17,15,30,06,
    22,09,00,27);
  SBox:array[0..7,0..8*8-1] of byte=(
    (14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7,
      0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8,
      4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0,
     15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13),
    (15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10,
      3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5,
      0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15,
     13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9),
    (10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8,
     13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1,
     13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7,
      1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12),
    ( 7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15,
     13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9,
     10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4,
      3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14),
    ( 2,12, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9,
     14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6,
      4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14,
     11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3),
    (12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11,
     10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8,
      9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6,
      4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13),
    ( 4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1,
     13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6,
      1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2,
      6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12),
    (13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7,
      1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2,
      7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8,
      2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6,11));
  FinalPerm:array[0..8*8-1] of byte=(
    00,32,08,40,16,48,24,56,
    01,33,09,41,17,49,25,57,
    02,34,10,42,18,50,26,58,
    03,35,11,43,19,51,27,59,
    04,36,12,44,20,52,28,60,
    05,37,13,45,21,53,29,61,
    06,38,14,46,22,54,30,62,
    07,39,15,47,23,55,31,63);
var
  k,l,m,n:DESBlock;
  ii,i,j,p:integer;
  kk:array[0..15] of DESBlock;
begin
  k:=b0;
  for i:=0 to 7 do
    for j:=0 to 6 do
     begin
      p:=Perm1[i*7+j];
      k[i]:=k[i] or (((Key[p shr 3] shr (p and 7)) and 1) shl (6-j));
     end;

  for ii:=0 to 15 do
   begin
    if ((RotX shr ii) and 1)=0 then
     begin
      p:=k[0] shr 5;
      k[0]:=((k[0] shl 2) and $7F) or (k[1] shr 5);
      k[1]:=((k[1] shl 2) and $7F) or (k[2] shr 5);
      k[2]:=((k[2] shl 2) and $7F) or (k[3] shr 5);
      k[3]:=((k[3] shl 2) and $7F) or p;
      p:=k[4] shr 5;
      k[4]:=((k[4] shl 2) and $7F) or (k[5] shr 5);
      k[5]:=((k[5] shl 2) and $7F) or (k[6] shr 5);
      k[6]:=((k[6] shl 2) and $7F) or (k[7] shr 5);
      k[7]:=((k[7] shl 2) and $7F) or p;
     end
    else
     begin
      p:=k[0] shr 6;
      k[0]:=((k[0] shl 1) and $7F) or (k[1] shr 6);
      k[1]:=((k[1] shl 1) and $7F) or (k[2] shr 6);
      k[2]:=((k[2] shl 1) and $7F) or (k[3] shr 6);
      k[3]:=((k[3] shl 1) and $7F) or p;
      p:=k[4] shr 6;
      k[4]:=((k[4] shl 1) and $7F) or (k[5] shr 6);
      k[5]:=((k[5] shl 1) and $7F) or (k[6] shr 6);
      k[6]:=((k[6] shl 1) and $7F) or (k[7] shr 6);
      k[7]:=((k[7] shl 1) and $7F) or p;
     end;

    l:=b0;
    for i:=0 to 7 do
      for j:=0 to 5 do
       begin
        p:=Perm2[i*6+j];
        l[i]:=l[i] or (((k[p shr 3] shr (p and 7)) and 1) shl (5-j));
       end;
    kk[ii]:=l;
   end;

  m:=b0;
  for i:=0 to 7 do
    for j:=0 to 7 do
     begin
      p:=InitPerm[i*8+j];
      m[i]:=m[i] or (((Input[p shr 3] shr (p and 7)) and 1) shl (7-j));
     end;

  for ii:=0 to 15 do
   begin
    l:=kk[ii xor KeyRev];
    for i:=0 to 7 do
      for j:=0 to 5 do
       begin
        p:=EBitX[i*6+j];
        l[i]:=l[i] xor (((m[p shr 3] shr (p and 7)) and 1) shl (5-j));
       end;
    for i:=0 to 7 do
      n[i]:=SBox[i,(l[i] and $20) or ((l[i] and 1) shl 4)
        or (l[i] shr 1) and $F];

    for i:=0 to 3 do l[i]:=m[i];
    for i:=4 to 7 do
     begin
      l[i]:=0;
      for j:=0 to 7 do
       begin
        p:=Perm3[(i and 3)*8+j];
        l[i]:=l[i] or (((n[p shr 2] shr (p and 3)) and 1) shl (7-j));
       end;
     end;

    for i:=0 to 3 do m[i]:=m[i+4];
    for i:=4 to 7 do m[i]:=l[i-4] xor l[i];
   end;

  n:=b0;
  for i:=0 to 7 do
    for j:=0 to 7 do
     begin
      p:=FinalPerm[i*8+j];
      n[i]:=n[i] or (((m[p shr 3] shr (p and 7)) and 1) shl (7-j));
     end;
     
  Result:=n;
end;

function DESEncrypt(Input,Key:DESBlock):DESBlock;
begin
  Result:=DESCrypt(Input,Key,$0);
end;

function DESDecrypt(Input,Key:DESBlock):DESBlock;
begin
  Result:=DESCrypt(Input,Key,$f);
end;

function TripleDESEncrypt(Input,Key1,Key2,Key3:DESBlock):DESBlock;
begin
  Result:=DESEncrypt(DESDecrypt(DESEncrypt(Input,Key1),Key2),Key3);
end;

function TripleDESDecrypt(Input,Key1,Key2,Key3:DESBlock):DESBlock;
begin
  Result:=DESDecrypt(DESEncrypt(DESDecrypt(Input,Key3),Key2),Key1);
end;

end.
