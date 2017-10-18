# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Semestry(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'SEM')
        #self.loaddata()
        #self.loadmenu()
        #self.showmenu()
        self.cls=False
        #self.=db
    def loadmenu(self):
        self.menu.clear()
        self.menu.append({'id':'BACK', 'caption':'<Powrót', 'hch':1, 'branch':''})
        self.menu.append({'id':'LIST', 'caption':'Lista', 'hch':0, 'branch':''})
        self.menu.append({'id':'ADD', 'caption':'Dodaj', 'hch':0, 'branch':''})
        #self.menu.append({'id':'DEL', 'caption':'Usuń', 'hch':0, 'branch':''})
        self.menu.append({'id':'EDIT', 'caption':'Edytuj', 'hch':0, 'branch':''})
    def doit(self,lw,ex):
        kw=super().doit(lw,ex,False)
        if kw!='EXIT':
            if kw=='LIST':          #wypisz listę 
                self.loaddata()
                print(self)
            elif kw=='ADD':         #dodaj 
                self.add(ex)
                ''
            elif kw=='DEL':         #usuń 
                #self.user_change_role(ex)                
                ''
            elif kw=='EDIT':         #modyfikuj
                self.edit(ex)                                
                ''
        return kw
    
    def menuhelp(self):
        super().menuhelp()
    
    def loaddata(self):
        self.a.select(sqlmapper.loadsem())     
        
    def add(self,ex):
        print('Uzupełnij dane (jeżel nie podasz którejś wartości - nie dodasz długości :')
        i=1
        wybor=''
        while (i<=3):
            if i==1:
                pytanie='Podaj Nazwę :'
            elif i==2:
                pytanie='Podaj datę od :'
            elif i==3:
                pytanie='Podaj datę do :'
            while (True):
                #print(i)
                wejscie=input(pytanie)
                if wejscie=="":
                    while (True):
                        wybor=input('Nie podałeś wartości, czy chcesz podać ponownie (P,[Enter]), czy przerwać wprowadzanie (Q):').upper()
                        if wybor in ('Q','P',''):
                            break
                    if wybor=='Q':
                        break
                else:
                    #print ('wejscie<>""')
                    if i==1:
                        nazwa=wejscie
                    elif i==2:
                        data_od=wejscie
                    elif i==3:
                        data_do=wejscie
                    #print ('stare i',i)
                    i+=1
                    #print ('nowe i',i)
                    break
            if wybor=='Q':
                break
        if wybor!='Q':
            print('Zapisuję dane...',end='') 
            #print(sqlmapper.addlng(dlugosc,dlg));
            #if False :
            if self.a.execute(sqlmapper.addsem(data_od, data_do, nazwa)):
                idu=self.a.get_last_id()
                self.a.select(sqlmapper.checksemid(idu))
                print('Wprowadzono:')
                print(self)   
        else:
            print('Rezygnacja z wprowadzania')
            
    def edit(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator semestru [Enter - rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break                    
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                    break                
                if self.check_semid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_semid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return        
        print(self)
        nazwa=input('Podaj nową nazwę ([Enter] - pozostawia obecne :')
        data_od=input('Podaj nową datę od (min)([Enter] - pozostawia obecne :')
        data_do=input('Podaj nową datę do (min)([Enter] - pozostawia obecne :')
        
        if nazwa=="":
            nazwa=self.a.result[0][1]
        if data_od=="":
            data_od=self.a.result[0][2]
        if data_do=="":
            data_do=self.a.result[0][3]
        print('Wprowadzam zmianę...', end='')
        self.a.execute(sqlmapper.updatesem(idu,data_od, data_do, nazwa))
        
            
    def check_semid(self,idu):
        self.a.select(sqlmapper.checksemid(idu))
        return len(self.a.result)>0
            
        
    def __str__(self):
        s='%8s|%-20s|%-12s|%-12s\n'%('Id','Nazwa','Data od', 'Data do')
        s+='-'*101+'\n'
        for row in self.a.result:
            s+='%8i|%-20s|%-12s|%-12s\n'%(row[0],row[1],row[2],row[3])
        return s 
    
    