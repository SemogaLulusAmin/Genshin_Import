// await pool.query(`
//             CREATE TABLE Weapon (
//                 weaponID VARCHAR(36) PRIMARY KEY,
//                 name VARCHAR(255) NOT NULL,
//                 type VARCHAR(100) NOT NULL,
//                 rarity VARCHAR(50) NOT NULL,
//                 baseAttack VARCHAR(50) NOT NULL,
//                 subStat VARCHAR(100) NOT NULL,
//                 passiveName VARCHAR(255) NOT NULL,
//                 passiveDesc TEXT NOT NULL,
//                 image_url VARCHAR(255) NOT NULL,
//                 price DECIMAL(15, 4) NOT NULL,
//                 stock INTEGER NOT NULL,
//                 createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//                 updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
//             )    
//         `)


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
