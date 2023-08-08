program Tax_calc;

uses
  Vcl.Forms,
  Widok in 'Widok.pas' {FormGlowny},
  UnitMiesiecznePracodawcy in 'Model\UnitMiesiecznePracodawcy.pas',
  UnitMiesieczne in 'Model\UnitMiesieczne.pas',
  UnitDaneRoczne in 'Model\UnitDaneRoczne.pas',
  Narzedzia in 'Narzedzia.pas',
  Kontroler in 'Kontroler.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormGlowny, FormGlowny);
  Application.Run;
end.
