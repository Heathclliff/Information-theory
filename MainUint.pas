unit MainUint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TMainForm = class(TForm)
    OriginalText: TLabel;
    MainText: TMemo;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    MainMenu: TMainMenu;
    Actions: TMenuItem;
    OpenFile: TMenuItem;
    SaveFile: TMenuItem;
    CloseProgram: TMenuItem;
    Result: TLabel;
    ResultText: TMemo;
    StartStep: TButton;
    StartAll: TButton;
    EnterKey: TLabel;
    KeyEdit: TEdit;
    procedure StartStepClick(Sender: TObject);
    procedure StartAllClick(Sender: TObject);
    procedure CloseProgramClick(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  str:string;

implementation

{$R *.dfm}

Function CheckLengthKey():Boolean;
begin
 if (length(MainForm.KeyEdit.Text)<>16)
    then
      result:=false
    else
      result:=true;
end;

procedure TMainForm.StartStepClick(Sender: TObject);
begin
  if (CheckLengthKey)
      then
        begin

        end
      else
        ShowMessage('Неверная длина ключа!');
end;

procedure TMainForm.StartAllClick(Sender: TObject);
begin
     if (CheckLengthKey)
      then
        begin

        end
      else
        ShowMessage('Неверная длина ключа!');
end;


procedure TMainForm.CloseProgramClick(Sender: TObject);
begin
  halt;
end;

procedure TMainForm.OpenFileClick(Sender: TObject);
var     FName,firststr:string;
        f:textFile;
   begin
   str:='';
   if OpenDialog.Execute then
    begin
    FName := OpenDialog.FileName;
    assignfile(f,FName);
    reset(f);
      while not(eof(f)) do
        begin
        readln(f,firststr);
        if not(eof(f)) then str:=str+firststr+#13#10
        else str:=str+firststr;
        end;
      with MainText do
         Lines.LoadFromFile(FName);
    closefile(f);
    end
     else showmessage('Выберите файл для работы :-)');
    If length(str)=0 then
      ShowMessage('Выберите непустой файл')
      else
      begin
      StartStep.Visible:=true;
      StartAll.Visible:=true;
      end;
end;

end.
