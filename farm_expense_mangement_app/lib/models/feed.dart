import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String itemName;
  int quantity;
  String? category;
  DateTime? expiryDate;
  int? requiredQuantity;

  Feed({
    required this.itemName,
    required this.quantity,
    this.category,
    this.expiryDate,
    this.requiredQuantity,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'category': category,
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'requiredQuantity': requiredQuantity,
    };
  }

  factory Feed.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final json = snapshot.data();
    return Feed(
      itemName: json?['itemName'],
      quantity: json?['quantity'],
      category: json?['category'],
      expiryDate:
          (json?['expiryDate'] != null) ? json!['expiryDate'].toDate() : null,
      requiredQuantity: json?['requiredQuantity'],
    );
  }
}
