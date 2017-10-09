# -*- coding: utf-8 -*-
from dbconnection import dbconn
from dbmapper import appusers
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
        super().__init__(db,u,True)
        #self.=db
    def doit(self,lw,ex):
        kw=super().doit(lw,ex)
        if kw!='EXIT':
            if kw=='LST':       #wypisz listę userów
                self.print_userlist(ex)
            elif kw=='ACU':
                self.add_user(ex)
            elif kw=='ACR':
                self.user_change_role(ex)                
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        print('LST [active|inactive|all] | [like wzorzec]')
        print('ACU [nazwa [login [email [password]]]]    ')
        print('       uwaga: nazwa, logi, email, password nie mogą zawierać spacji !')
    
    def user_change_role(self,ex):
        w=input('Podaj login usera :')
        if not self.check_if_login_exists(w):
            print('Użytkownik o takim loginie nie istnieje !')
            return
        print ('To do')
        return
        
    def add_user(self,ex):
        if len(ex)<2:
            name   =input('Podaj nazwę (np. imię i nazwisko:')
        else:
            name=ex[1]
        if len(ex)<3:
            while(True):
                login  =input('Podaj login                     :')
                if not self.check_if_login_exists(login):
                    break
        else:
            if self.check_if_login_exists(ex[2]):
                print('Użytkownik o takim loginie już istnieje !')
                return
            else:
                login=ex[2]
        if len(ex)<4:
            email  =input('Podaj email                     :')
        else:
            email=ex[3]
        if len(ex)<5:
            passwdtmp =input('Podaj hasło                     :')
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