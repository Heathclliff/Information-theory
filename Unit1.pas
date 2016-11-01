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
  Keys:array[1..9,1..6] of string[26];
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
     else showmessage('�������� ���� ��� ������ :-)');
    firststr:='';
    If length(str)=0 then
      ShowMessage('�������� �������� ����');
      end;



procedure TMainForm.SaveClick(Sender: TObject);
var  f:textFile;
begin
    if (str<>'') and (fname<>'') then
      begin
    fname:=fname+'cip';
    assignfile(f,FName);
    rewrite(f);
    writeln(f,str);   //���� ��� �������� str
    closefile(f);
    end
    else showmessage('�� ��������� ��������� ������ ����');
    end;
procedure TMainForm.keyEditKeyPress(Sender: TObject; var Key: Char);
const allowed: set of Char = ['0'..'9', 'A', 'B', 'C', 'D', 'E', 'F', #8];
begin
  if not (key in allowed) then key := #0;
end;


procedure GetAllKeys(Key:TKeyBits);
var i,j:integer;
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


function perevod(number:string):integer;
var temp:char;
    k:integer;
begin
 result:=0;
 k:=1;
 while number<>'' do
  begin
  temp:=number[length(number)];
  delete(number,length(number),1);
  result:=result+strtoint(temp)*k;
  k:=k*2;
  end;
  if result=0 then result:=65536;
end;


function pobitXOR(a,b:integer):integer;
var semiresult:string;
    temp:char;
    k:integer;
begin
  result:=0;
 while (a>0) and (b>0) do
  begin
   semiresult:=inttostr((a mod 2) xor (b mod 2));
   a:=a div 10;
   b:=b div 10;
  end;
 while length(semiresult)<8 do
  semiresult:=semiresult+'0';
 k:=1;
 while semiresult<>'' do
  begin
  temp:=semiresult[1];
  delete(semiresult,1,1);
  result:=result+strtoint(temp)*k;
  k:=k*2;
  end;
end;

function outresult(perem:integer):string;
var
  i:integer;
  begin
  I:=16;
  while perem>0 do
    begin
    if perem mod 2=0 then result[i]:='0'
    else result[i]:='1';
    dec(i);
    perem:=perem div 2;
    end;
  while i>=1 do
  begin
  result[i]:='0';
  dec(i);
  end;
  end;

procedure MainShifr();
var D1,D2,d3,d4:string[16];
    semiresult:string[64];
    a,b,c,d,e,f,j,temp,temp2:integer;
    i:integer;
begin
while Bitsstr<>'' do
  begin
  d1:=copy(bitsstr,1,16);
  delete(bitsstr,1,16);
  d2:=copy(bitsstr,1,16);
  delete(bitsstr,1,16);
  d3:=copy(bitsstr,1,16);
  delete(bitsstr,1,16);
  d4:=copy(bitsstr,1,16);
  delete(bitsstr,1,16);
  for i:=1 to 8 do
    begin
    j:=1;
    a:=perevod(d1) xor perevod(keys[i,j]);
    if (a=65536) then a:=0;
    a:=a mod 65537;
    inc(j);
    b:=perevod(d2)+perevod(keys[i,j]);
    b:=b mod 65536;
    inc(j);
    c:=perevod(d3)+perevod(keys[i,j]);
    if (c=65536) then a:=0;
    c:=c mod 65536;
    inc(j);
    d:=perevod(d4) xor perevod (keys[i,j]);
    d:=d mod 65537;
    inc(j);
    e:=pobitXor(a,c);
    f:=pobitXor(b,d);
    if e=0 then e:=65536;
    if perevod(keys[i,5])=0 then keys[i,5]:='10000000000000000000000000';
    if perevod(keys[i,6])=0 then keys[i,6]:='10000000000000000000000000';
    temp:=e xor perevod(keys[i,5]);
    temp:=temp mod 65537;
    temp:=temp+f;
    if temp=0 then temp:=65536;
    temp:=temp xor perevod(keys[i,6]);
    temp:=temp mod 65537;
    temp2:=e xor perevod(keys[i,5]);
    temp2:=temp2 mod 65537;
    temp2:=temp2+temp;
    temp2:=temp mod 65536;
    d1:=outresult(pobitXor(a,temp));
    d2:=outresult(pobitXor(c,temp));
    d3:=outresult(pobitXor(b,temp2));
    d4:=outresult(pobitXor(d,temp2));
    end;
  end;
  temp:=perevod(d1) xor perevod(keys[9,1]);
  temp:=temp mod 65537;
  if temp=65537 then temp:=0;
  d1:=outresult(temp);

  temp:=perevod(d4) xor perevod(keys[9,4]);
  temp:=temp mod 65537;
  if temp=65537 then temp:=0;
  d4:=outresult(temp);

  temp:=perevod(d3)+perevod(keys[9,2]);
  temp:=temp mod 65536;
  d2:=outresult(temp);

  temp:=perevod(d2)+perevod(keys[9,3]);
  temp:=temp mod 65536;
  d3:=outresult(temp);



end;


procedure Encryption();
begin
Key:=MainForm.keyedit.text;
TransformateKey(key);
GetAllKeys(KeyBits);
getbitsstr();
CheckAddedBits();
mainshifr();

end;

procedure decryption();
begin
Key:=MainForm.keyedit.text;
TransformateKey(key);
GetAllKeys(KeyBits);
mainshifr();
end;

procedure TMainForm.EncryptClick(Sender: TObject);
begin
if (str<>'') then
  if length(keyedit.Text)=32 then
    begin
      Encryption();
    end
  else showmessage('������� ���� ������ 32 �������')
  else showmessage('�������� ���� ��� ������');
end;

procedure TMainForm.StepClick(Sender: TObject);
begin
if (str<>'') then
if length(keyedit.Text)=32 then
    begin

    end
  else showmessage('������� ���� ������ 32 �������')
  else showmessage('�������� ���� ��� ������');
end;

procedure TMainForm.DecryptionClick(Sender: TObject);
begin
if (str<>'') then
  if length(keyedit.Text)=32 then
    begin

    end
    else showmessage('������� ���� ������ 32 �������')
  else showmessage('�������� ���� ��� ������');
end;

end.
