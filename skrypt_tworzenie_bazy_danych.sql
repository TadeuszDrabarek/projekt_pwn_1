-- *** Tworzenie bazy danych ***
drop database if exists pwn_projekt_szkola;  -- jeżeli istnieje to usuwanie
create database pwn_projekt_szkola;

-- Przełączanie na utworzoną bazę danych
use pwn_projekt_szkola_test;

-- *** Tworzenie struktur danych ***
-- tabela uczniowie
drop table if exists t_uczniowie;
create table t_uczniowie(
	id_ucznia		int primary key auto_increment,
    imie			varchar(50),
    nazwisko		varchar(50),
    adres			text
);

-- tabela nauczyciele
drop table if exists t_nauczyciele;
create table t_nauczyciele(
	id_nauczyciela	int primary key auto_increment,
    imie			varchar(50),
    nazwisko		varchar(50),
    adres			text,
    numer_konta		varchar(50)
);

-- tabela z semestrami
drop table if exists t_semestry;
create table t_semestry(
	id_semestru		int primary key auto_increment,
    data_od			date not null,
    data_do			date not null,
    nazwa			varchar(50),
    check (data_do > data_od or data_do is null)
);

-- tabela defiuniująca grupy zajęciowe
drop table if exists t_grupy;
create table t_grupy(
	id_grupy		int primary key auto_increment,
    nazwa			varchar(50),
    id_semestru		int,
    foreign key (id_semestru) references t_semestry(id_semestru)
);

-- tabela przypisująca uczniów do grupy
drop table if exists t_uczniowe_w_grupie;
create table t_uczniowe_w_grupie(
	id_ucznia		int,
    id_grupy		int,
    data_od			date not null,
    data_do			date default null,
    primary key (id_ucznia,id_grupy),
    foreign key (id_ucznia) references t_uczniowie(id_ucznia),
	foreign key (id_grupy) references t_grupy(id_grupy),	
    check (data_do > data_od or data_do is null)
);

-- tabela pomocnicza (słownikowa) z dniami roboczymi
drop table if exists t_dni_robocze;
create table t_dni_robocze(
	id_dnia			int primary key,
    nazwa_dnia 		varchar(50)
);


-- tabela pomocnicza (słownikowa) z długośiami lekcji
drop table if exists t_dlugosci;
create table t_dlugosci(
	id_dlugosci 	int primary key auto_increment,
    dlugosc			varchar(50),
    dlg				int
);

-- tabela z definicjami planów zajęć
drop table if exists t_plany;
create table t_plany(
	id_planu		int primary key auto_increment,
    id_grupy		int,
    id_dnia			int,
    id_dlugosci     int,
    godzina_rozp	time,
    godzina_konc	time,
    data_od			date not null,
    data_do			date not null,
    id_semestru		int,
    id_nauczyciela	int,
    foreign key (id_grupy) references t_grupy(id_grupy),
    foreign key (id_dnia) references t_dni_robocze(id_dnia),
    foreign key (id_dlugosci) references t_dlugosci(id_dlugosci),
    foreign key (id_semestru) references t_semestry(id_semestru),
    foreign key (id_nauczyciela) references t_nauczyciele(id_nauczyciela),
    check (data_do > data_od)
);

-- tabela określająca wysokości opłaty za lekcje dla uczniów
drop table if exists t_stawki_uczniow;
create table t_stawki_uczniow(
	id_stawki		int primary key auto_increment,
    data_od			date not null,
    data_do			date,
    id_dlugosci		int,
    cena_std		float,
    cena_nieob		float default null,
    stawka_podatku	float not null,
    liczebnosc_grupy_od	int not null,
    liczebnosc_grupy_do	int not null,
    foreign key (id_dlugosci) references t_dlugosci(id_dlugosci),
    check (data_do > data_od or data_do is null)
);

