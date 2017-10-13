# -*- coding: utf-8 -*-
from dbconnection import dbconn
from dbmapper import appusers
from role import Role
import pymysql
import hashlib
from menu import Menu

class User:
    def __init__(self,userid=-1,username='',userlogin='',useremail='',userrole='none'):
        self.userid=userid
        self.username=username
        self.userlogin=userlogin
        self.useremail=useremail
        self.userrole=userrole
        self.loggedin=False if userid==-1 else True

class AppUsers(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'ADU')
        #self.=db
    def doit(self,lw,ex):
        kw=super().doit(lw,ex)
        if kw!='EXIT':
            if kw=='LST':       #wypisz listę userów
                self.print_userlist(ex)
            elif kw=='ACU':
                self.add_user(ex)
            elif kw=='CHRU':
                self.user_change_role(ex) 
            elif kw=='CHPU':
                self.user_change_password(ex)             
            elif kw=='DIU':
                self.enable_disable_user(ex,0)
            elif kw=='EIU':
                self.enable_disable_user(ex,1)            
            elif kw=='APPROLES':
                r=Role(self.a, self.user) 
                r.loadmenu()
                r.showmenu()
                del r
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        print('LST [active|inactive|all] | [like wzorzec]')
        print('ACU [nazwa [login [email [password]]]]    ')
        print('       uwaga: nazwa, logi, email, password nie mogą zawierać spacji !')
        print('CHP [login [new_role_ID]]')
    
    def select_user(self,ex):
        if len(ex)<2:
            self.read_userlist('(1,0)')
            print('Dostępne loginy:')
            print(self)
            w=input('Podaj login usera :')
        else:
            w=ex[1]
        if not self.check_if_login_exists(w):
            print('Użytkownik o takim loginie nie istnieje !')
            return
        self.read_oneuser(w)
        print(self)
        return w
        
    def user_change_password(self,ex):
        w=self.select_user(ex)
        if len(ex)<3:
            passwdtmp =input('Podaj nowe hasło [Enter] - przerywa:')
            if passwdtmp=="":
                return
        else:
            passwdtmp=ex[2]        
        passwd=hashlib.md5(str(passwdtmp).encode("utf-8")).hexdigest()
        print('Zmiana hasła...', end='')
        self.a.execute(appusers.userchpasswd%(passwd,w))                
        
    def enable_disable_user(self,ex,ei):
        w=self.select_user(ex)
        if w==self.user.userlogin:
            print('Nie możesz zablokować ani odblokować sam siebie!')
            return
        if ei==0:
            print('Blokuję użytkownika...',end='')
            #print (appusers.userdisable%(0,w))
            self.a.execute(appusers.userdisable%(0,w))        
        else:
            print('Odblokowuję użytkownika...',end='')
            self.a.execute(appusers.userdisable%(1,w))        
            
    def user_change_role(self,ex):
        w=self.select_user(ex)        
        r=Role(self.a, self.user)
        if len(ex)<3:
            print ('Lista dostępnych ról:')
            print(r)
            roleid=input('Wybierz rolę dla użytkownika (Podaj ID Roli):')
        else:
            roleid=ex[2]
        if not r.check_roleid(roleid):
            print("Nie ma takiej roli !")
            del r
            return
        print('Zmieniam rolę...',end='')
        self.a.execute(appusers.userchangerole%(roleid,w))
        return
        
    def add_user(self,ex):
        if len(ex)<2:
            name   =input('Podaj nazwę (np. imię i nazwisko) [Enter] - przerywa:')
            if name=="":
                return
        else:
            name=ex[1]
        if len(ex)<3:
            while(True):
                login  =input('Podaj login [Enter] - przerywa :')
                if login=="":
                    return
                if not self.check_if_login_exists(login):
                    break
                print('Użytkownik o takim loginie już istnieje, podaj inny !')
        else:
            if self.check_if_login_exists(ex[2]):
                print('Użytkownik o takim loginie już istnieje !')
                return
            else:
                login=ex[2]
        if len(ex)<4:
            email  =input('Podaj email [Enter] - przerywa :')
            if email=="":
                return
        else:
            email=ex[3]
        if len(ex)<5:
            passwdtmp =input('Podaj hasło [Enter] - przerywa:')
            if passwdtmp=="":
                return
        else:
            passwdtmp=ex[4]
        passwd=hashlib.md5(str(passwdtmp).encode("utf-8")).hexdigest()
        print('Tworzenie...', end='')
        self.a.execute(appusers.addusersql%(login,email,passwd,name))
        
    def check_if_login_exists(self,login):
        self.a.select(appusers.checkloginsql%(login))
        if len(self.a.result)>0:
            return True
        return False
    
    def read_oneuser(self,userlogin):
        return self.a.select(appusers.loadoneuser%(userlogin))         
    
    def read_userlist(self,mode):
        return self.a.select(appusers.listuserssql%(mode))     
    def __str__(self):
        s='%4s|%-15s|%-30s|%-20s|%-20s|%-10s|%10s\n'%('Id','Login','Email','Data utworzenia','Nazwa','Rola','Aktywność')
        s+='-'*109+'\n'
        for row in self.a.result:
            s+='%4i|%-15s|%-30s|%-20s|%-20s|%-10s|%10s\n'%(row[0],row[1],row[2],row[3],row[4],row[5],row[6])
        return s 
    
    def print_userlist(self,ex):
        mode='(1,0)';
        if len(ex)==2:
            if ex[1]=='all':
                mode='(1,0)'
            elif ex[1]=='active':
                mode='(1)'
            elif ex[1]=='inactive':
                mode='(0)'
            else:
                mode='(-1)'
        if len(ex)==3:
            if ex[1]=='like':
                mode="(1,0) and (login like '%"+ex[2]+"%' or email like '%"+ex[2]+"%')"
        if self.read_userlist(mode):
            print(self)
        else:
            print("Błąd odczytu danych z bazy!")