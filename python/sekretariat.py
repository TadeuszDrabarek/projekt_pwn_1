# -*- coding: utf-8 -*-
from dbconnection import dbconn
from dbmapper import sekretariat
from uczniowie import Uczniowie
from nauczyciele import Nauczyciele
from dlugosci import Dlugosci
from semestry import Semestry
from grupy import Grupy
from uwg import Uwg

import pymysql
import hashlib
from menu import Menu

class Sekretariat(Menu):
    
    def __init__(self,db,u):
        super().__init__(db,u,True,'SEKR')
        #self.=db
    def doit(self,lw,ex):
        kw=super().doit(lw,ex)
        if kw!='EXIT':
            if kw=='STUDENTS':          #Administracja studentami
                #self.print_userlist(ex)
                u=Uczniowie(self.a, self.user) 
                u.loadmenu()
                u.showmenu()
                del u
            elif kw=='TEACHERS':        #Administracja nauczycielami
                n=Nauczyciele(self.a, self.user)               
                n.loadmenu()
                n.showmenu()
                del n
            elif kw=='LNG':
                d=Dlugosci(self.a, self.user)
                d.loadmenu()
                d.showmenu()                
                del d
            elif kw=='SEM':
                s=Semestry(self.a, self.user)  
                s.loadmenu()
                s.showmenu()
                del s
            elif kw=='GROUPS':
                g=Grupy(self.a, self.user)  
                g.loadmenu()
                g.showmenu()
                del g
            elif kw=='UWG':
                #print('A')
                ga=Uwg(self.a, self.user)  
                #print('B')
                #ga.loadmenu()
                #print('C')
                ga.showmenu()
                del g            
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        
    