unit base64;

interface

uses Classes;

function base64encode(f:TStream):string;
procedure base64decode(const s:string;f:TStream);

implementation

uses SysUtils;

const
  Base64Codes:array[0..63] of char=
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function base64encode(f:TStream):string;
const
  dSize=57*100;//must be multiple of 3
var
  d:array[0..dSize-1] of byte;
  i,l:integer;
begin
  Result:='';
  l:=dSize;
  while l=dSize do
   begin
    l:=f.Read(d[0],dSize);
    i:=0;
    while i<l do
     begin
      if i+1=l then
        Result:=Result+
          Base64Codes[  d[i  ] shr  2]+
          Base64Codes[((d[i  ] and $3) shl 4)]+
          '=='
      else if i+2=l then
        Result:=Result+
          Base64Codes[  d[i  ] shr  2]+
          Base64Codes[((d[i  ] and $3) shl 4) or (d[i+1] shr 4)]+
          Base64Codes[((d[i+1] and $F) shl 2)]+
          '='
      else
        Result:=Result+
          Base64Codes[  d[i  ] shr  2]+
          Base64Codes[((d[i  ] and $3) shl 4) or (d[i+1] shr 4)]+
          Base64Codes[((d[i+1] and $F) shl 2) or (d[i+2] shr 6)]+
          Base64Codes[  d[i+2] and $3F];
      inc(i,3);
      if ((i mod 57)=0) then Result:=Result+#13#10;
     end;
   end;
end;

procedure base64decode(const s:string;f:TStream);
const
  dSize=57*100;//must be multiple of 3
var
  d:array[0..dSize-1] of byte;
  i,j,k,l:integer;
begin
  l:=Length(s);
  i:=1;
  j:=0;
  while i<=l do
   begin
    while (i<=l) and (s[i]<=' ') do inc(i);

    k:=0;
    while (k<64) and (Base64Codes[k]<>s[i]) do inc(k);
    inc(i);

    d[j]:=k shl 2;

    k:=0;
    while (k<64) and (Base64Codes[k]<>s[i]) do inc(k);
    inc(i);

    d[j]:=d[j] or (k shr 4);
    d[j+1]:=(k shl 4);

    if s[i]='=' then
     begin
      inc(j);
      i:=l+1;
     end
    else
     begin

      k:=0;
      while (k<64) and (Base64Codes[k]<>s[i]) do inc(k);
      inc(i);

      d[j+1]:=d[j+1] or (k shr 2);
      d[j+2]:=(k shl 6);

      if s[i]='=' then
       begin
        inc(j,2);
        i:=l+1;
       end
      else
       begin

        k:=0;
        while (k<64) and (Base64Codes[k]<>s[i]) do inc(k);
        inc(i);

        d[j+2]:=d[j+2] or k;
        inc(j,3);
       end;
     end;
    if j=dSize then
     begin
      if f.Write(d[0],dSize)<>dSize then RaiseLastOSError;
      j:=0;
     end;
   end;
  if j<>0 then
    if f.Write(d[0],j)<>j then RaiseLastOSError;
end;

end.
