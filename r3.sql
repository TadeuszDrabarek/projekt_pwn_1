select * from t_dlugosci;

select * from t_dni_robocze;

select * from t_nauczyciele;

select * from t_uczniowie;

select * from t_nauczyciele;

insert into t_uczniowie(imie, nazwisko, adres) values('1','2','3') ;



 select * from t_dlugosci;
 
 select * from t_dni_robocze;
 
 select * from t_grupy;
 
 select * from t_semestry;
 
 select * from t_zajecia;
 
 select * from t_nauczyciele;
 
 update t_zajecia set id_nauczyciela=6 where id_zajecia=97;
 
 select ob.id_obecnosci, concat(u.imie,' ',u.nazwisko) as uczen, ob.czy_obecny, ob.id_zajecia, u.id_ucznia
 from t_obecnosci ob
 inner join t_uczniowie u on u.id_ucznia=ob.id_ucznia
 where ob.id_zajecia=97;
 
 
 select ob.id_obecnosci, concat(u.imie,' ',u.nazwisko) as uczen,
    case when ob.czy_obecny=1 then 'OBECNY'
        when ob.czy_obecny=0 then 'NIEOBECNY'
        else 'nieokreślony' end as obecnosc
    , ob.id_zajecia, u.id_ucznia
    from t_obecnosci ob
    inner join t_uczniowie u on u.id_ucznia=ob.id_ucznia
    where ob.id_zajecia=99 order by u.nazwisko,u.imie ;
    
select * from t_obecnosci where id_zajecia=99 and id_ucznia=1;

update t_obecnosci set czy_obecny=0 where id_zajecia=99 and id_ucznia=1;
