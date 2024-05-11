
// final cattle = Cattle(rfid:"5515154", sex: "male",age:  10,breed: "cow" ,lactationCycle:  2,weight:  120,/*dateOfBirth: DateTime.parse('2020-12-01')*/);

class Cattle {
  final String rfid;
  final String sex;
  final int age;
  final String breed;
  final int weight;
  final String state;
  final String source;
  // final DateTime dateOfBirth;

  Cattle(
      {required this.rfid,
      required this.sex,
      this.age = 0,
      required this.breed,
      this.weight = 0,
      this.state = 'Dry',
      this.source = 'Born on Farm'
      /*required this.dateOfBirth*/
      });

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
