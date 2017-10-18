# -*- coding: utf-8 -*-

def loginsql(user,passwd):
    #zapytanie sprawdza zgodność nazwy użytkownia z hasłem
    s="""
    select userid,login,email,username,roleid from app_users where login='%s' and pass='%s' and indactive=1;
    """
    return s%(user,passwd)

def oldloadmenusql(role,branch):
    #zapytanie zwraca menu na danym poziomie dla uż. z danej roli (stara wersja)
    s="""
    select * from (
            select amr.menuid,am.caption, count(child.menuid) as has_children, am.menuid as branch, am.pos
            from app_menu_role amr
            inner join app_menu am on am.menuid=amr.menuid
            left join app_menu child on child.parent=am.menuid
            left join app_menu_role ach on child.menuid=ach.menuid and ach.roleid='%s'
            where amr.roleid='%s' and am.parent='%s'
            group by amr.menuid,am.caption, am.pos
            union all
            select 'BACK' ,'Powrót', 1, am.parent as branch,-1
            from app_menu am 
            where am.parent is not null and am.menuid='%s'
    ) a
    order by a.pos;
    """
    return s%(branch,role,branch,branch)

def loadmenusql(role,branch):
    #zapytanie zwraca menu na danym poziomie dla uż. z danej roli (nowe wersja)
    s="""
    select * from (
            select amr.menuid,am.caption, count(child.menuid) as has_children, am.menuid as branch, am.pos
            from app_menu_role amr
            inner join app_menu am on am.menuid=amr.menuid
            left join app_menu child on child.parent=am.menuid
            left join app_menu_role ach on child.menuid=ach.menuid and ach.roleid='%s'
            where amr.roleid='%s' and am.parent='%s'
            group by amr.menuid,am.caption, am.pos
    ) a
    order by a.pos;
    """
    return s%(role,role,branch)

def mnuname(s):
    return "select caption from app_menu where menuid='%s';"%(s)

# Uczniowie

def loadstudents():
    return "select id_ucznia, imie, nazwisko,adres from t_uczniowie;"

def checkstudentid(s):
    return "select id_ucznia, imie, nazwisko,adres from t_uczniowie where id_ucznia=%i;"%(s)

def updatestudent(idu,imie,nazwisko,adres):
    return """
    update t_uczniowie 
        set imie='%s', nazwisko='%s', adres='%s' 
        where id_ucznia=%i;
    """%(imie,nazwisko,adres,idu)

def addstudent(imie,nazwisko,adres):
    return """
    insert into t_uczniowie(imie, nazwisko, adres) 
    values('%s','%s','%s');
    """%(imie,nazwisko,adres)

# Nauczyciele

def loadteachers():
    return "select id_nauczyciela, imie, nazwisko,adres, numer_konta from t_nauczyciele"

def checkteacherid(s):
    return "select id_nauczyciela, imie, nazwisko,adres, numer_konta from t_nauczyciele where id_nauczyciela=%i;"%(s)

def updateteacher(idu,imie,nazwisko,adres,numer_konta):
    return """
    update t_nauczyciele 
        set imie='%s', nazwisko='%s', adres='%s', numer_konta='%s'
        where id_nauczyciela=%i;
    """%(imie,nazwisko,adres,numer_konta,idu)

def addteacher(imie,nazwisko,adres, numer_konta):
    return """
    insert into t_nauczyciele(imie, nazwisko, adres, numer_konta) 
    values('%s','%s','%s','%s');
    """%(imie,nazwisko,adres,numer_konta)


# Role

def loadroles():
    return "select roleid, rolename from app_role"

def checkroleid(s):
    return "select roleid, rolename from app_role where roleid='%s';"%(s)

def updaterole(roleid,rolename):
    return """
    update app_role 
        set roleid='%s', rolename='%s'
        where roleid='%s';
    """%(roleid, rolename, roleid)

def addrole(roleid, rolename):
    return """
    insert into app_role(roleid, rolename) 
    values('%s','%s');
    """%(roleid, rolename)

# Długości

def loadlng():
    return "select id_dlugosci, dlugosc, dlg from t_dlugosci"

def checklngid(s):
    return "select id_dlugosci, dlugosc, dlg from t_dlugosci where id_dlugosci=%i;"%(s)

def updatelng(id_dlugosci,dlugosc,dlg):
    return """
    update t_dlugosci 
        set dlugosc='%s', dlg=%i
        where id_dlugosci=%i;
    """%(dlugosc, dlg, id_dlugosci)

def addlng(dlugosc,dlg):
    return """
    insert into t_dlugosci(dlg, dlugosc) 
    values(%i,'%s');
    """%(dlg, dlugosc)

# Semestry

def loadsem():
    return "select id_semestru, nazwa, data_od, data_do from t_semestry"

def checksemid(s):
    return "select id_semestru, nazwa, data_od, data_do from t_semestry where id_semestru=%i;"%(s)

def updatesem(id_semestru,data_od,data_do, nazwa):
    return """
    update t_semestry 
        set data_od='%s', data_do='%s', nazwa='%s'
        where id_semestru=%i;
    """%(data_od, data_do, nazwa, id_semestru)

