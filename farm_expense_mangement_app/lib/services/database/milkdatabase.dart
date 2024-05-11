import 'package:farm_expense_mangement_app/models/milk.dart';
import 'package:farm_expense_mangement_app/services/initializelocaldatabase.dart';
import 'package:sqflite/sqflite.dart';


Future<List<Milk>> getMilkFromDatabase(DateTime dateTime) async {
  final Database db = await initDatabase();
  final List<Map<String ,dynamic>> items = await db.query('milk',where: 'dateOfMilk = ?' ,whereArgs: [dateTime.millisecondsSinceEpoch]);
  return List.generate(items.length, (index) {
    return Milk(
        rfid: items[index]['rfid'],
        dateOfMilk: DateTime.fromMillisecondsSinceEpoch(items[index]['dateOfMilk']),
        morning: items[index]['morning'],
        evening: items[index]['evening']
    );
  });
}

Future addMilkInDatabase(Milk milk) async {
  final Database db = await initDatabase();
  return db.insert('milk', milk.toFireStore(),conflictAlgorithm: ConflictAlgorithm.replace);
}

Future deleteMilkFromDatabase(DateTime dateOfMilk) async {
  final Database db = await initDatabase();
  return db.delete('milk',where: 'dateOfMilk = ?',whereArgs: [dateOfMilk.millisecondsSinceEpoch]);
}

Future updateMilkInDatabase(Milk milk) async {
  final Database db = await initDatabase();
  return db.update('milk', milk.toFireStore(),where: 'rfid = ? AND dateOfMilk = ?',whereArgs: [milk.rfid,milk.dateOfMilk?.millisecondsSinceEpoch],conflictAlgorithm:  ConflictAlgorithm.replace);
}



Future<List<MilkByDate>> getAllMilkByDateFromDatabase() async {
  final Database db = await initDatabase();
  final List<Map<String,dynamic>> items = await db.query('milkByDate',orderBy: 'dateOfMilk DESC');
  return List.generate(items.length, (index) {
    return MilkByDate(
      dateOfMilk: DateTime.fromMillisecondsSinceEpoch(items[index]['dateOfMilk']),
      totalMilk: items[index]['totalMilk']
    );
  });
}

Future<MilkByDate> getMilkByDateFromDatabase(DateTime dateTime) async {
  final Database db = await initDatabase();
  final List<Map<String,dynamic>> items = await db.query('milkByDate',where: 'dateOfMilk = ?' ,whereArgs: [dateTime.millisecondsSinceEpoch],limit: 1);
  if(items.isNotEmpty) {
    return MilkByDate(
        dateOfMilk: DateTime.fromMillisecondsSinceEpoch(
            items.first['dateOfMilk']),
        totalMilk: items.first['totalMilk']

    );
  }
  else {
    return MilkByDate(dateOfMilk: dateTime,totalMilk: 0);
  }
}

Future addMilkByDateInDatabase(MilkByDate milkByDate) async {
  final Database db = await initDatabase();
  return await db.insert('milkByDate', milkByDate.toFireStore(),conflictAlgorithm: ConflictAlgorithm.replace);
}

Future updateMilkByDateInDatabase(MilkByDate milkByDate) async {
  final Database db = await initDatabase();
  return await db.update('milkByDate', milkByDate.toFireStore(),where: 'dateOfMilk = ?',whereArgs: [milkByDate.dateOfMilk?.millisecondsSinceEpoch],conflictAlgorithm: ConflictAlgorithm.replace);
}

Future deleteMilkByDateFromDatabase(DateTime dateTime) async {
  final Database db = await initDatabase();
  return await db.delete('milkByDate');
}