unit KalkulatorKosztowPracodawcy;

interface

uses
System.SysUtils, unitMiesiaceRoku, UnitMiesiecznePracodawcy,
Narzedzia, Spoleczne;

const
PROC_EMERYT = 0.0976;
PROC_RENTOW = 0.065;
WYPADKOWE = 0.0167;
FUNDUSZ_PRACY = 0.0245;
FGSP = 0.001;
WRN_K_PRACODAWCY = 'UWAGA! OBLICZENIA KOSZTÓW PRACODAWCY DLA WYNAGRODZENIA'
+ sLineBreak + 'POWY¯EJ 100 TYS. Z£OTYCH MIESIÊCZNIE MOG¥ BYÆ OBARCZONE B£ÊDEM!'#13#10'';
type
KosztPracodawcy = class
var
tabMsc: UnitMiesiecznePracodawcy.roczneKosztyPracodawcy;
constructor create(brutto, ZUS_LIMIT: Double);
function toString: String;
end;

implementation

constructor KosztPracodawcy.create(brutto, ZUS_LIMIT: Double);
var I: Integer;
    spo³eczneRazem: Double;
begin
spo³eczneRazem := ZUS_LIMIT;
for I := 1 to 12 do
begin
tabMsc[I]:= MscKosztPracodawcy.Create;
tabMsc[I].emerytalne := liczSpoleczne(brutto, spo³eczneRazem, PROC_EMERYT);
tabMsc[I].rentowe := liczSpoleczne(brutto, spo³eczneRazem, PROC_RENTOW);
tabMsc[I].wypadkowe:= brutto * WYPADKOWE;
tabMsc[I].fundPracy:= brutto * FUNDUSZ_PRACY;
tabMsc[I].FGSP:= brutto * FGSP;
tabMsc[I].kosztPracodawcy:= tabMsc[i].emerytalne
+ tabMsc[i].rentowe
+ tabMsc[i].wypadkowe
+ tabMsc[i].fundPracy
+ tabMsc[i].FGSP;
tabMsc[I].kosztLaczny:= brutto + tabMsc[I].kosztPracodawcy;
spo³eczneRazem := spo³eczneRazem - brutto;
end;
end;

function KosztPracodawcy.toString: String;
var I: Integer;
    kosztRazem: Double;
    msc_roku: unitMiesiaceRoku.tStringArray;
    tekst: String;
begin
kosztRazem:= 0;
tekst := WRN_K_PRACODAWCY + sLineBreak;
for I := 1 to 12 do
begin
  msc_roku:= unitMiesiaceRoku.MIESIACE_ROKU;

  tekst := tekst
  + msc_roku[I]
  + ' - emerytalne: '+ floatToStr(tabMsc[i].emerytalne)
  + ' rentowe: '+ floatToStr(tabMsc[i].rentowe)
  + ' wypadkowe: '+ floatToStr(tabMsc[i].wypadkowe)
  //+ ' spo³eczne: '+ floatToStr(tabMsc[i].emerytalne + tabMsc[i].rentowe + tabMsc[i].wypadkowe)
  + ' fund. pracy: ' + floatToStr(tabMsc[i].fundPracy)
  + ' FGSP: ' + floatToStr(tabMsc[i].FGSP)
  + ' ca³kowity koszt pracodawcy: ' + floatToStr(tabMsc[i].kosztLaczny)
  + sLineBreak;
  kosztRazem:= kosztRazem+tabMsc[i].kosztPracodawcy;
end;
  result:= tekst+'Koszty pracodawcy w skali roku to: '+floatToStr(kosztRazem);
end;

end.
