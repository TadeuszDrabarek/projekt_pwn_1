create table app_role(
	roleid varchar(10) primary key,
    rolename varchar(100)
);

drop table t_role;

insert into app_role values('admin','Główna rola systemowa');
insert into app_role values('none','Rola niezalogowanego użytkownika');
insert into app_role values('simple','Rola bez uprawnień');


create table app_users(
	userid integer auto_increment primary key,
    login varchar(100) not null,
    email varchar(100) not null,
    pass varchar(32) not null,
    indactive integer default 1,
    datcre date,
    usercre integer,
    username varchar(100),
    roleid varchar(10),
    foreign key (usercre) references app_users(userid),
    foreign key (roleid) references app_role(roleid),
    check (ind_active in (0,1))
);


#drop table app_users;

insert into app_users(login,email,pass,datcre,username,roleid) 
	values('admin','admin@admin','21232f297a57a5a743894a0e4a801fc3',curdate(),'Administrator','admin');
    
    
insert into app_users(login,email,pass,datcre,username,roleid) 
	values('inny','admin@admin','21232f297a57a5a743894a0e4a801fc3',curdate(),'Administrator','admin');


create table app_menu(
	menuid varchar(10)  primary key,
    pos integer default 1,
    caption varchar(50) not null,
    description varchar(400),
    parent varchar(10),
    foreign key (parent) references app_menu(menuid)
);

drop table app_menu;

insert into app_menu(menuid,pos,caption) values ('MAIN',0,'Menu główne');
insert into app_menu(menuid,pos,caption,parent) values ('EXIT',999,'Wyjście','MAIN');
insert into app_menu(menuid,pos,caption,parent) values ('GETTIME',998,'Podaj czas','MAIN');
insert into app_menu(menuid,pos,caption,parent) values ('LOGOUT',997,'Wyloguj','MAIN');
insert into app_menu(menuid,pos,caption,parent) values ('LOGIN',996,'Zaloguj','MAIN');

insert into app_menu(menuid,pos,caption,parent) values ('ADU',995,'Administracja użytkownikami','MAIN');
insert into app_menu(menuid,pos,caption,parent) values ('LST',9,'Lista użytkowników','ADU');
insert into app_menu(menuid,pos,caption,parent) values ('ACU',10,'Utwórz użytkownika','ADU');
insert into app_menu(menuid,pos,caption,parent) values ('ACR',11,'Ustal/zmień rolę uzytkownika','ADU');
insert into app_menu(menuid,pos,caption,parent) values ('DIU',12,'Zablokuj użytkownika','ADU');
insert into app_menu(menuid,pos,caption,parent) values ('CHP',13,'Zmień rolę użytkownika','ADU');


#truncate table app_menu;

#drop table app_menu_role;

select * from app_menu order by pos;

create table app_menu_role(
	menuid varchar(10),
    roleid varchar(10),
    primary key (menuid,roleid)
);

insert app_menu_role(roleid,menuid) values('none','EXIT');
insert app_menu_role(roleid,menuid) values('none','GETTIME');
insert app_menu_role(roleid,menuid) values('none','LOGIN');
insert app_menu_role(roleid,menuid) values('admin','EXIT');
insert app_menu_role(roleid,menuid) values('admin','LOGOUT');
insert app_menu_role(roleid,menuid) values('admin','GETTIME');

insert app_menu_role(roleid,menuid) value('admin','ADU');
insert app_menu_role(roleid,menuid) value('admin','ACU');
insert app_menu_role(roleid,menuid) value('admin','ACR');
insert app_menu_role(roleid,menuid) value('admin','DIU');
insert app_menu_role(roleid,menuid) value('admin','CHP');
insert app_menu_role(roleid,menuid) value('admin','LST');




-- truncate table app_menu_role;


select * from app_menu_role;

select 'BACK' ,'Powrót', 1, am.parent as branch
from app_menu am 
where am.parent is not null and am.menuid='ADU'
order by am.pos;


