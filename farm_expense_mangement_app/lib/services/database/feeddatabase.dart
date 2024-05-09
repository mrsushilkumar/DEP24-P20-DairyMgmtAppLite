//TODO: for Cattle database access
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/feed.dart';

class DatabaseServicesForFeed {
  final String uid;
  DatabaseServicesForFeed(this.uid);

  Future<void> infoToServerFeed(Feed feed) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(feed.itemName)
        .set(feed.toFireStore());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> infoFromServer(
      String itemName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(itemName)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> infoFromServerAllFeed() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .orderBy('itemName')
        .get();
  }

  Future<void> deleteFeed(String itemName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(itemName)
        .delete();
  }
}
