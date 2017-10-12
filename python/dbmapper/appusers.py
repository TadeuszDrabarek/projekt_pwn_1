# -*- coding: utf-8 -*-

addusersql="""
insert into app_users(login,email,pass,datcre,username,roleid)
values('%s','%s','%s',curdate(),'%s','simple');
"""

checkloginsql="""
select * from app_users where login='%s';
"""

listuserssql="""
select userid,login,email,datcre,username,roleid,
case when indactive=1 then 'aktywny' else 'nieaktywny' end as status
from app_users
where indactive in %s
"""

loadoneuser="""
select userid,login,email,datcre,username,roleid,
case when indactive=1 then 'aktywny' else 'nieaktywny' end as status
from app_users
where login='%s'
"""

userchangerole="""
update app_users set roleid='%s' where login='%s';
"""