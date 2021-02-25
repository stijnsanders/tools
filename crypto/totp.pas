{

  TOTP
  by Stijn Sanders
  http://yoy.be/md5
  2021
  v1.0.0

  based on
  https://tools.ietf.org/html/rfc4226
  https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2

  License: no license, free for any use

}
unit totp;

interface

function UtcNow:TDateTime;
function GenerateTOTP(const secret:UTF8String;
  seconds:word=30;digits:byte=6):integer;

implementation

uses SysUtils, Windows, HashUtils, sha1;

function UtcNow:TDateTime;
var
  st:TSystemTime;
  tz:TTimeZoneInformation;
  tx:cardinal;
  bias:TDateTime;
begin
  GetLocalTime(st);
  tx:=GetTimeZoneInformation(tz);
  case tx of
    //TIME_ZONE_ID_INVALID:RaiseLastOSError;
    TIME_ZONE_ID_UNKNOWN:  bias:=tz.Bias/1440.0;
    TIME_ZONE_ID_STANDARD: bias:=(tz.Bias+tz.StandardBias)/1440.0;
    TIME_ZONE_ID_DAYLIGHT: bias:=(tz.Bias+tz.DaylightBias)/1440.0;
    else bias:=0.0;
  end;
  Result:=
    EncodeDate(st.wYear,st.wMonth,st.wDay)+
    EncodeTime(st.wHour,st.wMinute,st.wSecond,st.wMilliseconds)+
    bias;
end;

{
function BuildTOTP_URL(const name,secret:UTF8String):UTF8String;
begin
  Result:='otpauth://totp/'+URLEncode(name)+'?secret='+URLEncode(secret);
end;
}

function GenerateTOTP(const secret:UTF8String;seconds:word;digits:byte):integer;
var
  cc:int64;
  i,k,m,n:integer;
  c,h:UTF8String;
begin
  //assert secret already Base32Decode'd
  cc:=Trunc((UtcNow-UnixDateDelta)*(SecsPerDay/seconds));
  SetLength(c,8);
  i:=8;
  while i<>0 do
   begin
    byte(c[i]):=cc and $FF;
    cc:=cc shr 8;
    dec(i);
   end;
  h:=HMAC(SHA1Hash,64,secret,c);
  n:=byte(h[20]) and $F;
  k:= ((byte(h[n+1]) and $7f) shl 24)
    or (byte(h[n+2]) shl 16)
    or (byte(h[n+3]) shl 8)
    or (byte(h[n+4]));
  m:=1000000;
  for i:=6 to digits-1 do m:=m*10;
  Result:=k mod m;
end;

end.
