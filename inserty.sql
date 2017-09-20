-- semestry
insert into t_semestry(data_od,data_do,nazwa) values('2017-09-01','2018-01-31','ZIMA2017-2018');


-- długości lekcji
insert into t_dlugosci(dlugosc, dlg) values ('45 minut',45);
insert into t_dlugosci(dlugosc, dlg) values ('60 minut',60);
insert into t_dlugosci(dlugosc, dlg) values ('90 minut',90);

-- dni robocze
insert into t_dni_robocze(id_dnia,nazwa_dnia) values (1,'Poniedziałek');
insert into t_dni_robocze(id_dnia,nazwa_dnia) values (2,'Wtorek');
insert into t_dni_robocze(id_dnia,nazwa_dnia) values (3,'Środa');
insert into t_dni_robocze(id_dnia,nazwa_dnia) values (4,'Czwartek');
insert into t_dni_robocze(id_dnia,nazwa_dnia) values (5,'Piątek');
insert into t_dni_robocze(id_dnia,nazwa_dnia) values (6,'Sobota');

-- stawki_uczniów
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,40,20,0,0,1);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,54,27,0,0,1);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,70,35,0,0,1);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,30,15,0,2,6);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,40,20,0,2,6);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,50,25,0,2,6);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,20,10,0,7,11);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,30,15,0,7,11);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,40,20,0,7,11);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,16,8,0,12,99);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,20,10,0,12,99);
INSERT INTO t_stawki_uczniow
(
data_od,id_dlugosci,cena_std,cena_nieob,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,26,13,0,12,99);

-- stawki nauczycieli
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,25,0,37,0,0,3);

INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,30,0,45,0,0,3);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,45,0,67,0,0,3);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,35,0,52,0,4,9);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,42,0,63,0,4,9);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,63,0,94,0,4,9);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',1,45,0,67,0,10,99);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',2,54,0,81,0,10,99);
INSERT INTO t_stawki_nauczycieli
(
data_od,id_dlugosci,cena_std,cena_nieob,cena_zast,stawka_podatku,liczebnosc_grupy_od,liczebnosc_grupy_do)
VALUES('2017-09-01',3,81,0,121,0,10,99);



-- NAUCZYCIELE
insert into t_nauczyciele(imie, nazwisko) values('Alojzy','Świętopełski');
insert into t_nauczyciele(imie, nazwisko) values('Kandelabr','Podwawelski');
insert into t_nauczyciele(imie, nazwisko) values('Leonia','Muchomór-Samotnik');
insert into t_nauczyciele(imie, nazwisko) values('Wiwianna','Kajak-Krzystof');
insert into t_nauczyciele(imie, nazwisko) values('Ludmiła','Wiercipiętka');

