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