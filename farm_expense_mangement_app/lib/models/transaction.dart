import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  String name;
  double value;
  DateTime? saleOnMonth;

  Sale({required this.name, required this.value, required this.saleOnMonth});

  factory Sale.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Sale(
      name: data?['name'],
      value: data?['value'],
      saleOnMonth:DateTime.fromMillisecondsSinceEpoch(data?['saleOnMonth']),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'name': name,
      'value': value,
      'saleOnMonth': (saleOnMonth != null) ? saleOnMonth?.millisecondsSinceEpoch : 0
    };
  }
}

class Expense {
  String name;
  double value;
  DateTime? expenseOnMonth;

  Expense(
      {required this.name, required this.value, required this.expenseOnMonth});

  factory Expense.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Expense(
      name: data?['name'],
      value: data?['value'],
      expenseOnMonth: DateTime.fromMillisecondsSinceEpoch(data?['expenseOnMonth']),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'name': name,
      'value': value,
      'expenseOnMonth':(expenseOnMonth != null) ? expenseOnMonth?.millisecondsSinceEpoch : 0
    };
  }
}
