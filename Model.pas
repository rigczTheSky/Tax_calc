unit Model;

interface

type
  Rok = class

  Const
    PROC_EMERYT = 0.0976;
    PROC_RENTOW = 0.015;
    PROC_CHOROB = 0.0245;
    PROC_ZDR = 0.09;
    KOSZT_WK = 300;
    KOSZT_MN = 250;
    PIT_MN = 0.17;
    PIT_W = 0.32;
    PROG_DLA_26 = 85528;

  var
    czyOdliczycZdrowotne, czyUlgaDlaSredniej: Boolean;
    progPit, kwotaWolna, limitZus: Double;

    constructor daj21;
    constructor daj22;
  end;

type
  TMiesiecznePracownika = class
  public
    brutto, bruttoRazem, netto, nettoRazem, podstawa, podstawaRazem, emerytalne,
      rentowe, chorobowe, zdrowotne, zdrDoOdliczenia, zaliczka: Double;
  end;

type
  TMscKosztPracodawcy = class
  var
    emerytalne, rentowe, wypadkowe, fundPracy, FGSP, kosztPracodawcy,
      kosztLaczny: Double;
  end;

  TRoczneKosztyPracownika = Array [1 .. 12] of TMiesiecznePracownika;
  TroczneKosztyPracodawcy = Array [1 .. 12] of TMscKosztPracodawcy;
  TTablicaRoczna = Array [1 .. 7, 1 .. 12] of Double;

function dajRoczneKosztyPracownikaWLiczbach(tm: TRoczneKosztyPracownika)
  : TTablicaRoczna;
function dajRoczneKosztyPracodawcyWLiczbach(rkp: TroczneKosztyPracodawcy)
  : TTablicaRoczna;

implementation

function dajRoczneKosztyPracownikaWLiczbach(tm: TRoczneKosztyPracownika)
  : TTablicaRoczna;
var
  tr: TTablicaRoczna;
begin
  for var I := 1 to 12 do
  begin
    tr[1][I] := tm[I].emerytalne;
    tr[2][I] := tm[I].rentowe;
    tr[3][I] := tm[I].chorobowe;
    tr[4][I] := tm[I].podstawa;
    tr[5][I] := tm[I].zaliczka;
    tr[6][I] := tm[I].zdrowotne;
    tr[7][I] := tm[I].netto;
  end;
  result := tr;
end;

function dajRoczneKosztyPracodawcyWLiczbach(rkp: TroczneKosztyPracodawcy)
  : TTablicaRoczna;
var
  tr: TTablicaRoczna;
begin
  for var I := 1 to 12 do
  begin
    tr[1][I] := rkp[I].emerytalne;
    tr[2][I] := rkp[I].rentowe;
    tr[3][I] := rkp[I].wypadkowe;
    tr[4][I] := rkp[I].fundPracy;
    tr[5][I] := rkp[I].FGSP;
    tr[6][I] := rkp[I].kosztPracodawcy;
    tr[7][I] := rkp[I].kosztLaczny;
  end;
  result := tr;
end;

constructor Rok.daj21;
begin
  czyOdliczycZdrowotne := true;
  czyUlgaDlaSredniej := false;
  progPit := 85528;
  kwotaWolna := 43.76;
  limitZus := 157770;
end;

constructor Rok.daj22;
begin
  czyOdliczycZdrowotne := false;
  czyUlgaDlaSredniej := true;
  progPit := 120000;
  kwotaWolna := 425;
  limitZus := 177660;
end;

end.
