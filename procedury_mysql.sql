 DELIMITER //
CREATE PROCEDURE run_lesson
(IN idl int)
BEGIN
	insert into t_obecnosci(id_zajecia,id_ucznia,czy_obecny) 
	select t.id_zajecia,ug.id_ucznia,null
	from t_zajecia t
	inner join t_plany p on p.id_planu=t.id_planu
	inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
	where 
		ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
		and t.id_zajecia=idl;

	update t_zajecia set czy_odbyte=null where id_zajecia=idl;

END //
DELIMITER ;

#drop procedure done_lesson;

 DELIMITER //
CREATE PROCEDURE done_lesson
(IN idl int)
BEGIN
	update t_obecnosci set czy_obecny=0 where czy_obecny is null and id_zajecia=idl;
	update t_zajecia set czy_odbyte=1 where id_zajecia=idl;
    
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
	where a.id_zajecia = idl;

END //
DELIMITER ;
