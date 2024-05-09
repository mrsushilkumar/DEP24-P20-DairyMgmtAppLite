import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({required this.uid});
}

class FarmUser {
  final String ownerName;
  final String farmName;
  final String location;
  final int phoneNo;

  FarmUser(
      {required this.ownerName,
      required this.farmName,
      required this.location,
      required this.phoneNo});

  factory FarmUser.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return FarmUser(
        ownerName: data?['ownerName'],
        farmName: data?['farmName'],
        location: data?['location'],
        phoneNo: data?['phoneNo']);
  }

  Map<String, dynamic> toFireStore() {
    return {
      'ownerName': ownerName,
      'farmName': farmName,
      'location': location,
      'phoneNo': phoneNo
    };
  }
}
