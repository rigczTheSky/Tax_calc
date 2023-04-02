unit PorownanieRozliczen;

interface

uses
  UnitMiesieczne, unitMiesiaceRoku, System.SysUtils, unitDaneRoczne, BruttoNaNetto;

type
  tablicaPorownan = Array [1 .. 3, 1 .. 12] of Double;
function stworzPorownanie(brutto, k_przychodu: Double; ulga26: Boolean; rok21, rok22: Rok)
  : tablicaPorownan;

var
  tm1, tm2: UnitMiesieczne.tablicaMiesiecy;

implementation

function stworzPorownanie(brutto, k_przychodu: Double; ulga26: Boolean; rok21, rok22: Rok)
  : tablicaPorownan;
var
  I: Integer;
  tp: tablicaPorownan;

begin
  tm1 := stworzTablice(brutto, k_przychodu, ulga26, rok21);
  tm2 := stworzTablice(brutto, k_przychodu, ulga26, rok22);
  for I := 1 to 12 do
  begin
    tp[1][I] := tm1[I].netto;
    tp[2][I] := tm2[I].netto;
    tp[3][I] := tm2[I].netto - tm1[I].netto;
  end;
  result := tp;
end;

end.