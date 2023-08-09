program Tax_calc;

uses
  Vcl.Forms,
  Widok in 'Widok.pas' {FormGlowny},
  Kontroler in 'Kontroler.pas',
  Model in 'Model.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormGlowny, FormGlowny);
  Application.Run;
end.
