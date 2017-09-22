select * from t_semestry;

select * from t_nayczyciele;

select * from t_dni_robocze;

select * from t_dlugosci;

select * from t_grupy;

select * from t_plany;

select * from v_ile_uczniow_w_grupie;

delete from t_dni_robocze where id_dnia=8;

select * 
from t_plany t;

select * from t_obecnosci;


select *
from hockey_stats
where date(game_date) between date('2012-11-03') and date('2012-11-05')
order by game_date desc;

select ;

create or replace view v_dates as 
select gen_date from 
(select adddate('1970-01-01',t4*10000 + t3*1000 + t2*100 + t1*10 + t0) gen_date from
 (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
 (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
 (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
 (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
 (select 0 t4 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
where gen_date between '2017-01-01' and '2111-12-31';


insert into t_obecnosci(id_zajecia,id_ucznia,czy_obecny) 
select t.id_zajecia,ug.id_ucznia,case when rand()<0.1 then 0 else 1 end as obecnosc
from t_zajecia t
inner join t_plany p on p.id_planu=t.id_planu
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
where 
	ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
    and t.data_zajec between '2017-09-01' and '2017-09-15'
;


select * from t_zajecia;

-- Lista obecności uczniów na danych zajęciach, wraz z kwotami do zapłaty za tę lekcję
select a.id_zajecia,coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana) as data_zajec_real 
	, a.czy_obecny
	, concat(u.imie,' ',u.nazwisko) as uczen
    , g.nazwa
	, case when a.czy_obecny then su.cena_std else su.cena_nieob end as do_zaplaty 
from v_obecnosci_det a
inner join t_stawki_uczniow su 
	on su.liczebnosc_grupy_od<=a.spodziewana_liczba_uczniow
    and su.liczebnosc_grupy_do>=a.spodziewana_liczba_uczniow
    and su.data_od<=coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana) 
    and coalesce(su.data_do,coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana))>=coalesce(a.data_zajec_odrabiana,a.data_zajec_oczekiwana)
    and su.id_dlugosci=a.id_dlugosci
inner join t_uczniowie u on u.id_ucznia=a.id_ucznia    
inner join t_grupy g on g.id_grupy=a.id_grupy
where a.id_zajecia=9    
;

select * from v_obecnosci_det where id_zajecia=17;

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
where a.id_zajecia between 2 and 50    
;


select * from t_rozliczenia_uczniow;


insert into t_zajecia(data_zajec,id_planu,id_nauczyciela,czy_odbyte,czy_odrabiane)
select v.gen_date, p.id_planu, p.id_nauczyciela,1,0
from v_dates v
inner join t_dni_robocze dr on dr.id_dnia=dayofweek(v.gen_date)
inner join t_plany p on p.id_dnia=dayofweek(v.gen_date)
where v.gen_date between '2017-09-01' and '2017-09-15';


select max(id_zajecia) from t_zajecia;
-- 64

select max(id_obecnosci) from t_obecnosci;
-- 497

-- Utwórz losowo wpisy o wpłatach uczniów
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