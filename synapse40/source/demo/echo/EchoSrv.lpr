program EchoSrv;

{$MODE Delphi}

uses
  Forms, Interfaces,
  main in 'main.pas' {Form1},
  echo in 'echo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
