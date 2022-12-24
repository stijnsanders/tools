unit eszett1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls;

const
  WM_ESZETT = $0403;

type
  TfrmEszettMain = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Settings1: TMenuItem;
    Settings2: TMenuItem;
    Exit1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  private
    hookinfo:record
      wnd,hook1,hook2:cardinal;
    end;
  protected
    procedure DoCreate; override;
    procedure DoDestroy; override;
  public
    procedure WMEszett(var Msg: TMessage); message WM_ESZETT;
  end;

var
  frmEszettMain: TfrmEszettMain;

implementation

uses Registry;

{$R *.dfm}

procedure TfrmEszettMain.DoCreate;
var
  r:TRegistry;
  h:THandle;
  p:TProcedure;
begin
  inherited;
  //create hooks

  if CreateMutex(nil,false,'Global\eszett')=0 then
    RaiseLastOSError
  else
    if GetLastError=ERROR_ALREADY_EXISTS then
     begin
      PostQuitMessage(1);
      raise Exception.Create('Another instance of eszett.exe is already running.');
     end;

  r:=TRegistry.Create;
  try
    r.OpenKey('\Software\Double Sigma Programming\eszett',true);
    hookinfo.wnd:=0;
    hookinfo.hook1:=0;
    hookinfo.hook2:=0;
    r.WriteBinaryData('HookInfo',hookinfo,4*3);

    h:=LoadLibrary(PChar(ExtractFilePath(Application.ExeName)+'eszc.dll'));
    if h=0 then
     begin
      MessageBox(GetDesktopWindow,'Failed to load eszc.dll','eszc',MB_OK or MB_ICONERROR);
      PostQuitMessage(1);
      raise Exception.Create('Failed to load eszc.dll');
     end
    else
     begin
      @p:=GetProcAddress(h,'eszcLoad');
      hookinfo.wnd:=Handle;
      hookinfo.hook1:=SetWindowsHookEx(WH_KEYBOARD,GetProcAddress(h,'eszcKeybCB'),h,0);
      hookinfo.hook2:=0;//SetWindowsHookEx(WH_MOUSE,GetProcAddress(h,'eszcMouseCB'),h,0);

      r.WriteBinaryData('HookInfo',hookinfo,4*3);
     end;

  finally
    r.Free;
  end;

  p;//eszcLoad
end;

procedure TfrmEszettMain.DoDestroy;
begin
  inherited;
  UnhookWindowsHookEx(hookinfo.hook1);
  //UnhookWindowsHookEx(hookinfo.hook2);
end;

procedure TfrmEszettMain.Exit1Click(Sender: TObject);
begin
  if MessageBox(GetDesktopWindow,'Close "eszett"?','eszett',MB_ICONQUESTION or MB_OKCANCEL)=idOk then
   begin
    //Close;
    Application.Terminate;
   end;
end;

procedure TfrmEszettMain.Settings1Click(Sender: TObject);
begin
  MessageBox(GetDesktopWindow,'Sorry, no settings','eszett',MB_ICONINFORMATION or MB_OK);
end;

procedure TfrmEszettMain.WMEszett(var Msg: TMessage);
begin
  //
end;

end.
