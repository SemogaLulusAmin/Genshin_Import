class Artifact {
  final String artifactID;
  final String name;
  final String setName;
  final String maxRarity;
  final int stock;
  final String imageUrl;
  final double price;
  final String? pieceBonus2;
  final String? pieceBonus4;

  Artifact({
    required this.artifactID,
    required this.name,
    required this.setName,
    required this.maxRarity,
    required this.stock,
    required this.imageUrl,
    required this.price,
    this.pieceBonus2,
    this.pieceBonus4,
  });

  factory Artifact.fromJson(Map<String, dynamic> json) {
    return Artifact(
      artifactID: json['artifactID'] ?? '',
      name: json['name'] ?? '',
      setName: json['set_name'] ?? '',
      maxRarity: json['max_rarity'] ?? '',
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      price: json['price'] != null
          ? double.parse(json['price'].toString())
          : 0.0,
      pieceBonus2: json['piece_bonus_2'],
      pieceBonus4: json['piece_bonus_4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artifactID': artifactID,
      'name': name,
      'set_name': setName,
      'max_rarity': maxRarity,
      'stock': stock,
      'image_url': imageUrl,
      'price': price,
      'piece_bonus_2': pieceBonus2,
      'piece_bonus_4': pieceBonus4,
    };
  }
}
