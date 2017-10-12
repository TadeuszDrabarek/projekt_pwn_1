# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu

class Role(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'APPROLES')
        self.loaddata()
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
        self.a.select(sqlmapper.loadroles())     
        
    def add(self,ex):
        print('Uzupełnij dane roli (jeżel nie podasz którejś wartości - nie dodasz roli):')
        i=1
        wybor=''
        while (i<=2):
            if i==1:
                pytanie='Podaj kod roli :'
            elif i==2:
                pytanie='Podaj opis roli :'
            
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
                        roleid=wejscie
                    elif i==2:
                        rolename=wejscie                                        
                    i+=1                    
                    break
            if wybor=='Q':
                break
        if wybor!='Q':
            print('Zapisuję dane...',end='')   
            if self.a.execute(sqlmapper.addrole(roleid, rolename)):
                self.a.select(sqlmapper.checkroleid(roleid))
                print('Wprowadzono:')
                print(self)   
        else:
            print('Rezygnacja z wprowadzania nowej roli')
            
    def edit(self,ex):
        roleid=""
        if len(ex)<2:
            while(True):
                roleid=input('Podaj identyfikator roli [Enter - rezygnacja]:')
                if roleid=="":
                    break                    
                if self.check_roleid(roleid):
                    break
                print('Identyfikator nie istnieje')
        else:
            roleid=ex[1]
            if not self.check_roleid(roleid):
                print('Identyfikator nie istnieje')            
                return
        if roleid=="":
            return        
        print(self)
        rolename=input('Podaj nowy opis roli ([Enter] - pozostawia obecny :')        
        if rolename=="":
            rolename=self.a.result[0][1]
        
        print('Wprowadzam zmianę...', end='')
        self.a.execute(sqlmapper.updaterole(roleid, rolename))
        
            
    def check_roleid(self,roleid):
        self.a.select(sqlmapper.checkroleid(roleid))
        return len(self.a.result)>0
            
        
    def __str__(self):
        s='%10s|%-40s\n'%('Id Roli','Opis roli')
        s+='-'*51+'\n'
        for row in self.a.result:
            s+='%10s|%-40s\n'%(row[0],row[1])
        return s 
    
    