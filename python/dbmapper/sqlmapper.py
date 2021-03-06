# -*- coding: utf-8 -*-

def loginsql(user,passwd):
    s="""
    select userid,login,email,username,roleid from app_users where login='%s' and pass='%s' and indactive=1;
    """
    return s%(user,passwd)

def oldloadmenusql(role,branch):
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
    return s%(branch,role,branch)

def listuserssql():
    return "select userid,login,email,datcre,username,roleid from app_users"