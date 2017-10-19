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


 DELIMITER //
CREATE PROCEDURE done_lesson
(IN idl int)
BEGIN
	update t_obecnosci set czy_obecny=0 where czy_obecny is null and id_zajecia=idl;
	update t_zajecia set czy_odbyte=1 where id_zajecia=idl;

END //
DELIMITER ;
