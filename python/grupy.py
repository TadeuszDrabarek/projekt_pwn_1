# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu
from semestry import Semestry

class Grupy(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'GROUPS')
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
        self.a.select(sqlmapper.loadgrp())     
        
    def add(self,ex):
        print('Uzupełnij dane (jeżel nie podasz którejś wartości - nie dodasz długości :')
        i=1
        wybor=''
        while (i<=2):
            if i==1:
                pytanie='Podaj nazwę grupy:'
            elif i==2:
                pytanie='Podaj identyfikator semestru :'
            while (True):
                #print(i)
                if i==2:
                    s=Semestry(self.a, self.user)
                    s.loaddata()
                    print(s)
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
                        semestr=wejscie
                        if not s.check_semid(int(semestr)) :
                            print ("Podałeś nieistniejący identyfikator, spróbuj ponownie.")
                            continue
                        del s
                    #print ('stare i',i)
                    i+=1
                    #print ('nowe i',i)
                    break
            if wybor=='Q':
                break
        if wybor!='Q':
            print('Zapisuję dane...',end='') 
            
            if self.a.execute(sqlmapper.addgrp(nazwa,semestr)):
                idu=self.a.get_last_id()
                self.a.select(sqlmapper.checkgrpid(idu))
                print('Wprowadzono:')
                print(self)   
        else:
            print('Rezygnacja z wprowadzania')
            
    def edit(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator grupy [Enter - rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break                    
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                    break                
                if self.check_grpid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_grpid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return        
        print(self)
        nazwa=input('Podaj nową nazwę grupy ([Enter] - pozostawia obecną :')
        if nazwa=="":
            nazwa=self.a.result[0][1]    
        cursem=self.a.result[0][3]
        s=Semestry(self.a, self.user)
        s.loaddata()        
        while (True):
            print(s)        
            semestr=input('Podaj nowy id semenstru semestr ([Enter] - pozostawia obecny :')
            if semestr=="":
                semestr=cursem
            if not s.check_semid(int(semestr)) :
                print ("Podałeś nieistniejący identyfikator, spróbuj ponownie.")
            else:
                break
        del s
              
        
        print('Wprowadzam zmianę...', end='')
        self.a.execute(sqlmapper.updategrp(nazwa,int(semestr),idu))
        
            
    def check_grpid(self,idu):
        self.a.select(sqlmapper.checkgrpid(idu))
        return len(self.a.result)>0
            
        
    def __str__(self):
        s='%8s|%-20s|%-20s\n'%('Id','Nazwa grupy', 'Semestr')
        s+='-'*101+'\n'
        for row in self.a.result:
            s+='%8i|%-20s|%-20s\n'%(row[0],row[1],row[2])
        return s 
    
    