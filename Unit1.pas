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
    options: TMenuItem;
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
  str,firststr,outputresult:ansistring;
  FName:string;
  KeyBits: TKeyBits;
  vector: TKeysVector;
  Key:string;
  Keys:array[1..9,1..6] of string[26];
  BitsStr:ansistring;
  AddedBits:byte;
  flag:boolean;
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
  BitsStr:='';
  while i<=length(str) do
    begin
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

procedure getBitsStr2();
 var f:File of byte;
      b:byte;
      strbit:string;
      j:integer;
      size:integer;
begin
assignfile(f,FName);
reset(f);
while not(eof(f)) do
        begin
        read(f,b);
        strbit:='';
          while b>0 do
            begin
            strbit:=strbit+inttostr(b mod 2);
            b:=b div 2;
            end;
          for j:=length(strbit) to 8 do
            strbit:=strbit+'0';
          for j:=8 downto 1 do
            Bitsstr:=Bitsstr+strbit[j];
        end;
closefile(f);
if not(flag) then
begin
size:=5*8+AddedBits;
if addedbits>9 then size:=size+16;
if addedbits<10 then size:=size+8;
delete(BitsStr,length(bitsstr)-size+1,size);
showmessage(inttostr(length(BitsStr) div 8));
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
      if saveDialog.Execute then
    begin
    FName := SaveDialog.FileName;
    assignfile(f,FName);
    rewrite(f);
    writeln(f,outputresult);
    closefile(f);
    end;
    end
    else showmessage('Вы пытаетесь сохранить пустой файл');
    end;
