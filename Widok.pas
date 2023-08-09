unit Widok;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Kontroler, Vcl.Grids,
  Vcl.NumberBox, Model;

const
  BLD_KALK = 'Wybierz kalkulator dla obliczenia';
  BLD_UJEMNA_KW = 'Podana kwota nie mo¿e byæ liczb¹ mniejsz¹ od 0 z³.';
  WIAD_NETTO_NA_BRUTTO = ' z³: kwota dla stycznia. Tabela przedstawia netto dla pozosta³ych miesiêcy.';
  WIAD_KOSZT_PRACODAWCY = 'UWAGA! Po przekroczeniu rocznego limitu sk³adek ZUS mog¹ wyst¹piæ b³êdy.';

type
  TFormGlowny = class(TForm)
    BtOblicz: TButton;
    CbWybierzKalk: TComboBox;
    RgZamieszkanie: TRadioGroup;
    CbUlga26: TCheckBox;
    SGPracownik: TStringGrid;
    SGPracodawca: TStringGrid;
    SGPorownanie: TStringGrid;
    NbWprowadzKwote: TNumberBox;
    LbPoleTxt: TLabel;
    LbWybierzKalk: TLabel;
    LbWprowadzKwote: TLabel;
    procedure BtObliczClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormGlowny: TFormGlowny;

implementation

{$R *.dfm}

function dajKoszt: Integer;
begin
  if (FormGlowny.RgZamieszkanie.ItemIndex = 0) then
    Result := TRozliczenieRoczne.KOSZT_MN
  else
    Result := TRozliczenieRoczne.KOSZT_WK;
end;

function czyUlgaDo26: Boolean;
begin
  if FormGlowny.CbUlga26.Checked then
    Result := true
  else
    Result := false;
end;

procedure pokazTbPracownika;
const
  POLA: Array [1 .. 7] of String = ('Emerytalne', 'Rentowe', 'Chorobowe',
    'Podstawa PIT', 'zaliczka PIT', 'Zdrowotne', 'Netto');
begin
  FormGlowny.SGPracownik.Show;
  for var I := 1 to 12 do
    FormGlowny.SGPracownik.Cells[0, I] := FormatSettings.LongMonthNames[I];
  for var K := 1 to 7 do
    FormGlowny.SGPracownik.Cells[K, 0] := POLA[K];
end;

procedure pokazTbPracodawcy;
const
  POLA: Array [1 .. 7] of String = ('Emerytalne', 'Rentowe', 'Wypadkowe',
    'Fund. Pracy', 'FGSP', 'koszt', 'koszt ³¹czny');
begin
  FormGlowny.SGPracodawca.Show;
  for var I := 1 to 12 do
    FormGlowny.SGPracodawca.Cells[0, I] := FormatSettings.LongMonthNames[I];
  for var K := 1 to 7 do
    FormGlowny.SGPracodawca.Cells[K, 0] := POLA[K];
end;

procedure pokazTbPorownanie;
const
  POLA: Array [1 .. 3] of String = ('2021', '2022', 'Ró¿nica');
begin
  FormGlowny.SGPorownanie.Show;
  for var I := 1 to 12 do
    FormGlowny.SGPorownanie.Cells[0, I] := FormatSettings.LongMonthNames[I];
  for var K := 1 to 3 do
    FormGlowny.SGPorownanie.Cells[K, 0] := POLA[K];
end;

procedure wypelnijTbPracownika(tm: TRoczneKosztyPracownika);
begin
  var
  tab := TRozliczenieRoczne.dajRoczneKosztyPracownikaWLiczbach(tm);
  for var j := 1 to 7 do
    for var l := 1 to 12 do
      FormGlowny.SGPracownik.Cells[j, l] := floatToStr(tab[j, l]);
end;

procedure wypelnijTbPracodawcy(tmp: TRoczneKosztyPracodawcy);
var
  tabP: TTablicaRoczna;
begin
  tabP := TRozliczenieRoczne.dajRoczneKosztyPracodawcyWLiczbach(tmp);
  for var j := 1 to 7 do
    for var l := 1 to 12 do
      FormGlowny.SGPracodawca.Cells[j, l] := floatToStr(tabP[j, l]);
