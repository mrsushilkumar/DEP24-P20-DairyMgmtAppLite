
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
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'requiredQuantity': requiredQuantity,
    };
  }

}
