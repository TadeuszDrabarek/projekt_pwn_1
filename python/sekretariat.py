# -*- coding: utf-8 -*-
from dbconnection import dbconn
from dbmapper import sekretariat
from uczniowie import Uczniowie
from nauczyciele import Nauczyciele
from dlugosci import Dlugosci
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
                del u
            elif kw=='TEACHERS':        #Administracja nauczycielami
                n=Nauczyciele(self.a, self.user)               
                del n
            elif kw=='LNG':
                d=Dlugosci(self.a, self.user)
        return kw
    
    def menuhelp(self):
        super().menuhelp()
        
    