//TODO: for Cattle database access

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/services/initializelocaldatabase.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/cattle.dart';

class DatabaseServicesForCattle {
  final String uid;
  DatabaseServicesForCattle(this.uid);

  Future<void> infoToServerSingleCattle(Cattle cattle) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return await db
        .collection('User')
        .doc(uid)
        .collection('Cattle')
        .doc(cattle.rfid)
        .set(cattle.toFireStore());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> infoFromServer(
      String rfid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Cattle')
        .doc(rfid)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> infoFromServerAllCattle(
      String uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Cattle')
        .orderBy('rfid')
        .get();
  }

  Future<void> deleteCattle(String rfid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Cattle')
        .doc(rfid)
        .delete();
  }

}

Future<List<Cattle>> getCattleFromDatabase() async {
  final Database db = await initDatabase();
  final List<Map<String, dynamic>> items = await db.query('cattles',);
  return List.generate(items.length, (index) {
    return Cattle(
        rfid: items[index]['rfid'],
        sex: items[index]['sex'],
        breed: items[index]['breed'],
        age: items[index]['age'],
        weight: items[index]['weight'],
        state: items[index]['state']
    );
  });
}

Future<List<Cattle>> getFemaleCattleFromDatabase() async {
  final Database db = await initDatabase();
  final List<Map<String, dynamic>> items = await db.query('cattles',where : 'sex = ?', whereArgs: ['Female']);
  return List.generate(items.length, (index) {
    return Cattle(
        rfid: items[index]['rfid'],
        sex: items[index]['sex'],
        breed: items[index]['breed'],
        age: items[index]['age'],
        weight: items[index]['weight'],
        state: items[index]['state']
    );
  });
}

Future<Cattle> getCattleDetailFromDatabase(String rfid) async {
  final Database db = await initDatabase();
  final List<Map<String, dynamic>> items = await db.query('cattles',where: 'rfid = ?', whereArgs: [rfid],limit: 1);
  return Cattle(
        rfid: items.first['rfid'],
        sex: items.first['sex'],
        breed: items.first['breed'],
        age: items.first['age'],
        weight: items.first['weight'],
        state: items.first['state']
    );
  }

Future addCattleToDatabase(Cattle cattle) async {
  final Database db = await initDatabase();
  return await db.insert('cattles', cattle.toFireStore());

}

Future deleteCattleFromDatabase(String rfid) async {
  final Database db = await initDatabase();
  return await db.delete('cattles',where: 'rfid = ?',whereArgs: [rfid]);
}

Future updateCattleInDatabase(Cattle cattle) async {
  final Database db = await initDatabase();
  return await db.update('cattles', cattle.toFireStore(),where: 'rfid = ?',whereArgs: [cattle.rfid]);
}

