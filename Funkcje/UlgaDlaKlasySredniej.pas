unit UlgaDlaKlasySredniej;

interface

uses
  Narzedzia;

const
  ULGA_PROG_1 = 5701;
  ULGA_PROG_2 = 8549;
  ULGA_PROG_3 = 11141;

function liczUlgê(brutto: Double; czyUlgaDlaSredniej: Boolean): Double;

implementation

function liczUlgê(brutto: Double; czyUlgaDlaSredniej: Boolean): Double;
begin
  if (brutto >= ULGA_PROG_1) and (brutto < ULGA_PROG_2) and czyUlgaDlaSredniej then
    result := redDoSetnych((brutto * 0.0668 - 380.5) / 0.17)
  else if (brutto >= ULGA_PROG_2) and (brutto < ULGA_PROG_3) and czyUlgaDlaSredniej then
    result := redDoSetnych((brutto * -0.0735 + 819.08) / 0.17)
  else
    result := 0;
end;

end.
