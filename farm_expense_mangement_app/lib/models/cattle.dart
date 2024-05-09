import 'package:cloud_firestore/cloud_firestore.dart';

// final cattle = Cattle(rfid:"5515154", sex: "male",age:  10,breed: "cow" ,lactationCycle:  2,weight:  120,/*dateOfBirth: DateTime.parse('2020-12-01')*/);

class Cattle {
  final String rfid;
  final String sex;
  final int age;
  final String breed;
  final int weight;
  final String state;
  // final DateTime dateOfBirth;

  Cattle(
      {required this.rfid,
      required this.sex,
      this.age = 0,
      required this.breed,
      this.weight = 0,
      this.state = 'Dry'
      /*required this.dateOfBirth*/
      });

  factory Cattle.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Cattle(
        rfid: data?['rfid'],
        sex: data?['sex'],
        age: data?['age'],
        breed: data?['breed'],
        weight: data?['weight'],
        state: data?['state']
        // dateOfBirth: data?['dateOfBirth']
        );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'rfid': rfid,
      'sex': sex,
      'age': age,
      'breed': breed,
      'weight': weight,
      'state': state
      // 'dateOfBirth':dateOfBirth
    };
  }
}
