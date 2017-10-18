# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Dlugosci(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'LNG')
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
            if kw=='LIST':          #wypisz listę uczniów
                self.loaddata()
                print(self)
            elif kw=='ADD':         #dodaj ucznia
                self.add(ex)
                ''
            elif kw=='DEL':         #usuń ucznia
                #self.user_change_role(ex)                
                ''
            elif kw=='EDIT':         #modyfikuj
                self.edit(ex)                                
                ''
        return kw
    
    def menuhelp(self):
        super().menuhelp()
    
    def loaddata(self):
        self.a.select(sqlmapper.loadlng())     
        
    def add(self,ex):
        print('Uzupełnij dane (jeżel nie podasz którejś wartości - nie dodasz długości :')
        i=1
        wybor=''
        while (i<=2):
            if i==1:
                pytanie='Podaj Opis :'
            elif i==2:
                pytanie='Podaj liczbę minut :'
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
                        dlugosc=wejscie
                    elif i==2:
                        dlg=int(wejscie)
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
            if self.a.execute(sqlmapper.addlng(dlugosc,dlg)):
                idu=self.a.get_last_id()
                self.a.select(sqlmapper.checklngid(idu))
                print('Wprowadzono:')
                print(self)   
        else:
            print('Rezygnacja z wprowadzania nowej długości')
            
    def edit(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator długości [Enter - rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break                    
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                    break                
                if self.check_lngid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_lngid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return        
        print(self)
        dlugosc=input('Podaj nowy opis ([Enter] - pozostawia obecne :')
        dlg=input('Podaj nową długość (min)([Enter] - pozostawia obecne :')
        #adres=input('Podaj nowy adres ([Enter] - pozostawia obecny :')
        if dlugosc=="":
            imie=self.a.result[0][1]
        if dlg=="":
            nazwisko=self.a.result[0][2]
        #if adres=="":
        #    adres=self.a.result[0][3]
        print('Wprowadzam zmianę...', end='')
        self.a.execute(sqlmapper.updatelng(idu,dlugosc,int(dlg)))
        
            
    def check_lngid(self,idu):
        self.a.select(sqlmapper.checklngid(idu))
        return len(self.a.result)>0
            
        
    def __str__(self):
        s='%8s|%-20s|%-30s\n'%('Id','Opis','Liczba minut')
        s+='-'*101+'\n'
        for row in self.a.result:
            s+='%8i|%-20s|%-30s\n'%(row[0],row[1],row[2])
        return s 
    
    