end;

procedure wypelnijPorownanie(tp: TTablicaPorownan);
begin
  for var I := 1 to 3 do
    for var K := 1 to 12 do
      FormGlowny.SGPorownanie.Cells[I, K] := floatToStr(tp[I, K]);
end;

procedure liczIDrukuj(brutto: Double);
var
  Kontroler: TKontroler;
  tp: TTablicaPorownan;
  rok21, rok22: TRozliczenieRoczne;
  tm: TRoczneKosztyPracownika;
  tmp: TRoczneKosztyPracodawcy;
  bruttoZNetto: Double;

begin
  rok21 := TRozliczenieRoczne.create(R2021);
  rok22 := TRozliczenieRoczne.create(R2022);
  Kontroler := TKontroler.create;

  case FormGlowny.CbWybierzKalk.ItemIndex of
    - 1:
      showMessage(BLD_KALK);
    0:
      begin
        FormGlowny.LbPoleTxt.Caption := '';
        tm := Kontroler.dajNetto(brutto, dajKoszt, czyUlgaDo26, rok21); pokazTbPracownika;
        wypelnijTbPracownika(tm);
      end;
    1:
      begin
        FormGlowny.LbPoleTxt.Caption := '';
        tm := Kontroler.dajNetto(brutto, dajKoszt, czyUlgaDo26, rok22); pokazTbPracownika;
        wypelnijTbPracownika(tm);
      end;
    2:
      begin
        FormGlowny.LbPoleTxt.Caption := '';
        pokazTbPorownanie;
        tp := Kontroler.stworzPorownanie(brutto, dajKoszt, czyUlgaDo26, rok21, rok22);
        wypelnijPorownanie(tp);
      end;
    3:
      begin
        FormGlowny.LbPoleTxt.Caption := WIAD_KOSZT_PRACODAWCY;
        tmp := Kontroler.dajKosztyPracodawcy(brutto, rok21.limitZus);
        pokazTbPracodawcy;
        wypelnijTbPracodawcy(tmp);
      end;
    4:
      begin
        FormGlowny.LbPoleTxt.Caption := WIAD_KOSZT_PRACODAWCY;
        tmp := Kontroler.dajKosztyPracodawcy(brutto, rok22.limitZus);
        pokazTbPracodawcy;
        wypelnijTbPracodawcy(tmp);
      end;
    5:
      begin
        pokazTbPracownika;
        bruttoZNetto := Kontroler.dajBrutto(brutto, dajKoszt, czyUlgaDo26, rok21);
        FormGlowny.LbPoleTxt.Caption := floatToStr(bruttoZNetto) + WIAD_NETTO_NA_BRUTTO;
        tm := Kontroler.dajNetto(bruttoZNetto, dajKoszt, czyUlgaDo26, rok21);
        wypelnijTbPracownika(tm);
      end;
    6:
      begin
        pokazTbPracownika;
        bruttoZNetto := Kontroler.dajBrutto(brutto, dajKoszt, czyUlgaDo26, rok22);
        FormGlowny.LbPoleTxt.Caption := floatToStr(bruttoZNetto) + WIAD_NETTO_NA_BRUTTO;
        tm := Kontroler.dajNetto(bruttoZNetto, dajKoszt, czyUlgaDo26, rok22);
        wypelnijTbPracownika(tm);
      end;
  end;
  rok21.Free;
  rok22.Free;
  Kontroler.Free;
end;

procedure TFormGlowny.BtObliczClick(Sender: TObject);

begin
  FormGlowny.SGPracownik.Hide;
  FormGlowny.SGPorownanie.Hide;
  FormGlowny.SGPracodawca.Hide;

  if NbWprowadzKwote.ValueFloat >= 0 then
    liczIDrukuj(NbWprowadzKwote.ValueFloat)
  else
    showMessage(BLD_UJEMNA_KW);
end;

procedure TFormGlowny.FormCreate(Sender: TObject);
begin
  SGPracownik.Show;
end;

end.