procedure TMainForm.keyEditKeyPress(Sender: TObject; var Key: Char);
const allowed: set of Char = ['0'..'9', 'A', 'B', 'C', 'D', 'E', 'F', #8];
begin
  if not (key in allowed) then key := #0;
end;


procedure GetAllKeys(Key:TKeyBits);
var i,j:integer;
    keystr,tempstr:string[128];
begin
keystr:='';
  for i:=1 to 128 do
    keystr:=keystr+inttostr(key[i]);
  {for i:=1 to 9 do
    for j:=1 to 6 do
      begin
      Keys[i,j]:=copy(keystr,1,25);
      delete(keystr,1,25);
      insert(keys[i,j],keystr,104);
      end;}
  Keys[1,1]:=copy(keystr,1,16);
  Keys[1,2]:=copy(keystr,17,16);
  Keys[1,3]:=copy(keystr,33,16);
  Keys[1,4]:=copy(keystr,49,16);
  Keys[1,5]:=copy(keystr,65,16);
  Keys[1,6]:=copy(keystr,81,16);
  Keys[2,1]:=copy(keystr,97,16);
  Keys[2,2]:=copy(keystr,113,16);
  tempstr:=copy(keystr,1,25);
  delete(keystr,1,25);
  insert(tempstr,keystr,104);
  Keys[2,3]:=copy(keystr,1,16);
  Keys[2,4]:=copy(keystr,17,16);
  Keys[2,5]:=copy(keystr,33,16);
  Keys[2,6]:=copy(keystr,49,16);
  Keys[3,1]:=copy(keystr,65,16);
  Keys[3,2]:=copy(keystr,81,16);
  Keys[3,3]:=copy(keystr,97,16);
  Keys[3,4]:=copy(keystr,113,16);
  tempstr:=copy(keystr,1,25);
  delete(keystr,1,25);
  insert(tempstr,keystr,104);
  Keys[3,5]:=copy(keystr,1,16);
  Keys[3,6]:=copy(keystr,17,16);
  Keys[4,1]:=copy(keystr,33,16);
  Keys[4,2]:=copy(keystr,49,16);
  Keys[4,3]:=copy(keystr,65,16);
  Keys[4,4]:=copy(keystr,81,16);
  Keys[4,5]:=copy(keystr,97,16);
  Keys[4,6]:=copy(keystr,113,16);
  tempstr:=copy(keystr,1,25);
  delete(keystr,1,25);
  insert(tempstr,keystr,104);
  Keys[5,1]:=copy(keystr,1,16);
  Keys[5,2]:=copy(keystr,17,16);
  Keys[5,3]:=copy(keystr,33,16);
  Keys[5,4]:=copy(keystr,49,16);
  Keys[5,5]:=copy(keystr,65,16);
  Keys[5,6]:=copy(keystr,81,16);
  Keys[6,1]:=copy(keystr,97,16);
  Keys[6,2]:=copy(keystr,113,16);
  tempstr:=copy(keystr,1,25);
  delete(keystr,1,25);
  insert(tempstr,keystr,104);
  Keys[6,3]:=copy(keystr,1,16);
  Keys[6,4]:=copy(keystr,17,16);
  Keys[6,5]:=copy(keystr,33,16);
  Keys[6,6]:=copy(keystr,49,16);
  Keys[7,1]:=copy(keystr,65,16);
  Keys[7,2]:=copy(keystr,81,16);
  Keys[7,3]:=copy(keystr,97,16);
  Keys[7,4]:=copy(keystr,113,16);
  tempstr:=copy(keystr,1,25);
  delete(keystr,1,25);
  insert(tempstr,keystr,104);
  Keys[7,5]:=copy(keystr,1,16);
  Keys[7,6]:=copy(keystr,17,16);
  Keys[8,1]:=copy(keystr,33,16);
  Keys[8,2]:=copy(keystr,49,16);
  Keys[8,3]:=copy(keystr,65,16);
  Keys[8,4]:=copy(keystr,81,16);
  Keys[8,5]:=copy(keystr,97,16);
  Keys[8,6]:=copy(keystr,113,16);
  tempstr:=copy(keystr,1,25);
  delete(keystr,1,25);
  insert(tempstr,keystr,104);
  Keys[1,1]:=copy(keystr,1,16);
  Keys[1,2]:=copy(keystr,17,16);
  Keys[1,3]:=copy(keystr,33,16);
  Keys[1,4]:=copy(keystr,49,16);
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


function perevod(number:string):int64;
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


function pobitXOR(a,b:int64):integer;
var semiresult:string;
    temp:char;
    k:integer;
begin
  result:=0;
 while (a>0) or (b>0) do
  begin
   semiresult:=semiresult+inttostr((a mod 2) xor (b mod 2));
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
  result:='1111111111111111';
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

function perevodintochar(str:string):string;
var temp:string;
    resultord:integer;
begin
result:='';
while str<>'' do
  begin
  temp:=copy(str,1,8);
  delete(str,1,8);
  resultord:=strtoint(temp[1])*128+strtoint(temp[2])*64+strtoint(temp[3])*32+strtoint(temp[4])*16+strtoint(temp[5])*8+strtoint(temp[6])*4+strtoint(temp[7])*2+strtoint(temp[8])*1;
  result:=result+chr(resultord);
  end;
end;

function mul(a, b :word):word; 
var 
tempA, tempB, res, module :Int64; 
begin
result:=0;
module:=65536; 
if a = 0 then
tempA := MODULE
else 
tempA := a; 
if b = 0 then 
tempB := MODULE 
else 
tempB := b; 
res := (tempA * tempB) mod (MODULE + 1); 
if res = MODULE then 
result := 0 
else 
result := word(res); 
end;

function  sum(a,b:word):word;
var result2:word;
begin
result2 := (a + b) mod 65536;
sum := result2;
end;

procedure MainShifr();
var D1,D2,d3,d4,d2old:string[16];
    semiresult:string[64];
    a,b,c,d,e,f,j,temp,temp2,k:int64;
    i:integer;
begin
outputresult:='';
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
a := mul(perevod(d1),perevod(keys[i,1]));
b := sum(perevod(d2),perevod(keys[i,2]));
c := sum(perevod(d3),perevod(keys[i,3]));
d := mul(perevod(d4),perevod(keys[i,4]));
e := a xor c;
f := b xor d;
d1 := outresult(a xor (mul(sum(f,mul(e,perevod(keys[i,5]))),perevod(keys[i,6]))));
d2 := outresult(c xor (mul(sum(f,mul(e,perevod(keys[i,5]))),perevod(keys[i,6]))));
d3 := outresult(b xor sum(mul(e,perevod(keys[i,5])),mul(sum(mul(e,perevod(keys[i,5])),f),perevod(keys[i,6]))));
d4 := outresult(d xor sum(mul(e,perevod(keys[i,5])),mul(sum(mul(e,perevod(keys[i,5])),f),perevod(keys[i,6]))));
    end;
  d1 := outresult(mul(perevod(d1),perevod(keys[9,1])));
  d2old:=d2;
  d2 := outresult(sum(perevod(d3),perevod(keys[9,2])));
  d3 := outresult(sum(perevod(d2old),perevod(keys[9,3])));
  d4 := outresult(mul(perevod(d4),perevod(keys[9,4])));
  semiresult:=d1+d2+d3+d4;
  outputresult:=outputresult+perevodintochar(semiresult);
  end;
 // AddedBits:=addeDbits div 8;
  if not(flag) then delete(outputresult,length(semiresult)-AddedBits+1,AddedBits);
  if (flag) then outputresult:=outputresult+'added'+inttostr(addedbits);
end;

procedure outmemo();
var f:textfile;
    i:integer;
begin
fname:=fname+'.cip';
    assignfile(f,FName);
    rewrite(f);
    write(f,outputresult);
    closefile(f);
    assignfile(f,FName);
    reset(f);
    with MainForm.lastfilememo do
         Lines.LoadFromFile(FName);
    closefile(f);
end;

procedure Encryption();
begin
flag:=true;
Key:=MainForm.keyedit.text;
TransformateKey(key);
GetAllKeys(KeyBits);
getbitsstr2();
CheckAddedBits();
mainshifr();
outmemo();
end;

function AdditiveInversion(key:string):string;
var i,k,semiresult:integer;
    temp:string;
begin
  k:=1;
  temp:='';
  semiresult:=0;
  result:='';
  for i:=length(key) downto 1 do
    begin
    semiresult:=semiresult+strtoint(key[i])*k;
    end;
  semiresult:=65536-semiresult;
  while semiresult>0 do
    begin
    temp:=temp+inttostr(semiresult mod 2);
    semiresult:=semiresult div 2;
    end;
  while Length(temp)<=16 do
    temp:=temp+'0';
  for i:=length(temp) downto 1 do
    result:=result+temp[i];
end;

function multiplecInversion(key:string):string;
var i,k,semiresult:integer;
    temp:string;
begin
  k:=1;
  temp:='';
  semiresult:=0;
  result:='';
  for i:=length(key) downto 1 do
    begin
    semiresult:=semiresult+strtoint(key[i])*k;
    end;
  for i:=1 to semiresult do
    begin
    if ((i*semiresult) mod 65367=1) then break;
    end;
  semiresult:=i;
  while semiresult>0 do
    begin
    temp:=temp+inttostr(semiresult mod 2);
    semiresult:=semiresult div 2;
    end;
  while Length(temp)<=16 do
    temp:=temp+'0';
  for i:=length(temp) downto 1 do
    result:=result+temp[i];
end;

procedure changekeys();
var i:integer;
begin
 for i:=1 to 9 do
  begin
  additiveInversion(keys[i,2]);
  additiveInversion(keys[i,3]);
  multiplecInversion(keys[i,4]);
  multiplecInversion(keys[i,1]);
  end;
end;

function getAdded():integer;
var d:integer;
    temp:string;
begin
  result:=0;
  d:=pos('added',str);
  if d<>0 then begin
  temp:=copy(str,d+5,length(str)-(d+4));
  delete(str,d,length(str)-d);
  result:=strtoint(temp);
  end
  else result:=0;
end;

procedure decrypt();
begin
flag:=false;
AddedBits:=getadded;
Key:=MainForm.keyedit.text;
TransformateKey(key);
GetAllKeys(KeyBits);
getbitsstr2();
changeKeys();
mainshifr();
outmemo();
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
    Begin
    decrypt;
    end
    else showmessage('Введите ключ длиной 32 символа')
  else showmessage('Выберите файл для работы');
end;

end.
