class WeaponModel {
  final String weaponId;
  final String name;
  final String type;
  final String rarity;
  final String baseAttack;
  final String subStat;
  final String passiveName;
  final String passiveDesc;
  final String imageUrl;
  final double price;
  final int stock;

  WeaponModel({
    required this.weaponId,
    required this.name,
    required this.type,
    required this.rarity,
    required this.baseAttack,
    required this.subStat,
    required this.passiveName,
    required this.passiveDesc,
    required this.imageUrl,
    required this.price,
    required this.stock,
  });

  factory WeaponModel.fromJson(Map<String, dynamic> json) {
    return WeaponModel(
      weaponId: json['weaponID'] ?? json['weaponId'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Unknown Weapon',
      type: json['type'] ?? '',
      rarity: json['rarity'] ?? '1',
      baseAttack: json['baseAttack'] ?? '',
      subStat: json['subStat'] ?? '',
      passiveName: json['passiveName'] ?? '',
      passiveDesc: json['passiveDesc'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
    );
  }
}
