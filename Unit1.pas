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
  Keys:array[1..9,1..6] of string[25];
  BitsStr:ansistring;
  AddedBits:byte;

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

procedure getBitsStr();
var i,temp,j:integer;
    strbit:string[8];
begin
  i:=1;
  while i<=length(str) do
    begin
    strbit:='';
    temp:=ord(str[i]);
    while temp>0 do
      begin
      strbit:=strbit+inttostr(temp mod 2);
      temp:=temp div 2;
      end;
    for j:=length(strbit) to 8 do
      strbit:=strbit+'0';
    for j:=8 downto 1 do
    Bitsstr:=Bitsstr+strbit[j];
    inc(i);
    end;
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
    keystr:=keystr+inttostr(key[i]);
  for i:=1 to 9 do
    for j:=1 to 6 do
      begin
      Keys[i,j]:=copy(keystr,1,25);
      delete(keystr,1,25);
      insert(keys[i,j],keystr,104);
      end;
end;

procedure CheckAddedBits();
var i:integer;
begin
if (length(bitsStr) mod 64<>0) then
    begin
    AddedBits:=64-length(bitsStr) mod 64;
    for i:=1 to addedbits do
      bitsStr:=BitsStr+'0';
    end
    else AddedBits:=0;
end;

procedure Encryption();
begin
Key:=MainForm.keyedit.text;
TransformateKey(key);
//GetKeysVector(KeyBits);
GetAllKeys(KeyBits);
getbitsstr();
CheckAddedBits();

end;

procedure decryption();
begin
Key:=MainForm.keyedit.text;
TransformateKey(key);
//GetKeysVector(KeyBits);
GetAllKeys(KeyBits);

end;

procedure TMainForm.EncryptClick(Sender: TObject);
begin
if (str<>'') then
  if length(keyedit.Text)=32 then
    begin
      Encryption();
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
