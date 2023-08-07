unit Zaliczka;

interface

uses
  Narzedzia;

Const
  PIT_MN = 0.17;
  PIT_W = 0.32;

function liczZaliczke(podstawa, podstawaRazem, BruttoRazem, progPit,
  wolnaKwota: Double; ulga26: Boolean; zdrDoOdliczenia: Double = 0): Double;

implementation

function liczZaliczke(podstawa, podstawaRazem, BruttoRazem, progPit,
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
end.
