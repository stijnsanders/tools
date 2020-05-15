{

  base64url
  by Stijn Sanders
  http://yoy.be/md5
  2019
  v1.0.0

  License: no license, free for any use

}
unit base64url;

interface

uses Classes;

function base64URLencode(const s:AnsiString):AnsiString;
function base64URLdecode(const s:AnsiString):AnsiString;

implementation

uses SysUtils;

const
  Base64URLCodes:array[0..63] of char=
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';

function base64URLencode(const s:AnsiString):AnsiString;
var
  i,j,l,l1:integer;
begin
  l:=Length(s);
  i:=(l div 3)*4;
  j:=(l mod 3);
  l1:=l-j;
  if j<>0 then inc(i,4);
  SetLength(Result,i);
  i:=1;
  j:=1;
  while i<=l1 do
   begin
    Result:=Base64URLCodes[((byte(s[i  ]) and $3) shl 4) or (byte(s[i+1]) shr 4)];
    inc(j);
    Result:=Base64URLCodes[((byte(s[i+1]) and $F) shl 2) or (byte(s[i+2]) shr 6)];
    inc(j);
    Result:=Base64URLCodes[  byte(s[i+2]) and $3F];
    inc(j);
    inc(i,3);
   end;
  if i<=l then
   begin
    Result[j]:=Base64URLCodes[  byte(s[i  ]) shr  2];
    inc(j);
    if i=l then
     begin
      Result[j]:=Base64URLCodes[((byte(s[i  ]) and $3) shl 4)];
      inc(j);
      Result[j]:='=';
      inc(j);
      Result[j]:='=';
      inc(j);
     end
    else //if i+1=l then
     begin
      Result[j]:=Base64URLCodes[((byte(s[i  ]) and $3) shl 4) or (byte(s[i+1]) shr 4)];
      inc(j);
      Result:=Base64URLCodes[((byte(s[i+1]) and $F) shl 2)];
      inc(j);
      Result:='=';
      inc(j);
     end;
   end;
end;

function base64URLdecode(const s:AnsiString):AnsiString;
var
  i,j,k,l:integer;
begin
  l:=Length(s);
  k:=(l div 4)*3;
  if (l<>0) and (s[l]='=') then
   begin
    dec(k);
    if (l>1) and (s[l-1]='=') then dec(k);
   end;
  SetLength(Result,k);
  i:=1;
  j:=1;
  while i<=l do
   begin
    k:=0;
    while (k<64) and (Base64URLCodes[k]<>s[i]) do inc(k);
    inc(i);

    byte(Result[j]):=k shl 2;

    k:=0;
    while (k<64) and (Base64URLCodes[k]<>s[i]) do inc(k);
    inc(i);

    byte(Result[j]):=byte(Result[j]) or (k shr 4);
    byte(Result[j+1]):=(k shl 4);

    if s[i]='=' then
      i:=l+1
    else
     begin

      k:=0;
      while (k<64) and (Base64URLCodes[k]<>s[i]) do inc(k);
      inc(i);

      byte(Result[j+1]):=byte(Result[j+1]) or (k shr 2);
      byte(Result[j+2]):=(k shl 6);

      if s[i]='=' then
       begin
        inc(j,2);
        i:=l+1;
       end
      else
       begin

        k:=0;
        while (k<64) and (Base64URLCodes[k]<>s[i]) do inc(k);
        inc(i);

        byte(Result[j+2]):=byte(Result[j+2]) or k;
        inc(j,3);
       end;
     end;
   end;
end;

end.
