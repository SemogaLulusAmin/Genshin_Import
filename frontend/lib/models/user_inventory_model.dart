class UserInventoryItem {
  final String id;
  final int quantity;
  final String type; // weapon / artifact
  final dynamic item;

  UserInventoryItem({
    required this.id,
    required this.quantity,
    required this.type,
    required this.item,
  });

  factory UserInventoryItem.fromJson(Map<String, dynamic> json) {
    if (json['weapon'] != null) {
      return UserInventoryItem(
        id: json['id'],
        quantity: json['quantity'],
        type: 'weapon',
        item: json['weapon'], // nanti di-parse lagi
      );
    } else {
      return UserInventoryItem(
        id: json['id'],
        quantity: json['quantity'],
        type: 'artifact',
        item: json['artifact'],
      );
    }
  }
}
