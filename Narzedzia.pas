unit Narzedzia;

interface

function redDoSetnych(liczba: Double): Double;
function minZero(liczba: Double): Double;

implementation

function redDoSetnych(liczba: Double): Double;
begin
  liczba := liczba * 100;
  liczba := round(liczba);
  result := liczba / 100;
end;

function minZero(liczba: Double): Double;
begin
  if liczba < 0 then
    result := 0
  else
    result := liczba;
end;

end.
