# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu
from semestry import Semestry
from grupy import Grupy
from uczniowie import Uczniowie

class Lessons(Menu):
    
    def __init__(self,db,u):
        #print('E')
        #self.loaddata()
        #self.loadmenu()
        #self.showmenu()
        self.cls=False
        #print('self/grupa,self.grupa')
        #self.=db
        #print('F')
        super().__init__(db,u,True,'LESSONS')
        #print('G')
    def loadmenu(self):
        self.menu.clear()
        self.menu.append({'id':'BACK', 'caption':'<Powrót', 'hch':1, 'branch':''})
        self.menu.append({'id':'CHECK', 'caption':'Sprawdź i wyświetl zajęcia na dzień', 'hch':0, 'branch':''})
        self.menu.append({'id':'CL', 'caption':'Sprawdź plan w planie ramowym', 'hch':0, 'branch':''})
        self.menu.append({'id':'STATUS', 'caption':'Pokaż status lekcji z dnia', 'hch':0, 'branch':''})
        self.menu.append({'id':'MK', 'caption':'Twórz zajęcia na zadany zakres czasu', 'hch':0, 'branch':''})
        self.menu.append({'id':'MV', 'caption':'Przsuwa zajęcia na inny dzień', 'hch':0, 'branch':''})
        self.menu.append({'id':'CT', 'caption':'Zmienia nauczyciela prowadzącego', 'hch':0, 'branch':''})
        self.menu.append({'id':'DETAILS', 'caption':'Wyświetl szczegóły zajęć', 'hch':0, 'branch':''})           
        self.menu.append({'id':'EDIT', 'caption':'Wchodzi w tryb ustawiania obecności', 'hch':0, 'branch':''})
            
    def printmenu(self):
        super().printmenu();
        
    def doit(self,lw,ex):
        kw=super().doit(lw,ex,False)
        if kw!='EXIT':
            if kw=='SELECT':          #
                #self.selectgrp(ex)
                ''
            elif kw=='CL':          #
                self.cl(ex,1)
                ''
            elif kw=='CHECK':         # 
                self.cl(ex,2)                
                ''
            elif kw=='MK':         # 
                self.cl(ex,3)
                '            '
            elif kw=='STATUS':         #d
                self.cl(ex,4)                                
                ''
            elif kw=='MV':         # 
                self.mv(ex)                            
                ''
            elif kw=='DELALL':         # 
                #self.delete_all(ex)                                        
                ''
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        
    def mv(self,ex):
        while (True):
            w=input('Podaj ID zajęć [Enter-rezygnacja]:')
            if w=='':
                return
            if w.isdigit():
                if self.checkidzajec(int(w)):
                    break
                else:
                    print("Nie ma takiego identyfikatora!")
            else:
                print("Identyfikator musi być cyfrowy!")
        while (True):
            w1=input('Podaj nową datę zajęć [Enter-rezygnacja]:')
            if w1=='':
                return            
            self.a.select(sqlmapper.checkdate(w1))            
            if self.a.result[0][0]==1:
                break
            print('Nieprawidłowa data spóbuj ponownie.')
        #print(sqlmapper.zmienterminzajec(int(w),w1))
        print('Aktualizacja danych ...',end='')
        
        self.a.execute(sqlmapper.zmienterminzajec(int(w),w1))  
        
    def checkidzajec(self,idz):
        self.a.select(sqlmapper.checkidzajec(idz))
        return len(self.a.result)>0   
    
    def cl(self,ex,l):
        while (True):
            w=input('Podaj datę zajęć [Enter - rezygnacja]:')
            if w=='':
                return            
            self.a.select(sqlmapper.checkdate(w))            
            if self.a.result[0][0]==1:
                break
            print('Nieprawidłowa data spóbuj ponownie.')
        if l==1:
            self.printppd(w)
        elif l==2:
            self.printplan(w)
        elif l==3:
            self.createz(w)
        elif l==4:
            self.status(w)        
        
    
    def status(self,w):
        if self.a.select(sqlmapper.status(w)):
            print('|%10s|%10s|%30s|%20s|%5s|%20s|%10s|'%('Godzina od','Godzina do','Nauczyciel','Grupa','Zastępstwo','Status','Przeniesienie z/na'))
            print('-'*105)
            for row in self.a.result:
                print('|%10s|%10s|%30s|%20s|%5s|%20s|%10s|'%(row[2],row[3],row[4],row[5],row[6],row[7],row[8]))                       
        else:
            print('Wystąpił błąd przy odczycie danych!')
    def createz(self,w):
        print('Tworzę plan zajęć na',w,' ...',end='')
        if self.a.execute(sqlmapper.createz(w)):
            printplan(w)
        
    def printppd(self,w):
        if self.a.select(sqlmapper.planowyplannadzien(w)):
            print('|%10s|%10s|%30s|%20s|'%('Godzina od','Godzina do','Nauczyciel','Grupa'))
            print('-'*75)
            for row in self.a.result:
                print('|%10s|%10s|%30s|%20s|'%(row[2],row[3],row[4],row[5]))                       
        else:
            print('Wystąpił błąd przy odczycie danych!')
            
    def printplan(self,w):
        if self.a.select(sqlmapper.plannadzien(w)):
            print('|%5s|%10s|%10s|%30s|%30s|%20s|%3s|'%('ID','Godzina od','Godzina do','Nauczyciel planowy','Nauczyciel rzeczywisty','Grupa','Liczebność'))
            print('-'*115)
            for row in self.a.result:
                print('|%5s|%10s|%10s|%30s|%30s|%20s|%3s|'%(row[0],row[2],row[3],row[4],row[5],row[6],row[7]))                       
        else:
            print('Wystąpił błąd przy odczycie danych!')
        
        
        # odstąd kasowanie
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
        
        
        # dotąd kasowanie
                
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
    
    