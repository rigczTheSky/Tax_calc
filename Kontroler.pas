unit Kontroler;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  UnitMiesieczne, unitMiesiaceRoku, Narzedzia, UnitDaneRoczne, UnitMiesiecznePracodawcy;

Const
  ZUS_LIMIT = 177660;
  WOLNA_KW = 425;
  PROC_EMERYT = 0.0976;
  PROC_RENTOW = 0.015;
  PROC_CHOROB = 0.0245;
  PROC_ZDR = 0.09;
  KOSZT_WK = 300;
  KOSZT_MN = 250;
  PIT_MN = 0.17;
  PIT_W = 0.32;
  PROG_PIT = 120000;
  PROG_DLA_26 = 85528;
  PROC_ZDR_OD = 0.0775;
  ULGA_PROG_1 = 5701;
  ULGA_PROG_2 = 8549;
  ULGA_PROG_3 = 11141;
  EMERYTALNE_PRACODAWCY = 0.0976;
  RENTOWE_PRACODAWCY = 0.065;
  WYPADKOWE = 0.0167;
  FUNDUSZ_PRACY = 0.0245;
  FGSP = 0.001;
  WRN_K_PRACODAWCY = 'UWAGA! OBLICZENIA KOSZTÓW PRACODAWCY DLA WYNAGRODZENIA' +
    sLineBreak + 'POWY¯EJ 100 TYS. Z£OTYCH MIESIÊCZNIE MOG¥ BYÆ OBARCZONE B£ÊDEM!'#13#10'';

type

  tablicaPorownan = Array [1 .. 3, 1 .. 12] of Double;
  MSC = UnitMiesieczne.miesieczne;
  tablicaMiesiecy = UnitMiesieczne.tablicaMiesiecy;
  TKontroler = class
  public
    function stworzTablice(brutto, kosztPrzychodu: Double; ulga26: Boolean;
      rok: rok; wlkTablicy: Integer = 12): tablicaMiesiecy;
  private
    function liczSpoleczne(brutto, razem, proc: Double): Double;
    function liczZaliczke(podstawa, podstawaRazem, BruttoRazem, progPit,
      wolnaKwota: Double; ulga26: Boolean; zdrDoOdliczenia: Double = 0): Double;
    function liczUlge(brutto: Double; czyUlgaDlaSredniej: Boolean): Double;
    function dajBrutto(netto, kPrzychodu: Double; ulgaDo26: Boolean;
      rok: rok): Double;
    function liczZdrDoOdliczenia(rok: rok; podstawaZdr: Double): Double;
    function stworzPorownanie(brutto, k_przychodu: Double; ulga26: Boolean; rok21, rok22: Rok)
  : tablicaPorownan;
    function dajKoszty(brutto, ZUS_LIMIT: Double): roczneKosztyPracodawcy;
  end;

implementation

function TKontroler.liczUlge(brutto: Double; czyUlgaDlaSredniej: Boolean): Double;
begin
  if (brutto >= ULGA_PROG_1) and (brutto < ULGA_PROG_2) and czyUlgaDlaSredniej then
    result := redDoSetnych((brutto * 0.0668 - 380.5) / PIT_MN)
  else if (brutto >= ULGA_PROG_2) and (brutto < ULGA_PROG_3) and czyUlgaDlaSredniej then
    result := redDoSetnych((brutto * -0.0735 + 819.08) / PIT_MN)
  else
    result := 0;
end;

function TKontroler.liczSpoleczne(brutto, razem, proc: Double): Double;
begin
  if brutto < razem then
  result := redDoSetnych(brutto * proc)
  else
  result := minZero(redDoSetnych(razem * proc));
end;

function TKontroler.liczZaliczke(podstawa, podstawaRazem, BruttoRazem, progPit,
  wolnaKwota: Double; ulga26: Boolean; zdrDoOdliczenia: Double = 0): Double;
  function liczProgowyMiesiac(progPit, wolnaKwota, podstawa,
    podstawaRazem: Double; zdrDoOdliczenia: Double = 0): Double;
  var
    czesc1, czesc2: Double;
  begin
    czesc1 := (progPit - (podstawaRazem - podstawa)) * PIT_MN;
    czesc2 := (podstawaRazem - progPit) * PIT_W;
    result := round(redDoSetnych(czesc1 + czesc2 - wolnaKwota) -
      zdrDoOdliczenia);
  end;

begin
  if ulga26 then
    progPit := progPit * 2;

  if (BruttoRazem < progPit) and ulga26 then
    result := 0
  else if podstawaRazem < progPit then
    result := minZero(round(podstawa * PIT_MN - wolnaKwota - zdrDoOdliczenia))
  else if (podstawaRazem - podstawa < progPit) AND (podstawaRazem > progPit)
  then
    result := liczProgowyMiesiac(progPit, wolnaKwota, podstawa, podstawaRazem, zdrDoOdliczenia)
  else
    result := round(redDoSetnych(podstawa * PIT_W) - zdrDoOdliczenia);
