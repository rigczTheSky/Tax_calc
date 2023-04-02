unit NettoNaBrutto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, UnitMiesieczne, unitMiesiaceRoku, Spoleczne, Narzedzia,
  UlgaDlaKlasySredniej, BruttoNaNetto, unitDaneRoczne;

function dajBrutto(netto, kPrzychodu: Double; ulgaDo26: Boolean; rok: Rok): Double;

implementation

function dajBrutto(netto, kPrzychodu: Double; ulgaDo26: Boolean; rok: Rok): Double;
var
  min, max, I: Integer;
  wynik, stycznioweNetto: Double;
  tm: unitMiesieczne.tablicaMiesiecy;
begin
  wynik := -1;
  min := trunc(netto * 100);
  max := trunc(netto * 200);
  for I := min to max do
  begin
    tm := stworzTablice(I/100, kPrzychodu, ulgaDo26, rok, 1);
    stycznioweNetto := tm[1].netto;
    tm[1].Free;
    if stycznioWeNetto = netto then
    begin
    wynik := I / 100;
    break
    end;
  end;
  result := wynik;
end;

end.
