class Weapon {
  final String weaponID;
  final String name;
  final String type;
  final String rarity;
  final String baseAttack;
  final String subStat;
  final String passiveName;
  final String passiveDesc;
  final double price;
  final int stock;
  final String imageUrl;

  Weapon({
    required this.weaponID,
    required this.name,
    required this.type,
    required this.rarity,
    required this.baseAttack,
    required this.subStat,
    required this.passiveName,
    required this.passiveDesc,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      weaponID: json['weaponID'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rarity: json['rarity'] ?? '',
      baseAttack: json['baseAttack'] ?? '',
      subStat: json['subStat'] ?? '',
      passiveName: json['passiveName'] ?? '',
      passiveDesc: json['passiveDesc'] ?? '',
      imageUrl: json['image_url'] ?? '',
      stock: json['stock'] ?? 0,
      price: json['price'] != null
          ? double.parse(json['price'].toString())
          : 0.0,
    );
  }
}
