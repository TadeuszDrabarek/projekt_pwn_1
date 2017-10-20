# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Obecnosci(Menu):
    
    def __init__(self,db,u,lessonid):
        super().__init__(db,u,True,'OBECN')
        #self.loaddata()
        #self.loadmenu()
        #self.showmenu()
        self.cls=False
        self.lid=lessonid
        #self.=db
    def loadmenu(self):
        self.menu.clear()
        self.menu.append({'id':'BACK', 'caption':'<Powrót', 'hch':1, 'branch':''})
        self.menu.append({'id':'SET', 'caption':'Oznacz obecność', 'hch':0, 'branch':''})
        self.menu.append({'id':'UNSET', 'caption':'Oznacz nieobecność', 'hch':0, 'branch':''})
    
    def printmenu(self):
        super().printmenu()
        if self.loaddata():
            print(self)
        else:
            print('Błąd odczytu danych!')
        
    def doit(self,lw,ex):
        kw=super().doit(lw,ex,False)
        if kw!='EXIT':
            if kw=='SET':          #wypisz listę 
                self.chg(ex,kw)
            elif kw=='UNSET':         #dodaj                 
                self.chg(ex,kw)
        return kw
    
    def chg(self,ex,kw):
        if len(ex)>1:
            w=ex[1]
            if w.isdigit():
                uid=int(w)
                if not self.checksol(uid):
                    print("Ten uczeń nie bierze udziału w tej lekcji!")
                    return 
            else:
                print('Identyfikator musi być liczbą!')
                return
        else:
            while (True):
                w=input("Podaj identyfikator ucznia :")
                if w.isdigit():
                    uid=int(w)
                    if self.checksol(uid):
                        break
                    else:
                        print("Ten uczeń nie bierze udziału w tej lekcji!")
                else:
                    print('Identyfikator musi być liczbą!')
                    
        print ('Zmieniam ',kw, self.lid, uid,'...', end='')
        self.setobecnosc(uid,1 if kw=='SET' else 0)
                
    def checksol(self,uid):
        if self.a.select(sqlmapper.checksol(self.lid, uid)):
            if len(self.a.result)>0:
                return True
        return False   
    
    def setobecnosc(self,uid,ob):
        self.a.execute(sqlmapper.setobecnosc(self.lid, uid,ob))
    
    def menuhelp(self):
        super().menuhelp()
    
    def loaddata(self):
        return self.a.select(sqlmapper.obecnosci(self.lid))     
        
        
    def __str__(self):
        s='%8s|%-20s|%-20s\n'%('Id','Uczeń', 'Obecność')
        s+='-'*101+'\n'
        #print(self.a.result)
        for row in self.a.result:
            s+='%8i|%-20s|%-20s\n'%(row[4],row[1],row[2])
        return s 
    
    