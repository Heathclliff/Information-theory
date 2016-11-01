unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  TKeysVector = array[1..54]of word;
  TKeyBits = array[1..128]of byte;
  TMainForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    open: TMenuItem;
    Save: TMenuItem;
    exit: TMenuItem;
    firstfilememo: TMemo;
    firstfiletext: TLabel;
    lastFileMemo: TMemo;
    lastfiletext: TLabel;
    KeeText: TLabel;
    keyEdit: TEdit;
    Encrypt: TButton;
    Decryption: TButton;
    Step: TButton;
    procedure exitClick(Sender: TObject);
    procedure openClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure keyEditKeyPress(Sender: TObject; var Key: Char);
    procedure EncryptClick(Sender: TObject);
    procedure StepClick(Sender: TObject);
    procedure DecryptionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  str,firststr:ansistring;
  FName:string;
  KeyBits: TKeyBits;
  vector: TKeysVector;
  Key:string;
  Keys:array[1..6,1..8] of string[25];

implementation

{$R *.dfm}

procedure TransformateKey(key: string);
var i, j: integer;
  buf: array[1..4]of byte;
begin
  for i := 1 to 32 do
  begin
    case key[i] of
      '0': begin buf[1] := 0; buf[2] := 0; buf[3] := 0; buf[4] := 0; end;
      '1': begin buf[1] := 0; buf[2] := 0; buf[3] := 0; buf[4] := 1; end;
      '2': begin buf[1] := 0; buf[2] := 0; buf[3] := 1; buf[4] := 0; end;
      '3': begin buf[1] := 0; buf[2] := 0; buf[3] := 1; buf[4] := 1; end;
      '4': begin buf[1] := 0; buf[2] := 1; buf[3] := 0; buf[4] := 0; end;
      '5': begin buf[1] := 0; buf[2] := 1; buf[3] := 0; buf[4] := 1; end;
      '6': begin buf[1] := 0; buf[2] := 1; buf[3] := 1; buf[4] := 0; end;
      '7': begin buf[1] := 0; buf[2] := 1; buf[3] := 1; buf[4] := 1; end;
      '8': begin buf[1] := 1; buf[2] := 0; buf[3] := 0; buf[4] := 0; end;
      '9': begin buf[1] := 1; buf[2] := 0; buf[3] := 0; buf[4] := 1; end;
      'A': begin buf[1] := 1; buf[2] := 0; buf[3] := 1; buf[4] := 0; end;
      'B': begin buf[1] := 1; buf[2] := 0; buf[3] := 1; buf[4] := 1; end;
      'C': begin buf[1] := 1; buf[2] := 1; buf[3] := 0; buf[4] := 0; end;
      'D': begin buf[1] := 1; buf[2] := 1; buf[3] := 0; buf[4] := 1; end;
      'E': begin buf[1] := 1; buf[2] := 1; buf[3] := 1; buf[4] := 0; end;
      'F': begin buf[1] := 1; buf[2] := 1; buf[3] := 1; buf[4] := 1; end;
    end;
    for j := 1 to 4 do
    begin
      KeyBits[(i - 1) * 4 + j] := buf[j];
    end;
  end;
end;


procedure TMainForm.exitClick(Sender: TObject);
begin
  Halt;
end;

procedure TMainForm.openClick(Sender: TObject);
 var f:textFile;
   begin
   if OpenDialog.Execute then
    begin
    FName := OpenDialog.FileName;
    assignfile(f,FName);
    reset(f);
      while not(eof(f)) do
        begin
        readln(f,firststr);
        str:=str+firststr;
        end;
      with firstfilememo do
         Lines.LoadFromFile(FName);
    closefile(f);
    end
     else showmessage('Выберите файл для работы :-)');
    firststr:='';
    If length(str)=0 then
      ShowMessage('Выберите непустой файл');
      end;



procedure TMainForm.SaveClick(Sender: TObject);
var  f:textFile;
begin
    if (str<>'') and (fname<>'') then
      begin
    fname:=fname+'cip';
    assignfile(f,FName);
    rewrite(f);
    writeln(f,str);   //пока что сохраняю str
    closefile(f);
    end
    else showmessage('Вы пытаетесь сохранить пустой файл');
    end;
procedure TMainForm.keyEditKeyPress(Sender: TObject; var Key: Char);
const allowed: set of Char = ['0'..'9', 'A', 'B', 'C', 'D', 'E', 'F', #8];
begin
  if not (key in allowed) then key := #0;
end;


procedure GetAllKeys(Key:TKeyBits);
var i,j,z:integer;
    keystr:string[128];
begin
  for i:=1 to 128 do
    keystr:=keystr+key[i];
  for i:=1 to 8 do
    for j:=1 to 6 do
      

end;

procedure Encryption();
begin
Key:=keyedit.text;
TransformateKey(key);
//GetKeysVector(KeyBits);
GetAllKeys(KeyBits);

end;

procedure decryption();
begin
Key:=keyedit.text;
TransformateKey(key);
//GetKeysVector(KeyBits);

end;

procedure TMainForm.EncryptClick(Sender: TObject);
begin
if (str<>'') then
  if length(keyedit.Text)=32 then
    begin

    end
  else showmessage('Введите ключ длиной 32 символа')
  else showmessage('Выберите файл для работы');
end;

procedure TMainForm.StepClick(Sender: TObject);
begin
if (str<>'') then
if length(keyedit.Text)=32 then
    begin

    end
  else showmessage('Введите ключ длиной 32 символа')
  else showmessage('Выберите файл для работы');
end;

procedure TMainForm.DecryptionClick(Sender: TObject);
begin
if (str<>'') then
  if length(keyedit.Text)=32 then
    begin

    end
    else showmessage('Введите ключ длиной 32 символа')
  else showmessage('Выберите файл для работы');
end;

end.