select * from (
	select amr.menuid,am.caption, count(child.menuid) as has_children, am.menuid as branch, am.pos
	from app_menu_role amr
	inner join app_menu am on am.menuid=amr.menuid
	left join app_menu child on child.parent=am.menuid
	left join app_menu_role ach on child.menuid=ach.menuid and ach.roleid='admin'
	where amr.roleid='admin' and am.parent='SEKR'
	group by amr.menuid,am.caption, am.pos
) a
order by a.pos;

select userid,login,email,datcre,username,roleid from app_users;

select userid,login,email,datcre,username,roleid,
case when indactive=1 then 'aktywny' else 'nieaktywny' end as status
from app_users
where indactive in (1,0);

select * from app_users;

select userid,login,email,datcre,username,roleid,
case when indactive=1 then 'aktywny' else 'nieaktywny' end as status
from app_users;

update app_users set roleid='simple' where login='tdrabarek';

select id_ucznia, imie, nazwisko,adres from t_uczniowie;


select caption from app_menu where menuid='MAIN';

select * from t_uczniowie where id_ucznia=2;


update t_uczniowie set imie='Brandon1', nazwisko='Acri1', adres='Adres1' where id_ucznia=2;

select * from app_users;
#e19d5cd5af0378da05f63f891c7467af
#e19d5cd5af0378da05f63f891c7467af
#e19d5cd5af0378da05f63f891c7467af

select * from app_role;
delete from app_role where roleid='75 minut';

delete from app_menu where menuid='SEM';

select * from t_semestry ;

delete from t_semestry where id_semestru=3;

select g.id_grupy,g.nazwa,t.nazwa from t_grupy g
inner join t_semestry t on t.id_semestru=g.id_semestru;

select * from t_grupy;

select * from v_ile_uczniow_w_grupie;

select uig.id_ucznia,concat(u.imie,' ',u.nazwisko) as imie_nazwisko, uig.id_grupy, g.nazwa,uig.data_od, uig.data_do 
from t_uczniowe_w_grupie uig
inner join t_uczniowie u on u.id_ucznia=uig.id_ucznia
inner join t_grupy g on g.id_grupy=uig.id_grupy
where uig.id_grupy=5


;

select uig.id_ucznia,concat(u.imie,' ',u.nazwisko) as imie_nazwisko, uig.id_grupy, g.nazwa,uig.data_od, uig.data_do 
    from t_uczniowe_w_grupie uig
    inner join t_uczniowie u on u.id_ucznia=uig.id_ucznia
    inner join t_grupy g on g.id_grupy=uig.id_grupy
    where uig.id_grupy=15
    and u.imie like '%a%'
    order by u.nazwisko,u.imie,uig.id_ucznia;
    
select * from t_uczniowe_w_grupie where id_grupy=15;    

update t_uczniowe_w_grupie set data_do=curdate()-1
    where id_grupy=15 and id_ucznia=100;


insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do)
values(101,15,curdate(),null);

insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do)
values(100,15,if(''='',curdate(),''),if(''='',null,''));

insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do) 
values(99,8,'2017-09-01','2018-01-31');




select max(data_zajec) from t_zajecia;

select * from t_zajecia order by data_zajec;

-- zapytanie zwraca listę uczniów jacy powinni być na zajęciach o zadanym ID
select t.id_zajecia,ug.id_ucznia
from t_zajecia t
inner join t_plany p on p.id_planu=t.id_planu
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
where 
	id_zajecia=67;
	
-- zapytanie zwraca listę zajęć z dzisiejszego dnia
select * from t_zajecia where data_zajec=curdate()+1 or data_odrabiania=curdate();

select p.id_planu, p.id_nauczyciela,p.godzina_rozp,p.godzina_konc
	,concat(n.imie,' ',n.nazwisko) as nauczyciel
    ,g.nazwa
from  t_dni_robocze dr 
inner join t_plany p on p.id_dnia=dr.id_dnia
inner join t_nauczyciele n on n.id_nauczyciela=p.id_nauczyciela
inner join t_grupy g on g.id_grupy=p.id_grupy
where dr.id_dnia=dayofweek('2017-10-19')
	and p.data_od<='2017-10-19' and coalesce(data_do,'2017-10-19')>='2017-10-19'
