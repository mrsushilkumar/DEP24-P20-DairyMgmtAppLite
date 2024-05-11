

class Milk {
  double morning;
  double evening;
  DateTime? dateOfMilk;
  String rfid;
  Milk(
      {required this.rfid,
      this.morning = 0,
      this.evening = 0,
      required this.dateOfMilk});


  Map<String, dynamic> toFireStore() {
    return {
      'morning': morning,
      'evening': evening,
      'dateOfMilk': (dateOfMilk != null) ? dateOfMilk?.millisecondsSinceEpoch : 0,
      'rfid': rfid
    };
  }
}

class MilkByDate {
  DateTime? dateOfMilk;
  double totalMilk;
  MilkByDate({required this.dateOfMilk, this.totalMilk = 0});


  Map<String, dynamic> toFireStore() {
    return {
      'dateOfMilk': (dateOfMilk != null) ? dateOfMilk?.millisecondsSinceEpoch : 0,
      'totalMilk': totalMilk
    };
  }
}
