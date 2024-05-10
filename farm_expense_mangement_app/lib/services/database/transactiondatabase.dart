
import 'package:farm_expense_mangement_app/models/transaction.dart';
import 'package:farm_expense_mangement_app/services/initializelocaldatabase.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Sale>> getAllSaleFromDatabase() async {
  final Database db = await initDatabase();
  final List<Map<String,dynamic>> items = await db.query('sales');
  return List.generate(items.length, (index) {
    return Sale(
        name: items[index]['name'],
        value: items[index]['value'],
        saleOnMonth: DateTime.fromMillisecondsSinceEpoch(items[index]['saleOnMonth'])
    );
  });
}

Future addSaleInDatabase(Sale sale) async {
  final Database db = await initDatabase();
  return db.insert('sales', sale.toFireStore());
}

Future updateSaleInDatabase(Sale sale) async {
  final Database db = await initDatabase();
  return db.update('sales', sale.toFireStore(),where: 'name =? AND saleOnMonth =?',whereArgs: [sale.name,sale.saleOnMonth?.millisecondsSinceEpoch]);

}

Future deleteSaleFromDatabase (Sale sale) async {
  final Database db = await initDatabase();
  return db.delete('sales',where: 'name =? AND saleOnMonth =?',whereArgs: [sale.name,sale.saleOnMonth?.millisecondsSinceEpoch]);
}



Future<List<Expense>> getAllExpenseFromDatabase() async {
  final Database db = await initDatabase();
  final List<Map<String,dynamic>> items = await db.query('expenses');
  return List.generate(items.length, (index) {
    return Expense(
        name: items[index]['name'],
        value: items[index]['value'],
        expenseOnMonth: DateTime.fromMillisecondsSinceEpoch(items[index]['expenseOnMonth'])
    );
  });
}

Future addExpenseInDatabase(Expense expense) async {
  final Database db = await initDatabase();
  return db.insert('expenses', expense.toFireStore());
}

Future updateExpenseInDatabase(Expense expense) async {
  final Database db = await initDatabase();
  return db.update('expenses', expense.toFireStore(),where: 'name =? AND expenseOnMonth =?',whereArgs: [expense.name,expense.expenseOnMonth?.millisecondsSinceEpoch]);

}

Future deleteExpenseFromDatabase (Expense expense) async {
  final Database db = await initDatabase();
  return db.delete('expenses',where: 'name =? AND expenseOnMonth =?',whereArgs: [expense.name,expense.expenseOnMonth?.millisecondsSinceEpoch]);
}
