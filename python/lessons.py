# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import hashlib
from menu import Menu
from semestry import Semestry
from grupy import Grupy
from uczniowie import Uczniowie
from nauczyciele import Nauczyciele
import time

def isint(i):
    if i.isdigit():
        return True
    if len(i)>1:
        j=i[1:]
        if j.isdigit():
            return True
    return False

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
        self.menu.append({'id':'CT', 'caption':'Zmienia nauczyciela prowadzącego (zastępwsto)', 'hch':0, 'branch':''})
        self.menu.append({'id':'DETAILS', 'caption':'Wyświetl szczegóły zajęć', 'hch':0, 'branch':''})           
        self.menu.append({'id':'UNDERWAY', 'caption':'Wyświetl listę zajęć w toku', 'hch':0, 'branch':''})           
        self.menu.append({'id':'RUN', 'caption':'Rozpocznij zajęcia', 'hch':0, 'branch':''})           
        self.menu.append({'id':'EDIT', 'caption':'Wchodzi w tryb ustawiania obecności', 'hch':0, 'branch':''})
        self.menu.append({'id':'DONE', 'caption':'Zakończ lekcję !', 'hch':0, 'branch':''})
            
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
            elif kw=='CT':         # 
                self.chu(ex)                                        
                ''
            elif kw=='UNDERWAY':
                self.underway()
                
            elif kw=='DETAILS':
                self.details(ex)
            
            elif kw=='RUN':
                self.run(ex,'RUN')            
                
            elif kw=='DONE':
                self.run(ex,'DONE')                        
                
            elif kw=='EDIT':
                self.run(ex,'EDIT') 
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        
    def underway(self):
        self.printunderway()
    
    def run(self,ex,tryb):
        if len(ex)>1:
            w=ex[1]
            if w.isdigit():
                if not self.checkidzajec(int(w)):
                    print('Nieprawidłowy identyfikator!')
                    return
                if tryb=='RUN':
                    if not self.check_can_run(int(w)):
                        print("Te zajęcia już zostały rozpoczęte!")
                        return   
                if tryb=="DONE":
                    if not self.check_can_done(int(w)):
                        print("Te zajęcia już zostały zakończone!")
                        return   
                if tryb=="EDIT":
                    if not self.check_can_edit(int(w)):
                        print("Te zajęcia nie zostały jeszcze rozpoczęte!")
                        return   
            else:
                return
        else:
            while (True):
                w=input('Podaj ID zajęć [Enter-rezygnacja]:')
                if w=='':
                    return
                if w.isdigit():
                    if self.checkidzajec(int(w)):
                        if tryb=='RUN':
                            if self.check_can_run(int(w)):
                                break
                            else:
                                print("Te zajęcia już zostały rozpoczęte!")
                        if tryb=='DONE':
                            if self.check_can_done(int(w)):
                                break
                            else:
                                print("Te zajęcia już zostały zakończone!")
                        if tryb=='EDIT':
                            if self.check_can_edit(int(w)):
                                break
                            else:
                                print("Te zajęcia nie zostały jeszcze rozpoczęte!")
                    else:
                        print("Nie ma takiego identyfikatora!")
                else:
                    print("Identyfikator musi być cyfrowy!")
        print ('Uruchamiam procedurę na bazie danych ...',end='')
        if tryb=='RUN':
            self.a.execute(sqlmapper.runlesson(int(w)))
        if tryb=="DONE":
            self.a.execute(sqlmapper.donelesson(int(w)))
        if tryb=="EDIT":
            #tu nowe menu 
            # 
            ''
        
    def details(self,ex):
        if len(ex)>1:
            w=ex[1]
            if w.isdigit():
                if not self.checkidzajec(int(w)):
                    print('Nieprawidłowy identyfikator!')
                    return
            else:
                return
        else:
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
        if self.a.select(sqlmapper.lesson_details(int(w))):
            if self.printdetails():
                if self.a.select(sqlmapper.lesson_studentslist(int(w))):
                    self.printstudents()
                else:
                    print('Błąd odczytu danych !')    
            else:
                if self.a.select(sqlmapper.lesson_studentslist2(int(w))):
                    self.printstudents2()
                else:
                    print('Błąd odczytu danych !')                        
        else:
            print('Błąd odczytu danych !')       
            
        
    def printdetails(self):
        print('Szczegóły zajęć :')
        print('--------------------------------------------------------------')
        row=self.a.result[0]
        print('Grupa                      :',row[13])
        print('Planowa data zajęć         :',row[0])
        print('Rzeczywista data zajęć     :',row[1])
        print('Czy zajęcia się odbyły?    :','TAK' if row[2]==1 else 'NIE')
        print('Czy zajęcia były odrabiane :','TAK' if row[3]==1 else 'NIE')
        print('Nauczyciel planowy         :',row[5])
        print('Nauczyciel rzeczywsty      :',row[7])
        print('Godziny zajęć              :',row[8],'-',row[10],row[11])
        print('Liczba uczniów             :',row[12])
        print('--------------------------------------------------------------')
        return True if row[2]=='1' else False
    
    def printstudents(self):
        print('Lista uczniów :')
        for i,row in enumerate(self.a.result):
            print('%3i. %s'%(i,row[2]))
            
    def printstudents2(self):
        print('Lista uczniów :')
        for i,row in enumerate(self.a.result):
            print('%3i. %-30s %s'%(i,row[2], row[3]))
            
    def chu(self,ex):
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
                print("Identyfikator musi być cyfrowy        !")
        while (True):
            print('Nauczyciele:')
            n=Nauczyciele(self.a, self.user)               
            n.loaddata()            
            print(n)
            nid=input('Podaj ID nowego nauczyciela :')
            if nid.isdigit():
                if n.check_teacherid(int(nid)):
                    break
            print('Nieprawidłowy identyfikator nauczyciela!')
        print('Aktualizacja danych ...', end='')
        self.a.execute(sqlmapper.lessonchangeteacher(int(w),int(nid)));
                            
        
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
        
    def checknotrunned(self,idz):
        self.a.select(sqlmapper.checknotrunned(idz))
        return len(self.a.result)>0           
    
    def check_can_edit(self,idz):
        self.a.select(sqlmapper.check_can_edit(idz))
        return len(self.a.result)>0 
    
    def check_can_run(self,idz):
        self.a.select(sqlmapper.check_can_run(idz))
        return len(self.a.result)>0 
    
    def check_can_done(self,idz):
        self.a.select(sqlmapper.check_can_done(idz))
        return len(self.a.result)>0     
    
    def checkidzajec(self,idz):
        self.a.select(sqlmapper.checkidzajec(idz))
        return len(self.a.result)>0   
    
    def cl(self,ex,l):
        if len(ex)>1:
            w1=ex[1]
            if isint(w1):
                wi1=int(w1)
                if abs(wi1)>100:
                    print('Dopuszczalny zakres to +-100 !')
                    return
                d0=time.time()+wi1*24*60*60
                dat=time.gmtime(d0)
                w='%4i-%02i-%02i'%(dat.tm_year,dat.tm_mon,dat.tm_mday)
                self.a.select(sqlmapper.checkdate(w))            
                if self.a.result[0][0]!=1:
                    print('Nieprawidłowa data!')                
                    return
                print('Wybrana data',w)
            else:
                print("Parametr musi być liczbą!")
                return
        else:        
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
            print('|%3s|%10s|%30s|%20s|%5s|%20s|%10s|%s'%('ID','Godzina od','Nauczyciel','Grupa','Zastępstwo','Status','Przeniesienie z/na',''))
            print('-'*105)
            for row in self.a.result:
                print('|%3s|%10s|%30s|%20s|%5s|%20s|%10s|%s'%(row[0],row[2],row[4],row[5],row[6],row[7],row[8],row[9]))                       
        else:
            print('Wystąpił błąd przy odczycie danych!')
    def createz(self,w):
        print('Tworzę plan zajęć na',w,' ...',end='')
        if self.a.execute(sqlmapper.createz(w)):
            self.printplan(w)
        
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
                print('|%5s|%10s|%10s|%30s|%30s|%20s|%3s|'%(row[0],row[2],row[3],row[5],row[4],row[6],row[7]))                       
        else:
            print('Wystąpił błąd przy odczycie danych!')
        
    def printunderway(self):
        if self.a.select(sqlmapper.printunderway()):
            print('|%10s|%5s|%10s|%10s|%30s|%20s|%3s|'%('Data','ID','Godzina od','Godzina do','Lekcję prowadzi','Grupa','Liczebność'))
            print('-'*125)
            for row in self.a.result:
                print('|%10s|%5s|%10s|%10s|%30s|%20s|%3s|'%(row[8],row[0],row[2],row[3],row[4],row[6],row[7]))                       
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
    
    