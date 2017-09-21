
-- Wypisz imiona i nazwiska uczniów w grupach w bieżącym semestrze
select s.nazwa,g.nazwa,u.imie,u.nazwisko 
from t_grupy g
inner join t_semestry s on s.id_semestru=g.id_semestru
inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
order by s.nazwa,g.nazwa,u.nazwisko, u.imie;

-- Wypisz ile uczniów jest w grupach w bieżącym semestrze (na dziś)
-- oraz jaka jest stawka za lekcję dla ucznia w tej grupie (zależy od liczebności grupy!)
-- oraz jaki jest dochód od uczniów (zał., że wszyscy przyjdą)
-- oraz jaki jest koszt nauczyciela (zał., ze bez zastepstwa)
-- oraz jaka jest róznica między przychodem od uczniów a kosztem nauczyciela
-- to wszystko w zalezności od dlugości trwania lekcji
select a.*,concat(su.cena_std,' PLN') as cena_dla_ucznia, d.dlugosc
	, concat(sn.cena_std,' PLN') as koszt_nauczyciela
    , concat(a.liczba_uczniow*su.cena_std,' PLN') as przychod_od_uczniow
    , concat(a.liczba_uczniow*su.cena_std-sn.cena_std,' PLN') as bilans
from  (
	select g.nazwa,count(*) as liczba_uczniow
	from t_grupy g
	inner join t_semestry s on s.id_semestru=g.id_semestru
	inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
	inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
	where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
	and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
	group by g.nazwa
) a
inner join t_stawki_uczniow su 
	on 
		su.liczebnosc_grupy_od<=a.liczba_uczniow 
        and su.liczebnosc_grupy_do>=a.liczba_uczniow
        and su.data_od<=curdate() and coalesce(su.data_do,curdate())>=curdate()
inner join t_stawki_nauczycieli sn
	on
		sn.liczebnosc_grupy_od<=a.liczba_uczniow 
        and sn.liczebnosc_grupy_do>=a.liczba_uczniow
        and sn.data_od<=curdate() and coalesce(sn.data_do,curdate())>=curdate()
inner join t_dlugosci d 
	on d.id_dlugosci=su.id_dlugosci        
		and d.id_dlugosci=sn.id_dlugosci        
order by a.nazwa, d.dlugosc;




-- Wypisz ile uczniów jest w grupach w bieżącym semestrze (na dziś)
-- oraz jaki jest dochód od uczniów (zał., że przyjdzie tylko jeden)
-- oraz jaki jest koszt nauczyciela (zał., ze będzie zastepstwo)
-- oraz jaka jest róznica między przychodem od uczniów a kosztem nauczyciela
-- to wszystko w zalezności od dlugości trwania lekcji
select a.*, d.dlugosc
	, concat(sn.cena_zast,' PLN') as koszt_nauczyciela
    , concat((a.liczba_uczniow-1)*su.cena_nieob+su.cena_std,' PLN') as przychod_od_uczniow
    , concat((a.liczba_uczniow-1)*su.cena_nieob+su.cena_std-sn.cena_zast,' PLN') as bilans
from  (
	select g.nazwa,count(*) as liczba_uczniow
	from t_grupy g
	inner join t_semestry s on s.id_semestru=g.id_semestru
	inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
	inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
	where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
	and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
	group by g.nazwa
) a
inner join t_stawki_uczniow su 
	on 
		su.liczebnosc_grupy_od<=a.liczba_uczniow 
        and su.liczebnosc_grupy_do>=a.liczba_uczniow
        and su.data_od<=curdate() and coalesce(su.data_do,curdate())>=curdate()
inner join t_stawki_nauczycieli sn
	on
		sn.liczebnosc_grupy_od<=a.liczba_uczniow 
        and sn.liczebnosc_grupy_do>=a.liczba_uczniow
        and sn.data_od<=curdate() and coalesce(sn.data_do,curdate())>=curdate()
inner join t_dlugosci d 
	on d.id_dlugosci=su.id_dlugosci        
		and d.id_dlugosci=sn.id_dlugosci        
order by a.nazwa, d.dlugosc;


-- Wyświetl plan zajęć na cały tydzień po kolei dla wszystkich nauczycieli
# w bieżącym semestrze
# na bieżący tydzień
select concat(n.imie,' ',n.nazwisko) as imie_nazwisko
	, dr.nazwa_dnia
	, p.godzina_rozp, d.dlugosc, p.godzina_konc
    , g.nazwa
    , vi.liczba_uczniow
from t_plany p
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_dni_robocze dr on dr.id_dnia=p.id_dnia
inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci
inner join t_grupy g on g.id_grupy=p.id_grupy
inner join t_semestry s on s.id_semestru=p.id_semestru
inner join v_ile_uczniow_w_grupie vi on vi.id_grupy=p.id_grupy
where
	p.data_od<=curdate() and coalesce(p.data_do,curdate())>=curdate()
    and s.data_od<=curdate() and coalesce(s.data_do,curdate())>=curdate()
