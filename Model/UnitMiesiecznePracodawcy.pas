unit UnitMiesiecznePracodawcy;

interface

type
MscKosztPracodawcy = class
var
emerytalne, rentowe, wypadkowe, fundPracy, FGSP, kosztPracodawcy,
kosztLaczny: Double;
end;
roczneKosztyPracodawcy = Array [1..12] of MscKosztPracodawcy;
txtTablicaMiesiecy = Array [1..7,1..12] of Double;
function toArrayOfString(rkp: roczneKosztyPracodawcy): txtTablicaMiesiecy;

implementation

function toArrayOfString(rkp: roczneKosztyPracodawcy): txtTablicaMiesiecy;
var tekstTab: txtTablicaMiesiecy;
begin
    for var I := 1 to 12 do
    begin
    tekstTab[1][I] := rkp[i].emerytalne;
    tekstTab[2][I] := rkp[i].rentowe;
    tekstTab[3][I] := rkp[i].wypadkowe;
    tekstTab[4][I] := rkp[i].fundPracy;
    tekstTab[5][I] := rkp[i].FGSP;
    tekstTab[6][I] := rkp[i].kosztPracodawcy;
    tekstTab[7][I] := rkp[i].kosztLaczny;
    end;
  result := tekstTab;
end;

end.
