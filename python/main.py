# -*- coding: utf-8 -*-
# To jest początek programu


from dbconnection import sqlmapper
from db import DB
from appusers import User, AppUsers
from menu import Menu
import hashlib
import time
import os



class MainMenu(Menu):
    def __init__(self,db,u):
        super().__init__(db,u)
        print('Witaj...')
        self.print_now()
    def menuhelp(self):
        super().menuhelp()
        print ("LOGIN [user [password]] - logowanie")
        return     
    
    def doit(self,lw,ex):
        kw=super().doit(lw,ex)
        #os.system("cls")
        #print('*'*20)
        #print('Twój wybór :',kw)
        if kw=='LOGIN':       #zalogu się
            if not (self.user.loggedin):
                if not self.log_in(ex):
                    print('Przekroczyłeś limit prób logowania!')
                    print('Wyjście z programu')
                    return 'EXIT'
        #elif kw=='LST':       #wypisz listę userów
        #    au=AppUsers(self.a)
        #    au.print_userlist()
        elif kw=='LOGOUT':    #wyloguj się
            del self.user
            self.user=User()
            self.loadmenu()
            os.system("cls")
            print('Wylogowanie!')
        elif kw=='GETTIME':
            self.print_now()
        elif kw=='ADU':
            submenu=AppUsers(self.a, self.user)
            submenu.loadmenu('ADU')
            submenu.showmenu()
            del submenu
        elif kw=='EXIT':
            if not input('Czy na pewno chcesz wyjść (T/N) ?').upper()=='T':
                return 'DONT EXIT'
            else:
                return kw
        else:
            return kw
            
    def print_now(self):
        now=time.gmtime(time.time())
        print('Dziś jest :%4i-%02i-%02i, %02i:%02i'%(now.tm_year,now.tm_mon,now.tm_mday,now.tm_hour,now.tm_min))        
        
    def log_in(self,ex):
        ile=1    
        print('Logowanie:')
        while(True):
            if len(ex)<2:
                user=  input('Podaj login (email) :')
            else:
                user=ex[1]
            if len(ex)<3:
                passwdtmp=input('Podaj hasło         :')
            else:
                passwdtmp=ex[2]
            passwd=hashlib.md5(str(passwdtmp).encode("utf-8")).hexdigest()
            sql=sqlmapper.loginsql(user,passwd)
            self.a.select(sql)
            if (len(self.a.result)==1):
                del (self.user)
                self.user=User(self.a.result[0][0],self.a.result[0][3],self.a.result[0][1],self.a.result[0][2],self.a.result[0][4])
                os.system("cls")
                print("Zostałeś zalogowany jako :%s (%s)"%(self.user.username,self.user.userrole))
                self.loadmenu()
                break
            elif (len(self.a.result)>1):
                print("Problem z danymi logowania, dopasowano więcej niż jednego użytkownika!")
                break
            print('Błędny user lub hasło!. Masz jeszcze %i prób.'%(3-ile))
            ex=[]
            ile+=1
            if(ile>3):
                break
        return self.user.loggedin   

    
db=DB();  
user=User()

a=MainMenu(db,user)
a.loadmenu()
a.showmenu()

db.dbclose()
del db
del a
del user
print('Bye, bye :-)')