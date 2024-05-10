
class CattleHistory {
  final String rfid;
  final String name;
  final DateTime date;

  CattleHistory({required this.rfid,required this.name, required this.date});


  Map<String, dynamic> toFireStore() {
    // final Timestamp timestamp = Timestamp.fromDate(date);
    return {'rfid':rfid,'name': name, 'date': date.millisecondsSinceEpoch};
  }

}
