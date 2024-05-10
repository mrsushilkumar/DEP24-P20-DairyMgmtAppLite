
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  return openDatabase(
      join(
          await getDatabasesPath(),'cattle_database.db'
      ),
    onCreate: (db,version) async {
        await db.execute(
            'CREATE TABLE cattles(rfid TEXT PRIMARY KEY,sex STRING,age INTEGER,breed TEXT,weight INTEGER,state TEXT,source TEXT)'
        );
        await db.execute(
            'CREATE TABLE feed(itemName TEXT,quantity INTEGER,category TEXT,expiryDate INTEGER,requiredQuantity INTEGER,PRIMARY KEY(itemName))'
        );
        await db.execute(
            'CREATE TABLE cattleHistory(rfid TEXT NOT NULL,name TEXT,date INTEGER,PRIMARY KEY(name,date),FOREIGN KEY(rfid) REFERENCES cattles(rfid))'
        );
        await db.execute(
            'CREATE TABLE sales(name TEXT,value REAL,saleOnMonth INTEGER,PRIMARY KEY(name,saleOnMonth))'
        );
        await db.execute(
            'CREATE TABLE expenses(name TEXT,value REAL,expenseOnMonth INTEGER,PRIMARY KEY(name,expenseOnMonth))'
        );
        await db.execute(
            'CREATE TABLE milk(morning REAL,evening REAL,dateOfMilk INTEGER,rfid TEXT NOT NULL,UNIQUE(rfid,dateOfMilk),FOREIGN KEY(rfid) REFERENCES cattles(rfid))'
        );
        await db.execute(
            'CREATE TABLE milkByDate(dateOfMilk INTEGER,totalMilk REAL,PRIMARY KEY(dateOfMilk))'
        );
    },
    version: 1
  );
}