order by p.id_nauczyciela,p.godzina_rozp;

select count(*) from v_dates where gen_date='2017-10-19';


select z.id_zajecia, p.id_nauczyciela, p.godzina_rozp, p.godzina_konc
	,concat(n.imie,' ',n.nazwisko) as nauczyciel_real
    ,concat(n0.imie,' ',n0.nazwisko) as nauczyciel_plan
    ,g.nazwa
    ,v.liczba_uczniow
from t_zajecia z
inner join t_plany p on p.id_planu=z.id_planu
inner join t_nauczyciele n on n.id_nauczyciela=z.id_nauczyciela
inner join t_nauczyciele n0 on n0.id_nauczyciela=p.id_nauczyciela
inner join t_grupy g on g.id_grupy=p.id_grupy
inner join v_ile_uczniow_w_grupie v on v.id_grupy=p.id_grupy
where z.data_zajec='2017-10-19';


select * from t_zajecia where id_zajecia=67;

select z.data_zajec,z.data_odrabiania,z.czy_odbyte,z.czy_odrabiane,z.id_nauczyciela nauczyciel_real,
	concat(n1.imie,' ',n1.nazwisko) imie_nazwisko_nau_real,
	p.id_nauczyciela nauczyciel_plan, 
    concat(n0.imie,' ',n0.nazwisko) imie_nazwisko_nau_plan,
    p.godzina_rozp, p.id_dlugosci,d.dlugosc,p.godzina_konc,
    v.liczba_uczniow, g.nazwa
from t_zajecia z
inner join t_plany p on p.id_planu=z.id_planu
inner join v_ile_uczniow_w_grupie v on v.id_grupy=p.id_grupy
inner join t_dlugosci d on d.id_dlugosci=p.id_dlugosci
inner join t_nauczyciele n0 on n0.id_nauczyciela=p.id_nauczyciela
inner join t_nauczyciele n1 on n1.id_nauczyciela=z.id_nauczyciela
inner join t_grupy g on p.id_grupy=g.id_grupy
where z.id_zajecia=83;

select * from v_grupy_i_uczniowie_w_bs;

select t.id_zajecia,ug.id_ucznia,concat(u.imie,' ',u.nazwisko) as uczen
	,case when ob.czy_obecny=1 then 'OBECNY' 
          when ob.czy_obecny=0 then 'NIEOBECNY'
          else 'nieokreślony' end as obecnosc
from t_zajecia t
inner join t_plany p on p.id_planu=t.id_planu
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia
left join t_obecnosci ob on ob.id_zajecia=t.id_zajecia and ob.id_ucznia=ug.id_ucznia
where 
	ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
    and t.id_zajecia=83
;

insert into t_obecnosci(id_zajecia,id_ucznia,czy_obecny) 
select t.id_zajecia,ug.id_ucznia,null
from t_zajecia t
inner join t_plany p on p.id_planu=t.id_planu
inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
where 
	ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
    and not exists(select 1 from t_obecnosci ob where ob.id_zajecia=t.id_zajecia and ob.id_ucznia=ug.id_ucznia);

   
delete from t_obecnosci where id_zajecia=99;

    
select * from t_obecnosci where id_zajecia=83    ;

select * from t_zajecia where id_zajecia=83;

select * from v_obecnosci_det where id_zajecia=83;

select * from v_view_plan vr where vr.id_zajecia=83;

select * from t_zajecia where czy_odbyte=0;

select * from t_zajecia where id_zajecia=99;
select * from t_obecnosci where id_zajecia=99;


call run_lesson(88);


select id_zajecia, id_nauczyciela, godzina_rozp, godzina_konc
	,nauczyciel_real
        ,nauczyciel_plan
        ,nazwa
        ,liczba_uczniow
        ,data_zajec_real
    from v_view_plan where czy_odbyte is null;

select * from t_obecnosci where id_zajecia=100;

update t_obecnosci set czy_obecny=0 where czy_obecny is null and id_zajecia=100;

select * from t_rozliczenia_uczniow where id_zajecia=103;