-- Tabela ze stawkami dla nauczycieli
drop table if exists t_stawki_nauczycieli;
create table t_stawki_nauczycieli(
	id_stawki		int primary key auto_increment,
    data_od			date not null,
    data_do			date,
    id_dlugosci		int,
    cena_std		float,
    cena_nieob		float default 0,
    cena_zast		float,
    stawka_podatku	float,
    liczebnosc_grupy_od	int not null,
    liczebnosc_grupy_do	int not null,
    foreign key (id_dlugosci) references t_dlugosci(id_dlugosci),
    check (data_do > data_od or data_do is null)
);

-- Tabela z konkretnym planem zajęć na semestr
drop table if exists t_zajecia;
create table t_zajecia(
	id_zajecia		int primary key auto_increment,
    id_planu		int,
    data_zajec		date not null,
    godzina_zajec	time,
    czy_odbyte		int,
    czy_odrabiane	int,
    data_odrabiania	date,
    godzina_odrabiania	time,
    id_nauczyciela	int,
    foreign key (id_planu) references t_plany(id_planu),
    foreign key (id_nauczyciela) references t_nauczyciele(id_nauczyciela),
    check (czy_odbyte in (0, 1)),
    check (czy_odrabiane in (0, 1)),
    check (   data_odrabiania is null and czy_odrabiane=0 
           or data_odrabiania is not null and czy_odrabiane=1)    
);
alter table t_zajecia add constraint unique(id_planu,data_zajec);

-- Tabela z obecnościami uczniów
drop table if exists t_obecnosci;
create table t_obecnosci(
	id_obecnosci	int primary key auto_increment,
    id_zajecia		int,
    id_ucznia		int,
    czy_obecny		int,
    foreign key (id_zajecia) references t_zajecia(id_zajecia),
    foreign key (id_ucznia) references t_uczniowie(id_ucznia),
    check (czy_obecny in (0, 1))
);
alter table t_obecnosci add constraint unique(id_zajecia,id_ucznia);

-- Tabela z rozliczeniami uczniów
drop table if exists t_rozliczenia_uczniow;
create table t_rozliczenia_uczniow(
	id_rozliczenia	int primary key auto_increment,
    id_ucznia		int,
    data_utworzenia	date,
    id_zajecia		int,
    data_zobowiazania	date,
    kwota_netto		float not null,
    kwota_brutto	float,
    podatek			float,
    foreign key (id_ucznia) references t_uczniowie(id_ucznia),
    foreign key (id_zajecia) references t_zajecia(id_zajecia),
    unique (id_ucznia,id_zajecia)
);

-- Tabela z rozliczeniami nauczycieli
drop table if exists t_rozliczenia_nauczycieli;
create table t_rozliczenia_nauczycieli(
	id_rozliczenia	int primary key auto_increment,
    id_nauczyciela		int,
    data_utworzenia	date,
    id_zajecia		int,
    data_zobowiazania	date,
    kwota_netto		float not null,
    kwota_brutto	float,
    podatek			float,
    foreign key (id_nauczyciela) references t_nauczyciele(id_nauczyciela),
    foreign key (id_zajecia) references t_zajecia(id_zajecia),
    unique (id_nauczyciela,id_zajecia)
);

-- Tabela z wpłatami uczniów
drop table if exists t_wplaty;
create table t_wplaty(
	id_wplaty		int primary key auto_increment,
    data_zaksiegowania	date not null,
    kwota			float not null,
    id_ucznia		int not null,
    foreign key (id_ucznia) references t_uczniowie(id_ucznia)
);

-- Tabela z wypłatami dla nauczycieli
drop table if exists t_wyplaty;
create table t_wyplaty(
	id_wyplaty		int primary key auto_increment,
    data_operacji	date not null,
    kwota			float not null,
    id_nauczyciela	int not null,
    foreign key (id_nauczyciela) references t_nauczyciele(id_nauczyciela)
);

-- Widok z rozliczeniem uczniów (należności-wpaty)
create or replace view v_saldo_uczniow as 
	select data_zaksiegowania as data_operacji, -kwota as kwota, id_ucznia from t_wplaty
    union
    select data_zobowiazania, kwota_brutto, id_ucznia from t_rozliczenia_uczniow;