def addsem(data_od, data_do, nazwa):
    return """
    insert into t_semestry(data_od, data_do, nazwa) 
    values('%s','%s','%s');
    """%(data_od, data_do, nazwa)

#Grupy

def loadgrp():
    return """
    select g.id_grupy,g.nazwa,t.nazwa,t.id_semestru from t_grupy g
    inner join t_semestry t on t.id_semestru=g.id_semestru;"""

def checkgrpid(s):
    return """
    select g.id_grupy,g.nazwa,t.nazwa,t.id_semestru from t_grupy g
    inner join t_semestry t on t.id_semestru=g.id_semestru
    where id_grupy=%i;
    """%(s)

def updategrp(nazwa,semestr, idu):
    return """
    update t_grupy set nazwa='%s', id_semestru=%i
    where id_grupy=%i;
    """%(nazwa, semestr, idu)

def addgrp(nazwa,semestr):
    return """
    insert into t_grupy(nazwa,id_semestru)
    values('%s','%s');
    """%(nazwa,semestr)

# Uczniowie w grupie

def loaduig(ig):
    return """
    select uig.id_ucznia,concat(u.imie,' ',u.nazwisko) as imie_nazwisko, uig.id_grupy, g.nazwa,uig.data_od, uig.data_do 
    from t_uczniowe_w_grupie uig
    inner join t_uczniowie u on u.id_ucznia=uig.id_ucznia
    inner join t_grupy g on g.id_grupy=uig.id_grupy
    where uig.id_grupy=%i
    order by u.nazwisko,u.imie,uig.id_ucznia;
    """%(ig)

def loaduigf(f):
    return """
    select id_ucznia, imie, nazwisko,adres from t_uczniowie
    where concat(imie,nazwisko) like '%%%s%%';
    """%(f)    

def addutg(idu,idg,od,do):
    return """
    insert into t_uczniowe_w_grupie(id_ucznia,id_grupy,data_od,data_do)
    values(%i,%i,if('%s'='',curdate(),'%s'),if('%s'='',null,'%s'));
    """%(idu,idg,od,od,do,do)

def delufg(grupa,idu):
    return """
    update t_uczniowe_w_grupie set data_do=curdate()-1
    where id_grupy=%i and id_ucznia=%i;
    """%(grupa,idu)

def undelufg(grupa,idu):
    return """
    update t_uczniowe_w_grupie set data_do=null
    where id_grupy=%i and id_ucznia=%i;
    """%(grupa,idu)

def remufg(grupa,idu):
    return """
    delete from t_uczniowe_w_grupie
    where id_grupy=%i and id_ucznia=%i;
    """%(grupa,idu)

def delallufg(grupa):
    return """
    delete from t_uczniowe_w_grupie
    where id_grupy=%i ;
    """%(grupa)

def checkdate(d):
    return "select count(*) from v_dates where gen_date='%s';"%(d)

def planowyplannadzien(d):
    return """
    select id_planu, id_nauczyciela,godzina_rozp,godzina_konc, nauczyciel,nazwa
    from v_plan_ramowy_dzien where gen_date='%s';
    """%(d)

def plannadzien(w):
    return"""
    select id_zajecia, id_nauczyciela, godzina_rozp, godzina_konc
	,nauczyciel_real
        ,nauczyciel_plan
        ,nazwa
        ,liczba_uczniow
    from v_view_plan where data_zajec_real='%s';
    """%(w)

def createz(w):
    return """
    insert into t_zajecia(data_zajec,id_planu,id_nauczyciela,czy_odbyte,czy_odrabiane)
    select v.gen_date, p.id_planu, p.id_nauczyciela,0,0
    from v_dates v
    inner join t_dni_robocze dr on dr.id_dnia=dayofweek(v.gen_date)
    inner join t_plany p on p.id_dnia=dayofweek(v.gen_date)
    where v.gen_date='%s';
    """%(w)

def status(w):
    return """
select id_zajecia,id_nauczyciela,godzina_rozp,godzina_konc,nauczyciel_real,vr.nazwa
, case when nauczyciel_plan<>nauczyciel_real then 'TAK' else 'NIE' end as zastepstwo
, case when data_odrabiania='%s' then 'Przesunięta na dziś' 
       when data_odrabiania is not null then 'Przesunięte z dziś' 
       else 'W terminie' end as status 
, case when data_zajec='%s' and data_zajec<>data_zajec_real then vr.data_zajec_real  
       when data_zajec_real='%s' and data_zajec<>data_zajec_real then data_zajec 
       else '' end as przeniesione_z_na
 from v_view_plan vr 
where vr.data_zajec_real='%s' or vr.data_zajec='%s'
order by godzina_rozp;
"""%(w,w,w,w,w)

def checkidzajec(idz):
    return """
    select * from t_zajecia where id_zajecia=%i;
    """%(idz)
    
def zmienterminzajec(idz,w):
    return """
    update t_zajecia set data_odrabiania='%s', czy_odrabiane=1 where id_zajecia=%i;
    """%(w,idz)