end;

function TKontroler.dajKoszty(brutto, ZUS_LIMIT: Double)
  : roczneKosztyPracodawcy;
var
  I: Integer;
  spoleczneRazem: Double;
  tabMsc: roczneKosztyPracodawcy;
begin
  spoleczneRazem := ZUS_LIMIT;
  for I := 1 to 12 do
  begin
    tabMsc[I] := MscKosztPracodawcy.Create;
    tabMsc[I].emerytalne := liczSpoleczne(brutto, spoleczneRazem,
      EMERYTALNE_PRACODAWCY);
    tabMsc[I].rentowe := liczSpoleczne(brutto, spoleczneRazem,
      RENTOWE_PRACODAWCY);
    tabMsc[I].WYPADKOWE := brutto * WYPADKOWE;
    tabMsc[I].fundPracy := brutto * FUNDUSZ_PRACY;
    tabMsc[I].FGSP := brutto * FGSP;
    tabMsc[I].kosztPracodawcy := tabMsc[I].emerytalne + tabMsc[I].rentowe +
      tabMsc[I].WYPADKOWE + tabMsc[I].fundPracy + tabMsc[I].FGSP;
    tabMsc[I].kosztLaczny := brutto + tabMsc[I].kosztPracodawcy;
    spoleczneRazem := spoleczneRazem - brutto;
  end;
end;

function TKontroler.liczZdrDoOdliczenia(rok: rok; podstawaZdr: Double): Double;
begin
  if rok.czyOdliczycZdrowotne then
    result := podstawaZdr * PROC_ZDR_OD
  else
    result := 0;
end;

function liczZdrowotne(podstawaZdr, podstawaPIT: Double; rok: Rok): Double;
var zdrowotne: Double;
var prezaliczka: Double;//zaliczka PIT bez odjêtej sk³adki zdrowotnej
begin
zdrowotne := redDoSetnych(podstawaZdr * PROC_ZDR);
prezaliczka :=  redDoSetnych(podstawaPIT * PIT_MN - rok.kwotaWolna);
if (zdrowotne > prezaliczka) and (rok.czyOdliczycZdrowotne) then
result := minZero(prezaliczka)
else
result := zdrowotne;
end;

function TKontroler.stworzTablice(brutto, kosztPrzychodu: Double; ulga26: Boolean; rok: Rok;
wlkTablicy: Integer = 12): tablicaMiesiecy;
var
  BruttoRazem, spoleczneRazem, podstawaRazem, ulga, podstawaZdr, zdrDoOdliczenia: Double;
  tm: UnitMiesieczne.tablicaMiesiecy;
begin
  BruttoRazem := 0;
  spoleczneRazem := rok.limitZus;
  podstawaRazem := 0;
  for var I := 1 to wlkTablicy do
  begin
    tm[I] := MSC.Create;
    BruttoRazem := BruttoRazem + brutto;
    ulga := liczUlge(brutto, rok.czyUlgaDlaSredniej);
    tm[I].emerytalne := liczSpoleczne(brutto, spoleczneRazem, PROC_EMERYT);
    tm[I].rentowe := liczSpoleczne(brutto, spoleczneRazem, PROC_RENTOW);
    tm[I].chorobowe := redDoSetnych(brutto * PROC_CHOROB);
    podstawaZdr:= redDoSetnych(brutto - tm[I].emerytalne - tm[I].rentowe - tm[I].chorobowe);
    tm[I].podstawa := minZero(round(podstawaZdr - kosztPrzychodu - ulga));
    podstawaRazem := podstawaRazem + tm[I].podstawa;
    zdrDoOdliczenia:= liczZdrDoOdliczenia(rok, podstawaZdr);
    tm[i].zaliczka :=
    liczZaliczke(tm[I].podstawa, podstawaRazem, bruttoRazem, rok.progPit, rok.kwotaWolna, ulga26, zdrDoOdliczenia);
    tm[i].zdrowotne := liczZdrowotne(podstawaZdr, tm[i].podstawa, rok);
    tm[I].netto := redDoSetnych(podstawaZdr - tm[I].zaliczka - tm[I].zdrowotne);
    spoleczneRazem := spoleczneRazem - brutto;
  end;
  result := tm;
end;

function TKontroler.dajBrutto(netto, kPrzychodu: Double; ulgaDo26: Boolean; rok: Rok): Double;
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

function TKontroler.stworzPorownanie(brutto, k_przychodu: Double; ulga26: Boolean; rok21, rok22: Rok)
  : tablicaPorownan;
var
  I: Integer;
  tp: tablicaPorownan;
  tm1, tm2: UnitMiesieczne.tablicaMiesiecy;

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
