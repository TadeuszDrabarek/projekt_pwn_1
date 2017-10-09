# -*- coding: utf-8 -*-
from dbconnection import dbconn, sqlmapper
import pymysql
import time

class DB:
    def __init__(self):
        ok=False
        self.dbconntime=0
        print("Łaczenie z bazą danych ...",end='')
        try:
            self.conn=pymysql.connect(host=dbconn.host, user=dbconn.dbuser, passwd=dbconn.dbpassword , db=dbconn.dbname, charset='utf8') #root/root
            self.cursor=self.conn.cursor()
            self.connected=True
            print (' połączono!')
            self.dbconntime=time.time()
        except:
            self.connected=False;
            print(' błąd połączenia !')

    def dbclose(self):
        self.conn.close()

    def select(self,sql):
        try:
            self.cursor.execute(sql)
            self.result=self.cursor.fetchall()
            self.conn.commit()
            return True
        except:
            self.conn.rollback()
            return False
        #self.cursor.close()
    def execute(self,sql):
        try:
            self.cursor=self.conn.cursor()
            self.cursor.execute(sql)
            self.conn.commit()
            print('OK.')
            return True
        except:
            self.conn.rollback()
            print('Błąd!')
            return False
    def insert(self,imie,nazwisko,email,haslo):
        sql="insert into users(name,lastname,email,password) values('%s','%s','%s','%s');"%(imie,nazwisko,email,haslo)
        print(sql)
        try:
            self.cursor=self.conn.cursor()
            self.cursor.execute(sql)
            self.conn.commit()
            print('Dodano.')
        except:
            print('Błąd dodawania.')
    def ask_and_insert(self):
        imie=input('Imię :')
        nazwisko=input('Nazwisko :')
        email=input('Email :')
        haslo=input('Hasło :')
        self.insert(imie,nazwisko,email,haslo)
    def delete(self,id):
        sql="delete from users where id=%i;"%(id)
        print(sql)
        try:
            self.cursor=self.conn.cursor()
            self.cursor.execute(sql)
            self.conn.commit()        
            print('Usunięto.')
        except:
            print('Błąd usuwania.')
