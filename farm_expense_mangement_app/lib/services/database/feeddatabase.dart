//TODO: for Cattle database access
import 'package:farm_expense_mangement_app/services/initializelocaldatabase.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/feed.dart';

Future<List<Feed>> getFeedFromDatabase() async {
  final Database db = await initDatabase();
  final List<Map<String, dynamic>> items = await db.query('feed');
  return List.generate(items.length, (index) {
    return Feed(
        itemName: items[index]['itemName'],
        quantity: items[index]['quantity'],
        requiredQuantity: items[index]['requiredQuantity'],
        expiryDate: DateTime.fromMillisecondsSinceEpoch(items[index]['expiryDate']),
        category: items[index]['category']);
  });
}

Future addFeedInDatabase(Feed feed) async {
  final Database db = await initDatabase();
  return db.insert('feed', feed.toFireStore(),conflictAlgorithm:  ConflictAlgorithm.replace);
}

Future deleteFeedFromDatabase(Feed feed) async {
  final Database db = await initDatabase();
  return db.delete('feed',where: 'itemName = ?',whereArgs: [feed.itemName]);
}

Future updateFeedInDatabase(Feed feed) async {
  final Database db = await initDatabase();
  return db.update('feed', feed.toFireStore(),where: 'itemName = ? ',whereArgs: [feed.itemName]);
}
