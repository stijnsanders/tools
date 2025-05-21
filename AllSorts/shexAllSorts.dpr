library shexAllSorts;

{$R 'shexAllS_Icon.res' 'shexAllS_Icon.rc'}

uses
  ComServ,
  shexAllSorts1 in 'shexAllSorts1.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.res}

begin
end.
