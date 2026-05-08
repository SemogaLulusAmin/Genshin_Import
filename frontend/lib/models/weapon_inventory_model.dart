class InventoryWeapon {
  final String weaponID;
  final String name;
  final String type;
  final String rarity;
  final int totalOwned; 
  final String imageUrl;

  InventoryWeapon({
    required this.weaponID,
    required this.name,
    required this.type,
    required this.rarity,
    required this.totalOwned,
    required this.imageUrl,
  });

  factory InventoryWeapon.fromJson(Map<String, dynamic> json) {
    return InventoryWeapon(
      weaponID: json['weaponID'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rarity: json['rarity']?.toString() ?? '1', 
      totalOwned: num.parse((json['totalOwned'] ?? 0).toString()).toInt(),
      imageUrl: json['image_url'] ?? '',
    );
  }
}