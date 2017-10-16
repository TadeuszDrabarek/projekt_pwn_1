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
