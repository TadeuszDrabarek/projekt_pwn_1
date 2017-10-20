
-- Wypisz imiona i nazwiska uczniów w grupach w bieżącym semestrze
create view v_grupy_i_uczniowie_w_bs as
select s.nazwa nazwa_s,g.nazwa nazwa_g,u.imie,u.nazwisko 
from t_grupy g
inner join t_semestry s on s.id_semestru=g.id_semestru
inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
order by s.nazwa,g.nazwa,u.nazwisko, u.imie;

select * from v_grupy_i_uczniowie_w_bs;

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
#(powinno się uzupełniać w dniu zajęć dla każdych zajęc osobno lub hurtem na cały dzień)
insert into t_zajecia(data_zajec,id_planu,id_nauczyciela,czy_odbyte,czy_odrabiane)
select v.gen_date, p.id_planu, p.id_nauczyciela,0,0
from v_dates v
inner join t_dni_robocze dr on dr.id_dnia=dayofweek(v.gen_date)
inner join t_plany p on p.id_dnia=dayofweek(v.gen_date)
where v.gen_date between '2017-10-20' and '2017-10-20';


-- Zapytanie losowo ustawia obecności na zajęciach uczniów w zadanym okresie
-- musi już być wypełniona tabela z zajęciami !
insert into t_obecnosci(id_zajecia,id_ucznia,czy_obecny) 
select t.id_zajecia,ug.id_ucznia,case when rand()<0.1 then 0 else 1 end as obecnosc
from t_zajecia t
inner join t_plany p on p.id_planu=t.id_planu
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
where 
	ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
    and t.data_zajec between '2017-09-01' and '2017-09-17'
;

select max(id_zajecia) from t_zajecia;

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

-- Utwórz losowo wpisy o wpłatach uczniów w oparciu o ich saldo bieżące
insert into t_wplaty(id_ucznia,kwota,data_zaksiegowania)
select u.id_ucznia,case when rand()<0.7 then sum(v.kwota) else floor(sum(v.kwota)*rand()) end as paid,curdate()
from v_saldo_uczniow v
inner join t_uczniowie u on u.id_ucznia=v.id_ucznia
where u.id_ucznia%3!=0
group by u.id_ucznia
order by u.id_ucznia;

-- Wyświetl saldo rozliczeń uczniów, przy każdym uczniu grupa, z której jest
select concat(u.imie,' ',u.nazwisko) uczen,sum(v.kwota) as saldo 
from v_saldo_uczniow v
inner join t_uczniowie u on u.id_ucznia=v.id_ucznia
group by u.id_ucznia
order by concat(u.imie,' ',u.nazwisko);

-- wyświetl plan tygodniowy zajęć dla wskazanego ucznia i cenę za lekcję
select u.imie, u.nazwisko, dr.nazwa_dnia, p.godzina_rozp, p.godzina_konc, g.nazwa
	, concat(su.cena_std,' PLN') as cena, concat(su.cena_nieob,' PLN') as cena_nieobecnosc
    , d.dlugosc
from t_plany p
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
	and ug.data_od<=curdate() and coalesce(ug.data_do,curdate())>=curdate()
inner join t_grupy g on g.id_grupy=ug.id_grupy
inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia
inner join t_dni_robocze dr on dr.id_dnia=p.id_dnia
inner join v_ile_uczniow_w_grupie vi on vi.id_grupy=ug.id_grupy
inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci
inner join t_stawki_uczniow su on su.data_od<=curdate() and coalesce(su.data_do,curdate())>=curdate()
inner join t_semestry sm on sm.id_semestru=p.id_semestru
	and su.id_dlugosci=p.id_dlugosci and su.liczebnosc_grupy_od<=vi.liczba_uczniow and su.liczebnosc_grupy_do>=vi.liczba_uczniow
where ug.id_ucznia=41
	and sm.data_od<curdate() and coalesce(sm.data_do,curdate())>=curdate()
order by p.id_dnia, p.godzina_rozp;
    
-- wyświetl frekwencję uczniów w zadanym okresie (na ilu lekcjach był, ile opuścił, frekwencja w %)
select u.imselect p.id_planu, p.id_nauczyciela,p.godzina_rozp,p.godzina_konc
	,concat(n.imie,' ',n.nazwisko) as nauczyciel
    ,g.nazwa
