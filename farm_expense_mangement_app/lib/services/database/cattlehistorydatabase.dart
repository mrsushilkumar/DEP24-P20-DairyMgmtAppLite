
import 'package:farm_expense_mangement_app/models/history.dart';
import 'package:sqflite/sqflite.dart';

import '../initializelocaldatabase.dart';


Future<List<CattleHistory>> getCattleHistory(String rfid) async {
  final Database db = await initDatabase();
  final List<Map<String, dynamic>> items = await db.query('cattleHistory',where: 'rfid = ?',whereArgs: [rfid],orderBy: 'date DESC');
  return List.generate(items.length, (index) {
    return CattleHistory(
        rfid: items[index]['rfid'],
        date: DateTime.fromMillisecondsSinceEpoch(items[index]['date']),
        name: items[index]['name']
    );
  });
}

Future addCattleHistoryToDatabase(CattleHistory cattleHistory) async {
  final Database db = await initDatabase();
  return await db.insert('cattleHistory', cattleHistory.toFireStore(),conflictAlgorithm: ConflictAlgorithm.replace);

}

Future deleteCattleHistoryFromDatabase(CattleHistory cattleHistory) async {
  final Database db = await initDatabase();
  return await db.delete('cattleHistory',where: 'name = ? AND date = ?',whereArgs: [cattleHistory.name,cattleHistory.date.millisecondsSinceEpoch]);
}

Future updateCattleHistoryInDatabase(CattleHistory cattleHistory) async {
  final Database db = await initDatabase();
  return await db.update('cattleHistory', cattleHistory.toFireStore(),where: 'name = ? AND date = ?',whereArgs: [cattleHistory.name,cattleHistory.date.millisecondsSinceEpoch]);
}

