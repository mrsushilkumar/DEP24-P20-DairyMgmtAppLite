

class Sale {
  String name;
  double value;
  DateTime? saleOnMonth;

  Sale({required this.name, required this.value, required this.saleOnMonth});


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


  Map<String, dynamic> toFireStore() {
    return {
      'name': name,
      'value': value,
      'expenseOnMonth':(expenseOnMonth != null) ? expenseOnMonth?.millisecondsSinceEpoch : 0
    };
  }
}