from  t_dni_robocze dr 
inner join t_plany p on p.id_dnia=dr.id_dnia
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_grupy g on g.id_grupy=p.id_grupy
where dr.id_dnia=dayofweek('2017-10-19')
order by p.id_nauczyciela,p.godzina_rozpie, u.nazwisko, sum(o.czy_obecny) obecnosci, sum(1-o.czy_obecny) nieobecnosci
	, round((sum(o.czy_obecny)/count(o.czy_obecny))*100.00,2) as "frekwencja_%"
from t_obecnosci o
inner join t_zajecia z on z.id_zajecia=o.id_zajecia
inner join t_uczniowie u on u.id_ucznia=o.id_ucznia
where z.data_zajec between '2017-09-01' and '2017-09-15' 
group by u.imie, u.nazwisko
;
-- wyświetla listę zajęc jakie wg. planu ramowego powinny odbyć się wybranego dnia

create or replace view v_plan_ramowy_dzien as
select p.id_planu, p.id_nauczyciela,p.godzina_rozp,p.godzina_konc
	,concat(n.imie,' ',n.nazwisko) as nauczyciel
    ,g.nazwa
    ,dr.id_dnia
    ,v.gen_date
    ,p.id_semestru
    ,p.id_grupy
from  t_dni_robocze dr 
inner join t_plany p on p.id_dnia=dr.id_dnia
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_grupy g on g.id_grupy=p.id_grupy
inner join v_dates v on dr.id_dnia=dayofweek(v.gen_date)
inner join t_semestry s on s.id_semestru=p.id_semestru and s.data_od<=v.gen_date and coalesce(s.data_do,v.gen_date)>v.gen_date
#where dr.id_dnia=dayofweek('2017-10-19')
order by p.id_nauczyciela,p.godzina_rozp;

select * from v_plan_ramowy_dzien where gen_date='2017-10-19';

-- zapytanie wyświetla listę zajęć danego dnia wraz ze szczególami
create or replace view v_view_plan as
select z.id_zajecia, p.id_nauczyciela, p.godzina_rozp, p.godzina_konc
	,concat(n.imie,' ',n.nazwisko) as nauczyciel_real
    ,concat(n0.imie,' ',n0.nazwisko) as nauczyciel_plan
    ,g.nazwa
    ,v.liczba_uczniow
    ,z.data_zajec
    ,z.data_odrabiania
    ,coalesce(z.data_odrabiania,z.data_zajec) as data_zajec_real
    ,p.id_planu
    ,p.id_semestru
    ,p.id_grupy
from t_zajecia z
inner join t_plany p on p.id_planu=z.id_planu
inner join t_nauczyciele n on n.id_nauczyciela=z.id_nauczyciela
inner join t_nauczyciele n0 on n0.id_nauczyciela=p.id_nauczyciela
inner join t_grupy g on g.id_grupy=p.id_grupy
inner join v_ile_uczniow_w_grupie v on v.id_grupy=p.id_grupy;


select *
from v_plan_ramowy_dzien vp
left join v_view_plan vr on vr.id_planu=vp.id_planu and vr.data_zajec_real=vp.gen_date
where vp.gen_date='2017-10-19' or vr.data_zajec_real='2017-10-19'
;
select vp.*,vr.*
from v_plan_ramowy_dzien vp
left join v_view_plan vr on vr.id_planu=vp.id_planu and vr.data_zajec_real=vp.gen_date
where vp.gen_date='2017-10-19' 
union
select vp.*,vr.*
from v_view_plan vr 
left join v_plan_ramowy_dzien vp on vr.id_planu=vp.id_planu and vr.data_zajec_real=vp.gen_date
where vr.data_zajec_real='2017-10-19';

-- zapytanie zwraca szczegóły lekcji z dnia dzisiejszego
select id_zajecia,id_nauczyciela,godzina_rozp,godzina_konc,nauczyciel_real,vr.nazwa
, case when nauczyciel_plan<>nauczyciel_real then 'TAK' else 'NIE' end as zastepstwo
, case when data_odrabiania='2017-10-19' then 'Przesunięta na dziś' 
       when data_odrabiania is not null then 'Przesunięte z dziś' 
       else 'W terminie' end as status 
, case when data_zajec='2017-10-19' and data_zajec<>data_zajec_real then vr.data_zajec_real  
       when data_zajec_real='2017-10-19' and data_zajec<>data_zajec_real then data_zajec 
       else '' end as przeniesione_z_na
 from v_view_plan vr 
where vr.data_zajec_real='2017-10-19' or vr.data_zajec='2017-10-19'
order by godzina_rozp;
