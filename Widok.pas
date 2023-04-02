unit Widok;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  BruttoNaNetto, UnitMiesieczne, PorownanieRozliczen,
  KalkulatorKosztowPracodawcy, NettoNaBrutto,
  Vcl.Grids, UnitMiesiaceRoku, UnitMiesiecznePracodawcy, Vcl.NumberBox, UnitDaneRoczne;

const
  ZUS_LIMIT_21 = 157770;
  ZUS_LIMIT_22 = 177660;
  KWOTA_MN = 250;
  KWOTA_WK = 300;
  BLD_KALK = 'Wybierz kalkulator dla obliczenia';
  BLD_UJEMNA_KW = 'Podana kwota nie mo¿e byæ liczb¹ mniejsz¹ od 0 z³.';
  WIAD_NETTO_NA_BRUTTO =
  ' z³: kwota dla stycznia. Tabela przedstawia netto dla pozosta³ych miesiêcy.';
  WIAD_KOSZT_PRACODAWCY =
  'UWAGA! Po przekroczeniu rocznego limitu sk³adek ZUS mog¹ wyst¹piæ b³êdy.';

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
  tm: tablicaMiesiecy;
  tmp: roczneKosztyPracodawcy;
  tp: tablicaPorownan;
  k_przychodu: Double;
  ulgaDo26: Boolean;
  bruttoZNetto: Double;

implementation

{$R *.dfm}

procedure ustawKoszt;
begin
  if (FormGlowny.RgZamieszkanie.ItemIndex = 0) then
    k_przychodu := KWOTA_MN
  else
    k_przychodu := KWOTA_WK;
end;

procedure pokazTbPracownika;
const
  POLA: Array [1 .. 7] of String = ('Emerytalne', 'Rentowe', 'Chorobowe',
    'Podstawa PIT', 'zaliczka PIT', 'Zdrowotne', 'Netto');
  begin
    FormGlowny.SgPracownik.Show;
    for var I := 1 to 12 do
      FormGlowny.SgPracownik.Cells[0, I] := MIESIACE_ROKU[I];
    for var K := 1 to 7 do
      FormGlowny.SgPracownik.Cells[K, 0] := POLA[K];
  end;

procedure pokazTbPracodawcy;
const
  POLA: Array [1 .. 7] of String = ('Emerytalne', 'Rentowe', 'Wypadkowe',
    'Fund. Pracy', 'FGSP', 'koszt', 'koszt ³¹czny');
  begin
    FormGlowny.SGPracodawca.Show;
    for var I := 1 to 12 do
      FormGlowny.SGPracodawca.Cells[0, I] := MIESIACE_ROKU[I];
    for var K := 1 to 7 do
      FormGlowny.SGPracodawca.Cells[K, 0] := POLA[K];
  end;

procedure pokazTbPorownanie;
const
  POLA: Array [1 .. 3] of String = ('2021','2022','Ró¿nica' );
  begin
    FormGlowny.SgPorownanie.Show;
    for var I := 1 to 12 do
      FormGlowny.SgPorownanie.Cells[0, I] := MIESIACE_ROKU[I];
    for var K := 1 to 3 do
      FormGlowny.SgPorownanie.Cells[K, 0] := POLA[K];
  end;

procedure wypelnijTbPracownika;
begin
  var
  tab := UnitMiesieczne.toArrayOfString(tm);
  for var j := 1 to 7 do
    for var l := 1 to 12 do
      FormGlowny.SgPracownik.Cells[j, l] := floatToStr(tab[j, l]);
end;

procedure wypelnijTbPracodawcy;
var tabP: txtTablicaMiesiecy;
begin
  tabP := UnitMiesiecznePracodawcy.toArrayOfString(tmp);
  for var j := 1 to 7 do
    for var l := 1 to 12 do
      FormGlowny.SGPracodawca.Cells[j, l] := floatToStr(tabP[j, l]);
end;

procedure wypelnijPorownanie(brutto, k_przychodu: Double; ulgaDo26: Boolean; rok21, rok22: Rok);
var tp : tablicaPorownan;
begin
  tp := stworzPorownanie(brutto, k_przychodu, ulgaDo26, rok21, rok22);
for var i := 1 to 3 do
  for var k := 1 to 12 do
    FormGlowny.SgPorownanie.Cells[i, k] := floatToStr(tp[i, k]);
end;

procedure liczIDrukuj(brutto: Double);

begin
  var rok21 := Rok.daj21;
  var rok22 := Rok.daj22;

  case FormGlowny.CbWybierzKalk.ItemIndex of
    -1:
      showMessage(BLD_KALK);
    0:
      begin
        FormGlowny.LbPoleTxt.Caption := '';
        tm := stworzTablice(brutto, k_przychodu, ulgaDo26, rok21);
        pokazTbPracownika;
        wypelnijTbPracownika;
      end;
    1:
      begin
        FormGlowny.LbPoleTxt.Caption := '';
        tm := stworzTablice(brutto, k_przychodu, ulgaDo26, rok22);
        pokazTbPracownika;
        wypelnijTbPracownika;
      end;
    2:
      begin
        FormGlowny.LbPoleTxt.Caption := '';
        pokazTbPorownanie;
        wypelnijPorownanie(brutto, k_przychodu, ulgaDo26, rok21, rok22);
      end;
    3:
      begin
        FormGlowny.LbPoleTxt.Caption := WIAD_KOSZT_PRACODAWCY;
        tmp := KosztPracodawcy.create(brutto, ZUS_LIMIT_21).tabMsc;
        pokazTbPracodawcy;
        wypelnijTbPracodawcy;
      end;
    4:
      begin
        FormGlowny.LbPoleTxt.Caption := WIAD_KOSZT_PRACODAWCY;
        tmp := KosztPracodawcy.create(brutto, ZUS_LIMIT_22).tabMsc;
        pokazTbPracodawcy;
        wypelnijTbPracodawcy;
      end;
    5:
      begin
        pokazTbPracownika;
        bruttoZNetto := NettoNaBrutto.dajBrutto(brutto, k_przychodu,
          ulgaDo26, rok21);
        FormGlowny.LbPoleTxt.Caption := floatToStr(bruttoZNetto) + WIAD_NETTO_NA_BRUTTO;
        tm := stworzTablice(bruttoZNetto, k_przychodu, ulgaDo26, rok21);
         wypelnijTbPracownika;
      end;
    6:
      begin
        pokazTbPracownika;
        bruttoZNetto := NettoNaBrutto.dajBrutto(brutto, k_przychodu,
          ulgaDo26, rok22);
        FormGlowny.LbPoleTxt.Caption := floatToStr(bruttoZNetto) + WIAD_NETTO_NA_BRUTTO;
        tm := stworzTablice(bruttoZNetto, k_przychodu, ulgaDo26, rok22);
         wypelnijTbPracownika;
      end;
  end;
end;

procedure TFormGlowny.BtObliczClick(Sender: TObject);

begin
  ustawKoszt;

    FormGlowny.SgPracownik.Hide;
    FormGlowny.SgPorownanie.Hide;
    FormGlowny.SGPracodawca.Hide;

  if CbUlga26.Checked then
       ulgaDo26:= true
  else ulgaDo26:= false;

if NbWprowadzKwote.ValueFloat >= 0 then
  liczIDrukuj(NbWprowadzKwote.ValueFloat)
else
 ShowMessage(BLD_UJEMNA_KW);
end;

procedure TFormGlowny.FormCreate(Sender: TObject);
begin
 SgPracownik.Show;
end;

end.
