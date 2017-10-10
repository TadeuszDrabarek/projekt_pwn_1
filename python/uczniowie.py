# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Uczniowie(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'STUDENTS')
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
        self.menu.append({'id':'DEL', 'caption':'Usuń', 'hch':0, 'branch':''})
        self.menu.append({'id':'EDIT', 'caption':'Edytuj', 'hch':0, 'branch':''})
    def doit(self,lw,ex):
        kw=super().doit(lw,ex,False)
        if kw!='EXIT':
            if kw=='LIST':          #wypisz listę uczniów
                self.loaddata()
                print(self)
            elif kw=='ADD':         #dodaj ucznia
                #self.add_user(ex)
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
        self.a.select(sqlmapper.loadstudents())     
        
    def edit(self,ex):
        if len(ex)<2:
            while(True):
                while(True):
                    idus=input('Podaj identyfikator ucznia :')
                    if idus.isdigit():
                        idu=int(idus)
                        break
                    print('Identyfikator musi być liczbowy')
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
        print(self)
        imie=input('Podaj nowe imię ([Enter] - pozostawia obecne :')
        nazwisko=input('Podaj nowe nazwisko ([Enter] - pozostawia obecne :')
        adres=input('Podaj nowy asdre ([Enter] - pozostawia obecny :')
        if imie=="":
            imie=self.a.result[0][1]
        if nazwisko=="":
            nazwisko=self.a.result[0][2]
        if adres=="":
            adres=self.a.result[0][3]
        print('Wprowadzam zmianę...')
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
    
    