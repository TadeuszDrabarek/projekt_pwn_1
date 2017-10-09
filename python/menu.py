# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import os

class Menu:
    def __init__(self,a,u,hp=False):
        self.a=a
        self.menu=[]
        self.user=u
        self.hp=hp
    def loadmenu(self,branch='MAIN'):
        self.menu.clear()
        if self.hp:
            self.menu.append({'id':'BACK', 'caption':'<Powrót', 'hch':1, 'branch':''})
        else:
            self.menu.append({'id':'EXIT', 'caption':'<<Wyjście', 'hch':0, 'branch':''})
        self.a.select(sqlmapper.loadmenusql(self.user.userrole,branch))
        if (len(self.a.result)>1):        
            for i in self.a.result:
                self.menu.append({'id':i[0], 'caption':i[1], 'hch':i[2], 'branch':i[3]})        
                
    def printmenu(self):
        print('Menu:')
        for key,value in enumerate(self.menu):
            print(('%3i-%s(%s) '%(key,value['caption'],value['id']))+('...' if value['hch']>0 else ''), end='')
        print('')  
    
    def doit(self,lw,ex):
        #super().doit(kw)
        os.system("cls")
        print('*'*20)
        kw=self.menu[lw]['id'].upper()
        print('Twój wybór :',self.menu[lw]['caption'].upper())
        return kw
    
    def menuhelp(self):
        print('Możesz wywołać niektóre polecenia z dodatkowymi parametrami:')
        return 
    
    def showmenu(self):
        #self.loadmenu()
        while (True):
            self.printmenu()
            if self.user.username=="":
                s='Jesteś niezalogowany, Twój wybór >'
            else:
                s='"%s(%s)", Twój wybór >'%(self.user.username,self.user.userrole) 
            w=input(s)
            if (w.upper()=='QUIT'):
                break
            if (w.isdigit()):
                lw=int(w)
                if (lw>=0) and lw<len(self.menu):
                    kw=self.doit(lw,[])
                    if kw=='EXIT' or kw=='BACK':
                        break                                            
                else:
                    print('Wartość spoza zakresu!')
            else:
                lw=-1
                sp=w.split(' ')
                #print('>>>',sp)
                w=sp[0]
                if w.upper()=='HELP':
                    self.menuhelp()
                else:
                    for key,value in enumerate(self.menu):
                        if (value['id'].upper()==w.upper()):
                            lw=key
                            break
                    if (lw>=0):
                        kw=self.doit(lw,sp)
                        if kw=='EXIT' or kw=='BACK':
                            #self.a.dbclose()
                            break
                    else:
                        print('Wartość spoza zakresu!' )
            print('-'*40)
        os.system("cls")