unit oSets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit, ExtCtrls, ComCtrls;

type
  TwinSettings = class(TForm)
    btnOk: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    btnCreateDataLink: TButton;
    Label2: TLabel;
    txtTable: TEdit;
    cbUser: TCheckBox;
    cbComp: TCheckBox;
    cbDomain: TCheckBox;
    Label4: TLabel;
    ValueListEditor1: TValueListEditor;
    Label3: TLabel;
    txtNiceDateTime: TEdit;
    cbCountControl: TCheckBox;
    cbCountDeletes: TComboBox;
    Label1: TLabel;
    cbCountArrows: TCheckBox;
    procedure btnCreateDataLinkClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
  end;

var
  winSettings: TwinSettings;

implementation

uses oMain, Clipbrd, ShellAPI, SQLiteData;

{$R *.dfm}

procedure TwinSettings.btnCreateDataLinkClick(Sender: TObject);
var
  fn,vn,s:string;
  i:integer;
  db:TSQLiteConnection;
begin
  fn:=Application.ExeName;
  fn:=copy(fn,1,length(fn)-4)+'.db';
  if FileExists(fn) then
   begin
    if not(Application.MessageBox(PChar('A local "'+fn+'" already exists, replace?'),'odo DataLink',MB_OKCANCEL or MB_ICONEXCLAMATION)=idOk) then
      exit;
    //close current connection!
    winMain.CloseDataLink;
    DeleteFile(fn);
   end;

  Screen.Cursor:=crHourGlass;
  try
    if txtTable.Text='' then txtTable.Text:='odo1';
    s:='CREATE TABLE ['+txtTable.Text+']'#13#10+
      '([TimeStamp] bigint not null'#13#10+
      ',[MouseX] int not null'#13#10+
      ',[MouseY] int not null'#13#10+
      ',[Clicks] int not null'#13#10+
      ',[Switches] int not null'#13#10+
      ',[Apps] int not null'#13#10+
      ',[Keystrokes] int not null'#13#10;
    if cbUser.Checked then s:=s+',[UserName] varchar(50) not null'#13#10;
    if cbComp.Checked then s:=s+',[ComputerName] varchar(50) not null'#13#10;
    if cbDomain.Checked then s:=s+',[DomainName] varchar(50) not null'#13#10;
    for i:=0 to ValueListEditor1.Strings.Count-1 do
     begin
      vn:=ValueListEditor1.Strings.Names[i];
      if vn<>'' then s:=s+',['+vn+'] varchar(50) not null'#13#10;
     end;
    s:=s+')';
    db:=TSQLiteConnection.Create(UTF8Encode(fn));
    try
      db.Execute(UTF8Encode(s));
    finally
      db.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  Application.MessageBox(PChar('"'+fn+'" created.'),'odo DataLink',MB_OK or MB_ICONINFORMATION);
  //winMain.OpenDataLink;
  //refresh the display?
end;

procedure TwinSettings.Image1Click(Sender: TObject);
begin
  Clipboard.AsText:='18v4XXjmWu2zV2E3zQnEP6aXAEvopq3gGb';
  MessageBox(Handle,'Bitcoun address copied to clipboard','odo: bitcoin accepted',MB_OK or MB_ICONINFORMATION);
end;

procedure TwinSettings.Label6Click(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow,nil,'http://yoy.bo/odo',nil,nil,SW_NORMAL);
end;

end.
