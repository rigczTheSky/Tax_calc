unit UnitMiesieczne;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  unitMiesiaceRoku;

type
  miesieczne = class
  public
    brutto, bruttoRazem, netto, nettoRazem, podstawa, podstawaRazem, emerytalne,
      rentowe, chorobowe, zdrowotne, zdrDoOdliczenia, zaliczka: double;
  end;

  tablicaMiesiecy = Array [1 .. 12] of miesieczne;
  txtTablicaMiesiecy = Array [1..7,1..12] of Double;

function toString(tm: tablicaMiesiecy): String;
function toArrayOfString(tm: tablicaMiesiecy): txtTablicaMiesiecy;

implementation

function toString(tm: tablicaMiesiecy): String;
begin
  var
  tekst := '';

  for var i := 1 to length(tm) do
  begin
    tekst := tekst
          + MIESIACE_ROKU[i]
    + ' - spo³eczne: ' +floatToStr(tm[i].emerytalne + tm[i].rentowe + tm[i].chorobowe)
    + ' podstawa: ' + floatToStr(tm[i].podstawa)
    + ' zaliczka PIT: ' + floatToStr(tm[i].zaliczka)
    + ' zdrowotne: ' + floatToStr(tm[i].zdrowotne)
    + ' netto ' + floatToStr(tm[i].netto) + sLineBreak
  end;
  result := tekst;
end;

function toArrayOfString(tm: tablicaMiesiecy): txtTablicaMiesiecy;
var tekstTab: txtTablicaMiesiecy;
begin
    for var I := 1 to 12 do
    begin
    tekstTab[1][I] := tm[I].emerytalne;
    tekstTab[2][I] := tm[I].rentowe;
    tekstTab[3][I] := tm[I].chorobowe;
    tekstTab[4][I] := tm[I].podstawa;
    tekstTab[5][I] := tm[I].zaliczka;
    tekstTab[6][I] := tm[I].zdrowotne;
    tekstTab[7][I] := tm[I].netto;
    end;
  result := tekstTab;
end;


end.