select t.id_zajecia,ug.id_ucznia,concat(u.imie,' ',u.nazwisko) as uczen
    ,case when ob.czy_obecny=1 then 'OBECNY' 
        when ob.czy_obecny=0 then 'NIEOBECNY'
        else 'nieokreślony' end as obecnosc
	,coalesce(ru.kwota_brutto,0) do_zaplaty
        from t_zajecia t
        inner join t_plany p on p.id_planu=t.id_planu
        inner join t_uczniowe_w_grupie ug on ug.id_grupy=p.id_grupy
        inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia
        left join t_obecnosci ob on ob.id_zajecia=t.id_zajecia and ob.id_ucznia=ug.id_ucznia
        left join t_rozliczenia_uczniow ru on ru.id_zajecia=t.id_zajecia and ru.id_ucznia=u.id_ucznia
        where 
    ug.data_od<=t.data_zajec and coalesce(ug.data_do,t.data_zajec)>=t.data_zajec
    and t.id_zajecia=103;
    
    
select * from t_zajecia order by id_zajecia;    

update t_zajecia set czy_odbyte=0 where id_zajecia>64 and data_zajec<'2017-10-23' and czy_odbyte=1;

delete from t_obecnosci where id_zajecia in (select id_zajecia from t_zajecia where id_zajecia>64 and data_zajec<'2017-10-23' and czy_odbyte=0);

commit;

select v.id_ucznia
	,concat(u.imie,' ',u.nazwisko) as uczen
	,sum(kwota) as saldo 
    ,case when sum(kwota)>0 then 'ZADŁUŻENIE'
          else                   'NADPŁATA'
          end as status_salda
from v_saldo_uczniow v
inner join t_uczniowie u on u.id_ucznia=v.id_ucznia
group by v.id_ucznia
having sum(kwota)<>0
order by sum(kwota) desc, uczen asc;

select * from t_uczniowie;

create or replace view v_rozliczenie_ucznia as
select v.id_ucznia
	,concat(u.imie,' ',u.nazwisko) as uczen
    ,v.data_operacji, v.kwota
    ,v.typ_operacji, v.id_operacji
    ,case when v.typ_operacji='WPL' then 'WPŁATA'
          when v.typ_operacji='NAL' then 
            concat('ZAJĘCIA ',coalesce(z.data_odrabiania,z.data_zajec),' (',dn.nazwa_dnia,') g.',p.godzina_rozp,' ',g.nazwa)
		  else  'unknown' end as tytulem
from v_saldo_uczniow v
inner join t_uczniowie u on u.id_ucznia=v.id_ucznia
left join t_rozliczenia_uczniow ru on ru.id_rozliczenia=v.id_operacji
left join t_zajecia z on z.id_zajecia=ru.id_zajecia
left join t_plany p on p.id_planu=z.id_planu
left join t_grupy g on g.id_grupy=p.id_grupy
left join t_dni_robocze dn on dn.id_dnia=p.id_dnia;

select id_ucznia, uczen, data_operacji, kwota, tytulem from v_rozliczenie_ucznia  where id_ucznia=96;

select v.id_ucznia
	,concat(u.imie,' ',u.nazwisko) as uczen
    ,v.data_operacji, v.kwota
    ,v.typ_operacji, v.id_operacji
    ,case when v.typ_operacji='WPL' then 'WPŁATA'
          when v.typ_operacji='NAL' then 
            concat('ZAJĘCIA ',coalesce(z.data_odrabiania,z.data_zajec),' (',dn.nazwa_dnia,') g.',p.godzina_rozp,' ',g.nazwa)
		  else  'unknown' end as tytulem
from v_saldo_uczniow v
inner join t_uczniowie u on u.id_ucznia=v.id_ucznia
left join t_rozliczenia_uczniow ru on ru.id_rozliczenia=v.id_operacji
left join t_zajecia z on z.id_zajecia=ru.id_zajecia
left join t_plany p on p.id_planu=z.id_planu
left join t_grupy g on g.id_grupy=p.id_grupy
left join t_dni_robocze dn on dn.id_dnia=p.id_dnia
where v.id_ucznia=96;

select * from v_saldo_uczniow where id_ucznia=96;

select * from t_wplaty where id_ucznia=96