-- *** Tworzenie bazy danych ***
drop database if exists pwn_projekt_szkola;  -- jeżeli istnieje to usuwanie
create database pwn_projekt_szkola;

-- Przełączanie na utworzoną bazę danych
use pwn_projekt_szkola;

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
    date_do			date default null,
    primary key (id_ucznia,id_grupy),
    foreign key (id_ucznia) references t_uczniowie(id_ucznia),
    foreign key (id_ucznia) references t_uczniowie(id_ucznia),
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
	id_dlugosci 	int primary key,
    dlugosc			varchar(50)
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
    foreign key (id_dlugosci) references t_dlugosci(id_dlugosci),
    check (data_do > data_od or data_do is null)
);

-- Tabela z konkretnym planem zajęć na semestr
drop table if exists t_zajecia;
create table t_zajecia(
	id_zajecia		int primary key auto_increment,
    id_planu		int,
    data_zajec		date not null,
    czy_odbyte		int,
    czy_odrabiane	int,
    data_odrabiania	date,
    id_nauczyciela	int,
    foreign key (id_planu) references t_plany(id_planu),
    foreign key (id_nauczyciela) references t_nauczyciele(id_nauczyciela),
    check (czy_odbyte in (0, 1)),
    check (czy_odrabiane in (0, 1)),
    check (   data_odrabiania is null and czy_odrabiane=0 
           or data_odrabiania is not null and czy_odrabiane=1)    
);

-- Tabela z obecnościami uczniów
drop table if exists t_obecnosci;
create table t_obecnosci(
	id_obecnosci	int primary key auto_increment,
    id_zajecia		int,
    czy_obecny		int,
    foreign key (id_zajecia) references t_zajecia(id_zajecia),
    check (czy_obecny in (0, 1))
);

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
    foreign key (id_zajecia) references t_zajecia(id_zajecia)
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
    foreign key (id_zajecia) references t_zajecia(id_zajecia)
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
create or replace view v_saldo_nauczycieli as 
	select data_operacji as data_operacji, -kwota as kwota, id_nauczyciela from t_wyplaty
    union
    select data_zobowiazania, kwota_brutto, id_nauczyciela from t_rozliczenia_nauczycieli;