-- Widok z rozliczeniem nauczycieli (należności-wpaty)
drop view if exists saldo_nauczycieli;
create or replace view v_saldo_nauczycieli as 
	select data_operacji as data_operacji, -kwota as kwota, id_nauczyciela from t_wyplaty
    union
    select data_zobowiazania, kwota_brutto, id_nauczyciela from t_rozliczenia_nauczycieli;

create or replace view v_ile_uczniow_w_grupie as
select id_grupy,count(*) as liczba_uczniow from t_uczniowe_w_grupie 
where data_od<=curdate() and coalesce(data_do,curdate())>=curdate()
group by id_grupy;

-- Widok generujący daty z zadanego przedziału
create or replace view v_dates as 
select gen_date from 
(select adddate('1970-01-01',t4*10000 + t3*1000 + t2*100 + t1*10 + t0) gen_date from
 (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
 (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
 (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
 (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
 (select 0 t4 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
where gen_date between '2017-01-01' and '2111-12-31';


-- Widok zwraca szczegóły obecności na zajęciach wraz z datami zajęć i info o tym czy było zastepstwo i czy zajecia są odrabiane
create or replace view v_obecnosci_det as
select o.id_obecnosci,o.id_ucznia,o.czy_obecny,ug.id_grupy
		, d.id_dlugosci
        , d.dlugosc
        , z.data_zajec as data_zajec_oczekiwana
        , z.data_odrabiania as data_zajec_odrabiana
        , z.id_nauczyciela as id_nauczyciela_oczekiwanego
        , p.id_nauczyciela as id_nauczyciela_real
        , o.id_zajecia
		, count(ug.id_ucznia) spodziewana_liczba_uczniow
	from t_obecnosci o
	inner join t_zajecia z on z.id_zajecia=o.id_zajecia
	inner join t_plany p on p.id_planu=z.id_planu
	inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
		and ug.data_od<=z.data_zajec and coalesce(ug.data_do,z.data_zajec)>=z.data_zajec
	inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci    
	group by o.id_obecnosci,o.id_ucznia,o.czy_obecny,ug.id_grupy,d.id_dlugosci,d.dlugosc,coalesce(z.data_odrabiania,z.data_zajec),o.id_zajecia,z.data_odrabiania,z.id_nauczyciela,p.id_nauczyciela;
    
    
    
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


-- tabele do obsłgi aplikacji w Pythonie
-- tabela z rolami uzytkowników
create table app_role(
	roleid varchar(10) primary key,
    rolename varchar(100)
);

-- tabela z użytkownikami
create table app_users(
	userid integer auto_increment primary key,
    login varchar(100) not null,
    email varchar(100) not null,
    pass varchar(32) not null,
    indactive integer default 1,
    datcre date,
    usercre integer,
    username varchar(100),
    roleid varchar(10) ,
    foreign key (usercre) references app_users(userid),
    foreign key (releid) references app_role(roleid),
    check (ind_active in (0,1))
);

-- tabela z opcjami w menu
create table app_menu(
	menuid varchar(10)  primary key,
    pos integer default 1,
    caption varchar(50) not null,
    description varchar(400),
    parent varchar(10),
    foreign key (parent) references app_menu(menuid)
);

-- tabela z przypisaniem uprawnień do opcji w menu
create table app_menu_role(
	menuid varchar(10),
    roleid varchar(10),
    primary key (menuid,roleid)
);

-- tabela z ramowym planem zajęć na dany dzień
create or replace view v_plan_ramowy_dzien as
select p.id_planu, p.id_nauczyciela,p.godzina_rozp,p.godzina_konc
	,concat(n.imie,' ',n.nazwisko) as nauczyciel
    ,g.nazwa
    ,dr.id_dnia
    ,v.gen_date
from  t_dni_robocze dr 
inner join t_plany p on p.id_dnia=dr.id_dnia
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_grupy g on g.id_grupy=p.id_grupy
inner join v_dates v on dr.id_dnia=dayofweek(v.gen_date)
inner join t_semestry s on s.id_semestru=p.id_semestru and s.data_od<=v.gen_date and coalesce(s.data_do,v.gen_date)>v.gen_date
order by p.id_nauczyciela,p.godzina_rozp;