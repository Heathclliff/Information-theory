program MainProject;

uses
  Forms,
  MainUint in 'MainUint.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
