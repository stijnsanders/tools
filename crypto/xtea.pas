{

  xtea
  by Stijn Sanders
  http://yoy.be/md5
  2017
  v1.0.0

  License: no license, free for any use

}
unit xtea;

interface

type
  TTEAKey=array[0..3] of cardinal;
  TXXTEAData=array[0..0] of cardinal;
  PXXTEAData=^TXXTEAData;

procedure TEA_encrypt(var v0,v1:cardinal;const k:TTEAKey);
procedure TEA_decrypt(var v0,v1:cardinal;const k:TTEAKey);

//  https://en.wikipedia.org/wiki/XTEA
procedure XTEA_encipher(num_rounds:cardinal;var v0,v1:cardinal;const k:TTEAKey);
procedure XTEA_decipher(num_rounds:cardinal;var v0,v1:cardinal;const k:TTEAKey);

//  https://en.wikipedia.org/wiki/XXTEA
function BTEA(v:PXXTEAData;n:integer;const k:TTEAKey):boolean;

implementation

procedure TEA_encrypt(var v0,v1:cardinal;const k:TTEAKey);
var
  sum,i:cardinal;
begin
  sum:=0;
  for i:=0 to 31 do
   begin
    inc(sum,$9e3779b9);
    inc(v0,((v1 shl 4)+k[0]) xor (v1+sum) xor ((v1 shr 5)+k[1]));
    inc(v1,((v0 shl 4)+k[2]) xor (v0+sum) xor ((v0 shr 5)+k[3]));
   end;
end;

procedure TEA_decrypt(var v0,v1:cardinal;const k:TTEAKey);
var
  sum,i:cardinal;
begin
  sum:=$c6ef3720;
  for i:=0 to 31 do
   begin
    dec(v1,((v0 shl 4)+k[2]) xor (v0+sum) xor ((v0 shr 5)+k[3]));
    dec(v0,((v1 shl 4)+k[0]) xor (v1+sum) xor ((v1 shr 5)+k[1]));
    dec(sum,$9e3779b9);
   end;
end;

procedure XTEA_encipher(num_rounds:cardinal;var v0,v1:cardinal;const k:TTEAKey);
var
  sum,i:cardinal;
begin
  sum:=0;
  for i:=0 to num_rounds-1 do
   begin
    inc(v0,(((v1 shl 4) xor (v1 shr 5))+v1) xor (sum+k[sum and 3]));
    inc(sum,$9E3779B9);
    inc(v1,(((v0 shl 4) xor (v0 shr 5))+v0) xor (sum+k[(sum shr 11) and 3]));
   end;
end;

procedure XTEA_decipher(num_rounds:cardinal;var v0,v1:cardinal;const k:TTEAKey);
var
  sum,i:cardinal;
begin
  sum:=$9E3779B9*num_rounds;
  for i:=0 to num_rounds-1 do
   begin
    dec(v1,(((v0 shl 4) xor (v0 shr 5))+v0) xor (sum+k[(sum shr 11) and 3]));
    dec(sum,$9E3779B9);
    dec(v0,(((v1 shl 4) xor (v1 shr 5))+v1) xor (sum+k[sum and 3]));
   end;
end;

function BTEA(v:PXXTEAData;n:integer;const k:TTEAKey):boolean;
const
  delta=$9e3779b9;
var
  z,y,sum,e,p,q:cardinal;
  function MX:cardinal;
  begin
    Result:=(((z shr 5) xor (y shr 2))+((y shr 3) xor (z shl 4)) xor (sum xor y)+(k[(p and 3) xor e] xor z));
  end;
begin
  if n>1 then //coding part
   begin
    q:=(6+52 div n);
    if q<>0 then dec(q);
    while q<>0 do
     begin
      inc(sum,delta);
      e:=(sum shr 2) and 3;
      for p:=0 to n-2 do
       begin
        y:=v[p+1];
        inc(v[p],MX);
        z:=v[p];
       end;
      y:=v[0];
      inc(v[n-1],MX);
      z:=v[n-1];
      dec(q);
     end;
    Result:=true;
   end
  else
  if n<-1 then //decoding part
   begin
    n:=-n;
    q:=6+52 div n;
    sum:=q*delta;
    while sum<>0 do
     begin
      e:=(sum shr 2) and 3;
      for p:=n-1 downto 1 do
       begin
        z:=v[p-1];
        dec(v[p],MX);
        y:=v[p];
       end;
      z:=v[n-1];
      dec(v[0],MX);
      y:=v[0];
     end;
    Result:=true;
   end
  else
    Result:=false;//raise?
end;

end.
