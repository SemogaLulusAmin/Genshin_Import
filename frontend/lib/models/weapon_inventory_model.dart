import 'inventory_model.dart';

class InventoryWeapon extends Inventory {
  final String weaponID;
  final String type;

  InventoryWeapon({
    required this.weaponID,
    required String name,
    required this.type,
    required String rarity,
    required int totalOwned,
    required String imageUrl,
  }) : super(
          id: weaponID,
          name: name,
          imageUrl: imageUrl,
          rarity: rarity,
          subtitle: type,
          totalOwned: totalOwned,
          itemType: 'Weapon',
        );

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