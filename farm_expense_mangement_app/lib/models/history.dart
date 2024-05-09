import 'package:cloud_firestore/cloud_firestore.dart';

class CattleHistory {
  final String name;
  final DateTime date;

  CattleHistory({required this.name, required this.date});

  factory CattleHistory.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    final name = data?['name'];
    final date = (data?['date'] != null) ? data!['date'].toDate() : null;
    // final date1 = DateTime(date.year, date.month, date.day);
    return CattleHistory(name: name, date: date);
  }

  Map<String, dynamic> toFireStore() {
    // final Timestamp timestamp = Timestamp.fromDate(date);
    return {'name': name, 'date': date};
  }

  Map<String, Object> toMap() {
    return {'name': name, 'date': date};
  }
}
