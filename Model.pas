unit Model;

interface

type

  TRok = (R2021, R2022);

  TMiesiecznePracownika = class
  public
    brutto, bruttoRazem, netto, nettoRazem, podstawa, podstawaRazem, emerytalne,
      rentowe, chorobowe, zdrowotne, zdrDoOdliczenia, zaliczka: Double;
  end;

  TMscKosztPracodawcy = class
  var
    emerytalne, rentowe, wypadkowe, fundPracy, FGSP, kosztPracodawcy,
      kosztLaczny: Double;
  end;

  TRoczneKosztyPracownika = Array [1 .. 12] of TMiesiecznePracownika;
  TroczneKosztyPracodawcy = Array [1 .. 12] of TMscKosztPracodawcy;
  TTablicaRoczna = Array [1 .. 7, 1 .. 12] of Double;
  TTablicaPorownan = Array [1 .. 3, 1 .. 12] of Double;

  TRozliczenieRoczne = class

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
  public
    constructor create(Rok: TRok);
  end;

implementation

constructor TRozliczenieRoczne.create(Rok: TRok);
begin
  if Rok = R2021 then
  begin
    czyOdliczycZdrowotne := true;
    czyUlgaDlaSredniej := false;
    progPit := 85528;
    kwotaWolna := 43.76;
    limitZus := 157770;
  end
  else
  begin
    czyOdliczycZdrowotne := false;
    czyUlgaDlaSredniej := true;
    progPit := 120000;
    kwotaWolna := 425;
    limitZus := 177660;
  end;
end;

end.