order by p.id_nauczyciela, p.id_dnia, p.godzina_rozp;
	
-- Wyświetl ile lekcji tygodniowo ma każdy z nauczycieli
# w rozbiciu na długości lekcji
# ile zarobi za te lekcje
select concat(n.imie,' ',n.nazwisko) as imie_nazwisko
	, d.dlugosc #, p.id_planu 
    , sum(sn.cena_std) as ile_zarobi_za_te_lekcje
from t_plany p
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci
inner join v_ile_uczniow_w_grupie vi on vi.id_grupy=p.id_grupy
inner join t_stawki_nauczycieli sn on sn.id_dlugosci=p.id_dlugosci 
	and vi.liczba_uczniow>=sn.liczebnosc_grupy_od
    and vi.liczba_uczniow<=sn.liczebnosc_grupy_do
group by concat(n.imie,' ',n.nazwisko), d.dlugosc;

# roboczy do porównania czy dobrze się sumuje
select concat(n.imie,' ',n.nazwisko) as imie_nazwisko
	, d.dlugosc, p.id_planu 
    , sn.cena_std
from t_plany p
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci
inner join v_ile_uczniow_w_grupie vi on vi.id_grupy=p.id_grupy
inner join t_stawki_nauczycieli sn on sn.id_dlugosci=p.id_dlugosci 
	and vi.liczba_uczniow>=sn.liczebnosc_grupy_od
    and vi.liczba_uczniow<=sn.liczebnosc_grupy_do;

-- Wyświetl ile każdy z nauczycieli zarobi w tygodniu
select concat(n.imie,' ',n.nazwisko) as imie_nazwisko
    , sum(sn.cena_std) as ile_zarobi_za_te_lekcje
from t_plany p
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci
inner join v_ile_uczniow_w_grupie vi on vi.id_grupy=p.id_grupy
inner join t_stawki_nauczycieli sn on sn.id_dlugosci=p.id_dlugosci 
	and vi.liczba_uczniow>=sn.liczebnosc_grupy_od
    and vi.liczba_uczniow<=sn.liczebnosc_grupy_do
group by concat(n.imie,' ',n.nazwisko);


-- Zapytanie uzupełnia tabelę z zajęciami w zadanym okresie dat
insert into t_zajecia(data_zajec,id_planu,id_nauczyciela,czy_odbyte,czy_odrabiane)
select v.gen_date, p.id_planu, p.id_nauczyciela,1,0
from v_dates v
inner join t_dni_robocze dr on dr.id_dnia=dayofweek(v.gen_date)
inner join t_plany p on p.id_dnia=dayofweek(v.gen_date)
where v.gen_date between '2017-09-01' and '2017-09-15';


-- Zapytanie losowo ustawia obecności na zajęciach uczniów w zadanym okresie
-- musi już być wypełniona tabela z zajęciami !
insert into t_obecnosci(id_zajecia,id_ucznia,czy_obecny) 
select t.id_zajecia,ug.id_ucznia,case when rand()<0.1 then 0 else 1 end as obecnosc
from t_zajecia t
inner join t_plany p on p.id_planu=t.id_planu
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
where 
	ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
    and t.data_zajec between '2017-09-01' and '2017-09-15'
;


-- Zapytanie wstawia wpisy do tabli z rozliczeniami uczniów za podane zajęcia
insert into t_rozliczenia_uczniow(id_zajecia, id_ucznia, data_utworzenia, data_zobowiazania, kwota_netto,podatek,kwota_brutto)
select a.id_zajecia
	, a.id_ucznia
    , curdate() as data_wpisu
	, coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana) as data_zobowiazania
	, case when a.czy_obecny then su.cena_std else su.cena_nieob end as do_zaplaty_netto
    , (case when a.czy_obecny then su.cena_std else su.cena_nieob end)*su.stawka_podatku/100.00
    , (case when a.czy_obecny then su.cena_std else su.cena_nieob end)*(1.00+su.stawka_podatku/100.00) as do_zaplaty_brutto
from v_obecnosci_det a
inner join t_stawki_uczniow su 
	on su.liczebnosc_grupy_od<=a.spodziewana_liczba_uczniow
    and su.liczebnosc_grupy_do>=a.spodziewana_liczba_uczniow
    and su.data_od<=coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana) 
    and coalesce(su.data_do,coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana))>=coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana)
    and su.id_dlugosci=a.id_dlugosci
inner join t_uczniowie u on u.id_ucznia=a.id_ucznia    
inner join t_grupy g on g.id_grupy=a.id_grupy
where a.id_zajecia between 1 and 50
;