-- UCZINIOWIE
insert into t_uczniowie(imie,nazwisko) values('Alek','Abo');
insert into t_uczniowie(imie,nazwisko) values('Brandon','Acri');
insert into t_uczniowie(imie,nazwisko) values('Deniz','Adamoska');
insert into t_uczniowie(imie,nazwisko) values('Elvis','Ambrąży');
insert into t_uczniowie(imie,nazwisko) values('Erik','Albercziok');
insert into t_uczniowie(imie,nazwisko) values('Eugeniusz','Aktanorowicz');
insert into t_uczniowie(imie,nazwisko) values('Felix','Adydak');
insert into t_uczniowie(imie,nazwisko) values('Gaspar','Ajon');
insert into t_uczniowie(imie,nazwisko) values('Henry','Aczkasowski');
insert into t_uczniowie(imie,nazwisko) values('Hieronim','Ajzynbał');
insert into t_uczniowie(imie,nazwisko) values('Ibrahim','Babendych');
insert into t_uczniowie(imie,nazwisko) values('Jack','Bielizna');
insert into t_uczniowie(imie,nazwisko) values('Jarema','Babiaczek');
insert into t_uczniowie(imie,nazwisko) values('Jason','Białousko');
insert into t_uczniowie(imie,nazwisko) values('John','Badzmiera');
insert into t_uczniowie(imie,nazwisko) values('Jovan','Bejćek');
insert into t_uczniowie(imie,nazwisko) values('Kilian','Bakó');
insert into t_uczniowie(imie,nazwisko) values('Lubomir','Bałakirew');
insert into t_uczniowie(imie,nazwisko) values('Alwin','Bandzia');
insert into t_uczniowie(imie,nazwisko) values('Amir','Baćkora');
insert into t_uczniowie(imie,nazwisko) values('Angelo','Cespedes');
insert into t_uczniowie(imie,nazwisko) values('Aureliusz','Cwelung');
insert into t_uczniowie(imie,nazwisko) values('Carlos','Cerebież');
insert into t_uczniowie(imie,nazwisko) values('Dastin','Ciągniwoda');
insert into t_uczniowie(imie,nazwisko) values('Davide','Chóras');
insert into t_uczniowie(imie,nazwisko) values('Edmund','Cipiór');
insert into t_uczniowie(imie,nazwisko) values('Euzebiusz','Chora');
insert into t_uczniowie(imie,nazwisko) values('Fabio','Ciotek');
insert into t_uczniowie(imie,nazwisko) values('Federico','Chrupajło');
insert into t_uczniowie(imie,nazwisko) values('Franek','Ciciorra');
insert into t_uczniowie(imie,nazwisko) values('Goran','Deptolla');
insert into t_uczniowie(imie,nazwisko) values('Hektor','Dołgoruka');
insert into t_uczniowie(imie,nazwisko) values('Ian','Djupero');
insert into t_uczniowie(imie,nazwisko) values('Jonas','Dziobaka');
insert into t_uczniowie(imie,nazwisko) values('Krzesimir','Dobijasz');
insert into t_uczniowie(imie,nazwisko) values('Lew','Dziurk');
insert into t_uczniowie(imie,nazwisko) values('Luca','Dokleja');
insert into t_uczniowie(imie,nazwisko) values('Marcus','Dymasz');
insert into t_uczniowie(imie,nazwisko) values('Marko','Dokucki');
insert into t_uczniowie(imie,nazwisko) values('Maxym','Dupczak');
insert into t_uczniowie(imie,nazwisko) values('Medard','Ficycz');
insert into t_uczniowie(imie,nazwisko) values('Mohamed','Fula');
insert into t_uczniowie(imie,nazwisko) values('Oktawiusz','Flesik');
insert into t_uczniowie(imie,nazwisko) values('Paskal','Fyfe');
insert into t_uczniowie(imie,nazwisko) values('Robin','Fakas');
insert into t_uczniowie(imie,nazwisko) values('Sajmon','Fuljanty');
insert into t_uczniowie(imie,nazwisko) values('Valentino','Fioł');
insert into t_uczniowie(imie,nazwisko) values('Wiesław','Foicik');
insert into t_uczniowie(imie,nazwisko) values('Wilhelm','Fixa');
insert into t_uczniowie(imie,nazwisko) values('Jessika','Gardeło');
insert into t_uczniowie(imie,nazwisko) values('Leah','Gróssy');
insert into t_uczniowie(imie,nazwisko) values('Nathalie','Gdera');
insert into t_uczniowie(imie,nazwisko) values('Raisa','Gląb');
insert into t_uczniowie(imie,nazwisko) values('Vivian','Gif');
insert into t_uczniowie(imie,nazwisko) values('Elif','Groźny');
insert into t_uczniowie(imie,nazwisko) values('Emi','Gmyra');
insert into t_uczniowie(imie,nazwisko) values('Kenza','Genjusz');
insert into t_uczniowie(imie,nazwisko) values('Zoya','Gnojowy');
insert into t_uczniowie(imie,nazwisko) values('Balbina','Gorsi');
insert into t_uczniowie(imie,nazwisko) values('Dagna','Cluj-Napoca');
insert into t_uczniowie(imie,nazwisko) values('Debora','Haniebny');
insert into t_uczniowie(imie,nazwisko) values('Emilie','Hłód');
insert into t_uczniowie(imie,nazwisko) values('Erika','Hałabała');
insert into t_uczniowie(imie,nazwisko) values('Iwa','Hott');
insert into t_uczniowie(imie,nazwisko) values('Kira','Heiter');
insert into t_uczniowie(imie,nazwisko) values('Latika','Hićkajło');
insert into t_uczniowie(imie,nazwisko) values('Latoya','Hoekstra');
insert into t_uczniowie(imie,nazwisko) values('Leokadia','Hejze');
insert into t_uczniowie(imie,nazwisko) values('Leonia','Hrapka');
insert into t_uczniowie(imie,nazwisko) values('Ligia','Hulaszczy');
insert into t_uczniowie(imie,nazwisko) values('Lorena','Kupaga');
insert into t_uczniowie(imie,nazwisko) values('Luna','Pagaku');
insert into t_uczniowie(imie,nazwisko) values('Marieta','Ugupugu');
insert into t_uczniowie(imie,nazwisko) values('Masza','Klituś-Bajduś');
insert into t_uczniowie(imie,nazwisko) values('Matilda','Bumtarata');
insert into t_uczniowie(imie,nazwisko) values('Megan','Kręciawka');
insert into t_uczniowie(imie,nazwisko) values('Nadzieja','Kaleson');
insert into t_uczniowie(imie,nazwisko) values('Nastia','Kaledotter');
insert into t_uczniowie(imie,nazwisko) values('Nikita','Kaleson-Dotter');
insert into t_uczniowie(imie,nazwisko) values('Noelia','Fajabaja');
insert into t_uczniowie(imie,nazwisko) values('Oxana','Kociambur');
insert into t_uczniowie(imie,nazwisko) values('Pamela','Zębimordka');
insert into t_uczniowie(imie,nazwisko) values('Salma','Ziębimordka');
insert into t_uczniowie(imie,nazwisko) values('Scarlett','Zrąbimordka');
insert into t_uczniowie(imie,nazwisko) values('Sofija','Zwątpimordka');
insert into t_uczniowie(imie,nazwisko) values('Waleria','Kociołek');
insert into t_uczniowie(imie,nazwisko) values('Wiwiana','Garnuszek');
insert into t_uczniowie(imie,nazwisko) values('Adelajda','Kociuszek');
insert into t_uczniowie(imie,nazwisko) values('Aisha','Garniołek');
insert into t_uczniowie(imie,nazwisko) values('Alessia','Falista');
insert into t_uczniowie(imie,nazwisko) values('Alisa','Stołeczna');
insert into t_uczniowie(imie,nazwisko) values('Amelie','Poulain');
insert into t_uczniowie(imie,nazwisko) values('Ariadna','Nić');
insert into t_uczniowie(imie,nazwisko) values('Arlena','Mitt');
insert into t_uczniowie(imie,nazwisko) values('Augustyna','Stefania');
insert into t_uczniowie(imie,nazwisko) values('Aurora','Aksnes');
insert into t_uczniowie(imie,nazwisko) values('Aylin','Vatankoş');
insert into t_uczniowie(imie,nazwisko) values('Blanca','Wyczesana');
insert into t_uczniowie(imie,nazwisko) values('Carla','Męczywór');
insert into t_uczniowie(imie,nazwisko) values('Caroline','Porąbaniec');
insert into t_uczniowie(imie,nazwisko) values('Chanel','Gamoń');
insert into t_uczniowie(imie,nazwisko) values('Chioma','Szpara');
insert into t_uczniowie(imie,nazwisko) values('Donata','Bzibziak');
insert into t_uczniowie(imie,nazwisko) values('Gaia','Kiełbasa');
insert into t_uczniowie(imie,nazwisko) values('Hana','Cyc');
insert into t_uczniowie(imie,nazwisko) values('Ismena','Kuciapa');


