unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
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
    procedure exitClick(Sender: TObject);
    procedure openClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  str,firststr:ansistring;
  FName:string;

implementation

{$R *.dfm}

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
end.
 