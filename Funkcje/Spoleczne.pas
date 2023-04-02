unit Spoleczne;

interface

uses
  Narzedzia;

function
liczSpoleczne(brutto, razem, proc: Double): Double;

implementation

function liczSpoleczne(brutto, razem, proc: Double): Double;
begin
  if brutto < razem then
  result := redDoSetnych(brutto * proc)
  else
  result := minZero(redDoSetnych(razem * proc));
end;

end.
