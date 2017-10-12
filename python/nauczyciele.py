# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Nauczyciele(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'TEACHERS')
        #self.loaddata()
        self.loadmenu()
        self.showmenu()
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
        self.a.select(sqlmapper.loadteachers())     
        
    def add(self,ex):
        print('Uzupełnij dane nauczyciela (jeżel nie podasz którejś wartości - przerwiesz wprowadzanie):')
        i=1
        wybor=''
        while (i<=4):
            if i==1:
                pytanie='Podaj imię :'
            elif i==2:
                pytanie='Podaj nazwisko :'
            elif i==3:
                pytanie='Podaj adres :'            
            else:
                pytanie='Podaj numer konta :'
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
                        imie=wejscie
                    elif i==2:
                        nazwisko=wejscie
                    elif i==3:
                        adres=wejscie
                    else:
                        numer_konta=wejscie
                    #print ('stare i',i)
                    i+=1
                    #print ('nowe i',i)
                    break
            if wybor=='Q':
                break
        if wybor!='Q':
            print('Zapisuję dane...',end='')   
            if self.a.execute(sqlmapper.addteacher(imie,nazwisko,adres,numer_konta)):
                idu=self.a.get_last_id()
                self.a.select(sqlmapper.checkteacherid(idu))
                print('Wprowadzono:')
                print(self)   
        else:
            print('Rezygnacja z wprowadzania nowego nauczyciela')
            
    def edit(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator nauczyciela [Enter-rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                        break                
                if self.check_teacherid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_teacherid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return
        print(self)
        imie=input('Podaj nowe imię ([Enter] - pozostawia obecne :')
        nazwisko=input('Podaj nowe nazwisko ([Enter] - pozostawia obecne :')
        adres=input('Podaj nowy adres ([Enter] - pozostawia obecny :')
        numer_konta=input('Podaj nowy numer konta ([Enter] - pozostawia obecny :')
        if imie=="":
            imie=self.a.result[0][1]
        if nazwisko=="":
            nazwisko=self.a.result[0][2]
        if adres=="":
            adres=self.a.result[0][3]
        if numer_konta=="":
            numer_konta=self.a.result[0][4]
        print('Wprowadzam zmianę...', end='')
        self.a.execute(sqlmapper.updateteacher(idu,imie,nazwisko,adres,numer_konta))
        
            
    def check_teacherid(self,idu):
        self.a.select(sqlmapper.checkteacherid(idu))
        return len(self.a.result)>0
            
        
    def __str__(self):
        s='%8s|%-20s|%-20s|%-30s|%20s\n'%('Id','Imię','Nazwisko','Adres','Numer konta')
        s+='-'*111+'\n'
        for row in self.a.result:
            s+='%8i|%-20s|%-20s|%-30s|%20s\n'%(row[0],row[1],row[2],row[3],row[4])
        return s 
    
    