-- grupy
insert into t_grupy(id_grupy,nazwa,id_semestru) values (3,'Grupa A1',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (4,'Grupa B1',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (5,'Grupa C1',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (6,'Grupa A2',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (7,'Grupa B2',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (8,'Grupa C2',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (9,'Grupa A3',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (10,'Grupa B3',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (11,'Grupa C3',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (12,'Grupa A4',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (13,'Grupa A5',1);
insert into t_grupy(id_grupy,nazwa,id_semestru) values (14,'Grupa A6',1);

-- Przypisanie uczniów do grup
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(1,3,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(2,4,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(3,5,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(4,6,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(5,7,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(6,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(7,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(8,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(9,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(10,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(11,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(12,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(13,4,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(14,4,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(15,5,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(16,6,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(17,7,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(18,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(19,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(20,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(21,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(22,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(23,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(24,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(25,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(26,5,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(27,5,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(28,6,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(29,7,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(30,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(31,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(32,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(33,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(34,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(35,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(36,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(37,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(38,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(39,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(40,6,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(41,7,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(42,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(43,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(44,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(45,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(46,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(47,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(48,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(49,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(50,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(51,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(52,5,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(53,7,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(54,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(55,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(56,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(57,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(58,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(59,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(60,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(61,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(62,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(63,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(64,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(65,7,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(66,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(67,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(68,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(69,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(70,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(71,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(72,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(73,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(74,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(75,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(76,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(77,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(78,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(79,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(80,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(81,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(82,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(83,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(84,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(85,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(86,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(87,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(88,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(89,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(90,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(91,9,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(92,10,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(93,11,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(94,12,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(95,13,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(96,14,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(97,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(98,8,'2017-09-01','2018-01-31');
insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) values(99,8,'2017-09-01','2018-01-31');

