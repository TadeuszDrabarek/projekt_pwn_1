# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Uczniowie(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'STUDENTS')
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
        self.menu.append({'id':'STATUS', 'caption':'Rozliczenia z uczniami', 'hch':0, 'branch':''})
        self.menu.append({'id':'ROZL', 'caption':'Rozliczenie ucznia', 'hch':0, 'branch':''})
        self.menu.append({'id':'PLAN', 'caption':'Pokaż ramowy plan ucznia', 'hch':0, 'branch':''})

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
            elif kw=='STATUS':
                self.status(ex)
                
            elif kw=='ROZL':
                self.rozl(ex)            
                
            elif kw=='PLAN':
                self.plan(ex)                        
        return kw
    
    def menuhelp(self):
        super().menuhelp()
    
    def loaddata(self):
        self.a.select(sqlmapper.loadstudents())     

    def plan(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator ucznia [Enter - rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break                    
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                    break                
                if self.check_studentid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_studentid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return                    
        #planucznia
        self.a.select(sqlmapper.planucznia(int(idus)))
        print("%-15s|%-10s|%20s|%10s|%10s|%10s"%("Dzień","Godzina","Grupa","Długość","Cena","Cena za nieobecność"))
        print('-'*100)
        for row in self.a.result:
            print("%-15s|%-10s|%-20s|%10s|%10s|%10s"%(row[2],row[3],row[5],row[8],row[6],row[7]))        
           
    def rozl(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator ucznia [Enter - rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break                    
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                    break                
                if self.check_studentid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_studentid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return            
        #print(sqlmapper.rozlucznia(int(idus)))
        self.a.select(sqlmapper.rozlucznia(int(idus)))
        print("%5s|%-30s|%13s|%11s|%-50s"%("ID","Uczeń","Data oper.","Kwota","Tytułem"))
        print('-'*100)
        for row in self.a.result:
            print("%5i|%-30s|%13s|%8.2f zł|%-50s"%(row[0],row[1],row[2],row[3],row[4]))        
            
    def status(self,ex):
        if len(ex)>1:
            j=ex[1].upper()
            if not (j in ('S','U')):
                print('Nierozpoznane pole do sortowania, wpisz S - po saldzie lub U - po uczniach')
                return
        else:
            j='S'
        #print(sqlmapper.saldouczniow(j))
        self.a.select(sqlmapper.saldouczniow(j))
        print("%5s|%-30s|%11s|%15s"%("ID","Uczeń","Saldo","Status salda"))
        print('-'*66)
        for row in self.a.result:
            print("%5i|%-30s|%8.2f zł|%-15s"%(row[0],row[1],row[2],row[3]))
        
    def add(self,ex):
        print('Uzupełnij dane ucznia (jeżel nie podasz którejś wartości - nie dodasz ucznia):')
        i=1
        wybor=''
        while (i<=3):
            if i==1:
                pytanie='Podaj nowe imię :'
            elif i==2:
                pytanie='Podaj nowe nazwisko :'
            else:
                pytanie='Podaj nowy adres :'
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
                    else:
                        adres=wejscie
                    #print ('stare i',i)
                    i+=1
                    #print ('nowe i',i)
                    break
            if wybor=='Q':
                break
        if wybor!='Q':
            print('Zapisuję dane...',end='')   
            if self.a.execute(sqlmapper.addstudent(imie,nazwisko,adres)):
                idu=self.a.get_last_id()
                self.a.select(sqlmapper.checkstudentid(idu))
                print('Wprowadzono:')
                print(self)   
        else:
            print('Rezygnacja z wprowadzania nowego ucznia')
            
    def edit(self,ex):
        idus=""
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator ucznia [Enter - rezygnacja]:')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    if idus=="":
                        break                    
                    print('Identyfikator musi być liczbowy')
                if idus=="":
                    break                
                if self.check_studentid(idu):
                    break
                print('Identyfikator nie istnieje')
        else:
            idus=ex[1]
            if idus.isdigit():
                idu=int(idus)
            else:
                print('Identyfikator musi być liczbowy')
                return
            if not self.check_studentid(idu):
                print('Identyfikator nie istnieje')            
                return
        if idus=="":
            return        
        print(self)
        imie=input('Podaj nowe imię ([Enter] - pozostawia obecne :')
        nazwisko=input('Podaj nowe nazwisko ([Enter] - pozostawia obecne :')
        adres=input('Podaj nowy adres ([Enter] - pozostawia obecny :')
        if imie=="":
            imie=self.a.result[0][1]
        if nazwisko=="":
            nazwisko=self.a.result[0][2]
        if adres=="":
            adres=self.a.result[0][3]
        print('Wprowadzam zmianę...', end='')
        self.a.execute(sqlmapper.updatestudent(idu,imie,nazwisko,adres))
        
            
    def check_studentid(self,idu):
        self.a.select(sqlmapper.checkstudentid(idu))
        return len(self.a.result)>0
            
        
    def __str__(self):
        s='%8s|%-20s|%-30s|%-40s\n'%('Id','Imię','Nazwisko','Adres')
        s+='-'*101+'\n'
        for row in self.a.result:
            s+='%8i|%-20s|%-30s|%-40s\n'%(row[0],row[1],row[2],row[3])
        return s 
    
    