unit Kontroler;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  UnitMiesieczne, unitMiesiaceRoku, Narzedzia, UnitDaneRoczne;

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

type

  TKontroler = class
  public
    function stworzTablice(brutto, kosztPrzychodu: Double; ulga26: Boolean;
      rok: rok; wlkTablicy: Integer = 12): tablicaMiesiecy;
  private
    function liczSpoleczne(brutto, razem, proc: Double): Double;
    function liczZaliczke(podstawa, podstawaRazem, BruttoRazem, progPit,
      wolnaKwota: Double; ulga26: Boolean; zdrDoOdliczenia: Double = 0): Double;
    function liczUlg�(brutto: Double; czyUlgaDlaSredniej: Boolean): Double;
    function dajBrutto(netto, kPrzychodu: Double; ulgaDo26: Boolean;
      rok: rok): Double;
    function liczZdrDoOdliczenia(rok: rok; podstawaZdr: Double): Double;
  end;

  MSC = UnitMiesieczne.miesieczne;
  tablicaMiesi�cy = UnitMiesieczne.tablicaMiesiecy;

implementation

function TKontroler.liczUlg�(brutto: Double; czyUlgaDlaSredniej: Boolean): Double;
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

function TKontroler.liczZdrDoOdliczenia(rok: rok; podstawaZdr: Double): Double;
begin
  if rok.czyOdliczycZdrowotne then
    result := podstawaZdr * PROC_ZDR_OD
  else
    result := 0;
end;

function liczZdrowotne(podstawaZdr, podstawaPIT: Double; rok: Rok): Double;
var zdrowotne: Double;
var prezaliczka: Double;//zaliczka PIT bez odj�tej sk�adki zdrowotnej
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
  BruttoRazem, spo�eczneRazem, podstawaRazem, ulga, podstawaZdr, zdrDoOdliczenia: Double;
  tm: UnitMiesieczne.tablicaMiesiecy;
begin
  BruttoRazem := 0;
  spo�eczneRazem := rok.limitZus;
  podstawaRazem := 0;
  for var I := 1 to wlkTablicy do
  begin
    tm[I] := MSC.Create;
    BruttoRazem := BruttoRazem + brutto;
    ulga := liczUlg�(brutto, rok.czyUlgaDlaSredniej);
    tm[I].emerytalne := liczSpoleczne(brutto, spo�eczneRazem, PROC_EMERYT);
    tm[I].rentowe := liczSpoleczne(brutto, spo�eczneRazem, PROC_RENTOW);
    tm[I].chorobowe := redDoSetnych(brutto * PROC_CHOROB);
    podstawaZdr:= redDoSetnych(brutto - tm[I].emerytalne - tm[I].rentowe - tm[I].chorobowe);
    tm[I].podstawa := minZero(round(podstawaZdr - kosztPrzychodu - ulga));
    podstawaRazem := podstawaRazem + tm[I].podstawa;
    zdrDoOdliczenia:= liczZdrDoOdliczenia(rok, podstawaZdr);
    tm[i].zaliczka :=
    liczZaliczke(tm[I].podstawa, podstawaRazem, bruttoRazem, rok.progPit, rok.kwotaWolna, ulga26, zdrDoOdliczenia);
    tm[i].zdrowotne := liczZdrowotne(podstawaZdr, tm[i].podstawa, rok);
    tm[I].netto := redDoSetnych(podstawaZdr - tm[I].zaliczka - tm[I].zdrowotne);
    spo�eczneRazem := spo�eczneRazem - brutto;
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

end.
