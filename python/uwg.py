# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu
from semestry import Semestry
from grupy import Grupy
from uczniowie import Uczniowie

class Uwg(Menu):
    
    def __init__(self,db,u):
        #print('E')
        #self.loaddata()
        #self.loadmenu()
        #self.showmenu()
        self.cls=False
        self.grupa=-1
        self.nazwagrupy=""
        #print('self/grupa,self.grupa')
        #self.=db
        #print('F')
        super().__init__(db,u,True,'UWG')
        self.g=Grupy(self.a, self.user)
        #print('G')
    def loadmenu(self):
        self.menu.clear()
        self.menu.append({'id':'BACK', 'caption':'<Powrót', 'hch':1, 'branch':''})
        self.menu.append({'id':'SELECT', 'caption':'Wybierz grupę', 'hch':0, 'branch':''})
        if self.grupa>0:
            self.menu.append({'id':'LIST', 'caption':'Wypisz uczniów w grupie', 'hch':0, 'branch':''})
            self.menu.append({'id':'JOIN', 'caption':'Dodaj ucznia do grupy', 'hch':0, 'branch':''})
            self.menu.append({'id':'EXCLUDE', 'caption':'Wypisz ucznia z grupy', 'hch':0, 'branch':''})
            self.menu.append({'id':'UNEXCLUDE', 'caption':'Przywróć ucznia do grupy', 'hch':0, 'branch':''})
            self.menu.append({'id':'DEL', 'caption':'Usuń ucznia z grupy', 'hch':0, 'branch':''})           
            self.menu.append({'id':'DELALL', 'caption':'Usuń wszystkich uczniów z grupy', 'hch':0, 'branch':''})
            
    def printmenu(self):
        super().printmenu();
        if self.grupa<0:
            print('Nie wybrano grupy')
        else:
            print('Wybrana grupa :',self.grupa, self.nazwagrupy)
    def doit(self,lw,ex):
        kw=super().doit(lw,ex,False)
        if kw!='EXIT':
            if kw=='SELECT':          #wypisz listę grup do wyboru
                self.selectgrp(ex)
            elif kw=='LIST':          #wypisz listę uczniów w grupie
                self.listgrp()
                ''
            elif kw=='EXCLUDE':         #usuń 
                self.delete(ex)                
                ''
            elif kw=='DEL':         #usuń 
                self.remove(ex)                
                '            '
            elif kw=='JOIN':         #dodaj ucznia do grupy
                self.add()                                
                ''
            elif kw=='UNEXCLUDE':         #usuń 
                self.undelete(ex)                            
                
            elif kw=='DELALL':         #usuń 
                self.delete_all(ex)                                        
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        
    def delete_all(self,ex):
        print('Lista uczniów w grupie')
        self.listgrp()
        wynik=input('Czy usunąć wszystkich OPERACJA BĘDZIE NIEODWRACALNA ? (USUŃ/N):')
        if wynik.upper()=='USUŃ':
            print('Usuwam uczniów z grupy')
            self.a.execute(sqlmapper.delallufg(self.grupa))
        
    def delete(self,ex):
        print('Lista uczniów w grupie')
        self.listgrp()
        while (True):
            wynik=input('Podaj ID ucznia do wypisania [Enter-rezygnacja]:')
            if wynik=='':
                return
            if wynik.isdigit():
                w=int(wynik)
                u=Uczniowie(self.a, self.user)
                if u.check_studentid(w):
                    del u
                    break
                del u
                print('Uczeń o podanym ID nie istnieje!'                )
        print('Wypisuję ucznia z grupy')
        self.a.execute(sqlmapper.delufg(self.grupa,w))
        
    def remove(self,ex):
        print('Lista uczniów w grupie')
        self.listgrp()
        while (True):
            wynik=input('Podaj ID ucznia do usunięcia [Enter-rezygnacja]:')
            if wynik=='':
                return
            if wynik.isdigit():
                w=int(wynik)
                u=Uczniowie(self.a, self.user)
                if u.check_studentid(w):
                    del u
                    break
                del u
                print('Uczeń o podanym ID nie istnieje!'                )
        print('Usuwam ucznia z grupy')
        self.a.execute(sqlmapper.remufg(self.grupa,w))


    def undelete(self,ex):
        print('Lista uczniów w grupie')
        self.listgrp()
        while (True):
            wynik=input('Podaj ID ucznia do przywrócenia [Enter-rezygnacja]:')
            if wynik=='':
                return
            if wynik.isdigit():
                w=int(wynik)
                u=Uczniowie(self.a, self.user)
                if u.check_studentid(w):
                    del u
                    break
                del u
                print('Uczeń o podanym ID nie istnieje!'                )
        print('Przywracam ucznia do grupy')
        self.a.execute(sqlmapper.undelufg(self.grupa,w))
        
    def add(self):
        print ('Dodawanie ucznia do grupy')
        while (True):
            wybor=input('Podaj ID lub fragment imienia i nazwiska do wyszukania, [Enter - przerwanie] :')
            if wybor.isdigit():
                # Podano identyfikator
                w=int(wybor)
                u=Uczniowie(self.a, self.user)
                if u.check_studentid(w):
                    del u
                    break
                del u
                print('Uczeń o podanym ID nie istnieje!')
            else:
                if wybor=="":   #wybrano Enter - wyjście
                    return
                # nie podano identyfikatora, ale może podano fragment imienia/nazwiska
                u=Uczniowie(self.a, self.user)
                self.loaddata_filtered(wybor)
                print(u)
                del u
        od=input('Podaj datę od kiedy [Enter=od teraz] :')
        do=input('Podaj datę do kiedy [Enter=do końca grupy w semestrze] :')
        
        print(sqlmapper.addutg(w,self.grupa,od,do))
        print('Dodaję ucznia od ID %i do grupy ...'%(w),end='')        
        self.a.execute(sqlmapper.addutg(w,self.grupa,od,do))
        
    def listgrp(self):
        if self.loaddata():
            print(self.__str__())
        else:
            print("Nie wiem jak tu trafiłeś, skoro nie wybrałeś grupy !");
    def selectgrp(self,ex):
        self.g.loaddata()
        if len(ex)<2:
            print("Lista grup do wyboru:")
            print(self.g)        
            while (True):
                wybor=input("Podaj identyfikator grupy [Enter - rezygnacja]:")
                if wybor=="":
                    return
                if wybor.isdigit():
                    grupa=int(wybor)
                    if self.g.check_grpid(grupa):
                        self.grupa=grupa
                        self.nazwagrupy=self.a.result[0][1]
                        break
                    else:
                        print("Podany ID grupy nie istnieje, wybierz ponownie.")
                else:
                    print('Identyfikator musi być liczbowy! Podaj ponownie.')
        else:
            wybor=ex[1]
            if wybor.isdigit():
                grupa=int(wybor)
            else:
                print('ID grupy musi być liczbą')
                return
            if self.g.check_grpid(grupa):
                self.grupa=grupa
                self.nazwagrupy=self.a.result[0][1]
            else:
                print("Podany ID grupy nie istnieje.")            
                return
        print('Wybrana grupa :')
        print(self.g);
    
        self.loadmenu();
        #self.loaddata();
                
    def loaddata(self):
        if self.grupa>0:
            self.a.select(sqlmapper.loaduig(self.grupa)) 
            return True
        else:
            return False
                   
    def loaddata_filtered(self,f):
        if self.grupa>0:
            self.a.select(sqlmapper.loaduigf(f)) 
            return True
        else:
            return False    
        
    def __str__(self):
        s='%5s|%-30s|%-20s|%-12s|%-12s\n'%('ID','Uczeń','Grupa', 'Dołączył', 'Odłączy(ł)')
        s+='-'*86+'\n'
        for row in self.a.result:
            s+='%5i|%-30s|%-20s|%-12s|%12s\n'%(row[0],row[1],row[3],row[4],row[5])
        return s 
    
    